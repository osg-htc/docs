Installing the StashCache Cache
===============================

This document describes how to install a StashCache cache service.  This service allows a site or regional
network to cache data frequently used on the OSG, reducing data transfer over the wide-area network and
decreasing access latency.

!!! note
    The cache service must be registered with the OSG if it is to be used by clients.  You may start the
    registration procedure prior to finishing the installation by contacting <support@opensciencegrid.org>
    with the following details:

    * Resource name and hostname.
    * Administrative and security contact.

    Follow the [registration documentation](/common/registration.md) for more information.

## Installation prerequisites for Cache

Before starting the installation process, consider the following mandatory points:

* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and
  `xrootd`
* __Host certificate:__ The StashCache server uses a host certificate to advertise to a central collector.
  The [host certificate documentation](/security/host-certs.md) provides more information on setting up host
  certificates.
* __Network ports:__ The cache service requires to inbound ports, one for the xrootd protocol and the other for
  HTTP.  The defaults are:
    * TCP port 1094 for xrootd.
    * TCP port 8000 for HTTP.
* __Hardware requirements:__ We recommend that a StashCache server has at least 10Gbps connectivity, 1TB of
 disk space, and 8GB of RAM.

If installing the (optional) authenticated StashCache, you need to do in addition the following:

* __Service certificate:__ create copy of the host certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
    * set owner of the directory `/etc/grid-security/xrd/` to `xrootd:xrootd` user:

            :::console
            root@host # chown -R xrootd:xrootd /etc/grid-security/xrd/

* __Network ports__: allow connections on port `8443 (TCP)` 

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Ensure the host has [a supported operating system](/release/supported_platforms.md).  At this time, we
  only support RHEL7-based cache servers.
* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)

Installing the StashCache cache
-------------------------------

The StashCache daemon consists of an XRootD server and an HTCondor-based service for collecting and reporting
statistics about the cache. To simplify installation, OSG provides convenience RPMs that install all required
software with a single command:

```console
root@host # yum install stashcache-cache-server
```

!!! note 
    If installing authenticated StashCache Cache server, you need additional packages to be installed:
        
        :::console
        root@host # yum install xrootd-lcmaps globus-proxy-utils

The cache server configuration assumes the disk user to cache data is mounted at */stash* and owned by the
`xrootd:xrootd` user.

Configuring Cache Server
------------------------

The `stashcache-cache-server` provides a default configuration file,
`/etc/xrootd/xrootd-stashcache-cache-server.cfg`, which must be customized for your cache.

The most common lines to customize are:

* `all.sitename Nebraska`: The registered OSG resource name.
* `set cachedir = /stash`: The location of the cache directory for this service.  Files downloaded by the
  cache will be stored here; we recommend it is at least 1TB in size.
* `pss.origin redirector.osgstorage.org:1094`: The data federation for this cache to join.  The default,
  `redirector.osgstorage.org`, is the production instance; test caches may need to join other federations.
  Customization of this directive is rare.
* `*.trace`, `pss.setopt`: These control the logging verbosity of the cache.  The defaults are relatively high
  in order to aid in debugging.  These lines can be commented out to reduce logging; however, if issues occur,
  OSG support may ask you to re-enable them.
* `pfc.ram 32g`: The amount of RAM the caching service should target to use.

<!-- TODO: not clear someone could reasonably setup their authentication using this information.

In Authfile you want to allow local reads below `$(cachedir)` defined in the main config. Example of Authfile:

```console
root@host # cat /etc/xrootd/Authfile-noauth 
u * /user/ligo -rl / rl
```
-->

<!-- TODO: this is complete copy/paste.  Add to RPM. -->

Additionally, create `/etc/xrootd/stashcache-robots.txt` with the following contents to prevent search engines
from attempting to index your server:

```
User-agent: *
Disallow: /
```

Managing the Cache Service
---------------------------
The cache service consists of the following systemd units:

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD    | `xrootd@stashcache-origin-server.service` | The xrootd daemon, which performs the data transfers |
| XRootD    | `cmsd@stashcache-origin-server.service` | The "cluster management service" daemon, which integrates the origin into the data federation.  |
| Fetch CRL | `fetch-crl-boot` and `fetch-crl-cron` | See [CA documentation](/common/ca#managing-fetch-crl-services) for more info |

<!-- TODO: how to run the condor-based monitoring? -->

These services must be managed with `systemctl`.  As a reminder, here are common service commands (all run as
`root`):

| To...                                   | On EL7, run the command...         |
| :-------------------------------------- | :--------------------------------- |
| Start a service                         | `systemctl start <SERVICE-NAME>`   |
| Stop a  service                         | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>` |

(Optional) Configuring the Authenticated Cache
----------------------------------------------

Once the public Cache Server is registered and functioning, you may want to enable the authenticated cache
service.  This is an optional step.  Before proceeding, make sure you have followed the
[prerequisite steps](#installation-prerequisites-for-cache).

<!-- TODO: this can be done completely within the RPM.  Remove this. -->

Now, create symbolic link to existing configuration file with `-auth` postfix:

```console
root@host # cd /etc/xrootd/
root@host # ln -s xrootd-stashcache-cache-server.cfg xrootd-stashcache-cache-server-auth.cfg
```

### RHEL7

On RHEL7 system, you need to configure and run following systemd units:
* `xrootd@stashcache-cache-server-auth.service`
* `xrootd-renew-proxy.service`
* `xrootd-renew-proxy.timer`
* `fetch-crl-cron`

#### Auth.service
1. Enable `xrootd@stashcache-cache-server-auth.service` instance:

        :::console
        root@host # systemctl enable xrootd@stashcache-cache-server-auth


2. Reload daemons:

        :::console
        root@host # systemctl daemon-reload


#### Proxy.service
1. Create the file with following content:

        :::console
        root@host # cat /usr/lib/systemd/system/xrootd-renew-proxy.service
        [Unit]
        Description=Renew xrootd proxy
        
        [Service]
        User=xrootd
        Group=xrootd
        Type = oneshot
        ExecStart = /bin/grid-proxy-init -cert /etc/grid-security/xrd/xrdcert.pem -key /etc/grid-security/xrd/xrdkey.pem -out /tmp/x509up_xrootd -valid 48:00
        
        [Install]
        WantedBy=multi-user.target

2. Reload daemons:

        :::console
        root@host # systemctl daemon-reload


#### Proxy.timer

1. Create the file with following content:

        :::console
        root@host # cat /usr/lib/systemd/system/xrootd-renew-proxy.timer
        [Unit]
        Description=Renew proxy every day at midnight
        
        [Timer]
        OnCalendar=*-*-* 00:00:00
        Unit=xrootd-renew-proxy.service
        
        [Install]
        WantedBy=multi-user.target

2. Enable timer:

        :::console
        root@host # systemctl enable xrootd-renew-proxy.timer


3. Start and check if timer is active and working:

        :::console
        root@host # systemctl start xrootd-renew-proxy.timer
        ...
        root@host # systemctl is-active xrootd-renew-proxy.timer
        active
        root@host # systemctl list-timers xrootd-renew-proxy*
        NEXT                         LEFT       LAST                         PASSED  UNIT                     ACTIVATES
        Thu 2017-05-11 00:00:00 CDT  54min left Wed 2017-05-10 00:00:01 CDT  23h ago xrootd-renew-proxy.timer xrootd-renew-proxy.service


4. Reload daemons:

        :::console
        root@host # systemctl daemon-reload


#### CRLs updates

It is very important to keep CRL list updated from cron:

1. Enable fetch-crl-cron

        :::console
        root@host # systemctl enable fetch-crl-cron

2. Start fetch-crl-cron

        :::console
        root@host # systemctl start fetch-crl-cron


3. Reload daemons:

        :::console
        root@host # systemctl daemon-reload


### Add Authfile for authenticated cache

Authfile for authenticated cache may differ from `/etc/xrootd/Authfile-noauth` defined in non-authenticated cache configuration. Example:

```console
root@host # cat /etc/xrootd/Authfile-auth 
g /osg/ligo /user/ligo r
u ligo /user/ligo lr / rl
```

When ready with configuration, you may [start](#managing-stashcache-and-associated-services) your StashCache Cache server.

Configuring Optional Features
-----------------------------

### Adjust disk utilization

To adjust the disk utilization of your StashCache cache, modify the values of `pfc.diskusage` in `/etc/xrootd/xrootd-stashcache-cache-server.cfg`:

```
pfc.diskusage 0.98 .99
```

The first value and second values correspond to the low and high usage watermarks, respectively, in percentages. When the high watermark is reached, the XRootD service will automatically purge cache objects down to the low watermark.

### Enable remote debugging

This feature enables remote debugging via the `digFS` read-only file system, it's optional line in the config file that was created when configuring the cache:

```
xrootd.diglib * /etc/xrootd/digauth.cf
```

where `/etc/xrootd/digauth.cf` may have following content:

```
all allow host h=abc.org
all allow host h=*.xyz.edu
```

## Managing StashCache and associated services

Ensure that your `/stash` disk is mounted, and then start `xrootd` and `condor` service.

### Non-authenticated Cache server services
| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stashcache-cache-server.service` | RHEL7 |
| HTCondor | `condor.service` | RHEL7  |
| Fetch CRL | `fetch-crl-cron` | RHEL7 |

### Authenticated Cache server services
| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stashcache-cache-server-auth.service` | RHEL7 |
|  | `xrootd-renew-proxy.service` | RHEL7 |
|  | `xrootd-renew-proxy.timer` | RHEL7  |
| HTCondor | `condor.service` | RHEL7  |
| Fetch CRL | `fetch-crl-cron` | RHEL7 |

### Test Cache server reports to HTCondor collector
To verify that your cache is being monitored properly, run the following command:
```
user@host $ condor_status -any -l -const "Name==\"xrootd@`hostname`\""
```
Where `hostname` is the string returned by the hostname command. The output of the above command should provide an HTCondor ClassAd that details the status of your cache.

### Test CVMFS accessibility via Cache server
```
[user@client ~]$ curl -O http://cache_host:8000/user/dweitzel/public/blast/queries/query1
```
