OSG Software Release 3.3.20
===========================

**Release Date**: 2017-01-10

Summary of changes
------------------

This release contains:

-   OSG 3.3.20
    -   [HTCondor 8.4.10](https://www-auth.cs.wisc.edu/lists/htcondor-world/2016/msg00020.shtml): Running in SELinux should work now, other bug fixes
    -   gratia-probe 1.17.2: Improved ability to report local jobs to OSG or not
    -   Updated to [XRootD 4.5.0](https://github.com/xrootd/xrootd/blob/v4.5.0/docs/ReleaseNotes.txt)
    -   Updated gridftp-hdfs to enable ordered data
    -   osg-configure 1.5.4: Further updates to support ATLAS AGIS [SOFTWARE-2554](https://jira.opensciencegrid.org/browse/SOFTWARE-2554)
    -   Ensure HTCondor-CE gratia probe is installed when installing osg-ce-bosco
    -   Updated to VOMS 2.0.14
    -   Completed conversion of packages to use systemd-tmpfiles on EL7
        -   zookeeper: populates /var/run/zookeeper using systemd-tmpfiles
-   Upcoming repository
    -   Updated to [HTCondor 8.5.8](https://www-auth.cs.wisc.edu/lists/htcondor-world/2016/msg00021.shtml)
    -   Added [Singularity 2.2](http://singularity.lbl.gov/release-2-2) as a new, preview technology
    -   Updated to [frontier-squid 3.5.23-3.1](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES), a technology preview of version 3

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.20%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   When updating or installing HTCondor on an EL 7 system with SELinux enabled, make sure that policycoreutils-python is installed before HTCondor. This dependency will be properly declared in the HTCondor RPM in the next release.
-   A previous version (`1.17.0-2.5`) of the Gratia probes required changes in the HTCondor configuration to operate properly. Now, these changes need to be reverted to use verison (`1.17.0-2.6`) and later of the probes. The lines below are likely to be found in `condor_config.local` or a new file in `/etc/condor/config.d` directory. Delete these lines and run `condor_reconfig`.

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

-   [blahp-1.18.28.bosco-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.28.bosco-2.osg33.el6)
-   [condor-8.4.10-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.10-1.osg33.el6)
-   [globus-ftp-control-7.7-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-ftp-control-7.7-1.osg33.el6)
-   [globus-gridftp-server-11.8-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-11.8-1.1.osg33.el6)
-   [gratia-probe-1.17.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.2-1.osg33.el6)
-   [gridftp-hdfs-0.5.4-25.5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-25.5.osg33.el6)
-   [osg-ce-3.3-10.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ce-3.3-10.osg33.el6)
-   [osg-configure-1.5.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.5.4-1.osg33.el6)
-   [osg-test-1.10.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.10.0-1.osg33.el6)
-   [osg-version-3.3.20-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.20-1.osg33.el6)
-   [voms-2.0.14-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-2.0.14-1.2.osg33.el6)
-   [xrootd-4.5.0-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.5.0-2.osg33.el6)
-   [zookeeper-3.4.3+15-1.cdh4.0.1.p0.4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=zookeeper-3.4.3+15-1.cdh4.0.1.p0.4.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.28.bosco-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.28.bosco-2.osg33.el7)
-   [condor-8.4.10-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.10-1.osg33.el7)
-   [globus-ftp-control-7.7-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-ftp-control-7.7-1.osg33.el7)
-   [globus-gridftp-server-11.8-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-11.8-1.1.osg33.el7)
-   [gratia-probe-1.17.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.2-1.osg33.el7)
-   [gridftp-hdfs-0.5.4-25.5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-25.5.osg33.el7)
-   [osg-ce-3.3-10.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ce-3.3-10.osg33.el7)
-   [osg-configure-1.5.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.5.4-1.osg33.el7)
-   [osg-test-1.10.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.10.0-1.osg33.el7)
-   [osg-version-3.3.20-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.20-1.osg33.el7)
-   [voms-2.0.14-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-2.0.14-1.2.osg33.el7)
-   [xrootd-4.5.0-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.5.0-2.osg33.el7)
-   [zookeeper-3.4.3+15-1.cdh4.0.1.p0.4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=zookeeper-3.4.3+15-1.cdh4.0.1.p0.4.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp globus-ftp-control globus-ftp-control-debuginfo globus-ftp-control-devel globus-ftp-control-doc globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer gridftp-hdfs gridftp-hdfs-debuginfo osg-base-ce osg-base-ce-bosco osg-base-ce-condor osg-base-ce-lsf osg-base-ce-pbs osg-base-ce-sge osg-base-ce-slurm osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-htcondor-ce osg-htcondor-ce-bosco osg-htcondor-ce-condor osg-htcondor-ce-lsf osg-htcondor-ce-pbs osg-htcondor-ce-sge osg-htcondor-ce-slurm osg-test osg-test-log-viewer osg-version voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs zookeeper zookeeper-server

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.28.bosco-2.osg33.el6
blahp-debuginfo-1.18.28.bosco-2.osg33.el6
condor-8.4.10-1.osg33.el6
condor-all-8.4.10-1.osg33.el6
condor-bosco-8.4.10-1.osg33.el6
condor-classads-8.4.10-1.osg33.el6
condor-classads-devel-8.4.10-1.osg33.el6
condor-cream-gahp-8.4.10-1.osg33.el6
condor-debuginfo-8.4.10-1.osg33.el6
condor-kbdd-8.4.10-1.osg33.el6
condor-procd-8.4.10-1.osg33.el6
condor-python-8.4.10-1.osg33.el6
condor-std-universe-8.4.10-1.osg33.el6
condor-test-8.4.10-1.osg33.el6
condor-vm-gahp-8.4.10-1.osg33.el6
globus-ftp-control-7.7-1.osg33.el6
globus-ftp-control-debuginfo-7.7-1.osg33.el6
globus-ftp-control-devel-7.7-1.osg33.el6
globus-ftp-control-doc-7.7-1.osg33.el6
globus-gridftp-server-11.8-1.1.osg33.el6
globus-gridftp-server-debuginfo-11.8-1.1.osg33.el6
globus-gridftp-server-devel-11.8-1.1.osg33.el6
globus-gridftp-server-progs-11.8-1.1.osg33.el6
gratia-probe-1.17.2-1.osg33.el6
gratia-probe-bdii-status-1.17.2-1.osg33.el6
gratia-probe-common-1.17.2-1.osg33.el6
gratia-probe-condor-1.17.2-1.osg33.el6
gratia-probe-condor-events-1.17.2-1.osg33.el6
gratia-probe-dcache-storage-1.17.2-1.osg33.el6
gratia-probe-dcache-storagegroup-1.17.2-1.osg33.el6
gratia-probe-dcache-transfer-1.17.2-1.osg33.el6
gratia-probe-debuginfo-1.17.2-1.osg33.el6
gratia-probe-enstore-storage-1.17.2-1.osg33.el6
gratia-probe-enstore-tapedrive-1.17.2-1.osg33.el6
gratia-probe-enstore-transfer-1.17.2-1.osg33.el6
gratia-probe-glexec-1.17.2-1.osg33.el6
gratia-probe-glideinwms-1.17.2-1.osg33.el6
gratia-probe-gram-1.17.2-1.osg33.el6
gratia-probe-gridftp-transfer-1.17.2-1.osg33.el6
gratia-probe-hadoop-storage-1.17.2-1.osg33.el6
gratia-probe-htcondor-ce-1.17.2-1.osg33.el6
gratia-probe-lsf-1.17.2-1.osg33.el6
gratia-probe-metric-1.17.2-1.osg33.el6
gratia-probe-onevm-1.17.2-1.osg33.el6
gratia-probe-pbs-lsf-1.17.2-1.osg33.el6
gratia-probe-services-1.17.2-1.osg33.el6
gratia-probe-sge-1.17.2-1.osg33.el6
gratia-probe-slurm-1.17.2-1.osg33.el6
gratia-probe-xrootd-storage-1.17.2-1.osg33.el6
gratia-probe-xrootd-transfer-1.17.2-1.osg33.el6
gridftp-hdfs-0.5.4-25.5.osg33.el6
gridftp-hdfs-debuginfo-0.5.4-25.5.osg33.el6
osg-base-ce-3.3-10.osg33.el6
osg-base-ce-bosco-3.3-10.osg33.el6
osg-base-ce-condor-3.3-10.osg33.el6
osg-base-ce-lsf-3.3-10.osg33.el6
osg-base-ce-pbs-3.3-10.osg33.el6
osg-base-ce-sge-3.3-10.osg33.el6
osg-base-ce-slurm-3.3-10.osg33.el6
osg-ce-3.3-10.osg33.el6
osg-ce-bosco-3.3-10.osg33.el6
osg-ce-condor-3.3-10.osg33.el6
osg-ce-lsf-3.3-10.osg33.el6
osg-ce-pbs-3.3-10.osg33.el6
osg-ce-sge-3.3-10.osg33.el6
osg-ce-slurm-3.3-10.osg33.el6
osg-configure-1.5.4-1.osg33.el6
osg-configure-bosco-1.5.4-1.osg33.el6
osg-configure-ce-1.5.4-1.osg33.el6
osg-configure-cemon-1.5.4-1.osg33.el6
osg-configure-condor-1.5.4-1.osg33.el6
osg-configure-gateway-1.5.4-1.osg33.el6
osg-configure-gip-1.5.4-1.osg33.el6
osg-configure-gratia-1.5.4-1.osg33.el6
osg-configure-infoservices-1.5.4-1.osg33.el6
osg-configure-lsf-1.5.4-1.osg33.el6
osg-configure-managedfork-1.5.4-1.osg33.el6
osg-configure-misc-1.5.4-1.osg33.el6
osg-configure-monalisa-1.5.4-1.osg33.el6
osg-configure-network-1.5.4-1.osg33.el6
osg-configure-pbs-1.5.4-1.osg33.el6
osg-configure-rsv-1.5.4-1.osg33.el6
osg-configure-sge-1.5.4-1.osg33.el6
osg-configure-slurm-1.5.4-1.osg33.el6
osg-configure-squid-1.5.4-1.osg33.el6
osg-configure-tests-1.5.4-1.osg33.el6
osg-htcondor-ce-3.3-10.osg33.el6
osg-htcondor-ce-bosco-3.3-10.osg33.el6
osg-htcondor-ce-condor-3.3-10.osg33.el6
osg-htcondor-ce-lsf-3.3-10.osg33.el6
osg-htcondor-ce-pbs-3.3-10.osg33.el6
osg-htcondor-ce-sge-3.3-10.osg33.el6
osg-htcondor-ce-slurm-3.3-10.osg33.el6
osg-test-1.10.0-1.osg33.el6
osg-test-log-viewer-1.10.0-1.osg33.el6
osg-version-3.3.20-1.osg33.el6
voms-2.0.14-1.2.osg33.el6
voms-clients-cpp-2.0.14-1.2.osg33.el6
voms-debuginfo-2.0.14-1.2.osg33.el6
voms-devel-2.0.14-1.2.osg33.el6
voms-doc-2.0.14-1.2.osg33.el6
voms-server-2.0.14-1.2.osg33.el6
xrootd-4.5.0-2.osg33.el6
xrootd-client-4.5.0-2.osg33.el6
xrootd-client-devel-4.5.0-2.osg33.el6
xrootd-client-libs-4.5.0-2.osg33.el6
xrootd-debuginfo-4.5.0-2.osg33.el6
xrootd-devel-4.5.0-2.osg33.el6
xrootd-doc-4.5.0-2.osg33.el6
xrootd-fuse-4.5.0-2.osg33.el6
xrootd-libs-4.5.0-2.osg33.el6
xrootd-private-devel-4.5.0-2.osg33.el6
xrootd-python-4.5.0-2.osg33.el6
xrootd-selinux-4.5.0-2.osg33.el6
xrootd-server-4.5.0-2.osg33.el6
xrootd-server-devel-4.5.0-2.osg33.el6
xrootd-server-libs-4.5.0-2.osg33.el6
zookeeper-3.4.3+15-1.cdh4.0.1.p0.4.osg33.el6
zookeeper-server-3.4.3+15-1.cdh4.0.1.p0.4.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.28.bosco-2.osg33.el7
blahp-debuginfo-1.18.28.bosco-2.osg33.el7
condor-8.4.10-1.osg33.el7
condor-all-8.4.10-1.osg33.el7
condor-bosco-8.4.10-1.osg33.el7
condor-classads-8.4.10-1.osg33.el7
condor-classads-devel-8.4.10-1.osg33.el7
condor-cream-gahp-8.4.10-1.osg33.el7
condor-debuginfo-8.4.10-1.osg33.el7
condor-kbdd-8.4.10-1.osg33.el7
condor-procd-8.4.10-1.osg33.el7
condor-python-8.4.10-1.osg33.el7
condor-test-8.4.10-1.osg33.el7
condor-vm-gahp-8.4.10-1.osg33.el7
globus-ftp-control-7.7-1.osg33.el7
globus-ftp-control-debuginfo-7.7-1.osg33.el7
globus-ftp-control-devel-7.7-1.osg33.el7
globus-ftp-control-doc-7.7-1.osg33.el7
globus-gridftp-server-11.8-1.1.osg33.el7
globus-gridftp-server-debuginfo-11.8-1.1.osg33.el7
globus-gridftp-server-devel-11.8-1.1.osg33.el7
globus-gridftp-server-progs-11.8-1.1.osg33.el7
gratia-probe-1.17.2-1.osg33.el7
gratia-probe-bdii-status-1.17.2-1.osg33.el7
gratia-probe-common-1.17.2-1.osg33.el7
gratia-probe-condor-1.17.2-1.osg33.el7
gratia-probe-condor-events-1.17.2-1.osg33.el7
gratia-probe-dcache-storage-1.17.2-1.osg33.el7
gratia-probe-dcache-storagegroup-1.17.2-1.osg33.el7
gratia-probe-dcache-transfer-1.17.2-1.osg33.el7
gratia-probe-debuginfo-1.17.2-1.osg33.el7
gratia-probe-enstore-storage-1.17.2-1.osg33.el7
gratia-probe-enstore-tapedrive-1.17.2-1.osg33.el7
gratia-probe-enstore-transfer-1.17.2-1.osg33.el7
gratia-probe-glexec-1.17.2-1.osg33.el7
gratia-probe-glideinwms-1.17.2-1.osg33.el7
gratia-probe-gram-1.17.2-1.osg33.el7
gratia-probe-gridftp-transfer-1.17.2-1.osg33.el7
gratia-probe-hadoop-storage-1.17.2-1.osg33.el7
gratia-probe-htcondor-ce-1.17.2-1.osg33.el7
gratia-probe-lsf-1.17.2-1.osg33.el7
gratia-probe-metric-1.17.2-1.osg33.el7
gratia-probe-onevm-1.17.2-1.osg33.el7
gratia-probe-pbs-lsf-1.17.2-1.osg33.el7
gratia-probe-services-1.17.2-1.osg33.el7
gratia-probe-sge-1.17.2-1.osg33.el7
gratia-probe-slurm-1.17.2-1.osg33.el7
gratia-probe-xrootd-storage-1.17.2-1.osg33.el7
gratia-probe-xrootd-transfer-1.17.2-1.osg33.el7
gridftp-hdfs-0.5.4-25.5.osg33.el7
gridftp-hdfs-debuginfo-0.5.4-25.5.osg33.el7
osg-base-ce-3.3-10.osg33.el7
osg-base-ce-bosco-3.3-10.osg33.el7
osg-base-ce-condor-3.3-10.osg33.el7
osg-base-ce-lsf-3.3-10.osg33.el7
osg-base-ce-pbs-3.3-10.osg33.el7
osg-base-ce-sge-3.3-10.osg33.el7
osg-base-ce-slurm-3.3-10.osg33.el7
osg-ce-3.3-10.osg33.el7
osg-ce-bosco-3.3-10.osg33.el7
osg-ce-condor-3.3-10.osg33.el7
osg-ce-lsf-3.3-10.osg33.el7
osg-ce-pbs-3.3-10.osg33.el7
osg-ce-sge-3.3-10.osg33.el7
osg-ce-slurm-3.3-10.osg33.el7
osg-configure-1.5.4-1.osg33.el7
osg-configure-bosco-1.5.4-1.osg33.el7
osg-configure-ce-1.5.4-1.osg33.el7
osg-configure-cemon-1.5.4-1.osg33.el7
osg-configure-condor-1.5.4-1.osg33.el7
osg-configure-gateway-1.5.4-1.osg33.el7
osg-configure-gip-1.5.4-1.osg33.el7
osg-configure-gratia-1.5.4-1.osg33.el7
osg-configure-infoservices-1.5.4-1.osg33.el7
osg-configure-lsf-1.5.4-1.osg33.el7
osg-configure-managedfork-1.5.4-1.osg33.el7
osg-configure-misc-1.5.4-1.osg33.el7
osg-configure-monalisa-1.5.4-1.osg33.el7
osg-configure-network-1.5.4-1.osg33.el7
osg-configure-pbs-1.5.4-1.osg33.el7
osg-configure-rsv-1.5.4-1.osg33.el7
osg-configure-sge-1.5.4-1.osg33.el7
osg-configure-slurm-1.5.4-1.osg33.el7
osg-configure-squid-1.5.4-1.osg33.el7
osg-configure-tests-1.5.4-1.osg33.el7
osg-htcondor-ce-3.3-10.osg33.el7
osg-htcondor-ce-bosco-3.3-10.osg33.el7
osg-htcondor-ce-condor-3.3-10.osg33.el7
osg-htcondor-ce-lsf-3.3-10.osg33.el7
osg-htcondor-ce-pbs-3.3-10.osg33.el7
osg-htcondor-ce-sge-3.3-10.osg33.el7
osg-htcondor-ce-slurm-3.3-10.osg33.el7
osg-test-1.10.0-1.osg33.el7
osg-test-log-viewer-1.10.0-1.osg33.el7
osg-version-3.3.20-1.osg33.el7
voms-2.0.14-1.2.osg33.el7
voms-clients-cpp-2.0.14-1.2.osg33.el7
voms-debuginfo-2.0.14-1.2.osg33.el7
voms-devel-2.0.14-1.2.osg33.el7
voms-doc-2.0.14-1.2.osg33.el7
voms-server-2.0.14-1.2.osg33.el7
xrootd-4.5.0-2.osg33.el7
xrootd-client-4.5.0-2.osg33.el7
xrootd-client-devel-4.5.0-2.osg33.el7
xrootd-client-libs-4.5.0-2.osg33.el7
xrootd-debuginfo-4.5.0-2.osg33.el7
xrootd-devel-4.5.0-2.osg33.el7
xrootd-doc-4.5.0-2.osg33.el7
xrootd-fuse-4.5.0-2.osg33.el7
xrootd-libs-4.5.0-2.osg33.el7
xrootd-private-devel-4.5.0-2.osg33.el7
xrootd-python-4.5.0-2.osg33.el7
xrootd-selinux-4.5.0-2.osg33.el7
xrootd-server-4.5.0-2.osg33.el7
xrootd-server-devel-4.5.0-2.osg33.el7
xrootd-server-libs-4.5.0-2.osg33.el7
zookeeper-3.4.3+15-1.cdh4.0.1.p0.4.osg33.el7
zookeeper-server-3.4.3+15-1.cdh4.0.1.p0.4.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.28.bosco-2.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.28.bosco-2.osgup.el6)
-   [condor-8.5.8-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.8-1.osgup.el6)
-   [frontier-squid-3.5.23-3.1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=frontier-squid-3.5.23-3.1.osgup.el6)
-   [singularity-2.2-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=singularity-2.2-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.28.bosco-2.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.28.bosco-2.osgup.el7)
-   [condor-8.5.8-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.8-1.osgup.el7)
-   [frontier-squid-3.5.23-3.1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=frontier-squid-3.5.23-3.1.osgup.el7)
-   [singularity-2.2-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=singularity-2.2-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp frontier-squid frontier-squid-debuginfo singularity singularity-debuginfo singularity-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.28.bosco-2.osgup.el6
blahp-debuginfo-1.18.28.bosco-2.osgup.el6
condor-8.5.8-1.osgup.el6
condor-all-8.5.8-1.osgup.el6
condor-bosco-8.5.8-1.osgup.el6
condor-classads-8.5.8-1.osgup.el6
condor-classads-devel-8.5.8-1.osgup.el6
condor-cream-gahp-8.5.8-1.osgup.el6
condor-debuginfo-8.5.8-1.osgup.el6
condor-kbdd-8.5.8-1.osgup.el6
condor-procd-8.5.8-1.osgup.el6
condor-python-8.5.8-1.osgup.el6
condor-std-universe-8.5.8-1.osgup.el6
condor-test-8.5.8-1.osgup.el6
condor-vm-gahp-8.5.8-1.osgup.el6
frontier-squid-3.5.23-3.1.osgup.el6
frontier-squid-debuginfo-3.5.23-3.1.osgup.el6
singularity-2.2-1.osgup.el6
singularity-debuginfo-2.2-1.osgup.el6
singularity-devel-2.2-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.28.bosco-2.osgup.el7
blahp-debuginfo-1.18.28.bosco-2.osgup.el7
condor-8.5.8-1.osgup.el7
condor-all-8.5.8-1.osgup.el7
condor-bosco-8.5.8-1.osgup.el7
condor-classads-8.5.8-1.osgup.el7
condor-classads-devel-8.5.8-1.osgup.el7
condor-cream-gahp-8.5.8-1.osgup.el7
condor-debuginfo-8.5.8-1.osgup.el7
condor-kbdd-8.5.8-1.osgup.el7
condor-procd-8.5.8-1.osgup.el7
condor-python-8.5.8-1.osgup.el7
condor-test-8.5.8-1.osgup.el7
condor-vm-gahp-8.5.8-1.osgup.el7
frontier-squid-3.5.23-3.1.osgup.el7
frontier-squid-debuginfo-3.5.23-3.1.osgup.el7
singularity-2.2-1.osgup.el7
singularity-debuginfo-2.2-1.osgup.el7
singularity-devel-2.2-1.osgup.el7
```

