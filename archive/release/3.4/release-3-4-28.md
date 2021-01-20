OSG Software Release 3.4.28
===========================

**Release Date**: 2019-04-25

Summary of changes
------------------

This release contains:

-   [XRootD 4.9.1](https://github.com/xrootd/xrootd/blob/v4.9.1/docs/ReleaseNotes.txt): Updated from XRootD 4.8.5
    -  Integrated plugins for macaroons and third-party copy
    -  Added support for Subject Alternative Names
    -  Added support for multiple configuration files via the `continue` statement
    -  Various bug fixes. See detailed release notes for more information.
-   [xrootd-hdfs 2.1.4](https://github.com/opensciencegrid/xrootd-hdfs/releases/tag/v2.1.4): Bugfix release
-   [GlideinWMS 3.4.5](http://glideinwms.fnal.gov/doc.v3_4_5/history.html): Updated from GlideinWMS 3.4.2
    -  Frontend configurations now use shared port (i.e. only port 9618 is required)
    -  Added a scaling factor for all Glidein limits in factory entries
    -  Added the ability to completely disable Glidein removal
    -  Includes unprivileged Singularity and preserve important system files
    -  Added option to ignore entries in downtime when considering Glidein matches
    -  Tracks jobs that spawn multiple nodes, e.g. HPC submission 
    -  Propagates attributes controlled by the Frontend to Factory and Glidein submission
    -  Various bug fixes. See detailed release notes for more information.
-   OSG Flock 1.1: Added new `flock.opensciencegrid.org` host certificate information
-   [VO Package v89](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-89)
    -  Added new GLOW certificate information
    -  Removed retired SBGrid certificate information
-   Upcoming Repository: [HTCondor 8.8.2](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00005.shtml)
    -  Added support for `condor_ssh_to_job` for jobs running under non-setuid Singularity
    -  Added new Python bindings function to output ClassAds as JSON
    -  Various bug fixes. See detailed release notes for more information.

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.28%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

-   OSG 3.4 contains only 64-bit components.
-   StashCache is only supported on EL7

### GlideinWMS ###

1. GlideinWMS 3.4.5 is the last release supporting Globus GRAM (a.k.a. GT2/GT5).

1. For new Singularity features introduced in GlideinWMS 3.4.1, all factories and frontends need to be >= 3.4.1.

    !!! note
        OSG GlideinWMS factories are running at least 3.4.1

    If some of the connected Factories are <= 3.4.1 you will see an error during reconfig/upgrade if you try to use
    features that require a newer Factory.
    To start using Singularity via GlideinWMS, see:

    - <https://glideinwms.fnal.gov/doc.prd/frontend/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/custom_vars.html#singularity_vars>

1. Upgrades from <= 3.4.0 may require merging `/etc/condor/config.d/*.rpmnew` files and a restart of HTCondor.

1. GlideinWMS >= 3.4.5 can use shared port. If you do so, it requires only port 9618.
   To ease the transition to shared port, the User Collector secondary collectors and CCBs support both shared and
   separate, individual ports.

   -  The HTCondor configuration should be changed as suggested in the new HTCondor config files included in the RPMs, to allow the support of shared port: check the `.rpmnew` files or apply the same changes if you configure your daemons manually.
   -  Port 9818 should be open also on standalone schedds (that earlier used only 9615).
   -  To start using shared port, change the secondary collectors lines and the CCBs lines (if any) in `/etc/gwms-frontend/frontend.xml`, changing the address to include the shared port sinful string:

            <collector DN="/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=gwms-frontend.domain" group="default" node="gwms-frontend.domain:9618?sock=collector0-40" secondary="True"/>

      Replacing `gwms-frontend-domain` with the hostname of your GlideinWMS frontend.
      See the [GlideinWMS documentation](https://glideinwms.fnal.gov/doc.prd/components/condor.html#collectors ) for details. 

Known Issues
------------

Due to the central RSV service retirement (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/) for details),
the new version of RSV will disable the `gratia-consumer` component that reports to the central service.
Please update _all_ RSV packages by running the following command on your RSV host:

``` console
root@host # yum update rsv\*
```

Additionally, if you are using osg-configure, please edit `/etc/osg/config.d/30-rsv.ini` and set the following:

``` file
enable_gratia = False
```

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-the-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note "Notes"
    -   Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [glideinwms-3.4.5-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4.5-1.osg34.el6)
-   [osg-flock-1.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.1-1.osg34.el6)
-   [osg-version-3.4.28-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.28-1.osg34.el6)
-   [vo-client-89-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-89-1.osg34.el6)
-   [xrootd-4.9.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.9.1-1.osg34.el6)
-   [xrootd-lcmaps-1.7.0-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.0-1.1.osg34.el6)

#### Enterprise Linux 7

-   [glideinwms-3.4.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4.5-1.osg34.el7)
-   [osg-flock-1.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.1-1.osg34.el7)
-   [osg-version-3.4.28-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.28-1.osg34.el7)
-   [vo-client-89-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-89-1.osg34.el7)
-   [xrootd-4.9.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.9.1-1.osg34.el7)
-   [xrootd-hdfs-2.1.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.4-1.osg34.el7)
-   [xrootd-lcmaps-1.7.0-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.0-1.1.osg34.el7)
-   [xrootd-multiuser-0.4.2-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.2-3.osg34.el7)
-   [xrootd-scitokens-0.6.0-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-0.6.0-3.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone osg-flock osg-version python2-xrootd vo-client vo-client-dcache vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
glideinwms-3.4.5-1.osg34.el6
glideinwms-common-tools-3.4.5-1.osg34.el6
glideinwms-condor-common-config-3.4.5-1.osg34.el6
glideinwms-factory-3.4.5-1.osg34.el6
glideinwms-factory-condor-3.4.5-1.osg34.el6
glideinwms-glidecondor-tools-3.4.5-1.osg34.el6
glideinwms-libs-3.4.5-1.osg34.el6
glideinwms-minimal-condor-3.4.5-1.osg34.el6
glideinwms-usercollector-3.4.5-1.osg34.el6
glideinwms-userschedd-3.4.5-1.osg34.el6
glideinwms-vofrontend-3.4.5-1.osg34.el6
glideinwms-vofrontend-standalone-3.4.5-1.osg34.el6
osg-flock-1.1-1.osg34.el6
osg-version-3.4.28-1.osg34.el6
python2-xrootd-4.9.1-1.osg34.el6
vo-client-89-1.osg34.el6
vo-client-dcache-89-1.osg34.el6
vo-client-lcmaps-voms-89-1.osg34.el6
xrootd-4.9.1-1.osg34.el6
xrootd-client-4.9.1-1.osg34.el6
xrootd-client-devel-4.9.1-1.osg34.el6
xrootd-client-libs-4.9.1-1.osg34.el6
xrootd-debuginfo-4.9.1-1.osg34.el6
xrootd-devel-4.9.1-1.osg34.el6
xrootd-doc-4.9.1-1.osg34.el6
xrootd-fuse-4.9.1-1.osg34.el6
xrootd-lcmaps-1.7.0-1.1.osg34.el6
xrootd-lcmaps-debuginfo-1.7.0-1.1.osg34.el6
xrootd-libs-4.9.1-1.osg34.el6
xrootd-private-devel-4.9.1-1.osg34.el6
xrootd-selinux-4.9.1-1.osg34.el6
xrootd-server-4.9.1-1.osg34.el6
xrootd-server-devel-4.9.1-1.osg34.el6
xrootd-server-libs-4.9.1-1.osg34.el6
```

#### Enterprise Linux 7

``` file
glideinwms-3.4.5-1.osg34.el7
glideinwms-common-tools-3.4.5-1.osg34.el7
glideinwms-condor-common-config-3.4.5-1.osg34.el7
glideinwms-factory-3.4.5-1.osg34.el7
glideinwms-factory-condor-3.4.5-1.osg34.el7
glideinwms-glidecondor-tools-3.4.5-1.osg34.el7
glideinwms-libs-3.4.5-1.osg34.el7
glideinwms-minimal-condor-3.4.5-1.osg34.el7
glideinwms-usercollector-3.4.5-1.osg34.el7
glideinwms-userschedd-3.4.5-1.osg34.el7
glideinwms-vofrontend-3.4.5-1.osg34.el7
glideinwms-vofrontend-standalone-3.4.5-1.osg34.el7
osg-flock-1.1-1.osg34.el7
osg-version-3.4.28-1.osg34.el7
python2-xrootd-4.9.1-1.osg34.el7
vo-client-89-1.osg34.el7
vo-client-dcache-89-1.osg34.el7
vo-client-lcmaps-voms-89-1.osg34.el7
xrootd-4.9.1-1.osg34.el7
xrootd-client-4.9.1-1.osg34.el7
xrootd-client-devel-4.9.1-1.osg34.el7
xrootd-client-libs-4.9.1-1.osg34.el7
xrootd-debuginfo-4.9.1-1.osg34.el7
xrootd-devel-4.9.1-1.osg34.el7
xrootd-doc-4.9.1-1.osg34.el7
xrootd-fuse-4.9.1-1.osg34.el7
xrootd-hdfs-2.1.4-1.osg34.el7
xrootd-hdfs-debuginfo-2.1.4-1.osg34.el7
xrootd-hdfs-devel-2.1.4-1.osg34.el7
xrootd-lcmaps-1.7.0-1.1.osg34.el7
xrootd-lcmaps-debuginfo-1.7.0-1.1.osg34.el7
xrootd-libs-4.9.1-1.osg34.el7
xrootd-multiuser-0.4.2-3.osg34.el7
xrootd-multiuser-debuginfo-0.4.2-3.osg34.el7
xrootd-private-devel-4.9.1-1.osg34.el7
xrootd-scitokens-0.6.0-3.osg34.el7
xrootd-scitokens-debuginfo-0.6.0-3.osg34.el7
xrootd-selinux-4.9.1-1.osg34.el7
xrootd-server-4.9.1-1.osg34.el7
xrootd-server-devel-4.9.1-1.osg34.el7
xrootd-server-libs-4.9.1-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.8.2-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.2-1.osgup.el6)

#### Enterprise Linux 7

-   [condor-8.8.2-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.2-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp minicondor python2-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.8.2-1.osgup.el6
condor-all-8.8.2-1.osgup.el6
condor-annex-ec2-8.8.2-1.osgup.el6
condor-bosco-8.8.2-1.osgup.el6
condor-classads-8.8.2-1.osgup.el6
condor-classads-devel-8.8.2-1.osgup.el6
condor-cream-gahp-8.8.2-1.osgup.el6
condor-debuginfo-8.8.2-1.osgup.el6
condor-kbdd-8.8.2-1.osgup.el6
condor-procd-8.8.2-1.osgup.el6
condor-std-universe-8.8.2-1.osgup.el6
condor-test-8.8.2-1.osgup.el6
condor-vm-gahp-8.8.2-1.osgup.el6
minicondor-8.8.2-1.osgup.el6
python2-condor-8.8.2-1.osgup.el6
```

#### Enterprise Linux 7

``` file
condor-8.8.2-1.osgup.el7
condor-all-8.8.2-1.osgup.el7
condor-annex-ec2-8.8.2-1.osgup.el7
condor-bosco-8.8.2-1.osgup.el7
condor-classads-8.8.2-1.osgup.el7
condor-classads-devel-8.8.2-1.osgup.el7
condor-cream-gahp-8.8.2-1.osgup.el7
condor-debuginfo-8.8.2-1.osgup.el7
condor-kbdd-8.8.2-1.osgup.el7
condor-procd-8.8.2-1.osgup.el7
condor-test-8.8.2-1.osgup.el7
condor-vm-gahp-8.8.2-1.osgup.el7
minicondor-8.8.2-1.osgup.el7
python2-condor-8.8.2-1.osgup.el7
```
