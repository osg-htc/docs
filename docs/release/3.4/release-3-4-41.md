OSG Software Release 3.4.41
===========================

**Release Date**: 2019-12-19    
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

-   [Singularity 3.5.2](https://github.com/sylabs/singularity/releases/tag/v3.5.2): Security release
-   [HTCondor-CE 3.4.0](https://github.com/htcondor/htcondor-ce/releases/tag/v3.4.0): Bug fix release
-   [CVMFS 2.7.0](https://cvmfs.readthedocs.io/en/2.7/cpt-releasenotes.html): New feature release
    -   Fuse 3 Support
    -   Pre-mounted Repository
    -   POSIX ACLs
    -   Client Performance Instrumentation
-   [GlideinWMS 3.6.1](https://glideinwms.fnal.gov/doc.v3_6_1/history.html): Improved Singularity support
-   Simplify initial setup for stand-alone XRootD server
-   [HTCondor 8.8.6](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00020.shtml): Bug fix release

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.41%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

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

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-osg-repositories).

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

-   [condor-8.8.6-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.6-1.1.osg34.el6)
-   [cvmfs-2.7.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.0-1.osg34.el6)
-   [glideinwms-3.6.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6.1-1.osg34.el6)
-   [htcondor-ce-3.4.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.4.0-1.osg34.el6)
-   [koji-1.15.3-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.15.3-1.2.osg34.el6)
-   [osg-oasis-16-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-1.osg34.el6)
-   [osg-version-3.4.41-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.41-1.osg34.el6)
-   [osg-xrootd-3.4-5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.4-5.osg34.el6)
-   [singularity-3.5.2-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.5.2-1.1.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.8.6-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.6-1.1.osg34.el7)
-   [cvmfs-2.7.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.0-1.osg34.el7)
-   [glideinwms-3.6.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6.1-1.osg34.el7)
-   [htcondor-ce-3.4.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.4.0-1.osg34.el7)
-   [koji-1.15.3-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.15.3-1.2.osg34.el7)
-   [osg-oasis-16-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-1.osg34.el7)
-   [osg-version-3.4.41-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.41-1.osg34.el7)
-   [osg-xrootd-3.4-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.4-5.osg34.el7)
-   [singularity-3.5.2-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.5.2-1.1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view koji koji-builder koji-hub koji-hub-plugins koji-utils koji-vm koji-web minicondor osg-oasis osg-version osg-xrootd osg-xrootd-standalone python2-condor python2-koji python2-koji-cli-plugins python3-condor singularity singularity-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.8.6-1.1.osg34.el6
condor-all-8.8.6-1.1.osg34.el6
condor-annex-ec2-8.8.6-1.1.osg34.el6
condor-bosco-8.8.6-1.1.osg34.el6
condor-classads-8.8.6-1.1.osg34.el6
condor-classads-devel-8.8.6-1.1.osg34.el6
condor-cream-gahp-8.8.6-1.1.osg34.el6
condor-debuginfo-8.8.6-1.1.osg34.el6
condor-kbdd-8.8.6-1.1.osg34.el6
condor-procd-8.8.6-1.1.osg34.el6
condor-std-universe-8.8.6-1.1.osg34.el6
condor-test-8.8.6-1.1.osg34.el6
condor-vm-gahp-8.8.6-1.1.osg34.el6
cvmfs-2.7.0-1.osg34.el6
cvmfs-devel-2.7.0-1.osg34.el6
cvmfs-fuse3-2.7.0-1.osg34.el6
cvmfs-server-2.7.0-1.osg34.el6
cvmfs-shrinkwrap-2.7.0-1.osg34.el6
cvmfs-unittests-2.7.0-1.osg34.el6
glideinwms-3.6.1-1.osg34.el6
glideinwms-common-tools-3.6.1-1.osg34.el6
glideinwms-condor-common-config-3.6.1-1.osg34.el6
glideinwms-factory-3.6.1-1.osg34.el6
glideinwms-factory-condor-3.6.1-1.osg34.el6
glideinwms-glidecondor-tools-3.6.1-1.osg34.el6
glideinwms-libs-3.6.1-1.osg34.el6
glideinwms-minimal-condor-3.6.1-1.osg34.el6
glideinwms-usercollector-3.6.1-1.osg34.el6
glideinwms-userschedd-3.6.1-1.osg34.el6
glideinwms-vofrontend-3.6.1-1.osg34.el6
glideinwms-vofrontend-standalone-3.6.1-1.osg34.el6
htcondor-ce-3.4.0-1.osg34.el6
htcondor-ce-bosco-3.4.0-1.osg34.el6
htcondor-ce-client-3.4.0-1.osg34.el6
htcondor-ce-collector-3.4.0-1.osg34.el6
htcondor-ce-condor-3.4.0-1.osg34.el6
htcondor-ce-lsf-3.4.0-1.osg34.el6
htcondor-ce-pbs-3.4.0-1.osg34.el6
htcondor-ce-sge-3.4.0-1.osg34.el6
htcondor-ce-slurm-3.4.0-1.osg34.el6
htcondor-ce-view-3.4.0-1.osg34.el6
koji-1.15.3-1.2.osg34.el6
koji-builder-1.15.3-1.2.osg34.el6
koji-hub-1.15.3-1.2.osg34.el6
koji-hub-plugins-1.15.3-1.2.osg34.el6
koji-utils-1.15.3-1.2.osg34.el6
koji-vm-1.15.3-1.2.osg34.el6
koji-web-1.15.3-1.2.osg34.el6
minicondor-8.8.6-1.1.osg34.el6
osg-oasis-16-1.osg34.el6
osg-version-3.4.41-1.osg34.el6
osg-xrootd-3.4-5.osg34.el6
osg-xrootd-standalone-3.4-5.osg34.el6
python2-condor-8.8.6-1.1.osg34.el6
python2-koji-1.15.3-1.2.osg34.el6
python2-koji-cli-plugins-1.15.3-1.2.osg34.el6
singularity-3.5.2-1.1.osg34.el6
singularity-debuginfo-3.5.2-1.1.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.8.6-1.1.osg34.el7
condor-all-8.8.6-1.1.osg34.el7
condor-annex-ec2-8.8.6-1.1.osg34.el7
condor-bosco-8.8.6-1.1.osg34.el7
condor-classads-8.8.6-1.1.osg34.el7
condor-classads-devel-8.8.6-1.1.osg34.el7
condor-cream-gahp-8.8.6-1.1.osg34.el7
condor-debuginfo-8.8.6-1.1.osg34.el7
condor-kbdd-8.8.6-1.1.osg34.el7
condor-procd-8.8.6-1.1.osg34.el7
condor-test-8.8.6-1.1.osg34.el7
condor-vm-gahp-8.8.6-1.1.osg34.el7
cvmfs-2.7.0-1.osg34.el7
cvmfs-devel-2.7.0-1.osg34.el7
cvmfs-ducc-2.7.0-1.osg34.el7
cvmfs-fuse3-2.7.0-1.osg34.el7
cvmfs-server-2.7.0-1.osg34.el7
cvmfs-shrinkwrap-2.7.0-1.osg34.el7
cvmfs-unittests-2.7.0-1.osg34.el7
glideinwms-3.6.1-1.osg34.el7
glideinwms-common-tools-3.6.1-1.osg34.el7
glideinwms-condor-common-config-3.6.1-1.osg34.el7
glideinwms-factory-3.6.1-1.osg34.el7
glideinwms-factory-condor-3.6.1-1.osg34.el7
glideinwms-glidecondor-tools-3.6.1-1.osg34.el7
glideinwms-libs-3.6.1-1.osg34.el7
glideinwms-minimal-condor-3.6.1-1.osg34.el7
glideinwms-usercollector-3.6.1-1.osg34.el7
glideinwms-userschedd-3.6.1-1.osg34.el7
glideinwms-vofrontend-3.6.1-1.osg34.el7
glideinwms-vofrontend-standalone-3.6.1-1.osg34.el7
htcondor-ce-3.4.0-1.osg34.el7
htcondor-ce-bosco-3.4.0-1.osg34.el7
htcondor-ce-client-3.4.0-1.osg34.el7
htcondor-ce-collector-3.4.0-1.osg34.el7
htcondor-ce-condor-3.4.0-1.osg34.el7
htcondor-ce-lsf-3.4.0-1.osg34.el7
htcondor-ce-pbs-3.4.0-1.osg34.el7
htcondor-ce-sge-3.4.0-1.osg34.el7
htcondor-ce-slurm-3.4.0-1.osg34.el7
htcondor-ce-view-3.4.0-1.osg34.el7
koji-1.15.3-1.2.osg34.el7
koji-builder-1.15.3-1.2.osg34.el7
koji-hub-1.15.3-1.2.osg34.el7
koji-hub-plugins-1.15.3-1.2.osg34.el7
koji-utils-1.15.3-1.2.osg34.el7
koji-vm-1.15.3-1.2.osg34.el7
koji-web-1.15.3-1.2.osg34.el7
minicondor-8.8.6-1.1.osg34.el7
osg-oasis-16-1.osg34.el7
osg-version-3.4.41-1.osg34.el7
osg-xrootd-3.4-5.osg34.el7
osg-xrootd-standalone-3.4-5.osg34.el7
python2-condor-8.8.6-1.1.osg34.el7
python2-koji-1.15.3-1.2.osg34.el7
python2-koji-cli-plugins-1.15.3-1.2.osg34.el7
python3-condor-8.8.6-1.1.osg34.el7
singularity-3.5.2-1.1.osg34.el7
singularity-debuginfo-3.5.2-1.1.osg34.el7
```
