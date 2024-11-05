title: Running Frontier Squid in a Container

Running Frontier Squid in a Container
=====================================

Frontier Squid is a distribution of the well-known [squid HTTP caching
proxy software](http://squid-cache.org) that is optimized for use with
applications on the Worldwide LHC Computing Grid (WLCG). It has
[many advantages](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Why_use_frontier_squid_instead_o)
over regular squid for common distributed computing applications, especially Frontier
and CVMFS. The OSG distribution of frontier-squid is a straight rebuild of the
upstream frontier-squid package for the convenience of OSG users.

!!! tip
    OSG recommends that all sites run a caching proxy for HTTP to help reduce bandwidth and improve
    throughput.

This document outlines how to run Frontier Squid in a Docker container.


Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Frontier Squid Reference section](/data/frontier-squid/#reference) as needed):

1. **Docker:** For the purpose of this guide, the host must have a running docker service
   and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
1.   **Network ports:** Frontier squid communicates on ports 3128 (TCP) and 3401 (UDP).
     - We encourage sites to allow monitoring on port 3401 via UDP from CERN IP address ranges, 128.142.0.0/16,
       188.184.128.0/17, 188.185.48.0/20 and 188.185.128.0/17.
       See the
       [CERN monitoring documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Enabling_monitoring)
       for additional details.
     - If outgoing connections are filtered, note that CVMFS always uses ports 8000, 80, or 8080.
1.   **Host choice:** If you will be supporting the Frontier application at your site, review the
[upstream documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Hardware) to determine how to size your equipment.


Configuring Squid
-----------------

### Environment variables (optional) ###

In addition to the required configuration above (ports and file systems),
you may also configure the behavior of your cache with the following environment variables:

Variable name       | Description                                                             | Defaults                                     |
---------------------|-------------------------------------------------------------------------|----------------------------------------------|
SQUID_IPRANGE       | Limits the incoming connections to the provided whitelist.     |By default only standard private network addresses are whitelisted. |
SQUID_CACHE_DISK    | Sets the cache_dir option which determines the disk size squid uses. Must be an integer value, and its unit is MBs. Note: The cache disk area is located at /var/cache/squid. | Defaults to 10000. |
SQUID_CACHE_MEM     | Sets the cache_mem option which regulates the size squid reserves for caching small objects in memory. Includes a space and unit, e.g. "MB". | Defaults to "128 MB". |

!!! tip "Cache Disk Size"
    For production deployments, OSG recommends allocating at least 50 to 100 GB
    (50000 to 100000 MB) to SQUID_CACHE_DISK.

### Mount points ###

In order to preserve the cache between redeployments, you should map the following areas to persistent storage outside the container:

Mountpoint       | Description                                                          | Example docker mount               |
-----------------|----------------------------------------------------------------------|------------------------------------|
/var/cache/squid | This directory contains the cache for squid. See also SQUID_CACHE_DISK above. | -v /tmp/squid:/var/cache/squid |
/var/log/squid   | This directory contains the squid logs.                              | -v /tmp/log:/var/log/squid         |

For more details, see the [Frontier Squid documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Configuration).

### Configuration customization (optional) ###

More complicated configuration customization can be done by mounting `.sh` and `.awk` files into /etc/squid/customize.d.
For details on the names and content of those files see the comments in the
[customization script](https://github.com/opensciencegrid/docker-frontier-squid/blob/master/squid-customize.sh) 
and see the
[upstream documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Configuration)
on configuration customization.


Running a Frontier Squid Container
----------------------------------

!!! info "Where is the OSG 24 container?"
    We are actively reworking our image build infrastructure for OSG 24 and expect to have all OSG Software containers
    available by the end of 2024.

To run a Frontier Squid container with the defaults:

```console
user@host $ docker run --rm --name frontier-squid \
             -v <HOST CACHE PARTITION>:/var/cache/squid \
             -v <HOST LOG PARTITION>:/var/log/squid \
             -p <HOST PORT>:3128 opensciencegrid/frontier-squid:23-release
```

You may pass configuration variables in `KEY=VALUE` format with either
docker `-e` options or in a file specified with `--env-file=<FILENAME>`.

### Running a Frontier Squid container with systemd

An example systemd service file for Frontier Squid.
This will require creating the environment file in the directory `/opt/xcache/.env`. 

!!! note
    This example systemd file assumes `<HOST PORT>` is `3128` and `<HOST CACHE PARTITION>` is `/tmp/squid` and
    `<HOST LOG PARTITION>` is `/tmp/log`.

Create the systemd service file `/etc/systemd/system/docker.frontier-squid.service` as follows:

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
ExecStartPre=/usr/bin/docker pull opensciencegrid/frontier-squid:23-release
ExecStart=/usr/bin/docker run --rm --name %n --publish 3128:3128 -v /tmp/squid:/var/cache/squid -v /tmp/log:/var/log/squid --env-file /opt/xcache/.env opensciencegrid/frontier-squid:23-release


[Install]
WantedBy=multi-user.target
```

Enable and start the service with:

```console
root@host $ systemctl enable docker.frontier-squid
root@host $ systemctl start docker.frontier-squid
```

Validating the Frontier Squid Cache
-----------------------------------

The cache server functions as a normal HTTP server and can interact with typical HTTP clients, such as `curl` or `wget`.
Here, `<HOST PORT>` is the port chosen in the `docker run` command, `3128` by default.

```console
user@host $ export http_proxy=http://localhost:<HOST PORT>
user@host $ wget -qdO/dev/null http://frontier.cern.ch 2>&1 | grep X-Cache
X-Cache: MISS from 797a56e426cf
user@host $ wget -qdO/dev/null http://frontier.cern.ch 2>&1 | grep X-Cache
X-Cache: HIT from 797a56e426cf
```

## Registering Frontier Squid

See the [Registering Frontier Squid](https://osg-htc.org/docs/data/frontier-squid/#registering-frontier-squid)
instructions to register your Frontier Squid host.


Getting Help
------------

To get assistance, please use the [this page](/common/help).
