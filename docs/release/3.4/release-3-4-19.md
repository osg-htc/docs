OSG Software Release 3.4.19
===========================

**Release Date**: 2018-10-25

Summary of changes
------------------

This release contains:

-   Added workaround to the OSG worker node tarball client to avoid TLS failures with GFAL
-   Updated to [XRootD 4.8.5](https://github.com/xrootd/xrootd/blob/v4.8.5/docs/ReleaseNotes.txt) - Bug fix release
-   Released `osg-flock` package for easier installation of OSG submit hosts
-   Improved StashCache packaging with better default configuration
-   Released [autopyfactory 2.4.9](https://github.com/PanDAWMS/autopyfactory/blob/2.4.9-1/CHANGELOG) which is currently in use at CERN

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.19%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found [here](/index.md).

Known Issues
------------

Due to the central RSV service retirement (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/) for details),
the new version of RSV will disable the `gratia-consumer` component that reports to the central service.
Please update _all_ RSV packages by running the following command on your RSV host:

``` console
root@host # yum update rsv\*
```

Additionally, if you are using osg-configure, please edit `/etc/osg/config.d/30-rsv.ini` and set the following:

``` file
enable_gratia = False
```

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](/common/yum#install-osg-repositories).

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

Do you need help with this release? [Contact us for help](/common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [autopyfactory-2.4.9-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=autopyfactory-2.4.9-2.osg34.el6)
-   [osg-flock-1.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.0-1.osg34.el6)
-   [osg-version-3.4.19-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.19-1.osg34.el6)
-   [xrootd-4.8.5-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.5-1.osg34.el6)

#### Enterprise Linux 7

-   [autopyfactory-2.4.9-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=autopyfactory-2.4.9-2.osg34.el7)
-   [osg-flock-1.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.0-1.osg34.el7)
-   [osg-version-3.4.19-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.19-1.osg34.el7)
-   [stashcache-0.9-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-0.9-1.osg34.el7)
-   [xrootd-4.8.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.5-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    autopyfactory-atlas autopyfactory-cloud autopyfactory-common autopyfactory-panda autopyfactory-plugins-cloud autopyfactory-plugins-local autopyfactory-plugins-monitor autopyfactory-plugins-panda autopyfactory-plugins-remote autopyfactory-plugins-scheds autopyfactory-proxymanager autopyfactory-remote autopyfactory-wms osg-flock osg-gums-config osg-version python2-xrootd python3-xrootd stashcache-cache-server stashcache-cache-server-auth stashcache-daemon stashcache-origin-server vo-client vo-client-dcache vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
autopyfactory-2.4.9-2.osg34.el6
autopyfactory-atlas-2.4.9-2.osg34.el6
autopyfactory-cloud-2.4.9-2.osg34.el6
autopyfactory-common-2.4.9-2.osg34.el6
autopyfactory-panda-2.4.9-2.osg34.el6
autopyfactory-plugins-cloud-2.4.9-2.osg34.el6
autopyfactory-plugins-local-2.4.9-2.osg34.el6
autopyfactory-plugins-monitor-2.4.9-2.osg34.el6
autopyfactory-plugins-panda-2.4.9-2.osg34.el6
autopyfactory-plugins-remote-2.4.9-2.osg34.el6
autopyfactory-plugins-scheds-2.4.9-2.osg34.el6
autopyfactory-proxymanager-2.4.9-2.osg34.el6
autopyfactory-remote-2.4.9-2.osg34.el6
autopyfactory-wms-2.4.9-2.osg34.el6
osg-flock-1.0-1.osg34.el6
osg-version-3.4.19-1.osg34.el6
python2-xrootd-4.8.5-1.osg34.el6
python3-xrootd-4.8.5-1.osg34.el6
xrootd-4.8.5-1.osg34.el6
xrootd-client-4.8.5-1.osg34.el6
xrootd-client-devel-4.8.5-1.osg34.el6
xrootd-client-libs-4.8.5-1.osg34.el6
xrootd-debuginfo-4.8.5-1.osg34.el6
xrootd-devel-4.8.5-1.osg34.el6
xrootd-doc-4.8.5-1.osg34.el6
xrootd-fuse-4.8.5-1.osg34.el6
xrootd-libs-4.8.5-1.osg34.el6
xrootd-private-devel-4.8.5-1.osg34.el6
xrootd-selinux-4.8.5-1.osg34.el6
xrootd-server-4.8.5-1.osg34.el6
xrootd-server-devel-4.8.5-1.osg34.el6
xrootd-server-libs-4.8.5-1.osg34.el6
```

#### Enterprise Linux 7

``` file
autopyfactory-2.4.9-2.osg34.el7
autopyfactory-atlas-2.4.9-2.osg34.el7
autopyfactory-cloud-2.4.9-2.osg34.el7
autopyfactory-common-2.4.9-2.osg34.el7
autopyfactory-panda-2.4.9-2.osg34.el7
autopyfactory-plugins-cloud-2.4.9-2.osg34.el7
autopyfactory-plugins-local-2.4.9-2.osg34.el7
autopyfactory-plugins-monitor-2.4.9-2.osg34.el7
autopyfactory-plugins-panda-2.4.9-2.osg34.el7
autopyfactory-plugins-remote-2.4.9-2.osg34.el7
autopyfactory-plugins-scheds-2.4.9-2.osg34.el7
autopyfactory-proxymanager-2.4.9-2.osg34.el7
autopyfactory-remote-2.4.9-2.osg34.el7
autopyfactory-wms-2.4.9-2.osg34.el7
osg-flock-1.0-1.osg34.el7
osg-version-3.4.19-1.osg34.el7
python2-xrootd-4.8.5-1.osg34.el7
python3-xrootd-4.8.5-1.osg34.el7
stashcache-0.9-1.osg34.el7
stashcache-cache-server-0.9-1.osg34.el7
stashcache-cache-server-auth-0.9-1.osg34.el7
stashcache-daemon-0.9-1.osg34.el7
stashcache-origin-server-0.9-1.osg34.el7
xrootd-4.8.5-1.osg34.el7
xrootd-client-4.8.5-1.osg34.el7
xrootd-client-devel-4.8.5-1.osg34.el7
xrootd-client-libs-4.8.5-1.osg34.el7
xrootd-debuginfo-4.8.5-1.osg34.el7
xrootd-devel-4.8.5-1.osg34.el7
xrootd-doc-4.8.5-1.osg34.el7
xrootd-fuse-4.8.5-1.osg34.el7
xrootd-libs-4.8.5-1.osg34.el7
xrootd-private-devel-4.8.5-1.osg34.el7
xrootd-selinux-4.8.5-1.osg34.el7
xrootd-server-4.8.5-1.osg34.el7
xrootd-server-devel-4.8.5-1.osg34.el7
xrootd-server-libs-4.8.5-1.osg34.el7
```
