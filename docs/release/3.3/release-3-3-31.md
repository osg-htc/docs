OSG Software Release 3.3.31
===========================

**Release Date**: 2017-12-21

Summary of changes
------------------

This release contains:

-   [XRootD 4.8.0](https://github.com/xrootd/xrootd/blob/v4.8.0/docs/ReleaseNotes.txt): fixed caching issues and multiple segfaults
-   [CernVM-FS 2.4.4](https://cvmfs.readthedocs.io/en/2.4/cpt-releasenotes.html): Update from 2.4.2
    -   bug fixes for servers and clients
-   [GlideinWMS 3.2.20](http://glideinwms.fnal.gov/doc.v3_2_20/history.html): improved factory performance, Singularity support
-   [osg-pki-tools 2.1.2](https://github.com/opensciencegrid/osg-pki-tools/releases): use HTTPS for all OIM connections, service certificate fix (Update from 2.0.0)
-   osg-wn-client: add gfal2-http plugin
-   lcmaps: enable VOMS signature checking by default
-   GridFTP-HDFS: fix potential crash related to CVMFS checksums
-   [HTCondor-CE 2.2.4](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.2.4): bug fixes
-   osg-gridftp: add osg-configure-gratia
-   [osg-configure 1.10.3](https://github.com/opensciencegrid/osg-configure/releases/tag/v1.10.3): minor bug fixes

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.31%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   This is the last regular release of this release series. At this point, only critical issues will be addressed in this series through May 2018.  After May, this release series is unsupported. Please consider moving to the 3.4 series.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-1 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore ('_'). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](/index.md).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details.`. This warning can safely be ignored.
-   Updates to VOMS admin server require the updated emi-trustmanager-tomcat and re-running the configure script:

        :::console
        root@host # /var/lib/trustmanager-tomcat/configure.sh

-   VOMS admin server shows an error when modifying/adding/signing AUPs, but all the actions still work.
-   After updating OSG-CE to version 3.3-12, please disable and remove OSG Info Services via the following procedure:

        :::console
        root@host # service osg-info-services stop
        root@host # yum erase gip osg-info-services

-   The Koji client config has changed in the new version of Koji: `pkgurl=http://koji.chtc.wisc.edu/packages` has been replaced by `topurl=http://koji.chtc.wisc.edu` and the Koji client will give a harmless but annoying warning when it finds `pkgurl`. To get rid of the warning, update to osg-build > `1.8.0`, rerun `osg-koji setup`, and say 'yes' when asked to replace the Koji configuration file; or, you may make the above change manually.
-   A previous version (`1.17.0-2.5`) of the Gratia probes required changes in the HTCondor configuration to operate properly. Now, these changes need to be reverted to use verison `1.17.0-2.6` and later of the probes. The lines below are likely to be found in `condor_config.local` or a new file in `/etc/condor/config.d` directory. Delete these lines and run `condor_reconfig`.

        # GlideinWMS Gratia commands
        PER_JOB_HISTORY_DIR = /var/lib/gratia/data
        JOBGLIDEIN_ResourceName="$$([IfThenElse(IsUndefined(TARGET.GLIDEIN_ResourceName), IfThenElse(IsUndefined(TARGET.GLIDEIN_Site), IfThenElse(IsUndefined(TARGET.FileSystemDomain), \"Local Job\", TARGET.FileSystemDomain), TARGET.GLIDEIN_Site), TARGET.GLIDEIN_ResourceName)])"
        SUBMIT_EXPRS = $(SUBMIT_EXPRS) JOBGLIDEIN_ResourceName

-   On EL7, your version of voms-proxy-init may come from the voms-clients-java package; this version will continue to make legacy proxies by default. If you want the new behavior, install the voms-clients-cpp package and uninstall the voms-clients-java package.

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
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension).

Need help?
----------

Do you need help with this release? [Contact us for help](/common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.35.bosco-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.35.bosco-1.osg33.el6)
-   [cvmfs-2.4.4-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.4.4-1.osg33.el6)
-   [glideinwms-3.2.20-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.20-1.osg33.el6)
-   [gridftp-hdfs-1.1.1-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-hdfs-1.1.1-1.1.osg33.el6)
-   [htcondor-ce-2.2.4-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.4-1.osg33.el6)
-   [lcmaps-1.6.6-1.9.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.9.osg33.el6)
-   [osg-ca-certs-updater-1.7-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.7-1.osg33.el6)
-   [osg-ca-scripts-1.2.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.2-1.osg33.el6)
-   [osg-ce-3.3-14.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.3-14.osg33.el6)
-   [osg-configure-1.10.3-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.10.3-1.osg33.el6)
-   [osg-gridftp-3.3-6.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.3-6.osg33.el6)
-   [osg-oasis-8-5.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-8-5.osg33.el6)
-   [osg-pki-tools-2.1.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-2.1.2-1.osg33.el6)
-   [osg-system-profiler-1.4.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.2-1.osg33.el6)
-   [osg-version-3.3.31-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.31-1.osg33.el6)
-   [osg-wn-client-3.3-8.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.3-8.osg33.el6)
-   [xrootd-4.8.0-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.0-1.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.35.bosco-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.35.bosco-1.osg33.el7)
-   [cvmfs-2.4.4-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.4.4-1.osg33.el7)
-   [glideinwms-3.2.20-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.20-1.osg33.el7)
-   [gridftp-hdfs-1.1.1-1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-hdfs-1.1.1-1.1.osg33.el7)
-   [htcondor-ce-2.2.4-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.4-1.osg33.el7)
-   [lcmaps-1.6.6-1.9.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.9.osg33.el7)
-   [osg-ca-certs-updater-1.7-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.7-1.osg33.el7)
-   [osg-ca-scripts-1.2.2-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.2-1.osg33.el7)
-   [osg-ce-3.3-14.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.3-14.osg33.el7)
-   [osg-configure-1.10.3-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.10.3-1.osg33.el7)
-   [osg-gridftp-3.3-6.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.3-6.osg33.el7)
-   [osg-oasis-8-5.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-8-5.osg33.el7)
-   [osg-pki-tools-2.1.2-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-2.1.2-1.osg33.el7)
-   [osg-system-profiler-1.4.2-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.2-1.osg33.el7)
-   [osg-version-3.3.31-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.31-1.osg33.el7)
-   [osg-wn-client-3.3-8.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.3-8.osg33.el7)
-   [xrootd-4.8.0-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.0-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo cvmfs cvmfs-devel cvmfs-server cvmfs-unittests glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone gridftp-hdfs gridftp-hdfs-debuginfo htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs lcmaps lcmaps-common-devel lcmaps-db-templates lcmaps-debuginfo lcmaps-devel lcmaps-without-gsi lcmaps-without-gsi-devel osg-base-ce osg-base-ce-bosco osg-base-ce-condor osg-base-ce-lsf osg-base-ce-pbs osg-base-ce-sge osg-base-ce-slurm osg-ca-certs osg-ca-certs-updater osg-ca-scripts osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-gridftp osg-gums-config osg-htcondor-ce osg-htcondor-ce-bosco osg-htcondor-ce-condor osg-htcondor-ce-lsf osg-htcondor-ce-pbs osg-htcondor-ce-sge osg-htcondor-ce-slurm osg-oasis osg-pki-tools osg-system-profiler osg-system-profiler-viewer osg-version osg-wn-client osg-wn-client-glexec python2-xrootd python3-xrootd vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.35.bosco-1.osg33.el6
blahp-debuginfo-1.18.35.bosco-1.osg33.el6
cvmfs-2.4.4-1.osg33.el6
cvmfs-devel-2.4.4-1.osg33.el6
cvmfs-server-2.4.4-1.osg33.el6
cvmfs-unittests-2.4.4-1.osg33.el6
glideinwms-3.2.20-1.osg33.el6
glideinwms-common-tools-3.2.20-1.osg33.el6
glideinwms-condor-common-config-3.2.20-1.osg33.el6
glideinwms-factory-3.2.20-1.osg33.el6
glideinwms-factory-condor-3.2.20-1.osg33.el6
glideinwms-glidecondor-tools-3.2.20-1.osg33.el6
glideinwms-libs-3.2.20-1.osg33.el6
glideinwms-minimal-condor-3.2.20-1.osg33.el6
glideinwms-usercollector-3.2.20-1.osg33.el6
glideinwms-userschedd-3.2.20-1.osg33.el6
glideinwms-vofrontend-3.2.20-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.20-1.osg33.el6
gridftp-hdfs-1.1.1-1.1.osg33.el6
gridftp-hdfs-debuginfo-1.1.1-1.1.osg33.el6
htcondor-ce-2.2.4-1.osg33.el6
htcondor-ce-bosco-2.2.4-1.osg33.el6
htcondor-ce-client-2.2.4-1.osg33.el6
htcondor-ce-collector-2.2.4-1.osg33.el6
htcondor-ce-condor-2.2.4-1.osg33.el6
htcondor-ce-lsf-2.2.4-1.osg33.el6
htcondor-ce-pbs-2.2.4-1.osg33.el6
htcondor-ce-sge-2.2.4-1.osg33.el6
htcondor-ce-slurm-2.2.4-1.osg33.el6
htcondor-ce-view-2.2.4-1.osg33.el6
lcmaps-1.6.6-1.9.osg33.el6
lcmaps-common-devel-1.6.6-1.9.osg33.el6
lcmaps-db-templates-1.6.6-1.9.osg33.el6
lcmaps-debuginfo-1.6.6-1.9.osg33.el6
lcmaps-devel-1.6.6-1.9.osg33.el6
lcmaps-without-gsi-1.6.6-1.9.osg33.el6
lcmaps-without-gsi-devel-1.6.6-1.9.osg33.el6
osg-base-ce-3.3-14.osg33.el6
osg-base-ce-bosco-3.3-14.osg33.el6
osg-base-ce-condor-3.3-14.osg33.el6
osg-base-ce-lsf-3.3-14.osg33.el6
osg-base-ce-pbs-3.3-14.osg33.el6
osg-base-ce-sge-3.3-14.osg33.el6
osg-base-ce-slurm-3.3-14.osg33.el6
osg-ca-certs-updater-1.7-1.osg33.el6
osg-ca-scripts-1.2.2-1.osg33.el6
osg-ce-3.3-14.osg33.el6
osg-ce-bosco-3.3-14.osg33.el6
osg-ce-condor-3.3-14.osg33.el6
osg-ce-lsf-3.3-14.osg33.el6
osg-ce-pbs-3.3-14.osg33.el6
osg-ce-sge-3.3-14.osg33.el6
osg-ce-slurm-3.3-14.osg33.el6
osg-configure-1.10.3-1.osg33.el6
osg-configure-bosco-1.10.3-1.osg33.el6
osg-configure-ce-1.10.3-1.osg33.el6
osg-configure-condor-1.10.3-1.osg33.el6
osg-configure-gateway-1.10.3-1.osg33.el6
osg-configure-gip-1.10.3-1.osg33.el6
osg-configure-gratia-1.10.3-1.osg33.el6
osg-configure-infoservices-1.10.3-1.osg33.el6
osg-configure-lsf-1.10.3-1.osg33.el6
osg-configure-misc-1.10.3-1.osg33.el6
osg-configure-network-1.10.3-1.osg33.el6
osg-configure-pbs-1.10.3-1.osg33.el6
osg-configure-rsv-1.10.3-1.osg33.el6
osg-configure-sge-1.10.3-1.osg33.el6
osg-configure-siteinfo-1.10.3-1.osg33.el6
osg-configure-slurm-1.10.3-1.osg33.el6
osg-configure-squid-1.10.3-1.osg33.el6
osg-configure-tests-1.10.3-1.osg33.el6
osg-gridftp-3.3-6.osg33.el6
osg-htcondor-ce-3.3-14.osg33.el6
osg-htcondor-ce-bosco-3.3-14.osg33.el6
osg-htcondor-ce-condor-3.3-14.osg33.el6
osg-htcondor-ce-lsf-3.3-14.osg33.el6
osg-htcondor-ce-pbs-3.3-14.osg33.el6
osg-htcondor-ce-sge-3.3-14.osg33.el6
osg-htcondor-ce-slurm-3.3-14.osg33.el6
osg-oasis-8-5.osg33.el6
osg-pki-tools-2.1.2-1.osg33.el6
osg-system-profiler-1.4.2-1.osg33.el6
osg-system-profiler-viewer-1.4.2-1.osg33.el6
osg-version-3.3.31-1.osg33.el6
osg-wn-client-3.3-8.osg33.el6
osg-wn-client-glexec-3.3-8.osg33.el6
python2-xrootd-4.8.0-1.osg33.el6
python3-xrootd-4.8.0-1.osg33.el6
xrootd-4.8.0-1.osg33.el6
xrootd-client-4.8.0-1.osg33.el6
xrootd-client-devel-4.8.0-1.osg33.el6
xrootd-client-libs-4.8.0-1.osg33.el6
xrootd-debuginfo-4.8.0-1.osg33.el6
xrootd-devel-4.8.0-1.osg33.el6
xrootd-doc-4.8.0-1.osg33.el6
xrootd-fuse-4.8.0-1.osg33.el6
xrootd-libs-4.8.0-1.osg33.el6
xrootd-private-devel-4.8.0-1.osg33.el6
xrootd-selinux-4.8.0-1.osg33.el6
xrootd-server-4.8.0-1.osg33.el6
xrootd-server-devel-4.8.0-1.osg33.el6
xrootd-server-libs-4.8.0-1.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.35.bosco-1.osg33.el7
blahp-debuginfo-1.18.35.bosco-1.osg33.el7
cvmfs-2.4.4-1.osg33.el7
cvmfs-devel-2.4.4-1.osg33.el7
cvmfs-server-2.4.4-1.osg33.el7
cvmfs-unittests-2.4.4-1.osg33.el7
glideinwms-3.2.20-1.osg33.el7
glideinwms-common-tools-3.2.20-1.osg33.el7
glideinwms-condor-common-config-3.2.20-1.osg33.el7
glideinwms-factory-3.2.20-1.osg33.el7
glideinwms-factory-condor-3.2.20-1.osg33.el7
glideinwms-glidecondor-tools-3.2.20-1.osg33.el7
glideinwms-libs-3.2.20-1.osg33.el7
glideinwms-minimal-condor-3.2.20-1.osg33.el7
glideinwms-usercollector-3.2.20-1.osg33.el7
glideinwms-userschedd-3.2.20-1.osg33.el7
glideinwms-vofrontend-3.2.20-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.20-1.osg33.el7
gridftp-hdfs-1.1.1-1.1.osg33.el7
gridftp-hdfs-debuginfo-1.1.1-1.1.osg33.el7
htcondor-ce-2.2.4-1.osg33.el7
htcondor-ce-bosco-2.2.4-1.osg33.el7
htcondor-ce-client-2.2.4-1.osg33.el7
htcondor-ce-collector-2.2.4-1.osg33.el7
htcondor-ce-condor-2.2.4-1.osg33.el7
htcondor-ce-lsf-2.2.4-1.osg33.el7
htcondor-ce-pbs-2.2.4-1.osg33.el7
htcondor-ce-sge-2.2.4-1.osg33.el7
htcondor-ce-slurm-2.2.4-1.osg33.el7
htcondor-ce-view-2.2.4-1.osg33.el7
lcmaps-1.6.6-1.9.osg33.el7
lcmaps-common-devel-1.6.6-1.9.osg33.el7
lcmaps-db-templates-1.6.6-1.9.osg33.el7
lcmaps-debuginfo-1.6.6-1.9.osg33.el7
lcmaps-devel-1.6.6-1.9.osg33.el7
lcmaps-without-gsi-1.6.6-1.9.osg33.el7
lcmaps-without-gsi-devel-1.6.6-1.9.osg33.el7
osg-base-ce-3.3-14.osg33.el7
osg-base-ce-bosco-3.3-14.osg33.el7
osg-base-ce-condor-3.3-14.osg33.el7
osg-base-ce-lsf-3.3-14.osg33.el7
osg-base-ce-pbs-3.3-14.osg33.el7
osg-base-ce-sge-3.3-14.osg33.el7
osg-base-ce-slurm-3.3-14.osg33.el7
osg-ca-certs-updater-1.7-1.osg33.el7
osg-ca-scripts-1.2.2-1.osg33.el7
osg-ce-3.3-14.osg33.el7
osg-ce-bosco-3.3-14.osg33.el7
osg-ce-condor-3.3-14.osg33.el7
osg-ce-lsf-3.3-14.osg33.el7
osg-ce-pbs-3.3-14.osg33.el7
osg-ce-sge-3.3-14.osg33.el7
osg-ce-slurm-3.3-14.osg33.el7
osg-configure-1.10.3-1.osg33.el7
osg-configure-bosco-1.10.3-1.osg33.el7
osg-configure-ce-1.10.3-1.osg33.el7
osg-configure-condor-1.10.3-1.osg33.el7
osg-configure-gateway-1.10.3-1.osg33.el7
osg-configure-gip-1.10.3-1.osg33.el7
osg-configure-gratia-1.10.3-1.osg33.el7
osg-configure-infoservices-1.10.3-1.osg33.el7
osg-configure-lsf-1.10.3-1.osg33.el7
osg-configure-misc-1.10.3-1.osg33.el7
osg-configure-network-1.10.3-1.osg33.el7
osg-configure-pbs-1.10.3-1.osg33.el7
osg-configure-rsv-1.10.3-1.osg33.el7
osg-configure-sge-1.10.3-1.osg33.el7
osg-configure-siteinfo-1.10.3-1.osg33.el7
osg-configure-slurm-1.10.3-1.osg33.el7
osg-configure-squid-1.10.3-1.osg33.el7
osg-configure-tests-1.10.3-1.osg33.el7
osg-gridftp-3.3-6.osg33.el7
osg-htcondor-ce-3.3-14.osg33.el7
osg-htcondor-ce-bosco-3.3-14.osg33.el7
osg-htcondor-ce-condor-3.3-14.osg33.el7
osg-htcondor-ce-lsf-3.3-14.osg33.el7
osg-htcondor-ce-pbs-3.3-14.osg33.el7
osg-htcondor-ce-sge-3.3-14.osg33.el7
osg-htcondor-ce-slurm-3.3-14.osg33.el7
osg-oasis-8-5.osg33.el7
osg-pki-tools-2.1.2-1.osg33.el7
osg-system-profiler-1.4.2-1.osg33.el7
osg-system-profiler-viewer-1.4.2-1.osg33.el7
osg-version-3.3.31-1.osg33.el7
osg-wn-client-3.3-8.osg33.el7
osg-wn-client-glexec-3.3-8.osg33.el7
python2-xrootd-4.8.0-1.osg33.el7
python3-xrootd-4.8.0-1.osg33.el7
xrootd-4.8.0-1.osg33.el7
xrootd-client-4.8.0-1.osg33.el7
xrootd-client-devel-4.8.0-1.osg33.el7
xrootd-client-libs-4.8.0-1.osg33.el7
xrootd-debuginfo-4.8.0-1.osg33.el7
xrootd-devel-4.8.0-1.osg33.el7
xrootd-doc-4.8.0-1.osg33.el7
xrootd-fuse-4.8.0-1.osg33.el7
xrootd-libs-4.8.0-1.osg33.el7
xrootd-private-devel-4.8.0-1.osg33.el7
xrootd-selinux-4.8.0-1.osg33.el7
xrootd-server-4.8.0-1.osg33.el7
xrootd-server-devel-4.8.0-1.osg33.el7
xrootd-server-libs-4.8.0-1.osg33.el7
```
