OSG Software Release 3.4.30
===========================

**Release Date**: 2019-05-16

Summary of changes
------------------

This release contains:

!!! danger
    This release contains a [security fix](https://opensciencegrid.org/security/vulns/OSG-SEC-2019-05-14-Vulnerability-in-Singularity/) for Singularity in the upcoming repository.
    The Singularity in OSG 3.4 does not have the vulnerability.

-   BLAHP 1.18.41
    -   Uses better qstat options for completed jobs when using PBS Pro
    -   Fixed proxy certificate renewal issue for non-HTCondor batch systems
    -   Uses the new HTCondor environment format
-   [VO Package v91](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-91): Update the STAR VO Certificate
-   xrootd-voms-plugin 0.6.0: Fix minor memory leak
-   [osg-pki-tools 3.3.0](https://github.com/opensciencegrid/osg-pki-tools/releases/tag/v3.3.0): New options to set organization and department codes
-   Upcoming repository:
    -   Singularity 3.1.1-1.1: [Security Fix](https://opensciencegrid.org/security/vulns/OSG-SEC-2019-05-14-Vulnerability-in-Singularity/)
    -   osg-se-hadoop meta-package for EL6
    -   BLAHP 1.18.41: See above

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.30%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](/index.md).

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

1. GlideinWMS >= 3.4.5 uses shared port, requiring only port 9618.
   To ease the transition to shared port, the User Collector secondary collectors and CCBs support both shared and
   separate, individual ports.
   To start using shared port, change the secondary collectors lines and the CCBs lines (if any) in
   `/etc/gwms-frontend/frontend.xml`, changing the address to include the shared port sinful string:

        <collector DN="/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=gwms-frontend.domain" group="default" node="gwms-frontend.domain:9618?sock=collector0-40" secondary="True"/>

   Replacing `gwms-frontend-domain` with the hostname of your GlideinWMS frontend.
   See the [GlideinWMS documentation](https://glideinwms.fnal.gov/doc.prd/components/condor.html#collectors ) for details.

Known Issues
------------

None.

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](/common/yum#install-osg-repositories).

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

Do you need help with this release? [Contact us for help](/common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.41.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.41.bosco-1.osg34.el6)
-   [osg-pki-tools-3.3.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.3.0-1.osg34.el6)
-   [osg-release-3.4-8.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-8.osg34.el6)
-   [osg-test-3.0.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-3.0.0-1.osg34.el6)
-   [osg-version-3.4.30-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.30-1.osg34.el6)
-   [vo-client-91-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-91-1.osg34.el6)
-   [xrootd-voms-plugin-0.6.0-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-voms-plugin-0.6.0-2.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.41.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.41.bosco-1.osg34.el7)
-   [osg-pki-tools-3.3.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.3.0-1.osg34.el7)
-   [osg-release-3.4-8.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-8.osg34.el7)
-   [osg-test-3.0.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-3.0.0-1.osg34.el7)
-   [osg-version-3.4.30-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.30-1.osg34.el7)
-   [vo-client-91-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-91-1.osg34.el7)
-   [xrootd-voms-plugin-0.6.0-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-voms-plugin-0.6.0-2.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo osg-pki-tools osg-release osg-test osg-test-log-viewer osg-version vo-client vo-client-dcache vo-client-lcmaps-voms xrootd-voms-plugin xrootd-voms-plugin-debuginfo xrootd-voms-plugin-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.41.bosco-1.osg34.el6
blahp-debuginfo-1.18.41.bosco-1.osg34.el6
osg-pki-tools-3.3.0-1.osg34.el6
osg-release-3.4-8.osg34.el6
osg-test-3.0.0-1.osg34.el6
osg-test-log-viewer-3.0.0-1.osg34.el6
osg-version-3.4.30-1.osg34.el6
vo-client-91-1.osg34.el6
vo-client-dcache-91-1.osg34.el6
vo-client-lcmaps-voms-91-1.osg34.el6
xrootd-voms-plugin-0.6.0-2.osg34.el6
xrootd-voms-plugin-debuginfo-0.6.0-2.osg34.el6
xrootd-voms-plugin-devel-0.6.0-2.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.41.bosco-1.osg34.el7
blahp-debuginfo-1.18.41.bosco-1.osg34.el7
osg-pki-tools-3.3.0-1.osg34.el7
osg-release-3.4-8.osg34.el7
osg-test-3.0.0-1.osg34.el7
osg-test-log-viewer-3.0.0-1.osg34.el7
osg-version-3.4.30-1.osg34.el7
vo-client-91-1.osg34.el7
vo-client-dcache-91-1.osg34.el7
vo-client-lcmaps-voms-91-1.osg34.el7
xrootd-voms-plugin-0.6.0-2.osg34.el7
xrootd-voms-plugin-debuginfo-0.6.0-2.osg34.el7
xrootd-voms-plugin-devel-0.6.0-2.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.41.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.41.bosco-1.osgup.el6)
-   [osg-se-hadoop-3.4-8.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-se-hadoop-3.4-8.osgup.el6)
-   [singularity-3.1.1-1.1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.1.1-1.1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.41.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.41.bosco-1.osgup.el7)
-   [singularity-3.1.1-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.1.1-1.1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    avro-doc avro-libs avro-tools bigtop-jsvc bigtop-jsvc-debuginfo bigtop-utils blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp glite-ce-cream-client-api-c glite-ce-cream-client-devel hadoop hadoop-0.20-conf-pseudo hadoop-0.20-mapreduce hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-journalnode hadoop-hdfs-namenode hadoop-hdfs-nfs3 hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-kms hadoop-kms-server hadoop-libhdfs hadoop-libhdfs-devel hadoop-mapreduce hadoop-yarn minicondor osg-gridftp osg-gridftp-hdfs osg-gridftp-xrootd osg-se-hadoop osg-se-hadoop-client osg-se-hadoop-datanode osg-se-hadoop-namenode osg-se-hadoop-secondarynamenode python2-condor singularity singularity-debuginfo zookeeper zookeeper-debuginfo zookeeper-native zookeeper-server

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.41.bosco-1.osgup.el6
blahp-debuginfo-1.18.41.bosco-1.osgup.el6
osg-se-hadoop-3.4-8.osgup.el6
osg-se-hadoop-client-3.4-8.osgup.el6
osg-se-hadoop-datanode-3.4-8.osgup.el6
osg-se-hadoop-namenode-3.4-8.osgup.el6
osg-se-hadoop-secondarynamenode-3.4-8.osgup.el6
singularity-3.1.1-1.1.osgup.el6
singularity-debuginfo-3.1.1-1.1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.41.bosco-1.osgup.el7
blahp-debuginfo-1.18.41.bosco-1.osgup.el7
singularity-3.1.1-1.1.osgup.el7
singularity-debuginfo-3.1.1-1.1.osgup.el7
```
