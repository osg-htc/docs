OSG Software Release 3.3.23
===========================

**Release Date**: 2017-04-11

Summary of changes
------------------

This release contains:

-   OSG 3.3.23
    -   LCMAPS VOMS plugin: Use VOMS attributes to map users
    -   [HTCondor-CE 2.1.5](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.1.5): LCMAPS VOMS integration, package Slurm configuration
    -   [CVMFS 2.3.5](http://cvmfs.readthedocs.io/en/2.3/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-3-5): Fixes, including automount fix when autofs restarts on EL7
    -   [Pegasus 4.7.4](https://pegasus.isi.edu/2017/02/27/pegasus-4-7-4-released/): [Update from version 4.6.1](https://pegasus.isi.edu/pegasus-timeline/)
    -   OSG-CE 3.3-12: Removed gip and osg-info-services, see note below
-   Upcoming repository
    -   LCMAPS 1.6.6-1.3: Enable VOMS attribute checking by default
    -   [Frontier squid 3.5.24-3.1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): Fix for some crashes under heavy load

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.23%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

<span class="twiki-macro NOTE"></span> After updating OSG-CE to version 3.3-12, please disable and remove OSG Info Services via the following procedure:

``` console
root@host # service osg-info-services stop
root@host # yum erase gip osg-info-services
```

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   The Koji client config has changed in the new version of Koji: \`pkgurl`` http://koji.chtc.wisc.edu/packages` has been replaced by `topurl=http://koji.chtc.wisc.edu` and the Koji client will give a harmless but annoying warning when it finds `pkgurl`. To get rid of the warning, update to osg-build > `` 1.8.0, rerun \`osg-koji setup\`, and say 'yes' when asked to replace the Koji configuration file; or, you may make the above change manually.
-   A previous version (`1.17.0-2.5`) of the Gratia probes required changes in the HTCondor configuration to operate properly. Now, these changes need to be reverted to use verison `1.17.0-2.6` and later of the probes. The lines below are likely to be found in `condor_config.local` or a new file in `/etc/condor/config.d` directory. Delete these lines and run `condor_reconfig`.

``` file
# GlideinWMS Gratia commands
PER_JOB_HISTORY_DIR = /var/lib/gratia/data
JOBGLIDEIN_ResourceName="$$([IfThenElse(IsUndefined(TARGET.GLIDEIN_ResourceName), IfThenElse(IsUndefined(TARGET.GLIDEIN_Site), IfThenElse(IsUndefined(TARGET.FileSystemDomain), \"Local Job\", TARGET.FileSystemDomain), TARGET.GLIDEIN_Site), TARGET.GLIDEIN_ResourceName)])"
SUBMIT_EXPRS = $(SUBMIT_EXPRS) JOBGLIDEIN_ResourceName   
```

-   On EL7, your version of voms-proxy-init may come from the voms-clients-java package; this version will continue to make legacy proxies by default. If you want the new behavior, install the voms-clients-cpp package and uninstall the voms-clients-java package.

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

<span class="twiki-macro NOTE"></span> Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

<span class="twiki-macro NOTE"></span> Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [cvmfs-2.3.5-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.3.5-1.osg33.el6)
-   [htcondor-ce-2.1.5-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.1.5-1.osg33.el6)
-   [lcmaps-1.6.6-1.2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.2.osg33.el6)
-   [lcmaps-plugins-verify-proxy-1.5.9-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.9-1.1.osg33.el6)
-   [lcmaps-plugins-voms-1.7.1-1.2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.2.osg33.el6)
-   [osg-build-1.8.1-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.8.1-1.osg33.el6)
-   [osg-ce-3.3-12.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.3-12.osg33.el6)
-   [osg-configure-1.6.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.6.2-1.osg33.el6)
-   [osg-oasis-7-9.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-7-9.osg33.el6)
-   [osg-version-3.3.23-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.23-1.osg33.el6)
-   [pegasus-4.7.4-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.7.4-1.1.osg33.el6)

#### Enterprise Linux 7

-   [cvmfs-2.3.5-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.3.5-1.osg33.el7)
-   [htcondor-ce-2.1.5-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.1.5-1.osg33.el7)
-   [lcmaps-1.6.6-1.2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.2.osg33.el7)
-   [lcmaps-plugins-verify-proxy-1.5.9-1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.9-1.1.osg33.el7)
-   [lcmaps-plugins-voms-1.7.1-1.2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.2.osg33.el7)
-   [osg-build-1.8.1-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.8.1-1.osg33.el7)
-   [osg-ce-3.3-12.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.3-12.osg33.el7)
-   [osg-configure-1.6.2-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.6.2-1.osg33.el7)
-   [osg-oasis-7-9.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-7-9.osg33.el7)
-   [osg-version-3.3.23-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.23-1.osg33.el7)
-   [pegasus-4.7.4-1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.7.4-1.1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cvmfs cvmfs-devel cvmfs-server cvmfs-unittests htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs lcmaps lcmaps-common-devel lcmaps-debuginfo lcmaps-devel lcmaps-plugins-verify-proxy lcmaps-plugins-verify-proxy-debuginfo lcmaps-plugins-voms lcmaps-plugins-voms-debuginfo lcmaps-without-gsi lcmaps-without-gsi-devel osg-base-ce osg-base-ce-bosco osg-base-ce-condor osg-base-ce-lsf osg-base-ce-pbs osg-base-ce-sge osg-base-ce-slurm osg-build osg-ca-certs osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gums-config osg-htcondor-ce osg-htcondor-ce-bosco osg-htcondor-ce-condor osg-htcondor-ce-lsf osg-htcondor-ce-pbs osg-htcondor-ce-sge osg-htcondor-ce-slurm osg-oasis osg-version pegasus pegasus-debuginfo vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
cvmfs-2.3.5-1.osg33.el7
cvmfs-devel-2.3.5-1.osg33.el7
cvmfs-server-2.3.5-1.osg33.el7
cvmfs-unittests-2.3.5-1.osg33.el7
htcondor-ce-2.1.5-1.osg33.el7
htcondor-ce-bosco-2.1.5-1.osg33.el7
htcondor-ce-client-2.1.5-1.osg33.el7
htcondor-ce-collector-2.1.5-1.osg33.el7
htcondor-ce-condor-2.1.5-1.osg33.el7
htcondor-ce-lsf-2.1.5-1.osg33.el7
htcondor-ce-pbs-2.1.5-1.osg33.el7
htcondor-ce-sge-2.1.5-1.osg33.el7
htcondor-ce-slurm-2.1.5-1.osg33.el7
htcondor-ce-view-2.1.5-1.osg33.el7
lcmaps-1.6.6-1.2.osg33.el7
lcmaps-common-devel-1.6.6-1.2.osg33.el7
lcmaps-debuginfo-1.6.6-1.2.osg33.el7
lcmaps-devel-1.6.6-1.2.osg33.el7
lcmaps-plugins-verify-proxy-1.5.9-1.1.osg33.el7
lcmaps-plugins-verify-proxy-debuginfo-1.5.9-1.1.osg33.el7
lcmaps-plugins-voms-1.7.1-1.2.osg33.el7
lcmaps-plugins-voms-debuginfo-1.7.1-1.2.osg33.el7
lcmaps-without-gsi-1.6.6-1.2.osg33.el7
lcmaps-without-gsi-devel-1.6.6-1.2.osg33.el7
osg-base-ce-3.3-12.osg33.el7
osg-base-ce-bosco-3.3-12.osg33.el7
osg-base-ce-condor-3.3-12.osg33.el7
osg-base-ce-lsf-3.3-12.osg33.el7
osg-base-ce-pbs-3.3-12.osg33.el7
osg-base-ce-sge-3.3-12.osg33.el7
osg-base-ce-slurm-3.3-12.osg33.el7
osg-build-1.8.1-1.osg33.el7
osg-ce-3.3-12.osg33.el7
osg-ce-bosco-3.3-12.osg33.el7
osg-ce-condor-3.3-12.osg33.el7
osg-ce-lsf-3.3-12.osg33.el7
osg-ce-pbs-3.3-12.osg33.el7
osg-ce-sge-3.3-12.osg33.el7
osg-ce-slurm-3.3-12.osg33.el7
osg-configure-1.6.2-1.osg33.el7
osg-configure-bosco-1.6.2-1.osg33.el7
osg-configure-ce-1.6.2-1.osg33.el7
osg-configure-cemon-1.6.2-1.osg33.el7
osg-configure-condor-1.6.2-1.osg33.el7
osg-configure-gateway-1.6.2-1.osg33.el7
osg-configure-gip-1.6.2-1.osg33.el7
osg-configure-gratia-1.6.2-1.osg33.el7
osg-configure-infoservices-1.6.2-1.osg33.el7
osg-configure-lsf-1.6.2-1.osg33.el7
osg-configure-managedfork-1.6.2-1.osg33.el7
osg-configure-misc-1.6.2-1.osg33.el7
osg-configure-monalisa-1.6.2-1.osg33.el7
osg-configure-network-1.6.2-1.osg33.el7
osg-configure-pbs-1.6.2-1.osg33.el7
osg-configure-rsv-1.6.2-1.osg33.el7
osg-configure-sge-1.6.2-1.osg33.el7
osg-configure-slurm-1.6.2-1.osg33.el7
osg-configure-squid-1.6.2-1.osg33.el7
osg-configure-tests-1.6.2-1.osg33.el7
osg-htcondor-ce-3.3-12.osg33.el7
osg-htcondor-ce-bosco-3.3-12.osg33.el7
osg-htcondor-ce-condor-3.3-12.osg33.el7
osg-htcondor-ce-lsf-3.3-12.osg33.el7
osg-htcondor-ce-pbs-3.3-12.osg33.el7
osg-htcondor-ce-sge-3.3-12.osg33.el7
osg-htcondor-ce-slurm-3.3-12.osg33.el7
osg-oasis-7-9.osg33.el7
osg-version-3.3.23-1.osg33.el7
pegasus-4.7.4-1.1.osg33.el7
pegasus-debuginfo-4.7.4-1.1.osg33.el7
```

#### Enterprise Linux 7

``` file
cvmfs-2.3.5-1.osg33.el7
cvmfs-devel-2.3.5-1.osg33.el7
cvmfs-server-2.3.5-1.osg33.el7
cvmfs-unittests-2.3.5-1.osg33.el7
htcondor-ce-2.1.5-1.osg33.el7
htcondor-ce-bosco-2.1.5-1.osg33.el7
htcondor-ce-client-2.1.5-1.osg33.el7
htcondor-ce-collector-2.1.5-1.osg33.el7
htcondor-ce-condor-2.1.5-1.osg33.el7
htcondor-ce-lsf-2.1.5-1.osg33.el7
htcondor-ce-pbs-2.1.5-1.osg33.el7
htcondor-ce-sge-2.1.5-1.osg33.el7
htcondor-ce-slurm-2.1.5-1.osg33.el7
htcondor-ce-view-2.1.5-1.osg33.el7
lcmaps-1.6.6-1.2.osg33.el7
lcmaps-common-devel-1.6.6-1.2.osg33.el7
lcmaps-debuginfo-1.6.6-1.2.osg33.el7
lcmaps-devel-1.6.6-1.2.osg33.el7
lcmaps-plugins-verify-proxy-1.5.9-1.1.osg33.el7
lcmaps-plugins-verify-proxy-debuginfo-1.5.9-1.1.osg33.el7
lcmaps-plugins-voms-1.7.1-1.2.osg33.el7
lcmaps-plugins-voms-debuginfo-1.7.1-1.2.osg33.el7
lcmaps-without-gsi-1.6.6-1.2.osg33.el7
lcmaps-without-gsi-devel-1.6.6-1.2.osg33.el7
osg-base-ce-3.3-12.osg33.el7
osg-base-ce-bosco-3.3-12.osg33.el7
osg-base-ce-condor-3.3-12.osg33.el7
osg-base-ce-lsf-3.3-12.osg33.el7
osg-base-ce-pbs-3.3-12.osg33.el7
osg-base-ce-sge-3.3-12.osg33.el7
osg-base-ce-slurm-3.3-12.osg33.el7
osg-build-1.8.1-1.osg33.el7
osg-ce-3.3-12.osg33.el7
osg-ce-bosco-3.3-12.osg33.el7
osg-ce-condor-3.3-12.osg33.el7
osg-ce-lsf-3.3-12.osg33.el7
osg-ce-pbs-3.3-12.osg33.el7
osg-ce-sge-3.3-12.osg33.el7
osg-ce-slurm-3.3-12.osg33.el7
osg-configure-1.6.2-1.osg33.el7
osg-configure-bosco-1.6.2-1.osg33.el7
osg-configure-ce-1.6.2-1.osg33.el7
osg-configure-cemon-1.6.2-1.osg33.el7
osg-configure-condor-1.6.2-1.osg33.el7
osg-configure-gateway-1.6.2-1.osg33.el7
osg-configure-gip-1.6.2-1.osg33.el7
osg-configure-gratia-1.6.2-1.osg33.el7
osg-configure-infoservices-1.6.2-1.osg33.el7
osg-configure-lsf-1.6.2-1.osg33.el7
osg-configure-managedfork-1.6.2-1.osg33.el7
osg-configure-misc-1.6.2-1.osg33.el7
osg-configure-monalisa-1.6.2-1.osg33.el7
osg-configure-network-1.6.2-1.osg33.el7
osg-configure-pbs-1.6.2-1.osg33.el7
osg-configure-rsv-1.6.2-1.osg33.el7
osg-configure-sge-1.6.2-1.osg33.el7
osg-configure-slurm-1.6.2-1.osg33.el7
osg-configure-squid-1.6.2-1.osg33.el7
osg-configure-tests-1.6.2-1.osg33.el7
osg-htcondor-ce-3.3-12.osg33.el7
osg-htcondor-ce-bosco-3.3-12.osg33.el7
osg-htcondor-ce-condor-3.3-12.osg33.el7
osg-htcondor-ce-lsf-3.3-12.osg33.el7
osg-htcondor-ce-pbs-3.3-12.osg33.el7
osg-htcondor-ce-sge-3.3-12.osg33.el7
osg-htcondor-ce-slurm-3.3-12.osg33.el7
osg-oasis-7-9.osg33.el7
osg-version-3.3.23-1.osg33.el7
pegasus-4.7.4-1.1.osg33.el7
pegasus-debuginfo-4.7.4-1.1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [frontier-squid-3.5.24-3.1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.24-3.1.osgup.el6)
-   [lcmaps-1.6.6-1.3.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.3.osgup.el6)

#### Enterprise Linux 7

-   [frontier-squid-3.5.24-3.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.24-3.1.osgup.el7)
-   [lcmaps-1.6.6-1.3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.3.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid frontier-squid-debuginfo lcmaps lcmaps-common-devel lcmaps-debuginfo lcmaps-devel lcmaps-without-gsi lcmaps-without-gsi-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
frontier-squid-3.5.24-3.1.osgup.el6
frontier-squid-debuginfo-3.5.24-3.1.osgup.el6
lcmaps-1.6.6-1.3.osgup.el6
lcmaps-common-devel-1.6.6-1.3.osgup.el6
lcmaps-debuginfo-1.6.6-1.3.osgup.el6
lcmaps-devel-1.6.6-1.3.osgup.el6
lcmaps-without-gsi-1.6.6-1.3.osgup.el6
lcmaps-without-gsi-devel-1.6.6-1.3.osgup.el6
```

#### Enterprise Linux 7

``` file
frontier-squid-3.5.24-3.1.osgup.el7
frontier-squid-debuginfo-3.5.24-3.1.osgup.el7
lcmaps-1.6.6-1.3.osgup.el7
lcmaps-common-devel-1.6.6-1.3.osgup.el7
lcmaps-debuginfo-1.6.6-1.3.osgup.el7
lcmaps-devel-1.6.6-1.3.osgup.el7
lcmaps-without-gsi-1.6.6-1.3.osgup.el7
lcmaps-without-gsi-devel-1.6.6-1.3.osgup.el7
```

