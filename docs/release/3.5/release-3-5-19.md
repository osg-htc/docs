OSG Software Release 3.5.19
===========================

**Release Date:** 2020-07-01    
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

!!! note
    If using scitokens-credmon with HTCondor 8.9, [manual adjustments](../release_series.md#updating-to-htcondor-897) need to be made before upgrading.

This release contains:

-   [XRootD 4.12.3](https://github.com/xrootd/xrootd/blob/v4.12.3/docs/ReleaseNotes.txt)
    -   Major features to the the xrdcp client:
        -   Ability to limit bandwidth usage
        -   Ability to resume a transfer
        -   Minor new enhancements for the python based bindings
        -   Several bug fixes
-   xrootd-lcmaps 1.7.7: Better logging when lcmaps is not used
-   [scitokens-credmon](https://github.com/htcondor/scitokens-credmon) 0.7
    -   Conforms (gracefully) to configuration changes in HTCondor 8.9.7
    -   Fixes exception logging that may have caused the CredMon to hang
    -   Fixes OAuthCredmon from trying to read LocalCredmon credentials
    -   Emits error message when local issuer private key is not found
    -   Adds a lookup table for common OAuth providers' user information endpoints
    -   Adds a lookup table to set how often tokens are refreshed for common OAuth providers
    -   The main condor\_credmon\_oauth script now uses multiprocessing processes and queue to prevent credmon threads from stalling
-   Upcoming: [HTCondor 8.9.7](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00010.shtml): New feature release
    -    Multiple enhancements in the file transfer code
    -    Support for more regions in s3:// URLs
    -    Much more flexible job router language
    -    Jobs may now specify cuda\_version to match equally-capable GPUs
    -    TOKENS are now called IDTOKENS to differentiate from SCITOKENS
    -    Added the ability to blacklist IDTOKENS via an expression
    -    Can simultaneously handle Kerberos and OAUTH credentials
    -    The startd supports a remote history query similar to the schedd
    -    condor\_q -submitters now works with accounting groups
    -    Fixed a bug reading service account credentials for Google Compute Engine

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.19%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.


Containers
----------

The `Frontier Squid` and `Hosted CE` containers are available and have been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [Stash Cache](https://hub.docker.com/r/opensciencegrid/stash-cache/)


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

-   [cctools-7.1.6-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.1.6-1.osg35.el7)
-   [scitokens-credmon-0.7-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-credmon-0.7-1.osg35.el7)
-   [xrootd-4.12.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.12.3-1.osg35.el7)
-   [xrootd-hdfs-2.1.7-6.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.7-6.osg35.el7)
-   [xrootd-lcmaps-1.7.7-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.7-2.osg35.el7)
-   [xrootd-multiuser-0.4.2-8.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.2-8.osg35.el7)
-   [xrootd-scitokens-1.2.0-5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.2.0-5.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cctools cctools-debuginfo cctools-devel python2-scitokens-credmon python2-xrootd scitokens-credmon xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs xrootd-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
cctools-7.1.6-1.osg35.el7
cctools-debuginfo-7.1.6-1.osg35.el7
cctools-devel-7.1.6-1.osg35.el7
python2-scitokens-credmon-0.7-1.osg35.el7
python2-xrootd-4.12.3-1.osg35.el7
scitokens-credmon-0.7-1.osg35.el7
xrootd-4.12.3-1.osg35.el7
xrootd-client-4.12.3-1.osg35.el7
xrootd-client-devel-4.12.3-1.osg35.el7
xrootd-client-libs-4.12.3-1.osg35.el7
xrootd-debuginfo-4.12.3-1.osg35.el7
xrootd-devel-4.12.3-1.osg35.el7
xrootd-doc-4.12.3-1.osg35.el7
xrootd-fuse-4.12.3-1.osg35.el7
xrootd-hdfs-2.1.7-6.osg35.el7
xrootd-hdfs-debuginfo-2.1.7-6.osg35.el7
xrootd-hdfs-devel-2.1.7-6.osg35.el7
xrootd-lcmaps-1.7.7-2.osg35.el7
xrootd-lcmaps-debuginfo-1.7.7-2.osg35.el7
xrootd-libs-4.12.3-1.osg35.el7
xrootd-multiuser-0.4.2-8.osg35.el7
xrootd-multiuser-debuginfo-0.4.2-8.osg35.el7
xrootd-private-devel-4.12.3-1.osg35.el7
xrootd-scitokens-1.2.0-5.osg35.el7
xrootd-scitokens-debuginfo-1.2.0-5.osg35.el7
xrootd-selinux-4.12.3-1.osg35.el7
xrootd-server-4.12.3-1.osg35.el7
xrootd-server-devel-4.12.3-1.osg35.el7
xrootd-server-libs-4.12.3-1.osg35.el7
xrootd-voms-4.12.3-1.osg35.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

-   [blahp-1.18.46-3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.46-3.osgup.el7)
-   [condor-8.9.7-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.7-1.1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone minicondor python2-condor python3-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
blahp-1.18.46-3.osgup.el7
blahp-debuginfo-1.18.46-3.osgup.el7
condor-8.9.7-1.1.osgup.el7
condor-all-8.9.7-1.1.osgup.el7
condor-annex-ec2-8.9.7-1.1.osgup.el7
condor-bosco-8.9.7-1.1.osgup.el7
condor-classads-8.9.7-1.1.osgup.el7
condor-classads-devel-8.9.7-1.1.osgup.el7
condor-debuginfo-8.9.7-1.1.osgup.el7
condor-kbdd-8.9.7-1.1.osgup.el7
condor-procd-8.9.7-1.1.osgup.el7
condor-test-8.9.7-1.1.osgup.el7
condor-vm-gahp-8.9.7-1.1.osgup.el7
minicondor-8.9.7-1.1.osgup.el7
python2-condor-8.9.7-1.1.osgup.el7
python3-condor-8.9.7-1.1.osgup.el7
```
