# StashCache Cache Installation Guide

This document describes how to install a StashCache cache service. The installation utilizes XRootD and HTCondor for file storage and monitoring, respectively.
The role of **"cache"** server is to keep data cached and immediately available (via [stashcp](https://support.opensciencegrid.org/support/solutions/articles/12000002775-transferring-data-with-stashcach) or CVMFS) within Stash federation (without re-transferring from "origin").

## Installation prerequisites for Cache

Before starting the installation process, consider the following mandatory points:

* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and `xrootd`
* __Host certificate:__ The StashCache server uses a host certificate to advertise to a central collector.  More information on how to retrieve a certificate can be found [here](/security/host-certs.md)
* __Network ports:__ The StashCache service must listen on ports:
    * XRootD service on port `1094 (TCP)`
    * and allow XRootD service over HTTP on port `8000 (TCP)`
* __Hardware requirements:__ We recommend that a StashCache server has at least 10Gbps connectivity, 1TB of disk space, and 8GB of RAM. 

If installing the (optional) authenticated StashCache, you need to do in addition the following:

* __Service certificate:__ create copy of the host certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
    * set owner of the directory `/etc/grid-security/xrd/` to `xrootd:xrootd` user:
    
            :::console
            root@host # chown -R xrootd:xrootd /etc/grid-security/xrd/

* __Network ports__: allow connections on port `8443 (TCP)` 

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Ensure the host has [a supported operating system](/release/supported_platforms.md)
* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)

## Installing the StashCache metapackage

The StashCache daemon consists of an XRootD server and an HTCondor-based service for collecting and reporting statistics about the cache. To simplify installation, OSG provides convenience RPMs that install all required software with a single command:

```console
root@host # yum install stashcache-daemon fetch-crl stashcache-cache-server
```

!!! note 
    If installing authenticated StashCache Cache server, you need additional packages to be installed:
        
        :::console
        root@host # yum install xrootd-lcmaps globus-proxy-utils


Mount the disk that will be used for the cache data to */stash* and set owner of the directory to `xrootd:xrootd` user.  


## Configuring Cache Server

The following section describes required configuration to have a functional non-authenticated StashCache Cache (not origin server!). StashCache Cache package `stashcache-cache-server` needs to be manually configured from pre-existing XRootD configuration.

### Cache server
!!! note
    While example of the configuration file below provides combination of _authenticated_ and _non-authenticated_ _Cache_, the non-authenticated cache is considered to be default and authenticated cache just optional (additional) service.

For configuring **cache** one needs to define directive `pss.origin redirector.osgstorage.org:1024` (not `all.manager redirector.osgstorage.org+ 1213` directive as it is in case of [configuring origin](install-origin.md)). 
`StashCache-daemon` package provides default configuration file `/etc/xrootd/xrootd-stashcache-cache-server.cfg`. Example of the configuration of cache server is as follows:
```
all.export  /
set cachedir = /stash
xrd.allow host *
sec.protocol  host
all.adminpath /var/spool/xrootd

xrootd.trace emsg login stall redirect
ofs.trace all
xrd.trace all
cms.trace all

ofs.osslib  libXrdPss.so
pss.origin redirector.osgstorage.org:1094
pss.cachelib libXrdFileCache.so
pss.setopt DebugLevel 1

oss.localroot $(cachedir)

# Config for v1 (xrootd <=v4.5.0)
#pfc.nramprefetch 4
#pfc.nramread 4
#pfc.diskusage 0.98 0.99

# Config for v2 (xrootd >v4.5.0)
pfc.blocksize 512k
pfc.ram       32g
pfc.prefetch  10
pfc.diskusage 0.98 0.99

xrootd.seclib /usr/lib64/libXrdSec.so
sec.protocol /usr/lib64 gsi \
  -certdir:/etc/grid-security/certificates \
  -cert:/etc/grid-security/xrd/xrdcert.pem \
  -key:/etc/grid-security/xrd/xrdkey.pem \
  -crl:1 \
  -authzfun:libXrdLcmaps.so \
  -authzfunparms:--lcmapscfg,/etc/xrootd/lcmaps.cfg,--loglevel,4|useglobals \
  -gmapopt:10 \
  -authzto:3600

# Enable the authorization module, even if we have an unauthenticated instance.
ofs.authorize 1
acc.audit deny grant

# Run the authenticated instance on port 8443 (Xrootd and HTTPS)
# Notice authenticated and unauthenticated instances use separate auth
# files.
if named stashcache-cache-server-auth
   #pss.origin  red-gridftp4.unl.edu:1094
   xrd.port 8443
   acc.authdb /etc/xrootd/Authfile-auth
   sec.protbind * gsi
   xrd.protocol http:8443 libXrdHttp.so
   pss.origin xrootd-local.unl.edu:1094
else
# Unauthenticated instance runs on port 1094 (Xrootd) and 8000 (HTTP/HTTPS)
   acc.authdb /etc/xrootd/Authfile-noauth
   #sec.protbind * none
   sec.protbind  * none
   xrd.protocol http:8000 libXrdHttp.so
fi

http.cadir /etc/grid-security/certificates
http.cert /etc/grid-security/xrd/xrdcert.pem
http.key /etc/grid-security/xrd/xrdkey.pem
http.secxtractor /usr/lib64/libXrdLcmaps.so
http.listingdeny yes
http.staticpreload http://static/robots.txt /etc/xrootd/stashcache-robots.txt

# Tune the client timeouts to more aggressively timeout.
pss.setopt ParallelEvtLoop 10
pss.setopt RequestTimeout 25
pss.setopt ConnectTimeout 25
pss.setopt ConnectionRetry 2

#Sending monitoring information
xrd.report uct2-collectd.mwt2.org:9931
xrootd.monitor all auth flush 30s window 5s fstat 60 lfn ops xfr 5 dest redir fstat info user uct2-collectd.mwt2.org:9930 dest fstat info user xrd-mon.osgstorage.org:9930

all.sitename Nebraska

# Optional configuration
# Remote debugging
xrootd.diglib * /etc/xrootd/digauth.cf
```

Some important lines to edit:

* `all.sitename Nebraska`: Edit to your local (arbitrary) site name.
* `set cachedir = /stash`: Edit to the directory that you wish to use for caching.

### Add Authfile for non-authenticated cache
In Authfile you want to allow local reads below `$(cachedir)` defined in the main config. Example of Authfile:

```console
root@host # cat /etc/xrootd/Authfile-noauth 
u * /user/ligo -rl / rl
```

### Add Robots file

```console
root@host # cat /etc/xrootd/stashcache-robots.txt 
User-agent: *
Disallow: /
```

### RHEL7
On RHEL7 system, you need to run following systemd unit:

* `systemctl start xrootd@stashcache-cache-server.service`

* `systemctl start condor.service`


## (Optional) Configure Authenticated Cache

Before you continue, make sure default Cache Server is configured in first place. Enabling authenticated cache is optional and additional to the default cache instance. This chapter describes all the steps needed. 

### Authenticated Cache server

Make sure you've in place following prerequisites from [install step here](#installation-prerequisites-for-cache):

* __Host certificate:__ create copy of the certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
    * Set owner of the directory `/etc/grid-security/xrd/` to `xrootd:xrootd` user:
    
            :::console
            root@host # chown -R xrootd:xrootd /etc/grid-security/xrd/
      
* __Network ports__: allow connections on port `8443 (TCP)` 

Now, create symbolic link to existing configuration file with `-auth` postfix:

```console
root@host # cd /etc/xrootd/
root@host # ln -s xrootd-stashcache-cache-server.cfg xrootd-stashcache-cache-server-auth.cfg
```

### RHEL7

On RHEL7 system, you need to configure and run following systemd units:
* `xrootd@stashcache-cache-server-auth.service`
* `xrootd-renew-proxy.service`
* `xrootd-renew-proxy.timer`
* `fetch-crl-cron`

#### Auth.service
1. Enable `xrootd@stashcache-cache-server-auth.service` instance:

        :::console
        root@host # systemctl enable xrootd@stashcache-cache-server-auth


2. Reload daemons:

        :::console
        root@host # systemctl daemon-reload


#### Proxy.service
1. Create the file with following content:

```console
root@host # cat /usr/lib/systemd/system/xrootd-renew-proxy.service
[Unit]
Description=Renew xrootd proxy

[Service]
User=xrootd
Group=xrootd
Type = oneshot
ExecStart = /bin/grid-proxy-init -cert /etc/grid-security/xrd/xrdcert.pem -key /etc/grid-security/xrd/xrdkey.pem -out /tmp/x509up_xrootd -valid 48:00

[Install]
WantedBy=multi-user.target
```

2. Reload daemons:

        :::console
        root@host # systemctl daemon-reload


#### Proxy.timer
1. Create the file with following content:

```console
root@host # cat /usr/lib/systemd/system/xrootd-renew-proxy.timer
[Unit]
Description=Renew proxy every day at midnight

[Timer]
OnCalendar=*-*-* 00:00:00
Unit=xrootd-renew-proxy.service

[Install]
WantedBy=multi-user.target
```

2. Enable timer:

        :::console
        root@host # systemctl enable xrootd-renew-proxy.timer


3. Start and check if timer is active and working:

        :::console
        root@host # systemctl start xrootd-renew-proxy.timer
        ...
        root@host # systemctl is-active xrootd-renew-proxy.timer
        active
        root@host # systemctl list-timers xrootd-renew-proxy*
        NEXT                         LEFT       LAST                         PASSED  UNIT                     ACTIVATES
        Thu 2017-05-11 00:00:00 CDT  54min left Wed 2017-05-10 00:00:01 CDT  23h ago xrootd-renew-proxy.timer xrootd-renew-proxy.service


4. Reload daemons:

        :::console
        root@host # systemctl daemon-reload


#### CRLs updates

It is very important to keep CRL list updated from cron:

1. Enable fetch-crl-cron

        :::console
        root@host # systemctl enable fetch-crl-cron

2. Start fetch-crl-cron

        :::console
        root@host # systemctl start fetch-crl-cron


3. Reload daemons:

        :::console
        root@host # systemctl daemon-reload


### Add Authfile for authenticated cache
Authfile for authenticated cache may differ from `/etc/xrootd/Authfile-noauth` defined in non-authenticated cache configuration. Example:

```console
root@host # cat /etc/xrootd/Authfile-auth 
g /osg/ligo /user/ligo r
u ligo /user/ligo lr / rl
```

When ready with configuration, you may [start](#managing-stashcache-and-associated-services) your StashCache Cache server.

## Optional configuration

### Adjust disk utilization
To adjust the disk utilization of your StashCache cache, modify the values of `pfc.diskusage` in `/etc/xrootd/xrootd-stashcache-cache-server.cfg`:
```
pfc.diskusage 0.98 .99
```
The first value and second values correspond to the low and high usage watermarks, respectively, in percentages. When the high watermark is reached, the XRootD service will automatically purge cache objects down to the low watermark.

### Enable remote debugging
This feature enables remote debugging via the `digFS` read-only file system, it's optional line in the config file that was created when configuring the cache:
```
xrootd.diglib * /etc/xrootd/digauth.cf
```
where `/etc/xrootd/digauth.cf` may have following content:
```
all allow host h=abc.org
all allow host h=*.xyz.edu
```

## Managing StashCache and associated services

Ensure that your `/stash` disk is mounted, and then start `xrootd` and `condor` service.

### Non-authenticated Cache server services
| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stashcache-cache-server.service` | RHEL7 |
| HTCondor | `condor.service` | RHEL7  |
| Fetch CRL | `fetch-crl-cron` | RHEL7 |

### Authenticated Cache server services
| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stashcache-cache-server-auth.service` | RHEL7 |
|  | `xrootd-renew-proxy.service` | RHEL7 |
|  | `xrootd-renew-proxy.timer` | RHEL7  |
| HTCondor | `condor.service` | RHEL7  |
| Fetch CRL | `fetch-crl-cron` | RHEL7 |

### Test Cache server reports to HTCondor collector
To verify that your cache is being monitored properly, run the following command:
```
user@host $ condor_status -any -l -const "Name==\"xrootd@`hostname`\""
```
Where `hostname` is the string returned by the hostname command. The output of the above command should provide an HTCondor ClassAd that details the status of your cache.

### Test CVMFS accessibility via Cache server
```
[user@client ~]$ curl -O http://cache_host:8000/user/dweitzel/public/blast/queries/query1
```

### Start/stop services
| **To...** | **Run the command...** | **Notes** |
|-----------|------------------------|-----------|
| Start a service | systemctl start SERVICE-NAME | RHEL7 |
| Stop a service | systemctl stop SERVICE-NAME | RHEL7 |
| Status | systemctl status SERVICE-NAME | RHEL7 | 
| Enable | systemctl enable SERVICE-NAME | RHEL7 |
