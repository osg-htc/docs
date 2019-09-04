OSG Software Release 3.4.23
===========================

**Release Date**: 2019-01-23

Summary of changes
------------------

This release contains:

-   Gratia probes 1.20.8
    -   Interpret CPU expressions for Hosted CEs (needed for proper accounting)
    -   Minor change properly set `Processor` field for Slurm (no impact on accounting)
    -   Added unit tests for the HTCondor probe processors field
-   Upcoming Repository
    -   [Singularity 3.0.2](https://github.com/sylabs/singularity/releases/tag/v3.0.2)
        -   Reimplemented in Go
        -   [Many changes](https://github.com/sylabs/singularity/blob/master/CHANGELOG.md)
    -   [HTCondor 8.8.0](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00000.shtml)
        -   Job Router: follow first match by default, easier to write routing rules

        !!! danger "Sites with multiple routes"
            If instead you prefer round-robin matching to to distribute jobs over routes,
            add `JOB_ROUTER_ROUND_ROBIN_SELECTION = True` to a file in the `/etc/condor-ce/config.d` directory
            and run `condor_ce_reconfig`.

        -   Performance improvements in the collector
        -   Tracks GPU resources

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.23%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

-   [gratia-probe-1.20.8-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.8-1.osg34.el6)
-   [osg-version-3.4.23-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.23-1.osg34.el6)

#### Enterprise Linux 7

-   [gratia-probe-1.20.8-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.8-1.osg34.el7)
-   [osg-version-3.4.23-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.23-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer igtf-ca-certs osg-ca-certs osg-version

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
gratia-probe-1.20.8-1.osg34.el6
gratia-probe-common-1.20.8-1.osg34.el6
gratia-probe-condor-1.20.8-1.osg34.el6
gratia-probe-condor-events-1.20.8-1.osg34.el6
gratia-probe-dcache-storage-1.20.8-1.osg34.el6
gratia-probe-dcache-storagegroup-1.20.8-1.osg34.el6
gratia-probe-dcache-transfer-1.20.8-1.osg34.el6
gratia-probe-debuginfo-1.20.8-1.osg34.el6
gratia-probe-enstore-storage-1.20.8-1.osg34.el6
gratia-probe-enstore-tapedrive-1.20.8-1.osg34.el6
gratia-probe-enstore-transfer-1.20.8-1.osg34.el6
gratia-probe-glideinwms-1.20.8-1.osg34.el6
gratia-probe-gridftp-transfer-1.20.8-1.osg34.el6
gratia-probe-hadoop-storage-1.20.8-1.osg34.el6
gratia-probe-htcondor-ce-1.20.8-1.osg34.el6
gratia-probe-lsf-1.20.8-1.osg34.el6
gratia-probe-metric-1.20.8-1.osg34.el6
gratia-probe-onevm-1.20.8-1.osg34.el6
gratia-probe-pbs-lsf-1.20.8-1.osg34.el6
gratia-probe-services-1.20.8-1.osg34.el6
gratia-probe-sge-1.20.8-1.osg34.el6
gratia-probe-slurm-1.20.8-1.osg34.el6
gratia-probe-xrootd-storage-1.20.8-1.osg34.el6
gratia-probe-xrootd-transfer-1.20.8-1.osg34.el6
osg-version-3.4.23-1.osg34.el6
```

#### Enterprise Linux 7

``` file
gratia-probe-1.20.8-1.osg34.el7
gratia-probe-common-1.20.8-1.osg34.el7
gratia-probe-condor-1.20.8-1.osg34.el7
gratia-probe-condor-events-1.20.8-1.osg34.el7
gratia-probe-dcache-storage-1.20.8-1.osg34.el7
gratia-probe-dcache-storagegroup-1.20.8-1.osg34.el7
gratia-probe-dcache-transfer-1.20.8-1.osg34.el7
gratia-probe-debuginfo-1.20.8-1.osg34.el7
gratia-probe-enstore-storage-1.20.8-1.osg34.el7
gratia-probe-enstore-tapedrive-1.20.8-1.osg34.el7
gratia-probe-enstore-transfer-1.20.8-1.osg34.el7
gratia-probe-glideinwms-1.20.8-1.osg34.el7
gratia-probe-gridftp-transfer-1.20.8-1.osg34.el7
gratia-probe-hadoop-storage-1.20.8-1.osg34.el7
gratia-probe-htcondor-ce-1.20.8-1.osg34.el7
gratia-probe-lsf-1.20.8-1.osg34.el7
gratia-probe-metric-1.20.8-1.osg34.el7
gratia-probe-onevm-1.20.8-1.osg34.el7
gratia-probe-pbs-lsf-1.20.8-1.osg34.el7
gratia-probe-services-1.20.8-1.osg34.el7
gratia-probe-sge-1.20.8-1.osg34.el7
gratia-probe-slurm-1.20.8-1.osg34.el7
gratia-probe-xrootd-storage-1.20.8-1.osg34.el7
gratia-probe-xrootd-transfer-1.20.8-1.osg34.el7
osg-version-3.4.23-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.8.0-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.0-1.osgup.el6)
-   [singularity-3.0.2-1.3.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.0.2-1.3.osgup.el6)

#### Enterprise Linux 7

-   [condor-8.8.0-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.0-1.osgup.el7)
-   [singularity-3.0.2-1.3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.0.2-1.3.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp glite-ce-cream-client-api-c glite-ce-cream-client-devel minicondor osg-gridftp osg-gridftp-hdfs osg-gridftp-xrootd python2-condor singularity singularity-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.8.0-1.osgup.el6
condor-all-8.8.0-1.osgup.el6
condor-annex-ec2-8.8.0-1.osgup.el6
condor-bosco-8.8.0-1.osgup.el6
condor-classads-8.8.0-1.osgup.el6
condor-classads-devel-8.8.0-1.osgup.el6
condor-cream-gahp-8.8.0-1.osgup.el6
condor-debuginfo-8.8.0-1.osgup.el6
condor-kbdd-8.8.0-1.osgup.el6
condor-procd-8.8.0-1.osgup.el6
condor-std-universe-8.8.0-1.osgup.el6
condor-test-8.8.0-1.osgup.el6
condor-vm-gahp-8.8.0-1.osgup.el6
minicondor-8.8.0-1.osgup.el6
python2-condor-8.8.0-1.osgup.el6
singularity-3.0.2-1.3.osgup.el6
singularity-debuginfo-3.0.2-1.3.osgup.el6
```

#### Enterprise Linux 7

``` file
condor-8.8.0-1.osgup.el7
condor-all-8.8.0-1.osgup.el7
condor-annex-ec2-8.8.0-1.osgup.el7
condor-bosco-8.8.0-1.osgup.el7
condor-classads-8.8.0-1.osgup.el7
condor-classads-devel-8.8.0-1.osgup.el7
condor-cream-gahp-8.8.0-1.osgup.el7
condor-debuginfo-8.8.0-1.osgup.el7
condor-kbdd-8.8.0-1.osgup.el7
condor-procd-8.8.0-1.osgup.el7
condor-test-8.8.0-1.osgup.el7
condor-vm-gahp-8.8.0-1.osgup.el7
minicondor-8.8.0-1.osgup.el7
python2-condor-8.8.0-1.osgup.el7
singularity-3.0.2-1.3.osgup.el7
singularity-debuginfo-3.0.2-1.3.osgup.el7
```
