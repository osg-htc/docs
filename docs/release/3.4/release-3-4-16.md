OSG Software Release 3.4.16
===========================

**Release Date**: 2018-08-01

Summary of changes
------------------

This release contains:

-   [Frontier Squid 3.5.27-5.2](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES): Improve performance by not doing a reverse DNS lookup for every client connection
-   [XRootD 4.8.4](https://github.com/xrootd/xrootd/blob/v4.8.4/docs/ReleaseNotes.txt): Bug fix release
-   [SciTokens 1.2.0](https://github.com/scitokens/scitokens/releases/tag/v1.2.0): Initial SciTokens Support (EL7 only)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.16%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-to-osg-35).

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

-   [frontier-squid-3.5.27-5.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.27-5.2.osg34.el6)
-   [osg-version-3.4.16-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.16-1.osg34.el6)
-   [xrootd-4.8.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.4-1.osg34.el6)

#### Enterprise Linux 7

-   [frontier-squid-3.5.27-5.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.27-5.2.osg34.el7)
-   [osg-version-3.4.16-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.16-1.osg34.el7)
-   [python-scitokens-1.2.0-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.2.0-2.osg34.el7)
-   [xrootd-4.8.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.4-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid frontier-squid-debuginfo osg-version python2-scitokens python2-xrootd python3-xrootd xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
frontier-squid-3.5.27-5.2.osg34.el6
frontier-squid-debuginfo-3.5.27-5.2.osg34.el6
osg-version-3.4.16-1.osg34.el6
python2-xrootd-4.8.4-1.osg34.el6
python3-xrootd-4.8.4-1.osg34.el6
xrootd-4.8.4-1.osg34.el6
xrootd-client-4.8.4-1.osg34.el6
xrootd-client-devel-4.8.4-1.osg34.el6
xrootd-client-libs-4.8.4-1.osg34.el6
xrootd-debuginfo-4.8.4-1.osg34.el6
xrootd-devel-4.8.4-1.osg34.el6
xrootd-doc-4.8.4-1.osg34.el6
xrootd-fuse-4.8.4-1.osg34.el6
xrootd-libs-4.8.4-1.osg34.el6
xrootd-private-devel-4.8.4-1.osg34.el6
xrootd-selinux-4.8.4-1.osg34.el6
xrootd-server-4.8.4-1.osg34.el6
xrootd-server-devel-4.8.4-1.osg34.el6
xrootd-server-libs-4.8.4-1.osg34.el6
```

#### Enterprise Linux 7

``` file
frontier-squid-3.5.27-5.2.osg34.el7
frontier-squid-debuginfo-3.5.27-5.2.osg34.el7
osg-version-3.4.16-1.osg34.el7
python2-scitokens-1.2.0-2.osg34.el7
python2-xrootd-4.8.4-1.osg34.el7
python3-xrootd-4.8.4-1.osg34.el7
python-scitokens-1.2.0-2.osg34.el7
xrootd-4.8.4-1.osg34.el7
xrootd-client-4.8.4-1.osg34.el7
xrootd-client-devel-4.8.4-1.osg34.el7
xrootd-client-libs-4.8.4-1.osg34.el7
xrootd-debuginfo-4.8.4-1.osg34.el7
xrootd-devel-4.8.4-1.osg34.el7
xrootd-doc-4.8.4-1.osg34.el7
xrootd-fuse-4.8.4-1.osg34.el7
xrootd-libs-4.8.4-1.osg34.el7
xrootd-private-devel-4.8.4-1.osg34.el7
xrootd-selinux-4.8.4-1.osg34.el7
xrootd-server-4.8.4-1.osg34.el7
xrootd-server-devel-4.8.4-1.osg34.el7
xrootd-server-libs-4.8.4-1.osg34.el7
```
