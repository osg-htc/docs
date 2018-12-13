Install XRootD Standalone
=========================

[XRootD](http://xrootd.org/) is a hierarchical storage system that can be used in a variety of ways to access data,
typically distributed among actual storage resources. In this document we focus on using XRootD as a simple layer
exporting an underlying storage system (e.g., [HDFS](/data/install-hadoop.md)) to the outside world.

!!! note
    The OSG only supports XRootD standalone installations on EL7 hosts

Before Starting
---------------

Before starting the installation process, consider the following points:

-   **User IDs:** If it does not exist already, the installation will create the Linux user ID `xrootd`
-   **Service certificate:** The XRootD service uses a host certificate and key pair at
    `/etc/grid-security/xrd/xrdcert.pem` and `/etc/grid-security/xrd/xrdkey.pem`
-   **Networking:** The XRootD service uses port 1094 by default

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

-   Ensure the host has [a supported operating system](/release/supported_platforms)
-   Obtain root access to the host
-   Prepare [the required Yum repositories](/common/yum)
-   Install [CA certificates](/common/ca)

Installing XRootD
-----------------

To install XRootD, run the following Yum command:

``` console
root@xrootd-standalone # yum install xrootd
```

Configuring XRootD
------------------

You will need to modify the file `/etc/xrootd/xrootd-standalone.cfg` that we will refer now on (unless explicitly said) as THE configuration file.
A simple example of such a configuration is below with further customizations in the rest of the document.

``` file
# Allow all contents of /store to be served from this host
all.export %RED%/store/%ENDCOLOR% readonly
# This site name is only used for monitoring purposes (ex: T2_US_UCSD or UCSD)
all.sitename   %RED%YOUR SITE NAME%ENDCOLOR%

xrd.port 1094
all.role server

cms.allow host *
# Logging verbosity
xrootd.trace emsg login stall redirect
ofs.trace -all
xrd.trace conn
cms.trace all

all.adminpath /var/run/xrootd
all.pidpath   /var/run/xrootd

xrd.report     xrootd.t2.ucsd.edu:9931,desire.physics.ucsd.edu:9931 every 30s all sync
xrootd.monitor all auth flush io 60s ident 5m mbuff 8k rbuff 4k rnums 3 window 10s dest files io info user redir xrootd.t2.ucsd.edu:9930 dest files iov info user xrootd.t2.ucsd.edu:9932

xrd.network keepalive kaparms 10m,1m,5
xrd.timeout idle 60m
```

Notice the following:

1. The directory `/store` is the one your users will interact "see" from this xrootd gateway. Other control options can be added like "writable" see [documentation here](http://xrootd.org/doc/dev48/ofs_config.htm) (look for `export`).
1. The sitename has only implications for monitoring, so should match whatever is registered (if) on [Topology](/common/registration/). 

### Configuring authorization

To configure XRootD authorization please follow the documentation [here](/data/xrootd/xrootd-authorization).

### Optional configuration

The following configuration steps are optional and will likely not be required for setting up a small site.
If you do not need any of the following special configurations, skip to
[the section on using XRootD](#using-xrootd).

#### Enabling HTTP support

In order to enable XRootD HTTP support please follow the instructions
[here](/data/install-xrootd/#optional-enabling-xrootd-over-http)

#### Enabling Hadoop support

For documentation on how to export your Hadoop storage using XRootD please see
[this documentation](/data/install-xrootd/#optional-adding-hadoop-support-to-xrootd)

#### Enabling CMS TFC support (CMS sites only)

For CMS users, there is a package available to integrate rule-based name lookup using a `storage.xml` file.
See [this documentation](/data/install-xrootd/#optional-adding-cms-tfc-support-to-xrootd-cms-sites-only).

Using XRootD
------------

In addition to the XRootD service itself, there are a number of supporting services in your installation.
The specific services are:

| Software  | Service Name                          | Notes                                                                        |
|:----------|:--------------------------------------|:-----------------------------------------------------------------------------|
| Fetch CRL | `fetch-crl-boot` and `fetch-crl-cron` | See [CA documentation](/common/ca#managing-fetch-crl-services) for more info |
| XRootD    | `xrootd@standalone`                   |                                                                              |

Start the services in the order listed and stop them in reverse order.
As a reminder, here are common service commands (all run as `root`):

| To …                                        | On EL 7, run the command…        |
|:--------------------------------------------|:---------------------------------|
| Start a service                             | `systemctl start SERVICE-NAME`   |
| Stop a service                              | `systemctl start SERVICE-NAME`   |
| Enable a service to start during boot       | `systemctl enable SERVICE-NAME`  |
| Disable a service from starting during boot | `systemctl disable SERVICE-NAME` |

Validating XRootD
-----------------

To validate an XRootD installation, perform the following verification steps:

1. Verify file transfer over the XRootD protocol using XRootD client tools:

    1. Install the client tools:

            :::console
            root@xrootd-standalone # yum install xrootd-client

    1. Copy a file to a directory for which you have write access:

            :::console
            root@xrootd-standalone # xrdcp /bin/sh root://localhost:1094//tmp/first_test
            [xrootd] Total 0.76 MB  [====================] 100.00 % [inf MB/s]

    1. Verify that the file has been copied over:

            :::console
            root@xrootd-standalone # ls -l /tmp/first_test
            -rw-r--r-- 1 xrootd xrootd 801512 Apr 11 10:48 /tmp/first_test

1. If you have enabled [HTTP support](#enabling-http-support), verify file transfer over HTTP using GFAL2 client
   tools:

    1. Install the GFAL2 client tools:

            :::console
            root@xrootd-standalone # yum install gfal2-util gfal2-plugin-http

    1. Copy a file to a directory for which you have write access:

            :::console
            root@xrootd-standalone # gfal-copy /bin/sh http://localhost:1094//tmp/first_test

    1. Verify that the file has been copied over:

            :::console
            root@xrootd-standalone # ls -l /tmp/first_test
            -rw-r--r-- 1 xrootd xrootd 801512 Apr 11 10:48 /tmp/first_test

Getting Help
------------

To get assistance. please use the [Help Procedure](/common/help/) page.

Reference
---------

- [XRootD documentation](http://xrootd.slac.stanford.edu/doc)
- [Export directive](http://xrootd.org/doc/dev48/ofs_config.htm#_Toc401930729) in the XRootD configuration and
  [relevant options](http://xrootd.org/doc/dev48/ofs_config.htm#_Toc401930728)


### File locations

| Service/Process | Configuration File                  | Description               |
|:----------------|:------------------------------------|:--------------------------|
| `xrootd`        | `/etc/xrootd/xrootd-standalone.cfg` | Main XRootD configuration |
|                 | `/etc/xrootd/auth_file`             | Authorized users file     |

| Service/Process          | Log File                                | Description                                 |
|:-------------------------|:----------------------------------------|:--------------------------------------------|
| `xrootd`                 | `/var/log/xrootd/server/xrootd.log`     | XRootD server daemon log                    |
| `cmsd`                   | `/var/log/xrootd/server/cmsd.log`       | Cluster management log                      |

