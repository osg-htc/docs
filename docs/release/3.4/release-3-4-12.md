OSG Software Release 3.4.12
===========================

**Release Date**: 2018-05-10

!!! warning "Required Actions"
    Due to the retirement of `grid.iu.edu` hosts (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/)
    for details), some software packages require updates to reference new hosts.

    1. Update all packages that may contain references to `grid.iu.edu`:
       (Yum will only update already installed packages.)

            :::console
            root@host # yum update osg-ca-certs-updater osg-ca-scripts osg-release osg-release-itb \
                        osg-test\* rsv\*

    1. If you have `rsv` installed, see [this section](#known-issues) below for rsv-specific instructions.

Summary of changes
------------------

This release contains:

-   Updated references to grid.iu.edu with opensciencegrid.org in the following packages:
    -   osg-ca-certs-updater
    -   osg-ca-scripts
    -   osg-release
    -   osg-release-itb
    -   osg-test
    -   rsv
-   [HTCondor-CE 3.1.2](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v3.1.2): Added mapping for Let's Encrypt
-   [GlideinWMS 3.2.22.2](http://glideinwms.fnal.gov/doc.v3_2_22_2/history.html)
    -   Improved interoperation with Singularity
    -   Improved proxy renewal support
-   [XRootD 4.8.3](https://github.com/xrootd/xrootd/blob/v4.8.3/docs/ReleaseNotes.txt)
-   Gratia probes 1.20
    -   More flexible parsing of PBS wall time
    -   Fixed bug in interaction with Slurm
    -   Made ProjectName comparision case insensitive
    -   Dropped GRAM and glexec probes
-   RSV 3.18
    -   Enhanced java version probe to detect Tomcat on Enterprize Linux 7
    -   Disable deprecated probes by default
    -   Drop gratia-consumer probe
-   Upcoming:
    -   [GlideinWMS 3.3.3](http://glideinwms.fnal.gov/doc.v3_3_3/history.html#development)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.12%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore (`_`). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](../../index.md).

Known Issues
------------

Due to the central RSV service retirement (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/) for details),
the new version of RSV will disable the `gratia-consumer` component that reports to the central service.
Please update _all_ RSV packages by running the following command on your RSV host:

``` console
root@host # yum update rsv\*
```

Additionally, if you are using osg-configure, please edit `/etc/osg/config.d/30-rsv.ini` and set the following:

``` file
enable_gratia = False
```

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

-   [glideinwms-3.2.22.2-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.22.2-4.osg34.el6)
-   [gratia-probe-1.20.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.1-1.osg34.el6)
-   [htcondor-ce-3.1.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.1.2-1.osg34.el6)
-   [osg-ca-certs-updater-1.8-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.8-1.osg34.el6)
-   [osg-ca-scripts-1.2.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.3-1.osg34.el6)
-   [osg-configure-2.3.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.3.0-1.osg34.el6)
-   [osg-test-2.2.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.2.0-1.osg34.el6)
-   [osg-version-3.4.12-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.12-1.osg34.el6)
-   [rsv-3.18.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.18.0-1.osg34.el6)
-   [xrootd-4.8.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.3-1.osg34.el6)

#### Enterprise Linux 7

-   [glideinwms-3.2.22.2-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.22.2-4.osg34.el7)
-   [gratia-probe-1.20.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.1-1.osg34.el7)
-   [htcondor-ce-3.1.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.1.2-1.osg34.el7)
-   [osg-ca-certs-updater-1.8-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.8-1.osg34.el7)
-   [osg-ca-scripts-1.2.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.3-1.osg34.el7)
-   [osg-configure-2.3.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.3.0-1.osg34.el7)
-   [osg-test-2.2.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.2.0-1.osg34.el7)
-   [osg-version-3.4.12-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.12-1.osg34.el7)
-   [rsv-3.18.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.18.0-1.osg34.el7)
-   [xrootd-4.8.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.3-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view osg-ca-certs-updater osg-ca-scripts osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-test osg-test-log-viewer osg-version python2-xrootd python3-xrootd rsv rsv-consumers rsv-core rsv-metrics xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
glideinwms-3.2.22.2-4.osg34.el6
glideinwms-common-tools-3.2.22.2-4.osg34.el6
glideinwms-condor-common-config-3.2.22.2-4.osg34.el6
glideinwms-factory-3.2.22.2-4.osg34.el6
glideinwms-factory-condor-3.2.22.2-4.osg34.el6
glideinwms-glidecondor-tools-3.2.22.2-4.osg34.el6
glideinwms-libs-3.2.22.2-4.osg34.el6
glideinwms-minimal-condor-3.2.22.2-4.osg34.el6
glideinwms-usercollector-3.2.22.2-4.osg34.el6
glideinwms-userschedd-3.2.22.2-4.osg34.el6
glideinwms-vofrontend-3.2.22.2-4.osg34.el6
glideinwms-vofrontend-standalone-3.2.22.2-4.osg34.el6
gratia-probe-1.20.1-1.osg34.el6
gratia-probe-common-1.20.1-1.osg34.el6
gratia-probe-condor-1.20.1-1.osg34.el6
gratia-probe-condor-events-1.20.1-1.osg34.el6
gratia-probe-dcache-storage-1.20.1-1.osg34.el6
gratia-probe-dcache-storagegroup-1.20.1-1.osg34.el6
gratia-probe-dcache-transfer-1.20.1-1.osg34.el6
gratia-probe-debuginfo-1.20.1-1.osg34.el6
gratia-probe-enstore-storage-1.20.1-1.osg34.el6
gratia-probe-enstore-tapedrive-1.20.1-1.osg34.el6
gratia-probe-enstore-transfer-1.20.1-1.osg34.el6
gratia-probe-glideinwms-1.20.1-1.osg34.el6
gratia-probe-gridftp-transfer-1.20.1-1.osg34.el6
gratia-probe-hadoop-storage-1.20.1-1.osg34.el6
gratia-probe-htcondor-ce-1.20.1-1.osg34.el6
gratia-probe-lsf-1.20.1-1.osg34.el6
gratia-probe-metric-1.20.1-1.osg34.el6
gratia-probe-onevm-1.20.1-1.osg34.el6
gratia-probe-pbs-lsf-1.20.1-1.osg34.el6
gratia-probe-services-1.20.1-1.osg34.el6
gratia-probe-sge-1.20.1-1.osg34.el6
gratia-probe-slurm-1.20.1-1.osg34.el6
gratia-probe-xrootd-storage-1.20.1-1.osg34.el6
gratia-probe-xrootd-transfer-1.20.1-1.osg34.el6
htcondor-ce-3.1.2-1.osg34.el6
htcondor-ce-bosco-3.1.2-1.osg34.el6
htcondor-ce-client-3.1.2-1.osg34.el6
htcondor-ce-collector-3.1.2-1.osg34.el6
htcondor-ce-condor-3.1.2-1.osg34.el6
htcondor-ce-lsf-3.1.2-1.osg34.el6
htcondor-ce-pbs-3.1.2-1.osg34.el6
htcondor-ce-sge-3.1.2-1.osg34.el6
htcondor-ce-slurm-3.1.2-1.osg34.el6
htcondor-ce-view-3.1.2-1.osg34.el6
osg-ca-certs-updater-1.8-1.osg34.el6
osg-ca-scripts-1.2.3-1.osg34.el6
osg-configure-2.3.0-1.osg34.el6
osg-configure-bosco-2.3.0-1.osg34.el6
osg-configure-ce-2.3.0-1.osg34.el6
osg-configure-condor-2.3.0-1.osg34.el6
osg-configure-gateway-2.3.0-1.osg34.el6
osg-configure-gip-2.3.0-1.osg34.el6
osg-configure-gratia-2.3.0-1.osg34.el6
osg-configure-infoservices-2.3.0-1.osg34.el6
osg-configure-lsf-2.3.0-1.osg34.el6
osg-configure-misc-2.3.0-1.osg34.el6
osg-configure-pbs-2.3.0-1.osg34.el6
osg-configure-rsv-2.3.0-1.osg34.el6
osg-configure-sge-2.3.0-1.osg34.el6
osg-configure-siteinfo-2.3.0-1.osg34.el6
osg-configure-slurm-2.3.0-1.osg34.el6
osg-configure-squid-2.3.0-1.osg34.el6
osg-configure-tests-2.3.0-1.osg34.el6
osg-test-2.2.0-1.osg34.el6
osg-test-log-viewer-2.2.0-1.osg34.el6
osg-version-3.4.12-1.osg34.el6
python2-xrootd-4.8.3-1.osg34.el6
python3-xrootd-4.8.3-1.osg34.el6
rsv-3.18.0-1.osg34.el6
rsv-consumers-3.18.0-1.osg34.el6
rsv-core-3.18.0-1.osg34.el6
rsv-metrics-3.18.0-1.osg34.el6
xrootd-4.8.3-1.osg34.el6
xrootd-client-4.8.3-1.osg34.el6
xrootd-client-devel-4.8.3-1.osg34.el6
xrootd-client-libs-4.8.3-1.osg34.el6
xrootd-debuginfo-4.8.3-1.osg34.el6
xrootd-devel-4.8.3-1.osg34.el6
xrootd-doc-4.8.3-1.osg34.el6
xrootd-fuse-4.8.3-1.osg34.el6
xrootd-libs-4.8.3-1.osg34.el6
xrootd-private-devel-4.8.3-1.osg34.el6
xrootd-selinux-4.8.3-1.osg34.el6
xrootd-server-4.8.3-1.osg34.el6
xrootd-server-devel-4.8.3-1.osg34.el6
xrootd-server-libs-4.8.3-1.osg34.el6
```

#### Enterprise Linux 7

``` file
glideinwms-3.2.22.2-4.osg34.el7
glideinwms-common-tools-3.2.22.2-4.osg34.el7
glideinwms-condor-common-config-3.2.22.2-4.osg34.el7
glideinwms-factory-3.2.22.2-4.osg34.el7
glideinwms-factory-condor-3.2.22.2-4.osg34.el7
glideinwms-glidecondor-tools-3.2.22.2-4.osg34.el7
glideinwms-libs-3.2.22.2-4.osg34.el7
glideinwms-minimal-condor-3.2.22.2-4.osg34.el7
glideinwms-usercollector-3.2.22.2-4.osg34.el7
glideinwms-userschedd-3.2.22.2-4.osg34.el7
glideinwms-vofrontend-3.2.22.2-4.osg34.el7
glideinwms-vofrontend-standalone-3.2.22.2-4.osg34.el7
gratia-probe-1.20.1-1.osg34.el7
gratia-probe-common-1.20.1-1.osg34.el7
gratia-probe-condor-1.20.1-1.osg34.el7
gratia-probe-condor-events-1.20.1-1.osg34.el7
gratia-probe-dcache-storage-1.20.1-1.osg34.el7
gratia-probe-dcache-storagegroup-1.20.1-1.osg34.el7
gratia-probe-dcache-transfer-1.20.1-1.osg34.el7
gratia-probe-debuginfo-1.20.1-1.osg34.el7
gratia-probe-enstore-storage-1.20.1-1.osg34.el7
gratia-probe-enstore-tapedrive-1.20.1-1.osg34.el7
gratia-probe-enstore-transfer-1.20.1-1.osg34.el7
gratia-probe-glideinwms-1.20.1-1.osg34.el7
gratia-probe-gridftp-transfer-1.20.1-1.osg34.el7
gratia-probe-hadoop-storage-1.20.1-1.osg34.el7
gratia-probe-htcondor-ce-1.20.1-1.osg34.el7
gratia-probe-lsf-1.20.1-1.osg34.el7
gratia-probe-metric-1.20.1-1.osg34.el7
gratia-probe-onevm-1.20.1-1.osg34.el7
gratia-probe-pbs-lsf-1.20.1-1.osg34.el7
gratia-probe-services-1.20.1-1.osg34.el7
gratia-probe-sge-1.20.1-1.osg34.el7
gratia-probe-slurm-1.20.1-1.osg34.el7
gratia-probe-xrootd-storage-1.20.1-1.osg34.el7
gratia-probe-xrootd-transfer-1.20.1-1.osg34.el7
htcondor-ce-3.1.2-1.osg34.el7
htcondor-ce-bosco-3.1.2-1.osg34.el7
htcondor-ce-client-3.1.2-1.osg34.el7
htcondor-ce-collector-3.1.2-1.osg34.el7
htcondor-ce-condor-3.1.2-1.osg34.el7
htcondor-ce-lsf-3.1.2-1.osg34.el7
htcondor-ce-pbs-3.1.2-1.osg34.el7
htcondor-ce-sge-3.1.2-1.osg34.el7
htcondor-ce-slurm-3.1.2-1.osg34.el7
htcondor-ce-view-3.1.2-1.osg34.el7
osg-ca-certs-updater-1.8-1.osg34.el7
osg-ca-scripts-1.2.3-1.osg34.el7
osg-configure-2.3.0-1.osg34.el7
osg-configure-bosco-2.3.0-1.osg34.el7
osg-configure-ce-2.3.0-1.osg34.el7
osg-configure-condor-2.3.0-1.osg34.el7
osg-configure-gateway-2.3.0-1.osg34.el7
osg-configure-gip-2.3.0-1.osg34.el7
osg-configure-gratia-2.3.0-1.osg34.el7
osg-configure-infoservices-2.3.0-1.osg34.el7
osg-configure-lsf-2.3.0-1.osg34.el7
osg-configure-misc-2.3.0-1.osg34.el7
osg-configure-pbs-2.3.0-1.osg34.el7
osg-configure-rsv-2.3.0-1.osg34.el7
osg-configure-sge-2.3.0-1.osg34.el7
osg-configure-siteinfo-2.3.0-1.osg34.el7
osg-configure-slurm-2.3.0-1.osg34.el7
osg-configure-squid-2.3.0-1.osg34.el7
osg-configure-tests-2.3.0-1.osg34.el7
osg-test-2.2.0-1.osg34.el7
osg-test-log-viewer-2.2.0-1.osg34.el7
osg-version-3.4.12-1.osg34.el7
python2-xrootd-4.8.3-1.osg34.el7
python3-xrootd-4.8.3-1.osg34.el7
rsv-3.18.0-1.osg34.el7
rsv-consumers-3.18.0-1.osg34.el7
rsv-core-3.18.0-1.osg34.el7
rsv-metrics-3.18.0-1.osg34.el7
xrootd-4.8.3-1.osg34.el7
xrootd-client-4.8.3-1.osg34.el7
xrootd-client-devel-4.8.3-1.osg34.el7
xrootd-client-libs-4.8.3-1.osg34.el7
xrootd-debuginfo-4.8.3-1.osg34.el7
xrootd-devel-4.8.3-1.osg34.el7
xrootd-doc-4.8.3-1.osg34.el7
xrootd-fuse-4.8.3-1.osg34.el7
xrootd-libs-4.8.3-1.osg34.el7
xrootd-private-devel-4.8.3-1.osg34.el7
xrootd-selinux-4.8.3-1.osg34.el7
xrootd-server-4.8.3-1.osg34.el7
xrootd-server-devel-4.8.3-1.osg34.el7
xrootd-server-libs-4.8.3-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [glideinwms-3.3.3-3.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.3.3-3.osgup.el6)

#### Enterprise Linux 7

-   [glideinwms-3.3.3-3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.3.3-3.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
glideinwms-3.3.3-3.osgup.el6
glideinwms-common-tools-3.3.3-3.osgup.el6
glideinwms-condor-common-config-3.3.3-3.osgup.el6
glideinwms-factory-3.3.3-3.osgup.el6
glideinwms-factory-condor-3.3.3-3.osgup.el6
glideinwms-glidecondor-tools-3.3.3-3.osgup.el6
glideinwms-libs-3.3.3-3.osgup.el6
glideinwms-minimal-condor-3.3.3-3.osgup.el6
glideinwms-usercollector-3.3.3-3.osgup.el6
glideinwms-userschedd-3.3.3-3.osgup.el6
glideinwms-vofrontend-3.3.3-3.osgup.el6
glideinwms-vofrontend-standalone-3.3.3-3.osgup.el6
```

#### Enterprise Linux 7

``` file
glideinwms-3.3.3-3.osgup.el7
glideinwms-common-tools-3.3.3-3.osgup.el7
glideinwms-condor-common-config-3.3.3-3.osgup.el7
glideinwms-factory-3.3.3-3.osgup.el7
glideinwms-factory-condor-3.3.3-3.osgup.el7
glideinwms-glidecondor-tools-3.3.3-3.osgup.el7
glideinwms-libs-3.3.3-3.osgup.el7
glideinwms-minimal-condor-3.3.3-3.osgup.el7
glideinwms-usercollector-3.3.3-3.osgup.el7
glideinwms-userschedd-3.3.3-3.osgup.el7
glideinwms-vofrontend-3.3.3-3.osgup.el7
glideinwms-vofrontend-standalone-3.3.3-3.osgup.el7
```
