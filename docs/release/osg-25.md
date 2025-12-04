title: OSG 25 News

OSG 25 News
===========

**Supported OS Versions:** EL8, EL9, EL10 (see [this document](supported_platforms.md) for details)

OSG 25 is the third release series following our [annual release schedule](release_series.md) and includes support for
EL10. The initial release includes GlideinWMS 3.10.15, HTCondor 25.0.2, HTCondor 25.2.1, HTCondor-CE 25.0.1, and XRootD 5.8.4.

OSG 25 will be supported for [approximately two years total](release_series.md#series-life-cycle).


!!! info "OSG 23 end-of-life"
    Following our [release series support policy](release_series.md#series-life-cycle),
    OSG 23 has reached its end-of-life and will no longer be supported with the release of OSG 25.


!!! danger "Deprecation of the CVMFS OSG WN client `current` symlink"
    In January 2026, we plan to remove the the `current` symlink for the CVMFS-based OSG WN client,
    i.e. `/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/current`

!!! danger "Local credmon not yet supported in EL10"
    The local credmon depends on `python3-scitokens`, which is currently missing from EPEL10.
    Users of the local credmon should wait to upgrade to EL10 until `python3-scitokens` becomes
    available.

Enterprise Linux 10
-------------------

### Microarchitecture ###

The x86-64 architecture contains multiple subversions with different CPU feature sets, referred to as
[microarchitectures](https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels)
Support for x86-64-v2, released in 2008, [has been dropped from RHEL 10](https://access.redhat.com/solutions/7066628), 
Centos Stream 10, and Rocky Linux 10. Almalinux 10 continues support for v2 and has dedicated
[Yum repositories](https://almalinux.org/blog/2025-06-26-epel-v2-now-covers-almalinux-10-stable/) for these packages.

Before EL10, all OSG Software `x86_64` packages were built against the v2 microarchitecture.
Starting in EL10, OSG Software `x86_64` architecture packages are built against the v3 microarchitecture,
while a separate `x86_64_v2` architecture is maintained to support v2 Almalinux 10. 
`yum` will automatically select the correct `$basearch` for your host when 
[installing the OSG yum repos](../common/yum.md).

### EPEL ###

In EL10, the EPEL repositories have minor versions that correspond to your operating system's minor versions
(see [this presentation](https://carlwgeorge.fedorapeople.org/presentations/the-road-to-epel-10.pdf) for details).
As a result, there are packages missing from EPEL 10.0 that are availabe in EPEL 10.1 or EPEL 10.2.
CentOS Stream 10 installations will point at the latest EPEL sub-version but other EL variants will need to upgrade OS
minor versions to access packages in newer EPEL sub-versions.

Note that at the time of this writing, Alma Linux, RHEL, and Rocky Linux have not released 10.1 or above.

Announcements
-------------

Updates to critical packages are also announced by email and are sent to the following recipients and lists:

-   [Registered administrative contacts](../common/registration.md#registering-resources)
-   [site-announce@osg-htc.org](https://groups.google.com/u/1/a/osg-htc.org/g/site-announce)
-   [software-discuss@osg-htc.org](https://groups.google.com/a/osg-htc.org/g/software-discuss)

**December 4, 2025:** IGTF 1.138, GlideinWMS 3.10.17
----------------------------------------------------------------------------------------------------------------------
-   CA certificates based on [IGTF 1.138](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Add new REUNA Issuing CA and updated RPDNC for HLCA emSign Trusted Root (CL)
    -   Withdraw superseded KEK CA (JP)
    -   Update RCauth Pilot ICA G1 with extended validity period (EU)
-   [GlideinWMS 3.10.17](https://glideinwms.fnal.gov/doc.v3_10_17/history.html#stable)
    -   Support for HTCondor v2 Python bindings
    -   Updated Factory monitoring of client requests
    -   Other features and fixes. See the [CHANGELOG](https://github.com/glideinWMS/glideinwms/blob/master/CHANGELOG.md#v31017-2025-11-20) for more details

**November 20, 2025:** Pelican 7.21.1
----------------------------------------------------------------------------------------------------------------------
-   [Pelican 7.21.1](https://pelicanplatform.org/releases)
    -   User interface improvements for Pelican Client, HTCondor plugin, and Pelican Servers
    -   Provide a short circuit mechanism for Caches/Origins with outdated XRootD configuration files
    -   Other useful updates (See release notes)

**November 13, 2025:** Upcoming: HTCondor 25.4.0
----------------------------------------------------------------------------------------------------------------------
-   Upcoming
    -   [HTCondor 25.4.0](https://htcondor.readthedocs.io/en/25.x/version-history/feature-versions-25-x.html#version-25-4-0)
        -   Job scratch space is now in a sub-directory of the execute directory
        -   HTCondor EPs can now refresh credentials during output transfers
        -   HTCondor will now create intermediate directories with output remaps
        -   `condor_watch_q` now correctly accounts for unmaterialized jobs
        -   Now able to control maximum jobs running by user on an AP
        -   HTCondor now tracks when jobs are vacated prior to running
        -   Disk space allocated to jobs now more closely matches the request

**November 6, 2025:** CVMFS 2.13.3, osg-configure 4.3.1, GlideinWMS 3.10.16; Upcoming: GlideinWMS 3.11.2
----------------------------------------------------------------------------------------------------------------------
-   [CVMFS 2.13.3](https://cvmfs.readthedocs.io/en/2.13/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-13-3)
    -   Fixes a race condition with auto unmount/mount introduced in 2.13.0 that sometimes caused hung clients

    !!! note
          This fix only takes effect on a new mount, after a repository is unmounted.  It does not take effect on a live upgrade.

    -   Adds an extended `cvmfs_config status <repo>` command to help with debugging
-   osg-configure 4.3.1
    -   Update to use version 2 of HTCondor Python bindings to fix critical bug that prevented configuration of CEs on OSG 25
-   [GlideinWMS 3.10.16](https://glideinwms.fnal.gov/doc.v3_10_16/history.html#stable)
    -   Various bug fixes. See the [CHANGELOG](https://github.com/glideinWMS/glideinwms/blob/master/CHANGELOG.md#v31016-2025-09-29) for more details
-   Upcoming
    -   [GlideinWMS 3.11.2](https://glideinwms.fnal.gov/doc.v3_11_2/history.html#development)
        -   Various bug fixes. See the [CHANGELOG](https://github.com/mambelli/glideinwms/blob/release_v3_11_2/CHANGELOG.md#v3112-2025-09-08) for more details

**November 3, 2025:** HTCondor 25.0.3; Upcoming: HTCondor 25.3.1
----------------------------------------------------------------
-   [HTCondor 25.0.3](https://htcondor.readthedocs.io/en/25.0/version-history/lts-versions-25-0.html#version-25-0-3)
    -   Fix interoperability problem between HTCondor-CE 24 and 25 which manifests as a Job Router crash when upgrading the CE to HTCondor 25
    -   Fix several issues when submitting jobs with itemdata in the htcondor2 Python bindings
    -   Fix bug when `using max_idle` and `transfer_input_files` that could result in the `container_image` to be only transferred with the first job
    -   Fix problem running PyTorch jobs on multiple GPUs with newer versions of the CUDA library by providing long GPU IDs in the `CUDA_VISIBLE_DEVICES` environment variable
    -   Other bug fixes (see the version history)
-   Upcoming
    -   [HTCondor 25.3.1](https://htcondor.readthedocs.io/en/25.x/version-history/feature-versions-25-x.html#version-25-3-1)
        -   Fix interoperability problem between HTCondor-CE 24 and 25 which manifests as a Job Router crash when upgrading the CE to HTCondor 25
        -   Fix several issues when submitting jobs with itemdata in the htcondor2 Python bindings
        -   Fix bug when `using max_idle` and `transfer_input_files` that could result in the `container_image` to be only transferred with the first job
        -   Fix problem running PyTorch jobs on multiple GPUs with newer versions of the CUDA library by providing long GPU IDs in the `CUDA_VISIBLE_DEVICES` environment variable
        -   Other bug fixes (see the version history)

**October 30, 2025:** XRootD 5.9.0
----------------------------------
-   [XRootD 5.9.0-1.1](https://github.com/xrootd/xrootd/releases/tag/v5.9.0)
    -   New redirect intercept plugin for SENSE
    -   udprefresh option for xrd.network directive to allow detecting and following DNS changes when sending out monitoring information
    -   New CORS plugin for XrdHttp
    -   Per-file cache control of block size and number of blocks via CGI elements
    -   Possibility to turn off client certificate authentication for HTTPS connections
    -   Updates to registerable summary monitoring statistics
    -   Optimization of HTTP requests with sequential I/O
    -   Refactoring of the XrdThrottle plugin as an OSS plugin
    -   As with previous releases, XRootD 5.9.0 is 100% [ABI compatible](https://xrootd.web.cern.ch/abi-tracker/timeline/xrootd/) with XRootD 5.8.x and earlier releases. There is a change in ABI in the XCache plugin due to new features, but it does not affect dependencies like EOS, ROOT, FTS, etc.

**October 21, 2025:** Initial Release
-------------------------------------

This initial release contains the following notable changes compared to the current OSG 24 release in [main](../common/yum.md):

-   [HTCondor 25.0.2](https://htcondor.readthedocs.io/en/latest/version-history/lts-versions-25-0.html) (see [upgrade notes](updating-to-osg-25.md#updating-your-htcondor-hosts))
    -   New and improved Python bindings: classad2 and htcondor2
        -   Python code must be migrated to the new bindings
    -   New `condor_dag_checker` tool finds syntax and logic errors before run
    -   Add the ability to enforce memory and CPU limits on local universe jobs
    -   Add job attributes to track why and how often a job is vacated
    -   New job attribute to report number of input files transferred by protocol
    -   New `condor_q -hold-codes` produces a summary of held jobs
    -   `condor_status -lvm` reports current disk usage by slots on the EPs
    -   Add new 'halt' and 'resume' verbs to "htcondor dag"
    -   htcondor ap status now reports the AP's RecentDaemonCoreDutyCycle
    -   Can limit the number of times that a job can be released
    -   `condor_watch_q` now displays when file transfer is happening
    -   Add ability to use authentication when fetching Docker images
    -   HTCondor marks slots as broken when the slot resources cannot be released
    -   HTCondor now advertises NVIDIA driver version
    -   Improved validation and cleanup of EXECUTE directories
    -   New `primary_unix_group` submit command that sets the job's primary group
    -   Add Singularity launcher to distinguish runtime failure from job failure
    -   Container Universe jobs can now mount a writable directory under scratch
    -   New job attributes FirstJobMatchDate and InitialWaitDuration
    -   Update Python file transfer plugins to use the new Python bindings
    -   Fix incorrect environment when using Singularity and nested scratch
    -   Fix bug that could cause Python job submission to crash

-   [HTCondor-CE 25.0.1](https://htcondor.com/htcondor-ce/v25/releases/#september-29-2025-2501) (see [upgrade notes](updating-to-osg-25.md#updating-your-osg-compute-entrypoint))
    -   If upgrading from HTCondor-CE 23, ensure that you have converted the old style Job Router configuration to
        [ClassAd transform syntax](https://htcondor.com/htcondor-ce/v25/releases/#updating-to-htcondor-ce-25)

!!! question "Where are the OSDF packages?"
    `osdf-cache`, `osdf-server`, `osdf-origin` are being reworked to align more closely with upstream Pelican configurations.
    These updates will require manual intervention, which will be documented and announced upon release.

-   [Pelican 7.20.2](https://pelicanplatform.org/releases/v7.20.0) brings a variety of Client usability improvements and
    bugfixes, server UI upgrades and Cache stability/debugging enhancements.
    -   New Features and Enhancements

        -   [Client]: Modified the Client command pelican object ls to produce single column outputs for better
            piping with grep
        -   [Plugin]: Enabled the HTCondor plugin to run condor_reconfig automatically whenever it's updated
        -   [Origin]: Gave Origin admins the ability to configure the issuer URL set in the Director's
            `X-Pelican-Token-Generation` response header (used by Clients for bootstrapping automatic token generation)
        -   [Cache]: Made a variety of new XRootD metrics available via Prometheus to aid in debugging server performance

    -   Bugs Fixed

        -   [Client]: Fixed various authorization errors related to listings and recursive deletes
        -   [Client]: Fixed a bug that prevented pelican origin token create from using custom paths for private keys
        -   [Client]: Fixed a Client deadlock that occurred in some transfers
        -   [Servers]: Fixed an RPM packaging bug that overrode the OSDF's discovery URL

And the following packages in [upcoming](../common/yum.md#upcoming-software):

-   [HTCondor 25.2.1](https://htcondor.readthedocs.io/en/latest/version-history/feature-versions-25-x.html#version-25-2-1)
    -   Support for re-running a job with an increased memory request
    -   Several DAGMan improvements
    -   Several local credmon improvements
    -   Fix problem that could prevent logging of hung file transfer plugins
    -   Plus all the fixes from HTCondor 25.0.2

### Package removals ###

The following packages were removed for OSG 25:

-  `cigetcert`: CILogon CA retired
-  `cilogon-openid-ca-cert`: CILogon CA retired
-  `openbao`: available in EPEL
-  `oidc-agent`: available in EPEL
-  `vault`: Superseded by openbao

### EL10 packaging differences ###

The following OSG packages are not yet available for Enterprise Linux 10:

-   frontier-squid
-   glideinwms
-   python3-scitokens
-   htvault-config

The following changes were made to packages in EL10:

-   OSG CE:

    !!! warning "Limited testing coverage"
        Due to missing EPEL dependencies, we are not currently testing `htcondor-ce-view` or `osg-ce-slurm` in our
        nightly integration tests.
        These packages however, are still available in case sites have alternative means to install the necessary
        `ganglia` and `slurm` dependencies.
        
    -   Removed `frontier-squid` as a dependency.
        The dependency will be re-added when `frontier-squid` is available for EL10
    -   Removed `osg-ce-torque` as Torque is not available via EPEL

-   OSG WN Client:
    -   Removed gfal2 dependency as it is not supported on EL10

### Container images ###

We plan on releasing container images over the coming weeks.
