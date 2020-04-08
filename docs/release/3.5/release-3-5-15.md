OSG Software Release 3.5.15
===========================

**Release Date:** 2020-04-08    
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

-   [Frontier Squid 4.10.3](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): Bug fix for negative caching
-   [VO Package v103](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-102)
    -   Added WLCG VOMS
    -   Updated certificate for voms1.fnal.gov
-   [XRootD 4.11.3](https://github.com/xrootd/xrootd/blob/v4.11.3/docs/ReleaseNotes.txt): Bug fix release
-   osg-xrootd 3.5-12: The standalone configuration file only affects the standalone XRootD process

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.15%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [frontier-squid-4.10-3.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.10-3.1.osg35.el7)
-   [osg-xrootd-3.5-12.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5-12.osg35.el7)
-   [vo-client-103-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-103-1.osg35.el7)
-   [xrootd-4.11.3-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.3-1.2.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid frontier-squid-debuginfo osg-xrootd osg-xrootd-standalone python2-xrootd vo-client vo-client-dcache vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
frontier-squid-4.10-3.1.osg35.el7
frontier-squid-debuginfo-4.10-3.1.osg35.el7
osg-xrootd-3.5-12.osg35.el7
osg-xrootd-standalone-3.5-12.osg35.el7
python2-xrootd-4.11.3-1.2.osg35.el7
vo-client-103-1.osg35.el7
vo-client-dcache-103-1.osg35.el7
vo-client-lcmaps-voms-103-1.osg35.el7
xrootd-4.11.3-1.2.osg35.el7
xrootd-client-4.11.3-1.2.osg35.el7
xrootd-client-devel-4.11.3-1.2.osg35.el7
xrootd-client-libs-4.11.3-1.2.osg35.el7
xrootd-debuginfo-4.11.3-1.2.osg35.el7
xrootd-devel-4.11.3-1.2.osg35.el7
xrootd-doc-4.11.3-1.2.osg35.el7
xrootd-fuse-4.11.3-1.2.osg35.el7
xrootd-libs-4.11.3-1.2.osg35.el7
xrootd-private-devel-4.11.3-1.2.osg35.el7
xrootd-selinux-4.11.3-1.2.osg35.el7
xrootd-server-4.11.3-1.2.osg35.el7
xrootd-server-devel-4.11.3-1.2.osg35.el7
xrootd-server-libs-4.11.3-1.2.osg35.el7
```
