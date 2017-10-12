Install Xrootd Grid FTP
============================

For a full storage element, visit [InstallBestmanXrootdSE](install-bestman-xrootd.md). However, bigger sites (tier-2, etc) may require multiple GridFTP to be load balanced under a single BeStMan Gateway SRM interface. This page aims to explain how to install such a GridFTP server.

This package could also be used to install a stand-alone GridFTP server on top of XRootD servers, but most installations use this

Requirements
=================

Host and OS 
-----------------------------------------------------

-   OS is Red Hat Enterprise Linux 6, 7, and variants (see [details...](../release/supported_platforms.md)).
-   [EPEL](http://fedoraproject.org/wiki/EPEL) repos enabled.
-   A working XRootD Server. See [InstallXrootd](install-xrootd) for details.
-   Root access

Users 
-----------------------------------------------

This installation will create several users unless they are already created.

| User | Comment |
|------|---------|
| `daemon` | Used by globus-gridftp-server. |
| `xrootd` | Used by the xrootd client to contact xrootd redirector. |

Certificates 
------------------------------------------------------

| Certificate | User that owns certificate | Path to certificate |
|-------------|----------------------------|---------------------|
| Host certificate | `root` | `/etc/grid-security/hostcert.pem`, `/etc/grid-security/hostkey.pem` |

[Instructions](../security/host-certs.md) to request a service certificate. You will also need a copy of CA certificates (see below).

Networking 
----------------------------------------------------

For more details on overall Firewall configuration, please see our <a href="/bin/view/Documentation/Release3/FirewallInformation" class="twikiLink">Firewall documentation</a>.

| Service Name | Protocol | Port Number | Inbound | Outbound | Comment |
|--------------|----------|-------------|---------|----------|---------|
| GRAM callback | tcp | `GLOBUS_TCP_PORT_RANGE` | <img src="/twiki/pub/TWiki/TWikiDocGraphics/choice-yes.gif" title="Y" alt="Y" width="16" height="16" /> |   | contiguous range of ports |
| GRAM callback | tcp | `GLOBUS_TCP_SOURCE_RANGE` |   | <img src="/twiki/pub/TWiki/TWikiDocGraphics/choice-yes.gif" title="Y" alt="Y" width="16" height="16" /> | contiguous range of ports |
| GridFTP | tcp | 2811 and `GLOBUS_TCP_SOURCE_RANGE` | <img src="/twiki/pub/TWiki/TWikiDocGraphics/choice-yes.gif" title="Y" alt="Y" width="16" height="16" /> |   | contiguous range of ports |

Engineering Considerations 
--------------------------------------------------------------------

The GridFTP server provides high-performance, secure and reliable data transfer. This guide is primarily intended for installations that require one [BeStMan](install-bestman-xrootd.md) endpoint but multiple GridFTP servers for scalability. Multiple GridFTP instances on different servers are recommended if:

-   You have a BeStMan-gateway/Xrootd SE (Storage Element) serving data to more than 250 cores for VOs that use storage heavily (e.g. CMS, ATLAS, CDF, and D0)
-   Your storage will be managing more than 50 TB of disk space
-   You have a BeStMan-gateway/Xrootd SE with more than 1Gbps bandwidth: plan on at least one GridFTP server for each 4Gbps of available bandwidth (assuming you have 10Gbps interfaces on the server) if you want to maximize throughput.

Install Instructions
=========================

Note that this package is primarily intended for GridFTP acting as an interface for XRootD server, usually part of a bigger storage element installation. If you have not installed an XRootD server yet, follow the instructions in [InstallXrootd](install-xrootd).

Certificates 
------------------------------------------------------

GridFTP, which is a part of this meta-package, requires a certificate package to run. If you require a specific certificate package, follow the [InstallCertAuth](../common/ca.md) instructions to install it. If you do not install a grid certificate package first, the install procedure will install one for you as part of its dependencies. (usually osg-ca-certs).

Package installation instructions 
---------------------------------------------------------------------------

First, you will need to install the XRootD GridFTP meta-package.

``` console
root@host # yum install osg-gridftp-xrootd
```

Configuring GridFTP authentication support 
------------------------------------------------------------------------------------

For information on how to configure authentication for your GridFTP installation, please refer to the <a href="/bin/view/Documentation/Release3/InstallOSGGridFTP#ConfiguringAuthentication" class="twikiAnchorLink">configuring authentication section of the GridFTP guide</a>.

Configuring GridFTP XRootD support 
----------------------------------------------------------------------------

### (Optional) Enabling GridFTP server for a BeStMan SE

If this installation is part of a greater SE deployment, you will probably want to add this server to your existing BeStMan installation.

In `/etc/bestman2/conf/bestman2.rc`, you will need to modify the `supportedProtocolList` line, such as

``` file
supportedProtocolList=gsiftp://gridftp.server.tld;gsiftp://gridftp2.server.tld;gsiftp://gridftp3.server.tld
```

Configuring xrootdfs 
--------------------------------------------------------------

(Optional) Configuring secured xrootdfs 
---------------------------------------------------------------------------------

Configure Xrootd Gratia Probes 
------------------------------------------------------------------------

Note that you can also enable the GridFTP gratia probe. However, the XRootD probes are likely sufficient. More information on the GridFTP probe can be found here: <a href="/bin/view/Documentation/Release3/InstallOSGGridFTP#6_0_Gratia_GridFTP_Transfer_Prob" class="twikiAnchorLink">InstallOSGGridFTP#6_0_Gratia_GridFTP_Transfer_Prob</a>

Starting Services 
-----------------------------------------------------------

1. fetch-crl

2. GridFTP

Starting GridFTP:

``` console
root@host # service globus-gridftp-server start
```

To start Gridftp automatically at boot time

``` console
root@host # chkconfig globus-gridftp-server on
```

3. Gratia transfer and storage probes

Stopping Services 
-----------------------------------------------------------

1. fetch-crl

\* (other grid service running on the machine may still use it)

\* (other grid service running on the machine may still use it)

2. GridFTP

Stopping GridFTP:

``` console
root@host # service globus-gridftp-server stop
```

3. Gratia transfer and storage probes

File Locations
===================

| Service/Process | Configuration File | Description |
|-----------------|--------------------|-------------|
| GridFTP | /etc/sysconfig/globus-gridftp-server | Environment variables for GridFTP and LCMAPS |
| | /usr/share/osg/sysconfig/globus-gridftp-server-plugin | Where environment variables for GridFTP plugin are included |
| Gratia Probe | /etc/gratia/xrootd-storage/ProbeConfig | GridFTP Xrootd Storage Probe configuration |
| | /etc/gratia/xrootd-transfer/ProbeConfig | GridFTP Xrootd Transfer Probe configuration |

[Service/Process](/bin/view/Documentation/Release3/InstallGridFtpXrootd?sortcol=0;table=5;up=0#sorted_table "Sort by this column")

[Log File](/bin/view/Documentation/Release3/InstallGridFtpXrootd?sortcol=1;table=5;up=0#sorted_table "Sort by this column")

[Description](/bin/view/Documentation/Release3/InstallGridFtpXrootd?sortcol=2;table=5;up=0#sorted_table "Sort by this column")

GridFTP

/var/log/gridftp.log

GridFTP transfer log

/var/log/gridftp-auth.log

GridFTP authorization log

Gratia probe

/var/logs/gratia

How to get Help?
=====================

If you cannot resolve the problem, there are several ways to receive help:

-   For bug support and issues, submit a ticket to the [Grid Operations Center](https://ticket.grid.iu.edu/goc).
-   For community support and best-effort software team support contact <osg-software@opensciencegrid.org.>

For a full set of help options, see [Help Procedure](../common/help.md).
