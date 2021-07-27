!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    OSG 3.6 is under active development and is not currently supported for production use.

    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](notes.md)

OSG 3.6 News
============

**Supported OS Versions:** EL7, EL8

The OSG 3.6 release series is a major overhaul of the OSG software stack compared to previous release series with
changes to core protocols used for authentication and data transfer:
bearer tokens, such as [SciTokens](https://scitokens.org/) or WLCG tokens, are used for authentication instead of
GSI proxies and HTTP is used for data transfer instead of GridFTP.

To support these new protocols, OSG 3.6 includes HTCondor 8.9, HTCondor-CE 5, and will shortly include HTCondor 9.0,
GlideinWMS 3.9, and XRootD 5.1.
We also dropped support for the GridFTP, GSI authentication, and Hadoop.

Latest News
-----------

### **July 27, 2021:** High Priority Release

-   HTCondor 9.0.3 and 9.1.1 Security Release. This release contains fixes for important security issues. More details on the security issues are in the vulnerability reports:
    -   [HTCONDOR-2021-0003](http://htcondor.org/security/vulnerabilities/HTCONDOR-2021-0003.html)
    -   [HTCONDOR-2021-0004](http://htcondor.org/security/vulnerabilities/HTCONDOR-2021-0004.html)

### **July 22, 2021:** HTCondor 9.0.2 and blahp 2.1.0

This release of OSG 3.6 contains the following packages:

-   [HTCondor 9.0.2-1.1](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00014.shtml): Bug fix release
    -   HTCondor can be setup to use only FIPS 140-2 approved security functions
    -   If the Singularity test fails, the job returns to the idle state
    -   Can divide GPU memory, when making multiple GPU entries for a single GPU
    -   Startd and Schedd cron job maximum line length increased to 64k bytes
    -   Added first class submit keywords for SciTokens
    -   Fixed MUNGE authentication
-   [blahp 2.1.0](https://github.com/htcondor/BLAH/releases/tag/v2.1.0): Bug fix release
    -   Fix bug where GPU request was not passed onto the batch script
    -   Fix issue where proxy symlinks were not cleaned up by not creating them
    -   Fix bug where output files are overwritten if no transfer output remap
    -   Added support for passing in extra submit arguments from the job ad

### **July 15, 2021:** VO Package v114

This release contains an updated VO Package with the following changes:

-   Fix typo in CLAS12 and EIC VOMS certificate issuers
-   Add LSC files for CERN VO IAM endpoints

### **July 1, 2021:** Frontier Squid 4.15-2.1, Vault 1.7.3, Upcoming: HTCondor 9.1.0

This release of OSG 3.6 contains the following packages:

-   [Frontier Squid 4.15-2.1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): Fix log rotation when not compressing
-   [Vault 1.7.3](https://discuss.hashicorp.com/t/ann-vault-1-7-3-released/25558): Bug fix release
-   htvault-config 1.2: Updated to match vault 1.7.3
-   Upcoming
    -   [HTCondor 9.1.0](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00011.shtml): Start of next feature series

### **June 24, 2021:** HTCondor 9.0.1, HTCondor-CE 5.1.1

This release of OSG 3.6 contains the following packages:

-   [HTCondor 9.0.1-1.2](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00009.shtml): Bug fix release
    -   Fix problem where X.509 proxy refresh kills job when using AES encryption
    -   Fix problem when jobs require a different machine after a failure
    -   Fix problem where a job matched a machine it can't use, delaying job start
    -   Fix exit code and retry checking when a job exits because of a signal
    -   Fix a memory leak in the job router when a job is removed via job policy
    -   Fixed the back-end support for the 'bosco\_cluster --add' command
-   [HTCondor-CE 5.1.1](https://htcondor.github.io/htcondor-ce/v5/releases/#511)
    -   Improve restart time of HTCondor-CE View
    -   Fix bug that caused HTCondor-CE to ignore incoming BatchRuntime requests
    -   Fixed error that occurred during RPM installation of non-HTCondor batch systems regarding missing file batch\_gahp

### **June 16, 2021:** VO Package v113

This release contains an updated VO Package with the following changes:

-   Added new CLAS12 and EIC VO certificates
-   Retired old CLAS12 and EIC VO certificates

### **June 3, 2021:** Vault security update and gratia probes

This release of OSG 3.6 contains the following packages:

-   gratia-probe 1.23.3: Fix problem that could cause pilot hours to be zero for non-HTCondor batch systems
-   [vault 1.7.2](https://github.com/hashicorp/vault/releases/tag/v1.7.2): Security update; fixes CVE-2021-32923. (OSG configuration not vulnerable)

### **May 25, 2021:** IGTF 1.111

This release contains updated CA Certificates based on IGTF 1.108:

-   Removed discontinued NERSC-SLCS CA (US)
-   Removed discontinued MYIFAM CA (MY)

### **May 17, 2021:** HTCondor-CE 5.1.0 and HTCondor 9.0.0

This release of OSG 3.6 contains the following packages:

-   [HTCondor 9.0.0-1.5](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00006.shtml): Major new release with enhanced security
-   [Blahp 2.0.2](https://github.com/htcondor/BLAH/releases): GPU Support, Converted to Python 3
-   [HTCondor-CE 5.1.0](https://htcondor.github.io/htcondor-ce/v5/releases/#510)
    -   Support for Job Router Transform configuration syntax
    -   Credential mapping changes
    -   Converted to Python 3
-   osg-scitokens-mapfile 3: Updated to support HTCondor-CE 5.1.0
-   osg-ce: now requires osg-scitokens-mapfile
-   vault 1.7.1: Update to latest upstream release
-   htvault-config 1.1: Uses yaml configuration files
-   htgettoken 1.2: improved error message handling and bug fixes

### **May 13, 2021:** High Priority Release

This release of OSG 3.6 contains the following packages:

-   [Frontier Squid 4.15-1.2](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES): [Closes multiple security vulnerabilities](http://lists.squid-cache.org/pipermail/squid-announce/2021-May/000127.html)
-   Updated CA certificates based on [IGTF 1.110](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
-   `osg-ca-certs 1.96`: Fixed Let's Encrypt signing policy to accept cross-signing chain

### **April 22, 2021:** CVMFS 2.8.1

This release of OSG 3.6 contains the following packages:

-   [CVMFS 2.8.1](https://cvmfs.readthedocs.io/en/2.8/cpt-releasenotes.html): Bug fix release
-   `gratia-probe 1.23.2`: Converted to use Python 3

### **March 25, 2021:** HTCondor 8.9.11 patches

This release of OSG 3.6 contains the following packages:

-   `HTCondor 8.9.11-1.4` (EL7 only)
    -   Fixes a potential SchedD crash when using malformed tokens
    -   `condor_watch_q` now works on DAGs
-   `vo-client-110-1` with updated WeNMR VOMS information

Additionally, the following packages that were already available in OSG 3.6 for EL7 were released for EL8:

-   `osg-scitokens-mapfile-1-1` containing a new HTCondor-CE mapfile for VO token issuers
-   `vault-1.6.2-1` and `htvault-config-0.5-1` for managing tokens
-   `cvmfs-gateway-1.2.0-1`: note the
    [upstream documentation](https://cvmfs.readthedocs.io/en/latest/cpt-repository-gateway.html#updating-from-cvmfs-gateway-0-2-5)
    for updating from version 0.2.5

### **February 26, 2021:** 3.6 Released

!!! question "Where are GlideinWMS and XRootD?"
    XRootD and GlideinWMS are both absent in the initial OSG 3.6 release:
    we expect major version updates that may require manual intervention for both of these packages so we are holding
    their initial releases in this series until they are ready.

!!! warning "OSG 3.5 end-of-life"
    As a result of this initial OSG 3.6 release, the end-of-life dates have been set for OSG 3.5 per our
    [policy](https://opensciencegrid.org/technology/policy/release-series/):
    regular support will end in **August 2021** and critical bug/security support will end in **February 2022**.


This initial release of the OSG 3.6 release series is based on the packages available in OSG 3.5.31.
One of the major changes in this release series is the shift to token-based authentication from GSI proxy-based
authentication.
Here is a list of the differences in this initial release:

-   GridFTP, GSI, and Hadoop are no longer available
-   Added packages to support token-based authentication
-   [HTCondor 8.9.11](https://htcondor.readthedocs.io/en/latest/version-history/development-release-series-89.html#version-8-9-11):
    initial token support (8.9.12, which will contain default configuration using tokens, was delayed)
-   [HTCondor-CE 5.0.0](https://htcondor.github.io/htcondor-ce/v5/releases/):
    support for Python 3
-   [Gratia Probe 2.0.0](https://github.com/opensciencegrid/gratia-probe/releases/tag/v2.0.0-2):
    replace all batch system probes with the non-root HTCondor-CE probe
-   [OSG-Configure 4.0.0](https://github.com/opensciencegrid/osg-configure/releases/tag/v4.0.0):
    - Deprecated RSV
    - Dropped unused configuration modules and attributes
    - Reorganized some configuration (see [update instructions](updating-to-osg-36.md#osg-configure) for more details)

In addition, we have updated our
[Software Release Policy](https://opensciencegrid.org/technology/policy/software-release/) to follow a rolling
release model.

Finally, our [Docker image releases](https://opensciencegrid.org/technology/policy/container-release/) will more
closely track our OSG 3.6 repositories.

Announcements
-------------

Updates to critical packages also announced by email and are sent to the following recipients and lists:

-   [Registered administrative contacts](../common/registration.md#registering-resources)
-   [osg-general@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-GENERAL)
-   [osg-operations@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-OPERATIONS)
-   [osg-sites@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-SITES)
-   [site-announce@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=site-announce)
-   [software-discuss@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=software-discuss)
OSG Software Release 3.5.42
===========================

**Release Date:** 2021-07-27  
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

-   HTCondor 8.8.14 Security Release. This release contains fixes for important security issues. More details on the security issues are in the vulnerability reports:
    -   [HTCONDOR-2021-0003](http://htcondor.org/security/vulnerabilities/HTCONDOR-2021-0003.html)
-   Upcoming

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.42%2C3.5.42-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [condor-8.8.14-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.14-1.1.osg35.el7)

#### Enterprise Linux 8

-   [condor-8.8.14-1.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.14-1.1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-8.8.14-1.1.osg35.el7
condor-all-8.8.14-1.1.osg35.el7
condor-annex-ec2-8.8.14-1.1.osg35.el7
condor-bosco-8.8.14-1.1.osg35.el7
condor-classads-8.8.14-1.1.osg35.el7
condor-classads-devel-8.8.14-1.1.osg35.el7
condor-debuginfo-8.8.14-1.1.osg35.el7
condor-kbdd-8.8.14-1.1.osg35.el7
condor-procd-8.8.14-1.1.osg35.el7
condor-test-8.8.14-1.1.osg35.el7
condor-vm-gahp-8.8.14-1.1.osg35.el7
minicondor-8.8.14-1.1.osg35.el7
python2-condor-8.8.14-1.1.osg35.el7
python3-condor-8.8.14-1.1.osg35.el7
```

#### Enterprise Linux 8

``` file
condor-8.8.14-1.1.osg35.el8
condor-all-8.8.14-1.1.osg35.el8
condor-annex-ec2-8.8.14-1.1.osg35.el8
condor-bosco-8.8.14-1.1.osg35.el8
condor-bosco-debuginfo-8.8.14-1.1.osg35.el8
condor-classads-8.8.14-1.1.osg35.el8
condor-classads-debuginfo-8.8.14-1.1.osg35.el8
condor-classads-devel-8.8.14-1.1.osg35.el8
condor-classads-devel-debuginfo-8.8.14-1.1.osg35.el8
condor-debuginfo-8.8.14-1.1.osg35.el8
condor-debugsource-8.8.14-1.1.osg35.el8
condor-kbdd-8.8.14-1.1.osg35.el8
condor-kbdd-debuginfo-8.8.14-1.1.osg35.el8
condor-procd-8.8.14-1.1.osg35.el8
condor-procd-debuginfo-8.8.14-1.1.osg35.el8
condor-test-8.8.14-1.1.osg35.el8
condor-test-debuginfo-8.8.14-1.1.osg35.el8
condor-vm-gahp-8.8.14-1.1.osg35.el8
condor-vm-gahp-debuginfo-8.8.14-1.1.osg35.el8
minicondor-8.8.14-1.1.osg35.el8
python3-condor-8.8.14-1.1.osg35.el8
python3-condor-debuginfo-8.8.14-1.1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-9.0.3-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.3-1.osg35up.el7)

#### Enterprise Linux 8

-   [condor-9.0.3-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.3-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-9.0.3-1.osg35up.el7
condor-all-9.0.3-1.osg35up.el7
condor-annex-ec2-9.0.3-1.osg35up.el7
condor-bosco-9.0.3-1.osg35up.el7
condor-classads-9.0.3-1.osg35up.el7
condor-classads-devel-9.0.3-1.osg35up.el7
condor-credmon-oauth-9.0.3-1.osg35up.el7
condor-credmon-vault-9.0.3-1.osg35up.el7
condor-debuginfo-9.0.3-1.osg35up.el7
condor-devel-9.0.3-1.osg35up.el7
condor-kbdd-9.0.3-1.osg35up.el7
condor-procd-9.0.3-1.osg35up.el7
condor-test-9.0.3-1.osg35up.el7
condor-vm-gahp-9.0.3-1.osg35up.el7
minicondor-9.0.3-1.osg35up.el7
python2-condor-9.0.3-1.osg35up.el7
python3-condor-9.0.3-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
condor-9.0.3-1.osg35up.el8
condor-all-9.0.3-1.osg35up.el8
condor-annex-ec2-9.0.3-1.osg35up.el8
condor-bosco-9.0.3-1.osg35up.el8
condor-bosco-debuginfo-9.0.3-1.osg35up.el8
condor-classads-9.0.3-1.osg35up.el8
condor-classads-debuginfo-9.0.3-1.osg35up.el8
condor-classads-devel-9.0.3-1.osg35up.el8
condor-classads-devel-debuginfo-9.0.3-1.osg35up.el8
condor-credmon-vault-9.0.3-1.osg35up.el8
condor-debuginfo-9.0.3-1.osg35up.el8
condor-debugsource-9.0.3-1.osg35up.el8
condor-devel-9.0.3-1.osg35up.el8
condor-kbdd-9.0.3-1.osg35up.el8
condor-kbdd-debuginfo-9.0.3-1.osg35up.el8
condor-procd-9.0.3-1.osg35up.el8
condor-procd-debuginfo-9.0.3-1.osg35up.el8
condor-test-9.0.3-1.osg35up.el8
condor-test-debuginfo-9.0.3-1.osg35up.el8
condor-vm-gahp-9.0.3-1.osg35up.el8
condor-vm-gahp-debuginfo-9.0.3-1.osg35up.el8
minicondor-9.0.3-1.osg35up.el8
python3-condor-9.0.3-1.osg35up.el8
python3-condor-debuginfo-9.0.3-1.osg35up.el8
```
