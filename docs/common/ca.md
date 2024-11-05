title: Installing Certificate Authorities (CAs)

Installing Certificate Authorities (CAs)
========================================

The [certificate authorities](https://en.wikipedia.org/wiki/Certificate_authority) (CAs) provide the trust roots for the
[public key infrastructure](https://en.wikipedia.org/wiki/Public_key_infrastructure) OSG uses to maintain integrity of its sites and services.
This document provides details of various options to install the Certificate Authority (CA) certificates and have up-to-date
[certificate revocation lists](https://en.wikipedia.org/wiki/Certificate_revocation_list) (CRLs) on your OSG hosts.

We provide three options for installing CA certificates that offer varying levels of control:

1.  Install an RPM for a specific set of CA certificates (*default*)
2.  Install `osg-ca-scripts`, a set of scripts that provide fine-grained CA management
3.  Install an RPM that doesn't install **any** CAs.
    This is useful if you'd like to manage CAs yourself while satisfying RPM dependencies.

Prior to following the instructions on this page, you must enable our [yum repositories](yum.md)

Installing CA Certificates
--------------------------

Please choose one of the three options to install CA certificates.

### Option 1: Install an RPM for a specific set of CA certificates ###

!!! note
    This option is the default if you install OSG software without pre-installing CAs.
    For example, `yum install osg-ce` will bring in `osg-ca-certs` by default.

In the OSG repositories, you will find two different sets of predefined CA certificates:

- (*default*) The OSG CA certificates. This is similar to the IGTF set but may have a small number of additions or deletions
- The [IGTF](http://www.igtf.net/) CA certificates

See [this page](https://osg-htc.org/security/CaDistribution/) for details of the contents of the OSG CA package.

| **If you chose...**  | **Then run the following command...** |
|----------------------|---------------------------------------|
| OSG CA certificates  | `yum install osg-ca-certs`            |
| IGTF CA certificates | `yum install igtf-ca-certs`           |

To automatically keep your RPM installation of CAs up to date, we recommend the [OSG CA certificates updater](../security/certificate-management.md#osg-ca-certificates-updater) service.

### Option 2: Install osg-ca-scripts ###

The `osg-ca-scripts` package provides scripts to install and update predefined sets of CAs with the ability to add or remove specific CAs. 

- The OSG CA certificates. This is similar to the IGTF set but may have a small number of additions or deletions
- The [IGTF](http://www.igtf.net/) CA certificates

See [this page](https://osg-htc.org/security/CaDistribution/) for details of the contents of the OSG CA package.

1. Install the `osg-ca-scripts` package:

        :::console
        root@host # yum install osg-ca-scripts

1. Choose and install the CA certificate set:

    | **If you choose...** | **Then run the following command...**              |
    |----------------------|----------------------------------------------------|
    | OSG CA certificates  | `osg-ca-manage setupCA --location root --url osg`  |
    | IGTF CA certificates | `osg-ca-manage setupCA --location root --url igtf` |

1. Enable the `osg-update-certs-cron` service to enable periodic CA updates. As a reminder, here are common service commands (all run as `root`):

    | To...                                   | Run the command...                            |
    | :-------------------------------------- | :-------------------------------------------- |
    | Start a service                         | `systemctl start <SERVICE-NAME>`              |
    | Stop a service                          | `systemctl stop <SERVICE-NAME>`               |
    | Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`             |
    | Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>`            |

1. (Optional) To add a new CA:

        osg-ca-manage add [--dir <local_dir>] --hash <CA-HASH>

1. (Optional) To remove a CA

        osg-ca-manage remove --hash <CA-HASH>

A complete set of options available though `osg-ca-manage` command, can be found in the [osg-ca-manage documentation](../security/certificate-management.md#managing-cas)

### Option 3: Site-managed CAs ###

If you want to handle the list of CAs completely internally to your site, you can utilize the `empty-ca-certs` RPM to satisfy
RPM dependencies while not actually installing any CAs. To install this RPM, run the following command:

``` console
root@host # yum install empty-ca-certs –-enablerepo=osg-empty
```

!!! warning
    If you choose this option, you are responsible for installing and maintaining the CA certificates. They must be installed in `/etc/grid-security/certificates`, or a symlink must be made from that location to the directory that contains the CA certificates.


### Installing other CAs ###

In addition to the above CAs, you can install other CAs via RPM. These only work with the RPMs that provide CAs (that is, `osg-ca-certs` and the like, but not `osg-ca-scripts`.) They are in addition to the above RPMs, so do not only install these extra CAs.

| **Set of CAs** | **RPM name**           | **Installation command (as root)**   |
|:---------------|:-----------------------|:-------------------------------------|
| [cilogon-openid](https://ca.cilogon.org/policy/openid) | cilogon-openid-ca-cert | `yum install cilogon-openid-ca-cert` |

Verifying CA Certificates
-------------------------

After installing or updating the CA certificates, they can be verified with the following command:

```console
root@host # curl --cacert <CA FILE> \
              --capath <CA DIRECTORY> \
              -o /dev/null \
              https://gracc.opensciencegrid.org \
              && echo "CA certificate installation verified"
```

Where `<CA FILE>` is the path to a valid X.509 CA certificate and `<CA DIRECTORY>` is the path to the directory
containing the installed CA certificates.
For example, the following command can be used to verify a default OSG CA certificate installation:

```console
root@host # curl --cacert /etc/grid-security/certificates/cilogon-osg.pem \
              --capath /etc/grid-security/certificates/ \
              -o /dev/null \
              https://gracc.opensciencegrid.org \
              && echo "CA certificate installation verified"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 22005    0 22005    0     0  86633      0 --:--:-- --:--:-- --:--:--  499k
CA certificate installation verified
```

If you do not see `CA certificate installation verified` this means that your CA certificate installation is broken.
First, ensure that your CA installation is up-to-date and if you continue to see issues please [contact us](#getting-help).

### Keeping CA Certificates Up-to-date ###

It is important to keep CA certificates up-to-date for services and their clients to maintain integrity of
production services.
To verify that your CA certificates are on the latest version on a given host, determine the most recently released
versions and the method by which your CA certificates have been installed:

1.  Retrieve the versions of the most recently released
    [IGTF CA certificates](https://repo.osg-htc.org/cadist/index.html) and
    [OSG CA certificates](https://repo.osg-htc.org/cadist/index-new.html)

1.  Determine which of the three CA certificate installation methods you are using:

        :::console
        # rpm -q igtf-ca-certs osg-ca-certs osg-ca-scripts empty-ca-certs

1.  Based on which package is installed from the output in the previous step, choose one of the following options:

    -   **If `igtf-ca-certs` or `osg-ca-certs` is installed**, compare the installed version from step 2 to the
        corresponding version from step 1.

        -   If the version is older than the corresponding version from step 1, continue onto 
            [option 1](#option-1-install-an-rpm-for-a-specific-set-of-ca-certificates) to upgrade your current
            installation and keep your installation up-to-date.

        -  If the versions match, your CA certificates are up-to-date!

    -   **If `osg-ca-scripts` is installed**, run the following command to update your CA certificates:

            :::console
            # osg-ca-manage refreshCA

        And continue to the instructions in [option 2](#option-2-install-osg-ca-scripts) to enable automatic
        updates of your CA certificates.

    -   **If `empty-ca-scripts` is installed**, then you are responsible for maintaining your own CA certificates as
            outlined in [option 3](#option-3-site-managed-cas).

    -   **If none of the packages are installed**, your host likely does not need CA certificates and you are done.

Managing Certificate Revocation Lists
-------------------------------------

In addition to CA certificates, you must have updated Certificate Revocation Lists (CRLs). CRLs contain certificate blacklists that OSG software uses to ensure that your hosts are only talking to valid clients or servers. To maintain up to date CAs, you will need to run the `fetch-crl` services. 

!!! note
    Normally `fetch-crl` is installed when you install the rest of the software and you do not need to explicitly install it.
    If you do wish to install it manually, run the following command:

        :::console
        root@host # yum install fetch-crl

If you do not wish to change the frequency of `fetch-crl` updates (default: every 6 hours) or use syslog for `fetch-crl` output, 
[skip to the service management section](#managing-fetch-crl-services)

### Optional: configuring `fetch-crl` ###

The following sub-sections contain optional configuration instructions.

!!! note
    Note that the `nosymlinks` option in the configuration files refers to ignoring links within the certificates directory (e.g. two different names for the same file). It is perfectly fine if the path of the CA certificates directory itself (`infodir`) is a link to a directory.

#### Changing the frequency of `fetch-crl-cron` ####

To modify the times that `fetch-crl-cron` runs, edit `/etc/cron.d/fetch-crl`.

#### Logging with syslog ####

`fetch-crl` can produce quite a bit of output when run in verbose mode. To send `fetch-crl` output to syslog, use the following instructions:

1.  Change the configuration file to enable syslog:

        logmode = syslog
        syslogfacility = daemon

1.  Make sure the file `/var/log/daemon` exists, e.g. touching the file
1.  Change `/etc/logrotate.d` files to rotate it

### Managing `fetch-crl` services ###

`fetch-crl` is installed as two different system services. The fetch-crl-boot service runs `fetch-crl` and is intended to only be enabled or disabled. The `fetch-crl-cron` service runs `fetch-crl` every 6 hours (with a random sleep time included). Both services are disabled by default. At the very minimum, the `fetch-crl-cron` service needs to be enabled and started, otherwise services will begin to fail as existing CRLs expire.

| Software  | Service name                 | Notes                                      |
|:----------|:-----------------------------|:-------------------------------------------|
| Fetch CRL | `fetch-crl.timer` (EL8+)     | Runs `fetch-crl` every 6 hours and on boot |

Start the services in the order listed and stop them in reverse order. As a reminder, here are common service commands (all run as `root`):

| To...                                   | Run the command...                            |
| :-------------------------------------- | :-------------------------------------------- |
| Start a service                         | `systemctl start <SERVICE-NAME>`              |
| Stop a service                          | `systemctl stop <SERVICE-NAME>`               |
| Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`             |
| Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>`            |

Getting Help
------------

To get assistance, please use the [this page](help.md).

References
----------

Some guides on X.509 certificates:

-   Useful commands: <http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html>
-   Install GSI authentication on a server: <http://security.ncsa.illinois.edu/research/wssec/gsihttps/>
-   Certificates how-to: <http://www.nordugrid.org/documents/certificate_howto.html>

See [this page](http://gagravarr.org/writing/openssl-certs/others.shtml) for examples of verifying certificates.


Related software:

-   [osg-ca-manage](../security/certificate-management.md#managing-cas)
-   [osg-ca-certs-updater](../security/certificate-management.md#osg-ca-certificates-updater)

### Configuration files ###

| Package                       | File Description                        | Location                                                                                    | Comment                                                                                                         |
|:------------------------------|:----------------------------------------|:--------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------|
| All CA Packages               | CA File Location                        | `/etc/grid-security/certificates`                                                           |                                                                                                                 |
| All CA Packages               | Index files                             | `/etc/grid-security/certificates/INDEX.html` or `/etc/grid-security/certificates/INDEX.txt` | Latest version also available at <http://repo.osg-htc.org/cadist/>                                              |
| All CA Packages               | Change Log                              | `/etc/grid-security/certificates/CHANGES`                                                   | Latest version also available at <http://repo.osg-htc.org/cadist/CHANGES>                                       |
| osg-ca-certs or igtf-ca-certs | contain only CA files                   |                                                                                             |                                                                                                                 |
| osg-ca-scripts                | Configuration File for osg-update-certs | `/etc/osg/osg-update-certs.conf`                                                            | This file may be edited by hand, though it is recommended to use osg-ca-manage to set configuration parameters. |
| fetch-crl-3.x                 | Configuration file                      | `/etc/fetch-crl.conf`                                                                       |                                                                                                                 |

The index and change log files contain a summary of all the CA distributed and their version.

### Logs files ###

| Package        | File Description             | Location                                        |
|:---------------|:-----------------------------|:------------------------------------------------|
| osg-ca-scripts | Log file of osg-update-certs | `/var/log/osg-update-certs.log`                 |
| osg-ca-scripts | Stdout of osg-update-certs   | `/var/log/osg-ca-certs-status.system.out`       |
| osg-ca-scripts | Stdout of osg-ca-manage      | `/var/log/osg-ca-manage.system.out`             |
| osg-ca-scripts | Stdout of initial CA setup   | `/var/log/osg-setup-ca-certificates.system.out` |
