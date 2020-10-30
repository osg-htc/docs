OSG Software Release 3.4.22
===========================

**Release Date**: 2018-12-20

Summary of changes
------------------

This release contains:

-   [HTCondor-CE 3.2.0](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v3.2.0): [Accept pilot jobs authenticated with host certificates signed by a VO](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3489)
-   [frontier-squid 4.4](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES): Update from 3.5.28
-   [Pegasus 4.9.0](https://pegasus.isi.edu/2018/10/31/pegasus-4-9-0-released/): Update from 4.8.4
-   HTCondor 8.6.13: [Patched memory leak when remote daemon is offline](https://htcondor-wiki.cs.wisc.edu/index.cgi/tktview?tn=6837)
-   osg-ca-scripts 1.2.4: Drop MD5 checksum requirement, prefer SHA256
-   stashcache-client 5.2.0: Can install stashcp locally, without using CVMFS
-   [CVMFS 2.5.2](https://cvmfs.readthedocs.io/en/2.5/cpt-releasenotes.html):  Bug fix release
-   osg-wn-client 3.4-5: Include stashcp on the worker-node
-   Certificate Authority certificates based on [IGTF 1.94](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   extended validity period for the ArmeSFo CA (AM)
    -   withdrawn expiring DFN-SLCS CA (DE)
-   [VO Package v85](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-85)
    -   Update `INFN` CA DN
    -   Add backup VOMS server for `enmr.eu` and `glast.org`

!!! important "Important HTCondor-CE update"
    This release of HTCondor-CE adds support for pilot jobs authenticating
    with host certificates signed by a VO.  Due to the expiration of service
    certificates starting in April 2019, it is important to update to this
    version to continue to receive OSG jobs.
    Be sure to watch out for `/etc/condor-ce/condor_mapfile.rpmnew` and merge
    any changes into `/etc/condor-ce/condor_mapfile`.

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.22%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found [here](../../index.md).

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

-   [condor-8.6.13-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.13-1.1.osg34.el6)
-   [cvmfs-2.5.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.5.2-1.osg34.el6)
-   [cvmfs-gateway-0.3.1-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-gateway-0.3.1-1.1.osg34.el6)
-   [frontier-squid-4.4-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.4-1.1.osg34.el6)
-   [htcondor-ce-3.2.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.2.0-1.osg34.el6)
-   [igtf-ca-certs-1.94-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.94-2.osg34.el6)
-   [osg-ca-certs-1.77-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.77-1.osg34.el6)
-   [osg-ca-scripts-1.2.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.4-1.osg34.el6)
-   [osg-oasis-11-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-11-1.osg34.el6)
-   [osg-test-2.3.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.3.0-1.osg34.el6)
-   [osg-version-3.4.22-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.22-1.osg34.el6)
-   [osg-wn-client-3.4-5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.4-5.osg34.el6)
-   [pegasus-4.9.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.9.0-1.osg34.el6)
-   [stashcache-client-5.2.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-5.2.0-1.osg34.el6)
-   [vo-client-85-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-85-1.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.6.13-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.13-1.1.osg34.el7)
-   [cvmfs-2.5.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.5.2-1.osg34.el7)
-   [cvmfs-gateway-0.3.1-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-gateway-0.3.1-1.1.osg34.el7)
-   [frontier-squid-4.4-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.4-1.1.osg34.el7)
-   [htcondor-ce-3.2.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.2.0-1.osg34.el7)
-   [igtf-ca-certs-1.94-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.94-2.osg34.el7)
-   [osg-ca-certs-1.77-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.77-1.osg34.el7)
-   [osg-ca-scripts-1.2.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.4-1.osg34.el7)
-   [osg-oasis-11-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-11-1.osg34.el7)
-   [osg-test-2.3.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.3.0-1.osg34.el7)
-   [osg-version-3.4.22-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.22-1.osg34.el7)
-   [osg-wn-client-3.4-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.4-5.osg34.el7)
-   [pegasus-4.9.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.9.0-1.osg34.el7)
-   [stashcache-client-5.2.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-5.2.0-1.osg34.el7)
-   [vo-client-85-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-85-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-devel cvmfs-gateway cvmfs-server cvmfs-unittests frontier-squid frontier-squid-debuginfo htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs osg-ca-certs osg-ca-scripts osg-gums-config osg-oasis osg-test osg-test-log-viewer osg-version osg-wn-client pegasus pegasus-debuginfo stashcache-client vo-client vo-client-dcache vo-client-edgmkgridmap vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.6.13-1.1.osg34.el6
condor-all-8.6.13-1.1.osg34.el6
condor-bosco-8.6.13-1.1.osg34.el6
condor-classads-8.6.13-1.1.osg34.el6
condor-classads-devel-8.6.13-1.1.osg34.el6
condor-cream-gahp-8.6.13-1.1.osg34.el6
condor-debuginfo-8.6.13-1.1.osg34.el6
condor-kbdd-8.6.13-1.1.osg34.el6
condor-procd-8.6.13-1.1.osg34.el6
condor-python-8.6.13-1.1.osg34.el6
condor-std-universe-8.6.13-1.1.osg34.el6
condor-test-8.6.13-1.1.osg34.el6
condor-vm-gahp-8.6.13-1.1.osg34.el6
cvmfs-2.5.2-1.osg34.el6
cvmfs-devel-2.5.2-1.osg34.el6
cvmfs-gateway-0.3.1-1.1.osg34.el6
cvmfs-server-2.5.2-1.osg34.el6
cvmfs-unittests-2.5.2-1.osg34.el6
frontier-squid-4.4-1.1.osg34.el6
frontier-squid-debuginfo-4.4-1.1.osg34.el6
htcondor-ce-3.2.0-1.osg34.el6
htcondor-ce-bosco-3.2.0-1.osg34.el6
htcondor-ce-client-3.2.0-1.osg34.el6
htcondor-ce-collector-3.2.0-1.osg34.el6
htcondor-ce-condor-3.2.0-1.osg34.el6
htcondor-ce-lsf-3.2.0-1.osg34.el6
htcondor-ce-pbs-3.2.0-1.osg34.el6
htcondor-ce-sge-3.2.0-1.osg34.el6
htcondor-ce-slurm-3.2.0-1.osg34.el6
htcondor-ce-view-3.2.0-1.osg34.el6
igtf-ca-certs-1.94-2.osg34.el6
osg-ca-certs-1.77-1.osg34.el6
osg-ca-scripts-1.2.4-1.osg34.el6
osg-gums-config-85-1.osg34.el6
osg-oasis-11-1.osg34.el6
osg-test-2.3.0-1.osg34.el6
osg-test-log-viewer-2.3.0-1.osg34.el6
osg-version-3.4.22-1.osg34.el6
osg-wn-client-3.4-5.osg34.el6
pegasus-4.9.0-1.osg34.el6
pegasus-debuginfo-4.9.0-1.osg34.el6
stashcache-client-5.2.0-1.osg34.el6
vo-client-85-1.osg34.el6
vo-client-dcache-85-1.osg34.el6
vo-client-edgmkgridmap-85-1.osg34.el6
vo-client-lcmaps-voms-85-1.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.6.13-1.1.osg34.el7
condor-all-8.6.13-1.1.osg34.el7
condor-bosco-8.6.13-1.1.osg34.el7
condor-classads-8.6.13-1.1.osg34.el7
condor-classads-devel-8.6.13-1.1.osg34.el7
condor-cream-gahp-8.6.13-1.1.osg34.el7
condor-debuginfo-8.6.13-1.1.osg34.el7
condor-kbdd-8.6.13-1.1.osg34.el7
condor-procd-8.6.13-1.1.osg34.el7
condor-python-8.6.13-1.1.osg34.el7
condor-test-8.6.13-1.1.osg34.el7
condor-vm-gahp-8.6.13-1.1.osg34.el7
cvmfs-2.5.2-1.osg34.el7
cvmfs-devel-2.5.2-1.osg34.el7
cvmfs-gateway-0.3.1-1.1.osg34.el7
cvmfs-server-2.5.2-1.osg34.el7
cvmfs-unittests-2.5.2-1.osg34.el7
frontier-squid-4.4-1.1.osg34.el7
frontier-squid-debuginfo-4.4-1.1.osg34.el7
htcondor-ce-3.2.0-1.osg34.el7
htcondor-ce-bosco-3.2.0-1.osg34.el7
htcondor-ce-client-3.2.0-1.osg34.el7
htcondor-ce-collector-3.2.0-1.osg34.el7
htcondor-ce-condor-3.2.0-1.osg34.el7
htcondor-ce-lsf-3.2.0-1.osg34.el7
htcondor-ce-pbs-3.2.0-1.osg34.el7
htcondor-ce-sge-3.2.0-1.osg34.el7
htcondor-ce-slurm-3.2.0-1.osg34.el7
htcondor-ce-view-3.2.0-1.osg34.el7
igtf-ca-certs-1.94-2.osg34.el7
osg-ca-certs-1.77-1.osg34.el7
osg-ca-scripts-1.2.4-1.osg34.el7
osg-gums-config-85-1.osg34.el7
osg-oasis-11-1.osg34.el7
osg-test-2.3.0-1.osg34.el7
osg-test-log-viewer-2.3.0-1.osg34.el7
osg-version-3.4.22-1.osg34.el7
osg-wn-client-3.4-5.osg34.el7
pegasus-4.9.0-1.osg34.el7
pegasus-debuginfo-4.9.0-1.osg34.el7
stashcache-client-5.2.0-1.osg34.el7
vo-client-85-1.osg34.el7
vo-client-dcache-85-1.osg34.el7
vo-client-edgmkgridmap-85-1.osg34.el7
vo-client-lcmaps-voms-85-1.osg34.el7
```
