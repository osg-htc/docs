OSG Software Release 3.4.3
==========================

**Release Date**: 2017-09-12

Summary of changes
------------------

This release contains:

-   Updated to [CVMFS 2.4.1](http://cvmfs.readthedocs.io/en/2.4/cpt-releasenotes.html)
-   Updated to [Singularity 2.3.1](https://github.com/singularityware/singularity/releases/tag/2.3.1)
-   Updated to BLAHP 1.18.33
    -   Properly parses times from Slurm's sacct command
    -   pbs\_pro does not need to be defined to query PBS for job status
-   Updated to [XRootD 4.7.0](https://github.com/xrootd/xrootd/blob/v4.7.0/docs/ReleaseNotes.txt)
-   Updated to [StashCache 0.8](https://github.com/opensciencegrid/StashCache-Daemon/releases/tag/v0.8)
-   Updated Globus packages to latest EPEL versions
-   osg-ca-scripts now use HTTPS to download CA certificates
-   Added the ability to limit transfer load in the globus-gridftp-osg-extensions
-   Fixed a few memory management bugs in [xrootd-lcmaps](https://github.com/opensciencegrid/xrootd-lcmaps/releases/tag/v1.3.4)
-   [HTCondor CE 3.0.2](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v3.0.2) reports an error if `JOB_ROUTER_ENTRIES` are not defined
-   osg-configure 2.2.0 - remove last vestiges of GRAM

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.3%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note
    OSG 3.4 contains only 64-bit components.

!!! note
    StashCache is supported on EL7 only.

!!! note 
    xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found [here](../../).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details`. This warning can safely be ignored.
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the October release.
-   In GlideinWMS, a small configuration change must be added to account for changes in HTCondor 8.6. Add the following line to the HTCondor configuration.

        COLLECTOR.USE_SHARED_PORT=False

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

-   [blahp-1.18.33.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.33.bosco-1.osg34.el6)
-   [cvmfs-2.4.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.4.1-1.osg34.el6)
-   [globus-ftp-client-8.36-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-8.36-1.1.osg34.el6)
-   [globus-gridftp-osg-extensions-0.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.4-1.osg34.el6)
-   [globus-gridftp-server-12.2-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.2-1.1.osg34.el6)
-   [globus-gridftp-server-control-5.1-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-5.1-1.1.osg34.el6)
-   [htcondor-ce-3.0.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.0.2-1.osg34.el6)
-   [myproxy-6.1.28-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.1.28-1.1.osg34.el6)
-   [osg-ca-scripts-1.1.7-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.7-1.osg34.el6)
-   [osg-configure-2.2.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.0-1.osg34.el6)
-   [osg-oasis-8-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-8-1.osg34.el6)
-   [osg-test-1.11.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.2-1.osg34.el6)
-   [osg-version-3.4.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.3-1.osg34.el6)
-   [singularity-2.3.1-0.1.4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.3.1-0.1.4.osg34.el6)
-   [xrootd-4.7.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.7.0-1.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.33.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.33.bosco-1.osg34.el7)
-   [cvmfs-2.4.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.4.1-1.osg34.el7)
-   [globus-ftp-client-8.36-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-8.36-1.1.osg34.el7)
-   [globus-gridftp-osg-extensions-0.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.4-1.osg34.el7)
-   [globus-gridftp-server-12.2-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.2-1.1.osg34.el7)
-   [globus-gridftp-server-control-5.1-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-5.1-1.1.osg34.el7)
-   [htcondor-ce-3.0.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.0.2-1.osg34.el7)
-   [myproxy-6.1.28-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.1.28-1.1.osg34.el7)
-   [osg-ca-scripts-1.1.7-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.7-1.osg34.el7)
-   [osg-configure-2.2.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.0-1.osg34.el7)
-   [osg-oasis-8-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-8-1.osg34.el7)
-   [osg-test-1.11.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.2-1.osg34.el7)
-   [osg-version-3.4.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.3-1.osg34.el7)
-   [singularity-2.3.1-0.1.4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.3.1-0.1.4.osg34.el7)
-   [stashcache-0.8-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-0.8-1.osg34.el7)
-   [xrootd-4.7.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.7.0-1.osg34.el7)
-   [xrootd-lcmaps-1.3.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.3.4-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo cvmfs cvmfs-devel cvmfs-server cvmfs-unittests globus-ftp-client globus-ftp-client-debuginfo globus-ftp-client-devel globus-ftp-client-doc globus-gridftp-osg-extensions globus-gridftp-osg-extensions-debuginfo globus-gridftp-server globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-ca-certs osg-ca-scripts osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-oasis osg-test osg-test-log-viewer osg-version singularity singularity-debuginfo singularity-devel singularity-runtime xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.33.bosco-1.osg34.el6
blahp-debuginfo-1.18.33.bosco-1.osg34.el6
cvmfs-2.4.1-1.osg34.el6
cvmfs-devel-2.4.1-1.osg34.el6
cvmfs-server-2.4.1-1.osg34.el6
cvmfs-unittests-2.4.1-1.osg34.el6
globus-ftp-client-8.36-1.1.osg34.el6
globus-ftp-client-debuginfo-8.36-1.1.osg34.el6
globus-ftp-client-devel-8.36-1.1.osg34.el6
globus-ftp-client-doc-8.36-1.1.osg34.el6
globus-gridftp-osg-extensions-0.4-1.osg34.el6
globus-gridftp-osg-extensions-debuginfo-0.4-1.osg34.el6
globus-gridftp-server-12.2-1.1.osg34.el6
globus-gridftp-server-control-5.1-1.1.osg34.el6
globus-gridftp-server-control-debuginfo-5.1-1.1.osg34.el6
globus-gridftp-server-control-devel-5.1-1.1.osg34.el6
globus-gridftp-server-debuginfo-12.2-1.1.osg34.el6
globus-gridftp-server-devel-12.2-1.1.osg34.el6
globus-gridftp-server-progs-12.2-1.1.osg34.el6
htcondor-ce-3.0.2-1.osg34.el6
htcondor-ce-bosco-3.0.2-1.osg34.el6
htcondor-ce-client-3.0.2-1.osg34.el6
htcondor-ce-collector-3.0.2-1.osg34.el6
htcondor-ce-condor-3.0.2-1.osg34.el6
htcondor-ce-lsf-3.0.2-1.osg34.el6
htcondor-ce-pbs-3.0.2-1.osg34.el6
htcondor-ce-sge-3.0.2-1.osg34.el6
htcondor-ce-slurm-3.0.2-1.osg34.el6
htcondor-ce-view-3.0.2-1.osg34.el6
myproxy-6.1.28-1.1.osg34.el6
myproxy-admin-6.1.28-1.1.osg34.el6
myproxy-debuginfo-6.1.28-1.1.osg34.el6
myproxy-devel-6.1.28-1.1.osg34.el6
myproxy-doc-6.1.28-1.1.osg34.el6
myproxy-libs-6.1.28-1.1.osg34.el6
myproxy-server-6.1.28-1.1.osg34.el6
myproxy-voms-6.1.28-1.1.osg34.el6
osg-ca-scripts-1.1.7-1.osg34.el6
osg-configure-2.2.0-1.osg34.el6
osg-configure-bosco-2.2.0-1.osg34.el6
osg-configure-ce-2.2.0-1.osg34.el6
osg-configure-condor-2.2.0-1.osg34.el6
osg-configure-gateway-2.2.0-1.osg34.el6
osg-configure-gip-2.2.0-1.osg34.el6
osg-configure-gratia-2.2.0-1.osg34.el6
osg-configure-infoservices-2.2.0-1.osg34.el6
osg-configure-lsf-2.2.0-1.osg34.el6
osg-configure-managedfork-2.2.0-1.osg34.el6
osg-configure-misc-2.2.0-1.osg34.el6
osg-configure-network-2.2.0-1.osg34.el6
osg-configure-pbs-2.2.0-1.osg34.el6
osg-configure-rsv-2.2.0-1.osg34.el6
osg-configure-sge-2.2.0-1.osg34.el6
osg-configure-slurm-2.2.0-1.osg34.el6
osg-configure-squid-2.2.0-1.osg34.el6
osg-configure-tests-2.2.0-1.osg34.el6
osg-oasis-8-1.osg34.el6
osg-test-1.11.2-1.osg34.el6
osg-test-log-viewer-1.11.2-1.osg34.el6
osg-version-3.4.3-1.osg34.el6
singularity-2.3.1-0.1.4.osg34.el6
singularity-debuginfo-2.3.1-0.1.4.osg34.el6
singularity-devel-2.3.1-0.1.4.osg34.el6
singularity-runtime-2.3.1-0.1.4.osg34.el6
xrootd-4.7.0-1.osg34.el6
xrootd-client-4.7.0-1.osg34.el6
xrootd-client-devel-4.7.0-1.osg34.el6
xrootd-client-libs-4.7.0-1.osg34.el6
xrootd-debuginfo-4.7.0-1.osg34.el6
xrootd-devel-4.7.0-1.osg34.el6
xrootd-doc-4.7.0-1.osg34.el6
xrootd-fuse-4.7.0-1.osg34.el6
xrootd-libs-4.7.0-1.osg34.el6
xrootd-private-devel-4.7.0-1.osg34.el6
xrootd-python-4.7.0-1.osg34.el6
xrootd-selinux-4.7.0-1.osg34.el6
xrootd-server-4.7.0-1.osg34.el6
xrootd-server-devel-4.7.0-1.osg34.el6
xrootd-server-libs-4.7.0-1.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.33.bosco-1.osg34.el7
blahp-debuginfo-1.18.33.bosco-1.osg34.el7
cvmfs-2.4.1-1.osg34.el7
cvmfs-devel-2.4.1-1.osg34.el7
cvmfs-server-2.4.1-1.osg34.el7
cvmfs-unittests-2.4.1-1.osg34.el7
globus-ftp-client-8.36-1.1.osg34.el7
globus-ftp-client-debuginfo-8.36-1.1.osg34.el7
globus-ftp-client-devel-8.36-1.1.osg34.el7
globus-ftp-client-doc-8.36-1.1.osg34.el7
globus-gridftp-osg-extensions-0.4-1.osg34.el7
globus-gridftp-osg-extensions-debuginfo-0.4-1.osg34.el7
globus-gridftp-server-12.2-1.1.osg34.el7
globus-gridftp-server-control-5.1-1.1.osg34.el7
globus-gridftp-server-control-debuginfo-5.1-1.1.osg34.el7
globus-gridftp-server-control-devel-5.1-1.1.osg34.el7
globus-gridftp-server-debuginfo-12.2-1.1.osg34.el7
globus-gridftp-server-devel-12.2-1.1.osg34.el7
globus-gridftp-server-progs-12.2-1.1.osg34.el7
htcondor-ce-3.0.2-1.osg34.el7
htcondor-ce-bosco-3.0.2-1.osg34.el7
htcondor-ce-client-3.0.2-1.osg34.el7
htcondor-ce-collector-3.0.2-1.osg34.el7
htcondor-ce-condor-3.0.2-1.osg34.el7
htcondor-ce-lsf-3.0.2-1.osg34.el7
htcondor-ce-pbs-3.0.2-1.osg34.el7
htcondor-ce-sge-3.0.2-1.osg34.el7
htcondor-ce-slurm-3.0.2-1.osg34.el7
htcondor-ce-view-3.0.2-1.osg34.el7
myproxy-6.1.28-1.1.osg34.el7
myproxy-admin-6.1.28-1.1.osg34.el7
myproxy-debuginfo-6.1.28-1.1.osg34.el7
myproxy-devel-6.1.28-1.1.osg34.el7
myproxy-doc-6.1.28-1.1.osg34.el7
myproxy-libs-6.1.28-1.1.osg34.el7
myproxy-server-6.1.28-1.1.osg34.el7
myproxy-voms-6.1.28-1.1.osg34.el7
osg-ca-scripts-1.1.7-1.osg34.el7
osg-configure-2.2.0-1.osg34.el7
osg-configure-bosco-2.2.0-1.osg34.el7
osg-configure-ce-2.2.0-1.osg34.el7
osg-configure-condor-2.2.0-1.osg34.el7
osg-configure-gateway-2.2.0-1.osg34.el7
osg-configure-gip-2.2.0-1.osg34.el7
osg-configure-gratia-2.2.0-1.osg34.el7
osg-configure-infoservices-2.2.0-1.osg34.el7
osg-configure-lsf-2.2.0-1.osg34.el7
osg-configure-managedfork-2.2.0-1.osg34.el7
osg-configure-misc-2.2.0-1.osg34.el7
osg-configure-network-2.2.0-1.osg34.el7
osg-configure-pbs-2.2.0-1.osg34.el7
osg-configure-rsv-2.2.0-1.osg34.el7
osg-configure-sge-2.2.0-1.osg34.el7
osg-configure-slurm-2.2.0-1.osg34.el7
osg-configure-squid-2.2.0-1.osg34.el7
osg-configure-tests-2.2.0-1.osg34.el7
osg-oasis-8-1.osg34.el7
osg-test-1.11.2-1.osg34.el7
osg-test-log-viewer-1.11.2-1.osg34.el7
osg-version-3.4.3-1.osg34.el7
singularity-2.3.1-0.1.4.osg34.el7
singularity-debuginfo-2.3.1-0.1.4.osg34.el7
singularity-devel-2.3.1-0.1.4.osg34.el7
singularity-runtime-2.3.1-0.1.4.osg34.el7
stashcache-0.8-1.osg34.el7
stashcache-cache-server-0.8-1.osg34.el7
stashcache-daemon-0.8-1.osg34.el7
stashcache-origin-server-0.8-1.osg34.el7
xrootd-4.7.0-1.osg34.el7
xrootd-client-4.7.0-1.osg34.el7
xrootd-client-devel-4.7.0-1.osg34.el7
xrootd-client-libs-4.7.0-1.osg34.el7
xrootd-debuginfo-4.7.0-1.osg34.el7
xrootd-devel-4.7.0-1.osg34.el7
xrootd-doc-4.7.0-1.osg34.el7
xrootd-fuse-4.7.0-1.osg34.el7
xrootd-lcmaps-1.3.4-1.osg34.el7
xrootd-lcmaps-debuginfo-1.3.4-1.osg34.el7
xrootd-libs-4.7.0-1.osg34.el7
xrootd-private-devel-4.7.0-1.osg34.el7
xrootd-python-4.7.0-1.osg34.el7
xrootd-selinux-4.7.0-1.osg34.el7
xrootd-server-4.7.0-1.osg34.el7
xrootd-server-devel-4.7.0-1.osg34.el7
xrootd-server-libs-4.7.0-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.33.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.33.bosco-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.33.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.33.bosco-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.33.bosco-1.osgup.el6
blahp-debuginfo-1.18.33.bosco-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.33.bosco-1.osgup.el7
blahp-debuginfo-1.18.33.bosco-1.osgup.el7
```

