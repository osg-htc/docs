Managing CAs
============

The osg-ca-manage tool provides a unified interface to manage the CA Certificate installations. This page provides the instructions on using this command. It provides status commands that allows you to list the CAs and the validity of the CAs and CRLs included in the installation. The manage commands allow you to fetch CAs and CRLs, change the distribution URL, as well as add and remove CAs from your local installation.

Syntax
------

       osg-ca-manage [global_options] command 
        global_options =
            [--verbose]
            [--force]
            [--cert-dir <location>]
            [--help | --usage]
            [--version]
            [--auto-refresh]

        command = [manage_command | status_command] 

        status_command = [
            showCAURL |
            listCA [--pattern <pattern>] |
            verify [--hash <CA hash>  | --pattern <pattern>] |
            diffCAPackage |
            show [--certfile <cert_file> | --hash <CA hash>] |
            showChain [--certfile <cert_file> | --hash <CA hash>]
        ]

        manage_command = [
            setupCA --location <root|PATH> [--url <osg|igtf|URL> --no-update --force] |
            refreshCA |
            fetchCRL |
            setCAURL [--url <osg|igtf|URL>] |
            add [--cadir <localdir> | --caname <CA>]
            remove [--cadir <localdir> | --caname <CA>]
        ]

### Explanation of global options ###

Zero or more of these options may be used during an execution of ca\_manage.

1.  `--verbose` Provides you with more information depending on the command context.
2.   `--force` Forces the command to run ignoring any checks/warnings. The actual effect is context dependent, and this behavior is noted in the command details below.
3.   `--cert-dir <location>` This location specifies the path CA directory. If this option is not specified then the command will look for `$X509_CERT_DIR`, and `$VDT_LOCATION/globus/TRUSTED_CA` respectively. If none of these directories can be found, the command will exit with an error.
4.  `--auto-refresh ` This option will indicate if this permissible to fetch CAs and CRLs as deemed necessary by this tool. For example at the end of an addCA/removeCA it would be advisable to refresh the CA list and the corresponding CRLs. Default is **not** to refresh, unless the admin requests it by specifying this option.
5.  `--version` Prints the version of the vdt-ca-certs-manager tool.
6.  `--help | --usage` Print usage information. Show a brief explanatory text for using osg-ca-manage.

### Explanation of commands ###

Exactly one command is to be specified during an execution of osg-ca-manage

#### Status commands ####

1.   `showCAURL` This will print out the distribution location specified in the config file. This command will read osg-update-certs.conf and output cacerts\_url.
2.   `listCA [--pattern <pattern>]` This command will use openssl x509 command on the files in the --dir to provide hash, the subject and whether a CA is IGTF or TeraGrid accredited and distribution package which was used to download CAs into the directory. --verbose option will provide additional information like issuer (of CA) and all associated dates (CA cert issuance date, and CRL issuance date, and expiry dates). The command will look for CA files in the -certDir. The `<pattern>` specified in the option will be matched, using perl regex, against the subject field of the certificate (but we might also expand it include issuer if needed) and all CAs are listed if no pattern is given.
3.   `verify [--hash <CA_hash> | --pattern <pattern>]` The verify command will check all CAs (or if specified only the `<CA_hash>`) in the `<certDir>` directory, to see if any CA/CRL have expired or are about to do so. If any expired CA/CRL are found, an error is issued along with the hash, date when CA cert/CRL expired. A warning is issued if either the CA cert or CRL is about the expire within the next 24 Hrs. The --verbose option provides the CA Name, date the CA certs and CRL files are created (by the CA), and when they will expire. In addition to hash value we will also consider providing an option of verify using `<pattern>` 
4. `diffCAPackage` This command will compare the hash of certificates included in the certificate directory against the latest VDT/OSG distribution (based on your cacerts\_url) and outputs the difference. 
5. `show [--certfile <cert_file> | --hash <CA_hash>]` This command will essentially provide a condensed output of openssl x509 command. --verbose option will provide the full output. If --hash option is used we will look for the `<CA_hash>.o` file in the `<certDir>`. The --certfile option can also take in a user proxy. 
6. `showChain [--certfile <cert_file> | --hash <CA_hash>]` This command will output the trust chain of the certificate. `<certDir>` will be used as the directory in which search for ancestor certs will be conducted. This command can also be used to trace the trust chain of a user proxy.

#### Manage commands ####

1.  `setupCA --location <root|PATH> [--url <osg|igtf|URL> --no-update --force]` This command is used for the inital setup of the CA package. The CA package can be setup to download CAs from any URL. Keywords are provided for various distributions. For the location to specify, keywords are provided to install into 'root' (/etc/grid-security). A --no-update option is available. Setting this flag instructs just setup the symlinks only and not to run configure osg-update-certs to be run automatically. This option is for installations that will not manage their own certificates, but will rely on updates through another method (such as RPM, or using osg-update-certs from a different OSG installation). A common use case for this is to have worker-node installations rely on the CA certificates being available on an NFS share, and the updating will happen on a single node.
2.   `refreshCA` This command run osg-update-certs to check for a new version of the CA distribution. If you already have the latest version, but wish to force an update anyways, use the --force option. 1.`fetchCRL` It retrieves CRLs for all CAs within the directory. This will involve invoking fetch-crl, with appropriate arguments. NOTE: If vdt's fetch-crl service has not been enabled (i.e. no fetch-crl entry in crontab), then this command will not execute. This is a safety mechanism to prevent crls from being downloaded using this tool if they are not scheduled to be updated.
3.   `setCAURL [--url <osg|igtf|URL>]` This command sets the location from where the CA files. This command will modify vdt-update-certs.conf and set the cacerts\_url as `<URL_location>`. Only if --auto-refresh is specified both CA and CRLs are refreshed once the URL change has been made. The distribution `<URL_location>` will be required to conform to the VDT CA distribution format (e.g. similar to <http://vdt.cs.wisc.edu/software/certificates/ca-certs-version>). If the `<URL_location>` cannot be reached or if it is valid syntactically (i.e. does not conform to the format requirements) a warning will be issues and no changes will be made. The --force option can be used to force a change ignoring the warning. If URL location is left unspecified the `<URL_location>` will be set to OSG default. We define keywords for OSG, IGTF as shortcuts for OSG wide well-known CA URL\_locations.
4.   `add [--cadir <localdir> | --caname <CA>]` The --hash argument is required. If --dir is not specified we will assume that the user wants to include a CA he has previously excluded and will remove the corresponding exclude lines from the config. If `<CA_hash>` is not known to us or it is already included we will provide appropriate error/warning information. In the common case this command will add include lines for `<local_dir>`/`<CA_hash>`.*, into the vdt-update-certs.conf file. Lastly the command will invoke functions refresh the CAs and fetch CRLs. This command will also do some preliminary error checks, e.g. make sure that “.0”, “.crl\_url”, “.signing\_policy” files exist and that --dir is different than --certDir.
5.   `remove [--cadir <localdir> | --caname <CA>]` This command will be complementary to add and would either add an exclude or remove an include depending on the scenario. This command will also refresh CA and CRLs. vdt-update-certs do the job of removing cert files, we will still do the preliminary error checks to make sure that the certs that are being removed are included in the first place. For both addCA and removeCA, new CAs will be included/removed and CRLs will be refreshed only if --auto-refresh is set.

### Usage Examples ###

!!! note
    These commands will not work if of the osg-ca-certs (or igtf-ca-certs) RPM packages are installed.

#### Install a Certificate Authority Package ####

Before you proceed to install a Certificate Authority Package you should decide which of the available packages to install.

- `osg`, the package recommended to be used by production resources on the OSG. It is based on the CA distribution from the IGTF, but it may differ slightly as decided by the [Security Team](https://opensciencegrid.github.io/security). 
- `igtf`, the package is a redistribution of the unchanged CA distribution from the IGTF
- `url` a package provided at a given URL

!!! note
    If in doubt, please consult the policies of your home institution and get in contact with the [Security Team](https://opensciencegrid.github.io/security).

Next decide at what location to install the Certificate Authority Package:

1.  on the `root` file system in a system directory `/etc/grid-security/certificates`
2.  in a `custom` directory that can also be shared

##### Setup the CA Certificates #####

The Certificate Authority Package is preferably be used by grid users without root privileges *or* if the CA certificates will not be shared by other installations on the same host.

``` console
root@host # osg-ca-manage setupca --location %RED%root%ENDCOLOR% --url osg
Setting CA Certificates for at '/etc/grid-security/certificates'

Setup completed successfully.
```

After a successful installation the certificates will be installed in (`/etc/grid-security/certificates` in this example). Typically to write into this default location you will need root privileges.

If you need to need to install it with out root privileges use

``` console
user@host $ osg-ca-manage setupca --location %RED%$HOME/certificates%ENDCOLOR% --url osg
Setting CA Certificates for at '$HOME/certificates'

Setup completed successfully.
```

#### Adding/Removing a directory of local CAs ####

##### Adding #####

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
cacerts_url = https://repo.grid.iu.edu/pacman/cadist/ca-certs-version-igtf-new

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

##### Removing #####

``` console
root@host #osg-ca-manage remove --cadir /etc/grid-security/localca
NOTE:
    You did not specify the --auto-refresh flag.
    So the changes made to the configuration will not be reflected till the next time
    when CAs and CRLs are updated respectively by osg-update-certs and fetch-crl running from cron.
    Run `osg-ca-manage refreshCA` and `osg-ca-manage fetchCRL` to commit your changes immediately.
```

#### Removing/Adding a particular CA included in OSG CA package ####

##### Removing #####

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
cacerts_url = https://repo.grid.iu.edu/pacman/cadist/ca-certs-version-igtf-new

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

##### Adding back the removed CA #####

``` console
root@host #osg-ca-manage add --caname IRAN-GRID
NOTE:
    You did not specify the --auto-refresh flag.
    So the changes made to the configuration will not be reflected till the next time
    when CAs and CRLs are updated respectively by osg-update-certs and fetch-crl running from cron.
    Run `osg-ca-manage refreshCA` and `osg-ca-manage fetchCRL` to commit your changes immediately.
```

#### Inspect Installed CA Certificates ####

You can inspect the list of CA Certificates that have been installed:

``` console
user@host $ osg-ca-manage listCA
Hash=09ff08b7; Subject= /C=FR/O=CNRS/CN=CNRS2-Projets; Issuer= /C=FR/O=CNRS/CN=CNRS2; Accreditation=Unknown; Status=https://repo.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=0a12b607; Subject= /DC=org/DC=ugrid/CN=UGRID CA; Issuer= /DC=org/DC=ugrid/CN=UGRID CA; Accreditation=Unknown; Status=https://repo.grid.iu.edu/pacman/cadist/ca-certs-version
[...]
```

Any certificate issued by any of the Certificate Authorities listed will be trusted. If in doubt please contact the [OSG Security Team](https://opensciencegrid.github.io/security) and review the policies of your home institution.

Troubleshooting
---------------

### Useful configuration and log files ###

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

-   [Installing the Certificate Authorities Certificates and the related RPMs](../common/ca)


