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
* __Network ports:__ The cache service requires inbound ports, one for the xrootd protocol, one for
  HTTP and, if authenticated StashCache is used, one for HTTPS.  The defaults are:
    * TCP port 1094 for xrootd.
    * TCP port 8000 for HTTP.
    * TCP port 8443 for HTTPS (optional).
* __Hardware requirements:__ We recommend that a StashCache server has at least 10Gbps connectivity, 1TB of
 disk space, and 8GB of RAM.

If installing the (optional) authenticated StashCache, you also need to do the following:

* __Service certificate:__ create copy of the host certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
    * set owner of the directory `/etc/grid-security/xrd/` to `xrootd:xrootd` user:

            :::console
            root@host # chown -R xrootd:xrootd /etc/grid-security/xrd/

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

        :::console
        root@host # yum install stashcache-cache-server

!!! note
    If installing authenticated StashCache Cache server, you need additional packages to be installed:

        :::console
        root@host # yum install stashcache-cache-server-auth

The cache server configuration assumes the disk user to cache data is mounted at `/stash` and owned by the
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
* `pfc.ram 7g`: The amount of RAM the caching service should target to use.

<!-- TODO: not clear someone could reasonably setup their authentication using this information.

In Authfile you want to allow local reads below `$(cachedir)` defined in the main config. Example of Authfile:

```console
root@host # cat /etc/xrootd/Authfile-noauth
u * /user/ligo -rl / rl
```
-->

Managing the Cache Service
---------------------------
The cache service is started by the following systemd unit:

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD    | `xrootd@stashcache-cache-server.service` | The xrootd daemon, which performs the data transfers |

1. Enable and start `xrootd@stashcache-cache-server.service` instance:

        :::console
        root@host # systemctl enable xrootd@stashcache-cache-server
        root@host # systemctl start  xrootd@stashcache-cache-server

<!-- TODO: how to run the condor-based monitoring? -->

These services must be managed with `systemctl`.  As a reminder, here are common service commands (all run as `root`):

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

### RHEL7

On RHEL7 system, you need to configure and run following systemd units:
* `xrootd@stashcache-cache-server-auth.service`
* `xrootd-renew-proxy.service`
* `xrootd-renew-proxy.timer`
* `fetch-crl-cron`

#### Auth.service
1. Enable and start `xrootd@stashcache-cache-server-auth.service` instance:

        :::console
        root@host # systemctl enable xrootd@stashcache-cache-server-auth
        root@host # systemctl start  xrootd@stashcache-cache-server-auth

#### Proxy.service and Proxy.timer

1. Run the service to generate the xrootd proxy and confirm the file exists

        :::console
        root@host # systemctl start xrootd-renew-proxy

        root@host # ls -al /tmp/x509up_xrootd
        -rw-------. 1 xrootd xrootd 4644 Sep 25 18:35 /tmp/x509up_xrootd

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

#### CRLs updates

It is very important to keep CRL list updated from cron:

1. Enable and start fetch-crl-cron

        :::console
        root@host # systemctl enable fetch-crl-cron
        root@host # systemctl start  fetch-crl-cron

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
pfc.diskusage 0.98 0.99
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
