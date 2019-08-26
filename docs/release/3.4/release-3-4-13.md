OSG Software Release 3.4.13
===========================

**Release Date**: 2018-06-12

Summary of changes
------------------

This release contains:

-   [CVMFS 2.5.0](https://cvmfs.readthedocs.io/en/2.5/cpt-releasenotes.html): performance improvements, new functionality, and bug fixes
-   [HTCondor 8.6.11](https://www-auth.cs.wisc.edu/lists/htcondor-world/2018/msg00011.shtml)
    -   Can now do an interactive submit of a Singularity job
    -   Shared port daemon is more resilient when starved for TCP ports
    -   The Windows installer configures the environment for the Python bindings
    -   Fixed several other minor problems
-   [Singularity 2.5.1](https://singularity.lbl.gov/release-2-5-1): Minor bug fix release
-   [Pegasus 4.8.2](https://pegasus.isi.edu/2018/05/03/pegasus-4-8-2-released/): Minor bug fix release
-   VOMS: added voms-proxy-direct for use when signing VOMS attributes directly
-   Upcoming repository:
    -   [HTCondor 8.7.8](https://www-auth.cs.wisc.edu/lists/htcondor-world/2018/msg00012.shtml)
        -   The condor annex can easily use multiple regions simultaneously
        -   HTCondor now uses CUDA_VISIBLE_DEVICES to tell which GPU devices to manage
        -   HTCondor now reports GPU memory utilization

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.13%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-to-osg-35).

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

-   [condor-8.6.11-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.11-1.osg34.el6)
-   [cvmfs-2.5.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.5.0-1.osg34.el6)
-   [osg-oasis-9-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-9-2.osg34.el6)
-   [osg-release-3.4-5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-5.osg34.el6)
-   [osg-tested-internal-3.4-6.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-6.osg34.el6)
-   [osg-version-3.4.13-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.13-1.osg34.el6)
-   [pegasus-4.8.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.8.2-1.osg34.el6)
-   [singularity-2.5.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.5.1-1.osg34.el6)
-   [voms-2.0.14-1.4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.4.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.6.11-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.11-1.osg34.el7)
-   [cvmfs-2.5.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.5.0-1.osg34.el7)
-   [osg-oasis-9-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-9-2.osg34.el7)
-   [osg-release-3.4-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-5.osg34.el7)
-   [osg-tested-internal-3.4-6.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-6.osg34.el7)
-   [osg-version-3.4.13-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.13-1.osg34.el7)
-   [pegasus-4.8.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.8.2-1.osg34.el7)
-   [singularity-2.5.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.5.1-1.osg34.el7)
-   [voms-2.0.14-1.4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.4.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-devel cvmfs-server cvmfs-unittests osg-oasis osg-release osg-tested-internal osg-version pegasus pegasus-debuginfo singularity singularity-debuginfo singularity-devel singularity-runtime voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.6.11-1.osg34.el6
condor-all-8.6.11-1.osg34.el6
condor-bosco-8.6.11-1.osg34.el6
condor-classads-8.6.11-1.osg34.el6
condor-classads-devel-8.6.11-1.osg34.el6
condor-cream-gahp-8.6.11-1.osg34.el6
condor-debuginfo-8.6.11-1.osg34.el6
condor-kbdd-8.6.11-1.osg34.el6
condor-procd-8.6.11-1.osg34.el6
condor-python-8.6.11-1.osg34.el6
condor-std-universe-8.6.11-1.osg34.el6
condor-test-8.6.11-1.osg34.el6
condor-vm-gahp-8.6.11-1.osg34.el6
cvmfs-2.5.0-1.osg34.el6
cvmfs-devel-2.5.0-1.osg34.el6
cvmfs-server-2.5.0-1.osg34.el6
cvmfs-unittests-2.5.0-1.osg34.el6
osg-oasis-9-2.osg34.el6
osg-release-3.4-5.osg34.el6
osg-tested-internal-3.4-6.osg34.el6
osg-version-3.4.13-1.osg34.el6
pegasus-4.8.2-1.osg34.el6
pegasus-debuginfo-4.8.2-1.osg34.el6
singularity-2.5.1-1.osg34.el6
singularity-debuginfo-2.5.1-1.osg34.el6
singularity-devel-2.5.1-1.osg34.el6
singularity-runtime-2.5.1-1.osg34.el6
voms-2.0.14-1.4.osg34.el6
voms-clients-cpp-2.0.14-1.4.osg34.el6
voms-debuginfo-2.0.14-1.4.osg34.el6
voms-devel-2.0.14-1.4.osg34.el6
voms-doc-2.0.14-1.4.osg34.el6
voms-server-2.0.14-1.4.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.6.11-1.osg34.el7
condor-all-8.6.11-1.osg34.el7
condor-bosco-8.6.11-1.osg34.el7
condor-classads-8.6.11-1.osg34.el7
condor-classads-devel-8.6.11-1.osg34.el7
condor-cream-gahp-8.6.11-1.osg34.el7
condor-debuginfo-8.6.11-1.osg34.el7
condor-kbdd-8.6.11-1.osg34.el7
condor-procd-8.6.11-1.osg34.el7
condor-python-8.6.11-1.osg34.el7
condor-test-8.6.11-1.osg34.el7
condor-vm-gahp-8.6.11-1.osg34.el7
cvmfs-2.5.0-1.osg34.el7
cvmfs-devel-2.5.0-1.osg34.el7
cvmfs-server-2.5.0-1.osg34.el7
cvmfs-unittests-2.5.0-1.osg34.el7
osg-oasis-9-2.osg34.el7
osg-release-3.4-5.osg34.el7
osg-tested-internal-3.4-6.osg34.el7
osg-version-3.4.13-1.osg34.el7
pegasus-4.8.2-1.osg34.el7
pegasus-debuginfo-4.8.2-1.osg34.el7
singularity-2.5.1-1.osg34.el7
singularity-debuginfo-2.5.1-1.osg34.el7
singularity-devel-2.5.1-1.osg34.el7
singularity-runtime-2.5.1-1.osg34.el7
voms-2.0.14-1.4.osg34.el7
voms-clients-cpp-2.0.14-1.4.osg34.el7
voms-debuginfo-2.0.14-1.4.osg34.el7
voms-devel-2.0.14-1.4.osg34.el7
voms-doc-2.0.14-1.4.osg34.el7
voms-server-2.0.14-1.4.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.36.bosco-2.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.36.bosco-2.osgup.el6)
-   [condor-8.7.8-2.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.8-2.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.36.bosco-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.36.bosco-2.osgup.el7)
-   [condor-8.7.8-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.8-2.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.36.bosco-2.osgup.el6
blahp-debuginfo-1.18.36.bosco-2.osgup.el6
condor-8.7.8-2.osgup.el6
condor-all-8.7.8-2.osgup.el6
condor-annex-ec2-8.7.8-2.osgup.el6
condor-bosco-8.7.8-2.osgup.el6
condor-classads-8.7.8-2.osgup.el6
condor-classads-devel-8.7.8-2.osgup.el6
condor-cream-gahp-8.7.8-2.osgup.el6
condor-debuginfo-8.7.8-2.osgup.el6
condor-kbdd-8.7.8-2.osgup.el6
condor-procd-8.7.8-2.osgup.el6
condor-python-8.7.8-2.osgup.el6
condor-std-universe-8.7.8-2.osgup.el6
condor-test-8.7.8-2.osgup.el6
condor-vm-gahp-8.7.8-2.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.36.bosco-2.osgup.el7
blahp-debuginfo-1.18.36.bosco-2.osgup.el7
condor-8.7.8-2.osgup.el7
condor-all-8.7.8-2.osgup.el7
condor-annex-ec2-8.7.8-2.osgup.el7
condor-bosco-8.7.8-2.osgup.el7
condor-classads-8.7.8-2.osgup.el7
condor-classads-devel-8.7.8-2.osgup.el7
condor-cream-gahp-8.7.8-2.osgup.el7
condor-debuginfo-8.7.8-2.osgup.el7
condor-kbdd-8.7.8-2.osgup.el7
condor-procd-8.7.8-2.osgup.el7
condor-python-8.7.8-2.osgup.el7
condor-test-8.7.8-2.osgup.el7
condor-vm-gahp-8.7.8-2.osgup.el7
```
