title: Installing the OSDF Cache by Container

Installing the OSDF Cache by Container
======================================

This document describes how to run an Open Science Data Federation (OSDF) Cache service via containers.
This service allows a site or regional network to cache data frequently used in Open Science Pool jobs,
reducing data transfer over the wide-area network and increasing throughput to jobs.

Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Docker:__ For the purpose of this guide, the host must have a running docker service
   and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
* __File Systems:__ The cache should have a partition of its own for storing data and metadata.
* __Network ports:__ The cache service requires the following open ports:
  * Inbound TCP port 8443 for authenticated file access via the HTTP(S) and XRoot protocols.
  * (Optional) Inbound TCP port 8444 for access to the web interface for monitoring and configuration;
    if enabled, access to this port should be restricted to the LAN.
  * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring
* __Host certificate:__ Required for authentication.  See note below.
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


!!! note "Host certificates"
    Caches are accessed by users through browsers, meaning caches need a certificate from a CA acceptable to a standard browser.
    Examples include [Let's Encrypt](../../security/host-certs/lets-encrypt.md) or the InCommon RSA CA.
    Caches without a valid certificate for the browser cannot be added to the OSDF.
    Note that, unlike legacy grid software, the public certificate file will need to contain the "full chain", including any
    intermediate CAs (if you're unsure about your setup, try accessing your cache from your browser).

    The certificate chain and key should be mounted into the following locations:

    * **Host Certificate Chain**: `/etc/pelican/certificates/tls.crt`
    * **Host Key**: `/etc/pelican/certificates/tls.key`


!!! note "osdf-cache 7.12"
    This document covers versions 7.12 and later of the `osdf-cache` container image.


Configuring the Cache Server
----------------------------

In addition to the required configuration above (ports and file systems),
you may also configure the behavior of your cache with the following variables using an environment variable file:

Where the environment file on the docker host, `/opt/osdf-cache/.env`, has (at least) the following contents,
replacing `<YOUR_RESOURCE_NAME>` with the name of your resource as
[registered in Topology](install-cache.md#registering-the-cache)
and `<FQDN>` with the public DNS name that should be used to contact your cache:

```file
PELICAN_XROOTD_SITENAME=<YOUR_RESOURCE_NAME>
PELICAN_CACHE_PORT=8443
```






Migrating from XCache-based OSDF cache (OSG 23 or earlier)
----------------------------------------------------------





### Optional configuration ###

Further behavior of the cache can be configured by setting the following in the environment variable file:

- `XC_SPACE_HIGH_WM`, `XC_SPACE_LOW_WM`: High-water and low-water marks for disk usage,
  as numbers between 0.00 (0%) and 1.00 (100%);
  when usage goes above the high-water mark, the cache will delete files until it hits the low-water mark.
- `XC_RAMSIZE`: Amount of memory to use for storing blocks before writting them to disk. (Use higher for slower disks).
- `XC_BLOCKSIZE`: Size of the blocks in the cache.
- `XC_PREFETCH`: Number of blocks to prefetch from a file at once.
       This controls how aggressive the cache is to request portions of a file.


Preparing for Initial Startup
-----------------------------

1.  The cache identifies itself to the federation via public key authentication;
before starting the cache for the first time, it is recommended to generate a keypair.
Download the Pelican client from <https://github.com/PelicanPlatform/pelican/releases> and run:

        :::console
        user@host$ pelican generate keygen


    The newly created files, `issuer.jwk` and `issuer-pub.jwks` are the private and public keys, respectively.

1.  **Save these files**; if you lose the `issuer.jwk`, your cache will need to be re-approved.


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
             --publish <HTTPS HOST PORT>:8443 \
             --publish <WEB INTERFACE HOST PORT>:8444 \
             --volume <ISSUER JWK>:/etc/pelican/issuer.jwk \
             --volume <HOST CERT>:/etc/pelican/certificates/tls.crt \
             --volume <HOST KEY>:/etc/pelican/certificates/tls.key \
             --volume <NAMESPACE PARTITION>:/run/pelican/cache/namespace \
             --volume <METADATA PARTITION>:/run/pelican/cache/meta \
             --volume <DATA PARTITION>:/run/pelican/cache/data \
             --name osdf-cache \
             --env-file=/opt/osdf-cache/.env \
             hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
```

### Single host partition ###

For a simpler installation, you may use a single host partition mounted to `/run/pelican/cache/`:

```console
user@host $ docker run --rm \
             --publish <HTTPS HOST PORT>:8443 \
             --publish <WEB INTERFACE HOST PORT>:8443 \
             --volume <HOST PARTITION>:/run/pelican/cache \
             --volume <HOST CERT>:/etc/pelican/certificates/tls.crt \
             --volume <HOST KEY>:/etc/pelican/certificates/tls.key \
             --name osdf-cache \
             --env-file=/opt/xcache/.env \
             hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
```

### Running a cache on container with systemd (TODO)

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
             --name osdf-cache \
             --env-file=/opt/xcache/.env \
             hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
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

You can use the Pelican client (from <https://github.com/PelicanPlatform/pelican/releases>) to verify that the cache is functional.

Download a test file from the OSDF through your cache (replacing `CACHE_HOSTNAME` with the host name of your cache)


```console
user@host $ pelican object get -c CACHE_HOSTNAME:8443 osdf://ospool/uc-shared/public/OSG-Staff/validation/test.txt /tmp/test.txt
user@host $ cat /tmp/test.txt

Hello, World!
```
If the download fails, rerun the above `pelican object get` command with the `-d` flag added.
Additional debugging information is located in the logs of your cache container.

```console
root@host $ docker logs osdf-cache
```

See [this page](../../common/help.md) for requesting assistance; please include the logs and the `pelican object get -d` output in your request.


Getting Help
------------

To get assistance, please use the [this page](../../common/help.md).
