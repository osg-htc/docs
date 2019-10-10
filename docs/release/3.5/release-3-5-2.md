OSG Software Release 3.5.2
===========================

**Release Date:** 2019-10-10
**Supported OS Versions:** EL7

Summary of Changes
------------------

This release contains:

-   HTCondor-CE 4.0.1
    -   [Some manual adjustments are required](/release/release_series#updating-to-htcondor-ce-4x)
    -   4.0.0: [Major feature update](https://github.com/htcondor/htcondor-ce/releases/tag/v4.0.0)
        -   SciTokens support
        -   Disabled job retries
        -   Simplified remote CE requirements format for non-HTCondor batch systems
        -   Major configuration reorganization
    -   4.0.1: [bug fix](https://github.com/htcondor/htcondor-ce/releases/tag/v4.0.1)
-   OSG CE 3.5-2: Carries OSG specific CE configurations
-   [CVMFS 2.6.3](https://cvmfs.readthedocs.io/en/2.6/cpt-releasenotes.html): Bug fix release
-   [Frontier-Squid 4.8-2](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): Add support for shoal-agent
-   [CCTools 7.0.18](http://ccl.cse.nd.edu/software/): Bug fix release
-   LCMAPS 1.6.6-1.9: Rebuilt to ease transition from OSG 3.3
-   [VO Package v96](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-96): Add LHCb VO

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.2%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

Known Issues
------------

- OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).


Containers
----------

Several containers are available and have been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [ATLAS XCache](https://hub.docker.com/r/opensciencegrid/atlas-xcache/)
-   [CMS XCache](https://hub.docker.com/r/opensciencegrid/cms-xcache/)
-   [Frontier Squid](https://hub.docker.com/r/opensciencegrid/frontier-squid/)
-   [Stash Cache](https://hub.docker.com/r/opensciencegrid/stash-cache/)

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

-   [cctools-7.0.18-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.18-1.osg35.el7)
-   [cvmfs-2.6.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.6.3-1.osg35.el7)
-   [cvmfs-x509-helper-2.1-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-2.1-2.osg35.el7)
-   [frontier-squid-4.8-2.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.8-2.1.osg35.el7)
-   [hosted-ce-tools-0.4-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.4-1.osg35.el7)
-   [htcondor-ce-4.0.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-4.0.1-1.osg35.el7)
-   [osg-ce-3.5-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.5-2.osg35.el7)
-   [osg-oasis-15-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-15-4.osg35.el7)
-   [vo-client-96-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-96-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cctools cctools-debuginfo cctools-devel cvmfs cvmfs-devel cvmfs-ducc cvmfs-server cvmfs-shrinkwrap cvmfs-unittests cvmfs-x509-helper cvmfs-x509-helper-debuginfo frontier-squid frontier-squid-debuginfo hosted-ce-tools htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-oasis vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
cctools-7.0.18-1.osg35.el7
cctools-debuginfo-7.0.18-1.osg35.el7
cctools-devel-7.0.18-1.osg35.el7
cvmfs-2.6.3-1.osg35.el7
cvmfs-devel-2.6.3-1.osg35.el7
cvmfs-ducc-2.6.3-1.osg35.el7
cvmfs-server-2.6.3-1.osg35.el7
cvmfs-shrinkwrap-2.6.3-1.osg35.el7
cvmfs-unittests-2.6.3-1.osg35.el7
cvmfs-x509-helper-2.1-2.osg35.el7
cvmfs-x509-helper-debuginfo-2.1-2.osg35.el7
frontier-squid-4.8-2.1.osg35.el7
frontier-squid-debuginfo-4.8-2.1.osg35.el7
hosted-ce-tools-0.4-1.osg35.el7
htcondor-ce-4.0.1-1.osg35.el7
htcondor-ce-bosco-4.0.1-1.osg35.el7
htcondor-ce-client-4.0.1-1.osg35.el7
htcondor-ce-collector-4.0.1-1.osg35.el7
htcondor-ce-condor-4.0.1-1.osg35.el7
htcondor-ce-lsf-4.0.1-1.osg35.el7
htcondor-ce-pbs-4.0.1-1.osg35.el7
htcondor-ce-sge-4.0.1-1.osg35.el7
htcondor-ce-slurm-4.0.1-1.osg35.el7
htcondor-ce-view-4.0.1-1.osg35.el7
osg-ce-3.5-2.osg35.el7
osg-ce-bosco-3.5-2.osg35.el7
osg-ce-condor-3.5-2.osg35.el7
osg-ce-lsf-3.5-2.osg35.el7
osg-ce-pbs-3.5-2.osg35.el7
osg-ce-sge-3.5-2.osg35.el7
osg-ce-slurm-3.5-2.osg35.el7
osg-oasis-15-4.osg35.el7
vo-client-96-1.osg35.el7
vo-client-dcache-96-1.osg35.el7
vo-client-lcmaps-voms-96-1.osg35.el7
```
