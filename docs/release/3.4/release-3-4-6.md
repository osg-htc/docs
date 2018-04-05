OSG Software Release 3.4.6
==========================

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
-   [HTCondor-CE 3.0.4](https://github.com/opensciencegrid/htcondor-ce/releases): Update from 3.0.2
-   osg-gridftp: add osg-configure-gratia
-   [osg-configure 2.2.3](https://github.com/opensciencegrid/osg-configure/releases/tag/v2.2.3): minor bug fixes

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.6%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note
    OSG 3.4 contains only 64-bit components.

!!! note
    StashCache is supported on EL7 only.

!!! note
    xrootd-lcmaps will remain at 1.2.1-2 on EL6.

!!! note
    OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore ('_'). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](../../).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details`. This warning can safely be ignored.

Updating to the new release
---------------------------

To update to the OSG 3.4 series, please consult the page on [updating between release series](../release_series).

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

-   [blahp-1.18.35.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.35.bosco-1.osg34.el6)
-   [cvmfs-2.4.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.4.4-1.osg34.el6)
-   [glideinwms-3.2.20-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.20-1.osg34.el6)
-   [htcondor-ce-3.0.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.0.4-1.osg34.el6)
-   [osg-ca-certs-updater-1.7-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.7-1.osg34.el6)
-   [osg-ca-scripts-1.2.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.2-1.osg34.el6)
-   [osg-configure-2.2.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.3-1.osg34.el6)
-   [osg-gridftp-3.4-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-4.osg34.el6)
-   [osg-oasis-8-5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-8-5.osg34.el6)
-   [osg-pki-tools-2.1.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-2.1.2-1.osg34.el6)
-   [osg-system-profiler-1.4.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.2-1.osg34.el6)
-   [osg-version-3.4.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.6-1.osg34.el6)
-   [osg-wn-client-3.4-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.4-3.osg34.el6)
-   [xrootd-4.8.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.0-1.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.35.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.35.bosco-1.osg34.el7)
-   [cvmfs-2.4.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.4.4-1.osg34.el7)
-   [glideinwms-3.2.20-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.20-1.osg34.el7)
-   [htcondor-ce-3.0.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.0.4-1.osg34.el7)
-   [osg-ca-certs-updater-1.7-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.7-1.osg34.el7)
-   [osg-ca-scripts-1.2.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.2-1.osg34.el7)
-   [osg-configure-2.2.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.3-1.osg34.el7)
-   [osg-gridftp-3.4-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-4.osg34.el7)
-   [osg-oasis-8-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-8-5.osg34.el7)
-   [osg-pki-tools-2.1.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-2.1.2-1.osg34.el7)
-   [osg-system-profiler-1.4.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.2-1.osg34.el7)
-   [osg-version-3.4.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.6-1.osg34.el7)
-   [osg-wn-client-3.4-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.4-3.osg34.el7)
-   [xrootd-4.8.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.0-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo cvmfs cvmfs-devel cvmfs-server cvmfs-unittests glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs osg-ca-certs osg-ca-certs-updater osg-ca-scripts osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-gridftp osg-gums-config osg-oasis osg-pki-tools osg-system-profiler osg-system-profiler-viewer osg-version osg-wn-client python2-xrootd python3-xrootd vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.35.bosco-1.osg34.el6
blahp-debuginfo-1.18.35.bosco-1.osg34.el6
cvmfs-2.4.4-1.osg34.el6
cvmfs-devel-2.4.4-1.osg34.el6
cvmfs-server-2.4.4-1.osg34.el6
cvmfs-unittests-2.4.4-1.osg34.el6
glideinwms-3.2.20-1.osg34.el6
glideinwms-common-tools-3.2.20-1.osg34.el6
glideinwms-condor-common-config-3.2.20-1.osg34.el6
glideinwms-factory-3.2.20-1.osg34.el6
glideinwms-factory-condor-3.2.20-1.osg34.el6
glideinwms-glidecondor-tools-3.2.20-1.osg34.el6
glideinwms-libs-3.2.20-1.osg34.el6
glideinwms-minimal-condor-3.2.20-1.osg34.el6
glideinwms-usercollector-3.2.20-1.osg34.el6
glideinwms-userschedd-3.2.20-1.osg34.el6
glideinwms-vofrontend-3.2.20-1.osg34.el6
glideinwms-vofrontend-standalone-3.2.20-1.osg34.el6
htcondor-ce-3.0.4-1.osg34.el6
htcondor-ce-bosco-3.0.4-1.osg34.el6
htcondor-ce-client-3.0.4-1.osg34.el6
htcondor-ce-collector-3.0.4-1.osg34.el6
htcondor-ce-condor-3.0.4-1.osg34.el6
htcondor-ce-lsf-3.0.4-1.osg34.el6
htcondor-ce-pbs-3.0.4-1.osg34.el6
htcondor-ce-sge-3.0.4-1.osg34.el6
htcondor-ce-slurm-3.0.4-1.osg34.el6
htcondor-ce-view-3.0.4-1.osg34.el6
osg-ca-certs-updater-1.7-1.osg34.el6
osg-ca-scripts-1.2.2-1.osg34.el6
osg-configure-2.2.3-1.osg34.el6
osg-configure-bosco-2.2.3-1.osg34.el6
osg-configure-ce-2.2.3-1.osg34.el6
osg-configure-condor-2.2.3-1.osg34.el6
osg-configure-gateway-2.2.3-1.osg34.el6
osg-configure-gip-2.2.3-1.osg34.el6
osg-configure-gratia-2.2.3-1.osg34.el6
osg-configure-infoservices-2.2.3-1.osg34.el6
osg-configure-lsf-2.2.3-1.osg34.el6
osg-configure-misc-2.2.3-1.osg34.el6
osg-configure-pbs-2.2.3-1.osg34.el6
osg-configure-rsv-2.2.3-1.osg34.el6
osg-configure-sge-2.2.3-1.osg34.el6
osg-configure-siteinfo-2.2.3-1.osg34.el6
osg-configure-slurm-2.2.3-1.osg34.el6
osg-configure-squid-2.2.3-1.osg34.el6
osg-configure-tests-2.2.3-1.osg34.el6
osg-gridftp-3.4-4.osg34.el6
osg-oasis-8-5.osg34.el6
osg-pki-tools-2.1.2-1.osg34.el6
osg-system-profiler-1.4.2-1.osg34.el6
osg-system-profiler-viewer-1.4.2-1.osg34.el6
osg-version-3.4.6-1.osg34.el6
osg-wn-client-3.4-3.osg34.el6
python2-xrootd-4.8.0-1.osg34.el6
python3-xrootd-4.8.0-1.osg34.el6
xrootd-4.8.0-1.osg34.el6
xrootd-client-4.8.0-1.osg34.el6
xrootd-client-devel-4.8.0-1.osg34.el6
xrootd-client-libs-4.8.0-1.osg34.el6
xrootd-debuginfo-4.8.0-1.osg34.el6
xrootd-devel-4.8.0-1.osg34.el6
xrootd-doc-4.8.0-1.osg34.el6
xrootd-fuse-4.8.0-1.osg34.el6
xrootd-libs-4.8.0-1.osg34.el6
xrootd-private-devel-4.8.0-1.osg34.el6
xrootd-selinux-4.8.0-1.osg34.el6
xrootd-server-4.8.0-1.osg34.el6
xrootd-server-devel-4.8.0-1.osg34.el6
xrootd-server-libs-4.8.0-1.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.35.bosco-1.osg34.el7
blahp-debuginfo-1.18.35.bosco-1.osg34.el7
cvmfs-2.4.4-1.osg34.el7
cvmfs-devel-2.4.4-1.osg34.el7
cvmfs-server-2.4.4-1.osg34.el7
cvmfs-unittests-2.4.4-1.osg34.el7
glideinwms-3.2.20-1.osg34.el7
glideinwms-common-tools-3.2.20-1.osg34.el7
glideinwms-condor-common-config-3.2.20-1.osg34.el7
glideinwms-factory-3.2.20-1.osg34.el7
glideinwms-factory-condor-3.2.20-1.osg34.el7
glideinwms-glidecondor-tools-3.2.20-1.osg34.el7
glideinwms-libs-3.2.20-1.osg34.el7
glideinwms-minimal-condor-3.2.20-1.osg34.el7
glideinwms-usercollector-3.2.20-1.osg34.el7
glideinwms-userschedd-3.2.20-1.osg34.el7
glideinwms-vofrontend-3.2.20-1.osg34.el7
glideinwms-vofrontend-standalone-3.2.20-1.osg34.el7
htcondor-ce-3.0.4-1.osg34.el7
htcondor-ce-bosco-3.0.4-1.osg34.el7
htcondor-ce-client-3.0.4-1.osg34.el7
htcondor-ce-collector-3.0.4-1.osg34.el7
htcondor-ce-condor-3.0.4-1.osg34.el7
htcondor-ce-lsf-3.0.4-1.osg34.el7
htcondor-ce-pbs-3.0.4-1.osg34.el7
htcondor-ce-sge-3.0.4-1.osg34.el7
htcondor-ce-slurm-3.0.4-1.osg34.el7
htcondor-ce-view-3.0.4-1.osg34.el7
osg-ca-certs-updater-1.7-1.osg34.el7
osg-ca-scripts-1.2.2-1.osg34.el7
osg-configure-2.2.3-1.osg34.el7
osg-configure-bosco-2.2.3-1.osg34.el7
osg-configure-ce-2.2.3-1.osg34.el7
osg-configure-condor-2.2.3-1.osg34.el7
osg-configure-gateway-2.2.3-1.osg34.el7
osg-configure-gip-2.2.3-1.osg34.el7
osg-configure-gratia-2.2.3-1.osg34.el7
osg-configure-infoservices-2.2.3-1.osg34.el7
osg-configure-lsf-2.2.3-1.osg34.el7
osg-configure-misc-2.2.3-1.osg34.el7
osg-configure-pbs-2.2.3-1.osg34.el7
osg-configure-rsv-2.2.3-1.osg34.el7
osg-configure-sge-2.2.3-1.osg34.el7
osg-configure-siteinfo-2.2.3-1.osg34.el7
osg-configure-slurm-2.2.3-1.osg34.el7
osg-configure-squid-2.2.3-1.osg34.el7
osg-configure-tests-2.2.3-1.osg34.el7
osg-gridftp-3.4-4.osg34.el7
osg-oasis-8-5.osg34.el7
osg-pki-tools-2.1.2-1.osg34.el7
osg-system-profiler-1.4.2-1.osg34.el7
osg-system-profiler-viewer-1.4.2-1.osg34.el7
osg-version-3.4.6-1.osg34.el7
osg-wn-client-3.4-3.osg34.el7
python2-xrootd-4.8.0-1.osg34.el7
python3-xrootd-4.8.0-1.osg34.el7
xrootd-4.8.0-1.osg34.el7
xrootd-client-4.8.0-1.osg34.el7
xrootd-client-devel-4.8.0-1.osg34.el7
xrootd-client-libs-4.8.0-1.osg34.el7
xrootd-debuginfo-4.8.0-1.osg34.el7
xrootd-devel-4.8.0-1.osg34.el7
xrootd-doc-4.8.0-1.osg34.el7
xrootd-fuse-4.8.0-1.osg34.el7
xrootd-libs-4.8.0-1.osg34.el7
xrootd-private-devel-4.8.0-1.osg34.el7
xrootd-selinux-4.8.0-1.osg34.el7
xrootd-server-4.8.0-1.osg34.el7
xrootd-server-devel-4.8.0-1.osg34.el7
xrootd-server-libs-4.8.0-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.35.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.35.bosco-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.35.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.35.bosco-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.35.bosco-1.osgup.el6
blahp-debuginfo-1.18.35.bosco-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.35.bosco-1.osgup.el7
blahp-debuginfo-1.18.35.bosco-1.osgup.el7
```

