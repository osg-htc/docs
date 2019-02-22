OSG Software Release 3.4.24
===========================

**Release Date**: 2019-02-21

Summary of changes
------------------

This release contains:

-   BLAHP 1.18.39: Now propagates signals down to the payload job
-   osg-pki-tools 3.0.1: Now accepts multi-word states or provinces
-   HTCondor-CE 3.2.1: Minor adjustments to work with new HTCondor versions
-   condor-cron 1.1.4: Minor adjustments to work with new HTCondor versions
-   osg-release 3.4-1: New osg-rolling repository (disabled by default) allows early access to fully tested software
-   Upcoming Repository
    -   [Singularity 3.0.3](https://github.com/sylabs/singularity/releases/tag/v3.0.3) ([change Log](https://github.com/sylabs/singularity/blob/master/CHANGELOG.md#v303---20190121))
    -   Limited client HDFS functionality to mount HDFS on EL6 hosts via FUSE

        !!! info
            Upgrade to EL7 to update name nodes, data nodes, XRootD, or GridFTP hosts.

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.24%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found [here](/index.md).

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

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-from-osg-31-32-33-to-33-or-34).

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

-   [blahp-1.18.39.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.39.bosco-1.osg34.el6)
-   [condor-cron-1.1.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.4-1.osg34.el6)
-   [htcondor-ce-3.2.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.2.1-1.osg34.el6)
-   [osg-build-1.14.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.14.1-1.osg34.el6)
-   [osg-pki-tools-3.0.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.0.1-1.osg34.el6)
-   [osg-release-3.4-7.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-7.osg34.el6)
-   [osg-test-2.3.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.3.1-1.osg34.el6)
-   [osg-version-3.4.24-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.24-1.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.39.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.39.bosco-1.osg34.el7)
-   [condor-cron-1.1.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.4-1.osg34.el7)
-   [htcondor-ce-3.2.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.2.1-1.osg34.el7)
-   [osg-build-1.14.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.14.1-1.osg34.el7)
-   [osg-pki-tools-3.0.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.0.1-1.osg34.el7)
-   [osg-release-3.4-7.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-7.osg34.el7)
-   [osg-test-2.3.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.3.1-1.osg34.el7)
-   [osg-version-3.4.24-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.24-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:


    blahp blahp-debuginfo condor-cron htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-pki-tools osg-release osg-test osg-test-log-viewer osg-version

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.39.bosco-1.osg34.el6
blahp-debuginfo-1.18.39.bosco-1.osg34.el6
condor-cron-1.1.4-1.osg34.el6
htcondor-ce-3.2.1-1.osg34.el6
htcondor-ce-bosco-3.2.1-1.osg34.el6
htcondor-ce-client-3.2.1-1.osg34.el6
htcondor-ce-collector-3.2.1-1.osg34.el6
htcondor-ce-condor-3.2.1-1.osg34.el6
htcondor-ce-lsf-3.2.1-1.osg34.el6
htcondor-ce-pbs-3.2.1-1.osg34.el6
htcondor-ce-sge-3.2.1-1.osg34.el6
htcondor-ce-slurm-3.2.1-1.osg34.el6
htcondor-ce-view-3.2.1-1.osg34.el6
osg-build-1.14.1-1.osg34.el6
osg-build-base-1.14.1-1.osg34.el6
osg-build-koji-1.14.1-1.osg34.el6
osg-build-mock-1.14.1-1.osg34.el6
osg-build-tests-1.14.1-1.osg34.el6
osg-pki-tools-3.0.1-1.osg34.el6
osg-release-3.4-7.osg34.el6
osg-test-2.3.1-1.osg34.el6
osg-test-log-viewer-2.3.1-1.osg34.el6
osg-version-3.4.24-1.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.39.bosco-1.osg34.el7
blahp-debuginfo-1.18.39.bosco-1.osg34.el7
condor-cron-1.1.4-1.osg34.el7
htcondor-ce-3.2.1-1.osg34.el7
htcondor-ce-bosco-3.2.1-1.osg34.el7
htcondor-ce-client-3.2.1-1.osg34.el7
htcondor-ce-collector-3.2.1-1.osg34.el7
htcondor-ce-condor-3.2.1-1.osg34.el7
htcondor-ce-lsf-3.2.1-1.osg34.el7
htcondor-ce-pbs-3.2.1-1.osg34.el7
htcondor-ce-sge-3.2.1-1.osg34.el7
htcondor-ce-slurm-3.2.1-1.osg34.el7
htcondor-ce-view-3.2.1-1.osg34.el7
osg-build-1.14.1-1.osg34.el7
osg-build-base-1.14.1-1.osg34.el7
osg-build-koji-1.14.1-1.osg34.el7
osg-build-mock-1.14.1-1.osg34.el7
osg-build-tests-1.14.1-1.osg34.el7
osg-pki-tools-3.0.1-1.osg34.el7
osg-release-3.4-7.osg34.el7
osg-test-2.3.1-1.osg34.el7
osg-test-log-viewer-2.3.1-1.osg34.el7
osg-version-3.4.24-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [avro-libs-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.2.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=avro-libs-1.7.6%2Bcdh5.13.0%2B135-1.cdh5.13.0.p0.34.2.osgup.el6)
-   [bigtop-jsvc-0.3.0-1.2.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bigtop-jsvc-0.3.0-1.2.osgup.el6)
-   [bigtop-utils-0.7.0+cdh5.13.0+0-1.cdh5.13.0.p0.34.1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bigtop-utils-0.7.0%2Bcdh5.13.0%2B0-1.cdh5.13.0.p0.34.1.osgup.el6)
-   [blahp-1.18.39.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.39.bosco-1.osgup.el6)
-   [hadoop-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hadoop-2.6.0%2Bcdh5.12.1%2B2540-1.cdh5.12.1.p0.3.8.osgup.el6)
-   [singularity-3.0.3-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.0.3-1.osgup.el6)
-   [zookeeper-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=zookeeper-3.4.5%2Bcdh5.14.2%2B142-1.cdh5.14.2.p0.11.1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.39.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.39.bosco-1.osgup.el7)
-   [singularity-3.0.3-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.0.3-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    avro-doc avro-libs avro-tools bigtop-jsvc bigtop-jsvc-debuginfo bigtop-utils blahp blahp-debuginfo hadoop hadoop-0.20-conf-pseudo hadoop-0.20-mapreduce hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-journalnode hadoop-hdfs-namenode hadoop-hdfs-nfs3 hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-kms hadoop-kms-server hadoop-libhdfs hadoop-libhdfs-devel hadoop-mapreduce hadoop-yarn singularity singularity-debuginfo zookeeper zookeeper-debuginfo zookeeper-native zookeeper-server

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
avro-doc-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.2.osgup.el6
avro-libs-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.2.osgup.el6
avro-tools-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.2.osgup.el6
bigtop-jsvc-0.3.0-1.2.osgup.el6
bigtop-jsvc-debuginfo-0.3.0-1.2.osgup.el6
bigtop-utils-0.7.0+cdh5.13.0+0-1.cdh5.13.0.p0.34.1.osgup.el6
blahp-1.18.39.bosco-1.osgup.el6
blahp-debuginfo-1.18.39.bosco-1.osgup.el6
hadoop-0.20-conf-pseudo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-0.20-mapreduce-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-client-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-conf-pseudo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-debuginfo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-doc-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-hdfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-hdfs-datanode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-hdfs-fuse-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-hdfs-journalnode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-hdfs-namenode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-hdfs-nfs3-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-hdfs-secondarynamenode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-hdfs-zkfc-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-httpfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-kms-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-kms-server-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-libhdfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-libhdfs-devel-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-mapreduce-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
hadoop-yarn-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osgup.el6
singularity-3.0.3-1.osgup.el6
singularity-debuginfo-3.0.3-1.osgup.el6
zookeeper-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osgup.el6
zookeeper-debuginfo-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osgup.el6
zookeeper-native-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osgup.el6
zookeeper-server-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.39.bosco-1.osgup.el7
blahp-debuginfo-1.18.39.bosco-1.osgup.el7
singularity-3.0.3-1.osgup.el7
singularity-debuginfo-3.0.3-1.osgup.el7
```
