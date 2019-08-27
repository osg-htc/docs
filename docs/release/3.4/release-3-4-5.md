OSG Software Release 3.4.5
==========================

**Release Date**: 2017-11-14

Summary of changes
------------------

This release contains:

-   OSG PKI: Host Certificate requests and retrievals are authenticated by default
-   BLAHP 1.18.34
    -   Fixed bug in Slurm memory-use parsing that caused jobs to be held
    -   Fixed Unicode decode error when reading blah.config
-   HTCondor: Update from version 8.6.6
    -   [HTCondor 8.6.7](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00025.shtml)
    -   [HTCondor 8.6.8](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00027.shtml)
-   [XRootD 4.7.1](https://github.com/xrootd/xrootd/blob/v4.7.1/docs/ReleaseNotes.txt): Fixed occasional crash when LCMAPS callout to GUMS fails
-   [CVMFS 2.4.2](http://cvmfs.readthedocs.io/en/2.4/cpt-releasenotes.html): Server side bug fixes
-   GridFTP-HDFS: Added support for CMVFS checksums
-   Globus GridFTP server: Fixed IPv6 redirection and IPv4 passive mode (EPSV) response
-   LCMAPS VOMS Plugin: Documented how to map using all FQANs
-   RSV: Fixed CRL freshness probe, removed unused probes
-   osg-system-profiler: Dropped check for osg-version, stopped checking for deprecated software, updated instructions
-   Upcoming
    -   HTCondor: Update from version 8.7.3
        - [HTCondor 8.7.4](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00026.shtml)
        - [HTCondor 8.7.5](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00027.shtml)
    -   BLAHP 1.18.34 (See above)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.5%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found [here](/index.md).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details`. This warning can safely be ignored.
-   In GlideinWMS, a small configuration change must be added to account for changes in HTCondor 8.6. Add the following line to the HTCondor configuration.

        COLLECTOR.USE_SHARED_PORT=False

Updating to the new release
---------------------------

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

-   [blahp-1.18.34.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.34.bosco-1.osg34.el6)
-   [condor-8.6.8-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.8-1.osg34.el6)
-   [cvmfs-2.4.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.4.2-1.osg34.el6)
-   [glite-ce-cream-client-api-c-1.15.4-2.4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.4.osg34.el6)
-   [globus-ftp-client-8.36-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-8.36-1.2.osg34.el6)
-   [globus-gridftp-server-12.2-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.2-1.2.osg34.el6)
-   [globus-gridftp-server-control-6.0-2.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-6.0-2.1.osg34.el6)
-   [gratia-probe-1.18.2-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.18.2-2.osg34.el6)
-   [lcmaps-1.6.6-1.8.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.8.osg34.el6)
-   [lcmaps-plugins-voms-1.7.1-1.5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.5.osg34.el6)
-   [osg-configure-2.2.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.2-1.osg34.el6)
-   [osg-oasis-8-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-8-2.osg34.el6)
-   [osg-pki-tools-2.0.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-2.0.0-1.osg34.el6)
-   [osg-system-profiler-1.4.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.1-1.osg34.el6)
-   [osg-test-2.0.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.0.0-1.osg34.el6)
-   [osg-version-3.4.5-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.5-1.osg34.el6)
-   [rsv-3.16.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.16.0-1.osg34.el6)
-   [xrootd-4.7.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.7.1-1.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.34.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.34.bosco-1.osg34.el7)
-   [condor-8.6.8-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.8-1.osg34.el7)
-   [cvmfs-2.4.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.4.2-1.osg34.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.4.osg34.el7)
-   [globus-ftp-client-8.36-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-8.36-1.2.osg34.el7)
-   [globus-gridftp-server-12.2-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.2-1.2.osg34.el7)
-   [globus-gridftp-server-control-6.0-2.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-6.0-2.1.osg34.el7)
-   [gratia-probe-1.18.2-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.18.2-2.osg34.el7)
-   [lcmaps-1.6.6-1.8.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.8.osg34.el7)
-   [lcmaps-plugins-voms-1.7.1-1.5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.5.osg34.el7)
-   [osg-configure-2.2.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.2-1.osg34.el7)
-   [osg-oasis-8-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-8-2.osg34.el7)
-   [osg-pki-tools-2.0.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-2.0.0-1.osg34.el7)
-   [osg-system-profiler-1.4.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.1-1.osg34.el7)
-   [osg-test-2.0.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.0.0-1.osg34.el7)
-   [osg-version-3.4.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.5-1.osg34.el7)
-   [rsv-3.16.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.16.0-1.osg34.el7)
-   [xrootd-4.7.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.7.1-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-devel cvmfs-server cvmfs-unittests glite-ce-cream-client-api-c glite-ce-cream-client-devel globus-ftp-client globus-ftp-client-debuginfo globus-ftp-client-devel globus-ftp-client-doc globus-gridftp-server globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer igtf-ca-certs lcmaps lcmaps-common-devel lcmaps-db-templates lcmaps-debuginfo lcmaps-devel lcmaps-plugins-voms lcmaps-plugins-voms-debuginfo lcmaps-without-gsi lcmaps-without-gsi-devel osg-ca-certs osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gums-config osg-oasis osg-pki-tools osg-system-profiler osg-system-profiler-viewer osg-test osg-test-log-viewer osg-version rsv rsv-consumers rsv-core rsv-metrics vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.34.bosco-1.osg34.el6
blahp-debuginfo-1.18.34.bosco-1.osg34.el6
condor-8.6.8-1.osg34.el6
condor-all-8.6.8-1.osg34.el6
condor-bosco-8.6.8-1.osg34.el6
condor-classads-8.6.8-1.osg34.el6
condor-classads-devel-8.6.8-1.osg34.el6
condor-cream-gahp-8.6.8-1.osg34.el6
condor-debuginfo-8.6.8-1.osg34.el6
condor-kbdd-8.6.8-1.osg34.el6
condor-procd-8.6.8-1.osg34.el6
condor-python-8.6.8-1.osg34.el6
condor-std-universe-8.6.8-1.osg34.el6
condor-test-8.6.8-1.osg34.el6
condor-vm-gahp-8.6.8-1.osg34.el6
cvmfs-2.4.2-1.osg34.el6
cvmfs-devel-2.4.2-1.osg34.el6
cvmfs-server-2.4.2-1.osg34.el6
cvmfs-unittests-2.4.2-1.osg34.el6
glite-ce-cream-client-api-c-1.15.4-2.4.osg34.el6
glite-ce-cream-client-devel-1.15.4-2.4.osg34.el6
globus-ftp-client-8.36-1.2.osg34.el6
globus-ftp-client-debuginfo-8.36-1.2.osg34.el6
globus-ftp-client-devel-8.36-1.2.osg34.el6
globus-ftp-client-doc-8.36-1.2.osg34.el6
globus-gridftp-server-12.2-1.2.osg34.el6
globus-gridftp-server-control-6.0-2.1.osg34.el6
globus-gridftp-server-control-debuginfo-6.0-2.1.osg34.el6
globus-gridftp-server-control-devel-6.0-2.1.osg34.el6
globus-gridftp-server-debuginfo-12.2-1.2.osg34.el6
globus-gridftp-server-devel-12.2-1.2.osg34.el6
globus-gridftp-server-progs-12.2-1.2.osg34.el6
gratia-probe-1.18.2-2.osg34.el6
gratia-probe-common-1.18.2-2.osg34.el6
gratia-probe-condor-1.18.2-2.osg34.el6
gratia-probe-condor-events-1.18.2-2.osg34.el6
gratia-probe-dcache-storage-1.18.2-2.osg34.el6
gratia-probe-dcache-storagegroup-1.18.2-2.osg34.el6
gratia-probe-dcache-transfer-1.18.2-2.osg34.el6
gratia-probe-debuginfo-1.18.2-2.osg34.el6
gratia-probe-enstore-storage-1.18.2-2.osg34.el6
gratia-probe-enstore-tapedrive-1.18.2-2.osg34.el6
gratia-probe-enstore-transfer-1.18.2-2.osg34.el6
gratia-probe-glexec-1.18.2-2.osg34.el6
gratia-probe-glideinwms-1.18.2-2.osg34.el6
gratia-probe-gram-1.18.2-2.osg34.el6
gratia-probe-gridftp-transfer-1.18.2-2.osg34.el6
gratia-probe-hadoop-storage-1.18.2-2.osg34.el6
gratia-probe-htcondor-ce-1.18.2-2.osg34.el6
gratia-probe-lsf-1.18.2-2.osg34.el6
gratia-probe-metric-1.18.2-2.osg34.el6
gratia-probe-onevm-1.18.2-2.osg34.el6
gratia-probe-pbs-lsf-1.18.2-2.osg34.el6
gratia-probe-services-1.18.2-2.osg34.el6
gratia-probe-sge-1.18.2-2.osg34.el6
gratia-probe-slurm-1.18.2-2.osg34.el6
gratia-probe-xrootd-storage-1.18.2-2.osg34.el6
gratia-probe-xrootd-transfer-1.18.2-2.osg34.el6
lcmaps-1.6.6-1.8.osg34.el6
lcmaps-common-devel-1.6.6-1.8.osg34.el6
lcmaps-db-templates-1.6.6-1.8.osg34.el6
lcmaps-debuginfo-1.6.6-1.8.osg34.el6
lcmaps-devel-1.6.6-1.8.osg34.el6
lcmaps-plugins-voms-1.7.1-1.5.osg34.el6
lcmaps-plugins-voms-debuginfo-1.7.1-1.5.osg34.el6
lcmaps-without-gsi-1.6.6-1.8.osg34.el6
lcmaps-without-gsi-devel-1.6.6-1.8.osg34.el6
osg-configure-2.2.2-1.osg34.el6
osg-configure-bosco-2.2.2-1.osg34.el6
osg-configure-ce-2.2.2-1.osg34.el6
osg-configure-condor-2.2.2-1.osg34.el6
osg-configure-gateway-2.2.2-1.osg34.el6
osg-configure-gip-2.2.2-1.osg34.el6
osg-configure-gratia-2.2.2-1.osg34.el6
osg-configure-infoservices-2.2.2-1.osg34.el6
osg-configure-lsf-2.2.2-1.osg34.el6
osg-configure-managedfork-2.2.2-1.osg34.el6
osg-configure-misc-2.2.2-1.osg34.el6
osg-configure-network-2.2.2-1.osg34.el6
osg-configure-pbs-2.2.2-1.osg34.el6
osg-configure-rsv-2.2.2-1.osg34.el6
osg-configure-sge-2.2.2-1.osg34.el6
osg-configure-slurm-2.2.2-1.osg34.el6
osg-configure-squid-2.2.2-1.osg34.el6
osg-configure-tests-2.2.2-1.osg34.el6
osg-oasis-8-2.osg34.el6
osg-pki-tools-2.0.0-1.osg34.el6
osg-system-profiler-1.4.1-1.osg34.el6
osg-system-profiler-viewer-1.4.1-1.osg34.el6
osg-test-2.0.0-1.osg34.el6
osg-test-log-viewer-2.0.0-1.osg34.el6
osg-version-3.4.5-1.osg34.el6
rsv-3.16.0-1.osg34.el6
rsv-consumers-3.16.0-1.osg34.el6
rsv-core-3.16.0-1.osg34.el6
rsv-metrics-3.16.0-1.osg34.el6
xrootd-4.7.1-1.osg34.el6
xrootd-client-4.7.1-1.osg34.el6
xrootd-client-devel-4.7.1-1.osg34.el6
xrootd-client-libs-4.7.1-1.osg34.el6
xrootd-debuginfo-4.7.1-1.osg34.el6
xrootd-devel-4.7.1-1.osg34.el6
xrootd-doc-4.7.1-1.osg34.el6
xrootd-fuse-4.7.1-1.osg34.el6
xrootd-libs-4.7.1-1.osg34.el6
xrootd-private-devel-4.7.1-1.osg34.el6
xrootd-python-4.7.1-1.osg34.el6
xrootd-selinux-4.7.1-1.osg34.el6
xrootd-server-4.7.1-1.osg34.el6
xrootd-server-devel-4.7.1-1.osg34.el6
xrootd-server-libs-4.7.1-1.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.34.bosco-1.osg34.el7
blahp-debuginfo-1.18.34.bosco-1.osg34.el7
condor-8.6.8-1.osg34.el7
condor-all-8.6.8-1.osg34.el7
condor-bosco-8.6.8-1.osg34.el7
condor-classads-8.6.8-1.osg34.el7
condor-classads-devel-8.6.8-1.osg34.el7
condor-cream-gahp-8.6.8-1.osg34.el7
condor-debuginfo-8.6.8-1.osg34.el7
condor-kbdd-8.6.8-1.osg34.el7
condor-procd-8.6.8-1.osg34.el7
condor-python-8.6.8-1.osg34.el7
condor-test-8.6.8-1.osg34.el7
condor-vm-gahp-8.6.8-1.osg34.el7
cvmfs-2.4.2-1.osg34.el7
cvmfs-devel-2.4.2-1.osg34.el7
cvmfs-server-2.4.2-1.osg34.el7
cvmfs-unittests-2.4.2-1.osg34.el7
glite-ce-cream-client-api-c-1.15.4-2.4.osg34.el7
glite-ce-cream-client-devel-1.15.4-2.4.osg34.el7
globus-ftp-client-8.36-1.2.osg34.el7
globus-ftp-client-debuginfo-8.36-1.2.osg34.el7
globus-ftp-client-devel-8.36-1.2.osg34.el7
globus-ftp-client-doc-8.36-1.2.osg34.el7
globus-gridftp-server-12.2-1.2.osg34.el7
globus-gridftp-server-control-6.0-2.1.osg34.el7
globus-gridftp-server-control-debuginfo-6.0-2.1.osg34.el7
globus-gridftp-server-control-devel-6.0-2.1.osg34.el7
globus-gridftp-server-debuginfo-12.2-1.2.osg34.el7
globus-gridftp-server-devel-12.2-1.2.osg34.el7
globus-gridftp-server-progs-12.2-1.2.osg34.el7
gratia-probe-1.18.2-2.osg34.el7
gratia-probe-common-1.18.2-2.osg34.el7
gratia-probe-condor-1.18.2-2.osg34.el7
gratia-probe-condor-events-1.18.2-2.osg34.el7
gratia-probe-dcache-storage-1.18.2-2.osg34.el7
gratia-probe-dcache-storagegroup-1.18.2-2.osg34.el7
gratia-probe-dcache-transfer-1.18.2-2.osg34.el7
gratia-probe-debuginfo-1.18.2-2.osg34.el7
gratia-probe-enstore-storage-1.18.2-2.osg34.el7
gratia-probe-enstore-tapedrive-1.18.2-2.osg34.el7
gratia-probe-enstore-transfer-1.18.2-2.osg34.el7
gratia-probe-glexec-1.18.2-2.osg34.el7
gratia-probe-glideinwms-1.18.2-2.osg34.el7
gratia-probe-gram-1.18.2-2.osg34.el7
gratia-probe-gridftp-transfer-1.18.2-2.osg34.el7
gratia-probe-hadoop-storage-1.18.2-2.osg34.el7
gratia-probe-htcondor-ce-1.18.2-2.osg34.el7
gratia-probe-lsf-1.18.2-2.osg34.el7
gratia-probe-metric-1.18.2-2.osg34.el7
gratia-probe-onevm-1.18.2-2.osg34.el7
gratia-probe-pbs-lsf-1.18.2-2.osg34.el7
gratia-probe-services-1.18.2-2.osg34.el7
gratia-probe-sge-1.18.2-2.osg34.el7
gratia-probe-slurm-1.18.2-2.osg34.el7
gratia-probe-xrootd-storage-1.18.2-2.osg34.el7
gratia-probe-xrootd-transfer-1.18.2-2.osg34.el7
lcmaps-1.6.6-1.8.osg34.el7
lcmaps-common-devel-1.6.6-1.8.osg34.el7
lcmaps-db-templates-1.6.6-1.8.osg34.el7
lcmaps-debuginfo-1.6.6-1.8.osg34.el7
lcmaps-devel-1.6.6-1.8.osg34.el7
lcmaps-plugins-voms-1.7.1-1.5.osg34.el7
lcmaps-plugins-voms-debuginfo-1.7.1-1.5.osg34.el7
lcmaps-without-gsi-1.6.6-1.8.osg34.el7
lcmaps-without-gsi-devel-1.6.6-1.8.osg34.el7
osg-configure-2.2.2-1.osg34.el7
osg-configure-bosco-2.2.2-1.osg34.el7
osg-configure-ce-2.2.2-1.osg34.el7
osg-configure-condor-2.2.2-1.osg34.el7
osg-configure-gateway-2.2.2-1.osg34.el7
osg-configure-gip-2.2.2-1.osg34.el7
osg-configure-gratia-2.2.2-1.osg34.el7
osg-configure-infoservices-2.2.2-1.osg34.el7
osg-configure-lsf-2.2.2-1.osg34.el7
osg-configure-managedfork-2.2.2-1.osg34.el7
osg-configure-misc-2.2.2-1.osg34.el7
osg-configure-network-2.2.2-1.osg34.el7
osg-configure-pbs-2.2.2-1.osg34.el7
osg-configure-rsv-2.2.2-1.osg34.el7
osg-configure-sge-2.2.2-1.osg34.el7
osg-configure-slurm-2.2.2-1.osg34.el7
osg-configure-squid-2.2.2-1.osg34.el7
osg-configure-tests-2.2.2-1.osg34.el7
osg-oasis-8-2.osg34.el7
osg-pki-tools-2.0.0-1.osg34.el7
osg-system-profiler-1.4.1-1.osg34.el7
osg-system-profiler-viewer-1.4.1-1.osg34.el7
osg-test-2.0.0-1.osg34.el7
osg-test-log-viewer-2.0.0-1.osg34.el7
osg-version-3.4.5-1.osg34.el7
rsv-3.16.0-1.osg34.el7
rsv-consumers-3.16.0-1.osg34.el7
rsv-core-3.16.0-1.osg34.el7
rsv-metrics-3.16.0-1.osg34.el7
xrootd-4.7.1-1.osg34.el7
xrootd-client-4.7.1-1.osg34.el7
xrootd-client-devel-4.7.1-1.osg34.el7
xrootd-client-libs-4.7.1-1.osg34.el7
xrootd-debuginfo-4.7.1-1.osg34.el7
xrootd-devel-4.7.1-1.osg34.el7
xrootd-doc-4.7.1-1.osg34.el7
xrootd-fuse-4.7.1-1.osg34.el7
xrootd-libs-4.7.1-1.osg34.el7
xrootd-private-devel-4.7.1-1.osg34.el7
xrootd-python-4.7.1-1.osg34.el7
xrootd-selinux-4.7.1-1.osg34.el7
xrootd-server-4.7.1-1.osg34.el7
xrootd-server-devel-4.7.1-1.osg34.el7
xrootd-server-libs-4.7.1-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.34.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.34.bosco-1.osgup.el6)
-   [condor-8.7.5-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.5-1.osgup.el6)
-   [glite-ce-cream-client-api-c-1.15.4-2.5.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.5.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.34.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.34.bosco-1.osgup.el7)
-   [condor-8.7.5-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.5-1.osgup.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.5.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.5.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp glite-ce-cream-client-api-c glite-ce-cream-client-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.34.bosco-1.osgup.el6
blahp-debuginfo-1.18.34.bosco-1.osgup.el6
condor-8.7.5-1.osgup.el6
condor-all-8.7.5-1.osgup.el6
condor-annex-ec2-8.7.5-1.osgup.el6
condor-bosco-8.7.5-1.osgup.el6
condor-classads-8.7.5-1.osgup.el6
condor-classads-devel-8.7.5-1.osgup.el6
condor-cream-gahp-8.7.5-1.osgup.el6
condor-debuginfo-8.7.5-1.osgup.el6
condor-kbdd-8.7.5-1.osgup.el6
condor-procd-8.7.5-1.osgup.el6
condor-python-8.7.5-1.osgup.el6
condor-std-universe-8.7.5-1.osgup.el6
condor-test-8.7.5-1.osgup.el6
condor-vm-gahp-8.7.5-1.osgup.el6
glite-ce-cream-client-api-c-1.15.4-2.5.osgup.el6
glite-ce-cream-client-devel-1.15.4-2.5.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.34.bosco-1.osgup.el7
blahp-debuginfo-1.18.34.bosco-1.osgup.el7
condor-8.7.5-1.osgup.el7
condor-all-8.7.5-1.osgup.el7
condor-annex-ec2-8.7.5-1.osgup.el7
condor-bosco-8.7.5-1.osgup.el7
condor-classads-8.7.5-1.osgup.el7
condor-classads-devel-8.7.5-1.osgup.el7
condor-cream-gahp-8.7.5-1.osgup.el7
condor-debuginfo-8.7.5-1.osgup.el7
condor-kbdd-8.7.5-1.osgup.el7
condor-procd-8.7.5-1.osgup.el7
condor-python-8.7.5-1.osgup.el7
condor-test-8.7.5-1.osgup.el7
condor-vm-gahp-8.7.5-1.osgup.el7
glite-ce-cream-client-api-c-1.15.4-2.5.osgup.el7
glite-ce-cream-client-devel-1.15.4-2.5.osgup.el7
```

