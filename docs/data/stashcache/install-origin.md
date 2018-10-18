Installing the StashCache Origin
================================

This document describes how to install a StashCache origin service.  This service allows an organization
to export its data to the StashCache data federation.

!!! note
    The origin must be registered with the OSG prior to joining the data federation.  You may start the
    registration process prior to finishing the installation by contacting <support@opensciencegrid.org>
    with the following details:

    * Resource name and hostname.
    * VO associated with this origin server (will be used to determine the origin's namespace prefix).
    * Administrative and security contact.

    Follow the [registration documentation](/common/registration.md) for more information.

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
* __Network ports:__ The StashCache Origin service defaults to using inbound TCP port 1094.  Outbound
  connectivity to TCP `redirector.osgstorage.org:1213` and UDP `collector.opensciencegrid.org:9619` is
  required.
* __Hardware requirements:__ We recommend that a StashCache server has at least 10Gbps connectivity and 8GB of
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

For this installation guide, we assume that the data to be exported to the federation is mounted at */stash*
and owned by the `xrootd:xrootd` user.  

Configuring the Origin Server
-----------------------------

The `stashcache-daemon` package provides a default configuration file,
`/etc/xrootd/xrootd-stashcache-origin-server.cfg`, which must be customized for your origin.

The most common lines to customize are:

* `oss.remoteroot /`: A prefix that will be prepended to all exported filenames.  Must be set to `/$VONAME`
  for your VO.  May only be specified once.
* `set localroot = /stash`: Change the `localroot` to the location where your data is mounted on
  the origin server; default is `/stash`.
* `all.export /`: A sub-directory within the `localroot` directory that will be exported.  Customize
  if not all data within `localroot` should be exported; default is `/`.  If multiple directories must
  be exported, you may specify `all.export` multiple times.

For example, if the HCC VO would like to setup an origin server, exporting from the mountpoint `/mnt/bigdata`,
but only exporting the sub-directories `/mnt/bigdata/bio/datasets` and `/mnt/bigdata/hep/generators`, they
would use the following configuration:

```
oss.remoteroot /hcc
set localroot = /mnt/bigdata
all.export /bio/datasets
all.export /hep/generators
```

With this configuration, the data in `/mnt/bigdata/chemistry` would not be available via StashCache; the
contents in `/mnt/bigdata/bio/datasets` would be available under the StashCache path `/hcc/bio/datasets`.

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

Testing Origin server Availability
----------------------------------

Once your server has been registered with the OSG and started, it should subscribe to the OSG-wide
redirector service.  To verify that your origin is correctly advertising its availability, run the
following command:

```
[user@client ~]$ xrdmapc --list s redirector.opensciencegrid.org:1094 
0**** redirector.grid.iu.edu:1094
      Srv redirector1.grid.iu.edu:2094
      Srv csiu.grid.iu.edu:1094
      Srv stash.osgconnect.net:1094
      Srv stashcache.fnal.gov:1094
      Srv redirector2.grid.iu.edu:2094
      Srv ceph-gridftp1.grid.uchicago.edu:1094
```

The output should list hostname of your service. If not, look for any signs of trouble in the log files
or contact `support@opensciencegrid.org` for support.

<!-- TODO: include an example for downloading via `stashcp` -->
