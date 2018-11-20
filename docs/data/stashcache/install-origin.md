Installing the StashCache Origin
================================

This document describes how to install a StashCache origin service.  This service allows an organization
to export its data to the StashCache data federation.

!!! note
    The _origin_ must be registered with the OSG prior to joining the data federation. You may start the
    registration process prior to finishing the installation by [using this link](#registering-the-origin) 
    along with the basic information like:

    * Resource name and hostname.
    * VO associated with this origin server (will be used to determine the origin's namespace prefix).
    * Administrative and security contact.

    Detailed walkthrough of the process is described [here](#registering-the-origin). 

This guide covers the procedure for exporting world-readable data; publishing proprietary data is still
experimental.

Before Starting
---------------

Before starting the installation process, consider the following points:

* __Operating system:__ A RHEL 7 or compatible operating systems is **strongly** recommended.
    If you have special needs that require you to run your origin server on a RHEL 6-based host,
    contact us at support@opensciencegrid.org.
* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and `xrootd`
* __Host certificate:__ The StashCache server uses a host certificate to advertise to a central collector.
  The [host certificate documentation](/security/host-certs.md) provides more information on setting up host
  certificates.
* __Network ports:__ The StashCache Origin service requires the following ports open:
    * Inbound TCP port 1094 for file access via the XRootD protocol
    * Outbound TCP port 1213 to `redirector.osgstorage.org` for connecting to the data federation
    * Outbound UDP port 9619 for reporting to `collector1.opensciencegrid.org` and `collector2.opensciencegrid.org`
* __Hardware requirements:__ We recommend that a StashCache origin has at least 1Gbps connectivity and 8GB of
  RAM.  We suggest that several gigabytes of local disk space be available for log files.

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Ensure the host has [a supported operating system](/release/supported_platforms.md).
  A RHEL 7-based operating system is strongly recommended.
* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)

Installing the StashCache origin
--------------------------------

The StashCache daemon consists of an XRootD server and an HTCondor-based service for collecting and reporting
monitoring data about the origin. To simplify installation, OSG provides convenience RPMs that install all required
software with a single command:

```console
root@host # yum install stashcache-origin-server
```

For this installation guide, we assume that the data to be exported to the federation is mounted at `/stash`
and owned by the `xrootd:xrootd` user.

Configuring the Origin Server
-----------------------------

The `stashcache-daemon` package provides a default configuration file,
`/etc/xrootd/xrootd-stashcache-origin-server.cfg`, which must be customized for your origin.

The most common lines to customize are:

* `oss.localroot /stash`: Change the `localroot` to the location where your data is mounted on
  the origin server; default is `/stash`.
* `all.export /<YOUR VO>`: A sub-directory within the `localroot` directory that will be exported.
  If multiple directories must be exported, you may specify `all.export` multiple times.

For example, if the HCC VO would like to set up an origin server exporting from the mountpoint `/mnt/bigdata`,
but only export the subdirectories `/mnt/bigdata/hcc/bio/datasets` and `/mnt/bigdata/hcc/hep/generators`,
they would use the following configuration:

```
oss.localroot /mnt/bigdata
all.export /hcc/bio/datasets
all.export /hcc/hep/generators
```

With this configuration, the data under `/mnt/bigdata/hcc/bio/datasets` would be available under the StashCache path
`/hcc/bio/datasets`, the data under `/mnt/bigdata/hcc/hep/generators` would be available under the StashCache path
`/hcc/hep/generators`, and no other data would be available via StashCache.

!!! warning
    The StashCache namespace is *global* within a data federation.
    Directories you export **must not** collide with directories provided by other origin servers.

    The best way to do this is to create a directory named after your VO or project,
    place all files you want to distribute within that directory,
    and export only that directory or its subdirectories.



Managing the Origin Service
---------------------------
The origin service consists of the following systemd units:

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stashcache-origin-server.service` | The xrootd daemon, which performs the data transfers |
| XRootD | `cmsd@stashcache-origin-server.service` | The "cluster management service" daemon, which integrates the origin into the data federation.  |
| Fetch CRL         | `fetch-crl-boot` and `fetch-crl-cron` | See [CA documentation](/common/ca#managing-fetch-crl-services) for more info |

These services must be managed with `systemctl`.  As a reminder, here are common service commands (all run as `root`):

| To...                                   | On EL7, run the command...         |
| :-------------------------------------- | :--------------------------------- |
| Start a service                         | `systemctl start <SERVICE-NAME>`   |
| Stop a  service                         | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>` |


Verifying the Origin Server
---------------------------

Once your server has been registered with the OSG and started,
perform the following steps to verify that it is functional.


### Testing availability

To verify that your origin is correctly advertising its availability, run the following command from the origin server:

```console
[user@server ~]$ xrdmapc -r --list s redirector.osgstorage.org:1094
0**** redirector.osgstorage.org:1094
      Srv ceph-gridftp1.grid.uchicago.edu:1094
      Srv stashcache.fnal.gov:1094
      Srv stash.osgconnect.net:1094
      Srv origin.ligo.caltech.edu:1094
      Srv csiu.grid.iu.edu:1094
```

The output should list the hostname of your origin server.


### Testing directory export

To verify that the directories you are exporting are visible from the redirector,
run the following command from the origin server:

```console
[user@server ~]$ xrdmapc -r --verify --list s redirector.osgstorage.org:1094 %RED%<exported dir>%ENDCOLOR%
0*rv* redirector.osgstorage.org:1094
  >+  Srv ceph-gridftp1.grid.uchicago.edu:1094
   ?  Srv stashcache.fnal.gov:1094 [not authorized]
  >+  Srv stash.osgconnect.net:1094
   -  Srv origin.ligo.caltech.edu:1094
   ?  Srv csiu.grid.iu.edu:1094 [connect error]
```

Your server should be marked with a `>+` to indicate that it contains the given path and the path was accessible.


### Testing file access

To verify that you can download a file from the origin server, use the `stashcp` tool.
Place a test file in the exported dir.
`stashcp` is available in the `stashcache-client` RPM.
Run the following command:

```console
[user@host]$ stashcp %RED%<test file>%ENDCOLOR% /tmp/testfile
```
<!-- ^ note the unicode space ' ' between "test" and "file" to fix syntax highlighting
       (because it thinks "test" is a keyword)
--->

If successful, there should be a file at `/tmp/testfile` with the contents of the test file on your origin server.
If unsuccessful, you can pass the `-d` flag to `stashcp` for debug info.


Registering the Origin
----------------------
To be part of the OSG StashCache Federation, your _origin_ must be
[registered with the OSG](https://github.com/opensciencegrid/topology#topology).
To register your resource:

1. Identify the facility, site, and resource group where your _origin_ is hosted.
   For example, the LIGO-Caltech uses the following information:

```
Disable: false
Production: true
GroupDescription: XRootD Origin Server for LIGO in OSG StashCache Federation
GroupID: 485 
Resources:
  CIT_LIGO_ORIGIN:
    ContactLists:
      Administrative Contact:
        Primary:
          Name: Stuart Anderson
          ID: c50e7cc9d0086272ef995fb76461612d40c70435
      Security Contact:
        Primary:
          Name: Stuart Anderson
          ID: c50e7cc9d0086272ef995fb76461612d40c70435
      Resource Report Contact:
        Primary:
          Name: Stuart Anderson
          ID: c50e7cc9d0086272ef995fb76461612d40c70435
    FQDN: origin.ligo.caltech.edu
    ID: 948
    Services:
      XRootD origin server:
        Description: StashCache Origin server
SupportCenter: Advanced LIGO
```

!!! warning
    The contact person should be listed in the OSG topology [contacts list](https://topology.opensciencegrid.org/contacts). 
    If the person or the resource are completely new (e.g. ID and/or GroupID doesn't exist), 
    you should consider to follow [main OSG registration documentation](/common/registration.md).

1. Using the above information, [create or update](https://github.com/opensciencegrid/topology#how-to-register) the
   appropriate YAML file, using [this template](https://github.com/opensciencegrid/topology/blob/master/template-resourcegroup.yaml)
   as a guide.

1. Update information of your resource (longitute/latitude included) in the [stashcp.json](https://github.com/opensciencegrid/StashCache/blob/master/bin/caches.json) by opening pull request.
   In order to identify GeoIP information you can use the following tool provided by [MAXMIND](https://www.maxmind.com/en/geoip-demo).  

Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact directly <support@opensciencegrid.org>.
