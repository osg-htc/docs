Installing Certificate Authorities (CAs)
========================================

The [certificate authorities](https://en.wikipedia.org/wiki/Certificate_authority) (CAs) provide the trust roots for the
[public key infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) OSG uses to maintain integrity of its sites and services.
This document provides details of various options to install the Certificate Authority (CA) certificates and have up-to-date
[certificate revocation lists](https://en.wikipedia.org/wiki/Certificate_revocation_list) (CRLs) on your OSG hosts.

When installing software the CAs, we provide a few mechanisms in order to allow you to make informed decisions.
You might ask "why do I care? Can’t you just give them to me?"  A few reasons why you may want to be involved:

-   What set of CA certificates do you want? How much control do you want over the set of CA certificates?
    Some sites might not want to install specific CAs for policy or security reasons.
-   How do you want to update them?
-   Do you want to centrally manage the CA certificates or install them on each host at your site?

You have three options for installing CA certificates:

1.  Install an RPM for a specific set of CA certificates.
2.  Install `osg-update-certs`, a program that lets you install/update a predefined set of CA certificates, then adjust the set by adding or deleting specific CAs.
3.  Install an RPM that installs **no** CAs. This is useful when you want your RPM installations to succeed (because our RPMs require CA certificates, and this RPM satisfies that dependency) but you want to manage them with your own technique.

Additionally this page also provides instruction on installation of a tool (`fetch-crl`) to ensure your site has up-to-date certificate revocation list (CRL) from the CA.

Prior to following the instructions on this page, you must enable our [yum repositories](/common/yum.md)

Installing CA Certificates
--------------------------

Please choose one of the three options to install the CA certificates.

### Option 1: Install an RPM for a specific set of CA certificates ###

If you want to install an RPM for one of our predefined CA certificates, you have two choices to make:

#### Which set of CAs? ####

1.  (*recommended*) The OSG CA certificates. This is similar to the IGTF set, but may have a small number of additions or deletions. (See [here](#contents-of-osg-ca-package) for details)
2.  The default [IGTF](http://www.igtf.net/) CA certificates.

Depending on your choice, you select one of two RPMs:

| **Set of CAs** | **RPM name**  | **Installation command (as root)** |
|----------------|---------------|------------------------------------|
| OSG            | osg-ca-certs  | `yum install osg-ca-certs`         |
| IGTF           | igtf-ca-certs | `yum install igtf-ca-certs`        |

#### How do I keep CAs updated? ####

Please follow the [update instructions](/security/certificate-management) to make sure that the CAs are kept updated.

### Option 2: Install osg-update-certs ###

Install this with:

``` console
root@host # yum install osg-ca-scripts
```

You have the same choices for CA certificates as above. In order to choose, you will run `osg-ca-manage`, which will install the CA certificates. Then (if desired) you need to enable periodic updating of the CA certificates.

| **Set of CAs** | **CA certs name** | *Installation command (as root)*                             |
|----------------|-------------------|--------------------------------------------------------------|
| OSG            | osg               | `/usr/sbin/osg-ca-manage setupCA --location root --url osg`  |
| IGTF           | igtf              | `/usr/sbin/osg-ca-manage setupCA --location root --url igtf` |

Here is an example:

``` console
root@host # /usr/sbin/osg-ca-manage setupCA --location root --url osg
Setting up CA Certificates for OSG installation
CA Certificates will be installed into /etc/grid-security/certificates
osg-update-certs
  Log file: /var/log/osg-update-certs.log
  Updates from: https://repo.opensciencegrid.org/pacman/cadist/ca-certs-version-new

Will update CA certificates from version unknown to version 1.21NEW.
Update successful.

Setup completed successfully.
```

Initially the CA certificates will not be updated. You can tell by looking at:

``` console
root@host # /sbin/service osg-update-certs-cron  status
Periodic osg-update-certs is disabled.
```

You can enable the `cron` job that updates the CA certs with:

``` console
root@host # /sbin/service osg-update-certs-cron  start
Enabling periodic osg-update-certs:                        [  %GREEN%OK%ENDCOLOR%  ]
```

A complete set of options available though `osg-ca-manage` command, including your interface to adding and removing CAs, could be found at [osg-ca-manage documentation](/security/certificate-management)

### Option 3: Site-managed CAs ###

If you want to handle the list of CAs completely internally to the site, you can utilize the `empty-ca-certs` RPM to satisfy
RPM dependencies - but not actually install any CAs.

Install this with:

``` console
yum install empty-ca-certs –-enablerepo=osg-empty
```

!!! warning
    If you choose this option, you are responsible for installing the CA certificates yourself. You must install them in `/etc/grid-security/certificates`, or make a symlink from that location to the directory that contains the CA certificates.


### Installing other CAs ###

!!! warning
    The `cilogon-openid` CA is only distributed in OSG 3.3.  Support will be removed by March 2018.

In addition to the above CAs, you can install other CAs via RPM. These only work with the RPMs that provide CAs (that is, `osg-ca-certs` and the like, but not `osg-ca-scripts`.) They are in addition to the above RPMs, so do not only install these extra CAs.

| **Set of CAs** | **RPM name**     | **Installation command (as root)** |
|----------------|------------------|------------------|------------------------------------|
| cilogon-openid | cilogon-ca-certs | `yum install cilogon-ca-certs`     |

Managing Certificate Revocation Lists
-------------------------------------

In addition to CA certificates, you must have updated Certificate Revocation Lists (CRLs) which are are lists of certificates that have been revoked for any reason. Software in the OSG Software Stack uses CRLs to ensure that you are talking to valid clients or servers.

We use a tool named `fetch-crl` that periodically updates the CRLs. Fetch CRL is a utility that updates Certificate Authority (CA) Certificate Revocation Lists (CRLs). These are lists of certificates that were granted by the CA, but have since been revoked. It is good practice to regularly update the CRL list for each CA to ensure that you do not authenticate any certificate that has been revoked.

### Installing `fetch-crl` ###

Normally `fetch-crl` is installed when you install the rest of the software and you do not need
to explicitly install it. If you do wish to install it, run the following command:

``` console
root@host # yum install fetch-crl
```

### Optional: configuring `fetch-crl` ###

The following sub-sections contain optional configuration instructions.

!!! note
    Note that the `nosymlinks` option in the configuration files refers to ignoring links within the certificates directory (e.g. two different names for the same file). It is perfectly fine if the path of the CA certificates directory itself (`infodir`) is a link to a directory.

#### Changing the frequency of `fetch-crl-cron` ####

To modify the times that `fetch-crl-cron` runs, edit `/etc/cron.d/fetch-crl`, which uses crontab formatting

#### Using an HTTP proxy for fetching CRLs ####

By default, `fetch-crl` connects directly to the remote CA; this is inefficient and potentially harmful if done simultaneously by many nodes (e.g. all the worker nodes of a big cluster). We recommend you provide an HTTP proxy such as [Frontier Squid](/data/frontier-squid.md) that your worker nodes can utilize. To configure `fetch-crl` to use an HTTP proxy server, create or edit the file `/etc/fetch-crl.conf` and add the following line:

```
http_proxy=%RED%<http://your.squid.fqdn:port>%ENDCOLOR%
```

Adjusting `<http://your.squid.fqdn:port>` for your proxy server.

#### Logging with syslog ####

Current versions of `fetch-crl` produce more output. It is possible to send the output to syslog instead of the default email system. To do so:

1.  Change the configuration file to enable syslog:

        logmode = syslog
        syslogfacility = daemon

1.  Make sure the file `/var/log/daemon` exists, e.g. touching the file
1.  Change `/etc/logrotate.d` files to rotate it

### Managing `fetch-crl` services ###

`fetch-crl` is installed as two different system services. The fetch-crl-boot service runs `fetch-crl` and is intended to only be enabled or disabled. The `fetch-crl-cron` service runs `fetch-crl` every 6 hours (with a random sleep time included). Both services are disabled by default. At the very minimum, the `fetch-crl-cron` service needs to be enabled and started, otherwise services will begin to fail as the existing CRLs expire.

| Software  | Service name     | Notes                          |
|:----------|:-----------------|:-------------------------------|
| Fetch CRL | `fetch-crl-cron` | Runs `fetch-crl` every 6 hours |
|           | `fetch-crl-boot` | Runs `fetch-crl` immediately   |

Start the services in the order listed and stop them in reverse order. As a reminder, here are common service commands (all run as `root`):

| To...                                   | On EL6, run the command...                | On EL7, run the command...                    |
| :-------------------------------------- | :---------------------------------------- | :-------------------------------------------- |
| Start a service                         | `service <SERVICE-NAME> start`            | `systemctl start <SERVICE-NAME>`              |
| Stop a  service                         | `service <SERVICE-NAME> stop`             | `systemctl stop <SERVICE-NAME>`               |
| Enable a service to start on boot       | `chkconfig <SERVICE-NAME> on`             | `systemctl enable <SERVICE-NAME>`             |
| Disable a service from starting on boot | `chkconfig <SERVICE-NAME> off`            | `systemctl disable <SERVICE-NAME>`            |

Updating CAs/CRLs
-----------------

### Why maintain up-to-date Trusted CA /CRL information?###

The Trusted Certificate Authority (CA) certificates, and their associated Certificate Revocation Lists (CRLs), are used for every transaction on a resource that establishes an authenticated network connection based on end user’s certificate. In order for the authentication to succeed, the user’s certificate must have been issued by one of the CAs in the Trusted CA directory, and the user’s certificate must not be listed in the CRL for that CA.

CRLs can be thought of as a black list of certificates. CAs are the trust authorities, similar to DMV that issues you the driving license. (Another way of thinking CRLs is the do-not-fly lists at the airports. if your certificate shows up in CRLs, you are not allowed access.)

This is handled at the certificate validation stage even before the authorization check (which will provide the mapping of an authenticated user to a local account UID/GID). So you do not need to do worry about it; the grid software will do this for you.

However, you should make sure that your site has the most up-to-date list of Trusted CAs. There are multiple trust authorities in OSG (think of it as a different DMV for each state). If you do not have an up-to-date list of CAs it is possible that some of your users transactions at your site will start to fail. A current CRL list for each CA is also necessary, since without one transactions for users of that CA will fail.

How to ensure you are get up-to-date CA/CRL information
-------------------------------------------------------

1.  If you installed CAs using rpm packages (`osg-ca-certs`,`igtf-ca-certs`) (Option 1), you will need to install the software described in [the CA update document](/security/certificate-management), and enable `osg-ca-certs-updater` service to keep the CAs automatically updated. If you do not install the updater, you will have to regularly run yum update to keep the CAs updated.
2.  If you use Option 2 (i.e. `osg-update-certs`) then make sure that you have the corresponding service enabled.

        :::console
        root@host # /sbin/service osg-update-certs-cron  status
        Periodic osg-update-certs is enabled.

3.  Ensure that fetch-crl cron is enabled

        :::console
        root@host # /sbin/service fetch-crl-cron  status
        Periodic fetch-crl is enabled.

Troubleshooting
---------------

### Configuration files ###

| Package                       | File Description                        | Location                                                                                    | Comment                                                                                                         |
|:------------------------------|:----------------------------------------|:--------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| All CA Packages               | CA File Location                        | `/etc/grid-security/certificates`                                                           |                                                                                                                 |
| All CA Packages               | Index files                             | `/etc/grid-security/certificates/INDEX.html` or `/etc/grid-security/certificates/INDEX.txt` | Latest version also available at <http://repo.opensciencegrid.org/pacman/cadist/>                                       |
| All CA Packages               | Change Log                              | `/etc/grid-security/certificates/CHANGES`                                                   | Latest version also available at <http://repo.opensciencegrid.org/pacman/cadist/CHANGES>                                |
| osg-ca-certs or igtf-ca-certs | contain only CA files                   |                                                                                             |                                                                                                                 |
| osg-ca-scripts                | Configuration File for osg-update-certs | `/etc/osg/osg-update-certs.conf`                                                            | This file may be edited by hand, though it is recommended to use osg-ca-manage to set configuration parameters. |
| fetch-crl-3.x                 | Configuration file                      | `/etc/fetch-crl.conf`                                                                      |                                                                                                                  |

The index and change log files contain a summary of all the CA distributed and their version.

### Logs files ###

| Package        | File Description             | Location                                        |
|:---------------|:-----------------------------|:------------------------------------------------|
| osg-ca-scripts | Log file of osg-update-certs | `/var/log/osg-update-certs.log`                 |
| osg-ca-scripts | Stdout of osg-update-certs   | `/var/log/osg-ca-certs-status.system.out`       |
| osg-ca-scripts | Stdout of osg-ca-manage      | `/var/log/osg-ca-manage.system.out`             |
| osg-ca-scripts | Stdout of initial CA setup   | `/var/log/osg-setup-ca-certificates.system.out` |

### Tests ###

To test the host certificate of a server `openssl s_client` can be used. Here is an example with the gatekeeper:

``` console
user@host $ openssl s_client -showcerts \
    -cert /etc/grid-security/hostcert.pem \
    -key /etc/grid-security/hostkey.pem \
    -CApath /etc/grid-security/certificates/ \
    -debug -connect osg-gk.mwt2.org:2119
```

Frequently Asked Questions
--------------------------

### Location of Certificates?

```
 /etc/grid-security/certificates
```

### What is the version of OSG CA package I have installed and what are its contents?

The version of the CA package ca be found at `/etc/grid-security/certificates/INDEX.html` or `/etc/grid-security/certificates/INDEX.txt`. The changes file can be found at `/etc/grid-security/certificates/CHANGES`.

### Contents of OSG CA package?

The OSG CA Distribution contains:

-   [IGTF Distribution of Authority Root Certificates](http://dist.eugridpma.info/distribution/igtf/current/) (CAs accredited by the [International Grid Trust Federation](http://igtf.net/))

For additional details what is in the current release, see the [distribution site](http://repo.opensciencegrid.org/pacman/cadist/) and [change log](http://repo.opensciencegrid.org/pacman/cadist/CHANGES).

### How can I add or remove a particular CA file?

Add and remove of CA files are supported only if you CA files are being installed using `osg-update-certs`, which is included in the `osg-ca-scripts` package (option 2), for all other options no support for adding and removing a particular CA file is provided by OSG. The preferred approach to add or remove a CA is to use [osg-ca-manage](/security/certificate-management). For adding a new CA `osg-ca-manage add [--dir <local_dir>] --hash <CA_hash>` may be used, while a CA is removed using `osg-ca-manage remove --hash <CA_hash>`.

### Are there any log files or configuration files associated with CA certificate package?

If CA files are installed using `osg-ca-certs` or `igtf-ca-certs` rpms (i.e. option 1) no log or configuration files are present.

Log and configuration files are however present for `osg-ca-scripts` rpm package (option 2).

Config files: `/etc/osg/osg-update-certs.conf` Log files: `/var/log/osg-update-certs.log`, `/var/log/osg-ca-certs-status.system.out`, `/var/log/osg-ca-manage.system.out`, `/var/log/osg-setup-ca-certificates.system.out`

### Are CA packages automatically updated?

If CA files are installed using `osg-ca-certs` or `igtf-ca-certs` rpms (i.e. option 1), you will need to install the software described in [OSG CA certs updater](/security/certificate-management), and enable `osg-ca-certs-updater` service to keep the CAs automatically updated.

If CA files are being installed using `osg-ca-scripts` rpm package (option 2), CA files are kept up-to-date as long as `osg-update-certs-cron` service the package provides has been started.

### How do I manually update my CA package?

For Option 1: run one of the following `yum update osg-ca-certs` or `yum update igtf-ca-certs` depending on the rpm package you installed.

For Option 2: You do not need to do a manual update, make sure `osg-update-certs-cron` is enabled using

``` console
root@host # /sbin/service osg-update-certs-cron  status
```

If the service is disabled, enable it using

``` console
root@host # /sbin/service osg-update-certs-cron  start
```

If for some extraordinary reason you need to manually update the CA you could run `osg-ca-manage [--force] refreshCA`.

### Where are the configuration files for fetch-crl?

`/etc/fetch-crl.conf`

References
----------

Some guides on x509 certificates:

-   Useful commands: <http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html>
-   Install GSI authentication on a server: <http://security.ncsa.illinois.edu/research/wssec/gsihttps/>
-   Certificates how-to: <http://www.nordugrid.org/documents/certificate_howto.html>

Some examples about verifying the certificates:

-   <http://gagravarr.org/writing/openssl-certs/others.shtml>
-   <http://www.cyberciti.biz/faq/test-ssl-certificates-diagnosis-ssl-certificate/>
-   <http://www.cyberciti.biz/tips/debugging-ssl-communications-from-unix-shell-prompt.html>

Related software:

-   Description, manual and examples of [osg-ca-manage](/security/certificate-management)
-   [osg-ca-certs-updater](/security/certificate-management)
