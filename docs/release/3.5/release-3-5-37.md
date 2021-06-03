OSG Software Release 3.5.37
===========================

**Release Date:** 2021-05-17  
**Supported OS Versions:** EL7, EL8

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 offers a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Summary of Changes
------------------

This release contains:

-   [HTCondor-CE 4.5.2](https://htcondor.github.io/htcondor-ce/v4/installation/htcondor-ce/): Upgrade from version 4.4.1
    -   [HTCondor-CE 4.5.0 Version History](https://github.com/htcondor/htcondor-ce/releases/tag/v4.5.0): New feature release
    -   [HTCondor-CE 4.5.1 Version History](https://github.com/htcondor/htcondor-ce/releases/tag/v4.5.1): Bug fix release
    -   [HTCondor-CE 4.5.2 Version History](https://github.com/htcondor/htcondor-ce/releases/tag/v4.5.2): Bug fix release
-   gratia-probe 1.23.3: Fix problem that could cause pilot hours to be zero for non-HTCondor batch systems
-   [vault 1.7.2](https://github.com/hashicorp/vault/releases/tag/v1.7.2): Security update; fixes CVE-2021-32923. (OSG configuration not vulnerable)
-   osg-gridftp for Enterprise Linux 8
-   Upcoming
    -   [GlideinWMS 3.7.4](https://glideinwms.fnal.gov/doc.v3_7_4/history.html#development): Fixed compatibility issue between 3.7 factories and 3.6.5 frontends

!!! bug "Known Issue"
    - HTCondor-CE 5.1.0: batch system max walltime requests are always set to 3 days.
      Details and workaround can be found in the
      [upstream bug tracker](https://opensciencegrid.atlassian.net/browse/HTCONDOR-506).

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.37%2C3.5.37-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [OSG Docker images](https://hub.docker.com/u/opensciencegrid/) have been updated to contain the latest CA certificates.

Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](../updating-to-osg-35.md).

For sites using non-RPM worker node client installations, new [tarballs](../../worker-node/install-wn-tarball.md) and
[container images](../../worker-node/using-wn-containers.md) are available:

- Tarball: <https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz>
- Container Images: <https://hub.docker.com/r/opensciencegrid/osg-wn/>

Need Help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed Changes in This Release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list [below](#rpms).

#### Enterprise Linux 7

-   [globus-gridftp-server-13.20-1.3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.20-1.3.osg35.el7)
-   [gratia-probe-1.23.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.23.3-1.osg35.el7)
-   [htcondor-ce-4.5.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-4.5.2-1.osg35.el7)
-   [vault-1.7.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.7.2-1.osg35.el7)

#### Enterprise Linux 8

-   [globus-gridftp-osg-extensions-0.4-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.4-1.osg35.el8)
-   [globus-gridftp-server-13.20-1.3.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.20-1.3.osg35.el8)
-   [gratia-probe-1.23.3-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.23.3-1.osg35.el8)
-   [gridftp-dsi-posix-1.4-3.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-dsi-posix-1.4-3.osg35.el8)
-   [lcas-lcmaps-gt4-interface-0.3.1-1.3.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcas-lcmaps-gt4-interface-0.3.1-1.3.osg35.el8)
-   [osg-gridftp-3.5-4.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.5-4.osg35.el8)
-   [vault-1.7.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.7.2-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-osg-pilot-container gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view vault 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
globus-gridftp-server-13.20-1.3.osg35.el7
globus-gridftp-server-debuginfo-13.20-1.3.osg35.el7
globus-gridftp-server-devel-13.20-1.3.osg35.el7
globus-gridftp-server-progs-13.20-1.3.osg35.el7
gratia-probe-1.23.3-1.osg35.el7
gratia-probe-common-1.23.3-1.osg35.el7
gratia-probe-condor-1.23.3-1.osg35.el7
gratia-probe-condor-events-1.23.3-1.osg35.el7
gratia-probe-dcache-storage-1.23.3-1.osg35.el7
gratia-probe-dcache-storagegroup-1.23.3-1.osg35.el7
gratia-probe-dcache-transfer-1.23.3-1.osg35.el7
gratia-probe-enstore-storage-1.23.3-1.osg35.el7
gratia-probe-enstore-tapedrive-1.23.3-1.osg35.el7
gratia-probe-enstore-transfer-1.23.3-1.osg35.el7
gratia-probe-glideinwms-1.23.3-1.osg35.el7
gratia-probe-gridftp-transfer-1.23.3-1.osg35.el7
gratia-probe-hadoop-storage-1.23.3-1.osg35.el7
gratia-probe-htcondor-ce-1.23.3-1.osg35.el7
gratia-probe-lsf-1.23.3-1.osg35.el7
gratia-probe-metric-1.23.3-1.osg35.el7
gratia-probe-onevm-1.23.3-1.osg35.el7
gratia-probe-osg-pilot-container-1.23.3-1.osg35.el7
gratia-probe-pbs-lsf-1.23.3-1.osg35.el7
gratia-probe-services-1.23.3-1.osg35.el7
gratia-probe-sge-1.23.3-1.osg35.el7
gratia-probe-slurm-1.23.3-1.osg35.el7
gratia-probe-xrootd-storage-1.23.3-1.osg35.el7
gratia-probe-xrootd-transfer-1.23.3-1.osg35.el7
htcondor-ce-4.5.2-1.osg35.el7
htcondor-ce-bosco-4.5.2-1.osg35.el7
htcondor-ce-client-4.5.2-1.osg35.el7
htcondor-ce-collector-4.5.2-1.osg35.el7
htcondor-ce-condor-4.5.2-1.osg35.el7
htcondor-ce-lsf-4.5.2-1.osg35.el7
htcondor-ce-pbs-4.5.2-1.osg35.el7
htcondor-ce-sge-4.5.2-1.osg35.el7
htcondor-ce-slurm-4.5.2-1.osg35.el7
htcondor-ce-view-4.5.2-1.osg35.el7
vault-1.7.2-1.osg35.el7
```

#### Enterprise Linux 8

``` file
globus-gridftp-osg-extensions-0.4-1.osg35.el8
globus-gridftp-osg-extensions-debuginfo-0.4-1.osg35.el8
globus-gridftp-osg-extensions-debugsource-0.4-1.osg35.el8
globus-gridftp-server-13.20-1.3.osg35.el8
globus-gridftp-server-debuginfo-13.20-1.3.osg35.el8
globus-gridftp-server-debugsource-13.20-1.3.osg35.el8
globus-gridftp-server-devel-13.20-1.3.osg35.el8
globus-gridftp-server-progs-13.20-1.3.osg35.el8
globus-gridftp-server-progs-debuginfo-13.20-1.3.osg35.el8
gratia-probe-1.23.3-1.osg35.el8
gratia-probe-common-1.23.3-1.osg35.el8
gratia-probe-condor-1.23.3-1.osg35.el8
gratia-probe-condor-events-1.23.3-1.osg35.el8
gratia-probe-dcache-storage-1.23.3-1.osg35.el8
gratia-probe-dcache-storagegroup-1.23.3-1.osg35.el8
gratia-probe-dcache-transfer-1.23.3-1.osg35.el8
gratia-probe-enstore-storage-1.23.3-1.osg35.el8
gratia-probe-enstore-tapedrive-1.23.3-1.osg35.el8
gratia-probe-enstore-transfer-1.23.3-1.osg35.el8
gratia-probe-glideinwms-1.23.3-1.osg35.el8
gratia-probe-gridftp-transfer-1.23.3-1.osg35.el8
gratia-probe-hadoop-storage-1.23.3-1.osg35.el8
gratia-probe-htcondor-ce-1.23.3-1.osg35.el8
gratia-probe-lsf-1.23.3-1.osg35.el8
gratia-probe-metric-1.23.3-1.osg35.el8
gratia-probe-onevm-1.23.3-1.osg35.el8
gratia-probe-osg-pilot-container-1.23.3-1.osg35.el8
gratia-probe-pbs-lsf-1.23.3-1.osg35.el8
gratia-probe-services-1.23.3-1.osg35.el8
gratia-probe-sge-1.23.3-1.osg35.el8
gratia-probe-slurm-1.23.3-1.osg35.el8
gratia-probe-xrootd-storage-1.23.3-1.osg35.el8
gratia-probe-xrootd-transfer-1.23.3-1.osg35.el8
gridftp-dsi-posix-1.4-3.osg35.el8
lcas-lcmaps-gt4-interface-0.3.1-1.3.osg35.el8
lcas-lcmaps-gt4-interface-debuginfo-0.3.1-1.3.osg35.el8
lcas-lcmaps-gt4-interface-debugsource-0.3.1-1.3.osg35.el8
osg-gridftp-3.5-4.osg35.el8
osg-gridftp-hdfs-3.5-4.osg35.el8
osg-gridftp-xrootd-3.5-4.osg35.el8
vault-1.7.2-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [glideinwms-3.7.4-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.7.4-1.osg35up.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-factory-core glideinwms-factory-httpd glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-core glideinwms-vofrontend-httpd glideinwms-vofrontend-standalone 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
glideinwms-3.7.4-1.osg35up.el7
glideinwms-common-tools-3.7.4-1.osg35up.el7
glideinwms-condor-common-config-3.7.4-1.osg35up.el7
glideinwms-factory-3.7.4-1.osg35up.el7
glideinwms-factory-condor-3.7.4-1.osg35up.el7
glideinwms-factory-core-3.7.4-1.osg35up.el7
glideinwms-factory-httpd-3.7.4-1.osg35up.el7
glideinwms-glidecondor-tools-3.7.4-1.osg35up.el7
glideinwms-libs-3.7.4-1.osg35up.el7
glideinwms-minimal-condor-3.7.4-1.osg35up.el7
glideinwms-usercollector-3.7.4-1.osg35up.el7
glideinwms-userschedd-3.7.4-1.osg35up.el7
glideinwms-vofrontend-3.7.4-1.osg35up.el7
glideinwms-vofrontend-core-3.7.4-1.osg35up.el7
glideinwms-vofrontend-httpd-3.7.4-1.osg35up.el7
glideinwms-vofrontend-standalone-3.7.4-1.osg35up.el7
```
