title: Running OSDF Origin in a Container
DateReviewed: 2022-12-16

Running OSDF Origin in a Container
========================================

The OSG operates the [Open Science Data Federation](overview.md) (OSDF), which
provides organizations with a method to distribute their data in a scalable manner to thousands of jobs without needing
to pre-stage data across sites or operate their own scalable infrastructure.

[Origins](install-origin.md) store copies of users' data.
Each community (or experiment) needs to run one origin to export its data via the federation.
This document outlines how to run such an origin in a Docker container.

!!! note
    The OSDF Origin was previously named "Stash Origin" and some documentation and software may use the old name.

Before Starting
---------------

Before starting the installation process, consider the following requirements:

1. **Docker:** For the purpose of this guide, the host must have a running docker service and you must have the ability
to start containers (i.e., belong to the `docker` Unix group).
1. **Network ports:** The origin listens for incoming HTTP(S) and XRootD connections on ports 1094 and/or 1095.
   1094 is used for serving public (unauthenticated) data, and 1095 is used for serving authenticated data.
1. **File Systems:** The origin needs a host partition to store user data.
1. **Hardware requirements:** We recommend that an origin has at least 1Gbps connectivity and 8GB of RAM.
1. **Host certificate:** Required for authentication.
  See our [host certificate documentation](../../security/host-certs.md) for instructions on how to request host certificates.
1. **Registration:** Before deploying an origin, you must
   [register the service](install-origin.md#registering-the-origin) in the OSG Topology

!!! note
    This document describes features introduced in XCache 3.2.2, released on 2022-09-29.
    You must use a version of the `opensciencegrid/stash-origin` image built after that date.

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

In addition, define the following variables to specify which subpaths should be served as public (unauthenticated) data
on port 1094, and which subpaths should be served as authenticated data on port 1095:

```file
XC_PUBLIC_ORIGIN_EXPORT=/<VO>/PUBLIC
XC_AUTH_ORIGIN_EXPORT=/<VO>/PROTECTED
```

These paths are relative to the host partition being served -- see the [Populating Origin Data](#populating-origin-data)
section below.

If you only define `XC_AUTH_ORIGIN_EXPORT`, you will only serve data on port 1095.
If you only define `XC_PUBLIC_ORIGIN_EXPORT`, you will only serve data on port 1094.
If you do not define either, you will serve the entire host partition as public data on port 1094.

!!! note
    For backward compatibility, `XC_ORIGINEXPORT` is accepted as an alias for `XC_PUBLIC_ORIGIN_EXPORT`.

### Providing a host certificate

The service will need a certificate for contacting central OSDF services and for authenticating connections.

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
    If you are running an origin image based on OSG 23 or newer, and your situation includes any of the following:
    
    -   Your origin's host certificate was signed by a SHA1-signed-CA
    -   You are expecting connections from clients or caches that authenticate themselves
        with a cert from a SHA1-signed-CA
    
    then you must add `ENABLE_SHA1=yes` to the environment variable file.


Populating Origin Data
----------------------

The OSDF namespace is shared by multiple VOs so you must
[choose a namespace](vo-data.md#choosing-namespaces) for your own VO's data.
When running an origin container, your chosen namespace must be reflected in your host partition.

For example, if your host partition is `/srv/origin` and the name of your VO is `ASTRO`,
you should store the Astro VO's public data in `/srv/origin/astro/PUBLIC`,
and protected data in `/srv/origin/astro/PROTECTED`.

When starting the container, mount `/srv/origin/` into `/xcache/namespace` in the container,
and set the environment variables `XC_PUBLIC_ORIGIN_EXPORT=/astro/PUBLIC` and `XC_AUTH_ORIGIN_EXPORT=/astro/PROTECTED`.

You may omit `XC_AUTH_ORIGIN_EXPORT` if you are only serving public data,
or omit `XC_PUBLIC_ORIGIN_EXPORT` if you are only serving protected data.
If you omit both, the entire `/srv/origin` partition will be served as public data.


Running the Origin
------------------

It is recommended to use a container orchestration service such as [docker-compose](https://docs.docker.com/compose/)
or [kubernetes](https://kubernetes.io/) whose details are beyond the scope of this document.
The following sections provide examples for starting origin containers from the command-line as well as a more
production-appropriate method using systemd.

```console
user@host $ docker run --rm --publish 1094:1094 --publish 1095:1095 \
             --volume <HOST PARTITION>:/xcache/namespace \
             --volume <HOST CERT>:/etc/grid-security/hostcert.pem \
             --volume <HOST KEY>:/etc/grid-security/hostkey.pem \
             --env-file=/opt/origin/.env \
             opensciencegrid/stash-origin:23-release
```

Replacing `<HOST PARTITION>` with the host directory containing data that your origin should serve.
See [this section](#populating-origin-data) for details.

!!! warning
    Unless configured otherwise via the env file `/opt/origin/.env`,
    a container deployed this way will serve the entire contents of `<HOST PARTITION>`.
    See the [Configuring the Origin](#configuring-the-origin) section for information on how to
    serve one subpath as public and another as protected.

!!! note
    You may omit `--publish 1094:1094` if you are only serving authenticated data,
    or omit `--publish 1095:1095` if you are only serving public data.

### Running on origin container with systemd

An example systemd service file for the OSDF.
This will require creating the environment file in the directory `/opt/origin/.env`.

!!! note
    This example systemd file assumes `<HOST PARTITION>` is `/srv/origin`,
    and the cert and key to use are in `/etc/ssl/host.crt` and `/etc/ssl/host.key`,
    respectively.

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
ExecStartPre=/usr/bin/docker pull opensciencegrid/stash-origin:23-release
ExecStart=/usr/bin/docker run --rm --name %n \
  --publish 1094:1094 \
  --publish 1095:1095 \
  --volume /srv/origin:/xcache/namespace \
  --volume /etc/ssl/host.crt:/etc/grid-security/hostcert.pem \
  --volume /etc/ssl/host.key:/etc/grid-security/hostkey.pem \
  --env-file /opt/origin/.env \
  opensciencegrid/stash-origin:23-release

[Install]
WantedBy=multi-user.target
```

Enable and start the service with:

```console
root@host $ systemctl enable docker.stash-origin
root@host $ systemctl start docker.stash-origin
```

!!! warning
    Unless configured otherwise via the env file `/opt/origin/.env`,
    a container deployed this way will serve the entire contents of `/srv/origin`.
    See the [Configuring the Origin](#configuring-the-origin) section for information on how to
    serve one subpath as public and another as protected.

!!! note
    You may omit `--publish 1094:1094` if you are only serving authenticated data,
    or omit `--publish 1095:1095` if you are only serving public data.

!!! warning
    You must [register](install-origin.md#registering-the-origin) the origin before starting it up.



Validating the Origin
---------------------

To validate the origin please follow the
[validating origin instructions](install-origin.md#verifying-the-origin-server).

Getting Help
------------

To get assistance, please use the [this page](../../common/help.md).
