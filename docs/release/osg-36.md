title: OSG 3.6 News

OSG 3.6 News
============

**Supported OS Versions:** EL7, EL8

The OSG 3.6 release series is a major overhaul of the OSG software stack compared to previous release series with
changes to core protocols used for authentication and data transfer:
bearer tokens, such as [SciTokens](https://scitokens.org/) or WLCG tokens, are used for authentication instead of
GSI proxies and HTTP is used for data transfer instead of GridFTP.

To support these new protocols, OSG 3.6 includes HTCondor 9.0, HTCondor-CE 5, GlideinWMS 3.9, and XRootD 5.4.
We also dropped support for the GridFTP, GSI authentication, and Hadoop.

Known Issues
------------

The following issues are known to currently affect packages distributed in OSG 3.6:

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

### rrdtool ###

To improve support for Python 3 based GlideinWMS in EL7,
the EL7 OSG Yum repositories contain a newer version of `rrdtool` than the operating system repositories.
This may cause dependency solving issues with non-OSG packages.
Therefore, on EL7 hosts that are not running GlideinWMS, we suggest adding the following line under the `[osg]` section
of `/etc/yum.repos.d/osg.repo`:

```
excludepkgs=rrdtool
```

Latest News
-----------

### **March 30, 2023: EL9 and Gratia Probe 2.8.4**

!!! note "No tarball client updates"
    This release does not contain any tarball client updates for EL7 or EL8.
    Initial EL9 tarballs will be released at a later date.

-   Critical [Gratia Probe 2.8.4](https://github.com/opensciencegrid/gratia-probe/releases/tag/v2.8.4) update for
    HTCondor APs, fixing issues with `gratia-probe-condor-ap` 2.8.1 through 2.8.3.
    If you have any of these versions, please update and perform the following steps to process

        :::console
        # By default, this will bring you to /var/lib/condor-ce/gratia/data/
        root@host # cd $(condor_config_val PER_JOB_HISTORY_DIR)
        root@host # mv quarantine/history* .

-   This is the initial release of OSG Software Stack for EL9!
    Notable differences between EL9 and EL7/EL8 include:
    -   Frontier Squid 5.8-2.1

        !!! warning "If you've already installed `frontier-squid-5.8-1.1` on an EL9 host..."
            You will need to uninstall `frontier-squid` and remove `/etc/init.d`.
            If you have any other packages that have files in `/etc/init.d`, they may also need to be reinstalled and
            cleaned up in a similar fashion.

    -   HTCondor 10.3.0: see [upstream documentation](https://htcondor.readthedocs.io/en/latest/version-history/upgrading-from-9-0-to-10-0-versions.html)
        for manual update steps.
    -   HTCondor-CE 6.0.0: see [upstream documentation](https://htcondor.com/htcondor-ce/v6/releases/#updating-to-htcondor-ce-6)
        for manual update steps.
    -   Missing packages to be released at a later date:
        -   hosted-ce-tools
        -   htgettoken
        -   osg-update-data

### ** March 16, 2023:** OSDF Client 6.10.0
-   [OSDF Client 6.10.0](https://github.com/htcondor/osdf-client/releases/tag/v6.10.0)
    -   The `stashcp` client, when run in a terminal, can acquire a new token via OAuth2 if supported by the upstream origin
    -   The use of the `http_proxy` can now be disabled via setting the `OSDF_DISABLE_HTTP_PROXY` environment variable
    -   The OSDF client can now handle `HTTP 206 Partial Content` responses
    -   `stash_plugin -get-caches <prefix>` will print out the caches to be used for a given prefix

### ** March 14, 2023:** IGTF 1.119, osg-scitokens-mapfile 12, XCache 3.4.0-3
-   CA certificates based on [IGTF 1.119](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Updated UKeScience Root (2007) with consistent string encodings (UK)
    -   Removed obsolete SHA1 subordinates DigiCertGridTrustCA-Classic
        and DigiCertGridCA-1-Classic from DigiCert, reflected in RPDNC namespaces
    -   Experimental (non-accredited) new InCommon RSA IGTF Server CA 2 (ICA under
        Sectigo USERTrust RSA root, for which namespaces have been updated) (US)
    -   Updated GridCanada CA with re-issued SHA-2 based root (CA)
    -   Updated CILogon basic, silver, and openid with re-issued SHA-2 certs (US)
    -   Updated UKeScience Root (2007) re-issued with SHA-2, retired 2A ICA (UK)
-   osg-scitokens-mapfile 12
    -   New token for USCMS local pilots
-   XCache 3.4.0-3
    -   Add xrootd-tcp-stats to osdf-cache

### ** March 9, 2023:** XRootD 5.5.3-1.2, frontier-squid 5.7-2.1, CVMFS 2.10.1
-   [XRootD 5.5.3-1.2](https://github.com/xrootd/xrootd/blob/v5.5.3/docs/ReleaseNotes.txt)
    -   Fix bug where GFAL davs writes fail on EL7 redirectors after eight hours
    -   XRootD 5.5.2 was not released because of critical bugs that are fixed in XRootD 5.5.3
-   [frontier-squid-5.7-2.1](http://www.squid-cache.org/Versions/v5/squid-5.7-RELEASENOTES.html)
    -   Uses first destination IP address that responds (dns\_v4\_first removed)
    -   Add MAJOR\_CVMFS sites cvmfs-stratum-one.cc.kek.jp, cvmfs*.sdcc.bnl.gov
    -   Remove obsolete sites frontier*.racf.bnl.gov from ATLAS\_FRONTIER
    -   Fix bug where old caches may not be cleaned up

!!! note
    Manual intervention is needed to downgrade `frontier-squid`.

        :::console
        # Downgrade instructions
        root@host # rpm -e --nodeps frontier-squid
        root@host # yum install 'frontier-squid < 11:5

-   [CVMFS 2.10.1](https://cvmfs.readthedocs.io/en/stable/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-10-1)
    -   Minor bug fixes and improvements

### ** March 2, 2023:** gratia-probe 2.8.2, osg-flock 1.9
-   gratia-probe 2.8.2
    -   CRITICAL bug fix for sites that have installed `gratia-probe-htcondor-ce-2.8.2` or
        `gratia-probe-condor-ap-2.8.2`. After updating to 2.8.2, perform the following manual steps for a CE:

            :::console
            # By default, this will bring you to /var/lib/condor-ce/gratia/data/
            root@host # cd $(condor_ce_config_val PER_JOB_HISTORY_DIR)
            root@host # mv quarantine/history*.0 .

        And for an AP:

            :::console
            # By default, this will bring you to /var/lib/condor-ce/gratia/data/
            root@host # cd $(condor_config_val PER_JOB_HISTORY_DIR)
            root@host # mv quarantine/history*. .

-   osg-flock 1.9
    -   Adds the "OSPool" attribute to the job ad based on the EP configuration

### ** February 21, 2023:** VO Package v130
-   [VO Package v130](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-130)
    -   Update DN for voms2.fnal.gov

### ** February 16, 2023:** gratia-probe 2.8.1, python-scitokens 1.7.4
-   gratia-probe 2.8.1
    -   gratia-probe-condor-ap: important reporting update for APs with access to multiple pools (e.g., flocking)
-   [python-scitokens 1.7.4](https://github.com/scitokens/scitokens/releases)
    -   Remove aud enforcement from deserialize function

### ** February 7, 2023:** VO Package v129
-   [VO Package v129](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-129)
    -   Update DN for voms1.fnal.gov

!!! note
    The CA/Browser Forum has changed DN formats again this year.
    This will affect certificates issued by IGTF CAs.

### ** February 2, 2023:** GlideinWMS 3.10.1, osg-client 6.9.5, htvault-config 1.14
-   [GlideinWMS 3.10.1](https://glideinwms.fnal.gov/doc.v3_10_1/history.html#stable)
    -   Production release supporting tokens and Python 3
    -   Fix monitoring by including Glidein IDs with SciTokens
    -   Add Python module to help with custom scripts
    -   Custom setup scripts written in shell should always use the gconfig\_\* functions introduced in
        [3.9.6](https://glideinwms.fnal.gov/doc.v3_10_1/history.html#development) to read and write glidein configuration.
        See the release notes for details.
-   [osdf-client 6.9.5](https://github.com/htcondor/osdf-client/releases/tag/v6.9.5)
    -   Better handling of failures and broken proxies
    -   Various token handling bug fixes
    -   Add support for specifying token name in URL
-   htvault-config 1.14
    -   Add auditlog option to move the audit log to a different location

### ** January 17, 2023:** VO Package v128
-   [VO Package v128](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-128)
    -   Update HCC, GLOW, and OSG VOMS certificates

### ** January 3, 2023:** htgettoken 1.16
-   Fix ``httokendecode -H`` functionality to only attempt to convert a parsed word
    if it is entirely numeric, not if it just contains one digit
-   At the same time, rewrite this functionality in native ``bash`` instead of using ``grep`` and ``sed``
-   Add ``htdestroytoken`` command
-   Add ``htdecodetoken`` symbolic link that points to ``httokendecode``

### ** December 22, 2022:** VO Package v127
-   [VO Package v127](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-127)
    -   Update VOMS certificates for DESY VOs (IceCube, Belle, ILC, and others)
-   Rebuild packages and sign with new repository key (no software changes)
    -   cigetcert
    -   cilogon-openid-ca-cert
    -   cvmfs-config-osg
    -   cvmfs-gateway
    -   javascriptrrd
    -   osg-ca-certs-updater
    -   osg-ca-scripts
    -   osg-system-profiler
    -   osg-update-vos
    -   python-jwt
    -   scitokens-credmon

### ** December 8, 2022:** osg-scitokens-mapfile 11, XRootD 5.5.1, CVMFS 2.10.0, GlideinWMS 3.9.6, XCache 3.3.0, Vault 1.12.1
-   osg-scitokens-mapfile 11
    -   Support HEPCloud factory
-   [XRootD 5.5.1](https://github.com/xrootd/xrootd/blob/v5.5.1/docs/ReleaseNotes.txt)
    -   Fixes critical issue with XRootD FUSE mounts via xrdfs
-   [CVMFS 2.10.0](https://cvmfs.readthedocs.io/en/stable/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-10-0)
    -   Support for proxy sharding with the new client option `CVMFS_PROXY_SHARD={yes|no}`
    -   Improved use of the kernel page cache resulting in significant client performance improvements in some scenarios
    -   Fix for a long-standing open issue regarding the concurrent reading of changing files
    -   Support for unpacking container images through Harbor registry proxies in the container conversion tools
-   [GlideinWMS 3.9.6](https://glideinwms.fnal.gov/doc.v3_9_6/history.html#development)
    -   Adds token (and hybrid) support for Clouds (AWS/GCE)
-   XCache 3.3.0
    -   Removed X.509 proxy requirement for an unauthenticated stash-cache instance
-   [Vault 1.12.1](https://discuss.hashicorp.com/t/vault-1-12-1-1-11-5-and-1-10-8-released/46374)
    -   Includes a fix to prevent a potential denial of service attack for HA installations

### ** November 21, 2022:** VO Package v126
-   [VO Package v126](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-126-1)
    -   Update VOMS certificates for DESY VOs (IceCube, Belle, ILC, and others)

!!! note
    Any sites supporting "IceCube", "Belle", or "ILC" **must** update.
    If not, pilots will not arrive or jobs will have storage access issues.

### ** November 3, 2022:** HTCondor-CE 5.1.6, osdf-client 6.9.2, xrootd-multiuser 2.1.2, XCache 3.2.3; Upcoming: HTCondor 9.12.0
-   HTCondor-CE 5.1.6
    -   HTCondor-CE now uses the C++ Collector plugin for payload job traceability
    -   Fix HTCondor-CE mapfiles to be compliant with PCRE2 and HTCondor 9.10.0+
    -   Add support for multiple APEL accounting scaling factors
    -   Suppress spurious log message about a missing negotiator
    -   Fix crash in HTCondor-CE View
-   osdf-client 6.9.2 (includes stashcp and condor\_stash\_plugin)
    -   Add support for osdf:// URLs
    -   Fix zero-byte file upload error
-   xrootd-multiuser 2.1.2
    -   Fix advertising of files not readable by the "xrootd" user
-   XCache 3.2.3
    -   Update XCache systemd overrides for xrootd-multiuser 2.1.2
-   Upcoming: [HTCondor 9.12.0](https://htcondor.readthedocs.io/en/v9_1/version-history/development-release-series-91.html#version-9-12-0)
    -   Provide a mechanism to bootstrap secure authentication within a pool
    -   Add the ability to define submit templates
    -   Administrators can now extend the help offered by condor\_submit
    -   Add DAGMan ClassAd attributes to record more information about jobs
    -   On Linux, advertise the x86\_64 micro-architecture in a slot attribute
    -   Added -drain option to condor\_off and condor\_restart
    -   Administrators can now set the shared memory size for Docker jobs
    -   Multiple improvements to condor\_adstash
    -   HAD daemons now use SHA-256 checksums by default

### ** October 13, 2022:** HTCondor 9.0.17
-   [HTCondor 9.0.17](https://htcondor.readthedocs.io/en/v9_0/version-history/stable-release-series-90.html#version-9-0-17)
    -   Fix file descriptor leak when schedd fails to launch scheduler universe jobs
    -   Fix failure to forward batch grid universe job's refreshed X.509 proxy
    -   Fix DAGMan failure when the DONE keyword appeared in the JOB line
    -   Fix HTCondor's handling of extremely large UIDs on Linux
    -   Fix bug where OAUTH tokens lose their scope and audience upon refresh
    -   Support for Apptainer in addition to Singularity

### ** September 29, 2022:** XCache 3.2.2
-   XCache 3.2.2
    -   Allow specifying separate export paths for unauthenticated and authenticated origin instances
    -   Allow local scitokens.conf additions
    -   Fix authfile generation on origins that serve no public data
    
!!! note
    XRootD services should be restarted after this update

### ** September 16, 2022:** VO Package v125
-   [VO Package v125](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-125)
    -   DN changes for Gluex VO

### ** September 15, 2022:** XRootD 5.5.0, stashcp 6.8.1, osg-token-renewer 0.8.3
-   [XRootD 5.5.0](https://github.com/xrootd/xrootd/blob/v5.5.0/docs/ReleaseNotes.txt): Multiple new features and bug fixes
-   [stashcp 6.8.1](https://github.com/opensciencegrid/stashcp/releases/tag/v6.8.1)
    -   Fix WLCG token discovery
    -   Dynamically obtain list of caches based on the source file's namespace
-   [osg-token-renewer 0.8.3](https://github.com/opensciencegrid/osg-token-renewer/releases/tag/v0.8.3)
    -   Doesn't check for password file when ``--pw-fd`` is being used

### ** September 9, 2022:** VO Package v124
-   [VO Package v124](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-124)
    -    Add voms1.slac.stanford.edu VOMS server for LSST and SuperCDMS

### **August 30, 2022:** VO Package v123, IGTF 1.117
-   [VO Package v123](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-123)
    -    Update Virgo DNs
-   CA certificates based on [IGTF 1.117](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -    Add new intermediate ICA DigiCert Grid-TLS (US)
    -    Add new intermediate ICA DigiCert Grid-Client-RSA2048-SHA256-2022-CA1 (US)
    -    Removed discontinued NCSA-slcs-2013 following end of XSEDE (US)
    -    Removed discontinued PSC-Myproxy-CA following end of XSEDE (US)

### **August 25, 2022:** gratia-probe 2.7.1, HTCondor 9.11.0
-   gratia-probe 2.7.1
    -   Fix condor-ap probe bugs in resource name detection
-   Upcoming: [HTCondor 9.11.0](https://htcondor.readthedocs.io/en/v9_1/version-history/development-release-series-91.html#version-9-11-0)
    -   Modified GPU attributes to support the new `require_gpus` submit command
    -   Add `PREEMPT_IF_DISK_EXCEEDED` and `HOLD_IF_DISK_EXCEEDED` configuration templates
    -   `ADVERTISE` authorization levels now also provide `READ` authorization
    -   Periodic release expressions no longer apply to manually held jobs
    -   If a `#!` interpreter doesn't exist, a proper hold and log message appears
    -   Can now set the Singularity target directory with `container_target_dir`
    -   If SciToken and X.509 available, uses SciToken for arc job authentication
    -   Singularity now mounts `/tmp` and `/var/tmp` under the scratch directory
    -   Fix bug where Singularity jobs go on hold at the first checkpoint
    -   Report resources provisioned by the Slurm batch scheduler when available
    -   Fix bug where gridmanager deletes the X.509 proxy file instead of the copy
        -   Fixes jobs going on hold in the HTCondor-CE with the following message:

                HoldReason:Failed to get expiration time of proxy: unable to read proxy file


### **August 18, 2022:** HTCondor 9.0.16, xrootd-monitoring-shoveler 1.1.2
-  [HTCondor 9.0.16](https://htcondor.readthedocs.io/en/v9_0/version-history/stable-release-series-90.html#version-9-0-16)
    -   Singularity now mounts /tmp and /var/tmp under the scratch directory
    -   Fix bug where Singularity jobs go on hold at the first checkpoint
    -   Fix bug where gridmanager deletes the X.509 proxy file instead of the copy
        -   Fixes jobs going on hold in the HTCondor-CE with the following message:

                HoldReason:Failed to get expiration time of proxy: unable to read proxy file

-  xrootd-monitoring-shoveler 1.1.2
    -   Fix bug that affects those using the auto-renewal of tokens

### **July 28, 2022:** gratia-probe 2.7.0, blahp 2.2.1, HTCondor 9.0.15, CVMFS 2.9.3
-  gratia-probe 2.7.0
    -   Fix issue with accounting for whole node Slurm pilots by reporting allocated CPUs if available
    -   Fix broken dcache-transfer probe
    -   Improve mechanism to extract Resource Name
    -   Add back missing gratia-probe-services package
-  blahp 2.2.1
    -   Report allocated CPUs of Slurm jobs in status result
    -   Disable email notifications for blahp-\>condor jobs
-  [HTCondor 9.0.15](https://htcondor.readthedocs.io/en/v9_0/version-history/stable-release-series-90.html#version-9-0-15)
    -   Report resources provisioned by the Slurm batch scheduler when available
    -   SciToken mapping failures are now recorded in the HTCondor daemon logs
    -   Fix bug that stopped file transfers when output and error are the same
    -   Ensure that the Python bindings version matches the installed HTCondor
    -   $(OPSYSANDVER) now expand properly in job transforms
    -   Fix bug where context managed Python htcondor.SecMan sessions crash
    -   Fix bug where remote CPU times would rarely be set to zero
-  [CVMFS 2.9.3](https://cvmfs.readthedocs.io/en/stable/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-9-3)
    -   Bug fix for a type of client crash
    -   Bug fix for server garbage collection unreleased locks
-  osg-xrootd 3.6-18
    -   Enable VOMS support in authenticated stash caches and origins
    -   Add ability to turn off VOMS support via environment variable
-  XRootD 5.4.3-1.2
    -   Improve logging for xrootd-scitokens
-  htgettoken 1.15
    -   Improve support for vault service using round-robin DNS
-  Upcoming: [HTCondor 9.10.1](https://htcondor.readthedocs.io/en/v9_1/version-history/development-release-series-91.html#version-9-10-1)
    -   ActivationSetupDuration is now correct for jobs that checkpoint
    -   With collector administrator access, can manage HTCondor pool daemons
    -   SciTokens can now be used for authentication with ARC CE servers
    -   Prevent negative values when using huge files with file transfer plugins

### **June 16, 2022:** HTCondor-CE 5.1.5, gratia-probe 2.6.1, GlideinWMS 3.9.5, HTCondor 9.0.13
-   HTCondor-CE 5.1.5
    -   Fix whole node job glidein CPUs and GPUs expressions that caused held jobs
    -   Fix bug where default CERequirements were being ignored
    -   Pass whole node request from GlideinWMS to the batch system
    -   Rename AuthToken attributes in the routed job to better support accounting
    -   Prevent GSI environment from pointing the job to the wrong certificates
    -   Fix issue where HTCondor-CE would need port 9618 open to start up
-   gratia-probe 2.6.1
    -   Log schedd cron errors with newer versions of HTCondor
    -   Replace AuthToken\* references with routed job attributes
    -   Remove certinfo flie log messages
    -   Fix crash on send failure
-   [GlideinWMS 3.9.5](https://glideinwms.fnal.gov/doc.v3_9_5/history.html#development)
    -   Support for Apptainer
    -   Support for CVMFS on-demand
    -   Configurable idtokens lifetime
    -   Improved frontend logging
    -   Improved default SHARED\_PORT configuration
    -   Special handling of multiline condor config values
    -   Several bug fixes
-   [HTCondor 9.0.13](https://htcondor.readthedocs.io/en/v9_0/version-history/stable-release-series-90.html#version-9-0-13): Bug fix release
    -   Schedd and startd cron jobs can now log output upon non-zero exit
    -   condor\_config\_val now produces correct syntax for multi-line values
    -   The condor\_run tool now reports submit errors and warnings to the terminal
    -   Fix issue where Kerberos authentication would fail within DAGMan
    -   Fix HTCondor startup failure with certain complex network configurations
-   [VO Package v122](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-122)
    -   Add new sPHENIX and EIC VO certificates
  -   XCache 3.1.0
    -   Fixed library dependency issues for xcache-reporter
    -   Add systemd overrides for xrootd-privileged
-   [XRootD 5.4.3](https://github.com/xrootd/xrootd/blob/v5.4.3/docs/ReleaseNotes.txt): Bug fix release
-   stashcp 6.7.5
    -   Adds multi-file transfer and improved error messages
    -   Relax download timeouts for file transfer plugin
    -   Multiple bug fixes
-   htvault-config 1.13
    -   Removes support for old style secret storage; requires htgettoken >= 1.7
-   htgettoken 1.12
    -   Avoids crash when verbose output includes UTF-8
-   osg-pki-tools 3.5.2
    -   Bug fix for osg-incommon-cert-request when using host file
-   osg-token-renewer 0.8.2
    -   Use oidc-agent's built-in password file option
    -   Ensure tokens are renewed more frequently than their lifespan
-   rrdtool 1.8.0-1.2.el7
    -   Make Python RRDtools available to GlideinWMS
-   xrootd-multiuser 2.0.4
    -   Fix crash on Enterprise Linux 8
-   osg-release 3.6-5: Add osg-next yum repository
-   Upcoming
    -   [HTCondor 9.9.1](https://htcondor.readthedocs.io/en/update/version-history/development-release-series-91.html#version-9-9-1)
        -   A new authentication method for remote HTCondor administration
        -   Several changes to improve the security of connections
        -   Fix issue where DAGMan direct submission failed when using Kerberos
        -   The submission method is now recorded in the job ClassAd
        -   Singularity jobs can now pull from Docker style repositories
        -   The OWNER authorization level has been folded into the ADMINISTRATOR level

### **May 24, 2022:** VO Package v121
-   [VO Package v121](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-121-1)
    -   Add new VO certificates for CLAS12 and EIC

### **May 11, 2022:** OSG Worker Node Client and Tarballs
-   OSG worker node client 3.6-5
    -   Add in missing `stashcp` and `voms-client-cpp` packages

!!! warning
    The current [OASIS tarball](../worker-node/install-wn-oasis.md) link now points to the OSG 3.6 tarball.

    Packages no longer available in the OSG worker node tarball include:

    -   fts-client (was present in EL7 only)
    -   MyProxy
    -   GridFTP clients (e.g. globus-url-copy)
    -   UberFTP
    -   SRM and GridFTP plugins for GFAL2
    -   GSISSH client


### **May 5, 2022:** HTCondor 9.0.12, XCache 3.0.1, gratia-probe 2.5.2
-   [HTCondor 9.0.12](https://htcondor.readthedocs.io/en/v9_0/version-history/stable-release-series-90.html#version-9-0-12): Bug fix release
-   XCache 3.0.1
    -   Fixed library dependency issues for xcache-reporter
-   gratia-probe 2.5.2
    -   Remove pre-routed jobs instead of quarantining them
    -   Always set MapUnknownToGroup
-   osg-flock 1.8
    -   Remove MapUnknownToGroup and MapGroupToRole from osg-flock
    -   Advertise osg-flock version in the osg-flock RPM

### **April 26, 2022:** CVMFS 2.9.2, Upcoming: HTCondor 9.8.1

-   CA certificates based on [IGTF 1.116](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Updated intermediate CERN Grid CA ICA with extended validity (CERN)
-   [CVMFS 2.9.2](https://cvmfs.readthedocs.io/en/2.9/cpt-releasenotes.html): Bug fix release
-   cigetcert 1.20: works better with CILogon's AWS infrastructure
-   osg-ce 3.6-5
    -   Add OSG\_SERIES = 3.6 as a schedd attribute
    -   Remove default BATCH\_GAHP configuration now provided by upstream
-   osg-pki-tools 3.5.1: Python 3 fixes for osg-incommon-cert-request
-   osg-xrootd 3.6-16
    -   Fix stash-cache: enabling VOMS causes unauth cache to crash
-   vault 1.10, htvault-config 1.12 htgettoken 1.11
    -   Update from upstream software and change httokendecode to also
          verify tokens if scitokens-verify is present
-   VOMS 2: Update default proxy certificate key length to 2048 bits
-   Upcoming: [HTCondor 9.8.1](https://htcondor.readthedocs.io/en/update/version-history/development-release-series-91.html#version-9-8-1)
    -   Support for Heterogeneous GPUs, some configuration required
    -   Allow HTCondor to use grid sites requiring multi-factor authentication
    -   Technology preview: bring your own resources from HPC clusters
    -   Fix HTCondor startup failure with complex network configurations

### **April 14, 2022:** osg-configure 4.1.1, osg-scitokens-mapfile 8

-   [OSG-Configure 4.1.1](https://github.com/opensciencegrid/osg-configure/releases/tag/v4.1.1)
    -   Fix gratia DataFolder/PER\_JOB\_HISTORY\_DIR check for HTCondor-CE with an HTCondor batch system
-   osg-scitokens-mapfile 8
    -   New token mappings for CMS local and USCMS local pilots.
    -   New token mappings for HCC pilots

### **March 31, 2022:** IGTF 1.115

This release contains updated CA Certificates based on [IGTF 1.115](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)

-    Removed obsolete CNRS2 CAs, superseded by AC-GRID-FR hierarchy (FR)
-    Add supplementary BCDR download location for UGRID-G2 CRL (UA)
-    Extended validity period of HPCI CA (JP)

### **March 24, 2022:** XRootD 5.4.2-1.1, HTCondor 9.0.11, stashcp 6.6.0

-   [XRootD 5.4.2](https://github.com/xrootd/xrootd/blob/v5.4.2/docs/ReleaseNotes.txt) plus OSG patches
    -   [Add support for VOMS mapfiles](https://opensciencegrid.atlassian.net/browse/SOFTWARE-4870)
    -   [Fix DN hashing for HTTPS transfers](https://github.com/xrootd/xrootd/pull/1640)
    -   [Add new throttling for max open files and active connections per entity](https://github.com/xrootd/xrootd/pull/1582)
-   [HTCondor 9.0.11](https://htcondor.readthedocs.io/en/v9_0/version-history/stable-release-series-90.html#version-9-0-11)
    -   The Job Router can now create an IDTOKEN for use by the job
        -   Fix bug where a self-checkpointing job may erroneously be held
        -   Fix bug where the Job Router erroneously substitutes a default value
        -   Fix bug where a file transfer error may identify the wrong file
        -   Fix bug where condor_ssh_to_job may fail to connect
-   [stashcp 6.6.0](https://github.com/opensciencegrid/stashcp/releases/tag/v6.6.0)
    -   Rewritten in Go
    -   New features
        -   HTCondor File Transfer plugin interface
        -   Progress bar on interactive terminals
        -   Recursive downloads
        -   WLCG token discovery
-   [python-scitokens 1.7.0](https://github.com/scitokens/scitokens/releases/tag/v1.7.0)
-   osg-token-renewer 0.8.1: Add support for manual client registration
-   [xrootd-monitoring-shoveler 1.0.0](https://github.com/opensciencegrid/xrootd-monitoring-shoveler/releases/tag/v1.0.0): Initial release
-   [vault 1.9.3](https://github.com/hashicorp/vault/releases/tag/v1.9.3)
-   [htgettoken 1.10](https://github.com/fermitools/htgettoken/releases/tag/v1.10)
    -   Upcoming
        -   [HTCondor 9.7.0](https://htcondor.readthedocs.io/en/v9_1/version-history/development-release-series-91.html#version-9-7-0)
            -   Support environment variables, application elements in ARC REST jobs
            -   Container universe supports Singularity jobs with hard-coded command
            -   DAGMan submits jobs directly (does not shell out to condor_submit)
            -   Meaningful error message and sub-code for file transfer failures
            -   Add file transfer statistics for file transfer plugins
            -   Add named list policy knobs for SYSTEM_PERIODIC_ policies

### **March 15, 2022:** High Priority Release

-   HTCondor 9.0.10 and 9.6.0 Security Release. This release contains fixes for important security issues. More details on the security issues are in the vulnerability reports:
    -   [HTCONDOR-2022-0001](https://htcondor.org/security/vulnerabilities/HTCONDOR-2022-0001)
    -   [HTCONDOR-2022-0002](https://htcondor.org/security/vulnerabilities/HTCONDOR-2022-0002)
    -   [HTCONDOR-2022-0003](https://htcondor.org/security/vulnerabilities/HTCONDOR-2022-0003)

### **March 3, 2022:** XRootD 5.4.1 and GlideinWMS 3.9.4

-   [XRootD 5.4.1](https://github.com/xrootd/xrootd/blob/v5.4.1/docs/ReleaseNotes.txt): Bug fix release
-   osg-xrootd 3.6-15
-   [GlideinWMS 3.9.4](https://glideinwms.fnal.gov/doc.v3_9_4/history.html#development)
    -   Add flexible mount points for CVMFS in the Glideins (not always /cvmfs)
    -   Per-Entry IDTOKENS
    -   Support per-group SciTokens
    -   Frontend and Factory check the expiration of SciTokens, other JWT tokens
    -   Bug Fixes:
        -   IDTOKEN issuer changed from collector host to trust domain
        -   X.509 proxy is now renewed also when using also tokens
    -   shared port is now the default in the User (VO) Collector HTCondor

### **February 17, 2022:** VO Package v120

-   [VO Package v120](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-120)
    -   Update FNAL voms1 DN

### **February 10, 2022:** HTCondor 9.0.9 LTS

-   [HTCondor 9.0.9 LTS](https://www-auth.cs.wisc.edu/lists/htcondor-world/2022/msg00000.shtml)
    -   The OAUTH credmon is now available on Enterprise Linux 8
    -   Deprecated C-style comments no longer cause the job router to crash
-   [VO Package v119](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-119)
    -   Update OSG VO and GLOW VO DNs
-   hosted-ce-tools 0.9: new for Enterprise Linux 8
-   scitokens-credmon 0.8.1: new for Enterprise Linux 8

### **February 3, 2022:** Gratia Probe 2.5.1

-   gratia-probe 2.5.1
    -   Fix a bug that prevented record generation for HTCondor batch systems.  Manual intervention required; see [this documentation](updating-to-osg-36.md#htcondor-batch-systems) for details.
    -   Fix ownership of the record quarantine directory
-   osg-flock 1.7
    -   Fixed capitalization of the OSG VO in the default accounting configuration (access point admins that have already updated to osg-flock-1.6 should change VOOverride="OSG" to VOOverride="osg" in /etc/gratia/condor-ap/ProbeConfig)
    -   Dropped configuration required for old versions of HTCondor
-   [VO Package v118](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-118)
    -   Update FNAL voms2 DN

### **January 27, 2022:** VO Package v117 and OSG SciTokens mapfile 5

-   [VO Package v117](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-117)
    -   Update GlueX DN
    -   Update hcc-voms2 DN
    -   Add ATLAS IAM vomses entry
-   osg-scitokens-mapfile 5
    -   Add default SciTokens mappings for the FNAL VOs

### **January 20, 2022:** CVMFS 2.9.0 and HTCondor 5.1.3 updates

-   CA Certificates based on [IGTF 1.114](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Extend validity for SlovakGrid issuing CA (SK)
    -   Remove expired Let's Encrypt ROOT CA X3 and X4
-   [CVMFS 2.9.0](https://cvmfs.readthedocs.io/en/2.9/cpt-releasenotes.html)
    -   Incremental conversion of container images, resulting in a large speed-up for publishing new container image versions to unpacked.cern.ch
    -   Support for maintaining repositories in S3 over HTTPS (not just HTTP)
    -   Significant speed-ups for S3 and gateway publisher deployments
    -   Various bugfixes and smaller improvements (error reporting, repository statistics, network failure handling, etc.)
-   [HTCondor-CE 5.1.3](https://github.com/htcondor/htcondor-ce/releases/tag/v5.1.3)
    -   The HTCondor-CE central collector requires SSL credentials from client CEs
    -   Fix BDII crash if an HTCondor Access Point is not available
    -   Fix formatting of APEL records that contain huge values
    -   HTCondor-CE client mapfiles are not installed on the central collector
-   osg-xrootd 3.6-12
    -   Fix default location for grid-mapfile when using HTTP/WebDAV transfer
    -   Fix monitoring of writes
-   osg-ce 3.6-4
    -   Release the osg-ce-bosco package


### **January 13, 2022:** XRootD 5.4.0 and Vault updates

-   [XRootD 5.4.0](https://github.com/xrootd/xrootd/releases/tag/v5.4.0): New feature release
    -   Fix problem interacting with version 5.1 or 5.2 origin servers
-   xrootd-tcp-stats 1.0.0: Initial release of TCP statistics plugin
-   vault 1.9.0, htvault-config 1.11, htgettoken 1.9
    -   upgrade to latest vault
    -   add support for ssh-agent authentication
-   [VO Package v116](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-116)
    -   Add second Belle2 VOMS server
-   [oidc-agent 4.2.4](https://github.com/indigo-dc/oidc-agent/releases)
    -   Upgrade to new major version from version 3.3.3
    -   NOTE: oidc-agent must be restarted after upgrade
-   osg-scitokens-mapfile 4
    -    Add default ATLAS token mappings
-   osg-pki-tools 3.5.0-2: Upgrade to Python 3

### **December 9, 2021:** XRootD and HTCondor updates

!!!warning "Problem interoperating with older origin servers"
    If an XRootD 5.3.4 cache interacts with a 5.1 or 5.2 origin and there is an asyncio error, it may crash the origin.
    Please upgrade your origin at your earliest convenience.
    You may turn off asyncio (`async off`) on either end to avoid the problem.

-   [XRootD 5.3.4](https://github.com/xrootd/xrootd/blob/v5.3.4/docs/ReleaseNotes.txt)
    -   Fix uncorrectable checksum errors in XCache Origins
-   [HTCondor 9.0.8 LTS](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00027.shtml)
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
-   [HTCondor 9.0.7](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00025.shtml): Bug fix release
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
    -   [HTCondor 9.3.0](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00026.shtml)
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

-   Initial release of the [osg-token-renewer](https://osg-htc.org/docs/other/osg-token-renewer/): a service to manage automatic renewal of bearer tokens from OIDC providers (e.g., CILogon, IAM), intended for use by VO managers
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


This initial release of the OSG 3.6 release series is based on the packages available in OSG 3.5.31.
One of the major changes in this release series is the shift to token-based authentication from GSI proxy-based
authentication.
Here is a list of the differences in this initial release:

-   GridFTP, GSI, and Hadoop are no longer available
-   Added packages to support token-based authentication
-   [HTCondor 8.9.11](https://htcondor.readthedocs.io/en/v9_0/version-history/development-release-series-89.html#version-8-9-11):
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
[Software Release Policy](https://osg-htc.org/technology/policy/software-release/) to follow a rolling
release model.

Finally, our [Docker image releases](https://osg-htc.org/technology/policy/container-release/) will more
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
