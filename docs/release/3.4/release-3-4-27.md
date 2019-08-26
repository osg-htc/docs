OSG Software Release 3.4.27
===========================

**Release Date**: 2019-04-11

Summary of changes
------------------

This release contains:

-   [CVMFS 2.6.0](https://cvmfs.readthedocs.io/en/2.6/cpt-releasenotes.html): performance improvements, new functionality, and bug fixes
-   [Cooperative Computing Tools](https://ccl.cse.nd.edu/software/) 7.0.11: [Bug fix release](https://cclnd.blogspot.com/2019/03/the-cooperative-computing-lab-is.html)
-   [osg-pki-tools 3.2.2](https://github.com/opensciencegrid/osg-pki-tools/releases): Update from 3.1.0, bug fixes
-   [HTCondor-CE 3.2.2](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v3.2.2): Takes advantage of HTCondor's new multi-line syntax
-   Update Globus GridFTP packages to use the Grid Community Toolkit (GCT)
-   Upcoming Repository
    -   [Singularity 3.1.1](https://github.com/sylabs/singularity/releases/tag/v3.1.1): Bug fix release

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.27%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is only supported on EL7

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

-   [cctools-7.0.11-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.11-1.osg34.el6)
-   [cvmfs-2.6.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.6.0-1.osg34.el6)
-   [globus-ftp-client-9.1-2.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-9.1-2.1.osg34.el6)
-   [globus-gridftp-server-13.9-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.9-1.1.osg34.el6)
-   [globus-gridftp-server-control-8.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-8.0-1.osg34.el6)
-   [htcondor-ce-3.2.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.2.2-1.osg34.el6)
-   [koji-1.11.1-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.11.1-1.1.osg34.el6)
-   [osg-build-1.14.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.14.2-1.osg34.el6)
-   [osg-oasis-12-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-12-1.osg34.el6)
-   [osg-pki-tools-3.2.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.2.2-1.osg34.el6)
-   [osg-version-3.4.27-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.27-1.osg34.el6)

#### Enterprise Linux 7

-   [cctools-7.0.11-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.11-1.osg34.el7)
-   [cvmfs-2.6.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.6.0-1.osg34.el7)
-   [globus-ftp-client-9.1-2.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-9.1-2.1.osg34.el7)
-   [globus-gridftp-server-13.9-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.9-1.1.osg34.el7)
-   [globus-gridftp-server-control-8.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-8.0-1.osg34.el7)
-   [htcondor-ce-3.2.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.2.2-1.osg34.el7)
-   [koji-1.11.1-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.11.1-1.1.osg34.el7)
-   [osg-build-1.14.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.14.2-1.osg34.el7)
-   [osg-oasis-12-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-12-1.osg34.el7)
-   [osg-pki-tools-3.2.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.2.2-1.osg34.el7)
-   [osg-version-3.4.27-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.27-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cctools cctools-debuginfo cctools-devel cvmfs cvmfs-devel cvmfs-ducc cvmfs-server cvmfs-shrinkwrap cvmfs-unittests globus-ftp-client globus-ftp-client-debuginfo globus-ftp-client-devel globus-ftp-client-doc globus-gridftp-server globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs koji koji-builder koji-hub koji-hub-plugins koji-utils koji-vm koji-web osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-ca-certs osg-oasis osg-pki-tools osg-version vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
cctools-7.0.11-1.osg34.el6
cctools-debuginfo-7.0.11-1.osg34.el6
cctools-devel-7.0.11-1.osg34.el6
cvmfs-2.6.0-1.osg34.el6
cvmfs-devel-2.6.0-1.osg34.el6
cvmfs-server-2.6.0-1.osg34.el6
cvmfs-shrinkwrap-2.6.0-1.osg34.el6
cvmfs-unittests-2.6.0-1.osg34.el6
globus-ftp-client-9.1-2.1.osg34.el6
globus-ftp-client-debuginfo-9.1-2.1.osg34.el6
globus-ftp-client-devel-9.1-2.1.osg34.el6
globus-ftp-client-doc-9.1-2.1.osg34.el6
globus-gridftp-server-13.9-1.1.osg34.el6
globus-gridftp-server-control-8.0-1.osg34.el6
globus-gridftp-server-control-debuginfo-8.0-1.osg34.el6
globus-gridftp-server-control-devel-8.0-1.osg34.el6
globus-gridftp-server-debuginfo-13.9-1.1.osg34.el6
globus-gridftp-server-devel-13.9-1.1.osg34.el6
globus-gridftp-server-progs-13.9-1.1.osg34.el6
htcondor-ce-3.2.2-1.osg34.el6
htcondor-ce-bosco-3.2.2-1.osg34.el6
htcondor-ce-client-3.2.2-1.osg34.el6
htcondor-ce-collector-3.2.2-1.osg34.el6
htcondor-ce-condor-3.2.2-1.osg34.el6
htcondor-ce-lsf-3.2.2-1.osg34.el6
htcondor-ce-pbs-3.2.2-1.osg34.el6
htcondor-ce-sge-3.2.2-1.osg34.el6
htcondor-ce-slurm-3.2.2-1.osg34.el6
htcondor-ce-view-3.2.2-1.osg34.el6
koji-1.11.1-1.1.osg34.el6
koji-builder-1.11.1-1.1.osg34.el6
koji-hub-1.11.1-1.1.osg34.el6
koji-hub-plugins-1.11.1-1.1.osg34.el6
koji-utils-1.11.1-1.1.osg34.el6
koji-vm-1.11.1-1.1.osg34.el6
koji-web-1.11.1-1.1.osg34.el6
osg-build-1.14.2-1.osg34.el6
osg-build-base-1.14.2-1.osg34.el6
osg-build-koji-1.14.2-1.osg34.el6
osg-build-mock-1.14.2-1.osg34.el6
osg-build-tests-1.14.2-1.osg34.el6
osg-oasis-12-1.osg34.el6
osg-pki-tools-3.2.2-1.osg34.el6
osg-version-3.4.27-1.osg34.el6
```

#### Enterprise Linux 7

``` file
cctools-7.0.11-1.osg34.el7
cctools-debuginfo-7.0.11-1.osg34.el7
cctools-devel-7.0.11-1.osg34.el7
cvmfs-2.6.0-1.osg34.el7
cvmfs-devel-2.6.0-1.osg34.el7
cvmfs-ducc-2.6.0-1.osg34.el7
cvmfs-server-2.6.0-1.osg34.el7
cvmfs-shrinkwrap-2.6.0-1.osg34.el7
cvmfs-unittests-2.6.0-1.osg34.el7
globus-ftp-client-9.1-2.1.osg34.el7
globus-ftp-client-debuginfo-9.1-2.1.osg34.el7
globus-ftp-client-devel-9.1-2.1.osg34.el7
globus-ftp-client-doc-9.1-2.1.osg34.el7
globus-gridftp-server-13.9-1.1.osg34.el7
globus-gridftp-server-control-8.0-1.osg34.el7
globus-gridftp-server-control-debuginfo-8.0-1.osg34.el7
globus-gridftp-server-control-devel-8.0-1.osg34.el7
globus-gridftp-server-debuginfo-13.9-1.1.osg34.el7
globus-gridftp-server-devel-13.9-1.1.osg34.el7
globus-gridftp-server-progs-13.9-1.1.osg34.el7
htcondor-ce-3.2.2-1.osg34.el7
htcondor-ce-bosco-3.2.2-1.osg34.el7
htcondor-ce-client-3.2.2-1.osg34.el7
htcondor-ce-collector-3.2.2-1.osg34.el7
htcondor-ce-condor-3.2.2-1.osg34.el7
htcondor-ce-lsf-3.2.2-1.osg34.el7
htcondor-ce-pbs-3.2.2-1.osg34.el7
htcondor-ce-sge-3.2.2-1.osg34.el7
htcondor-ce-slurm-3.2.2-1.osg34.el7
htcondor-ce-view-3.2.2-1.osg34.el7
koji-1.11.1-1.1.osg34.el7
koji-builder-1.11.1-1.1.osg34.el7
koji-hub-1.11.1-1.1.osg34.el7
koji-hub-plugins-1.11.1-1.1.osg34.el7
koji-utils-1.11.1-1.1.osg34.el7
koji-vm-1.11.1-1.1.osg34.el7
koji-web-1.11.1-1.1.osg34.el7
osg-build-1.14.2-1.osg34.el7
osg-build-base-1.14.2-1.osg34.el7
osg-build-koji-1.14.2-1.osg34.el7
osg-build-mock-1.14.2-1.osg34.el7
osg-build-tests-1.14.2-1.osg34.el7
osg-oasis-12-1.osg34.el7
osg-pki-tools-3.2.2-1.osg34.el7
osg-version-3.4.27-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [singularity-3.1.1-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.1.1-1.osgup.el6)

#### Enterprise Linux 7

-   [singularity-3.1.1-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.1.1-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    singularity singularity-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
singularity-3.1.1-1.osgup.el6
singularity-debuginfo-3.1.1-1.osgup.el6
```

#### Enterprise Linux 7

``` file
singularity-3.1.1-1.osgup.el7
singularity-debuginfo-3.1.1-1.osgup.el7
```
