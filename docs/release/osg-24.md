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

### **December 11, 2024:** XRootD 5.7.2-1.1, GlideinWMS 3.10.8 Upcoming: osdf-server 7.11.7
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

!!! info "Where is the OSG 24 worker node tarball?"
    We plan to distribute the worker node tarball within the next week. Stay tuned for updates!

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
