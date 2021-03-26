OSG Software Release 3.4.31
===========================

**Release Date**: 2019-06-13

Summary of changes
------------------

This release contains:

!!! note
    This release contains a major upgrade to Singularity.
    Be on the lookout for any .rpmnew files and merge in any local changes.
    There are numerous additions to the configuration.

-   [Singularity 3.2.1](https://github.com/sylabs/singularity/releases): Major upgrade from version 2.6.1 (See note above).
    Singularity 3, no longer uses a setuid binary for building container images so the `singularity-runtime` package has
    been merged into the `singularity` package.
-   GlideinWMS 3.4.5-2: Fix problems with the proxy renewal service
-   HTCondor 8.6.13-1.4: Fix problems when upgrading condor-python
-   [VO Package v93](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-93): Add in sPHENIX VO
-   Upcoming repository:
    -   [HTCondor 8.8.3](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00011.shtml)
        -   Fixed a bug where jobs were killed instead of peacefully shutting down
        -   Fixed a bug where a restarted schedd wouldn't connect to its running jobs
        -   Improved file transfer performance when sending multiple files
        -   Fix a bug that prevented interactive submit from working with Singularity
        -   Orphaned Docker containers are now cleaned up on execute nodes
        -   Restored a deprecated Python interface that is used to read the event log

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.31%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

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

-   [condor-8.6.13-1.4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.13-1.4.osg34.el6)
-   [glideinwms-3.4.5-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4.5-2.osg34.el6)
-   [osg-version-3.4.31-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.31-1.osg34.el6)
-   [singularity-3.2.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.2.1-1.osg34.el6)
-   [vo-client-93-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-93-1.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.6.13-1.4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.13-1.4.osg34.el7)
-   [glideinwms-3.4.5-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4.5-2.osg34.el7)
-   [osg-version-3.4.31-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.31-1.osg34.el7)
-   [singularity-3.2.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.2.1-1.osg34.el7)
-   [vo-client-93-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-93-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone igtf-ca-certs osg-ca-certs osg-version python2-condor singularity singularity-debuginfo vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.6.13-1.4.osg34.el6
condor-all-8.6.13-1.4.osg34.el6
condor-bosco-8.6.13-1.4.osg34.el6
condor-classads-8.6.13-1.4.osg34.el6
condor-classads-devel-8.6.13-1.4.osg34.el6
condor-cream-gahp-8.6.13-1.4.osg34.el6
condor-debuginfo-8.6.13-1.4.osg34.el6
condor-kbdd-8.6.13-1.4.osg34.el6
condor-procd-8.6.13-1.4.osg34.el6
condor-std-universe-8.6.13-1.4.osg34.el6
condor-test-8.6.13-1.4.osg34.el6
condor-vm-gahp-8.6.13-1.4.osg34.el6
glideinwms-3.4.5-2.osg34.el6
glideinwms-common-tools-3.4.5-2.osg34.el6
glideinwms-condor-common-config-3.4.5-2.osg34.el6
glideinwms-factory-3.4.5-2.osg34.el6
glideinwms-factory-condor-3.4.5-2.osg34.el6
glideinwms-glidecondor-tools-3.4.5-2.osg34.el6
glideinwms-libs-3.4.5-2.osg34.el6
glideinwms-minimal-condor-3.4.5-2.osg34.el6
glideinwms-usercollector-3.4.5-2.osg34.el6
glideinwms-userschedd-3.4.5-2.osg34.el6
glideinwms-vofrontend-3.4.5-2.osg34.el6
glideinwms-vofrontend-standalone-3.4.5-2.osg34.el6
osg-version-3.4.31-1.osg34.el6
python2-condor-8.6.13-1.4.osg34.el6
singularity-3.2.1-1.osg34.el6
singularity-debuginfo-3.2.1-1.osg34.el6
vo-client-93-1.osg34.el6
vo-client-dcache-93-1.osg34.el6
vo-client-lcmaps-voms-93-1.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.6.13-1.4.osg34.el7
condor-all-8.6.13-1.4.osg34.el7
condor-bosco-8.6.13-1.4.osg34.el7
condor-classads-8.6.13-1.4.osg34.el7
condor-classads-devel-8.6.13-1.4.osg34.el7
condor-cream-gahp-8.6.13-1.4.osg34.el7
condor-debuginfo-8.6.13-1.4.osg34.el7
condor-kbdd-8.6.13-1.4.osg34.el7
condor-procd-8.6.13-1.4.osg34.el7
condor-test-8.6.13-1.4.osg34.el7
condor-vm-gahp-8.6.13-1.4.osg34.el7
glideinwms-3.4.5-2.osg34.el7
glideinwms-common-tools-3.4.5-2.osg34.el7
glideinwms-condor-common-config-3.4.5-2.osg34.el7
glideinwms-factory-3.4.5-2.osg34.el7
glideinwms-factory-condor-3.4.5-2.osg34.el7
glideinwms-glidecondor-tools-3.4.5-2.osg34.el7
glideinwms-libs-3.4.5-2.osg34.el7
glideinwms-minimal-condor-3.4.5-2.osg34.el7
glideinwms-usercollector-3.4.5-2.osg34.el7
glideinwms-userschedd-3.4.5-2.osg34.el7
glideinwms-vofrontend-3.4.5-2.osg34.el7
glideinwms-vofrontend-standalone-3.4.5-2.osg34.el7
osg-version-3.4.31-1.osg34.el7
python2-condor-8.6.13-1.4.osg34.el7
singularity-3.2.1-1.osg34.el7
singularity-debuginfo-3.2.1-1.osg34.el7
vo-client-93-1.osg34.el7
vo-client-dcache-93-1.osg34.el7
vo-client-lcmaps-voms-93-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.8.3-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.3-1.osgup.el6)

#### Enterprise Linux 7

-   [condor-8.8.3-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.3-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp minicondor python2-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.8.3-1.osgup.el6
condor-all-8.8.3-1.osgup.el6
condor-annex-ec2-8.8.3-1.osgup.el6
condor-bosco-8.8.3-1.osgup.el6
condor-classads-8.8.3-1.osgup.el6
condor-classads-devel-8.8.3-1.osgup.el6
condor-cream-gahp-8.8.3-1.osgup.el6
condor-debuginfo-8.8.3-1.osgup.el6
condor-kbdd-8.8.3-1.osgup.el6
condor-procd-8.8.3-1.osgup.el6
condor-std-universe-8.8.3-1.osgup.el6
condor-test-8.8.3-1.osgup.el6
condor-vm-gahp-8.8.3-1.osgup.el6
minicondor-8.8.3-1.osgup.el6
python2-condor-8.8.3-1.osgup.el6
```

#### Enterprise Linux 7

``` file
condor-8.8.3-1.osgup.el7
condor-all-8.8.3-1.osgup.el7
condor-annex-ec2-8.8.3-1.osgup.el7
condor-bosco-8.8.3-1.osgup.el7
condor-classads-8.8.3-1.osgup.el7
condor-classads-devel-8.8.3-1.osgup.el7
condor-cream-gahp-8.8.3-1.osgup.el7
condor-debuginfo-8.8.3-1.osgup.el7
condor-kbdd-8.8.3-1.osgup.el7
condor-procd-8.8.3-1.osgup.el7
condor-test-8.8.3-1.osgup.el7
condor-vm-gahp-8.8.3-1.osgup.el7
minicondor-8.8.3-1.osgup.el7
python2-condor-8.8.3-1.osgup.el7
```
