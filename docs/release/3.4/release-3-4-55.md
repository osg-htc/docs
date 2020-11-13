OSG Software Release 3.4.55
===========================

**Release Date**: 2020-10-08    
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

-   [GlideinWMS 3.6.5](https://glideinwms.fnal.gov/doc.v3_6_5/history.html) Upgrade from 3.6.2
    -   Improved Singularity support
    -   HTCondor's Python based condor\_chip in the PATH
    -   Support for EL8 worker nodes
-   [Singularity 3.6.3](https://github.com/sylabs/singularity/releases/tag/v3.6.3): Security release, Upgrade from 3.5.2

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.55%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

-   [osg-version-3.4.55-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.55-1.osg34.el6)
-   [singularity-3.6.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.6.3-1.osg34.el6)

#### Enterprise Linux 7

-   [glideinwms-3.6.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6.5-1.osg34.el7)
-   [osg-version-3.4.55-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.55-1.osg34.el7)
-   [singularity-3.6.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.6.3-1.osg34.el7)

If you wish to only update the RPMs that changed, the set of RPMs is:

    glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone osg-version singularity singularity-debuginfo

#### Enterprise Linux 6

``` file
osg-version-3.4.55-1.osg34.el6
singularity-3.6.3-1.osg34.el6
singularity-debuginfo-3.6.3-1.osg34.el6
```

#### Enterprise Linux 7

``` file
glideinwms-3.6.5-1.osg34.el7
glideinwms-common-tools-3.6.5-1.osg34.el7
glideinwms-condor-common-config-3.6.5-1.osg34.el7
glideinwms-factory-3.6.5-1.osg34.el7
glideinwms-factory-condor-3.6.5-1.osg34.el7
glideinwms-glidecondor-tools-3.6.5-1.osg34.el7
glideinwms-libs-3.6.5-1.osg34.el7
glideinwms-minimal-condor-3.6.5-1.osg34.el7
glideinwms-usercollector-3.6.5-1.osg34.el7
glideinwms-userschedd-3.6.5-1.osg34.el7
glideinwms-vofrontend-3.6.5-1.osg34.el7
glideinwms-vofrontend-standalone-3.6.5-1.osg34.el7
osg-version-3.4.55-1.osg34.el7
singularity-3.6.3-1.osg34.el7
singularity-debuginfo-3.6.3-1.osg34.el7
```
