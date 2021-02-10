OSG Software Release 3.5.28
===========================

**Release Date:** 2020-12-10    
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

-   osg-ca-certs 1.90: Add new Let's Encrypt intermediate CAs (EL7 and EL8) (fixes issues with newly issued host certficates)
-   htgettoken 1.0: get OIDC bearer tokens by interacting with Hashicorp vault
-   [XRootD 4.12.5](https://github.com/xrootd/xrootd/blob/v4.12.5/docs/ReleaseNotes.txt) (EL7 Only)
    -   *[XrdCl]* Fix regression in recursive copy (introduced in f6723e00)
    -   *[VOMS]* Do not touch the Entity.name field; especially converting spaces
    -   *[VOMS]* Fix improper collection of multi-VO cert attributes
    -   *[RPM]* Refine xrootd-voms obsoletes/provides for vomsxrd
    -   *[RPM]* Remove libXrdSecgsiVOMS-4.so from xrootd-libs pkg
    -   *[pfc]* Make sure v4 does not try to read v5 cinfo files
    -   *[XrdHttp]* Shutdown the connection in the case of an unrecognized HTTP first line.
-   [HTCondor 8.8.12](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00024.shtml) (EL7 Only)
    -   Added a family of version comparison functions to ClassAds
    -   Increased default Globus proxy key length to meet current NIST guidance
-   Upcoming: [HTCondor 8.9.10](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00023.shtml) (EL7 Only)
    -   Fix bug where negotiator stopped making matches when group quotas are used
    -   Support OAuth, SciTokens, and Kerberos credentials in local universe jobs
    -   The Python schedd.submit method now takes a Submit object
    -   DAGMan can now optionally run a script when a job goes on hold
    -   DAGMan now provides a method for inline jobs to share submit descriptions
    -   Can now add arbitrary tags to condor annex instances
    -   Runs the "singularity test" before running the a singularity job

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.28%2C%203.5.28-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The following container is available and has been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [CMS XCache](https://hub.docker.com/r/opensciencegrid/cms-xcache/)
-   [Hosted CE](https://hub.docker.com/r/opensciencegrid/hosted-ce/)

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

#### Enterprise Linux 7

-   [blahp-1.18.48-2.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.48-2.1.osg35.el7)
-   [condor-8.8.12-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.12-1.1.osg35.el7)
-   [hosted-ce-tools-0.9-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.9-1.osg35.el7)
-   [htgettoken-1.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.0-1.osg35.el7)
-   [osg-ca-certs-1.90-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.90-1.osg35.el7)
-   [xrootd-4.12.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.12.5-1.osg35.el7)

#### Enterprise Linux 8

-   [htgettoken-1.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.0-1.osg35.el8)
-   [osg-ca-certs-1.90-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.90-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp hosted-ce-tools htgettoken minicondor osg-ca-certs python2-condor python2-xrootd python3-condor xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs xrootd-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-1.18.48-2.1.osg35.el7
blahp-debuginfo-1.18.48-2.1.osg35.el7
condor-8.8.12-1.1.osg35.el7
condor-all-8.8.12-1.1.osg35.el7
condor-annex-ec2-8.8.12-1.1.osg35.el7
condor-bosco-8.8.12-1.1.osg35.el7
condor-classads-8.8.12-1.1.osg35.el7
condor-classads-devel-8.8.12-1.1.osg35.el7
condor-debuginfo-8.8.12-1.1.osg35.el7
condor-kbdd-8.8.12-1.1.osg35.el7
condor-procd-8.8.12-1.1.osg35.el7
condor-test-8.8.12-1.1.osg35.el7
condor-vm-gahp-8.8.12-1.1.osg35.el7
hosted-ce-tools-0.9-1.osg35.el7
htgettoken-1.0-1.osg35.el7
minicondor-8.8.12-1.1.osg35.el7
osg-ca-certs-1.90-1.osg35.el7
python2-condor-8.8.12-1.1.osg35.el7
python2-xrootd-4.12.5-1.osg35.el7
python3-condor-8.8.12-1.1.osg35.el7
xrootd-4.12.5-1.osg35.el7
xrootd-client-4.12.5-1.osg35.el7
xrootd-client-devel-4.12.5-1.osg35.el7
xrootd-client-libs-4.12.5-1.osg35.el7
xrootd-debuginfo-4.12.5-1.osg35.el7
xrootd-devel-4.12.5-1.osg35.el7
xrootd-doc-4.12.5-1.osg35.el7
xrootd-fuse-4.12.5-1.osg35.el7
xrootd-libs-4.12.5-1.osg35.el7
xrootd-private-devel-4.12.5-1.osg35.el7
xrootd-selinux-4.12.5-1.osg35.el7
xrootd-server-4.12.5-1.osg35.el7
xrootd-server-devel-4.12.5-1.osg35.el7
xrootd-server-libs-4.12.5-1.osg35.el7
xrootd-voms-4.12.5-1.osg35.el7
```

#### Enterprise Linux 8

``` file
htgettoken-1.0-1.osg35.el8
osg-ca-certs-1.90-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [blahp-1.18.48-2.2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.48-2.2.osgup.el7)
-   [condor-8.9.10-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.10-1.osgup.el7)

#### Enterprise Linux 8

-   None

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-1.18.48-2.2.osgup.el7
blahp-debuginfo-1.18.48-2.2.osgup.el7
condor-8.9.10-1.osgup.el7
condor-all-8.9.10-1.osgup.el7
condor-annex-ec2-8.9.10-1.osgup.el7
condor-bosco-8.9.10-1.osgup.el7
condor-classads-8.9.10-1.osgup.el7
condor-classads-devel-8.9.10-1.osgup.el7
condor-credmon-oauth-8.9.10-1.osgup.el7
condor-debuginfo-8.9.10-1.osgup.el7
condor-kbdd-8.9.10-1.osgup.el7
condor-procd-8.9.10-1.osgup.el7
condor-test-8.9.10-1.osgup.el7
condor-vm-gahp-8.9.10-1.osgup.el7
minicondor-8.9.10-1.osgup.el7
python2-condor-8.9.10-1.osgup.el7
python3-condor-8.9.10-1.osgup.el7
```

#### Enterprise Linux 8

``` file
```
