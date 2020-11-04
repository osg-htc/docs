OSG Software Release 3.5.11
===========================

**Release Date:** 2020-03-11    
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

-   [CVMFS 2.7.1](https://cvmfs.readthedocs.io/en/2.7/cpt-releasenotes.html): Bug Fixes and Improvements
    -   Fix client fail-over for redirected stratum 1 sources
    -   Add server configuration to support MaxMind GeoDB license requirements
-   [oidc-agent 3.3.1](https://github.com/indigo-dc/oidc-agent/releases): Update from version 3.2.6
    -   Add support to request tokens with specific audience
-   [CCTools 7.0.22](http://cclnd.blogspot.com/2020/01/announcement-cctools-version-7022.html): Bug fix release
-   GSI-OpenSSH 7.4p1-5: Bring up to date with EPEL
-   [VO Package v101](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-101)
    -   Update LZ VOMS server DN
    -   Add new GlueX VO DN
    -   Retire DOSAR

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.11%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.


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

-   [cctools-7.0.22-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.22-1.osg35.el7)
-   [cvmfs-2.7.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.1-1.osg35.el7)
-   [gsi-openssh-7.4p1-5.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.4p1-5.1.osg35.el7)
-   [oidc-agent-3.3.1-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=oidc-agent-3.3.1-1.1.osg35.el7)
-   [osg-oasis-16-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-2.osg35.el7)
-   [vo-client-101-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-101-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cctools cctools-debuginfo cctools-devel cvmfs cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server oidc-agent oidc-agent-debuginfo osg-oasis vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
cctools-7.0.22-1.osg35.el7
cctools-debuginfo-7.0.22-1.osg35.el7
cctools-devel-7.0.22-1.osg35.el7
cvmfs-2.7.1-1.osg35.el7
cvmfs-devel-2.7.1-1.osg35.el7
cvmfs-ducc-2.7.1-1.osg35.el7
cvmfs-fuse3-2.7.1-1.osg35.el7
cvmfs-server-2.7.1-1.osg35.el7
cvmfs-shrinkwrap-2.7.1-1.osg35.el7
cvmfs-unittests-2.7.1-1.osg35.el7
gsi-openssh-7.4p1-5.1.osg35.el7
gsi-openssh-clients-7.4p1-5.1.osg35.el7
gsi-openssh-debuginfo-7.4p1-5.1.osg35.el7
gsi-openssh-server-7.4p1-5.1.osg35.el7
oidc-agent-3.3.1-1.1.osg35.el7
oidc-agent-debuginfo-3.3.1-1.1.osg35.el7
osg-oasis-16-2.osg35.el7
vo-client-101-1.osg35.el7
vo-client-dcache-101-1.osg35.el7
vo-client-lcmaps-voms-101-1.osg35.el7
```
