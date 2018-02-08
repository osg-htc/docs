OSG Software Release 3.4.8
==========================

**Release Date**: 2018-02-08

Summary of changes
------------------

This release contains:

-   Critical GlideinWMS bug fix for heavily loaded frontends (<https://cdcvs.fnal.gov/redmine/issues/18748>)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.8%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore (`_`). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](/index.md).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details`. This warning can safely be ignored.

Updating to the new release
---------------------------

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-from-osg-31-32-33-to-33-or-34).

### Update Repositories

To update to this series, you need [install the current OSG repositories](/common/yum#install-osg-repositories).

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

-   [glideinwms-3.2.20-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.20-2.osg34.el6)
-   [osg-version-3.4.8-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.8-1.osg34.el6)

#### Enterprise Linux 7

-   [glideinwms-3.2.20-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.20-2.osg34.el7)
-   [osg-version-3.4.8-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.8-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone osg-version

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
glideinwms-3.2.20-2.osg34.el6
glideinwms-common-tools-3.2.20-2.osg34.el6
glideinwms-condor-common-config-3.2.20-2.osg34.el6
glideinwms-factory-3.2.20-2.osg34.el6
glideinwms-factory-condor-3.2.20-2.osg34.el6
glideinwms-glidecondor-tools-3.2.20-2.osg34.el6
glideinwms-libs-3.2.20-2.osg34.el6
glideinwms-minimal-condor-3.2.20-2.osg34.el6
glideinwms-usercollector-3.2.20-2.osg34.el6
glideinwms-userschedd-3.2.20-2.osg34.el6
glideinwms-vofrontend-3.2.20-2.osg34.el6
glideinwms-vofrontend-standalone-3.2.20-2.osg34.el6
osg-version-3.4.8-1.osg34.el6
```

#### Enterprise Linux 7

``` file
glideinwms-3.2.20-2.osg34.el7
glideinwms-common-tools-3.2.20-2.osg34.el7
glideinwms-condor-common-config-3.2.20-2.osg34.el7
glideinwms-factory-3.2.20-2.osg34.el7
glideinwms-factory-condor-3.2.20-2.osg34.el7
glideinwms-glidecondor-tools-3.2.20-2.osg34.el7
glideinwms-libs-3.2.20-2.osg34.el7
glideinwms-minimal-condor-3.2.20-2.osg34.el7
glideinwms-usercollector-3.2.20-2.osg34.el7
glideinwms-userschedd-3.2.20-2.osg34.el7
glideinwms-vofrontend-3.2.20-2.osg34.el7
glideinwms-vofrontend-standalone-3.2.20-2.osg34.el7
osg-version-3.4.8-1.osg34.el7
```
