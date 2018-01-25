OSG Software Stack -- Data Release -- 3.3.24-2
==============================================

**Release Date**: 2017-05-16

Summary of changes
------------------

This release contains:

-   [VO Package v73](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-73)
    -   Update edg-mkgridmap CDF entry to match vomses
    -   Remove LIGO server from GUMS template
    -   Remove unused CDF glidecaf settings
    -   Drop /production role for DES vomsUserGroup
    -   Update default CMS mappings
    -   Update default Fermilab / FIFE mappings

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.24-2%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note
    Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

!!! note
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [vo-client-73-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-73-1.osg33.el6)

#### Enterprise Linux 7

-   [vo-client-73-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-73-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-gums-config vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
osg-gums-config-73-1.osg33.el6
vo-client-73-1.osg33.el6
vo-client-edgmkgridmap-73-1.osg33.el6
vo-client-lcmaps-voms-73-1.osg33.el6
```

#### Enterprise Linux 7

``` file
osg-gums-config-73-1.osg33.el7
vo-client-73-1.osg33.el7
vo-client-edgmkgridmap-73-1.osg33.el7
vo-client-lcmaps-voms-73-1.osg33.el7
```

