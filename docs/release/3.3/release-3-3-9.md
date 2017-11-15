OSG Software Release 3.3.9
==========================

**Release Date**: 2016-02-09

Summary of changes
------------------

This release contains:

-   Update GSI-OpenSSH 5.7 to address [CVE-2016-0777](https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2016-0777)
-   [glideinWMS 3.2.12](http://glideinwms.fnal.gov/doc.v3_2_12_1/history.html)
-   CVMFS over StashCache in the Upcoming Repository
    -   [CVMFS 2.2.0](http://cernvm.cern.ch/portal/filesystem/cvmfs-2.2.0-prerelease)
    -   Configuration RPM
    -   XRootD LCMAPS 1.2.1
-   XRootD HDFS plugin - support non-world-readable files
-   lcmaps-plugins-scas-client - fix memory leak, better man page
-   CA Certificates based on [IGTF 1.71](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
-   [VO Package v63](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-63)
-   VOMS admin update to disable unnecessary CA check
-   Better warnings and message handling in RSV-perfsonar 1.1.2
-   Support for HDFS on EL7 platforms
-   jGlobus - remove tomcat dependency
-   HTCondor CE - requires HTCondor >= 8.3.7
-   emi-trustmanager update to support gratia service in EL7

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.9%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   The new HTCondor-CE View has a bug where some graphs show up blank. This may also manifest in errors like the following in `/var/log/condor-ce/GangliadLog`: \\ <pre class="file">

1/11/16 15:05:54 Failed to execute /usr/share/condor-ce/condor\_ce\_metric --conf /etc/ganglia/gmond.conf --group HTCondor.Schedd --name SchedulerRecentDaemonCoreDutyCycle --value 1.04449 --type float --units % --slope both --spoof 192.170.227.226:itbv-ce-htcondor.mwt2.org --tmax 120 --dmax 86400: Usage: condor\_ce\_metric \[options\]

condor\_ce\_metric: error: no such option: --conf

01/11/16 15:05:54 Failed to publish metric SchedulerRecentDaemonCoreDutyCycle for itbv-ce-htcondor.mwt2.org </pre>

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note
    Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

!!! note
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [emi-trustmanager-3.0.3-10.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-3.0.3-10.osg33.el6)
-   [emi-trustmanager-tomcat-3.0.0-14.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-tomcat-3.0.0-14.osg33.el6)
-   [glideinwms-3.2.12.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.12.1-1.osg33.el6)
-   [gsi-openssh-5.7-4.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gsi-openssh-5.7-4.1.osg33.el6)
-   [hadoop-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6)
-   [htcondor-ce-2.0.0-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.0-2.osg33.el6)
-   [igtf-ca-certs-1.71-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.71-1.osg33.el6)
-   [jglobus-2.1.0-7.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=jglobus-2.1.0-7.osg33.el6)
-   [lcmaps-plugins-scas-client-0.5.6-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=lcmaps-plugins-scas-client-0.5.6-1.osg33.el6)
-   [osg-ca-certs-1.52-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.52-1.osg33.el6)
-   [osg-ca-generator-1.0.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-generator-1.0.2-1.osg33.el6)
-   [osg-test-1.5.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.5.1-1.osg33.el6)
-   [osg-version-3.3.9-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.9-1.osg33.el6)
-   [rsv-perfsonar-1.1.2-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-perfsonar-1.1.2-3.osg33.el6)
-   [vo-client-63-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-63-1.osg33.el6)
-   [voms-admin-server-2.7.0-1.21.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-admin-server-2.7.0-1.21.osg33.el6)
-   [voms-api-java-2.0.8-1.9.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-api-java-2.0.8-1.9.osg33.el6)
-   [xrootd-hdfs-1.8.6-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.8.6-1.osg33.el6)
-   [xrootd-lcmaps-1.2.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.2.1-1.osg33.el6)

#### Enterprise Linux 7

-   [emi-trustmanager-3.0.3-10.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-3.0.3-10.osg33.el7)
-   [emi-trustmanager-tomcat-3.0.0-14.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-tomcat-3.0.0-14.osg33.el7)
-   [glideinwms-3.2.12.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.12.1-1.osg33.el7)
-   [gsi-openssh-5.7-4.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gsi-openssh-5.7-4.1.osg33.el7)
-   [hadoop-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7)
-   [htcondor-ce-2.0.0-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.0-2.osg33.el7)
-   [igtf-ca-certs-1.71-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.71-1.osg33.el7)
-   [jglobus-2.1.0-7.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=jglobus-2.1.0-7.osg33.el7)
-   [lcmaps-plugins-scas-client-0.5.6-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=lcmaps-plugins-scas-client-0.5.6-1.osg33.el7)
-   [osg-ca-certs-1.52-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.52-1.osg33.el7)
-   [osg-ca-generator-1.0.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-generator-1.0.2-1.osg33.el7)
-   [osg-test-1.5.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.5.1-1.osg33.el7)
-   [osg-version-3.3.9-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.9-1.osg33.el7)
-   [rsv-perfsonar-1.1.2-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-perfsonar-1.1.2-3.osg33.el7)
-   [vo-client-63-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-63-1.osg33.el7)
-   [voms-api-java-2.0.8-1.9.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-api-java-2.0.8-1.9.osg33.el7)
-   [xrootd-lcmaps-1.2.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.2.1-1.osg33.el7)
-   [zookeeper-3.4.3+15-1.cdh4.0.1.p0.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=zookeeper-3.4.3+15-1.cdh4.0.1.p0.3.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    emi-trustmanager emi-trustmanager-tomcat glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server hadoop hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-fuse-selinux hadoop-hdfs-journalnode hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-libhdfs hadoop-mapreduce hadoop-yarn htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-debuginfo htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view igtf-ca-certs jglobus lcmaps-plugins-scas-client lcmaps-plugins-scas-client-debuginfo osg-ca-certs osg-ca-generator osg-gums-config osg-test osg-version rsv-perfsonar vo-client vo-client-edgmkgridmap voms-admin-server voms-api-java voms-api-java-javadoc xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
emi-trustmanager-3.0.3-10.osg33.el6
emi-trustmanager-tomcat-3.0.0-14.osg33.el6
glideinwms-3.2.12.1-1.osg33.el6
glideinwms-common-tools-3.2.12.1-1.osg33.el6
glideinwms-condor-common-config-3.2.12.1-1.osg33.el6
glideinwms-factory-3.2.12.1-1.osg33.el6
glideinwms-factory-condor-3.2.12.1-1.osg33.el6
glideinwms-glidecondor-tools-3.2.12.1-1.osg33.el6
glideinwms-libs-3.2.12.1-1.osg33.el6
glideinwms-minimal-condor-3.2.12.1-1.osg33.el6
glideinwms-usercollector-3.2.12.1-1.osg33.el6
glideinwms-userschedd-3.2.12.1-1.osg33.el6
glideinwms-vofrontend-3.2.12.1-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.12.1-1.osg33.el6
gsi-openssh-5.7-4.1.osg33.el6
gsi-openssh-clients-5.7-4.1.osg33.el6
gsi-openssh-debuginfo-5.7-4.1.osg33.el6
gsi-openssh-server-5.7-4.1.osg33.el6
hadoop-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-client-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-conf-pseudo-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-debuginfo-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-doc-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-hdfs-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-hdfs-datanode-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-hdfs-fuse-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-hdfs-fuse-selinux-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-hdfs-journalnode-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-hdfs-namenode-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-hdfs-secondarynamenode-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-hdfs-zkfc-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-httpfs-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-libhdfs-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-mapreduce-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
hadoop-yarn-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el6
htcondor-ce-2.0.0-2.osg33.el6
htcondor-ce-client-2.0.0-2.osg33.el6
htcondor-ce-collector-2.0.0-2.osg33.el6
htcondor-ce-condor-2.0.0-2.osg33.el6
htcondor-ce-debuginfo-2.0.0-2.osg33.el6
htcondor-ce-lsf-2.0.0-2.osg33.el6
htcondor-ce-pbs-2.0.0-2.osg33.el6
htcondor-ce-sge-2.0.0-2.osg33.el6
htcondor-ce-view-2.0.0-2.osg33.el6
igtf-ca-certs-1.71-1.osg33.el6
jglobus-2.1.0-7.osg33.el6
lcmaps-plugins-scas-client-0.5.6-1.osg33.el6
lcmaps-plugins-scas-client-debuginfo-0.5.6-1.osg33.el6
osg-ca-certs-1.52-1.osg33.el6
osg-ca-generator-1.0.2-1.osg33.el6
osg-gums-config-63-1.osg33.el6
osg-test-1.5.1-1.osg33.el6
osg-version-3.3.9-1.osg33.el6
rsv-perfsonar-1.1.2-3.osg33.el6
vo-client-63-1.osg33.el6
vo-client-edgmkgridmap-63-1.osg33.el6
voms-admin-server-2.7.0-1.21.osg33.el6
voms-api-java-2.0.8-1.9.osg33.el6
voms-api-java-javadoc-2.0.8-1.9.osg33.el6
xrootd-hdfs-1.8.6-1.osg33.el6
xrootd-hdfs-debuginfo-1.8.6-1.osg33.el6
xrootd-hdfs-devel-1.8.6-1.osg33.el6
xrootd-lcmaps-1.2.1-1.osg33.el6
xrootd-lcmaps-debuginfo-1.2.1-1.osg33.el6
```

#### Enterprise Linux 7

``` file
emi-trustmanager-3.0.3-10.osg33.el7
emi-trustmanager-tomcat-3.0.0-14.osg33.el7
glideinwms-3.2.12.1-1.osg33.el7
glideinwms-common-tools-3.2.12.1-1.osg33.el7
glideinwms-condor-common-config-3.2.12.1-1.osg33.el7
glideinwms-factory-3.2.12.1-1.osg33.el7
glideinwms-factory-condor-3.2.12.1-1.osg33.el7
glideinwms-glidecondor-tools-3.2.12.1-1.osg33.el7
glideinwms-libs-3.2.12.1-1.osg33.el7
glideinwms-minimal-condor-3.2.12.1-1.osg33.el7
glideinwms-usercollector-3.2.12.1-1.osg33.el7
glideinwms-userschedd-3.2.12.1-1.osg33.el7
glideinwms-vofrontend-3.2.12.1-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.12.1-1.osg33.el7
gsi-openssh-5.7-4.1.osg33.el7
gsi-openssh-clients-5.7-4.1.osg33.el7
gsi-openssh-debuginfo-5.7-4.1.osg33.el7
gsi-openssh-server-5.7-4.1.osg33.el7
hadoop-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-client-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-conf-pseudo-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-debuginfo-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-doc-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-hdfs-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-hdfs-datanode-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-hdfs-fuse-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-hdfs-fuse-selinux-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-hdfs-journalnode-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-hdfs-namenode-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-hdfs-secondarynamenode-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-hdfs-zkfc-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-httpfs-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-libhdfs-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-mapreduce-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
hadoop-yarn-2.0.0+545-1.cdh4.1.1.p0.22.osg33.el7
htcondor-ce-2.0.0-2.osg33.el7
htcondor-ce-client-2.0.0-2.osg33.el7
htcondor-ce-collector-2.0.0-2.osg33.el7
htcondor-ce-condor-2.0.0-2.osg33.el7
htcondor-ce-debuginfo-2.0.0-2.osg33.el7
htcondor-ce-lsf-2.0.0-2.osg33.el7
htcondor-ce-pbs-2.0.0-2.osg33.el7
htcondor-ce-sge-2.0.0-2.osg33.el7
htcondor-ce-view-2.0.0-2.osg33.el7
igtf-ca-certs-1.71-1.osg33.el7
jglobus-2.1.0-7.osg33.el7
lcmaps-plugins-scas-client-0.5.6-1.osg33.el7
lcmaps-plugins-scas-client-debuginfo-0.5.6-1.osg33.el7
osg-ca-certs-1.52-1.osg33.el7
osg-ca-generator-1.0.2-1.osg33.el7
osg-gums-config-63-1.osg33.el7
osg-test-1.5.1-1.osg33.el7
osg-version-3.3.9-1.osg33.el7
rsv-perfsonar-1.1.2-3.osg33.el7
vo-client-63-1.osg33.el7
vo-client-edgmkgridmap-63-1.osg33.el7
voms-api-java-2.0.8-1.9.osg33.el7
voms-api-java-javadoc-2.0.8-1.9.osg33.el7
xrootd-lcmaps-1.2.1-1.osg33.el7
xrootd-lcmaps-debuginfo-1.2.1-1.osg33.el7
zookeeper-3.4.3+15-1.cdh4.0.1.p0.3.osg33.el7
zookeeper-server-3.4.3+15-1.cdh4.0.1.p0.3.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [cvmfs-2.2.0-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.2.0-1.osgup.el6)
-   [cvmfs-config-osg-1.2-2.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-2.osgup.el6)
-   [htcondor-ce-2.0.0-2.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.0-2.osgup.el6)
-   [osg-oasis-6-2.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-6-2.osgup.el6)

#### Enterprise Linux 7

-   [cvmfs-2.2.0-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.2.0-1.osgup.el7)
-   [cvmfs-config-osg-1.2-2.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-2.osgup.el7)
-   [htcondor-ce-2.0.0-2.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.0-2.osgup.el7)
-   [osg-oasis-6-2.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-6-2.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cvmfs cvmfs-config-osg cvmfs-devel cvmfs-server cvmfs-unittests htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-debuginfo htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view osg-oasis

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
cvmfs-2.2.0-1.osgup.el6
cvmfs-config-osg-1.2-2.osgup.el6
cvmfs-devel-2.2.0-1.osgup.el6
cvmfs-server-2.2.0-1.osgup.el6
cvmfs-unittests-2.2.0-1.osgup.el6
htcondor-ce-2.0.0-2.osgup.el6
htcondor-ce-client-2.0.0-2.osgup.el6
htcondor-ce-collector-2.0.0-2.osgup.el6
htcondor-ce-condor-2.0.0-2.osgup.el6
htcondor-ce-debuginfo-2.0.0-2.osgup.el6
htcondor-ce-lsf-2.0.0-2.osgup.el6
htcondor-ce-pbs-2.0.0-2.osgup.el6
htcondor-ce-sge-2.0.0-2.osgup.el6
htcondor-ce-view-2.0.0-2.osgup.el6
osg-oasis-6-2.osgup.el6
```

#### Enterprise Linux 7

``` file
cvmfs-2.2.0-1.osgup.el7
cvmfs-config-osg-1.2-2.osgup.el7
cvmfs-devel-2.2.0-1.osgup.el7
cvmfs-server-2.2.0-1.osgup.el7
cvmfs-unittests-2.2.0-1.osgup.el7
htcondor-ce-2.0.0-2.osgup.el7
htcondor-ce-client-2.0.0-2.osgup.el7
htcondor-ce-collector-2.0.0-2.osgup.el7
htcondor-ce-condor-2.0.0-2.osgup.el7
htcondor-ce-debuginfo-2.0.0-2.osgup.el7
htcondor-ce-lsf-2.0.0-2.osgup.el7
htcondor-ce-pbs-2.0.0-2.osgup.el7
htcondor-ce-sge-2.0.0-2.osgup.el7
htcondor-ce-view-2.0.0-2.osgup.el7
osg-oasis-6-2.osgup.el7
```

