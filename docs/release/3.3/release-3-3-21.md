OSG Software Release 3.3.21
===========================

**Release Date**: 2017-02-14

Summary of changes
------------------

This release contains:

-   OSG 3.3.21
    -   osg-configure 1.6.1: [Additional support](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/IniConfigurationOptions#GipResourceEntry) for ATLAS AGIS in osg-configure
    -   [glideinWMS 3.2.17](http://glideinwms.fnal.gov/doc.v3_2_17/history.html)
        -   See known issues below
    -   Important bug fixes for CVMFS server
        -   [CVM-1165](https://sft.its.cern.ch/jira/browse/CVM-1165) - swissknife hang during publish
        -   [CVM-1108](https://sft.its.cern.ch/jira/browse/CVM-1108) - Prevent garbage collection from running at the same time as snapshot
        -   [CVM-1153](https://sft.its.cern.ch/jira/browse/CVM-1153) - cvmfs build fails on centos7.3, in externals/build\_c-ares
    -   [HTCondor 8.4.11](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00000.shtml): Final bug fix release of the 8.4 series
    -   [HTCondor-CE 2.1.2](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.1.2)
        -   Accept Russian Data Intensive Grid certificates
        -   Avoid crash in client tools (e.g. `condor-ce-info-status`) by accepting `CPUs` or `Cpus` from the collector
    -   Added two new scripts to help maintain tarball installations
        -   osg-update-vos: update VO client data
        -   osg-update-data: update VO client data and CA certificates
    -   rsv-perfsonar 1.2.1: Control over message send to the MQ
    -   Internal tools: koji, osg-build, osg-koji setup
        -   See known issues below
    -   Internal automated tests: Use default cache location for CMVFS to address test failures with SELinux on EL6
-   Upcoming repository
    -   [Singularity 2.2.1](https://github.com/singularityware/singularity/releases/tag/2.2.1) Security Release
        -   Security Information
            -   In versions of Singularity previous to 2.2.1, it was possible for a malicious user to create and manipulate specifically crafted raw devices within containers they own. Utilizing MS\_NODEV as a container image mount option mitigates this potential vector of attack. As a result, this update should be implemented with high urgency.
        -   Other Improvements
            -   Fixed some leaky file descriptors
            -   Cleaned up \*printf() usage
            -   Catch if user's group is not properly defined

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.21%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   The glideinWMS 3.2.17 factory has a bug when you attempt to restart the service. You must first remove a lock file (`/var/lib/gwms-factory/work-dir/lock/glideinWMS.lock`) that isn't properly cleaned up when the service is stopped.
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
[root@client ~] $ yum update
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

-   [condor-8.4.11-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.11-1.osg33.el6)
-   [cvmfs-2.3.2-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.3.2-1.1.osg33.el6)
-   [glideinwms-3.2.17-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.17-1.osg33.el6)
-   [htcondor-ce-2.1.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.1.2-1.osg33.el6)
-   [koji-1.11.0-1.5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=koji-1.11.0-1.5.osg33.el6)
-   [osg-build-1.8.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.8.0-1.osg33.el6)
-   [osg-configure-1.6.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.6.1-1.osg33.el6)
-   [osg-test-1.10.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.10.1-1.osg33.el6)
-   [osg-update-vos-1.3.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-update-vos-1.3.0-1.osg33.el6)
-   [osg-version-3.3.21-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.21-1.osg33.el6)
-   [rsv-perfsonar-1.2.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-perfsonar-1.2.1-1.osg33.el6)

#### Enterprise Linux 7

-   [condor-8.4.11-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.11-1.osg33.el7)
-   [cvmfs-2.3.2-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.3.2-1.1.osg33.el7)
-   [glideinwms-3.2.17-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.17-1.osg33.el7)
-   [htcondor-ce-2.1.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.1.2-1.osg33.el7)
-   [koji-1.11.0-1.5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=koji-1.11.0-1.5.osg33.el7)
-   [osg-build-1.8.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.8.0-1.osg33.el7)
-   [osg-configure-1.6.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.6.1-1.osg33.el7)
-   [osg-test-1.10.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.10.1-1.osg33.el7)
-   [osg-update-vos-1.3.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-update-vos-1.3.0-1.osg33.el7)
-   [osg-version-3.3.21-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.21-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-devel cvmfs-server cvmfs-unittests glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view igtf-ca-certs koji koji-builder koji-hub koji-hub-plugins koji-utils koji-vm koji-web osg-build osg-ca-certs osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gums-config osg-test osg-test-log-viewer osg-update-data osg-update-vos osg-version rsv-perfsonar vo-client vo-client-edgmkgridmap

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.4.11-1.osg33.el6
condor-all-8.4.11-1.osg33.el6
condor-bosco-8.4.11-1.osg33.el6
condor-classads-8.4.11-1.osg33.el6
condor-classads-devel-8.4.11-1.osg33.el6
condor-cream-gahp-8.4.11-1.osg33.el6
condor-debuginfo-8.4.11-1.osg33.el6
condor-kbdd-8.4.11-1.osg33.el6
condor-procd-8.4.11-1.osg33.el6
condor-python-8.4.11-1.osg33.el6
condor-std-universe-8.4.11-1.osg33.el6
condor-test-8.4.11-1.osg33.el6
condor-vm-gahp-8.4.11-1.osg33.el6
cvmfs-2.3.2-1.1.osg33.el6
cvmfs-devel-2.3.2-1.1.osg33.el6
cvmfs-server-2.3.2-1.1.osg33.el6
cvmfs-unittests-2.3.2-1.1.osg33.el6
glideinwms-3.2.17-1.osg33.el6
glideinwms-common-tools-3.2.17-1.osg33.el6
glideinwms-condor-common-config-3.2.17-1.osg33.el6
glideinwms-factory-3.2.17-1.osg33.el6
glideinwms-factory-condor-3.2.17-1.osg33.el6
glideinwms-glidecondor-tools-3.2.17-1.osg33.el6
glideinwms-libs-3.2.17-1.osg33.el6
glideinwms-minimal-condor-3.2.17-1.osg33.el6
glideinwms-usercollector-3.2.17-1.osg33.el6
glideinwms-userschedd-3.2.17-1.osg33.el6
glideinwms-vofrontend-3.2.17-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.17-1.osg33.el6
htcondor-ce-2.1.2-1.osg33.el6
htcondor-ce-bosco-2.1.2-1.osg33.el6
htcondor-ce-client-2.1.2-1.osg33.el6
htcondor-ce-collector-2.1.2-1.osg33.el6
htcondor-ce-condor-2.1.2-1.osg33.el6
htcondor-ce-lsf-2.1.2-1.osg33.el6
htcondor-ce-pbs-2.1.2-1.osg33.el6
htcondor-ce-sge-2.1.2-1.osg33.el6
htcondor-ce-view-2.1.2-1.osg33.el6
koji-1.11.0-1.5.osg33.el6
koji-builder-1.11.0-1.5.osg33.el6
koji-hub-1.11.0-1.5.osg33.el6
koji-hub-plugins-1.11.0-1.5.osg33.el6
koji-utils-1.11.0-1.5.osg33.el6
koji-vm-1.11.0-1.5.osg33.el6
koji-web-1.11.0-1.5.osg33.el6
osg-build-1.8.0-1.osg33.el6
osg-configure-1.6.1-1.osg33.el6
osg-configure-bosco-1.6.1-1.osg33.el6
osg-configure-ce-1.6.1-1.osg33.el6
osg-configure-cemon-1.6.1-1.osg33.el6
osg-configure-condor-1.6.1-1.osg33.el6
osg-configure-gateway-1.6.1-1.osg33.el6
osg-configure-gip-1.6.1-1.osg33.el6
osg-configure-gratia-1.6.1-1.osg33.el6
osg-configure-infoservices-1.6.1-1.osg33.el6
osg-configure-lsf-1.6.1-1.osg33.el6
osg-configure-managedfork-1.6.1-1.osg33.el6
osg-configure-misc-1.6.1-1.osg33.el6
osg-configure-monalisa-1.6.1-1.osg33.el6
osg-configure-network-1.6.1-1.osg33.el6
osg-configure-pbs-1.6.1-1.osg33.el6
osg-configure-rsv-1.6.1-1.osg33.el6
osg-configure-sge-1.6.1-1.osg33.el6
osg-configure-slurm-1.6.1-1.osg33.el6
osg-configure-squid-1.6.1-1.osg33.el6
osg-configure-tests-1.6.1-1.osg33.el6
osg-test-1.10.1-1.osg33.el6
osg-test-log-viewer-1.10.1-1.osg33.el6
osg-update-data-1.3.0-1.osg33.el6
osg-update-vos-1.3.0-1.osg33.el6
osg-version-3.3.21-1.osg33.el6
rsv-perfsonar-1.2.1-1.osg33.el6
```

#### Enterprise Linux 7

``` file
condor-8.4.11-1.osg33.el7
condor-all-8.4.11-1.osg33.el7
condor-bosco-8.4.11-1.osg33.el7
condor-classads-8.4.11-1.osg33.el7
condor-classads-devel-8.4.11-1.osg33.el7
condor-cream-gahp-8.4.11-1.osg33.el7
condor-debuginfo-8.4.11-1.osg33.el7
condor-kbdd-8.4.11-1.osg33.el7
condor-procd-8.4.11-1.osg33.el7
condor-python-8.4.11-1.osg33.el7
condor-test-8.4.11-1.osg33.el7
condor-vm-gahp-8.4.11-1.osg33.el7
cvmfs-2.3.2-1.1.osg33.el7
cvmfs-devel-2.3.2-1.1.osg33.el7
cvmfs-server-2.3.2-1.1.osg33.el7
cvmfs-unittests-2.3.2-1.1.osg33.el7
glideinwms-3.2.17-1.osg33.el7
glideinwms-common-tools-3.2.17-1.osg33.el7
glideinwms-condor-common-config-3.2.17-1.osg33.el7
glideinwms-factory-3.2.17-1.osg33.el7
glideinwms-factory-condor-3.2.17-1.osg33.el7
glideinwms-glidecondor-tools-3.2.17-1.osg33.el7
glideinwms-libs-3.2.17-1.osg33.el7
glideinwms-minimal-condor-3.2.17-1.osg33.el7
glideinwms-usercollector-3.2.17-1.osg33.el7
glideinwms-userschedd-3.2.17-1.osg33.el7
glideinwms-vofrontend-3.2.17-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.17-1.osg33.el7
htcondor-ce-2.1.2-1.osg33.el7
htcondor-ce-bosco-2.1.2-1.osg33.el7
htcondor-ce-client-2.1.2-1.osg33.el7
htcondor-ce-collector-2.1.2-1.osg33.el7
htcondor-ce-condor-2.1.2-1.osg33.el7
htcondor-ce-lsf-2.1.2-1.osg33.el7
htcondor-ce-pbs-2.1.2-1.osg33.el7
htcondor-ce-sge-2.1.2-1.osg33.el7
htcondor-ce-view-2.1.2-1.osg33.el7
koji-1.11.0-1.5.osg33.el7
koji-builder-1.11.0-1.5.osg33.el7
koji-hub-1.11.0-1.5.osg33.el7
koji-hub-plugins-1.11.0-1.5.osg33.el7
koji-utils-1.11.0-1.5.osg33.el7
koji-vm-1.11.0-1.5.osg33.el7
koji-web-1.11.0-1.5.osg33.el7
osg-build-1.8.0-1.osg33.el7
osg-configure-1.6.1-1.osg33.el7
osg-configure-bosco-1.6.1-1.osg33.el7
osg-configure-ce-1.6.1-1.osg33.el7
osg-configure-cemon-1.6.1-1.osg33.el7
osg-configure-condor-1.6.1-1.osg33.el7
osg-configure-gateway-1.6.1-1.osg33.el7
osg-configure-gip-1.6.1-1.osg33.el7
osg-configure-gratia-1.6.1-1.osg33.el7
osg-configure-infoservices-1.6.1-1.osg33.el7
osg-configure-lsf-1.6.1-1.osg33.el7
osg-configure-managedfork-1.6.1-1.osg33.el7
osg-configure-misc-1.6.1-1.osg33.el7
osg-configure-monalisa-1.6.1-1.osg33.el7
osg-configure-network-1.6.1-1.osg33.el7
osg-configure-pbs-1.6.1-1.osg33.el7
osg-configure-rsv-1.6.1-1.osg33.el7
osg-configure-sge-1.6.1-1.osg33.el7
osg-configure-slurm-1.6.1-1.osg33.el7
osg-configure-squid-1.6.1-1.osg33.el7
osg-configure-tests-1.6.1-1.osg33.el7
osg-test-1.10.1-1.osg33.el7
osg-test-log-viewer-1.10.1-1.osg33.el7
osg-update-data-1.3.0-1.osg33.el7
osg-update-vos-1.3.0-1.osg33.el7
osg-version-3.3.21-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [singularity-2.2.1-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=singularity-2.2.1-1.osgup.el6)

#### Enterprise Linux 7

-   [singularity-2.2.1-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=singularity-2.2.1-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    singularity singularity-debuginfo singularity-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
singularity-2.2.1-1.osgup.el6
singularity-debuginfo-2.2.1-1.osgup.el6
singularity-devel-2.2.1-1.osgup.el6
```

#### Enterprise Linux 7

``` file
singularity-2.2.1-1.osgup.el7
singularity-debuginfo-2.2.1-1.osgup.el7
singularity-devel-2.2.1-1.osgup.el7
```

