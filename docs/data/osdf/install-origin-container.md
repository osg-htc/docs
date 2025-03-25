title: Installing the OSDF Origin by Container

Installing the OSDF Origin by Container
=======================================

This document describes how to run an Open Science Data Federation (OSDF) Origin service via containers.
This service allows projects and organizations to distribute their data in a scalable manner to distributed high-throughput computing jobs,
reducing data transfer over the wide-area network and increasing throughput to jobs.

Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Container runtime:__ The examples in this guide assume using Docker as the container runtime,
    for which the host must have a running `docker` service,
   and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
* __Host certificate:__ Required for authentication.  See note below.
* __Network ports:__ The origin service requires the following ports open:
    * Inbound TCP port 8443 for file access via the HTTP(S) and XRoot protocols.
    * (Optional) Inbound TCP port 8444 for access to the web interface for monitoring and configuration;
      if enabled, access to this port should be restricted to the LAN.
* __Service requirements:__ An origin in the OSDF should have at least:
    * 1 core
    * 1 Gbps connectivity
    * 12 GB of RAM
    * 10 GB of local disk space in `/var/log` for log files

!!! note "Host certificates"
    Origins are accessed by users through browsers, meaning origins need a certificate from a CA acceptable to a standard browser.
    Examples include [Let's Encrypt](../../security/host-certs/lets-encrypt.md) or the InCommon RSA CA.
    Origins without a valid certificate for the browser cannot be added to the OSDF.
    Note that, unlike legacy grid software, the public certificate file will need to contain the "full chain", including any
    intermediate CAs (if you're unsure about your setup, try accessing your origin from your browser).

    The certificate chain and key should be mounted into the following locations:

    * **Host Certificate Chain**: `/etc/pelican/certificates/tls.crt`
    * **Host Key**: `/etc/pelican/certificates/tls.key`


!!! note "osdf-origin 7.12"
    This document covers versions 7.12 and later of the `osdf-origin` container image.

!!! note "root"
    The paths used as examples on this page (e.g., `/etc/osdf-origin`) require root to edit;
    if you do not have root on the host, choose new locations where you have modification permissions.



Configuring the Origin Server
-----------------------------

The preferred method of configuring a Pelican-based OSDF Origin is via a YAML file that will be
mounted into the container into the `/etc/pelican/config.d` directory.
This document will use `/etc/osdf-origin/config.yaml` as the name of the configuration file outside of the container.

Create `/etc/osdf-origin/config.yaml` with the following contents:
```file
Origin:
# XRootD:
#   Sitename: <RESOURCE NAME REGISTERED WITH OSG>
```
You will uncomment and fill in the value for `XRootD.Sitename` in a later step, after registration is complete.

You must tell Pelican the data to export to the federation.
An origin may export one or more directory trees, or one or more S3 buckets -- follow one of the sections below.
A single origin cannot export both a bucket and a directory tree.



### Configuring POSIX (directory) export

Set these options to export one or more directory trees to the federation.

#### Single volume

The simplest POSIX setup is to export a single directory tree to the federation.
Use the following configuration to do that:

```
Origin:
  StorageType: "posix"
  Exports:
    - FederationPrefix: "<EXTERNAL OSDF NAMESPACE>"
      StoragePrefix:    "/pelican"
      Capabilities:    # Add or remove individual capabilities as desired
        - Reads        # Enable authenticated reading of objects from under the directory tree through a cache
        - PublicReads  # Enable unauthenticated reading of objects from under the directory tree through a cache
        - DirectReads  # Enable reading objects from under the directory tree without going through a cache
        - Listings     # Enable directory listings
        - Writes       # Enable writing to files in the directory tree
```


#### Multiple volumes

You may want to export multiple directory trees to the federation,
for example if you export data from multiple filesystems,
or want to have different permissions for the different directory trees.

```
Origin:
  StorageType: "posix"
  Exports:
    - FederationPrefix: "<EXTERNAL OSDF NAMESPACE 1>"
      StoragePrefix:    "/pelican/<SUBDIRECTORY 1>"
      Capabilities:    # Add or remove individual capabilities as desired
        - Reads        # Enable authenticated reading of objects from under the directory tree through a cache
        - PublicReads  # Enable unauthenticated reading of objects from under the directory tree through a cache
        - DirectReads  # Enable reading objects from under the directory tree without going through a cache
        - Listings     # Enable directory listings
        - Writes       # Enable writing to files in the directory tree
    - FederationPrefix: "<EXTERNAL OSDF NAMESPACE 2>"
      StoragePrefix:    "/pelican/<SUBDIRECTORY 2>"
      Capabilities:    # Add or remove individual capabilities as desired
        - Reads        # Enable authenticated reading of objects from under the directory tree through a cache
        - PublicReads  # Enable unauthenticated reading of objects from under the directory tree through a cache
        - DirectReads  # Enable reading objects from under the directory tree without going through a cache
        - Listings     # Enable directory listings
        - Writes       # Enable writing to files in the directory tree
    ...
```
where `<SUBDIRECTORY 1>`, `<SUBDIRECTORY 2>`, etc. will be mount points for volume that you want to export.


### Configuring S3 export

To configure your origin to serve objects from an S3 endpoint, see the
[upstream documentation](https://docs.pelicanplatform.org/federating-your-data/s3-backend).


Preparing for Initial Startup
-----------------------------

1.  The origin identifies itself to the federation via public key authentication;
before starting the origin for the first time, it is recommended to generate a keypair.
Download the Pelican client from <https://github.com/PelicanPlatform/pelican/releases>,
install the executable as `/usr/local/bin/pelican`, and run:

        :::console
        root@host$ cd /etc/osdf-origin
        root@host$ pelican generate keygen


    The newly created files, `issuer.jwk` and `issuer-pub.jwks` are the private and public keys, respectively.

1.  **Save these files**; if you lose the `issuer.jwk`, your origin will need to be re-approved.


Running an Origin
-----------------

This section describes how the origin may be run using the Docker command-line.
For production, we recommend using a container orchestration service such as
[Docker Compose](https://docs.docker.com/compose/),
or [Kubernetes](https://kubernetes.io/).

This example uses the single-volume POSIX setup.

This table provides a reminder of the parameters that will be used in the examples:

| Parameter             | Example value                    | Description                                                                             | 
|-----------------------|----------------------------------|-----------------------------------------------------------------------------------------|
| `ORIGIN_HOST_PORT`    | `8443`                           | The host port used for data transfer via HTTP(S)                                        | 
| `WEB_INTERFACE_PORT`  | `8444`                           | The host port used for service management via the web interface                         | 
| `ISSUER_JWK`          | `/etc/osdf-origin/issuer.jwk`    | The private key generated by `pelican generate keygen`                                  | 
| `HOST_CERT_CHAIN`     | `/etc/osdf-origin/hostcert.pem`  | The host certificate, with full chain                                                   | 
| `HOST_KEY`            | `/etc/osdf-origin/hostkey.pem`   | The private key matching the host certificate                                           | 
| `ORIGIN_CONFIG_FILE`  | `/etc/osdf-origin/config.yaml`   | The YAML file containing various origin settings                                        | 
| `OUTSIDE_DIRECTORY`   | `/mnt/origin`                    | The directory outside the container that stores the data to be served                   | 
| `INSIDE_DIRECTORY`    | `/pelican`                       | The path inside the container corresponding to StoragePrefix in your origin config file |


```console
user@host $ docker run --rm \
             --publish <ORIGIN_HOST_PORT>:8443 \
             --publish <WEB_INTERFACE_HOST PORT>:8444 \
             --volume <ISSUER_JWK>:/etc/pelican/issuer.jwk \
             --volume <HOST_CERT_CHAIN>:/etc/pelican/certificates/tls.crt \
             --volume <HOST_KEY>:/etc/pelican/certificates/tls.key \
             --volume <ORIGIN_CONFIG_FILE>:/etc/pelican/config.d/99-local.yaml \
             --volume <OUTSIDE_DIRECTORY>:<INSIDE_DIRECTORY> \
             --name osdf-origin \
             hub.opensciencegrid.org/pelican_platform/osdf-origin:latest
```

Using the example values from the table, this is

```console
user@host $ docker run --rm \
             --publish 8443:8443 \
             --publish 8444:8444 \
             --volume /etc/osdf-origin/issuer.jwk:/etc/pelican/issuer.jwk \
             --volume /etc/osdf-origin/hostcert.pem:/etc/pelican/certificates/tls.crt \
             --volume /etc/osdf-origin/hostkey.pem:/etc/pelican/certificates/tls.key \
             --volume /etc/osdf-origin/config.yaml:/etc/pelican/config.d/99-local.yaml \
             --volume /mnt/origin:/pelican \
             --name osdf-origin \
             hub.opensciencegrid.org/pelican_platform/osdf-origin:latest
```


Validating the Origin
---------------------

Download a test file (POSIX) or object (S3) from your origin (replacing `ORIGIN_HOSTNAME` with the host name of your origin,
and TEST_PATH with the OSDF path to the test file or object)

```
user@host$ curl -L https://ORIGIN_HOSTNAME:8443/TEST_PATH -o /tmp/testfile
```

Verify the contents of `/tmp/testfile` match the test file or object your origin was serving.

Debugging information will be in your container logs e.g., `docker logs osdf-origin`.
To increase the debugging information in the origin, edit your origin configuration file and set:
```
Debug: true
```

See [this page](../../common/help.md) for requesting assistance; please include the logs in your request.


Joining the Origin to the Federation
------------------------------------

The origin must be registered with the OSG prior to joining the data federation.
Send mail to <help@osg-htc.org> requesting registration; provide the following information:

*   Origin hostname
*   Administrative and security contact(s)
*   Institution that the origin belongs to

OSG Staff will register the origin and respond with the Resource Name.

Once you have that information, edit `/etc/osdf-origin/config.yaml`, and set `XRootD.Sitename`:
```
XRootD:
  Sitename: <RESOURCE NAME REGISTERED WITH OSG>
```

Validating the Origin Through the Federation
--------------------------------------------

Once your origin has been registered in the federation,
perform the following actions to verify that it can be used through the federation.
These steps will use the Pelican client
(which you can download from <https://github.com/PelicanPlatform/pelican/releases>).

If the actions fail, see debugging information in your container logs,
which are accessible via
```
docker logs osdf-origin
```
To increase the debugging information in the origin, edit your origin configuration file and set:
```
Debug: true
```
See [this page](../../common/help.md) for requesting assistance; please include the logs in your request.

1.  Optional, if DirectReads are enabled:  Download a test file (POSIX) or object (S3) directly from your origin,
    (replacing `<TEST_PATH>` with the OSDF path to the test file or object):

        :::console
        user@host $ pelican object get 'osdf:///<TEST_PATH>?directread=1' -o /tmp/testfile

    Verify the contents of `/tmp/testfile` match the test file or object your origin was serving.

1.  Download a test file (POSIX) or object (S3) from your origin via a cache,
    (replacing `<TEST_PATH>` with the OSDF path to the test file or object):

        :::console
        user@host $ pelican object get 'osdf:///<TEST_PATH>' -o /tmp/testfile2

    Verify the contents of `/tmp/testfile2` match the test file or object your origin was serving.

1.  Verify that your test is running against your Pelican origin:

        :::console
        user@host $ docker logs osdf-origin | grep <TEST_PATH>

    Replacing `<TEST PATH>` with the same path that you used in step (1) or (2).
    If you see output, then the OSDF is directing client requests to your Pelican origin!


Advanced topics
---------------

### Persisting logs

By default, the origin sends logs to the console, where it is captured by the container runtime's logging mechanism.
To save logs to a file instead, set the log location in your origin config file (e.g., `/etc/osdf-origin/config.yaml`)
as follows:

```file
Logging:
  LogLocation: <LOG_FILE_PATH>
```

!!! danger
    Note: the osdf-origin image does not come with log rotation; if you save logs to a file, you must
    set up log rotation yourself to avoid running the origin out of disk space.


### Managing an origin with systemd

If you do not have a container orchestration service but still want to manage a container-based origin,
you may run the container via a systemd service.
The following example uses the values from the setup documented in the [Running an Origin](#running-an-origin) section above.

Create the systemd service file `/etc/systemd/system/docker-osdf-origin.service` as follows:

```file
[Unit]
Description=OSDF Origin Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop osdf-origin
ExecStartPre=-/usr/bin/docker rm osdf-origin
ExecStartPre=/usr/bin/docker pull hub.opensciencegrid.org/pelican_platform/osdf-origin:latest
ExecStart=/usr/bin/docker run --rm --name osdf-origin \
  --publish 8443:8443 \
  --publish 8444:8444 \
  --volume /etc/osdf-origin/issuer.jwk:/etc/pelican/issuer.jwk \
  --volume /etc/osdf-origin/hostcert.pem:/etc/pelican/certificates/tls.crt \
  --volume /etc/osdf-origin/hostkey.pem:/etc/pelican/certificates/tls.key \
  --volume /etc/osdf-origin/config.yaml:/etc/pelican/config.d/99-local.yaml \
  --volume /mnt/origin:/pelican \
  --name osdf-origin \
  hub.opensciencegrid.org/pelican_platform/osdf-origin:latest

[Install]
WantedBy=multi-user.target
```

Enable and start the service with:

```console
root@host $ systemctl enable docker-osdf-origin
root@host $ systemctl start docker-osdf-origin
```



Getting Help
------------

To get assistance, please use the [this page](../../common/help.md).
