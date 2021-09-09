OSG Software Release 3.5.46
===========================

**Release Date:** 2021-09-09  
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

!!! note "Important"
    If you are running an HTCondor-CE with SciTokens and GSI Authentication, you should update to HTCondor 9.0.5
    at your earliest convenience.

This release contains:

-   Upcoming
    -   [HTCondor 9.0.5](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00017.shtml): Bug fix release
        -   **Other authentication methods are tried if mapping fails using SciTokens**
        -   Fix rare crashes from successful condor_submit, which caused DAGMan issues
        -   Fix bug where ExitCode attribute would be suppressed when OnExitHold fired
        -   condor_who now suppresses spurious warnings coming from netstat
        -   The online manual now has detailed instructions for installing on MacOS
        -   Fix bug where misconfigured MIG devices confused condor_gpu_discovery
        -   The transfer_checkpoint_file list may now include input files
    -   [blahp 2.1.1](https://github.com/htcondor/BLAH/releases/tag/v2.1.1): Bug fix release
        -   Add Python 2 support back for Enterprise Linux 7
        -   Allow the user to override system configuration files
        -   Enable flexible configuration via a configuration directory
        -   Fix Slurm resource usage reporting

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.46-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [blahp-2.1.1-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-2.1.1-1.osg35up.el7)
-   [condor-9.0.5-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.5-1.1.osg35up.el7)

#### Enterprise Linux 8

-   [blahp-2.1.1-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-2.1.1-1.osg35up.el8)
-   [condor-9.0.5-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.5-1.1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-2.1.1-1.osg35up.el7
blahp-debuginfo-2.1.1-1.osg35up.el7
condor-9.0.5-1.1.osg35up.el7
condor-all-9.0.5-1.1.osg35up.el7
condor-annex-ec2-9.0.5-1.1.osg35up.el7
condor-bosco-9.0.5-1.1.osg35up.el7
condor-classads-9.0.5-1.1.osg35up.el7
condor-classads-devel-9.0.5-1.1.osg35up.el7
condor-credmon-oauth-9.0.5-1.1.osg35up.el7
condor-credmon-vault-9.0.5-1.1.osg35up.el7
condor-debuginfo-9.0.5-1.1.osg35up.el7
condor-devel-9.0.5-1.1.osg35up.el7
condor-kbdd-9.0.5-1.1.osg35up.el7
condor-procd-9.0.5-1.1.osg35up.el7
condor-test-9.0.5-1.1.osg35up.el7
condor-vm-gahp-9.0.5-1.1.osg35up.el7
minicondor-9.0.5-1.1.osg35up.el7
python2-condor-9.0.5-1.1.osg35up.el7
python3-condor-9.0.5-1.1.osg35up.el7
```

#### Enterprise Linux 8

``` file
blahp-2.1.1-1.osg35up.el8
blahp-debuginfo-2.1.1-1.osg35up.el8
blahp-debugsource-2.1.1-1.osg35up.el8
condor-9.0.5-1.1.osg35up.el8
condor-all-9.0.5-1.1.osg35up.el8
condor-annex-ec2-9.0.5-1.1.osg35up.el8
condor-bosco-9.0.5-1.1.osg35up.el8
condor-bosco-debuginfo-9.0.5-1.1.osg35up.el8
condor-classads-9.0.5-1.1.osg35up.el8
condor-classads-debuginfo-9.0.5-1.1.osg35up.el8
condor-classads-devel-9.0.5-1.1.osg35up.el8
condor-classads-devel-debuginfo-9.0.5-1.1.osg35up.el8
condor-credmon-vault-9.0.5-1.1.osg35up.el8
condor-debuginfo-9.0.5-1.1.osg35up.el8
condor-debugsource-9.0.5-1.1.osg35up.el8
condor-devel-9.0.5-1.1.osg35up.el8
condor-kbdd-9.0.5-1.1.osg35up.el8
condor-kbdd-debuginfo-9.0.5-1.1.osg35up.el8
condor-procd-9.0.5-1.1.osg35up.el8
condor-procd-debuginfo-9.0.5-1.1.osg35up.el8
condor-test-9.0.5-1.1.osg35up.el8
condor-test-debuginfo-9.0.5-1.1.osg35up.el8
condor-vm-gahp-9.0.5-1.1.osg35up.el8
condor-vm-gahp-debuginfo-9.0.5-1.1.osg35up.el8
minicondor-9.0.5-1.1.osg35up.el8
python3-condor-9.0.5-1.1.osg35up.el8
python3-condor-debuginfo-9.0.5-1.1.osg35up.el8
```
