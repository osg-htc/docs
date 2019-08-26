OSG Software Release 3.4.29
===========================

**Release Date**: 2019-05-02

Summary of changes
------------------

This release contains:

-   XCache 1.0.5 is a complete overhaul of the packaging and configuration
    for the StashCache cache and origin services, based on improvements
    available in XRootD 4.9.1.  XCache is also the basis of upcoming work
    for connecting caches to the CMS and ATLAS data federations.

    The configuration has been rewritten to use `config.d`-style directories
    instead of single config files, and supporting services have been added
    to do the following:

    -   update authorization for both caches and origins based on data in the
        OSG Topology service
    -   automatically renew cache proxies

    This [overview document](https://opensciencegrid.org/docs/data/stashcache/overview/)
    contains links to instructions for setting up new
    caches and origins, and instructions for VOs on how to get their data
    into the StashCache Federation.

    !!! note
        -   XCache is only available for EL7, and EL7 is now a requirement for
            a cache or origin to join the StashCache Data Federation.

        -   Because of the extensive changes to the configuration, sites upgrading
            their caches or origins to this version should consider the upgrade to
            be the same amount of work as a reinstall of the service.

-   Update MyProxy to use the Grid Community Toolkit (GCT)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.29%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](/index.md).

-   OSG 3.4 contains only 64-bit components.
-   StashCache is only supported on EL7

### GlideinWMS ###

1. GlideinWMS 3.4.5 is the last release supporting Globus GRAM (a.k.a. GT2/GT5).

1. For new Singularity features introduced in GlideinWMS 3.4.1, all factories and frontends need to be >= 3.4.1.

    !!! note
        OSG GlideinWMS factories are running at least 3.4.1

    If some of the connected Factories are <= 3.4.1 you will see an error during reconfig/upgrade if you try to use
    features that require a newer Factory.
    To start using Singularity via GlideinWMS, see:

    - <https://glideinwms.fnal.gov/doc.prd/frontend/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/custom_vars.html#singularity_vars>

1. Upgrades from <= 3.4.0 may require merging `/etc/condor/config.d/*.rpmnew` files and a restart of HTCondor.

1. GlideinWMS >= 3.4.5 uses shared port, requiring only port 9618.
   To ease the transition to shared port, the User Collector secondary collectors and CCBs support both shared and
   separate, individual ports.
   To start using shared port, change the secondary collectors lines and the CCBs lines (if any) in
   `/etc/gwms-frontend/frontend.xml`, changing the address to include the shared port sinful string:

        <collector DN="/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=gwms-frontend.domain" group="default" node="gwms-frontend.domain:9618?sock=collector0-40" secondary="True"/>

   Replacing `gwms-frontend-domain` with the hostname of your GlideinWMS frontend.
   See the [GlideinWMS documentation](https://glideinwms.fnal.gov/doc.prd/components/condor.html#collectors ) for details. 

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

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-to-osg-35).

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

-   [myproxy-6.2.3-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.2.3-1.1.osg34.el6)
-   [osg-version-3.4.29-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.29-1.osg34.el6)

#### Enterprise Linux 7

-   [myproxy-6.2.3-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.2.3-1.1.osg34.el7)
-   [osg-version-3.4.29-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.29-1.osg34.el7)
-   [xcache-1.0.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-1.0.5-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-version stash-cache stash-origin xcache

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
myproxy-6.2.3-1.1.osg34.el6
myproxy-admin-6.2.3-1.1.osg34.el6
myproxy-debuginfo-6.2.3-1.1.osg34.el6
myproxy-devel-6.2.3-1.1.osg34.el6
myproxy-doc-6.2.3-1.1.osg34.el6
myproxy-libs-6.2.3-1.1.osg34.el6
myproxy-server-6.2.3-1.1.osg34.el6
myproxy-voms-6.2.3-1.1.osg34.el6
osg-version-3.4.29-1.osg34.el6
```

#### Enterprise Linux 7

``` file
myproxy-6.2.3-1.1.osg34.el7
myproxy-admin-6.2.3-1.1.osg34.el7
myproxy-debuginfo-6.2.3-1.1.osg34.el7
myproxy-devel-6.2.3-1.1.osg34.el7
myproxy-doc-6.2.3-1.1.osg34.el7
myproxy-libs-6.2.3-1.1.osg34.el7
myproxy-server-6.2.3-1.1.osg34.el7
myproxy-voms-6.2.3-1.1.osg34.el7
osg-version-3.4.29-1.osg34.el7
stash-cache-1.0.5-1.osg34.el7
stash-origin-1.0.5-1.osg34.el7
xcache-1.0.5-1.osg34.el7
```
