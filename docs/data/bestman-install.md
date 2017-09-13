Installing BeStMan
==================

!!! warning
    As of the June 2017 release of OSG 3.4.0, this software is officially deprecated.  Support is scheduled to end as of June 2018.

About this Document
====================

This document explains how to install a BeStMan SRMv2 service. This procedure will guide one through the installation and configuration of a basic `bestman2` host with an underlying GridFTP server. This will allow the service to service requests via the SRM (Storage Resource Manager) protocol or the GridFTP protocol.

Installing BeStMan Storage Element
==================================

This procedure explains how to install the stand-alone BeStMan Storage Element server; [see below](#upgrading-bestman) for notes on upgrading.  The service has the following components:

-   BeStMan - provides load-balancing across GridFTP servers.
-   GridFTP server - provides file transfer services using the GridFTP protocol.
-   [Gratia gridftp transfer probe](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/GratiaTransferProbe) (optional) - provides transfer accounting information to the OSG.

Requirements
------------

### Host and OS

- You need at least one node in order to install this service.
- The OS must be in the [supported platforms](../release/supported_platforms.md) list.
- The [OSG software repositories](../common/yum.md) must be configured correctly.
- All procedures in this document require *root* privileges.

### Users

This installation will create following users unless they are already created:

| User      | Comment                                         |
|:----------|:------------------------------------------------|
| `bestman` | Used by Bestman SRM server                      |

For full functionality, the `bestman` account will need limited `sudo` access to a few commands, described below.

For this package to function correctly, you will have to create the users needed for grid operation. Any user that can be authenticated should be created.  For grid-mapfile users, each line of the grid-mapfile is a certificate/user pair. Each user in this file should be created on the server. For GUMS sites, this means that each user that can be authenticated by GUMS should be created on the server.

Note that these users must be kept in sync with the authentication method. For instance, if new users or rules are added in GUMS, then new users should also be added here.

### Certificates

Two certificates are needed for operation of this service.

| Certificate                 | User that owns certificate | Path to certificate                                                                                 |
|:----------------------------|:---------------------------|:----------------------------------------------------------------------------------------------------|
| Host certificate            | `root`                     | `/etc/grid-security/hostcert.pem` and `/etc/grid-security/hostkey.pem`                       |
| Bestman service certificate | `bestman`                  | `/etc/grid-security/bestman/bestmancert.pem` and `/etc/grid-security/bestman/bestmankey.pem` |

Following the [instructions](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/OSGPKICommandlineClients) to request a service certificate.

You will also need a copy of CA certificates. Note that the `osg-se-bestman` package will automatically install a certificate package but will not necessarily pick the cert package you expect; see [the CA certificates](../common/ca.md) documentation for more information.

### Networking

For more details on overall firewall configuration, please see our [firewall documentation](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/FirewallInformation).

| Service Name            | Protocol | Port Number               | Inbound | Outbound | Comment                                 |
|:------------------------|:---------|:--------------------------|:--------|:---------|:----------------------------------------|
| GridFTP data channels   | tcp      | `GLOBUS_TCP_PORT_RANGE`   | X       |          | contiguous range of ports is necessary. |
| GridFTP data channels   | tcp      | `GLOBUS_TCP_SOURCE_RANGE` |         | X        | contiguous range of ports is necessary. |
| GridFTP control channel | tcp      | 2811                      | X       |          |                                         |
| SRM                     | tcp      | 8443                      | X       |          |                                         |

### Engineering Considerations

Please answer following questions before you proceed with installation and configuration of BeStMan storage element:

Q. *What authorization mechanism should I use?*

Decide between a [grid-mapfile](../security/edg-mkgridmap) or a [GUMS](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallGums) server for authorization.  Both mechanisms are deprecated with a planned removal by June 2018.  The replacement mechanism, however, does not work with `bestman2`.

Q. *How many GridFTP servers will I need?*

Choose to run multiple GridFTP servers for load balancing and better performance. We recommend to install additional GridFTP servers if your Storage Element:

* Is serving data to more than 1000 cores for VOs that use storage heavily (e.g. CMS, ATLAS, CDF, and D0),
* Is managing more than 500 TB of disk space, OR
* Has more than 10Gbps bandwidth

We recommend approximately one GridFTP server for each 8Gbps of desired utilized bandwidth.

Q. *Do I need to change default configuration of Gridftp server?*

Yes, you may want to do this if the node on which GridFTP server will be installed has multiple network interfaces. Read [this section](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallOSGGridFTP#ConfigMultiHomed) for more details.

Q. *Do you need to enable Gratia gridftp-transfer probes?*   
The Gratia gridftp-transfer probes provide OSG storage statistics for accounting purposes. The reports include the source and destination of transfers, certificate subject of transfer initiator, as well as the size and status of the transferred file. The probe needs to be installed on every GridFTP server.

Install Instructions
====================

Installing BeStMan2
-------------------

1.  Install Java using [these instructions](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallSoftwareWithOpenJDK7#InstallingJava).
2.  Install the BeStMan Storage element meta-package:

```console
[root@client ~] # yum install osg-se-bestman
```

Authorization
-------------

There are two authorization options:

* Gridmap file
* GUMS authentication server

Please choose one of these and follow the instructions in one of the two following sections.

### Configuring Gridmap Support

By default, GridFTP uses a gridmap file, found in `/etc/grid-security/grid-mapfile`. This file is not generated by default. can generate this file. You can generate this file manually, by including DN/username combinations (this is most useful for debugging). Otherwise, you can use [`edg-mkgridmap`](../security/edg-mkgridmap), which will periodically contact a list of VOMS servers that you specify.

Once `edg-mkgridmap` is configured, you will have to modify `/etc/bestman2/conf/bestman2.rc` and change `GridMapFileName` from `/etc/bestman2/conf/grid-mapfile.empty` to:
```text
GridMapFileName=/etc/grid-security/grid-mapfile
```

In `/etc/sysconfig/bestman2`, change
```bash
BESTMAN_GUMS_ENABLED=no
```

### Configuring GUMS support

By default, GridFTP uses a gridmap file, found in `/etc/grid-security/gridmap-file`. If you want to use GUMS security (recommended), you will need to enable it using the following steps.

First, edit `/etc/grid-security/gsi-authz.conf` and uncomment the authorization callout:

```
globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout
```

Next edit `/etc/lcmaps.db` to enter the correct GUMS hostname:

```
gumsclient = "lcmaps_gums_client.mod"
             "-resourcetype ce"
             "-actiontype execute-now"
             "-capath /etc/grid-security/certificates"
             "-cert   /etc/grid-security/hostcert.pem"
             "-key    /etc/grid-security/hostkey.pem"
             "--cert-owner root"
# Change this URL to your GUMS server
             "--endpoint https://<GUMS_HOSTNAME>:8443/gums/services/GUMSXACMLAuthorizationServicePort"
```

You will need to modify the following settings in `/etc/sysconfig/bestman2`

```bash
BESTMAN_GUMSCERTPATH=/etc/grid-security/bestman/bestmancert.pem
BESTMAN_GUMSKEYPATH=/etc/grid-security/bestman/bestmankey.pem
```

You will need to modify the following settings in `/etc/bestman2/conf/bestman2.rc`

```text
GUMSserviceURL=https://<GUMS_HOST>:8443/gums/services/GUMSXACMLAuthorizationServicePort
```

Edit Bestman Settings
---------------------

Bestman settings are split into three files:

- Environment variables (except those that represent server and client libraries) are stored in `/etc/sysconfig/bestman2`.
- The server and client library environment variables are stored in `/etc/sysconfig/bestman2lib`.
- Configuration is stored in `/etc/bestman2/conf/bestman2.rc`.

You should review these settings to make sure all of them comply with your environment. You are not expected to edit `/etc/sysconfig/bestman2lib` .

!!! note
    If you are upgrading from a version prior to 2.3.0-9, you will need to remove **all** entries for `BESTMAN2_SERVER_LIB` and `BESTMAN2_CLIENT_LIB` in file `/etc/sysconfig/bestman2.` These settings are now present in file `/etc/sysconfig/bestman2lib`

You will likely need to modify the following settings in `/etc/bestman2/conf/bestman2.rc`:

```text
localPathListAllowed=/tmp
CertFileName=/etc/grid-security/bestman/bestmancert.pem
KeyFileName=/etc/grid-security/bestman/bestmankey.pem
supportedProtocolList=gsiftp://<GRIDFTP_HOSTNAME>;gsiftp://<GRIDFTP_HOSTNAME2>
```

!!! note
    Make sure the value for `localPathListAllowed` is correctly entered - i.e. each path separated by a `;`. If it is not, this parameter may not be effective.
    Make sure the permissions for the `localPathListAllowed` directory(ies) are set to 1777, which is the default for `/tmp`. Further, note that on many systems, `/tmp` gets cleared out automatically, so you may want to use a different location to ensure that the files persist.

BeStMan requires up to two sets of certificate pairs. One is for host services; when clients connect to BeStMan, they will receive this certificate (`CertFileName`, `KeyFileName`) as proof of the server identity. The second certificate pair (`BESTMAN_GUMSCERTPATH`, `BESTMAN_GUMSKEYPATH`) is used to communicate with GUMS when verifying identity information (this only applicable for GUMS-enabled sites). These two can (and usually will be) the same files, but can be split if your GUMS setup requires a specific identity.

`localPathListAllowed` determines which paths users will be able to access via SRM.

`supportedProtocolList` is a semi-colon list of GridFTP servers that the BeStMan will use as transfer agents. If you are using anything but the standard GridFTP port 2811, you will also have to add the port (ie `gsiftp://<HOSTNAME>:port`).

Finally, modify `GUMSserviceURL` to use your local GUMS installation if you are using GUMS.

Modify `/etc/sudoers`
---------------------

BeStman requires the `sudo` command in order to write information as the proper user. You will need to give the `bestman` user the proper permissions to run these commands.

Modify `/etc/sudoers` and comment the following line.

```text
#Defaults    requiretty
```

Then add the following lines at the end of the `/etc/sudoers` file.

```text
Cmnd_Alias SRM_CMD = /bin/rm, /bin/mkdir, /bin/rmdir, /bin/mv, /bin/cp, /bin/ls
Runas_Alias SRM_USR = ALL, !root
bestman   ALL=(SRM_USR) NOPASSWD: SRM_CMD
```

Copying certificates to an alternate location
---------------------------------------------

BeStMan requires a certificate pair to function; this must be readable by the `bestman` user.

```console
[root@client ~] # cp /etc/grid-security/hostkey.pem /etc/grid-security/bestman/bestmankey.pem
[root@client ~] # cp /etc/grid-security/hostcert.pem /etc/grid-security/bestman/bestmancert.pem
[root@client ~] # chown -R bestman:bestman /etc/grid-security/bestman/
```

Verify `CertFileName` and `KeyFileName` in `/etc/bestman2/conf/bestman2.rc` are set appropriately.

(Optional) Using a different bestman user
---------------------------------------------

If you would like to use a different user than the default `bestman` user (*not recommended*), you will need to change the following:

-   Ownership of bestman certs in `/etc/grid-security/bestman`.
-   `SRM_OWNER` in `/etc/sysconfig/bestman2` to the new user.
-   User in `/etc/sudoers`. The last line (`bestman ALL(SRM_USR) NOPASSWD: SRM_CMD`) should be changed from `bestman` to the new user.
-   Ownership of `/var/log/bestman2`

!!! warning
    Currently the RPM packaging will change the ownership of the `/var/log/bestman2` directory back to `bestman` on upgrades.

(Optional) Modifying default logging for `event.srm.log`
--------------------------------------------------------

The logging directory (`/var/log/bestman2`) has two types of logs - `bestman2.log` and `event.srm.log`.

Log-rotation of `bestman2.log` file is controlled by `/etc/logrotate.d/bestman2` file.

By default, the size of `event.srm.log` log file is set to 50MB within the Bestman code itself.

Left unchanged, `event.srm.log` file counts will keep increasing indefinitely.  Depending on the usage, the number of these files can become high enough to fill up the partition that holds these logs.

There are 3 ways to avoid this -

-   Modify following parameters (commented by default) in the `/etc/sysconfig/bestman2` file

        :::shell
        # Number of files to keep
        BESTMAN_EVENT_LOG_COUNT=10
        # Size of each file in bytes
        BESTMAN_EVENT_LOG_SIZE=20971520

    The optimal value for these depends on usage of the service.

- Create a directory under a much bigger partition and have a symlink from `/var/log/bestman2` to that directory.
- Leave the default settings, but have your own custom script that cleans these files according to your needs.

Starting Services
=================

1. `fetch-crl`

    For RHEL 6:

        :::console
        [root@client ~] # /usr/sbin/fetch-crl   # This fetches the CRLs 
        [root@client ~] # /sbin/service fetch-crl-boot start
        [root@client ~] # /sbin/service fetch-crl-cron start

    For RHEL 7:

        :::console
        [root@client ~] # /usr/sbin/fetch-crl   # This fetches the CRLs 
        [root@client ~] # systemctl start fetch-crl-boot
        [root@client ~] # systemctl start fetch-crl-cron

2. GridFTP

        :::console
        [root@client ~] # service globus-gridftp-server start

3. Bestman

        :::console
        [root@client ~] # service bestman2 start

    To start Bestman automatically at boot time

        :::console
        [root@client ~] # chkconfig bestman2 on

4. Gratia transfer probe:

        :::console
        [root@client ~] # service gratia-gridftp-transfer start

Stopping Services
=================

1. fetch-crl

    For RHEL 6:

        :::console
        [root@client ~] # /usr/sbin/fetch-crl   # This fetches the CRLs
        [root@client ~] # /sbin/service fetch-crl-boot stop
        [root@client ~] # /sbin/service fetch-crl-cron stop

    For RHEL 7:

        :::console
        [root@client ~] # /usr/sbin/fetch-crl   # This fetches the CRLs
        [root@client ~] # systemctl stop fetch-crl-boot
        [root@client ~] # systemctl stop fetch-crl-cron

2. GridFTP

        :::console
        [root@client ~] # service globus-gridftp-server stop

3. Bestman

        :::console
        [root@client ~] # service bestman2 stop

4. Gratia transfer probe

        :::console
        [root@client ~] # service gratia-gridftp-transfer stop


Validation of Service Operation
===============================

Once you have your SE setup and configured, there are several ways to monitor your installation. Refer to the following pages for more information:

* [BeStMan SRM Tester](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/SrmTester).
* [RSV](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallRSV) which includes SRM probes as well.

You can also self-test to verify your installation with an SRM client such as `gfal-copy`.

Troubleshooting
===============

| Service/Process | Log File                          | Description                                   |
|:----------------|:----------------------------------|:----------------------------------------------|
| BeStMan2        | `/var/log/bestman2/bestman2.log`  | BeStMan2 server log and errors                |
|                 | `/var/log/bestman2/event.srm.log` | Records all SRM transactions                  |
| GridFTP         | `/var/log/gridftp.log`            | Transfer log                                  |
|                 | `/var/log/gridftp-auth.log`       | Authentication log                            |
|                 | `/var/log/messages`               | Main system log (look here for LCMAPS errors) |

Debugging Procedure
-------------------

If system validation failed, you would probably need to check each component in order to verify your installation. In order to do so, you should check all of them in the following order

-   GUMS (if in use)
-   GridFTP
-   BeStMan

### Verifying GUMS

Make sure that the service certificate you specified for BeStMan configuration with `GUMSHOSTCERT`, `GUMSHOSTKEY` options and GridFTP service certificate are accepted by GUMS.

Test GUMS by running:

```console
[root@client ~] # srm-ping srm://<BESTMAN_HOST>:8443/srm/v2/server
```

In the output, check that your `gumsIDMapped` is not `null`. It returns the `uid` that GUMS will map you to. This can be obtained from your GUMS administrator. Verify that this `uid` exists on BeStMan and GridFTP node.

### Verifying GridFTP

Login on the node where your certificate and [OSG Client](../client/wn.md) is installed You will need to generate your proxy credentials using `grid-proxy-init` or `voms-proxy-init`.

Then test GridFTP using `globus-url-copy`:

```console
[user@client ~] $ echo "This is a test" >/tmp/test 
[user@client ~] $ globus-url-copy -dbg file:///tmp/test gsiftp://<GRIDFTP_HOST>/tmp/test 
```
Check the GridFTP logs to see if you have encountered any errors.

### Verifying BeStMan

Make sure that the BeStMan process is running

```console
[root@client ~] # ps -ef | grep bestman
bestman   5121     1 99 19:59 ?        00:00:01 /usr/java/latest/bin/java -server -Xmx1024m -XX:MaxDirectMemorySize=1024m -DX509_CERT_DIR=/etc/grid-security/certificates -DCADIR=/etc/grid-security/certificates -Daxis.socketSecureFactory=org.glite.security.trustmanager.axis.AXISSocketFactory -DsslCAFiles=/etc/grid-security/certificates/*.0 -DsslCertfile=/etc/grid-security/bestman/bestmancert.pem -DsslKey=/etc/grid-security/bestman/bestmankey.pem -DJettyConfiguration=/etc/bestman2/conf/WEB-INF/jetty.xml -DJettyDescriptor=/etc/bestman2/conf/WEB-INF/web.xml -DJettyResource=/etc/bestman2/conf/ -Dorg.eclipse.jetty.util.log.IGNORE=true gov.lbl.srm.server.Server /etc/bestman2/conf/bestman2.rc
```

If `bestman2` is not running, check information in the log file **`/var/log/bestman2/bestman2.log`**.

Useful Configuration and Log Files
==================================

| Service/Process | Configuration File                               | Description                                                                                     |
|:----------------|:-------------------------------------------------|:------------------------------------------------------------------------------------------------|
| BeStMan2        | `/etc/bestman2/conf/bestman2.rc`                 | Main BeStMan2 configuration file                                                                |
|                 | `/etc/sysconfig/bestman2`                        | Environment variables used by BeStMan2                                                          |
|                 | `/etc/sysconfig/bestman2lib`                     | Environment variables that store values of various client and server libraries used by BeStMan2 |
|                 | `/etc/bestman2/conf/*`                           | Other runtime configuration files                                                               |
|                 | `/etc/init.d/bestman2`                           | init.d startup script                                                                           |
|                 | `/etc/gridftp.conf`                              | Startup parameters                                                                              |
| GridFTP         | `/etc/sysconfig/globus-gridftp-server`           | Environment variables for GridFTP                                                               |
| Gratia Probe    | `/etc/gratia/gridftp-transfer/ProbeConfig`       | GridFTP Gratia Probe configuration                                                              |
|                 | `/etc/cron.d/gratia-probe-gridftp-transfer.cron` | Cron tab file                                                                                   |

| Service/Process | Log File                          | Description                                   |
|:----------------|:----------------------------------|:----------------------------------------------|
| BeStMan2        | `/var/log/bestman2/bestman2.log`  | BeStMan2 container log                        |
|                 | `/var/log/bestman2/event.srm.log` | Records all SRM transactions                  |
| GridFTP         | `/var/log/gridftp.log`            | Transfer log                                  |
|                 | `/var/log/gridftp-auth.log`       | GridFTP authorization log                     |
|                 | `/var/log/messages`               | Main system log (look here for LCMAPS errors) |
| Gratia probe    | `/var/log/gratia`                 |                                               |

Upgrading BeStMan
=================

Upgrading BeStMan can be done by

```console
[root@client ~] # yum upgrade bestman2-server
```

There are a few notes to be aware of when upgrading BeStMan.

-   From many of the versions of the BeStMan, configuration changes have taken place. Do not ignore any warnings about rpmsave or rpmnew files. You will need to especially be careful about and `/etc/bestman2/conf/bestman2.rc`.
-   Beginning with BeStMan 2.3.0-9, many dependency locations changed. Be sure that `/etc/sysconfig/bestman2lib` contains the `build-classpath` directives in the `BESTMAN2_SERVER_LIB` and `BESTMAN2_CLIENT_LIB`. Otherwise, you may get java class loading errors on startup or on run-time. Be sure to remove these entries from the `/etc/sysconfig/bestman2` file.
-   For BeStMan 2.1.3, certain versions had a combined sysconfig and configuration file. You may need to split these files apart if this is the case.

For more help, please contact the GOC to create a support ticket.

How to get Help?
================

If you cannot resolve the problem, there are several ways to receive help:

-   For bug support and issues, submit a ticket to the [Grid Operations Center](https://ticket.grid.iu.edu/goc).
-   For community support and best-effort software team support contact <osg-software@opensciencegrid.org>.

For a full set of help options, see the [Help Procedure](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/HelpProcedure).

References
==========

* [Storage infrastructure software](https://twiki.grid.iu.edu/bin/view/Documentation/StorageInfrastructureSoftware)
* [Information on planning, installing and validating storage software](https://twiki.grid.iu.edu/bin/view/Documentation/StorageSiteAdministrator)
* [Tips and FAQ](https://twiki.grid.iu.edu/bin/view/Storage/SEToolsTipsFAQs)
* [OSG Gratia Transfer Probe page](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/GratiaTransferProbe)
* [SRM v2.2 LBNL client command line examples](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/LbnlSrmClient)
* [SRM-Tester](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/SrmTester)
* [BeStMan official website](http://sdm.lbl.gov/bestman)
    * [BeStMan User guides](http://sdm.lbl.gov/bestman/docs/bestman-guide.html)
    * [BeStMan FAQ](http://sdm.lbl.gov/bestman/docs/bestman-faq.html)
* [SLAC Gateway mode Instruction](http://wt2.slac.stanford.edu/xrootdfs/bestman-gateway.html) - SLAC guide on gateway mode
* [US ATLAS instruction page](http://www.usatlas.bnl.gov/twiki/bin/view/Admins/BestMan)
* [SRM specifications and collaboration](http://sdm.lbl.gov/srm-wg) - from SRM collaboration working group
* [S2](http://s-2.sourceforge.net/) - A SRM v2.2 test suite from CERN. It provides basic functionality tests based on use cases, and cross-copy tests, as part of the certification process and supports file access/transfer protocols: rfio, dcap, gsidcap, gsiftp
* [SHA-2 compliance page](https://opensciencegrid.github.io/technology/projects/sha2-support/)
* [Bestman scalability tuning](https://sdm.lbl.gov/twiki/bin/view/Software/BeStMan/BeStMan2Guide/ScalabilityNotes)

Known Issues
============

Requesting host certificates in RHEL6
------------------------------------

Bestman may not start if the certificates were requested on slc6. This is be caused by a bug in JGlobus (see [JGlobusIssue118](https://github.com/jglobus/JGlobus/issues/118)), a `bestman2` dependency. A known workaround is to run this command

```console
[user@client ~] $ openssl rsa -in mykey.pem -out mykey.pem.old
```

This command on converts `mykey.pem` to `mykey.pem.old`; the latter format is supported.

