# Installation Guide

This document describes how to install a StashCache service (Origin or Cache). The installation utilizes XRootD and HTCondor for file storage and monitoring, respectively. The role of the Origin and Cache is different, following explanation may help to decide when would you need to install which:

* [StashCache cache](configure-cache.md): role of **"cache"** server is to keep data cached and immediately available (via [stashcp](https://support.opensciencegrid.org/support/solutions/articles/12000002775-transferring-data-with-stashcach) or CVMFS) within Stash federation (without re-transferring from "origin").
* [StashCache origin](configure-origin.md): **"origin"** is the authoritative data server that hosts files locally and serves them to users upon transfer request (via [stashcp](https://support.opensciencegrid.org/support/solutions/articles/12000002775-transferring-data-with-stashcach) or CVMFS) unless data are already cached.

---

## Installation prerequisites for Origin and Cache

Before starting the installation process, consider the following mandatory points:

* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs condor and xrootd
* __Service certificate:__ The StashCache server uses a host certificate to advertise to a central collector.  More information on how to receive a certificate can be found [here](/security/host-certs.md)
* __Network ports:__ The StashCache service must listen on ports:
    * XRootD service on port `1094 (TCP)`
    * and allow XRootD service over HTTP on port `8000 (TCP)`
* __Hardware requirements:__ We recommend that a StashCache server has at least 10Gbps connectivity, 1TB of disk space, and 8GB of RAM. 
    * More information about hardware and system configuration of existing caches you can find at [Upgrade status page](upgrades.md).

If installing the (optional) authenticated StashCache, you need to do in addition the following:

* __Service certificate:__ create copy of the certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
    * set owner of the directory `/etc/grid-security/xrd/` to `xrootd:xrootd` user:
    
            $ chown -R xrootd:xrootd /etc/grid-security/xrd/

* __Network ports__: allow connections on port `8443 (TCP)` 

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Ensure the host has [a supported operating system](/release/supported_platforms.md)
* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)

## Installing the StashCache metapackage

The StashCache daemon consists of an XRootD server and an HTCondor-based service for collecting and reporting statistics about the cache. To simplify installation, OSG provides convenience RPMs that install all required software with a single command:

* if you are installing __Origin server__:

        [root@client ~]$ yum install stashcache-daemon fetch-crl stashcache-cache-origin

* if you are installing __Cache server__:

        [root@client ~]$ yum install stashcache-daemon fetch-crl stashcache-cache-server
   

!!! note 
    If installing authenticated StashCache Cache server, you need additional packages to be installed:

        [root@client ~]$ yum install xrootd-lcmaps globus-proxy-utils


Mount the disk that will be used for the cache or origin data to */stash* and set owner of the directory to `xrootd:xrootd` user.  

Next, configure the [Cache](configure-cache.md) or [Origin](configure-origin.md) server.
