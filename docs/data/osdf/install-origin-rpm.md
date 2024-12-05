title: Installing the OSDF Origin by RPM

Installing the OSDF Origin
==========================

This document describes how to install a Pelican-based Open Science Data Federation (OSDF) Origin service via RPMs.
This service allows an organization to export its data to the Data Federation.

!!! note
    The origin must be registered with the OSG prior to joining the data federation.
    You may start the registration process prior to finishing the installation by [using this link](#registering-the-origin) 
    along with information like:

    * Resource name and hostname
    * VO associated with this origin server (which will be used to determine the origin's namespace prefix)
    * Administrative and security contact(s)
    * Who (or what) will be allowed to access the VO's data
    * Which caches will be allowed to cache the VO data


Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 8 or RHEL 9 or compatible operating systems.
* __User IDs:__ If they do not exist already, the installation will create the Linux user ID `xrootd` for running daemons.
* __Host certificate:__ Required for authentication.  See note below.
* __Network ports:__ The origin service requires the following ports open:
  * Inbound TCP port 8443 for file access via the HTTP(S) and XRoot protocols.
  * (Optional) Inbound TCP port 8444 for access to the web interface for monitoring and configuration;
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
    Origins should use a CA that is accepted by major browsers and operating systems,
    such as InCommon RSA or [Let's Encrypt](../../security/host-certs/lets-encrypt).
    IGTF certs are not recommended because clients are not configured to accept them by default.
    Note that you will need the full certificate chain, not just the certificate.
    
    The following locations should be used (note that they are in separate directories):
    
    * **Host Certificate Chain**: `/etc/pki/tls/certs/pelican.crt`
    * **Host Key**: `/etc/pki/tls/private/pelican.key`


Installing the Origin
---------------------

The origin service is provided by the `osdf-origin` RPM.
Install it using the following command:


```console
root@host # yum install --enablerepo=osg-upcoming osdf-origin
```


Configuring the Origin Server
-----------------------------

Configuration for a Pelican-based OSDF Origin is located in `/etc/pelican/osdf-origin.yaml`.

You must configure the following:
```
XRootD:
  Sitename: <RESOURCE NAME REGISTERED WITH OSG>
```

In addition, you must tell Pelican the data to export to the federation.
An origin may export one or more directory trees, or one or more S3 buckets -- follow one of the sections below.
(An single origin cannot export both a bucket and a directory tree.)



### Configuring POSIX (directory) export

Set these options to export one or more directory trees to the federation.

```
Origin:
  StorageType: "posix"
  Exports:
    # You may have one or more of the following block:
    - FederationPrefix: "<EXTERNAL OSDF NAMESPACE>"
      StoragePrefix:    "<LOCAL FILESYSTEM DIRECTORY>"
      Capabilities:    # Add or remove as desired
        - Reads        # Enable authenticated reading of objects from under the directory tree through a cache
        - PublicReads  # Enable unauthenticated reading of objects from under the directory tree through a cache
        - DirectReads  # Enable reading objects from under the directory tree
                       # without going through a cache
        - Listings     # Enable directory listings
        - Writes       # Enable writing to files in the directory tree
```

### Configuring S3 export

Set these options to export one or more S3 buckets to the federation

```
Origin:
  StorageType: "s3"
  S3Region: "<S3 REGION IF APPLICABLE>"
  S3ServiceUrl: "<URL OF S3 SERVER>"
  S3UrlStyle: "path"
  Exports:
    # You may have one or more of the following block:
    - FederationPrefix: "<EXTERNAL OSDF NAMESPACE>"
      S3Bucket:         "<NAME OF S3 BUCKET>"
      S3AccessKeyfile:  "<PATH TO S3 BUCKET ACCESS KEY>"
      S3SecretKeyfile:  "<PATH TO S3 BUCKET SECRET KEY>"
      Capabilities:     # Add or remove as desired
        - Reads         # Enable authenticated reading of objects from the bucket through a cache
        - PublicReads   # Enable unauthenticated reading of objects from the bucket through a cache
        - DirectReads   # Enable reading objects from the bucket
                        # without going through a cache
        - Listings      # Enable listing bucket items
        - Writes        # Enable writing to objects in the bucket
```


Preparing for Initial Startup
-----------------------------

1.  The origin identifies itself to the federation via public key authentication;
before starting the origin for the first time, it is recommended to generate a keypair.

    :::command
    root@host$ cd /etc/pelican
    root@host$ pelican generate keygen


    The newly created files, `issuer.jwk` and `issuer-pub.jwks` are the private and public keys, respectively.
    **Save these files**; if you lose them, you will have to re-register the origin.

1.  Contact OSG Staff and let them know that you are about to start your origin,
    and what namespace(s) the origin will serve.
    OSG Staff will need to approve the origin's registration.


Managing the Origin Service
---------------------------
Use the following SystemD commands as root to start, stop, enable, and disable the OSDF Origin.

| To...                                    | Run the command...                 |
| :--------------------------------------- | :--------------------------------- |
| Start the origin                         | `systemctl start osdf-origin`      |
| Stop the origin                          | `systemctl stop osdf-origin`       |
| Enable the origin to start on boot       | `systemctl enable osdf-origin`     |
| Disable the origin from starting on boot | `systemctl disable osdf-origin`    |


Registering the Origin
----------------------
To be part of the Open Science Data Federation, your origin must be
[registered with the OSG](../../common/registration.md).  The service type is `Pelican origin`.


Getting Help
------------
To get assistance, please use the [this page](../../common/help.md).
