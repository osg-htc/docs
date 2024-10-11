title: Installing the OSDF Cache by RPM

Installing the OSDF Cache
=========================

This document describes how to install a Pelican-based Open Science Data Federation (OSDF) Cache service via RPMs.
This service allows a site or regional network to cache data 

!!! note
    The cache must be registered with the OSG prior to joining the data federation.
    You may start the registration process prior to finishing the installation by [using this link](#registering-the-cache) 
    along with information like:

    * Resource name and hostname
    * Administrative and security contact(s)


Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 8 or RHEL 9 or compatible operating systems.
* __User IDs:__ If they do not exist already, the installation will create the Linux user named `xrootd` for running daemons.
* __File Systems:__ The cache should have a partition of its own for storing data and metadata.
* __Host certificate:__ Required for authentication.  See note below.
* __Network ports:__ The cache service requires the following ports open:
  * Inbound TCP port 8443 for file access via the HTTP(S) and XRoot protocols.
  * (Optional) Inbound TCP port cache for access to the web interface for monitoring and configuration;
    if enabled, this should be restricted to the LAN or management network.
* __Hardware requirements:__ We recommend that an origin has at least 1Gbps connectivity and 12GB of RAM.
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
Install it using the following command:


```console
root@host # yum install --enablerepo=osg-upcoming osdf-cache
```


Configuring the Cache Server
----------------------------

Configuration for a Pelican-based OSDF Cache is located in `/etc/pelican/osdf-cache.yaml`.

You must configure the following:
```
XRootD:
  Sitename: <RESOURCE NAME REGISTERED WITH OSG>
Cache:
  DataLocation: "<TOP OF CACHE DIRECTORY>"
```

If you are using a separate partition for the cached data, which is strongly recommended,
then use the mount point of the cache partition as `Cache.DataLocation`.


Preparing for Initial Startup
-----------------------------

1.  The cache identifies itself to the federation via public key authentication;
before starting the cache for the first time, it is recommended to generate a keypair.

    :::command
    root@host$ cd /etc/pelican
    root@host$ pelican generate keygen


    The newly created files, `issuer.jwk` and `issuer-pub.jwks` are the private and public keys, respectively.
    **Save these files**; if you lose them, your cache will need to be re-approved.

1.  Contact OSG Staff and let them know that you are about to start your cache,
    and what the hostname of the cache is.
    OSG Staff will need to approve the cache's registration.


Managing the Cache Service
---------------------------
Use the following SystemD commands as root to start, stop, enable, and disable the OSDF Cache.

| To...                                    | Run the command...                 |
| :--------------------------------------- | :--------------------------------- |
| Start the cache                          | `systemctl start osdf-cache`       |
| Stop the cache                           | `systemctl stop osdf-cache`        |
| Enable the cache to start on boot        | `systemctl enable osdf-cache`      |
| Disable the cache from starting on boot  | `systemctl disable osdf-cache`     |


Registering the Cache in OSG Topology
-------------------------------------
To be part of the Open Science Data Federation, your cache must be
[registered in the OSG Topology system](../../common/registration.md).
The service type is `Pelican cache`.


Getting Help
------------
To get assistance, please use the [this page](../../common/help.md).
