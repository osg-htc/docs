
Installing Certificate Authorities Certificates and related RPMs
================================================================

This document provides you with details of various options to install the Certificate Authority (CA) certificates and have up-to-date certificate revocation list (CRL).

When installing software with RPMs, you need to decide how you want to install the Certificate Authority (CA) certificates. You might ask "why do I care? Can’t you just give them to me?" We can, but you have a few things to consider:

-   What set of CA certificates do you want? How much control do you want over the set of CA certificates? (Some sites might not want to install specific CAs for policy or security reasons.)
-   How do you want to update them?
-   Do you want to centrally manage the CA certificates or install them on each computer at your site?

You have four options for installing CA certificates:

1.  Install an RPM for a specific set of CA certificates.
2.  Install `osg-update-certs`, a program that lets you install/update a predefined set of CA certificates, then adjust the set by adding or deleting specific CAs.
3.  Install an RPM that installs **no** CAs. This is useful when you want your RPM installations to succeed (because our RPMs require CA certificates, and this RPM satisfies that dependency) but you want to manage them with your own technique.
4.  Make no choice, let `yum` decide for you.

Additionally this page also provides instruction on installation of a tool (fetch-crl) to ensure your site has up-to-date certificate revocation list (CRL) from the CA.

Prior to following the instructions on this page, you must enable our [yum repositories](../Common/yum.md)

Install CA certificates: Options
================================

Please choose one of the four options to install the CA certificates.

Option 1: Install an RPM for a specific set of CA certificates
--------------------------------------------------------------

If you want to install an RPM for one of our predefined CA certificates, you have two choices to make:

### Which set of CAs?

1.  (*recommended*) The OSG CA certificates. This is similar to the IGTF set, but may have a small number of additions or deletions. (See [here](InstallCertAuth#Contents_of_OSG_CA_package) for details)
2.  The default [IGTF](http://www.igtf.net/) CA certificates.

Depending on your choice, you select one of two RPMs:

| **Set of CAs** | **Format** --| **RPM name**  | **Installation command (as root)** |
|----------------|--------------|---------------|------------------------------------|
| OSG            | OpenSSL-both | osg-ca-certs  | `yum install osg-ca-certs`         |
| IGTF           | OpenSSL-both | igtf-ca-certs | `yum install igtf-ca-certs`        |

### How do I keep CAs updated?

Please follow the [update instructions](ca_updater.md) to make sure that the CAs are kept updated.

Option 2: Install osg-update-certs
----------------------------------

Install this with:

```
%UCL_PROMPT_ROOT% yum install osg-ca-scripts
```

You have the same choices for CA certificates as above. In order to choose, you will run `osg-ca-manage`, which will install the CA certificates. Then (if desired) you need to enable periodic updating of the CA certificates.

| **Set of CAs** | **Format**   | **CA certs name** | *Installation command (as root)*                             |
|----------------|--------------|-------------------|--------------------------------------------------------------|
| OSG            | OpenSSL-both | osg               | `/usr/sbin/osg-ca-manage setupCA --location root --url osg`  |
| IGTF           | OpenSSL-both | igtf              | `/usr/sbin/osg-ca-manage setupCA --location root --url igtf` |

Here is an example:

```
%UCL_PROMPT_ROOT% /usr/sbin/osg-ca-manage setupCA --location root --url osg 
Setting up CA Certificates for OSG installation
CA Certificates will be installed into /etc/grid-security/certificates
osg-update-certs
  Log file: /var/log/osg-update-certs.log
  Updates from: http://software.grid.iu.edu/pacman/cadist/ca-certs-version-new

Will update CA certificates from version unknown to version 1.21NEW.
Update successful.

Setup completed successfully.
```

Initially the CA certificates will not be updated. You can tell by looking at:

```
%UCL_PROMPT_ROOT% /sbin/service osg-update-certs-cron  status
Periodic osg-update-certs is disabled.
```

You can enable the `cron` job that updates the CA certs with:

```
%UCL_PROMPT_ROOT% /sbin/service osg-update-certs-cron  start
Enabling periodic osg-update-certs:                        [  %GREEN%OK%ENDCOLOR%  ]
```

A complete set of options available though `osg-ca-manage` command, including your interface to adding and removing CAs, could be found at [osg-ca-manage documentation](OsgCaManage)

Option 3: Install an RPM that installs no CAs
---------------------------------------------

Install this with:

```
yum install empty-ca-certs –-enablerepo=osg-empty
```

!!! warning
    If you choose this option, you are responsible for installing the CA certificates yourself. You must install them in `/etc/grid-security/certificates`, or make a symlink from that location to the directory that contains the CA certificates.

Option 4: Make no choice, let yum decide for you
------------------------------------------------

If you use `yum` to install software that requires CA certificates but you haven’t made one of these choices, yum will choose a default. Right now, it is Option \#1 from above (*Install an RPM for a specific set of CA certificates*), and the osg-ca-certs RPM is chosen.

Install other CAs
-----------------

In addition to the above CAs, you can install other CAs via RPM. These only work with the RPMs that provide CAs (that is, `osg-ca-certs` and the like, but not `osg-ca-scripts`.) They are in addition to the above RPMs, so do not only install these extra CAs.

| **Set of CAs**                 | **Format**   | **RPM name**     | **Installation command (as root)** |
|--------------------------------|--------------|------------------|------------------------------------|
| cilogon-basic & cilogon-openid | OpenSSL-both | cilogon-ca-certs | `yum install cilogon-ca-certs`     |

Managing Certificate Revocation Lists
=====================================

In addition to CA certificates, you normally need to have updated Certificate Revocation Lists (CRLs) which are are lists of certificates that have been revoked for any reason. Software in the OSG Software Stack use these to ensure that you are talking to valid clients or servers. We use a tool named `fetch-crl` that periodically updates the CRLs. Fetch CRL is a utility that updates Certificate Authority (CA) Certificate Revocation Lists (CRLs). These are lists of certificates that were granted by the CA, but have since been revoked. It is good practice to regularly update the CRL list for each CA to ensure that you do not authenticate any certificate that has been revoked.

`fetch-crl` is installed as two different system services. The fetch-crl-boot service runs only
at boot time. The `fetch-crl-cron` service runs `fetch-crl` every 6 hours (with a random sleep
time included) by default. Both services are disabled by default. At the very minimum, the
`fetch-crl-cron` service needs to be enabled otherwise services will begin to fail as the
existing CRLs expire.

Install `fetch-crl`
-------------------

Normally `fetch-crl` is installed when you install the rest of the software and you do not need
to specifically install it. If you do wish to install it, you can install it as:

```
%RED%# For RHEL 5, CentOS 5, and SL5 %ENDCOLOR%
%UCL_PROMPT_ROOT% yum install fetch-crl3
%RED%# For RHEL 6 or 7, CentOS 6 or 7, and SL6 or SL7 %ENDCOLOR%
%UCL_PROMPT_ROOT% yum install fetch-crl
```

### Enable and Start `fetch-crl`

To enable fetch-crl (fetch Certificate Revocation Lists) services by default on the node:

```
%RED%# For RHEL 5, CentOS 5, and SL5 %ENDCOLOR%
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl3-boot on
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl3-cron on
%RED%# For RHEL 6 or 7, CentOS 6 or 7, and SL6 or SL7 %ENDCOLOR% 
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl-boot on
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl-cron on
```

To start fetch-crl:

```
%RED%# For RHEL 5, CentOS 5, and SL5 %ENDCOLOR%
%UCL_PROMPT_ROOT% /sbin/service fetch-crl3-boot start
%UCL_PROMPT_ROOT% /sbin/service fetch-crl3-cron start
%RED%# For RHEL 6 or 7, CentOS 6 or 7, and SL6 or SL7 %ENDCOLOR% 
%UCL_PROMPT_ROOT% /sbin/service fetch-crl-boot start
%UCL_PROMPT_ROOT% /sbin/service fetch-crl-cron start
```

!!! note
    While it is necessary to start `fetch-crl-cron` in order to have it active, `fetch-crl-boot` is started automatically at boot time if enabled. The start command will run `fetch-crl-boot` at the moment when it is invoked and it may take some time to complete.

### Configure `fetch-crl`

To modify the times that fetch-crl-cron runs, edit `/etc/cron.d/fetch-crl` (or `/etc/cron.d/fetch-crl3` depending on the version you have).

By default, `fetch-crl` connects directly to the remote CA; this is
inefficient and potentially harmful if done simultaneously by many nodes
(e.g. all the worker nodes of a big cluster). We recommend you provide a
HTTP proxy (such as `squid`) the worker nodes can utilize; OSG provides
[packaging of squid](../Frontier_Squid/squid.md).

To configure fetch-crl to use an HTTP proxy server:

-   If using `fetch-crl` version 2 (the `fetch-crl` package on RHEL5 only), then create the file `/etc/sysconfig/fetch-crl` and add the following line:

      ```
      export http_proxy=%RED%http://your.squid.fqdn:port%ENDCOLOR%
      ```

    Adjust the URL appropriately for your proxy server.

-   If using `fetch-crl` version 3 on RHEL5 via the `fetch-crl3` package
    or on RHEL6/RHEL7 via the `fetch-crl` package, then create or edit the
    file `/etc/fetch-crl3.conf` (RHEL5) or `/etc/fetch-crl.conf`
    (RHEL6/RHEL7) and add the following line:

      ```
      http_proxy=%RED%http://your.squid.fqdn:port%ENDCOLOR%
      ```

    Again, adjust the URL appropriately for your proxy server.

Note that the **`nosymlinks`** option in the configuration files refers
to ignoring links within the certificates directory (e.g. two different
names for the same file). It is perfectly fine if the path of the CA
certificates directory itself (`infodir`) is a link to a directory.

Any modifications to the configuration file will be preserved during an RPM update.

Current versions of `fetch-crl` and `fetch-crl3` produce more output.
It is possible to send the output to syslog instead of the default email system. To do so:

1.  Change the configuration file to enable syslog:

      ```
      logmode = syslog
      syslogfacility = daemon\</pre\>
      ```

1.  Make sure the file `/var/log/daemon` exists, e.g. touching the file
2.  Change `/etc/logrotate.d` files to rotate it

### Start/Stop fetch-crl: A quick guide

You need to fetch the latest CA Certificate Revocation Lists (CRLs) and you should enable the fetch-crl service to keep the CRLs up to date:

```
%RED%# For RHEL 5, CentOS 5, and SL5 %ENDCOLOR%
%UCL_PROMPT_ROOT% /usr/sbin/fetch-crl3 # This fetches the CRLs
%UCL_PROMPT_ROOT% /sbin/service fetch-crl3-boot start
%UCL_PROMPT_ROOT% /sbin/service fetch-crl3-cron start
%RED%# For RHEL 6 or 7, CentOS 6 or 7, and SL6 or SL7%ENDCOLOR%
%UCL_PROMPT_ROOT% /usr/sbin/fetch-crl # This fetches the CRLs
%UCL_PROMPT_ROOT% /sbin/service fetch-crl-boot start
%UCL_PROMPT_ROOT% /sbin/service fetch-crl-cron start
```

To enable the `fetch-crl` service to keep the CRLs up to date after reboots:

```
%RED%# For RHEL 5, CentOS 5, and SL5 %ENDCOLOR%
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl3-boot on
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl3-cron on
%RED%# For RHEL 6 or 7, CentOS 6 or 7, and SL6 or SL7 %ENDCOLOR%
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl-boot on
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl-cron on
```

To stop `fetch-crl`:

```
%RED%# For RHEL 5, CentOS 5, and SL5 %ENDCOLOR%
%UCL_PROMPT_ROOT% /sbin/service fetch-crl3-boot stop
%UCL_PROMPT_ROOT% /sbin/service fetch-crl3-cron stop
%RED%# For RHEL 6 or 7, CentOS 6 or 7, and SL6 or SL7 %ENDCOLOR%
%UCL_PROMPT_ROOT% /sbin/service fetch-crl-boot stop
%UCL_PROMPT_ROOT% /sbin/service fetch-crl-cron stop
```

To disable the fetch-crl service:

```
%RED%# For RHEL 5, CentOS 5, and SL5 %ENDCOLOR%
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl3-boot off
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl3-cron off
%RED%# For RHEL 6 or 7, CentOS 6 or 7, and SL6 or SL7 %ENDCOLOR%
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl-boot off
%UCL_PROMPT_ROOT% /sbin/chkconfig fetch-crl-cron off
```

Updating CAs/CRLs
=================

Why maintain up-to-date Trusted CA /CRL information
---------------------------------------------------

The Trusted Certificate Authority (CA) certificates, and their associated Certificate Revocation Lists (CRLs), are used for every transaction on a resource that establishes an authenticated network connection based on end user’s certificate. In order for the authentication to succeed, the user’s certificate must have been issued by one of the CAs in the Trusted CA directory, and the user’s certificate must not be listed in the CRL for that CA. CRLs can be thought of as a black list of certificates. CAs are the trust authorities, similar to DMV that issues you the driving license. (Another way of thinking CRLs is the do-not-fly lists at the airports. if your certificate shows up in CRLs, you are not allowed access.) This is handled at the certificate validation stage even before the authorization check (which will provide the mapping of an authenticated user to a local account UID/GID). So you do not need to do worry about it; the grid software will do this for you. However, you should make sure that your site has the most up-to-date list of Trusted CAs. There are multiple trust authorities in OSG (think of it as a different DMV for each state). If you do not have an up-to-date list of CAs it is possible that some of your users transactions at your site will start to fail. A current CRL list for each CA is also necessary, since without one transactions for users of that CA will fail.

How to ensure you are get up-to-date CA/CRL information
-------------------------------------------------------

1.  If you installed CAs using rpm packages (`osg-ca-certs`,`igtf-ca-certs`) (Options 1, 4), you will need to install the software described in [the CA update document](ca_updater.md), and enable `osg-ca-certs-updater` service to keep the CAs automatically updated. If you do not install the updater, you will have to regularly run yum update to keep the CAs updated.
2.  If you use Option 2 (i.e. `osg-update-certs`) then make sure that you have the corresponding service enabled.

   ```
   %UCL_PROMPT_ROOT% /sbin/service osg-update-certs-cron  status
   Periodic osg-update-certs is enabled.
   ```

3.  Ensure that fetch-crl cron is enabled\\

  ```
  %UCL_PROMPT_ROOT% /sbin/service fetch-crl-cron  status
  Periodic fetch-crl is enabled.
  ```

Troubleshooting
===============

Useful configuration and log files
----------------------------------

Configuration files:

| Package                       | File Description                        | Location                                                                                    | Comment                                                                                                         |
|:------------------------------|:----------------------------------------|:--------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| All CA Packages               | CA File Location                        | `/etc/grid-security/certificates`                                                           |                                                                                                                 |
| All CA Packages               | Index files                             | `/etc/grid-security/certificates/INDEX.html` or `/etc/grid-security/certificates/INDEX.txt` | Latest version also available at <http://software.grid.iu.edu/pacman/cadist/>                                   |
| All CA Packages               | Change Log                              | `/etc/grid-security/certificates/CHANGES`                                                   | Latest version also available at <http://software.grid.iu.edu/pacman/cadist/CHANGES>                            |
| osg-ca-certs or igtf-ca-certs | contain only CA files                   |                                                                                             |                                                                                                                 |
| osg-ca-scripts                | Configuration File for osg-update-certs | `/etc/osg/osg-update-certs.conf`                                                            | This file may be edited by hand, though it is recommended to use osg-ca-manage to set configuration parameters. |
| fetch-crl-2.x                 | Configuration file                      | `/etc/fetch-crl.conf`                                                                       |                                                                                                                 |
| fetch-crl-3.x                 | Configuration file                      | `/etc/fetch-crl3.conf`                                                                      |                                                                                                                 |

The index and change log files contain a summary of all the CA distributed and their version.

Logs files:

| Package        | File Description             | Location                                        |
|:---------------|:-----------------------------|:------------------------------------------------|
| osg-ca-scripts | Log file of osg-update-certs | `/var/log/osg-update-certs.log`                 |
| osg-ca-scripts | Stdout of osg-update-certs   | `/var/log/osg-ca-certs-status.system.out`       |
| osg-ca-scripts | Stdout of osg-ca-manage      | `/var/log/osg-ca-manage.system.out`             |
| osg-ca-scripts | Stdout of initial CA setup   | `/var/log/osg-setup-ca-certificates.system.out` |

Tests
-----

To test the host certificate of a server `openssl s_client` can be used. Here is an example with the gatekeeper:

```
%UCL_PROMPT% openssl s_client -showcerts -cert /etc/grid-security/hostcert.pem -key /etc/grid-security/hostkey.pem -CApath /etc/grid-security/certificates/ -debug -connect osg-gk.mwt2.org:2119
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
-   [Purdue TeraGrid CA](http://tg-ca.purdue.teragrid.org:8080/ejbca/)

Details of CAs in OSG distribution can be found [here](Documentation.CaDistribution#Contents). For additional details what is in the current release, see the [distribution site](http://software.grid.iu.edu/pacman/cadist/) and [change log](http://software.grid.iu.edu/pacman/cadist/CHANGES).

### How can I add or remove a particular CA file?

Add and remove of CA files are supported only if you CA files are being installed using `osg-update-certs`, which is included in the `osg-ca-scripts` package (option 2), for all other options no support for adding and removing a particular CA file is provided by OSG. The preferred approach to add or remove a CA is to use [osg-ca-manage](OsgCaManage). For adding a new CA `osg-ca-manage add [--dir <local_dir>] --hash <CA_hash>` may be used, while a CA is removed using `osg-ca-manage remove --hash <CA_hash>`.

### Are there any log files or configuration files associated with CA certificate package?

If CA files are installed using `osg-ca-certs` or `igtf-ca-certs` rpms (i.e. options 1, 4) no log or configuration files are present.

Log and configuration files are however present for `osg-ca-scripts` rpm package (option 2).

Config files: `/etc/osg/osg-update-certs.conf` Log files: `/var/log/osg-update-certs.log`, `/var/log/osg-ca-certs-status.system.out`, `/var/log/osg-ca-manage.system.out`, `/var/log/osg-setup-ca-certificates.system.out`

### Are CA packages automatically updated?

If CA files are installed using `osg-ca-certs` or `igtf-ca-certs` rpms (i.e. options 1, 4), you will need to install the software described in OsgCaCertsUpdater, and enable osg-ca-certs-updater service to keep the CAs automatically updated.

If CA files are being installed using `osg-ca-scripts` rpm package (option 2), CA files are kept up-to-date as long as `osg-update-certs-cron` service the package provides has been started.

### How do I manually update my CA package?

For Option 1: run one of the following `yum update osg-ca-certs` or `yum update igtf-ca-certs` depending on the rpm package you installed.

For Option 4: run `yum update osg-ca-certs`

For Option 2: You do not need to do a manual update, make sure `osg-update-certs-cron` is enabled using

```
%UCL_PROMPT_ROOT% /sbin/service osg-update-certs-cron  status
```

If the service is disabled, enable it using

```
%UCL_PROMPT_ROOT% /sbin/service osg-update-certs-cron  start
```

If for some extraordinary reason you need to manually update the CA you could run `osg-ca-manage [--force] refreshCA`.

### Where are the configuration files for fetch-crl?

`/etc/fetch-crl.conf` or `/etc/fetch-crl3.conf` for fetch-crl 2.x or 3.x respectively

References
==========

Some guides on x509 certificates:

-   Useful commands: <http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html>
-   Install GSI authentication on a server: <http://security.ncsa.illinois.edu/research/wssec/gsihttps/>
-   Certificates how-to: <http://www.nordugrid.org/documents/certificate_howto.html>

Some examples about verifying the certificates:

-   <http://gagravarr.org/writing/openssl-certs/others.shtml>
-   <http://www.cyberciti.biz/faq/test-ssl-certificates-diagnosis-ssl-certificate/>
-   <http://www.cyberciti.biz/tips/debugging-ssl-communications-from-unix-shell-prompt.html>

Related software:

-   Description, manual and examples of OsgCaManage
-   OsgCaCertsUpdater
-   [Upgrading Fetch-Crl 2 to Fetch-Crl 3 on EL5](UpgradeFetchCrl2to3)

