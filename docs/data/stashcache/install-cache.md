Installing the StashCache Cache
===============================

This document describes how to install a StashCache cache service.  This service allows a site or regional
network to cache data frequently used on the OSG, reducing data transfer over the wide-area network and
decreasing access latency.

!!! note
    The _cache_ service must be registered with the OSG if it is to be used by clients. You may start 
    registration procedure prior to finishing the installation by [using this link](#registering-the-cache) 
    along with the basic information like:

    * Resource name and hostname.
    * Administrative and security contact.

    Detailed walkthrough of the process is described [here](#registering-the-cache). 

## Installation prerequisites for the Cache

Before starting the installation process, consider the following mandatory points:

* __Operating system:__ Only RHEL 7 and compatible operating systems are supported.
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

* __Service certificate:__ copy the host certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
    * Set the owner of the directory and contents `/etc/grid-security/xrd/` to `xrootd:xrootd`:

            :::console
            root@host # chown -R xrootd:xrootd /etc/grid-security/xrd/

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Ensure the host has [a supported operating system](/release/supported_platforms.md).  At this time, we
  only support RHEL7-based cache servers.
* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)

Installing the Cache
--------------------

The StashCache daemon consists of an XRootD server and an HTCondor-based service for collecting and reporting
statistics about the cache. To simplify installation, OSG provides convenience RPMs that install all required
software with a single command:

    :::console
    root@host # yum install --enablerepo=osg-testing stashcache-cache-server

!!! note
    If installing authenticated StashCache Cache server, you need an additional package:

        :::console
        root@host # yum install --enablerepo=osg-testing stashcache-cache-server-auth

The cache server configuration assumes the disk used to cache data is mounted at `/stash` and owned by the
`xrootd:xrootd` user and group.

Configuring the Cache
---------------------

The `stashcache-cache-server` provides a default configuration file,
`/etc/xrootd/xrootd-stashcache-cache-server.cfg`, which must be customized for your cache.

The most common lines to customize are:

* `all.sitename YOUR_SITE_NAME`: The registered OSG resource name.  This **must** be changed.
* `set cachedir = /stash`: The location of the cache directory for this service.  Files downloaded by the
  cache will be stored here; we recommend it is at least 1TB in size.
* `*.trace`, `pss.setopt`: These control the logging verbosity of the cache.  The defaults are relatively high
  in order to aid in debugging.  These lines can be commented out to reduce logging; however, if issues occur,
  OSG support may ask you to re-enable them.
* `pfc.ram 7g`: The amount of RAM the caching service should target to use.

The Authfile specifies which files and directories can be read,
relative to the `cachedir` that was defined in the main config.

An example:

```console
root@host # cat /etc/xrootd/Authfile-noauth
u * /user/ligo -rl / rl
```

This permits all users (`u *`) to read all directories (`/ rl`) _except_ those under `/user/ligo` (`/user/ligo -rl`);
the `/user/ligo` directory should only be readable in authenticated setups.
For more details, see the [XRootD security documentation](http://xrootd.org/doc/dev47/sec_config.htm#_Toc489606598).

Configuring the Authenticated Cache (Optional)
----------------------------------------------

The authenticated cache service is a separate instance of the StashCache cache service,
and runs alongside the unauthenticated instance.
You should make sure that the unauthenticated instance is functioning before setting up the authenticated instance.
Before proceeding, make sure you have followed the [prerequisite steps](#installation-prerequisites-for-cache).

### Add Authfile for authenticated cache

The Authfile for the authenticated cache is located in `/etc/xrootd/Authfile-auth`.
This is a separate file from the non-authenticated cache Authfile.

Since the authenticated cache runs alongside the unauthenticated cache,
care must be taken to avoid conflicts between the two.
In particular, paths that are accessible via the authenticated cache should not be accessible via the unauthenticated cache,
and vice versa.

As an example:

```console
root@host # cat /etc/xrootd/Authfile-auth
g /osg/ligo /user/ligo rl
u ligo /user/ligo rl
```

This permits users in the VOMS group `/osg/ligo` and users mapped to `ligo` to read and list anything under
`/user/ligo`.

When ready with configuration, you may [start](#managing-stashcache-and-associated-services) your Cache server.

Configuring Optional Features
-----------------------------

### Adjust disk utilization

To adjust the disk utilization of your StashCache cache, modify the values of `pfc.diskusage` in `/etc/xrootd/xrootd-stashcache-cache-server.cfg`:

```
pfc.diskusage 0.98 0.99
```

The first value and second values correspond to the low and high usage watermarks, respectively, in fractions. When the high watermark is reached, the XRootD service will automatically purge cache objects down to the low watermark.

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

StashCache daemons are managed by systemd units.  First ensure that your cache directory (default `/stash`) is
mounted, then ensure you *enable* (set to start at boot) and *start* the StashCache-related services.

As a reminder, here are common service commands (all run as `root`) for EL7:

| To...                                   | On EL7, run the command...         |
| :-------------------------------------- | :--------------------------------- |
| Start a service                         | `systemctl start <SERVICE-NAME>`   |
| Stop a  service                         | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>` |

### Public Cache Services
| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stashcache-cache-server.service` | The xrootd daemon, which performs the data transfers |
| HTCondor | `condor.service` | Report cache statistics to central OSG collector |
| Fetch CRL | `fetch-crl-boot` and `fetch-crl-cron` | Required to authenticate monitoring services.  See [CA documentation](/common/ca#managing-fetch-crl-services) for more info |

### Authenticated Cache Services

_In addition_ to the public cache services, there are three systemd units specific to the authenticated cache.

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stashcache-cache-server-auth.service` | The xrootd daemon which performs the authenticated data transfers |
|  | `xrootd-renew-proxy.service` | Renew a proxy for authenticated downloads to the cache |
|  | `xrootd-renew-proxy.timer` | Trigger daily proxy renewal |

## Testing Functionality

The cache server functions as a normal HTTP server and can interact with typical HTTP clients, such as `curl`.


```console
user@host $ curl -O http://cache_host:8000/user/dweitzel/public/blast/queries/query1
```

### Test Cache server reports to HTCondor collector

To verify the cache is reporting to the central collector, run the following command:

```console
user@host $ condor_status -any -l -const "Name==\"xrootd@`hostname`\""
```

Where `hostname` is the string returned by the hostname command. The output of the above command should provide an HTCondor ClassAd that details the status of your cache.

Registering the Cache
---------------------
To be part of the OSG StashCache Federation, your _cache_ must be
[registered with the OSG](https://github.com/opensciencegrid/topology#topology).
To register your resource:

1. Identify the facility, site, and resource group where your _cache_ is hosted.
   For example, the CHTC-Wisconsin uses the following information:

```
Disable: false
GroupDescription: The University of Wisconsin's Center for High Throughput Computing. Note
  that CHTC and GLOW are closely related, and in many contexts, they are synonyms.
GroupID: 314
Production: true
Resources:
  CHTC_STASHCACHE_CACHE:
    Active: false
    Description: This is a StashCache cache server at UW.
    ID: 958
    ContactLists:
      Administrative Contact:
        Primary:
          ID: ec1013224934d6a11a2a46a5234b3337095f5ec4
          Name: Matyas Selmeci
        Secondary:
          ID: 46a55ac4815b2b8c00ff283549f413113b45d628
          Name: Aaron Moate
        Tertiary:
          ID: 3f306d87236d84ef770ddf0c34844908e2d94dfa
          Name: Timothy Slauson
      Security Contact:
        Primary:
          ID: ec1013224934d6a11a2a46a5234b3337095f5ec4
          Name: Matyas Selmeci
        Secondary:
          ID: 46a55ac4815b2b8c00ff283549f413113b45d628
          Name: Aaron Moate
        Tertiary:
          ID: 3f306d87236d84ef770ddf0c34844908e2d94dfa
          Name: Timothy Slauson
    FQDN: sc-cache.chtc.wisc.edu
    Services:
      XRootD cache server:
        Description: StashCache cache server
    VOOwnership:
      GLOW: 100
```

!!! warning
    The contact person should be listed in the OSG topology [contacts list](https://topology.opensciencegrid.org/contacts). 
    If the person or the resource are completely new (e.g. ID and/or GroupID doesn't exist), 
    you should consider to follow [main OSG registration documentation](/common/registration.md).

1. Using the above information, [create or update](https://github.com/opensciencegrid/topology#how-to-register) the
   appropriate YAML file, using [this template](https://github.com/opensciencegrid/topology/blob/master/template-resourcegroup.yaml)
   as a guide.

1. Update information of your resource (longitute/latitude included) in the [stashcp.json](https://github.com/opensciencegrid/StashCache/blob/master/bin/caches.json) by opening pull request.
   In order to identify GeoIP information you can use the following tool provided by [MAXMIND](https://www.maxmind.com/en/geoip-demo).  

1. In order to get your cache available to the CVMFS _osg-config_ repository (OASIS), open pull request by adding your resource under `CVMFS_EXTERNAL_URL` [here](https://github.com/opensciencegrid/oasis-server/blob/6aa1492b44ed7d74f1b737f1ea92ace31190e6a2/goc/config-osg/etc/cvmfs/domain.d/osgstorage.org.conf#L7).

1. If you run authenticated cache instance for the specific VO, for example LIGO, edit and update `CVMFS_EXTERNAL_URL` [here](https://github.com/opensciencegrid/oasis-server/blob/6aa1492b44ed7d74f1b737f1ea92ace31190e6a2/goc/config-osg/etc/cvmfs/config.d/ligo.osgstorage.org.conf#L1).

Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact directly <support@opensciencegrid.org>.
