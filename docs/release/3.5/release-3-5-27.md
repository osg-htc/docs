OSG Software Release 3.5.27
===========================

**Release Date:** 2020-11-12    
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

-   gfal2 2.18.1-1.1: Fixes issue preventing osg-wn-client installations
-   [HTCondor 8.9.9](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00022.shtml)
    -   The RPM packages require globus, munge, scitokens, and voms from EPEL
    -   Improved cgroup memory policy settings that set both hard and soft limit
    -   Cgroup memory usage reporting no longer includes the kernel buffer cache
    -   Numerous Python binding improvements, see [version history](https://htcondor.readthedocs.io/en/latest/version-history/development-release-series-89.html#version-8-9-9)
    -   Can create a manifest of files on the execute node at job start and finish
    -   Added provisioner nodes to DAGMan, allowing users to provision resources
    -   DAGMan can now produce .dot graphs without running the workflow
    -   HTCondor now properly tracks usage over vanilla universe checkpoints
    -   New ClassAd equality and inequality operators in the Python bindings
    -   Fixed a bug where removing in-use routes could crash the job router
    -   Fixed a bug where condor\_chirp would abort after success on Windows
    -   Fixed a bug where using MACHINE\_RESOURCE\_NAMES could crash the startd
    -   Improved condor c-gahp to prioritize commands over file transfers
    -   Fixed a rare crash in the schedd when running many local universe jobs
    -   With GSI, avoid unnecessary reverse DNS lookup when HOST\_ALIAS is set
    -   Fix a bug that could cause grid universe jobs to fail upon proxy refresh
-   [GlideinWMS 3.7.1](https://glideinwms.fnal.gov/doc.v3_7_1/history.html#development)
    -   Includes all features and fixes of [3.6.5](https://glideinwms.fnal.gov/doc.v3_6_5/history.html)
        -   Improved Singularity support
        -   HTCondor's Python based condor\_chip in the PATH
        -   Support for EL8 worker nodes
    -   Configuration changes to make more compatible with HTCondor 8.9 on initial install
    -   SciTokens authentication between Factory and CE
    -   IDTokens authentication between Factory and Frontend
    -   Bug fix: Factory reconfigs and startups do not require manual creation of directories
    -   Bug fix: Factory builds Condor Tarballs to send with glideins correctly

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.27%2C%203.5.27-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

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

-   [gfal2-2.18.1-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gfal2-2.18.1-1.1.osg35.el7)

#### Enterprise Linux 8

-   None

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    gfal2 gfal2-all gfal2-debuginfo gfal2-devel gfal2-doc gfal2-plugin-dcap gfal2-plugin-file gfal2-plugin-gridftp gfal2-plugin-http gfal2-plugin-lfc gfal2-plugin-mock gfal2-plugin-rfio gfal2-plugin-sftp gfal2-plugin-srm gfal2-plugin-xrootd 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
gfal2-2.18.1-1.1.osg35.el7
gfal2-all-2.18.1-1.1.osg35.el7
gfal2-debuginfo-2.18.1-1.1.osg35.el7
gfal2-devel-2.18.1-1.1.osg35.el7
gfal2-doc-2.18.1-1.1.osg35.el7
gfal2-plugin-dcap-2.18.1-1.1.osg35.el7
gfal2-plugin-file-2.18.1-1.1.osg35.el7
gfal2-plugin-gridftp-2.18.1-1.1.osg35.el7
gfal2-plugin-http-2.18.1-1.1.osg35.el7
gfal2-plugin-lfc-2.18.1-1.1.osg35.el7
gfal2-plugin-mock-2.18.1-1.1.osg35.el7
gfal2-plugin-rfio-2.18.1-1.1.osg35.el7
gfal2-plugin-sftp-2.18.1-1.1.osg35.el7
gfal2-plugin-srm-2.18.1-1.1.osg35.el7
gfal2-plugin-xrootd-2.18.1-1.1.osg35.el7
```

#### Enterprise Linux 8

``` file
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-8.9.9-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.9-1.osgup.el7)
-   [glideinwms-3.7.1-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.7.1-1.osgup.el7)
-   [xrootd-cmstfc-1.5.2-6.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-cmstfc-1.5.2-6.osgup.el7)

#### Enterprise Linux 8

-   None

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone minicondor python2-condor python3-condor xrootd-cmstfc xrootd-cmstfc-debuginfo xrootd-cmstfc-devel 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-8.9.9-1.osgup.el7
condor-all-8.9.9-1.osgup.el7
condor-annex-ec2-8.9.9-1.osgup.el7
condor-bosco-8.9.9-1.osgup.el7
condor-classads-8.9.9-1.osgup.el7
condor-classads-devel-8.9.9-1.osgup.el7
condor-credmon-oauth-8.9.9-1.osgup.el7
condor-debuginfo-8.9.9-1.osgup.el7
condor-kbdd-8.9.9-1.osgup.el7
condor-procd-8.9.9-1.osgup.el7
condor-test-8.9.9-1.osgup.el7
condor-vm-gahp-8.9.9-1.osgup.el7
glideinwms-3.7.1-1.osgup.el7
glideinwms-common-tools-3.7.1-1.osgup.el7
glideinwms-condor-common-config-3.7.1-1.osgup.el7
glideinwms-factory-3.7.1-1.osgup.el7
glideinwms-factory-condor-3.7.1-1.osgup.el7
glideinwms-glidecondor-tools-3.7.1-1.osgup.el7
glideinwms-libs-3.7.1-1.osgup.el7
glideinwms-minimal-condor-3.7.1-1.osgup.el7
glideinwms-usercollector-3.7.1-1.osgup.el7
glideinwms-userschedd-3.7.1-1.osgup.el7
glideinwms-vofrontend-3.7.1-1.osgup.el7
glideinwms-vofrontend-standalone-3.7.1-1.osgup.el7
minicondor-8.9.9-1.osgup.el7
python2-condor-8.9.9-1.osgup.el7
python3-condor-8.9.9-1.osgup.el7
xrootd-cmstfc-1.5.2-6.osgup.el7
xrootd-cmstfc-debuginfo-1.5.2-6.osgup.el7
xrootd-cmstfc-devel-1.5.2-6.osgup.el7
```

#### Enterprise Linux 8

``` file
```
