Installing the StashCache Cache
===============================

This document describes how to install a StashCache cache service.  This service allows a site or regional
network to cache data frequently used on the OSG, reducing data transfer over the wide-area network and
decreasing access latency.


Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 7 or compatible operating systems.
* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and
  `xrootd`
* __Host certificate:__ Required for reporting and authenticated StashCache.
  Authenticated StashCache is an optional feature.
  See our [documentation](/security/host-certs.md) for instructions on how to request and install host certificates.
* __Network ports:__ The cache service requires the following ports open:
    * Inbound TCP port 1094 for file access via the XRootD protocol
    * Inbound TCP port 8000 for file access via HTTP
    * Inbound TCP port 8443 for authenticated file access via HTTPS (optional)
    * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring
* __Hardware requirements:__ We recommend that a cache has at least 10Gbps connectivity, 1TB of
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

To register your cache host, follow the general registration instructions [here](https://opensciencegrid.org/docs/common/registration/#new-resources).
The service type is `XRootD cache server`.

!!! info
    This step must be completed before installation.

In your registration, you must specify which VOs your cache will serve by adding an `AllowedVOs` list, with each line specifying a VO whose data you are willing to cache.

There are special values you may use in `AllowedVOs`:

- `ANY_PUBLIC` indicates that the cache is willing to serve public data from any VO.
- `ANY` indicates that the cache is willing to serve data from any VO,
  both public and non-public.
  `ANY` implies `ANY_PUBLIC`.

There are extra requirements for serving non-public data:

- In addition to the cache allowing a VO in the `AllowedVOs` list,
  that VO must also allow the cache in its `AllowedCaches` list.
  See the page on [getting your VO's data into StashCache](/data/stashcache/vo-data).
- There must be an authenticated XRootD instance on the cache server.
- There must be a `DN` attribute in the resource registration
  with the [subject DN](/security/host-certs#before-starting) of the host certificate

This is an example registration for a cache server that serves all public data:
```yaml
  MY_STASHCACHE_CACHE:
    FQDN: my-cache.example.net
    Service: XRootD cache server
      Description: StashCache cache server
    AllowedVOs:
      - ANY_PUBLIC
```

This is an example registration for a cache server that only serves authenticated data from the OSG VO:
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
    root@host # yum install stash-cache


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
- `set resourcename = YOUR_RESOURCE_NAME`: the resource name registered with the OSG.


### Add a service certificate

The service will need a certificate for reporting and to authenticate to StashCache origins.
The easiest solution for this is to use your host certificate and key as follows:

1. Copy the host certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
1. Set the owner of the directory and contents `/etc/grid-security/xrd/` to `xrootd:xrootd`:

        :::console
        root@host # chown -R xrootd:xrootd /etc/grid-security/xrd/

!!! note
    You must repeat the above steps whenever you renew your host certificate.
    If you automate certificate renewal, you should automate copying as well.
    For example, if you are using Certbot for Let's Encrypt, you should write a "deploy hook" as documented
    [on the Certbot site](https://certbot.eff.org/docs/using.html#renewing-certificates).


Configuring Optional Features
-----------------------------

### Adjust disk utilization

To adjust the disk utilization of your cache, create or edit a file named `/etc/xrootd/config.d/90-local.cfg`
and set the values of `pfc.diskusage`.

```
pfc.diskusage 0.90 0.95
```

The two values correspond to the low and high usage water marks, respectively.
When usage goes above the high water mark,
the XRootD service will delete cached files until usage goes below the low water mark.


### Enable remote debugging

XRootD provides remote debugging via a read-only file system named digFS.
This feature is disabled by default, but you may enable it if you need help troubleshooting your server.

To enable remote debugging, edit `/etc/xrootd/digauth.cfg` and specify the authorizations for reading digFS.
An example of authorizations:
```
all allow gsi g=/glow h=*.cs.wisc.edu
```
This gives access to the config file, log files, core files, and process information
to anyone from `*.cs.wisc.edu` in the `/glow` VOMS group.

See [the XRootD manual](http://xrootd.org/doc/dev48/xrd_config.htm#_Toc496911334) for the full syntax.

Remote debugging should only be enabled for as long as you need assistance.
As soon as your issue has been resolved, revert any changes you have made to `/etc/xrootd/digauth.cfg`.


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


### Authenticated cache services (optional)

In addition to the public cache services, there are three systemd units specific to the authenticated cache.

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stash-cache-auth.service` | The xrootd daemon which performs authenticated data transfers |
|  | `xrootd-renew-proxy.service` | Renew a proxy for authenticated downloads to the cache |
|  | `xrootd-renew-proxy.timer` | Trigger daily proxy renewal |


Validating the Cache
---------------------

The cache server functions as a normal HTTP server and can interact with typical HTTP clients, such as `curl`.


```console
user@host $ curl -O http://cache_host:8000/user/dweitzel/public/blast/queries/query1
```

`curl` may not correctly report a failure, so verify that the contents of the file are:
```
>Derek's first query!
MPVSDSGFDNSSKTMKDDTIPTEDYEEITKESEMGDATKITSKIDANVIEKKDTDSENNITIAQDDEKVSWLQRVVEFFE
```

### Test cache server reporting to the central collector

To verify the cache is reporting to the central collector, run the following command from the cache server:

```console
user@host $ condor_status -any -pool collector.opensciencegrid.org:9619 \
                          -l -const "Name==\"xrootd@`hostname`\""
```

The output of the above command should detail what the collector knows about the status of your cache.
Here is an example snippet of the output:
```
AuthenticatedIdentity = "sc-cache.chtc.wisc.edu@daemon.opensciencegrid.org"
AuthenticationMethod = "GSI"
free_cache_bytes = 868104454144
free_cache_fraction = 0.8022261674321525
LastHeardFrom = 1552002482
most_recent_access_time = 1551997049
MyType = "Machine"
Name = "xrootd@sc-cache.chtc.wisc.edu"
ping_elapsed_time = 0.00763392448425293
ping_response_code = 0
ping_response_message = "[SUCCESS] "
ping_response_status = "ok"
STASHCACHE_DaemonVersion = "1.0.0"
...
```



Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact <help@opensciencegrid.org> directly.
