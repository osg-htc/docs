OSG Software Release 3.5.56
===========================

**Release Date:** 2022-02-10  
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

-   [VO Package v119](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-119)
    -   Update OSG VO and GLOW VO DNs
-   hosted-ce-tools 0.9: new for Enterprise Linux 8
-   scitokens-credmon 0.8.1: new for Enterprise Linux 8
-   Upcoming
    -   [HTCondor 9.0.9 LTS](https://www-auth.cs.wisc.edu/lists/htcondor-world/2022/msg00000.shtml)
        -   The OAUTH credmon is now available on Enterprise Linux 8
        -   Deprecated C-style comments no longer cause the job router to crash

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.56%2C3.5.56-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [vo-client-119-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-119-1.osg35.el7)

#### Enterprise Linux 8

-   [hosted-ce-tools-0.9-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.9-1.osg35.el8)
-   [scitokens-credmon-0.8.1-1.2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-credmon-0.8.1-1.2.osg35.el8)
-   [vo-client-119-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-119-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    hosted-ce-tools python3-scitokens-credmon scitokens-credmon vo-client vo-client-dcache vo-client-lcmaps-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
vo-client-119-1.osg35.el7
vo-client-dcache-119-1.osg35.el7
vo-client-lcmaps-voms-119-1.osg35.el7
```

#### Enterprise Linux 8

``` file
hosted-ce-tools-0.9-1.osg35.el8
python3-scitokens-credmon-0.8.1-1.2.osg35.el8
scitokens-credmon-0.8.1-1.2.osg35.el8
vo-client-119-1.osg35.el8
vo-client-dcache-119-1.osg35.el8
vo-client-lcmaps-voms-119-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-9.0.9-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.9-1.1.osg35up.el7)

#### Enterprise Linux 8

-   [condor-9.0.9-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.9-1.1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-9.0.9-1.1.osg35up.el7
condor-all-9.0.9-1.1.osg35up.el7
condor-annex-ec2-9.0.9-1.1.osg35up.el7
condor-bosco-9.0.9-1.1.osg35up.el7
condor-classads-9.0.9-1.1.osg35up.el7
condor-classads-devel-9.0.9-1.1.osg35up.el7
condor-credmon-oauth-9.0.9-1.1.osg35up.el7
condor-credmon-vault-9.0.9-1.1.osg35up.el7
condor-debuginfo-9.0.9-1.1.osg35up.el7
condor-devel-9.0.9-1.1.osg35up.el7
condor-kbdd-9.0.9-1.1.osg35up.el7
condor-procd-9.0.9-1.1.osg35up.el7
condor-test-9.0.9-1.1.osg35up.el7
condor-vm-gahp-9.0.9-1.1.osg35up.el7
minicondor-9.0.9-1.1.osg35up.el7
python2-condor-9.0.9-1.1.osg35up.el7
python3-condor-9.0.9-1.1.osg35up.el7
```

#### Enterprise Linux 8

``` file
condor-9.0.9-1.1.osg35up.el8
condor-all-9.0.9-1.1.osg35up.el8
condor-annex-ec2-9.0.9-1.1.osg35up.el8
condor-bosco-9.0.9-1.1.osg35up.el8
condor-bosco-debuginfo-9.0.9-1.1.osg35up.el8
condor-classads-9.0.9-1.1.osg35up.el8
condor-classads-debuginfo-9.0.9-1.1.osg35up.el8
condor-classads-devel-9.0.9-1.1.osg35up.el8
condor-classads-devel-debuginfo-9.0.9-1.1.osg35up.el8
condor-credmon-oauth-9.0.9-1.1.osg35up.el8
condor-credmon-vault-9.0.9-1.1.osg35up.el8
condor-debuginfo-9.0.9-1.1.osg35up.el8
condor-debugsource-9.0.9-1.1.osg35up.el8
condor-devel-9.0.9-1.1.osg35up.el8
condor-kbdd-9.0.9-1.1.osg35up.el8
condor-kbdd-debuginfo-9.0.9-1.1.osg35up.el8
condor-procd-9.0.9-1.1.osg35up.el8
condor-procd-debuginfo-9.0.9-1.1.osg35up.el8
condor-test-9.0.9-1.1.osg35up.el8
condor-test-debuginfo-9.0.9-1.1.osg35up.el8
condor-vm-gahp-9.0.9-1.1.osg35up.el8
condor-vm-gahp-debuginfo-9.0.9-1.1.osg35up.el8
minicondor-9.0.9-1.1.osg35up.el8
python3-condor-9.0.9-1.1.osg35up.el8
python3-condor-debuginfo-9.0.9-1.1.osg35up.el8
```
