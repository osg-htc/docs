OSG Software Release 3.4.44
===========================

**Release Date**: 2020-02-20    
**Supported OS Versions:** EL7, EL6

!!!warning "OSG 3.4 End-of-Life Approaching"
    According to our
    [OSG Software Release Series Support Policy](https://opensciencegrid.org/technology/policy/release-series/),
    the OSG 3.4 series is due to reach
    [end-of-life](https://opensciencegrid.org/technology/policy/release-series/#life-cycle-dates) in **November 2020**.
    Please [upgrade to OSG 3.5](https://opensciencegrid.org/docs/release/release_series/#updating-to-osg-35)
    at your earliest convenience.

Summary of changes
------------------

This release contains:

-   [XRootD 4.11.2](https://github.com/xrootd/xrootd/blob/v4.11.2/docs/ReleaseNotes.txt): Bug fix release
-   XCache 1.2.1: Fixed problem where plugins were applied to redirectors
-   [VO Package v99](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-99): New certificate DN for HCC VOMS
-   UberFTP 2.8-3: OSG fixes incorporated upstream
-   osg-configure 2.5.1: Minor fixes
-   osg-system-profiler 1.5.0:
    -   Report XRootD configuration
    -   Elide kernel RPM checks

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.44%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The StashCache container is available and has been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [StashCache](https://hub.docker.com/r/opensciencegrid/stash-cache/)

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

-   OSG 3.4 contains only 64-bit components.
-   The StashCache service is only supported on EL7

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note "Notes"
    -   Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [osg-configure-2.5.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.5.1-1.osg34.el6)
-   [osg-system-profiler-1.5.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.5.0-1.osg34.el6)
-   [osg-version-3.4.44-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.44-1.osg34.el6)
-   [uberftp-2.8-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=uberftp-2.8-3.osg34.el6)
-   [vo-client-99-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-99-1.osg34.el6)
-   [xrootd-4.11.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.2-1.osg34.el6)

#### Enterprise Linux 7

-   [osg-configure-2.5.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.5.1-1.osg34.el7)
-   [osg-system-profiler-1.5.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.5.0-1.osg34.el7)
-   [osg-version-3.4.44-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.44-1.osg34.el7)
-   [uberftp-2.8-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=uberftp-2.8-3.osg34.el7)
-   [vo-client-99-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-99-1.osg34.el7)
-   [xcache-1.2.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-1.2.1-1.osg34.el7)
-   [xrootd-4.11.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.2-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    atlas-xcache cms-xcache osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-system-profiler osg-system-profiler-viewer osg-version python2-xrootd stash-cache stash-origin uberftp uberftp-debuginfo vo-client vo-client-dcache vo-client-lcmaps-voms xcache xcache-redirector xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
osg-configure-2.5.1-1.osg34.el6
osg-configure-bosco-2.5.1-1.osg34.el6
osg-configure-ce-2.5.1-1.osg34.el6
osg-configure-condor-2.5.1-1.osg34.el6
osg-configure-gateway-2.5.1-1.osg34.el6
osg-configure-gip-2.5.1-1.osg34.el6
osg-configure-gratia-2.5.1-1.osg34.el6
osg-configure-infoservices-2.5.1-1.osg34.el6
osg-configure-lsf-2.5.1-1.osg34.el6
osg-configure-misc-2.5.1-1.osg34.el6
osg-configure-pbs-2.5.1-1.osg34.el6
osg-configure-rsv-2.5.1-1.osg34.el6
osg-configure-sge-2.5.1-1.osg34.el6
osg-configure-siteinfo-2.5.1-1.osg34.el6
osg-configure-slurm-2.5.1-1.osg34.el6
osg-configure-squid-2.5.1-1.osg34.el6
osg-configure-tests-2.5.1-1.osg34.el6
osg-system-profiler-1.5.0-1.osg34.el6
osg-system-profiler-viewer-1.5.0-1.osg34.el6
osg-version-3.4.44-1.osg34.el6
python2-xrootd-4.11.2-1.osg34.el6
uberftp-2.8-3.osg34.el6
uberftp-debuginfo-2.8-3.osg34.el6
vo-client-99-1.osg34.el6
vo-client-dcache-99-1.osg34.el6
vo-client-lcmaps-voms-99-1.osg34.el6
xrootd-4.11.2-1.osg34.el6
xrootd-client-4.11.2-1.osg34.el6
xrootd-client-devel-4.11.2-1.osg34.el6
xrootd-client-libs-4.11.2-1.osg34.el6
xrootd-debuginfo-4.11.2-1.osg34.el6
xrootd-devel-4.11.2-1.osg34.el6
xrootd-doc-4.11.2-1.osg34.el6
xrootd-fuse-4.11.2-1.osg34.el6
xrootd-libs-4.11.2-1.osg34.el6
xrootd-private-devel-4.11.2-1.osg34.el6
xrootd-selinux-4.11.2-1.osg34.el6
xrootd-server-4.11.2-1.osg34.el6
xrootd-server-devel-4.11.2-1.osg34.el6
xrootd-server-libs-4.11.2-1.osg34.el6
```

#### Enterprise Linux 7

``` file
atlas-xcache-1.2.1-1.osg34.el7
cms-xcache-1.2.1-1.osg34.el7
osg-configure-2.5.1-1.osg34.el7
osg-configure-bosco-2.5.1-1.osg34.el7
osg-configure-ce-2.5.1-1.osg34.el7
osg-configure-condor-2.5.1-1.osg34.el7
osg-configure-gateway-2.5.1-1.osg34.el7
osg-configure-gip-2.5.1-1.osg34.el7
osg-configure-gratia-2.5.1-1.osg34.el7
osg-configure-infoservices-2.5.1-1.osg34.el7
osg-configure-lsf-2.5.1-1.osg34.el7
osg-configure-misc-2.5.1-1.osg34.el7
osg-configure-pbs-2.5.1-1.osg34.el7
osg-configure-rsv-2.5.1-1.osg34.el7
osg-configure-sge-2.5.1-1.osg34.el7
osg-configure-siteinfo-2.5.1-1.osg34.el7
osg-configure-slurm-2.5.1-1.osg34.el7
osg-configure-squid-2.5.1-1.osg34.el7
osg-configure-tests-2.5.1-1.osg34.el7
osg-system-profiler-1.5.0-1.osg34.el7
osg-system-profiler-viewer-1.5.0-1.osg34.el7
osg-version-3.4.44-1.osg34.el7
python2-xrootd-4.11.2-1.osg34.el7
stash-cache-1.2.1-1.osg34.el7
stash-origin-1.2.1-1.osg34.el7
uberftp-2.8-3.osg34.el7
uberftp-debuginfo-2.8-3.osg34.el7
vo-client-99-1.osg34.el7
vo-client-dcache-99-1.osg34.el7
vo-client-lcmaps-voms-99-1.osg34.el7
xcache-1.2.1-1.osg34.el7
xcache-redirector-1.2.1-1.osg34.el7
xrootd-4.11.2-1.osg34.el7
xrootd-client-4.11.2-1.osg34.el7
xrootd-client-devel-4.11.2-1.osg34.el7
xrootd-client-libs-4.11.2-1.osg34.el7
xrootd-debuginfo-4.11.2-1.osg34.el7
xrootd-devel-4.11.2-1.osg34.el7
xrootd-doc-4.11.2-1.osg34.el7
xrootd-fuse-4.11.2-1.osg34.el7
xrootd-libs-4.11.2-1.osg34.el7
xrootd-private-devel-4.11.2-1.osg34.el7
xrootd-selinux-4.11.2-1.osg34.el7
xrootd-server-4.11.2-1.osg34.el7
xrootd-server-devel-4.11.2-1.osg34.el7
xrootd-server-libs-4.11.2-1.osg34.el7
```
