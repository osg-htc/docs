Updating to OSG 3.5
===================

!!! note "OS Version Support"
    OSG 3.5 only supports EL7

If you have an existing installation based on OSG release version <= 3.4 (which will be referred to as the *old series*),
and want to upgrade to 3.5 (the *new series*), we recommend the following procedure:

1.  First, remove the old series yum repositories:

        :::console
        root@host # rpm -e osg-release

    This step ensures that any local modifications to `*.repo` files will not prevent installing the new series repos.
    Any modified `*.repo` files should appear under `/etc/yum.repos.d/` with the `*.rpmsave` extension.
    After installing the new OSG repositories (the next step) you may want to apply any changes made in the `*.rpmsave`
    files to the new `*.repo` files.

2.  Install the OSG repositories:

        :::console
        root@host # yum install https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm

3.  Clean yum cache:

        :::console
        root@host # yum clean all --enablerepo=*

4. Update software:

        :::console
        root@host # yum update

    !!! info
        -   Please be aware that running `yum update` may also update other RPMs.
            You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the
            `yum` command.
        -   Watch the yum update carefully for any messages about a `.rpmnew` file being created.
            That means that a configuration file had been edited, and a new default version was to be installed.
            In that case, RPM does not overwrite the edited configuration file but instead installs the new version with
            a `.rpmnew` extension.
            You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version
            into place (that is, without the `.rpmnew` extension).
            Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

1. Remove any deprecated packages that were previously installed:

        :::console
        root@host # yum remove osg-version \
                               osg-control \
                               'rsv*' \
                               glite-ce-cream-client-api-c \
                               glite-lbjp-common-gsoap-plugin \
                               xacml

    If you did not have any of the above packages installed, Yum will not remove any packages:

        No Match for argument: osg-version
        No Match for argument: osg-control
        No Match for argument: rsv*
        No Match for argument: glite-ce-cream-client-api-c
        No Match for argument: glite-lbjp-common-gsoap-plugin
        No Match for argument: xacml
        No Packages marked for removal

1. If you are updating an HTCondor-CE host, please consult the manual [HTCondor](#updating-to-htcondor-88x_1) and
[OSG Configure](#updating-to-osg-configure-3) instructions below.

!!! tip "Running into issues?"
    If you are not having the expected result or having problems with Yum please see the
    [Yum troubleshooting guide](yum-basics.md#troubleshooting)

Updating to HTCondor-CE 4.x
---------------------------

The OSG 3.5 release series contains HTCondor-CE 4, a major version upgrade from the previously released versions in the OSG.
See the HTCondor-CE 4.0.0 [release notes](https://github.com/htcondor/htcondor-ce/releases/tag/v4.0.0) for an overview
of the changes.
In particular, this version includes a major reorganization of the default configuration so updates will require manual
intervention.
To update your HTCondor-CE host(s), perform the following steps:

1. Update all CE packages:

        :::console
        root@host # yum update htcondor-ce 'osg-ce*'

1. The new default `condor_mapfile` is sufficient since HTCondor-CE no longer relies on GSI authentication between
   its daemons.
   If `/etc/condor-ce/condor_mapfile.rpmnew` exists, replace your old `condor_mapfile` with the `.rpmnew` version:

        :::console
        root@host # mv /etc/condor-ce/condor_mapfile.rpmnew /etc/condor-ce/condor_mapfile

1. Merge any `*.rpmnew` files in `/etc/condor-ce/config.d/`

1. Additionally, you may wish to make one or more of the following optional changes:

    - HTCondor-CE now disables batch system job retries by default.
      To re-enable job retries, set the following configuration in `/etc/condor-ce/config.d/99-local.conf`:

            ENABLE_JOB_RETRIES = True

    - For non-HTCondor sites that use [remote CE requirements](../compute-element/job-router-recipes.md#setting-batch-system-directives),
      the new version of HTCondor-CE accepts a simplified format.
      For example, a snippet from an example job route in the old format:

            set_default_remote_cerequirements = strcat("Walltime == 3600 && AccountingGroup =="", x509UserProxyFirstFQAN, "\"");

        May be rewritten as the following:

            set_WallTime = 3600;
            set_AccountingGroup = x509UserProxyFirstFQAN;
            set_default_CERequirements = "Walltime,AccountingGroup";

1. Reload and restart the HTCondor-CE daemons:

        :::console
        root@host # systemctl daemon-reload
        root@host # systemctl restart condor-ce

### Updating to HTCondor 8.8.x ###

The OSG 3.5 release series contains HTCondor 8.8, a major version upgrade from the previously released versions in the OSG.
See the detailed [update instructions below](#updating-to-htcondor-88x_1) to update to HTCondor 8.8.

Updating to OSG Configure 3
---------------------------

The OSG 3.5 release series contains OSG-Configure 3, a major version upgrade from the previously released versions in the OSG.
See the OSG Configure release notes for an overview of the
[changes](https://github.com/opensciencegrid/osg-configure/releases/tag/v3.0.0).
To update OSG Configure on your HTCondor-CE, perform the following steps:

1. If you haven't already, [update to OSG 3.5](#updating-to-osg-35).

1. If you have `site_name` set in `/etc/osg/config.d/40-siteinfo.ini`, delete it and specify `resource` instead.
   `resource` should match the resource name that's registered in
   [OSG Topology](../common/registration.md#registering-resources).

1.  Set `resource_group` in `/etc/osg/config.d/40-siteinfo.ini` to the resource group registered in
    [OSG Topology](../common/registration.md#registering-resources),
    i.e. the name of the `.yaml` file in OSG Topology that contains the registered resouce above.

1.  Set `host_name` to the host name that is registered in [OSG Topology](../common/registration.md#registering-resources).
    This may be different from the FQDN of the host if you're using a DNS alias, for example.

1.  OSG Configure will warn about config options that it does not recognize;
    delete these options from the config to get rid of the warnings.

Updating to HTCondor 8.9.7+
---------------------------

!!!tip "Where to find HTCondor 8.9"
    The HTCondor [development series](https://htcondor.readthedocs.io/en/latest/version-history/introduction-version-history.html#the-development-release-series)
    is available through the [OSG upcoming](release_series.md) repository.

For HTCondor hosts < 8.9.7 using the SciTokens CredMon, updates to HTCondor 8.9.7+ require manual intervention and a
corresponding update to `python2-scitokens-credmon`, available in the OSG 3.5 release repository.
If you do not have the `python2-scitokens-credmon` package installed, you may skip these instructions.
Otherwise, follow these steps for a seamless update to HTCondor 8.9.7+:

1.  Determine if your HTCondor installation is configured to use the SciTokens CredMon:

        :::console
        # condor_config_val -v DAEMON_LIST

    If `CREDD` and `SEC_CREDENTIAL_MONITOR` are in the output of the above command, continue onto the next step.
    Otherwise, your installation is not configured to use SciTokens CredMon and you should skip the rest of these
    instructions.

1.  Add the following to a file in `/etc/condor/config.d/`:

        SEC_CREDENTIAL_DIRECTORY_OAUTH = /var/lib/condor/oauth_credentials
        CREDMON_OAUTH = /usr/bin/condor_credmon_oauth
        SEC_CREDENTIAL_MONITOR_OAUTH_LOG = $(LOG)/CredMonOAuthLog

        if version < 8.9.7
          CREDMON_OAUTH = /usr/bin/scitokens_credmon
        endif

1.  Update your `DAEMON_LIST` configuration from:

        DAEMON_LIST = $(DAEMON_LIST), CREDD, SEC_CREDENTIAL_MONITOR

    to

        DAEMON_LIST = $(DAEMON_LIST), CREDD, CREDMON_OAUTH

1.  Turn off the SchedD and CredMon daemons:

        :::console
        # condor_off -daemon SCHEDD
        # condor_off -daemon SEC_CREDENTIAL_MONITOR
        # condor_off -daemon CREDMON_OAUTH

1.  Move the existing credential directory and set up a temporary symlink:

        # mv $(condor_config_val SEC_CREDENTIAL_DIRECTORY) $(condor_config_val SEC_CREDENTIAL_DIRECTORY_OAUTH)
        # ln -s $(condor_config_val SEC_CREDENTIAL_DIRECTORY_OAUTH) $(condor_config_val SEC_CREDENTIAL_DIRECTORY)

1.  Update HTCondor and SciTokens CredMon packages:

        :::console
        # yum -y upgrade python2-scitokens-credmon condor

1.  If you are running Apache on this host, reload the Apache configuration:

        :::console
        # systemctl reload httpd.service

1.  Reconfigure HTCondor:

        :::console
        # condor_reconfig

1.  Turn the SchedD and CredMon daemons back on:

        :::console
        # condor_on -daemon CREDMON_OAUTH
        # condor_on -daemon SCHEDD

1.  Clean up old CredMon configuration.
    Remove the following entries from your HTCondor configuration:

        SEC_CREDENTIAL_DIRECTORY = /var/lib/condor/credentials
        SEC_CREDENTIAL_MONITOR = /usr/bin/scitokens_credmon
        SEC_CREDENTIAL_MONITOR_LOG = $(LOG)/CredMonLog

1.  To allow for seamless HTCondor downgrades, update the `if version < 8.9.7` block that you added in step 2.

        if version < 8.9.7
          CREDMON_OAUTH = /usr/bin/scitokens_credmon
          SEC_CREDENTIAL_DIRECTORY = $(SEC_CREDENTIAL_DIRECTORY_OAUTH)
        endif

1.  Remove the symlink to the old credential directory that you created in step 5.
    This is whatever you had set `SEC_CREDENTIAL_DIRECTORY` to before.
    For example:

        :::console
        # rm /var/lib/condor/credentials


Updating to HTCondor 8.8.x
--------------------------

The OSG 3.5 release series contains HTCondor 8.8, a major version upgrade from the previously released versions
in the OSG.
See the HTCondor 8.8 manual for an overview of the
[changes](https://htcondor.readthedocs.io/en/stable/version-history/upgrading-from-86-to-88-series.html).
To update HTCondor on your HTCondor-CE and/or HTCondor pool hosts, perform the following steps:

1. Update all HTCondor packages:

        :::console
        root@host # yum update 'condor*'

1. **HTCondor pools only:**

    - The `DAEMON_LIST`, and `CONDOR_HOST` configuration changed in HTCondor 8.8.
      Additionally in OSG 3.5, the default security was changed to use FS and pool password.
      If you are experiencing issues with communication between hosts in your pool after the upgrade,
      the default OSG configuration is listed in `/etc/condor/config.d/00-osg_default_*.config`:
      ensure that any default configuration is overriden with your own `DAEMON_LIST`, `CONDOR_HOST`, and/or
      [security](https://htcondor.readthedocs.io/en/stable/admin-manual/security.html) configuration in subsequent files.

    - As of HTCondor 8.8, [MOUNT\_UNDER\_SCRATCH](https://htcondor.readthedocs.io/en/stable/admin-manual/configuration-macros.html#condor-startd-configuration-file-macros)
      has default values of `/tmp` and `/var/tmp`, which may cause issues if your
      [OSG\_WN\_TMP](../worker-node/using-wn.md#the-worker-node-environment) is a subdirectory of either of these directories.
      If the partition containing your execute directories is [large enough](../worker-node/using-wn.md#hardware-recommendations),
      we recommend setting your `OSG_WN_TMP` to `/tmp` or `/var/tmp`.
      If that partition is not large enough, we recommend setting your `OSG_WN_TMP` variable to a directory outside of
      `/tmp` or `/var/tmp`.

1. **HTCondor-CE hosts only:** The HTCondor 8.8 series changed the default job route matching order
   [from round-robin to first matching route](../compute-element/job-router-recipes.md#how-jobs-match-to-job-routes).
   To use the old round-robin matching order, add the following configuration to `/etc/condor-ce/config.d/99-local.conf`:

        JOB_ROUTER_ROUND_ROBIN_SELECTION = True

1. Clean-up deprecated packages:

        :::console
        root@host # yum remove 'rsv*' glite-ce-cream-client-api-c

Updating to XRootD 5
--------------------

!!! bug "Known issues with XRootD 5.1.1"
    -   The XRootD team is [evaluating solutions for a memory leak](https://github.com/xrootd/xrootd/pull/1431) in the
        HTTP Third-Party Copy (HTTP-TPC) use case related to `libcurl` and `NSS`.
        These leaks appear to exist in `libcurl` for all versions of XRootD and their impact depends on the transfer
        load at each site.
    -   [Incompatibility with the multi-user plugin](https://github.com/opensciencegrid/xrootd-multiuser/issues/21):
        users of the XRootD multi-user plugin will be unable to update to XRootD 5.1.x until a fixed version
        of XRootD multi-user is released into the OSG repositories
    -   In some cases, XCaches using the Rucio plug-in may crash due to malformed URLs generated by the plug-in.

!!! tip "Use the OSG XRootD meta-package!"
    The `osg-xrootd` and `osg-xrootd-standalone` meta-packages provide default XRootD configurations in
    `/etc/xrootd/config.d/` with the ability to easily enable or disable features (such as HTTP or LCMAPS) through
    simple configuration flags.
    Additionally, the configurations provided by `osg-xrootd` and `osg-xrootd-standalone` are designed to work with the
    OSG-released versions of XRootD, reducing the number of necessary manual configuration updates.

The OSG 3.5 upcoming repositories contain XRootD 5, a major version upgrade from the previously released versions
in the OSG.
See the upstream [release notes](https://github.com/xrootd/xrootd/blob/v5.1.1/docs/ReleaseNotes.txt) for an overview of
the changes.
To update XRootD on your StashCache, XCache, XRootD clustered, and XRootD standalone hosts, perform the following steps:

1.  Update all XRootD packages:

        :::console
        root@host # yum update --enablerepo=osg-upcoming 'xrootd'* xcache

1.  Determine whether or not you are using OSG XRootD meta-packages

        :::console
        root@host # rpm -q --verify xrootd-server | \
                    egrep "/etc/xrootd/xrootd-(standalone|clustered).cfg"

1.  If the above command does not return any output, skip to step 6.

1.  **If you are not using OSG XRootD meta-packaging and are using `xrootd-lcmaps`,**
    update the `-authzfunparams` to the new `key=value` syntax.
    For example, the following configuration:

        :::console
        -authzfunparms:--lcmapscfg,/etc/xrootd/lcmaps.cfg,--loglevel,0,--policy,authorize_only

    Should be turned into:

        :::console
        -authzfunparms:lcmapscfg=/etc/lcmaps.db,loglevel=0,policy=authorize_only

1.  **If you are not using OSG XRootD meta-packaging and are loading multiple `ofs.authlib` libraries,**
    separate out each library into its own `ofs.authlib` directive.
    For example, the following configuration:

        :::console
        ofs.authlib libXrdMacaroons.so libXrdAccSciTokens.so

    Should be re-ordered and turned into:

        :::console
        # Enable SciTokens-based mappings; if no token is present, then the GSI certificate will be used.
        ofs.authlib ++ libXrdAccSciTokens.so
        ofs.authlib ++ libXrdMacaroons.so

1.  Restart the relevant XRootD services:

    | If you are running a(n)... | Restart the service with...             |
    |:---------------------------|:----------------------------------------|
    | ATLAS XCache               | `systemctl restart xrootd@atlas-xcache` |
    | CMS XCache                 | `systemctl restart xrootd@cms-xcache`   |
    | Stash Cache                | `systemctl restart xrootd@stash-cache`  |
    | Stash Origin               | `systemctl restart xrootd@stash-origin` |
    | XRootD Standalone          | `systemctl restart xrootd@standalone`   |
    | XRootD Clustered           | `systemctl restart xrootd@clustered`    |
