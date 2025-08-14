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

### **August 14, 2025:** CVMFS 2.13.2, XRootD 5.8.4-1.2; Upcoming: frontier-squid 6.13-1.5, GlideinWMS 3.11.1
-   [CVMFS 2.13.2](https://cvmfs.readthedocs.io/en/2.13/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-13-2)
    -   Includes important bug fixes to prevent client hangs and crashes
        and to avoid multiple concurrent server snapshots.  Everyone who
        has installed cvmfs client 2.12 or greater is especially encouraged
        to upgrade promptly.
-   [XRootD 5.8.4-1.2](https://github.com/xrootd/xrootd/releases/tag/v5.8.4)
    -   Fixes for some memory leaks
    -   Fix for a crash while computing checksums
-   Upcoming
    -   [Frontier-squid 6.13-1.5](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt)
        -   Major update with breaking changes for sites using multiple workers.
            Manual intervention is required in this case.
            Must use the [rock cache](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Rock_cache)
            instead of the previously recommended multi-ufs cache.
    -   [GlideinWMS 3.11.1](https://glideinwms.fnal.gov/doc.v3_11_1/history.html#development)
        -   Improvements and fixes to the refactored credentials

### **August 7, 2025:** osg-scitokens-mapfile 15-2, ospool-ep 23-9, GlideinWMS 3.10.15
-   osg-scitokens-mapfile 15-2
    -   Add new scitokens issuer at JLAB to GLUEX mapping
-   ospool-ep 23-9
    -   Run in unprivileged mode by default
    -   Explicitly use the nvidia docker runtime when GPUs are requested
-   [GlideinWMS 3.10.15](https://glideinwms.fnal.gov/doc.v3_10_15/history.html)
    -   Able to run containers without Bash
    -   Able to query all known schedds without listing them
    -   Improved control of apptainer containers environment
    -   Early availability of cvmfsexec
    -   3.10.15 is a recommended upgrade from any 3.10.x

### **July 28, 2025:** HTCondor 23.0.27; Upcoming: HTCondor 23.10.27, Pelican 7.17.0
-   [HTCondor 23.0.27](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-27)
    -   Fix bug where `condor_ssh_to_job` failed when EP scratch path is too long
    -   Fix incorrect time reported by `htcondor status` for long running jobs
    -   Fix bug where `.job.ad`, `.machine.ad` files were missing when LVM is in use
-   Upcoming
    -   [HTCondor 23.10.27](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-27)
        -   Fix bug where the vacate reason was not propagated back to the user
        -   Fix bug where `condor_ssh_to_job` failed when EP scratch path is too long
        -   Fix incorrect time reported by `htcondor status` for long running jobs
        -   Fix bug where `.job.ad`, `.machine.ad` files were missing when LVM is in use
    -   [Pelican 7.17.2](https://pelicanplatform.org/releases)

### **July 10, 2025:** CVMFS 2.13.1, htgettoken 2.4
-   [CVMFS 2.13.1](https://cvmfs.readthedocs.io/en/2.13/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-13-1)
    -   Fixes a bug that has been present since cvmfs-2.12.0 which prevents
        periodic resets to the closest stratum 1, causing performance
        degradation. All who have upgraded to version 2.12.0 or later are
        encouraged to update as soon as possible.
-   htgettoken 2.4
    -   Update htdecodetoken to not run scitokens-verify by default when stdout
        is not a TTY

### **June 26, 2025:** XRootD 5.8.3-1.2, HTCondor 23.0.26; Upcoming: Pelican 7.17.0, HTCondor 23.10.26
-   [XRootD 5.8.3-1.2](https://github.com/xrootd/xrootd/releases/tag/v5.8.3)
    -   Fixes for various crashes and other bugs
-   [HTCondor 23.0.26](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-26)
    -   Fix ingestion of ads into Elasticsearch under very rare circumstances
    -   DAGMan better handles being unable to write to a full filesystem
    -   `kill_sig` submit commands are now ignored on the Windows platform
-   Upcoming
    -   [Pelican 7.17.0](https://pelicanplatform.org/releases)
        -   Improved TOKEN handling in the client
        -   Graceful shutdown for origins and caches
        -   Improved end-to-end checksum validation functionality
        -   DEPRECATION: the `IssuerKey` configuration has been deprecated in favor of `IssuerKeysDirectory`
        -   Adding the ability to enable throttling connections via `Cache.Concurrency` and `Origin.Concurrency`
        -   Extended login cookie for web UI to 16 hours
    -   [HTCondor 23.10.26](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-26)
        -   Fix memory leak in the `condor_schedd` when using late materialization
        -   Fix `condor_master` start up when file descriptor ulimit was huge
        -   Fix ingestion of ads into Elasticsearch under very rare circumstances
        -   DAGMan better handles being unable to write to a full filesystem
        -   `kill_sig` submit commands are now ignored on the Windows platform

### **June 19, 2025:** Pelican 7.16.6
-   [Pelican 7.16.6](https://pelicanplatform.org/releases)
    -   Avoid HTTPS proxies when putting objects

### **June 12, 2025:** IGTF 1.136, CVMFS 2.13.0, GlideinWMS 3.10.13
-   CA certificates based on [IGTF 1.136](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Added new CESNET CA Gen5 hierarchy and new off-line Root 2 (CZ)
    -   Withdrawn retired CILogon CAs cilogon-basic and cilogon-silver (US)
    -   A new version of the generation-4 package signing key
-   [CVMFS 2.13.0](https://cvmfs.readthedocs.io/en/2.13/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-13-0)
    -   Various fixes and improvements in both the client and server packages
-   [GlideinWMS 3.10.13](https://glideinwms.fnal.gov/doc.v3_10_13/history.html)
    -   Able to upload custom files to a HTCondor config.d directory in the Glidein
    -   Publishes `GLIDEIN_Name` and `GLIDEIN_UUID` to the Glidein environment

### **May 29, 2025:** HTCondor 23.0.25, XRootD 5.8.2-1.5, xrdcl-pelican 1.2.3, frontier-squid 5.10-1.2, htgettoken 2.2-2; Upcoming: HTCondor 23.10.25, Pelican 7.16.5
-   [HTCondor 23.0.25](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-25)
    -   Fix problems where parallel universe jobs could crash the `condor_schedd`
    -   Avoid `condor_starter` crash when evicting job during input file transfer
    -   `condor_watch_q` now properly displays job id ranges using numeric sort
-   [XRootD 5.8.2-1.5](https://github.com/xrootd/xrootd/releases/tag/v5.8.2)
    -   Experimental fair-share for throttling plugin [PelicanPlatform #23](https://github.com/PelicanPlatform/xrootd/issues/23)
    -   Fix deadlock in caching plugin when starting up [XRootD #2505](https://github.com/xrootd/xrootd/issues/2505)
    -   Fix race condition in callback handler [XRootD #2517](https://github.com/xrootd/xrootd/issues/2517)
    -   Various bug fixes - see release notes
-   [xrdcl-pelican 1.2.3](https://github.com/PelicanPlatform/xrdcl-pelican/releases/tag/v1.2.3)
    -   Fixes potential crashing or data corruption issue
-   [Frontier-squid 5.10-1.2](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt)
    -   Fixes for minor bugs and three security issues
-   htgettoken 2.2-2
    -   Update `htgettoken` command to ignore the local Python environment
-   Upcoming
    -   [HTCondor 23.10.25](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-25)
        -   Fix bug where `DAGMAN_MAX_JOBS_IDLE` was being ignored
        -   HTCondor tarballs now contain Pelican 7.16.5 and Apptainer 1.4.1
        -   Fix problems where parallel universe jobs could crash the `condor_schedd`
        -   Avoid `condor_starter` crash when evicting job during input file transfer
        -   `condor_watch_q` now properly displays job id ranges using numeric sort
    -   [Pelican 7.16.5](https://pelicanplatform.org/releases)
        -   Now includes end-to-end integrity checks for clients

### **May 8, 2025:** IGTF 1.135, XRootD 5.8.1-1.3, xrdcl-pelican 1.2.1, OpenBao 2.2.0, htvault-config 2.0.0, Decision Engine 2.0.5; Upcoming: Pelican 7.15.3, xrdhttp-pelican 0.0.6
-   CA certificates based on [IGTF 1.135](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Updated SlovakGrid trust anchor with extended validity (SK)
    -   Withdrawn discontinued HPCI CA (JP)
-   [XRootD 5.8.1](https://github.com/xrootd/xrootd/releases/tag/v5.8.1)
    -   Packet marking crash and other various bug fixes
-   [xrdcl-pelican 1.2.1](https://github.com/PelicanPlatform/xrdcl-pelican/releases/tag/v1.2.1) - This is an urgent update for caches
    -   Including changes from [xrdcl-pelican 1.1.0](https://github.com/PelicanPlatform/xrdcl-pelican/releases/tag/v1.1.0) and [xrdcl-pelican 1.2.0](https://github.com/PelicanPlatform/xrdcl-pelican/releases/tag/v1.2.0)
-   [OpenBao 2.2.0](https://openbao.org/docs/release-notes/2-2-0/#220)
    -   Open source replacement for Hashicorp's Vault
-   htvault-config 2.0.0
    -   Take advantage of improved integration with OpenBao
-   HEPCloud's [Decision Engine 2.0.5](https://hepcloud.github.io/decisionengine/release_notes/release_notes_2.0.html) on EL9 only
    -   Initial version in OSG Repositories
-   Upcoming
    -   [Pelican 7.15.3](https://github.com/PelicanPlatform/pelican/releases/tag/v7.15.3)
        -   Fix throttling in cache
        -   Fix bug in metrics collection
    -   [xrdhttp-pelican 0.0.6](https://github.com/PelicanPlatform/xrdhttp-pelican/releases/tag/v0.0.6)
        -   Adds XRootD 5.8 support and APIs for cache management

### **April 22, 2025:** HTCondor 23.0.24; Upcoming: HTCondor 23.10.24, Pelican 7.15.2
-   [HTCondor 23.0.24](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-24)
    -   Fix inflated cgroups v2 memory usage reporting for Docker jobs
-   Upcoming
    -   [HTCondor 23.10.24](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-24)
        -   HTCondor tarballs now contain Pelican 7.15.1 and Apptainer 1.4.0
        -   Fix inflated cgroups v2 memory usage reporting for Docker jobs
    -   [Pelican 7.15.2](https://github.com/PelicanPlatform/pelican/releases/tag/v7.15.2)
        -   Now sanity checks size for client GETs
        -   Enabled multiuser origins to cache public keys for validating tokens
        -   Made Origin throttling configurable
        -   XRootD now uses xldcl-pelican v1.2.0 which contains bug fixes for the cache

### **April 10, 2025:** vo-client 138-2, osg-ca-cert-updater 2.2, ospool-ep 23-7, frontier-squid 5.9-3.3; Upcoming: Pelican 7.15.0
-   vo-client 138-2
    -   Remove OpenShift Legacy IAM servers for ATLAS and CMS
-   osg-ca-certs-updater 2.2
    -   Now started via systemd timer
-   ospool-ep 23-7
    -   Make ospool-ep service more resilient to Docker service restart
-   frontier-squid 5.9-3.3
    -   Initial support for ARM (no shoal agent support)
-   Upcoming
    -   [Pelican 7.15.0](https://github.com/PelicanPlatform/pelican/releases/tag/v7.15.0)
        -   Pelican origins can now specify multiple issuers per namespace
        -   Added support for a Federation to have multiple Directors
        -   Director can optionally report cache redirection reasoning
        -   Integrate XRootD OSS statistics
        -   Add API Token Listing endpoint
        -   Client now correctly reports the start time for uploads
        -   Several bug fixes for the client

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

### **March 27, 2025:** HTCondor 23.0.22, XRootD 5.7.3-1.5, htgettoken 2.2; Upcoming: HTCondor 23.10.22
-   [HTCondor 23.0.22](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-22): Important Security Fix
    -   More details on the security issue are in the [Vulnerability Report](https://htcondor.org/security/vulnerabilities/HTCONDOR-2025-0001)
-   XRootD 5.7.3-1.5
    -   Fix gstream configuration processing
    -   Add support for purge plugins
-   htgettoken 2.2
    -   Fix htdecodetoken to work with token files that do not end in a newline
    -   Support args in htgettoken.main() Python entry point
-   Upcoming
    -   [HTCondor 23.10.22](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-22): Important Security Fix
        -   More details on the security issue are in the [Vulnerability Report](https://htcondor.org/security/vulnerabilities/HTCONDOR-2025-0001)

### **March 13, 2025:** IGTF-1.134, osg-pki-tools 3.7.2; Upcoming: xrdhttp-pelican 0.0.3, Pelican 7.14.1
-   CA certificates based on [IGTF 1.134](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   New ANSPGrid CA 2 roll-over for root-issuer key pair (BR)
    -   Withdrawn discontinued AC-GRID-FR series authorities (FR)
-   osg-pki-tools 3.7.2
    -   Fix bug sometimes preventing certificate retrieval with `osg-incommon-cert-request`
    -   Add `python3-m2crpyto` and `python3-urllib3` as runtime requirements
-   Upcoming
    -   xrdhttp-pelican 0.0.3: Support Pelican 7.14+
    -   [Pelican 7.14.1](https://github.com/PelicanPlatform/pelican/releases/tag/v7.14.0)

### **February 27, 2025:** XRootD 5.7.3, CVMFS 2.12.6, IGTF 1.133, OSPool EP 1.0-6; Upcoming Pelican 7.13.0
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
- OSPool EP 1.0-6
    - Update docker launch script to support providing NVIDIA GPU Resources
-   Upcoming
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

### **January 23, 2025:** VO Package v137-4, osg-scitokens-mapfile 14, osg-ce, osg-wn-client, osg-xrootd, xcache; Upcoming: Pelican 7.12.0
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
-   Upcoming
    -   [Pelican 7.12.0](https://github.com/PelicanPlatform/pelican/releases/tag/v7.12.0)

### **January 9, 2025:** frontier-squid 5.9-3.2
-   frontier-squid 5.9-3.2
    -   Add site `*.eessi.science` to the `MAJOR_CVMFS` list of allowed CVMFS Stratum 1s
    -   Move the `frontier-squid` start/stop script from `/etc/init.d` to `/usr/libexec/squid`

### **January 6, 2025:** HTCondor 23.0.19; Upcoming: HTCondor 23.10.19
-   [HTCondor 23.0.19](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-19)
    -   Numerous updates in memory tracking with cgroups
        -   Fix bug in reporting peak memory
        -   Made cgroup v1 and v2 memory tracking consistent with each other
        -   Fix bug where cgroup v1 usage included disk cache pages
        -   Fix bug where cgroup v1 jobs killed by OOM were not held
        -   Polls cgroups for memory usage more often
        -   Can configure to always hold jobs killed by OOM
    -   Make `condor_adstash` work with OpenSearch Python Client v2.x
    -   Avoid OAUTH credmon errors by only signaling it when necessary
    -   Restore case insensitivity to `condor_status -subsystem`
    -   Fix rare `condor_schedd` crash when a `$$()` macro could not be expanded
-   Upcoming
    -   [HTCondor 23.10.19](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-19)
        -   Numerous updates in memory tracking with cgroups
            -   Fix bug in reporting peak memory
            -   Made cgroup v1 and v2 memory tracking consistent with each other
            -   Fix bug where cgroup v1 usage included disk cache pages
            -   Fix bug where cgroup v1 jobs killed by OOM were not held
            -   Polls cgroups for memory usage more often
            -   Can configure to always hold jobs killed by OOM
        -   Make `condor_adstash` work with OpenSearch Python Client v2.x
        -   Avoid OAUTH credmon errors by only signaling it when necessary
        -   Restore case insensitivity to `condor_status -subsystem`
        -   Fix rare `condor_schedd` crash when a `$$()` macro could not be expanded
        -   Fix bug where jobs would match but not start when using KeyboardIdle
        -   Fix bug when trying to avoid IPv6 link local addresses

### **January 2, 2025:** XRootD 5.7.2-1.2
-   XRootD 5.7.2-1.2
    -   Fixes file descriptor leak when using the caching plugin

### **December 19, 2024:** IGTF 1.132, gratia-probe 2.5.8, HTCondor-CE 23.0.18, XCache 3.7.0-2
-   CA certificates based on [IGTF 1.132](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   added new trust anchor for TRGRID transition (TR)
-   gratia-probe 2.8.5
    -   Log HTCondor schedd cron stdout/stderr for easier debugging
-   [HTCondor-CE 23.0.18](https://htcondor.com/htcondor-ce/v23/releases/#december-19-2024-23018)
    -   Does not pass WholeNode request expressions to non-HTCondor batch systems
    -   Fix certificate subject parsing in `condor_ce_host_network_check`
-   XCache 3.7.0-2
    -   Relax RPM package requirement to ease upgrade to OSG 24

### **December 11, 2024:** XRootD 5.7.2-1.1, GlideinWMS 3.10.8 Upcoming: osdf-server 7.11.7, Pelican 7.11.7
-   [XRootD 5.7.2-1.1](https://xrootd.github.io/2024/11/29/announcement_5_7_2.html)
    -   Various major bug fixes
-   [GlideinWMS 3.10.8](https://glideinwms.fnal.gov/doc.v3_10_8/history.html)
    -   Bug fix: Fixed root unable to remove other users jobs in the Factory
    -   Bug fix: Disabled shebang mangling in `rpm_build` to avoid gwms-python not finding the shell
    -   Bug fix: Dynamic creation of HTCondor IDTOKEN password so it is not in the images
    -   Bug fix: Failed log rotation due to wrong file creation time
-   Upcoming
    -   osdf-server 7.11.7
        -   Updated to Pelican 7.11.7
        -   Use config.d Pelican configuration layout
    -   [Pelican 7.11.7](https://github.com/PelicanPlatform/pelican/releases/tag/v7.11.0)

### **November 19, 2024:** HTCondor 23.0.18; Upcoming: HTCondor 23.10.18
-   [HTCondor 23.0.18](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-18)
    -   Proper error message and hold when Docker emits multi-line error message
-   Upcoming
    -   [HTCondor 23.10.18](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-18)
        -   Fix issue where an unresponsive libvirtd blocked an EP from starting up

### **November 13, 2024:** XRootD 5.7.1-1.4
-   XRootD 5.7.1-1.4
    -   Reduce XCache error rate under load

### **October 30, 2024:** Upcoming: HTCondor 23.10.2, Pelican 7.10.11
-   Upcoming
    -   [HTCondor 23.10.2](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-1)
        -   Fix for output file transfer errors obscuring input file transfer errors
    -   [Pelican 7.10.11](https://github.com/PelicanPlatform/pelican/releases/tag/v7.10.11)

### **October 24, 2024:** XRootD 5.7.1-1.3, HTCondor 23.0.17
-   XRootD 5.7.1-1.3
    -   Urgent fix for S3 caches to avoid near-infinite loop
    -   Change cache age logic to only indicate fully cached files
-   [HTCondor 23.0.17](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-17)
    -   Bug fix for PID namespaces and `condor_ssh_to_job` on EL9
    -   Augment `condor_upgrade_check` to find unit suffixes in ClassAd expressions

### **October 10, 2024:** HTCondor 23.0.16; Upcoming: osdf-server 7.10.7
-   [HTCondor 23.0.16](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-16)
    -   Back-port all cgroup v2 fixes and enhancements from the 23.10.1 release
-   Upcoming
    -   osdf-server 7.10.7
        -   Update to require Pelican 7.10.7
        -   Restart services when Pelican or XRootD are upgraded.

### **October 3, 2024:** IGTF 1.131; Upcoming: HTCondor 23.10.1, Pelican 7.10.7
-   CA Certificates based on IGTF 1.131
    -   removed discontinued HKU-CA-2 authority (HK)
    -   removed obsolete 3rd generation TCS intermediates (EU)
-   Upcoming
    -   [HTCondor 23.10.1](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-10-1)
        -   Improvements to disk usage enforcement when using LVM
            -   Can encrypt job sandboxes when using LVM
            -   More precise tracking of disk usage when using LVM
            -   Reduced disk usage tracking overhead
        -   Improvements tracking CPU and memory usage with cgroup v2 (on EL9)
            -   Don't count kernel cache pages against job's memory usage
            -   Avoid rare inclusion of previous job's CPU and peak memory usage
        -   HTCondor now re-checks DNS before re-connecting to a collector
        -   HTCondor now writes out per job epoch history
        -   HTCondor can encrypt network connections without authentication
        -   htcondor CLI can now show status for local server, AP, and CM
        -   htcondor CLI can now display OAUTH2 credentials
        -   Uses job's sandbox to convert image format for Singularity/Apptainer
        -   Bug fix to not lose GPUs in Docker job on systemd reconfig
        -   Bug fix for PID namespaces and `condor_ssh_to_job` on EL9
    -   [Pelican 7.10.7](https://github.com/PelicanPlatform/pelican/releases/tag/v7.10.0)
        -   Stopped file transfers are now retryable errors
        -   General improvements to error messages within the client and the plugin
        -   Put requests now work with Origins using OA4MP Issuers
        -   Retries metadata lookup failures
        -   Fixed naming issue with queries on get/copy
        -   Director supports server sorting on distance, server load, and objects
        -   Add object availability test for cache access
        -   Caches can fetch objects from other caches when there's a cache miss
        -   Site name is populated in the Origin/Cache auto-registration process
        -   Origins and Caches advertise their storage backend type to the director

### **October 1, 2024:** HTCondor 23.0.15, XRootD 5.7.1-1.1, xrdcl-pelican 0.9.6
-   [HTCondor 23.0.15 LTS](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-15)
    -   Fix bug where Docker universe jobs reported zero memory usage on EL9
    -   Fix bug where Docker universe images would not be removed from EP cache
    -   Fix bug where `condor_watch_q` could crash
    -   Fix bug that could cause the file transfer hold reason to be truncated
-   XRootD 5.7.1
    -   New Features
        -   Allow cconfig to write out combined config file
        -   Allow for API endpoints for fixed remote origins
        -   Allow server to assume an arbitrary network identity
        -   Allow a redirector to be configured read-only
        -   Add "OSS Statistics" plugin to enable file system load monitoring
        -   Defer client TLS authentication for XRootD to avoid unnecessary browser popups
    -   Major bug fixes
        -   Do not leak file pointer on open error
        -   Fix memory leaks when creating Python objects
        -   Ensure correct certificate is used when passed via cgi with `xrd.gsiusrproxy=...`
        -   Fix too few arguments to formatting function
-   xrdcl-pelican 0.9.4
    -   Allow X.509 client authentication
    -   Provide an error code on metadata lookup failure

### **September 12, 2024:** CVMFS 2.11.5, vault 1.17.2, htvault-config 1.18, htgettoken 2.0, xrootd-multiuser 2.2.0-1.1, xrdcl-pelican 0.9.3-2.1
-   [CVMFS 2.11.5](https://cvmfs.readthedocs.io/en/2.11/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-11-5)
    -   Fix blocking behavior in repositories when pipe reads take longer than a timeout
    -   Fix streaming cache manager with secure repositories
    -   Fix handling of network errors in streaming cache manager
    -   Fix rare stuck condition after cache manager crashes
-   vault 1.17.2
    -   Update to latest upstream version
-   htvault-config 1.18
    -   Add caching of exchanged tokens
    -   Give vault tokens the ability to delete secrets and revoke themselves
    -   Update dependencies
-   htgettoken 2.0
    -   Major update replacing some libraries with modern equivalents
    -   Remove use of PyInstaller
    -   Make htgettoken directly callable from Python
    -   Add use of a newer API to access vault secrets
    -   Fix the -o option to work with relative paths
    -   Change the --nobearertoken option to always save a vault token
-   xrootd-multiuser 2.2.0-1.1
    -   Rebuild for ARM64 (aarch64)
-   xrdcl-pelican 0.9.3-2.1
    -   Rebuild for ARM64 (aarch64)

### **September 5, 2024:** XRootD 5.7.0-1.6
-   XRootD 5.7.0-1.6
    -   Fix file descriptor leak causing "too many open files" error in XCache
    -   Improve performance by reducing stat calls on HTTP GET

### **August 8, 2024:** HTCondor 23.0.14; Upcoming: HTCondor-CE 23.9.1, HTCondor 23.9.6, Pelican 7.9.9
-   [HTCondor 23.0.14 LTS](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-14)
    -   Docker and Container jobs run on EPs that match the AP's CPU architecture
    -   Fixed premature cleanup of credentials by the `condor_credd`
    -   Fixed bug where a malformed SciToken could cause a `condor_schedd` crash
    -   Fixed crash in `condor_annex` script
    -   Fixed daemon crash after IDTOKEN request is approved by the collector
-   Upcoming
    -   [HTCondor-CE 23.9.1](https://htcondor.com/htcondor-ce/v23/releases/#2391)
        -   Use new Job Router syntax by default
        -   Update configuration files to work with HTCondor 23.9.1 and later
    -   [HTCondor 23.9.6](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-9-6)
        -   Add configuration knob to have cgroups not count kernel memory for jobs on EL9
        -   Remove support for numeric unit suffixes (k,M,G) in ClassAd expressions
        -   In submit files, `request_disk` & `request_memory` still accept unit suffixes
        -   Hide GPUs not allocated to the job on cgroup v2 systems such as EL9
        -   DAGMan can now produce credentials when using direct submission
        -   Singularity jobs have a contained home directory when file transfer is on
        -   Avoid using IPv6 link local addresses when resolving hostname to IP addr
        -   New 'htcondor credential' command to aid in debugging
    -   [Pelican 7.9.9](https://github.com/PelicanPlatform/pelican/releases/tag/v7.9.9)

### **July 30, 2024:** XRootD 5.7.0
-   XRootD 5.7.0
    -   New feature release
    -   Support for Python 2.x is now deprecated
    -   Support for CentOS 7 is now deprecated (although official RPMs for 5.7.0 are available)
    -   Add support for pelican:// protocol
    -   Update min/default RSA bits to 2048
    -   Add option to force the destination IP address on a HTTP-TPC
    -   Always create directory path when opening dest file for HTTP TPC
    -   HTTP header parsing is now case-insensitive
    -   See upstream release notes for details

### **July 25, 2024:** HTCondor-CE 23.0.13, GlideinWMS 3.10.7, hosted-ce-tools 2.1: Upcoming: Pelican 7.9.5
-   [HTCondor-CE 23.0.13](https://htcondor.com/htcondor-ce/v23/releases/#23013)
    -   Include `condor_ce_upgrade_check` script
-   [GlideinWMS 3.10.7](http://glideinwms.fnal.gov/doc.v3_10_7/history.html)
    -   Apptainer cache and temp directory set in the Glidein working directory
    -   Ability to set a minimum required memory for partitionable Glideins
    -   Blackhole Detection
        -   Stop accepting jobs if they are consumed at a high rate
    -   Fix Apptainer validation not considering `uid_map` w/o initial blank
    -   Flatten error messages in HTCondor error file and `JobWrapperFailure` Ad
    -   Fix problem when `check_signature` in `glidein_startup` is not defined
    -   `get_tarballs` also looks for HTCondor tarballs in the update directory
-   hosted-ce-tools 2.1
    -   `cvmfsexec-osg-wrapper` now detects Red Hat Enterprise Linux as RHEL-like
-   Upcoming
    -   [Pelican 7.9.5](https://github.com/PelicanPlatform/pelican/releases/tag/v7.9.5)

### **July 17, 2024:** HTCondor-CE 23.0.12, IGTF 1.130; Upcoming: osdf-server 7.9.3, Pelican 7.9.3
-   [HTCondor-CE 23.0.12](https://htcondor.com/htcondor-ce/v23/releases/#23012)
    -   Fix whole node GPU request expression for non-HTCondor batch systems
-   CA certificates based on [IGTF 1.130](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   osg-ca-certs version number matches igft-ca-certs version number
    -   resolve subjectDN nameformat compatibility issues trust anchor metadata
-   Upcoming
    -   osdf-server 7.9.3
        -   Updated to upstream Pelican 7.9.3
        -   Added logrotate config
        -   Raised minimum XRootD version requirement to 5.6.9-1.6
    -   [Pelican 7.9.3](https://github.com/PelicanPlatform/pelican/releases/tag/v7.9.2)

### **June 27, 2024:** IGTF 1.129, osg-configure 4.2.0; Upcoming: HTCondor 23.8.1
-   CA certificates based on [IGTF 1.129](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Updated CRL URL location for MREN CA (ME)
    -   Removed discontinued TSU-GE GRENA CA (GE)
    -   Removed suspended BYGCA (BY)
    -   Removed discontinued LIP CA (PT)
    -   Removed obsolete DT transitional CAs (AE)
    -   Additions to OSG CA Bundle (osg-ca-certs)
        -   Add Let's Encrypt Intermediate CAs to support XRootD
        -   Add Let's Encrypt root CA (ISRG Root X2)
-   osg-configure 4.2.0
    -   Add "queue" to `OSG_ResourceCatalog` for Pilot sections
    -   Remove osg-configure-rsv
-   Upcoming
    -   [HTCondor 23.8.1](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-8-1)
        -   HTCondor Docker images are now based on Alma Linux 9
        -   HTCondor Docker images are now available for the arm64 CPU architecture
        -   The user can now choose which submit method DAGMan will use
        -   Can add custom attributes to the User ClassAd with `condor_qusers -edit`
        -   Add use-projection option to `condor_gangliad` to reduce memory footprint
        -   Fix bug where interactive submit does not work on cgroup v2 systems (EL9)


### **June 13, 2024:** HTCondor 23.0.12
-   [HTCondor 23.0.12 LTS](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-12)
    -   Remote `condor_history` queries now work the same as local queries
    -   Improve error handling when submitting to a remote scheduler via ssh
    -   Fix bug on Windows where `condor_procd` may crash when suspending a job
    -   Fix Python binding crash when submitting a DAG which has empty lines

### **June 11, 2024:** XRootD 5.6.9-1.6
-   XRootD 5.6.9-1.6
    -   Add `gateway timeout` error code for unresponsive origins
    -   Add g-stream monitoring for I/O time
    -   Add ability to disable or defer TLS authentication
    -   Fix timers used for I/O throttling

### **May 16, 2024:** VOMS 2.1.0-0.31.rc3.2; Upcoming: HTCondor 23.7.2, Pelican 7.8.2
-   VOMS 2.1.0-0.31.rc3.2
    -   Fix `voms-proxy-init` incompatibility with new LHC IAM servers
-   Upcoming
    -   [HTCondor 23.7.2](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-7-2)
        -   Warns about deprecated multiple `queue` statements in a submit file
        -   The semantics of `skip_if_dataflow` have been improved
        -   Removing large DAGs is now non-blocking, preserving schedd performance
        -   Periodic policy expressions are now checked during input file transfer
        -   Local universe jobs can now specify a container image
        -   File transfer plugins can now advertise extra attributes
        -   DAGMan can rescue and abort if pending jobs are missing from the job queue
        -   Fix so `condor_submit -interactive` works on cgroup v2 execution points
    -   [Pelican 7.8.2](https://github.com/PelicanPlatform/pelican/releases/tag/v7.8.2)


### **May 9, 2024:** VO Package v136
-   [VO Package v136](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-136)
    -   Transition to new IAM-based VOMS signing servers for LHC experiments
-   [HTCondor 23.0.10 LTS](https://htcondor.readthedocs.io/en/23.0/version-history/lts-versions-23-0.html#version-23-0-10)
    -   Preliminary support for Ubuntu 22.04 (Noble Numbat)
    -   Warns about deprecated multiple queue statements in a submit file
    -   Fix bug where plugins could not signify to retry a file transfer
    -   The `condor_upgrade_check` script checks for proper token file permissions
    -   Fix bug where the `condor_upgrade_check` script crashes on older platforms
    -   The bundled version of apptainer was moved to libexec in the tarball
-   XRootD 5.6.9-1.3:
    -   Add g-stream monitoring for IO time for Pelican
-   [CVMFS 2.11.3](https://cvmfs.readthedocs.io/en/2.11/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-11-3)
    -   Update method of downloading the MaxMind GeoIP, including requiring new configuration parameter `CVMFS_GEO_ACCOUNT_ID`
-   Upcoming
    -   [Pelican 7.8.1](https://github.com/PelicanPlatform/pelican/releases/tag/v7.8.0)

### **May 2, 2024:** XCache 3.7.0, osg-xrootd 23-6; Upcoming: Pelican 7.7.3
-   [XCache 3.7.0](https://github.com/opensciencegrid/xcache/releases/tag/v3.7.0) and osg-xrootd 23-6
    -   Security update for OSDF caches and origins
        -   Require explicit mapping of DNs to avoid hash collisions
        -   Get mappings for cache and origin DNs from Topology
-   Upcoming
    -   [Pelican 7.7.3](https://github.com/PelicanPlatform/pelican/releases/tag/v7.7.0)

### **April 15, 2024:** Upcoming: HTCondor 23.6.1
-   Upcoming
    -   [HTCondor 23.6.1](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-6-1)
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

### **April 4, 2024:** XRootD 5.6.9; Upcoming: Pelican 7.6.2
-   XRootD 5.6.9
    -   Various minor bug fixes; see upstream release notes for details
-   Upcoming
    -   [Pelican 7.6.2](https://github.com/PelicanPlatform/pelican/releases/tag/v7.6.2)

### **March 21, 2024:** osg-scitokens-mapfile 13-2, vo-client 135-1
-   osg-scitokens-mapfile 13-2
    -   Add the new CERN IAM instances for ATLAS and CMS to the default CE token to local user mapfiles
-   vo-client 135-1
    -   Adds LSC files for new LHC IAM hosts for ALICE, ATLAS, CMS, DTEAM, and LHCb 

### **March 14, 2024:** IGTF 1.128, osg-xrootd 23-5, HTCondor 23.0.6 LTS, HTCondor-CE 23.0.6; Upcoming: HTCondor 23.5.2, Pelican 7.5.8
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
    -   [HTCondor 23.5.2](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-5-2)
        -   Disable old ClassAd-based syntax by default for the job router
        -   Add ability to use LVM partitions to efficiently manage/enforce disk space
        -   Enable GPU discovery on all Execution Points by default
        -   Use cgroups v1 enforcement to prevent accessing unallocated GPUs
        -   Add new `condor_submit` commands for constraining GPU properties
        -   Add ability to transfer EP's starter log back to the Access Point
        -   Enable use of VOMS attributes when mapping identities of SSL connections
        -   Add the Git SHA of the HTCondor sources to the CondorVersion string
    -   [Pelican 7.5.8](https://github.com/PelicanPlatform/pelican/releases/tag/v7.5.8)

### **February 29, 2024:** XRootD 5.6.8; Upcoming: Pelican 7.5.7
-   [XRootD 5.6.8](https://github.com/xrootd/xrootd/releases/tag/v5.6.8)
    -   Fix automatic renewal of server certificate with OpenSSL>=1.1
    -   Other minor bug fixes
-   Upcoming
    -   [Pelican 7.5.7](https://github.com/PelicanPlatform/pelican/releases/tag/v7.5.7)

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
-   GlideinWMS 3.10.6: Enterprise Linux 9 only
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

### **February 8, 2024:** Frontier-squid 5.9-2.1, HTCondor 23.0.4, htvault-config 1.16, vault 1.15.4, osg-configure 4.1.1-3; Upcoming: HTCondor 23.4.0, Pelican 7.5.1
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
    -   [HTCondor 23.4.0](https://htcondor.readthedocs.io/en/23.x/version-history/feature-versions-23-x.html#version-23-4-0)
        -   `condor_submit` warns about unit-less `request_disk` and `request_memory`
        -   Separate `condor-credmon-local` RPM package provides local SciTokens issuer
        -   Fix bug where `NEGOTIATOR_SLOT_CONSTRAINT` was ignored since version 23.3.0
        -   The `htcondor` command line tool can process multiple event logs at once
        -   Prevent Docker daemon from keeping a duplicate copy of the job's stdout
    -   [Pelican 7.5.1](https://github.com/PelicanPlatform/pelican/releases/tag/v7.5.0)
        -   The plugin now downloads files in parallel
        -   Improved file unpacking
        -   Origins now support public namespaces

### **January 4, 2024:** IGTF 1.126, ospool-ep 1.0; Pelican 7.3.1
-   CA certificates based on [IGTF 1.126](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Removed replaced InCommon IGTF Server CA and associated Comodo RSA CA (US)
    -   Removed discontinued UNLPGrid CA (CL)
-   ospool-ep 1.0
    -   [Automatically manage the OSPool EP Docker container with systemd](https://osg-htc.org/docs/resource-sharing/os-backfill-containers/#running-the-container-via-rpm)
-   Upcoming
    -   [Pelican 7.3.1](https://github.com/PelicanPlatform/pelican/releases/tag/v7.3.1)

### **December 14, 2023:** XRootD 5.6.4, XCache 3.6.0, xrootd-multiuser 2.2.0; Pelican 7.3.0
-   [XRootD 5.6.4](https://github.com/xrootd/xrootd/releases/tag/v5.6.4)
    -   Fix segfault with macaroons
    -   Fix segfault if pss.origin uses https protocol with no port
    -   Switch from using a certificate file to a certificate chain file
-   [XCache 3.6.0](https://github.com/opensciencegrid/xcache/releases/tag/v3.6.0)
    -   Allow overriding redirector in caches with the environment variable ``XC_REDIRECTOR``
    -   Allow adding local additions to ``Authfile`` and ``scitokens.conf`` file in ``/etc/xrootd``
-   [xrootd-multiuser 2.2.0](https://github.com/opensciencegrid/xrootd-multiuser/releases/tag/v2.2.0-1)
    -   Add ability to enable/disable xrootd-multiuser with the ``XC_ENABLE_MULTIUSER`` environment variable
-   Upcoming
    -   [Pelican 7.3.0](https://github.com/PelicanPlatform/pelican/releases/tag/v7.3.0)

### **November 30, 2023:** VO Package v133, IGTF 1.125; Upcoming: Pelican 7.2.1
-   [VO Package v133](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-133)
    -   Update certificates for FNAL and GlueX VOMS servers
-   CA certificates based on [IGTF 1.125](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Updated root certificate ArmeSFo CA with extended validity (AM)
-   Upcoming
    -   [Pelican 7.2.1](https://github.com/PelicanPlatform/pelican/releases/tag/v7.2.1)

### **November 16, 2023:** VO Package v132, XRootD 5.6.3, osg-ce 23-2, HTCondor-CE 23.0.1, osg-system-profiler 1.7.0; Upcoming: Pelican 7.2.0
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
-   Upcoming
    -   [Pelican 7.2.0](https://github.com/PelicanPlatform/pelican/releases/tag/v7.2.0)

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

-   GlideinWMS 3.10.5:
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
