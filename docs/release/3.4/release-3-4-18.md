OSG Software Release 3.4.18
===========================

**Release Date**: 2018-09-27

Summary of changes
------------------

This release contains:

-   OSG 3.4 Repository
    -   XRootD: Patches to the XrdHttp implementation, particularly relevant for StashCache
    -   [xrootd-lcmaps 1.4.1](https://github.com/opensciencegrid/xrootd-lcmaps/releases/tag/v1.4.1): Fixed crash when using both HTTP and XRootD protocols
    -   [xrootd-hdfs 2.1.3](https://github.com/opensciencegrid/xrootd-hdfs/releases): Fixed two checksum handlings bugs (Update from 2.0.2)
    -   [HTCondor-CE 3.1.4](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v3.1.4)
        -   `condor_ce_trace` now works with a mix of EL6 and EL7 hosts
        -   `condor_ce_q` now shows jobs for all users
        -   Russian Data Intensive Grid (RDIG) CEs now report to the central collector
        -   Creates all required directories at installation time
    -   [CernVM-FS 2.5.1](https://cvmfs.readthedocs.io/en/2.5/cpt-releasenotes.html): Bug fixes and improvement for clients and servers
    -   Gratia probes 1.20.7
        -   Handles Unicode characters properly
        -   Unhandled exceptions in the Slurm probe are now logged
    -   [Pegasus 4.8.4](https://pegasus.isi.edu/2018/08/31/pegasus-4-8-4-released/): Pegasus workflows should now appear in Gracc
    -   Updated Globus Packages from EPEL (globus-gridftp-server and globus-gridftp-server-control)
    -   [GlideinWMS 3.4](http://glideinwms.fnal.gov/doc.v3_4/history.html): Moved from the Upcoming Repository
    -   [RSV 3.19.8](https://github.com/opensciencegrid/rsv/releases/tag/v3.19.8): Fixed persistent warning about the Gracc server being down
    -   [BLAHP 1.18.38](https://github.com/osg-bosco/BLAH/releases/tag/v1.18.38.bosco): Updated default worker node configuration with respect to proxy renewals
-   Upcoming Repository
    -   [BLAHP 1.18.38](https://github.com/osg-bosco/BLAH/releases/tag/v1.18.38.bosco): Updated default worker node configuration with respect to proxy renewals

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.18%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

-   [blahp-1.18.38.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.38.bosco-1.osg34.el6)
-   [cvmfs-2.5.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.5.1-1.osg34.el6)
-   [glideinwms-3.4-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4-1.1.osg34.el6)
-   [globus-gridftp-server-12.9-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.9-1.1.osg34.el6)
-   [globus-gridftp-server-control-7.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-7.0-1.osg34.el6)
-   [gratia-probe-1.20.7-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.7-1.osg34.el6)
-   [htcondor-ce-3.1.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.1.4-1.osg34.el6)
-   [osg-oasis-10-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-10-1.osg34.el6)
-   [osg-version-3.4.18-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.18-1.osg34.el6)
-   [pegasus-4.8.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.8.4-1.osg34.el6)
-   [rsv-3.19.8-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.19.8-1.osg34.el6)
-   [xrootd-4.8.4-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.4-3.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.38.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.38.bosco-1.osg34.el7)
-   [cvmfs-2.5.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.5.1-1.osg34.el7)
-   [glideinwms-3.4-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4-1.1.osg34.el7)
-   [globus-gridftp-server-12.9-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.9-1.1.osg34.el7)
-   [globus-gridftp-server-control-7.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-7.0-1.osg34.el7)
-   [gratia-probe-1.20.7-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.7-1.osg34.el7)
-   [htcondor-ce-3.1.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.1.4-1.osg34.el7)
-   [osg-oasis-10-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-10-1.osg34.el7)
-   [osg-version-3.4.18-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.18-1.osg34.el7)
-   [pegasus-4.8.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.8.4-1.osg34.el7)
-   [rsv-3.19.8-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.19.8-1.osg34.el7)
-   [xrootd-4.8.4-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.4-3.osg34.el7)
-   [xrootd-hdfs-2.1.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.3-1.osg34.el7)
-   [xrootd-lcmaps-1.4.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.4.1-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo cvmfs cvmfs-devel cvmfs-server cvmfs-unittests glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone globus-gridftp-server globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs osg-ca-certs osg-gums-config osg-oasis osg-version pegasus pegasus-debuginfo python2-xrootd python3-xrootd rsv rsv-consumers rsv-core rsv-metrics vo-client vo-client-dcache vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.38.bosco-1.osg34.el6
blahp-debuginfo-1.18.38.bosco-1.osg34.el6
cvmfs-2.5.1-1.osg34.el6
cvmfs-devel-2.5.1-1.osg34.el6
cvmfs-server-2.5.1-1.osg34.el6
cvmfs-unittests-2.5.1-1.osg34.el6
glideinwms-3.4-1.1.osg34.el6
glideinwms-common-tools-3.4-1.1.osg34.el6
glideinwms-condor-common-config-3.4-1.1.osg34.el6
glideinwms-factory-3.4-1.1.osg34.el6
glideinwms-factory-condor-3.4-1.1.osg34.el6
glideinwms-glidecondor-tools-3.4-1.1.osg34.el6
glideinwms-libs-3.4-1.1.osg34.el6
glideinwms-minimal-condor-3.4-1.1.osg34.el6
glideinwms-usercollector-3.4-1.1.osg34.el6
glideinwms-userschedd-3.4-1.1.osg34.el6
glideinwms-vofrontend-3.4-1.1.osg34.el6
glideinwms-vofrontend-standalone-3.4-1.1.osg34.el6
globus-gridftp-server-12.9-1.1.osg34.el6
globus-gridftp-server-control-7.0-1.osg34.el6
globus-gridftp-server-control-debuginfo-7.0-1.osg34.el6
globus-gridftp-server-control-devel-7.0-1.osg34.el6
globus-gridftp-server-debuginfo-12.9-1.1.osg34.el6
globus-gridftp-server-devel-12.9-1.1.osg34.el6
globus-gridftp-server-progs-12.9-1.1.osg34.el6
gratia-probe-1.20.7-1.osg34.el6
gratia-probe-common-1.20.7-1.osg34.el6
gratia-probe-condor-1.20.7-1.osg34.el6
gratia-probe-condor-events-1.20.7-1.osg34.el6
gratia-probe-dcache-storage-1.20.7-1.osg34.el6
gratia-probe-dcache-storagegroup-1.20.7-1.osg34.el6
gratia-probe-dcache-transfer-1.20.7-1.osg34.el6
gratia-probe-debuginfo-1.20.7-1.osg34.el6
gratia-probe-enstore-storage-1.20.7-1.osg34.el6
gratia-probe-enstore-tapedrive-1.20.7-1.osg34.el6
gratia-probe-enstore-transfer-1.20.7-1.osg34.el6
gratia-probe-glideinwms-1.20.7-1.osg34.el6
gratia-probe-gridftp-transfer-1.20.7-1.osg34.el6
gratia-probe-hadoop-storage-1.20.7-1.osg34.el6
gratia-probe-htcondor-ce-1.20.7-1.osg34.el6
gratia-probe-lsf-1.20.7-1.osg34.el6
gratia-probe-metric-1.20.7-1.osg34.el6
gratia-probe-onevm-1.20.7-1.osg34.el6
gratia-probe-pbs-lsf-1.20.7-1.osg34.el6
gratia-probe-services-1.20.7-1.osg34.el6
gratia-probe-sge-1.20.7-1.osg34.el6
gratia-probe-slurm-1.20.7-1.osg34.el6
gratia-probe-xrootd-storage-1.20.7-1.osg34.el6
gratia-probe-xrootd-transfer-1.20.7-1.osg34.el6
htcondor-ce-3.1.4-1.osg34.el6
htcondor-ce-bosco-3.1.4-1.osg34.el6
htcondor-ce-client-3.1.4-1.osg34.el6
htcondor-ce-collector-3.1.4-1.osg34.el6
htcondor-ce-condor-3.1.4-1.osg34.el6
htcondor-ce-lsf-3.1.4-1.osg34.el6
htcondor-ce-pbs-3.1.4-1.osg34.el6
htcondor-ce-sge-3.1.4-1.osg34.el6
htcondor-ce-slurm-3.1.4-1.osg34.el6
htcondor-ce-view-3.1.4-1.osg34.el6
osg-oasis-10-1.osg34.el6
osg-version-3.4.18-1.osg34.el6
pegasus-4.8.4-1.osg34.el6
pegasus-debuginfo-4.8.4-1.osg34.el6
python2-xrootd-4.8.4-3.osg34.el6
python3-xrootd-4.8.4-3.osg34.el6
rsv-3.19.8-1.osg34.el6
rsv-consumers-3.19.8-1.osg34.el6
rsv-core-3.19.8-1.osg34.el6
rsv-metrics-3.19.8-1.osg34.el6
xrootd-4.8.4-3.osg34.el6
xrootd-client-4.8.4-3.osg34.el6
xrootd-client-devel-4.8.4-3.osg34.el6
xrootd-client-libs-4.8.4-3.osg34.el6
xrootd-debuginfo-4.8.4-3.osg34.el6
xrootd-devel-4.8.4-3.osg34.el6
xrootd-doc-4.8.4-3.osg34.el6
xrootd-fuse-4.8.4-3.osg34.el6
xrootd-libs-4.8.4-3.osg34.el6
xrootd-private-devel-4.8.4-3.osg34.el6
xrootd-selinux-4.8.4-3.osg34.el6
xrootd-server-4.8.4-3.osg34.el6
xrootd-server-devel-4.8.4-3.osg34.el6
xrootd-server-libs-4.8.4-3.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.38.bosco-1.osg34.el7
blahp-debuginfo-1.18.38.bosco-1.osg34.el7
cvmfs-2.5.1-1.osg34.el7
cvmfs-devel-2.5.1-1.osg34.el7
cvmfs-server-2.5.1-1.osg34.el7
cvmfs-unittests-2.5.1-1.osg34.el7
glideinwms-3.4-1.1.osg34.el7
glideinwms-common-tools-3.4-1.1.osg34.el7
glideinwms-condor-common-config-3.4-1.1.osg34.el7
glideinwms-factory-3.4-1.1.osg34.el7
glideinwms-factory-condor-3.4-1.1.osg34.el7
glideinwms-glidecondor-tools-3.4-1.1.osg34.el7
glideinwms-libs-3.4-1.1.osg34.el7
glideinwms-minimal-condor-3.4-1.1.osg34.el7
glideinwms-usercollector-3.4-1.1.osg34.el7
glideinwms-userschedd-3.4-1.1.osg34.el7
glideinwms-vofrontend-3.4-1.1.osg34.el7
glideinwms-vofrontend-standalone-3.4-1.1.osg34.el7
globus-gridftp-server-12.9-1.1.osg34.el7
globus-gridftp-server-control-7.0-1.osg34.el7
globus-gridftp-server-control-debuginfo-7.0-1.osg34.el7
globus-gridftp-server-control-devel-7.0-1.osg34.el7
globus-gridftp-server-debuginfo-12.9-1.1.osg34.el7
globus-gridftp-server-devel-12.9-1.1.osg34.el7
globus-gridftp-server-progs-12.9-1.1.osg34.el7
gratia-probe-1.20.7-1.osg34.el7
gratia-probe-common-1.20.7-1.osg34.el7
gratia-probe-condor-1.20.7-1.osg34.el7
gratia-probe-condor-events-1.20.7-1.osg34.el7
gratia-probe-dcache-storage-1.20.7-1.osg34.el7
gratia-probe-dcache-storagegroup-1.20.7-1.osg34.el7
gratia-probe-dcache-transfer-1.20.7-1.osg34.el7
gratia-probe-debuginfo-1.20.7-1.osg34.el7
gratia-probe-enstore-storage-1.20.7-1.osg34.el7
gratia-probe-enstore-tapedrive-1.20.7-1.osg34.el7
gratia-probe-enstore-transfer-1.20.7-1.osg34.el7
gratia-probe-glideinwms-1.20.7-1.osg34.el7
gratia-probe-gridftp-transfer-1.20.7-1.osg34.el7
gratia-probe-hadoop-storage-1.20.7-1.osg34.el7
gratia-probe-htcondor-ce-1.20.7-1.osg34.el7
gratia-probe-lsf-1.20.7-1.osg34.el7
gratia-probe-metric-1.20.7-1.osg34.el7
gratia-probe-onevm-1.20.7-1.osg34.el7
gratia-probe-pbs-lsf-1.20.7-1.osg34.el7
gratia-probe-services-1.20.7-1.osg34.el7
gratia-probe-sge-1.20.7-1.osg34.el7
gratia-probe-slurm-1.20.7-1.osg34.el7
gratia-probe-xrootd-storage-1.20.7-1.osg34.el7
gratia-probe-xrootd-transfer-1.20.7-1.osg34.el7
htcondor-ce-3.1.4-1.osg34.el7
htcondor-ce-bosco-3.1.4-1.osg34.el7
htcondor-ce-client-3.1.4-1.osg34.el7
htcondor-ce-collector-3.1.4-1.osg34.el7
htcondor-ce-condor-3.1.4-1.osg34.el7
htcondor-ce-lsf-3.1.4-1.osg34.el7
htcondor-ce-pbs-3.1.4-1.osg34.el7
htcondor-ce-sge-3.1.4-1.osg34.el7
htcondor-ce-slurm-3.1.4-1.osg34.el7
htcondor-ce-view-3.1.4-1.osg34.el7
osg-oasis-10-1.osg34.el7
osg-version-3.4.18-1.osg34.el7
pegasus-4.8.4-1.osg34.el7
pegasus-debuginfo-4.8.4-1.osg34.el7
python2-xrootd-4.8.4-3.osg34.el7
python3-xrootd-4.8.4-3.osg34.el7
rsv-3.19.8-1.osg34.el7
rsv-consumers-3.19.8-1.osg34.el7
rsv-core-3.19.8-1.osg34.el7
rsv-metrics-3.19.8-1.osg34.el7
xrootd-4.8.4-3.osg34.el7
xrootd-client-4.8.4-3.osg34.el7
xrootd-client-devel-4.8.4-3.osg34.el7
xrootd-client-libs-4.8.4-3.osg34.el7
xrootd-debuginfo-4.8.4-3.osg34.el7
xrootd-devel-4.8.4-3.osg34.el7
xrootd-doc-4.8.4-3.osg34.el7
xrootd-fuse-4.8.4-3.osg34.el7
xrootd-hdfs-2.1.3-1.osg34.el7
xrootd-hdfs-debuginfo-2.1.3-1.osg34.el7
xrootd-hdfs-devel-2.1.3-1.osg34.el7
xrootd-lcmaps-1.4.1-1.osg34.el7
xrootd-lcmaps-debuginfo-1.4.1-1.osg34.el7
xrootd-libs-4.8.4-3.osg34.el7
xrootd-private-devel-4.8.4-3.osg34.el7
xrootd-selinux-4.8.4-3.osg34.el7
xrootd-server-4.8.4-3.osg34.el7
xrootd-server-devel-4.8.4-3.osg34.el7
xrootd-server-libs-4.8.4-3.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.38.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.38.bosco-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.38.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.38.bosco-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.38.bosco-1.osgup.el6
blahp-debuginfo-1.18.38.bosco-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.38.bosco-1.osgup.el7
blahp-debuginfo-1.18.38.bosco-1.osgup.el7
```
