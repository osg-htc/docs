OSG Software Release 3.5.8
===========================

**Release Date:** 2020-01-16    
**Supported OS Versions:** EL7

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 and 3.4 offer a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Summary of Changes
------------------

This release contains:

-   [XRootD 4.11.1](https://github.com/xrootd/xrootd/blob/v4.11.1/docs/ReleaseNotes.txt): Bug fix release
-   VOMS 2.0.14-15: Disable TLS <1.2 and insecure ciphers in VOMS server
-   [HTCondor 8.8.7](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00022.shtml): Bug fix release
-   gratia-probe 1.20.12: Fix silent failure when malformed ClassAd exists
-   osg-xrootd: Enable third party copy and macaroons by default
-   host-ce-tools 0.5-2: Ensure that sudo is installed
-   scitokens-cpp 0.4.0: Support for the WLCG token profile
-   worker-node tarball: Contains 'wget'
-   osg-ce: Minor improvements
-   Moved OSG configuration for gsi-openssh into OSG meta-package
-   Moved OSG configuration for globus-gridftp-server into OSG meta-package
-   Upcoming Repository: [HTCondor 8.9.5](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00000.shtml) feature release

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.8%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

Known Issues
------------

- OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).


Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](/release/release_series#updating-to-osg-35).

For sites using non-RPM worker node client installations, new [tarballs](/worker-node/install-wn-tarball) and
[container images](/worker-node/using-wn-containers) are available:

- Tarball: <https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz>
- Container Images: <https://hub.docker.com/r/opensciencegrid/osg-wn/>

Need Help?
----------

Do you need help with this release? [Contact us for help](/common/help).

Detailed Changes in This Release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list [below](#rpms).

-   [condor-8.8.7-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.7-1.osg35.el7)
-   [globus-gridftp-server-13.20-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.20-1.osg35.el7)
-   [gratia-probe-1.20.12-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.12-1.osg35.el7)
-   [gsi-openssh-7.4p1-4.5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.4p1-4.5.osg35.el7)
-   [hosted-ce-tools-0.5-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.5-2.osg35.el7)
-   [osg-ce-3.5-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.5-4.osg35.el7)
-   [osg-gridftp-3.5-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.5-4.osg35.el7)
-   [osg-gsi-openssh-addons-1.0.0-3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gsi-openssh-addons-1.0.0-3.osg35.el7)
-   [osg-xrootd-3.5-10.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5-10.osg35.el7)
-   [scitokens-cpp-0.4.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.4.0-1.osg35.el7)
-   [voms-2.0.14-1.5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.5.osg35.el7)
-   [xrootd-4.11.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.1-1.osg35.el7)
-   [xrootd-lcmaps-1.7.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.5-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server hosted-ce-tools minicondor osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-gridftp osg-gridftp-hdfs osg-gridftp-xrootd osg-gsi-openssh-addons osg-xrootd osg-xrootd-standalone python2-condor python2-xrootd python3-condor scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
condor-8.8.7-1.osg35.el7
condor-all-8.8.7-1.osg35.el7
condor-annex-ec2-8.8.7-1.osg35.el7
condor-bosco-8.8.7-1.osg35.el7
condor-classads-8.8.7-1.osg35.el7
condor-classads-devel-8.8.7-1.osg35.el7
condor-debuginfo-8.8.7-1.osg35.el7
condor-kbdd-8.8.7-1.osg35.el7
condor-procd-8.8.7-1.osg35.el7
condor-test-8.8.7-1.osg35.el7
condor-vm-gahp-8.8.7-1.osg35.el7
globus-gridftp-server-13.20-1.osg35.el7
globus-gridftp-server-debuginfo-13.20-1.osg35.el7
globus-gridftp-server-devel-13.20-1.osg35.el7
globus-gridftp-server-progs-13.20-1.osg35.el7
gratia-probe-1.20.12-1.osg35.el7
gratia-probe-common-1.20.12-1.osg35.el7
gratia-probe-condor-1.20.12-1.osg35.el7
gratia-probe-condor-events-1.20.12-1.osg35.el7
gratia-probe-dcache-storage-1.20.12-1.osg35.el7
gratia-probe-dcache-storagegroup-1.20.12-1.osg35.el7
gratia-probe-dcache-transfer-1.20.12-1.osg35.el7
gratia-probe-debuginfo-1.20.12-1.osg35.el7
gratia-probe-enstore-storage-1.20.12-1.osg35.el7
gratia-probe-enstore-tapedrive-1.20.12-1.osg35.el7
gratia-probe-enstore-transfer-1.20.12-1.osg35.el7
gratia-probe-glideinwms-1.20.12-1.osg35.el7
gratia-probe-gridftp-transfer-1.20.12-1.osg35.el7
gratia-probe-hadoop-storage-1.20.12-1.osg35.el7
gratia-probe-htcondor-ce-1.20.12-1.osg35.el7
gratia-probe-lsf-1.20.12-1.osg35.el7
gratia-probe-metric-1.20.12-1.osg35.el7
gratia-probe-onevm-1.20.12-1.osg35.el7
gratia-probe-pbs-lsf-1.20.12-1.osg35.el7
gratia-probe-services-1.20.12-1.osg35.el7
gratia-probe-sge-1.20.12-1.osg35.el7
gratia-probe-slurm-1.20.12-1.osg35.el7
gratia-probe-xrootd-storage-1.20.12-1.osg35.el7
gratia-probe-xrootd-transfer-1.20.12-1.osg35.el7
gsi-openssh-7.4p1-4.5.osg35.el7
gsi-openssh-clients-7.4p1-4.5.osg35.el7
gsi-openssh-debuginfo-7.4p1-4.5.osg35.el7
gsi-openssh-server-7.4p1-4.5.osg35.el7
hosted-ce-tools-0.5-2.osg35.el7
minicondor-8.8.7-1.osg35.el7
osg-ce-3.5-4.osg35.el7
osg-ce-bosco-3.5-4.osg35.el7
osg-ce-condor-3.5-4.osg35.el7
osg-ce-lsf-3.5-4.osg35.el7
osg-ce-pbs-3.5-4.osg35.el7
osg-ce-sge-3.5-4.osg35.el7
osg-ce-slurm-3.5-4.osg35.el7
osg-gridftp-3.5-4.osg35.el7
osg-gridftp-hdfs-3.5-4.osg35.el7
osg-gridftp-xrootd-3.5-4.osg35.el7
osg-gsi-openssh-addons-1.0.0-3.osg35.el7
osg-xrootd-3.5-10.osg35.el7
osg-xrootd-standalone-3.5-10.osg35.el7
python2-condor-8.8.7-1.osg35.el7
python2-xrootd-4.11.1-1.osg35.el7
python3-condor-8.8.7-1.osg35.el7
scitokens-cpp-0.4.0-1.osg35.el7
scitokens-cpp-debuginfo-0.4.0-1.osg35.el7
scitokens-cpp-devel-0.4.0-1.osg35.el7
voms-2.0.14-1.5.osg35.el7
voms-clients-cpp-2.0.14-1.5.osg35.el7
voms-debuginfo-2.0.14-1.5.osg35.el7
voms-devel-2.0.14-1.5.osg35.el7
voms-doc-2.0.14-1.5.osg35.el7
voms-server-2.0.14-1.5.osg35.el7
xrootd-4.11.1-1.osg35.el7
xrootd-client-4.11.1-1.osg35.el7
xrootd-client-devel-4.11.1-1.osg35.el7
xrootd-client-libs-4.11.1-1.osg35.el7
xrootd-debuginfo-4.11.1-1.osg35.el7
xrootd-devel-4.11.1-1.osg35.el7
xrootd-doc-4.11.1-1.osg35.el7
xrootd-fuse-4.11.1-1.osg35.el7
xrootd-lcmaps-1.7.5-1.osg35.el7
xrootd-lcmaps-debuginfo-1.7.5-1.osg35.el7
xrootd-libs-4.11.1-1.osg35.el7
xrootd-private-devel-4.11.1-1.osg35.el7
xrootd-selinux-4.11.1-1.osg35.el7
xrootd-server-4.11.1-1.osg35.el7
xrootd-server-devel-4.11.1-1.osg35.el7
xrootd-server-libs-4.11.1-1.osg35.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

-   [blahp-1.18.45-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.45-1.1.osgup.el7)
-   [condor-8.9.5-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.5-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
blahp-1.18.45-1.1.osgup.el7
blahp-debuginfo-1.18.45-1.1.osgup.el7
condor-8.9.5-1.osgup.el7
condor-all-8.9.5-1.osgup.el7
condor-annex-ec2-8.9.5-1.osgup.el7
condor-bosco-8.9.5-1.osgup.el7
condor-classads-8.9.5-1.osgup.el7
condor-classads-devel-8.9.5-1.osgup.el7
condor-debuginfo-8.9.5-1.osgup.el7
condor-kbdd-8.9.5-1.osgup.el7
condor-procd-8.9.5-1.osgup.el7
condor-test-8.9.5-1.osgup.el7
condor-vm-gahp-8.9.5-1.osgup.el7
minicondor-8.9.5-1.osgup.el7
python2-condor-8.9.5-1.osgup.el7
python3-condor-8.9.5-1.osgup.el7
```
