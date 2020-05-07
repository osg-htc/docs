Running Stash Origin in a Container
===================================

The OSG operates the [StashCache data federation](/data/stashcache/overview), which
provides organizations with a method to distribute their data in a scalable manner to thousands of jobs without needing
to pre-stage data across sites or operate their own scalable infrastructure.

[Stash Origins](/data/stashcache/install-origin) store copies of users' data. Each community (or experiment) needs to run one origin to export its data via the StashCache federation.
This document outlines how to run such an origin in a Docker container.

Before Starting
---------------

Before starting the installation process, consider the following points:

1. **Docker:** For the purpose of this guide, the host must have a running docker service and you must have the ability to start containers (i.e., belong to the `docker` Unix group).
1. **Network ports:** The Stash Origin listens for incoming HTTP/S and XRootD connections on ports 1094 and 1095 (by default).
1. **File Systems:** Stash Origin needs a partition on the host to store user data.

Configuring Stash Origin
------------------------

In addition to the required configuration above (ports and file systems), you may also configure the behavior of your cache with the following variables using an enviroment variable file:

Where the environment file on the docker host, `/opt/origin/.env`, has (at least)the following contents:
```file
XC_ORIGINEXPORT=/origin
XC_RESOURCENAME = YOUR_SITE_NAME
```

### Creating an Auth file ###

XrootD needs an authentication file [(AuthFile)](/data/xrootd/xrootd-authorization/) to control access to different parts of the namespace in your origin. You can create a simple authfile named `/opt/origin/auth_file` as follows:

```file
u * /origin rl
```

Create a configuration file for XrootD to find your authfile. Create a file `/opt/origin/10-origin-authfile.cfg`:

```
set StashOriginPublicAuthfile = /etc/xrootd/public-origin-authfile
```


### Disabling OSG monitoring ###

By default, XCache reports to the OSG so that OSG staff can monitor the health of data federations.
If you would like to report monitoring information to another destination, you can disable the OSG monitoring by setting
the following in your environment variable configuration:

```file
DISABLE_OSG_MONITORING = true
```

!!! warning
    Do not disable OSG monitoring in any service that is to be used for any other than testing

Running an Origin
-----------------

To run the container, use docker run with the following options, replacing the text within angle brackets with your own values:

```console
user@host $ docker run --rm --publish 1094:1094 \
	     --publish 1095:1095 \
             --volume <HOST PARTITION>:/origin \
             --volume /opt/origin/10-origin-authfile.cfg:/etc/xrootd/config.d/10-origin-authfile.cfg \
             --volume /opt/origin/auth_file:/etc/xrootd/public-origin-authfile \
             --env-file=/opt/origin/.env \
             opensciencegrid/stash-origin:stable
```

It is recommended to use a container orchestration service such as [docker-compose](https://docs.docker.com/compose/) or [kubernetes](https://kubernetes.io/), or start the stash origin container with systemd.

### Running Stashcache on container with systemd

An example systemd service file for StashCache.
This will require creating the environment file in the directory `/opt/xcache/.env`. 

!!! note
    This example systemd file assumes `<HOST PARTITION>` is `/srv/origin`.

```file
[Unit]
Description=StashOrigin Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull opensciencegrid/stash-origin:stable
ExecStart=/usr/bin/docker run --rm --name %n -p 1094:1094 -p 1095:1095 -v /srv/origin:/origin -v /opt/origin/10-origin-authfile.cfg:/etc/xrootd/config.d/10-origin-authfile.cfg -v /opt/origin/auth_file:/etc/xrootd/public-origin-authfile --env-file /opt/origin/.env opensciencegrid/stash-origin:stable

[Install] 
WantedBy=multi-user.target
```

This systemd file can be saved to `/etc/systemd/system/docker.stash-origin.service` and started with:

```console
root@host $ systemctl enable docker.stash-origin
root@host $ systemctl start docker.stash-origin
```

!!! warning
    You must [register](/data/stashcache/install-origin/#registering-the-origin) the cache before considering it a production service.



Validating Origin
-----------------

To validate the origin please follow the [validating-origin instructions](/data/stashcache/install-origin/#verifying-the-origin-server)

Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact <help@opensciencegrid.org> directly.
