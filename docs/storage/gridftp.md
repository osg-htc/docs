Install a GridFTP Server
========================

<span class="twiki-macro DOC_STATUS_TABLE"></span> <span class="twiki-macro TOC"></span>

—\# About this Document This page explains how to install the stand-alone Globus GridFTP server.

The GridFTP package contains components necessary to set up a stand-alone gsiftp server and tools used to monitor and report its performance. A stand-alone GridFTP server might be used under the following circumstances:

-   A simple front-end to a filesystem allowing access over WAN - for example NFS.
-   BeStMan is capable of distributing its workload among several gsiftp servers so if you expect large movements of data into/out of your site, multiple gsiftp servers can be set up.

—\# Requirements

—\#\# Host and OS

-   OS must be <span class="twiki-macro SUPPORTED_OS"></span>.
-   [EPEL](http://fedoraproject.org/wiki/EPEL) repos enabled.
-   Root access

—\#\# Certificates

<span class="twiki-macro STARTSECTION">Certificates</span>

| Certificate      | User that owns certificate | Path to certificate                                                       |
|:-----------------|:---------------------------|:--------------------------------------------------------------------------|
| Host certificate | `root`                     | `/etc/grid-security/hostcert.pem` \<br\> `/etc/grid-security/hostkey.pem` |

<span class="twiki-macro ENDSECTION">Certificates</span>

[Instructions](InstallCertScripts) to request a service certificate.

You will also need a copy of CA certificates (see below).

—\#\# Users

<span class="twiki-macro STARTSECTION">GridUsers</span> For this package to function correctly, you will have to create the users needed for grid operation. Any user that can be authenticated should be created.

For grid-mapfile users, each line of the grid-mapfile is a certificate/user pair. Each user in this file should be created on the server.

For gums users, this means that each user that can be authenticated by gums should be created on the server.

Note that these users must be kept in sync with the authentication method. For instance, if new users or rules are added in gums, then new users should also be added here. <span class="twiki-macro ENDSECTION">GridUsers</span>

—\#\# Networking

<span class="twiki-macro STARTSECTION">Firewalls</span> <span class="twiki-macro INCLUDE" section="FirewallTable" lines="gridftp,portrange,portsource">Documentation/Release3.FirewallInformation</span> \\ <span class="twiki-macro ENDSECTION">Firewalls</span>

If you have a multi-homed host you may be interested in reading [this section](#ConfigMultiHomed).

—\#\# Engineering Considerations

It is recommended that the GridFTP package be installed on its own server if:

-   You are serving the VOs that use storage heavily (CMS, ATLAS, CDF, and D0) and have more than 250 cores
-   Your site will be managing more than 50 TB of disk space

If you are planning to have a Storage Element with BeStMan and have more than 1Gbps bandwidth, then you should plan on at least one GridFTP server per 4Gbps of available bandwidth (assuming you have 10Gbps interfaces on the server) if you want to maximize throughput.

Also, you have to decide what authorization mechanism you prefer. You may use either grid-mapfile or a GUMS server for users’ authentication and authorization. We currently recommend using GUMS as it provides superior flexibility and allows a site to manage all of its mappings in one central location; most large sites use GUMS.

<span class="twiki-macro NOTE"></span> OSG does not support launching the GridFTP server with xinetd — only launching with init is supported.

—\# Install Instructions

<span class="twiki-macro INCLUDE" section="OSGRepoBrief" TOC_SHIFT="+">YumRepositories</span> <span class="twiki-macro INCLUDE" section="OSGBriefCaCerts" TOC_SHIFT="+">InstallCertAuth</span>

<span class="twiki-macro STARTSECTION">Full</span>

<span class="twiki-macro STARTSECTION">Install</span> GridFTP requires a certificate package to run. If you require a specific certificate package, follow the Documentation/Release3.InstallCertAuth instructions to install it. If you do not install a grid certificate package first, the install procedure will install one for you as part of its dependencies. (usually osg-ca-certs).

—\#\# Installing the GridFTP Server

First, you will need to install the GridFTP meta-package:

``` rootscreen
%UCL_PROMPT_ROOT% yum install osg-gridftp
```

<span class="twiki-macro ENDSECTION">Install</span>

—\# Configuration

—\#\# Authorization

<span class="twiki-macro STARTSECTION">Authorization</span> There are two authorization options:

-   Gridmap file
-   GUMS authentication server

Please choose one of these and follow the instructions in one of the two following sections.

—\#\#\# Configuring Gridmap Support

<span class="twiki-macro STARTSECTION">Gridmap</span> By default, GridFTP uses a gridmap file, found in `/etc/grid-security/grid-mapfile`. This file is not generated by default. There are two ways you can generate this file. You can generate this file manually, by including DN/username combinations. This is most useful for debugging. Otherwise, you can install edg-mkgridmap, which will periodically contact a list of VOMS servers that you specify. It assembles a list of users from those servers and creates a grid-mapfile. This grid-mapfile serves both as a list of authorized users and provides a mapping from user dns to local user ids.

To install edg\_mkgridmap, perform the following steps

``` rootscreen
yum install edg-mkgridmap
```

Review `/etc/edg-mkgridmap.conf` to make sure that it has all VOs that you are interested in and also to comment out any VOs that you do not wish to support.

``` rootscreen
vi /etc/edg-mkgridmap.conf
```

This utility `edg-mkgridmap` runs as a cronjob `/etc/cron.d/edg-mkgridmap-cron` (by default every 6 hours). You can also run `edg-mkgridmap` manually to see that it generates `/etc/grid-security/grid-mapfile`.

``` rootscreen
edg-mkgridmap
```

Then, you can enable/start the service.

``` rootscreen
/sbin/service edg-mkgridmap start
/sbin/chkconfig edg-mkgridmap on
```

You can read more on this page: [edg\_mkgridmap (on the CE)](Documentation/Release3.InstallComputeElement#5_2_Using_edg_mkgridmap_for_auth) <span class="twiki-macro ENDSECTION">Gridmap</span>

—\#\#\# Configuring GUMS support

<span class="twiki-macro STARTSECTION">Gums</span> By default, GridFTP uses a gridmap file, found in `/etc/grid-security/gridmap-file`. If you want to use GUMS security (recommended), you will need to enable it using the following steps:

First, edit `/etc/grid-security/gsi-authz.conf` and uncomment the globus callout.

``` file
globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout
```

Note that this used to be the full path to the library (`/usr/lib64` or `/usr/lib`), but now we rely on the linker for proper resolution in this file.

Next edit `/etc/lcmaps.db` to edit your gums information:

``` file
...
gumsclient = "lcmaps_gums_client.mod"
             "-resourcetype ce"
             "-actiontype execute-now"
             "-capath /etc/grid-security/certificates"
             "-cert   /etc/grid-security/hostcert.pem"
             "-key    /etc/grid-security/hostkey.pem"
             "--cert-owner root"
# Change this URL to your GUMS server
             "--endpoint https://%RED%gums.fnal.gov:8443%ENDCOLOR%/gums/services/GUMSXACMLAuthorizationServicePort"
```

If you would like to run SAZ, you will need to enable the relevant lines in the above file as well (more documentation to be added later). <span class="twiki-macro ENDSECTION">Gums</span>

<span class="twiki-macro ENDSECTION">Authorization</span>

—\#\# (Optional) Modifying the Environment

<span class="twiki-macro STARTSECTION">Environment</span> Environment variables are stored in `/etc/sysconfig/globus-gridftp-server` which is sourced on service startup. If you want to change LCMAPS log levels, or globus port ranges, you can edit them there.

``` file
#Uncomment and modify for firewalls
#export GLOBUS_TCP_PORT_RANGE=min,max
#export GLOBUS_TCP_SOURCE_RANGE=min,max
```

Note that the variables `GLOBUS_TCP_PORT_RANGE` and `GLOBUS_TCP_SOURCE_RANGE` can be set here to allow globus to navigate around firewall rules.

To troubleshoot LCMAPS authorization, you can add the following to `/etc/sysconfig/globus-gridftp-server` and choose a higher debug level:

``` file
# level 0: no messages, 1: errors, 2: also warnings, 3: also notices,
#  4: also info, 5: maximum debug
LCMAPS_DEBUG_LEVEL=2
```

Output goes to `/var/log/messages` by default. Do not set logging to 5 on any production systems as that may cause systems to slow down significantly or become unresponsive.

<span class="twiki-macro ENDSECTION">Environment</span>

\#ConfigMultiHomed —\#\# Configuring a multi-homed server

<span class="twiki-macro STARTSECTION">MultiHomed</span> The GridFTP uses control connections, data connections and IPC connections. By default it listens in all interfaces but this can be changed by editing the configuration file `/etc/gridftp.conf`.

To use a single interface you can set `hostname` to the Hostname or IP address to use:\<pre class=“file”\>hostname IP-TO-USE\</pre\> You can also set separately the `control_interface`, `data_interface` and `ipc_interface`. E.g. on systems that have multiple network interfaces, you may want to associate data transfers with the fastest possible NIC available. This can be done in the GridFTP server by setting `data_interface`: \<pre class=“file”\> control\_interface IP-TO-USE data\_interface IP-TO-USE ipc\_interface IP-TO-USE\</pre\> <span class="twiki-macro ENDSECTION">MultiHomed</span>

For more options available for the GridFTP server, read the comments in the configuration file (`/etc/gridftp.conf`) or see the [Globus manual](http://www.globus.org/toolkit/docs/latest-stable/gridftp/admin/#gridftp-configuring) mentioned in the [Reference](#DocReferences) section below.

—\# Starting GridFTP

<span class="twiki-macro STARTSECTION">Starting</span>

Starting GridFTP:

``` rootscreen
%UCL_PROMPT_ROOT% service globus-gridftp-server start
```

<span class="twiki-macro ENDSECTION">Starting</span> To start Gridftp automatically at boot time

``` rootscreen
%UCL_PROMPT_ROOT% chkconfig globus-gridftp-server on
```

—\# Stopping GridFTP <span class="twiki-macro STARTSECTION">Stopping</span> Stopping GridFTP:

``` rootscreen
%UCL_PROMPT_ROOT% service globus-gridftp-server stop
```

<span class="twiki-macro ENDSECTION">Stopping</span>

—\# Validation of services

<span class="twiki-macro STARTSECTION">Validation</span>

The GridFTP service can be validated by using globus-url-copy. You will need to run `grid-proxy-init` or `voms-proxy-init` in order to get a valid user proxy in order to communicate with the GridFTP server.

``` screen
%UCL_PROMPT% globus-url-copy file:///tmp/zero.source gsiftp://yourhost.yourdomain/tmp/zero
%UCL_PROMPT% echo $?
0
```

Note that you should preferably not try to run validation as root, as globus-url-copy will sometimes attempt to use the host certificate instead of your user certificate, with confusing results. <span class="twiki-macro ENDSECTION">Validation</span>

—\# Gratia GridFTP Transfer Probe The [Gratia GridFTP probe](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/GratiaTransferProbe) collects the information about the Gridftp transfers and forwards it to central Gratia collector. You need to enable the probe first. To do this, make sure following is set in file /etc/gratia/gridftp-transfer/ProbeConfig

``` file
EnableProbe="1"
```

All other configuration settings should be suitable for most purposes. However, you can edit them if needed. The probe runs every 30 minutes as a cron job.

—\# Useful Configuration and Log Files

<span class="twiki-macro STARTSECTION">Locations</span>

| Service/Process | Configuration File                                    | Description                                                 |
|:----------------|:------------------------------------------------------|:------------------------------------------------------------|
| GridFTP         | /etc/sysconfig/globus-gridftp-server                  | Environment variables for GridFTP and LCMAPS                |
|                 | /usr/share/osg/sysconfig/globus-gridftp-server-plugin | Where environment variables for GridFTP plugin are included |
| Gratia Probe    | /etc/gratia/gridftp-transfer/ProbeConfig              | GridFTP Gratia Probe configuration                          |
| Gratia Probe    | /etc/cron.d/gratia-probe-gridftp-transfer.cron        | Cron tab file                                               |

| Service/Process | Log File                  | Description               |
|:----------------|:--------------------------|:--------------------------|
| GridFTP         | /var/log/gridftp.log      | GridFTP transfer log      |
|                 | /var/log/gridftp-auth.log | GridFTP authorization log |
| Gratia probe    | /var/logs/gratia          |                           |

<span class="twiki-macro ENDSECTION">Locations</span>

<span class="twiki-macro ENDSECTION">Full</span>

—\# How to get Help?

If you cannot resolve the problem, there are several ways to receive help:

-   For bug support and issues, submit a ticket to the [Grid Operations Center](https://ticket.grid.iu.edu/goc).
-   For community support and best-effort software team support contact <osg-software@opensciencegrid.org>.

For a full set of help options, see [Help Procedure](HelpProcedure).

—\# Screen Dump of Install Procedure

<span class="twiki-macro TWISTY" mode="div" showlink="Click here for a full installation example." hidelink="Hide the example" showimgleft="%ICONURLPATH{toggleopen-small}%" hideimgleft="%ICONURLPATH{toggleclose-small}%"></span>

``` screen
[root@fermicloud108 ~]# wget http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
--2011-10-18 11:07:32--  http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
Resolving download.fedoraproject.org... 140.211.169.197, 152.19.134.146, 209.132.181.16, ...
Connecting to download.fedoraproject.org|140.211.169.197|:80... connected.
HTTP request sent, awaiting response... 302 FOUND
Location: http://kdeforge.unl.edu/mirrors/epel/5/i386/epel-release-5-4.noarch.rpm [following]
--2011-10-18 11:07:33--  http://kdeforge.unl.edu/mirrors/epel/5/i386/epel-release-5-4.noarch.rpm
Resolving kdeforge.unl.edu... 129.93.181.6
Connecting to kdeforge.unl.edu|129.93.181.6|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 12232 (12K) [application/x-rpm]
Saving to: `epel-release-5-4.noarch.rpm'

100%[==================================================================>] 12,232      --.-K/s   in 0.03s

2011-10-18 11:07:33 (349 KB/s) - `epel-release-5-4.noarch.rpm' saved [12232/12232]

[root@fermicloud108 ~]# rpm -i epel-release-5-4.noarch.rpm
warning: epel-release-5-4.noarch.rpm: Header V3 DSA signature: NOKEY, key ID 217521f6
[root@fermicloud108 ~]# yum -y install yum-priorities
Loaded plugins: kernel-module
epel                                                                                 | 3.7 kB     00:00
epel/primary_db                                                                      | 3.8 MB     00:02
fermi-base                                                                           | 2.1 kB     00:00
fermi-security                                                                       | 1.9 kB     00:00
fermi-security/primary_db                                                            | 1.7 MB     00:00
sl-base                                                                              | 2.1 kB     00:00
Setting up Install Process
Resolving Dependencies
--> Running transaction check
---> Package yum-priorities.noarch 0:1.1.16-14.el5 set to be updated
--> Finished Dependency Resolution
Beginning Kernel Module Plugin
Finished Kernel Module Plugin

Dependencies Resolved

============================================================================================================
 Package                      Arch                 Version                      Repository             Size
============================================================================================================
Installing:
 yum-priorities               noarch               1.1.16-14.el5                sl-base                14 k

Transaction Summary
============================================================================================================
Install       1 Package(s)
Upgrade       0 Package(s)

Total download size: 14 k
Downloading Packages:
yum-priorities-1.1.16-14.el5.noarch.rpm                                              |  14 kB     00:00
Running rpm_check_debug
Running Transaction Test
Finished Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing     : yum-priorities                                                                       1/1

Installed:
  yum-priorities.noarch 0:1.1.16-14.el5

Complete!
[root@fermicloud108 ~]# rpm -Uvh http://repo.grid.iu.edu/osg-release-latest.rpm
Retrieving http://repo.grid.iu.edu/osg-release-latest.rpm
warning: /var/tmp/rpm-xfer.tQF1ZU: Header V3 DSA signature: NOKEY, key ID 824b8603
Preparing...                ########################################### [100%]
   1:osg-release            ########################################### [100%]
[root@fermicloud108 ~]# yum --enablerepo=osg-testing install osg-gridftp
Loaded plugins: kernel-module, priorities
osg                                                                                  | 1.9 kB     00:00
osg/primary_db                                                                       |  65 kB     00:00
osg-testing                                                                          | 1.9 kB     00:00
osg-testing/primary_db                                                               | 319 kB     00:00
1232 packages excluded due to repository priority protections
Setting up Install Process
Resolving Dependencies
--> Running transaction check
---> Package osg-gridftp.x86_64 0:3.0.0-5 set to be updated
--> Processing Dependency: globus-gridftp-server-progs for package: osg-gridftp
--> Processing Dependency: gratia-probe-gridftp-transfer for package: osg-gridftp
--> Processing Dependency: vo-client for package: osg-gridftp
--> Processing Dependency: grid-certificates for package: osg-gridftp
--> Processing Dependency: gums-client for package: osg-gridftp
--> Processing Dependency: liblcas_lcmaps_gt4_mapping.so.0()(64bit) for package: osg-gridftp
--> Running transaction check
---> Package globus-gridftp-server-progs.x86_64 0:6.1-5.osg set to be updated
--> Processing Dependency: globus-gridftp-server = 6.1-5.osg for package: globus-gridftp-server-progs
--> Processing Dependency: globus-xio-gsi-driver >= 2 for package: globus-gridftp-server-progs
--> Processing Dependency: perl(Globus::Core::Paths) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gssapi_gsi.so.9(globus_gssapi_gsi)(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gsi_credential.so.5()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gssapi_error.so.4()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_io.so.8()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gsi_cert_utils.so.8()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_callout.so.2()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_openssl.so.3()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_authz.so.2()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gsi_authz_callout_error.so.2()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_common.so.14()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_proxy_ssl.so.4()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_xio.so.3()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gsi_proxy_core.so.6()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gfork.so.3()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gridftp_server_control.so.2()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_ftp_control.so.4()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gss_assist.so.8()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_openssl_error.so.2()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gridftp_server.so.6()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gsi_sysconfig.so.5()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_usage.so.3()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gsi_callback.so.4()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_gssapi_gsi.so.9()(64bit) for package: globus-gridftp-server-progs
--> Processing Dependency: libglobus_oldgaa.so.4()(64bit) for package: globus-gridftp-server-progs
---> Package gratia-probe-gridftp-transfer.noarch 0:1.09-0.4.1.pre set to be updated
--> Processing Dependency: gratia-probe-common >= 1.09-0.4.1.pre for package: gratia-probe-gridftp-transfer
--> Processing Dependency: netlogger for package: gratia-probe-gridftp-transfer
---> Package gums-client.noarch 0:1.3.18.002-3 set to be updated
--> Processing Dependency: gums = 1.3.18.002 for package: gums-client
--> Processing Dependency: osg-vo-map for package: gums-client
---> Package lcas-lcmaps-gt4-interface.x86_64 0:0.1.4-6.osg set to be updated
--> Processing Dependency: liblcas.so.0()(64bit) for package: lcas-lcmaps-gt4-interface
--> Processing Dependency: liblcmaps.so.0()(64bit) for package: lcas-lcmaps-gt4-interface
--> Processing Dependency: libglobus_gridmap_callout_error.so.1()(64bit) for package: lcas-lcmaps-gt4-interface
---> Package osg-ca-certs.noarch 0:1.24-1 set to be updated
---> Package vo-client.noarch 0:38-9.osg set to be updated
--> Running transaction check
---> Package globus-authz.x86_64 0:2.0-2.osg set to be updated
---> Package globus-authz-callout-error.x86_64 0:2.0-2.osg set to be updated
---> Package globus-callout.x86_64 0:2.0-2.osg set to be updated
--> Processing Dependency: libltdl.so.3()(64bit) for package: globus-callout
---> Package globus-common.x86_64 0:14.0-3.osg set to be updated
---> Package globus-ftp-control.x86_64 0:4.0-2.osg set to be updated
---> Package globus-gfork.x86_64 0:3.0-2.osg set to be updated
---> Package globus-gridftp-server.x86_64 0:6.1-5.osg set to be updated
---> Package globus-gridftp-server-control.x86_64 0:2.0-3.osg set to be updated
--> Processing Dependency: globus-xio-pipe-driver >= 2 for package: globus-gridftp-server-control
---> Package globus-gridmap-callout-error.x86_64 0:1.1-1.osg set to be updated
---> Package globus-gsi-callback.x86_64 0:4.0-2.osg set to be updated
---> Package globus-gsi-cert-utils.x86_64 0:8.0-2.osg set to be updated
---> Package globus-gsi-credential.x86_64 0:5.0-3.osg set to be updated
---> Package globus-gsi-openssl-error.x86_64 0:2.0-2.osg set to be updated
---> Package globus-gsi-proxy-core.x86_64 0:6.0-2.osg set to be updated
---> Package globus-gsi-proxy-ssl.x86_64 0:4.0-2.osg set to be updated
---> Package globus-gsi-sysconfig.x86_64 0:5.0-3.osg set to be updated
---> Package globus-gss-assist.x86_64 0:8.0-2.osg set to be updated
---> Package globus-gssapi-error.x86_64 0:4.0-2.osg set to be updated
---> Package globus-gssapi-gsi.x86_64 0:10.0-1.osg set to be updated
---> Package globus-io.x86_64 0:9.0-2.osg set to be updated
---> Package globus-openssl-module.x86_64 0:3.0-2.osg set to be updated
---> Package globus-usage.x86_64 0:3.0-2.osg set to be updated
---> Package globus-xio.x86_64 0:3.0-3.osg set to be updated
---> Package globus-xio-gsi-driver.x86_64 0:2.0-2.osg set to be updated
---> Package gratia-probe-common.noarch 0:1.09-0.4.1.pre set to be updated
--> Processing Dependency: pyOpenSSL for package: gratia-probe-common
---> Package gums.noarch 0:1.3.18.002-3 set to be updated
--> Processing Dependency: java for package: gums
---> Package lcas.x86_64 0:1.3.13-8.osg set to be updated
--> Processing Dependency: liblcas_userban.so()(64bit) for package: lcas
---> Package lcmaps.x86_64 0:1.4.28-14.osg set to be updated
--> Processing Dependency: lcmaps-plugins-saz-client for package: lcmaps
--> Processing Dependency: lcmaps-plugins-gums-client for package: lcmaps
--> Processing Dependency: liblcmaps_scas_client.so.0()(64bit) for package: lcmaps
--> Processing Dependency: liblcmaps_verify_proxy.so.0()(64bit) for package: lcmaps
--> Processing Dependency: libvomsapi.so.1()(64bit) for package: lcmaps
--> Processing Dependency: liblcmaps_posix_enf.so.0()(64bit) for package: lcmaps
---> Package netlogger.noarch 0:4.2.0-1 set to be updated
---> Package osg-vo-map.noarch 0:0.0.1-1.osg set to be updated
--> Running transaction check
---> Package globus-xio-pipe-driver.x86_64 0:2.0-2.osg set to be updated
---> Package java-1.6.0-openjdk.x86_64 1:1.6.0.0-1.22.1.9.8.el5_6 set to be updated
--> Processing Dependency: jpackage-utils >= 1.7.3-1jpp.2 for package: java-1.6.0-openjdk
--> Processing Dependency: libasound.so.2(ALSA_0.9)(64bit) for package: java-1.6.0-openjdk
--> Processing Dependency: libasound.so.2(ALSA_0.9.0rc4)(64bit) for package: java-1.6.0-openjdk
--> Processing Dependency: tzdata-java for package: java-1.6.0-openjdk
--> Processing Dependency: libXtst.so.6()(64bit) for package: java-1.6.0-openjdk
--> Processing Dependency: libasound.so.2()(64bit) for package: java-1.6.0-openjdk
--> Processing Dependency: libgif.so.4()(64bit) for package: java-1.6.0-openjdk
---> Package lcas-plugins-basic.x86_64 0:1.3.5-5.osg set to be updated
---> Package lcmaps-plugins-basic.x86_64 0:1.4.5-1.osg set to be updated
---> Package lcmaps-plugins-gums-client.x86_64 0:0.0.2-2.osg set to be updated
--> Processing Dependency: lcmaps-plugins-scas-client for package: lcmaps-plugins-gums-client
---> Package lcmaps-plugins-saz-client.x86_64 0:0.2.22-7.osg set to be updated
--> Processing Dependency: saml2-xacml2-c-lib for package: lcmaps-plugins-saz-client
--> Processing Dependency: libxacml.so.0()(64bit) for package: lcmaps-plugins-saz-client
---> Package lcmaps-plugins-verify-proxy.x86_64 0:1.4.9-2.osg set to be updated
---> Package libtool-ltdl.x86_64 0:1.5.22-7.el5_4 set to be updated
---> Package pyOpenSSL.x86_64 0:0.6-1.p24.7.2.2 set to be updated
---> Package voms.x86_64 0:2.0.6-3.osg set to be updated
--> Running transaction check
---> Package alsa-lib.x86_64 0:1.0.17-1.el5 set to be updated
---> Package giflib.x86_64 0:4.1.3-7.1.el5_3.1 set to be updated
---> Package jpackage-utils.noarch 0:1.7.3-1jpp.2.el5 set to be updated
---> Package lcmaps-plugins-scas-client.x86_64 0:0.2.22-7.osg set to be updated
---> Package libXtst.x86_64 0:1.0.1-3.1 set to be updated
---> Package saml2-xacml2-c-lib.x86_64 0:1.0.1-6.osg set to be updated
---> Package tzdata-java.x86_64 0:2011h-2.el5 set to be updated
--> Finished Dependency Resolution
Beginning Kernel Module Plugin
Finished Kernel Module Plugin

Dependencies Resolved

============================================================================================================
 Package                            Arch        Version                           Repository           Size
============================================================================================================
Installing:
 osg-gridftp                        x86_64      3.0.0-5                           osg-testing         2.1 k
Installing for dependencies:
 alsa-lib                           x86_64      1.0.17-1.el5                      sl-base             414 k
 giflib                             x86_64      4.1.3-7.1.el5_3.1                 sl-base              39 k
 globus-authz                       x86_64      2.0-2.osg                         osg-testing          14 k
 globus-authz-callout-error         x86_64      2.0-2.osg                         osg-testing         9.9 k
 globus-callout                     x86_64      2.0-2.osg                         osg-testing          16 k
 globus-common                      x86_64      14.0-3.osg                        osg-testing         128 k
 globus-ftp-control                 x86_64      4.0-2.osg                         osg-testing          73 k
 globus-gfork                       x86_64      3.0-2.osg                         osg-testing          19 k
 globus-gridftp-server              x86_64      6.1-5.osg                         osg-testing         163 k
 globus-gridftp-server-control      x86_64      2.0-3.osg                         osg-testing          77 k
 globus-gridftp-server-progs        x86_64      6.1-5.osg                         osg-testing          40 k
 globus-gridmap-callout-error       x86_64      1.1-1.osg                         osg-testing         6.7 k
 globus-gsi-callback                x86_64      4.0-2.osg                         osg-testing          41 k
 globus-gsi-cert-utils              x86_64      8.0-2.osg                         osg-testing          18 k
 globus-gsi-credential              x86_64      5.0-3.osg                         osg-testing          35 k
 globus-gsi-openssl-error           x86_64      2.0-2.osg                         osg-testing          16 k
 globus-gsi-proxy-core              x86_64      6.0-2.osg                         osg-testing          36 k
 globus-gsi-proxy-ssl               x86_64      4.0-2.osg                         osg-testing          17 k
 globus-gsi-sysconfig               x86_64      5.0-3.osg                         osg-testing          29 k
 globus-gss-assist                  x86_64      8.0-2.osg                         osg-testing          34 k
 globus-gssapi-error                x86_64      4.0-2.osg                         osg-testing          13 k
 globus-gssapi-gsi                  x86_64      10.0-1.osg                        osg-testing          60 k
 globus-io                          x86_64      9.0-2.osg                         osg-testing          44 k
 globus-openssl-module              x86_64      3.0-2.osg                         osg-testing          14 k
 globus-usage                       x86_64      3.0-2.osg                         osg-testing          16 k
 globus-xio                         x86_64      3.0-3.osg                         osg-testing         178 k
 globus-xio-gsi-driver              x86_64      2.0-2.osg                         osg-testing          37 k
 globus-xio-pipe-driver             x86_64      2.0-2.osg                         osg-testing          16 k
 gratia-probe-common                noarch      1.09-0.4.1.pre                    osg-testing         132 k
 gratia-probe-gridftp-transfer      noarch      1.09-0.4.1.pre                    osg-testing          22 k
 gums                               noarch      1.3.18.002-3                      osg-testing          25 M
 gums-client                        noarch      1.3.18.002-3                      osg-testing          13 k
 java-1.6.0-openjdk                 x86_64      1:1.6.0.0-1.22.1.9.8.el5_6        fermi-security       37 M
 jpackage-utils                     noarch      1.7.3-1jpp.2.el5                  sl-base              61 k
 lcas                               x86_64      1.3.13-8.osg                      osg-testing          28 k
 lcas-lcmaps-gt4-interface          x86_64      0.1.4-6.osg                       osg-testing          17 k
 lcas-plugins-basic                 x86_64      1.3.5-5.osg                       osg-testing          23 k
 lcmaps                             x86_64      1.4.28-14.osg                     osg-testing          89 k
 lcmaps-plugins-basic               x86_64      1.4.5-1.osg                       osg-testing          38 k
 lcmaps-plugins-gums-client         x86_64      0.0.2-2.osg                       osg-testing         2.6 k
 lcmaps-plugins-saz-client          x86_64      0.2.22-7.osg                      osg-testing          32 k
 lcmaps-plugins-scas-client         x86_64      0.2.22-7.osg                      osg-testing          39 k
 lcmaps-plugins-verify-proxy        x86_64      1.4.9-2.osg                       osg-testing          23 k
 libXtst                            x86_64      1.0.1-3.1                         sl-base              16 k
 libtool-ltdl                       x86_64      1.5.22-7.el5_4                    fermi-security       38 k
 netlogger                          noarch      4.2.0-1                           osg-testing         624 k
 osg-ca-certs                       noarch      1.24-1                            osg-testing         450 k
 osg-vo-map                         noarch      0.0.1-1.osg                       osg-testing         7.3 k
 pyOpenSSL                          x86_64      0.6-1.p24.7.2.2                   sl-base             120 k
 saml2-xacml2-c-lib                 x86_64      1.0.1-6.osg                       osg-testing         581 k
 tzdata-java                        x86_64      2011h-2.el5                       fermi-security      178 k
 vo-client                          noarch      38-9.osg                          osg-testing          15 k
 voms                               x86_64      2.0.6-3.osg                       osg-testing         171 k

Transaction Summary
============================================================================================================
Install      54 Package(s)
Upgrade       0 Package(s)

Total download size: 66 M
Is this ok [y/N]: y
Downloading Packages:
(1/54): osg-gridftp-3.0.0-5.x86_64.rpm                                               | 2.1 kB     00:00
(2/54): lcmaps-plugins-gums-client-0.0.2-2.osg.x86_64.rpm                            | 2.6 kB     00:00
(3/54): globus-gridmap-callout-error-1.1-1.osg.x86_64.rpm                            | 6.7 kB     00:00
(4/54): osg-vo-map-0.0.1-1.osg.noarch.rpm                                            | 7.3 kB     00:00
(5/54): globus-authz-callout-error-2.0-2.osg.x86_64.rpm                              | 9.9 kB     00:00
(6/54): gums-client-1.3.18.002-3.noarch.rpm                                          |  13 kB     00:00
(7/54): globus-gssapi-error-4.0-2.osg.x86_64.rpm                                     |  13 kB     00:00
(8/54): globus-authz-2.0-2.osg.x86_64.rpm                                            |  14 kB     00:00
(9/54): globus-openssl-module-3.0-2.osg.x86_64.rpm                                   |  14 kB     00:00
(10/54): vo-client-38-9.osg.noarch.rpm                                               |  15 kB     00:00
(11/54): globus-gsi-openssl-error-2.0-2.osg.x86_64.rpm                               |  16 kB     00:00
(12/54): libXtst-1.0.1-3.1.x86_64.rpm                                                |  16 kB     00:00
(13/54): globus-usage-3.0-2.osg.x86_64.rpm                                           |  16 kB     00:00
(14/54): globus-callout-2.0-2.osg.x86_64.rpm                                         |  16 kB     00:00
(15/54): globus-xio-pipe-driver-2.0-2.osg.x86_64.rpm                                 |  16 kB     00:00
(16/54): globus-gsi-proxy-ssl-4.0-2.osg.x86_64.rpm                                   |  17 kB     00:00
(17/54): lcas-lcmaps-gt4-interface-0.1.4-6.osg.x86_64.rpm                            |  17 kB     00:00
(18/54): globus-gsi-cert-utils-8.0-2.osg.x86_64.rpm                                  |  18 kB     00:00
(19/54): globus-gfork-3.0-2.osg.x86_64.rpm                                           |  19 kB     00:00
(20/54): gratia-probe-gridftp-transfer-1.09-0.4.1.pre.noarch.rpm                     |  22 kB     00:00
(21/54): lcas-plugins-basic-1.3.5-5.osg.x86_64.rpm                                   |  23 kB     00:00
(22/54): lcmaps-plugins-verify-proxy-1.4.9-2.osg.x86_64.rpm                          |  23 kB     00:00
(23/54): lcas-1.3.13-8.osg.x86_64.rpm                                                |  28 kB     00:00
(24/54): globus-gsi-sysconfig-5.0-3.osg.x86_64.rpm                                   |  29 kB     00:00
(25/54): lcmaps-plugins-saz-client-0.2.22-7.osg.x86_64.rpm                           |  32 kB     00:00
(26/54): globus-gss-assist-8.0-2.osg.x86_64.rpm                                      |  34 kB     00:00
(27/54): globus-gsi-credential-5.0-3.osg.x86_64.rpm                                  |  35 kB     00:00
(28/54): globus-gsi-proxy-core-6.0-2.osg.x86_64.rpm                                  |  36 kB     00:00
(29/54): globus-xio-gsi-driver-2.0-2.osg.x86_64.rpm                                  |  37 kB     00:00
(30/54): libtool-ltdl-1.5.22-7.el5_4.x86_64.rpm                                      |  38 kB     00:00
(31/54): lcmaps-plugins-basic-1.4.5-1.osg.x86_64.rpm                                 |  38 kB     00:00
(32/54): lcmaps-plugins-scas-client-0.2.22-7.osg.x86_64.rpm                          |  39 kB     00:00
(33/54): giflib-4.1.3-7.1.el5_3.1.x86_64.rpm                                         |  39 kB     00:00
(34/54): globus-gridftp-server-progs-6.1-5.osg.x86_64.rpm                            |  40 kB     00:00
(35/54): globus-gsi-callback-4.0-2.osg.x86_64.rpm                                    |  41 kB     00:00
(36/54): globus-io-9.0-2.osg.x86_64.rpm                                              |  44 kB     00:00
(37/54): globus-gssapi-gsi-10.0-1.osg.x86_64.rpm                                     |  60 kB     00:00
(38/54): jpackage-utils-1.7.3-1jpp.2.el5.noarch.rpm                                  |  61 kB     00:00
(39/54): globus-ftp-control-4.0-2.osg.x86_64.rpm                                     |  73 kB     00:00
(40/54): globus-gridftp-server-control-2.0-3.osg.x86_64.rpm                          |  77 kB     00:00
(41/54): lcmaps-1.4.28-14.osg.x86_64.rpm                                             |  89 kB     00:00
(42/54): pyOpenSSL-0.6-1.p24.7.2.2.x86_64.rpm                                        | 120 kB     00:00
(43/54): globus-common-14.0-3.osg.x86_64.rpm                                         | 128 kB     00:00
(44/54): gratia-probe-common-1.09-0.4.1.pre.noarch.rpm                               | 132 kB     00:00
(45/54): globus-gridftp-server-6.1-5.osg.x86_64.rpm                                  | 163 kB     00:00
(46/54): voms-2.0.6-3.osg.x86_64.rpm                                                 | 171 kB     00:00
(47/54): globus-xio-3.0-3.osg.x86_64.rpm                                             | 178 kB     00:00
(48/54): tzdata-java-2011h-2.el5.x86_64.rpm                                          | 178 kB     00:00
(49/54): alsa-lib-1.0.17-1.el5.x86_64.rpm                                            | 414 kB     00:00
(50/54): osg-ca-certs-1.24-1.noarch.rpm                                              | 450 kB     00:00
(51/54): saml2-xacml2-c-lib-1.0.1-6.osg.x86_64.rpm                                   | 581 kB     00:00
(52/54): netlogger-4.2.0-1.noarch.rpm                                                | 624 kB     00:00
(53/54): gums-1.3.18.002-3.noarch.rpm                                                |  25 MB     00:02
(54/54): java-1.6.0-openjdk-1.6.0.0-1.22.1.9.8.el5_6.x86_64.rpm                      |  37 MB     00:00
------------------------------------------------------------------------------------------------------------
Total                                                                       5.3 MB/s |  66 MB     00:12
warning: rpmts_HdrFromFdno: Header V3 DSA signature: NOKEY, key ID 824b8603
osg-testing/gpgkey                                                                   | 1.7 kB     00:00
Importing GPG key 0x824B8603 "OSG Software Team (RPM Signing Key for Koji Packages) <vdt-support@opensciencegrid.org>" from /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
Is this ok [y/N]: y
Running rpm_check_debug
Running Transaction Test
Finished Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing     : globus-gsi-proxy-ssl                                                                1/54
  Installing     : saml2-xacml2-c-lib                                                                  2/54
  Installing     : lcmaps-plugins-saz-client                                                           3/54
  Installing     : libtool-ltdl                                                                        4/54
  Installing     : globus-common                                                                       5/54
  Installing     : globus-gsi-openssl-error                                                            6/54
  Installing     : globus-openssl-module                                                               7/54
  Installing     : globus-gsi-sysconfig                                                                8/54
  Installing     : globus-gsi-cert-utils                                                               9/54
  Installing     : globus-gsi-callback                                                                10/54
  Installing     : globus-gsi-credential                                                              11/54
  Installing     : globus-gsi-proxy-core                                                              12/54
  Installing     : globus-gssapi-gsi                                                                  13/54
  Installing     : globus-callout                                                                     14/54
  Installing     : globus-gss-assist                                                                  15/54
  Installing     : globus-xio                                                                         16/54
  Installing     : globus-gssapi-error                                                                17/54
  Installing     : globus-xio-gsi-driver                                                              18/54
  Installing     : globus-io                                                                          19/54
  Installing     : globus-authz-callout-error                                                         20/54
  Installing     : globus-authz                                                                       21/54
  Installing     : globus-ftp-control                                                                 22/54
  Installing     : globus-usage                                                                       23/54
  Installing     : globus-gfork                                                                       24/54
  Installing     : globus-gridmap-callout-error                                                       25/54
  Installing     : globus-xio-pipe-driver                                                             26/54
  Installing     : globus-gridftp-server-control                                                      27/54
  Installing     : globus-gridftp-server                                                              28/54
  Installing     : globus-gridftp-server-progs                                                        29/54
  Installing     : lcmaps-plugins-scas-client                                                         30/54
  Installing     : voms                                                                               31/54
  Installing     : giflib                                                                             32/54
  Installing     : lcmaps-plugins-basic                                                               33/54
  Installing     : pyOpenSSL                                                                          34/54
  Installing     : alsa-lib                                                                           35/54
  Installing     : lcmaps-plugins-verify-proxy                                                        36/54
  Installing     : libXtst                                                                            37/54
  Installing     : osg-ca-certs                                                                       38/54
  Installing     : vo-client                                                                          39/54
  Installing     : gratia-probe-common                                                                40/54
  Installing     : lcmaps-plugins-gums-client                                                         41/54
  Installing     : lcmaps                                                                             42/54
  Installing     : jpackage-utils                                                                     43/54
  Installing     : osg-vo-map                                                                         44/54
  Installing     : netlogger                                                                          45/54
  Installing     : gratia-probe-gridftp-transfer                                                      46/54
  Installing     : tzdata-java                                                                        47/54
  Installing     : java-1.6.0-openjdk                                                                 48/54
  Installing     : gums                                                                               49/54
  Installing     : gums-client                                                                        50/54
  Installing     : lcas                                                                               51/54
  Installing     : lcas-lcmaps-gt4-interface                                                          52/54
  Installing     : lcas-plugins-basic                                                                 53/54
  Installing     : osg-gridftp                                                                        54/54

Installed:
  osg-gridftp.x86_64 0:3.0.0-5

Dependency Installed:
  alsa-lib.x86_64 0:1.0.17-1.el5
  giflib.x86_64 0:4.1.3-7.1.el5_3.1
  globus-authz.x86_64 0:2.0-2.osg
  globus-authz-callout-error.x86_64 0:2.0-2.osg
  globus-callout.x86_64 0:2.0-2.osg
  globus-common.x86_64 0:14.0-3.osg
  globus-ftp-control.x86_64 0:4.0-2.osg
  globus-gfork.x86_64 0:3.0-2.osg
  globus-gridftp-server.x86_64 0:6.1-5.osg
  globus-gridftp-server-control.x86_64 0:2.0-3.osg
  globus-gridftp-server-progs.x86_64 0:6.1-5.osg
  globus-gridmap-callout-error.x86_64 0:1.1-1.osg
  globus-gsi-callback.x86_64 0:4.0-2.osg
  globus-gsi-cert-utils.x86_64 0:8.0-2.osg
  globus-gsi-credential.x86_64 0:5.0-3.osg
  globus-gsi-openssl-error.x86_64 0:2.0-2.osg
  globus-gsi-proxy-core.x86_64 0:6.0-2.osg
  globus-gsi-proxy-ssl.x86_64 0:4.0-2.osg
  globus-gsi-sysconfig.x86_64 0:5.0-3.osg
  globus-gss-assist.x86_64 0:8.0-2.osg
  globus-gssapi-error.x86_64 0:4.0-2.osg
  globus-gssapi-gsi.x86_64 0:10.0-1.osg
  globus-io.x86_64 0:9.0-2.osg
  globus-openssl-module.x86_64 0:3.0-2.osg
  globus-usage.x86_64 0:3.0-2.osg
  globus-xio.x86_64 0:3.0-3.osg
  globus-xio-gsi-driver.x86_64 0:2.0-2.osg
  globus-xio-pipe-driver.x86_64 0:2.0-2.osg
  gratia-probe-common.noarch 0:1.09-0.4.1.pre
  gratia-probe-gridftp-transfer.noarch 0:1.09-0.4.1.pre
  gums.noarch 0:1.3.18.002-3
  gums-client.noarch 0:1.3.18.002-3
  java-1.6.0-openjdk.x86_64 1:1.6.0.0-1.22.1.9.8.el5_6
  jpackage-utils.noarch 0:1.7.3-1jpp.2.el5
  lcas.x86_64 0:1.3.13-8.osg
  lcas-lcmaps-gt4-interface.x86_64 0:0.1.4-6.osg
  lcas-plugins-basic.x86_64 0:1.3.5-5.osg
  lcmaps.x86_64 0:1.4.28-14.osg
  lcmaps-plugins-basic.x86_64 0:1.4.5-1.osg
  lcmaps-plugins-gums-client.x86_64 0:0.0.2-2.osg
  lcmaps-plugins-saz-client.x86_64 0:0.2.22-7.osg
  lcmaps-plugins-scas-client.x86_64 0:0.2.22-7.osg
  lcmaps-plugins-verify-proxy.x86_64 0:1.4.9-2.osg
  libXtst.x86_64 0:1.0.1-3.1
  libtool-ltdl.x86_64 0:1.5.22-7.el5_4
  netlogger.noarch 0:4.2.0-1
  osg-ca-certs.noarch 0:1.24-1
  osg-vo-map.noarch 0:0.0.1-1.osg
  pyOpenSSL.x86_64 0:0.6-1.p24.7.2.2
  saml2-xacml2-c-lib.x86_64 0:1.0.1-6.osg
  tzdata-java.x86_64 0:2011h-2.el5
  vo-client.noarch 0:38-9.osg
  voms.x86_64 0:2.0.6-3.osg

Complete!
[root@fermicloud108 ~]# cat /etc/grid-security/gsi-authz.conf
#globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout
[root@fermicloud108 ~]# sed -i 's/\#globus_mapping/globus_mapping/' /etc/grid-security/gsi-authz.conf
[root@fermicloud108 ~]# cat /etc/grid-security/gsi-authz.conf
globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout
[root@fermicloud108 ~]# vi /etc/lcmaps.db
[root@fermicloud108 ~]# sed -i 's/yourgums.yourdomain/gums.fnal.gov/' /etc/lcmaps.db
[root@fermicloud108 ~]# vi /etc/lcmaps.db
[root@fermicloud108 ~]# service globus-gridftp-server start
Started GridFTP Server                                     [  OK  ]
[root@fermicloud108 ~]# ps -ef | grep globus
root      2364     1  0 11:12 ?        00:00:00 /usr/sbin/globus-gridftp-server -c /etc/gridftp.conf -pidfile /var/run/globus-gridftp-server.pid -no-detach -config-base-path /
root      2371  2164  0 11:12 pts/0    00:00:00 grep globus
[root@fermicloud108 ~]#  
```

<span class="twiki-macro ENDTWISTY"></span>

\#DocReferences —\# References

-   [Globus GridFTP administration manual](http://www.globus.org/toolkit/docs/latest-stable/gridftp/admin/)
-   [Globus GridFTP tutorial](http://www.mcs.anl.gov/~mlink/tutorials/GridFTPTutorialHandout.pdf)

