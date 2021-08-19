OSG Software Release 3.5.34
===========================

**Release Date:** 2021-04-22  
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

-   [CVMFS 2.8.1](https://cvmfs.readthedocs.io/en/2.8/cpt-releasenotes.html): Bug fix release
-   gratia-probe 1.23.2: Converted to use Python 3


These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.34)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.


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

-   [cvmfs-2.8.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.8.1-1.osg35.el7)
-   [gratia-probe-1.23.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.23.2-1.osg35.el7)
-   [osg-oasis-17-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-17-2.osg35.el7)

#### Enterprise Linux 8

-   [cvmfs-2.8.1-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.8.1-1.osg35.el8)
-   [gratia-probe-1.23.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.23.2-1.osg35.el8)
-   [osg-oasis-17-2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-17-2.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cvmfs cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests gratia-probe gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-osg-pilot-container gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer osg-oasis 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
cvmfs-2.8.1-1.osg35.el7
cvmfs-devel-2.8.1-1.osg35.el7
cvmfs-ducc-2.8.1-1.osg35.el7
cvmfs-fuse3-2.8.1-1.osg35.el7
cvmfs-server-2.8.1-1.osg35.el7
cvmfs-shrinkwrap-2.8.1-1.osg35.el7
cvmfs-unittests-2.8.1-1.osg35.el7
gratia-probe-1.23.2-1.osg35.el7
gratia-probe-common-1.23.2-1.osg35.el7
gratia-probe-condor-1.23.2-1.osg35.el7
gratia-probe-condor-events-1.23.2-1.osg35.el7
gratia-probe-dcache-storage-1.23.2-1.osg35.el7
gratia-probe-dcache-storagegroup-1.23.2-1.osg35.el7
gratia-probe-dcache-transfer-1.23.2-1.osg35.el7
gratia-probe-enstore-storage-1.23.2-1.osg35.el7
gratia-probe-enstore-tapedrive-1.23.2-1.osg35.el7
gratia-probe-enstore-transfer-1.23.2-1.osg35.el7
gratia-probe-glideinwms-1.23.2-1.osg35.el7
gratia-probe-gridftp-transfer-1.23.2-1.osg35.el7
gratia-probe-hadoop-storage-1.23.2-1.osg35.el7
gratia-probe-htcondor-ce-1.23.2-1.osg35.el7
gratia-probe-lsf-1.23.2-1.osg35.el7
gratia-probe-metric-1.23.2-1.osg35.el7
gratia-probe-onevm-1.23.2-1.osg35.el7
gratia-probe-osg-pilot-container-1.23.2-1.osg35.el7
gratia-probe-pbs-lsf-1.23.2-1.osg35.el7
gratia-probe-services-1.23.2-1.osg35.el7
gratia-probe-sge-1.23.2-1.osg35.el7
gratia-probe-slurm-1.23.2-1.osg35.el7
gratia-probe-xrootd-storage-1.23.2-1.osg35.el7
gratia-probe-xrootd-transfer-1.23.2-1.osg35.el7
osg-oasis-17-2.osg35.el7
```

#### Enterprise Linux 8

``` file
cvmfs-2.8.1-1.osg35.el8
cvmfs-devel-2.8.1-1.osg35.el8
cvmfs-ducc-2.8.1-1.osg35.el8
cvmfs-fuse3-2.8.1-1.osg35.el8
cvmfs-server-2.8.1-1.osg35.el8
cvmfs-shrinkwrap-2.8.1-1.osg35.el8
cvmfs-unittests-2.8.1-1.osg35.el8
gratia-probe-1.23.2-1.osg35.el8
gratia-probe-common-1.23.2-1.osg35.el8
gratia-probe-condor-1.23.2-1.osg35.el8
gratia-probe-condor-events-1.23.2-1.osg35.el8
gratia-probe-dcache-storage-1.23.2-1.osg35.el8
gratia-probe-dcache-storagegroup-1.23.2-1.osg35.el8
gratia-probe-dcache-transfer-1.23.2-1.osg35.el8
gratia-probe-enstore-storage-1.23.2-1.osg35.el8
gratia-probe-enstore-tapedrive-1.23.2-1.osg35.el8
gratia-probe-enstore-transfer-1.23.2-1.osg35.el8
gratia-probe-glideinwms-1.23.2-1.osg35.el8
gratia-probe-gridftp-transfer-1.23.2-1.osg35.el8
gratia-probe-hadoop-storage-1.23.2-1.osg35.el8
gratia-probe-htcondor-ce-1.23.2-1.osg35.el8
gratia-probe-lsf-1.23.2-1.osg35.el8
gratia-probe-metric-1.23.2-1.osg35.el8
gratia-probe-onevm-1.23.2-1.osg35.el8
gratia-probe-osg-pilot-container-1.23.2-1.osg35.el8
gratia-probe-pbs-lsf-1.23.2-1.osg35.el8
gratia-probe-services-1.23.2-1.osg35.el8
gratia-probe-sge-1.23.2-1.osg35.el8
gratia-probe-slurm-1.23.2-1.osg35.el8
gratia-probe-xrootd-storage-1.23.2-1.osg35.el8
gratia-probe-xrootd-transfer-1.23.2-1.osg35.el8
osg-oasis-17-2.osg35.el8
```

