title: OSG 26 News

OSG 26 News
===========

**Supported OS Versions:** EL8, EL9, EL10 (see [this document](supported_platforms.md) for details)

OSG 26 is the third release series following our [annual release schedule](release_series.md) and includes support for
EL10. The initial release includes GlideinWMS 3.11.4, HTCondor 26.0.1, HTCondor 26.1.0, HTCondor-CE 26.0.1, and XRootD 6.2.0.

OSG 26 will be supported for [approximately two years total](release_series.md#series-life-cycle).


!!! info "OSG 24 end-of-life"
    Following our [release series support policy](release_series.md#series-life-cycle),
    OSG 24 has reached its end-of-life and will no longer be supported with the release of OSG 26.

Announcements
-------------

Updates to critical packages are also announced by email and are sent to the following recipients and lists:

-   [Registered administrative contacts](../common/registration.md#registering-resources)
-   [site-announce@osg-htc.org](https://groups.google.com/u/1/a/osg-htc.org/g/site-announce)
-   [software-discuss@osg-htc.org](https://groups.google.com/a/osg-htc.org/g/software-discuss)

Latest News
-----------

**November 13, 2026:** Initial Release
--------------------------------------


This initial release contains the following notable changes compared to the current OSG 25 release in [main](../common/yum.md):

-  [HTCondor 26.0.1](https://htcondor.readthedocs.io/en/latest/version-history/lts-versions-26-0.html) (see [upgrade notes](updating-to-osg-26.md#updating-your-htcondor-hosts))
    -   Initial implementation of the common files feature, where immutable files 	may only be transferred once when jobs run on the same execution point
    -   New self-service annex mode that works with any Slurm cluster
    -   `condor_dag_checker` can now check submit files, sub-DAGs, and scripts
    -   Several improvements to throttle and monitor DAGMan resource usage
    -   New DAGMan `TOLERANCE` which gives fine control over what is a failure
    -   Added weak dependencies to DAGMan
    -   HTCondor now detects AMD GPUs that use ROCM 7
    -   Container universe adds the detected GPU flag the container command line
    -   Several improvements to the `condor_credmon`
    -   Administrators can now require units on memory and disk requests
    -   Can now append columns to `condor_q`, `condor_qusers`, `condor_status`, and `condor_who` output
    -   Can now automatically retry a job with a larger disk request
    -   Initial support for EP health checks
    -   `condor_config_val` `--trace` finds a definition in a complex configuration
    -   Can now set a duration for a user's ceiling, floor, or priority factor
    -   New metric daemon that can export metrics to Prometheus and Ganglia
    -   Add CCB Tunneling for daemons with no outbound network connectivity
    -   The CCB can now proxy connections with both ends on private networks
    -   Can now maintain a job index to speed up common condor history queries
    -   `condor_rm now` accepts the `-held` option

-   [HTCondor-CE 26.0.1](https://htcondor.com/htcondor-ce/v26/releases/) (see [upgrade notes](updating-to-osg-26.md#updating-your-osg-compute-entrypoint))

-   [Pelican 26.0.2](https://github.com/PelicanPlatform/pelican/releases/tag/v26.0.0) brings usability enhancements, a new Collections feature for delegating access management, a web-based client for Origins, and other features and bug fixes:
    -   New Features and Enhancements
        -   [Origin]: New registration view for Origins
        -   [Origin]: HTTPS/WebDav, Globus, S3/Blob added as V2 Pelican backends
        -   [Client]: Client agent now has remote transfer server functionality
        -   [Client]: Error messages are more human readable
        -   [Origin]: Web client added
        -   [Cache]: Per-origin fair scheduler added to prevent single slow Origin from blocking a Cache’s other transfers
        -   [Client] Now infers destination filename when uploading to a directory
        -   [Origin] Added a standalone mode for the Origin, which allows the Origin to be its own federation
        -   [Origin] Per namespace IssuerJwks for embedded OAuth2 Issuer
        -   [Origin] Added pstore, an Origin storage backend that uses Cache V2 block store as an Origin’s primary data store rather than as a Cache
        -   [Origin] Added POSC, object metadata tracking/publishing to the V2 Origin
    -   Bugs Fixed
        -   [Origin] Added CORS support for the embedded OIDC issuer endpoints
        -   [Origin/Cache] All issuer keys registered at startup, not just lexicographically-first one
        -   [Client] No longer download a collection as if it were an object
        -   [Client] List a plain object instead of claiming listings are unsupported against POSIX V2 Origins
        -   [Origin] Added OPTIONS /  handler, no longer returns 405 #3626
        -   [Client] PelicanFS now forwards transfer options to the transfer jobs it creates
        -   [Client] Improve Director-response Cache keys and reuse #3655
        -   [Client] Upload now uses scopes with storage.modify if Client.EnableOverwrites is set
        -   [Servers] Added token clock skew tolerance to account for differences across servers

    - Pelican 26.0.2 also includes all of the features and fixes from [Pelican 7.27.1](https://github.com/PelicanPlatform/pelican/releases/tag/v7.27.1)

-   GlideinWMS 3.11.4 (see [upgrade notes](updating-to-osg-26.md#updating-your-glideinwms-frontend))

-   XRootD 6.2.0
    -   Many fixes and features; see [release announcement for 6.0.0](https://listserv.slac.stanford.edu/scripts/wa.exe?A2=XROOTD-L;8f4e2464.2302&FT=&P=3558585&H=N&S=) and [releases pages](https://github.com/xrootd/xrootd/releases)


### Package removals ###

The following packages were removed for OSG 26:


-   `osg-ca-certs-updater`: we recommend alternative means for automatically updating the osg-ca-certs RPM
-   `osg-pki-tools`: we recommend using Let's Encrypt certificates where possible. For IGTF certificates, contact your institution.


