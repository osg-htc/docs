Install Bestman XRootD SE
=========================

!!! warning
    As of the June 2017 release of OSG 3.4.0, this software is officially deprecated.  Support is scheduled to end as of May 2018.

About this Document
===================

This page explains how to install the BeStMan Storage Element with underlying XRootD storage.

Requirements
============

Host and OS
-----------

-   OS is Red Hat Enterprise Linux 6, 7, and variants (see [details...](../common/yum.md))
-   [EPEL](http://fedoraproject.org/wiki/EPEL) repos enabled.
-   A working XRootD Server. See [the XRootD install documentation](install-xrootd) for details.
-   Root access

Users
-----

This installation will create several users unless they are already created.

| User      | Comment                                                 |
|:----------|:--------------------------------------------------------|
| `bestman` | Used by Bestman SRM server (needs sudo access).         |
| `daemon`  | Used by globus-gridftp-server.                          |
| `xrootd`  | Used by the XRootD client to contact XRootD redirector. |

For this package to function correctly, you will have to create the users needed for grid operation. Any user that can be authenticated should be created.

For grid-mapfile users, each line of the grid-mapfile is a certificate/user pair. Each user in this file should be created on the server.

For gums users, this means that each user that can be authenticated by gums should be created on the server.

Note that these users must be kept in sync with the authentication method. For instance, if new users or rules are added in gums, then new users should also be added here.

Certificates
------------

| Certificate                 | User that owns certificate | Path to certificate                                                                                 |
|:----------------------------|:---------------------------|:----------------------------------------------------------------------------------------------------|
| Host certificate            | `root`                     | `/etc/grid-security/hostcert.pem` `/etc/grid-security/hostkey.pem`                       |
| Bestman service certificate | `bestman`                  | `/etc/grid-security/bestman/bestmancert.pem` `/etc/grid-security/bestman/bestmankey.pem` |

[Instructions](../security/host-certs.md) to request a service certificate.

You will also need a copy of CA certificates (see below).

Networking
----------

| Service Name            | Protocol    | Port Number                      | Inbound | Outbound |Commen                     |
|:------------------------|:------------|:---------------------------------|:--------|:---------|:--------------------------|
| GridFTP                 | tcp         |2811 and `GLOBUS_TCP_SOURCE_RANGE`| YES     |          | contiguous range of ports |
| Storage Resource Manager| tcp		|  8443                            | YES     |          |                           |


Install Instructions
=-===================

Note that this package is primarily intended for Bestman-Gateway acting as an endpoint for XRootD server. If you have not installed an XRootD server yet, follow the instructions in [the XRootD install documentation](install-xrootd).



Certificates
------------

GridFTP, which is a part of this meta-package, requires a certificate package to run. If you require a specific certificate package, follow the [InstallCertAuth](../common/ca.md) instructions to install it. If you do not install a grid certificate package first, the install procedure will install one for you as part of its dependencies. (usually osg-ca-certs).

Package installation instructions
---------------------------------

1.  Install Java using [these instructions](../common/openjdk7#installing-java)
2.  Install the BeStMan Gateway XRootD Storage element meta-package:

        :::console
        root@host # yum install osg-se-bestman-xrootd

Configuring GridFTP authentication
----------------------------------

For information on how to configure authentication for your GridFTP installation, please refer to the [configuring authentication section of the GridFTP guide](../data/gridftp/#configuring-gridftp).

Configuring GridFTP XRootD support
----------------------------------

 In order to configure GridFTP to work with XRootD, you will need to configure the Data Storage Interface (DSI) module with XRootD pre-load libraries. This module is used to access XRootD and POSIX file systems.

Edit `/etc/sysconfig/xrootd-dsi` (create it if it is missing) and set XROOTD\_VMP (XRootD Virtual Mount Point) to use your XRootD redirector.

    :::file
    export XROOTD_VMP="%RED%redirector:1094:/local_path=/remote_path%ENDCOLOR%"

!!! note
    The syntax of the above environment variable is a little confusing, so make sure that you adhere to the following directions for XROOTD_VMP (Virtual Mount Point):

        - Redirector: This is the hostname and domain of the local XRootD redirector server.
        - local_path: This is the path used to access the GridFTP server (ie this server).
        - remote_path: This is the path used to access the XRootD redirector.

!!! note
    The xrootd-dsi module overloads the `gridftp.conf` file and uses the alternate file `/etc/xrootd-dsi/gridftp-xrootd.conf`. If you have made local changes to your `gridftp.conf` file, then you will need to carry them over to `/etc/xrootd-dsi/gridftp-xrootd.conf`.

Configuring xrootdfs
--------------------

Though the DSI module will work for GridFTP, you will need a FUSE mount in order for BeStMan to work correctly with XRootD. Configure it using the following steps.

Modify **`/etc/fstab`** by adding the following entries:

    :::file
    ....
    xrootdfs                %RED%/mnt/xrootd%ENDCOLOR%              fuse    rdr=xroot://%RED%redirector1.domain.com%ENDCOLOR%:1094/%RED%/path/%ENDCOLOR%,uid=xrootd 0 0


Replace `/mnt/xrootd` with the path that you would like to access with BeStMan. This should also match the GridFTP settings for the `XROOTD_VMP` local path. Create **`/mnt/xrootd`** directory. Once you are finished, you can mount it:

    :::file
    mount /mnt/xrootd

You should now be able to run UNIX commands such as `ls /mnt/xrootd` to see the contents of the XRootD server.

### (Optional) Configuring secured xrootdfs

If you want to enable security for access to XRootD via xrootdfs you will need to modify XRootD configuration and perform several steps to make xrootdfs secured.

1. On the XRootD redirector node, execute the following command:

        :::console
        root@host # xrdsssadmin -k %RED%<my_key_name>%ENDCOLOR% -u anybody -g usrgroup add %RED%<keyfile>%ENDCOLOR%

        eg:

        root@host # xrdsssadmin -k top_secret -u anybody -g usrgroup add /etc/xrootd/xrootd.key

2. Set ownership

        :::console
        root@host # chown xrootd.xrootd /etc/xrootd/xrootd.key

3. On the node where xrootdfs is installed modify **`/etc/fstab`** add security information:

        :::console
        root@host # xrootdfs %RED%/mnt/xrootd %ENDCOLOR" fuse rdr=xroot://%RED%redirector1.domain.com%ENDCOLOR%:1094/%RED%/path/redirector1%ENDCOLOR%,uid=xrootd,sss=%RED%keyfile%ENDCOLOR% 0 0

4. On all XRootD data servers and redirector node, modify XRootD configuration (**`/etc/xrootd/xrootd-clustered.cfg`**) by adding the following segment: 

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

5. On all XRootD data server nodes, edit /etc/xrootd/auth\_file to add authorized users of the form `u %RED%username%ENDCOLOR% %RED%/directoryname%ENDCOLOR% lr` where "lr" is the permission set.

6. Copy %RED%keyfile<span class="twiki-macro ENDCOLOR"></span> from redirector node to every data server node and the xrootdfs node. Make sure that this file is owned by the `xrootd` user.

7. Restart XRootD cluster by following [these instructions](install-xrootd)
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

Edit Bestman Settings
---------------------

See [Edit Bestman Settings](../data/bestman-install/#edit-bestman-settings)

Modify `/etc/sudoers`
---------------------

See [Bestman Instructions](../data/bestman-install/#modify-etcsudoers)

### (Optional) Copying certificates to a bestman location

See [Bestman Instructions](../data/bestman-install/#copying-certificates-to-an-alternate-location)


Validation
==========

Validation can be done similar to a stand-alone BeStMan or GridFTP server. For more information, see [BeStMan Validation](../data/bestman-install/#validation-of-service-operation) and [GridFTP Validation](../data/gridftp/#validating-gridftp).

Services
=======

| Software    | Service name                           | Notes                                                                 |
|:------------|:--------------------------------------|:----------------------------------------------------------------------|
| fetch-crl   | `fetch-crl-boot` and `fetch-crl-cron` | See  [CA documentation](../common/ca/#startstop-fetch-crl-a-quick-guide) |
| Gridftp     | `globus-gridftp-server`               |                                                                       |
| BestMan     | `bestman2`                            | See [Bestman Services](../data/bestman-install/#starting-services)    |
|Gratia probes| `gratia-xrootd-transfer` and `gratia-xrootd-storage`|                                                         |

As a reminder, here are common service commands (all run as `root`):

| To …                                        | Run the command …                     |
|:--------------------------------------------|:--------------------------------------|
| Start a service                             | `service %RED%<SERVICE-NAME>%ENDCOLOR% start` |
| Stop a service                              | `service %RED%<SERVICE-NAME>%ENDCOLOR% stop`  |
| Enable a service to start during boot       | `chkconfig %RED%<SERVICE-NAME>%ENDCOLOR% on`  |
| Disable a service from starting during boot | `chkconfig %RED%<SERVICE-NAME>%ENDCOLOR% off` |


Notes on Upgrading Bestman
=========================

See [Upgrading Bestman](../data/bestman-install/#upgrading-bestman)

How to get Help?
================

If you cannot resolve the problem, there are several ways to receive help:

-   For bug support and issues, submit a ticket to the [Grid Operations Center](https://ticket.opensciencegrid.org/goc).

For a full set of help options, see [Help Procedure](../common/help.md).

