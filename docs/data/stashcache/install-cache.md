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
 disk space for the cache directory, and 8GB of RAM.

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

The StashCache daemon consists of an XRootD server and a service for collecting and reporting
statistics about the cache. To simplify installation, OSG provides convenience RPMs that install all required
software with a single command:

    :::console
    root@host # yum install --enablerepo=osg-testing stashcache-cache-server

!!! note
    If installing authenticated StashCache Cache server, you need an additional package:

        :::console
        root@host # yum install --enablerepo=osg-testing stashcache-cache-server-auth


Configuring the Cache
---------------------

First, you must create a "cache directory", which will be used to store downloaded files.
By default this is `/stash`.
We recommend using a separate file system for the cache directory,
with at least 1 TB of storage available.

!!! note
    The cache directory must be writable by the `xrootd:xrootd` user and group.

The `stashcache-cache-server` provides a default configuration file,
`/etc/xrootd/xrootd-stashcache-cache-server.cfg`, which must be customized for your cache.

The most common lines to customize are:

* `all.sitename YOUR_SITE_NAME`: The registered OSG resource name.  This **must** be changed.
* `set cachedir = /stash`: The location of the cache directory for this service.
* `*.trace`, `pss.setopt`: These control the logging verbosity of the cache.  The defaults are relatively high
  in order to aid in debugging.  These lines can be commented out to reduce logging; however, if issues occur,
  OSG support may ask you to re-enable them.

The Authfile specifies which files and directories can be read,
relative to the cache directory (`cachedir` in the main config).

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
| StashCache Reporter | `stashcache-reporter.timer` | Report cache statistics to central OSG collector |
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
To be part of the OSG StashCache Federation, your cache must be
[registered with the OSG](/common/registration.md).  The service type is `XRootD cache server`.

The resource may also specify which VOs it will serve data from.
To do this, add an `AllowedVOs` list, with each line specifying a VO whose StashCache data the resource is willing to cache.

There are special values you can use in `AllowedVOs`:

- `ANY_PUBLIC` indicates that the cache is willing to serve public data from any VO.
- `ANY` indicates that the cache is willing to serve data from any VO,
  both public and non-public.
  `ANY` implies `ANY_PUBLIC`.

There are extra requirements for serving non-public data:

- In addition to the cache allowing a VO in the `AllowedVOs` list,
  that VO must also allow the cache in its `AllowedCaches` list.
  See the page on [getting your VO's data into StashCache](/data/stashcache/vo-data).
- There must be an authenticated XRootD instance on the cache server.
- There must be a `DN` attribute in the resource
  with the DN of the cert used by the authenticated XRootD instance.

This is an example of a cache server that serves all public data:
```
  MY_STASHCACHE_CACHE:
    FQDN: my-cache.example.net
    Service: XRootD cache server
      Description: StashCache cache server
    AllowedVOs:
      - ANY_PUBLIC
```

This is an example of a cache server that only serves authenticated data from the OSG VO:
```
  MY_AUTH_STASHCACHE_CACHE:
    FQDN: my-auth-cache.example.net
    Service: XRootD cache server
      Description: StashCache cache server
    AllowedVOs:
      - OSG
    DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=my-auth-cache.example.net
```

Once the cache has been registered, open a [help ticket](https://support.opensciencegrid.org) with your cache name.  Mention in your ticket that you would like to "Finalize the cache registration."

Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact <help@opensciencegrid.org> directly.
