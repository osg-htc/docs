!!!bug "EL7 version compatibility"
    There is an incompatibility with EL7 < 7.5 due to an issue with the xrootd-lcmaps package


Install XRootD Standalone
=========================

[XRootD](http://xrootd.org/) is a hierarchical storage system that can be used in a variety of ways to access data,
typically distributed among actual storage resources. In this document we focus on using XRootD as a simple layer
exporting an underlying storage system (e.g., [HDFS](/data/install-hadoop.md)) to the outside world.

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

To configure XRootD as a standalone server, replace the contents of `/etc/xrootd/xrootd-standalone.cfg` as follows:

1.  Add an `all.export` directive for each directory that you wish to serve via XRootD.
    For example, to serve the contents of `/store` and `/public`:

        all.export /store/
        all.export /public/

    !!! note
        The directories specified this way are writable by default.
        Access controls should be managed via [authorization configuration](#configuring-authorization).

1. Add an `all.sitename` directive set to the [resource name](/common/registration/#registering-resources) of your
   XRootD service.
   For example, the XRootD service registered at the
   [FermiGrid site](https://github.com/opensciencegrid/topology/blob/master/topology/Fermi%20National%20Accelerator%20Laboratory/FermiGrid/FNAL_PUBLIC_DCACHE.yaml#L6)
   should set the following configuration:

        all.sitename   Fermilab Public DCache

    !!! note
        CMS sites should follow CMS policy for `all.sitename`

1.  Append the following configuration to the end of `/etc/xrootd/xrootd-standalone.cfg`

        xrd.port 1094
        all.role server

        cms.allow host *
        # Logging verbosity
        xrootd.trace emsg login stall redirect
        ofs.trace -all
        xrd.trace conn
        cms.trace all

        xrd.report xrd-report.osgstorage.org:9931
        xrootd.monitor all \
                       auth \
                       flush 30s \
                       window 5s fstat 60 lfn ops xfr 5 \
                       dest redir fstat info user xrd-report.osgstorage.org:9930 \
                       dest fstat info user xrd-mon.osgstorage.org:9930

        xrd.network keepalive kaparms 10m,1m,5
        xrd.timeout idle 60m

1.  On EL 6, set the default options to use the standalone configuration in the `/etc/sysconfig/xrootd` file.

        XROOTD_DEFAULT_OPTIONS="-l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-standalone.cfg -k fifo"

### Configuring authorization

To configure XRootD authorization please follow the documentation [here](/data/xrootd/xrootd-authorization).

### Optional configuration

The following configuration steps are optional and will likely not be required for setting up a small site.
If you do not need any of the following special configurations, skip to
[the section on using XRootD](#using-xrootd).

#### Enabling HTTP support

In order to enable XRootD HTTP support please follow the instructions
[here](/data/xrootd/install-storage-element#optional-enabling-xrootd-over-http)

#### Enabling Hadoop support (EL 7 Only)

For documentation on how to export your Hadoop storage using XRootD please see
[this documentation](/data/xrootd/install-storage-element#optional-adding-hadoop-support-to-xrootd)

#### Enabling CMS TFC support (CMS sites only)

For CMS users, there is a package available to integrate rule-based name lookup using a `storage.xml` file.
See [this documentation](/data/xrootd/install-storage-element#optional-adding-cms-tfc-support-to-xrootd-cms-sites-only).

Using XRootD
------------

In addition to the XRootD service itself, there are a number of supporting services in your installation.
The specific services are:

| Software  | Service Name                            | Notes                                                                        |
|:----------|:----------------------------------------|:-----------------------------------------------------------------------------|
| Fetch CRL | `fetch-crl-boot` and `fetch-crl-cron`   | See [CA documentation](/common/ca#managing-fetch-crl-services) for more info |
| XRootD    | EL 7:`xrootd@standalone`, EL 6:`xrootd` |                                                                              |

Start the services in the order listed and stop them in reverse order.
As a reminder, here are common service commands (all run as `root`):

| To …                                        | On EL 7, run the command…        | On EL 6, run the command…    |
|:--------------------------------------------|:---------------------------------|:-----------------------------|
| Start a service                             | `systemctl start SERVICE-NAME`   | `service SERVICE-NAME start` |
| Stop a service                              | `systemctl stop SERVICE-NAME`    | `service SERVICE-NAME stop`  |
| Enable a service to start during boot       | `systemctl enable SERVICE-NAME`  | `chkconfig SERVICE-NAME on`  |
| Disable a service from starting during boot | `systemctl disable SERVICE-NAME` | `chkconfig SERVICE-NAME off` |

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


### Service Configuration

On EL 6, which config to use is set in the file `/etc/sysconfig/xrootd`.

To use the standalone config, you would use:

``` file
XROOTD_DEFAULT_OPTIONS="-l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-%RED%standalone%ENDCOLOR%.cfg -k fifo"
```

On EL 7, which config to use is determined by the service name given to `systemctl`.
To use the standalone config, you would use:

``` console
root@host # systemctl start xrootd@%RED%standalone%ENDCOLOR%
```

### File locations

| Service/Process | Configuration File                  | Description               |
|:----------------|:------------------------------------|:--------------------------|
| `xrootd`        | `/etc/xrootd/xrootd-standalone.cfg` | Main XRootD configuration |
|                 | `/etc/xrootd/auth_file`             | Authorized users file     |

| Service/Process          | Log File                                | Description                                 |
|:-------------------------|:----------------------------------------|:--------------------------------------------|
| `xrootd`                 | `/var/log/xrootd/server/xrootd.log`     | XRootD server daemon log                    |
| `cmsd`                   | `/var/log/xrootd/server/cmsd.log`       | Cluster management log                      |

