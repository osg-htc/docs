OSG Software Release 3.4.14
===========================

**Release Date**: 2018-07-02

Summary of changes
------------------

This release contains:

-   OSG 3.4 respository
    -   [Hadoop Distributed File System 2.6](https://opensciencegrid.org/docs/data/hadoop-overview/) on El7 (Based on cloudera CDH 5)
    -   osg-configure 2.3.1: automatically turn off BLAHP proxy renewal on HTCondor-CE
    -   RSV 3.19.7: works with Apache 2.4, fixed CA and CRL probes
    -   lcmaps-plugins-voms 1.7.1-1.6: fixes issues with llrun
    -   Gratia probes 1.20.3: improve performance with PBS/LSF batch systems
    -   osg-pki-tools 3.0.0: [generate CSRs for CAs](https://opensciencegrid.org/docs/security/host-certs/#requesting-incommon-igtf-host-certificates)

        !!! note
            The OSG CA has been retired


    -   GridFTP-HDFS 1.1.1-1.2: increase control channel timeout to avoid checksum failures
    -   lcmaps-plugins-verify-proxy: fix rare crash
    -   [One-Way Ping (OWAMP) 3.5.6](http://software.internet2.edu/owamp/): Minor bug fixes
    -   BLAHP: Improved security
-   Upcoming repository
    -   [GlideinWMS 3.4](http://glideinwms.fnal.gov/doc.v3_4/history.html)
        -   Code modernization to Python 2.7 idioms (Python 2.6 is still supported)
        -   Support for Google CE and the policy plugins.
        -   Glidein lifetime is no longer based on the length of the proxy
        -   New option to kill glideins when the number of job requests drop
        -   Estimate in advance how many cores will be provided to glideins
        -   Add entry monitoring breakdown for metasites
        -   Review Factory and Frontend tools, especially glidien_off and manual_glidein_submit.py
        -   Singularity improvements
            -   Use PATH and module when SINGULARITY_BIN does not contain the correct path
            -   Run in a separate session to support restricted-access CVMFS

        !!! note "Notes"
            -   All nodes
                -   GLIDEIN_ToDie is no longer shortened depending on the X509 proxy lifetime, to get the old behavior set GLIDEIN_Ignore_X509_Duration to False
                -   The type of the GLIDEIN_CPU attr is String (to accomodate the keywords auto, slot, node). It was incorrectly documented as type Int. Make sure your configuration uses the correct type or you may get a reconfig/upgrade error.
            -   Factory only:
                -   If you use HTCondor 8.7.2 or later with the GlideinWMS Factory, then GRAM gateways are no longer supported
                -   'entry_sets' should be considered an experimental feature: the implementation will change in 3.4.1 and there may be errors and manual interventions required when upgrading to new versions of GlideinWMS if metasites are configured


    -   BLAHP: Improved security

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.14%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

-   [blahp-1.18.37.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.37.bosco-1.osg34.el6)
-   [globus-gridftp-server-12.2-1.3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.2-1.3.osg34.el6)
-   [gratia-probe-1.20.3-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.3-2.osg34.el6)
-   [lcmaps-plugins-verify-proxy-1.5.11-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.11-1.1.osg34.el6)
-   [lcmaps-plugins-voms-1.7.1-1.6.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.6.osg34.el6)
-   [osg-build-1.13.0.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.13.0.1-1.osg34.el6)
-   [osg-configure-2.3.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.3.1-1.osg34.el6)
-   [osg-pki-tools-3.0.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.0.0-1.osg34.el6)
-   [osg-version-3.4.14-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.14-1.osg34.el6)
-   [owamp-3.5.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=owamp-3.5.6-1.osg34.el6)
-   [rsv-3.19.7-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.19.7-1.osg34.el6)

#### Enterprise Linux 7

-   [avro-libs-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=avro-libs-1.7.6%2Bcdh5.13.0%2B135-1.cdh5.13.0.p0.34.1.osg34.el7)
-   [bigtop-jsvc-0.3.0-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bigtop-jsvc-0.3.0-1.2.osg34.el7)
-   [bigtop-utils-0.7.0+cdh5.13.0+0-1.cdh5.13.0.p0.34.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bigtop-utils-0.7.0%2Bcdh5.13.0%2B0-1.cdh5.13.0.p0.34.1.osg34.el7)
-   [blahp-1.18.37.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.37.bosco-1.osg34.el7)
-   [globus-gridftp-server-12.2-1.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.2-1.3.osg34.el7)
-   [gratia-probe-1.20.3-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.3-2.osg34.el7)
-   [gridftp-hdfs-1.1.1-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-hdfs-1.1.1-1.2.osg34.el7)
-   [hadoop-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hadoop-2.6.0%2Bcdh5.12.1%2B2540-1.cdh5.12.1.p0.3.7.osg34.el7
-   [lcmaps-plugins-verify-proxy-1.5.11-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.11-1.1.osg34.el7)
-   [lcmaps-plugins-voms-1.7.1-1.6.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.6.osg34.el7)
-   [osg-build-1.13.0.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.13.0.1-1.osg34.el7)
-   [osg-configure-2.3.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.3.1-1.osg34.el7)
-   [osg-gridftp-hdfs-3.4-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-hdfs-3.4-3.osg34.el7)
-   [osg-pki-tools-3.0.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.0.0-1.osg34.el7)
-   [osg-se-hadoop-3.4-6.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-se-hadoop-3.4-6.osg34.el7)
-   [osg-version-3.4.14-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.14-1.osg34.el7)
-   [owamp-3.5.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=owamp-3.5.6-1.osg34.el7)
-   [rsv-3.19.7-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.19.7-1.osg34.el7)
-   [xrootd-hdfs-2.0.2-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.0.2-1.1.osg34.el7)
-   [zookeeper-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=zookeeper-3.4.5%2Bcdh5.14.2%2B142-1.cdh5.14.2.p0.11.1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    avro-doc avro-libs avro-tools bigtop-jsvc bigtop-jsvc-debuginfo bigtop-utils blahp blahp-debuginfo globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer gridftp-hdfs gridftp-hdfs-debuginfo hadoop hadoop-0.20-conf-pseudo hadoop-0.20-mapreduce hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-journalnode hadoop-hdfs-namenode hadoop-hdfs-nfs3 hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-kms hadoop-kms-server hadoop-libhdfs hadoop-libhdfs-devel hadoop-mapreduce hadoop-yarn lcmaps-plugins-verify-proxy lcmaps-plugins-verify-proxy-debuginfo lcmaps-plugins-voms lcmaps-plugins-voms-debuginfo osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-gridftp-hdfs osg-pki-tools osg-se-hadoop osg-se-hadoop-client osg-se-hadoop-datanode osg-se-hadoop-gridftp osg-se-hadoop-namenode osg-se-hadoop-secondarynamenode osg-version owamp owamp-client owamp-debuginfo owamp-server rsv rsv-consumers rsv-core rsv-metrics xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel zookeeper zookeeper-debuginfo zookeeper-native zookeeper-server

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.37.bosco-1.osg34.el6
blahp-debuginfo-1.18.37.bosco-1.osg34.el6
globus-gridftp-server-12.2-1.3.osg34.el6
globus-gridftp-server-debuginfo-12.2-1.3.osg34.el6
globus-gridftp-server-devel-12.2-1.3.osg34.el6
globus-gridftp-server-progs-12.2-1.3.osg34.el6
gratia-probe-1.20.3-2.osg34.el6
gratia-probe-common-1.20.3-2.osg34.el6
gratia-probe-condor-1.20.3-2.osg34.el6
gratia-probe-condor-events-1.20.3-2.osg34.el6
gratia-probe-dcache-storage-1.20.3-2.osg34.el6
gratia-probe-dcache-storagegroup-1.20.3-2.osg34.el6
gratia-probe-dcache-transfer-1.20.3-2.osg34.el6
gratia-probe-debuginfo-1.20.3-2.osg34.el6
gratia-probe-enstore-storage-1.20.3-2.osg34.el6
gratia-probe-enstore-tapedrive-1.20.3-2.osg34.el6
gratia-probe-enstore-transfer-1.20.3-2.osg34.el6
gratia-probe-glideinwms-1.20.3-2.osg34.el6
gratia-probe-gridftp-transfer-1.20.3-2.osg34.el6
gratia-probe-hadoop-storage-1.20.3-2.osg34.el6
gratia-probe-htcondor-ce-1.20.3-2.osg34.el6
gratia-probe-lsf-1.20.3-2.osg34.el6
gratia-probe-metric-1.20.3-2.osg34.el6
gratia-probe-onevm-1.20.3-2.osg34.el6
gratia-probe-pbs-lsf-1.20.3-2.osg34.el6
gratia-probe-services-1.20.3-2.osg34.el6
gratia-probe-sge-1.20.3-2.osg34.el6
gratia-probe-slurm-1.20.3-2.osg34.el6
gratia-probe-xrootd-storage-1.20.3-2.osg34.el6
gratia-probe-xrootd-transfer-1.20.3-2.osg34.el6
lcmaps-plugins-verify-proxy-1.5.11-1.1.osg34.el6
lcmaps-plugins-verify-proxy-debuginfo-1.5.11-1.1.osg34.el6
lcmaps-plugins-voms-1.7.1-1.6.osg34.el6
lcmaps-plugins-voms-debuginfo-1.7.1-1.6.osg34.el6
osg-build-1.13.0.1-1.osg34.el6
osg-build-base-1.13.0.1-1.osg34.el6
osg-build-koji-1.13.0.1-1.osg34.el6
osg-build-mock-1.13.0.1-1.osg34.el6
osg-build-tests-1.13.0.1-1.osg34.el6
osg-configure-2.3.1-1.osg34.el6
osg-configure-bosco-2.3.1-1.osg34.el6
osg-configure-ce-2.3.1-1.osg34.el6
osg-configure-condor-2.3.1-1.osg34.el6
osg-configure-gateway-2.3.1-1.osg34.el6
osg-configure-gip-2.3.1-1.osg34.el6
osg-configure-gratia-2.3.1-1.osg34.el6
osg-configure-infoservices-2.3.1-1.osg34.el6
osg-configure-lsf-2.3.1-1.osg34.el6
osg-configure-misc-2.3.1-1.osg34.el6
osg-configure-pbs-2.3.1-1.osg34.el6
osg-configure-rsv-2.3.1-1.osg34.el6
osg-configure-sge-2.3.1-1.osg34.el6
osg-configure-siteinfo-2.3.1-1.osg34.el6
osg-configure-slurm-2.3.1-1.osg34.el6
osg-configure-squid-2.3.1-1.osg34.el6
osg-configure-tests-2.3.1-1.osg34.el6
osg-pki-tools-3.0.0-1.osg34.el6
osg-version-3.4.14-1.osg34.el6
owamp-3.5.6-1.osg34.el6
owamp-client-3.5.6-1.osg34.el6
owamp-debuginfo-3.5.6-1.osg34.el6
owamp-server-3.5.6-1.osg34.el6
rsv-3.19.7-1.osg34.el6
rsv-consumers-3.19.7-1.osg34.el6
rsv-core-3.19.7-1.osg34.el6
rsv-metrics-3.19.7-1.osg34.el6
```

#### Enterprise Linux 7

``` file
avro-doc-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.1.osg34.el7
avro-libs-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.1.osg34.el7
avro-tools-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.1.osg34.el7
bigtop-jsvc-0.3.0-1.2.osg34.el7
bigtop-jsvc-debuginfo-0.3.0-1.2.osg34.el7
bigtop-utils-0.7.0+cdh5.13.0+0-1.cdh5.13.0.p0.34.1.osg34.el7
blahp-1.18.37.bosco-1.osg34.el7
blahp-debuginfo-1.18.37.bosco-1.osg34.el7
globus-gridftp-server-12.2-1.3.osg34.el7
globus-gridftp-server-debuginfo-12.2-1.3.osg34.el7
globus-gridftp-server-devel-12.2-1.3.osg34.el7
globus-gridftp-server-progs-12.2-1.3.osg34.el7
gratia-probe-1.20.3-2.osg34.el7
gratia-probe-common-1.20.3-2.osg34.el7
gratia-probe-condor-1.20.3-2.osg34.el7
gratia-probe-condor-events-1.20.3-2.osg34.el7
gratia-probe-dcache-storage-1.20.3-2.osg34.el7
gratia-probe-dcache-storagegroup-1.20.3-2.osg34.el7
gratia-probe-dcache-transfer-1.20.3-2.osg34.el7
gratia-probe-debuginfo-1.20.3-2.osg34.el7
gratia-probe-enstore-storage-1.20.3-2.osg34.el7
gratia-probe-enstore-tapedrive-1.20.3-2.osg34.el7
gratia-probe-enstore-transfer-1.20.3-2.osg34.el7
gratia-probe-glideinwms-1.20.3-2.osg34.el7
gratia-probe-gridftp-transfer-1.20.3-2.osg34.el7
gratia-probe-hadoop-storage-1.20.3-2.osg34.el7
gratia-probe-htcondor-ce-1.20.3-2.osg34.el7
gratia-probe-lsf-1.20.3-2.osg34.el7
gratia-probe-metric-1.20.3-2.osg34.el7
gratia-probe-onevm-1.20.3-2.osg34.el7
gratia-probe-pbs-lsf-1.20.3-2.osg34.el7
gratia-probe-services-1.20.3-2.osg34.el7
gratia-probe-sge-1.20.3-2.osg34.el7
gratia-probe-slurm-1.20.3-2.osg34.el7
gratia-probe-xrootd-storage-1.20.3-2.osg34.el7
gratia-probe-xrootd-transfer-1.20.3-2.osg34.el7
gridftp-hdfs-1.1.1-1.2.osg34.el7
gridftp-hdfs-debuginfo-1.1.1-1.2.osg34.el7
hadoop-0.20-conf-pseudo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-0.20-mapreduce-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-client-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-conf-pseudo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-debuginfo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-doc-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-hdfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-hdfs-datanode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-hdfs-fuse-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-hdfs-journalnode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-hdfs-namenode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-hdfs-nfs3-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-hdfs-secondarynamenode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-hdfs-zkfc-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-httpfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-kms-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-kms-server-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-libhdfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-libhdfs-devel-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-mapreduce-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
hadoop-yarn-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osg34.el7
lcmaps-plugins-verify-proxy-1.5.11-1.1.osg34.el7
lcmaps-plugins-verify-proxy-debuginfo-1.5.11-1.1.osg34.el7
lcmaps-plugins-voms-1.7.1-1.6.osg34.el7
lcmaps-plugins-voms-debuginfo-1.7.1-1.6.osg34.el7
osg-build-1.13.0.1-1.osg34.el7
osg-build-base-1.13.0.1-1.osg34.el7
osg-build-koji-1.13.0.1-1.osg34.el7
osg-build-mock-1.13.0.1-1.osg34.el7
osg-build-tests-1.13.0.1-1.osg34.el7
osg-configure-2.3.1-1.osg34.el7
osg-configure-bosco-2.3.1-1.osg34.el7
osg-configure-ce-2.3.1-1.osg34.el7
osg-configure-condor-2.3.1-1.osg34.el7
osg-configure-gateway-2.3.1-1.osg34.el7
osg-configure-gip-2.3.1-1.osg34.el7
osg-configure-gratia-2.3.1-1.osg34.el7
osg-configure-infoservices-2.3.1-1.osg34.el7
osg-configure-lsf-2.3.1-1.osg34.el7
osg-configure-misc-2.3.1-1.osg34.el7
osg-configure-pbs-2.3.1-1.osg34.el7
osg-configure-rsv-2.3.1-1.osg34.el7
osg-configure-sge-2.3.1-1.osg34.el7
osg-configure-siteinfo-2.3.1-1.osg34.el7
osg-configure-slurm-2.3.1-1.osg34.el7
osg-configure-squid-2.3.1-1.osg34.el7
osg-configure-tests-2.3.1-1.osg34.el7
osg-gridftp-hdfs-3.4-3.osg34.el7
osg-pki-tools-3.0.0-1.osg34.el7
osg-se-hadoop-3.4-6.osg34.el7
osg-se-hadoop-client-3.4-6.osg34.el7
osg-se-hadoop-datanode-3.4-6.osg34.el7
osg-se-hadoop-gridftp-3.4-6.osg34.el7
osg-se-hadoop-namenode-3.4-6.osg34.el7
osg-se-hadoop-secondarynamenode-3.4-6.osg34.el7
osg-version-3.4.14-1.osg34.el7
owamp-3.5.6-1.osg34.el7
owamp-client-3.5.6-1.osg34.el7
owamp-debuginfo-3.5.6-1.osg34.el7
owamp-server-3.5.6-1.osg34.el7
rsv-3.19.7-1.osg34.el7
rsv-consumers-3.19.7-1.osg34.el7
rsv-core-3.19.7-1.osg34.el7
rsv-metrics-3.19.7-1.osg34.el7
xrootd-hdfs-2.0.2-1.1.osg34.el7
xrootd-hdfs-debuginfo-2.0.2-1.1.osg34.el7
xrootd-hdfs-devel-2.0.2-1.1.osg34.el7
zookeeper-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg34.el7
zookeeper-debuginfo-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg34.el7
zookeeper-native-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg34.el7
zookeeper-server-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.37.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.37.bosco-1.osgup.el6)
-   [glideinwms-3.4-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.37.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.37.bosco-1.osgup.el7)
-   [glideinwms-3.4-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.37.bosco-1.osgup.el6
blahp-debuginfo-1.18.37.bosco-1.osgup.el6
glideinwms-3.4-1.osgup.el6
glideinwms-common-tools-3.4-1.osgup.el6
glideinwms-condor-common-config-3.4-1.osgup.el6
glideinwms-factory-3.4-1.osgup.el6
glideinwms-factory-condor-3.4-1.osgup.el6
glideinwms-glidecondor-tools-3.4-1.osgup.el6
glideinwms-libs-3.4-1.osgup.el6
glideinwms-minimal-condor-3.4-1.osgup.el6
glideinwms-usercollector-3.4-1.osgup.el6
glideinwms-userschedd-3.4-1.osgup.el6
glideinwms-vofrontend-3.4-1.osgup.el6
glideinwms-vofrontend-standalone-3.4-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.37.bosco-1.osgup.el7
blahp-debuginfo-1.18.37.bosco-1.osgup.el7
glideinwms-3.4-1.osgup.el7
glideinwms-common-tools-3.4-1.osgup.el7
glideinwms-condor-common-config-3.4-1.osgup.el7
glideinwms-factory-3.4-1.osgup.el7
glideinwms-factory-condor-3.4-1.osgup.el7
glideinwms-glidecondor-tools-3.4-1.osgup.el7
glideinwms-libs-3.4-1.osgup.el7
glideinwms-minimal-condor-3.4-1.osgup.el7
glideinwms-usercollector-3.4-1.osgup.el7
glideinwms-userschedd-3.4-1.osgup.el7
glideinwms-vofrontend-3.4-1.osgup.el7
glideinwms-vofrontend-standalone-3.4-1.osgup.el7
```
