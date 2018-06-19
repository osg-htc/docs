# StashCache Origin Installation Guide

This document describes how to install a StashCache origin service. The installation utilizes XRootD and HTCondor for file storage and monitoring, respectively. 

## Installation prerequisites for Origin

Before starting the installation process, consider the following mandatory points:

* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and `xrootd`
* __Host certificate:__ The StashCache server uses a host certificate to advertise to a central collector.  More information on how to retrieve a certificate can be found [here](/security/host-certs.md)
* __Network ports:__ The StashCache service must listen on ports:
    * XRootD service on port `1094 (TCP)`
* __Hardware requirements:__ We recommend that a StashCache server has at least 10Gbps connectivity, 1TB of disk space, and 8GB of RAM. 

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Ensure the host has [a supported operating system](/release/supported_platforms.md)
* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)

## Installing the StashCache metapackage

The StashCache daemon consists of an XRootD server and an HTCondor-based service for collecting and reporting statistics about the cache. To simplify installation, OSG provides convenience RPMs that install all required software with a single command:

```console
root@host # yum install stashcache-daemon fetch-crl stashcache-cache-origin
```
   

Mount the disk that will be used for the origin data to */stash* and set owner of the directory to `xrootd:xrootd` user.  


# Configuring Origin Server

Packages installed: `stashcache-daemon fetch-crl stashcache-origin-server`

The following section describes required configuration to have a functional StashCache Origin (not cache server!). StashCache Origin package `stashcache-cache-origin` needs to be manually configured from pre-existing XRootD configuration.

## Origin server
The origin server connects only to a redirector (not directly to cache server), thus minimal xrootd configuration is required. `StashCache-daemon` package provides default configuration file `/etc/xrootd/xrootd-stashcache-origin-server.cfg`. Example of the configuration of origin server is as follows:
```
all.export /
set localroot = /stash
xrd.port 1094

all.role server
all.manager redirector.osgstorage.org+ 1213

oss.localroot $(localroot)
xrootd.trace emsg login stall redirect
ofs.trace none
xrd.trace conn
cms.trace all
sec.protocol  host
sec.protbind  * none
all.adminpath /var/spool/xrootd
all.pidpath /var/run/xrootd

# Sending monitoring information
xrd.report uct2-collectd.mwt2.org:9931
xrootd.monitor all auth flush 30s window 5s fstat 60 lfn ops xfr 5 dest redir fstat info user uct2-collectd.mwt2.org:9930
```

Important lines to edit:

* `set localroot = /stash`: Change to the directory you would like to serve.

### RHEL7
On RHEL7 system, you need to run following systemd units:
* `xrootd@stashcache-cache-origin.service`
* `cmsd@stashcache-cache-origin.service`


# Origin server services
| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stashcache-origin-server.service` | RHEL7 |
| XRootD | `cmsd@stashcache-origin-server.service` | RHEL7  |

## Test Origin server availability in Stash Federation
To verify that your origin is being subscribed to the redirector, run the following command:
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
The output should list hostname of your service. If not, look for any signs of trouble in the log files or contact us at `stashcache@opensciencegrid.org`.

## Start/stop services
| **To...** | **Run the command...** | **Notes** |
|-----------|------------------------|-----------|
| Start a service | systemctl start SERVICE-NAME | RHEL7 |
| Stop a service | systemctl stop SERVICE-NAME | RHEL7 |
| Status | systemctl status SERVICE-NAME | RHEL7 | 
| Enable | systemctl enable SERVICE-NAME | RHEL7 |
