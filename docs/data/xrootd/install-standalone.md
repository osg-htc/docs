DateReviewed: 2021-11-12

Install XRootD Standalone
=========================

!!!bug "EL7 version compatibility"
    There is an incompatibility with EL7 < 7.5 due to an issue with the `globus-gsi-proxy-core` package


[XRootD](http://xrootd.org/) is a hierarchical storage system that can be used in many ways to access data,
typically distributed among actual storage resources.
In its standalone configuration, XRootD acts as a simple layer exporting data from a storage system to the outside world.

This document focuses on installing a default configuration of XRootD standalone that provides the following features:

- Supports any POSIX-based storage system
- Macaroons, X.509 proxy, and VOMS proxy authentication
- Third-Party Copy over HTTP (HTTP-TPC)

Before Starting
---------------

Before starting the installation process, consider the following points:

-   **User IDs:** If it does not exist already, the installation will create the Linux user ID `xrootd`
-   **Service certificate:** The XRootD service uses a host certificate and key pair at
    `/etc/grid-security/xrd/xrdcert.pem` and `/etc/grid-security/xrd/xrdkey.pem` that must be owned by the `xrootd` user
-   **Networking:** The XRootD service uses port 1094 by default

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

-   Ensure the host has [a supported operating system](../../release/supported_platforms.md)
-   Obtain root access to the host
-   Prepare [the required Yum repositories](../../common/yum.md)
-   Install [CA certificates](../../common/ca.md)

Installing XRootD
-----------------

!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes, contact your VO(s) to verify that they support HTTP-based data transfer
    before replacing your GridFTP service with XRootD.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](../../release/notes.md).

    Note that OSG 3.5 will reach its end-of-life in [February 2022](../../release/release_series.md#series-overviews).

!!! bug "VOMS attribute mappings incompatible with `xrootd-multiuser` in OSG 3.6"
    The OSG 3.6 configuration of XRootD uses the `XrdVoms` plugin, which pass along the entire VOMS FQAN as the
    groupname to the authorization layer (see the section on
    [authorization database file formatting](xrootd-authorization.md#formatting)).
    Some characters in VOMS FQANs are not legal in Unix usernames, therefore VOMS attributes mappings are incompatible
    with `xrootd-multiuser`.
    See [XRootD GitHub issue #1538](https://github.com/xrootd/xrootd/issues/1538) for more details.

To install an XRootD Standalone server, run one of the following commands based on your installed
[OSG release series](../../release/release_series.md#series-overviews):

-   OSG 3.6 (recommended):

        :::console
        root@xrootd-standalone # yum install osg-xrootd-standalone

-   OSG 3.5

        :::console
        root@xrootd-standalone # yum install osg-xrootd-standalone \
                                             --enablerepo=osg-upcoming

Configuring XRootD
------------------

To configure XRootD as a standalone server, you will modify `/etc/xrootd/xrootd-standalone.cfg` and the config files
under `/etc/xrootd/config.d/` as follows:

1.  Configure a `rootdir` in `/etc/xrootd/config.d/10-common-site-local.cfg`, to point to the top of the directory
    hierarchy which you wish to serve via XRootD.

        set rootdir = <DIRECTORY>

    !!! danger "Carefully consider your `rootdir`"
        Do not set `rootdir` to `/`.
        This might result in serving private information.

1.  If you want to limit the sub-directories to serve under your configured `rootdir`,
    comment out the `all.export /` directive in
    `/etc/xrootd/config.d/90-osg-standalone-paths.cfg`,
    and add an `all.export` directive for each directory under `rootdir` that you wish to serve via XRootD.
    
    This is useful if you have a mixture of files under your `rootdir`, for example from multiple users,
    but only want to expose a subset of them to the world.
    
    For example, to serve the contents of `/data/store` and `/data/public` (with `rootdir` configured to `/data`):

        all.export /store/
        all.export /public/

    If you want to serve everything under your configured `rootdir`, you don't have to change anything.

    !!! danger
        The directories specified this way are writable by default.
        Access controls should be managed via [authorization configuration](#configuring-authorization).

1. In `/etc/xrootd/config.d/10-common-site-local.cfg`, add a line to set the `resourcename` variable to the
   [resource name](../../common/registration.md#registering-resources) of your XRootD service or to a value matching
   your supported VOs policies.
   For example, the XRootD service registered at the
   [University of Florida site](https://github.com/opensciencegrid/topology/blob/b14218d6e9d9df013a42e4d8538b2eeea615514c/topology/University%20of%20Florida/UF%20HPC/UFlorida-HPC.yaml#L250)
   should set the following configuration:

        set resourcename = UFlorida-XRD

### Configuring authorization

To configure XRootD authorization please follow the documentation [here](xrootd-authorization.md).

### Optional configuration

The following configuration steps are optional and will likely not be required for setting up a small site.
If you do not need any of the following special configurations, skip to
[the section on using XRootD](#using-xrootd).

#### Enabling Hadoop support (deprecated, EL 7 Only)

!!! info "OSG 3.5 end-of-life"
    Hadoop is no longer supported in OSG 3.6 and OSG 3.5 will reach its end-of-life in
    [February 2022](../../release/release_series.md#series-overviews).

Hadoop File System (HDFS) based sites should utilize the `xrootd-hdfs` plugin to allow XRootD to access their storage:

1. Install the XRootD HDFS plugin package:

        :::console
        root@host # yum install xrootd-hdfs

1. Add the following configuration to `/etc/xrootd/xrootd-clustered.cfg`:

        :::file
        ofs.osslib /usr/lib64/libXrdHdfs.so

For more information, see [the HDFS installation documents](../install-hadoop.md).


#### Enabling multi-user support

!!! bug "VOMS attribute mappings incompatible with `xrootd-multiuser` in OSG 3.6"
    The OSG 3.6 configuration of XRootD uses the `XrdVoms` plugin, which pass along the entire VOMS FQAN as the
    groupname to the authorization layer (see the section on [authorization database file formatting](xrootd-authorization.md#formatting)).
    Some characters in VOMS FQANs are not legal in Unix usernames, therefore VOMS attributes mappings are incompatible
    with `xrootd-multiuser`.
    See [XRootD GitHub issue #1538](https://github.com/xrootd/xrootd/issues/1538) for more details.

The `xrootd-multiuser` plugin allows XRootD to write files on the storage system as the
[authenticated](xrootd-authorization.md) user instead of the `xrootd` user.
If your XRootD service only allows read-only access, you should skip installation of this plugin.

To set up XRootD in multi-user mode, perform the following steps, install the `xrootd-multiuser` package:

``` console
root@host # yum install xrootd-multiuser
```

#### Enabling CMS TFC support (CMS sites only)

!!! info "Coming soon to OSG 3.6"
    The `xrootd-cmstfc` package is not yet available in OSG 3.6.
    [See this ticket](https://opensciencegrid.atlassian.net/browse/SOFTWARE-4893) to track its progress.

For CMS sites, there is a package available to integrate rule-based name lookup using a `storage.xml` file.
If you are not setting up a service for CMS, skip this section.

``` console
yum install --enablerepo=osg-contrib xrootd-cmstfc
```

You will need to add your `storage.xml` to `/etc/xrootd/storage.xml` and then add the following line to your XRootD
configuration:

``` file
# Integrate with CMS TFC, placed in /etc/xrootd/storage.xml
oss.namelib /usr/lib64/libXrdCmsTfc.so file:/etc/xrootd/storage.xml?protocol=hadoop
```

Add the orange text only if you are running hadoop (see below).

See the CMS TWiki for more information:

-   <https://twiki.cern.ch/twiki/bin/view/Main/XrootdTfcChanges>
-   <https://twiki.cern.ch/twiki/bin/view/Main/HdfsXrootdInstall>

Using XRootD
------------

In addition to the XRootD service itself, there are a number of supporting services in your installation.
The specific services are:

| Software          | Service Name                          | Notes                                                                                                       |
|:------------------|:--------------------------------------|:------------------------------------------------------------------------------------------------------------|
| Fetch CRL         | `fetch-crl-boot` and `fetch-crl-cron` | See [CA documentation](../../common/ca.md#managing-fetch-crl-services) for more info                        |
| XRootD            | `xrootd@standalone`                   |                                                                                                             |
| XRootD Multi-user | `xrootd-privileged@standalone`        | If running in [multi-user](#enabling-multi-user-support), start this service instead of `xrootd@standalone` |

Start the services in the order listed and stop them in reverse order.
As a reminder, here are common service commands (all run as `root`):

| To …                                        | Run the command…                 |
|:--------------------------------------------|:---------------------------------|
| Start a service                             | `systemctl start SERVICE-NAME`   |
| Stop a service                              | `systemctl stop SERVICE-NAME`    |
| Enable a service to start during boot       | `systemctl enable SERVICE-NAME`  |
| Disable a service from starting during boot | `systemctl disable SERVICE-NAME` |

Validating XRootD
-----------------

To validate an XRootD installation, perform the following verification steps:

!!! note
    If you have configured authentication/authorization for XRootD,
    be sure you have given yourself the necessary permissions to run these tests.
    For example, if you are using an X.509 proxy,
    make sure your DN is mapped to a user in [/etc/grid-security/grid-mapfile](../../security/lcmaps-voms-authentication.md#mapping-users),
    make sure you have a valid proxy on your local machine,
    and ensure that the [Authfile](xrootd-authorization.md#authorization-database) on the XRootD server gives
    write access to the mapped user from `/etc/grid-security/grid-mapfile`.

1. Verify [authorization](xrootd-authorization.md#verifying-xrootd-authorization) of bearer tokens and/or proxies

1.  Verify HTTP-TPC using the same GFAL2 client tools:

    !!! bug "Requires gfal2 >= 2.20.0"
        `gfal2-2.20.0` contains a fix for a bug affecting XRootD HTTP-TPC support.

    1.  Copy a file from your XRootD standalone host to another host and path where you have write access:

            :::console
            root@xrootd-standalone # gfal-copy davs://localhost:1094/<PATH TO LOCAL FILE> \
                                               <REMOTE HOST>/<PATH TO WRITE REMOTE FILE>

        Replacing `<PATH TO LOCAL FILE>` with the path to a file that you can read on your host relative to `rootdir`;
        `<REMOTE HOST>` with the protocol, FQDN, and port of the remote storage host;
        and `<PATH TO WRITE REMOTE FILE>` to a location on the remote storage host where you have write access.

    1.  Copy a file from a remote host where you have read access to your XRootD standalone installation:

            :::console
            root@xrootd-standalone # gfal-copy <REMOTE HOST>/<PATH TO REMOTE FILE> \
                                               davs://localhost:1094/<PATH TO WRITE LOCAL FILE>

        Replacing `<REMOTE HOST>` with the protocol, FQDN, and port of the remote storage host;
        `<PATH TO REMOTE FILE>` with the path to a file that you can read on the remote storage host;
        and `<PATH TO WRITE LOCAL FILE>` to a location on the XRootD standalone host relative to `rootdir` where you
        have write access.

Registering an XRootD Standalone Server
---------------------------------------

To register your XRootD server, follow the general registration instructions
[here](../../common/registration.md#new-resources) with the following XRootD-specific details:

1.  Add an `XRootD component:` section to the `Services:` list, with any relevant fields for that service.
    This is a partial example:

        :::console
        ...
        FQDN: <FULLY QUALIFIED DOMAIN NAME>
        Services:
          XRootD component:
            Description: Standalone XRootD server
        ...

    Replacing `<FULLY QUALIFIED DOMAIN NAME>` with your XRootD server's DNS entry.

2.  If you are setting up a new resource, set `Active: false`.
    Only set `Active: true` for a resource when it is accepting requests and ready for production.

Getting Help
------------

To get assistance. please use the [Help Procedure](../../common/help.md) page.

Reference
---------

- [XRootD documentation](https://xrootd.slac.stanford.edu/docs.html)
- [Export directive](https://xrootd.slac.stanford.edu/doc/dev49/ofs_config.htm#_Toc522916544) in the XRootD
  configuration and [relevant options](https://xrootd.slac.stanford.edu/doc/dev49/ofs_config.htm#_defaults)


### Service Configuration

The configuration that your XRootD service uses is determined by the service name given to `systemctl`.
To use the standalone config, you would start XRootD with the following command:

``` console
root@host # systemctl start xrootd@standalone
```

### File locations

| Service/Process | Configuration File                  | Description               |
|:----------------|:------------------------------------|:--------------------------|
| `xrootd`        | `/etc/xrootd/xrootd-standalone.cfg` | Main XRootD configuration |
|                 | `/etc/xrootd/config.d/`             | Drop-in configuration dir |
|                 | `/etc/xrootd/auth_file`             | Authorized users file     |

| Service/Process          | Log File                                | Description                                 |
|:-------------------------|:----------------------------------------|:--------------------------------------------|
| `xrootd`                 | `/var/log/xrootd/server/xrootd.log`     | XRootD server daemon log                    |
| `cmsd`                   | `/var/log/xrootd/server/cmsd.log`       | Cluster management log                      |
