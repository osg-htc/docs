OSG Software Release 3.5.45
===========================

**Release Date:** 2021-08-12  
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

-   Gratia probes 1.24.0
    -   Fix a problem that caused a traceback message in the condor\_meter
    -   Fix a traceback caused by missing LogLevel in ProbeConfig
    -   Ensure that Gratia accounts for SciTokens-based pilots
-   Upcoming
    -   [XRootD 5.3.1](https://github.com/xrootd/xrootd/blob/v5.3.1/docs/ReleaseNotes.txt): Bug fix release
        -   Fix occasional crash under heavy load when using asynchronous I/O

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.45%2C3.5.45-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [OSG Docker images](https://hub.docker.com/u/opensciencegrid/) have been updated to contain the new software.

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

-   [gratia-probe-1.24.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.24.0-1.osg35.el7)

#### Enterprise Linux 8

-   [gratia-probe-1.24.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.24.0-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    gratia-probe gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-osg-pilot-container gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
gratia-probe-1.24.0-1.osg35.el7
gratia-probe-common-1.24.0-1.osg35.el7
gratia-probe-condor-1.24.0-1.osg35.el7
gratia-probe-condor-events-1.24.0-1.osg35.el7
gratia-probe-dcache-storage-1.24.0-1.osg35.el7
gratia-probe-dcache-storagegroup-1.24.0-1.osg35.el7
gratia-probe-dcache-transfer-1.24.0-1.osg35.el7
gratia-probe-enstore-storage-1.24.0-1.osg35.el7
gratia-probe-enstore-tapedrive-1.24.0-1.osg35.el7
gratia-probe-enstore-transfer-1.24.0-1.osg35.el7
gratia-probe-glideinwms-1.24.0-1.osg35.el7
gratia-probe-gridftp-transfer-1.24.0-1.osg35.el7
gratia-probe-hadoop-storage-1.24.0-1.osg35.el7
gratia-probe-htcondor-ce-1.24.0-1.osg35.el7
gratia-probe-lsf-1.24.0-1.osg35.el7
gratia-probe-metric-1.24.0-1.osg35.el7
gratia-probe-onevm-1.24.0-1.osg35.el7
gratia-probe-osg-pilot-container-1.24.0-1.osg35.el7
gratia-probe-pbs-lsf-1.24.0-1.osg35.el7
gratia-probe-services-1.24.0-1.osg35.el7
gratia-probe-sge-1.24.0-1.osg35.el7
gratia-probe-slurm-1.24.0-1.osg35.el7
gratia-probe-xrootd-storage-1.24.0-1.osg35.el7
gratia-probe-xrootd-transfer-1.24.0-1.osg35.el7
```

#### Enterprise Linux 8

``` file
gratia-probe-1.24.0-1.osg35.el8
gratia-probe-common-1.24.0-1.osg35.el8
gratia-probe-condor-1.24.0-1.osg35.el8
gratia-probe-condor-events-1.24.0-1.osg35.el8
gratia-probe-dcache-storage-1.24.0-1.osg35.el8
gratia-probe-dcache-storagegroup-1.24.0-1.osg35.el8
gratia-probe-dcache-transfer-1.24.0-1.osg35.el8
gratia-probe-enstore-storage-1.24.0-1.osg35.el8
gratia-probe-enstore-tapedrive-1.24.0-1.osg35.el8
gratia-probe-enstore-transfer-1.24.0-1.osg35.el8
gratia-probe-glideinwms-1.24.0-1.osg35.el8
gratia-probe-gridftp-transfer-1.24.0-1.osg35.el8
gratia-probe-hadoop-storage-1.24.0-1.osg35.el8
gratia-probe-htcondor-ce-1.24.0-1.osg35.el8
gratia-probe-lsf-1.24.0-1.osg35.el8
gratia-probe-metric-1.24.0-1.osg35.el8
gratia-probe-onevm-1.24.0-1.osg35.el8
gratia-probe-osg-pilot-container-1.24.0-1.osg35.el8
gratia-probe-pbs-lsf-1.24.0-1.osg35.el8
gratia-probe-services-1.24.0-1.osg35.el8
gratia-probe-sge-1.24.0-1.osg35.el8
gratia-probe-slurm-1.24.0-1.osg35.el8
gratia-probe-xrootd-storage-1.24.0-1.osg35.el8
gratia-probe-xrootd-transfer-1.24.0-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [xrootd-5.3.1-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.3.1-1.1.osg35up.el7)

#### Enterprise Linux 8

-   [xrootd-5.3.1-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.3.1-1.1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    python2-xrootd python36-xrootd xrootd xrootd-client xrootd-client-compat xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-scitokens xrootd-selinux xrootd-server xrootd-server-compat xrootd-server-devel xrootd-server-libs xrootd-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
python2-xrootd-5.3.1-1.1.osg35up.el7
python36-xrootd-5.3.1-1.1.osg35up.el7
xrootd-5.3.1-1.1.osg35up.el7
xrootd-client-5.3.1-1.1.osg35up.el7
xrootd-client-compat-5.3.1-1.1.osg35up.el7
xrootd-client-devel-5.3.1-1.1.osg35up.el7
xrootd-client-libs-5.3.1-1.1.osg35up.el7
xrootd-debuginfo-5.3.1-1.1.osg35up.el7
xrootd-devel-5.3.1-1.1.osg35up.el7
xrootd-doc-5.3.1-1.1.osg35up.el7
xrootd-fuse-5.3.1-1.1.osg35up.el7
xrootd-libs-5.3.1-1.1.osg35up.el7
xrootd-private-devel-5.3.1-1.1.osg35up.el7
xrootd-scitokens-5.3.1-1.1.osg35up.el7
xrootd-selinux-5.3.1-1.1.osg35up.el7
xrootd-server-5.3.1-1.1.osg35up.el7
xrootd-server-compat-5.3.1-1.1.osg35up.el7
xrootd-server-devel-5.3.1-1.1.osg35up.el7
xrootd-server-libs-5.3.1-1.1.osg35up.el7
xrootd-voms-5.3.1-1.1.osg35up.el7
```

#### Enterprise Linux 8

``` file
python3-xrootd-5.3.1-1.1.osg35up.el8
python3-xrootd-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-5.3.1-1.1.osg35up.el8
xrootd-client-5.3.1-1.1.osg35up.el8
xrootd-client-compat-5.3.1-1.1.osg35up.el8
xrootd-client-compat-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-client-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-client-devel-5.3.1-1.1.osg35up.el8
xrootd-client-devel-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-client-libs-5.3.1-1.1.osg35up.el8
xrootd-client-libs-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-debugsource-5.3.1-1.1.osg35up.el8
xrootd-devel-5.3.1-1.1.osg35up.el8
xrootd-doc-5.3.1-1.1.osg35up.el8
xrootd-fuse-5.3.1-1.1.osg35up.el8
xrootd-fuse-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-libs-5.3.1-1.1.osg35up.el8
xrootd-libs-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-private-devel-5.3.1-1.1.osg35up.el8
xrootd-scitokens-5.3.1-1.1.osg35up.el8
xrootd-scitokens-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-selinux-5.3.1-1.1.osg35up.el8
xrootd-server-5.3.1-1.1.osg35up.el8
xrootd-server-compat-5.3.1-1.1.osg35up.el8
xrootd-server-compat-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-server-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-server-devel-5.3.1-1.1.osg35up.el8
xrootd-server-libs-5.3.1-1.1.osg35up.el8
xrootd-server-libs-debuginfo-5.3.1-1.1.osg35up.el8
xrootd-voms-5.3.1-1.1.osg35up.el8
xrootd-voms-debuginfo-5.3.1-1.1.osg35up.el8
```
