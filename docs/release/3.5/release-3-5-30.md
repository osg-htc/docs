OSG Software Release 3.5.30
===========================

**Release Date:** 2021-01-27    
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

-   Upcoming Repository: HTCondor 8.9.11 Security Release. This release contains fixes for important security issues. More details on the security issues are in the vulnerability reports:
    -   [HTCONDOR-2021-0001](http://htcondor.org/security/vulnerabilities/HTCONDOR-2021-0001.html)
    -   [HTCONDOR-2021-0002](http://htcondor.org/security/vulnerabilities/HTCONDOR-2021-0002.html)

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.30%2C%203.5.30-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

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

#### Enterprise Linux 7

-   None

#### Enterprise Linux 8

-   None

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    None

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
```

#### Enterprise Linux 8

``` file
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-8.9.11-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.11-1.osgup.el7)

#### Enterprise Linux 8

-   None

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-8.9.11-1.osgup.el7
condor-all-8.9.11-1.osgup.el7
condor-annex-ec2-8.9.11-1.osgup.el7
condor-bosco-8.9.11-1.osgup.el7
condor-classads-8.9.11-1.osgup.el7
condor-classads-devel-8.9.11-1.osgup.el7
condor-credmon-oauth-8.9.11-1.osgup.el7
condor-debuginfo-8.9.11-1.osgup.el7
condor-kbdd-8.9.11-1.osgup.el7
condor-procd-8.9.11-1.osgup.el7
condor-test-8.9.11-1.osgup.el7
condor-vm-gahp-8.9.11-1.osgup.el7
minicondor-8.9.11-1.osgup.el7
python2-condor-8.9.11-1.osgup.el7
python3-condor-8.9.11-1.osgup.el7
```

#### Enterprise Linux 8

``` file
```
