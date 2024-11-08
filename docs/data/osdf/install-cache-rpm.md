title: Installing the OSDF Cache by RPM

Installing the OSDF Cache
=========================

This document describes how to install a Pelican-based Open Science Data Federation (OSDF) Cache service via RPMs.
This service allows a site or regional network to cache data frequently used in Open Science Pool jobs,
reducing data transfer over the wide-area network and decreasing access latency.


Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 8 or RHEL 9 or [compatible operating system](../../release/supported_platforms.md).
* __User IDs:__ If it does not exist already, the installation will create the Linux user named `xrootd` for running daemons.
* __File Systems:__ The cache should have a partition of its own for storing data and metadata.
* __Host certificate:__ Required for authentication.  See note below.
* __Network ports:__ The cache service requires the following ports open:
  * Inbound TCP port 8443 for file access via the HTTP(S) and XRoot protocols.
  * (Optional) Inbound TCP port 8444 for access to the web interface for monitoring and configuration;
    if enabled, access to this port should be restricted to the LAN.
* __Service requirements:__
    * A cache serving the OSDF federation as a regional cache should have at least:
        * 8 cores
        * 40 Gbps connectivity
        * 50-200 TB of NVMe disk for the cache partition; you may distribute the disk, e.g., by using an NVMe-backed Ceph pool,
            if you cannot fit that much disk into a single chassis
        * 24 GB of RAM
    * A cache being used to serve data from the OSDF to a single site should have at least:
        * 8 cores
        * 40 Gbps connectivity
        * 2 TB of NVMe disk for the cache partition
        * 24 GB of RAM
  We suggest that several gigabytes of local disk space be available for log files,
  although some logging verbosity can be reduced.

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Obtain root access to the host
* Prepare [the required Yum repositories](../../common/yum.md)


!!! note "OSG 23"
    In OSG 23, the Pelican-based OSDF RPMs are only available in the "osg-upcoming" repositories.

!!! note "Host certificates"
    Caches should use a CA that is accepted by major browsers and operating systems,
    such as InCommon RSA or [Let's Encrypt](../../security/host-certs/lets-encrypt).
    IGTF certs are not recommended because clients are not configured to accept them by default.
    Note that you will need the full certificate chain, not just the certificate.

    The following locations should be used (note that they are in separate directories):
    
    * **Host Certificate Chain**: `/etc/pki/tls/certs/pelican.crt`
    * **Host Key**: `/etc/pki/tls/private/pelican.key`


Installing the Cache
--------------------

The cache service is provided by the `osdf-cache` RPM.
Install it using one of the following commands:


OSG 24:
```console
root@host # yum install osdf-cache --enablerepo=osg-testing
```

OSG 23:
```console
root@host # yum install --enablerepo=osg-upcoming-testing osdf-cache
```


Configuring the Cache Server
----------------------------

!!! note "osdf-cache 7.11.1"
    This configuration requires version 7.11.1 or newer of the `osdf-cache`
    and `pelican` RPMs.
    
In `/etc/pelican/config.d/20-cache.yaml`, set `Cache.LocalRoot`, `Cache.DataLocation` and `Cache.MetaLocation` as follows,
replacing `<CACHE PARTITION>` with the mount point of the partition you will use for the cache.
```
Cache:
  LocalRoot: "<CACHE PARTITION>/namespaces"
  DataLocation: "<CACHE PARTITION>/data"
  MetaLocation: "<CACHE PARTITION>/meta"
```


Preparing for Initial Startup
-----------------------------

1.  The cache identifies itself to the federation via public key authentication;
before starting the cache for the first time, it is generate a keypair.

        :::console
        root@host$ cd /etc/pelican
        root@host$ pelican generate keygen


    The newly created files, `issuer.jwk` and `issuer-pub.jwks` are the private and public keys, respectively.

1.  **Save these files**; if you lose them, your cache will need to be re-approved.


Validating the Cache Installation
---------------------------------

Do the following steps to verify that the cache is functional:

1.  Start the cache using the following command:

        :::console
        root@host$ systemctl start osdf-cache

1.  Download a test file from the OSDF through your cache (replacing `CACHE_HOSTNAME` with the host name of your cache)

        :::console
        root@host$ osdf object get -c CACHE_HOSTNAME:8443 /ospool/uc-shared/public/OSG-Staff/validation/test.txt /tmp/test.txt
        root@host$ cat /tmp/test.txt

        Hello, World!

    If the download fails, rerun the above `osdf object get` command with the `-d` flag added;
    additional debugging information is located in `/var/log/pelican/osdf-cache.log`.
    See [this page](../../common/help.md) for requesting assistance; please include the log file
    and the `osdf object get -d` output in your request.


Joining the Cache to the Federation
-----------------------------------

The cache must be registered with the OSG prior to joining the data federation.
Send mail to <help@osg-htc.org> requesting registration; provide the following information:

*   Cache hostname
*   Administrative and security contact(s)
*   Institution that the cache belongs to

OSG Staff will register the cache and respond with the Resource Name that the cache was registered as.

Once you have that information, edit `/etc/pelican/config.d/15-osdf.yaml`, and set `XRootD.Sitename`:
```
XRootD:
  Sitename: <RESOURCE NAME REGISTERED WITH OSG>
```

Then, restart the cache by running

```console
root@host$ systemctl restart osdf-cache
```

Let OSG Staff know that you have restarted the cache with the updated sitename,
so they can approve the new cache.


Managing the Cache Service
---------------------------
Use the following SystemD commands as root to start, stop, enable, and disable the OSDF Cache.

| To...                                    | Run the command...                 |
| :--------------------------------------- | :--------------------------------- |
| Start the cache                          | `systemctl start osdf-cache`       |
| Stop the cache                           | `systemctl stop osdf-cache`        |
| Enable the cache to start on boot        | `systemctl enable osdf-cache`      |
| Disable the cache from starting on boot  | `systemctl disable osdf-cache`     |


Getting Help
------------
To get assistance, please use the [this page](../../common/help.md).
