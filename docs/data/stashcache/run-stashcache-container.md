DateReviewed: 2020-06-22

Running StashCache Cache in a Container
=======================================

The OSG operates the [StashCache data federation](overview.md), which
provides organizations with a method to distribute their data in a scalable manner to thousands of jobs without needing
to pre-stage data across sites or operate their own scalable infrastructure.

[Stash Caches](install-cache.md) transfer data to clients such as jobs or users.
A set of caches are operated across the OSG for the benefit of nearby sites;
in addition, each site may run its own cache in order to reduce the amount of data transferred over the WAN.
This document outlines how to run StashCache in a Docker container.

Before Starting
---------------

Before starting the installation process, consider the following points:

1. **Docker:** For the purpose of this guide, the host must have a running docker service
   and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
1. **Network ports:** Stash Cache listens for incoming HTTP/S connections on port 8000 (by default)
1. **File Systems:** Stash Cache needs host partitions to store user data.
   For improved performance and storage, we recommend multiple partitions for handling namespaces (HDD), data (HDDs),
   and metadata (SSDs).

Configuring Stash Cache
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

### Optional configuration ###

Further behavior of the cache can be configured by setting the following in the environment variable file:

- `XC_SPACE_HIGH_WM`, `XC_SPACE_LOW_WM`: High-water and low-water marks for disk usage;
      when usage goes above the high-water mark, the cache will delete files until it hits the low-water mark.
- `XC_PORT`: TCP port that XCache listens on
- `XC_RAMSIZE`: Amount of memory to use for storing blocks before writting them to disk. (Use higher for slower disks).
- `XC_BLOCKSIZE`: Size of the blocks in the cache.
- `XC_PREFETCH`: Number of blocks to prefetch from a file at once.
       This controls how aggressive the cache is to request portions of a file.
       If you set it to `0`, prefetching will be disabled, but that is not recommended.


Running a Cache
---------------

StashCache cache containers  may be run with either multiple mounted host partitions (recommended) or a single host
partition.

It is recommended to use a container orchestration service such as [docker-compose](https://docs.docker.com/compose/)
or [kubernetes](https://kubernetes.io/) whose details are beyond the scope of this document.
The following sections provide examples for starting cache containers from the command-line as well as a more
production-appropriate method using systemd.

### Multiple host partitions (recommended) ###

For improved performance and storage,
especially if your cache is serving over 10 TB of data,
we recommend multiple partitions for handling namespaces (HDD, SSD, or NVME), data (HDDs), and metadata (SSDs or NVME).

!!! note
    Under this configuration the `<NAMESPACE PARTITION>` is not used to store the files.
    Instead, the partition stores symlinks to the files in the metadata and data partitions.

```console
user@host $ docker run --rm --publish <HOST PORT>:8000 \
             --volume <NAMESPACE PARTITION>:/xcache/namespace \
             --volume <METADATA PARTITION 1>:/xcache/meta1
             ...
             --volume <METADATA PARTITION N>:/xcache/metaN
             --volume <DATA PARTITION 1>:/xcache/data1
             ...
             --volume <DATA PARTITION N>:/xcache/dataN
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:release
```

!!! warning
    For over 100 TB of assigned space we highly encourage to use this setup and mount `<NAMESPACE PARTITION>` in
    solid state disks or NVME.

### Single host partition ###

For a simpler installation, you may use a single host partition mounted to `/xcache/`:

```console
user@host $ docker run --rm --publish <HOST PORT>:8000 \
             --volume <HOST PARTITION>:/xcache \
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:release
```

### Running Stash Cache on container with systemd

An example systemd service file for Stash Cache.
This will require creating the environment file in the directory `/opt/xcache/.env`. 

!!! note
    This example systemd file assumes `<HOST PORT>` is `8000` and  `<HOST PARTITION>` is `/srv/cache`.

Create the systemd service file `/etc/systemd/system/docker.stash-cache.service` as follows:

```file
[Unit]
Description=Stash Cache Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull opensciencegrid/stash-cache:release
ExecStart=/usr/bin/docker run --rm --name %n --publish 8000:8000 --volume /srv/cache:/xcache --env-file /opt/xcache/.env opensciencegrid/stash-cache:release

[Install]
WantedBy=multi-user.target
```

Enable and start the service with:

```console
root@host $ systemctl enable docker.stash-cache
root@host $ systemctl start docker.stash-cache
```

!!! warning
    You must [register](install-cache.md#registering-the-cache) the cache before considering it a
    production service.



### Network optimization ###

For caches that are connected to NIC's over `40Gbps` we recommend that you disable the virtualized network and "bind" the
container to the host network:

```console
user@host $ docker run --rm  \
             --network="host" \
             --volume <HOST PARTITION>:/cache \
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:release
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
Here, `<HOST PORT>` is the port chosen in the `docker run` command, `8000` by default.


```console
user@host $ curl -O http://cache_host:<HOST PORT>/osgconnect/public/rynge/test.data
```

`curl` may not correctly report a failure, so verify that the contents of the file are:
```
hello world!
```

Getting Help
------------

To get assistance, please use the [this page](../../common/help.md) or contact <help@opensciencegrid.org> directly.
