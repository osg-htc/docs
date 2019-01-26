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

    Additionally, if this is the first origin for the VO, you will need to decide on what identities are
    allowed to access the VO's data, as well as which caches are allowed to cache the VO data.

Before Starting
---------------

Before starting the installation process, consider the following points:

* __Operating system:__ A RHEL 7 or compatible operating system.
* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and `xrootd`;
  only the `xrootd` user is utilized for the running daemons.
* __Host certificate:__ The StashCache server uses a host certificate to authenticate with the caches it serves.
  The [host certificate documentation](/security/host-certs.md) provides more information on setting up host
  certificates.
* __Network ports:__ The StashCache Origin service requires the following ports open:
    * Inbound TCP port 1094 for file access via the XRootD protocol
    * Outbound TCP port 1213 to `redirector.osgstorage.org` for connecting to the data federation
    * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring.
* __Hardware requirements:__ We recommend that a StashCache origin has at least 1Gbps connectivity and 8GB of
  RAM.  We suggest that several gigabytes of local disk space be available for log files, although some logging verbosity
  can be reduced.

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)

Installing the origin
---------------------

The origin service consists of an XRootD daemons and its dependencies for the authentication infrastructure.
To simplify installation, OSG provides convenience RPMs that install all required
software with a single command:

```console
root@host # yum install --enablerepo=osg-development stash-origin
```

!!! note
    This document covers a completely overhauled stash origin service that depends on XRootD 4.9.0; while this
    has not yet been released into the OSG production repository, we strongly recommend using this version.

For this installation guide, we assume that the data to be exported to the federation is mounted at `/stash`
and owned by the `xrootd:xrootd` user.

Configuring the Origin Server
-----------------------------

The `stash-origin` package provides a default configuration files in
`/etc/xrootd/xrootd-stash-origin.cfg` and `/etc/xrootd/config.d`.  Administrators may provide additional configuration
by placing files in `/etc/xrootd/config.d` of the form `/etc/xrootd/config.d/1*.cfg` (for directives that need to
be processed BEFORE the OSG configuration) or `/etc/xrootd/config.d/9*.cfg` (for directives that are processed
AFTER the OSG configuration).

All _mandatory_ configuration that the admin must make is in `/etc/xrootd/config.d/10-origin-site-local.cfg`; EVERY
directive there must be configured.

The three mandatory directives that must be customized are:

* `origindir`: the mounted filesystem path to export.  This document refers to this as `/stash`.
* `originexport`: the file within the `origindir` to export.  This MUST be in your supported VO's registered namespace.
* `sitename`: the resource name registered with OSG.

For example, if the HCC VO would like to set up an origin server exporting from the mountpoint `/mnt/bigdata`,
but HCC's registered namespace is `/hcc`, then the following would be set:

```
set origindir = /mnt/bigdata
set originexport = /hcc
set sitename = HCC_STASH_ORIGIN
```

With this configuration, the data under `/mnt/bigdata/hcc/bio/datasets` would be available under the StashCache path
`/hcc/bio/datasets` and the data under `/mnt/bigdata/hcc/hep/generators` would be available under the StashCache path
`/hcc/hep/generators`.

!!! warning
    The StashCache namespace is *global* within a data federation.
    Directories you export **must not** collide with directories provided by other origin servers; this is
    why the explicit registration is required.


Managing the Origin Service
---------------------------
The origin service consists of the following systemd units:

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stash-origin.service` | The xrootd daemon, which performs the data transfers |
| XRootD | `xrootd@stash-origin-auth.service` | The xrootd daemon, which performs authenticated data transfers |
| XRootD | `cmsd@stashcache-origin-server.service` | The "cluster management service" daemon, which integrates the origin into the data federation.  |

These services must be managed with `systemctl` and may start additional services as dependencies.  As a reminder, here are common service commands (all run as `root`):

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
To be part of the OSG StashCache Federation, your _cache_ must be
[registered with the OSG](/common/registration.md).  The service type is "XRootD origin server"


Getting Help
------------

To get assistance, please use the [this page](/common/help) or contact directly <support@opensciencegrid.org>.
