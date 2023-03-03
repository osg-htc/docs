title: Installing the OSDF Cache

Installing the OSDF Cache
=========================

This document describes how to install an Open Science Data Federation (OSDF) cache service.  This service allows a site or regional
network to cache data frequently used on the OSG, reducing data transfer over the wide-area network and
decreasing access latency.

!!! note
    The OSDF cache was previously named "Stash Cache" and some documentation and software may use the old name.

Before Starting
---------------

Before starting the installation process, consider the following requirements:

* __Operating system:__ Ensure the host has [a supported operating system](../../release/supported_platforms.md)
* __User IDs:__ If they do not exist already, the installation will create the Linux user IDs `condor` and
  `xrootd`
* __Host certificate:__ Required for authentication.
  See our [host certificate documentation](../../security/host-certs.md) for instructions on how to request and install host certificates.
* __Network ports:__ Your host may run a public cache instance (for serving public data only), an authenticated cache instance (for serving protected data), or both.
    
    * A public cache instance requires the following ports open:
        * Inbound TCP port 1094 for file access via the XRootD protocol
        * Inbound TCP port 8000 for file access via HTTP(S)
        * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring
    * An authenticated cache instance requires the following ports open:
        * Inbound TCP port 8443 for authenticated file access via HTTPS
        * Outbound UDP port 9930 for reporting to `xrd-report.osgstorage.org` and `xrd-mon.osgstorage.org` for monitoring
* __Hardware requirements:__ We recommend that a cache has at least 10Gbps connectivity, 1TB of
 disk space for the cache directory, and 12GB of RAM.

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Obtain root access to the host
* Prepare [the required Yum repositories](../../common/yum.md)
* Install [CA certificates](../../common/ca.md)

!!! note
    This document describes features introduced in XCache 3.3.0, released on 2022-12-08.
    When installing, ensure that your version of the `stash-cache` RPM is at least 3.3.0.

<!-- NOTE: Keep the "Registering the Cache" section below in sync with run-stashcache-container.md -->

Registering the Cache
---------------------

To be part of the OSDF, your cache must be registered with the OSG.
You will need basic information like the resource name, hostname,
host certificate DN, and the administrative and security contacts.


### Initial registration

To register your cache host, follow the general registration instructions [here](https://osg-htc.org/docs/common/registration/#new-resources).
The service type is `XRootD cache server`.

!!! info
    This step must be completed before installation.

In your registration, you must specify which VOs your cache will serve by adding an `AllowedVOs` list, with each line specifying a VO whose data you are willing to cache.

There are special values you may use in `AllowedVOs`:

- `ANY_PUBLIC` indicates that the cache is willing to serve public data from any VO.
- `ANY` indicates that the cache is willing to serve data from any VO,
  both public and protected.
  `ANY` implies `ANY_PUBLIC`.

There are extra requirements for serving protected data:

- In addition to the cache allowing a VO in the `AllowedVOs` list,
  that VO must also allow the cache in its `AllowedCaches` list.
  See the page on [getting your VO's data into OSDF](vo-data.md).
- There must be an authenticated XRootD instance on the cache server.
- There must be a `DN` attribute in the resource registration
  with the [subject DN](../../security/host-certs/overview.md#before-starting) of the host certificate

This is an example registration for a cache server that serves all public data:
```yaml
  MY_OSDF_CACHE:
    FQDN: my-cache.example.net
    Services:
      XRootD cache server:
        Description: OSDF cache server
    AllowedVOs:
      - ANY_PUBLIC
```

This is an example registration for a cache server that only serves protected data for the Open Science Pool:
```yaml
  MY_AUTH_OSDF_CACHE:
    FQDN: my-auth-cache.example.net
    Services:
      XRootD cache server:
        Description: OSDF cache server
    AllowedVOs:
      - OSG
    DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=my-auth-cache.example.net
```

This is an example registration for a cache server that serves all public data _and_ protected data from the OSG VO:
```yaml
  MY_COMBO_OSDF_CACHE:
    FQDN: my-combo-cache.example.net
    Services:
      XRootD cache server:
        Description: OSDF cache server
    AllowedVOs:
      - OSG
      - ANY_PUBLIC
    DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=my-combo-cache.example.net
```


#### Non-standard ports

By default, an unauthenticated cache instance serves public data on port 8000,
and an authenticated cache instance serves protected data on port 8443.
If you change the ports for your cache instances, you must specify the new endpoints under the service, as follows:

```yaml
  MY_COMBO_OSDF_CACHE2:
    FQDN: my-combo-cache2.example.net
    Services:
      XRootD cache server:
        Description: OSDF cache server
        Details:
          endpoint_override: my-combo-cache2.example.net:8080
          auth_endpoint_override: my-combo-cache2.example.net:8444
```


### Finalizing registration

Once initial registration is complete, you may start the installation process.
In the meantime, open a [help ticket](https://support.opensciencegrid.org) with your cache name.
Mention in your ticket that you would like to "Finalize the cache registration."

<!-- NOTE: Keep the "Registering the Cache" section above in sync with run-stashcache-container.md -->

Installing the Cache
--------------------

The OSDF software consists of an XRootD server with special configuration and supporting services.
To simplify installation, OSG provides convenience RPMs that install all required
packages with a single command:

```console
root@host # yum install stash-cache
```

Configuring the Cache
---------------------

First, you must create a "cache directory", which will be used to store downloaded files.
By default this is `/mnt/stash`.
We recommend using a separate file system for the cache directory,
with at least 1 TB of storage available.

!!! note
    The cache directory must be writable by the `xrootd:xrootd` user and group.

The `stash-cache` package provides default configuration files in `/etc/xrootd/xrootd-stash-cache.cfg` and `/etc/xrootd/config.d/`.
Administrators may provide additional configuration by placing files in `/etc/xrootd/config.d/1*.cfg` (for files that need to be processed BEFORE the OSG configuration) or `/etc/xrootd/config.d/9*.cfg` (for files that need to be processed AFTER the OSG configuration).

You _must_ configure every variable in `/etc/xrootd/config.d/10-common-site-local.cfg`.

The mandatory variables to configure are:

- `set rootdir = /mnt/stash`: the mounted filesystem path to export.  This document refers to this as `/mnt/stash`.
- `set resourcename = YOUR_RESOURCE_NAME`: the resource name registered with the OSG.


### Ensure the xrootd service has a certificate

The service will need a certificate for reporting and to authenticate to origins.
The easiest solution for this is to use your host certificate and key as follows:

1. Copy the host certificate to `/etc/grid-security/xrd/xrd{cert,key}.pem`
1. Set the owner of the directory and contents `/etc/grid-security/xrd/` to `xrootd:xrootd`:

        :::console
        root@host # chown -R xrootd:xrootd /etc/grid-security/xrd/

!!! note
    You must repeat the above steps whenever you renew your host certificate.
    If you automate certificate renewal, you should automate copying as well.
    In addition, you will need to restart the XRootD services (`xrootd@stash-cache` and/or `xrootd@stash-cache-auth`)
    so they load the updated certificates.
    For example, if you are using Certbot for Let's Encrypt, you should write a "deploy hook" as documented
    [on the Certbot site](https://certbot.eff.org/docs/using.html#renewing-certificates).


Configuring Optional Features
-----------------------------

### Adjust disk utilization

To adjust the disk utilization of your cache, create or edit a file named `/etc/xrootd/config.d/90-local.cfg`
and set the values of `pfc.diskusage`.

```
pfc.diskusage 0.90 0.95
```

The two values correspond to the low and high usage water marks, respectively.
When usage goes above the high water mark,
the XRootD service will delete cached files until usage goes below the low water mark.


### Enable remote debugging (only if needed)

XRootD provides remote debugging via a read-only file system named digFS.
This feature is disabled by default, but you may enable it if you need help troubleshooting your server.

To enable remote debugging, edit `/etc/xrootd/digauth.cfg` and specify the authorizations for reading digFS.
An example of authorizations:
```
all allow gsi g=/glow h=*.cs.wisc.edu
```
This gives access to the config file, log files, core files, and process information
to anyone from `*.cs.wisc.edu` in the `/glow` VOMS group.

See [the XRootD manual](http://xrootd.org/doc/dev48/xrd_config.htm#_Toc496911334) for the full syntax.

Remote debugging should only be enabled for as long as you need assistance.
As soon as your issue has been resolved, revert any changes you have made to `/etc/xrootd/digauth.cfg`.


### Enable HTTPS on the unauthenticated cache

By default, the unauthenticated cache instance uses plain HTTP, not HTTPS.
To use HTTPS:

1.  Add a certificate according to the [instructions above](#ensure-the-xrootd-service-has-a-certificate)

1.  Uncomment `set EnableVoms = 1` in `/etc/xrootd/config.d/10-osg-xrdvoms.cfg`

!!! note "Upgrading from OSG 3.5"
    If upgrading from OSG 3.5, you may have a file with the following contents in `/etc/xrootd/config.d`:

           # Support HTTPS access to unauthenticated cache
           if named stash-cache
             http.cadir /etc/grid-security/certificates
             http.cert /etc/grid-security/xrd/xrdcert.pem
             http.key /etc/grid-security/xrd/xrdkey.pem
             http.secxtractor /usr/lib64/libXrdLcmaps.so
           fi

    You must delete this config block or XRootD will fail to start.


Manually Setting the FQDN (optional)
------------------------------------
The FQDN of the cache server that you registered in [Topology](#registering-the-cache) may be different than its internal hostname
(as reported by `hostname -f`).
For example, this may be the case if your cache is behind a load balancer such as LVS or MetalLB.
In this case, you must manually tell the cache services which FQDN to use for topology lookups.

If you are running a public cache instance:

1.  Create the file `/etc/systemd/system/stash-authfile@stash-cache.service.d/override.conf`
    with the following contents:
   
        :::ini
        [Service]
        Environment=CACHE_FQDN=<Topology-registered FQDN>


If you are running an authenticated cache instance:

1.  Create the file `/etc/systemd/system/stash-authfile@stash-cache-auth.service.d/override.conf`
    with the following contents:
   
        :::ini
        [Service]
        Environment=CACHE_FQDN=<Topology-registered FQDN>


Managing OSDF services
-------------------------------------------

These services must be managed by `systemctl` and may start additional services as dependencies.
As a reminder, here are common service commands (all run as `root`):

| To...                                   | Run the command...                 |
| :-------------------------------------- | :--------------------------------- |
| Start a service                         | `systemctl start <SERVICE-NAME>`   |
| Stop a service                          | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>` |

### Public cache services (if running a public cache instance)

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd@stash-cache.service` | The XRootD daemon, which performs the data transfers |
| XCache | `xcache-reporter.timer` | Reports usage information to collector.opensciencegrid.org |
| Fetch CRL |EL8: `fetch-crl.timer` <br> EL7: `fetch-crl-boot` and `fetch-crl-cron` | Required to authenticate monitoring services.  See [CA documentation](../../common/ca.md#managing-fetch-crl-services) for more info |
| | `stash-authfile@stash-cache.service` | Generate authentication configuration files for XRootD (public cache instance) |
| | `stash-authfile@stash-cache.timer` | Periodically run the above service (public cache instance) |


### Authenticated cache services (if running an authenticated cache instance)



| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| XRootD | `xrootd-renew-proxy.service` | Renew a proxy for authenticated downloads to the cache |
|  | `xrootd@stash-cache-auth.service` | The xrootd daemon which performs authenticated data transfers |
|  | `xrootd-renew-proxy.timer` | Trigger daily proxy renewal |
|  | `stash-authfile@stash-cache-auth.service` | Generate the authentication configuration files for XRootD (authenticated cache instance) |
|  | `stash-authfile@stash-cache-auth.timer` | Periodically run the above service (authenticated cache instance) |


Validating the Cache
---------------------

The cache server functions as a normal HTTP server and can interact with typical HTTP clients, such as `curl`.


```console
user@host $ curl -O http://cache_host:8000/osgconnect/public/rynge/test.data
```

`curl` may not correctly report a failure, so verify that the contents of the file are:
```
hello world!
```

### Test cache server reporting to the central collector

To verify the cache is reporting to the central collector, run the following command from the cache server:

```console
user@host $ condor_status -any -pool collector.opensciencegrid.org:9619 \
                          -l -const "Name==\"xrootd@`hostname`\""
```

The output of the above command should detail what the collector knows about the status of your cache.
Here is an example snippet of the output:
```
AuthenticatedIdentity = "sc-cache.chtc.wisc.edu@daemon.opensciencegrid.org"
AuthenticationMethod = "GSI"
free_cache_bytes = 868104454144
free_cache_fraction = 0.8022261674321525
LastHeardFrom = 1552002482
most_recent_access_time = 1551997049
MyType = "Machine"
Name = "xrootd@sc-cache.chtc.wisc.edu"
ping_elapsed_time = 0.00763392448425293
ping_response_code = 0
ping_response_message = "[SUCCESS] "
ping_response_status = "ok"
STASHCACHE_DaemonVersion = "1.0.0"
...
```


Updating to OSG 3.6
-------------------

The OSG 3.5 series reached end-of-life on May 1, 2022.
Admins are strongly encouraged to move their caches to OSG 3.6.

See [general update instructions](../../release/updating-to-osg-36.md).

Unauthenticated caches (`xrootd@stash-cache` service) do not need any configuration changes,
unless HTTPS access has been enabled.
See the ["enable HTTPS on the unauthenticated cache" section](#enable-https-on-the-unauthenticated-cache))
for the necessary configuration changes.

Authenticated caches (`xrootd@stash-cache-auth` service) may need the configuration changes described in the
[updating to OSG 3.6 section](../xrootd/xrootd-authorization.md#updating-to-osg-36)
of the XRootD authorization configuration document.


Getting Help
------------

To get assistance, please use the [this page](../../common/help.md).
