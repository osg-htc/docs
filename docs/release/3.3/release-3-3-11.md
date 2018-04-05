OSG Software Release 3.3.11
===========================

**Release Date**: 2016-04-12

Summary of changes
------------------

This release contains:

-   [VO Package v65](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-65-2) - More OSG CA migrations
-   CA Certificates based on [IGTF 1.73](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
-   [XRootD 4.3.0](https://github.com/xrootd/xrootd/blob/v4.3.0/docs/ReleaseNotes.txt): Several important fixes for bugs affecting CMS
-   HDFS 2.0.0+1612: Support ACLs, Support the EL7 platform
-   Update to [GlideinWMS 3.2.13](http://glideinwms.fnal.gov/doc.v3_2_13/history.html)
-   Add gfal functionality to xrootd-dsi
-   HTCondor CE 2.0.4: Accept full subject DNs in extattr\_table.txt
-   BLAHP 1.18.18: Changes in the BLAHP to support PBS Pro
-   osg-pki-tools 1.2.15: Better error messages and checking of arguments
-   [HTCondor 8.4.5](https://lists.cs.wisc.edu/archive/htcondor-users/2016-March/msg00143.shtml): Various bug fixes
-   Pull in the required log4j package when installing the emi-trustmanager
-   [HTCondor 8.5.3](https://lists.cs.wisc.edu/archive/htcondor-users/2016-March/msg00153.shtml) in the Upcoming repository
-   Support for an OSG CVMFS configuration repository in the Upcoming repository

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.11%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   `condor_ce_q` does not show any jobs when run as root with `condor-8.5.3` from upcoming. Work around this by using `condor_ce_q -allusers` instead.

<!-- -->

-   The new HTCondor-CE View has a bug where some graphs show up blank. This may also manifest in errors like the following in `/var/log/condor-ce/GangliadLog`: \\ <pre class="file">

1/11/16 15:05:54 Failed to execute /usr/share/condor-ce/condor\_ce\_metric --conf /etc/ganglia/gmond.conf --group HTCondor.Schedd --name SchedulerRecentDaemonCoreDutyCycle --value 1.04449 --type float --units % --slope both --spoof 192.170.227.226:itbv-ce-htcondor.mwt2.org --tmax 120 --dmax 86400: Usage: condor\_ce\_metric \[options\]

condor\_ce\_metric: error: no such option: --conf

01/11/16 15:05:54 Failed to publish metric SchedulerRecentDaemonCoreDutyCycle for itbv-ce-htcondor.mwt2.org </pre>

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note
    Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

!!! note
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.osg33.el6)
-   [blahp-1.18.18.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.18.bosco-1.osg33.el6)
-   [condor-8.4.5-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.5-1.osg33.el6)
-   [emi-trustmanager-3.0.3-11.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-3.0.3-11.osg33.el6)
-   [glideinwms-3.2.13-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.13-1.osg33.el6)
-   [gridftp-hdfs-0.5.4-25.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-25.osg33.el6)
-   [hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6)
-   [htcondor-ce-2.0.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.4-1.osg33.el6)
-   [igtf-ca-certs-1.73-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.73-1.osg33.el6)
-   [osg-ca-certs-1.54-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.54-1.osg33.el6)
-   [osg-pki-tools-1.2.15-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.15-1.osg33.el6)
-   [osg-release-3.3-5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-release-3.3-5.osg33.el6)
-   [osg-release-itb-3.3-5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-release-itb-3.3-5.osg33.el6)
-   [osg-test-1.6.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.6.0-1.osg33.el6)
-   [osg-version-3.3.11-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.11-1.osg33.el6)
-   [vo-client-65-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-65-2.osg33.el6)
-   [xrootd-4.3.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.3.0-1.osg33.el6)
-   [xrootd-dsi-3.0.4-17.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-dsi-3.0.4-17.osg33.el6)
-   [xrootd-hdfs-1.8.7-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.8.7-2.osg33.el6)

#### Enterprise Linux 7

-   [bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.osg33.el7)
-   [blahp-1.18.18.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.18.bosco-1.osg33.el7)
-   [condor-8.4.5-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.5-1.osg33.el7)
-   [emi-trustmanager-3.0.3-11.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-3.0.3-11.osg33.el7)
-   [glideinwms-3.2.13-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.13-1.osg33.el7)
-   [gridftp-hdfs-0.5.4-25.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-25.osg33.el7)
-   [hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7)
-   [htcondor-ce-2.0.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.4-1.osg33.el7)
-   [igtf-ca-certs-1.73-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.73-1.osg33.el7)
-   [osg-ca-certs-1.54-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.54-1.osg33.el7)
-   [osg-pki-tools-1.2.15-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.15-1.osg33.el7)
-   [osg-release-3.3-5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-release-3.3-5.osg33.el7)
-   [osg-release-itb-3.3-5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-release-itb-3.3-5.osg33.el7)
-   [osg-test-1.6.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.6.0-1.osg33.el7)
-   [osg-version-3.3.11-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.11-1.osg33.el7)
-   [vo-client-65-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-65-2.osg33.el7)
-   [xrootd-4.3.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.3.0-1.osg33.el7)
-   [xrootd-dsi-3.0.4-17.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-dsi-3.0.4-17.osg33.el7)
-   [xrootd-hdfs-1.8.7-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.8.7-2.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    bigtop-utils blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp emi-trustmanager glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone gridftp-hdfs gridftp-hdfs-debuginfo hadoop hadoop-0.20-conf-pseudo hadoop-0.20-mapreduce hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-fuse-selinux hadoop-hdfs-journalnode hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-libhdfs hadoop-mapreduce hadoop-yarn htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view igtf-ca-certs osg-ca-certs osg-gums-config osg-pki-tools osg-pki-tools-tests osg-release osg-release-itb osg-test osg-version vo-client vo-client-edgmkgridmap xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-dsi xrootd-dsi-debuginfo xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.osg33.el6
blahp-1.18.18.bosco-1.osg33.el6
blahp-debuginfo-1.18.18.bosco-1.osg33.el6
condor-8.4.5-1.osg33.el6
condor-all-8.4.5-1.osg33.el6
condor-bosco-8.4.5-1.osg33.el6
condor-classads-8.4.5-1.osg33.el6
condor-classads-devel-8.4.5-1.osg33.el6
condor-cream-gahp-8.4.5-1.osg33.el6
condor-debuginfo-8.4.5-1.osg33.el6
condor-kbdd-8.4.5-1.osg33.el6
condor-procd-8.4.5-1.osg33.el6
condor-python-8.4.5-1.osg33.el6
condor-std-universe-8.4.5-1.osg33.el6
condor-test-8.4.5-1.osg33.el6
condor-vm-gahp-8.4.5-1.osg33.el6
emi-trustmanager-3.0.3-11.osg33.el6
glideinwms-3.2.13-1.osg33.el6
glideinwms-common-tools-3.2.13-1.osg33.el6
glideinwms-condor-common-config-3.2.13-1.osg33.el6
glideinwms-factory-3.2.13-1.osg33.el6
glideinwms-factory-condor-3.2.13-1.osg33.el6
glideinwms-glidecondor-tools-3.2.13-1.osg33.el6
glideinwms-libs-3.2.13-1.osg33.el6
glideinwms-minimal-condor-3.2.13-1.osg33.el6
glideinwms-usercollector-3.2.13-1.osg33.el6
glideinwms-userschedd-3.2.13-1.osg33.el6
glideinwms-vofrontend-3.2.13-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.13-1.osg33.el6
gridftp-hdfs-0.5.4-25.osg33.el6
gridftp-hdfs-debuginfo-0.5.4-25.osg33.el6
hadoop-0.20-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-0.20-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-client-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-debuginfo-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-doc-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-hdfs-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-hdfs-datanode-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-hdfs-fuse-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-hdfs-fuse-selinux-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-hdfs-journalnode-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-hdfs-namenode-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-hdfs-secondarynamenode-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-hdfs-zkfc-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-httpfs-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-libhdfs-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
hadoop-yarn-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el6
htcondor-ce-2.0.4-1.osg33.el6
htcondor-ce-client-2.0.4-1.osg33.el6
htcondor-ce-collector-2.0.4-1.osg33.el6
htcondor-ce-condor-2.0.4-1.osg33.el6
htcondor-ce-lsf-2.0.4-1.osg33.el6
htcondor-ce-pbs-2.0.4-1.osg33.el6
htcondor-ce-sge-2.0.4-1.osg33.el6
htcondor-ce-view-2.0.4-1.osg33.el6
igtf-ca-certs-1.73-1.osg33.el6
osg-ca-certs-1.54-1.osg33.el6
osg-gums-config-65-2.osg33.el6
osg-pki-tools-1.2.15-1.osg33.el6
osg-pki-tools-tests-1.2.15-1.osg33.el6
osg-release-3.3-5.osg33.el6
osg-release-itb-3.3-5.osg33.el6
osg-test-1.6.0-1.osg33.el6
osg-version-3.3.11-1.osg33.el6
vo-client-65-2.osg33.el6
vo-client-edgmkgridmap-65-2.osg33.el6
xrootd-4.3.0-1.osg33.el6
xrootd-client-4.3.0-1.osg33.el6
xrootd-client-devel-4.3.0-1.osg33.el6
xrootd-client-libs-4.3.0-1.osg33.el6
xrootd-debuginfo-4.3.0-1.osg33.el6
xrootd-devel-4.3.0-1.osg33.el6
xrootd-doc-4.3.0-1.osg33.el6
xrootd-dsi-3.0.4-17.osg33.el6
xrootd-dsi-debuginfo-3.0.4-17.osg33.el6
xrootd-fuse-4.3.0-1.osg33.el6
xrootd-hdfs-1.8.7-2.osg33.el6
xrootd-hdfs-debuginfo-1.8.7-2.osg33.el6
xrootd-hdfs-devel-1.8.7-2.osg33.el6
xrootd-libs-4.3.0-1.osg33.el6
xrootd-private-devel-4.3.0-1.osg33.el6
xrootd-python-4.3.0-1.osg33.el6
xrootd-selinux-4.3.0-1.osg33.el6
xrootd-server-4.3.0-1.osg33.el6
xrootd-server-devel-4.3.0-1.osg33.el6
xrootd-server-libs-4.3.0-1.osg33.el6
```

#### Enterprise Linux 7

``` file
bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.osg33.el7
blahp-1.18.18.bosco-1.osg33.el7
blahp-debuginfo-1.18.18.bosco-1.osg33.el7
condor-8.4.5-1.osg33.el7
condor-all-8.4.5-1.osg33.el7
condor-bosco-8.4.5-1.osg33.el7
condor-classads-8.4.5-1.osg33.el7
condor-classads-devel-8.4.5-1.osg33.el7
condor-debuginfo-8.4.5-1.osg33.el7
condor-kbdd-8.4.5-1.osg33.el7
condor-procd-8.4.5-1.osg33.el7
condor-python-8.4.5-1.osg33.el7
condor-test-8.4.5-1.osg33.el7
condor-vm-gahp-8.4.5-1.osg33.el7
emi-trustmanager-3.0.3-11.osg33.el7
glideinwms-3.2.13-1.osg33.el7
glideinwms-common-tools-3.2.13-1.osg33.el7
glideinwms-condor-common-config-3.2.13-1.osg33.el7
glideinwms-factory-3.2.13-1.osg33.el7
glideinwms-factory-condor-3.2.13-1.osg33.el7
glideinwms-glidecondor-tools-3.2.13-1.osg33.el7
glideinwms-libs-3.2.13-1.osg33.el7
glideinwms-minimal-condor-3.2.13-1.osg33.el7
glideinwms-usercollector-3.2.13-1.osg33.el7
glideinwms-userschedd-3.2.13-1.osg33.el7
glideinwms-vofrontend-3.2.13-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.13-1.osg33.el7
gridftp-hdfs-0.5.4-25.osg33.el7
gridftp-hdfs-debuginfo-0.5.4-25.osg33.el7
hadoop-0.20-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-0.20-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-client-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-debuginfo-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-doc-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-hdfs-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-hdfs-datanode-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-hdfs-fuse-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-hdfs-fuse-selinux-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-hdfs-journalnode-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-hdfs-namenode-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-hdfs-secondarynamenode-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-hdfs-zkfc-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-httpfs-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-libhdfs-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
hadoop-yarn-2.0.0+1612-1.cdh4.7.1.p0.12.3.osg33.el7
htcondor-ce-2.0.4-1.osg33.el7
htcondor-ce-client-2.0.4-1.osg33.el7
htcondor-ce-collector-2.0.4-1.osg33.el7
htcondor-ce-condor-2.0.4-1.osg33.el7
htcondor-ce-lsf-2.0.4-1.osg33.el7
htcondor-ce-pbs-2.0.4-1.osg33.el7
htcondor-ce-sge-2.0.4-1.osg33.el7
htcondor-ce-view-2.0.4-1.osg33.el7
igtf-ca-certs-1.73-1.osg33.el7
osg-ca-certs-1.54-1.osg33.el7
osg-gums-config-65-2.osg33.el7
osg-pki-tools-1.2.15-1.osg33.el7
osg-pki-tools-tests-1.2.15-1.osg33.el7
osg-release-3.3-5.osg33.el7
osg-release-itb-3.3-5.osg33.el7
osg-test-1.6.0-1.osg33.el7
osg-version-3.3.11-1.osg33.el7
vo-client-65-2.osg33.el7
vo-client-edgmkgridmap-65-2.osg33.el7
xrootd-4.3.0-1.osg33.el7
xrootd-client-4.3.0-1.osg33.el7
xrootd-client-devel-4.3.0-1.osg33.el7
xrootd-client-libs-4.3.0-1.osg33.el7
xrootd-debuginfo-4.3.0-1.osg33.el7
xrootd-devel-4.3.0-1.osg33.el7
xrootd-doc-4.3.0-1.osg33.el7
xrootd-dsi-3.0.4-17.osg33.el7
xrootd-dsi-debuginfo-3.0.4-17.osg33.el7
xrootd-fuse-4.3.0-1.osg33.el7
xrootd-hdfs-1.8.7-2.osg33.el7
xrootd-hdfs-debuginfo-1.8.7-2.osg33.el7
xrootd-hdfs-devel-1.8.7-2.osg33.el7
xrootd-libs-4.3.0-1.osg33.el7
xrootd-private-devel-4.3.0-1.osg33.el7
xrootd-python-4.3.0-1.osg33.el7
xrootd-selinux-4.3.0-1.osg33.el7
xrootd-server-4.3.0-1.osg33.el7
xrootd-server-devel-4.3.0-1.osg33.el7
xrootd-server-libs-4.3.0-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.18.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.18.bosco-1.osgup.el6)
-   [condor-8.5.3-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.3-1.osgup.el6)
-   [cvmfs-2.2.1-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.2.1-1.osgup.el6)
-   [cvmfs-config-osg-1.2-3.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-3.osgup.el6)
-   [osg-oasis-6-4.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-6-4.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.18.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.18.bosco-1.osgup.el7)
-   [condor-8.5.3-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.3-1.osgup.el7)
-   [cvmfs-2.2.1-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.2.1-1.osgup.el7)
-   [cvmfs-config-osg-1.2-3.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-3.osgup.el7)
-   [osg-oasis-6-4.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-6-4.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-config-osg cvmfs-devel cvmfs-server cvmfs-unittests osg-oasis

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.18.bosco-1.osgup.el6
blahp-debuginfo-1.18.18.bosco-1.osgup.el6
condor-8.5.3-1.osgup.el6
condor-all-8.5.3-1.osgup.el6
condor-bosco-8.5.3-1.osgup.el6
condor-classads-8.5.3-1.osgup.el6
condor-classads-devel-8.5.3-1.osgup.el6
condor-cream-gahp-8.5.3-1.osgup.el6
condor-debuginfo-8.5.3-1.osgup.el6
condor-kbdd-8.5.3-1.osgup.el6
condor-procd-8.5.3-1.osgup.el6
condor-python-8.5.3-1.osgup.el6
condor-std-universe-8.5.3-1.osgup.el6
condor-test-8.5.3-1.osgup.el6
condor-vm-gahp-8.5.3-1.osgup.el6
cvmfs-2.2.1-1.osgup.el6
cvmfs-config-osg-1.2-3.osgup.el6
cvmfs-devel-2.2.1-1.osgup.el6
cvmfs-server-2.2.1-1.osgup.el6
cvmfs-unittests-2.2.1-1.osgup.el6
osg-oasis-6-4.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.18.bosco-1.osgup.el7
blahp-debuginfo-1.18.18.bosco-1.osgup.el7
condor-8.5.3-1.osgup.el7
condor-all-8.5.3-1.osgup.el7
condor-bosco-8.5.3-1.osgup.el7
condor-classads-8.5.3-1.osgup.el7
condor-classads-devel-8.5.3-1.osgup.el7
condor-debuginfo-8.5.3-1.osgup.el7
condor-kbdd-8.5.3-1.osgup.el7
condor-procd-8.5.3-1.osgup.el7
condor-python-8.5.3-1.osgup.el7
condor-test-8.5.3-1.osgup.el7
condor-vm-gahp-8.5.3-1.osgup.el7
cvmfs-2.2.1-1.osgup.el7
cvmfs-config-osg-1.2-3.osgup.el7
cvmfs-devel-2.2.1-1.osgup.el7
cvmfs-server-2.2.1-1.osgup.el7
cvmfs-unittests-2.2.1-1.osgup.el7
osg-oasis-6-4.osgup.el7
```

