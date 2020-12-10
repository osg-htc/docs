OSG Software Release 3.5.23
===========================

**Release Date:** 2020-09-03    
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

-   xrootd-hdfs 2.1.8: Fixed a bug with loading a library introduced in 2.1.7
-   osg-release 3.5-4: Minor tweak to spread the load over the mirrors
-   Upcoming:
    -   [HTCondor 8.9.8](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00018.shtml)
        -   condor_qedit can no longer be used to disrupt the condor_schedd
        -   Fixed a bug where the SHARED_PORT_PORT configuration setting was ignored
        -   Added htcondor.dags and htcondor.htchirp to the HTCondor Python bindings
        -   New condor_watch_q tool that efficiently provides live job status updates
        -   Added support for marking a GPU offline while other jobs continue
        -   The condor_master command does not return until it is fully started
        -   Deprecated several Python interfaces in the Python bindings
    -   [XRootD 5.0.1](https://github.com/xrootd/xrootd/blob/v5.0.1/docs/ReleaseNotes.txt)
        -   TLS support
        -   Starting with version 5.0.0 XRootD protocol supports encryption

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.23%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.

Known Issues
------------

There is a known bug in XRootD 5.0.1 that prevents HTTP-TPC from working with X.509 proxies. Sites that utilize HTTP-TPC to move data with FTS should not upgrade to this release. See [Gitub xrootd issue #1276](https://github.com/xrootd/xrootd/issues/1276) for technical details.


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

-   [osg-release-3.5-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.5-4.osg35.el7)
-   [xrootd-hdfs-2.1.8-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.8-1.osg35.el7)

#### Enterprise Linux 8

-   None

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-release xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
osg-release-3.5-4.osg35.el7
xrootd-hdfs-2.1.8-1.osg35.el7
xrootd-hdfs-debuginfo-2.1.8-1.osg35.el7
xrootd-hdfs-devel-2.1.8-1.osg35.el7
```

#### Enterprise Linux 8

``` file
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-8.9.8-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.8-1.1.osgup.el7)
-   [xrootd-5.0.1-1.3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.0.1-1.3.osgup.el7)
-   [xrootd-cmstfc-1.5.2-5.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-cmstfc-1.5.2-5.osgup.el7)
-   [xrootd-hdfs-2.1.8-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.8-1.1.osgup.el7)
-   [xrootd-lcmaps-1.7.8-3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.8-3.osgup.el7)
-   [xrootd-multiuser-0.4.3-4.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.3-4.osgup.el7)
-   [xrootd-rucioN2N-for-Xcache-1.2-3.3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-rucioN2N-for-Xcache-1.2-3.3.osgup.el7)
-   [xrootd-scitokens-1.2.2-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.2.2-1.osgup.el7)

#### Enterprise Linux 8

-   None

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python2-xrootd python3-condor python3-xrootd xrootd xrootd-client xrootd-client-compat xrootd-client-devel xrootd-client-libs xrootd-cmstfc xrootd-cmstfc-debuginfo xrootd-cmstfc-devel xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-rucioN2N-for-Xcache xrootd-rucioN2N-for-Xcache-debuginfo xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-compat xrootd-server-devel xrootd-server-libs xrootd-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-8.9.8-1.1.osgup.el7
condor-all-8.9.8-1.1.osgup.el7
condor-annex-ec2-8.9.8-1.1.osgup.el7
condor-bosco-8.9.8-1.1.osgup.el7
condor-classads-8.9.8-1.1.osgup.el7
condor-classads-devel-8.9.8-1.1.osgup.el7
condor-debuginfo-8.9.8-1.1.osgup.el7
condor-kbdd-8.9.8-1.1.osgup.el7
condor-procd-8.9.8-1.1.osgup.el7
condor-test-8.9.8-1.1.osgup.el7
condor-vm-gahp-8.9.8-1.1.osgup.el7
minicondor-8.9.8-1.1.osgup.el7
python2-condor-8.9.8-1.1.osgup.el7
python2-xrootd-5.0.1-1.3.osgup.el7
python3-condor-8.9.8-1.1.osgup.el7
python3-xrootd-5.0.1-1.3.osgup.el7
xrootd-5.0.1-1.3.osgup.el7
xrootd-client-5.0.1-1.3.osgup.el7
xrootd-client-compat-5.0.1-1.3.osgup.el7
xrootd-client-devel-5.0.1-1.3.osgup.el7
xrootd-client-libs-5.0.1-1.3.osgup.el7
xrootd-cmstfc-1.5.2-5.osgup.el7
xrootd-cmstfc-debuginfo-1.5.2-5.osgup.el7
xrootd-cmstfc-devel-1.5.2-5.osgup.el7
xrootd-debuginfo-5.0.1-1.3.osgup.el7
xrootd-devel-5.0.1-1.3.osgup.el7
xrootd-doc-5.0.1-1.3.osgup.el7
xrootd-fuse-5.0.1-1.3.osgup.el7
xrootd-hdfs-2.1.8-1.1.osgup.el7
xrootd-hdfs-debuginfo-2.1.8-1.1.osgup.el7
xrootd-hdfs-devel-2.1.8-1.1.osgup.el7
xrootd-lcmaps-1.7.8-3.osgup.el7
xrootd-lcmaps-debuginfo-1.7.8-3.osgup.el7
xrootd-libs-5.0.1-1.3.osgup.el7
xrootd-multiuser-0.4.3-4.osgup.el7
xrootd-multiuser-debuginfo-0.4.3-4.osgup.el7
xrootd-private-devel-5.0.1-1.3.osgup.el7
xrootd-rucioN2N-for-Xcache-1.2-3.3.osgup.el7
xrootd-rucioN2N-for-Xcache-debuginfo-1.2-3.3.osgup.el7
xrootd-scitokens-1.2.2-1.osgup.el7
xrootd-scitokens-debuginfo-1.2.2-1.osgup.el7
xrootd-selinux-5.0.1-1.3.osgup.el7
xrootd-server-5.0.1-1.3.osgup.el7
xrootd-server-compat-5.0.1-1.3.osgup.el7
xrootd-server-devel-5.0.1-1.3.osgup.el7
xrootd-server-libs-5.0.1-1.3.osgup.el7
xrootd-voms-5.0.1-1.3.osgup.el7
```

#### Enterprise Linux 8

``` file
```
