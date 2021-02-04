OSG Software Release 3.5.31
===========================

**Release Date:** 2021-02-04    
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

-   [CVMFS 2.8.0](https://cvmfs.readthedocs.io/en/2.8/cpt-releasenotes.html)
    -   A new “service container” aimed at easier kubernetes deployments
    -   Support for macOS 11 Big Sur
    -   Support for Windows Services for Linux (WSL2)
    -   Parallelized garbage collection for greatly reduced GC durations
    -   Support for generating podman image store meta-data in DUCC
    -   Ability to show the diff of the current transaction using the cvmfs\_server diff --worktree command
    -   Two new experimental features: “template transactions” and ephemeral publish containers
-   [XRootD 4.12.6](https://github.com/xrootd/xrootd/blob/v4.12.6/docs/ReleaseNotes.txt): Bug fix release
-   osg-ca-certs 1.94: Added cross-signing Let's Encrypt root CA
-   osg-release 3.5-5: Make upcoming repositories OSG version specific
-   osg-flock 1.3: Enable schedd audit log
-   python-scitokens 1.3.1
    -   Added option to specify the lifetime of generated tokens
    -   Fix dependency change of behavior in PyJWT
-   lcmaps 1.6.6: Initial version on EL8

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.31)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [cvmfs-2.8.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.8.0-1.osg35.el7)
-   [osg-ca-certs-1.94-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.94-1.osg35.el7)
-   [osg-flock-1.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.3-1.osg35.el7)
-   [osg-oasis-17-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-17-1.osg35.el7)
-   [osg-release-3.5-5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.5-5.osg35.el7)
-   [python-scitokens-1.3.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.3.1-1.osg35.el7)
-   [xrootd-4.12.6-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.12.6-1.1.osg35.el7)

#### Enterprise Linux 8

-   [cvmfs-2.8.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.8.0-1.osg35.el8)
-   [lcmaps-1.6.6-1.14.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.14.osg35.el8)
-   [lcmaps-plugins-basic-1.7.0-2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-basic-1.7.0-2.osg35.el8)
-   [lcmaps-plugins-verify-proxy-1.5.11-1.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.11-1.1.osg35.el8)
-   [lcmaps-plugins-voms-1.7.1-1.6.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.6.osg35.el8)
-   [osg-ca-certs-1.94-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.94-1.osg35.el8)
-   [osg-oasis-17-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-17-1.osg35.el8)
-   [osg-release-3.5-5.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.5-5.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cvmfs cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests osg-ca-certs osg-flock osg-oasis osg-release python2-scitokens python2-xrootd python3-scitokens python-scitokens xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs xrootd-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
cvmfs-2.8.0-1.osg35.el7
cvmfs-devel-2.8.0-1.osg35.el7
cvmfs-ducc-2.8.0-1.osg35.el7
cvmfs-fuse3-2.8.0-1.osg35.el7
cvmfs-server-2.8.0-1.osg35.el7
cvmfs-shrinkwrap-2.8.0-1.osg35.el7
cvmfs-unittests-2.8.0-1.osg35.el7
osg-ca-certs-1.94-1.osg35.el7
osg-flock-1.3-1.osg35.el7
osg-oasis-17-1.osg35.el7
osg-release-3.5-5.osg35.el7
python2-scitokens-1.3.1-1.osg35.el7
python2-xrootd-4.12.6-1.1.osg35.el7
python3-scitokens-1.3.1-1.osg35.el7
python-scitokens-1.3.1-1.osg35.el7
xrootd-4.12.6-1.1.osg35.el7
xrootd-client-4.12.6-1.1.osg35.el7
xrootd-client-devel-4.12.6-1.1.osg35.el7
xrootd-client-libs-4.12.6-1.1.osg35.el7
xrootd-debuginfo-4.12.6-1.1.osg35.el7
xrootd-devel-4.12.6-1.1.osg35.el7
xrootd-doc-4.12.6-1.1.osg35.el7
xrootd-fuse-4.12.6-1.1.osg35.el7
xrootd-libs-4.12.6-1.1.osg35.el7
xrootd-private-devel-4.12.6-1.1.osg35.el7
xrootd-selinux-4.12.6-1.1.osg35.el7
xrootd-server-4.12.6-1.1.osg35.el7
xrootd-server-devel-4.12.6-1.1.osg35.el7
xrootd-server-libs-4.12.6-1.1.osg35.el7
xrootd-voms-4.12.6-1.1.osg35.el7
```

#### Enterprise Linux 8

``` file
cvmfs-2.8.0-1.osg35.el8
cvmfs-devel-2.8.0-1.osg35.el8
cvmfs-ducc-2.8.0-1.osg35.el8
cvmfs-fuse3-2.8.0-1.osg35.el8
cvmfs-server-2.8.0-1.osg35.el8
cvmfs-shrinkwrap-2.8.0-1.osg35.el8
cvmfs-unittests-2.8.0-1.osg35.el8
lcmaps-1.6.6-1.14.osg35.el8
lcmaps-common-devel-1.6.6-1.14.osg35.el8
lcmaps-db-templates-1.6.6-1.14.osg35.el8
lcmaps-debuginfo-1.6.6-1.14.osg35.el8
lcmaps-debugsource-1.6.6-1.14.osg35.el8
lcmaps-devel-1.6.6-1.14.osg35.el8
lcmaps-plugins-basic-1.7.0-2.osg35.el8
lcmaps-plugins-basic-debuginfo-1.7.0-2.osg35.el8
lcmaps-plugins-basic-debugsource-1.7.0-2.osg35.el8
lcmaps-plugins-basic-ldap-1.7.0-2.osg35.el8
lcmaps-plugins-basic-ldap-debuginfo-1.7.0-2.osg35.el8
lcmaps-plugins-verify-proxy-1.5.11-1.1.osg35.el8
lcmaps-plugins-verify-proxy-debuginfo-1.5.11-1.1.osg35.el8
lcmaps-plugins-verify-proxy-debugsource-1.5.11-1.1.osg35.el8
lcmaps-plugins-voms-1.7.1-1.6.osg35.el8
lcmaps-plugins-voms-debuginfo-1.7.1-1.6.osg35.el8
lcmaps-plugins-voms-debugsource-1.7.1-1.6.osg35.el8
lcmaps-without-gsi-1.6.6-1.14.osg35.el8
lcmaps-without-gsi-debuginfo-1.6.6-1.14.osg35.el8
lcmaps-without-gsi-devel-1.6.6-1.14.osg35.el8
osg-ca-certs-1.94-1.osg35.el8
osg-oasis-17-1.osg35.el8
osg-release-3.5-5.osg35.el8
```
