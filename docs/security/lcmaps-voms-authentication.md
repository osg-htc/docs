Installing and Maintaining the LCMAPS VOMS Plugin
=================================================

LCMAPS is a software library used on [HTCondor-CE](../compute-element/install-htcondor-ce), [GridFTP](../data/gridftp), and [XRootD](../data/install-xrootd) hosts for mapping grid certificates of incoming connections to specific Unix accounts. The LCMAPS VOMS plugin enables LCMAPS to make mapping decisions based on the VOMS attributes of grid certificates, e.g., `/cms/Role=production/Capability=NULL`. Starting in OSG 3.4, the LCMAPS VOMS plugin will replace GUMS and edg-mkgridmap as the authentication method at OSG sites.

The OSG provides a default set of mappings from VOMS attributes to Unix accounts. By configuring LCMAPS, you can override these mappings, including changing the Unix account that a VO is mapped to, banning based on VOMS attributes, banning a specific user, or adding a VO, VO group, VO role, and/or user that is not in the OSG's set of mappings.

Use this page to learn how to install and configure the LCMAPS VOMS plugin to authenticate users to access your resources on a per-VO basis.


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

The following section describes the steps required to configure the LCMAPS VOMS plugin for authentication. If you are using OSG 3.3 packages, there are software-specific instructions that must be followed for [HTCondor-CE](../compute-element/install-htcondor-ce), [GridFTP](../data/gridftp), and [XRootD](../data/install-xrootd). To check if you are running OSG 3.3, run the following command:

``` console
root@host # rpm -q --queryformat="%{VERSION}\n" osg-release
```

Additionally, there is [optional configuration](#optional-configuration) if you need to make changes to the default mappings.


### Enabling the LCMAPS VOMS plugin

To configure your host to use LCMAPS VOMS plugin authentication, edit `/etc/osg/config.d/10-misc.ini` and set the following options:

``` ini
edit_lcmaps_db = True
authorization_method = vomsmap
```

If the `glexec_location` option is present, you must comment it out or set it to `UNAVAILABLE`.
The LCMAPS VOMS plugin does not work with gLExec.

### Supporting mapped VOs and users

Unix accounts must exist for each VO, VO role, VO group, or user you choose to support in the [mapfiles](#configuration-files):

1.  Consult the default VO mappings in `/usr/share/osg/voms-mapfile-default` to determine the mapped Unix account names. Each of the mapfiles has the following format:

        "%RED%<VO, VO role, VO group or user>%ENDCOLOR%" %RED%<Unix account>%ENDCOLOR%


1.  Create Unix accounts for each VO, VO role, VO group, and user that you wish to support
1.  Edit `/etc/osg/config.d/30-gip.ini` and specify the supported VOs per [Subcluster or ResourceEntry section](../other/configuration-with-osg-configure#subcluster-resource-entry):

``` ini
allowed_vos="VO1,VO2..."
```

The full list of VOs is located on [OIM](https://oim.opensciencegrid.org/oim/vo).
You are not expected to support all the VOs.
If you would like to support opportunistic usage, we recommend creating the following Unix accounts:

| **VO name**                                             | **Unix account(s)**                                                    |
|---------------------------------------------------------|------------------------------------------------------------------------|
| [GLOW](https://oim.opensciencegrid.org/oim/vo?id=13)    | `glow`                                                                 |
| [OSG](https://oim.opensciencegrid.org/oim/vo?id=30)     | `osg`                                                                  |
| [ATLAS](https://oim.opensciencegrid.org/oim/vo?id=35)   | `usatlas1`, `usatlas2`, `usatlas3`, `usatlas4`                         |
| [CMS](https://oim.opensciencegrid.org/oim/vo?id=3)      | `cmspilot`, `uscmslocal`, `cmslocal`, `cmsprod`, `lcgadmin`, `cmsuser` |
| [Fermilab](https://oim.opensciencegrid.org/oim/vo?id=9) | `fermigli`, `fermilab`                                                 |
| [HCC](https://oim.opensciencegrid.org/oim/vo?id=67)     | `hcc`                                                                  |
| [Gluex](https://oim.opensciencegrid.org/oim/vo?id=62)   | `gluex`                                                                |


### Applying configuration settings

Making changes to the OSG configuration files in the `/etc/osg/config.d` directory does not apply those settings to software automatically. For the OSG settings, use the [osg-configure](../other/configuration-with-osg-configure) tool to validate (to a limited extent) and apply the settings to the relevant software components. If instead you wish to manage the LCMAPS VOMS plugin configuration yourself, skip to the [manual configuration section](#manual-configuration).

1.  Make all changes to `.ini` files in the `/etc/osg/config.d` directory.

    !!!note
        This document only describes the critical settings for the LCMAPS VOMS plugin and related software. You may need to configure other software that is installed on your host, too.

1.  Validate the configuration settings:

        :::console
        root@host # osg-configure -v

1.  Once the validation command succeeds without errors, apply the configuration settings:

        :::console
        root@host # osg-configure -c



### Optional configuration

The following subsections contain information on migration from `edg-mkgridmap`, mapping or banning users by their certificates' Distinguished Names (DNs) or by their proxies' VOMS attributes. Any optional configuration is to be performed after the installation and configuration sections above.

For a table of the configuration files and their order of evaluation, consult the [reference section](#configuration-files).

-   [Migrating from edg-mkgridmap](#migrating-from-edg-mkgridmap)
-   [Mapping VOs](#mapping-vos)
-   [Mapping users](#mapping-users)
-   [Banning VOs](#banning-vos)
-   [Banning users](#banning-users)
-   [Mapping using all FQANs](#mapping-using-all-fqans)


#### Migrating from edg-mkgridmap

The program edg-mkgridmap (found in the package `edg-mkgridmap`), used for authentication on HTCondor-CE, GridFTP, and XRootD hosts, is no longer available starting in OSG 3.4. The LCMAPS VOMS plugin (package `lcmaps-plugins-voms`) now provides the same functionality. To migrate from edg-mkgridmap to the LCMAPS VOMS plugin, perform the following procedure:

1.  Configure user DN mappings:

    * If you have a local grid mapfile (see [the EDG-mkgridmap docs](../security/edg-mkgridmap)), replace the contents of `/etc/grid-security/grid-mapfile` with the contents of the local grid mapfile.

    * If you do not have a local grid mapfile, remove `/etc/grid-security/grid-mapfile`.

1.  If you are remaining on OSG 3.3, ensure that the you have set `export LLGT_VOMS_ENABLE_CREDENTIAL_CHECK=1` in the appropriate file and restart the service. If you have updated your host to OSG 3.4, skip to the next step.

    | **If your host is a(n)...** | **Add the aforementioned line to...**  | **And restart this service...** |
    |:----------------------------|:---------------------------------------| :------------------------------ |
    | HTCondor-CE                 | `/etc/sysconfig/condor-ce`             | `condor-ce`                     |
    | GridFTP server              | `/etc/sysconfig/globus-gridftp-server` | `globus-gridftp-server`         |

1.  If you are converting an HTCondor-CE host, remove the HTCondor-CE `GRIDMAP` configuration. Otherwise, skip to the next step.

    1. Find where `GRIDMAP` is set:

            :::console
            root@host # condor_ce_config_val -v GRIDMAP

    1. If the above command returns `Not defined: GRIDMAP`, skip to step 4. Otherwise, delete the line that sets the `GRIDMAP` configuration variable
    1. Reconfigure HTCondor-CE:

            :::console
            root@host # condor_ce_reconfig

1. If running OSG 3.3, disable edg-mkgridmap:

        :::console
        root@host # service edg-mkgridmap stop
        root@host # chkconfig edg-mkgridmap off

1. If running OSG 3.4, remove edg-mkgridmap and related packages:

        :::console
        root@host # yum erase edg-mkgridmap

    !!! warning
        In the output from this command, yum should **not** list other packages than the one.
        If it lists other packages, cancel the erase operation, make sure the other packages are updated to their latest OSG 3.4 versions (they should have ".osg34" in their versions), and try again.


#### Mapping VOs

`/etc/grid-security/voms-mapfile` is used to map VOs, VO roles, or VO groups to Unix accounts based on their VOMS attributes. An example of the format of a `voms-mapfile` follows:

```
# map GLOW jobs in the chtc group to the 'glow1' Unix account.
"/GLOW/chtc/*" glow1
# map GLOW jobs with the htpc role to the 'glow2' Unix account.
"/GLOW/Role=htpc/*" glow2
# map other GLOW jobs to the 'glow' Unix account.
"/GLOW/*" glow
```

Each non-commented line is a shell-style pattern which is compared against the user's VOMS attributes, and a Unix account that the user will be mapped to if the pattern matches.
The patterns are compared in the order they are listed in. Therefore, more general patterns should be placed later in the file.

!!!note
    The Unix account must exist for the user to be mapped. If a VO's Unix account is missing, that VO will not be able to access your resources.

    Additionally, if you map VOMS attributes to a non-existent user in `/etc/grid-security/voms-mapfile`, `/usr/share/osg/voms-mapfile-default` will be considered next to find a mapping. The best way to ban a VO is edit `/etc/grid-security/ban-voms-mapfile` as described in [Banning VOs](#banning-vos) below. Do not edit `voms-mapfile-default` as your changes will be overwritten upon updates.


#### Mapping users

`/etc/grid-security/grid-mapfile` is used to map specific users to Unix accounts based on their certificates' DNs. An example of the format of a `grid-mapfile` follows:

```
# map Matyas's FNAL DN to the 'matyas' Unix account
"/DC=gov/DC=fnal/O=Fermilab/OU=People/CN=Matyas Selmeci/CN=UID:matyas" matyas
```

!!! note
    The Unix account must exist for the user to be mapped. If a user's Unix account is missing, that user will not be able to access your resources.


#### Banning VOs

`/etc/grid-security/ban-voms-mapfile` is used to ban an entire VO or a role withing a VO from accessing resources on your machine. An example of the format of a `ban-voms-mapfile` follows:

```
# ban CMS production jobs
"/cms/Role=production/*"
```

Each non-commented line is a shell-style pattern which is compared against a user's VOMS attributes. If the pattern matches, that user will be unable to access your resources.

!!!danger
    When banning VOs, you must restart the services using LCMAPS VOMS authentication (e.g. `condor-ce`, `globus-gridftp-server`, etc.) to clear any authentication caches.

!!!warning
    `/etc/grid-security/ban-voms-mapfile` *must* exist, even if you are not banning any VOs. In that case, the file should be blank. If the file does not exist, LCMAPS will ban every user.


#### Banning users

`/etc/grid-security/ban-mapfile` is used to ban specific users from accessing your resources based on their certificates' DNs. An example of the format of a `ban-mapfile` follows:

```
# ban Matyas's FNAL DN
"/DC=gov/DC=fnal/O=Fermilab/OU=People/CN=Matyas Selmeci/CN=UID:matyas"
```

!!!danger
    When banning users, you must restart the services using LCMAPS VOMS authentication (e.g. `condor-ce`, `globus-gridftp-server`, etc.) to clear any authentication caches.

!!!warning
    `/etc/grid-security/ban-mapfile` *must* exist, even if you are not banning any users. In that case, the file should be blank. If the file does not exist, LCMAPS will ban every user.



### Mapping using all FQANs

By default, the LCMAPS VOMS plugin only considers the first FQAN of a VOMS proxy for mapping. This matches the behavior of GUMS. If you want to consider all FQANs, you must set the appropriate option.

-   If you are using osg-configure, set `all_fqans = True` in `10-misc.ini`, then run `osg-configure -c`

    !!! note
        If you are using OSG 3.3, osg-configure should be at least version 1.10.2.  If you are using OSG 3.4, osg-configure should be at least version 2.2.2.

-   If you are configuring `lcmaps.db` manually (see [manual configuration](#manual-configuration) below), add `"-all-fqans"` to the module definitions for `vomsmapfile` and `defaultmapfile`

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
        user@host $ voms-proxy-init -voms %RED%<YOUR_VO>%ENDCOLOR%

1.  Verify that your credentials are mapped as expected:

        :::console
        user@host $ llrun -s -l mode=pem,policy=authorize_only,db=/etc/lcmaps.db \
            -p/tmp/x509up_u`id -u`

If you did not get correctly mapped, check your proxy's FQAN by running:
``` console
user@host $ voms-proxy-info -fqan
```
and make sure it matches one of the patterns in `/etc/grid-security/voms-mapfile` or `/usr/share/osg/voms-mapfile-default`, and does not match any patterns in `/etc/grid-security/ban-voms-mapfile`.

Troubleshooting the LCMAPS VOMS Plugin
--------------------------------------

LCMAPS logs to `journalctl` (EL7) or `/var/log/messages` (EL6) and the verbosity of the logging can be increased by setting the `LCMAPS_DEBUG_LEVEL` environment variable. You can also change the destination of the logging by setting the `LCMAPS_LOG_FILE` environment variable.

1.  Use the table below to choose the appropriate file to edit:

    | If your host is a(n)... | Edit this file...                      |
    |:------------------------|:---------------------------------------|
    | HTCondor-CE             | `/etc/sysconfig/condor-ce`             |
    | GridFTP server          | `/etc/sysconfig/globus-gridftp-server` |

    Add the following to the file chosen in the previous step:

        :::bash
        export LCMAPS_DEBUG_LEVEL=5
        # optional (uncomment the following line to output log messages to a file):
        # export LCMAPS_LOG_FILE=/tmp/lcmaps.log


1.  Use the table below to choose the appropriate service to restart:

    | If your host is a(n)... | Restart the following service... |
    |:------------------------|:---------------------------------|
    | HTCondor-CE             | `condor-ce`                      |
    | GridFTP server          | `globus-gridftp-server`          |


### Troubleshooting mapping with HTCondor-CE

HTCondor-CE caches auth lookups for 30 minutes by default. If you are testing changes to your various mapfiles with HTCondor-CE, you will need to disable this caching.

To do this, create a file in `/etc/condor-ce/config.d` called e.g. `99-disablegsicache.conf` with the following line:

```
GSS_ASSIST_GRIDMAP_CACHE_EXPIRATION=0
```

and then restart `condor-ce`.

Once you are satisfied that your mappings are working, you may remove this file and restart `condor-ce` in order to reduce the load on your CE caused by authentication.

Getting Help
------------

To get assistance, please use the [this page](../common/help).

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

This section is intended for use as reference if you choose to forego configuring the LCMAPS VOMS plugin via osg-configure (i.e., if you prefer a configuration management system like [Ansible](https://www.ansible.com/) or [Puppet](https://puppet.com/)). Therefore, the following instructions serve as a replacement for [this section](#applying-configuration-settings) above.

LCMAPS is configured in `/etc/lcmaps.db`. and since the VOMS plugin is a newer component, configuration for it may not be present in your existing `/etc/lcmaps.db` file.

1.  Ensure the following lines are present in the "Module definitions" section (the top section, before `authorize_only`) of `/etc/lcmaps.db`:

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

