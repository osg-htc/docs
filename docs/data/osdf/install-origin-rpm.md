title: Installing the OSDF Origin by RPM

Installing the OSDF Origin by RPM
=================================

!!! warning "OSG 24"
    This installation guide requires OSG 24

This document describes how to install an Open Science Data Federation (OSDF) Origin service via RPMs.
This service, based on the [Pelican Platform](https://docs.pelicanplatform.org/federating-your-data), allows an
administrator to serve data from a POSIX filesystem or S3 endpoint through the global OSDF infrastructure.


Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 8 or RHEL 9 or [compatible operating system](../../release/supported_platforms.md).
* __User IDs:__ If it does not exist already, the installation will create the Linux user named `xrootd` for running daemons.
* __Host certificate:__ Required for authentication.  See note below.
* __Network ports:__ The origin service requires the following ports open:
  * Inbound TCP port 8443 for file access via the HTTP(S) and XRoot protocols.
  * (Optional) Inbound TCP port 8444 for access to the web interface for monitoring and configuration;
    if enabled, access to this port should be restricted to the LAN.
* __Service requirements:__
    * An origin in the OSDF should have at least:
        * 1 core
        * 1 Gbps connectivity
        * 12 GB of RAM
  We suggest that several gigabytes of local disk space be available for log files,
  although some logging verbosity can be reduced.

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Obtain root access to the host
* Prepare [the required Yum repositories](../../common/yum.md);
  the [OSG 24 repositories](../../common/yum.md#install-the-osg-repositories) should be used.

!!! note "Host certificates"
    Origins are accessed by users through browsers, meaning origins need a certificate from a CA acceptable to a standard browser.
    Examples include [Let's Encrypt](../../security/host-certs/lets-encrypt.md) or the InCommon RSA CA.
    Origins without a valid certificate for the browser cannot be added to the OSDF.
    Note that, unlike legacy grid software, the public certificate file will need to contain the "full chain", including any
    intermediate CAs (if you're unsure about your setup, try accessing your origin from your browser).
    
    The following locations should be used (note that they are in separate directories):
    
    * **Host Certificate Chain**: `/etc/pki/tls/certs/pelican.crt`
    * **Host Key**: `/etc/pki/tls/private/pelican.key`



Installing the Origin
---------------------

The origin service is provided by the `osdf-origin` RPM.
Install it using the following command:


OSG 24:
```console
root@host # yum install osdf-origin
```


!!! note "osdf-origin 7.11.1"
    This document covers versions 7.11.1 and later of the `osdf-origin` package; ensure the above installation
    results in an appropriate version.

Configuring the Origin Server
-----------------------------

Create a file named `/etc/pelican/config.d/20-origin.yaml`

You must tell Pelican the data to export to the federation.
An origin may export one or more directory trees, or one or more S3 buckets -- follow one of the sections below.
A single origin cannot export both a bucket and a directory tree.



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
        - DirectReads  # Enable reading objects from under the directory tree without going through a cache
        - Listings     # Enable directory listings
        - Writes       # Enable writing to files in the directory tree
```

### Configuring S3 export

To configure your origin to serve objects from an S3 endpoint, see the
[upstream documentation](https://docs.pelicanplatform.org/federating-your-data/s3-backend).


Preparing for Initial Startup
-----------------------------

1.  The origin identifies itself to the federation via public key authentication;
before starting the origin for the first time, it is recommended to generate a keypair.

        :::console
        root@host$ cd /etc/pelican
        root@host$ pelican generate keygen


    The newly created files, `issuer.jwk` and `issuer-pub.jwks` are the private and public keys, respectively.

1.  **Save these files**; if you lose the `issuer.jwk`, your origin will need to be re-approved.


Validating the Origin Installation
----------------------------------

Do the following steps to verify that the origin is functional:

1.  Start the origin using the following command:

        :::console
        root@host$ systemctl start osdf-origin

1.  Download a test file (POSIX) or object (S3) from your origin (replacing `ORIGIN_HOSTNAME` with the host name of your origin,
    and TEST_PATH with the OSDF path to the test file or object

        :::console
        user@host$ curl -L https://ORIGIN_HOSTNAME:8443/TEST_PATH -o /tmp/testfile

    Verify the contents of `/tmp/testfile` match the test file or object your origin was serving.

    If the download fails, debugging information is located in `/var/log/pelican/osdf-origin.log`.
    See [this page](../../common/help.md) for requesting assistance; please include the log file
    in your request.


Joining the Origin to the Federation
------------------------------------

The origin must be registered with the OSG prior to joining the data federation.
Send mail to <help@osg-htc.org> requesting registration; provide the following information:

*   Origin hostname
*   Administrative and security contact(s)
*   Institution that the origin belongs to

OSG Staff will register the origin and respond with the Resource Name that the origin was registered as.

Once you have that information, edit `/etc/pelican/config.d/15-osdf.yaml`, and set `XRootD.Sitename`:
```
XRootD:
  Sitename: <RESOURCE NAME REGISTERED WITH OSG>
```

Then, restart the origin by running

```console
root@host$ systemctl restart osdf-origin
```

Let OSG Staff know that you have restarted the origin with the updated sitename,
so they can approve the new origin.



<!--

Upgrading a Non-Pelican Origin
------------------------------

If you are running a non-Pelican origin, e.g. one that was installed before OSG 24, there are special consideratiosn for
the upgrade to ensure minimal downtime for your users.

1.  Verify that you are not already running a Pelican-based origin, run the following on your origin host:

        :::console
        root@host # systemctl status osdf-origin
        Unit osdf-origin.service could not be found.

    If you see the following, then you are not running a Pelican-based origin and should proceed with the rest of the
    instructions in this section

1.  Install the origin

1.  Configure the origin

1.  Directly verify the origin

1.  Register the origin in the Director and Topology

    !!! danger ""

1.  Verify the origin through the OSDF director

1.  Uninstall the old service:

        :::console
        root@host # yum remove stash-origin

-->

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
