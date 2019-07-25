OSG Software Release 3.4.32
===========================

**Release Date**: 2019-07-25

Summary of changes
------------------

This release contains:

-   Frontier Squid 4.4-2.1: [Address remote code execution vulnerability](http://www.squid-cache.org/Advisories/SQUID-2019_5.txt)
-   Singularity 3.2.1-1.1: Applied two patches
    -   [Fixed regression in mounting custom home directories](https://github.com/sylabs/singularity/pull/3456)
    -   [Fix problem binding read-only file-systems, such as CVMFS, when running unprivileged](https://github.com/sylabs/singularity/pull/3803)
-   [VO Package v94](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-94): Updated certificate DNs for LSST and SuperCDMS
-   Upcoming repository:
    -   [HTCondor 8.8.4](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00014.shtml)
        -   Python 3 bindings - see version history for details
        -   Can configure DAGMan to dramatically reduce memory usage on some DAGs
        -   Improved scalability when using the python bindings to qedit jobs
        -   Fixed infrequent schedd crashes when removing scheduler universe jobs
        -   The condor_master creates run and lock directories when systemd doesn't
        -   The condor daemon obituary email now contains the last 200 lines of log

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.32%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

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

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-from-osg-31-32-33-to-33-or-34).

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

-   [frontier-squid-4.4-2.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.4-2.1.osg34.el6)
-   [glite-lbjp-common-gsoap-plugin-3.2.12-7.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-lbjp-common-gsoap-plugin-3.2.12-7.osg34.el6)
-   [osg-version-3.4.32-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.32-1.osg34.el6)
-   [singularity-3.2.1-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.2.1-1.1.osg34.el6)
-   [vo-client-94-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-94-1.osg34.el6)

#### Enterprise Linux 7

-   [frontier-squid-4.4-2.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.4-2.1.osg34.el7)
-   [glite-lbjp-common-gsoap-plugin-3.2.12-7.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-lbjp-common-gsoap-plugin-3.2.12-7.osg34.el7)
-   [osg-version-3.4.32-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.32-1.osg34.el7)
-   [singularity-3.2.1-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.2.1-1.1.osg34.el7)
-   [vo-client-94-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-94-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid frontier-squid-debuginfo glite-lbjp-common-gsoap-plugin glite-lbjp-common-gsoap-plugin-debuginfo glite-lbjp-common-gsoap-plugin-devel igtf-ca-certs osg-ca-certs osg-version singularity singularity-debuginfo vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
frontier-squid-4.4-2.1.osg34.el6
frontier-squid-debuginfo-4.4-2.1.osg34.el6
glite-lbjp-common-gsoap-plugin-3.2.12-7.osg34.el6
glite-lbjp-common-gsoap-plugin-debuginfo-3.2.12-7.osg34.el6
glite-lbjp-common-gsoap-plugin-devel-3.2.12-7.osg34.el6
osg-version-3.4.32-1.osg34.el6
singularity-3.2.1-1.1.osg34.el6
singularity-debuginfo-3.2.1-1.1.osg34.el6
vo-client-94-1.osg34.el6
vo-client-dcache-94-1.osg34.el6
vo-client-lcmaps-voms-94-1.osg34.el6
```

#### Enterprise Linux 7

``` file
frontier-squid-4.4-2.1.osg34.el7
frontier-squid-debuginfo-4.4-2.1.osg34.el7
glite-lbjp-common-gsoap-plugin-3.2.12-7.osg34.el7
glite-lbjp-common-gsoap-plugin-debuginfo-3.2.12-7.osg34.el7
glite-lbjp-common-gsoap-plugin-devel-3.2.12-7.osg34.el7
osg-version-3.4.32-1.osg34.el7
singularity-3.2.1-1.1.osg34.el7
singularity-debuginfo-3.2.1-1.1.osg34.el7
vo-client-94-1.osg34.el7
vo-client-dcache-94-1.osg34.el7
vo-client-lcmaps-voms-94-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.8.4-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.4-1.osgup.el6)

#### Enterprise Linux 7

-   [condor-8.8.4-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.4-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp minicondor python2-condor python3-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.8.4-1.osgup.el6
condor-all-8.8.4-1.osgup.el6
condor-annex-ec2-8.8.4-1.osgup.el6
condor-bosco-8.8.4-1.osgup.el6
condor-classads-8.8.4-1.osgup.el6
condor-classads-devel-8.8.4-1.osgup.el6
condor-cream-gahp-8.8.4-1.osgup.el6
condor-debuginfo-8.8.4-1.osgup.el6
condor-kbdd-8.8.4-1.osgup.el6
condor-procd-8.8.4-1.osgup.el6
condor-std-universe-8.8.4-1.osgup.el6
condor-test-8.8.4-1.osgup.el6
condor-vm-gahp-8.8.4-1.osgup.el6
minicondor-8.8.4-1.osgup.el6
python2-condor-8.8.4-1.osgup.el6
```

#### Enterprise Linux 7

``` file
condor-8.8.4-1.osgup.el7
condor-all-8.8.4-1.osgup.el7
condor-annex-ec2-8.8.4-1.osgup.el7
condor-bosco-8.8.4-1.osgup.el7
condor-classads-8.8.4-1.osgup.el7
condor-classads-devel-8.8.4-1.osgup.el7
condor-cream-gahp-8.8.4-1.osgup.el7
condor-debuginfo-8.8.4-1.osgup.el7
condor-kbdd-8.8.4-1.osgup.el7
condor-procd-8.8.4-1.osgup.el7
condor-test-8.8.4-1.osgup.el7
condor-vm-gahp-8.8.4-1.osgup.el7
minicondor-8.8.4-1.osgup.el7
python2-condor-8.8.4-1.osgup.el7
python3-condor-8.8.4-1.osgup.el7
```
