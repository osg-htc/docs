OSG Software Release 3.4.36
===========================

**Release Date**: 2019-10-10
**Supported OS Versions:** EL7, EL6

Summary of changes
------------------

This release contains:

-   [CVMFS 2.6.3](https://cvmfs.readthedocs.io/en/2.6/cpt-releasenotes.html): Bug fix release
-   [Frontier-Squid 4.8-2](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): Add support for shoal-agent
-   [CCTools 7.0.18](http://ccl.cse.nd.edu/software/): Bug fix release
-   [Singularity 3.4.1](https://github.com/sylabs/singularity/releases/tag/v3.4.1): Bug fix release
-   LCMAPS 1.6.6-1.9: Rebuilt to ease transition from OSG 3.3
-   [VO Package v96](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-96): Add LHCb VO

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.36%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

-   OSG 3.4 contains only 64-bit components.
-   StashCache is only supported on EL7

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

OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).

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

-   [cctools-7.0.18-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.18-1.osg34.el6)
-   [cvmfs-2.6.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.6.3-1.osg34.el6)
-   [cvmfs-config-osg-2.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.4-1.osg34.el6)
-   [cvmfs-x509-helper-2.1-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-2.1-2.osg34.el6)
-   [frontier-squid-4.8-2.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.8-2.1.osg34.el6)
-   [lcmaps-1.6.6-1.9.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.9.osg34.el6)
-   [osg-oasis-15-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-15-4.osg34.el6)
-   [osg-version-3.4.36-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.36-1.osg34.el6)
-   [singularity-3.4.1-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.4.1-1.2.osg34.el6)
-   [vo-client-96-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-96-1.osg34.el6)

#### Enterprise Linux 7

-   [cctools-7.0.18-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.18-1.osg34.el7)
-   [cvmfs-2.6.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.6.3-1.osg34.el7)
-   [cvmfs-config-osg-2.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.4-1.osg34.el7)
-   [cvmfs-x509-helper-2.1-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-2.1-2.osg34.el7)
-   [frontier-squid-4.8-2.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.8-2.1.osg34.el7)
-   [hosted-ce-tools-0.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.4-1.osg34.el7)
-   [lcmaps-1.6.6-1.9.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.9.osg34.el7)
-   [osg-oasis-15-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-15-4.osg34.el7)
-   [osg-version-3.4.36-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.36-1.osg34.el7)
-   [singularity-3.4.1-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.4.1-1.2.osg34.el7)
-   [vo-client-96-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-96-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cctools cctools-debuginfo cctools-devel cvmfs cvmfs-config-osg cvmfs-devel cvmfs-ducc cvmfs-server cvmfs-shrinkwrap cvmfs-unittests cvmfs-x509-helper cvmfs-x509-helper-debuginfo frontier-squid frontier-squid-debuginfo hosted-ce-tools lcmaps lcmaps-common-devel lcmaps-db-templates lcmaps-debuginfo lcmaps-devel lcmaps-without-gsi lcmaps-without-gsi-devel osg-oasis osg-version singularity singularity-debuginfo vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
cctools-7.0.18-1.osg34.el6
cctools-debuginfo-7.0.18-1.osg34.el6
cctools-devel-7.0.18-1.osg34.el6
cvmfs-2.6.3-1.osg34.el6
cvmfs-config-osg-2.4-1.osg34.el6
cvmfs-devel-2.6.3-1.osg34.el6
cvmfs-server-2.6.3-1.osg34.el6
cvmfs-shrinkwrap-2.6.3-1.osg34.el6
cvmfs-unittests-2.6.3-1.osg34.el6
cvmfs-x509-helper-2.1-2.osg34.el6
cvmfs-x509-helper-debuginfo-2.1-2.osg34.el6
frontier-squid-4.8-2.1.osg34.el6
frontier-squid-debuginfo-4.8-2.1.osg34.el6
lcmaps-1.6.6-1.9.osg34.el6
lcmaps-common-devel-1.6.6-1.9.osg34.el6
lcmaps-db-templates-1.6.6-1.9.osg34.el6
lcmaps-debuginfo-1.6.6-1.9.osg34.el6
lcmaps-devel-1.6.6-1.9.osg34.el6
lcmaps-without-gsi-1.6.6-1.9.osg34.el6
lcmaps-without-gsi-devel-1.6.6-1.9.osg34.el6
osg-oasis-15-4.osg34.el6
osg-version-3.4.36-1.osg34.el6
singularity-3.4.1-1.2.osg34.el6
singularity-debuginfo-3.4.1-1.2.osg34.el6
vo-client-96-1.osg34.el6
vo-client-dcache-96-1.osg34.el6
vo-client-lcmaps-voms-96-1.osg34.el6
```

#### Enterprise Linux 7

``` file
cctools-7.0.18-1.osg34.el7
cctools-debuginfo-7.0.18-1.osg34.el7
cctools-devel-7.0.18-1.osg34.el7
cvmfs-2.6.3-1.osg34.el7
cvmfs-config-osg-2.4-1.osg34.el7
cvmfs-devel-2.6.3-1.osg34.el7
cvmfs-ducc-2.6.3-1.osg34.el7
cvmfs-server-2.6.3-1.osg34.el7
cvmfs-shrinkwrap-2.6.3-1.osg34.el7
cvmfs-unittests-2.6.3-1.osg34.el7
cvmfs-x509-helper-2.1-2.osg34.el7
cvmfs-x509-helper-debuginfo-2.1-2.osg34.el7
frontier-squid-4.8-2.1.osg34.el7
frontier-squid-debuginfo-4.8-2.1.osg34.el7
hosted-ce-tools-0.4-1.osg34.el7
lcmaps-1.6.6-1.9.osg34.el7
lcmaps-common-devel-1.6.6-1.9.osg34.el7
lcmaps-db-templates-1.6.6-1.9.osg34.el7
lcmaps-debuginfo-1.6.6-1.9.osg34.el7
lcmaps-devel-1.6.6-1.9.osg34.el7
lcmaps-without-gsi-1.6.6-1.9.osg34.el7
lcmaps-without-gsi-devel-1.6.6-1.9.osg34.el7
osg-oasis-15-4.osg34.el7
osg-version-3.4.36-1.osg34.el7
singularity-3.4.1-1.2.osg34.el7
singularity-debuginfo-3.4.1-1.2.osg34.el7
vo-client-96-1.osg34.el7
vo-client-dcache-96-1.osg34.el7
vo-client-lcmaps-voms-96-1.osg34.el7
```
