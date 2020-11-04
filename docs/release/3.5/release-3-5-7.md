OSG Software Release 3.5.7
===========================

**Release Date:** 2019-12-19    
**Supported OS Versions:** EL7

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 and 3.4 offer a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Summary of Changes
------------------

This release contains:

-   [HTCondor-CE 4.1.0](https://github.com/htcondor/htcondor-ce/releases/tag/v4.1.0): Bug fix release
    -   Fix an issue where `condor_ce_q` required authentication
    -   Re-enable the ability for local users to submit jobs to the CE queue
    -   Fix an issue where some jobs were capped at 72 minutes instead of 72 hours
-   [CVMFS 2.7.0](https://cvmfs.readthedocs.io/en/2.7/cpt-releasenotes.html): New feature release
    -   Fuse 3 Support
    -   Pre-mounted Repository
    -   POSIX ACLs
    -   Client Performance Instrumentation
-   [GlideinWMS 3.6.1](https://glideinwms.fnal.gov/doc.v3_6_1/history.html): Improved Singularity support
-   Simplify initial setup for stand-alone XRootD server
-   [HTCondor 8.8.6](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00020.shtml): Bug fix release
-   [HTCondor 8.9.4](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00021.shtml) in the upcoming repository
    -   Amazon S3 file transfers using pre-signed URLs
    -   Further reductions in DAGMan memory usage


These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.7%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

Known Issues
------------

- OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).


Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](/release/release_series#updating-to-osg-35).

For sites using non-RPM worker node client installations, new [tarballs](/worker-node/install-wn-tarball) and
[container images](/worker-node/using-wn-containers) are available:

- Tarball: <https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz>
- Container Images: <https://hub.docker.com/r/opensciencegrid/osg-wn/>

Need Help?
----------

Do you need help with this release? [Contact us for help](/common/help).

Detailed Changes in This Release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list [below](#rpms).

-   [condor-8.8.6-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.6-1.1.osg35.el7)
-   [cvmfs-2.7.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.0-1.osg35.el7)
-   [glideinwms-3.6.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6.1-1.osg35.el7)
-   [htcondor-ce-4.1.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-4.1.0-1.osg35.el7)
-   [osg-oasis-16-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-1.osg35.el7)
-   [osg-xrootd-3.5-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5-4.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp cvmfs cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view minicondor osg-oasis osg-xrootd osg-xrootd-standalone python2-condor python3-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
condor-8.8.6-1.1.osg35.el7
condor-all-8.8.6-1.1.osg35.el7
condor-annex-ec2-8.8.6-1.1.osg35.el7
condor-bosco-8.8.6-1.1.osg35.el7
condor-classads-8.8.6-1.1.osg35.el7
condor-classads-devel-8.8.6-1.1.osg35.el7
condor-debuginfo-8.8.6-1.1.osg35.el7
condor-kbdd-8.8.6-1.1.osg35.el7
condor-procd-8.8.6-1.1.osg35.el7
condor-test-8.8.6-1.1.osg35.el7
condor-vm-gahp-8.8.6-1.1.osg35.el7
cvmfs-2.7.0-1.osg35.el7
cvmfs-devel-2.7.0-1.osg35.el7
cvmfs-ducc-2.7.0-1.osg35.el7
cvmfs-fuse3-2.7.0-1.osg35.el7
cvmfs-server-2.7.0-1.osg35.el7
cvmfs-shrinkwrap-2.7.0-1.osg35.el7
cvmfs-unittests-2.7.0-1.osg35.el7
glideinwms-3.6.1-1.osg35.el7
glideinwms-common-tools-3.6.1-1.osg35.el7
glideinwms-condor-common-config-3.6.1-1.osg35.el7
glideinwms-factory-3.6.1-1.osg35.el7
glideinwms-factory-condor-3.6.1-1.osg35.el7
glideinwms-glidecondor-tools-3.6.1-1.osg35.el7
glideinwms-libs-3.6.1-1.osg35.el7
glideinwms-minimal-condor-3.6.1-1.osg35.el7
glideinwms-usercollector-3.6.1-1.osg35.el7
glideinwms-userschedd-3.6.1-1.osg35.el7
glideinwms-vofrontend-3.6.1-1.osg35.el7
glideinwms-vofrontend-standalone-3.6.1-1.osg35.el7
htcondor-ce-4.1.0-1.osg35.el7
htcondor-ce-bosco-4.1.0-1.osg35.el7
htcondor-ce-client-4.1.0-1.osg35.el7
htcondor-ce-collector-4.1.0-1.osg35.el7
htcondor-ce-condor-4.1.0-1.osg35.el7
htcondor-ce-lsf-4.1.0-1.osg35.el7
htcondor-ce-pbs-4.1.0-1.osg35.el7
htcondor-ce-sge-4.1.0-1.osg35.el7
htcondor-ce-slurm-4.1.0-1.osg35.el7
htcondor-ce-view-4.1.0-1.osg35.el7
minicondor-8.8.6-1.1.osg35.el7
osg-oasis-16-1.osg35.el7
osg-xrootd-3.5-4.osg35.el7
osg-xrootd-standalone-3.5-4.osg35.el7
python2-condor-8.8.6-1.1.osg35.el7
python3-condor-8.8.6-1.1.osg35.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

-   [condor-8.9.4-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.4-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
condor-8.9.4-1.osgup.el7
condor-all-8.9.4-1.osgup.el7
condor-annex-ec2-8.9.4-1.osgup.el7
condor-bosco-8.9.4-1.osgup.el7
condor-classads-8.9.4-1.osgup.el7
condor-classads-devel-8.9.4-1.osgup.el7
condor-debuginfo-8.9.4-1.osgup.el7
condor-kbdd-8.9.4-1.osgup.el7
condor-procd-8.9.4-1.osgup.el7
condor-test-8.9.4-1.osgup.el7
condor-vm-gahp-8.9.4-1.osgup.el7
minicondor-8.9.4-1.osgup.el7
python2-condor-8.9.4-1.osgup.el7
python3-condor-8.9.4-1.osgup.el7
```
