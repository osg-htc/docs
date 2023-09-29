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

Latest News
-----------

### **September 29, 2023**: Initial Release

!!! info "OSG 3.6 retirement"
    As part of our transition to our new series release cadence, we are planning to end support for OSG 3.6 on 30 June
    2024 to align with the EL7 end-of-life.
    See our [release series life-cycle](release_series.md#series-life-cycle) table for details.

The initial release of OSG 23 contains [major package updates](#major-package-updates) and
[package removals](#package-removals).
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
    an update from XRootD 5.5.1 in OSG 3.6 main.
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
    -   Various OSG_Autoconf improvements
    -   Fixed bugs with Python 3.9 and rrdtools failures with missing ClassAds and monitoring

#### Package Removals ####

The following packages were removed from OSG 23 compared to OSG 3.6:

-  `blahp`: available as `condor-blahp`
-  `oidc-agent`: available in EPEL
-  `python-jwt`: available in EPEL
-  `python-scitokens`: available in EPEL
-  `rrdtool` available from OS repositories

Announcements
-------------

Updates to critical packages also announced by email and are sent to the following recipients and lists:

-   [Registered administrative contacts](../common/registration.md#registering-resources)
-   [osg-general@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-GENERAL)
-   [osg-operations@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-OPERATIONS)
-   [osg-sites@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-SITES)
-   [site-announce@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=site-announce)
-   [software-discuss@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=software-discuss)
