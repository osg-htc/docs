OSG Software Release 3.5.3
===========================

**Release Date:** 2019-10-17
**Supported OS Versions:** EL7

Summary of Changes
------------------

This release contains:

-   [GlideinWMS 3.6](https://glideinwms.fnal.gov/doc.v3_6/history.html): New stable version
    -   [Manual adjustments required](https://glideinwms.fnal.gov/doc.dev/factory/configuration.html#single_user) when updating a GlideinWMS factory
    -   Compatible with HTCondor 8.6.x, 8.8.x, and 8.9.x
-   [oidc-agent 3.2.6](https://github.com/indigo-dc/oidc-agent/releases/tag/v3.2.6): Tools for managing OpenID Connect tokens
-   [scitokens-cpp 0.3.4](https://github.com/scitokens/scitokens-cpp/pull/14): Add support for Identity and Access Management (IAM)
-   [XRootD 4.10.1](https://github.com/xrootd/xrootd/blob/bced78a4a3f4a1ea34ffd8684cec1d99107b588a/docs/ReleaseNotes.txt): Make third party client check bogus-response proof
-   [HTCondor 8.8.5](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00017.shtml)
    -   Enhanced security with default configuration added by OSG
    -   `bosco_cluster` pulls tarball via HTTPS
    -   Added support for customizations to remote BOSCO installations
-   [osg-configure 3.1.0](https://github.com/opensciencegrid/osg-configure/releases/tag/v3.1.0): Add support for `bosco_cluster` override directories
-   gratia-probe 1.20.11: Updates to work better with Slurm
-   Upcoming repository:
    -   [HTCondor 8.9.3](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00018.shtml)
        -   TOKEN and SSL authentication methods are now enabled by default
        -   The job and global event logs use ISO 8601 formatted dates by default
        -   Added Google Drive multifile transfer plugin
        -   Added upload capability to Box multifile transfer plugin
        -   Added Python bindings to submit a DAG
        -   Python 'JobEventLog' can be pickled to facilitate intermittent readers
        -   2x matchmaking speed for partitionable slots with simple START expressions
        -   Improved the performance of the condor_schedd under heavy load
        -   Reduced the memory footprint of condor_dagman
        -   Initial implementation to record the circumstances of a job's termination

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.3%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

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

-   [condor-8.8.5-1.6.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.5-1.6.osg35.el7)
-   [glideinwms-3.6-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6-1.osg35.el7)
-   [gratia-probe-1.20.11-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.11-1.osg35.el7)
-   [oidc-agent-3.2.6-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=oidc-agent-3.2.6-1.osg35.el7)
-   [osg-configure-3.1.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-3.1.0-1.osg35.el7)
-   [scitokens-cpp-0.3.4-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.3.4-1.osg35.el7)
-   [xrootd-4.10.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.10.1-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer minicondor oidc-agent oidc-agent-debuginfo osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests python2-condor python2-xrootd python3-condor scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
condor-8.8.5-1.6.osg35.el7
condor-all-8.8.5-1.6.osg35.el7
condor-annex-ec2-8.8.5-1.6.osg35.el7
condor-bosco-8.8.5-1.6.osg35.el7
condor-classads-8.8.5-1.6.osg35.el7
condor-classads-devel-8.8.5-1.6.osg35.el7
condor-debuginfo-8.8.5-1.6.osg35.el7
condor-kbdd-8.8.5-1.6.osg35.el7
condor-procd-8.8.5-1.6.osg35.el7
condor-test-8.8.5-1.6.osg35.el7
condor-vm-gahp-8.8.5-1.6.osg35.el7
glideinwms-3.6-1.osg35.el7
glideinwms-common-tools-3.6-1.osg35.el7
glideinwms-condor-common-config-3.6-1.osg35.el7
glideinwms-factory-3.6-1.osg35.el7
glideinwms-factory-condor-3.6-1.osg35.el7
glideinwms-glidecondor-tools-3.6-1.osg35.el7
glideinwms-libs-3.6-1.osg35.el7
glideinwms-minimal-condor-3.6-1.osg35.el7
glideinwms-usercollector-3.6-1.osg35.el7
glideinwms-userschedd-3.6-1.osg35.el7
glideinwms-vofrontend-3.6-1.osg35.el7
glideinwms-vofrontend-standalone-3.6-1.osg35.el7
gratia-probe-1.20.11-1.osg35.el7
gratia-probe-common-1.20.11-1.osg35.el7
gratia-probe-condor-1.20.11-1.osg35.el7
gratia-probe-condor-events-1.20.11-1.osg35.el7
gratia-probe-dcache-storage-1.20.11-1.osg35.el7
gratia-probe-dcache-storagegroup-1.20.11-1.osg35.el7
gratia-probe-dcache-transfer-1.20.11-1.osg35.el7
gratia-probe-debuginfo-1.20.11-1.osg35.el7
gratia-probe-enstore-storage-1.20.11-1.osg35.el7
gratia-probe-enstore-tapedrive-1.20.11-1.osg35.el7
gratia-probe-enstore-transfer-1.20.11-1.osg35.el7
gratia-probe-glideinwms-1.20.11-1.osg35.el7
gratia-probe-gridftp-transfer-1.20.11-1.osg35.el7
gratia-probe-hadoop-storage-1.20.11-1.osg35.el7
gratia-probe-htcondor-ce-1.20.11-1.osg35.el7
gratia-probe-lsf-1.20.11-1.osg35.el7
gratia-probe-metric-1.20.11-1.osg35.el7
gratia-probe-onevm-1.20.11-1.osg35.el7
gratia-probe-pbs-lsf-1.20.11-1.osg35.el7
gratia-probe-services-1.20.11-1.osg35.el7
gratia-probe-sge-1.20.11-1.osg35.el7
gratia-probe-slurm-1.20.11-1.osg35.el7
gratia-probe-xrootd-storage-1.20.11-1.osg35.el7
gratia-probe-xrootd-transfer-1.20.11-1.osg35.el7
minicondor-8.8.5-1.6.osg35.el7
oidc-agent-3.2.6-1.osg35.el7
oidc-agent-debuginfo-3.2.6-1.osg35.el7
osg-configure-3.1.0-1.osg35.el7
osg-configure-bosco-3.1.0-1.osg35.el7
osg-configure-ce-3.1.0-1.osg35.el7
osg-configure-condor-3.1.0-1.osg35.el7
osg-configure-gateway-3.1.0-1.osg35.el7
osg-configure-gip-3.1.0-1.osg35.el7
osg-configure-gratia-3.1.0-1.osg35.el7
osg-configure-infoservices-3.1.0-1.osg35.el7
osg-configure-lsf-3.1.0-1.osg35.el7
osg-configure-misc-3.1.0-1.osg35.el7
osg-configure-pbs-3.1.0-1.osg35.el7
osg-configure-rsv-3.1.0-1.osg35.el7
osg-configure-sge-3.1.0-1.osg35.el7
osg-configure-siteinfo-3.1.0-1.osg35.el7
osg-configure-slurm-3.1.0-1.osg35.el7
osg-configure-squid-3.1.0-1.osg35.el7
osg-configure-tests-3.1.0-1.osg35.el7
python2-condor-8.8.5-1.6.osg35.el7
python2-xrootd-4.10.1-1.osg35.el7
python3-condor-8.8.5-1.6.osg35.el7
scitokens-cpp-0.3.4-1.osg35.el7
scitokens-cpp-debuginfo-0.3.4-1.osg35.el7
scitokens-cpp-devel-0.3.4-1.osg35.el7
xrootd-4.10.1-1.osg35.el7
xrootd-client-4.10.1-1.osg35.el7
xrootd-client-devel-4.10.1-1.osg35.el7
xrootd-client-libs-4.10.1-1.osg35.el7
xrootd-debuginfo-4.10.1-1.osg35.el7
xrootd-devel-4.10.1-1.osg35.el7
xrootd-doc-4.10.1-1.osg35.el7
xrootd-fuse-4.10.1-1.osg35.el7
xrootd-libs-4.10.1-1.osg35.el7
xrootd-private-devel-4.10.1-1.osg35.el7
xrootd-selinux-4.10.1-1.osg35.el7
xrootd-server-4.10.1-1.osg35.el7
xrootd-server-devel-4.10.1-1.osg35.el7
xrootd-server-libs-4.10.1-1.osg35.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

-   [condor-8.9.3-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.3-1.1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
condor-8.9.3-1.1.osgup.el7
condor-all-8.9.3-1.1.osgup.el7
condor-annex-ec2-8.9.3-1.1.osgup.el7
condor-bosco-8.9.3-1.1.osgup.el7
condor-classads-8.9.3-1.1.osgup.el7
condor-classads-devel-8.9.3-1.1.osgup.el7
condor-debuginfo-8.9.3-1.1.osgup.el7
condor-kbdd-8.9.3-1.1.osgup.el7
condor-procd-8.9.3-1.1.osgup.el7
condor-test-8.9.3-1.1.osgup.el7
condor-vm-gahp-8.9.3-1.1.osgup.el7
minicondor-8.9.3-1.1.osgup.el7
python2-condor-8.9.3-1.1.osgup.el7
python3-condor-8.9.3-1.1.osgup.el7
```
