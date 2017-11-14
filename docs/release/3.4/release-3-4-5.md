OSG Software Release 3.4.5
==========================

**Release Date**: 2017-11-14

Summary of changes
------------------

This release contains:


These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.5%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note
    OSG 3.4 contains only 64-bit components.

!!! note
    StashCache is supported on EL7 only.

!!! note
    xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found [here](../../).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details`. This warning can safely be ignored.
-   In GlideinWMS, a small configuration change must be added to account for changes in HTCondor 8.6. Add the following line to the HTCondor configuration.

        COLLECTOR.USE_SHARED_PORT=False

Updating to the new release
---------------------------

To update to the OSG 3.4 series, please consult the page on [updating between release series](../release_series).

### Update Repositories

To update to this series, you need [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note
Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

!!! note
Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6


#### Enterprise Linux 7


### RPMs

If you wish to manually update your system, you can run yum update against the following packages:


If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
```

#### Enterprise Linux 7

``` file
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6


#### Enterprise Linux 7


### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:


If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
```

#### Enterprise Linux 7

``` file
```

