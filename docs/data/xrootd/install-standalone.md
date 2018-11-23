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
root@xrootd-server # yum install xrootd
```

Configuring XRootD
------------------

You will need to modify the file `/etc/xrootd/xrootd-server.cfg` that we will refer now on (unless explicitly said) as THE configuration file.
A simple example of such a configuration is below with further customizations in the rest of the document.

``` file
xrd.port 1094
all.role server
# Allow all contents of /store to be served from this host
all.export %RED%/store/ global %ENDCOLOR% readonly

cms.allow host *
# Logging verbosity
xrootd.trace emsg login stall redirect
ofs.trace -all
xrd.trace conn
cms.trace all

all.adminpath /var/run/xrootd
all.pidpath   /var/run/xrootd
# This site name is only used for monitoring purposes (ex: T2_US_UCSD or UCSD)
all.sitename   %RED%YOUR SITE NAME%ENDCOLOR%

xrd.report     xrootd.t2.ucsd.edu:9931,desire.physics.ucsd.edu:9931 every 30s all sync
xrootd.monitor all auth flush io 60s ident 5m mbuff 8k rbuff 4k rnums 3 window 10s dest files io info user redir xrootd.t2.ucsd.edu:9930 dest files iov info user xrootd.t2.ucsd.edu:9932

xrd.network keepalive kaparms 10m,1m,5
xrd.timeout idle 60m
```

#### (Optional) Enable HTTP support

In order to enable XRootD HTTP support please follow the instructions
[here](/data/install-xrootd/#optional-enabling-xrootd-over-http)

#### (Optional) Adding Hadoop support to XRootD

For documentation on how to export your Hadoop storage using XRootD please see
[this documentation](/data/install-xrootd/#optional-adding-hadoop-support-to-xrootd)

#### (Optional) Adding CMS TFC support to XRootD (CMS sites only)

For CMS users, there is a package available to integrate rule-based name lookup using a `storage.xml` file.
See [this documentation](/data/install-xrootd/#optional-adding-cms-tfc-support-to-xrootd-cms-sites-only).

### Authorization file

For the authorization options on XRootD please see [here](/data/install-xrootd/#optional-authorization)

An example of an authorization file for read only of store by CMS would be:

```file
g /cms /store lr
```

#### LCMAPS authorization

To configure the LCMAPS authentication please follow the documentation
[here](/data/install-xrootd/#security-option-3-xrootd-lcmaps-authorization)

Using XRootD
------------
In order to start your XRootD server you need to run

``` console
root@host # systemctl start xrootd@%RED%server%ENDCOLOR%
```

As a reminder, here are common service commands (all run as `root`):

| To …                                        | On EL 6, run the command…    | On EL 7, run the command…        |
|:--------------------------------------------|:-----------------------------|:---------------------------------|
| Start a service                             | `service SERVICE-NAME start` | `systemctl start SERVICE-NAME`   |
| Stop a service                              | `service SERVICE-NAME stop`  | `systemctl start SERVICE-NAME`   |
| Enable a service to start during boot       | `chkconfig SERVICE-NAME on`  | `systemctl enable SERVICE-NAME`  |
| Disable a service from starting during boot | `chkconfig SERVICE-NAME off` | `systemctl disable SERVICE-NAME` |

Testing XRootD
--------------

### Basic XRootD Test

To perform a basic test of XRootD you can use:

``` console
root@host # yum install xrootd-client
root@host # xrdcp /bin/sh root://localhost:1094//tmp/first_test
[xrootd] Total 0.76 MB  [====================] 100.00 % [inf MB/s]
root@host # ls -l /tmp/first_test
-rw-r--r-- 1 xrootd xrootd 801512 Apr 11 10:48 /tmp/first_test
```

#### (Optional) Testing XRootD over HTTP

To perform a test of the HTTP connectivity try:

``` console
root@host # yum install gfal2*
root@host # gfal-copy /bin/sh http://localhost:1094//tmp/first_test
root@host # ls -l /tmp/first_test
-rw-r--r-- 1 xrootd xrootd 801512 Apr 11 10:48 /tmp/first_test
```

Getting Help
------------

To get assistance. please use the [Help Procedure](../common/help/) page.

Reference
---------

[XRootD documentation](http://xrootd.slac.stanford.edu/doc)

### File locations

| Service/Process | Configuration File                 | Description                              |
|:----------------|:-----------------------------------|:-----------------------------------------|
| `xrootd`        | `/etc/xrootd/xrootd-server.cfg` | Main clustered mode XRootD configuration |
|                 | `/etc/xrootd/auth_file`            | Authorized users file                    |

| Service/Process          | Log File                                | Description                                 |
|:-------------------------|:----------------------------------------|:--------------------------------------------|
| `xrootd`                 | `/var/log/xrootd/server/xrootd.log`     | XRootD server daemon log                    |
| `cmsd`                   | `/var/log/xrootd/server/cmsd.log`       | Cluster management log                      |

