OSG Software Release 3.4.1
==========================

**Release Date**: 2017-07-12

Summary of changes
------------------

This release contains:

-   Bug fix in LCMAPS plugin that could cause the HTCondor-CE schedd to crash
-   osg-configure uses the new GUMS JSON interface
-   The BLAHP properly requests multi-core resources for Slurm batch systems
-   HTCondor-CE 2.2.1
    -   Fixed memory requirement requests to non-HTCondor batch systems
    -   Correct CPU allocation for whole node jobs
-   Gratia probes
    -   support whole node jobs
    -   can include arbitrary ClassAd attributes in Gratia usage records
-   Bug fix to CVMFS client to able to mount when large groups exist
-   GridFTP server now uses correct configuration with a dsi plugin
-   gridftp-dsi-posix replaces the xrootd-dsi plugin
    -   any local changes made to `/etc/sysconfig/xrootd-dsi` should be transferred over to `/etc/sysconfig/gridftp-dsi-posix`
-   Enhanced gridftp-dsi-posix
    -   Added MD5 checksum
    -   Added GRIDFTP\_APPEND\_XROOTD\_CGI hook to support XRootD space tokens
-   [HTCondor 8.6.4](https://lists.cs.wisc.edu/archive/htcondor-world/2017/msg00019.shtml): BOSCO now works without CA certificates on remote cluster
-   [HTCondor 8.7.2](https://lists.cs.wisc.edu/archive/htcondor-world/2017/msg00020.shtml): introducing the 8.7 series in the upcoming repository
-   RSV
    -   replace software.grid.iu.edu with repo.grid.iu.edu
    -   parse condor\_cron condor\_q output properly
-   osg-gridftp now pulls in osg-configure-misc
-   condor\_cron: eliminate email on restart
-   Internal tools
    -   osg-build update
    -   Drop unused tests from osg-test

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.1%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

<span class="twiki-macro NOTE"></span> OSG 3.4 contains only 64-bit components. <span class="twiki-macro NOTE"></span> StashCache is supported on EL7 only. <span class="twiki-macro NOTE"></span> xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details.`. This warning can safely be ignored.
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the August release.
-   In GlideinWMS, a small configuration change must be added to account for changes in HTCondor 8.6. Add the following line to the HTCondor configuration.

``` file
COLLECTOR.USE_SHARED_PORT=False
```

Updating to the new release
---------------------------

To update to the OSG 3.4 series, please consult the page on [updating between release series](../release_series).

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

<span class="twiki-macro NOTE"></span> Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

<span class="twiki-macro NOTE"></span> Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.30.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.30.bosco-1.osg34.el6)
-   [condor-8.6.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.4-1.osg34.el6)
-   [condor-cron-1.1.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.2-1.osg34.el6)
-   [cvmfs-2.3.5-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.3.5-1.1.osg34.el6)
-   [globus-gridftp-server-11.8-1.3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-11.8-1.3.osg34.el6)
-   [gratia-probe-1.18.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.18.1-1.osg34.el6)
-   [gridftp-dsi-posix-1.4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-dsi-posix-1.4-2.osg34.el6)
-   [htcondor-ce-2.2.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.1-1.osg34.el6)
-   [lcmaps-plugins-verify-proxy-1.5.9-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.9-1.2.osg34.el6)
-   [osg-build-1.10.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.1-1.osg34.el6)
-   [osg-configure-2.1.0-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.1.0-2.osg34.el6)
-   [osg-gridftp-3.4-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-3.osg34.el6)
-   [osg-test-1.11.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.0-1.osg34.el6)
-   [osg-version-3.4.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.1-1.osg34.el6)
-   [rsv-3.14.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.14.2-1.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.30.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.30.bosco-1.osg34.el7)
-   [condor-8.6.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.4-1.osg34.el7)
-   [condor-cron-1.1.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.2-1.osg34.el7)
-   [cvmfs-2.3.5-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.3.5-1.1.osg34.el7)
-   [globus-gridftp-server-11.8-1.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-11.8-1.3.osg34.el7)
-   [gratia-probe-1.18.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.18.1-1.osg34.el7)
-   [gridftp-dsi-posix-1.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-dsi-posix-1.4-2.osg34.el7)
-   [htcondor-ce-2.2.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.1-1.osg34.el7)
-   [lcmaps-plugins-verify-proxy-1.5.9-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.9-1.2.osg34.el7)
-   [osg-build-1.10.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.1-1.osg34.el7)
-   [osg-configure-2.1.0-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.1.0-2.osg34.el7)
-   [osg-gridftp-3.4-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-3.osg34.el7)
-   [osg-test-1.11.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.0-1.osg34.el7)
-   [osg-version-3.4.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.1-1.osg34.el7)
-   [rsv-3.14.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.14.2-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-cron condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-devel cvmfs-server cvmfs-unittests globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer gridftp-dsi-posix gridftp-dsi-posix-debuginfo htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs lcmaps-plugins-verify-proxy lcmaps-plugins-verify-proxy-debuginfo osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-ca-certs osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gridftp osg-test osg-test-log-viewer osg-version rsv rsv-consumers rsv-core rsv-metrics

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.30.bosco-1.osg34.el6
blahp-debuginfo-1.18.30.bosco-1.osg34.el6
condor-8.6.4-1.osg34.el6
condor-all-8.6.4-1.osg34.el6
condor-bosco-8.6.4-1.osg34.el6
condor-classads-8.6.4-1.osg34.el6
condor-classads-devel-8.6.4-1.osg34.el6
condor-cream-gahp-8.6.4-1.osg34.el6
condor-cron-1.1.2-1.osg34.el6
condor-debuginfo-8.6.4-1.osg34.el6
condor-kbdd-8.6.4-1.osg34.el6
condor-procd-8.6.4-1.osg34.el6
condor-python-8.6.4-1.osg34.el6
condor-std-universe-8.6.4-1.osg34.el6
condor-test-8.6.4-1.osg34.el6
condor-vm-gahp-8.6.4-1.osg34.el6
cvmfs-2.3.5-1.1.osg34.el6
cvmfs-devel-2.3.5-1.1.osg34.el6
cvmfs-server-2.3.5-1.1.osg34.el6
cvmfs-unittests-2.3.5-1.1.osg34.el6
globus-gridftp-server-11.8-1.3.osg34.el6
globus-gridftp-server-debuginfo-11.8-1.3.osg34.el6
globus-gridftp-server-devel-11.8-1.3.osg34.el6
globus-gridftp-server-progs-11.8-1.3.osg34.el6
gratia-probe-1.18.1-1.osg34.el6
gratia-probe-bdii-status-1.18.1-1.osg34.el6
gratia-probe-common-1.18.1-1.osg34.el6
gratia-probe-condor-1.18.1-1.osg34.el6
gratia-probe-condor-events-1.18.1-1.osg34.el6
gratia-probe-dcache-storage-1.18.1-1.osg34.el6
gratia-probe-dcache-storagegroup-1.18.1-1.osg34.el6
gratia-probe-dcache-transfer-1.18.1-1.osg34.el6
gratia-probe-debuginfo-1.18.1-1.osg34.el6
gratia-probe-enstore-storage-1.18.1-1.osg34.el6
gratia-probe-enstore-tapedrive-1.18.1-1.osg34.el6
gratia-probe-enstore-transfer-1.18.1-1.osg34.el6
gratia-probe-glexec-1.18.1-1.osg34.el6
gratia-probe-glideinwms-1.18.1-1.osg34.el6
gratia-probe-gram-1.18.1-1.osg34.el6
gratia-probe-gridftp-transfer-1.18.1-1.osg34.el6
gratia-probe-hadoop-storage-1.18.1-1.osg34.el6
gratia-probe-htcondor-ce-1.18.1-1.osg34.el6
gratia-probe-lsf-1.18.1-1.osg34.el6
gratia-probe-metric-1.18.1-1.osg34.el6
gratia-probe-onevm-1.18.1-1.osg34.el6
gratia-probe-pbs-lsf-1.18.1-1.osg34.el6
gratia-probe-services-1.18.1-1.osg34.el6
gratia-probe-sge-1.18.1-1.osg34.el6
gratia-probe-slurm-1.18.1-1.osg34.el6
gratia-probe-xrootd-storage-1.18.1-1.osg34.el6
gratia-probe-xrootd-transfer-1.18.1-1.osg34.el6
gridftp-dsi-posix-1.4-2.osg34.el6
gridftp-dsi-posix-debuginfo-1.4-2.osg34.el6
htcondor-ce-2.2.1-1.osg34.el6
htcondor-ce-bosco-2.2.1-1.osg34.el6
htcondor-ce-client-2.2.1-1.osg34.el6
htcondor-ce-collector-2.2.1-1.osg34.el6
htcondor-ce-condor-2.2.1-1.osg34.el6
htcondor-ce-lsf-2.2.1-1.osg34.el6
htcondor-ce-pbs-2.2.1-1.osg34.el6
htcondor-ce-sge-2.2.1-1.osg34.el6
htcondor-ce-slurm-2.2.1-1.osg34.el6
htcondor-ce-view-2.2.1-1.osg34.el6
lcmaps-plugins-verify-proxy-1.5.9-1.2.osg34.el6
lcmaps-plugins-verify-proxy-debuginfo-1.5.9-1.2.osg34.el6
osg-build-1.10.1-1.osg34.el6
osg-build-base-1.10.1-1.osg34.el6
osg-build-koji-1.10.1-1.osg34.el6
osg-build-mock-1.10.1-1.osg34.el6
osg-build-tests-1.10.1-1.osg34.el6
osg-configure-2.1.0-2.osg34.el6
osg-configure-bosco-2.1.0-2.osg34.el6
osg-configure-ce-2.1.0-2.osg34.el6
osg-configure-condor-2.1.0-2.osg34.el6
osg-configure-gateway-2.1.0-2.osg34.el6
osg-configure-gip-2.1.0-2.osg34.el6
osg-configure-gratia-2.1.0-2.osg34.el6
osg-configure-infoservices-2.1.0-2.osg34.el6
osg-configure-lsf-2.1.0-2.osg34.el6
osg-configure-managedfork-2.1.0-2.osg34.el6
osg-configure-misc-2.1.0-2.osg34.el6
osg-configure-network-2.1.0-2.osg34.el6
osg-configure-pbs-2.1.0-2.osg34.el6
osg-configure-rsv-2.1.0-2.osg34.el6
osg-configure-sge-2.1.0-2.osg34.el6
osg-configure-slurm-2.1.0-2.osg34.el6
osg-configure-squid-2.1.0-2.osg34.el6
osg-configure-tests-2.1.0-2.osg34.el6
osg-gridftp-3.4-3.osg34.el6
osg-test-1.11.0-1.osg34.el6
osg-test-log-viewer-1.11.0-1.osg34.el6
osg-version-3.4.1-1.osg34.el6
rsv-3.14.2-1.osg34.el6
rsv-consumers-3.14.2-1.osg34.el6
rsv-core-3.14.2-1.osg34.el6
rsv-metrics-3.14.2-1.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.30.bosco-1.osg34.el7
blahp-debuginfo-1.18.30.bosco-1.osg34.el7
condor-8.6.4-1.osg34.el7
condor-all-8.6.4-1.osg34.el7
condor-bosco-8.6.4-1.osg34.el7
condor-classads-8.6.4-1.osg34.el7
condor-classads-devel-8.6.4-1.osg34.el7
condor-cream-gahp-8.6.4-1.osg34.el7
condor-cron-1.1.2-1.osg34.el7
condor-debuginfo-8.6.4-1.osg34.el7
condor-kbdd-8.6.4-1.osg34.el7
condor-procd-8.6.4-1.osg34.el7
condor-python-8.6.4-1.osg34.el7
condor-test-8.6.4-1.osg34.el7
condor-vm-gahp-8.6.4-1.osg34.el7
cvmfs-2.3.5-1.1.osg34.el7
cvmfs-devel-2.3.5-1.1.osg34.el7
cvmfs-server-2.3.5-1.1.osg34.el7
cvmfs-unittests-2.3.5-1.1.osg34.el7
globus-gridftp-server-11.8-1.3.osg34.el7
globus-gridftp-server-debuginfo-11.8-1.3.osg34.el7
globus-gridftp-server-devel-11.8-1.3.osg34.el7
globus-gridftp-server-progs-11.8-1.3.osg34.el7
gratia-probe-1.18.1-1.osg34.el7
gratia-probe-bdii-status-1.18.1-1.osg34.el7
gratia-probe-common-1.18.1-1.osg34.el7
gratia-probe-condor-1.18.1-1.osg34.el7
gratia-probe-condor-events-1.18.1-1.osg34.el7
gratia-probe-dcache-storage-1.18.1-1.osg34.el7
gratia-probe-dcache-storagegroup-1.18.1-1.osg34.el7
gratia-probe-dcache-transfer-1.18.1-1.osg34.el7
gratia-probe-debuginfo-1.18.1-1.osg34.el7
gratia-probe-enstore-storage-1.18.1-1.osg34.el7
gratia-probe-enstore-tapedrive-1.18.1-1.osg34.el7
gratia-probe-enstore-transfer-1.18.1-1.osg34.el7
gratia-probe-glexec-1.18.1-1.osg34.el7
gratia-probe-glideinwms-1.18.1-1.osg34.el7
gratia-probe-gram-1.18.1-1.osg34.el7
gratia-probe-gridftp-transfer-1.18.1-1.osg34.el7
gratia-probe-hadoop-storage-1.18.1-1.osg34.el7
gratia-probe-htcondor-ce-1.18.1-1.osg34.el7
gratia-probe-lsf-1.18.1-1.osg34.el7
gratia-probe-metric-1.18.1-1.osg34.el7
gratia-probe-onevm-1.18.1-1.osg34.el7
gratia-probe-pbs-lsf-1.18.1-1.osg34.el7
gratia-probe-services-1.18.1-1.osg34.el7
gratia-probe-sge-1.18.1-1.osg34.el7
gratia-probe-slurm-1.18.1-1.osg34.el7
gratia-probe-xrootd-storage-1.18.1-1.osg34.el7
gratia-probe-xrootd-transfer-1.18.1-1.osg34.el7
gridftp-dsi-posix-1.4-2.osg34.el7
gridftp-dsi-posix-debuginfo-1.4-2.osg34.el7
htcondor-ce-2.2.1-1.osg34.el7
htcondor-ce-bosco-2.2.1-1.osg34.el7
htcondor-ce-client-2.2.1-1.osg34.el7
htcondor-ce-collector-2.2.1-1.osg34.el7
htcondor-ce-condor-2.2.1-1.osg34.el7
htcondor-ce-lsf-2.2.1-1.osg34.el7
htcondor-ce-pbs-2.2.1-1.osg34.el7
htcondor-ce-sge-2.2.1-1.osg34.el7
htcondor-ce-slurm-2.2.1-1.osg34.el7
htcondor-ce-view-2.2.1-1.osg34.el7
lcmaps-plugins-verify-proxy-1.5.9-1.2.osg34.el7
lcmaps-plugins-verify-proxy-debuginfo-1.5.9-1.2.osg34.el7
osg-build-1.10.1-1.osg34.el7
osg-build-base-1.10.1-1.osg34.el7
osg-build-koji-1.10.1-1.osg34.el7
osg-build-mock-1.10.1-1.osg34.el7
osg-build-tests-1.10.1-1.osg34.el7
osg-configure-2.1.0-2.osg34.el7
osg-configure-bosco-2.1.0-2.osg34.el7
osg-configure-ce-2.1.0-2.osg34.el7
osg-configure-condor-2.1.0-2.osg34.el7
osg-configure-gateway-2.1.0-2.osg34.el7
osg-configure-gip-2.1.0-2.osg34.el7
osg-configure-gratia-2.1.0-2.osg34.el7
osg-configure-infoservices-2.1.0-2.osg34.el7
osg-configure-lsf-2.1.0-2.osg34.el7
osg-configure-managedfork-2.1.0-2.osg34.el7
osg-configure-misc-2.1.0-2.osg34.el7
osg-configure-network-2.1.0-2.osg34.el7
osg-configure-pbs-2.1.0-2.osg34.el7
osg-configure-rsv-2.1.0-2.osg34.el7
osg-configure-sge-2.1.0-2.osg34.el7
osg-configure-slurm-2.1.0-2.osg34.el7
osg-configure-squid-2.1.0-2.osg34.el7
osg-configure-tests-2.1.0-2.osg34.el7
osg-gridftp-3.4-3.osg34.el7
osg-test-1.11.0-1.osg34.el7
osg-test-log-viewer-1.11.0-1.osg34.el7
osg-version-3.4.1-1.osg34.el7
rsv-3.14.2-1.osg34.el7
rsv-consumers-3.14.2-1.osg34.el7
rsv-core-3.14.2-1.osg34.el7
rsv-metrics-3.14.2-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.30.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.30.bosco-1.osgup.el6)
-   [condor-8.7.2-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.2-1.osgup.el6)
-   [glite-ce-cream-client-api-c-1.15.4-2.4.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.4.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.30.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.30.bosco-1.osgup.el7)
-   [condor-8.7.2-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.2-1.osgup.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.4.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.4.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone glite-ce-cream-client-api-c glite-ce-cream-client-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.30.bosco-1.osgup.el6
blahp-debuginfo-1.18.30.bosco-1.osgup.el6
condor-8.7.2-1.osgup.el6
condor-all-8.7.2-1.osgup.el6
condor-annex-ec2-8.7.2-1.osgup.el6
condor-bosco-8.7.2-1.osgup.el6
condor-classads-8.7.2-1.osgup.el6
condor-classads-devel-8.7.2-1.osgup.el6
condor-cream-gahp-8.7.2-1.osgup.el6
condor-debuginfo-8.7.2-1.osgup.el6
condor-kbdd-8.7.2-1.osgup.el6
condor-procd-8.7.2-1.osgup.el6
condor-python-8.7.2-1.osgup.el6
condor-std-universe-8.7.2-1.osgup.el6
condor-test-8.7.2-1.osgup.el6
condor-vm-gahp-8.7.2-1.osgup.el6
glite-ce-cream-client-api-c-1.15.4-2.4.osgup.el6
glite-ce-cream-client-devel-1.15.4-2.4.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.30.bosco-1.osgup.el7
blahp-debuginfo-1.18.30.bosco-1.osgup.el7
condor-8.7.2-1.osgup.el7
condor-all-8.7.2-1.osgup.el7
condor-annex-ec2-8.7.2-1.osgup.el7
condor-bosco-8.7.2-1.osgup.el7
condor-classads-8.7.2-1.osgup.el7
condor-classads-devel-8.7.2-1.osgup.el7
condor-cream-gahp-8.7.2-1.osgup.el7
condor-debuginfo-8.7.2-1.osgup.el7
condor-kbdd-8.7.2-1.osgup.el7
condor-procd-8.7.2-1.osgup.el7
condor-python-8.7.2-1.osgup.el7
condor-test-8.7.2-1.osgup.el7
condor-vm-gahp-8.7.2-1.osgup.el7
glite-ce-cream-client-api-c-1.15.4-2.4.osgup.el7
glite-ce-cream-client-devel-1.15.4-2.4.osgup.el7
```

