DateReviewed: 2020-06-22

Running OSDF Origin in a Container
========================================

!!! note
    Currently, the origin container only supports distribution of public data.
    If you would like to distribute private data requiring authentication,
    see [the RPM installation guide](install-origin.md).

The OSG operates the [Open Science Data Federation](overview.md) (OSDF), which
provides organizations with a method to distribute their data in a scalable manner to thousands of jobs without needing
to pre-stage data across sites or operate their own scalable infrastructure.

[Origins](install-origin.md) store copies of users' data.
Each community (or experiment) needs to run one origin to export its data via the federation.
This document outlines how to run such an origin in a Docker container.

Before Starting
---------------

Before starting the installation process, consider the following points:

1. **Docker:** For the purpose of this guide, the host must have a running docker service and you must have the ability
to start containers (i.e., belong to the `docker` Unix group).
1. **Network ports:** The origin listens for incoming HTTP/S and XRootD connections on ports 1094 and 1095 (by
default).
1. **File Systems:** The origin needs a host partition to store user data.
1. **Registration:** Before deploying an origin, you must
   [registered the service](install-origin.md#registering-the-origin) in the OSG Topology

Configuring the Origin
----------------------

In addition to the required configuration above (ports and file systems), you may also configure the behavior of your
origin with the following variables using an environment variable file:

Where the environment file on the docker host, `/opt/origin/.env`, has (at least) the following contents,
replacing `<YOUR_RESOURCE_NAME>` with the resource name of your origin as
[registered in Topology](install-origin.md#registering-the-origin)
and `<FQDN>` with the public DNS name that should be used to contact your origin:

```file
XC_RESOURCENAME=YOUR_SITE_NAME
ORIGIN_FQDN=<FQDN>
```

Populating Origin Data
----------------------

The OSDF namespace is shared by multiple VOs so you must
[choose a namespace](vo-data.md#choosing-namespaces) for your own VO's data.
When running an origin container, your chosen namespace must be reflected in your host partition.

For example, if your host partition is `/srv/origin-public` and the name of your VO is `ASTRO`,
you should store the Astro VO's public data in `/srv/origin-public/astro/`.
Then, when starting container, you will mount `/srv/origin-public/` into `/xcache/namespace` in the container.

Running the Origin
------------------

It is recommended to use a container orchestration service such as [docker-compose](https://docs.docker.com/compose/)
or [kubernetes](https://kubernetes.io/) whose details are beyond the scope of this document.
The following sections provide examples for starting origin containers from the command-line as well as a more
production-appropriate method using systemd.

```console
user@host $ docker run --rm --publish 1094:1094 \
             --publish 1095:1095 \
             --volume <HOST PARTITION>:/xcache/namespace \
             --env-file=/opt/origin/.env \
             opensciencegrid/stash-origin:release
```

Replacing `<HOST PARTITION>` with the host directory containing data that your origin should serve.
See [this section](#populating-origin-data) for details.

!!!warning
    A container deployed this way will serve the entire contents of `<HOST PARTITION>`.

### Running on origin container with systemd

An example systemd service file for the OSDF.
This will require creating the environment file in the directory `/opt/origin/.env`.

!!! note
    This example systemd file assumes `<HOST PARTITION>` is `/srv/origin-public`.

Create the systemd service file `/etc/systemd/system/docker.stash-origin.service` as follows:

```file
[Unit]
Description=Origin Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull opensciencegrid/stash-origin:release
ExecStart=/usr/bin/docker run --rm --name %n -p 1094:1094 -p 1095:1095 -v /srv/origin-public:/xcache/namespace --env-file /opt/origin/.env opensciencegrid/stash-origin:release

[Install] 
WantedBy=multi-user.target
```

Enable and start the service with:

```console
root@host $ systemctl enable docker.stash-origin
root@host $ systemctl start docker.stash-origin
```

!!! warning
    You must [register](install-origin.md#registering-the-origin) the origin before considering it a
    production service.



Validating Origin
-----------------

To validate the origin please follow the
[validating origin instructions](install-origin.md#verifying-the-origin-server).

Getting Help
------------

To get assistance, please use the [this page](../../common/help.md) or contact <help@opensciencegrid.org> directly.
