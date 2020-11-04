OSG Software Release 3.4.26
===========================

**Release Date**: 2019-03-07

Summary of changes
------------------

This release contains:

-   [Cooperative Computing Tools](https://ccl.cse.nd.edu/software/) 7.0.9: Upgrade from version 4.4.3
-   [Pegasus 4.9.1](https://pegasus.isi.edu/2019/03/06/pegasus-4-9-1-released/)
    -   Bug fix release
    -   When using containers, transfers happen within the container
-   [osg-pki-tools 3.1.0](https://github.com/opensciencegrid/osg-pki-tools/releases/tag/v3.1.0):
    Added `osg-incommon-cert-request` for use by administrators with an InCommon account that can create certificates.
-   Upcoming Repository
    -   [Singularity 3.1.0](https://github.com/sylabs/singularity/releases/tag/v3.1.0): Feature Release, new OCI compliant variant of Singularity runtime

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.26%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is only supported on EL7

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

-   [cctools-7.0.9-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.9-2.osg34.el6)
-   [osg-pki-tools-3.1.0-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.1.0-1.1.osg34.el6)
-   [osg-version-3.4.26-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.26-1.osg34.el6)
-   [pegasus-4.9.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.9.1-1.osg34.el6)

#### Enterprise Linux 7

-   [cctools-7.0.9-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.9-2.osg34.el7)
-   [osg-pki-tools-3.1.0-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.1.0-1.1.osg34.el7)
-   [osg-version-3.4.26-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.26-1.osg34.el7)
-   [pegasus-4.9.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.9.1-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cctools cctools-debuginfo cctools-devel osg-pki-tools osg-version pegasus pegasus-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
cctools-7.0.9-2.osg34.el6
cctools-debuginfo-7.0.9-2.osg34.el6
cctools-devel-7.0.9-2.osg34.el6
osg-pki-tools-3.1.0-1.1.osg34.el6
osg-version-3.4.26-1.osg34.el6
pegasus-4.9.1-1.osg34.el6
pegasus-debuginfo-4.9.1-1.osg34.el6
```

#### Enterprise Linux 7

``` file
cctools-7.0.9-2.osg34.el7
cctools-debuginfo-7.0.9-2.osg34.el7
cctools-devel-7.0.9-2.osg34.el7
osg-pki-tools-3.1.0-1.1.osg34.el7
osg-version-3.4.26-1.osg34.el7
pegasus-4.9.1-1.osg34.el7
pegasus-debuginfo-4.9.1-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [singularity-3.1.0-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.1.0-1.osgup.el6)

#### Enterprise Linux 7

-   [singularity-3.1.0-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.1.0-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    singularity singularity-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
singularity-3.1.0-1.osgup.el6
singularity-debuginfo-3.1.0-1.osgup.el6
```

#### Enterprise Linux 7

``` file
singularity-3.1.0-1.osgup.el7
singularity-debuginfo-3.1.0-1.osgup.el7
```
