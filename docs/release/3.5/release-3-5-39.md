OSG Software Release 3.5.39
===========================

**Release Date:** 2021-06-24  
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

This release contains:

-   scitokens-cpp 0.6.2: Fix WLCG token compatibility for the HTCondor READ scope
-   Upcoming
    -   [HTCondor 9.0.1-1.2](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00009.shtml): Bug fix release
        -   Fix problem where X.509 proxy refresh kills job when using AES encryption
        -   Fix problem when jobs require a different machine after a failure
        -   Fix problem where a job matched a machine it can't use, delaying job start
        -   Fix exit code and retry checking when a job exits because of a signal
        -   Fix a memory leak in the job router when a job is removed via job policy
        -   Fixed the back-end support for the 'bosco\_cluster --add' command
    -   [HTCondor-CE 5.1.1](https://htcondor.github.io/htcondor-ce/v5/releases/#511)
        -   Improve restart time of HTCondor-CE View
        -   Fix bug that caused HTCondor-CE to ignore incoming BatchRuntime requests
        -   Fixed error that occurred during RPM installation of non-HTCondor batch systems regarding missing file batch\_gahp

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.39%2C3.5.39-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

### Packages

We added or updated the following packages to the production OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list [below](#rpms).

#### Enterprise Linux 7

-   [scitokens-cpp-0.6.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.6.2-1.osg35.el7)

#### Enterprise Linux 8

-   [scitokens-cpp-0.6.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.6.2-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
scitokens-cpp-0.6.2-1.osg35.el7
scitokens-cpp-debuginfo-0.6.2-1.osg35.el7
scitokens-cpp-devel-0.6.2-1.osg35.el7
```

#### Enterprise Linux 8

``` file
scitokens-cpp-0.6.2-1.osg35.el8
scitokens-cpp-debuginfo-0.6.2-1.osg35.el8
scitokens-cpp-debugsource-0.6.2-1.osg35.el8
scitokens-cpp-devel-0.6.2-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-9.0.1-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.1-1.1.osg35up.el7)
-   [htcondor-ce-5.1.1-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-5.1.1-1.1.osg35up.el7)

#### Enterprise Linux 8

-   [condor-9.0.1-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.1-1.1.osg35up.el8)
-   [htcondor-ce-5.1.1-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-5.1.1-1.1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-9.0.1-1.1.osg35up.el7
condor-all-9.0.1-1.1.osg35up.el7
condor-annex-ec2-9.0.1-1.1.osg35up.el7
condor-bosco-9.0.1-1.1.osg35up.el7
condor-classads-9.0.1-1.1.osg35up.el7
condor-classads-devel-9.0.1-1.1.osg35up.el7
condor-credmon-oauth-9.0.1-1.1.osg35up.el7
condor-credmon-vault-9.0.1-1.1.osg35up.el7
condor-debuginfo-9.0.1-1.1.osg35up.el7
condor-devel-9.0.1-1.1.osg35up.el7
condor-kbdd-9.0.1-1.1.osg35up.el7
condor-procd-9.0.1-1.1.osg35up.el7
condor-test-9.0.1-1.1.osg35up.el7
condor-vm-gahp-9.0.1-1.1.osg35up.el7
htcondor-ce-5.1.1-1.1.osg35up.el7
htcondor-ce-bosco-5.1.1-1.1.osg35up.el7
htcondor-ce-client-5.1.1-1.1.osg35up.el7
htcondor-ce-collector-5.1.1-1.1.osg35up.el7
htcondor-ce-condor-5.1.1-1.1.osg35up.el7
htcondor-ce-lsf-5.1.1-1.1.osg35up.el7
htcondor-ce-pbs-5.1.1-1.1.osg35up.el7
htcondor-ce-sge-5.1.1-1.1.osg35up.el7
htcondor-ce-slurm-5.1.1-1.1.osg35up.el7
htcondor-ce-view-5.1.1-1.1.osg35up.el7
minicondor-9.0.1-1.1.osg35up.el7
python2-condor-9.0.1-1.1.osg35up.el7
python3-condor-9.0.1-1.1.osg35up.el7
```

#### Enterprise Linux 8

``` file
condor-9.0.1-1.1.osg35up.el8
condor-all-9.0.1-1.1.osg35up.el8
condor-annex-ec2-9.0.1-1.1.osg35up.el8
condor-bosco-9.0.1-1.1.osg35up.el8
condor-bosco-debuginfo-9.0.1-1.1.osg35up.el8
condor-classads-9.0.1-1.1.osg35up.el8
condor-classads-debuginfo-9.0.1-1.1.osg35up.el8
condor-classads-devel-9.0.1-1.1.osg35up.el8
condor-classads-devel-debuginfo-9.0.1-1.1.osg35up.el8
condor-credmon-vault-9.0.1-1.1.osg35up.el8
condor-debuginfo-9.0.1-1.1.osg35up.el8
condor-debugsource-9.0.1-1.1.osg35up.el8
condor-devel-9.0.1-1.1.osg35up.el8
condor-kbdd-9.0.1-1.1.osg35up.el8
condor-kbdd-debuginfo-9.0.1-1.1.osg35up.el8
condor-procd-9.0.1-1.1.osg35up.el8
condor-procd-debuginfo-9.0.1-1.1.osg35up.el8
condor-test-9.0.1-1.1.osg35up.el8
condor-test-debuginfo-9.0.1-1.1.osg35up.el8
condor-vm-gahp-9.0.1-1.1.osg35up.el8
condor-vm-gahp-debuginfo-9.0.1-1.1.osg35up.el8
htcondor-ce-5.1.1-1.1.osg35up.el8
htcondor-ce-bosco-5.1.1-1.1.osg35up.el8
htcondor-ce-client-5.1.1-1.1.osg35up.el8
htcondor-ce-collector-5.1.1-1.1.osg35up.el8
htcondor-ce-condor-5.1.1-1.1.osg35up.el8
htcondor-ce-lsf-5.1.1-1.1.osg35up.el8
htcondor-ce-pbs-5.1.1-1.1.osg35up.el8
htcondor-ce-sge-5.1.1-1.1.osg35up.el8
htcondor-ce-slurm-5.1.1-1.1.osg35up.el8
htcondor-ce-view-5.1.1-1.1.osg35up.el8
minicondor-9.0.1-1.1.osg35up.el8
python3-condor-9.0.1-1.1.osg35up.el8
python3-condor-debuginfo-9.0.1-1.1.osg35up.el8
```
