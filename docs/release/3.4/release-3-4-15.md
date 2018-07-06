OSG Software Release 3.4.15
===========================

**Release Date**: 2018-07-06

Summary of changes
------------------

This release contains:

-   [Singularity 2.5.2](https://github.com/singularityware/singularity/releases/tag/2.5.2)
    -   This release contains fixes for a *high severity* security issue affecting Singularity 2.3.0 through 2.5.1 on
        kernels that support overlay file systems (CVE-2018-12021). A malicious user with network access to the host
        system (e.g. ssh) could exploit this vulnerability to access sensitive information on disk and bypass directory
        image restrictions like those preventing the root file system from being mounted into the container.
    -   Singularity 2.5.2 should be installed immediately, and all previous versions of Singularity should be removed.
        The vulnerability addressed in this release affects kernels that support overlayfs. If you are unable to upgrade
        immediately, you should set `enable overlay = no` in `singularity.conf`.

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.15%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-from-osg-31-32-33-to-33-or-34).

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

-   [osg-version-3.4.15-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.15-1.osg34.el6)
-   [singularity-2.5.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.5.2-1.osg34.el6)

#### Enterprise Linux 7

-   [osg-version-3.4.15-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.15-1.osg34.el7)
-   [singularity-2.5.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.5.2-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-version singularity singularity-debuginfo singularity-devel singularity-runtime

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
osg-version-3.4.15-1.osg34.el6
singularity-2.5.2-1.osg34.el6
singularity-debuginfo-2.5.2-1.osg34.el6
singularity-devel-2.5.2-1.osg34.el6
singularity-runtime-2.5.2-1.osg34.el6
```

#### Enterprise Linux 7

``` file
osg-version-3.4.15-1.osg34.el7
singularity-2.5.2-1.osg34.el7
singularity-debuginfo-2.5.2-1.osg34.el7
singularity-devel-2.5.2-1.osg34.el7
singularity-runtime-2.5.2-1.osg34.el7
```
