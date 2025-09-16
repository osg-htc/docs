title: Installing the OSDF Cache by Container

Installing the OSDF Cache by Container
======================================

This document describes how to run an Open Science Data Federation (OSDF) Cache service via containers.
This service allows a site or regional network to cache data frequently used in Open Science Pool jobs,
reducing data transfer over the wide-area network and increasing throughput to jobs.

Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Container runtime:__ This guide assumes Docker as the container runtime,
    for which the host must have a running `docker` service,
   and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
* __File systems:__ The cache should have a partition of its own for storing data and metadata.
* __Host certificate:__ Required for authentication.  See note below.
* __Network ports:__ The cache service requires the following open ports:
    * Inbound TCP port 8443 for authenticated file access via the HTTP(S) and XRoot protocols.
    * Inbound TCP port 8444 for access to web endpoints such as origin-based token issuers, federation health checks,
      and metrics
    * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring
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
    intermediate CAs; in addition, the first certificate in the file must be the host cert.
    If you're unsure about your setup, try accessing your cache from your browser.

    The certificate chain and key should be mounted into the following locations:

    * **Host Certificate Chain**: `/etc/pelican/certificates/tls.crt`
    * **Host Key**: `/etc/pelican/certificates/tls.key`


!!! note "osdf-cache 7.18"
    This document covers versions 7.18 and later of the `osdf-cache` container image.

!!! note "root"
    The paths used as examples on this page (e.g., `/etc/osdf-cache`) require root to edit;
    if you do not have root on the host, choose new locations where you have modification permissions.


Configuring the Cache Server
----------------------------

The preferred method of configuring a Pelican-based OSDF cache is via a YAML file that will be
mounted into the container at `/etc/pelican/pelican.yaml`.
This document will use `/etc/osdf-cache/config.yaml` as the name of the configuration file outside of the container.

Create `/etc/osdf-cache/config.yaml` with the following contents:
```file
Federation:
  DiscoveryUrl: "https://osg-htc.org"

Cache:
  Port: 8443
# XRootD:
#   Sitename: <RESOURCE NAME REGISTERED WITH OSG>

Server:
  Hostname: "https://<FQDN>"
```

Replacing `<FQDN>` with the externally-accessible FQDN of your cache service
(this should match one of the SANs in your host certificate).
You will also uncomment and fill in the value for `XRootD.Sitename` in a later step, after registration is complete.

Preparing for Initial Startup
-----------------------------

1.  The cache identifies itself to the federation via public key authentication;
before starting the cache for the first time, it is recommended to generate a keypair.
Download the Pelican client from <https://github.com/PelicanPlatform/pelican/releases>,
install the executable as /usr/local/bin/pelican, and run:

        :::console
        root@host$ cd /etc/osdf-cache
        root@host$ pelican key create


    The newly created files, `private-key.pem` and `issuer-pub.jwks` are the private and public keys, respectively.

1.  **Save these files**; if you lose the `private-key.pem` file, your cache will need to be re-approved.


Running a Cache
---------------

This section describes how the cache may be run using the Docker command-line.
For production, we recommend using a container orchestration service such as
[Docker Compose](https://docs.docker.com/compose/),
or [Kubernetes](https://kubernetes.io/).

This table provides a reminder of the parameters that will be used in the examples:

| Parameter             | Example value                    | Description                                                                             | 
|-----------------------|----------------------------------|-----------------------------------------------------------------------------------------|
| `CACHE_HOST_PORT`     | `8443`                           | The host port used for data transfer via HTTP(S)                                        | 
| `WEB_INTERFACE_PORT`  | `8444`                           | The host port used for service management via the web interface                         | 
| `PRIVATE_KEY`         | `/etc/osdf-cache/private-key.pem`| The private key generated by `pelican key create`                                       | 
| `HOST_CERT_CHAIN`     | `/etc/osdf-cache/hostcert.pem`   | The host certificate, with full chain                                                   | 
| `HOST_KEY`            | `/etc/osdf-cache/hostkey.pem`    | The private key matching the host certificate                                           | 
| `CACHE_CONFIG_FILE`   | `/etc/osdf-cache/config.yaml`    | The YAML file containing various cache settings                                         | 
| `CACHE_PARTITION`     | `/mnt/cache`                     | The partition to be used for storing cached data (single partition setup only)          | 
| `NAMESPACE_PARTITION` | `/mnt/cache-namespace`           | The partition to be used for storing namespace information (multi-partition setup only) | 
| `METADATA_PARTITION`  | `/mnt/cache-meta`                | The partition to be used for storing metadata (multi-partition setup only)              | 
| `DATA_PARTITION`      | `/mnt/cache-data`                | The partition to be used for storing cached file contents (multi-partition setup only)  | 


### Single partition

A cache may be configured to use a single partition only;
this is a simpler setup than using multiple partitions, but may have worse performance,
and is not recommended for caches with more than 10 TB of capacity.


```console
user@host $ docker run --rm \
             --publish <CACHE_HOST_PORT>:8443 \
             --publish <WEB_INTERFACE_HOST PORT>:8444 \
             --volume <PRIVATE_KEY>:/etc/pelican/issuer-keys/private-key.pem \
             --volume <HOST_CERT_CHAIN>:/etc/pelican/certificates/tls.crt \
             --volume <HOST_KEY>:/etc/pelican/certificates/tls.key \
             --volume <CACHE_CONFIG_FILE>:/etc/pelican/pelican.yaml \
             --volume <CACHE_PARTITION>:/run/pelican/cache \
             --name osdf-cache \
             hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
```

Using the example values from the table, this is

```console
user@host $ docker run --rm \
             --publish 8443:8443 \
             --publish 8444:8444 \
             --volume /etc/osdf-cache/private-key.pem:/etc/pelican/issuer-keys/private-key.pem \
             --volume /etc/osdf-cache/hostcert.pem:/etc/pelican/certificates/tls.crt \
             --volume /etc/osdf-cache/hostkey.pem:/etc/pelican/certificates/tls.key \
             --volume /etc/osdf-cache/config.yaml:/etc/pelican/pelican.yaml \
             --volume /mnt/cache:/run/pelican/cache \
             --name osdf-cache \
             hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
```


### Multiple partitions

A cache may be configured to store namespace information, data, and metadata on separate partitions.
This improves performance and is recommended for caches with more than 10 TB of capacity.


```console
user@host $ docker run --rm \
             --publish <CACHE_HOST_PORT>:8443 \
             --publish <WEB_INTERFACE_PORT>:8444 \
             --volume <PRIVATE_KEY>:/etc/pelican/issuer-keys/private-key.pem \
             --volume <HOST_CERT_CHAIN>:/etc/pelican/certificates/tls.crt \
             --volume <HOST_KEY>:/etc/pelican/certificates/tls.key \
             --volume <CACHE_CONFIG_FILE>:/etc/pelican/pelican.yaml \
             --volume <NAMESPACE_PARTITION>:/run/pelican/cache/namespace \
             --volume <METADATA_PARTITION>:/run/pelican/cache/meta \
             --volume <DATA_PARTITION>:/run/pelican/cache/data \
             --name osdf-cache \
             hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
```

Using the example values from the table, this is

```console
user@host $ docker run --rm \
             --publish 8443:8443 \
             --publish 8444:8444 \
             --volume /etc/osdf-cache/private-key.pem:/etc/pelican/issuer-keys/private-key.pem \
             --volume /etc/osdf-cache/hostcert.pem:/etc/pelican/certificates/tls.crt \
             --volume /etc/osdf-cache/hostkey.pem:/etc/pelican/certificates/tls.key \
             --volume /etc/osdf-cache/config.yaml:/etc/pelican/pelican.yaml \
             --volume /mnt/cache-namespace:/run/pelican/cache/namespace \
             --volume /mnt/cache-meta:/run/pelican/cache/meta \
             --volume /mnt/cache-data:/run/pelican/cache/data \
             --name osdf-cache \
             hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
```


Validating the Cache
---------------------

You can use the Pelican client (from <https://github.com/PelicanPlatform/pelican/releases>) to verify that the cache is functional.

Download a test file from the OSDF through your cache (replacing `CACHE_HOSTNAME` with the host name of your cache)


```console
user@host $ pelican object get -c CACHE_HOSTNAME:8443 osdf:///pelicanplatform/test/hello-world.txt /tmp/test.txt
user@host $ cat /tmp/test.txt
If you are seeing this message, getting an object from OSDF was successful.
```

If the download fails, rerun the above `pelican object get` command with the `-d` flag added.
Additional debugging information is located in the logs of your cache container.

```console
user@host $ docker logs osdf-cache
```

To increase the debugging information in the cache, edit your cache configuration file and set:
```
Debug: true
```

See [this page](../../common/help.md) for requesting assistance; please include the logs and the `pelican object get -d` output in your request.


Joining the Cache to the Federation
-----------------------------------

The cache must be registered with the OSG prior to joining the data federation.
Send mail to <help@osg-htc.org> requesting registration; provide the following information:

*   Cache hostname
*   Administrative and security contact(s)
*   Institution that the cache belongs to

OSG Staff will register the cache and respond with the Resource Name that the cache was registered as.
Edit your cache configuration file (`/etc/osdf-cache/config.yaml` in the example above):
uncomment `XRootD.Sitename` and change the value to the Resource Name that OSG Staff responded with.
Then, restart your cache.


<!--
Migrating from XCache-based OSDF cache (OSG 23 or earlier) (TODO)
----------------------------------------------------------
-->




Advanced topics
---------------

### Persisting logs

By default, the cache sends logs to the console, where it is captured by the container runtime's logging mechanism.
To save logs to a file instead, set the log location in your cache config file (e.g., `/etc/osdf-cache/config.yaml`)
as follows:

```file
Logging:
  LogLocation: <LOG_FILE_PATH>
```

!!! danger
    Note: the osdf-cache image does not come with log rotation; if you save logs to a file, you must
    set up log rotation yourself to avoid running the cache out of disk space.


<!--

### Optional configuration (TODO)

Further behavior of the cache can be configured by setting the following in the environment variable file:

- `XC_SPACE_HIGH_WM`, `XC_SPACE_LOW_WM`: High-water and low-water marks for disk usage,
  as numbers between 0.00 (0%) and 1.00 (100%);
  when usage goes above the high-water mark, the cache will delete files until it hits the low-water mark.
- `XC_RAMSIZE`: Amount of memory to use for storing blocks before writting them to disk. (Use higher for slower disks).
- `XC_BLOCKSIZE`: Size of the blocks in the cache.
- `XC_PREFETCH`: Number of blocks to prefetch from a file at once.
       This controls how aggressive the cache is to request portions of a file.

-->

### Managing a cache with systemd

If you do not have a container orchestration service but still want to manage a container-based cache,
you may run the container via a systemd service.
The following example uses the [single partition](#single-partition) setup documented above.

Create the systemd service file `/etc/systemd/system/docker-osdf-cache.service` as follows:

```file
[Unit]
Description=OSDF Cache Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop osdf-cache
ExecStartPre=-/usr/bin/docker rm osdf-cache
ExecStartPre=/usr/bin/docker pull hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
ExecStart=/usr/bin/docker run --rm --name osdf-cache \
  --publish 8443:8443 \
  --publish 8444:8444 \
  --volume /etc/osdf-cache/private-key.pem:/etc/pelican/issuer-keys/private-key.pem \
  --volume /etc/osdf-cache/hostcert.pem:/etc/pelican/certificates/tls.crt \
  --volume /etc/osdf-cache/hostkey.pem:/etc/pelican/certificates/tls.key \
  --volume /etc/osdf-cache/config.yaml:/etc/pelican/pelican.yaml \
  --volume /mnt/cache:/run/pelican/cache \
  --name osdf-cache \
  hub.opensciencegrid.org/pelican_platform/osdf-cache:latest

[Install]
WantedBy=multi-user.target
```

Enable and start the service with:

```console
root@host $ systemctl enable docker-osdf-cache
root@host $ systemctl start docker-osdf-cache
```


### Network optimization ###

For caches that are connected to NICs over 40 Gbps we recommend that you disable the virtualized network and bind the
container to the host network.
The following example uses the [single partition](#single-partition) setup documented above.

```console
user@host $ docker run --rm  \
             --network="host" \
             --volume /etc/osdf-cache/private-key.pem:/etc/pelican/issuer-keys/private-key.pem \
             --volume /etc/osdf-cache/hostcert.pem:/etc/pelican/certificates/tls.crt \
             --volume /etc/osdf-cache/hostkey.pem:/etc/pelican/certificates/tls.key \
             --volume /etc/osdf-cache/config.yaml:/etc/pelican/pelican.yaml \
             --volume /mnt/cache:/run/pelican/cache \
             --name osdf-cache \
             hub.opensciencegrid.org/pelican_platform/osdf-cache:latest
```



Getting Help
------------

To get assistance, please use the [this page](../../common/help.md).
