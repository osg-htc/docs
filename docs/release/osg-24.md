title: OSG 24 News

OSG 24 News
===========

**Supported OS Versions:** EL8, EL9 (see [this document](supported_platforms.md) for details)

OSG 24 is the second release series following our [annual release schedule](release_series.md) and includes support for
the ARM CPU architecture.
The initial release includes GlideinWMS 3.10.7, HTCondor 24.0.1, HTCondor 24.1.1, HTCondor-CE 24.0, and XRootD 5.7.0.

OSG 24 will be supported for [approximately two years total](release_series.md#series-life-cycle).

Latest News
-----------

### **May 8, 2025:** IGTF 1.135, Pelican 7.15.3, XRootD 5.8.1-1.3, xrdcl-pelican 1.2.1, xrdhttp-pelican 0.0.6, OpenBao 2.2.0, htvault-config 2.0.0, Decision Engine 2.0.5
-   CA certificates based on [IGTF 1.135](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Updated SlovakGrid trust anchor with extended validity (SK)
    -   Withdrawn discontinued HPCI CA (JP)
-   [Pelican 7.15.3](https://github.com/PelicanPlatform/pelican/releases/tag/v7.15.3)
    -   Fix throttling in cache
    -   Fix bug in metrics collection
-   [XRootD 5.8.1](https://github.com/xrootd/xrootd/releases/tag/v5.8.1)
    -   Packet marking crash and other various bug fixes
-   [xrdcl-pelican 1.2.1](https://github.com/PelicanPlatform/xrdcl-pelican/releases/tag/v1.2.1) - This is an urgent update to caches
    -   Including changes from [xrdcl-pelican 1.1.0](https://github.com/PelicanPlatform/xrdcl-pelican/releases/tag/v1.1.0) and [xrdcl-pelican 1.2.0](https://github.com/PelicanPlatform/xrdcl-pelican/releases/tag/v1.2.0)
-   [xrdhttp-pelican 0.0.6](https://github.com/PelicanPlatform/xrdhttp-pelican/releases/tag/v0.0.6)
    -   Adds XRootD 5.8 support and APIs for cache management
-   [OpenBao 2.2.0](https://openbao.org/docs/release-notes/2-2-0/#220)
    -   Open source replacement for Hashicorp's Vault
-   htvault-config 2.0.0
    -   Take advantage of improved integration with OpenBao
-   HEPCloud's [Decision Engine 2.0.5](https://hepcloud.github.io/decisionengine/release_notes/release_notes_2.0.html) on EL9 only
    -   Initial version in OSG Repositories

### **April 22, 2025:** HTCondor 24.0.7; Upcoming: HTCondor 24.7.3, Pelican 7.15.2
-   [HTCondor 24.0.7](https://htcondor.readthedocs.io/en/24.0/version-history/lts-versions-24-0.html#version-24-0-7)
    -   With delegated cgroups v2, job out-of-memory no longer affects the pilot
    -   HTCondor tarballs now contain Pelican 7.15.1 and Apptainer 1.4.0
    -   Fix inflated cgroups v2 memory usage reporting for Docker jobs
-   [Pelican 7.15.2](https://github.com/PelicanPlatform/pelican/releases/tag/v7.15.2)
    -   Now sanity checks size for client GETs
    -   Enabled multiuser origins to cache public keys for validating tokens
    -   Made Origin throttling configurable
    -   XRootD now uses xldcl-pelican v1.2.0 which contains bug fixes for the cache
-   Upcoming
    -   [HTCondor 24.7.3](https://htcondor.readthedocs.io/en/24.x/version-history/feature-versions-24-x.html#version-24-7-3)
        -   `condor_who` now works for Glideins
        -   Can add arbitrary credentials to be used by the file transfer plugins
        -   Fixed WLCG token generation in the local credmon
        -   Can limit the number of times that a job can be released
        -   EP administrators can enforce no outbound networking for jobs
        -   Add ability to use authentication when fetching Docker images
        -   `condor_watch_q` now displays when file transfer is happening
        -   To provide more consistency, using swap for jobs is disabled by default
        -   With delegated cgroups v2, job out-of-memory no longer affects the pilot
        -   HTCondor tarballs now contain Pelican 7.15.1 and Apptainer 1.4.0
        -   Fix inflated cgroups v2 memory usage reporting for Docker jobs

### **April 10, 2025:** Pelican 7.15.0, vo-client 138-2, osg-ca-cert-updater 2.2, ospool-ep 23-7, frontier-squid 5.9-3.3
-   [Pelican 7.15.0](https://pelicanplatform.org/releases)
    -   Pelican origins can now specify multiple issuers per namespace
    -   Added support for a Federation to have multiple Directors
    -   Director can optionally report cache redirection reasoning
    -   Integrate XRootD OSS statistics
    -   Add API Token Listing endpoint
    -   Client now correctly reports the start time for uploads
    -   Several bug fixes for the client
-   vo-client 138-2
    -   Remove OpenShift Legacy IAM servers for ATLAS and CMS
-   osg-ca-certs-updater 2.2
    -   Now started via systemd timer
-   ospool-ep 24-3 and 23-7
    -   Make ospool-ep service more resilient to Docker service restart
-   frontier-squid 5.9-3.3
    -   Initial support for ARM (no shoal agent support)

### **April 3, 2025:** GlideinWMS 3.10.11
-   [GlideinWMS 3.10.11](https://glideinwms.fnal.gov/doc.v3_10_11/history.html)
    -   New features
        -   Add new knob, `stale_age`, for Factory entries to control Glidein age
        -   Configurable default Apptainer testing image
    -   Bug fixes
        -   More robust custom start-up script execution
        -   Blacklist search by IP address when host command is not available
        -   Unset `CONDOR_INHERIT` before HTCondor start up
    -   See the [CHANGELOG](https://github.com/glideinWMS/glideinwms/blob/master/CHANGELOG.md#v31011-2025-03-24) for important default changes

### **March 27, 2025:** HTCondor 24.0.6, XRootD 5.7.3-1.5, htgettoken 2.2; Upcoming: HTCondor 24.6.1
-   [HTCondor 24.0.6](https://htcondor.readthedocs.io/en/24.0/version-history/lts-versions-24-0.html#version-24-0-6): Important Security Fix
    -   More details on the security issue are in the [Vulnerability Report](https://htcondor.org/security/vulnerabilities/HTCONDOR-2025-0001)
-   XRootD 5.7.3-1.5
    -   Fix gstream configuration processing
    -   Add support for purge plugins
-   htgettoken 2.2
    -   Fix htdecodetoken to work with token files that do not end in a newline
    -   Support args in htgettoken.main() Python entry point
-   Upcoming
    -   [HTCondor 24.6.1](https://htcondor.readthedocs.io/en/24.x/version-history/feature-versions-24-x.html#version-24-6-1): Important Security Fix
        -   More details on the security issue are in the [Vulnerability Report](https://htcondor.org/security/vulnerabilities/HTCONDOR-2025-0001)

### **March 13, 2025:** IGTF-1.134, osg-pki-tools 3.7.2, xrdhttp-pelican 0.0.3, Pelican 7.14.1; Upcoming: GlideinWMS 3.11.0
-   CA certificates based on [IGTF 1.134](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   New ANSPGrid CA 2 roll-over for root-issuer key pair (BR)
    -   Withdrawn discontinued AC-GRID-FR series authorities (FR)
-   osg-pki-tools 3.7.2
    -   Fix bug sometimes preventing certificate retrieval with `osg-incommon-cert-request`
    -   Add `python3-m2crpyto` and `python3-urllib3` as runtime requirements
-   xrdhttp-pelican 0.0.3: Support Pelican 7.14+
-   [Pelican 7.14.1](https://github.com/PelicanPlatform/pelican/releases/tag/v7.14.0)
-   Upcoming
    -   [GlideinWMS 3.11.0](https://glideinwms.fnal.gov/doc.v3_11_0/history.html)
        -   Credentials Refactoring
            -   Introduced new hierarchical credential classes
            -   Added new security parameters that are handled independently of credentials
            -   Introduced the a new generators framework that supports credentials and parameters generation
            -   Introduced built-in generators such as RoundRobinGenerator and LegacyGenerator
            -   Reintroduced credential renewal scripts (creation_script and update_frequency parameters)
        -   Changed Defaults / Behaviors
            -   Glideclient advertising is now skipped if there are no Glideins to request or actively running in a given group

### **February 27, 2025:** XRootD 5.7.3, CVMFS 2.12.6, IGTF 1.133, OSG Token Renewer 0.9.0, OSPool EP 24-2, Pelican 7.13.0
- [XRootD v5.7.3](https://github.com/xrootd/xrootd/releases/tag/v5.7.3)
    - Various major and minor bugfixes
- [CVMFS 2.12.6](https://cvmfs.readthedocs.io/en/stable/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-12-6-2-12-5)
    - \[client\] Revert `CVMFS_PATCH_LEVEL` to 0 for `check_cvmfs.sh`
    - \[rpm\] fix package install on wsl2 and other non-systemd platforms
- CA certificates based on [IGTF 1.133](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    - Updated re-issued GridCanada root with extended validity period (CA)
    - Added GEANT TCS Generation 5 TLS and Auth ICAs and corresponding HARICA 
      and private trust roots (EU)
    - updated SHA-256 root CA for RDIG mitigating EL9/FedoraCore deprication
    - MARGI put on hold due to domainname resolution issues (MK)
- OSG Token Renewer 0.9.0
    - Move the previously releasesd osg-upcoming package into osg-main
- OSPool EP 24-2
    - Update docker launch script to support providing NVIDIA GPU Resources
-   [Pelican 7.13.0](https://github.com/PelicanPlatform/pelican/releases/tag/v7.13.0)


### **February 13, 2025:** VO Package v138-1, GlideinWMS 3.10.10, XRootD Monitoring Shoveler 1.4.0, XRDCL Pelican 1.0.5
-   [VO Package v138-1](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-138)
    - Include voms-cms-auth.cern.ch in `/etc/vomses`
    - Remove `{lcg-,}voms2.cern.ch` LSC files and from `/etc/vomses`
-   [GlideinWMS 3.10.10](https://glideinwms.fnal.gov/doc.v3_10_10/history.html)
    - Now using also Apptainer included in the HTCondor tar ball (Issue#364, PR#473)
    - Added custom JWT-authenticated log server example (new RPM glideinwms-logging) (Issue#398, PR#467)
    - Improvements of gfdiff and `get_tarballs`
    - Bug fix: Fixed and updated Glidein JWT logging (Issue#398, PR#467)
    - Bug fix: Allow anonymous SSL authentication for the dynamically generated client config (Issue#222, PR#470)
    - Bug fix: Fixed further log files errors and inconsistent documentation (Issue#464, PR#462, PR#463)
- XRootD Monitoring Shoveler 1.4.0
    - Updated from v1.1.2; see upstream release notes at <https://github.com/opensciencegrid/xrootd-monitoring-shoveler/releases> for details.
- XRootD Pelican client plugin (`xrdcl-pelican`)
    - Fixes crash under load due to director information caching.


### **January 23, 2025:** VO Package v137-4, osg-scitokens-mapfile 14, osg-ce, osg-wn-client, osg-xrootd, xcache, Pelican 7.12.0
-   [VO Package v137-4](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-137-4)
    -   Add new production IAM endpoints to vomses file for ATLAS, Alice, and LHCb
-   osg-scitokens-mapfile 14
    -   Fix capitalization in URL for the new CMS issuer
-   Use weak RPM dependencies to prefer osg-ca-certs for grid-certificates in the following packages:
    -   osg-ce
    -   osg-wn-client
    -   osg-xrootd
    -   vo-client
    -   xcache
-   [Pelican 7.12.0](https://github.com/PelicanPlatform/pelican/releases/tag/v7.12.0)

### **January 9, 2025:** frontier-squid 5.9-3.2
-   frontier-squid 5.9-3.2
    -   Add site `*.eessi.science` to the `MAJOR_CVMFS` list of allowed CVMFS Stratum 1s
    -   Move the `frontier-squid` start/stop script from `/etc/init.d` to `/usr/libexec/squid`

### **January 6, 2025:** HTCondor 24.0.3; Upcoming: HTCondor 24.3.0
-   [HTCondor 24.0.3](https://htcondor.readthedocs.io/en/24.0/version-history/lts-versions-24-0.html#version-24-0-3)
    -   Numerous updates in memory tracking with cgroups
        -   Fix bug in reporting peak memory
        -   Made cgroup v1 and v2 memory tracking consistent with each other
        -   Fix bug where cgroup v1 usage included disk cache pages
        -   Fix bug where cgroup v1 jobs killed by OOM were not held
        -   Polls cgroups for memory usage more often
        -   Can configure to always hold jobs killed by OOM
    -   Make `condor_adstash` work with OpenSearch Python Client v2.x
    -   Restore case insensitivity to `condor_status -subsystem`
    -   Fix bug where jobs would match but not start when using KeyboardIdle
    -   Fix bug when trying to avoid IPv6 link local addresses
    -   EPs spawned by 'htcondor annex' no longer crash on startup
-   Upcoming
    -   [HTCondor 24.3.0](https://htcondor.readthedocs.io/en/24.x/version-history/feature-versions-24-x.html#version-24-3-0)
        -   Allow local issuer credmon and Vault credmon to coexist
        -   Add Singularity launcher to distinguish runtime failure from job failure
        -   Advertises when the EP is enforcing disk usage via LVM
        -   By default, LVM disk enforcement hides mounts when possible
        -   Container Universe jobs can now mount a writable directory under scratch
        -   Pass `PELICAN_*` job environment variables to pelican file transfer plugin
        -   Fix HTCondor startup when network interface has no IPv6 address
        -   VacateReason is set in the job ad under more circumstances
        -   `htcondor job submit` now issues credentials like `condor_submit` does
        -   Numerous updates in memory tracking with cgroups
            -   Fix bug in reporting peak memory
            -   Made cgroup v1 and v2 memory tracking consistent with each other
            -   Fix bug where cgroup v1 usage included disk cache pages
            -   Fix bug where cgroup v1 jobs killed by OOM were not held
            -   Polls cgroups for memory usage more often
            -   Can configure to always hold jobs killed by OOM
        -   Make `condor_adstash` work with OpenSearch Python Client v2.x
        -   Restore case insensitivity to `condor_status -subsystem`
        -   Fix bug where jobs would match but not start when using KeyboardIdle
        -   Fix bug when trying to avoid IPv6 link local addresses
        -   EPs spawned by 'htcondor annex' no longer crash on startup

### **January 2, 2025:** XRootD 5.7.2-1.2
-   XRootD 5.7.2-1.2
    -   Fixes file descriptor leak when using the caching plugin

### **December 19, 2024:** IGTF 1.132, gratia-probe 2.5.8, HTCondor-CE 24.0.2, XCache 3.7.0-2
-   CA certificates based on [IGTF 1.132](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   added new trust anchor for TRGRID transition (TR)
-   gratia-probe 2.8.5
    -   Log HTCondor schedd cron stdout/stderr for easier debugging
-   [HTCondor-CE 24.0.2](https://htcondor.com/htcondor-ce/v24/releases/#december-19-2024-2402)
    -   Does not pass WholeNode request expressions to non-HTCondor batch systems
    -   Fix certificate subject parsing in `condor_ce_host_network_check`

### **December 11, 2024:** XRootD 5.7.2-1.1, GlideinWMS 3.10.8, osdf-server 7.11.7, osg-ce 24-2, Pelican 7.11.7
-   [XRootD 5.7.2-1.1](https://xrootd.github.io/2024/11/29/announcement_5_7_2.html)
    -   Various major bug fixes
-   [GlideinWMS 3.10.8](https://glideinwms.fnal.gov/doc.v3_10_8/history.html)
    -   Bug fix: Fixed root unable to remove other users jobs in the Factory
    -   Bug fix: Disabled shebang mangling in `rpm_build` to avoid gwms-python not finding the shell
    -   Bug fix: Dynamic creation of HTCondor IDTOKEN password so it is not in the images
    -   Bug fix: Failed log rotation due to wrong file creation time
-   osdf-server 7.11.7
    -   Updated to Pelican 7.11.7
    -   Use config.d Pelican configuration layout
-   osg-ce 24-2
    -   Rebuild to not depend on obsolete hosted-ce-tools package
-   [Pelican 7.11.7](https://github.com/PelicanPlatform/pelican/releases/tag/v7.11.0)

### **November 26, 2024:** HTCondor 24.0.2; Upcoming: HTCondor 24.2.1
-   [HTCondor 24.0.2](https://htcondor.readthedocs.io/en/24.0/version-history/lts-versions-24-0.html#version-24-0-2)
    -   Add `STARTER_ALWAYS_HOLD_ON_OOM` to minimize confusion about memory usage
    -   Fix bug that caused `condor_ssh_to_job` `sftp` and `scp` modes to fail
    -   Fix `KeyboardIdle` attribute in dynamic slots that could prevent job start
    -   No longer signals the OAuth credmon when there is no work to do
    -   Fix rare `condor_schedd crash` when a `$$()` macro could not be expanded
    -   By default, put Docker jobs on hold when CPU architecture doesn't match
-   Upcoming
    -   [HTCondor 24.2.1](https://htcondor.readthedocs.io/en/24.x/version-history/feature-versions-24-x.html#version-24-2-1)
        - Fixed DAGMan's direct submission of late materialization jobs
        - New `primary_unix_group` submit command that sets the job's primary group
        - Initial implementation of broken slot detection and reporting
        - New job attributes `FirstJobMatchDate` and `InitialWaitDuration`
        - `condor_ssh_to_job` now sets the supplemental groups in Apptainer
        - `MASTER_NEW_BINARY_RESTART` now accepts the `FAST` parameter
        - Avoid blocking on dead collectors at shutdown

### **November 13, 2024:** XRootD 5.7.1-1.4
-   XRootD 5.7.1-1.4
    -   Reduce XCache error rate under load

### **October 31, 2024:** Initial Release ###

This initial release contains the following notable changes compared to the current OSG 23 release:

-   [HTCondor 24.0.1 LTS](https://htcondor.readthedocs.io/en/24.0/version-history/lts-versions-24-0.html#version-24-0-1)
    -   Improvements from the HTCondor 23.x feature series
        -   Improved tracking and enforcement of disk usage by using LVM
        -   Enhancements to the htcondor CLI tool
        -   cgroup v2 support for tracking and enforcement of CPU and memory usage
        -   Leverage cgroups to hide GPUs not allocated to the job
        -   DAGMan can now produce job credentials when using direct submit
        -   New submit commands to aid in matching specific GPU requirements
        -   New implementation of the Python bindings, htcondor2 and classad2
        -   Improved default security configuration
        -   Significant reduction in memory and CPU usage on the Central Manager
    -   Additional highlights:
        -   Support for GPUs using AMD's HIP 6 library
        -   Fix bugs when -divide or -repeat was used in GPU detection
        -   Proper error message and hold when Docker emits multi-line error message
        -   Fix issue where an unresponsive libvirtd blocked an EP from starting up
        -   The htcondor CLI now works on Windows

-   [HTCondor-CE 24.0.1](https://htcondor.com/htcondor-ce/v24/installation/htcondor-ce)
    -   Remove obsolete GSI configuration
    -   Fix certificate subject parsing in `condor_ce_host_network_check`

-   [Pelican 7.10.11](https://github.com/PelicanPlatform/pelican/releases/tag/v7.10.11):
    the initial release of Pelican in the main line of the OSG Software Stack.
    Pelican is the new foundational software for the [OSDF](../data/stashcache/overview.md).
    Administrators of hosts installing `pelican` for the client are encouraged to upgrade to 7.10.11.

    !!! warning "OSDF origins / caches"
        For operators of existing OSDF caches or origins (formerly `stash-cache` or `stash-origin`, respectively),
        we recommend waiting for the release of Pelican 7.11 and accompanying `osdf-server` RPMs before upgrading.

-   [HTCondor 24.1.1](https://htcondor.readthedocs.io/en/24.x/version-history/feature-versions-24-x.html#version-24-1-1) in [OSG Upcoming](../common/yum.md#upcoming-software)
    -   All of the changes from the HTCondor 24.0.1 LTS release
    -   Can print contents of stored OAuth2 credential with htcondor CLI tool
    -   In DAGMan, inline submit descriptions work when not submitting directly
    -   By default, put Docker jobs on hold when CPU architecture doesn't match
    -   Detects and deletes invalid checkpoint and reschedules job

-   OSG PKI tools 3.7.1-2: fix an issue with missing `python3-*` dependencies

-   `ospool-ap` replaces the `osg-flock` RPM

#### Package removals ####

The following packages were removed from OSG 24:

-  `hosted-ce-tools`: moved into relevant container images
-  `voms`: available in EPEL
-  `x509-token-issuer`: removed due to lack of demand

#### Container images ####

!!! question "Where are the other OSG images?"
    We intend to release `atlas-xcache`, `cms-xcache`, `frontier-squid`, `oidc-agent`, `osg-wn` container images by the
    end of the year.

    `stash-cache` and `stash-origin` images will be replaced by `pelican_platform/osdf-cache` and
    `/pelican_platform/osdf-origin` images, respectively.

The following container images have new tags for OSG 24:

| Image name                                               | Tags         |
|:---------------------------------------------------------|:-------------|
| `hub.opensciencegrid.org/osg-htc/ospool-ep`              | `24-release` |

Announcements
-------------

Updates to critical packages also announced by email and are sent to the following recipients and lists:

-   [Registered administrative contacts](../common/registration.md#registering-resources)
-   [osg-general@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-GENERAL)
-   [operations@osg-htc.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-OPERATIONS)
-   [osg-sites@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-SITES)
-   [site-announce@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=site-announce)
-   [software-discuss@osg-htc.org](https://groups.google.com/a/osg-htc.org/g/software-discuss)
