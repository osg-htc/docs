OSG Software Release 3.3.24
===========================

**Release Date**: 2017-05-09

Summary of changes
------------------

This release contains:

-   OSG 3.3.24
    -   osg-configure 1.7.0
        -   Edit lcmaps.db to use the VOMS plugin
            -   Add template lcmaps.db files
        -   Make all attributes relating to the defunct BDII service optional
        -   Don't error out if user-vo-map missing, issue warning with suggestion
    -   CVMFS X.509 helper - fix for running inside a container
    -   gsissh in tarball installations
    -   Fix HTCondor Gratia probe to not call .eval() if not present when doing DebugPrint logging
    -   osg-build 1.9.0
        -   Split osg-build into subpackages
        -   add supprt for git repos in .source files (for HCC)
        -   osg-build notes default options
        -   add support for 3.4
-   Upcoming repository
    -   [HTCondor 8.6.2](https://lists.cs.wisc.edu/archive/htcondor-world/2017/msg00015.shtml)
    -   [GlideinWMS 3.3.2](http://glideinwms.fnal.gov/doc.v3_3_2/history.html#development)
        -   Allow multiple remote directories for BOSCO submissions
        -   Bug fix: Submit attributes in entry configuration are now transmitted to AWS VM

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.24%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   After updating OSG-CE to version 3.3-12, please disable and remove OSG Info Services via the following procedure:

``` console
root@host # service osg-info-services stop
root@host # yum erase gip osg-info-services
```

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

To update to this series, you need to [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note
    Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

!!! note
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [cvmfs-x509-helper-1.0-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-1.0-1.osg33.el6)
-   [gratia-probe-1.17.5-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.17.5-1.osg33.el6)
-   [lcmaps-1.6.6-1.3.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.3.osg33.el6)
-   [osg-build-1.9.0-2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.9.0-2.osg33.el6)
-   [osg-configure-1.7.0-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.7.0-1.osg33.el6)
-   [osg-version-3.3.24-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.24-1.osg33.el6)
-   [osg-wn-client-3.3-7.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.3-7.osg33.el6)

#### Enterprise Linux 7

-   [cvmfs-x509-helper-1.0-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-1.0-1.osg33.el7)
-   [gratia-probe-1.17.5-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.17.5-1.osg33.el7)
-   [lcmaps-1.6.6-1.3.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.3.osg33.el7)
-   [osg-build-1.9.0-2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.9.0-2.osg33.el7)
-   [osg-configure-1.7.0-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.7.0-1.osg33.el7)
-   [osg-version-3.3.24-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.24-1.osg33.el7)
-   [osg-wn-client-3.3-7.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.3-7.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cvmfs-x509-helper cvmfs-x509-helper-debuginfo gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer lcmaps lcmaps-common-devel lcmaps-db-templates lcmaps-debuginfo lcmaps-devel lcmaps-without-gsi lcmaps-without-gsi-devel osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-version osg-wn-client osg-wn-client-glexec

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
cvmfs-x509-helper-1.0-1.osg33.el6
cvmfs-x509-helper-debuginfo-1.0-1.osg33.el6
gratia-probe-1.17.5-1.osg33.el6
gratia-probe-bdii-status-1.17.5-1.osg33.el6
gratia-probe-common-1.17.5-1.osg33.el6
gratia-probe-condor-1.17.5-1.osg33.el6
gratia-probe-condor-events-1.17.5-1.osg33.el6
gratia-probe-dcache-storage-1.17.5-1.osg33.el6
gratia-probe-dcache-storagegroup-1.17.5-1.osg33.el6
gratia-probe-dcache-transfer-1.17.5-1.osg33.el6
gratia-probe-debuginfo-1.17.5-1.osg33.el6
gratia-probe-enstore-storage-1.17.5-1.osg33.el6
gratia-probe-enstore-tapedrive-1.17.5-1.osg33.el6
gratia-probe-enstore-transfer-1.17.5-1.osg33.el6
gratia-probe-glexec-1.17.5-1.osg33.el6
gratia-probe-glideinwms-1.17.5-1.osg33.el6
gratia-probe-gram-1.17.5-1.osg33.el6
gratia-probe-gridftp-transfer-1.17.5-1.osg33.el6
gratia-probe-hadoop-storage-1.17.5-1.osg33.el6
gratia-probe-htcondor-ce-1.17.5-1.osg33.el6
gratia-probe-lsf-1.17.5-1.osg33.el6
gratia-probe-metric-1.17.5-1.osg33.el6
gratia-probe-onevm-1.17.5-1.osg33.el6
gratia-probe-pbs-lsf-1.17.5-1.osg33.el6
gratia-probe-services-1.17.5-1.osg33.el6
gratia-probe-sge-1.17.5-1.osg33.el6
gratia-probe-slurm-1.17.5-1.osg33.el6
gratia-probe-xrootd-storage-1.17.5-1.osg33.el6
gratia-probe-xrootd-transfer-1.17.5-1.osg33.el6
lcmaps-1.6.6-1.3.osg33.el6
lcmaps-common-devel-1.6.6-1.3.osg33.el6
lcmaps-db-templates-1.6.6-1.3.osg33.el6
lcmaps-debuginfo-1.6.6-1.3.osg33.el6
lcmaps-devel-1.6.6-1.3.osg33.el6
lcmaps-without-gsi-1.6.6-1.3.osg33.el6
lcmaps-without-gsi-devel-1.6.6-1.3.osg33.el6
osg-build-1.9.0-2.osg33.el6
osg-build-base-1.9.0-2.osg33.el6
osg-build-koji-1.9.0-2.osg33.el6
osg-build-mock-1.9.0-2.osg33.el6
osg-build-tests-1.9.0-2.osg33.el6
osg-configure-1.7.0-1.osg33.el6
osg-configure-bosco-1.7.0-1.osg33.el6
osg-configure-ce-1.7.0-1.osg33.el6
osg-configure-cemon-1.7.0-1.osg33.el6
osg-configure-condor-1.7.0-1.osg33.el6
osg-configure-gateway-1.7.0-1.osg33.el6
osg-configure-gip-1.7.0-1.osg33.el6
osg-configure-gratia-1.7.0-1.osg33.el6
osg-configure-infoservices-1.7.0-1.osg33.el6
osg-configure-lsf-1.7.0-1.osg33.el6
osg-configure-managedfork-1.7.0-1.osg33.el6
osg-configure-misc-1.7.0-1.osg33.el6
osg-configure-monalisa-1.7.0-1.osg33.el6
osg-configure-network-1.7.0-1.osg33.el6
osg-configure-pbs-1.7.0-1.osg33.el6
osg-configure-rsv-1.7.0-1.osg33.el6
osg-configure-sge-1.7.0-1.osg33.el6
osg-configure-slurm-1.7.0-1.osg33.el6
osg-configure-squid-1.7.0-1.osg33.el6
osg-configure-tests-1.7.0-1.osg33.el6
osg-version-3.3.24-1.osg33.el6
osg-wn-client-3.3-7.osg33.el6
osg-wn-client-glexec-3.3-7.osg33.el6
```

#### Enterprise Linux 7

``` file
cvmfs-x509-helper-1.0-1.osg33.el7
cvmfs-x509-helper-debuginfo-1.0-1.osg33.el7
gratia-probe-1.17.5-1.osg33.el7
gratia-probe-bdii-status-1.17.5-1.osg33.el7
gratia-probe-common-1.17.5-1.osg33.el7
gratia-probe-condor-1.17.5-1.osg33.el7
gratia-probe-condor-events-1.17.5-1.osg33.el7
gratia-probe-dcache-storage-1.17.5-1.osg33.el7
gratia-probe-dcache-storagegroup-1.17.5-1.osg33.el7
gratia-probe-dcache-transfer-1.17.5-1.osg33.el7
gratia-probe-debuginfo-1.17.5-1.osg33.el7
gratia-probe-enstore-storage-1.17.5-1.osg33.el7
gratia-probe-enstore-tapedrive-1.17.5-1.osg33.el7
gratia-probe-enstore-transfer-1.17.5-1.osg33.el7
gratia-probe-glexec-1.17.5-1.osg33.el7
gratia-probe-glideinwms-1.17.5-1.osg33.el7
gratia-probe-gram-1.17.5-1.osg33.el7
gratia-probe-gridftp-transfer-1.17.5-1.osg33.el7
gratia-probe-hadoop-storage-1.17.5-1.osg33.el7
gratia-probe-htcondor-ce-1.17.5-1.osg33.el7
gratia-probe-lsf-1.17.5-1.osg33.el7
gratia-probe-metric-1.17.5-1.osg33.el7
gratia-probe-onevm-1.17.5-1.osg33.el7
gratia-probe-pbs-lsf-1.17.5-1.osg33.el7
gratia-probe-services-1.17.5-1.osg33.el7
gratia-probe-sge-1.17.5-1.osg33.el7
gratia-probe-slurm-1.17.5-1.osg33.el7
gratia-probe-xrootd-storage-1.17.5-1.osg33.el7
gratia-probe-xrootd-transfer-1.17.5-1.osg33.el7
lcmaps-1.6.6-1.3.osg33.el7
lcmaps-common-devel-1.6.6-1.3.osg33.el7
lcmaps-db-templates-1.6.6-1.3.osg33.el7
lcmaps-debuginfo-1.6.6-1.3.osg33.el7
lcmaps-devel-1.6.6-1.3.osg33.el7
lcmaps-without-gsi-1.6.6-1.3.osg33.el7
lcmaps-without-gsi-devel-1.6.6-1.3.osg33.el7
osg-build-1.9.0-2.osg33.el7
osg-build-base-1.9.0-2.osg33.el7
osg-build-koji-1.9.0-2.osg33.el7
osg-build-mock-1.9.0-2.osg33.el7
osg-build-tests-1.9.0-2.osg33.el7
osg-configure-1.7.0-1.osg33.el7
osg-configure-bosco-1.7.0-1.osg33.el7
osg-configure-ce-1.7.0-1.osg33.el7
osg-configure-cemon-1.7.0-1.osg33.el7
osg-configure-condor-1.7.0-1.osg33.el7
osg-configure-gateway-1.7.0-1.osg33.el7
osg-configure-gip-1.7.0-1.osg33.el7
osg-configure-gratia-1.7.0-1.osg33.el7
osg-configure-infoservices-1.7.0-1.osg33.el7
osg-configure-lsf-1.7.0-1.osg33.el7
osg-configure-managedfork-1.7.0-1.osg33.el7
osg-configure-misc-1.7.0-1.osg33.el7
osg-configure-monalisa-1.7.0-1.osg33.el7
osg-configure-network-1.7.0-1.osg33.el7
osg-configure-pbs-1.7.0-1.osg33.el7
osg-configure-rsv-1.7.0-1.osg33.el7
osg-configure-sge-1.7.0-1.osg33.el7
osg-configure-slurm-1.7.0-1.osg33.el7
osg-configure-squid-1.7.0-1.osg33.el7
osg-configure-tests-1.7.0-1.osg33.el7
osg-version-3.3.24-1.osg33.el7
osg-wn-client-3.3-7.osg33.el7
osg-wn-client-glexec-3.3-7.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.6.2-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.2-1.osgup.el6)
-   [glideinwms-3.3.2-2.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.3.2-2.osgup.el6)
-   [lcmaps-1.6.6-1.4.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.4.osgup.el6)

#### Enterprise Linux 7

-   [condor-8.6.2-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.2-1.osgup.el7)
-   [glideinwms-3.3.2-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.3.2-2.osgup.el7)
-   [lcmaps-1.6.6-1.4.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.4.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone lcmaps lcmaps-common-devel lcmaps-db-templates lcmaps-debuginfo lcmaps-devel lcmaps-without-gsi lcmaps-without-gsi-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.6.2-1.osgup.el6
condor-all-8.6.2-1.osgup.el6
condor-bosco-8.6.2-1.osgup.el6
condor-classads-8.6.2-1.osgup.el6
condor-classads-devel-8.6.2-1.osgup.el6
condor-cream-gahp-8.6.2-1.osgup.el6
condor-debuginfo-8.6.2-1.osgup.el6
condor-kbdd-8.6.2-1.osgup.el6
condor-procd-8.6.2-1.osgup.el6
condor-python-8.6.2-1.osgup.el6
condor-std-universe-8.6.2-1.osgup.el6
condor-test-8.6.2-1.osgup.el6
condor-vm-gahp-8.6.2-1.osgup.el6
glideinwms-3.3.2-2.osgup.el6
glideinwms-common-tools-3.3.2-2.osgup.el6
glideinwms-condor-common-config-3.3.2-2.osgup.el6
glideinwms-factory-3.3.2-2.osgup.el6
glideinwms-factory-condor-3.3.2-2.osgup.el6
glideinwms-glidecondor-tools-3.3.2-2.osgup.el6
glideinwms-libs-3.3.2-2.osgup.el6
glideinwms-minimal-condor-3.3.2-2.osgup.el6
glideinwms-usercollector-3.3.2-2.osgup.el6
glideinwms-userschedd-3.3.2-2.osgup.el6
glideinwms-vofrontend-3.3.2-2.osgup.el6
glideinwms-vofrontend-standalone-3.3.2-2.osgup.el6
lcmaps-1.6.6-1.4.osgup.el6
lcmaps-common-devel-1.6.6-1.4.osgup.el6
lcmaps-db-templates-1.6.6-1.4.osgup.el6
lcmaps-debuginfo-1.6.6-1.4.osgup.el6
lcmaps-devel-1.6.6-1.4.osgup.el6
lcmaps-without-gsi-1.6.6-1.4.osgup.el6
lcmaps-without-gsi-devel-1.6.6-1.4.osgup.el6
```

#### Enterprise Linux 7

``` file
condor-8.6.2-1.osgup.el7
condor-all-8.6.2-1.osgup.el7
condor-bosco-8.6.2-1.osgup.el7
condor-classads-8.6.2-1.osgup.el7
condor-classads-devel-8.6.2-1.osgup.el7
condor-cream-gahp-8.6.2-1.osgup.el7
condor-debuginfo-8.6.2-1.osgup.el7
condor-kbdd-8.6.2-1.osgup.el7
condor-procd-8.6.2-1.osgup.el7
condor-python-8.6.2-1.osgup.el7
condor-test-8.6.2-1.osgup.el7
condor-vm-gahp-8.6.2-1.osgup.el7
glideinwms-3.3.2-2.osgup.el7
glideinwms-common-tools-3.3.2-2.osgup.el7
glideinwms-condor-common-config-3.3.2-2.osgup.el7
glideinwms-factory-3.3.2-2.osgup.el7
glideinwms-factory-condor-3.3.2-2.osgup.el7
glideinwms-glidecondor-tools-3.3.2-2.osgup.el7
glideinwms-libs-3.3.2-2.osgup.el7
glideinwms-minimal-condor-3.3.2-2.osgup.el7
glideinwms-usercollector-3.3.2-2.osgup.el7
glideinwms-userschedd-3.3.2-2.osgup.el7
glideinwms-vofrontend-3.3.2-2.osgup.el7
glideinwms-vofrontend-standalone-3.3.2-2.osgup.el7
lcmaps-1.6.6-1.4.osgup.el7
lcmaps-common-devel-1.6.6-1.4.osgup.el7
lcmaps-db-templates-1.6.6-1.4.osgup.el7
lcmaps-debuginfo-1.6.6-1.4.osgup.el7
lcmaps-devel-1.6.6-1.4.osgup.el7
lcmaps-without-gsi-1.6.6-1.4.osgup.el7
lcmaps-without-gsi-devel-1.6.6-1.4.osgup.el7
```

