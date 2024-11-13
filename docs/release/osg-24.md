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

### **November 13, 2024:** XRootD 5.7.1-1.4
-   XRootD 5.7.1-1.4
    -   Reduce XCache error rate under load

### October 31, 2024: Initial Release ###

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
