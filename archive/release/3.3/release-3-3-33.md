OSG Software Release 3.3.33
===========================

**Release Date**: 2018-03-08

Summary of changes
------------------

This release contains:

-   Fixed a configuration issue where the XRootD service would not start at boot time

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.33%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../index.md).

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-osg-repositories#updating-from-osg-31-32-33-to-33-or-34).

### Update Software

Once the repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note "Notes"
    -   Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension).

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [osg-version-3.3.33-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.33-1.osg33.el6)
-   [xrootd-4.8.0-2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.0-2.osg33.el6)

#### Enterprise Linux 7

-   [osg-version-3.3.33-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.33-1.osg33.el7)
-   [xrootd-4.8.0-2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.0-2.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-version python2-xrootd python3-xrootd xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
osg-version-3.3.33-1.osg33.el6
python2-xrootd-4.8.0-2.osg33.el6
python3-xrootd-4.8.0-2.osg33.el6
xrootd-4.8.0-2.osg33.el6
xrootd-client-4.8.0-2.osg33.el6
xrootd-client-devel-4.8.0-2.osg33.el6
xrootd-client-libs-4.8.0-2.osg33.el6
xrootd-debuginfo-4.8.0-2.osg33.el6
xrootd-devel-4.8.0-2.osg33.el6
xrootd-doc-4.8.0-2.osg33.el6
xrootd-fuse-4.8.0-2.osg33.el6
xrootd-libs-4.8.0-2.osg33.el6
xrootd-private-devel-4.8.0-2.osg33.el6
xrootd-selinux-4.8.0-2.osg33.el6
xrootd-server-4.8.0-2.osg33.el6
xrootd-server-devel-4.8.0-2.osg33.el6
xrootd-server-libs-4.8.0-2.osg33.el6
```

#### Enterprise Linux 7

``` file
osg-version-3.3.33-1.osg33.el7
python2-xrootd-4.8.0-2.osg33.el7
python3-xrootd-4.8.0-2.osg33.el7
xrootd-4.8.0-2.osg33.el7
xrootd-client-4.8.0-2.osg33.el7
xrootd-client-devel-4.8.0-2.osg33.el7
xrootd-client-libs-4.8.0-2.osg33.el7
xrootd-debuginfo-4.8.0-2.osg33.el7
xrootd-devel-4.8.0-2.osg33.el7
xrootd-doc-4.8.0-2.osg33.el7
xrootd-fuse-4.8.0-2.osg33.el7
xrootd-libs-4.8.0-2.osg33.el7
xrootd-private-devel-4.8.0-2.osg33.el7
xrootd-selinux-4.8.0-2.osg33.el7
xrootd-server-4.8.0-2.osg33.el7
xrootd-server-devel-4.8.0-2.osg33.el7
xrootd-server-libs-4.8.0-2.osg33.el7
```
