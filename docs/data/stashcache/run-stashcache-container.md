DateReviewed: 2020-06-22

Running StashCache Cache in a Container
=======================================

The OSG operates the [StashCache data federation](/data/stashcache/overview), which
provides organizations with a method to distribute their data in a scalable manner to thousands of jobs without needing
to pre-stage data across sites or operate their own scalable infrastructure.

[Stash Caches](/data/stashcache/install-cache) transfer data to clients such as jobs or users.
A set of caches are operated across the OSG for the benefit of nearby sites;
in addition, each site may run its own cache in order to reduce the amount of data transferred over the WAN.
This document outlines how to run StashCache in a Docker container.

Before Starting
---------------

Before starting the installation process, consider the following points:

1. **Docker:** For the purpose of this guide, the host must have a running docker service
   and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
1. **Network ports:** Stash Cache listens for incoming HTTP/S connections on port 8000 (by default)
1. **File Systems:** Stash Cache needs a partition on the host to store cached data

Configuring Stash Cache
-----------------------

In addition to the required configuration above (ports and file systems),
you may also configure the behavior of your cache with the following variables using an environment variable file:

Where the environment file on the docker host, `/opt/xcache/.env`, has (at least) the following contents
(replace `YOUR_SITE_NAME` with the name of your site as
[registered in Topology](/data/stashcache/install-cache#registering-the-cache)):
```file
XC_RESOURCENAME=YOUR_SITE_NAME
XC_ROOTDIR=/cache
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

To run the container, use `docker run` with the following options, replacing the text within angle brackets
with your own values:

```console
user@host $ docker run --rm --publish <HOST PORT>:8000 \
             --volume <HOST PARTITION>:/cache \
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:stable
```

It is recommended to use a container orchestration service such as [docker-compose](https://docs.docker.com/compose/)
or [kubernetes](https://kubernetes.io/), or start the stash cache container with systemd.

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
ExecStartPre=/usr/bin/docker pull opensciencegrid/stash-cache:stable
ExecStart=/usr/bin/docker run --rm --name %n --publish 8000:8000 --volume /srv/cache:/cache --env-file /opt/xcache/.env opensciencegrid/stash-cache:stable

[Install]
WantedBy=multi-user.target
```

Enable and start the service with:

```console
root@host $ systemctl enable docker.stash-cache
root@host $ systemctl start docker.stash-cache
```

!!! warning
    You must [register](/data/stashcache/install-cache/#registering-the-cache) the cache before considering it a production service.



### Network Optimization ###

For caches that are connected to NIC's over `40Gbps` we recommend to disable the virtualized network and "bind" the container to the host network:

```console
user@host $ docker run --rm  \
             --network="host" \
             --volume <HOST PARTITION>:/cache \
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:stable
```

### Memory optimization ###

The cache uses the host's memory for two purposes:

1. Caching files recently read from disk (via the kernel page cache).
1. Buffering files recently received from the network before writing them to disk (to compensate for slow disks).

An easy way to increase the performance of the cache is to assign it more memory.
If you set a limit on the container's memory usage via the docker option `--memory` or Kubernetes resource limits,
make sure it is at least twice the value of `XC_RAMSIZE`.


### Multiple disks ###

For caches that store over 10 TB or that have assigned space for storing the cached files over multiple partitions
(e.g. `/partition1, /partition2, ...`) we recommend the following:

1. Create a config file `90-my-stash-cache-disks.cfg` with the following contents:

        :::file
        pfc.spaces data
        oss.space data /data1
        oss.space data /data2
        .
        .
        .

1. Run the container with the following options:

        :::console
        user@host $ docker run --rm --publish <HOST PORT>:8000 \
             --volume <HOST PARTITION>:/cache \
             --volume /partition1:/data1 \
             --volume /partition2:/data2 \
             --volume /opt/xcache/90-my-stash-cache-disks.cfg:/etc/xrootd/config.d/90-stash-cache-disks.cfg \
             --env-file=/opt/xcache/.env \
             opensciencegrid/stash-cache:stable

!!! note
    Under this configuration the `<HOST PARTITION>` is not used to store the files.
    Instead, the host partition stores symlinks to the files in `/partition1` and `/partition2`.

!!! warning
    For over 100 TB of assigned space we highly encourage to use this setup and mount `<HOST PARTITION>` in solid state disks or NVME.


Validating the Cache
---------------------

The cache server functions as a normal HTTP server and can interact with typical HTTP clients, such as `curl`.


```console
user@host $ curl -O http://cache_host:8000/osgconnect/public/rynge/test.data
```

`curl` may not correctly report a failure, so verify that the contents of the file are:
```
hello world!
```

Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact <help@opensciencegrid.org> directly.

