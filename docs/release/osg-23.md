title: OSG 23 News

OSG 23 News
===========

**Supported OS Versions:** EL8, EL9 (see [this document](supported_platforms.md) for details)

OSG 23 is the first release series that follows our new [support policy](release_series.md), which aims to increase the
regularity of the OSG Software Stack lifecycle.
Moving forward, we plan to distribute a new release series each year, supporting each release series for approximately 2
years total.
As with OSG 3.6, we will continue to release OSG 23 package updates in a rolling fashion.

Additionally, OSG 23 aligns the OSG and HTCondor Software Suite (HTCSS) release cycles:

-   OSG 23 main Yum repositories will contain HTCSS LTS series
    ([HTCondor 23.0](https://htcondor.readthedocs.io/en/23.0/index.html),
    [HTCondor-CE 23.0](https://htcondor.com/htcondor-ce/v23/installation/htcondor-ce/))
-   OSG 23 upcoming Yum repositories will contain HTCSS feature series (HTCondor 23.x, HTCondor-CE 23.x)

Known Issues
------------

The following issues are known to currently affect packages distributed in OSG 23:

### CA Certificates on EL9 ###

EL9 operating systems have a tighter default cryptographic policy that can cause services to reject certificates issued
by SHA-1 signed CAs.
Some CAs in the `igtf-ca-certs` and `osg-ca-certs` packages are affected and you may see service issues if your server
certificate or certificates presented by clients are issued by these CAs.
The Software Team is investigating solutions but in the meantime, we recommend running the following command on XRootD
hosts to accept certificates issued by SHA-1 signed CAs:

```
root@host # update-crypto-policies --set DEFAULT:SHA1
```

!!! note "Do I need to run this on my Compute Entrypoint (CE) hosts?"
    No. At this time, the Software Team believes that CE hosts are unaffected since their clients only present tokens
    and token issuers present modern CAs.


Latest News
-----------

### **May 2, 2024:** XCache 3.7.0, osg-xrootd 23-6
-   [XCache 3.7.0](https://github.com/opensciencegrid/xcache/releases/tag/v3.7.0) and osg-xrootd 23-6
    -   Security update for OSDF caches and origins
        -   Require explicit mapping of DNs to avoid hash collisions
        -   Get mappings for cache and origin DNs from Topology

### **April 15, 2024:** Upcoming: HTCondor 23.6.1
-   Upcoming
    -   [HTCONDOR 23.6.1](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-6-1)
        -   Add the ability to force vanilla universe jobs to run in a container
        -   Add the ability to override the entrypoint for a Docker image
        -   `condor_q -better-analyze` includes units for memory and disk quantities

### **April 11, 2024:** HTCondor 23.0.8 LTS, HTCondor-CE 23.0.8
-   [HTCondor 23.0.8 LTS](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-8)
    -   Fix bug where ssh-agent processes were leaked with grid universe jobs
    -   Fix DAGMan crash when a provisioner node was given a parent
    -   Fix bug that prevented use of ftp: URLs in file transfer
    -   Fix bug where jobs that matched an offline slot never start
-   [HTCondor-CE 23.0.8](https://htcondor.com/htcondor-ce/v23/releases/#2308)
    -   Fix memory request being ignored for whole node jobs

### **April 4, 2024:** XRootD 5.6.9
-   [XRootD 5.6.9](https://listserv.slac.stanford.edu/cgi-bin/wa?A2=ind2403&L=XROOTD-L&P=816)
    -   Various minor bug fixes; see upstream release notes for details

### **March 21, 2024:** osg-scitokens-mapfile 13-2, vo-client 135-1
-   osg-scitokens-mapfile 13-2
    -   Add the new CERN IAM instances for ATLAS and CMS to the default CE token to local user mapfiles
-   vo-client 135-1
    -   Adds LSC files for new LHC IAM hosts for ALICE, ATLAS, CMS, DTEAM, and LHCb 

### **March 14, 2024:** IGTF 1.128, osg-xrootd 23-5, HTCondor 23.0.6 LTS, HTCondor-CE 23.0.6; Upcoming: HTCondor 23.5.2
-   CA certificates based on [IGTF 1.128](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Update CRL download URL for ArmeSFo (AM)
-   osg-xrootd 23-5
    -   Automatically log DN of incoming user
-   [HTCondor 23.0.6 LTS](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-6)
    -   Fix DAGMan where descendants of removed retry-able jobs are marked futile
    -   Ensure the `condor_test_token` works correctly when invoked as root
    -   Fix bug where empty multi-line values could cause a crash
    -   Return proper exit code in `condor_qusers` for errors in formatting options
    -   Fix crash in job router when a job transform is missing an argument
-   Upcoming
    -   [HTCONDOR 23.5.2](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-5-2)
        -   Disable old ClassAd-based syntax by default for the job router
        -   Add ability to use LVM partitions to efficiently manage/enforce disk space
        -   Enable GPU discovery on all Execution Points by default
        -   Use cgroups v1 enforcement to prevent accessing unallocated GPUs
        -   Add new `condor_submit` commands for constraining GPU properties
        -   Add ability to transfer EP's starter log back to the Access Point
        -   Enable use of VOMS attributes when mapping identities of SSL connections
        -   Add the Git SHA of the HTCondor sources to the CondorVersion string

### **February 29, 2024:** XRootD 5.6.8
-   [XRootD 5.6.8](https://github.com/xrootd/xrootd/releases/tag/v5.6.8)
    -   Fix automatic renewal of server certificate with OpenSSL>=1.1
    -   Other minor bug fixes

### **February 27, 2024:** VO Package v134, osg-pki-tools 3.7.1, osg-xrootd 3.6-22, GlideinWMS 3.10.6
-   [VO Package v134](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-134)
    -   Update OSG VOMS certificate used by the LIGO VO
-   osg-pki-tools 3.7.1
    -   Fix `osg-incommon-cert-request` to work on Enterprise Linux 9
-   osg-xrootd 3.6-22
    -   Enable HTTP directory listings for authenticated caches and all origins

### **February 22, 2024:** XRootD 5.6.7, xrdcl-pelican 0.9.3, IGTF 1.127, GlideinWMS 3.10.6, VOMS 2.10.0-0.31.rc3.1; Upcoming: osg-token-renewer 0.9.0, oidc-agent 5.1.0, osdf-server 7.5.6
-   [XRootD 5.6.7](https://github.com/xrootd/xrootd/releases/tag/v5.6.7)
    -   Add pelican:// support
    -   Fix potential segmentation fault in third-party copy
-   [xrdcl-pelican 0.9.3](https://github.com/PelicanPlatform/xrdcl-pelican/releases/tag/v0.9.2)
    -   A Pelican platform-based plugin for the XrdCl interface
-   CA certificates based on [IGTF 1.127](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   added supplementary issuing CA Issuing CA IGTF - C5 - 1 for eMudhra (IN)
    -   removed discontinued QuoVadis CAs: QuoVadis-Grid-ICA-G2,
        QuoVadis-Root-CA2G3, QuoVadis-Root-CA2, and QuoVadis-Root-CA3G3 (BM)
-   VOMS 2.10.0-0.31.rc3.1
    -   Rebuild with latest source to get Enterprise Linux 9 support
-   [GlideinWMS 3.10.6](http://glideinwms.fnal.gov/doc.v3_10_6/history.html): Enterprise Linux 9 only
    -   Knobs to overload memory and CPU
    -   HTCondor tarball downloader
    -   Advertising of Factory's HTCondor submit parameters
    -   Fixed match policy\_file import failure
    -   Fixed syntax error in ClassAd used for gangliad configuration
    -   Fixed writing of missing dict files during upgrade
- Upcoming
    -   [osg-token-renewer 0.9.0](https://github.com/opensciencegrid/osg-token-renewer/releases/tag/v0.9.0)
        -   Utilize oidc-agent 5.1.0 to use new '--skip-check' option
    -   [oidc-agent 5.1.0](https://github.com/indigo-dc/oidc-agent/releases/tag/v5.1.0)
        -   Fix issue where osg-token-renewer would get 'No scopes found' error
        -   Note: This is in upcoming because it requires redoing OIDC token
                  authentication for any existing refresh tokens
    -   osdf-server 7.5.6

### **February 8, 2024:** Frontier-squid 5.9-2.1, HTCondor 23.0.4, htvault-config 1.16, vault 1.15.4, osg-configure 4.1.1-3; Upcoming: HTCondor 23.4.0, Pelican 7.5.0
-   [Frontier-squid 5.9-2.1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt)
    -   Fixed several security vulnerabilities
    -   Improved support for SELinux
-   [HTCondor 23.0.4 LTS](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-4)
    -   `NVIDIA_VISIBLE_DEVICES` environment variable lists full uuid of slot GPUs
    -   Fix problem where some container jobs would see GPUs not assigned to them
    -   Restore condor keyboard monitoring that was broken since HTCondor 23.0.0
    -   In `condor_adstash`, the search engine timeouts now apply to all operations
    -   Ensure the prerequisite perl modules are installed for `condor_gather_info`
-   htvault-config 1.16
    -   Support rate limits
    -   Support '@' in ssh authentication key names
-   vault 1.15.4
    -   Update to latest upstream version
-   osg-configure 4.1.1-3
    -   Create necessary directories for CE on Enterprise Linux 8 and 9
-   Upcoming
    -   [HTCONDOR 23.4.0](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-4-0)
        -   `condor_submit` warns about unit-less `request_disk` and `request_memory`
        -   Separate `condor-credmon-local` RPM package provides local SciTokens issuer
        -   Fix bug where `NEGOTIATOR_SLOT_CONSTRAINT` was ignored since version 23.3.0
        -   The `htcondor` command line tool can process multiple event logs at once
        -   Prevent Docker daemon from keeping a duplicate copy of the job's stdout
    -   [Pelican 7.5.0](https://github.com/PelicanPlatform/pelican/releases/tag/v7.5.0)
        -   The plugin now downloads files in parallel
        -   Improved file unpacking
        -   Origins now support public namespaces

### **January 4, 2024:** IGTF 1.126, ospool-ep 1.0
-   CA certificates based on [IGTF 1.126](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Removed replaced InCommon IGTF Server CA and associated Comodo RSA CA (US)
    -   Removed discontinued UNLPGrid CA (CL)
-   ospool-ep 1.0
    -   [Automatically manage the OSPool EP Docker container with systemd](https://osg-htc.org/docs/resource-sharing/os-backfill-containers/#running-the-container-via-rpm)

### **December 14, 2023:** XRootD 5.6.4, XCache 3.6.0, xrootd-multiuser 2.2.0
-   [XRootD 5.6.4](https://github.com/xrootd/xrootd/releases/tag/v5.6.4)
    -   Fix segfault with macaroons
    -   Fix segfault if pss.origin uses https protocol with no port
    -   Switch from using a certificate file to a certificate chain file
-   [XCache 3.6.0](https://github.com/opensciencegrid/xcache/releases/tag/v3.6.0)
    -   Allow overriding redirector in caches with the environment variable ``XC_REDIRECTOR``
    -   Allow adding local additions to ``Authfile`` and ``scitokens.conf`` file in ``/etc/xrootd``
-   [xrootd-multiuser 2.2.0](https://github.com/opensciencegrid/xrootd-multiuser/releases/tag/v2.2.0-1)
    -   Add ability to enable/disable xrootd-multiuser with the ``XC_ENABLE_MULTIUSER`` environment variable

### **November 30, 2023:** VO Package v133, IGTF 1.125
-   [VO Package v133](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-133)
    -   Update certificates for FNAL and GlueX VOMS servers
-   CA certificates based on [IGTF 1.125](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Updated root certificate ArmeSFo CA with extended validity (AM)

### **November 16, 2023:** VO Package v132, XRootD 5.6.3, osg-ce 23-2, HTCondor-CE 23.0.1, osg-system-profiler 1.7.0
-   [VO Package v132](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-132)
    -   Update certificates for FNAL and SLAC VOMS servers
    -   Update certificates for CLAS12, EIC, GLOW, and HCC
    -   Drop stale certificates for nanohub, STAR, and wisc.edu lz
-   [XRootD 5.6.3](https://github.com/xrootd/xrootd/releases/tag/v5.6.3)
    -   Fix parsing of chunked PUT requests
    -   Add HTTP TPC packet marking
    -   Differentiate between push and pull TPC error messages
    -   Use configured CA path for the SciTokens plugin
-   osg-ce meta package
    -   Correctly set value of `OSG_RELEASE_SERIES` attribute for OSG 23
-   [HTCondor-CE 23.0.1](https://htcondor.com/htcondor-ce/v23/releases/#2301)
    -   Add `condor_ce_test_token` command
-   osg-system-profiler 1.7.0
    -   Add system cryptographic policy
    -   Better XRootD configuration information for generated profile

### **November 2, 2023:** IGTF 1.124, CVMFS 2.11.2, cvmfs-x509-helper 2.4
-   CA certificates based on [IGTF 1.124](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Updated contact meta-data for ArmeSFo authority (AM)
    -   Removed discontinued AEGIS authority (RS)
    -   Removed suspended KENET Root and issuing CAs (KE)
    -   Removed suspended SDG-G2 authority (CN)
    -   Removed suspended CNIC authority (CN)
    -   Removed all four discontinued DigitalTrust CAs operated by their issuer (AE)
-   [CVMFS 2.11.2](https://cvmfs.readthedocs.io/en/2.11/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-11-2)
    -   Bug fix release
-   [cvmfs-x509-helper 2.4](https://github.com/cvmfs-contrib/cvmfs-x509-helper/releases/tag/2.4)
    -   Important bug fix for reading credentials from within an unprivileged user namespace such
        as unprivileged apptainer users.  This is needed due to a change in recent el8 & el9 kernels.

### **October 31, 2023:** HTCondor 23.0.1 LTS; Upcoming: HTCondor 23.1.0
-   [HTCondor 23.0.1 LTS](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-1)
    -   Update to apptainer version 1.2.4 in the HTCondor tarballs
    -   Fix 10.6.0 bug that broke PID namespaces
    -   Fix bug where execution times for ARC CE jobs were 60 times too large
    -   Fix bug where a failed 'Service' node would crash DAGMan
    -   Condor-C and Job Router jobs now get resources provisioned updates
-   Upcoming: [HTCondor 23.1.0](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-1-0)
    -   Enhanced filtering with `condor_watch_q`
    -   The Access Point can now be told to use a non-standard ssh port when
        sending jobs to a remote scheduling system (such as Slurm)
    -   Laid groundwork to allow an Execution Point running without root access
        to accurately limit the job's usage of CPU and Memory in real time via
        Linux kernel cgroups; this is particularly interesting for glidein pools
    -   HTCondor file transfers using HTTPS can now utilize CA certificates
        in a non-standard location
    -   All the fixes from HTCondor 23.0.1

### **October 26, 2023:** CVMFS 2.11.1-1.3, XRootD 5.6.2-2.3, osg-update-vos 1.4.2-2
-   [CVMFS 2.11.1-1.3](https://cvmfs.readthedocs.io/en/2.11/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-11-1)
    -   Important fix to bug impacting osgstorage.org repositories introduced in 2.11.0 --
            all 2.11.0 installations should upgrade urgently
    -   Fix race conditions on concurrent fuse3 mounts
-   XRootD 5.6.2-2.3
    -   Update to -2.3 release to avoid confusion with upstream -2 release
    -   Fix a bug with parsing compound IDs in authfiles
-   osg-update-vos 1.4.2-2
    -   tarballs now contain cpio, so osg-update-vos will work

### **October 3, 2023**: Initial Release

!!! info "OSG 3.6 retirement"
    As part of our transition to our new series release cadence, we are planning to end support for OSG 3.6 on 30 June
    2024 to align with the EL7 end-of-life.
    See our [release series life-cycle](release_series.md#series-life-cycle) table for details.

The initial release of OSG 23 contains [major package updates](#major-package-updates),
[package removals](#package-removals), and [new container images](#container-images).
All other packages may have received minor version and/or packaging updates compared to OSG 3.6.

#### Major package updates ####

This release contains the following major package updates compared to the current OSG 3.6 release:

-   [HTCondor 23.0.0](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-0):
    an update from 10.0.8 in OSG 3.6 main and 10.8.0 in OSG 3.6 upcoming.
    -   New features
        -   A `condor_startd` without any slot types defined will now default to a single partitionable slot rather than a
            number of static slots equal to the number of cores as it was in previous versions.
            The configuration template use `FEATURE : StaticSlots` was added for admins wanting the old behavior.
        -   The `TargetType` attribute is no longer a required attribute in most Classads.
            It is still used for queries to the `condor_collector` and it remains in the Job ClassAd and the Machine
            ClassAd because of older versions of HTCondor require it to be present.
        -   The `-dry-run option` of `condor_submit` will now print the output of a `SEC_CREDENTIAL_STORER script`.
            This can be useful when developing such a script.
        -   Added ability to query epoch history records from the python bindings.
        -   The default value of `SEC_DEFAULT_AUTHENTICATION_METHODS` will now be visible in `condor_config_val`.
            The default for `SEC_*_AUTHENTICATION_METHODS will` inherit from this value, and thus no `READ` and `CLIENT`
            will no longer automatically have `CLAIMTOBE`.
        -   Added new tool `condor_test_token`, which will create a SciToken with configurable contents (including
            issuer) which will be accepted for a short period of time by the local HTCondor daemons.
    -   Bug fixes
        -   Fixed a bug that would cause the condor_startd to crash in rare cases when jobs go on hold
        -   Fixed a bug where if a user-level checkpoint could not be transferred from the starter to the AP, the job
            would go on hold
            Now it will retry, or go back to idle
        -   Fixed a bug where the `CommittedTime` attribute was not set correctly for Docker Universe jobs doing user
            level check-pointing
        -   Fixed a bug where `condor_preen` was deleting files named 'OfflineAds' in the spool directory
        -   Fixed a bug where the blahpd would incorrectly believe that an LSF batch scheduler was not working
        -   Fixed the Execution Point’s detection of whether libvirt is working properly for the VM universe
        -   Fixed a bug where container universe did not work for late materialization jobs submitted to the
            `condor_schedd`
        -   Fixed a bug where the condor_startd could crash if a new match is made at the end a drain request

-   [HTCondor-CE 23.0.0](https://htcondor.com/htcondor-ce/v23/installation/htcondor-ce/):
    an update from 6.0.0 in OSG 3.6 main.

    !!! warning "Job router configuration deprecation"
        The configuration macros `JOB_ROUTER_DEFAULTS`, `JOB_ROUTER_ENTRIES`, `JOB_ROUTER_ENTRIES_CMD`, and
        `JOB_ROUTER_ENTRIES_FILE` are deprecated and will be removed for V24 of HTCondor.
        New configuration syntax for the job router is defined using `JOB_ROUTER_ROUTE_NAMES` and
        `JOB_ROUTER_ROUTE_<name>`.
        Note: The removal will occur during the lifetime of the HTCondor V23 feature series, i.e. the versions that will
        be available in OSG upcoming repositories.

    -   Adds deprecation warnings for old job router configuration syntax
    -   Adds grid CA and host certificate/key locations to default SSL search paths
    -   Verifies that HTCondor-CE can access the local HTCondor's `SPOOL` directory on startup
    -   `condor_ce_upgrade_check` checks compatibility with HTCondor 23
    -   Adds an option to allow running `condor_ce_trace` without a SciToken for testing batch system integration

-   [XRootD 5.6.2](https://github.com/xrootd/xrootd/blob/v5.6.2/docs/ReleaseNotes.txt#L1-L123):
    an update from XRootD 5.5.5 in OSG 3.6 main.
    -  New Features
        -   Add xrdfs cache subcommand to allow for cache evictions
        -   Better handling of unicode strings in the API
        -   Add gsi option to display DN when it differs from entity name
        -   Allow specfication of minimum and maximum creation mode
        -   Make maxfd be configurable (default is 256k)
        -   Include token information in the monitoring stream (phase 1)
        -   Implement a file evict function
        -   Increase default number of parallel event loops to 10
        -   xrdcp: number of parallel copy jobs increased from 4 to 128
        -   Allow XRootD to return trailers indicating failure
        -   Denote Accept-Ranges in HEAD response
        -   Report cache object age for caching proxy mode
        -   Allow origin to be a directory of a locally mounted file system
        -   Implement ability to have the token username as a separate claim
        -   Use SHA-256 for signatures, and message digest algorithm
        -   Allow option '-tokenlib none' to disable token validation
        -   Allow to point to a token file using CGI `'?xrd.ztn=tokenfile'`
    -   Major bug fixes
        -   Fix SEGV in case request has object for opaque data but no content
        -   Fix memory leaks in GSI authentication
        -   Fix chunked PUT creating empty files

-   [GlideinWMS 3.10.5](http://glideinwms.fnal.gov/doc.v3_10_5/history.html):
    an update from 3.10.1 in OSG 3.6 main

    !!! warning "If you are using custom setup scripts..."
        If you are using custom setup scripts please change the use of `glidein_config`:

        -   Custom scripts should always read values via `gconfig_get()`.
            The only exception is the parsing of the line to get the `add_config_line` source file.
        -   `add_config_line` is deprecated in favor of `gconfig_add`.
            `add_config_line` will be removed from future versions.
        -   `add_config_line_safe` is deprecated in favor of `gconfig_add_safe`.
            `gconfig_add` is the recommended method to use also in concurrent scripts.
        -   Custom scripts in Python should `import gconfig.py` (compatible with both Python 2 and 3) and use the
            provided functions or classes: `gconfig_get`, `gconfig_add`, etc.

    -   This release completes EL9 and Python 3.9 support
    -   Added structured logging
    -   Various OSG\_Autoconf improvements
    -   Fixed bugs with Python 3.9 and rrdtools failures with missing ClassAds and monitoring

#### Package Removals ####

The following packages were removed from OSG 23 compared to OSG 3.6:

-  `blahp`: available as part of the `condor` package
-  `oidc-agent`: available in EPEL
-  `python-jwt`: available in EPEL
-  `python-scitokens`: available in EPEL
-  `rrdtool` available from OS repositories

#### Container Images ####

The following container images have new tags for OSG 23:

| Image name                                                   | Tags                       |
|:-------------------------------------------------------------|:---------------------------|
| `hub.opensciencegrid.org/opensciencegrid/atlas-xcache`       | `23-release`, `23-testing` |
| `hub.opensciencegrid.org/opensciencegrid/cms-xcache`         | `23-release`, `23-testing` |
| `hub.opensciencegrid.org/opensciencegrid/frontier-squid`     | `23-release`, `23-testing` |
| `hub.opensciencegrid.org/opensciencegrid/oidc-agent`         | `23-release`, `23-testing` |
| `hub.opensciencegrid.org/opensciencegrid/osgvo-docker-pilot` | `23-release`, `23-testing` |
| `hub.opensciencegrid.org/opensciencegrid/stash-cache`        | `23-release`, `23-testing` |
| `hub.opensciencegrid.org/opensciencegrid/stash-origin`       | `23-release`, `23-testing` |

For example, to retreive an OSG 23 backfill container image, run the following command:

```
docker pull hub.opensciencegrid.org/opensciencegrid/osgvo-docker-pilot:23-release
```

For more details on OSG container images,
see our [policy document](https://osg-htc.org/technology/policy/container-release/).

Announcements
-------------

Updates to critical packages also announced by email and are sent to the following recipients and lists:

-   [Registered administrative contacts](../common/registration.md#registering-resources)
-   [osg-general@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-GENERAL)
-   [osg-operations@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-OPERATIONS)
-   [osg-sites@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-SITES)
-   [site-announce@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=site-announce)
-   [software-discuss@osg-htc.org](https://groups.google.com/a/osg-htc.org/g/software-discuss)
