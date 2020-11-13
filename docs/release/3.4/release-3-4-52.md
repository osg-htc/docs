OSG Software Release 3.4.52
===========================

**Release Date**: 2020-06-11    
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

-   [Frontier Squid 4.11-3.1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): Fixed critical bug that causes server errors to be cached indefinitely which may require caches to be cleared. The bug was introduced in version 4.10-3.1
-   VOMS 2.0.14-1.6: Allow VOMS libraries to accept certificates with VOMS attributes that only have a top-level component, such as those provided by the WLCG VO

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.52%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

-   OSG 3.4 contains only 64-bit components.
-   The StashCache service is only supported on EL7

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

-   [frontier-squid-4.11-3.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.11-3.1.osg34.el6)
-   [osg-version-3.4.52-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.52-1.osg34.el6)
-   [voms-2.0.14-1.6.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.6.osg34.el6)

#### Enterprise Linux 7

-   [frontier-squid-4.11-3.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.11-3.1.osg34.el7)
-   [osg-version-3.4.52-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.52-1.osg34.el7)
-   [voms-2.0.14-1.6.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.6.osg34.el7)

If you wish to only update the RPMs that changed, the set of RPMs is:

    frontier-squid frontier-squid-debuginfo osg-version voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server

#### Enterprise Linux 6

``` file
frontier-squid-4.11-3.1.osg34.el6
frontier-squid-debuginfo-4.11-3.1.osg34.el6
osg-version-3.4.52-1.osg34.el6
voms-2.0.14-1.6.osg34.el6
voms-clients-cpp-2.0.14-1.6.osg34.el6
voms-debuginfo-2.0.14-1.6.osg34.el6
voms-devel-2.0.14-1.6.osg34.el6
voms-doc-2.0.14-1.6.osg34.el6
voms-server-2.0.14-1.6.osg34.el6
```

#### Enterprise Linux 7

``` file
frontier-squid-4.11-3.1.osg34.el7
frontier-squid-debuginfo-4.11-3.1.osg34.el7
osg-version-3.4.52-1.osg34.el7
voms-2.0.14-1.6.osg34.el7
voms-clients-cpp-2.0.14-1.6.osg34.el7
voms-debuginfo-2.0.14-1.6.osg34.el7
voms-devel-2.0.14-1.6.osg34.el7
voms-doc-2.0.14-1.6.osg34.el7
voms-server-2.0.14-1.6.osg34.el7
```
