title: OSG 25 News

OSG 25 News
===========

**Supported OS Versions:** EL8, EL9, EL10 (see [this document](supported_platforms.md) for details)

OSG 25 is the third release series following our [annual release schedule](release_series.md) and includes support for
EL10. The initial release includes GlideinWMS 3.10.15, HTCondor 25.0.1, HTCondor 25.1.1, HTCondor-CE 25.0, and XRootD 5.8.4.

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

The x86-64 architecture contains multiple subversions with different CPU feature sets. Support for x86-64-v2, 
released in 2008, has been dropped from RHEL 10, Centos Stream 10, and Rocky Linux 10. Almalinux 10 continues
support for v2. In EL<=9, OSG's `x86_64` architecture packages are built against the v2 microarchitecture.
Starting in EL10, OSG's `x86_64` architecture packages are built against the v3 microarchitecture, while a separate
`x86_64_v2` architecture is maintained to support v2 Almalinux 10.

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

**October 10, 2025:** Initial Release
-------------------------------------

This initial release contains the following notable changes compared to the current OSG 24 release in [main](../common/yum.md):

-   [HTCondor 25.0.2 LTS](https://htcondor.readthedocs.io/en/latest/version-history/lts-versions-25-0.html#version-25-0-2)
    -   Replaces the HTCondor v1 Python bindings (`htcondor` and `classad`) with v2 Python bindings (`htcondor2` and
        `classad2`)
    -   Update Python file transfer plugins to use the new Python bindings
    -   Fix incorrect environment when using Singularity and nested scratch
    -   All changes in [HTCondor 24.12.13](https://htcondor.readthedocs.io/en/latest/version-history/feature-versions-24-x.html#version-24-12-13)
    -   Fix bug that could cause Python job submission to crash

-   [HTCondor-CE 25.0.2](https://htcondor.com/htcondor-ce/v25/releases/#september-29-2025-2501)
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
    -   All changes in 25.0.2

### Package removals ###

The following packages were removed from OSG 25:

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
