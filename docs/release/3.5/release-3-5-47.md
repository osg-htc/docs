OSG Software Release 3.5.47
===========================

**Release Date:** 2021-09-23  
**Supported OS Versions:** EL7, EL8

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 offers a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Summary of Changes
------------------

!!! important "Important HTCondor update for HTCondor-CEs"
    If you are running an HTCondor-CE with SciTokens and GSI Authentication, you should update to HTCondor 9.0.5
    at your earliest convenience.
    If you have not yet updated to HTCondor-CE 5 or HTCondor 9.0, please see [the update instructions](../updating-to-osg-35.md).

This release contains:

-   Upcoming
    -   [HTCondor-CE 5.1.2](https://github.com/htcondor/htcondor-ce/releases/tag/v5.1.2)
        -   Fixed the default memory and CPU requests when using job router transforms
        -   Apply default MaxJobs and MaxJobsIdle when using job router transforms
        -   Improved SciTokens support in submission tools
        -   Fixed --debug flag in condor\_ce\_run
        -   Update configuration verification script to handle job router transforms
        -   Corrected ownership of the HTCondor PER\_JOBS\_HISTORY\_DIR
        -   Fix bug passing maximum wall time requests to the local batch system

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.47-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [OSG Docker images](https://hub.docker.com/u/opensciencegrid/) have been updated to contain the new software.

Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](../updating-to-osg-35.md).

For sites using non-RPM worker node client installations, new [tarballs](../../worker-node/install-wn-tarball.md) and
[container images](../../worker-node/using-wn-containers.md) are available:

- Tarball: <https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz>
- Container Images: <https://hub.docker.com/r/opensciencegrid/osg-wn/>

Need Help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed Changes in This Release
--------------------------------

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [htcondor-ce-5.1.2-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-5.1.2-1.osg35up.el7)

#### Enterprise Linux 8

-   [htcondor-ce-5.1.2-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-5.1.2-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
htcondor-ce-5.1.2-1.osg35up.el7
htcondor-ce-bosco-5.1.2-1.osg35up.el7
htcondor-ce-client-5.1.2-1.osg35up.el7
htcondor-ce-collector-5.1.2-1.osg35up.el7
htcondor-ce-condor-5.1.2-1.osg35up.el7
htcondor-ce-lsf-5.1.2-1.osg35up.el7
htcondor-ce-pbs-5.1.2-1.osg35up.el7
htcondor-ce-sge-5.1.2-1.osg35up.el7
htcondor-ce-slurm-5.1.2-1.osg35up.el7
htcondor-ce-view-5.1.2-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
htcondor-ce-5.1.2-1.osg35up.el8
htcondor-ce-bosco-5.1.2-1.osg35up.el8
htcondor-ce-client-5.1.2-1.osg35up.el8
htcondor-ce-collector-5.1.2-1.osg35up.el8
htcondor-ce-condor-5.1.2-1.osg35up.el8
htcondor-ce-lsf-5.1.2-1.osg35up.el8
htcondor-ce-pbs-5.1.2-1.osg35up.el8
htcondor-ce-sge-5.1.2-1.osg35up.el8
htcondor-ce-slurm-5.1.2-1.osg35up.el8
htcondor-ce-view-5.1.2-1.osg35up.el8
```
