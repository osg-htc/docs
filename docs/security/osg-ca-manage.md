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

1.  <verbatim>--verbose</verbatim> Provides you with more information depending on the command context.
2.   <verbatim>--force</verbatim> Forces the command to run ignoring any checks/warnings. The actual effect is context dependent, and this behavior is noted in the command details below.
3.   <verbatim>--cert-dir <location></verbatim> This location specifies the path CA directory. If this option is not specified then the command will look for $X509\_CERT\_DIR, and $VDT\_LOCATION/globus/TRUSTED\_CA respectively. If none of these directories can be found, the command will exit with an error.
4.  <verbatim>--auto-refresh </verbatim> This option will indicate if this permissible to fetch CAs and CRLs as deemed necessary by this tool. For example at the end of an addCA/removeCA it would be advisable to refresh the CA list and the corresponding CRLs. Default is **not** to refresh, unless the admin requests it by specifying this option.
5.  <verbatim>--version</verbatim> Prints the version of the vdt-ca-certs-manager tool.
6.  <verbatim>--help | --usage</verbatim> Print usage information. Show a brief explanatory text for using osg-ca-manage.

### Explanation of commands ###

Exactly one command is to be specified during an execution of osg-ca-manage

#### Status commands ####

1.   <verbatim>showCAURL</verbatim> This will print out the distribution location specified in the config file. This command will read osg-update-certs.conf and output cacerts\_url.
2.   <verbatim>listCA \[--pattern <pattern>\]</verbatim> This command will use openssl x509 command on the files in the --dir to provide hash, the subject and whether a CA is IGTF or TeraGrid accredited and distribution package which was used to download CAs into the directory. --verbose option will provide additional information like issuer (of CA) and all associated dates (CA cert issuance date, and CRL issuance date, and expiry dates). The command will look for CA files in the -certDir. The \\<pattern\\> specified in the option will be matched, using perl regex, against the subject field of the certificate (but we might also expand it include issuer if needed) and all CAs are listed if no pattern is given.
3.   <verbatim>verify \[--hash <CA\_hash> | --pattern <pattern>\]</verbatim> The verify command will check all CAs (or if specified only the \\<CA\_hash\\>) in the \\<certDir\\> directory, to see if any CA/CRL have expired or are about to do so. If any expired CA/CRL are found, an error is issued along with the hash, date when CA cert/CRL expired. A warning is issued if either the CA cert or CRL is about the expire within the next 24 Hrs. The --verbose option provides the CA Name, date the CA certs and CRL files are created (by the CA), and when they will expire. In addition to hash value we will also consider providing an option of verify using \\<pattern\\> 4. <verbatim>diffCAPackage</verbatim> This command will compare the hash of certificates included in the certificate directory against the latest VDT/OSG distribution (based on your cacerts\_url) and outputs the difference. 5. <verbatim>show \[--certfile <cert\_file> | --hash <CA\_hash>\]</verbatim> This command will essentially provide a condensed output of openssl x509 command. --verbose option will provide the full output. If --hash option is used we will look for the \\<CA\_hash\\>.o file in the \\<certDir\\>. The --certfile option can also take in a user proxy. 6. <verbatim>showChain \[--certfile <cert\_file> | --hash <CA\_hash>\]</verbatim> This command will output the trust chain of the certificate. \\<certDir\\> will be used as the directory in which search for ancestor certs will be conducted. This command can also be used to trace the trust chain of a user proxy.

#### Manage commands ####

1.  <verbatim>setupCA --location <root|PATH> \[--url <osg|igtf|URL> --no-update --force\]</verbatim> This command is used for the inital setup of the CA package. The CA package can be setup to download CAs from any URL. Keywords are provided for various distributions. For the location to specify, keywords are provided to install into 'root' (/etc/grid-security). A --no-update option is available. Setting this flag instructs just setup the symlinks only and not to run configure osg-update-certs to be run automatically. This option is for installations that will not manage their own certificates, but will rely on updates through another method (such as RPM, or using osg-update-certs from a different OSG installation). A common use case for this is to have worker-node installations rely on the CA certificates being available on an NFS share, and the updating will happen on a single node.
2.   <verbatim>refreshCA</verbatim> This command run osg-update-certs to check for a new version of the CA distribution. If you already have the latest version, but wish to force an update anyways, use the --force option. 1.<verbatim>fetchCRL</verbatim> It retrieves CRLs for all CAs within the directory. This will involve invoking fetch-crl, with appropriate arguments. NOTE: If vdt's fetch-crl service has not been enabled (i.e. no fetch-crl entry in crontab), then this command will not execute. This is a safety mechanism to prevent crls from being downloaded using this tool if they are not scheduled to be updated.
3.   <verbatim>setCAURL \[--url <osg|igtf|URL>\]</verbatim> This command sets the location from where the CA files. This command will modify vdt-update-certs.conf and set the cacerts\_url as <URL\_location>. Only if --auto-refresh is specified both CA and CRLs are refreshed once the URL change has been made. The distribution \\<URL\_location\\> will be required to conform to the VDT CA distribution format (e.g. similar to <http://vdt.cs.wisc.edu/software/certificates/ca-certs-version>). If the \\<URL\_location\\> cannot be reached or if it is valid syntactically (i.e. does not conform to the format requirements) a warning will be issues and no changes will be made. The --force option can be used to force a change ignoring the warning. If URL location is left unspecified the \\<URL\_location\\> will be set to OSG default. We define keywords for OSG, IGTF as shortcuts for OSG wide well-known CA URL\_locations.
4.   <verbatim>add \[--cadir <localdir> | --caname <CA>\]</verbatim> The --hash argument is required. If --dir is not specified we will assume that the user wants to include a CA he has previously excluded and will remove the corresponding exclude lines from the config. If \\<CA\_hash\\> is not known to us or it is already included we will provide appropriate error/warning information. In the common case this command will add include lines for \\<local\_dir\\>/\\<CA\_hash\\>.\*, into the vdt-update-certs.conf file. Lastly the command will invoke functions refresh the CAs and fetch CRLs. This command will also do some preliminary error checks, e.g. make sure that “.0”, “.crl\_url”, “.signing\_policy” files exist and that --dir is different than --certDir.
5.   <verbatim>remove \[--cadir <localdir> | --caname <CA>\]</verbatim> This command will be complementary to add and would either add an exclude or remove an include depending on the scenario. This command will also refresh CA and CRLs. vdt-update-certs do the job of removing cert files, we will still do the preliminary error checks to make sure that the certs that are being removed are included in the first place. For both addCA and removeCA, new CAs will be included/removed and CRLs will be refreshed only if --auto-refresh is set.

### Usage Examples ###

!!! note
    These commands will not work if of the osg-ca-certs (or igtf-ca-certs) RPM packages are installed.

#### Install a Certificate Authority Package ####

Before you proceed to install a Certificate Authority Package you should decide which of the available packages to install.

\* `osg`, the package recommended to be used by production resources on the <span class="twiki-macro LINK_OSG"></span>. It is based on the CA distribution from the <span class="twiki-macro LINK_IGTF"></span>, but it may differ slightly as decided by the [Security Team](Security/WebHome). \* `igtf`, the package is a redistribution of the unchanged CA distribution from the <span class="twiki-macro LINK_IGTF"></span>,

-   `url` a package provided at a given URL

!!! note
    If in doubt, please consult the policies of your home institution and get in contact with the [Security Team](Security/WebHome).

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
cacerts_url = http://software.grid.iu.edu/pacman/cadist/ca-certs-version-igtf-new

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
cacerts_url = http://software.grid.iu.edu/pacman/cadist/ca-certs-version-igtf-new

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
```

<details>``` %UCL_SCREEN%
user@host $ osg-ca-manage listCA
Hash=09ff08b7; Subject= /C=FR/O=CNRS/CN=CNRS2-Projets; Issuer= /C=FR/O=CNRS/CN=CNRS2; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=0a12b607; Subject= /DC=org/DC=ugrid/CN=UGRID CA; Issuer= /DC=org/DC=ugrid/CN=UGRID CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=0a2bac92; Subject= /C=BR/O=ICPEDU/O=UFF BrGrid CA/CN=UFF Brazilian Grid Certification Authority; Issuer= /C=BR/O=ICPEDU/O=UFF BrGrid CA/CN=UFF Brazilian Grid Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=1149214e; Subject= /C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN-Verein PCA Grid - G01; Issuer= /C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN-Verein PCA Grid - G01; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=11b4a5a2; Subject= /C=PT/O=LIPCA/CN=LIP Certification Authority; Issuer= /C=PT/O=LIPCA/CN=LIP Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=163af95c; Subject= /C=FR/O=CNRS/CN=CNRS2; Issuer= /C=FR/O=CNRS/CN=CNRS2; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=1691b9ba; Subject= /C=TR/O=TRGrid/CN=TR-Grid CA; Issuer= /C=TR/O=TRGrid/CN=TR-Grid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=169d7f9c; Subject= /C=NL/O=TERENA/CN=TERENA eScience Personal CA; Issuer= /C=US/ST=UT/L=Salt Lake City/O=The USERTRUST Network/OU=http://www.usertrust.com/CN=UTN-USERFirst-Client Authentication and Email; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=16da7552; Subject= /C=NL/O=NIKHEF/CN=NIKHEF medium-security certification auth; Issuer= /C=NL/O=NIKHEF/CN=NIKHEF medium-security certification auth; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=1c3f2ca8; Subject= /DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1; Issuer= /DC=net/DC=ES/O=ESnet/OU=Certificate Authorities/CN=ESnet Root CA 1; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=1d879c6c; Subject= /DC=ch/DC=cern/CN=CERN Trusted Certification Authority; Issuer= /DC=ch/DC=cern/CN=CERN Root CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=1e12d831; Subject= /C=AU/O=APACGrid/OU=CA/CN=APACGrid/emailAddress=camanager@vpac.org; Issuer= /C=AU/O=APACGrid/OU=CA/CN=APACGrid/emailAddress=camanager@vpac.org; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=1e43b9cc; Subject= /C=IE/O=Grid-Ireland/CN=Grid-Ireland Certification Authority; Issuer= /C=IE/O=Grid-Ireland/CN=Grid-Ireland Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=1f0e8352; Subject= /O=Grid/O=NorduGrid/CN=NorduGrid Certification Authority; Issuer= /O=Grid/O=NorduGrid/CN=NorduGrid Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=1f3834d0; Subject= /DC=RO/DC=RomanianGRID/O=ROSA/OU=Certification Authority/CN=RomanianGRID CA; Issuer= /DC=RO/DC=RomanianGRID/O=ROSA/OU=Certification Authority/CN=RomanianGRID CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=2418a3f3; Subject= /DC=bg/DC=acad/CN=BG.ACAD CA; Issuer= /DC=bg/DC=acad/CN=BG.ACAD CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=24c3ccde; Subject= /C=MX/O=UNAMgrid/OU=UNAM/CN=CA; Issuer= /C=MX/O=UNAMgrid/OU=UNAM/CN=CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=28a58577; Subject= /C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid Root CA 2006; Issuer= /C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid Root CA 2006; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=295adc19; Subject= /C=CL/O=REUNACA/CN=REUNA Certification Authority; Issuer= /C=CL/O=REUNACA/CN=REUNA Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=2a237f16; Subject= /DC=org/DC=balticgrid/CN=Baltic Grid Certification Authority; Issuer= /DC=org/DC=balticgrid/CN=Baltic Grid Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=2ac09305; Subject= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC MICS CA; Issuer= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC Root CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=2f3fadf6; Subject= /C=IT/O=INFN/CN=INFN CA; Issuer= /C=IT/O=INFN/CN=INFN CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=304cf809; Subject= /C=CH/O=Switch - Teleinformatikdienste fuer Lehre und Forschung/CN=SWITCHslcs CA; Issuer= /C=CH/O=Switch - Teleinformatikdienste fuer Lehre und Forschung/CN=SWITCHgrid Root CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=3232b9bc; Subject= /DC=me/DC=ac/DC=MREN/CN=MREN-CA; Issuer= /DC=me/DC=ac/DC=MREN/CN=MREN-CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=367b75c3; Subject= /C=UK/O=eScienceCA/OU=Authority/CN=UK e-Science CA; Issuer= /C=UK/O=eScienceRoot/OU=Authority/CN=UK e-Science Root; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=393f7863; Subject= /C=RS/O=AEGIS/CN=AEGIS-CA; Issuer= /C=RS/O=AEGIS/CN=AEGIS-CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=3d5be7bc; Subject= /C=SI/O=SiGNET/CN=SiGNET CA; Issuer= /C=SI/O=SiGNET/CN=SiGNET CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=3f0f4285; Subject= /C=VE/O=Grid/O=Universidad de Los Andes/OU=CeCalCULA/CN=ULAGrid Certification Authority; Issuer= /C=VE/O=Grid/O=Universidad de Los Andes/OU=CeCalCULA/CN=ULAGrid Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=468d15b3; Subject= /DC=ORG/DC=SEE-GRID/CN=SEE-GRID CA; Issuer= /DC=ORG/DC=SEE-GRID/CN=SEE-GRID CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=4798da47; Subject= /DC=HK/DC=HKU/DC=GRID/CN=HKU Grid CA; Issuer= /DC=HK/DC=HKU/DC=GRID/CN=HKU Grid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=55994d72; Subject= /C=RU/O=RDIG/CN=Russian Data-Intensive Grid CA; Issuer= /C=RU/O=RDIG/CN=Russian Data-Intensive Grid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=5cf9d536; Subject= /C=BM/O=QuoVadis Limited/OU=Root Certification Authority/CN=QuoVadis Root Certification Authority; Issuer= /C=BM/O=QuoVadis Limited/OU=Root Certification Authority/CN=QuoVadis Root Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=617ff41b; Subject= /C=JP/O=KEK/OU=CRC/CN=KEK GRID Certificate Authority; Issuer= /C=JP/O=KEK/OU=CRC/CN=KEK GRID Certificate Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=67e8acfa; Subject= /CN=Purdue TeraGrid RA/OU=Purdue TeraGrid/O=Purdue University/ST=Indiana/C=US; Issuer= /CN=PurdueCA/O=Purdue University/ST=Indiana/C=US; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=684261aa; Subject= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC Root CA; Issuer= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC Root CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=6e3b436b; Subject= /C=AT/O=AustrianGrid/OU=Certification Authority/CN=Certificate Issuer; Issuer= /C=AT/O=AustrianGrid/OU=Certification Authority/CN=Certificate Issuer; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=6fee79b0; Subject= /C=IL/O=IUCC/CN=IUCC/emailAddress=ca@mail.iucc.ac.il; Issuer= /C=IL/O=IUCC/CN=IUCC/emailAddress=ca@mail.iucc.ac.il; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=709bed08; Subject= /DC=by/DC=grid/O=uiip.bas-net.by/CN=Belarusian Grid Certification Authority; Issuer= /DC=by/DC=grid/O=uiip.bas-net.by/CN=Belarusian Grid Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=712ae4cc; Subject= /DC=cz/DC=cesnet-ca/O=CESNET CA/CN=CESNET CA 3; Issuer= /DC=cz/DC=cesnet-ca/O=CESNET CA/CN=CESNET CA Root; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=71a89a47; Subject= /DC=TW/DC=ORG/DC=NCHC/CN=NCHC CA; Issuer= /DC=TW/DC=ORG/DC=NCHC/CN=NCHC CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=722e5071; Subject= /C=KR/O=KISTI/O=GRID/CN=KISTI Grid Certificate Authority; Issuer= /C=KR/O=KISTI/O=GRID/CN=KISTI Grid Certificate Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=742edd45; Subject= /DC=LV/DC=latgrid/CN=Certification Authority for Latvian Grid; Issuer= /DC=LV/DC=latgrid/CN=Certification Authority for Latvian Grid; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=75680d2e; Subject= /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services; Issuer= /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=7721d4d3; Subject= /DC=NET/DC=PRAGMA-GRID/CN=PRAGMA-UCSD CA; Issuer= /DC=NET/DC=PRAGMA-GRID/CN=PRAGMA-UCSD CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=7b54708e; Subject= /C=MA/O=MaGrid/CN=MaGrid CA; Issuer= /C=MA/O=MaGrid/CN=MaGrid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=7d0d064a; Subject= /C=MK/O=MARGI/CN=MARGI-CA; Issuer= /C=MK/O=MARGI/CN=MARGI-CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=82b36fca; Subject= /C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2006; Issuer= /C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid Root CA 2006; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=8a047de1; Subject= /C=TH/O=NECTEC/OU=GOC/CN=NECTEC GOC CA; Issuer= /C=TH/O=NECTEC/OU=GOC/CN=NECTEC GOC CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=8a661490; Subject= /C=PL/O=GRID/CN=Polish Grid CA; Issuer= /C=PL/O=GRID/CN=Polish Grid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=95009ddc; Subject= /CN=PurdueCA/O=Purdue University/ST=Indiana/C=US; Issuer= /CN=PurdueCA/O=Purdue University/ST=Indiana/C=US; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=98ef0ee5; Subject= /C=UK/O=eScienceRoot/OU=Authority/CN=UK e-Science Root; Issuer= /C=UK/O=eScienceRoot/OU=Authority/CN=UK e-Science Root; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=99f9f5a3; Subject= /DC=gov/DC=fnal/O=Fermilab/OU=Certificate Authorities/CN=Kerberized CA HSM; Issuer= /DC=gov/DC=fnal/O=Fermilab/OU=Certificate Authorities/CN=Kerberized CA HSM; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=9b59ecad; Subject= /DC=cz/DC=cesnet-ca/CN=CESNET CA; Issuer= /DC=cz/DC=cesnet-ca/CN=CESNET CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=9b95bbf2; Subject= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=CACL; Issuer= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=CACL; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=9cd75e87; Subject= /C=TW/O=AS/CN=Academia Sinica Grid Computing Certification Authority Mercury; Issuer= /C=TW/O=AS/CN=Academia Sinica Grid Computing Certification Authority Mercury; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=9dd23746; Subject= /DC=es/DC=irisgrid/CN=IRISGridCA; Issuer= /DC=es/DC=irisgrid/CN=IRISGridCA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=9ec3a561; Subject= /C=US/ST=UT/L=Salt Lake City/O=The USERTRUST Network/OU=http://www.usertrust.com/CN=UTN-USERFirst-Client Authentication and Email; Issuer= /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=9ff26ea4; Subject= /DC=MD/DC=MD-Grid/O=RENAM/OU=Certification Authority/CN=MD-Grid CA; Issuer= /DC=MD/DC=MD-Grid/O=RENAM/OU=Certification Authority/CN=MD-Grid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=a02131f7; Subject= /C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN SLCS-CA; Issuer= /C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN SLCS-CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=a317c467; Subject= /C=JP/O=AIST/OU=GRID/CN=Certificate Authority; Issuer= /C=JP/O=AIST/OU=GRID/CN=Certificate Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=a87d9192; Subject= /C=JP/O=National Research Grid Initiative/OU=CGRD/CN=NAREGI CA; Issuer= /C=JP/O=National Research Grid Initiative/OU=CGRD/CN=NAREGI CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=a9082267; Subject= /DC=BR/DC=UFF/DC=IC/O=UFF LACGrid CA/CN=UFF Latin American and Caribbean Catch-all Grid CA; Issuer= /DC=BR/DC=UFF/DC=IC/O=UFF LACGrid CA/CN=UFF Latin American and Caribbean Catch-all Grid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=afe55e66; Subject= /C=CY/O=CyGrid/O=HPCL/CN=CyGridCA; Issuer= /C=CY/O=CyGrid/O=HPCL/CN=CyGridCA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=b2771d44; Subject= /DC=CN/DC=Grid/CN=Root Certificate Authority at CNIC; Issuer= /DC=CN/DC=Grid/CN=Root Certificate Authority at CNIC; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=b7bcb7b2; Subject= /C=AR/O=e-Ciencia/OU=UNLP/L=CeSPI/CN=PKIGrid; Issuer= /C=AR/O=e-Ciencia/OU=UNLP/L=CeSPI/CN=PKIGrid; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=b93d6240; Subject= /DC=net/DC=ES/OU=Certificate Authorities/CN=NERSC Online CA; Issuer= /DC=net/DC=ES/O=ESnet/OU=Certificate Authorities/CN=ESnet Root CA 1; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=ba2f39ca; Subject= /C=CN/O=HEP/CN=gridca-cn/emailAddress=gridca@ihep.ac.cn; Issuer= /C=CN/O=HEP/CN=gridca-cn/emailAddress=gridca@ihep.ac.cn; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=bffbd7d0; Subject= /C=CA/O=Grid/CN=Grid Canada Certificate Authority; Issuer= /C=CA/O=Grid/CN=Grid Canada Certificate Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=c48c63f3; Subject= /DC=CN/DC=Grid/DC=SDG/CN=Scientific Data Grid CA; Issuer= /DC=CN/DC=Grid/CN=Root Certificate Authority at CNIC; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=cc800af0; Subject= /C=HU/O=NIIF/OU=Certificate Authorities/CN=NIIF Root CA; Issuer= /C=HU/O=NIIF/OU=Certificate Authorities/CN=NIIF Root CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=ce33db76; Subject= /C=IR/O=IPM/O=IRAN-GRID/CN=IRAN-GRID CA; Issuer= /C=IR/O=IPM/O=IRAN-GRID/CN=IRAN-GRID CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=d0b701c0; Subject= /C=CH/O=Switch - Teleinformatikdienste fuer Lehre und Forschung/CN=SWITCHgrid Root CA; Issuer= /C=CH/O=Switch - Teleinformatikdienste fuer Lehre und Forschung/CN=SWITCHgrid Root CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=d0c2a341; Subject= /C=AM/O=ArmeSFo/CN=ArmeSFo CA; Issuer= /C=AM/O=ArmeSFo/CN=ArmeSFo CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=d11f973e; Subject= /C=FR/O=CNRS/CN=GRID2-FR; Issuer= /C=FR/O=CNRS/CN=CNRS2-Projets; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=d1737728; Subject= /C=SG/O=Netrust Certificate Authority 1/OU=Netrust CA1; Issuer= /C=SG/O=Netrust Certificate Authority 1/OU=Netrust CA1; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=d1b603c3; Subject= /DC=net/DC=ES/O=ESnet/OU=Certificate Authorities/CN=ESnet Root CA 1; Issuer= /DC=net/DC=ES/O=ESnet/OU=Certificate Authorities/CN=ESnet Root CA 1; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=d254cc30; Subject= /DC=ch/DC=cern/CN=CERN Root CA; Issuer= /DC=ch/DC=cern/CN=CERN Root CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=da75f6a8; Subject= /DC=IN/DC=GARUDAINDIA/CN=Indian Grid Certification Authority; Issuer= /DC=IN/DC=GARUDAINDIA/CN=Indian Grid Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=dd4b34ea; Subject= /C=DE/O=GermanGrid/CN=GridKa-CA; Issuer= /C=DE/O=GermanGrid/CN=GridKa-CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=e13e0fcf; Subject= /C=SK/O=SlovakGrid/CN=SlovakGrid CA; Issuer= /C=SK/O=SlovakGrid/CN=SlovakGrid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=e5cc84c2; Subject= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC Classic CA; Issuer= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC Root CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=e72045ce; Subject= /C=BM/O=QuoVadis Limited/OU=Issuing Certification Authority/CN=QuoVadis Grid ICA; Issuer= /C=BM/O=QuoVadis Limited/OU=Root Certification Authority/CN=QuoVadis Root Certification Authority; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=e8ac4b61; Subject= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=GridShib CA; Issuer= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=GridShib CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=e8d818e6; Subject= /C=BE/OU=BEGRID/O=BELNET/CN=BEgrid CA; Issuer= /C=BE/OU=BEGRID/O=BELNET/CN=BEgrid CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=edca0fc0; Subject= /DC=cz/DC=cesnet-ca/O=CESNET CA/CN=CESNET CA Root; Issuer= /DC=cz/DC=cesnet-ca/O=CESNET CA/CN=CESNET CA Root; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=f2e89fe3; Subject= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=MyProxy; Issuer= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=MyProxy; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=f5ead794; Subject= /C=PK/O=NCP/CN=PK-GRID-CA; Issuer= /C=PK/O=NCP/CN=PK-GRID-CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
Hash=ff94d436; Subject= /C=HR/O=edu/OU=srce/CN=SRCE CA; Issuer= /C=HR/O=edu/OU=srce/CN=SRCE CA; Accreditation=Unknown; Status=http://software.grid.iu.edu/pacman/cadist/ca-certs-version
```

</details>

Any certificate issued by any of the Certificate Authorities listed will be trusted. If in doubt please contact the [OSG Security Team](Security/WebHome) and review the policies of your home institution.

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

-   [Installing the Certificate Authorities Certificates and the related RPMs](InstallCertAuth)


