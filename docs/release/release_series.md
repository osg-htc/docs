**OSG Release Series**
======================

An OSG release series is a sequence of OSG software releases that are intended to provide a painless upgrade path. For example, the 3.2 release series contains OSG software 3.2.0, 3.2.1, 3.2.2, and so forth. A release series corresponds to a set of Yum software repositories, including ones for development, testing, and production use. The Yum repositories for one release series are completely distinct from the repositories for a different release series, even though they share many common packages.  A particular release within a series is a snapshot of packages and their exact versions at one point in time. When you install software from a release series, say 3.2, you get the most current versions of software packages within that series, regardless of the current release version.

When a new series is released, it is an opportunity for the OSG Technology area to add major new software packages, make substantial updates to existing packages, and remove obsolete packages. When a new series is initially released, most packages are identical to the previous release, but two adjacent series will diverge over time.

Our goal is, within a series, that one may upgrade their OSG services via `yum update` cleanly and without any necessary config file changes or excessive downtime.

OSG Release Series
==================

Since the start of the RPM-based OSG software stack, we have offered the following release series:

-   **OSG 3.1** started in April 2012, and was end-of-lifed in April 2015. While the files have not been removed, it is strongly recommended that it not be installed anymore. Historically, there were 3.0.x releases as well, but there was no separate release series for 3.0 and 3.1; we simply went from 3.0.10 to 3.1.0 in the same repositories.

-   **OSG 3.2** started in November 2013, and was end-of-lifed in August 2016. While the files have not been removed, it is strongly recommended that it not be installed anymore. The main differences between it and 3.1 were the introduction of glideinWMS 3.2, HTCondor 8.0, and Hadoop/HDFS 2.0; also the gLite CE Monitor system was dropped in favor of osg-info-services.

-   **OSG 3.3** started in August 2015 and is still supported today.  End-of-support is scheduled for June 2018; sites are encouraged to investigate the upgrade to OSG 3.4. The main differences between 3.3 and 3.2 are the dropping of EL5 support, the addition of EL7 support, and the dropping of Globus GRAM support.

-   **OSG 3.4** stared June 2017. The main differences between it and 3.3 are the removal of edg-mkgridmap, GUMS, BeStMan, and VOMS Admin Server packages.

OSG Upcoming
============

There is one more OSG Series called "upcoming" which contains major updates planned for a future release series. The yum repositories for upcoming (`osg-upcoming` and `osg-upcoming-testing`) are available from all OSG 3.x series, and individual packages can be installed from Upcoming without needing to update entirely to a new series. Note, however, that packages in the "upcoming" repositories are tested against the most recent OSG series.  As of the time of writing, `osg-upcoming` is meant to work with OSG 3.4.

Installing an OSG Release Series
================================

See the [yum repositories document](/common/yum) for instructions on installing the OSG repositories.

Updating from OSG 3.1, 3.2, 3.3 to 3.3 or 3.4
=============================================

1.  If you have an existing installation based on OSG 3.1, 3.2, or 3.3 (which will be referred to as the *old series*), and want to upgrade to 3.3 or 3.4 (the *new series*), we recommend the following procedure:

    First, remove the old series yum repositories:

        :::console
        root@host # rpm -e osg-release

    This step ensures that any local modifications to `*.repo` files will not prevent installing the new series repos. Any modified `*.repo` files should appear under `/etc/yum.repos.d/` with the `*.rpmsave` extension. After installing the new OSG repositories (the next step) you may want to apply any changes made in the `*.rpmsave` files to the new `*.repo` files.

2.  Install the OSG repositories:

        :::console
        root@host # rpm -Uvh <URL>

    where `<URL>` is one of the following:

    | Series                    | EL5 URL (for RHEL5, CentOS5, or SL5)                             | EL6 URL (for RHEL6, CentOS6, or SL6)                             | EL7 URL (for RHEL7, CentOS7, or SL7)                             |
    |:--------------------------|:-----------------------------------------------------------------|:-----------------------------------------------------------------|:-----------------------------------------------------------------|
    | **OSG 3.1** (unsupported) | `http://repo.grid.iu.edu/osg/3.1/osg-3.1-el5-release-latest.rpm` | `http://repo.grid.iu.edu/osg/3.1/osg-3.1-el6-release-latest.rpm` | N/A                                                              |
    | **OSG 3.2** (unsupported) | `http://repo.grid.iu.edu/osg/3.2/osg-3.2-el5-release-latest.rpm` | `http://repo.grid.iu.edu/osg/3.2/osg-3.2-el6-release-latest.rpm` | N/A                                                              |
    | **OSG 3.3**               | N/A                                                              | `http://repo.grid.iu.edu/osg/3.3/osg-3.3-el6-release-latest.rpm` | `http://repo.grid.iu.edu/osg/3.3/osg-3.3-el7-release-latest.rpm` |
    | **OSG 3.4**               | N/A                                                              | `http://repo.grid.iu.edu/osg/3.4/osg-3.4-el6-release-latest.rpm` | `http://repo.grid.iu.edu/osg/3.4/osg-3.4-el7-release-latest.rpm` |

3.  Clean yum cache:

        :::console
        root@host # yum clean all --enablerepo=*

4. Update software:

        :::console
        root@host # yum update

This command will update **all** packages on your system.

**Troubleshooting** If you are not having the expected result or having problems with Yum please see the [Yum troubleshooting guide](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/YumRpmBasics#Troubleshooting)

Migrating from edg-mkgridmap to LCMAPS VOMS Plugin
--------------------------------------------------

After following the update instructions above, perform the migration process documented [here](../security/lcmaps-voms-authentication#migrating-from-edg-mkgridmap).

Updating from Frontier Squid 2.7 to Frontier Squid 3.5 (upgrading from OSG 3.3)
-------------------------------------------------------------------------------

The program `frontier-squid` received a major version upgrade (versions 2.7 to 3.5) between OSG 3.3 and OSG 3.4. Follow the [upstream upgrade documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Upgrading) when transitioning your squid server to OSG 3.4.

Uninstalling BeStMan2 from the Storage Element (upgrading to OSG 3.4)
---------------------------------------------------------------------

The program BeStMan2 is no longer available in OSG 3.4 and its functionality has been replaced by [load-balanced GridFTP](../data/load-balanced-gridftp). To update your storage element to OSG 3.4, you must perform the following procedure:

1.  Ensure that OSG BeStMan packages are installed:

        :::console
        root@host # rpm -q osg-se-bestman

2.  Stop the `bestman2` service:

        :::console
        root@host # service bestman2 stop

3.  Uninstall the software:

        :::console
        root@host # yum erase bestman2-tester-libs bestman2-common-libs \
                                    bestman2-server-libs bestman2-server-dep-libs \
                                    bestman2-client-libs bestman2-tester bestman2-client \
                                    bestman2-server osg-se-bestman

!!! note
    In the output from this command, yum should **not** list other packages than those nine. If it lists other packages, cancel the erase operation, make sure the other packages are updated to their latest OSG 3.3 versions, and try again.

After successfully removing BeStMan2, continue updating your host to OSG 3.4 by following the instructions above.

Uninstalling OSG Info Services from the Compute Element (upgrading from OSG 3.3 or 3.2)
---------------------------------------------------------------------------------------

The program OSG Info Services is no longer required on OSG 3.3, and is no longer available starting in OSG 3.4. This is because the service that OSG Info Services reported to, named BDII, has been retired and is no longer functional.

To cleanly uninstall OSG Info Services from your CE, perform the following procedure (after following the main update instructions above):

1.  Ensure that you are using a sufficiently new version of the `osg-ce` metapackages:

        :::console
        root@host # rpm -q osg-ce

    should be at least 3.3-12 (OSG 3.3) or 3.4-1 (OSG 3.4).  If not, update them:

        :::console
        root@host # yum update osg-ce

2.  Stop the `osg-info-services` service:

        :::console
        root@host # service osg-info-services stop

3.  Uninstall the software:

        :::console
        root@host # yum erase gip osg-info-services

!!! note
    In the output from this command, yum should **not** list other packages than those two. If it lists other packages, cancel the erase operation, make sure the other packages are updated to their latest OSG 3.3 (or 3.4) versions, and try again.

Uninstalling CEMon from the Compute Element (upgrading from OSG 3.1)
--------------------------------------------------------------------

The program CEMon (found in the package `glite-ce-monitor`) is no longer available starting in OSG 3.2. Its functionality is no longer required because the service that CEMon reported to has been retired and is no longer functional.

To cleanly uninstall CEMon from your CE, perform the following procedure (after following the main update instructions above):

1.  Ensure that you are using a sufficiently new version of the `osg-ce` metapackages:

        :::console
        root@host # rpm -q osg-ce

    should be at least 3.3-12 (OSG 3.3) or 3.4-1 (OSG 3.4). If not, update them:

        :::console
        root@host # yum update osg-ce

2.  If there is a CEMon configuration file at `/etc/osg/config.d/30-cemon.ini`, remove it.
3.  Remove CEMon and related packages:

        :::console
        root@host # yum erase glite-ce-monitor glite-ce-osg-ce-plugin osg-configure-cemon

!!! note
    In the output from this command, yum should **not** list other packages than those three. If it lists other packages, cancel the erase operation, make sure the other packages are updated to their OSG 3.3 (or 3.4) versions (they should have `.osg33` or `.osg34` in their versions), and try again.

References
==========

-   [YUM Repositories](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/YumRepositories)
-   [Basic use of Yum](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/YumRpmBasics)
-   [Best practices in using Yum](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallBestPractices)

