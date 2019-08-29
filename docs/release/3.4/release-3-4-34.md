OSG Software Release 3.4.34
===========================

**Release Date**: 2019-08-29    
**Supported OS Versions:** EL7, EL6

Summary of changes
------------------

This release contains:

-   XCache 1.1.1: ATLAS and CMS XCache; Stash Origin HTTP/S Support
-   osg-configure 2.4: improvements for Slurm, PBS Pro, BOSCO, Frontier Squid
-   OSG XRootD 3.5: A meta-package including common configuration across [standalone](/data/xrootd/install-standalone),
    [storage element](/data/xrootd/install-storage-element), and [caching](/data/stashcache/overview) installations of
    XRootD.
-   XRootD HDFS 2.1.6: includes default configuration in `/etc/xrootd/40-xrootd-hdfs.cfg`.
-   XRootD LCMAPS 1.7.4: includes default authorization configuration in `/etc/xrootd/config.d/40-xrootd-lcmaps.cfg`.
    To use the default configuration, uncomment the `# set EnableLcmaps = 1` line in `/etc/xrootd/config.d/10-xrootd-lcmaps.cfg`.
-   MyProxy 6.2.4: Remove usage statistics collection support
-   [CCTools 7.0.14](http://ccl.cse.nd.edu/software/): Bug fix release
-   osg-system-profiler 1.4.3: Remove collection of obsolete information

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.34%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

None.

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

-   [cctools-7.0.14-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.14-1.osg34.el6)
-   [myproxy-6.2.4-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.2.4-1.1.osg34.el6)
-   [osg-configure-2.4.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.4.1-1.osg34.el6)
-   [osg-system-profiler-1.4.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.3-1.osg34.el6)
-   [osg-version-3.4.34-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.34-1.osg34.el6)
-   [osg-xrootd-3.4-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.4-4.osg34.el6)
-   [xrootd-lcmaps-1.7.4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.4-2.osg34.el6)

#### Enterprise Linux 7

-   [cctools-7.0.14-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.14-1.osg34.el7)
-   [myproxy-6.2.4-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.2.4-1.1.osg34.el7)
-   [osg-configure-2.4.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.4.1-1.osg34.el7)
-   [osg-system-profiler-1.4.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.3-1.osg34.el7)
-   [osg-version-3.4.34-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.34-1.osg34.el7)
-   [osg-xrootd-3.4-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.4-4.osg34.el7)
-   [xcache-1.1.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-1.1.1-1.osg34.el7)
-   [xrootd-hdfs-2.1.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.6-1.osg34.el7)
-   [xrootd-lcmaps-1.7.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.4-2.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    atlas-xcache cctools cctools-debuginfo cctools-devel cms-xcache myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-system-profiler osg-system-profiler-viewer osg-version osg-xrootd osg-xrootd-standalone stash-cache stash-origin xcache xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
cctools-7.0.14-1.osg34.el6
cctools-debuginfo-7.0.14-1.osg34.el6
cctools-devel-7.0.14-1.osg34.el6
myproxy-6.2.4-1.1.osg34.el6
myproxy-admin-6.2.4-1.1.osg34.el6
myproxy-debuginfo-6.2.4-1.1.osg34.el6
myproxy-devel-6.2.4-1.1.osg34.el6
myproxy-doc-6.2.4-1.1.osg34.el6
myproxy-libs-6.2.4-1.1.osg34.el6
myproxy-server-6.2.4-1.1.osg34.el6
myproxy-voms-6.2.4-1.1.osg34.el6
osg-configure-2.4.1-1.osg34.el6
osg-configure-bosco-2.4.1-1.osg34.el6
osg-configure-ce-2.4.1-1.osg34.el6
osg-configure-condor-2.4.1-1.osg34.el6
osg-configure-gateway-2.4.1-1.osg34.el6
osg-configure-gip-2.4.1-1.osg34.el6
osg-configure-gratia-2.4.1-1.osg34.el6
osg-configure-infoservices-2.4.1-1.osg34.el6
osg-configure-lsf-2.4.1-1.osg34.el6
osg-configure-misc-2.4.1-1.osg34.el6
osg-configure-pbs-2.4.1-1.osg34.el6
osg-configure-rsv-2.4.1-1.osg34.el6
osg-configure-sge-2.4.1-1.osg34.el6
osg-configure-siteinfo-2.4.1-1.osg34.el6
osg-configure-slurm-2.4.1-1.osg34.el6
osg-configure-squid-2.4.1-1.osg34.el6
osg-configure-tests-2.4.1-1.osg34.el6
osg-system-profiler-1.4.3-1.osg34.el6
osg-system-profiler-viewer-1.4.3-1.osg34.el6
osg-version-3.4.34-1.osg34.el6
osg-xrootd-3.4-4.osg34.el6
osg-xrootd-standalone-3.4-4.osg34.el6
xrootd-lcmaps-1.7.4-2.osg34.el6
xrootd-lcmaps-debuginfo-1.7.4-2.osg34.el6
```

#### Enterprise Linux 7

``` file
atlas-xcache-1.1.1-1.osg34.el7
cctools-7.0.14-1.osg34.el7
cctools-debuginfo-7.0.14-1.osg34.el7
cctools-devel-7.0.14-1.osg34.el7
cms-xcache-1.1.1-1.osg34.el7
myproxy-6.2.4-1.1.osg34.el7
myproxy-admin-6.2.4-1.1.osg34.el7
myproxy-debuginfo-6.2.4-1.1.osg34.el7
myproxy-devel-6.2.4-1.1.osg34.el7
myproxy-doc-6.2.4-1.1.osg34.el7
myproxy-libs-6.2.4-1.1.osg34.el7
myproxy-server-6.2.4-1.1.osg34.el7
myproxy-voms-6.2.4-1.1.osg34.el7
osg-configure-2.4.1-1.osg34.el7
osg-configure-bosco-2.4.1-1.osg34.el7
osg-configure-ce-2.4.1-1.osg34.el7
osg-configure-condor-2.4.1-1.osg34.el7
osg-configure-gateway-2.4.1-1.osg34.el7
osg-configure-gip-2.4.1-1.osg34.el7
osg-configure-gratia-2.4.1-1.osg34.el7
osg-configure-infoservices-2.4.1-1.osg34.el7
osg-configure-lsf-2.4.1-1.osg34.el7
osg-configure-misc-2.4.1-1.osg34.el7
osg-configure-pbs-2.4.1-1.osg34.el7
osg-configure-rsv-2.4.1-1.osg34.el7
osg-configure-sge-2.4.1-1.osg34.el7
osg-configure-siteinfo-2.4.1-1.osg34.el7
osg-configure-slurm-2.4.1-1.osg34.el7
osg-configure-squid-2.4.1-1.osg34.el7
osg-configure-tests-2.4.1-1.osg34.el7
osg-system-profiler-1.4.3-1.osg34.el7
osg-system-profiler-viewer-1.4.3-1.osg34.el7
osg-version-3.4.34-1.osg34.el7
osg-xrootd-3.4-4.osg34.el7
osg-xrootd-standalone-3.4-4.osg34.el7
stash-cache-1.1.1-1.osg34.el7
stash-origin-1.1.1-1.osg34.el7
xcache-1.1.1-1.osg34.el7
xrootd-hdfs-2.1.6-1.osg34.el7
xrootd-hdfs-debuginfo-2.1.6-1.osg34.el7
xrootd-hdfs-devel-2.1.6-1.osg34.el7
xrootd-lcmaps-1.7.4-2.osg34.el7
xrootd-lcmaps-debuginfo-1.7.4-2.osg34.el7
```
