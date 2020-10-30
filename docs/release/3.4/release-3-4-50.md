OSG Software Release 3.4.50
===========================

**Release Date**: 2020-05-14    
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

-   [XRootD 4.11.3](https://github.com/xrootd/xrootd/blob/v4.11.3/docs/ReleaseNotes.txt): Bug fix release
-   [VO Package v105](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-105): Added EIC VO

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.50%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

-   [osg-version-3.4.50-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.50-1.osg34.el6)
-   [vo-client-105-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-105-1.osg34.el6)
-   [xrootd-4.11.3-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.3-1.2.osg34.el6)

#### Enterprise Linux 7

-   [osg-version-3.4.50-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.50-1.osg34.el7)
-   [vo-client-105-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-105-1.osg34.el7)
-   [xrootd-4.11.3-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.3-1.2.osg34.el7)

If you wish to only update the RPMs that changed, the set of RPMs is:

    osg-version vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-python xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs xrootd-voms-plugin xrootd-voms-plugin-debuginfo xrootd-voms-plugin-devel

#### Enterprise Linux 6

``` file
osg-version-3.4.50-1.osg34.el6
python2-xrootd-4.11.3-1.2.osg34.el6
vo-client-105-1.osg34.el6
vo-client-dcache-105-1.osg34.el6
vo-client-lcmaps-voms-105-1.osg34.el6
xrootd-4.11.3-1.2.osg34.el6
xrootd-client-4.11.3-1.2.osg34.el6
xrootd-client-devel-4.11.3-1.2.osg34.el6
xrootd-client-libs-4.11.3-1.2.osg34.el6
xrootd-debuginfo-4.11.3-1.2.osg34.el6
xrootd-devel-4.11.3-1.2.osg34.el6
xrootd-doc-4.11.3-1.2.osg34.el6
xrootd-fuse-4.11.3-1.2.osg34.el6
xrootd-libs-4.11.3-1.2.osg34.el6
xrootd-private-devel-4.11.3-1.2.osg34.el6
xrootd-selinux-4.11.3-1.2.osg34.el6
xrootd-server-4.11.3-1.2.osg34.el6
xrootd-server-devel-4.11.3-1.2.osg34.el6
xrootd-server-libs-4.11.3-1.2.osg34.el6
```

#### Enterprise Linux 7

``` file
osg-version-3.4.50-1.osg34.el7
python2-xrootd-4.11.3-1.2.osg34.el7
vo-client-105-1.osg34.el7
vo-client-dcache-105-1.osg34.el7
vo-client-lcmaps-voms-105-1.osg34.el7
xrootd-4.11.3-1.2.osg34.el7
xrootd-client-4.11.3-1.2.osg34.el7
xrootd-client-devel-4.11.3-1.2.osg34.el7
xrootd-client-libs-4.11.3-1.2.osg34.el7
xrootd-debuginfo-4.11.3-1.2.osg34.el7
xrootd-devel-4.11.3-1.2.osg34.el7
xrootd-doc-4.11.3-1.2.osg34.el7
xrootd-fuse-4.11.3-1.2.osg34.el7
xrootd-libs-4.11.3-1.2.osg34.el7
xrootd-private-devel-4.11.3-1.2.osg34.el7
xrootd-selinux-4.11.3-1.2.osg34.el7
xrootd-server-4.11.3-1.2.osg34.el7
xrootd-server-devel-4.11.3-1.2.osg34.el7
xrootd-server-libs-4.11.3-1.2.osg34.el7
```
