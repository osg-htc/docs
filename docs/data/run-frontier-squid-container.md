Running Frontier Squid in a Container
=====================================

Frontier Squid is a distribution of the well-known [squid HTTP caching
proxy software](http://squid-cache.org) that is optimized for use with
applications on the Worldwide LHC Computing Grid (WLCG). It has
[many advantages](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Why_use_frontier_squid_instead_o)
over regular squid for common grid applications, especially Frontier
and CVMFS. The OSG distribution of frontier-squid is a straight rebuild of the
upstream frontier-squid package for the convenience of OSG users.

!!! tip
    OSG recommends that all sites run a caching proxy for HTTP and HTTPS to help reduce bandwidth and improve
    throughput.

This document outlines how to run Frontier Squid in a Docker container.


Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Reference section below](#reference) as needed):

1. **Docker:** For the purpose of this guide, the host must have a running docker service
   and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
1.   **Network ports:** Frontier squid communicates on ports 3128 (TCP) and 3401 (UDP)
1.   **Host choice:** If you will be supporting the Frontier application at your site, review the
[upstream documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Hardware) to determine how to size your equipment.


Configuring Squid
-----------------

### Environment variables (optional) ###

In addition to the required configuration above (ports and file systems),
you may also configure the behavior of your cache with the following variables using an environment variable file:

Where the environment file on the docker host, `/etc/squid/.env`, has any of the following variables set in `KEY=VALUE`
format:

Variable name       | Description                                                             | Defaults                                     |
---------------------|-------------------------------------------------------------------------|----------------------------------------------|
SQUID_IPRANGE       | Limits the incoming connections to the provided whitelist.     |By default only standard private network addresses are whitelisted. |
SQUID_CACHE_DISK    | Sets the cache_dir option which determines the disk size squid uses. Must be an integer value, and its unit is MBs. Note: The cache disk area is located at /var/cache/squid. | Defaults to 10000. |
SQUID_CACHE_MEM     | Sets the cache_mem option which regulates the size squid reserves for caching small objects in memory. | Defaults to "128 MB". |

### Mount points ###

In order to preserve the cache between redeployments, you should map the following areas to persistent storage outside the container:

Mountpoint       | Description                                                          | Example docker mount               |
-----------------|----------------------------------------------------------------------|------------------------------------|
/var/cache/squid | This directory contains the cache for squid. See also SQUID_CACHE_DISK above. | -v /tmp/squid:/var/cache/squid |
/var/log/squid   | This directory contains the squid logs.                              | -v /tmp/log:/var/log/squid         |

For more details, see the [Frontier Squid documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Configuration).


Running a Frontier Squid Container
----------------------------------

To run a Frontier Squid container with the defaults:

```console
user@host $ docker run --rm --name frontier-squid \
             --env-file=/etc/squid/.env \
             -v <HOST CACHE PARTITION>:/var/cache/squid \
             -v <HOST LOG PARTITION>:/var/log/squid \
             -p <HOST PORT>:3128 opensciencegrid/frontier-squid:stable
```

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
ExecStartPre=/usr/bin/docker pull opensciencegrid/frontier-squid:stable
ExecStart=/usr/bin/docker run --rm --name %n --publish 3128:3128 -v /tmp/squid:/var/cache/squid -v /tmp/log:/var/log/squid --env-file /opt/xcache/.env opensciencegrid/frontier-squid:stable


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

See the [Registering Frontier Squid](https://opensciencegrid.org/docs/data/frontier-squid/#registering-frontier-squid)
instructions to register your Frontier Squid host.


Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact <help@opensciencegrid.org> directly.
