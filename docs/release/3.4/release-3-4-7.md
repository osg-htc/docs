OSG Software Release 3.4.7
==========================

**Release Date**: 2018-02-01

Summary of changes
------------------

This release contains:

-   HDFS 2.6 and related tools (GridFTP-HDFS and XRootD-HDFS) are now available in the Upcoming Repository for Enterprise Linux 7
-   [Singularity 2.4.2](https://github.com/singularityware/singularity/releases): Feature upgrade from Singularity 2.3.2
    -   See [Singularity 2.4 release notes](http://singularity.lbl.gov/release-2-4) for a list of new features and improvements
-   [Pegasus 4.8.1](https://pegasus.isi.edu/2018/01/16/pegasus-4-8-1-released/): Feature upgrade from Pegasus 4.7.4
    -   See [Pegasus 4.8.0 release notes](https://pegasus.isi.edu/2017/09/05/pegasus-4-8-0-released/) for a list of new features and improvements
-   Updated gratia-probe to account for GPUs
-   perfSONAR-tools meta-package including updated BWCTL, OWAMP, and nuttcp packages
-   [HTCondor 8.6.9](https://www-auth.cs.wisc.edu/lists/htcondor-world/2018/msg00000.shtml): Bug fix release
-   [frontier-squid 3.5.27-2.1](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES): Bug fix release
-   Minor bug fix for osg-user-cert-renew
-   [HTCondor 8.7.6](https://www-auth.cs.wisc.edu/lists/htcondor-world/2018/msg00001.shtml) in the Upcoming respository

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.7%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore ('_'). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](../../index.md).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details`. This warning can safely be ignored.

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-osg-repositories).

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

-   [I2util-1.2-2.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=I2util-1.2-2.1.osg34.el6)
-   [bwctl-1.5.2-5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bwctl-1.5.2-5.osg34.el6)
-   [condor-8.6.9-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.9-1.1.osg34.el6)
-   [frontier-squid-3.5.27-2.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.27-2.1.osg34.el6)
-   [gratia-probe-1.19.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.19.0-1.osg34.el6)
-   [nuttcp-8.1.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=nuttcp-8.1.4-1.osg34.el6)
-   [osg-build-1.11.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.11.2-1.osg34.el6)
-   [osg-ca-generator-1.3.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-generator-1.3.2-1.osg34.el6)
-   [osg-ce-3.4-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.4-4.osg34.el6)
-   [osg-gridftp-3.4-5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-5.osg34.el6)
-   [osg-gridftp-xrootd-3.4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-xrootd-3.4-2.osg34.el6)
-   [osg-pki-tools-2.1.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-2.1.4-1.osg34.el6)
-   [osg-test-2.0.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.0.1-1.osg34.el6)
-   [osg-version-3.4.7-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.7-1.osg34.el6)
-   [osg-wn-client-3.4-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.4-4.osg34.el6)
-   [owamp-3.4-10.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=owamp-3.4-10.osg34.el6)
-   [pegasus-4.8.1-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.8.1-1.2.osg34.el6)
-   [perfsonar-tools-4.0.1-1.3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=perfsonar-tools-4.0.1-1.3.osg34.el6)
-   [singularity-2.4.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.4.2-1.osg34.el6)

#### Enterprise Linux 7

-   [I2util-1.2-2.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=I2util-1.2-2.1.osg34.el7)
-   [bwctl-1.5.2-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bwctl-1.5.2-5.osg34.el7)
-   [condor-8.6.9-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.9-1.1.osg34.el7)
-   [frontier-squid-3.5.27-2.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.27-2.1.osg34.el7)
-   [gratia-probe-1.19.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.19.0-1.osg34.el7)
-   [nuttcp-8.1.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=nuttcp-8.1.4-1.osg34.el7)
-   [osg-build-1.11.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.11.2-1.osg34.el7)
-   [osg-ca-generator-1.3.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-generator-1.3.2-1.osg34.el7)
-   [osg-ce-3.4-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.4-4.osg34.el7)
-   [osg-gridftp-3.4-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-5.osg34.el7)
-   [osg-gridftp-xrootd-3.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-xrootd-3.4-2.osg34.el7)
-   [osg-pki-tools-2.1.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-2.1.4-1.osg34.el7)
-   [osg-test-2.0.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.0.1-1.osg34.el7)
-   [osg-version-3.4.7-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.7-1.osg34.el7)
-   [osg-wn-client-3.4-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.4-4.osg34.el7)
-   [owamp-3.4-10.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=owamp-3.4-10.osg34.el7)
-   [pegasus-4.8.1-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.8.1-1.2.osg34.el7)
-   [perfsonar-tools-4.0.1-1.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=perfsonar-tools-4.0.1-1.3.osg34.el7)
-   [singularity-2.4.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.4.2-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    bwctl bwctl-client bwctl-debuginfo bwctl-devel bwctl-server condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp frontier-squid frontier-squid-debuginfo gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer I2util I2util-debuginfo igtf-ca-certs nuttcp nuttcp-debuginfo osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-ca-certs osg-ca-generator osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-gridftp osg-gridftp-xrootd osg-pki-tools osg-test osg-test-log-viewer osg-version osg-wn-client owamp owamp-client owamp-debuginfo owamp-server pegasus pegasus-debuginfo perfsonar-tools singularity singularity-debuginfo singularity-devel singularity-runtime

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
bwctl-1.5.2-5.osg34.el6
bwctl-client-1.5.2-5.osg34.el6
bwctl-debuginfo-1.5.2-5.osg34.el6
bwctl-devel-1.5.2-5.osg34.el6
bwctl-server-1.5.2-5.osg34.el6
condor-8.6.9-1.1.osg34.el6
condor-all-8.6.9-1.1.osg34.el6
condor-bosco-8.6.9-1.1.osg34.el6
condor-classads-8.6.9-1.1.osg34.el6
condor-classads-devel-8.6.9-1.1.osg34.el6
condor-cream-gahp-8.6.9-1.1.osg34.el6
condor-debuginfo-8.6.9-1.1.osg34.el6
condor-kbdd-8.6.9-1.1.osg34.el6
condor-procd-8.6.9-1.1.osg34.el6
condor-python-8.6.9-1.1.osg34.el6
condor-std-universe-8.6.9-1.1.osg34.el6
condor-test-8.6.9-1.1.osg34.el6
condor-vm-gahp-8.6.9-1.1.osg34.el6
frontier-squid-3.5.27-2.1.osg34.el6
frontier-squid-debuginfo-3.5.27-2.1.osg34.el6
gratia-probe-1.19.0-1.osg34.el6
gratia-probe-common-1.19.0-1.osg34.el6
gratia-probe-condor-1.19.0-1.osg34.el6
gratia-probe-condor-events-1.19.0-1.osg34.el6
gratia-probe-dcache-storage-1.19.0-1.osg34.el6
gratia-probe-dcache-storagegroup-1.19.0-1.osg34.el6
gratia-probe-dcache-transfer-1.19.0-1.osg34.el6
gratia-probe-debuginfo-1.19.0-1.osg34.el6
gratia-probe-enstore-storage-1.19.0-1.osg34.el6
gratia-probe-enstore-tapedrive-1.19.0-1.osg34.el6
gratia-probe-enstore-transfer-1.19.0-1.osg34.el6
gratia-probe-glexec-1.19.0-1.osg34.el6
gratia-probe-glideinwms-1.19.0-1.osg34.el6
gratia-probe-gram-1.19.0-1.osg34.el6
gratia-probe-gridftp-transfer-1.19.0-1.osg34.el6
gratia-probe-hadoop-storage-1.19.0-1.osg34.el6
gratia-probe-htcondor-ce-1.19.0-1.osg34.el6
gratia-probe-lsf-1.19.0-1.osg34.el6
gratia-probe-metric-1.19.0-1.osg34.el6
gratia-probe-onevm-1.19.0-1.osg34.el6
gratia-probe-pbs-lsf-1.19.0-1.osg34.el6
gratia-probe-services-1.19.0-1.osg34.el6
gratia-probe-sge-1.19.0-1.osg34.el6
gratia-probe-slurm-1.19.0-1.osg34.el6
gratia-probe-xrootd-storage-1.19.0-1.osg34.el6
gratia-probe-xrootd-transfer-1.19.0-1.osg34.el6
I2util-1.2-2.1.osg34.el6
I2util-debuginfo-1.2-2.1.osg34.el6
nuttcp-8.1.4-1.osg34.el6
nuttcp-debuginfo-8.1.4-1.osg34.el6
osg-build-1.11.2-1.osg34.el6
osg-build-base-1.11.2-1.osg34.el6
osg-build-koji-1.11.2-1.osg34.el6
osg-build-mock-1.11.2-1.osg34.el6
osg-build-tests-1.11.2-1.osg34.el6
osg-ca-generator-1.3.2-1.osg34.el6
osg-ce-3.4-4.osg34.el6
osg-ce-bosco-3.4-4.osg34.el6
osg-ce-condor-3.4-4.osg34.el6
osg-ce-lsf-3.4-4.osg34.el6
osg-ce-pbs-3.4-4.osg34.el6
osg-ce-sge-3.4-4.osg34.el6
osg-ce-slurm-3.4-4.osg34.el6
osg-gridftp-3.4-5.osg34.el6
osg-gridftp-xrootd-3.4-2.osg34.el6
osg-pki-tools-2.1.4-1.osg34.el6
osg-test-2.0.1-1.osg34.el6
osg-test-log-viewer-2.0.1-1.osg34.el6
osg-version-3.4.7-1.osg34.el6
osg-wn-client-3.4-4.osg34.el6
owamp-3.4-10.osg34.el6
owamp-client-3.4-10.osg34.el6
owamp-debuginfo-3.4-10.osg34.el6
owamp-server-3.4-10.osg34.el6
pegasus-4.8.1-1.2.osg34.el6
pegasus-debuginfo-4.8.1-1.2.osg34.el6
perfsonar-tools-4.0.1-1.3.osg34.el6
singularity-2.4.2-1.osg34.el6
singularity-debuginfo-2.4.2-1.osg34.el6
singularity-devel-2.4.2-1.osg34.el6
singularity-runtime-2.4.2-1.osg34.el6
```

#### Enterprise Linux 7

``` file
bwctl-1.5.2-5.osg34.el7
bwctl-client-1.5.2-5.osg34.el7
bwctl-debuginfo-1.5.2-5.osg34.el7
bwctl-devel-1.5.2-5.osg34.el7
bwctl-server-1.5.2-5.osg34.el7
condor-8.6.9-1.1.osg34.el7
condor-all-8.6.9-1.1.osg34.el7
condor-bosco-8.6.9-1.1.osg34.el7
condor-classads-8.6.9-1.1.osg34.el7
condor-classads-devel-8.6.9-1.1.osg34.el7
condor-cream-gahp-8.6.9-1.1.osg34.el7
condor-debuginfo-8.6.9-1.1.osg34.el7
condor-kbdd-8.6.9-1.1.osg34.el7
condor-procd-8.6.9-1.1.osg34.el7
condor-python-8.6.9-1.1.osg34.el7
condor-test-8.6.9-1.1.osg34.el7
condor-vm-gahp-8.6.9-1.1.osg34.el7
frontier-squid-3.5.27-2.1.osg34.el7
frontier-squid-debuginfo-3.5.27-2.1.osg34.el7
gratia-probe-1.19.0-1.osg34.el7
gratia-probe-common-1.19.0-1.osg34.el7
gratia-probe-condor-1.19.0-1.osg34.el7
gratia-probe-condor-events-1.19.0-1.osg34.el7
gratia-probe-dcache-storage-1.19.0-1.osg34.el7
gratia-probe-dcache-storagegroup-1.19.0-1.osg34.el7
gratia-probe-dcache-transfer-1.19.0-1.osg34.el7
gratia-probe-debuginfo-1.19.0-1.osg34.el7
gratia-probe-enstore-storage-1.19.0-1.osg34.el7
gratia-probe-enstore-tapedrive-1.19.0-1.osg34.el7
gratia-probe-enstore-transfer-1.19.0-1.osg34.el7
gratia-probe-glexec-1.19.0-1.osg34.el7
gratia-probe-glideinwms-1.19.0-1.osg34.el7
gratia-probe-gram-1.19.0-1.osg34.el7
gratia-probe-gridftp-transfer-1.19.0-1.osg34.el7
gratia-probe-hadoop-storage-1.19.0-1.osg34.el7
gratia-probe-htcondor-ce-1.19.0-1.osg34.el7
gratia-probe-lsf-1.19.0-1.osg34.el7
gratia-probe-metric-1.19.0-1.osg34.el7
gratia-probe-onevm-1.19.0-1.osg34.el7
gratia-probe-pbs-lsf-1.19.0-1.osg34.el7
gratia-probe-services-1.19.0-1.osg34.el7
gratia-probe-sge-1.19.0-1.osg34.el7
gratia-probe-slurm-1.19.0-1.osg34.el7
gratia-probe-xrootd-storage-1.19.0-1.osg34.el7
gratia-probe-xrootd-transfer-1.19.0-1.osg34.el7
I2util-1.2-2.1.osg34.el7
I2util-debuginfo-1.2-2.1.osg34.el7
nuttcp-8.1.4-1.osg34.el7
nuttcp-debuginfo-8.1.4-1.osg34.el7
osg-build-1.11.2-1.osg34.el7
osg-build-base-1.11.2-1.osg34.el7
osg-build-koji-1.11.2-1.osg34.el7
osg-build-mock-1.11.2-1.osg34.el7
osg-build-tests-1.11.2-1.osg34.el7
osg-ca-generator-1.3.2-1.osg34.el7
osg-ce-3.4-4.osg34.el7
osg-ce-bosco-3.4-4.osg34.el7
osg-ce-condor-3.4-4.osg34.el7
osg-ce-lsf-3.4-4.osg34.el7
osg-ce-pbs-3.4-4.osg34.el7
osg-ce-sge-3.4-4.osg34.el7
osg-ce-slurm-3.4-4.osg34.el7
osg-gridftp-3.4-5.osg34.el7
osg-gridftp-xrootd-3.4-2.osg34.el7
osg-pki-tools-2.1.4-1.osg34.el7
osg-test-2.0.1-1.osg34.el7
osg-test-log-viewer-2.0.1-1.osg34.el7
osg-version-3.4.7-1.osg34.el7
osg-wn-client-3.4-4.osg34.el7
owamp-3.4-10.osg34.el7
owamp-client-3.4-10.osg34.el7
owamp-debuginfo-3.4-10.osg34.el7
owamp-server-3.4-10.osg34.el7
pegasus-4.8.1-1.2.osg34.el7
pegasus-debuginfo-4.8.1-1.2.osg34.el7
perfsonar-tools-4.0.1-1.3.osg34.el7
singularity-2.4.2-1.osg34.el7
singularity-debuginfo-2.4.2-1.osg34.el7
singularity-devel-2.4.2-1.osg34.el7
singularity-runtime-2.4.2-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.7.6-1.1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.6-1.1.osgup.el6)

#### Enterprise Linux 7

-   [avro-libs-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=avro-libs-1.7.6%2Bcdh5.13.0%2B135-1.cdh5.13.0.p0.34.1.osgup.el7)
-   [bigtop-jsvc-0.3.0-1.2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bigtop-jsvc-0.3.0-1.2.osgup.el7)
-   [bigtop-utils-0.7.0+cdh5.13.0+0-1.cdh5.13.0.p0.34.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bigtop-utils-0.7.0%2Bcdh5.13.0%2B0-1.cdh5.13.0.p0.34.1.osgup.el7)
-   [condor-8.7.6-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.6-1.1.osgup.el7)
-   [gridftp-hdfs-1.1.1-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-hdfs-1.1.1-1.1.osgup.el7)
-   [hadoop-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hadoop-2.6.0%2Bcdh5.12.1%2B2540-1.cdh5.12.1.p0.3.7.osgup.el7)
-   [osg-gridftp-hdfs-3.4-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-hdfs-3.4-1.osgup.el7)
-   [osg-se-hadoop-3.4-3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-se-hadoop-3.4-3.osgup.el7)
-   [xrootd-hdfs-1.9.2-5.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.9.2-5.osgup.el7)
-   [zookeeper-3.4.3+15-1.cdh4.0.1.p0.6.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=zookeeper-3.4.3%2B15-1.cdh4.0.1.p0.6.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.7.6-1.1.osgup.el6
condor-all-8.7.6-1.1.osgup.el6
condor-annex-ec2-8.7.6-1.1.osgup.el6
condor-bosco-8.7.6-1.1.osgup.el6
condor-classads-8.7.6-1.1.osgup.el6
condor-classads-devel-8.7.6-1.1.osgup.el6
condor-cream-gahp-8.7.6-1.1.osgup.el6
condor-debuginfo-8.7.6-1.1.osgup.el6
condor-kbdd-8.7.6-1.1.osgup.el6
condor-procd-8.7.6-1.1.osgup.el6
condor-python-8.7.6-1.1.osgup.el6
condor-std-universe-8.7.6-1.1.osgup.el6
condor-test-8.7.6-1.1.osgup.el6
condor-vm-gahp-8.7.6-1.1.osgup.el6
```

#### Enterprise Linux 7

``` file
avro-doc-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.1.osgup.el7
avro-libs-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.1.osgup.el7
avro-tools-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.1.osgup.el7
bigtop-jsvc-0.3.0-1.2.osgup.el7
bigtop-jsvc-debuginfo-0.3.0-1.2.osgup.el7
bigtop-utils-0.7.0+cdh5.13.0+0-1.cdh5.13.0.p0.34.1.osgup.el7
condor-8.7.6-1.1.osgup.el7
condor-all-8.7.6-1.1.osgup.el7
condor-annex-ec2-8.7.6-1.1.osgup.el7
condor-bosco-8.7.6-1.1.osgup.el7
condor-classads-8.7.6-1.1.osgup.el7
condor-classads-devel-8.7.6-1.1.osgup.el7
condor-cream-gahp-8.7.6-1.1.osgup.el7
condor-debuginfo-8.7.6-1.1.osgup.el7
condor-kbdd-8.7.6-1.1.osgup.el7
condor-procd-8.7.6-1.1.osgup.el7
condor-python-8.7.6-1.1.osgup.el7
condor-test-8.7.6-1.1.osgup.el7
condor-vm-gahp-8.7.6-1.1.osgup.el7
gridftp-hdfs-1.1.1-1.1.osgup.el7
gridftp-hdfs-debuginfo-1.1.1-1.1.osgup.el7
hadoop-0.20-conf-pseudo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-0.20-mapreduce-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-client-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-conf-pseudo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-debuginfo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-doc-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-hdfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-hdfs-datanode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-hdfs-fuse-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-hdfs-journalnode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-hdfs-namenode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-hdfs-nfs3-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-hdfs-secondarynamenode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-hdfs-zkfc-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-httpfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-kms-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-kms-server-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-libhdfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-libhdfs-devel-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-mapreduce-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
hadoop-yarn-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.7.osgup.el7
osg-gridftp-hdfs-3.4-1.osgup.el7
osg-se-hadoop-3.4-3.osgup.el7
osg-se-hadoop-client-3.4-3.osgup.el7
osg-se-hadoop-datanode-3.4-3.osgup.el7
osg-se-hadoop-gridftp-3.4-3.osgup.el7
osg-se-hadoop-namenode-3.4-3.osgup.el7
osg-se-hadoop-secondarynamenode-3.4-3.osgup.el7
xrootd-hdfs-1.9.2-5.osgup.el7
xrootd-hdfs-debuginfo-1.9.2-5.osgup.el7
xrootd-hdfs-devel-1.9.2-5.osgup.el7
zookeeper-3.4.3+15-1.cdh4.0.1.p0.6.osgup.el7
zookeeper-server-3.4.3+15-1.cdh4.0.1.p0.6.osgup.el7
```
