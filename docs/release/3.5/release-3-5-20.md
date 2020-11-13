OSG Software Release 3.5.20
===========================

**Release Date:** 2020-07-23    
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

-   [HTCondor-CE 4.4.0](https://github.com/htcondor/htcondor-ce/releases/tag/v4.4.0)
    -   Compared to version 4.2.1, this release includes the following new features
        -   Identify broken job routes upon startup
        -   Add configuration option (COMPLETED_JOB_EXPIRATION) for how many days completed jobs may stay in the queue
        -   Add the CE registry web application to the Central Collector
            -   The registry provides an interface to OSG site administrators of HTCondor-CEs to retrieve an HTCondor IDTOKEN for authenticating pilot job submissions.
        -   Add plug-in interface to HTCondor-CE View and separate out OSG-specific code and configuration
    -   Bug fixes
        -   Fix HTCondor-CE View SchedD query that caused "Info" tables to be blank
        -   Fix handling of unmapped GSI users in the Central Collector
-   [CVMFS 2.7.3](https://cvmfs.readthedocs.io/en/2.7/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-7-3)
    -   Client / EL8: fix spurious SElinux error message during package upgrade
    -   Client: fix cvmfs\_config chksetup for squashed NFS alien cache
    -   Server: fix handling of .cvmfs\_status.json after garbage collection
    -   Server: add add-replica -P option to create pass-through replicas
-   [Frontier Squid 4.12-2.1](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES)
    -   Fixed cache poisoning issue in HTTP request processing
    -   Support the "stdio:" prefix for access\_log
-   scitokens-cpp 0.5.1: Add support for WLCG-style storage write permissions


These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.20%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.


Containers
----------

The `Frontier Squid` container is available and has been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [Frontier Squid](https://hub.docker.com/r/opensciencegrid/frontier-squid/)


The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.


Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](../release_series.md#updating-to-osg-35).

For sites using non-RPM worker node client installations, new [tarballs](../../worker-node/install-wn-tarball.md) and
[container images](../../worker-node/using-wn-containers.md) are available:

- Tarball: <https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz>
- Container Images: <https://hub.docker.com/r/opensciencegrid/osg-wn/>

Need Help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed Changes in This Release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list [below](#rpms).

-   [cvmfs-2.7.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.3-1.osg35.el7)
-   [cvmfs-config-osg-2.4-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.4-4.osg35.el7)
-   [frontier-squid-4.12-2.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.12-2.1.osg35.el7)
-   [htcondor-ce-4.4.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-4.4.0-1.osg35.el7)
-   [osg-oasis-16-5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-5.osg35.el7)
-   [scitokens-cpp-0.5.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.5.1-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cvmfs cvmfs-config-osg cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests frontier-squid htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view osg-oasis scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
cvmfs-2.7.3-1.osg35.el7
cvmfs-config-osg-2.4-4.osg35.el7
cvmfs-devel-2.7.3-1.osg35.el7
cvmfs-ducc-2.7.3-1.osg35.el7
cvmfs-fuse3-2.7.3-1.osg35.el7
cvmfs-server-2.7.3-1.osg35.el7
cvmfs-shrinkwrap-2.7.3-1.osg35.el7
cvmfs-unittests-2.7.3-1.osg35.el7
frontier-squid-4.12-2.1.osg35.el7
htcondor-ce-4.4.0-1.osg35.el7
htcondor-ce-bosco-4.4.0-1.osg35.el7
htcondor-ce-client-4.4.0-1.osg35.el7
htcondor-ce-collector-4.4.0-1.osg35.el7
htcondor-ce-condor-4.4.0-1.osg35.el7
htcondor-ce-lsf-4.4.0-1.osg35.el7
htcondor-ce-pbs-4.4.0-1.osg35.el7
htcondor-ce-sge-4.4.0-1.osg35.el7
htcondor-ce-slurm-4.4.0-1.osg35.el7
htcondor-ce-view-4.4.0-1.osg35.el7
osg-oasis-16-5.osg35.el7
scitokens-cpp-0.5.1-1.osg35.el7
scitokens-cpp-debuginfo-0.5.1-1.osg35.el7
scitokens-cpp-devel-0.5.1-1.osg35.el7
```
