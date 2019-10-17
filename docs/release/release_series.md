**OSG Release Series**
======================

An OSG release series is a sequence of OSG software releases that are intended to provide a painless upgrade path.
For example, the 3.2 release series contains OSG software 3.2.0, 3.2.1, 3.2.2, and so forth.
A release series corresponds to a set of Yum software repositories, including ones for development, testing, and
production use.
The Yum repositories for one release series are completely distinct from the repositories for a different release
series, even though they share many common packages.
A particular release within a series is a snapshot of packages and their exact versions at one point in time.
When you install software from a release series, say 3.2, you get the most current versions of software packages within
that series, regardless of the current release version.

When a new series is released, it is an opportunity for the OSG Technology area to add major new software packages, make
substantial updates to existing packages, and remove obsolete packages.
When a new series is initially released, most packages are identical to the previous release, but two adjacent series
will diverge over time.

Our goal is, within a series, that one may upgrade their OSG services via `yum update` cleanly and without any necessary
config file changes or excessive downtime.

OSG Release Series
------------------

Since the start of the RPM-based OSG software stack, we have offered the following release series:

-   **OSG 3.5** started August 2019.
    The main differences between it and 3.4 were the introduction of the HTCondor 8.8 and 8.9 series;
    also the RSV monitoring probes, EL6 support, and CREAM support were all dropped.

-   **OSG 3.4** started June 2017 and will reach its end-of-life in November 2020.
    The main differences between it and 3.3 are the removal of edg-mkgridmap, GUMS, BeStMan, and VOMS Admin Server
    packages.

-   **OSG 3.3** started in August 2015 and was end-of-lifed in May 2018.
    While the files have not been removed, it is strongly recommended that it not be installed anymore.
    The main differences between 3.3 and 3.2 are the dropping of EL5 support, the addition of EL7 support, and the
    dropping of Globus GRAM support.

-   **OSG 3.2** started in November 2013, and was end-of-lifed in August 2016.
    The main differences between it and 3.1 were the introduction of glideinWMS 3.2, HTCondor 8.0, and Hadoop/HDFS 2.0;
    also the gLite CE Monitor system was dropped in favor of osg-info-services.

-   **OSG 3.1** started in April 2012, and was end-of-lifed in April 2015.
    Historically, there were 3.0.x releases as well, but there was no separate release series for 3.0 and 3.1;
    we simply went from 3.0.10 to 3.1.0 in the same repositories.

OSG Upcoming
------------

There is one more OSG Series called "upcoming" which contains major updates planned for a future release series.
The yum repositories for upcoming (`osg-upcoming` and `osg-upcoming-testing`) are available from all OSG 3.x series, and
individual packages can be installed from Upcoming without needing to update entirely to a new series.
Note, however, that packages in the "upcoming" repositories are tested against the most recent OSG series.
As of the time of writing, `osg-upcoming` is meant to work with OSG 3.5.

Installing an OSG Release Series
--------------------------------

See the [yum repositories document](/common/yum) for instructions on installing the OSG repositories.

<a name="updating-from-old"></a>

Updating to OSG 3.5
-------------------

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

1. If you are updating an HTCondor-CE host, please consult the manual [HTCondor](#updating-to-htcondor-8.8.x) and
[OSG Configure](#updating-to-osg-configure-3) instructions below.

!!! tip "Running into issues?"
    If you are not having the expected result or having problems with Yum please see the
    [Yum troubleshooting guide](/release/yum-basics#troubleshooting)

### Updating to HTCondor-CE 4.x ###

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

    - For non-HTCondor sites that use [remote CE requirements](/compute-element/job-router-recipes/#setting-batch-system-directives),
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

### Updating to OSG Configure 3 ###

The OSG 3.5 release series contains OSG-Configure 3, a major version upgrade from the previously released versions in the OSG.
See the OSG Configure release notes for an overview of the
[changes](https://github.com/opensciencegrid/osg-configure/releases/tag/v3.0.0).
To update OSG Configure on your HTCondor-CE, perform the following steps:

1. If you haven't already, [update to OSG 3.5](#updating-to-osg-35).

1. If you have `site_name` set in `/etc/osg/config.d/40-siteinfo.ini`, delete it and specify `resource` instead.
   `resource` should match the resource name that's registered in
   [OSG Topology](/common/registration/#registering-resources).

1.  Set `resource_group` in `/etc/osg/config.d/40-siteinfo.ini` to the resource group registered in
    [OSG Topology](/common/registration/#registering-resources),
    i.e. the name of the `.yaml` file in OSG Topology that contains the registered resouce above.

1.  Set `host_name` to the host name that is registered in [OSG Topology](/common/registration/#registering-resources).
    This may be different from the FQDN of the host if you're using a DNS alias, for example.

1.  OSG Configure will warn about config options that it does not recognize;
    delete these options from the config to get rid of the warnings.

Updating to HTCondor 8.8.x
--------------------------

The OSG 3.5 and 3.4 release series contain HTCondor 8.8, a major version upgrade from the previously released versions
in the OSG.
See the HTCondor 8.8 manual for an overview of the
[changes](https://htcondor.readthedocs.io/en/v8_8_4/version-history/upgrading-from-86-to-88-series.html).
To update HTCondor on your HTCondor-CE and/or HTCondor pool hosts, perform the following steps:

1. Update all HTCondor packages:

        :::console
        root@host # yum update 'condor*'

1. **HTCondor pools only:** The default authentication, `DAEMON_LIST`, and `CONDOR_HOST` configuration changed in
   HTCondor 8.8 in OSG 3.5.
   Similarly, the `DAEMON_LIST` and `CONDOR_HOST` configuration changed in OSG 3.4.
   If you are experiencing issues with communication between hosts in your pool after the upgrade,
   the default OSG configuration is listed in `/etc/condor/config.d/00-osg_default_*.config`:
   ensure that any default configuration is overriden with your own `DAEMON_LIST`, `CONDOR_HOST`, and/or
   [security](https://htcondor.readthedocs.io/en/v8_8_4/admin-manual/security.html) configuration in subsequent files.

1. **HTCondor-CE hosts only:** The HTCondor 8.8 series changed the default job route matching order
   [from round-robin to first matching route](/compute-element/job-router-recipes#how-jobs-match-to-job-routes).
   To use the old round-robin matching order, add the following configuration to `/etc/condor-ce/config.d/99-local.conf`:

        JOB_ROUTER_ROUND_ROBIN_SELECTION = True

1. Clean-up deprecated packages:

        :::console
        root@host # yum remove 'rsv*' glite-ce-cream-client-api-c

References
----------

-   [Yum repositories](/common/yum)
-   [Basic use of Yum](/release/yum-basics)

