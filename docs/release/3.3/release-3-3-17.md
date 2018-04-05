OSG Software Release 3.3.17
===========================

**Release Date**: 2016-10-13

Summary of changes
------------------

This release contains:

-   [HTCondor 8.4.9](https://lists.cs.wisc.edu/archive/htcondor-users/2016-September/msg00102.shtml): Job Router prompts schedd reschedule, other bug fixes
-   [HTCondor-CE 2.0.10](https://github.com/opensciencegrid/htcondor-ce/releases)
    -   Detect and refuse to start with an invalid configuration
    -   Handle unbounded HTCondor-CE accounting directory
    -   Properly check against 'undefined' for undefined values
-   gratia-probe-1.17.0-2.3
    -   Update gratia probe to work with more recent versions of Slurm
    -   Add fallback default in gratia probe for HTCondor-CE history folder
-   [frontier-squid-2.7.STABLE9-27](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt) - fix unbounded growth of swap.state
-   [CVMFS 2.3.2](http://cvmfs.readthedocs.io/en/2.3/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-3-2): support for secured (using VOMS X.509 proxies) access to data in osgstorage.org repositories
-   [XRootD 4.4.0](https://github.com/xrootd/xrootd/blob/v4.4.0/docs/ReleaseNotes.txt)
-   Several configuration updates to better mesh with EL7 and systemd
    -   osg-control now uses systemd interfaces where appropriate
    -   systemd tmpfile mechanism employed for HTCondor, HTCondor-CE, gratia
    -   globus-gatekeeper init script now works properly with systemd
-   Add RPM package version list to tarballs
-   [HTCondor 8.5.7](https://lists.cs.wisc.edu/archive/htcondor-users/2016-September/msg00103.shtml) in Upcoming: the schedd can perform job ClassAd transformations
-   Updated to [VO Package v69](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-69): Added: miniclean VO; Removed: LNBE, CDF INFN
-   [RSV-perfSONAR 1.1.4](https://github.com/opensciencegrid/rsv-perfsonar/releases/tag/1.1.4) - Have probes look farther back into the past for information

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.17%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

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

!!! note "Notes"
    -   Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.26.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.26.bosco-1.osg33.el6)
-   [condor-8.4.9-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.9-1.osg33.el6)
-   [condor-cron-1.1.1-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-cron-1.1.1-2.osg33.el6)
-   [cvmfs-2.3.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.3.2-1.osg33.el6)
-   [cvmfs-config-osg-1.2-5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-5.osg33.el6)
-   [cvmfs-x509-helper-0.9-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-0.9-1.osg33.el6)
-   [frontier-squid-2.7.STABLE9-27.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=frontier-squid-2.7.STABLE9-27.1.osg33.el6)
-   [globus-gatekeeper-10.10-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gatekeeper-10.10-1.2.osg33.el6)
-   [gratia-probe-1.17.0-2.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.0-2.3.osg33.el6)
-   [htcondor-ce-2.0.10-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.10-1.osg33.el6)
-   [osg-control-1.1.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-control-1.1.0-1.osg33.el6)
-   [osg-oasis-7-5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-7-5.osg33.el6)
-   [osg-test-1.9.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.9.0-1.osg33.el6)
-   [osg-tested-internal-3.3-15.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-15.osg33.el6)
-   [osg-version-3.3.17-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.17-1.osg33.el6)
-   [rsv-perfsonar-1.1.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-perfsonar-1.1.4-1.osg33.el6)
-   [vo-client-69-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-69-1.osg33.el6)
-   [xrootd-4.4.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.4.0-1.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.26.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.26.bosco-1.osg33.el7)
-   [condor-8.4.9-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.9-1.osg33.el7)
-   [condor-cron-1.1.1-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-cron-1.1.1-2.osg33.el7)
-   [cvmfs-2.3.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.3.2-1.osg33.el7)
-   [cvmfs-config-osg-1.2-5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-5.osg33.el7)
-   [cvmfs-x509-helper-0.9-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-0.9-1.osg33.el7)
-   [frontier-squid-2.7.STABLE9-27.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=frontier-squid-2.7.STABLE9-27.1.osg33.el7)
-   [globus-gatekeeper-10.10-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gatekeeper-10.10-1.2.osg33.el7)
-   [gratia-probe-1.17.0-2.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.0-2.3.osg33.el7)
-   [htcondor-ce-2.0.10-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.10-1.osg33.el7)
-   [osg-control-1.1.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-control-1.1.0-1.osg33.el7)
-   [osg-oasis-7-5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-7-5.osg33.el7)
-   [osg-test-1.9.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.9.0-1.osg33.el7)
-   [osg-tested-internal-3.3-15.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-15.osg33.el7)
-   [osg-version-3.3.17-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.17-1.osg33.el7)
-   [vo-client-69-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-69-1.osg33.el7)
-   [xrootd-4.4.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.4.0-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-cron condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-config-osg cvmfs-devel cvmfs-server cvmfs-unittests cvmfs-x509-helper cvmfs-x509-helper-debuginfo frontier-squid frontier-squid-debuginfo globus-gatekeeper globus-gatekeeper-debuginfo gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view osg-control osg-gums-config osg-oasis osg-test osg-tested-internal osg-tested-internal-gram osg-version rsv-perfsonar vo-client vo-client-edgmkgridmap xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.26.bosco-1.osg33.el6
blahp-debuginfo-1.18.26.bosco-1.osg33.el6
condor-8.4.9-1.osg33.el6
condor-all-8.4.9-1.osg33.el6
condor-bosco-8.4.9-1.osg33.el6
condor-classads-8.4.9-1.osg33.el6
condor-classads-devel-8.4.9-1.osg33.el6
condor-cream-gahp-8.4.9-1.osg33.el6
condor-cron-1.1.1-2.osg33.el6
condor-debuginfo-8.4.9-1.osg33.el6
condor-kbdd-8.4.9-1.osg33.el6
condor-procd-8.4.9-1.osg33.el6
condor-python-8.4.9-1.osg33.el6
condor-std-universe-8.4.9-1.osg33.el6
condor-test-8.4.9-1.osg33.el6
condor-vm-gahp-8.4.9-1.osg33.el6
cvmfs-2.3.2-1.osg33.el6
cvmfs-config-osg-1.2-5.osg33.el6
cvmfs-devel-2.3.2-1.osg33.el6
cvmfs-server-2.3.2-1.osg33.el6
cvmfs-unittests-2.3.2-1.osg33.el6
cvmfs-x509-helper-0.9-1.osg33.el6
cvmfs-x509-helper-debuginfo-0.9-1.osg33.el6
frontier-squid-2.7.STABLE9-27.1.osg33.el6
frontier-squid-debuginfo-2.7.STABLE9-27.1.osg33.el6
globus-gatekeeper-10.10-1.2.osg33.el6
globus-gatekeeper-debuginfo-10.10-1.2.osg33.el6
gratia-probe-1.17.0-2.3.osg33.el6
gratia-probe-bdii-status-1.17.0-2.3.osg33.el6
gratia-probe-common-1.17.0-2.3.osg33.el6
gratia-probe-condor-1.17.0-2.3.osg33.el6
gratia-probe-condor-events-1.17.0-2.3.osg33.el6
gratia-probe-dcache-storage-1.17.0-2.3.osg33.el6
gratia-probe-dcache-storagegroup-1.17.0-2.3.osg33.el6
gratia-probe-dcache-transfer-1.17.0-2.3.osg33.el6
gratia-probe-debuginfo-1.17.0-2.3.osg33.el6
gratia-probe-enstore-storage-1.17.0-2.3.osg33.el6
gratia-probe-enstore-tapedrive-1.17.0-2.3.osg33.el6
gratia-probe-enstore-transfer-1.17.0-2.3.osg33.el6
gratia-probe-glexec-1.17.0-2.3.osg33.el6
gratia-probe-glideinwms-1.17.0-2.3.osg33.el6
gratia-probe-gram-1.17.0-2.3.osg33.el6
gratia-probe-gridftp-transfer-1.17.0-2.3.osg33.el6
gratia-probe-hadoop-storage-1.17.0-2.3.osg33.el6
gratia-probe-htcondor-ce-1.17.0-2.3.osg33.el6
gratia-probe-lsf-1.17.0-2.3.osg33.el6
gratia-probe-metric-1.17.0-2.3.osg33.el6
gratia-probe-onevm-1.17.0-2.3.osg33.el6
gratia-probe-pbs-lsf-1.17.0-2.3.osg33.el6
gratia-probe-services-1.17.0-2.3.osg33.el6
gratia-probe-sge-1.17.0-2.3.osg33.el6
gratia-probe-slurm-1.17.0-2.3.osg33.el6
gratia-probe-xrootd-storage-1.17.0-2.3.osg33.el6
gratia-probe-xrootd-transfer-1.17.0-2.3.osg33.el6
htcondor-ce-2.0.10-1.osg33.el6
htcondor-ce-bosco-2.0.10-1.osg33.el6
htcondor-ce-client-2.0.10-1.osg33.el6
htcondor-ce-collector-2.0.10-1.osg33.el6
htcondor-ce-condor-2.0.10-1.osg33.el6
htcondor-ce-lsf-2.0.10-1.osg33.el6
htcondor-ce-pbs-2.0.10-1.osg33.el6
htcondor-ce-sge-2.0.10-1.osg33.el6
htcondor-ce-view-2.0.10-1.osg33.el6
osg-control-1.1.0-1.osg33.el6
osg-gums-config-69-1.osg33.el6
osg-oasis-7-5.osg33.el6
osg-test-1.9.0-1.osg33.el6
osg-tested-internal-3.3-15.osg33.el6
osg-tested-internal-gram-3.3-15.osg33.el6
osg-version-3.3.17-1.osg33.el6
rsv-perfsonar-1.1.4-1.osg33.el6
vo-client-69-1.osg33.el6
vo-client-edgmkgridmap-69-1.osg33.el6
xrootd-4.4.0-1.osg33.el6
xrootd-client-4.4.0-1.osg33.el6
xrootd-client-devel-4.4.0-1.osg33.el6
xrootd-client-libs-4.4.0-1.osg33.el6
xrootd-debuginfo-4.4.0-1.osg33.el6
xrootd-devel-4.4.0-1.osg33.el6
xrootd-doc-4.4.0-1.osg33.el6
xrootd-fuse-4.4.0-1.osg33.el6
xrootd-libs-4.4.0-1.osg33.el6
xrootd-private-devel-4.4.0-1.osg33.el6
xrootd-python-4.4.0-1.osg33.el6
xrootd-selinux-4.4.0-1.osg33.el6
xrootd-server-4.4.0-1.osg33.el6
xrootd-server-devel-4.4.0-1.osg33.el6
xrootd-server-libs-4.4.0-1.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.26.bosco-1.osg33.el7
blahp-debuginfo-1.18.26.bosco-1.osg33.el7
condor-8.4.9-1.osg33.el7
condor-all-8.4.9-1.osg33.el7
condor-bosco-8.4.9-1.osg33.el7
condor-classads-8.4.9-1.osg33.el7
condor-classads-devel-8.4.9-1.osg33.el7
condor-cream-gahp-8.4.9-1.osg33.el7
condor-cron-1.1.1-2.osg33.el7
condor-debuginfo-8.4.9-1.osg33.el7
condor-kbdd-8.4.9-1.osg33.el7
condor-procd-8.4.9-1.osg33.el7
condor-python-8.4.9-1.osg33.el7
condor-test-8.4.9-1.osg33.el7
condor-vm-gahp-8.4.9-1.osg33.el7
cvmfs-2.3.2-1.osg33.el7
cvmfs-config-osg-1.2-5.osg33.el7
cvmfs-devel-2.3.2-1.osg33.el7
cvmfs-server-2.3.2-1.osg33.el7
cvmfs-unittests-2.3.2-1.osg33.el7
cvmfs-x509-helper-0.9-1.osg33.el7
cvmfs-x509-helper-debuginfo-0.9-1.osg33.el7
frontier-squid-2.7.STABLE9-27.1.osg33.el7
frontier-squid-debuginfo-2.7.STABLE9-27.1.osg33.el7
globus-gatekeeper-10.10-1.2.osg33.el7
globus-gatekeeper-debuginfo-10.10-1.2.osg33.el7
gratia-probe-1.17.0-2.3.osg33.el7
gratia-probe-bdii-status-1.17.0-2.3.osg33.el7
gratia-probe-common-1.17.0-2.3.osg33.el7
gratia-probe-condor-1.17.0-2.3.osg33.el7
gratia-probe-condor-events-1.17.0-2.3.osg33.el7
gratia-probe-dcache-storage-1.17.0-2.3.osg33.el7
gratia-probe-dcache-storagegroup-1.17.0-2.3.osg33.el7
gratia-probe-dcache-transfer-1.17.0-2.3.osg33.el7
gratia-probe-debuginfo-1.17.0-2.3.osg33.el7
gratia-probe-enstore-storage-1.17.0-2.3.osg33.el7
gratia-probe-enstore-tapedrive-1.17.0-2.3.osg33.el7
gratia-probe-enstore-transfer-1.17.0-2.3.osg33.el7
gratia-probe-glexec-1.17.0-2.3.osg33.el7
gratia-probe-glideinwms-1.17.0-2.3.osg33.el7
gratia-probe-gram-1.17.0-2.3.osg33.el7
gratia-probe-gridftp-transfer-1.17.0-2.3.osg33.el7
gratia-probe-hadoop-storage-1.17.0-2.3.osg33.el7
gratia-probe-htcondor-ce-1.17.0-2.3.osg33.el7
gratia-probe-lsf-1.17.0-2.3.osg33.el7
gratia-probe-metric-1.17.0-2.3.osg33.el7
gratia-probe-onevm-1.17.0-2.3.osg33.el7
gratia-probe-pbs-lsf-1.17.0-2.3.osg33.el7
gratia-probe-services-1.17.0-2.3.osg33.el7
gratia-probe-sge-1.17.0-2.3.osg33.el7
gratia-probe-slurm-1.17.0-2.3.osg33.el7
gratia-probe-xrootd-storage-1.17.0-2.3.osg33.el7
gratia-probe-xrootd-transfer-1.17.0-2.3.osg33.el7
htcondor-ce-2.0.10-1.osg33.el7
htcondor-ce-bosco-2.0.10-1.osg33.el7
htcondor-ce-client-2.0.10-1.osg33.el7
htcondor-ce-collector-2.0.10-1.osg33.el7
htcondor-ce-condor-2.0.10-1.osg33.el7
htcondor-ce-lsf-2.0.10-1.osg33.el7
htcondor-ce-pbs-2.0.10-1.osg33.el7
htcondor-ce-sge-2.0.10-1.osg33.el7
htcondor-ce-view-2.0.10-1.osg33.el7
osg-control-1.1.0-1.osg33.el7
osg-gums-config-69-1.osg33.el7
osg-oasis-7-5.osg33.el7
osg-test-1.9.0-1.osg33.el7
osg-tested-internal-3.3-15.osg33.el7
osg-tested-internal-gram-3.3-15.osg33.el7
osg-version-3.3.17-1.osg33.el7
vo-client-69-1.osg33.el7
vo-client-edgmkgridmap-69-1.osg33.el7
xrootd-4.4.0-1.osg33.el7
xrootd-client-4.4.0-1.osg33.el7
xrootd-client-devel-4.4.0-1.osg33.el7
xrootd-client-libs-4.4.0-1.osg33.el7
xrootd-debuginfo-4.4.0-1.osg33.el7
xrootd-devel-4.4.0-1.osg33.el7
xrootd-doc-4.4.0-1.osg33.el7
xrootd-fuse-4.4.0-1.osg33.el7
xrootd-libs-4.4.0-1.osg33.el7
xrootd-private-devel-4.4.0-1.osg33.el7
xrootd-python-4.4.0-1.osg33.el7
xrootd-selinux-4.4.0-1.osg33.el7
xrootd-server-4.4.0-1.osg33.el7
xrootd-server-devel-4.4.0-1.osg33.el7
xrootd-server-libs-4.4.0-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.26.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.26.bosco-1.osgup.el6)
-   [condor-8.5.7-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.7-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.26.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.26.bosco-1.osgup.el7)
-   [condor-8.5.7-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.7-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-ec2 condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.26.bosco-1.osgup.el6
blahp-debuginfo-1.18.26.bosco-1.osgup.el6
condor-8.5.7-1.osgup.el6
condor-all-8.5.7-1.osgup.el6
condor-bosco-8.5.7-1.osgup.el6
condor-classads-8.5.7-1.osgup.el6
condor-classads-devel-8.5.7-1.osgup.el6
condor-cream-gahp-8.5.7-1.osgup.el6
condor-debuginfo-8.5.7-1.osgup.el6
condor-ec2-8.5.7-1.osgup.el6
condor-kbdd-8.5.7-1.osgup.el6
condor-procd-8.5.7-1.osgup.el6
condor-python-8.5.7-1.osgup.el6
condor-std-universe-8.5.7-1.osgup.el6
condor-test-8.5.7-1.osgup.el6
condor-vm-gahp-8.5.7-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.26.bosco-1.osgup.el7
blahp-debuginfo-1.18.26.bosco-1.osgup.el7
condor-8.5.7-1.osgup.el7
condor-all-8.5.7-1.osgup.el7
condor-bosco-8.5.7-1.osgup.el7
condor-classads-8.5.7-1.osgup.el7
condor-classads-devel-8.5.7-1.osgup.el7
condor-cream-gahp-8.5.7-1.osgup.el7
condor-debuginfo-8.5.7-1.osgup.el7
condor-ec2-8.5.7-1.osgup.el7
condor-kbdd-8.5.7-1.osgup.el7
condor-procd-8.5.7-1.osgup.el7
condor-python-8.5.7-1.osgup.el7
condor-test-8.5.7-1.osgup.el7
condor-vm-gahp-8.5.7-1.osgup.el7
```

