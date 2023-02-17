title: Installing the OSDF Origin
DateReviewed: 2022-12-16

Installing the OSDF Origin
================================

This document describes how to install an Open Science Data Federation (OSDF) origin service.  This service allows an organization
to export its data to the data federation.

!!! note
    The OSDF Origin was previously named "Stash Origin" and some documentation and software may use the old name.

!!! note
    The _origin_ must be registered with the OSG prior to joining the data federation. You may start the
    registration process prior to finishing the installation by [using this link](#registering-the-origin) 
    along with information like:

    * Resource name and hostname
    * VO associated with this origin server (which will be used to determine the origin's namespace prefix)
    * Administrative and security contact(s)
    * Who (or what) will be allowed to access the VO's data
    * Which caches will be allowed to cache the VO data

Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 7 or RHEL 8 or compatible operating systems.
* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and `xrootd`;
  only the `xrootd` user is utilized for the running daemons.
* __Host certificate:__ Required for authentication.
  See our [host certificate documentation](../../security/host-certs.md) for instructions on how to request and install host certificates.
* __Network ports:__ The origin service requires the following ports open:
  * Inbound TCP port 1094 for unauthenticated file access via the XRoot or HTTP protocols (if serving public data)
  * Inbound TCP port 1095 for authenticated file access via the XRoot or HTTPS protocols (if serving authenticated data)
  * Outbound TCP port 1213 to `redirector.osgstorage.org` for connecting to the data federation
  * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring.
* __Hardware requirements:__ We recommend that an origin has at least 1Gbps connectivity and 8GB of RAM.
  We suggest that several gigabytes of local disk space be available for log files,
  although some logging verbosity can be reduced.

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Obtain root access to the host
* Prepare [the required Yum repositories](../../common/yum.md)
* Install [CA certificates](../../common/ca.md)

!!! note
    This document describes features introduced in XCache 3.2.2, released on 2022-09-29.
    When installing, ensure that your version of the `stash-origin` RPM is at least 3.2.2.


Installing the Origin
---------------------

The origin service consists of one or more XRootD daemons and their dependencies for the authentication infrastructure.
To simplify installation, OSG provides convenience RPMs that install all required
software with a single command:

```console
root@host # yum install stash-origin
```

For this installation guide, we assume that the data to be exported to the federation is mounted at `/mnt/stash`
and owned by the `xrootd:xrootd` user.

Configuring the Origin Server
-----------------------------

The `stash-origin` package provides a default configuration files in
`/etc/xrootd/xrootd-stash-origin.cfg` and `/etc/xrootd/config.d`.
Administrators may provide additional configuration by placing files in `/etc/xrootd/config.d`
of the form `/etc/xrootd/config.d/1*.cfg` (for directives that need to be processed BEFORE the OSG configuration)
or `/etc/xrootd/config.d/9*.cfg` (for directives that are processed AFTER the OSG configuration).

You _must_ configure every variable in `/etc/xrootd/config.d/10-common-site-local.cfg` and `/etc/xrootd/config.d/10-origin-site-local.cfg`.

The mandatory variables to configure are:

| File                     | Config line                             | Description                                                                                           |
|--------------------------|-----------------------------------------|-------------------------------------------------------------------------------------------------------|
| 10-common-site-local.cfg | `set rootdir = /mnt/stash`              | The mounted filesystem path to export; this document calls it `/mnt/stash`                            |
| 10-common-site-local.cfg | `set resourcename = YOUR_RESOURCE_NAME` | The resource name registered with OSG                                                                 |
| 10-origin-site-local.cfg | `set PublicOriginExport = /VO/PUBLIC`   | The directory relative to `rootdir` that is the top of the exported namespace for public (unauthenticated) origin services |
| 10-origin-site-local.cfg | `set AuthOriginExport = /VO/PUBLIC`     | The directory relative to `rootdir` that is the top of the exported namespace for authenticated origin services |

For example, if the HCC VO would like to set up an origin server exporting from the mount point `/mnt/stash`,
and HCC has a public registered namespace at `/hcc/PUBLIC`, then the following would be set in `10-common-site-local.cfg`:

```
set rootdir = /mnt/stash
set resourcename = HCC_OSDF_ORIGIN
```

And the following would be set in `10-origin-site-local.cfg`:
```
set PublicOriginExport = /hcc/PUBLIC
```

With this configuration, the data under `/mnt/stash/hcc/PUBLIC/bio/datasets` would be available under the path
`/hcc/PUBLIC/bio/datasets` in the OSDF namespace and the data under `/mnt/stash/hcc/PUBLIC/hep/generators` would be available under the path
`/hcc/PUBLIC/hep/generators` in the OSDF namespace.

If the HCC has a protected registered namespace at `/hcc/PROTECTED` then set the following in `10-origin-site-local.cfg`:
```
set AuthOriginExport = /hcc/PROTECTED
```
If you are serving public data from the origin, you must set `PublicOriginExport` and use the `xrootd@stash-origin` service.
If you are serving protected data from the origin, you must set `AuthOriginExport` and use the `xrootd@stash-origin-auth` service.

!!! warning
    The OSDF namespace is a *global* namespace.
    Directories you export **must not** collide with directories provided by other origin servers; this is
    why the explicit registration is required.


Manually Setting the FQDN (optional)
------------------------------------
The FQDN of the origin server that you registered in [Topology](#registering-the-origin) may be different than its internal hostname
(as reported by `hostname -f`).
For example, this may be the case if your origin is behind a load balancer such as LVS or MetalLB.
In this case, you must manually tell the origin services which FQDN to use for topology lookups.

1.  Create the file `/etc/systemd/system/stash-origin-authfile.service.d/override.conf`
    with the following contents:
   
        :::ini
        [Service]
        Environment=ORIGIN_FQDN=<Topology-registered FQDN>


Managing the Origin Services
----------------------------
Serving data for an origin is done by the `xrootd` daemon.
There can be multiple instances of `xrootd`, running on different ports.
The instance that serves unauthenticated data will run on port 1094.
The instance that serves authenticated data will run on port 1095.
If your origin serves both authenticated and unauthenticated data, you will run both instances.

The origin services consist of the following SystemD units that you must directly manage:

| **Service name** | **Notes** |
|------------------|-----------|
| `xrootd@stash-origin.service` | Performs data transfers (unauthenticated instance) |
| `xrootd@stash-origin-auth.service` | Performs data transfers (authenticated instance) |

These services must be managed with `systemctl` and may start additional services as dependencies.
As a reminder, here are common service commands (all run as `root`):

| To...                                   | Run the command...                 |
| :-------------------------------------- | :--------------------------------- |
| Start a service                         | `systemctl start <SERVICE-NAME>`   |
| Stop a service                          | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>` |

In addition, the origin service automatically uses the following SystemD units:

| **Service name** | **Notes** |
|------------------|-----------|
| `cmsd@stash-origin.service` | Integrates the origin into the data federation (unauthenticated instance) |
| `cmsd@stash-origin-auth.service` | Integrates the origin into the data federation (authenticated instance) |
| `stash-origin-authfile.timer` | Updates the authorization files periodically |

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

```console hl_lines="1"
[user@server ~]$ xrdmapc -r --verify --list s redirector.osgstorage.org:1094 <EXPORTED DIR>
0*rv* redirector.osgstorage.org:1094
  >+  Srv ceph-gridftp1.grid.uchicago.edu:1094
   ?  Srv stashcache.fnal.gov:1094 [not authorized]
  >+  Srv stash.osgconnect.net:1094
   -  Srv origin.ligo.caltech.edu:1094
   ?  Srv csiu.grid.iu.edu:1094 [connect error]
```
Change `<EXPORTED_DIR>` for the directory the service is suppose to export.
Your server should be marked with a `>+` to indicate that it contains the given path and the path was accessible.


### Testing file access (unauthenticated origin)

To verify that you can download a file from the origin server, use the `stashcp` tool,
which is available in the `stashcp` RPM.
Place a `<TEST FILE>` in `<EXPORTED DIR>`, where `<TEST FILE>` can be any file in a publicly accessible path.
Run the following command:

```console
[user@host]$ stashcp <TEST FILE> /tmp/testfile
```
<!-- ^ note the unicode space ' ' between "test" and "file" to fix syntax highlighting
       (because it thinks "test" is a keyword)
--->

If successful, there should be a file at `/tmp/testfile` with the contents of the test file on your origin server.
If unsuccessful, you can pass the `-d` flag to `stashcp` for debug info.

You can also test directly downloading from the origin via `xrdcp`, which is available in the `xrootd-client` RPM.
Run the following command:

```console
[user@host]$ xrdcp xroot://<origin server>:1094/<TEST FILE> /tmp/testfile
```


### Testing file access (authenticated origin)

In order to download files from the origin, caches must be able to access the origin via SSL certificates.
To test SSL authentication, use the `curl` command.
Place a `<TEST FILE>` in `<EXPORTED DIR>`, where `<TEST FILE>` can be any file in a protected location.
As root on your origin, run the following command:

```console
[root@host]# curl --cert /etc/grid-security/hostcert.pem \
                  --key /etc/grid-security/hostkey.pem \
                  https://<origin server>:1095/<TEST FILE> \
                  -o /tmp/testfile
```
If successful, there should be a file at `/tmp/testfile` with the contents of the test file on your origin server.

!!! note
    This test requires including the DN of your origin in your origin's [OSG Topology registration](#registering-the-origin).


To verify that a user can download a file from the origin server, use the `stashcp` tool,
which is available in the `stashcp` RPM.
Obtain a credential (a SciToken or WLCG Token, depending on your origin's configuration).
Place a `<TEST FILE>` in `<EXPORTED DIR>`, where `<TEST FILE>` can be any file in a path you expect to be accessible
using the credential you just obtained.
Run the following command:

```console
[user@host]$ stashcp <TEST FILE> /tmp/testfile
```
<!-- ^ note the unicode space ' ' between "test" and "file" to fix syntax highlighting
       (because it thinks "test" is a keyword)
--->

If successful, there should be a file at `/tmp/testfile` with the contents of the test file on your origin server.
If unsuccessful, you can pass the `-d` flag to `stashcp` for debug info.


Registering the Origin
----------------------
To be part of the Open Science Data Federation, your origin must be
[registered with the OSG](../../common/registration.md).  The service type is `XRootD origin server`.

The resource must also specify which VOs it will serve data from.
To do this, add an `AllowedVOs` list, with each line specifying a VO whose data the resource is willing to host.
For example:
```yaml
  MY_OSDF_ORIGIN:
    Services:
      XRootD origin server:
        Description: OSDF origin server
    AllowedVOs:
      - GLOW
      - OSG
    DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=my-osdf-origin.example.net

```
You can use the special value `ANY` to indicate that the origin will serve data from any VO that puts data on it.

In addition to the origin allowing a VOs via the `AllowedVOs` list,
that VO must also allow the origin in one of its `AllowedOrigins` lists in `DataFederation/StashCache/Namespaces`.
See the page on [getting your VO's data into OSDF](vo-data.md).

Specifying the DN of your origin is not required but it is useful for testing.

Updating to OSG 3.6
-------------------

The OSG 3.5 series reached end-of-life on May 1, 2022.
Admins are strongly encouraged to move their origins to OSG 3.6.

See [general update instructions](../../release/updating-to-osg-36.md).

Unauthenticated origins (`xrootd@stash-origin` service) do not need any configuration changes.

Authenticated origins (`xrootd@stash-origin-auth` service) may need the configuration changes described in the
[updating to OSG 3.6 section](../xrootd/xrootd-authorization.md#updating-to-osg-36)
of the XRootD authorization configuration document.

Getting Help
------------

To get assistance, please use the [this page](../../common/help.md).
