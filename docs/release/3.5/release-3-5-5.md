OSG Software Release 3.5.5
===========================

**Release Date:** 2019-11-14
**Supported OS Versions:** EL7

Summary of Changes
------------------

This release contains:

-   [Frontier-Squid 4.9-2.1](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES): [Fixed security vulnerabilities](https://opensciencegrid.org/security/vulns/OSG-SEC-2019-11-11-Vulnerability-in-Squid-UPDATE/)
    -   Heap Overflow issue in URN processing
    -   Multiple issues in URI processing
-   [XRootD 4.11.0](https://github.com/xrootd/xrootd/blob/v4.11.0/docs/ReleaseNotes.txt): New feature release
-   [BLAHP 1.18.45](https://github.com/htcondor/BLAH/releases/tag/v1.18.44)
    -   Add SystemCpu accounting when Slurm jobs complete
    -   Add support for decimal seconds fields from Slurm
    -   Move local submit attributes scripts from spec to sources
    -   Pull in various updates to Slurm scripts from HTCondor's BLAHP
        -   Add BLAHP options for project name (-A, BatchProject) and runtime limit (-t, BatchRuntime).
            -   The `BatchProject` HTCondor job attribute is a string that's used with the project or allocation option of the batch system's submission interface.
            -   The `BatchRuntime` HTCondor job attribute is an integer that limits the job's wall-clock execution time, expressed in seconds.
        -   Detect and handle Slurm jobs in the TIMEOUT state
        -   Explicitly specify `/bin/bash` for shell scripts rather than `/bin/sh`
        -   Minor python bug fixes for comparing variables against None
        -   Support multiple Slurm clusters. The batch queue job parameter to the BLAHP now accepts an optional `@<CLUSTER NAME>` suffix. The job id generated for the BLAHP will include the cluster name to allow subsequent actions to target the specified cluster.
-   scitokens-credmon 0.4.2: Provide configuration files in examples directory
-   scitokens-cpp 0.3.5: Fixed Elliptic-curve public key handling

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.5%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.

Known Issues
------------

- OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).


Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](../../release/release_series.md#updating-to-osg-35).

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

-   [blahp-1.18.45-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.45-1.osg35.el7)
-   [frontier-squid-4.9-2.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.9-2.1.osg35.el7)
-   [scitokens-cpp-0.3.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.3.5-1.osg35.el7)
-   [scitokens-credmon-0.4-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-credmon-0.4-2.osg35.el7)
-   [xrootd-4.11.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.0-1.osg35.el7)
-   [xrootd-hdfs-2.1.7-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.7-2.osg35.el7)
-   [xrootd-lcmaps-1.7.4-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.4-4.osg35.el7)
-   [xrootd-multiuser-0.4.2-5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.2-5.osg35.el7)
-   [xrootd-scitokens-1.0.0-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.0.0-1.2.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo frontier-squid frontier-squid-debuginfo python2-scitokens-credmon python2-xrootd scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
blahp-1.18.45-1.osg35.el7
blahp-debuginfo-1.18.45-1.osg35.el7
frontier-squid-4.9-2.1.osg35.el7
frontier-squid-debuginfo-4.9-2.1.osg35.el7
python2-scitokens-credmon-0.4-2.osg35.el7
python2-xrootd-4.11.0-1.osg35.el7
scitokens-cpp-0.3.5-1.osg35.el7
scitokens-cpp-debuginfo-0.3.5-1.osg35.el7
scitokens-cpp-devel-0.3.5-1.osg35.el7
scitokens-credmon-0.4-2.osg35.el7
xrootd-4.11.0-1.osg35.el7
xrootd-client-4.11.0-1.osg35.el7
xrootd-client-devel-4.11.0-1.osg35.el7
xrootd-client-libs-4.11.0-1.osg35.el7
xrootd-debuginfo-4.11.0-1.osg35.el7
xrootd-devel-4.11.0-1.osg35.el7
xrootd-doc-4.11.0-1.osg35.el7
xrootd-fuse-4.11.0-1.osg35.el7
xrootd-hdfs-2.1.7-2.osg35.el7
xrootd-hdfs-debuginfo-2.1.7-2.osg35.el7
xrootd-hdfs-devel-2.1.7-2.osg35.el7
xrootd-lcmaps-1.7.4-4.osg35.el7
xrootd-lcmaps-debuginfo-1.7.4-4.osg35.el7
xrootd-libs-4.11.0-1.osg35.el7
xrootd-multiuser-0.4.2-5.osg35.el7
xrootd-multiuser-debuginfo-0.4.2-5.osg35.el7
xrootd-private-devel-4.11.0-1.osg35.el7
xrootd-scitokens-1.0.0-1.2.osg35.el7
xrootd-scitokens-debuginfo-1.0.0-1.2.osg35.el7
xrootd-selinux-4.11.0-1.osg35.el7
xrootd-server-4.11.0-1.osg35.el7
xrootd-server-devel-4.11.0-1.osg35.el7
xrootd-server-libs-4.11.0-1.osg35.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

-   [blahp-1.18.45-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.45-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
blahp-1.18.45-1.osgup.el7
blahp-debuginfo-1.18.45-1.osgup.el7
```
