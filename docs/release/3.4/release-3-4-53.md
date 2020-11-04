OSG Software Release 3.4.53
===========================

**Release Date**: 2020-07-01    
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

-   [XRootD 4.12.3](https://github.com/xrootd/xrootd/blob/v4.12.3/docs/ReleaseNotes.txt)
    -   Major features to the the xrdcp client:
        -   Ability to limit bandwidth usage
        -   Ability to resume a transfer
        -   Minor new enhancements for the python based bindings
        -   Several bug fixes
-   xrootd-lcmaps 1.7.7: Better logging when lcmaps is not used

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.53%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](/index.md).

-   OSG 3.4 contains only 64-bit components.
-   The StashCache service is only supported on EL7

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

-   [osg-version-3.4.53-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.53-1.osg34.el6)
-   [xrootd-4.12.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.12.3-1.osg34.el6)
-   [xrootd-lcmaps-1.7.7-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.7-2.osg34.el6)

#### Enterprise Linux 7

-   [osg-version-3.4.53-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.53-1.osg34.el7)
-   [xrootd-4.12.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.12.3-1.osg34.el7)
-   [xrootd-hdfs-2.1.7-6.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.7-6.osg34.el7)
-   [xrootd-lcmaps-1.7.7-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.7-2.osg34.el7)
-   [xrootd-multiuser-0.4.2-9.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.2-9.osg34.el7)
-   [xrootd-scitokens-1.2.0-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.2.0-5.osg34.el7)

If you wish to only update the RPMs that changed, the set of RPMs is:

    osg-version python2-xrootd xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs xrootd-voms

#### Enterprise Linux 6

``` file
osg-version-3.4.53-1.osg34.el6
python2-xrootd-4.12.3-1.osg34.el6
xrootd-4.12.3-1.osg34.el6
xrootd-client-4.12.3-1.osg34.el6
xrootd-client-devel-4.12.3-1.osg34.el6
xrootd-client-libs-4.12.3-1.osg34.el6
xrootd-debuginfo-4.12.3-1.osg34.el6
xrootd-devel-4.12.3-1.osg34.el6
xrootd-doc-4.12.3-1.osg34.el6
xrootd-fuse-4.12.3-1.osg34.el6
xrootd-lcmaps-1.7.7-2.osg34.el6
xrootd-lcmaps-debuginfo-1.7.7-2.osg34.el6
xrootd-libs-4.12.3-1.osg34.el6
xrootd-private-devel-4.12.3-1.osg34.el6
xrootd-selinux-4.12.3-1.osg34.el6
xrootd-server-4.12.3-1.osg34.el6
xrootd-server-devel-4.12.3-1.osg34.el6
xrootd-server-libs-4.12.3-1.osg34.el6
xrootd-voms-4.12.3-1.osg34.el6
```

#### Enterprise Linux 7

``` file
osg-version-3.4.53-1.osg34.el7
python2-xrootd-4.12.3-1.osg34.el7
xrootd-4.12.3-1.osg34.el7
xrootd-client-4.12.3-1.osg34.el7
xrootd-client-devel-4.12.3-1.osg34.el7
xrootd-client-libs-4.12.3-1.osg34.el7
xrootd-debuginfo-4.12.3-1.osg34.el7
xrootd-devel-4.12.3-1.osg34.el7
xrootd-doc-4.12.3-1.osg34.el7
xrootd-fuse-4.12.3-1.osg34.el7
xrootd-hdfs-2.1.7-6.osg34.el7
xrootd-hdfs-debuginfo-2.1.7-6.osg34.el7
xrootd-hdfs-devel-2.1.7-6.osg34.el7
xrootd-lcmaps-1.7.7-2.osg34.el7
xrootd-lcmaps-debuginfo-1.7.7-2.osg34.el7
xrootd-libs-4.12.3-1.osg34.el7
xrootd-multiuser-0.4.2-9.osg34.el7
xrootd-multiuser-debuginfo-0.4.2-9.osg34.el7
xrootd-private-devel-4.12.3-1.osg34.el7
xrootd-scitokens-1.2.0-5.osg34.el7
xrootd-scitokens-debuginfo-1.2.0-5.osg34.el7
xrootd-selinux-4.12.3-1.osg34.el7
xrootd-server-4.12.3-1.osg34.el7
xrootd-server-devel-4.12.3-1.osg34.el7
xrootd-server-libs-4.12.3-1.osg34.el7
xrootd-voms-4.12.3-1.osg34.el7
```
