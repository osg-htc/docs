Managing Certificates
=====================

The OSG provides several tools to assist in the management of host and CA certificates.  This page serves as a
reference guide for several of these tools:

- `osg-pki-tools`: command line tools for requesting and managing user and host certificates.
- `osg-ca-certs-updater`: A package for auto-updating CAs on a server host.
- `osg-ca-manage`: A tool for detailed management of CA directories outside RPMs.

!!! note
    This is a reference document and not introduction on how to install CA certificates or request
    host / user certificates.  Most users will want the [CA overview](../common/ca.md),
    [host certificate overview](host-certs.md), or [user certificate overview](user-certs.md) documents.


OSG PKI Command Line Clients
----------------------------

### Overview

The OSG PKI Command Line Clients provide a command-line interface for requesting and issuing host certificates from the OSG PKI. They complement the [OIM Web Interface](https://oim.opensciencegrid.org/oim/certificateuser).

### Prerequisites

If you have not already done so, you need to [configure the OSG software repositories](../common/yum.md).

### Installation

The command-line scripts have been packaged as an RPM and are available from the OSG repositories.

To install the RPM, run:

```console
root@host # yum install osg-pki-tools
```

Usage
-----

Documentation for usage of the osg-pki-tools can be found [here](https://github.com/opensciencegrid/osg-pki-tools/blob/master/README.md)


OSG CA Certificates Updater
---------------------------

This section explains the installation and use of `osg-ca-certs-updater`, a package that provides automatic updates of
CA certificates.

### Requirements

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms.md)
- Obtain root access to the host
- Prepare the [required Yum repositories](../common/yum.md)
- Install [CA certificates](../common/ca.md)

### Install instructions

Run the following command to install the latest version of the updater.

``` console
root@host# yum install osg-ca-certs-updater
```

### Services

#### Starting and Enabling Services

Run the following to enable the updater. This will persist until the machine is rebooted.

``` console
root@host# service osg-ca-certs-updater-cron start
```

Run the following to enable the updater when the machine is rebooted.

``` console
root@host# chkconfig osg-ca-certs-updater-cron on
```

Run both commands if you wish for the service to activate immediately and remain active throughout reboots.

#### Stopping and Disabling Services

Enter the following to disable the updater. This will persist until the machine is rebooted.

``` console
root@host# service osg-ca-certs-updater-cron stop
```

Enter the following to disable the updater when the machine is rebooted.

``` console
root@host# chkconfig osg-ca-certs-updater-cron off
```

Run both commands if you wish for the service to deactivate immediately and not get reactivated during reboots.

### Configuration

While there is no configuration file, the behavior of the updater can be adjusted by command-line arguments that are specified in the `cron` entry of the service. This entry is located in the file `/etc/cron.d/osg-ca-certs-updater`. Please see the Unix manual page for `crontab` in section 5 for an explanation of the format. The manual page can be accessed by the command `man 5 crontab`. The valid command-line arguments can be listed by running `osg-ca-certs-updater --help`. Reasonable defaults have been provided, namely:

-   Attempt an update no more often than every 23 hours. Due to the random wait (see below), having a 24-hour minimum time between updates would cause the update time to slowly slide back every day.
-   Run the script every 6 hours. We run the script more often than we update so that downtime at the wrong moment does not cause the update to be delayed for a full day.
-   Delay for a random amount of time up to 30 minutes before updating, to reduce load spikes on OSG repositories.
-   Do not warn the administrator about update failures that have happened less than 72 hours since the last successful update.
-   Log errors only.

### Troubleshooting

#### Useful configuration and log files

##### Configuration file

| Package              | File Description                                      | Location                                                       | Comment                                                                                       |
|:---------------------|:------------------------------------------------------|:---------------------------------------------------------------|:----------------------------------------------------------------------------------------------|
| osg-ca-certs-updater | Cron entry for periodically launching the updater     | `/etc/cron.d/osg-ca-certs-updater`                             | Command-line arguments to the updater can be specified here                                   |
| osg-release          | Repo definition files for production OSG repositories | `/etc/yum.repos.d/osg.repo` or `/etc/yum.repos.d/osg-el6.repo` | Make sure these repositories are enabled and reachable from the host you are trying to update |

#### Log files

Logging is performed to the console by default. Please see the manual for your `cron` daemon to find out how it handles console output.

A logfile can be specified via the `-l` / `--logfile` command-line option.

If logging to syslog via the `-s` / `--log-to-syslog` option, the updater will write to the `user` section of the syslog. The file `/etc/syslog.conf` determines where syslog messages are saved.

### References

Some guides on X.509 certificates:

-   Useful commands: <http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html>
-   Install GSI authentication on a server: <http://security.ncsa.illinois.edu/research/wssec/gsihttps/>
-   Certificates how-to: <http://www.nordugrid.org/documents/certificate_howto.html>

Some examples about verifying the certificates:

-   <http://gagravarr.org/writing/openssl-certs/others.shtml>
-   <http://www.cyberciti.biz/faq/test-ssl-certificates-diagnosis-ssl-certificate/>
-   <http://www.cyberciti.biz/tips/debugging-ssl-communications-from-unix-shell-prompt.html>

Managing CAs
------------

The osg-ca-manage tool provides a unified interface to manage the CA Certificate installations. This page provides the instructions on using this command. It provides status commands that allows you to list the CAs and the validity of the CAs and CRLs included in the installation. The manage commands allow you to fetch CAs and CRLs, change the distribution URL, as well as add and remove CAs from your local installation.

### Usage examples

Documentation for usage of the osg-ca-manage tool can be found [here](https://github.com/opensciencegrid/osg-ca-scripts/)

!!! note
    These commands will not work if of the osg-ca-certs (or igtf-ca-certs) RPM packages are installed.

#### Install a certificate authority package

Before you proceed to install a Certificate Authority Package you should decide which of the available packages to install.

- `osg`, the package recommended to be used by production resources on the OSG. It is based on the CA distribution from the IGTF, but it may differ slightly as decided by the [Security Team](https://opensciencegrid.org/security).
- `igtf`, the package is a redistribution of the unchanged CA distribution from the IGTF
- `url` a package provided at a given URL

!!! note
    If in doubt, please consult the policies of your home institution and get in contact with the [Security Team](https://opensciencegrid.org/security).

Next decide at what location to install the Certificate Authority Package:

1.  on the `root` file system in a system directory `/etc/grid-security/certificates`
2.  in a `custom` directory that can also be shared

##### Setup the CA certificates

The Certificate Authority Package is preferably be used by grid users without root privileges *or* if the CA certificates will not be shared by other installations on the same host.

``` console
root@host # osg-ca-manage setupca --location root --url osg
Setting CA Certificates for at '/etc/grid-security/certificates'

Setup completed successfully.
```

After a successful installation the certificates will be installed in (`/etc/grid-security/certificates` in this example). Typically to write into this default location you will need root privileges.

If you need to need to install it with out root privileges use

``` console
user@host $ osg-ca-manage setupca --location $HOME/certificates --url osg
Setting CA Certificates for at '$HOME/certificates'

Setup completed successfully.
```

#### Adding a directory of local CAs

``` console
root@host #osg-ca-manage add --cadir /etc/grid-security/localca
NOTE:
    You did not specify the --auto-refresh flag.
    So the changes made to the configuration will not be reflected till the next time
    when CAs and CRLs are updated respectively by osg-update-certs and fetch-crl running from cron.
    Run `osg-ca-manage refreshCA` and `osg-ca-manage fetchCRL` to commit your changes immediately.
```

Here is the resulting file after add

``` file
##cat /etc/osg/osg-update-certs.conf
# Configuration file for osg-update-certs

# This file has been regenerated by osg-ca-manage, which removes most
# comments.  You can still manually modify it, any manual change will
# be preserved if osg-ca-manage is used again.

## The parent location certificates will be installed at.
install_dir = /etc/grid-security

## cacerts_url is the URL of your certificate distribution
cacerts_url = https://repo.opensciencegrid.org/pacman/cadist/ca-certs-version-igtf-new

## log specifies where logging output will go
log = /var/log/osg-update-certs.log

## include specifies files (full pathnames) that should be copied
## into the certificates installation after an update has occured.
include=/etc/grid-security/localca/*

## exclude_ca specifies a CA (not full pathnames, but just the hash
## of the CA you want to exclude) that should be removed from the
## certificates installation after an update has occured.

debug = 0
```

#### Removing a directory of local CAs

``` console
root@host #osg-ca-manage remove --cadir /etc/grid-security/localca
NOTE:
    You did not specify the --auto-refresh flag.
    So the changes made to the configuration will not be reflected till the next time
    when CAs and CRLs are updated respectively by osg-update-certs and fetch-crl running from cron.
    Run `osg-ca-manage refreshCA` and `osg-ca-manage fetchCRL` to commit your changes immediately.
```

#### Removing a particular CA included in OSG CA package

``` console
root@host #osg-ca-manage remove --caname ce33db76
Symlink detected for hash: We have determided that the hash value you entered belong to the CA 'IRAN-GRID.pem'. If you wish to add this CA back you will have to use this name is the parameter.
NOTE:
    You did not specify the --auto-refresh flag.
    So the changes made to the configuration will not be reflected till the next time
    when CAs and CRLs are updated respectively by osg-update-certs and fetch-crl running from cron.
    Run `osg-ca-manage refreshCA` and `osg-ca-manage fetchCRL` to commit your changes immediately.
```

The resulting config file after the remove is as follows

``` file
##cat /etc/osg/osg-update-certs.conf
# Configuration file for osg-update-certs

# This file has been regenerated by osg-ca-manage, which removes most
# comments.  You can still manually modify it, any manual change will
# be preserved if osg-ca-manage is used again.

## The parent location certificates will be installed at.
install_dir = /etc/grid-security

## cacerts_url is the URL of your certificate distribution
cacerts_url = https://repo.opensciencegrid.org/pacman/cadist/ca-certs-version-igtf-new

## log specifies where logging output will go
log = /var/log/osg-update-certs.log

## include specifies files (full pathnames) that should be copied
## into the certificates installation after an update has occured.

## exclude_ca specifies a CA (not full pathnames, but just the hash
## of the CA you want to exclude) that should be removed from the
## certificates installation after an update has occured.
exclude_ca = IRAN-GRID

debug = 0
```

#### Adding a CA from the OSG CA package

``` console
root@host #osg-ca-manage add --caname IRAN-GRID
NOTE:
    You did not specify the --auto-refresh flag.
    So the changes made to the configuration will not be reflected till the next time
    when CAs and CRLs are updated respectively by osg-update-certs and fetch-crl running from cron.
    Run `osg-ca-manage refreshCA` and `osg-ca-manage fetchCRL` to commit your changes immediately.
```

#### Inspect installed CA certificates

You can inspect the list of CA Certificates that have been installed:

``` console
user@host $ osg-ca-manage listCA
Hash=09ff08b7; Subject= /C=FR/O=CNRS/CN=CNRS2-Projets; Issuer= /C=FR/O=CNRS/CN=CNRS2; Accreditation=Unknown; Status=https://repo.opensciencegrid.org/pacman/cadist/ca-certs-version-new
Hash=0a12b607; Subject= /DC=org/DC=ugrid/CN=UGRID CA; Issuer= /DC=org/DC=ugrid/CN=UGRID CA; Accreditation=Unknown; Status=https://repo.opensciencegrid.org/pacman/cadist/ca-certs-version-new
[...]
```

Any certificate issued by any of the Certificate Authorities listed will be trusted. If in doubt please contact the [OSG Security Team](https://opensciencegrid.org/security) and review the policies of your home institution.

Troubleshooting
---------------

### Useful configuration and log files

Logs and configuration:

| File Description                        | Location                                        | Comment                                                                                                         |
|:----------------------------------------|:------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| Configuration File for osg-update-certs | `/etc/osg/osg-update-certs.conf`                | This file may be edited by hand, though it is recommended to use osg-ca-manage to set configuration parameters. |
| Log file of osg-update-certs            | `/var/log/osg-update-certs.log`                 |                                                                                                                 |
| Stdout of osg-update-certs              | `/var/log/osg-ca-certs-status.system.out`       |                                                                                                                 |
| Stdout of osg-ca-manage                 | `/var/log/osg-ca-manage.system.out`             |                                                                                                                 |
| Stdout of initial CA setup              | `/var/log/osg-setup-ca-certificates.system.out` |                                                                                                                 |

References
----------

-   [Installing the Certificate Authorities Certificates and the related RPMs](../common/ca.md)

