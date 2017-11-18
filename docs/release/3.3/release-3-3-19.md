OSG Software Release 3.3.19
===========================

**Release Date**: 2016-12-13

Summary of changes
------------------

This release contains:

-   HTCondor-CE 2.1.1
    -   Update HTCondor-CE to provide data needed by the ATLAS AGIS system
    -   Provide better hold messages when the Job Router does not route a job
-   Augment osg-configure 1.5.2 to process "Resource Entry" sections needed to provide data to AGIS
    -   handle double quotes in batch system configuration input
-   Provide a way for Gratia to avoid reporting local, non-OSG jobs records
    -   See known issues section below for configuration information
-   Systemd service files
    -   RSV
    -   Globus gridFTP server
-   Remove inaccurate comments from wn-client/setup.sh
-   osg-vo-map: Put the correct month in log timestamps
-   tmpfiles.d configuration for hadoop packages
-   Check folder ownership of /var/run/myproxy
-   Update to frontier-squid 3 in the Upcoming repository
    -   See the [upgrading section of the upstream documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Upgrading) for the system administrators view of the changes

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.19%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   The previous version (`1.17.0-2.5`) of the Gratia probes required changes in the HTCondor configuration to operate properly. Now, these changes need to be reverted to use this version (`1.17.0-2.6`) of the probes. The lines below are likely to be found in `condor_config.local` or a new file in `/etc/condor/config.d` directory. Delete these lines and run `condor_reconfig`.

``` file
# GlideinWMS Gratia commands
PER_JOB_HISTORY_DIR = /var/lib/gratia/data
JOBGLIDEIN_ResourceName="$$([IfThenElse(IsUndefined(TARGET.GLIDEIN_ResourceName), IfThenElse(IsUndefined(TARGET.GLIDEIN_Site), IfThenElse(IsUndefined(TARGET.FileSystemDomain), \"Local Job\", TARGET.FileSystemDomain), TARGET.GLIDEIN_Site), TARGET.GLIDEIN_ResourceName)])"
SUBMIT_EXPRS = $(SUBMIT_EXPRS) JOBGLIDEIN_ResourceName   
```

-   On EL7, your version of voms-proxy-init may come from the voms-clients-java package; this version will continue to make legacy proxies by default. If you want the new behavior, install the voms-clients-cpp package and uninstall the voms-clients-java package.

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

-   [globus-gridftp-server-10.4-1.5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-10.4-1.5.osg33.el6)
-   [gratia-probe-1.17.0-2.6.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.0-2.6.osg33.el6)
-   [hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6)
-   [htcondor-ce-2.1.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.1.1-1.osg33.el6)
-   [myproxy-6.1.18-1.4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=myproxy-6.1.18-1.4.osg33.el6)
-   [osg-configure-1.5.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.5.3-1.osg33.el6)
-   [osg-version-3.3.19-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.19-1.osg33.el6)
-   [osg-vo-map-0.0.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-vo-map-0.0.2-1.osg33.el6)
-   [osg-wn-client-3.3-6.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-wn-client-3.3-6.osg33.el6)
-   [rsv-3.14.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.14.0-1.osg33.el6)

#### Enterprise Linux 7

-   [globus-gridftp-server-10.4-1.5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-10.4-1.5.osg33.el7)
-   [gratia-probe-1.17.0-2.6.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.0-2.6.osg33.el7)
-   [hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7)
-   [htcondor-ce-2.1.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.1.1-1.osg33.el7)
-   [myproxy-6.1.18-1.4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=myproxy-6.1.18-1.4.osg33.el7)
-   [osg-configure-1.5.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.5.3-1.osg33.el7)
-   [osg-version-3.3.19-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.19-1.osg33.el7)
-   [osg-vo-map-0.0.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-vo-map-0.0.2-1.osg33.el7)
-   [osg-wn-client-3.3-6.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-wn-client-3.3-6.osg33.el7)
-   [rsv-3.14.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.14.0-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-p
    robe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-pr
    obe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage g
    ratia-probe-xrootd-transfer hadoop hadoop-0.20-conf-pseudo hadoop-0.20-mapreduce hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-fuse-selinux hadoop-hdfs-journalno
    de hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-libhdfs hadoop-mapreduce hadoop-yarn htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htc
    ondor-ce-pbs htcondor-ce-sge htcondor-ce-view myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-
    condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv
     osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-version osg-vo-map osg-wn-client osg-wn-client-glexec rsv rsv-consumers rsv-core rsv-metrics

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
globus-gridftp-server-10.4-1.5.osg33.el6
globus-gridftp-server-debuginfo-10.4-1.5.osg33.el6
globus-gridftp-server-devel-10.4-1.5.osg33.el6
globus-gridftp-server-progs-10.4-1.5.osg33.el6
gratia-probe-1.17.0-2.6.osg33.el6
gratia-probe-bdii-status-1.17.0-2.6.osg33.el6
gratia-probe-common-1.17.0-2.6.osg33.el6
gratia-probe-condor-1.17.0-2.6.osg33.el6
gratia-probe-condor-events-1.17.0-2.6.osg33.el6
gratia-probe-dcache-storage-1.17.0-2.6.osg33.el6
gratia-probe-dcache-storagegroup-1.17.0-2.6.osg33.el6
gratia-probe-dcache-transfer-1.17.0-2.6.osg33.el6
gratia-probe-debuginfo-1.17.0-2.6.osg33.el6
gratia-probe-enstore-storage-1.17.0-2.6.osg33.el6
gratia-probe-enstore-tapedrive-1.17.0-2.6.osg33.el6
gratia-probe-enstore-transfer-1.17.0-2.6.osg33.el6
gratia-probe-glexec-1.17.0-2.6.osg33.el6
gratia-probe-glideinwms-1.17.0-2.6.osg33.el6
gratia-probe-gram-1.17.0-2.6.osg33.el6
gratia-probe-gridftp-transfer-1.17.0-2.6.osg33.el6
gratia-probe-hadoop-storage-1.17.0-2.6.osg33.el6
gratia-probe-htcondor-ce-1.17.0-2.6.osg33.el6
gratia-probe-lsf-1.17.0-2.6.osg33.el6
gratia-probe-metric-1.17.0-2.6.osg33.el6
gratia-probe-onevm-1.17.0-2.6.osg33.el6
gratia-probe-pbs-lsf-1.17.0-2.6.osg33.el6
gratia-probe-services-1.17.0-2.6.osg33.el6
gratia-probe-sge-1.17.0-2.6.osg33.el6
gratia-probe-slurm-1.17.0-2.6.osg33.el6
gratia-probe-xrootd-storage-1.17.0-2.6.osg33.el6
gratia-probe-xrootd-transfer-1.17.0-2.6.osg33.el6
hadoop-0.20-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-0.20-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-client-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-debuginfo-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-doc-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-hdfs-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-hdfs-datanode-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-hdfs-fuse-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-hdfs-fuse-selinux-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-hdfs-journalnode-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-hdfs-namenode-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-hdfs-secondarynamenode-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-hdfs-zkfc-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-httpfs-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-libhdfs-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
hadoop-yarn-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el6
htcondor-ce-2.1.1-1.osg33.el6
htcondor-ce-bosco-2.1.1-1.osg33.el6
htcondor-ce-client-2.1.1-1.osg33.el6
htcondor-ce-collector-2.1.1-1.osg33.el6
htcondor-ce-condor-2.1.1-1.osg33.el6
htcondor-ce-lsf-2.1.1-1.osg33.el6
htcondor-ce-pbs-2.1.1-1.osg33.el6
htcondor-ce-sge-2.1.1-1.osg33.el6
htcondor-ce-view-2.1.1-1.osg33.el6
myproxy-6.1.18-1.4.osg33.el6
myproxy-admin-6.1.18-1.4.osg33.el6
myproxy-debuginfo-6.1.18-1.4.osg33.el6
myproxy-devel-6.1.18-1.4.osg33.el6
myproxy-doc-6.1.18-1.4.osg33.el6
myproxy-libs-6.1.18-1.4.osg33.el6
myproxy-server-6.1.18-1.4.osg33.el6
myproxy-voms-6.1.18-1.4.osg33.el6
osg-configure-1.5.3-1.osg33.el6
osg-configure-bosco-1.5.3-1.osg33.el6
osg-configure-ce-1.5.3-1.osg33.el6
osg-configure-cemon-1.5.3-1.osg33.el6
osg-configure-condor-1.5.3-1.osg33.el6
osg-configure-gateway-1.5.3-1.osg33.el6
osg-configure-gip-1.5.3-1.osg33.el6
osg-configure-gratia-1.5.3-1.osg33.el6
osg-configure-infoservices-1.5.3-1.osg33.el6
osg-configure-lsf-1.5.3-1.osg33.el6
osg-configure-managedfork-1.5.3-1.osg33.el6
osg-configure-misc-1.5.3-1.osg33.el6
osg-configure-monalisa-1.5.3-1.osg33.el6
osg-configure-network-1.5.3-1.osg33.el6
osg-configure-pbs-1.5.3-1.osg33.el6
osg-configure-rsv-1.5.3-1.osg33.el6
osg-configure-sge-1.5.3-1.osg33.el6
osg-configure-slurm-1.5.3-1.osg33.el6
osg-configure-squid-1.5.3-1.osg33.el6
osg-configure-tests-1.5.3-1.osg33.el6
osg-version-3.3.19-1.osg33.el6
osg-vo-map-0.0.2-1.osg33.el6
osg-wn-client-3.3-6.osg33.el6
osg-wn-client-glexec-3.3-6.osg33.el6
rsv-3.14.0-1.osg33.el6
rsv-consumers-3.14.0-1.osg33.el6
rsv-core-3.14.0-1.osg33.el6
rsv-metrics-3.14.0-1.osg33.el6
```

#### Enterprise Linux 7

``` file
globus-gridftp-server-10.4-1.5.osg33.el7
globus-gridftp-server-debuginfo-10.4-1.5.osg33.el7
globus-gridftp-server-devel-10.4-1.5.osg33.el7
globus-gridftp-server-progs-10.4-1.5.osg33.el7
gratia-probe-1.17.0-2.6.osg33.el7
gratia-probe-bdii-status-1.17.0-2.6.osg33.el7
gratia-probe-common-1.17.0-2.6.osg33.el7
gratia-probe-condor-1.17.0-2.6.osg33.el7
gratia-probe-condor-events-1.17.0-2.6.osg33.el7
gratia-probe-dcache-storage-1.17.0-2.6.osg33.el7
gratia-probe-dcache-storagegroup-1.17.0-2.6.osg33.el7
gratia-probe-dcache-transfer-1.17.0-2.6.osg33.el7
gratia-probe-debuginfo-1.17.0-2.6.osg33.el7
gratia-probe-enstore-storage-1.17.0-2.6.osg33.el7
gratia-probe-enstore-tapedrive-1.17.0-2.6.osg33.el7
gratia-probe-enstore-transfer-1.17.0-2.6.osg33.el7
gratia-probe-glexec-1.17.0-2.6.osg33.el7
gratia-probe-glideinwms-1.17.0-2.6.osg33.el7
gratia-probe-gram-1.17.0-2.6.osg33.el7
gratia-probe-gridftp-transfer-1.17.0-2.6.osg33.el7
gratia-probe-hadoop-storage-1.17.0-2.6.osg33.el7
gratia-probe-htcondor-ce-1.17.0-2.6.osg33.el7
gratia-probe-lsf-1.17.0-2.6.osg33.el7
gratia-probe-metric-1.17.0-2.6.osg33.el7
gratia-probe-onevm-1.17.0-2.6.osg33.el7
gratia-probe-pbs-lsf-1.17.0-2.6.osg33.el7
gratia-probe-services-1.17.0-2.6.osg33.el7
gratia-probe-sge-1.17.0-2.6.osg33.el7
gratia-probe-slurm-1.17.0-2.6.osg33.el7
gratia-probe-xrootd-storage-1.17.0-2.6.osg33.el7
gratia-probe-xrootd-transfer-1.17.0-2.6.osg33.el7
hadoop-0.20-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-0.20-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-client-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-debuginfo-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-doc-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-hdfs-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-hdfs-datanode-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-hdfs-fuse-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-hdfs-fuse-selinux-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-hdfs-journalnode-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-hdfs-namenode-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-hdfs-secondarynamenode-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-hdfs-zkfc-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-httpfs-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-libhdfs-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
hadoop-yarn-2.0.0+1612-1.cdh4.7.1.p0.12.5.osg33.el7
htcondor-ce-2.1.1-1.osg33.el7
htcondor-ce-bosco-2.1.1-1.osg33.el7
htcondor-ce-client-2.1.1-1.osg33.el7
htcondor-ce-collector-2.1.1-1.osg33.el7
htcondor-ce-condor-2.1.1-1.osg33.el7
htcondor-ce-lsf-2.1.1-1.osg33.el7
htcondor-ce-pbs-2.1.1-1.osg33.el7
htcondor-ce-sge-2.1.1-1.osg33.el7
htcondor-ce-view-2.1.1-1.osg33.el7
myproxy-6.1.18-1.4.osg33.el7
myproxy-admin-6.1.18-1.4.osg33.el7
myproxy-debuginfo-6.1.18-1.4.osg33.el7
myproxy-devel-6.1.18-1.4.osg33.el7
myproxy-doc-6.1.18-1.4.osg33.el7
myproxy-libs-6.1.18-1.4.osg33.el7
myproxy-server-6.1.18-1.4.osg33.el7
myproxy-voms-6.1.18-1.4.osg33.el7
osg-configure-1.5.3-1.osg33.el7
osg-configure-bosco-1.5.3-1.osg33.el7
osg-configure-ce-1.5.3-1.osg33.el7
osg-configure-cemon-1.5.3-1.osg33.el7
osg-configure-condor-1.5.3-1.osg33.el7
osg-configure-gateway-1.5.3-1.osg33.el7
osg-configure-gip-1.5.3-1.osg33.el7
osg-configure-gratia-1.5.3-1.osg33.el7
osg-configure-infoservices-1.5.3-1.osg33.el7
osg-configure-lsf-1.5.3-1.osg33.el7
osg-configure-managedfork-1.5.3-1.osg33.el7
osg-configure-misc-1.5.3-1.osg33.el7
osg-configure-monalisa-1.5.3-1.osg33.el7
osg-configure-network-1.5.3-1.osg33.el7
osg-configure-pbs-1.5.3-1.osg33.el7
osg-configure-rsv-1.5.3-1.osg33.el7
osg-configure-sge-1.5.3-1.osg33.el7
osg-configure-slurm-1.5.3-1.osg33.el7
osg-configure-squid-1.5.3-1.osg33.el7
osg-configure-tests-1.5.3-1.osg33.el7
osg-version-3.3.19-1.osg33.el7
osg-vo-map-0.0.2-1.osg33.el7
osg-wn-client-3.3-6.osg33.el7
osg-wn-client-glexec-3.3-6.osg33.el7
rsv-3.14.0-1.osg33.el7
rsv-consumers-3.14.0-1.osg33.el7
rsv-core-3.14.0-1.osg33.el7
rsv-metrics-3.14.0-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [frontier-squid-3.5.22-2.1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=frontier-squid-3.5.22-2.1.osgup.el6)

#### Enterprise Linux 7

-   [frontier-squid-3.5.22-2.1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=frontier-squid-3.5.22-2.1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid frontier-squid-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
frontier-squid-3.5.22-2.1.osgup.el6
frontier-squid-debuginfo-3.5.22-2.1.osgup.el6
```

#### Enterprise Linux 7

``` file
frontier-squid-3.5.22-2.1.osgup.el7
frontier-squid-debuginfo-3.5.22-2.1.osgup.el7
```

