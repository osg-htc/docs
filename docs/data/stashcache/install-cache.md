Installing the StashCache Cache
===============================

This document describes how to install a StashCache cache service.  This service allows a site or regional
network to cache data frequently used on the OSG, reducing data transfer over the wide-area network and
decreasing access latency.


Installation Prerequisites for the Cache
----------------------------------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 7 or compatible operating systems.
* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and
  `xrootd`
* __Host certificate:__ Optional, required for authenticated StashCache.
  The [host certificate documentation](/security/host-certs.md) provides more information on setting up host
  certificates.
* __Network ports:__ The cache service requires the following ports open:
    * Inbound TCP port 1094 for file access via the XRootD protocol
    * Inbound TCP port 8000 for file access via HTTP
    * Inbound TCP port 8443 for authenticated file access via HTTPS (optional)
    * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring
* __Hardware requirements:__ We recommend that a StashCache cache has at least 10Gbps connectivity, 1TB of
 disk space for the cache directory, and 8GB of RAM.

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)


Registering the Cache
---------------------

To be part of the OSG StashCache Federation, your cache must be registered with the OSG.
You will need basic information like the resource name and hostname,
and the administrative and security contacts.


### Initial registration

Initial registration is documented [here](/common/registration.md).
The service type is `XRootD cache server`.

!!! note
    This step must be completed before installation.

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
```yaml
  MY_STASHCACHE_CACHE:
    FQDN: my-cache.example.net
    Service: XRootD cache server
      Description: StashCache cache server
    AllowedVOs:
      - ANY_PUBLIC
```

This is an example of a cache server that only serves authenticated data from the OSG VO:
```yaml
  MY_AUTH_STASHCACHE_CACHE:
    FQDN: my-auth-cache.example.net
    Service: XRootD cache server
      Description: StashCache cache server
    AllowedVOs:
      - OSG
    DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=my-auth-cache.example.net
```


### Finalizing registration

Once initial registration is complete, you may start the installation process.
In the meantime, open a [help ticket](https://support.opensciencegrid.org) with your cache name.
Mention in your ticket that you would like to "Finalize the cache registration."


Installing the Cache
--------------------

The StashCache software consists of an XRootD server with special configuration and supporting services.
To simplify installation, OSG provides convenience RPMs that install all required
packages with a single command:

    :::console
    root@host # yum install --enablerepo=osg-testing stash-cache


Configuring the Cache
---------------------

First, you must create a "cache directory", which will be used to store downloaded files.
By default this is `/mnt/stash`.
We recommend using a separate file system for the cache directory,
with at least 1 TB of storage available.

!!! note
    The cache directory must be writable by the `xrootd:xrootd` user and group.

The `stash-cache` package provides default configuration files in `/etc/xrootd/xrootd-stash-cache.cfg` and `/etc/xrootd/config.d/`.
Administrators may provide additional configuration by placing files in `/etc/xrootd/config.d/1*.cfg` (for files that need to be processed BEFORE the OSG configuration) or `/etc/xrootd/config.d/9*.cfg` (for files that need to be processed AFTER the OSG configuration).

You _must_ configure every variable in `/etc/xrootd/10-common-site-local.cfg`.

The mandatory variables to configure are:

- `set rootdir = /mnt/stash`: the mounted filesystem path to export.  This document refers to this as `/mnt/stash`.
- `set sitename = YOUR_SITE_NAME`: the resource name registered with the OSG.

When ready with configuration, you may [start](#managing-stashcache-and-associated-services) your xrootd@stash-cache service.

Configuring the Authenticated Cache (Optional)
----------------------------------------------

The authenticated cache service is a separate instance of the StashCache cache service,
and runs alongside the unauthenticated instance.
You should make sure that the unauthenticated instance is functioning before setting up the authenticated instance.
Before proceeding, make sure you have followed the [prerequisite steps](#installation-prerequisites-for-cache).


### Add a service certificate

The service will need a certificate to authenticate to StashCache origins.
Do the following:

1. Copy the host certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
1. Set the owner of the directory and contents `/etc/grid-security/xrd/` to `xrootd:xrootd`:

        :::console
        root@host # chown -R xrootd:xrootd /etc/grid-security/xrd/

When ready with configuration, you may [start](#managing-stashcache-and-associated-services) your xrootd@stash-cache-auth service.

Configuring Optional Features
-----------------------------

### Adjust disk utilization

To adjust the disk utilization of your StashCache cache, create or edit a file named `/etc/xrootd/config.d/90-local.cfg`
and set the values of `pfc.diskusage`.

```
pfc.diskusage 0.90 0.95
```

The two values correspond to the low and high usage water marks, respectively.
When usage goes above the high water mark,
the XRootD service will delete cached files until usage goes below the low water mark.


### Enable remote debugging

XRootD provides remote debugging via a read-only file system named digFS.
This feature is disabled by default, but you can enable it when you need assistance with your server.

To enable remote debugging, edit `/etc/xrootd/digauth.cfg` and specify the authorizations for reading digFS.

See [the XRootD manual](http://xrootd.org/doc/dev48/xrd_config.htm#_Toc496911334) for the syntax.

Remote debugging should only be enabled for as long as you need assistance.
Once your problem has been resolved, turn it off.


Managing StashCache and associated services
-------------------------------------------

These services must be managed by `systemctl` and may start additional services as dependencies.
As a reminder, here are common service commands (all run as `root`) for EL7:

| To...                                   | On EL7, run the command...         |
| :-------------------------------------- | :--------------------------------- |
| Start a service                         | `systemctl start <SERVICE-NAME>`   |
| Stop a service                          | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>` |

### Public cache services

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stash-cache.service` | The xrootd daemon, which performs the data transfers |
| Fetch CRL | `fetch-crl-boot` and `fetch-crl-cron` | Required to authenticate monitoring services.  See [CA documentation](/common/ca#managing-fetch-crl-services) for more info |


### Authenticated cache services

In addition to the public cache services, there are three systemd units specific to the authenticated cache.

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stash-cache-auth.service` | The xrootd daemon which performs authenticated data transfers |
|  | `xrootd-renew-proxy.service` | Renew a proxy for authenticated downloads to the cache |
|  | `xrootd-renew-proxy.timer` | Trigger daily proxy renewal |


Testing Functionality
---------------------

The cache server functions as a normal HTTP server and can interact with typical HTTP clients, such as `curl`.


```console
user@host $ curl -O http://cache_host:8000/user/dweitzel/public/blast/queries/query1
```

### Test cache server reporting to the central collector

To verify the cache is reporting to the central collector, run the following command from the cache server:

```console
user@host $ condor_status -any -l -const "Name==\"xrootd@`hostname`\""
```

The output of the above command should provide an HTCondor ClassAd that details the status of your cache.


Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact <help@opensciencegrid.org> directly.
