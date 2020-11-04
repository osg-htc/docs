OSG Software Release 3.4.40
===========================

**Release Date**: 2019-11-26    
**Supported OS Versions:** EL7, EL6

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 and 3.4 offer a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Summary of changes
------------------

This release contains:

-   XCache 1.2:
    -   Added support for multi-node caches
    -   Fixed problem with StashCache working with authenticated origins
-   [CCTools 7.0.21](https://groups.google.com/forum/#!topic/cctools-nd/BTaG_o_qeSg): Minor bug fix release
-   osg-release 3.4-9: Updated development server host name to `koji.opensciencegrid.org`

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.40%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](/index.md).

-   OSG 3.4 contains only 64-bit components.
-   The StashCache service is only supported on EL7

### GlideinWMS ###

1. GlideinWMS 3.4.6 is the last release supporting Globus GRAM (a.k.a. GT2/GT5).

1. For new Singularity features introduced in GlideinWMS 3.4.1, all factories and frontends need to be >= 3.4.1.

    !!! note
        OSG GlideinWMS factories are running at least 3.4.1

    If some of the connected Factories are <= 3.4.1 you will see an error during reconfig/upgrade if you try to use
    features that require a newer Factory.
    To start using Singularity via GlideinWMS, see:

    - <https://glideinwms.fnal.gov/doc.prd/frontend/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/custom_vars.html#singularity_vars>

1. Upgrades from <= 3.4.0 may require merging `/etc/condor/config.d/*.rpmnew` files and restarting HTCondor.

1. GlideinWMS >= 3.4.5 uses shared port, requiring only port 9618.
   To ease the transition to shared port, the User Collector, secondary collectors, and CCBs support both shared and
   separate, individual ports.
   To start using shared port, change the secondary collectors lines and the CCBs lines (if any) in
   `/etc/gwms-frontend/frontend.xml`, changing the address to include the shared port sinful string:

        <collector DN="/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=gwms-frontend.domain" group="default" node="gwms-frontend.domain:9618?sock=collector0-40" secondary="True"/>

    Replace `gwms-frontend-domain` above with the hostname of your GlideinWMS frontend.
    See the [GlideinWMS documentation](https://glideinwms.fnal.gov/doc.prd/components/condor.html#collectors ) for details.

Known Issues
------------

OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).

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

-   [cctools-7.0.21-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.21-1.osg34.el6)
-   [osg-release-3.4-9.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-9.osg34.el6)
-   [osg-version-3.4.40-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.40-1.osg34.el6)

#### Enterprise Linux 7

-   [cctools-7.0.21-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.21-1.osg34.el7)
-   [osg-release-3.4-9.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-9.osg34.el7)
-   [osg-version-3.4.40-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.40-1.osg34.el7)
-   [xcache-1.2.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-1.2.0-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    atlas-xcache cctools cctools-debuginfo cctools-devel cms-xcache osg-release osg-version stash-cache stash-origin xcache xcache-redirector

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
cctools-7.0.21-1.osg34.el6
cctools-debuginfo-7.0.21-1.osg34.el6
cctools-devel-7.0.21-1.osg34.el6
osg-release-3.4-9.osg34.el6
osg-version-3.4.40-1.osg34.el6
```

#### Enterprise Linux 7

``` file
atlas-xcache-1.2.0-1.osg34.el7
cctools-7.0.21-1.osg34.el7
cctools-debuginfo-7.0.21-1.osg34.el7
cctools-devel-7.0.21-1.osg34.el7
cms-xcache-1.2.0-1.osg34.el7
osg-release-3.4-9.osg34.el7
osg-version-3.4.40-1.osg34.el7
stash-cache-1.2.0-1.osg34.el7
stash-origin-1.2.0-1.osg34.el7
xcache-1.2.0-1.osg34.el7
xcache-redirector-1.2.0-1.osg34.el7
```
