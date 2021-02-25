OSG Software Release 3.5.17
===========================

**Release Date:** 2020-06-04    
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

-   [BLAHP 1.18.46](https://github.com/htcondor/BLAH/releases/tag/v1.18.46): better interaction with HTCondor and Slurm
    -   Fix an issue where the slurm binpath always returned scontrol
    -   Python 3 compatibility
    -   Handle extra-quoted arguments to condor\_submit.sh
    -   Expand env vars in configured slurm\_binpath
    -   Fix cluster handling in slurm\_status.py
    -   Introduce blah\_job\_env\_confs for dynamic env var expansion
    -   Add EXIT trap to remove barrier file
    -   Amended file credits for Matt Farrellee
-   [HTCondor 8.8.9](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00007.shtml): Bug fix release
    - Proper tracking of maximum memory used by Docker universe jobs
    - Fixed preempting a GPU slot for a GPU job when all GPUs are in use
    - Fixed a Python crash when queue\_item\_data iterator raises an exception
    - Fixed a bug where slot attribute overrides were ignored
    - Calculates accounting group quota correctly when more than 1 CPU requested
    - Updated HTCondor Annex to accommodate API change for AWS Spot Fleet
    - Fixed a problem where HTCondor would not start on AWS Fargate
    - Fixed where the collector could wait forever for a partial message
    - Fixed streaming output to large files (>2Gb) when using the 32-bit shadow
-   gratia-probe 1.20.13
    -   Fix bug in interacting with Slurm versions earlier than 18
    -   Handle cluster name that contain special characters
-   [VO Package v106](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-106): Fixed WLCG VOMS server host name
-   Upcoming: [HTCondor 8.9.7](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00010.shtml): New feature release
    -    Multiple enhancements in the file transfer code
    -    Support for more regions in s3:// URLs
    -    Much more flexible job router language
    -    Jobs may now specify cuda\_version to match equally-capable GPUs
    -    TOKENS are now called IDTOKENS to differentiate from SCITOKENS
    -    Added the ability to blacklist TOKENS via an expression
    -    Can simultaneously handle Kerberos and OAUTH credentials
    -    The startd supports a remote history query similar to the schedd
    -    condor\_q -submitters now works with accounting groups
    -    Fixed a bug reading service account credentials for Google Compute Engine
-   Upcoming: [GlideinWMS 3.7](https://glideinwms.fnal.gov/doc.v3_7/history.html#development): New feature release
    -   Includes all features and fixes of 3.6.2
    -   Use of HTCondor token-auth for Glideins authentication
    -   Secure logging channel
    -   Refactored glidein\_startup to separate out the code in heredoc sections

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.17%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

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

-   [blahp-1.18.46-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.46-1.osg35.el7)
-   [condor-8.8.9-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.9-1.1.osg35.el7)
-   [gratia-probe-1.20.13-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.13-1.osg35.el7)
-   [vo-client-106-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-106-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp gratia-probe gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer minicondor python2-condor python3-condor vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
blahp-1.18.46-1.osg35.el7
blahp-debuginfo-1.18.46-1.osg35.el7
condor-8.8.9-1.1.osg35.el7
condor-all-8.8.9-1.1.osg35.el7
condor-annex-ec2-8.8.9-1.1.osg35.el7
condor-bosco-8.8.9-1.1.osg35.el7
condor-classads-8.8.9-1.1.osg35.el7
condor-classads-devel-8.8.9-1.1.osg35.el7
condor-debuginfo-8.8.9-1.1.osg35.el7
condor-kbdd-8.8.9-1.1.osg35.el7
condor-procd-8.8.9-1.1.osg35.el7
condor-test-8.8.9-1.1.osg35.el7
condor-vm-gahp-8.8.9-1.1.osg35.el7
gratia-probe-1.20.13-1.osg35.el7
gratia-probe-common-1.20.13-1.osg35.el7
gratia-probe-condor-1.20.13-1.osg35.el7
gratia-probe-condor-events-1.20.13-1.osg35.el7
gratia-probe-dcache-storage-1.20.13-1.osg35.el7
gratia-probe-dcache-storagegroup-1.20.13-1.osg35.el7
gratia-probe-dcache-transfer-1.20.13-1.osg35.el7
gratia-probe-debuginfo-1.20.13-1.osg35.el7
gratia-probe-enstore-storage-1.20.13-1.osg35.el7
gratia-probe-enstore-tapedrive-1.20.13-1.osg35.el7
gratia-probe-enstore-transfer-1.20.13-1.osg35.el7
gratia-probe-glideinwms-1.20.13-1.osg35.el7
gratia-probe-gridftp-transfer-1.20.13-1.osg35.el7
gratia-probe-hadoop-storage-1.20.13-1.osg35.el7
gratia-probe-htcondor-ce-1.20.13-1.osg35.el7
gratia-probe-lsf-1.20.13-1.osg35.el7
gratia-probe-metric-1.20.13-1.osg35.el7
gratia-probe-onevm-1.20.13-1.osg35.el7
gratia-probe-pbs-lsf-1.20.13-1.osg35.el7
gratia-probe-services-1.20.13-1.osg35.el7
gratia-probe-sge-1.20.13-1.osg35.el7
gratia-probe-slurm-1.20.13-1.osg35.el7
gratia-probe-xrootd-storage-1.20.13-1.osg35.el7
gratia-probe-xrootd-transfer-1.20.13-1.osg35.el7
minicondor-8.8.9-1.1.osg35.el7
python2-condor-8.8.9-1.1.osg35.el7
python3-condor-8.8.9-1.1.osg35.el7
vo-client-106-1.osg35.el7
vo-client-dcache-106-1.osg35.el7
vo-client-lcmaps-voms-106-1.osg35.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

-   [blahp-1.18.46-3.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.46-3.osgup.el7)
-   [condor-8.9.7-1.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.7-1.1.osgup.el7)
-   [glideinwms-3.7-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.7-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone minicondor python2-condor python3-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
blahp-1.18.46-3.osgup.el7
blahp-debuginfo-1.18.46-3.osgup.el7
condor-8.9.7-1.1.osgup.el7
condor-all-8.9.7-1.1.osgup.el7
condor-annex-ec2-8.9.7-1.1.osgup.el7
condor-bosco-8.9.7-1.1.osgup.el7
condor-classads-8.9.7-1.1.osgup.el7
condor-classads-devel-8.9.7-1.1.osgup.el7
condor-debuginfo-8.9.7-1.1.osgup.el7
condor-kbdd-8.9.7-1.1.osgup.el7
condor-procd-8.9.7-1.1.osgup.el7
condor-test-8.9.7-1.1.osgup.el7
condor-vm-gahp-8.9.7-1.1.osgup.el7
glideinwms-3.7-1.osgup.el7
glideinwms-common-tools-3.7-1.osgup.el7
glideinwms-condor-common-config-3.7-1.osgup.el7
glideinwms-factory-3.7-1.osgup.el7
glideinwms-factory-condor-3.7-1.osgup.el7
glideinwms-glidecondor-tools-3.7-1.osgup.el7
glideinwms-libs-3.7-1.osgup.el7
glideinwms-minimal-condor-3.7-1.osgup.el7
glideinwms-usercollector-3.7-1.osgup.el7
glideinwms-userschedd-3.7-1.osgup.el7
glideinwms-vofrontend-3.7-1.osgup.el7
glideinwms-vofrontend-standalone-3.7-1.osgup.el7
minicondor-8.9.7-1.1.osgup.el7
python2-condor-8.9.7-1.1.osgup.el7
python3-condor-8.9.7-1.1.osgup.el7
```
