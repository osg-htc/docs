OSG Software Release 3.5.38
===========================

**Release Date:** 2021-06-10  
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

-   HTCondor 8.8.13-1.1: Ensure that completed job ads retain local batch system job IDs
-   Upcoming
    -   [XRootD 5.2.0](https://github.com/xrootd/xrootd/blob/v5.2.0/docs/ReleaseNotes.txt)
        -   Fix scaling issue with HTTP-TPC (caused by inefficient CA handling)
        -   Many other features and bug fixes
    -   xrootd-hdfs 2.2.0-1.1: Bug fix for token authentication

!!! bug "Known Issue"
    - HTCondor-CE 5.1.0: batch system max walltime requests are always set to 3 days.
      Details and workaround can be found in the
      [upstream bug tracker](https://opensciencegrid.atlassian.net/browse/HTCONDOR-506).

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.38%2C3.5.38-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [OSG Docker images](https://hub.docker.com/u/opensciencegrid/) have been updated to contain the latest CA certificates.

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

-   [condor-8.8.13-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.13-1.1.osg35.el7)

#### Enterprise Linux 8

-   [condor-8.8.13-1.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.13-1.1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-8.8.13-1.1.osg35.el7
condor-all-8.8.13-1.1.osg35.el7
condor-annex-ec2-8.8.13-1.1.osg35.el7
condor-bosco-8.8.13-1.1.osg35.el7
condor-classads-8.8.13-1.1.osg35.el7
condor-classads-devel-8.8.13-1.1.osg35.el7
condor-debuginfo-8.8.13-1.1.osg35.el7
condor-kbdd-8.8.13-1.1.osg35.el7
condor-procd-8.8.13-1.1.osg35.el7
condor-test-8.8.13-1.1.osg35.el7
condor-vm-gahp-8.8.13-1.1.osg35.el7
minicondor-8.8.13-1.1.osg35.el7
python2-condor-8.8.13-1.1.osg35.el7
python3-condor-8.8.13-1.1.osg35.el7
```

#### Enterprise Linux 8

``` file
condor-8.8.13-1.1.osg35.el8
condor-all-8.8.13-1.1.osg35.el8
condor-annex-ec2-8.8.13-1.1.osg35.el8
condor-bosco-8.8.13-1.1.osg35.el8
condor-bosco-debuginfo-8.8.13-1.1.osg35.el8
condor-classads-8.8.13-1.1.osg35.el8
condor-classads-debuginfo-8.8.13-1.1.osg35.el8
condor-classads-devel-8.8.13-1.1.osg35.el8
condor-classads-devel-debuginfo-8.8.13-1.1.osg35.el8
condor-debuginfo-8.8.13-1.1.osg35.el8
condor-debugsource-8.8.13-1.1.osg35.el8
condor-kbdd-8.8.13-1.1.osg35.el8
condor-kbdd-debuginfo-8.8.13-1.1.osg35.el8
condor-procd-8.8.13-1.1.osg35.el8
condor-procd-debuginfo-8.8.13-1.1.osg35.el8
condor-test-8.8.13-1.1.osg35.el8
condor-test-debuginfo-8.8.13-1.1.osg35.el8
condor-vm-gahp-8.8.13-1.1.osg35.el8
condor-vm-gahp-debuginfo-8.8.13-1.1.osg35.el8
minicondor-8.8.13-1.1.osg35.el8
python3-condor-8.8.13-1.1.osg35.el8
python3-condor-debuginfo-8.8.13-1.1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [osg-xrootd-3.5.upcoming-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5.upcoming-1.osg35up.el7)
-   [xrootd-5.2.0-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.2.0-1.1.osg35up.el7)
-   [xrootd-hdfs-2.2.0-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.2.0-1.1.osg35up.el7)
-   [xrootd-multiuser-1.0.0-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-1.0.0-1.osg35up.el7)
-   [xrootd-scitokens-1.2.2-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.2.2-1.osg35up.el7)

#### Enterprise Linux 8

-   [osg-xrootd-3.5.upcoming-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5.upcoming-1.osg35up.el8)
-   [xrootd-5.2.0-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.2.0-1.1.osg35up.el8)
-   [xrootd-cmstfc-1.5.2-6.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-cmstfc-1.5.2-6.osg35up.el8)
-   [xrootd-lcmaps-1.7.8-3.osgup.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.8-3.osgup.el8)
-   [xrootd-multiuser-1.0.0-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-1.0.0-1.osg35up.el8)
-   [xrootd-rucioN2N-for-Xcache-1.2-3.3.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-rucioN2N-for-Xcache-1.2-3.3.osg35up.el8)
-   [xrootd-scitokens-1.2.2-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.2.2-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-xrootd osg-xrootd-standalone python2-xrootd python36-xrootd xrootd xrootd-client xrootd-client-compat xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-scitokens xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-compat xrootd-server-devel xrootd-server-libs xrootd-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
osg-xrootd-3.5.upcoming-1.osg35up.el7
osg-xrootd-standalone-3.5.upcoming-1.osg35up.el7
python2-xrootd-5.2.0-1.1.osg35up.el7
python36-xrootd-5.2.0-1.1.osg35up.el7
xrootd-5.2.0-1.1.osg35up.el7
xrootd-client-5.2.0-1.1.osg35up.el7
xrootd-client-compat-5.2.0-1.1.osg35up.el7
xrootd-client-devel-5.2.0-1.1.osg35up.el7
xrootd-client-libs-5.2.0-1.1.osg35up.el7
xrootd-debuginfo-5.2.0-1.1.osg35up.el7
xrootd-devel-5.2.0-1.1.osg35up.el7
xrootd-doc-5.2.0-1.1.osg35up.el7
xrootd-fuse-5.2.0-1.1.osg35up.el7
xrootd-hdfs-2.2.0-1.1.osg35up.el7
xrootd-hdfs-debuginfo-2.2.0-1.1.osg35up.el7
xrootd-hdfs-devel-2.2.0-1.1.osg35up.el7
xrootd-libs-5.2.0-1.1.osg35up.el7
xrootd-multiuser-1.0.0-1.osg35up.el7
xrootd-multiuser-debuginfo-1.0.0-1.osg35up.el7
xrootd-private-devel-5.2.0-1.1.osg35up.el7
xrootd-scitokens-1.2.2-1.osg35up.el7
xrootd-scitokens-5.2.0-1.1.osg35up.el7
xrootd-scitokens-debuginfo-1.2.2-1.osg35up.el7
xrootd-selinux-5.2.0-1.1.osg35up.el7
xrootd-server-5.2.0-1.1.osg35up.el7
xrootd-server-compat-5.2.0-1.1.osg35up.el7
xrootd-server-devel-5.2.0-1.1.osg35up.el7
xrootd-server-libs-5.2.0-1.1.osg35up.el7
xrootd-voms-5.2.0-1.1.osg35up.el7
```

#### Enterprise Linux 8

``` file
osg-xrootd-3.5.upcoming-1.osg35up.el8
osg-xrootd-standalone-3.5.upcoming-1.osg35up.el8
python3-xrootd-5.2.0-1.1.osg35up.el8
python3-xrootd-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-5.2.0-1.1.osg35up.el8
xrootd-client-5.2.0-1.1.osg35up.el8
xrootd-client-compat-5.2.0-1.1.osg35up.el8
xrootd-client-compat-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-client-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-client-devel-5.2.0-1.1.osg35up.el8
xrootd-client-devel-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-client-libs-5.2.0-1.1.osg35up.el8
xrootd-client-libs-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-cmstfc-1.5.2-6.osg35up.el8
xrootd-cmstfc-debuginfo-1.5.2-6.osg35up.el8
xrootd-cmstfc-debugsource-1.5.2-6.osg35up.el8
xrootd-cmstfc-devel-1.5.2-6.osg35up.el8
xrootd-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-debugsource-5.2.0-1.1.osg35up.el8
xrootd-devel-5.2.0-1.1.osg35up.el8
xrootd-doc-5.2.0-1.1.osg35up.el8
xrootd-fuse-5.2.0-1.1.osg35up.el8
xrootd-fuse-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-lcmaps-1.7.8-3.osgup.el8
xrootd-lcmaps-debuginfo-1.7.8-3.osgup.el8
xrootd-lcmaps-debugsource-1.7.8-3.osgup.el8
xrootd-libs-5.2.0-1.1.osg35up.el8
xrootd-libs-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-multiuser-1.0.0-1.osg35up.el8
xrootd-multiuser-debuginfo-1.0.0-1.osg35up.el8
xrootd-multiuser-debugsource-1.0.0-1.osg35up.el8
xrootd-private-devel-5.2.0-1.1.osg35up.el8
xrootd-rucioN2N-for-Xcache-1.2-3.3.osg35up.el8
xrootd-rucioN2N-for-Xcache-debuginfo-1.2-3.3.osg35up.el8
xrootd-rucioN2N-for-Xcache-debugsource-1.2-3.3.osg35up.el8
xrootd-scitokens-1.2.2-1.osg35up.el8
xrootd-scitokens-5.2.0-1.1.osg35up.el8
xrootd-scitokens-debuginfo-1.2.2-1.osg35up.el8
xrootd-scitokens-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-scitokens-debugsource-1.2.2-1.osg35up.el8
xrootd-selinux-5.2.0-1.1.osg35up.el8
xrootd-server-5.2.0-1.1.osg35up.el8
xrootd-server-compat-5.2.0-1.1.osg35up.el8
xrootd-server-compat-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-server-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-server-devel-5.2.0-1.1.osg35up.el8
xrootd-server-libs-5.2.0-1.1.osg35up.el8
xrootd-server-libs-debuginfo-5.2.0-1.1.osg35up.el8
xrootd-voms-5.2.0-1.1.osg35up.el8
xrootd-voms-debuginfo-5.2.0-1.1.osg35up.el8
```
