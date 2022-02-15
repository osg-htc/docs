Installing and Maintaining the LCMAPS VOMS Plugin
=================================================

!!! warning
    This document is for software that will no longer be supported after the OSG 3.5 retirement (beginning of May 2022).
    See the [Release Series Support Policy](https://opensciencegrid.org/technology/policy/release-series/) for details.

LCMAPS is a software library used on [HTCondor-CE](../compute-element/install-htcondor-ce.md), [GridFTP](../data/gridftp.md), and
[XRootD](../data/xrootd/install-storage-element.md) hosts for mapping grid certificates of incoming connections to specific
Unix accounts.
The LCMAPS VOMS plugin enables LCMAPS to make mapping decisions based on the VOMS attributes of grid certificates, e.g.
`/cms/Role=production/Capability=NULL`.

The OSG provides a default set of mappings from VOMS attributes to Unix accounts.
By configuring LCMAPS, you can override these mappings, including changing the Unix account that a VO is mapped to;
adding custom mappings for specific users and VOMS attributes; and/or banning specific users and VOMS attributes.

Use this page to learn how to install and configure the LCMAPS VOMS plugin to authenticate users to access your
resources on a per-VO basis.


Installing the LCMAPS VOMS Plugin
---------------------------------

To install the LCMAPS VOMS plugin, make sure that your host is up to date before installing the required packages:

1. Clean yum cache:

        ::console
        root@host # yum clean all --enablerepo=*

2. Update software:

        :::console
        root@host # yum update

    This command will update **all** packages

1. Install `lcmaps`, the default mapfile, and the configuration tools:

        :::console
        root@host # yum install lcmaps vo-client-lcmaps-voms osg-configure-misc


Configuring the LCMAPS VOMS Plugin
----------------------------------

The following section describes the steps required to configure the LCMAPS VOMS plugin for authentication.
Additionally, there are [optional configuration](#optional-configuration) instructions if you need to make changes to
the default mappings.

### Supporting mapped VOs and users

 Ensure Unix accounts exist for each VO, VO role, VO group, or user you choose to support in the [mapfiles](#configuration-files):

1.  Consult the default VO mappings in `/usr/share/osg/voms-mapfile-default` to determine the mapped Unix account names.
    Each of the mapfiles has the following format:

        "<VO, VO role, VO group or user>" <Unix account>


1.  Create Unix accounts for each VO, VO role, VO group, and user that you wish to support.
    The full list of VOs is located in the [OSG topology](https://github.com/opensciencegrid/topology/tree/master/virtual-organizations).
    You are not expected to support all the VOs.
    If you would like to support opportunistic usage, we recommend creating the following Unix accounts:

    | **VO name**                                                                                             | **Unix account(s)** |
    |---------------------------------------------------------------------------------------------------------|---------------------|
    | [GLOW](https://github.com/opensciencegrid/topology/blob/master/virtual-organizations/GLOW.yaml)         | `glow`              |
    | [OSG](https://github.com/opensciencegrid/topology/blob/master/virtual-organizations/OSG.yaml)           | `osg`               |
    | [ATLAS](https://github.com/opensciencegrid/topology/blob/master/virtual-organizations/ATLAS.yaml)       | `usatlas3`          |
    | [CMS](https://github.com/opensciencegrid/topology/blob/master/virtual-organizations/CMS.yaml)           | `cmsuser`           |
    | [Fermilab](https://github.com/opensciencegrid/topology/blob/master/virtual-organizations/Fermilab.yaml) | `fnalgrid`          |
    | [HCC](https://github.com/opensciencegrid/topology/blob/master/virtual-organizations/HCC.yaml)           | `hcc`               |
    | [Gluex](https://github.com/opensciencegrid/topology/blob/master/virtual-organizations/Gluex.yaml)       | `gluex`             |

1.  Edit `/etc/osg/config.d/30-gip.ini` and specify the supported VOs per [Subcluster or ResourceEntry section](../other/configuration-with-osg-configure.md#subcluster-resource-entry-for-agis-glideinwms-entry):

        :::ini
        allowed_vos="VO1,VO2..."

### Applying configuration settings

Making changes to the OSG configuration files in the `/etc/osg/config.d` directory does not apply those settings to
software automatically.
For the OSG settings, use the [osg-configure](../other/configuration-with-osg-configure.md) tool to validate (to a limited
extent) and apply the settings to the relevant software components.
If instead you wish to manage the LCMAPS VOMS plugin configuration yourself, skip to the
[manual configuration section](#manual-configuration).

1.  Make all changes to `.ini` files in the `/etc/osg/config.d` directory.

    !!!note
        This document only describes the critical settings for the LCMAPS VOMS plugin and related software.
        You may need to configure other software that is installed on your host, too.

1.  Validate the configuration settings:

        :::console
        root@host # osg-configure -v

1.  Once the validation command succeeds without errors, apply the configuration settings:

        :::console
        root@host # osg-configure -c



### Optional configuration

The following subsections contain information on mapping or banning users by their
certificates' Distinguished Names (DNs) or by their proxies' VOMS attributes.
Any optional configuration is to be performed after the installation and configuration sections above.

For a table of the configuration files and their order of evaluation, consult the [reference section](#configuration-files).

-   [Mapping VOs](#mapping-vos)
-   [Mapping users](#mapping-users)
-   [Banning VOs](#banning-vos)
-   [Banning users](#banning-users)
-   [Mapping using all FQANs](#mapping-using-all-fqans)

#### Mapping VOs

To map VOs, VO roles, or VO groups to Unix accounts based on their VOMS attributes, create `/etc/grid-security/voms-mapfile`.
An example of the format of a `voms-mapfile` follows:

```
# map GLOW jobs in the chtc group to the 'glow1' Unix account.
"/GLOW/chtc/*" glow1
# map GLOW jobs with the htpc role to the 'glow2' Unix account.
"/GLOW/Role=htpc/*" glow2
# map other GLOW jobs to the 'glow' Unix account.
"/GLOW/*" glow
```

Each non-commented line is a shell-style pattern which is compared against the user's VOMS attributes, and a Unix
account that the user will be mapped to if the pattern matches.
The patterns are compared in the order they are listed in. Therefore, more general patterns should be placed later in
the file.

!!!note
    The Unix account must exist for the user to be mapped.
    If a VO's Unix account is missing, that VO will not be able to access your resources.

    Additionally, if you map VOMS attributes to a non-existent user in `/etc/grid-security/voms-mapfile`,
    `/usr/share/osg/voms-mapfile-default` will be considered next to find a mapping.
    The best way to ban a VO is edit `/etc/grid-security/ban-voms-mapfile` as described in [Banning VOs](#banning-vos)
    below.
    Do not edit `voms-mapfile-default` as your changes will be overwritten upon updates.


#### Mapping users

To map specific users to Unix accounts based on their certificates' DNs, create `/etc/grid-security/grid-mapfile`.

!!!note
    The openssl version 1.1.x command prints the subject DN in a slightly different format.
    OpenSSL version 1.1 is present on Enterprise Linux 8 systems.
    The new format is a comma separated list of attributes.
    You must convert that back to the older format for our map files.
    Each attribute must start with a `/` and there are no spaces around the `=` and remove the comma between attributes:

    ```
    DC = org, DC = opensciencegrid, O = Open Science Grid, OU = People, CN = Matyas Selmeci
    ```

    should be written as:

    ```
    /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=People/CN=Matyas Selmeci
    ```


An example of the format of a `grid-mapfile` follows:

```
# map Matyas's FNAL DN to the 'matyas' Unix account
"/DC=gov/DC=fnal/O=Fermilab/OU=People/CN=Matyas Selmeci/CN=UID:matyas" matyas
```


!!! note
    The Unix account must exist for the user to be mapped. If a user's Unix account is missing, that user will not be
    able to access your resources.


#### Banning VOs

`/etc/grid-security/ban-voms-mapfile` is used to ban an entire VO or a role withing a VO from accessing resources on
your machine.
An example of the format of a `ban-voms-mapfile` follows:

```
# ban CMS production jobs
"/cms/Role=production/*"
```

Each non-commented line is a shell-style pattern which is compared against a user's VOMS attributes.
If the pattern matches, that user will be unable to access your resources.

!!!danger
    When banning VOs, you must restart the services using LCMAPS VOMS authentication (e.g. `condor-ce`,
    `globus-gridftp-server`, `xrootd`, etc.) to clear any authentication caches. In the case of XRootD
    when the service is not restarted the change could take up to 12hrs to take effect. This can be
    modified by defining the `authzto` option in the `sec.protocol` configuration attribute, e.g.:

        sec.protocol /usr/lib64 gsi \
            -certdir:/etc/grid-security/certificates \
            -cert:/etc/grid-security/xrd/xrdcert.pem \
            ...
            -authzto:3600

    The units of `-authzto` are in seconds which means that the above will set the LCMAPS cache lifetime to 1hr.

!!!warning
    `/etc/grid-security/ban-voms-mapfile` *must* exist, even if you are not banning any VOs.
    In that case, the file should not contain any entries. If the file does not exist, LCMAPS will ban every user.


#### Banning users

`/etc/grid-security/ban-mapfile` is used to ban specific users from accessing your resources based on their
certificates' DNs. An example of the format of a `ban-mapfile` follows:

```
# ban Matyas's FNAL DN
"/DC=gov/DC=fnal/O=Fermilab/OU=People/CN=Matyas Selmeci/CN=UID:matyas"
```

!!!danger
    When banning users, you must restart the services using LCMAPS VOMS authentication (e.g. `condor-ce`,
    `globus-gridftp-server`, `xrootd`, etc.) to clear any authentication caches. In the case of XRootD
    when the service is not restarted the change could take up to 12hrs to take effect. This can be
    modified by defining the `authzto` option in the `sec.protocol` configuration attribute, e.g.:

        sec.protocol /usr/lib64 gsi \
            -certdir:/etc/grid-security/certificates \
            -cert:/etc/grid-security/xrd/xrdcert.pem \
            ...
            -authzto:3600

    The units of `-authzto` are in seconds which means that the above will set the LCMAPS cache lifetime to 1hr.

!!!warning
    `/etc/grid-security/ban-mapfile` *must* exist, even if you are not banning any users.
    In that case, the file should be blank. If the file does not exist, LCMAPS will ban every user.



### Mapping using all FQANs

By default, the LCMAPS VOMS plugin only considers the first FQAN of a VOMS proxy for mapping.
If you want to consider all FQANs, you must set the appropriate option.

-   If you are using osg-configure, set `all_fqans = True` in `10-misc.ini`, then run `osg-configure -c`

-   If you are configuring `lcmaps.db` manually (see [manual configuration](#manual-configuration) below),
    add `"-all-fqans"` to the module definitions for `vomsmapfile` and `defaultmapfile`

Using the LCMAPS VOMS Plugin
----------------------------

LCMAPS is a software library that is called for authentication;
therefore, there are no running services and it does not have to be invoked manually.

Validating the LCMAPS VOMS Plugin VO Mappings
---------------------------------------------

To validate the LCMAPS VOMS plugin by itself, use the following procedure to test mapping your own cert to a user:

1.  Verify your DN is *not* in `/etc/grid-security/grid-mapfile`, or else it will generate a false positive
1.  Verify your DN is *not* in `/etc/grid-security/ban-mapfile`, or else it will generate a false negative
1.  Install the `llrun` and `voms-clients` packages:

        :::console
        root@host # yum install llrun voms-clients

1.  As an unprivileged user, create a VOMS proxy (filling in `<YOUR_VO>` with a VO you are a member of):

        :::console
        user@host $ voms-proxy-init -voms <YOUR_VO>

1.  Verify that your credentials are mapped as expected:

        :::console
        user@host $ llrun -s -l mode=pem,policy=authorize_only,db=/etc/lcmaps.db \
            -p/tmp/x509up_u`id -u`

If you did not get correctly mapped, check your proxy's FQAN by running:
``` console
user@host $ voms-proxy-info -fqan
```
and make sure it matches one of the patterns in `/etc/grid-security/voms-mapfile` or
`/usr/share/osg/voms-mapfile-default`, and does not match any patterns in `/etc/grid-security/ban-voms-mapfile`.

Troubleshooting the LCMAPS VOMS Plugin
--------------------------------------

LCMAPS logs to `journalctl` and the verbosity of the logging can be increased by modifying the appropriate
configuration and restarting the relevant service.
This section outlines the configuration necessary to raise the debug level for the different hosts that can use LCMAPS
VOMS authentication as well as common LCMAPS VOMS authentication issues.

### HTCondor-CE hosts ###

If you are troubleshooting an HTCondor-CE host, follow these instructions to raise the LCMAPS debug level:

1. Add the following text to `/etc/sysconfig/condor-ce`:

        :::bash
        export LCMAPS_DEBUG_LEVEL=5
        # optional (uncomment the following line to output log messages to a file):
        # export LCMAPS_LOG_FILE=/tmp/lcmaps.log

1. Disable HTCondor-CE authentication caches by creating `/etc/condor-ce/config.d/99-disablegsicache.conf` with the
   following contents:

        GSS_ASSIST_GRIDMAP_CACHE_EXPIRATION = 0

1. Restart the [condor-ce](https://htcondor.github.io/htcondor-ce/v5/verification/#managing-htcondor-ce-services) service

!!! tip
    After you've completed troubleshooting, remember to revert the changes above and restart services!

### XRootD hosts ###

If you are troubleshooting an XRootD host, follow these instructions to raise the LCMAPS debug level:

1. Choose the configuration file to edit based on the following table:

    | If you are running XRootD in... | Then modify the following file...   |
    |:--------------------------------|:------------------------------------|
    | Standalone mode                 | `/etc/xrootd/xrootd-standalone.cfg` |
    | Clustered mode                  | `/etc/xrootd/xrootd-clustered.cfg`  |

1. Set `loglevel=5` under the `-authzfunparms` of the `sec.protocol /usr/lib64 gsi` line. For example:

        :::file hl_lines="6"
        sec.protocol /usr/lib64 gsi -certdir:/etc/grid-security/certificates \
                    -cert:/etc/grid-security/xrootd/xrootdcert.pem \
                    -key:/etc/grid-security/xrootd/xrootdkey.pem \
                    -crl:1 \
                    -authzfun:libXrdLcmaps.so \
                    -authzfunparms:lcmapscfg=/etc/xrootd/lcmaps.cfg,loglevel=5,policy=authorize_only \
                    -gmapopt:10 -gmapto:0

1. Restart the [xrootd](../data/xrootd/install-storage-element.md#managing-xrootd-services) service

!!! tip
    After you've completed troubleshooting, remember to revert the changes above and restart services!

### GridFTP hosts ###

If you are troubleshooting a GridFTP host, follow these instructions to raise the LCMAPS debug level:

1. Add the following text to `/etc/sysconfig/globus-gridftp-server`:

        :::bash
        export LCMAPS_DEBUG_LEVEL=5
        # optional (uncomment the following line to output log messages to a file):
        # export LCMAPS_LOG_FILE=/tmp/lcmaps.log

1. Restart the [globus-gridftp-server](../data/gridftp.md#managing-gridftp) service.

!!! tip
    After you've completed troubleshooting, remember to revert the changes above and restart services!

### Common issues

#### A user/VO still has access to my XRootD server after adding them to the ban files
The best way to ensure that a user/VO is immediately banned is to restart the XRootD server after adding the DN or VOMS attributes to the corresponding ban file.
If the above is not possible, the the lifetime of the LCMAPS cache for XRootD can be controlled by setting the parameter `authzto`
within the `sec.protocol` configuration attribute, e.g.:

    sec.protocol /usr/lib64 gsi \
    -certdir:/etc/grid-security/certificates \
    -cert:/etc/grid-security/xrd/xrdcert.pem \
    ...
    -authzto:3600

The units of `-authzto` are in seconds which means that the above will set the LCMAPS cache lifetime to 1hr.
The default value for this parameter is 12hrs.



#### Wrong version of GridFTP

If you have the EPEL version of the GridFTP server, you may see error messages in `journalctl`
or the location specified by `LCMAPS_LOG_FILE`.

**Symptoms**

```
Apr 11 13:51:41 atlas-hub globus-gridftp-server: You are still root after the LCMAPS execution. The implicit root-mapping safety is enabled. See documentation for details
```

**Next actions**

1. If the versions of the `globus-gridftp-server-*` packages do not end in `osgXX.elY`, 
   continue with these instructions.
   To check the version of your `globus-gridftp-server-*`, run the following command:

        :::console
        user@host $ rpm -qa 'globus-gridftp*'

1. Verify that the [priority](../common/yum.md#install-the-yum-priorities-plugin-el7) of the OSG repositories are set
   properly

1. Clean your yum cache

        :::console
        root@host # yum clean all --enablerepo=*

1. Reinstall `globus-gridftp-server`:

        :::console
        root@host # yum update globus-gridftp-server

Getting Help
------------

To get assistance, please use the [this page](../common/help.md).

Reference
---------

### Configuration Files

The files are evaluated in the following order, with earlier files taking precedence over later ones:

| File                                  | Provider | Purpose           |
|:--------------------------------------|:---------|:------------------|
| `/etc/grid-security/ban-mapfile`      | Admin    | Ban DNs           |
| `/etc/grid-security/ban-voms-mapfile` | Admin    | Ban VOs           |
| `/etc/grid-security/grid-mapfile`     | Admin    | Map DNs           |
| `/etc/grid-security/voms-mapfile`     | Admin    | Map VOs           |
| `/usr/share/osg/voms-mapfile-default` | OSG      | Map VOs (default) |

!!! warning
    `/usr/share/osg/voms-mapfile-default` is not meant to be edited and will be overwritten on upgrades.
    All VO mappings can be overridden by editing the above files in `/etc/grid-security`.

### Manual Configuration

This section is intended for use as reference if you choose to forego configuring the LCMAPS VOMS plugin via
osg-configure (i.e., if you prefer a configuration management system like [Ansible](https://www.ansible.com/) or
[Puppet](https://puppet.com/)).
Therefore, the following instructions serve as a replacement for [this section](#applying-configuration-settings) above.

LCMAPS is configured in `/etc/lcmaps.db` and since the VOMS plugin is a newer component, configuration for it may not
be present in your existing `/etc/lcmaps.db` file.

1.  Ensure the following lines are present in the "Module definitions" section (the top section, before
    `authorize_only`) of `/etc/lcmaps.db`:

        gridmapfile = "lcmaps_localaccount.mod"
                      "-gridmap /etc/grid-security/grid-mapfile"
        banfile = "lcmaps_ban_dn.mod"
                  "-banmapfile /etc/grid-security/ban-mapfile"
        banvomsfile = "lcmaps_ban_fqan.mod"
                      "-banmapfile /etc/grid-security/ban-voms-mapfile"
        vomsmapfile = "lcmaps_voms_localaccount.mod"
                      "-gridmap /etc/grid-security/voms-mapfile"
        defaultmapfile = "lcmaps_voms_localaccount2.mod"
                         "-gridmap /usr/share/osg/voms-mapfile-default"

        verifyproxynokey = "lcmaps_verify_proxy2.mod"
                  "--allow-limited-proxy"
                  "--discard_private_key_absence"
                  " -certdir /etc/grid-security/certificates"

1.  Edit the `authorize_only` section so that it contains only the following uncommented lines:

        verifyproxynokey -> banfile
        banfile -> banvomsfile | bad
        banvomsfile -> gridmapfile | bad
        gridmapfile -> good | vomsmapfile
        vomsmapfile -> good | defaultmapfile
        defaultmapfile -> good | bad

1.  Edit `/etc/grid-security/gsi-authz.conf` and ensure that it contains the following line with a newline at the end:

        globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout
