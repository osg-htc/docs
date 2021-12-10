!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](notes.md).

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

Known Issues
------------

The following issues are known to currently affect packages distributed in OSG 3.6:

### HTCondor-CE ###

-   C-style comments, e.g. `/* comment */`, in `JOB_ROUTER_ENTRIES` will prevent the JobRouter from routing jobs
    ([HTCONDOR-864](https://opensciencegrid.atlassian.net/browse/HTCONDOR-864)).
    For the time being, remove any comments if you are still using the
    [deprecated syntax](https://htcondor.com/htcondor-ce/v5/configuration/job-router-overview#deprecated-syntax).

### XRootD Multiuser ###

-   The OSG 3.6 configuration of XRootD uses the `XrdVoms` plugin, which pass along the entire VOMS FQAN as the
    groupname to the authorization layer (see the section on
    [authorization database file formatting](../data/xrootd/xrootd-authorization.md#formatting)).
    Some characters in VOMS FQANs are not legal in Unix usernames, therefore VOMS attributes mappings are incompatible
    with `xrootd-multiuser`.
    See [XRootD GitHub issue #1538](https://github.com/xrootd/xrootd/issues/1538) for more details.

### XRootD ###

-   If an XRootD 5.3.4 cache interacts with a 5.1 or 5.2 origin and there is an asyncio error, it may crash the origin.
    Please upgrade your origin at your earliest convenience.
    You may turn off asyncio (`async off`) on either end to avoid the problem.

Latest News
-----------

### **December 9, 2021:** XRootD and HTCondor updates

!!!warning "Problem interoperating with older origin servers"
    If an XRootD 5.3.4 cache interacts with a 5.1 or 5.2 origin and there is an asyncio error, it may crash the origin.
    Please upgrade your origin at your earliest convenience.
    You may turn off asyncio (`async off`) on either end to avoid the problem.

-   [XRootD 5.3.4](https://github.com/xrootd/xrootd/blob/v5.3.4/docs/ReleaseNotes.txt)
    -   Fix uncorrectable checksum errors in XCache Origins
-   [HTCondor 9.0.8 LTS](https://htcondor.org/news/HTCondor_9.0.8_released/)
    -   X.509 proxy delegation now works in OSG 3.6
    -   Fix bug where huge values of ImageSize and others would end up negative
    -   Fix bug in how MAX\_JOBS\_PER\_OWNER applied to late materialization jobs
    -   Fix bug where the schedd could choose a slot with insufficient disk space
    -   Fix crash in ClassAd substr() function when the offset is out of range
    -   Fix bug in Kerberos code that can crash on macOS and could leak memory
    -   Fix bug where a job is ignored for 20 minutes if the startd claim fails


### **December 1, 2021:** Initial XRootD release
-   [XRootD 5.3.2](https://github.com/xrootd/xrootd/blob/v5.3.2/docs/ReleaseNotes.txt)
    -   Initial release of XRootD in OSG 3.6
-   XCache 3.0.0
    -   Initial release of XCache in OSG 3.6
-   [HTCondor 9.0.7](https://htcondor.org/news/HTCondor_9.0.7_released/): Bug fix release
    -   Fix bug where condor\_gpu\_discovery could crash with older CUDA libraries
    -   Fix bug where condor\_watch\_q would fail on machines with older kernels
    -   condor\_watch\_q no longer has a limit on the number of job event log files
    -   Fix bug where a startd could crash claiming a slot with p-slot preemption
    -   Fix bug where a job start would not be recorded when a shadow reconnects
-   [VO Package v115](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-115)
    -   Add CMS IAM vomses entry
    -   Update WLCG VO certificate
-   [GlideinWMS 3.9.3](https://glideinwms.fnal.gov/doc.v3_9_3/history.html#development)
    -   Type validation support to the check\_python3\_expr.py script
    -   Drops the encondingSupport.py module and its unit tests
    -   Fixes an encoding problem affecting cloud submissions
-   [Pegasus 5.0.1](https://pegasus.isi.edu/2021/10/07/pegasus-5-0-1-released/)
    -   First OSG release of the Pegasus 5 series
-   Upcoming
    -   [HTCondor 9.3.0](https://htcondor.org/news/HTCondor_9.3.0_released/)
        -   File transfer plugin sample code to aid in developing new plugins
        -   Add generic knob to set the slot user for all slots


### **November 11, 2021:** osg-flock and gratia-probes

-   osg-flock 1.6-3
    -   Update probe configuration to support Open Science Pool
    -   Overhaul configuration for HTCondor 9.0
-   gratia-probe 2.3.3
    -   Add gratia-probe-condor-ap for user job accounting of HTCondor Access Points
    -   Drop unused XRootD transfer probes
    -   Fix default HTCondor-CE probe directory configurations and ownership

### **October 13, 2021:** Initial osg-token-renewer release

-   Initial release of the [osg-token-renewer](https://opensciencegrid.org/docs/other/osg-token-renewer/): a service to manage automatic renewal of bearer tokens from OIDC providers (e.g., CILogon, IAM), intended for use by VO managers
-   [blahp 2.1.3](https://github.com/htcondor/BLAH/releases/tag/v2.1.3): Bug fix release
    -   Include the more efficient LSF status script
    -   Fix status caching on EL7 for PBS, Slurm, and LSF

### **October 5, 2021:** IGTF 1.113

This release contains updated CA Certificates based on [IGTF 1.113](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)

-   Suspended MD-GRID CA due to network resolution issues (MD)

### **September 30, 2021:** Urgent Let's Encrypt CA certificate update

!!! danger "Please update osg-ca-certs as soon as possible."
    Applications and tools using OpenSSL such as wget, HTCondor, and XRootD,
    will to fail to establish TLS/HTTPS connections to servers using Let's
    Encrypt certificates with a "certificate has expired" message.

This release of OSG 3.6 contains the following packages:

-   [osg-ca-certs 1.99](https://github.com/opensciencegrid/osg-certificates/releases/tag/v1.99.igtf.1.112): Remove expired Let's Encrypt CA certificate
-   osg-wn-client: Fix installation issue causes by EPEL's gfal2 update
-   [CVMFS 2.8.2](https://cvmfs.readthedocs.io/en/2.8/cpt-releasenotes.html): Bug fix release
-   cvmfs-x509-helper 2.2-2: Fix a number of issues with SciTokens support
-   [HTCondor 9.0.6](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00021.shtml)
    -   CUDA\_VISIBLE\_DEVICES can now contain GPU-<uuid> formatted values
    -   Fix a bug that caused jobs to fail when using Singularity versions > 3.7
    -   Fix bugs relating to the transfer of standard output and error logs
-   vault 1.8.2, htvault-config 1.6, htgettoken 1.6: Minor improvements
-   Upcoming
    -   [HTCondor 9.2.0](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00023.shtml)
        -   Add DAGMan SERVICE node, used to monitor or report on DAG workflow
        -   Fix problem where proxy delegation to HTCondor versions < 9.1.3 failed
        -   Jobs are now re-run if the execute directory unexpectedly disappears
        -   HTCondor counts the number of files transferred at the submit node
        -   Fix a bug that caused jobs to fail when using Singularity versions > 3.7

### **September 23, 2021:** HTCondor-CE 5.1.2

This release of OSG 3.6 contains the following packages:

-   [HTCondor-CE 5.1.2](https://github.com/htcondor/htcondor-ce/releases/tag/v5.1.2)
    -   Fixed the default memory and CPU requests when using job router transforms
    -   Apply default MaxJobs and MaxJobsIdle when using job router transforms
    -   Improved SciTokens support in submission tools
    -   Fixed --debug flag in condor\_ce\_run
    -   Update configuration verification script to handle job router transforms
    -   Corrected ownership of the HTCondor PER\_JOBS\_HISTORY\_DIR
    -   Fix bug passing maximum wall time requests to the local batch system

### **September 9, 2021:** HTCondor 9.0.5 and blahp 2.1.1

This release of OSG 3.6 contains the following packages:

-   [HTCondor 9.0.5](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00017.shtml): Bug fix release
    -   Other authentication methods are tried if mapping fails using SciTokens
    -   Fix rare crashes from successful condor\_submit, which caused DAGMan issues
    -   Fix bug where ExitCode attribute would be suppressed when OnExitHold fired
    -   condor\_who now suppresses spurious warnings coming from netstat
    -   The online manual now has detailed instructions for installing on MacOS
    -   Fix bug where misconfigured MIG devices would cause no GPUs to be detected
    -   The transfer\_checkpoint\_file list may now include input files
-   [blahp 2.1.1](https://github.com/htcondor/BLAH/releases/tag/v2.1.1): Bug fix release
    -   Add Python 2 support back for Enterprise Linux 7
    -   Allow the user to override system configuration files
    -   Enable flexible configuration via a configuration directory
    -   Fix Slurm resource usage reporting

### **August 16, 2021:** IGTF 1.112

This release contains updated CA Certificates based on [IGTF 1.112](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)

-   Updated ANSPGrid CA with extended validity date (BR)

### **August 12, 2021:** Gratia probes 2.1.0

-   Gratia probes 2.1.0
    -   Fix a problem that caused a traceback message in the condor\_meter
    -   Fix a traceback caused by missing LogLevel in ProbeConfig
    -   Ensure that Gratia accounts for SciTokens-based pilots

### **August 5, 2021:** VOMS Update, htvault-config 1.4, htgettoken 1.3

-   VOMS 2.0.16-1.2 (EL7) and VOMS 2.1.0-0.14.rc2.2 (EL8)
    -   Add IAM and TLS SNI support
-   htvault-config 1.4 and htgettoken 1.3
    -   Improved security through more fine-grained vault tokens and detailed logging
    -   Miscellaneous improvements

### **July 30, 2021:** High Priority Release

-   HTCondor 9.0.4 and 9.1.2 Security Release. This release contains fixes for important security issues. More details on the security issues are in the vulnerability reports:
    -   [HTCONDOR-2021-0003](http://htcondor.org/security/vulnerabilities/HTCONDOR-2021-0003.html)
    -   [HTCONDOR-2021-0004](http://htcondor.org/security/vulnerabilities/HTCONDOR-2021-0004.html)

### **July 27, 2021:** High Priority Release

-   HTCondor 9.0.3 and 9.1.1 Security Release. This release contains fixes for important security issues. More details on the security issues are in the vulnerability reports:
    -   Unfortunately, these releases did not fully mitigate the vulnerability described in HTCONDOR-2021-0003
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

This release contains updated CA Certificates based on [IGTF 1.111](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)

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
