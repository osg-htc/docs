OSG Software Release 3.4.11
===========================

**Release Date**: 2018-05-01

Summary of changes
------------------

This release contains:

-   [Singularity 2.5.0](https://github.com/singularityware/singularity/releases/tag/2.5.0)
    - This release includes fixes for several high and medium severity security issues.
      It also contains a number of bug fixes including the much awaited docker aufs whiteout file fix.
      It's a new release instead of a point release because it adds a new dependency to handle this bug,
      includes some new (albeit minor) feature enhancements, and changes the behavior of a few environment variables.
    - Singularity 2.5 should be installed immediately and all previous versions of Singularity should be removed.
      Many of the vulnerabilities fixed in this release are expected to affect all Linux distributions
      regardless of whether they implement overlayfs.
      There are no mitigations or workarounds for these issues outside of updating Singularity.

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.11%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore (`_`). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](../../index.md).

Known Issues
------------

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-the-osg-repositories).

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

-   [osg-version-3.4.11-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.11-1.osg34.el6)
-   [singularity-2.5.0-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.5.0-1.1.osg34.el6)

#### Enterprise Linux 7

-   [osg-version-3.4.11-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.11-1.osg34.el7)
-   [singularity-2.5.0-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.5.0-1.1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-version singularity singularity-debuginfo singularity-devel singularity-runtime

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
osg-version-3.4.11-1.osg34.el6
singularity-2.5.0-1.1.osg34.el6
singularity-debuginfo-2.5.0-1.1.osg34.el6
singularity-devel-2.5.0-1.1.osg34.el6
singularity-runtime-2.5.0-1.1.osg34.el6
```

#### Enterprise Linux 7

``` file
osg-version-3.4.11-1.osg34.el7
singularity-2.5.0-1.1.osg34.el7
singularity-debuginfo-2.5.0-1.1.osg34.el7
singularity-devel-2.5.0-1.1.osg34.el7
singularity-runtime-2.5.0-1.1.osg34.el7
```
