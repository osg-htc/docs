OSG Software Release 3.5.21
===========================

**Release Date:** 2020-07-30    
**Supported OS Versions:** EL7, EL8

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

-   The worker node client and OASIS are now supported on Enterprise Linux 8
-   [HTCondor-CE 4.4.1](https://github.com/htcondor/htcondor-ce/releases/tag/v4.4.1)
    -   Fixed a race condition that could cause removed jobs to be put on hold
    -   Improve performance of the HTCondor-CE View
-   osg-flock 1.1-2: Fix CA requirements to work with osg-ca-scripts
-   osg-pki-tools 3.4.0: Add option to specify Organizational Unit in the CSR
-   osg-system-profiler 1.6.0: Report which Python versions are installed
-   osg-xrootd 3.5-13: Reduce the default amount of logging
-   [stashcache-client 6.0.0](https://github.com/opensciencegrid/StashCache/releases/tag/v6.0.0): Add Python 3 support

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.21%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

!!!note 
    To enable OSG repositories on Enterprise Linux 8, follow the OSG repository [instructions](/common/yum/#enable-additional-os-repositories).

Containers
----------

The `Hosted CE` container is available and has been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [Hosted CE](https://hub.docker.com/r/opensciencegrid/hosted-ce/)


The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.


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

#### Enterprise Linux 7

-   [htcondor-ce-4.4.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-4.4.1-1.osg35.el7)
-   [osg-flock-1.1-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.1-2.osg35.el7)
-   [osg-pki-tools-3.4.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.4.0-1.osg35.el7)
-   [osg-system-profiler-1.6.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.6.0-1.osg35.el7)
-   [osg-wn-client-3.5-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.5-4.osg35.el7)
-   [osg-xrootd-3.5-13.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5-13.osg35.el7)
-   [stashcache-client-6.0.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-6.0.0-1.osg35.el7)

#### Enterprise Linux 8

-   [cvmfs-2.7.3-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.3-1.osg35.el8)
-   [cvmfs-config-osg-2.4-4.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.4-4.osg35.el8)
-   [cvmfs-x509-helper-2.1-2.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-2.1-2.1.osg35.el8)
-   [igtf-ca-certs-1.106-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.106-1.osg35.el8)
-   [osg-ca-certs-1.88-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.88-1.osg35.el8)
-   [osg-ca-scripts-1.2.4-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.4-1.osg35.el8)
-   [osg-oasis-16-5.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-5.osg35.el8)
-   [osg-system-profiler-1.6.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.6.0-1.osg35.el8)
-   [osg-update-vos-1.4.0-2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-update-vos-1.4.0-2.osg35.el8)
-   [osg-wn-client-3.5-4.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.5-4.osg35.el8)
-   [stashcache-client-6.0.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-6.0.0-1.osg35.el8)
-   [vo-client-106-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-106-1.osg35.el8)
-   [voms-2.1.0-0.14.rc0.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.1.0-0.14.rc0.1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view osg-flock osg-pki-tools osg-system-profiler osg-system-profiler-viewer osg-wn-client osg-xrootd osg-xrootd-standalone stashcache-client

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
htcondor-ce-4.4.1-1.osg35.el7
htcondor-ce-bosco-4.4.1-1.osg35.el7
htcondor-ce-client-4.4.1-1.osg35.el7
htcondor-ce-collector-4.4.1-1.osg35.el7
htcondor-ce-condor-4.4.1-1.osg35.el7
htcondor-ce-lsf-4.4.1-1.osg35.el7
htcondor-ce-pbs-4.4.1-1.osg35.el7
htcondor-ce-sge-4.4.1-1.osg35.el7
htcondor-ce-slurm-4.4.1-1.osg35.el7
htcondor-ce-view-4.4.1-1.osg35.el7
osg-flock-1.1-2.osg35.el7
osg-pki-tools-3.4.0-1.osg35.el7
osg-system-profiler-1.6.0-1.osg35.el7
osg-system-profiler-viewer-1.6.0-1.osg35.el7
osg-wn-client-3.5-4.osg35.el7
osg-xrootd-3.5-13.osg35.el7
osg-xrootd-standalone-3.5-13.osg35.el7
stashcache-client-6.0.0-1.osg35.el7
```

#### Enterprise Linux 8

``` file
cvmfs-2.7.3-1.osg35.el8
cvmfs-config-osg-2.4-4.osg35.el8
cvmfs-devel-2.7.3-1.osg35.el8
cvmfs-ducc-2.7.3-1.osg35.el8
cvmfs-fuse3-2.7.3-1.osg35.el8
cvmfs-server-2.7.3-1.osg35.el8
cvmfs-shrinkwrap-2.7.3-1.osg35.el8
cvmfs-unittests-2.7.3-1.osg35.el8
cvmfs-x509-helper-2.1-2.1.osg35.el8
cvmfs-x509-helper-debuginfo-2.1-2.1.osg35.el8
cvmfs-x509-helper-debugsource-2.1-2.1.osg35.el8
igtf-ca-certs-1.106-1.osg35.el8
osg-ca-certs-1.88-1.osg35.el8
osg-ca-scripts-1.2.4-1.osg35.el8
osg-oasis-16-5.osg35.el8
osg-system-profiler-1.6.0-1.osg35.el8
osg-system-profiler-viewer-1.6.0-1.osg35.el8
osg-update-data-1.4.0-2.osg35.el8
osg-update-vos-1.4.0-2.osg35.el8
osg-wn-client-3.5-4.osg35.el8
stashcache-client-6.0.0-1.osg35.el8
vo-client-106-1.osg35.el8
vo-client-dcache-106-1.osg35.el8
vo-client-lcmaps-voms-106-1.osg35.el8
voms-2.1.0-0.14.rc0.1.osg35.el8
voms-clients-cpp-2.1.0-0.14.rc0.1.osg35.el8
voms-clients-cpp-debuginfo-2.1.0-0.14.rc0.1.osg35.el8
voms-debuginfo-2.1.0-0.14.rc0.1.osg35.el8
voms-debugsource-2.1.0-0.14.rc0.1.osg35.el8
voms-devel-2.1.0-0.14.rc0.1.osg35.el8
voms-doc-2.1.0-0.14.rc0.1.osg35.el8
voms-server-2.1.0-0.14.rc0.1.osg35.el8
voms-server-debuginfo-2.1.0-0.14.rc0.1.osg35.el8
```
