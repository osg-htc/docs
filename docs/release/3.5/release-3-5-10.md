OSG Software Release 3.5.10
===========================

**Release Date:** 2020-02-20    
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

-   [XRootD 4.11.2](https://github.com/xrootd/xrootd/blob/v4.11.2/docs/ReleaseNotes.txt): Bug fix release
-   XCache 1.2.1: Fixed problem where plugins were applied to redirectors
-   [VO Package v99](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-99): New certificate DN for HCC VOMS
-   UberFTP 2.8-3: OSG fixes incorporated upstream
-   osg-configure 3.1.1: Minor fixes
-   osg-system-profiler 1.5.0:
    -   Report XRootD configuration
    -   Elide kernel RPM checks

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.10%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The StashCache container is available and has been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [StashCache](https://hub.docker.com/r/opensciencegrid/stash-cache/)


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

-   [osg-configure-3.1.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-3.1.1-1.osg35.el7)
-   [osg-system-profiler-1.5.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.5.0-1.osg35.el7)
-   [uberftp-2.8-3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=uberftp-2.8-3.osg35.el7)
-   [vo-client-99-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-99-1.osg35.el7)
-   [xcache-1.2.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-1.2.1-1.osg35.el7)
-   [xrootd-4.11.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.2-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    atlas-xcache cms-xcache osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-system-profiler osg-system-profiler-viewer python2-xrootd stash-cache stash-origin uberftp uberftp-debuginfo vo-client vo-client-dcache vo-client-lcmaps-voms xcache xcache-redirector xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
atlas-xcache-1.2.1-1.osg35.el7
cms-xcache-1.2.1-1.osg35.el7
osg-configure-3.1.1-1.osg35.el7
osg-configure-bosco-3.1.1-1.osg35.el7
osg-configure-ce-3.1.1-1.osg35.el7
osg-configure-condor-3.1.1-1.osg35.el7
osg-configure-gateway-3.1.1-1.osg35.el7
osg-configure-gip-3.1.1-1.osg35.el7
osg-configure-gratia-3.1.1-1.osg35.el7
osg-configure-infoservices-3.1.1-1.osg35.el7
osg-configure-lsf-3.1.1-1.osg35.el7
osg-configure-misc-3.1.1-1.osg35.el7
osg-configure-pbs-3.1.1-1.osg35.el7
osg-configure-rsv-3.1.1-1.osg35.el7
osg-configure-sge-3.1.1-1.osg35.el7
osg-configure-siteinfo-3.1.1-1.osg35.el7
osg-configure-slurm-3.1.1-1.osg35.el7
osg-configure-squid-3.1.1-1.osg35.el7
osg-configure-tests-3.1.1-1.osg35.el7
osg-system-profiler-1.5.0-1.osg35.el7
osg-system-profiler-viewer-1.5.0-1.osg35.el7
python2-xrootd-4.11.2-1.osg35.el7
stash-cache-1.2.1-1.osg35.el7
stash-origin-1.2.1-1.osg35.el7
uberftp-2.8-3.osg35.el7
uberftp-debuginfo-2.8-3.osg35.el7
vo-client-99-1.osg35.el7
vo-client-dcache-99-1.osg35.el7
vo-client-lcmaps-voms-99-1.osg35.el7
xcache-1.2.1-1.osg35.el7
xcache-redirector-1.2.1-1.osg35.el7
xrootd-4.11.2-1.osg35.el7
xrootd-client-4.11.2-1.osg35.el7
xrootd-client-devel-4.11.2-1.osg35.el7
xrootd-client-libs-4.11.2-1.osg35.el7
xrootd-debuginfo-4.11.2-1.osg35.el7
xrootd-devel-4.11.2-1.osg35.el7
xrootd-doc-4.11.2-1.osg35.el7
xrootd-fuse-4.11.2-1.osg35.el7
xrootd-libs-4.11.2-1.osg35.el7
xrootd-private-devel-4.11.2-1.osg35.el7
xrootd-selinux-4.11.2-1.osg35.el7
xrootd-server-4.11.2-1.osg35.el7
xrootd-server-devel-4.11.2-1.osg35.el7
xrootd-server-libs-4.11.2-1.osg35.el7
```
