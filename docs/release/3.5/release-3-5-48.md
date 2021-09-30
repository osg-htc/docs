OSG Software Release 3.5.48
===========================

**Release Date:** 2021-09-30  
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

!!! danger "Please update osg-ca-certificates as soon as possible."
    Applications and tools using OpenSSL such as wget, HTCondor, and XRootD,
    will to fail to establish TLS/HTTPS connections to servers using Let's
    Encrypt certificates with a "certificate has expired" message.

This release contains:

-   [osg-ca-certs 1.99](https://github.com/opensciencegrid/osg-certificates/releases/tag/v1.99.igtf.1.112): Remove expired Let's Encrypt CA certificate
-   osg-wn-client: Fix installation issue causes by EPEL's gfal2 update
-   [CVMFS 2.8.2](https://cvmfs.readthedocs.io/en/2.8/cpt-releasenotes.html): Bug fix release
-   cvmfs-x509-helper 2.2-2: Fix a number of issues with SciTokens support
-   vault 1.8.2, htvault-config 1.6, htgettoken 1.6: Minor improvements
-   Upcoming
    -   [GlideinWMS 3.7.5](https://glideinwms.fnal.gov/doc.v3_7_5/history.html#development)
        -   SciTokens, IDTOKENS, and Singularity bug fixes
        -   Support for automounting CVMFS in the Glidein script
    -   [xrootd-multiuser 2.0.2](https://github.com/opensciencegrid/xrootd-multiuser/releases/tag/v2.0.0)
        -   Add support for writing checksums to file extended attributes
    -   [HTCondor 9.0.6](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00021.shtml)
        -   CUDA_VISIBLE_DEVICES can now contain GPU-<uuid> formatted values
        -   Fix a bug that caused jobs to fail when using Singularity versions > 3.7
        -   Fix bugs relating to the transfer of standard output and error logs

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.48%2C3.5.48-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [cvmfs-2.8.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.8.2-1.osg35.el7)
-   [cvmfs-x509-helper-2.2-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-2.2-2.osg35.el7)
-   [htgettoken-1.6-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.6-1.osg35.el7)
-   [htvault-config-1.6-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.6-1.osg35.el7)
-   [osg-ca-certs-1.99-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.99-1.osg35.el7)
-   [osg-oasis-17-5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-17-5.osg35.el7)
-   [osg-wn-client-3.5-5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.5-5.osg35.el7)
-   [vault-1.8.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.8.2-1.osg35.el7)

#### Enterprise Linux 8

-   [cvmfs-2.8.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.8.2-1.osg35.el8)
-   [cvmfs-x509-helper-2.2-2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-2.2-2.osg35.el8)
-   [htgettoken-1.6-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.6-1.osg35.el8)
-   [htvault-config-1.6-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.6-1.osg35.el8)
-   [osg-ca-certs-1.99-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.99-1.osg35.el8)
-   [osg-oasis-17-5.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-17-5.osg35.el8)
-   [osg-wn-client-3.5-5.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.5-5.osg35.el8)
-   [vault-1.8.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.8.2-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cvmfs cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests cvmfs-x509-helper cvmfs-x509-helper-debuginfo htgettoken htvault-config osg-ca-certs osg-oasis osg-wn-client vault 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
cvmfs-2.8.2-1.osg35.el7
cvmfs-devel-2.8.2-1.osg35.el7
cvmfs-ducc-2.8.2-1.osg35.el7
cvmfs-fuse3-2.8.2-1.osg35.el7
cvmfs-server-2.8.2-1.osg35.el7
cvmfs-shrinkwrap-2.8.2-1.osg35.el7
cvmfs-unittests-2.8.2-1.osg35.el7
cvmfs-x509-helper-2.2-2.osg35.el7
cvmfs-x509-helper-debuginfo-2.2-2.osg35.el7
htgettoken-1.6-1.osg35.el7
htvault-config-1.6-1.osg35.el7
osg-ca-certs-1.99-1.osg35.el7
osg-oasis-17-5.osg35.el7
osg-wn-client-3.5-5.osg35.el7
vault-1.8.2-1.osg35.el7
```

#### Enterprise Linux 8

``` file
cvmfs-2.8.2-1.osg35.el8
cvmfs-devel-2.8.2-1.osg35.el8
cvmfs-ducc-2.8.2-1.osg35.el8
cvmfs-fuse3-2.8.2-1.osg35.el8
cvmfs-server-2.8.2-1.osg35.el8
cvmfs-shrinkwrap-2.8.2-1.osg35.el8
cvmfs-unittests-2.8.2-1.osg35.el8
cvmfs-x509-helper-2.2-2.osg35.el8
cvmfs-x509-helper-debuginfo-2.2-2.osg35.el8
cvmfs-x509-helper-debugsource-2.2-2.osg35.el8
htgettoken-1.6-1.osg35.el8
htvault-config-1.6-1.osg35.el8
osg-ca-certs-1.99-1.osg35.el8
osg-oasis-17-5.osg35.el8
osg-wn-client-3.5-5.osg35.el8
vault-1.8.2-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-9.0.6-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.6-1.1.osg35up.el7)
-   [glideinwms-3.7.5-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.7.5-1.osg35up.el7)
-   [xrootd-multiuser-2.0.2-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-2.0.2-1.osg35up.el7)

#### Enterprise Linux 8

-   [condor-9.0.6-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.6-1.1.osg35up.el8)
-   [xrootd-multiuser-2.0.2-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-2.0.2-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-factory-core glideinwms-factory-httpd glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-core glideinwms-vofrontend-httpd glideinwms-vofrontend-standalone minicondor python2-condor python3-condor xrootd-multiuser xrootd-multiuser-debuginfo 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-9.0.6-1.1.osg35up.el7
condor-all-9.0.6-1.1.osg35up.el7
condor-annex-ec2-9.0.6-1.1.osg35up.el7
condor-bosco-9.0.6-1.1.osg35up.el7
condor-classads-9.0.6-1.1.osg35up.el7
condor-classads-devel-9.0.6-1.1.osg35up.el7
condor-credmon-oauth-9.0.6-1.1.osg35up.el7
condor-credmon-vault-9.0.6-1.1.osg35up.el7
condor-debuginfo-9.0.6-1.1.osg35up.el7
condor-devel-9.0.6-1.1.osg35up.el7
condor-kbdd-9.0.6-1.1.osg35up.el7
condor-procd-9.0.6-1.1.osg35up.el7
condor-test-9.0.6-1.1.osg35up.el7
condor-vm-gahp-9.0.6-1.1.osg35up.el7
glideinwms-3.7.5-1.osg35up.el7
glideinwms-common-tools-3.7.5-1.osg35up.el7
glideinwms-condor-common-config-3.7.5-1.osg35up.el7
glideinwms-factory-3.7.5-1.osg35up.el7
glideinwms-factory-condor-3.7.5-1.osg35up.el7
glideinwms-factory-core-3.7.5-1.osg35up.el7
glideinwms-factory-httpd-3.7.5-1.osg35up.el7
glideinwms-glidecondor-tools-3.7.5-1.osg35up.el7
glideinwms-libs-3.7.5-1.osg35up.el7
glideinwms-minimal-condor-3.7.5-1.osg35up.el7
glideinwms-usercollector-3.7.5-1.osg35up.el7
glideinwms-userschedd-3.7.5-1.osg35up.el7
glideinwms-vofrontend-3.7.5-1.osg35up.el7
glideinwms-vofrontend-core-3.7.5-1.osg35up.el7
glideinwms-vofrontend-httpd-3.7.5-1.osg35up.el7
glideinwms-vofrontend-standalone-3.7.5-1.osg35up.el7
minicondor-9.0.6-1.1.osg35up.el7
python2-condor-9.0.6-1.1.osg35up.el7
python3-condor-9.0.6-1.1.osg35up.el7
xrootd-multiuser-2.0.2-1.osg35up.el7
xrootd-multiuser-debuginfo-2.0.2-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
condor-9.0.6-1.1.osg35up.el8
condor-all-9.0.6-1.1.osg35up.el8
condor-annex-ec2-9.0.6-1.1.osg35up.el8
condor-bosco-9.0.6-1.1.osg35up.el8
condor-bosco-debuginfo-9.0.6-1.1.osg35up.el8
condor-classads-9.0.6-1.1.osg35up.el8
condor-classads-debuginfo-9.0.6-1.1.osg35up.el8
condor-classads-devel-9.0.6-1.1.osg35up.el8
condor-classads-devel-debuginfo-9.0.6-1.1.osg35up.el8
condor-credmon-vault-9.0.6-1.1.osg35up.el8
condor-debuginfo-9.0.6-1.1.osg35up.el8
condor-debugsource-9.0.6-1.1.osg35up.el8
condor-devel-9.0.6-1.1.osg35up.el8
condor-kbdd-9.0.6-1.1.osg35up.el8
condor-kbdd-debuginfo-9.0.6-1.1.osg35up.el8
condor-procd-9.0.6-1.1.osg35up.el8
condor-procd-debuginfo-9.0.6-1.1.osg35up.el8
condor-test-9.0.6-1.1.osg35up.el8
condor-test-debuginfo-9.0.6-1.1.osg35up.el8
condor-vm-gahp-9.0.6-1.1.osg35up.el8
condor-vm-gahp-debuginfo-9.0.6-1.1.osg35up.el8
minicondor-9.0.6-1.1.osg35up.el8
python3-condor-9.0.6-1.1.osg35up.el8
python3-condor-debuginfo-9.0.6-1.1.osg35up.el8
xrootd-multiuser-2.0.2-1.osg35up.el8
xrootd-multiuser-debuginfo-2.0.2-1.osg35up.el8
xrootd-multiuser-debugsource-2.0.2-1.osg35up.el8
```
