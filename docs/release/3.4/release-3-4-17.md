OSG Software Release 3.4.17
===========================

**Release Date**: 2018-08-16

Summary of changes
------------------

This release contains:

-   OSG 3.4 Repository
    -   [Singularity 2.6.0](https://github.com/singularityware/singularity/releases/tag/2.6.0): Bug fix release
        -   This release includes an extra option called "underlay" that is not
            in the upstream release nor enabled by default but is supported by
            OSG and recommended to be enabled instead of the "overlay" option.
            [See the documentation for details.](https://opensciencegrid.org/docs/worker-node/install-singularity/#configuring-singularity)
    -   [HTCondor 8.6.12](https://www-auth.cs.wisc.edu/lists/htcondor-world/2018/msg00016.shtml): Bug fix release
        -   Fixed memory leak when SSL authentication fails
        -   Can now set job environment variables in Singularity containers
    -   CVMFS X.509 helper 1.1: Fixed file descriptor leak
    -   Gratia probes 1.20.4: Fixed problem where some Slurm jobs weren't reported
    -   [Pegasus 4.8.3](https://pegasus.isi.edu/2018/08/06/pegasus-4-8-3-released/): Minor bug fix release
    -   [HTCondor-CE 3.1.3](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v3.1.3): Fix for `condor_ce_info_status` using the wrong port for the central collector
    -   xrootd-lcmaps 1.4.0: Fixed the ability to specify an alternate policy name in lcmaps.db (EL7 Only)
    -   New xrootd-multiuser 0.4.2 plugin (EL7 only)
-   Upcoming Repository
    -   [HTCondor 8.7.9](https://www-auth.cs.wisc.edu/lists/htcondor-world/2018/msg00017.shtml)
        -   Fixed handling of CNAMEs in NETWORK_HOSTNAME

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.17%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-from-osg-31-32-33-to-33-or-34).

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

-   [condor-8.6.12-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.12-1.osg34.el6)
-   [cvmfs-x509-helper-1.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-1.1-1.osg34.el6)
-   [gratia-probe-1.20.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.4-1.osg34.el6)
-   [htcondor-ce-3.1.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.1.3-1.osg34.el6)
-   [osg-oasis-9-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-9-3.osg34.el6)
-   [osg-test-2.2.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.2.1-1.osg34.el6)
-   [osg-version-3.4.17-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.17-1.osg34.el6)
-   [pegasus-4.8.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.8.3-1.osg34.el6)
-   [singularity-2.6.0-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.6.0-1.1.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.6.12-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.12-1.osg34.el7)
-   [cvmfs-x509-helper-1.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-1.1-1.osg34.el7)
-   [gratia-probe-1.20.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.4-1.osg34.el7)
-   [htcondor-ce-3.1.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.1.3-1.osg34.el7)
-   [osg-oasis-9-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-9-3.osg34.el7)
-   [osg-test-2.2.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.2.1-1.osg34.el7)
-   [osg-version-3.4.17-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.17-1.osg34.el7)
-   [pegasus-4.8.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.8.3-1.osg34.el7)
-   [singularity-2.6.0-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.6.0-1.1.osg34.el7)
-   [xrootd-lcmaps-1.4.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.4.0-1.osg34.el7)
-   [xrootd-multiuser-0.4.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.2-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cilogon-openid-ca-cert condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs-x509-helper cvmfs-x509-helper-debuginfo gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view osg-oasis osg-test osg-test-log-viewer osg-version pegasus pegasus-debuginfo singularity singularity-debuginfo singularity-devel singularity-runtime xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-multiuser xrootd-multiuser-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.6.12-1.osg34.el6
condor-all-8.6.12-1.osg34.el6
condor-bosco-8.6.12-1.osg34.el6
condor-classads-8.6.12-1.osg34.el6
condor-classads-devel-8.6.12-1.osg34.el6
condor-cream-gahp-8.6.12-1.osg34.el6
condor-debuginfo-8.6.12-1.osg34.el6
condor-kbdd-8.6.12-1.osg34.el6
condor-procd-8.6.12-1.osg34.el6
condor-python-8.6.12-1.osg34.el6
condor-std-universe-8.6.12-1.osg34.el6
condor-test-8.6.12-1.osg34.el6
condor-vm-gahp-8.6.12-1.osg34.el6
cvmfs-x509-helper-1.1-1.osg34.el6
cvmfs-x509-helper-debuginfo-1.1-1.osg34.el6
gratia-probe-1.20.4-1.osg34.el6
gratia-probe-common-1.20.4-1.osg34.el6
gratia-probe-condor-1.20.4-1.osg34.el6
gratia-probe-condor-events-1.20.4-1.osg34.el6
gratia-probe-dcache-storage-1.20.4-1.osg34.el6
gratia-probe-dcache-storagegroup-1.20.4-1.osg34.el6
gratia-probe-dcache-transfer-1.20.4-1.osg34.el6
gratia-probe-debuginfo-1.20.4-1.osg34.el6
gratia-probe-enstore-storage-1.20.4-1.osg34.el6
gratia-probe-enstore-tapedrive-1.20.4-1.osg34.el6
gratia-probe-enstore-transfer-1.20.4-1.osg34.el6
gratia-probe-glideinwms-1.20.4-1.osg34.el6
gratia-probe-gridftp-transfer-1.20.4-1.osg34.el6
gratia-probe-hadoop-storage-1.20.4-1.osg34.el6
gratia-probe-htcondor-ce-1.20.4-1.osg34.el6
gratia-probe-lsf-1.20.4-1.osg34.el6
gratia-probe-metric-1.20.4-1.osg34.el6
gratia-probe-onevm-1.20.4-1.osg34.el6
gratia-probe-pbs-lsf-1.20.4-1.osg34.el6
gratia-probe-services-1.20.4-1.osg34.el6
gratia-probe-sge-1.20.4-1.osg34.el6
gratia-probe-slurm-1.20.4-1.osg34.el6
gratia-probe-xrootd-storage-1.20.4-1.osg34.el6
gratia-probe-xrootd-transfer-1.20.4-1.osg34.el6
htcondor-ce-3.1.3-1.osg34.el6
htcondor-ce-bosco-3.1.3-1.osg34.el6
htcondor-ce-client-3.1.3-1.osg34.el6
htcondor-ce-collector-3.1.3-1.osg34.el6
htcondor-ce-condor-3.1.3-1.osg34.el6
htcondor-ce-lsf-3.1.3-1.osg34.el6
htcondor-ce-pbs-3.1.3-1.osg34.el6
htcondor-ce-sge-3.1.3-1.osg34.el6
htcondor-ce-slurm-3.1.3-1.osg34.el6
htcondor-ce-view-3.1.3-1.osg34.el6
osg-oasis-9-3.osg34.el6
osg-test-2.2.1-1.osg34.el6
osg-test-log-viewer-2.2.1-1.osg34.el6
osg-version-3.4.17-1.osg34.el6
pegasus-4.8.3-1.osg34.el6
pegasus-debuginfo-4.8.3-1.osg34.el6
singularity-2.6.0-1.1.osg34.el6
singularity-debuginfo-2.6.0-1.1.osg34.el6
singularity-devel-2.6.0-1.1.osg34.el6
singularity-runtime-2.6.0-1.1.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.6.12-1.osg34.el7
condor-all-8.6.12-1.osg34.el7
condor-bosco-8.6.12-1.osg34.el7
condor-classads-8.6.12-1.osg34.el7
condor-classads-devel-8.6.12-1.osg34.el7
condor-cream-gahp-8.6.12-1.osg34.el7
condor-debuginfo-8.6.12-1.osg34.el7
condor-kbdd-8.6.12-1.osg34.el7
condor-procd-8.6.12-1.osg34.el7
condor-python-8.6.12-1.osg34.el7
condor-test-8.6.12-1.osg34.el7
condor-vm-gahp-8.6.12-1.osg34.el7
cvmfs-x509-helper-1.1-1.osg34.el7
cvmfs-x509-helper-debuginfo-1.1-1.osg34.el7
gratia-probe-1.20.4-1.osg34.el7
gratia-probe-common-1.20.4-1.osg34.el7
gratia-probe-condor-1.20.4-1.osg34.el7
gratia-probe-condor-events-1.20.4-1.osg34.el7
gratia-probe-dcache-storage-1.20.4-1.osg34.el7
gratia-probe-dcache-storagegroup-1.20.4-1.osg34.el7
gratia-probe-dcache-transfer-1.20.4-1.osg34.el7
gratia-probe-debuginfo-1.20.4-1.osg34.el7
gratia-probe-enstore-storage-1.20.4-1.osg34.el7
gratia-probe-enstore-tapedrive-1.20.4-1.osg34.el7
gratia-probe-enstore-transfer-1.20.4-1.osg34.el7
gratia-probe-glideinwms-1.20.4-1.osg34.el7
gratia-probe-gridftp-transfer-1.20.4-1.osg34.el7
gratia-probe-hadoop-storage-1.20.4-1.osg34.el7
gratia-probe-htcondor-ce-1.20.4-1.osg34.el7
gratia-probe-lsf-1.20.4-1.osg34.el7
gratia-probe-metric-1.20.4-1.osg34.el7
gratia-probe-onevm-1.20.4-1.osg34.el7
gratia-probe-pbs-lsf-1.20.4-1.osg34.el7
gratia-probe-services-1.20.4-1.osg34.el7
gratia-probe-sge-1.20.4-1.osg34.el7
gratia-probe-slurm-1.20.4-1.osg34.el7
gratia-probe-xrootd-storage-1.20.4-1.osg34.el7
gratia-probe-xrootd-transfer-1.20.4-1.osg34.el7
htcondor-ce-3.1.3-1.osg34.el7
htcondor-ce-bosco-3.1.3-1.osg34.el7
htcondor-ce-client-3.1.3-1.osg34.el7
htcondor-ce-collector-3.1.3-1.osg34.el7
htcondor-ce-condor-3.1.3-1.osg34.el7
htcondor-ce-lsf-3.1.3-1.osg34.el7
htcondor-ce-pbs-3.1.3-1.osg34.el7
htcondor-ce-sge-3.1.3-1.osg34.el7
htcondor-ce-slurm-3.1.3-1.osg34.el7
htcondor-ce-view-3.1.3-1.osg34.el7
osg-oasis-9-3.osg34.el7
osg-test-2.2.1-1.osg34.el7
osg-test-log-viewer-2.2.1-1.osg34.el7
osg-version-3.4.17-1.osg34.el7
pegasus-4.8.3-1.osg34.el7
pegasus-debuginfo-4.8.3-1.osg34.el7
singularity-2.6.0-1.1.osg34.el7
singularity-debuginfo-2.6.0-1.1.osg34.el7
singularity-devel-2.6.0-1.1.osg34.el7
singularity-runtime-2.6.0-1.1.osg34.el7
xrootd-lcmaps-1.4.0-1.osg34.el7
xrootd-lcmaps-debuginfo-1.4.0-1.osg34.el7
xrootd-multiuser-0.4.2-1.osg34.el7
xrootd-multiuser-debuginfo-0.4.2-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.37.bosco-2.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.37.bosco-2.osgup.el6)
-   [condor-8.7.9-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.9-1.osgup.el6)
-   [glite-ce-cream-client-api-c-1.15.4-2.6.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.6.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.37.bosco-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.37.bosco-2.osgup.el7)
-   [condor-8.7.9-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.9-1.osgup.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.6.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.6.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone glite-ce-cream-client-api-c glite-ce-cream-client-devel osg-gridftp osg-gridftp-hdfs osg-gridftp-xrootd

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.37.bosco-2.osgup.el6
blahp-debuginfo-1.18.37.bosco-2.osgup.el6
condor-8.7.9-1.osgup.el6
condor-all-8.7.9-1.osgup.el6
condor-annex-ec2-8.7.9-1.osgup.el6
condor-bosco-8.7.9-1.osgup.el6
condor-classads-8.7.9-1.osgup.el6
condor-classads-devel-8.7.9-1.osgup.el6
condor-cream-gahp-8.7.9-1.osgup.el6
condor-debuginfo-8.7.9-1.osgup.el6
condor-kbdd-8.7.9-1.osgup.el6
condor-procd-8.7.9-1.osgup.el6
condor-python-8.7.9-1.osgup.el6
condor-std-universe-8.7.9-1.osgup.el6
condor-test-8.7.9-1.osgup.el6
condor-vm-gahp-8.7.9-1.osgup.el6
glite-ce-cream-client-api-c-1.15.4-2.6.osgup.el6
glite-ce-cream-client-devel-1.15.4-2.6.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.37.bosco-2.osgup.el7
blahp-debuginfo-1.18.37.bosco-2.osgup.el7
condor-8.7.9-1.osgup.el7
condor-all-8.7.9-1.osgup.el7
condor-annex-ec2-8.7.9-1.osgup.el7
condor-bosco-8.7.9-1.osgup.el7
condor-classads-8.7.9-1.osgup.el7
condor-classads-devel-8.7.9-1.osgup.el7
condor-cream-gahp-8.7.9-1.osgup.el7
condor-debuginfo-8.7.9-1.osgup.el7
condor-kbdd-8.7.9-1.osgup.el7
condor-procd-8.7.9-1.osgup.el7
condor-python-8.7.9-1.osgup.el7
condor-test-8.7.9-1.osgup.el7
condor-vm-gahp-8.7.9-1.osgup.el7
glite-ce-cream-client-api-c-1.15.4-2.6.osgup.el7
glite-ce-cream-client-devel-1.15.4-2.6.osgup.el7
```
