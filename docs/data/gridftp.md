Installing and Maintaining a GridFTP Server
===========================================

About This Guide
----------------

This page explains how to install the stand-alone Globus GridFTP server which is an extension of the File Transfer Protocol (FTP) for grid computing.
The aim of GridFTP is to provide a more reliable and high performance file transfer.

The `osg-gridftp` package contains components necessary to set up a stand-alone GridFTP server and tools used to monitor and report its performance.
A stand-alone GridFTP server might be used under the following circumstances:

-   You are serving VOs that use storage heavily (CMS, ATLAS, CDF, and D0) and your site has more than 250 cores
-   Your site will be managing more than 50 TB of disk space
-   You want a simple front-end to a filesystem allowing access over WAN - for example NFS.

!!! note
    This document is for a standalone GridFTP server on top of POSIX storage.  We have two specialized documents
    for Hadoop Distributed File System (HDFS) and XRootD based storage:

    -   [Install and configure a GridFTP server on top of HDFS.](install-hadoop#standalone-gridftp-node-installation)
    -   [Install and configure a GridFTP server on top of XRootD.](/data/xrootd/install-storage-element#optional-installing-a-gridftp-server)

Before Starting
---------------

Before starting the installation process you will need to fulfill these prerequisites.


-   Ensure the host has [a supported operating system](/release/supported_platforms.md)
-   Obtain root access to the host
-   Prepare [the required Yum repositories](/common/yum.md)
-   Install [CA certificates](/common/ca.md)
-   SSL Certificate: The GridFTP service uses a host certificate at `/etc/grid-security/hostcert.pem` and an accompanying key at `/etc/grid-security/hostkey.pem`
-   Network ports: GridFTP listens on TCP port 2811 and the list of ports configured by the `GLOBUS_TCP_SOURCE_RANGE` environment variable.

Installing GridFTP
------------------

First, you will need to install the GridFTP meta-package:

```console
root@host # yum install osg-gridftp
```

Configuring GridFTP
-------------------

### Configuring authentication

To configure which virtual organizations and users are allowed to use your GridFTP server, follow the instructions in
[the LCMAPS VOMS plugin document](/security/lcmaps-voms-authentication#configuring-the-lcmaps-voms-plugin).

### Set port ranges
As mentioned above, GridFTP uses port 2811 for control communication as well as a range of ports for the data transfer.
This range of ports has to defined by setting the variable `GLOBUS_TCP_PORT_RANGE` within the configuration file:
`/etc/sysconfig/globus-gridftp-server` as it is shown in the next example.
This range has to be open within your firewall for inbound communication.

    :::file
    $GLOBUS_TCP_PORT_RANGE 50000,51000


Starting the service
------------------
Once you have finished configuring the service and have set the port range, it is time to start the service.

for CentOS 7:

```console
systemctl start globus-gridftp-server
```

for CentOS 6:
```console
service globus-gridftp-server start
```

Validating GridFTP
------------------

The GridFTP service can be validated by using `globus-url-copy`, you can get this tool by installing the package
```globus-gass-copy-progs```

You will need to run `grid-proxy-init` or `voms-proxy-init` in order to get a valid user proxy in order to get
authenticated in the GridFTP server.
Make sure that the your proxy has a VO extension of a VO that is allowed in the GridFTP Server, i.e. it is listed
in the file `/usr/share/osg/voms-mapfile-default` and it has a unix account on the server.

```console
voms-proxy-init -voms cms
```
Having created a valid proxy, the result of the following command should be to have the file "zero.source", which
exists on /tmp in the machine where you are executing the command into the GridFTP server on /tmp/zero

```console
root@host # globus-url-copy file:///tmp/zero.source gsiftp://yourhost.yourdomain/tmp/zero
root@host # echo $?
0
```

To verify that the authentication is working, we could remove our proxy `voms-proxy-destroy` and execute the same
command again, this time it should fail. Keep in mind that when invoked as root, `globus-url-copy` will attempt to use
the host certificate instead of your user certificate, which could produce confusing results.



Monitoring
-------------------

### Enabling GridFTP transfer probe

The OSG monitoring of GridFTP is carried out by the GridFTP Gratia Probe which is installed by the package:
`gratia-probe-gridftp-transfer`
Assuming you installed GridFTP using the `osg-gridftp` or `osg-se-hadoop-gridftp` rpm, this package will
already be installed.

Here are the most relevant file and directory locations:

| Purpose             | Needs Editing? | Location                                 |
|---------------------|----------------|------------------------------------------|
| Probe Configuration | Yes            | /etc/gratia/gridftp-transfer/ProbeConfig |
| Probe Executables   | No             | /usr/share/gratia/gridftp-transfer       |
| Log files           | No             | /var/log/gratia                          |
| Temporary files     | No             | /var/lib/gratia/tmp                      |

The RPM installs the Gratia probe into the system crontab, but does not configure it. The configuration of the probe is controlled by the file

    /etc/gratia/gridftp-transfer/ProbeConfig

This is usually one XML node spread over multiple lines. Note that comments (\#) have no effect on this file. You will need to edit the following:

| Attribute                       | Needs Editing                                                                              | Value                                                                                                                                      |
|---------------------------------|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| ProbeName                       | Maybe                                                                                      | This should be set to "gridftp-transfer:`<HOSTNAME>`", where `<HOSTNAME>` is the fully-qualified domain name of your gridftp host. |
| CollectorHost                   | Maybe                                                                                      | Set to the hostname and port of the central collector. By default it sends to the OSG collector. See below.                                |
| SiteName                        | Yes                                                                                        | Set to the resource group name of your site as registered in OIM.                                                                          |
| GridftpLogDir                   | Yes                                                                                        | Set to /var/log, or wherever your current gridftp logs are located                                                                         |
| Grid                            | Maybe                                                                                      | Set to "ITB" if this is a test resource; otherwise, leave as OSG.                                                                          |
| UserVOMapFile                   | No                                                                                         | This should be set to /var/lib/osg/user-vo-map; see below for information about this file.                                                 |
| SuppressUnknownVORecords| Maybe | Set to 1 to suppress any records that can't be matched to a VO; 0 is strongly recommended. |
| SuppressNoDNRecords             | Maybe                                                                                      | Set to 1 to suppress records that can't be matched to a DN; 0 is strongly recommended.                                                     |
| EnableProbe                     | Yes                                                                                        | Set to 1 to enable the probe.                                                                                                              |

#### Selecting a collector host ####

The collector is the central server which logs the GridFTP transfers into a database. There are usually two options:

1. **OSG Transfer Collector**: This is the primary collector for transfers in the OSG. Use `CollectorHost="gratia-osg-prod.opensciencegrid.org:80"`.
1. **OSG-ITB Transfer Collector**: This is the test collector for transfers in the OSG. Use `CollectorHost=" gratia-osg-itb.opensciencegrid.org:80"`.

### Starting the service
Once the configuration file is edited, as described above, we will proceed to start the service.

for CentOS 7:

```console
systemctl start gratia-probes-cron
```

for CentOS 6:
```console
service gratia-probes-cron start
```

### Validation

Run the Gratia probe once by hand to check for functionality:

``` console
root@host # /usr/share/gratia/gridftp-transfer/gridftp-transfer_meter
```

Look for any abnormal termination and report it if it is a non-trivial site issue. Look in the log files in `/var/log/gratia/<date>.log` and make sure there are no error messages printed.

Optional configuration
-------------------


#### Setting transfer limits for GridFTP-HDFS

To set a limit on the total or per-user number of transfers, create `/etc/sysconfig/gridftp-hdfs` and set the following configuration:

    :::file hl_lines="3"
    export GRIDFTP_TRANSFER_LIMIT="80"
    export GRIDFTP_DEFAULT_USER_TRANSFER_LIMIT="50"
    export GRIDFTP_<UNIX USERNAME>_USER_TRANSFER_LIMIT="40"

In the above configuration:

- There would be no more than 80 transfers going at a time, across all users.
- By default, any single user can have no more than 50 transfers at a time.
- The `<UNIX USERNAME>` user has a more stringent limit of 40 transfers at a time.


!!!note
    This limits are per gridftp server. If you have several gridftp servers you may want to have this limits divided by the number of gridftp servers at your site.

#### Modifying the environment

Environment variables are stored in `/etc/sysconfig/globus-gridftp-server` which is sourced on service startup.  If you want to change LCMAPS log levels, or GridFTP port ranges, you can edit them there.

```shell
#Uncomment and modify for firewalls
#export GLOBUS_TCP_PORT_RANGE=min,max
#export GLOBUS_TCP_SOURCE_RANGE=min,max
```

Note that the variables `GLOBUS_TCP_PORT_RANGE` and `GLOBUS_TCP_SOURCE_RANGE` can be set here to allow GridFTP to navigate around firewall rules (these affect the inbound and outbound ports, respectively).

To troubleshoot LCMAPS authorization, you can add the following to `/etc/sysconfig/globus-gridftp-server` and choose a higher debug level:

``` file
# level 0: no messages, 1: errors, 2: also warnings, 3: also notices,
#  4: also info, 5: maximum debug
LCMAPS_DEBUG_LEVEL=2
```

Output goes to `/var/log/messages` by default. Do not set logging to 5 on any production systems as that may cause systems to slow down significantly or become unresponsive.

#### Configuring a multi-homed server

The GridFTP uses control connections, data connections and IPC connections. By default it listens in all interfaces but this can be changed by editing the configuration file `/etc/gridftp.conf`.

To use a single interface you can set `hostname` to the Hostname or IP address to use:

```text
hostname IP-TO-USE
```

You can also set separately the `control_interface`, `data_interface` and `ipc_interface`.  On systems that have multiple network interfaces, you may want to associate data transfers with the fastest possible NIC available. This can be done in the GridFTP server by setting `data_interface`:

```text
control_interface IP-TO-USE
data_interface IP-TO-USE
ipc_interface IP-TO-USE
```

For more options available for the GridFTP server, read the comments in the configuration file (`/etc/gridftp.conf`) or
see the [GridFTP manual](https://gridcf.org/gct-docs/latest/gridftp/admin/index.html).

Managing GridFTP
----------------

In addition to the GridFTP service itself, there are a number of supporting services in your installation. The specific services are:

| Software  | Service name                          | Notes                                                                                  |
|:----------|:--------------------------------------|:---------------------------------------------------------------------------------------|
| Fetch CRL | `fetch-crl-boot` and `fetch-crl-cron` | See [CA documentation](/common/ca/#startstop-fetch-crl-a-quick-guide) for more info |
| Gratia    | `gratia-probes-cron`                  | Accounting software                                                                    |
| GridFTP   | `globus-gridftp-server`               |                                                                                        |


Getting Help
------------

For assistance, please use [this page](/common/help).

Reference
---------

-   [GridFTP administration manual](https://gridcf.org/gct-docs/latest/gridftp/admin/index.html)
-   [GridFTP tutorial](http://www.mcs.anl.gov/~mlink/tutorials/GridFTPTutorialHandout.pdf)

### Configuration and Log Files

| Service/Process | Configuration File                                      | Description                                                 |
|:----------------|:--------------------------------------------------------|:------------------------------------------------------------|
| GridFTP         | `/etc/sysconfig/globus-gridftp-server`                  | Environment variables for GridFTP and LCMAPS                |
|                 | `/usr/share/osg/sysconfig/globus-gridftp-server-plugin` | Where environment variables for GridFTP plugin are included |
| Gratia Probe    | `/etc/gratia/gridftp-transfer/ProbeConfig`              | GridFTP Gratia Probe configuration                          |
| Gratia Probe    | `/etc/cron.d/gratia-probe-gridftp-transfer.cron`        | Cron tab file                                               |

| Service/Process | Log File                    | Description               |
|:----------------|:----------------------------|:--------------------------|
| GridFTP         | `/var/log/gridftp.log`      | GridFTP transfer log      |
|                 | `/var/log/gridftp-auth.log` | GridFTP authorization log |
| Gratia probe    | `/var/logs/gratia`          |                           |

### Certificates

| Certificate      | User that owns certificate | Path to certificate                                                           |
|:-----------------|:---------------------------|:------------------------------------------------------------------------------|
| Host certificate | `root`                     | `/etc/grid-security/hostcert.pem` and `/etc/grid-security/hostkey.pem` |

[Instructions](/security/host-certs.md) to request a service certificate.

Make sure you have installed the [CA certificates](/common/ca.md)

### Users

For this package to function correctly, you will have to create the users needed for grid operation. Any Unix username that can be mapped by LCMAPS VOMS should be created on the GridFTP host.

For example, VOs newly-added to the LCMAPS VOMS configuration will not be able to transfer files until the corresponding Unix user account is created.

### Networking

| Service Name            | Protocol | Port Number               | Inbound | Outbound | Comment                                 |
|:------------------------|:---------|:--------------------------|:--------|:---------|:----------------------------------------|
| GridFTP data channels   | tcp      | `GLOBUS_TCP_PORT_RANGE`   | X       |          | contiguous range of ports is necessary. |
| GridFTP data channels   | tcp      | `GLOBUS_TCP_SOURCE_RANGE` |         | X        | contiguous range of ports is necessary. |
| GridFTP control channel | tcp      | 2811                      | X       |          |                                         |
