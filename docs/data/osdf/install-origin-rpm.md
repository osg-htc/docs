title: Installing the OSDF Origin by RPM

Installing the OSDF Origin by RPM
=================================

!!! tip "Upgrading from OSG 24?"
    Pelican configuration semantics changed between OSG 24 and OSG 25.
    See [Updating to OSG 25](../../../release/updating-to-osg-25) for more details.

This document describes how to install an Open Science Data Federation (OSDF) Origin service via RPMs.
This service, based on the [Pelican Platform](https://docs.pelicanplatform.org/federating-your-data), allows an
administrator to serve data from a POSIX filesystem or S3 endpoint through the global OSDF infrastructure.


Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 8, RHEL 9, RHEL 10, or [compatible operating system](../../release/supported_platforms.md).
* __User IDs:__ If it does not exist already, the installation will create the Linux user named `xrootd` for running daemons.
* __Host certificate:__ Required for authentication.  See note below.
* __Network ports:__ The origin service requires the following ports open:
    * Inbound TCP port 8443 for file access via the HTTP(S) and XRoot protocols.
    * Inbound TCP port 8444 for access to web endpoints such as origin-based token issuers, federation health checks, and
      metrics
* __Service requirements:__ The recommended resources for an origin in the OSDF are:
    * 4 cores
    * 25 Gbps connectivity
    * 20 GB of RAM
    * 10 GB of local disk space in `/var/log` for log files

    At a minumum, an origin in the OSDF should have:

    * 1 core
    * 1 Gbps connectivity
    * 12 GB of RAM
    * 10 GB of local disk space in `/var/log` for log files

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Obtain root access to the host
* Prepare [the required Yum repositories](../../common/yum.md);
  the [OSG 26 repositories](../../common/yum.md#install-the-osg-repositories) should be used.

!!! note "Host certificates"
    Origins are accessed by users through browsers, meaning origins need a certificate from a CA acceptable to a standard browser.
    Examples include [Let's Encrypt](../../security/host-certs/lets-encrypt.md) or the InCommon RSA CA.
    Origins without a valid certificate for the browser cannot be added to the OSDF.
    Note that, unlike legacy grid software, the public certificate file will need to contain the "full chain", including any
    intermediate CAs (if you're unsure about your setup, try accessing your origin from your browser).
    
    The following locations should be used:

    * **Host Certificate Chain**: `/etc/pelican/certificates/tls.crt`
    * **Host Key**: `/etc/pelican/certificates/tls.key`

Upgrading a Non-Pelican Origin
------------------------------

If you are running a non-Pelican origin, e.g. one that was installed before OSG 24, there are special considerations for
the upgrade to ensure minimal downtime for your users. Please reach out to [help@osg-htc.org](mailto:help@osg-htc.org)
for assistance.

Installing the Origin
---------------------

The origin service is provided by the `osdf-server` RPM.
Install it via the following command:

```console
root@host # yum install osdf-server
```

Configuring the Origin Server
-----------------------------

Edit the file named `/etc/pelican/config.d/20-origin-exports.yaml`

You must tell Pelican the data to export to the federation.
An origin may export one or more directory trees, or one or more S3 buckets -- follow one of the sections below.
A single origin cannot export both a bucket and a directory tree.

!!! note
    `/etc/pelican/config.d` contains template files for multiple Pelican/OSDF services, not just an origin.
    You may ignore the files for the services you are not using.


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
        root@host$ mkdir -p /etc/pelican/issuer-keys
        root@host$ chmod 0750 /etc/pelican/issuer-keys
        root@host$ chown root:pelican /etc/pelican/issuer-keys

        root@host$ cd /etc/pelican/issuer-keys
        root@host$ pelican key create


    The newly created files, `private-key.pem` and `issuer-pub.jwks` are the private and public keys, respectively.

1.  **Save these files**; if you lose the `private-key.pem` file, your origin will need to be re-approved.


Validating the Origin Installation
----------------------------------

Do the following steps to verify that the origin is functional:

1.  Start the origin using one of the following commands:

        :::console
        root@host$ systemctl start pelican-origin


1.  Download a test file (POSIX) or object (S3) from your origin (replacing `ORIGIN_HOSTNAME` with the host name of your origin,
    and TEST_PATH with the OSDF path to the test file or object

        :::console
        user@host$ pelican object get -c ORIGIN_HOSTNAME:8443 'osdf:///<TEST_PATH>' -o /tmp/testfile

    (Note: this test will not work if DirectReads are not enabled.)

    Verify the contents of `/tmp/testfile` match the test file or object your origin was serving.

    If the download fails, rerun the above `pelican object get` command with the `-d` flag added.

    Additional debugging information is located in `/var/log/pelican/pelican-origin.log`.<br>

    To increase the debugging information in the log file, edit your origin configuration file and set:
    ```
    Logging:
      Level: debug
    ```
    Note that `debug` produces a lot of output and you should remove that setting or set it to `info`
    once the problem has been resolved.
    
    See [this page](../../common/help.md) for requesting assistance; please include the log file
    and the `pelican object get -d` output in your request.


Joining the Origin to the Federation
------------------------------------

The origin must be registered with the OSG prior to joining the data federation.
Send mail to <help@osg-htc.org> requesting registration; provide the following information:

*   Origin hostname
*   Administrative and security contact(s)
*   Institution that the origin belongs to

OSG Staff will register the origin and respond with the Resource Name.

Once you have that information, edit `/etc/pelican/config.d/15-osdf.yaml`, and set `XRootD.Sitename`:
```
XRootD:
  Sitename: <RESOURCE NAME REGISTERED WITH OSG>
```

Then, restart the origin by running the following command:

```console
root@host$ systemctl restart pelican-origin
```


Validating the Origin Through the Federation
--------------------------------------------

Once your origin has been registered in the federation:

1.  Optional, if DirectReads are enabled:  Download a test file (POSIX) or object (S3) directly from your origin,
    (replacing `<TEST_PATH>` with the OSDF path to the test file or object):

        :::console
        user@host $ pelican object get 'osdf:///<TEST_PATH>?directread=1' -o /tmp/testfile

    Verify the contents of `/tmp/testfile` match the test file or object your origin was serving.

    If the download fails, debugging information is located in `/var/log/pelican/osdf-origin.log`.
    See [this page](../../common/help.md) for requesting assistance; please include the log file
    in your request.

1.  Download a test file (POSIX) or object (S3) from your origin via a cache, 
    (replacing `<TEST_PATH>` with the OSDF path to the test file or object):

        :::console
        user@host $ pelican object get 'osdf:///<TEST_PATH>' -o /tmp/testfile2

    Verify the contents of `/tmp/testfile2` match the test file or object your origin was serving.

    If the download fails, debugging information is located in `/var/log/pelican/osdf-origin.log`.
    See [this page](../../common/help.md) for requesting assistance; please include the log file
    in your request.

1.  Verify that your test is running against your Pelican origin:

        :::console
        user@host $ grep <TEST_PATH> /var/log/pelican/pelican-origin.log

    Replacing `<TEST PATH>` with the same path that you used in step (1) or (2).
    If you see output, then the OSDF is directing client requests to your Pelican origin!
    If you do not see output, please [contact us](#getting-help).

Managing the Origin Service
---------------------------
Use the following SystemD commands as root to start, stop, enable, and disable the OSDF Origin.

| To...                                    | Run the command...                 |
| :--------------------------------------- | :--------------------------------- |
| Start the origin                         | `systemctl start pelican-origin`   |
| Stop the origin                          | `systemctl stop pelican-origin`    |
| Enable the origin to start on boot       | `systemctl enable pelican-origin`  |
| Disable the origin from starting on boot | `systemctl disable pelican-origin` |

Getting Help
------------
To get assistance, please use the [this page](../../common/help.md).
