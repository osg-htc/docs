title: Installing the OSDF Origin by RPM

Installing the OSDF Origin by RPM
=================================

!!! warning "OSG 24"
    This installation guide requires OSG 24

!!! tip "Upgrading from a non-Pelican origin?"
    This installation guide also walks you through upgrading an origin that you installed prior to OSG 24.
    See [this section](#upgrading-a-non-pelican-origin) for more details.

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
  the [OSG 24 repositories](../../common/yum.md#install-the-osg-repositories) should be used.

    !!! danger "Upgrading to a Pelican origin"
        If you are upgrading from a pre-Pelican OSDF origin, update all of your OSG 23 packages before installing the OSG 24
        repositories:

            :::console
            root@host # yum update

!!! note "Host certificates"
    Origins are accessed by users through browsers, meaning origins need a certificate from a CA acceptable to a standard browser.
    Examples include [Let's Encrypt](../../security/host-certs/lets-encrypt.md) or the InCommon RSA CA.
    Origins without a valid certificate for the browser cannot be added to the OSDF.
    Note that, unlike legacy grid software, the public certificate file will need to contain the "full chain", including any
    intermediate CAs (if you're unsure about your setup, try accessing your origin from your browser).
    
    The following locations should be used (note that they are in separate directories):
    
    * **Host Certificate Chain**: `/etc/pki/tls/certs/pelican.crt`
    * **Host Key**: `/etc/pki/tls/private/pelican.key`

Upgrading a Non-Pelican Origin
------------------------------

If you are running a non-Pelican origin, e.g. one that was installed before OSG 24, there are special considerations for
the upgrade to ensure minimal downtime for your users.
This document will guide you through the upgrade process by installing and configuring a Pelican origin alongside your
non-Pelican origin.

!!! note "Using different hosts"
    You may install your new Pelican origin on a separate host if your underlying data store is shared between hosts.

First, determine if you have an active non-Pelican origin service running:

```console
user@host $ systemctl status xrootd@stash-origin-auth \
                             xrootd@stash-origin \
                             xrootd-privileged@stash-origin-auth \
            | grep -F 'Active: active'
   Active: active (running) since Wed 2024-12-04 17:46:17 CST; 1 weeks 1 days ago
```

*   **If you do not see any output from the above command**, you may proceed with the rest of the documentation.

*   **If you see any output from the above command**, you may proceed with the rest of the documentation but keep an eye
    out for special instructions related to the upgrade:

    !!! danger "Upgrading to a Pelican origin"
        You will find upgrade-specific instructions here.

Installing the Origin
---------------------

The origin service is provided by the `osdf-origin` RPM.
Install it using the following command:


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

For each namespace in your `Origin.Exports` list, validate their functionality by using the following sections based on
whether or not they have `PublicReads` in their `Capabilities` list.

Before starting any validation steps, ensure that the origin is running using the following command:

```console
root@host$ systemctl start osdf-origin
```

### Public namespaces ###

If the your namespace has the `PublicReads` capability, perform the following steps to validate its functionality.

1.  If your origin isn't already configured with `DirectReads` in the `Capabilities` list, add it and restart the container

2.  Download a test file (POSIX) or object (S3) from your origin (replacing `ORIGIN_HOSTNAME` with the host name of your
    origin, and TEST_PATH with the OSDF path to the test file or object)

        :::console
        user@host$ pelican object get -c ORIGIN_HOSTNAME:8443 'osdf:///<TEST_PATH>' -o /tmp/testfile

3.  Verify the contents of `/tmp/testfile` match the test file or object your origin was serving.

4.  If you enabled `DirectReads` in step (1) above, remove it and restart the container.

### Private namespaces ###

Origins without `PublicReads` are slightly more involved to test since they require a JSON Web Token (JWT):

1.  If your origin isn't already configured with `DirectReads` in the `Capabilities` list, add it and restart the container

1.  Retrieve or generate a JWT, depending on the output of the following command:

        :::console
        user@host$ docker exec osdf-origin pelican --config /etc/pelican/osdf-origin.yaml config get issuerurl

    -   If the above command outputs a non-empty value (e.g., `server.issuerurl: "https://...`), you must retrieve a
        token from this issuer and save it to a file.
        The details for retrieving such a token are dependent on your issuer and are beyond the scope of this document.

    -   If the above command returns an empty value (e.g., `server.issuerurl: ""`), generate a token by running the
        following inside the container:

            :::console
            user@container$ pelican origin token create \
                                    --config /etc/pelican/osdf-origin.yaml \
                                    --subject "test" \  # set this to your Unix username if you've set Origin.Multiuser: true
                                    --audience "https://wlcg.cern.ch/jwt/v1/any" \
                                    --scope "storage.read:/" 

        This will output a JWT that you must save to a file.

2.  Download a test file (POSIX) or object (S3) from your origin (replacing `ORIGIN_HOSTNAME` with the host name of your
    origin, and TEST_PATH with the OSDF path to the test file or object)

        :::console
        user@host$ pelican object get -t <PATH TO TOKEN FILE> -c ORIGIN_HOSTNAME:8443 'osdf:///<TEST_PATH>' -o /tmp/testfile

3.  Verify the contents of `/tmp/testfile` match the test file or object your origin was serving.

4.  If you enabled `DirectReads` in step (1) above, remove it and restart the container.

### Troubleshooting validation ###

If you get errors, add the `--debug` flag to the `pelican object get` invocation.

Debugging information will be in your container logs e.g., `docker logs osdf-origin`.
To increase the debugging information in the origin, edit your origin configuration file and set:
```
Debug: true
Logging:
  Origin:
    SciTokens: trace
```

See [this page](../../common/help.md) for requesting assistance; please include the logs in your request.

Joining the Origin to the Federation
------------------------------------

!!! danger "Upgrading to a Pelican origin"
    Once registered, all OSDF clients of your namespace will be directed to your Pelican origin.
    Before initiating this process, ensure that your Pelican origin is functioning and that you are ready to migrate
    production transfers.

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

Then, restart the origin by running

```console
root@host$ systemctl restart osdf-origin
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
        user@host $ grep <TEST_PATH> /var/log/pelican/osdf-origin.log

    Replacing `<TEST PATH>` with the same path that you used in step (1) or (2).
    If you see output, then the OSDF is directing client requests to your Pelican origin!
    If you do not see output, please [contact us](#getting-help).

!!! danger "Upgrading to a Pelican origin"
    Congratulations, you have fully verified the functionality of your Pelican origin!
    You may uninstall the non-Pelican origin:
    
        root@host $ yum remove stash-origin

Managing the Origin Service
---------------------------
Use the following SystemD commands as root to start, stop, enable, and disable the OSDF Origin.

| To...                                    | Run the command...                 |
| :--------------------------------------- | :--------------------------------- |
| Start the origin                         | `systemctl start osdf-origin`      |
| Stop the origin                          | `systemctl stop osdf-origin`       |
| Enable the origin to start on boot       | `systemctl enable osdf-origin`     |
| Disable the origin from starting on boot | `systemctl disable osdf-origin`    |


Getting Help
------------
To get assistance, please use the [this page](../../common/help.md).
