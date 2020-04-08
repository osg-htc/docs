OSG Software Release 3.5.14
===========================

**Release Date:** 2020-04-02    
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

-   HTCondor 8.8.8 Security Release. This release contains fixes for important security issues. More details on the security issues are in the vulnerability reports:
    -   [HTCONDOR-2020-0001](http://htcondor.org/security/vulnerabilities/HTCONDOR-2020-0001.html)
    -   [HTCONDOR-2020-0002](http://htcondor.org/security/vulnerabilities/HTCONDOR-2020-0002.html)
    -   [HTCONDOR-2020-0003](http://htcondor.org/security/vulnerabilities/HTCONDOR-2020-0003.html)
    -   [HTCONDOR-2020-0004](http://htcondor.org/security/vulnerabilities/HTCONDOR-2020-0004.html)
-   Upcoming Repository: HTCondor 8.9.6 Security Release. This release contains fixes for important security issues. More details on the security issues are in the vulnerability reports:
    -   [HTCONDOR-2020-0001](http://htcondor.org/security/vulnerabilities/HTCONDOR-2020-0001.html)
    -   [HTCONDOR-2020-0002](http://htcondor.org/security/vulnerabilities/HTCONDOR-2020-0002.html)
    -   [HTCONDOR-2020-0003](http://htcondor.org/security/vulnerabilities/HTCONDOR-2020-0003.html)
    -   [HTCONDOR-2020-0004](http://htcondor.org/security/vulnerabilities/HTCONDOR-2020-0004.html)

!!!note "Affected nodes"
    These updates affect submit and execute hosts. Please update your submit host first and then your execute nodes.
    Don't forget to update your HTCondor CE.
    If you are upgrading from HTCondor 8.6.x, please note that configuration changes may be necessary when
    [updating to HTCondor 8.8.8](https://opensciencegrid.org/docs/release/release_series/#updating-to-htcondor-88x)

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.14%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

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

-   [condor-8.8.8-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.8-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp GenericError: Invalid tagInfo:

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
condor-8.8.8-1.osg35.el7
condor-all-8.8.8-1.osg35.el7
condor-annex-ec2-8.8.8-1.osg35.el7
condor-bosco-8.8.8-1.osg35.el7
condor-classads-8.8.8-1.osg35.el7
condor-classads-devel-8.8.8-1.osg35.el7
condor-debuginfo-8.8.8-1.osg35.el7
condor-kbdd-8.8.8-1.osg35.el7
condor-procd-8.8.8-1.osg35.el7
condor-test-8.8.8-1.osg35.el7
condor-vm-gahp-8.8.8-1.osg35.el7
minicondor-8.8.8-1.osg35.el7
python2-condor-8.8.8-1.osg35.el7
python3-condor-8.8.8-1.osg35.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

-   [condor-8.9.6-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.6-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
condor-8.9.6-1.osgup.el7
condor-all-8.9.6-1.osgup.el7
condor-annex-ec2-8.9.6-1.osgup.el7
condor-bosco-8.9.6-1.osgup.el7
condor-classads-8.9.6-1.osgup.el7
condor-classads-devel-8.9.6-1.osgup.el7
condor-debuginfo-8.9.6-1.osgup.el7
condor-kbdd-8.9.6-1.osgup.el7
condor-procd-8.9.6-1.osgup.el7
condor-test-8.9.6-1.osgup.el7
condor-vm-gahp-8.9.6-1.osgup.el7
minicondor-8.9.6-1.osgup.el7
python2-condor-8.9.6-1.osgup.el7
python3-condor-8.9.6-1.osgup.el7
```
