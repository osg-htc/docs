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
-   [A working XRootD Server](install-xrootd).
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

| Service Name | Protocol | Port Number | Inbound | Outbound | Comment |
|--------------|----------|-------------|---------|----------|---------|
| GRAM callback | tcp | `GLOBUS_TCP_PORT_RANGE` | Y |   | contiguous range of ports |
| GRAM callback | tcp | `GLOBUS_TCP_SOURCE_RANGE` |   | Y | contiguous range of ports |
| GridFTP | tcp | 2811 and `GLOBUS_TCP_SOURCE_RANGE` | Y |   | contiguous range of ports |

Engineering Considerations 
--------------------------------------------------------------------

The GridFTP server provides high-performance, secure and reliable data transfer. This guide is primarily intended for installations that require one [BeStMan](install-bestman-xrootd.md) endpoint but multiple GridFTP servers for scalability. Multiple GridFTP instances on different servers are recommended if:

-   You have a BeStMan-gateway/Xrootd SE (Storage Element) serving data to more than 250 cores for VOs that use storage heavily (e.g. CMS, ATLAS, CDF, and D0)
-   Your storage will be managing more than 50 TB of disk space
-   You have a BeStMan-gateway/Xrootd SE with more than 1Gbps bandwidth: plan on at least one GridFTP server for each 4Gbps of available bandwidth (assuming you have 10Gbps interfaces on the server) if you want to maximize throughput.

Install Instructions
=========================

Note that this package is primarily intended for GridFTP acting as an interface for XRootD server, usually part of a bigger storage element installation. If you have not installed an XRootD server yet, [please do so](install-xrootd).

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

For information on how to configure authentication for your GridFTP installation, please refer to the [configuring authentication section of the GridFTP guide](gridftp#configuring-authentication).

Configuring GridFTP XRootD support 
----------------------------------------------------------------------------

### (Optional) Enabling GridFTP server for a BeStMan SE

If this installation is part of a greater SE deployment, you will probably want to add this server to your existing BeStMan installation.

In `/etc/bestman2/conf/bestman2.rc`, you will need to modify the `supportedProtocolList` line, such as

``` file
supportedProtocolList=gsiftp://gridftp.server.tld;gsiftp://gridftp2.server.tld;gsiftp://gridftp3.server.tld
```

Configuring xrootdfs
--------------------

You can use a FUSE mount in order to test POSIX access to xrootd in the GridFTP server. Configure it using the following steps.

Modify **`/etc/fstab`** by adding the following entries:

    :::file
    ....
    xrootdfs                %RED%/mnt/xrootd%ENDCOLOR%              fuse    rdr=xroot://%RED%redirector1.domain.com%ENDCOLOR%:1094/%RED%/path/%ENDCOLOR%,uid=xrootd 0 0


Replace `/mnt/xrootd` with the path that you would like to access with. This should also match the GridFTP settings for the `XROOTD_VMP` local path. Create **`/mnt/xrootd`** directory. Once you are finished, you can mount it:

    :::file
    mount /mnt/xrootd

You should now be able to run UNIX commands such as `ls /mnt/xrootd` to see the contents of the XRootD server.

### (Optional) Configuring secured xrootdfs

If you want to enable security for access to xrootd via xrootdfs you will need to modify xrootd configuration and perform several steps to make xrootdfs secured.

1. On the xrootd redirector node, execute the following command:

        :::console
        root@host # xrdsssadmin -k %RED%<my_key_name>%ENDCOLOR% -u anybody -g usrgroup add %RED%<keyfile>%ENDCOLOR%

        eg:

        root@host # xrdsssadmin -k top_secret -u anybody -g usrgroup add /etc/xrootd/xrootd.key

2. Set ownership

        :::console
        root@host # chown xrootd.xrootd /etc/xrootd/xrootd.key

3. On the node where xrootdfs is installed modify **`/etc/fstab`** add security information:

        :::console
        root@host # xrootdfs %RED%/mnt/xrootd %ENDCOLOR" fuse rdr=xroot://%RED%redirector1.domain.com%ENDCOLOR%:1094/%RED%/path/redirector1%ENDCOLOR%,uid=xrootd,sss=%RED%keyfile%ENDCOLOR%0 0

4. On all xrootd data servers and redirector node, modify xrootd configuration (**`/etc/xrootd/xrootd-clustered.cfg`**) by adding the following segment:

        :::file
        # ENABLE_SECURITY_BEGIN
           xrootd.seclib /usr/lib64/libXrdSec.so
           #the line below should be before "sec.protocol ... unix"
           %RED%sec.protocol /usr/lib64 sss -s keyfile %ENDCOLOR%
           sec.protocol /usr/lib64 unix
           # this specify that we use the 'unix' authentication module, additional one can be specified.
           # this is the authorization file
           acc.authdb /etc/xrootd/auth_file
           ofs.authorize
           # ENABLE_SECURITY_END

5. On all xrootd data server nodes, edit /etc/xrootd/auth\_file to add authorized users of the form `u %RED%username%ENDCOLOR% %RED%/directoryname%ENDCOLOR% lr` where "lr" is the permission set.

6. Copy %RED%keyfile<span class="twiki-macro ENDCOLOR"></span> from redirector node to every data server node and the xrootdfs node. Make sure that this file is owned by the `xrootd` user.

7. Restart xrootd cluster by following [these instructions](install-xrootd)
8. On xroodfs node execute mount:

        :::console
        root@host # mount %RED%/mnt/xrootd%ENDCOLOR%

9. Verify that you can access the mount point (df,ls) and can not write into unauthorized path, e.g:

        :::console
        root@host # cp /bin/sh /mnt/xrootd/tlevshin/test1 cp:
        cannot create regular file \`/mnt/xrootd/tlevshin/test1': Permission denied

    Login as yourself and try:

        :::console
        root@host # su - tlevshin
        user@host $ cp /bin/sh /mnt/xrootd/tlevshin/test1

Services
=======

| Software    | Service name                           | Notes                                                                 |
|:------------|:--------------------------------------|:----------------------------------------------------------------------|
| fetch-crl   | `fetch-crl-boot` and `fetch-crl-cron` | See  [CA documentation](../common/ca/#startstop-fetch-crl-a-quick-guide) |
| Gridftp     | `globus-gridftp-server`               | See [gridftp documentation](../data/gridftp/#managing-gridftp)        |

As a reminder, here are common service commands (all run as `root`):

| To …                                        | Run the command …                     |
|:--------------------------------------------|:--------------------------------------|
| Start a service                             | `service %RED%<SERVICE-NAME>%ENDCOLOR% start` |
| Stop a service                              | `service %RED%<SERVICE-NAME>%ENDCOLOR% stop`  |
| Enable a service to start during boot       | `chkconfig %RED%<SERVICE-NAME>%ENDCOLOR% on`  |
| Disable a service from starting during boot | `chkconfig %RED%<SERVICE-NAME>%ENDCOLOR% off` |


File Locations
===================

| Service/Process | Configuration File | Description |
|-----------------|--------------------|-------------|
| GridFTP | /etc/sysconfig/globus-gridftp-server | Environment variables for GridFTP and LCMAPS |
| | /usr/share/osg/sysconfig/globus-gridftp-server-plugin | Where environment variables for GridFTP plugin are included |
| Gratia Probe | /etc/gratia/xrootd-storage/ProbeConfig | GridFTP Xrootd Storage Probe configuration |
| | /etc/gratia/xrootd-transfer/ProbeConfig | GridFTP Xrootd Transfer Probe configuration |

| Service/Process | Log File | Description              |
|-----------------|----------|--------------------------|
| GridFTP | /var/log/gridftp.log | GridFTP transfer log |
| | /var/log/gridftp-auth.log | GridFTP authorization log |
| Gratia probe | /var/logs/gratia | |

How to get Help?
=====================

For a full set of help options, see [Help Procedure](../common/help.md).
