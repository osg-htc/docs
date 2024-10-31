title: Running OSDF Cache in a Container
DateReviewed: 2020-06-22

Running OSDF Cache in a Container
=======================================

!!! warning "Deprecation warning"
    This document is outdated and describes an XCache-based OSDF Cache install, which is deprecated.
    Future OSDF Caches should be based on Pelican; documentation for a Pelican-based OSDF Cache install is forthcoming.

The OSG operates the [Open Science Data Federation](overview.md) (OSDF), which
provides organizations with a method to distribute their data in a scalable manner to thousands of jobs without needing
to pre-stage data across sites or operate their own scalable infrastructure.

[OSDF Caches](install-cache.md) transfer data to clients such as jobs or users.
A set of caches are operated across the OSG for the benefit of nearby sites;
in addition, each site may run its own cache in order to reduce the amount of data transferred over the WAN.
This document outlines how to run a cache in a Docker container.

!!! note
    The OSDF cache was previously named "Stash Cache" and some documentation and software may use the old name.

Before Starting
---------------

Before starting the installation process, consider the following requirements:

1. **Docker:** For the purpose of this guide, the host must have a running docker service
   and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
1. **Network ports:** The cache service requires the following open ports:
     * Inbound TCP port 1094 for unauthenticated file access via the XRootD protocol (optional)
     * Inbound TCP port 8000 for unauthenticated file access via HTTP(S) and/or
     * Inbound TCP port 8443 for authenticated file access via HTTPS
     * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring
1. **File Systems:** The cache needs host partitions to store user data.
   For improved performance and storage, we recommend multiple partitions for handling namespaces (HDD, SSD, or NVMe),
   data (HDDs), and metadata (SSDs or NVMe).
1. **Host certificate:** Required for authentication.
   See our [host certificate documentation](../../security/host-certs.md) for instructions on how to request host certificates.
1. **Hardware requirements:** We recommend that a cache has at least 10Gbps connectivity,
   1 TB of disk space for the cache directory, and 12GB of RAM.

<!-- NOTE: Keep the "Registering the Cache" section below in sync with install-cache.md -->

Registering the Cache
---------------------

To be part of the OSDF, your cache must be registered with the OSG.
You will need basic information like the resource name, hostname,
host certificate DN, and the administrative and security contacts.


### Initial registration

To register your cache host, follow the general registration instructions [here](https://osg-htc.org/docs/common/registration/#new-resources).
The service type is `XRootD cache server`.

!!! info
    This step must be completed before installation.

In your registration, you must specify which VOs your cache will serve by adding an `AllowedVOs` list, with each line specifying a VO whose data you are willing to cache.

There are special values you may use in `AllowedVOs`:

- `ANY_PUBLIC` indicates that the cache is willing to serve public data from any VO.
- `ANY` indicates that the cache is willing to serve data from any VO,
  both public and protected.
  `ANY` implies `ANY_PUBLIC`.

There are extra requirements for serving protected data:

- In addition to the cache allowing a VO in the `AllowedVOs` list,
  that VO must also allow the cache in its `AllowedCaches` list.
  See the page on [getting your VO's data into OSDF](vo-data.md).
- There must be an authenticated XRootD instance on the cache server.
- There must be a `DN` attribute in the resource registration
  with the [subject DN](../../security/host-certs/overview.md#before-starting) of the host certificate

This is an example registration for a cache server that serves all public data:
```yaml
  MY_OSDF_CACHE:
    FQDN: my-cache.example.net
    Services:
      XRootD cache server:
        Description: OSDF cache server
    AllowedVOs:
      - ANY_PUBLIC
```

This is an example registration for a cache server that only serves protected data for the Open Science Pool:
```yaml
  MY_AUTH_OSDF_CACHE:
    FQDN: my-auth-cache.example.net
    Services:
      XRootD cache server:
        Description: OSDF cache server
    AllowedVOs:
      - OSG
    DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=my-auth-cache.example.net
```

This is an example registration for a cache server that serves all public data _and_ protected data from the OSG VO:
```yaml
  MY_COMBO_OSDF_CACHE:
    FQDN: my-combo-cache.example.net
    Services:
      XRootD cache server:
        Description: OSDF cache server
    AllowedVOs:
      - OSG
      - ANY_PUBLIC
    DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=my-combo-cache.example.net
```

<!-- NOTE: Keep the "Registering the Cache" section above in sync with install-cache.md -->

Configuring the OSDF Cache
-----------------------

In addition to the required configuration above (ports and file systems),
you may also configure the behavior of your cache with the following variables using an environment variable file:

Where the environment file on the docker host, `/opt/xcache/.env`, has (at least) the following contents,
replacing `<YOUR_RESOURCE_NAME>` with the name of your resource as
[registered in Topology](install-cache.md#registering-the-cache)
and `<FQDN>` with the public DNS name that should be used to contact your cache:

```file
XC_RESOURCENAME=<YOUR_RESOURCE_NAME>
CACHE_FQDN=<FQDN>
```

### Providing a host certificate

The service will need a certificate for contacting central OSDF services
and for authenticating to origins.

Follow our [host certificate documentation](../../security/host-certs.md) to obtain a host certificate and key.
Then, volume-mount the host certificate to `/etc/grid-security/hostcert.pem`,
and the key to `/etc/grid-security/hostkey.pem`.

!!! note
    You must restart the container whenever you renew your certificate
    in order for the services to pick up the new certificate.
    If you automate certificate renewal, you should automate restarts as well.
    For example, if you are using Certbot for Let's Encrypt, you should write a "deploy hook" as documented
    [on the Certbot site](https://certbot.eff.org/docs/using.html#renewing-certificates).

!!! note
    A small number of CAs in the IGTF and OSG CA cert distributions were signed with the SHA1 algorithm,
    which is not accepted by default starting with Enterprise Linux 9.
    If you are running a cache image based on OSG 23 or newer, and your situation includes any of the following:
    
    -   Your cache's host certificate was signed by a SHA1-signed-CA
    -   You are expecting connections from clients that authenticate themselves with a cert from a SHA1-signed-CA
    -   Your cache serves data from an origin whose host certificate was signed by a SHA1-signed-CA
    
    then you must add `ENABLE_SHA1=yes` to the environment variable file.


### Optional configuration ###

Further behavior of the cache can be configured by setting the following in the environment variable file:

- `XC_SPACE_HIGH_WM`, `XC_SPACE_LOW_WM`: High-water and low-water marks for disk usage,
  as numbers between 0.00 (0%) and 1.00 (100%);
  when usage goes above the high-water mark, the cache will delete files until it hits the low-water mark.
- `XC_RAMSIZE`: Amount of memory to use for storing blocks before writting them to disk. (Use higher for slower disks).
- `XC_BLOCKSIZE`: Size of the blocks in the cache.
- `XC_PREFETCH`: Number of blocks to prefetch from a file at once.
       This controls how aggressive the cache is to request portions of a file.


Running a Cache
---------------

Cache containers may be run with either multiple mounted host partitions (recommended) or a single host
partition.

It is recommended to use a container orchestration service such as [docker-compose](https://docs.docker.com/compose/)
or [kubernetes](https://kubernetes.io/) whose details are beyond the scope of this document.
The following sections provide examples for starting cache containers from the command-line as well as a more
production-appropriate method using systemd.

### Multiple host partitions (recommended) ###

For improved performance and storage,
especially if your cache is serving over 10 TB of data,
we recommend multiple partitions for handling namespaces (HDD, SSD, or NVMe), data (HDDs), and metadata (SSDs or NVMe).

!!! note
    Under this configuration the `<NAMESPACE PARTITION>` is not used to store the files.
    Instead, the partition stores symlinks to the files in the metadata and data partitions.

```console
user@host $ docker run --rm \
             --publish <HTTP HOST PORT>:8000 \
             --publish <HTTPS HOST PORT>:8443 \
             --volume <HOST CERT>:/etc/grid-security/hostcert.pem \
             --volume <HOST KEY>:/etc/grid-security/hostkey.pem \
             --volume <NAMESPACE PARTITION>:/xcache/namespace \
             --volume <METADATA PARTITION 1>:/xcache/meta1
             ...
             --volume <METADATA PARTITION N>:/xcache/metaN
             --volume <DATA PARTITION 1>:/xcache/data1
             ...
             --volume <DATA PARTITION N>:/xcache/dataN
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:23-release
```

!!! warning
    For over 10 TB of assigned space we highly encourage to use this setup and mount `<NAMESPACE PARTITION>` in
    solid state disks or NVMe.

### Single host partition ###

For a simpler installation, you may use a single host partition mounted to `/xcache/`:

```console
user@host $ docker run --rm \
             --publish <HTTP HOST PORT>:8000 \
             --publish <HTTPS HOST PORT>:8443 \
             --volume <HOST PARTITION>:/xcache \
             --volume <HOST CERT>:/etc/grid-security/hostcert.pem \
             --volume <HOST KEY>:/etc/grid-security/hostkey.pem \
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:23-release
```

### Running a cache on container with systemd

An example systemd service file for the OSDF cache.
This will require creating the environment file in the directory `/opt/xcache/.env`.

!!! note
    This example systemd file assumes `<HTTP HOST PORT>` is `8000`, `<HTTPS HOST PORT>` is `8443`, 
    `<HOST PARTITION>` is `/srv/cache`, and the cert and key to use are in `/etc/ssl/host.crt` and `/etc/ssl/host.key`,
    respectively.

Create the systemd service file `/etc/systemd/system/docker.stash-cache.service` as follows:

```file
[Unit]
Description=Cache Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull opensciencegrid/stash-cache:23-release
ExecStart=/usr/bin/docker run --rm --name %n \
  --publish 8000:8000 \
  --publish 8443:8443 \
  --volume /srv/cache:/xcache \
  --volume /etc/ssl/host.crt:/etc/grid-security/hostcert.pem \
  --volume /etc/ssl/host.key:/etc/grid-security/hostkey.pem \
  --env-file /opt/xcache/.env \
  opensciencegrid/stash-cache:23-release

[Install]
WantedBy=multi-user.target
```

Enable and start the service with:

```console
root@host $ systemctl enable docker.stash-cache
root@host $ systemctl start docker.stash-cache
```

!!! warning
    You must [register](install-cache.md#registering-the-cache) the cache before starting it up.



### Network optimization ###

For caches that are connected to NICs over 40 Gbps we recommend that you disable the virtualized network and "bind" the
container to the host network:

```console
user@host $ docker run --rm  \
             --network="host" \
             --volume <HOST PARTITION>:/cache \
             --volume <HOST CERT>:/etc/grid-security/hostcert.pem \
             --volume <HOST KEY>:/etc/grid-security/hostkey.pem \
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:23-release
```

### Memory optimization ###

The cache uses the host's memory for two purposes:

1. Caching files recently read from disk (via the kernel page cache).
1. Buffering files recently received from the network before writing them to disk (to compensate for slow disks).

An easy way to increase the performance of the cache is to assign it more memory.
If you set a limit on the container's memory usage via the docker option `--memory` or Kubernetes resource limits,
make sure it is at least twice the value of `XC_RAMSIZE`.

Validating the Cache
---------------------

The cache server functions as a normal HTTP server and can interact with typical HTTP clients, such as `curl`.
Here, `<HTTP HOST PORT>` is the port chosen in the `docker run` command, `8000` by default.


```console
user@host $ curl -O http://cache_host:<HTTP HOST PORT>/ospool/uc-shared/public/OSG-Staff/validation/test.txt
```

`curl` may not correctly report a failure, so verify that the contents of the file are:
```
Hello, World!
```

Getting Help
------------

To get assistance, please use the [this page](../../common/help.md).
