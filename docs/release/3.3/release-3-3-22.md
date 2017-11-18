OSG Software Release 3.3.22
===========================

**Release Date**: 2017-03-14

Summary of changes
------------------

This release contains:

-   OSG 3.3.22
    -   HTCondor 8.4.11: Backport fix to avoid crash in the Job Router when job transform or submit requirements fail. ([SOFTWARE-2615](https://jira.opensciencegrid.org/browse/SOFTWARE-2615))
    -   Update default emi-trustmanager configuration to have GUMS use proper TLS protocols when contacting VOMS admin. ([SOFTWARE-2523](https://jira.opensciencegrid.org/browse/SOFTWARE-2523))
    -   BLAHP 1.18.29: Better Slurm integration, fixed problem with proxy refresh
    -   [HTCondor-CE 2.1.4](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.1.4): Respect `RequestCpus`, Added JSON attibutes for AGIS (This OSG release contains changes from [HTCondor-CE 2.1.3](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.1.3) for the first time)
    -   Gratia probe 1.17.4: Now picks up `RequestCpus` with HTCondor-CE
    -   Update to [CVMFS 2.3.3](http://cvmfs.readthedocs.io/en/2.3/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-3-3)
    -   Update to [GlideinWMS 3.2.18](http://glideinwms.fnal.gov/doc.v3_2_18/history.html)
    -   <strike>Update to [XRootD 4.6.0](https://github.com/xrootd/xrootd/blob/v4.6.0/docs/ReleaseNotes.txt)</strike>
    -   HDFS: GridFTP prints proper error message when HDFS quota is exhausted
    -   VOMS 2.0.14-1.3: Now validates top-level group of proxy
-   Upcoming repository
    -   [HTCondor 8.6.1](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00005.shtml): New stable series of HTCondor in Upcoming (This OSG release contains changes from [HTCondor-8.6.0](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00001.shtml) for the first time)
    -   Update to [frontier-squid 3.5.24-1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.22%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   %RED%On Friday, March 17th, [XRootD 4.6.0](https://github.com/xrootd/xrootd/blob/v4.6.0/docs/ReleaseNotes.txt) was pulled from the release repository. %ENDCOLOR%Most of the issues origin from improper CRL verification bug introduced in the recent code. Criticality of the issue:
    -   high criticality running XRootD in a **server** mode you may have issues since reading the final file usually does require authentication (mostly GSI auth which relates to CRL verification code)
    -   low criticality running XRootD in a **manager** mode you may NOT experience any issues assuming your redirector does not require authentication
    -   to check if you have the affected components installed, run <pre class="rootscreen">root@host # rpm -qa | grep xrootd</pre> to display the versions of your xrootd packages. If any of them are version 4.6.0, run <pre class="rootscreen">root@host # yum downgrade <package></pre> on those packages.
    -   as pre-caution to avoid this bug [XRootD 4.6.0](https://github.com/xrootd/xrootd/blob/v4.6.0/docs/ReleaseNotes.txt) was pulled from the release repository and we do not recommend using it until further notice
    -   given the number of recent improvements and fixes 4.6.1 is available in EPEL testing repo and once it gets to production release we push it into OSG release as well
-   The Koji client config has changed in the new version of Koji: \`pkgurl`` http://koji.chtc.wisc.edu/packages` has been replaced by `topurl=http://koji.chtc.wisc.edu` and the Koji client will give a harmless but annoying warning when it finds `pkgurl`. To get rid of the warning, update to osg-build > `` 1.8.0, rerun \`osg-koji setup\`, and say 'yes' when asked to replace the Koji configuration file; or, you may make the above change manually.
-   A previous version (`1.17.0-2.5`) of the Gratia probes required changes in the HTCondor configuration to operate properly. Now, these changes need to be reverted to use verison `1.17.0-2.6` and later of the probes. The lines below are likely to be found in `condor_config.local` or a new file in `/etc/condor/config.d` directory. Delete these lines and run `condor_reconfig`.

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

-   [blahp-1.18.29.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.29.bosco-1.osg33.el6)
-   [condor-8.4.11-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.11-1.1.osg33.el6)
-   [cvmfs-2.3.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.3.3-1.osg33.el6)
-   [cvmfs-config-osg-2.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.0-1.osg33.el6)
-   [emi-trustmanager-3.0.3-14.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-3.0.3-14.osg33.el6)
-   [glideinwms-3.2.18-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.18-1.osg33.el6)
-   [gratia-probe-1.17.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.4-1.osg33.el6)
-   [hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6)
-   [htcondor-ce-2.1.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.1.4-1.osg33.el6)
-   [osg-oasis-7-7.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-7-7.osg33.el6)
-   [osg-version-3.3.22-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.22-1.osg33.el6)
-   [voms-2.0.14-1.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-2.0.14-1.3.osg33.el6)
-   <strike> [xrootd-4.6.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.6.0-1.osg33.el6)</strike>

#### Enterprise Linux 7

-   [blahp-1.18.29.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.29.bosco-1.osg33.el7)
-   [condor-8.4.11-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.11-1.1.osg33.el7)
-   [cvmfs-2.3.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.3.3-1.osg33.el7)
-   [cvmfs-config-osg-2.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.0-1.osg33.el7)
-   [emi-trustmanager-3.0.3-14.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-3.0.3-14.osg33.el7)
-   [glideinwms-3.2.18-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.18-1.osg33.el7)
-   [gratia-probe-1.17.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.4-1.osg33.el7)
-   [hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7)
-   [htcondor-ce-2.1.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.1.4-1.osg33.el7)
-   [osg-oasis-7-7.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-7-7.osg33.el7)
-   [osg-version-3.3.22-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.22-1.osg33.el7)
-   [voms-2.0.14-1.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-2.0.14-1.3.osg33.el7)
-   <strike>[xrootd-4.6.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.6.0-1.osg33.el7)</strike>

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-config-osg cvmfs-devel cvmfs-server cvmfs-unittests emi-trustmanager glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer hadoop hadoop-0.20-conf-pseudo hadoop-0.20-mapreduce hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-fuse-selinux hadoop-hdfs-journalnode hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-libhdfs hadoop-mapreduce hadoop-yarn htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view igtf-ca-certs osg-ca-certs osg-gums-config osg-oasis osg-version vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server <strike>xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs</strike>

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.29.bosco-1.osg33.el6
blahp-debuginfo-1.18.29.bosco-1.osg33.el6
condor-8.4.11-1.1.osg33.el6
condor-all-8.4.11-1.1.osg33.el6
condor-bosco-8.4.11-1.1.osg33.el6
condor-classads-8.4.11-1.1.osg33.el6
condor-classads-devel-8.4.11-1.1.osg33.el6
condor-cream-gahp-8.4.11-1.1.osg33.el6
condor-debuginfo-8.4.11-1.1.osg33.el6
condor-kbdd-8.4.11-1.1.osg33.el6
condor-procd-8.4.11-1.1.osg33.el6
condor-python-8.4.11-1.1.osg33.el6
condor-std-universe-8.4.11-1.1.osg33.el6
condor-test-8.4.11-1.1.osg33.el6
condor-vm-gahp-8.4.11-1.1.osg33.el6
cvmfs-2.3.3-1.osg33.el6
cvmfs-config-osg-2.0-1.osg33.el6
cvmfs-devel-2.3.3-1.osg33.el6
cvmfs-server-2.3.3-1.osg33.el6
cvmfs-unittests-2.3.3-1.osg33.el6
emi-trustmanager-3.0.3-14.osg33.el6
glideinwms-3.2.18-1.osg33.el6
glideinwms-common-tools-3.2.18-1.osg33.el6
glideinwms-condor-common-config-3.2.18-1.osg33.el6
glideinwms-factory-3.2.18-1.osg33.el6
glideinwms-factory-condor-3.2.18-1.osg33.el6
glideinwms-glidecondor-tools-3.2.18-1.osg33.el6
glideinwms-libs-3.2.18-1.osg33.el6
glideinwms-minimal-condor-3.2.18-1.osg33.el6
glideinwms-usercollector-3.2.18-1.osg33.el6
glideinwms-userschedd-3.2.18-1.osg33.el6
glideinwms-vofrontend-3.2.18-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.18-1.osg33.el6
gratia-probe-1.17.4-1.osg33.el6
gratia-probe-bdii-status-1.17.4-1.osg33.el6
gratia-probe-common-1.17.4-1.osg33.el6
gratia-probe-condor-1.17.4-1.osg33.el6
gratia-probe-condor-events-1.17.4-1.osg33.el6
gratia-probe-dcache-storage-1.17.4-1.osg33.el6
gratia-probe-dcache-storagegroup-1.17.4-1.osg33.el6
gratia-probe-dcache-transfer-1.17.4-1.osg33.el6
gratia-probe-debuginfo-1.17.4-1.osg33.el6
gratia-probe-enstore-storage-1.17.4-1.osg33.el6
gratia-probe-enstore-tapedrive-1.17.4-1.osg33.el6
gratia-probe-enstore-transfer-1.17.4-1.osg33.el6
gratia-probe-glexec-1.17.4-1.osg33.el6
gratia-probe-glideinwms-1.17.4-1.osg33.el6
gratia-probe-gram-1.17.4-1.osg33.el6
gratia-probe-gridftp-transfer-1.17.4-1.osg33.el6
gratia-probe-hadoop-storage-1.17.4-1.osg33.el6
gratia-probe-htcondor-ce-1.17.4-1.osg33.el6
gratia-probe-lsf-1.17.4-1.osg33.el6
gratia-probe-metric-1.17.4-1.osg33.el6
gratia-probe-onevm-1.17.4-1.osg33.el6
gratia-probe-pbs-lsf-1.17.4-1.osg33.el6
gratia-probe-services-1.17.4-1.osg33.el6
gratia-probe-sge-1.17.4-1.osg33.el6
gratia-probe-slurm-1.17.4-1.osg33.el6
gratia-probe-xrootd-storage-1.17.4-1.osg33.el6
gratia-probe-xrootd-transfer-1.17.4-1.osg33.el6
hadoop-0.20-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-0.20-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-client-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-debuginfo-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-doc-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-hdfs-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-hdfs-datanode-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-hdfs-fuse-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-hdfs-fuse-selinux-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-hdfs-journalnode-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-hdfs-namenode-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-hdfs-secondarynamenode-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-hdfs-zkfc-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-httpfs-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-libhdfs-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
hadoop-yarn-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el6
htcondor-ce-2.1.4-1.osg33.el6
htcondor-ce-bosco-2.1.4-1.osg33.el6
htcondor-ce-client-2.1.4-1.osg33.el6
htcondor-ce-collector-2.1.4-1.osg33.el6
htcondor-ce-condor-2.1.4-1.osg33.el6
htcondor-ce-lsf-2.1.4-1.osg33.el6
htcondor-ce-pbs-2.1.4-1.osg33.el6
htcondor-ce-sge-2.1.4-1.osg33.el6
htcondor-ce-view-2.1.4-1.osg33.el6
osg-oasis-7-7.osg33.el6
osg-version-3.3.22-1.osg33.el6
voms-2.0.14-1.3.osg33.el6
voms-clients-cpp-2.0.14-1.3.osg33.el6
voms-debuginfo-2.0.14-1.3.osg33.el6
voms-devel-2.0.14-1.3.osg33.el6
voms-doc-2.0.14-1.3.osg33.el6
voms-server-2.0.14-1.3.osg33.el6
<strike>xrootd-4.6.0-1.osg33.el6
xrootd-client-4.6.0-1.osg33.el6
xrootd-client-devel-4.6.0-1.osg33.el6
xrootd-client-libs-4.6.0-1.osg33.el6
xrootd-debuginfo-4.6.0-1.osg33.el6
xrootd-devel-4.6.0-1.osg33.el6
xrootd-doc-4.6.0-1.osg33.el6
xrootd-fuse-4.6.0-1.osg33.el6
xrootd-libs-4.6.0-1.osg33.el6
xrootd-private-devel-4.6.0-1.osg33.el6
xrootd-python-4.6.0-1.osg33.el6
xrootd-selinux-4.6.0-1.osg33.el6
xrootd-server-4.6.0-1.osg33.el6
xrootd-server-devel-4.6.0-1.osg33.el6
xrootd-server-libs-4.6.0-1.osg33.el6</strike>
```

#### Enterprise Linux 7

``` file
blahp-1.18.29.bosco-1.osg33.el7
blahp-debuginfo-1.18.29.bosco-1.osg33.el7
condor-8.4.11-1.1.osg33.el7
condor-all-8.4.11-1.1.osg33.el7
condor-bosco-8.4.11-1.1.osg33.el7
condor-classads-8.4.11-1.1.osg33.el7
condor-classads-devel-8.4.11-1.1.osg33.el7
condor-cream-gahp-8.4.11-1.1.osg33.el7
condor-debuginfo-8.4.11-1.1.osg33.el7
condor-kbdd-8.4.11-1.1.osg33.el7
condor-procd-8.4.11-1.1.osg33.el7
condor-python-8.4.11-1.1.osg33.el7
condor-test-8.4.11-1.1.osg33.el7
condor-vm-gahp-8.4.11-1.1.osg33.el7
cvmfs-2.3.3-1.osg33.el7
cvmfs-config-osg-2.0-1.osg33.el7
cvmfs-devel-2.3.3-1.osg33.el7
cvmfs-server-2.3.3-1.osg33.el7
cvmfs-unittests-2.3.3-1.osg33.el7
emi-trustmanager-3.0.3-14.osg33.el7
glideinwms-3.2.18-1.osg33.el7
glideinwms-common-tools-3.2.18-1.osg33.el7
glideinwms-condor-common-config-3.2.18-1.osg33.el7
glideinwms-factory-3.2.18-1.osg33.el7
glideinwms-factory-condor-3.2.18-1.osg33.el7
glideinwms-glidecondor-tools-3.2.18-1.osg33.el7
glideinwms-libs-3.2.18-1.osg33.el7
glideinwms-minimal-condor-3.2.18-1.osg33.el7
glideinwms-usercollector-3.2.18-1.osg33.el7
glideinwms-userschedd-3.2.18-1.osg33.el7
glideinwms-vofrontend-3.2.18-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.18-1.osg33.el7
gratia-probe-1.17.4-1.osg33.el7
gratia-probe-bdii-status-1.17.4-1.osg33.el7
gratia-probe-common-1.17.4-1.osg33.el7
gratia-probe-condor-1.17.4-1.osg33.el7
gratia-probe-condor-events-1.17.4-1.osg33.el7
gratia-probe-dcache-storage-1.17.4-1.osg33.el7
gratia-probe-dcache-storagegroup-1.17.4-1.osg33.el7
gratia-probe-dcache-transfer-1.17.4-1.osg33.el7
gratia-probe-debuginfo-1.17.4-1.osg33.el7
gratia-probe-enstore-storage-1.17.4-1.osg33.el7
gratia-probe-enstore-tapedrive-1.17.4-1.osg33.el7
gratia-probe-enstore-transfer-1.17.4-1.osg33.el7
gratia-probe-glexec-1.17.4-1.osg33.el7
gratia-probe-glideinwms-1.17.4-1.osg33.el7
gratia-probe-gram-1.17.4-1.osg33.el7
gratia-probe-gridftp-transfer-1.17.4-1.osg33.el7
gratia-probe-hadoop-storage-1.17.4-1.osg33.el7
gratia-probe-htcondor-ce-1.17.4-1.osg33.el7
gratia-probe-lsf-1.17.4-1.osg33.el7
gratia-probe-metric-1.17.4-1.osg33.el7
gratia-probe-onevm-1.17.4-1.osg33.el7
gratia-probe-pbs-lsf-1.17.4-1.osg33.el7
gratia-probe-services-1.17.4-1.osg33.el7
gratia-probe-sge-1.17.4-1.osg33.el7
gratia-probe-slurm-1.17.4-1.osg33.el7
gratia-probe-xrootd-storage-1.17.4-1.osg33.el7
gratia-probe-xrootd-transfer-1.17.4-1.osg33.el7
hadoop-0.20-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-0.20-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-client-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-conf-pseudo-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-debuginfo-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-doc-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-hdfs-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-hdfs-datanode-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-hdfs-fuse-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-hdfs-fuse-selinux-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-hdfs-journalnode-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-hdfs-namenode-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-hdfs-secondarynamenode-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-hdfs-zkfc-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-httpfs-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-libhdfs-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-mapreduce-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
hadoop-yarn-2.0.0+1612-1.cdh4.7.1.p0.12.6.osg33.el7
htcondor-ce-2.1.4-1.osg33.el7
htcondor-ce-bosco-2.1.4-1.osg33.el7
htcondor-ce-client-2.1.4-1.osg33.el7
htcondor-ce-collector-2.1.4-1.osg33.el7
htcondor-ce-condor-2.1.4-1.osg33.el7
htcondor-ce-lsf-2.1.4-1.osg33.el7
htcondor-ce-pbs-2.1.4-1.osg33.el7
htcondor-ce-sge-2.1.4-1.osg33.el7
htcondor-ce-view-2.1.4-1.osg33.el7
osg-oasis-7-7.osg33.el7
osg-version-3.3.22-1.osg33.el7
voms-2.0.14-1.3.osg33.el7
voms-clients-cpp-2.0.14-1.3.osg33.el7
voms-debuginfo-2.0.14-1.3.osg33.el7
voms-devel-2.0.14-1.3.osg33.el7
voms-doc-2.0.14-1.3.osg33.el7
voms-server-2.0.14-1.3.osg33.el7
<strike>xrootd-4.6.0-1.osg33.el7
xrootd-client-4.6.0-1.osg33.el7
xrootd-client-devel-4.6.0-1.osg33.el7
xrootd-client-libs-4.6.0-1.osg33.el7
xrootd-debuginfo-4.6.0-1.osg33.el7
xrootd-devel-4.6.0-1.osg33.el7
xrootd-doc-4.6.0-1.osg33.el7
xrootd-fuse-4.6.0-1.osg33.el7
xrootd-libs-4.6.0-1.osg33.el7
xrootd-private-devel-4.6.0-1.osg33.el7
xrootd-python-4.6.0-1.osg33.el7
xrootd-selinux-4.6.0-1.osg33.el7
xrootd-server-4.6.0-1.osg33.el7
xrootd-server-devel-4.6.0-1.osg33.el7
xrootd-server-libs-4.6.0-1.osg33.el7</strike>
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.29.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.29.bosco-1.osgup.el6)
-   [condor-8.6.1-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.6.1-1.osgup.el6)
-   [frontier-squid-3.5.24-1.1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=frontier-squid-3.5.24-1.1.osgup.el6)
-   [glite-ce-cream-client-api-c-1.15.4-2.3.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.3.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.29.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.29.bosco-1.osgup.el7)
-   [condor-8.6.1-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.6.1-1.osgup.el7)
-   [frontier-squid-3.5.24-1.1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=frontier-squid-3.5.24-1.1.osgup.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.3.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.3.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp frontier-squid frontier-squid-debuginfo glite-ce-cream-client-api-c glite-ce-cream-client-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.29.bosco-1.osgup.el6
blahp-debuginfo-1.18.29.bosco-1.osgup.el6
condor-8.6.1-1.osgup.el6
condor-all-8.6.1-1.osgup.el6
condor-bosco-8.6.1-1.osgup.el6
condor-classads-8.6.1-1.osgup.el6
condor-classads-devel-8.6.1-1.osgup.el6
condor-cream-gahp-8.6.1-1.osgup.el6
condor-debuginfo-8.6.1-1.osgup.el6
condor-kbdd-8.6.1-1.osgup.el6
condor-procd-8.6.1-1.osgup.el6
condor-python-8.6.1-1.osgup.el6
condor-std-universe-8.6.1-1.osgup.el6
condor-test-8.6.1-1.osgup.el6
condor-vm-gahp-8.6.1-1.osgup.el6
frontier-squid-3.5.24-1.1.osgup.el6
frontier-squid-debuginfo-3.5.24-1.1.osgup.el6
glite-ce-cream-client-api-c-1.15.4-2.3.osgup.el6
glite-ce-cream-client-devel-1.15.4-2.3.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.29.bosco-1.osgup.el7
blahp-debuginfo-1.18.29.bosco-1.osgup.el7
condor-8.6.1-1.osgup.el7
condor-all-8.6.1-1.osgup.el7
condor-bosco-8.6.1-1.osgup.el7
condor-classads-8.6.1-1.osgup.el7
condor-classads-devel-8.6.1-1.osgup.el7
condor-cream-gahp-8.6.1-1.osgup.el7
condor-debuginfo-8.6.1-1.osgup.el7
condor-kbdd-8.6.1-1.osgup.el7
condor-procd-8.6.1-1.osgup.el7
condor-python-8.6.1-1.osgup.el7
condor-test-8.6.1-1.osgup.el7
condor-vm-gahp-8.6.1-1.osgup.el7
frontier-squid-3.5.24-1.1.osgup.el7
frontier-squid-debuginfo-3.5.24-1.1.osgup.el7
glite-ce-cream-client-api-c-1.15.4-2.3.osgup.el7
glite-ce-cream-client-devel-1.15.4-2.3.osgup.el7
```

