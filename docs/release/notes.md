OSG 3.5 Release Notes
=====================

**Supported OS Versions:** EL7

The OSG 3.5 release series introduces HTCondor 8.8 and 8.9, available in `osg-release` and `osg-upcoming`, respectively.
It also drops support for the RSV monitoring probes, CREAM CEs, and Enterprise Linux 6.
See the initial [OSG 3.5.0 release notes](3.5/release-3-5-0.md) for additional details.

To update to the OSG 3.5 series, please consult the page on
[updating between release series](updating-to-osg-35.md).

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 offers a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Known Issues
------------

The following issues are known to currently affect packages distributed in OSG 3.5:

### HTCondor-CE ###

-   C-style comments, e.g. `/* comment /*`, in `JOB_ROUTER_ENTRIES` will prevent the JobRouter from routing jobs
    ([HTCONDOR-864](https://opensciencegrid.atlassian.net/browse/HTCONDOR-864)).
    For the time being, remove any comments if you are still using the
    [deprecated syntax](https://htcondor.com/htcondor-ce/v5/configuration/job-router-overview#deprecated-syntax).

Releases
--------

| Version                             | Date       | Summary                                                                       |
|:------------------------------------|:-----------|:------------------------------------------------------------------------------|
| [3.5.50](3.5/release-3-5-50.md)     | 2021-11-11 | osg-ca-certs-updater 2.0; Upcoming: xrootd-multiuser 2.0.3                    |
| [3.5.49](3.5/release-3-5-49.md)     | 2021-10-13 | osg-token-renewer 0.7.1; Upcoming: HTCondor 9.0.6, blahp 2.1.3                |
| [3.5.48-2](3.5/release-3-5-48-2.md) | 2021-10-05 | IGTF 1.113                                                                    |
| [3.5.48](3.5/release-3-5-48.md)     | 2021-09-30 | osg-ca-certs, osg-wn-client, CVMFS 2.8.2, cvmfs-x509-helper, vault 1.8.2, htvault-config 1.6, htgettoken 1.6; Upcoming: GlideinWMS 3.7.5, xrootd-multiuser 2.0.2, HTCondor 9.0.6 |
| [3.5.47](3.5/release-3-5-47.md)     | 2021-09-23 | Upcoming: HTCondor-CE 5.1.2                                                   |
| [3.5.46](3.5/release-3-5-46.md)     | 2021-09-09 | Upcoming: HTCondor 9.0.5, blahp 2.1.1                                         |
| [3.5.45-2](3.5/release-3-5-45-2.md) | 2021-08-16 | IGTF 1.112                                                                    |
| [3.5.45](3.5/release-3-5-45.md)     | 2021-08-12 | gratia-probe 1.24.0; Upcoming: XRootD 5.3.1                                   |
| [3.5.44](3.5/release-3-5-44.md)     | 2021-08-05 | VOMS 2.0.16 (EL7), VOMS 2.1.0-rc2 (EL8), htvault-config 1.4, htgettoken 1.3; Upcoming: XCache 2.0.1 |
| [3.5.43](3.5/release-3-5-43.md)     | 2021-07-30 | High Priority Release: HTCondor 8.8.15; Upcoming: HTCondor 9.0.4              |
| [3.5.42](3.5/release-3-5-42.md)     | 2021-07-27 | High Priority Release: HTCondor 8.8.14; Upcoming: HTCondor 9.0.3              |
| [3.5.41](3.5/release-3-5-41.md)     | 2021-07-22 | Upcoming: HTCondor 9.0.2, blahp 2.1.0, XRootD 5.3.0                           |
| [3.5.40-2](3.5/release-3-5-40-2.md) | 2021-07-15 | VO Package v114                                                               |
| [3.5.40](3.5/release-3-5-40.md)     | 2021-07-01 | Frontier Squid 4.15-2.1, vault 1.7.3, htvault-config 1.2, EL8: XRootD 4.12.6 and plugins, osg-flock 1.3, Upcoming: xrootd-multiuser 1.1.0 |
| [3.5.39](3.5/release-3-5-39.md)     | 2021-06-24 | scitokens-cpp 0.6.2, Upcoming: HTCondor 9.0.1-1.1, HTCondor-CE 5.1.1-1.1      |
| [3.5.38-2](3.5/release-3-5-38-2.md) | 2021-06-16 | VO Package v113                                                               |
| [3.5.38](3.5/release-3-5-38.md)     | 2021-06-10 | HTCondor 8.8.13-1.1, Upcoming: XRootD 5.2.0, xrootd-hdfs 2.2.0-1.1            |
| [3.5.37](3.5/release-3-5-37.md)     | 2021-06-03 | HTCondor-CE 4.5.2, gratia-probe 1.23.3, vault 1.7.2, osg-gridftp on EL8, Upcoming: GlideinWMS 3.7.4 |
| [3.5.36-2](3.5/release-3-5-36-2.md) | 2021-05-25 | IGTF 1.111                                                                    |
| [3.5.36](3.5/release-3-5-36.md)     | 2021-05-17 | HTCondor 8.8.13; Upcoming: HTCondor 9.0.0-1.5, HTCondor-CE 5.1.0, GlideinWMS 3.7.3 |
| [3.5.35](3.5/release-3-5-35.md)     | 2021-05-13 | High Priority Release: Frontier Squid 4.15-1.2, IGTF 1.110                    |
| [3.5.34](3.5/release-3-5-34.md)     | 2021-04-22 | CVMFS 2.8.1, gratia-probe 1.23.2                                              |
| [3.5.33](3.5/release-3-5-33.md)     | 2021-04-01 | Upcoming: XRootD 5.1.1 and plugins, XCache 2.0.0                              |
| [3.5.32](3.5/release-3-5-32.md)     | 2021-03-25 | Vault 1.6.2-1, SciTokens mapfile, VO Package v110; Upcoming: HTcondor 8.9.11-1 |
| [3.5.31](3.5/release-3-5-31.md)     | 2021-02-04 | CVMFS 2.8.0, XRootD 4.12.6, osg-ca-certs 1.94, osg-release 3.5-5, osg-flock 1.3, python-scitokens 1.3.1 |
| [3.5.30](3.5/release-3-5-30.md)     | 2021-01-27 | High Priority Release:  Upcoming: HTCondor 8.9.11                             |
| [3.5.29](3.5/release-3-5-29.md)     | 2021-01-21 | IGTF 1.109, osg-configure 3.11.0, htgettoken 1.1, Upcoming: GlideinWMS 3.7.2  |
| [3.5.28-2](3.5/release-3-5-28-2.md) | 2020-12-15 | IGTF 1.108                                                                    |
| [3.5.28](3.5/release-3-5-28.md)     | 2020-12-10 | osg-ca-certs 1.90, htgettoken 1.0, XRootD 4.12.5, HTCondor 8.8.12; Upcoming: HTCondor 8.9.10 |
| [3.5.27](3.5/release-3-5-27.md)     | 2020-11-12 | gfal2 2.18.1-1.1; Upcoming: HTCondor 8.9.9, GlideinWMS 3.7.1                  |
| [3.5.26](3.5/release-3-5-26.md)     | 2020-11-05 | gfal2 2.18.1, HTCondor 8.8.11, CVMFS 2.7.5, osg-flock 1.2, python-scitokens 1.2.4-3, scitokens-credmon 0.8.1; Upcoming: XRootD 5.0.2 |
| [3.5.25-2](3.5/release-3-5-25-2.md) | 2020-10-29 | VO Package v109                                                               |
| [3.5.25](3.5/release-3-5-25.md)     | 2020-10-08 | GlideinWMS 3.6.5, BLAHP 1.18.48; Upcoming: BLAHP 1.18.48                      |
| [3.5.24](3.5/release-3-5-24.md)     | 2020-09-17 | CVMFS 2.7.4, stashcache-client 6.1.0, hosted-ce-tools 0.8.2, CCTools 7.1.7, VO Package v108 |
| [3.5.23](3.5/release-3-5-23.md)     | 2020-09-03 | xrootd-hdfs 2.1.8, osg-release 3.5-4; Upcoming: HTCondor 8.9.8, XRootD 5.0.1 and associated plugins |
| [3.5.22](3.5/release-3-5-22.md)     | 2020-08-27 | HTCondor 8.8.10, Frontier Squid 4.13-1.1, XCache 1.5.2, xrootd-scitokens 1.2.2, gratia-probe 1.20.14, BLAHP 1.18.47, oidc-agent 3.3.3, XRootD plugins |
| [3.5.21-2](3.5/release-3-5-21-2.md) | 2020-08-10 | IGTF 1.107, VO Package v107                                                   |
| [3.5.21](3.5/release-3-5-21.md)     | 2020-07-30 | WN client and OASIS on EL8, HTCondor-CE 4.4.1, osg-flock 1.1-2, osg-pki-tools 3.4.0, osg-system-profiler 1.6.0, osg-xrootd 3.5-13, stashcache-client 6.0.0 |
| [3.5.20](3.5/release-3-5-20.md)     | 2020-07-23 | HTCondor-CE 4.4.0, CVMFS 2.7.3, Frontier Squid 4.12-2.1, scitokens-cpp 0.5.1  |
| [3.5.19](3.5/release-3-5-19.md)     | 2020-07-01 | XRoodD 4.12.3, xrootd-lcmaps 1.7.7, scitokens-credmon 0.7; Upcoming: HTCondor 8.9.7 |
| [3.5.18](3.5/release-3-5-18.md)     | 2020-06-11 | Frontier Squid 4.11-3.1, VOMS 2.0.14-6, XCache 1.4, stashcache-client 5.6.1   |
| [3.5.17](3.5/release-3-5-17.md)     | 2020-06-04 | BLAHP 1.18.46, HTCondor 8.8.9, gratia-probe 1.20.13, VO Package v106; Upcoming: GlideinWMS 3.7, HTCondor 8.9.7 |
| [3.5.16](3.5/release-3-5-16.md)     | 2020-05-14 | CVMFS 2.7.2, Frontier Squid 4.11-2.1, osg-ce 3.5-5, hosted-ce-tools 0.7, CCTools 7.1.5, VO Package v105 |
| [3.5.15-3](3.5/release-3-5-15-3.md) | 2020-05-06 | IGTF 1.106                                                                    |
| [3.5.15-2](3.5/release-3-5-15-2.md) | 2020-04-15 | VO Package v104                                                               |
| [3.5.15](3.5/release-3-5-15.md)     | 2020-04-08 | Frontier Squid 4.10.3, VO Package v103, XRootD 4.11.3, osg-xrootd 3.5-12      |
| [3.5.14](3.5/release-3-5-14.md)     | 2020-04-07 | High Priority Release: HTCondor 8.8.8; Upcoming: HTCondor 8.9.6               |
| [3.5.13](3.5/release-3-5-13.md)     | 2020-04-02 | GlideinWMS 3.6.2, IGTF 1.105, HTCondor-CE 4.2.1, Pegasus 4.9.3, LCMAPS 1.6.6-1.12, globus-gridftp-server 13.20-1.1, scitokens-cpp 0.5.0 |
| [3.5.12](3.5/release-3-5-12.md)     | 2020-03-26 | High Priority Release: XRootD-SciTokens 1.2.0                                 |
| [3.5.11](3.5/release-3-5-11.md)     | 2020-03-11 | CVMFS 2.7.1, oidc-agent 3.3.1, CCTools 7.0.22, GSI-OpenSSH 7.4p1-5, VO Package v101 |
| [3.5.10-2](3.5/release-3-5-10-2.md) | 2020-03-04 | VO Package v100                                                               |
| [3.5.10](3.5/release-3-5-10.md)     | 2020-02-20 | XRootD 4.11.2, XCache 1.2.1, VO Package v99, UberFTP 2.8-3, osg-configure 3.1.1, osg-system-profiler 1.5.0 |
| [3.5.9](3.5/release-3-5-9.md)       | 2020-02-06 | High Priority Release: Frontier Squid 4.10                                    |
| [3.5.8-4](3.5/release-3-5-8-4.md)   | 2020-01-30 | High Priority Release: IGTF 1.104                                             |
| [3.5.8-3](3.5/release-3-5-8-3.md)   | 2020-01-29 | High Priority Release: OSG CA certs based on IGTF 1.104 pre-release           |
| [3.5.8-2](3.5/release-3-5-8-2.md)   | 2020-01-28 | IGTF 1.103                                                                    |
| [3.5.8](3.5/release-3-5-8.md)       | 2020-01-16 | XRootD 4.11.1, VOMS 2.0.14-15, HTCondor 8.8.7, gratia-probe 1.20.12, osg-xrootd, host-ce-tools 0.5-2, scitokens-cpp 0.4.0, osg-ce, gsi-openssh, globus-gridftp-server, Upcoming: HTCondor 8.9.5 |
| [3.5.7](3.5/release-3-5-7.md)       | 2019-12-19 | HTCondor-CE 4.1.0, CVMFS 2.7.0, GlideinWMS 3.6.1, HTCondor 8.8.6; Upcoming: HTCondor 8.9.4 |
| [3.5.6](3.5/release-3-5-6.md)       | 2019-11-26 | XCache 1.2, CCTools 7.0.21, osg-release 3.5-3                                 |
| [3.5.5](3.5/release-3-5-5.md)       | 2019-11-14 | High Priority Release: Frontier Squid 4.9, XRootD 4.11.0, BLAHP 1.81.45, scitokens-credmon 0.4.2, scitokens-cpp 0.3.5 |
| [3.5.4](3.5/release-3-5-4.md)       | 2019-10-23 | HTCondor 8.8.5-1.7, StashCache-Client 5.5.0, IGTF 1.102, VO Package v97       |
| [3.5.3](3.5/release-3-5-3.md)       | 2019-10-17 | GlideinWMS 3.6, oidc-agent 3.2.6, scitokens-cpp 0.3.4, XRootD 4.10.1, HTCondor 8.8.5, osg-configure 3.1.0, gratia-probe 1.20.11; Upcoming: HTCondor 8.9.3 |
| [3.5.2](3.5/release-3-5-2.md)       | 2019-10-10 | HTCondor-CE 4.0.1, OSG CE 3.5-2, CVMFS 2.6.3, Frontier-Squid 4.8-2, CCTools 7.0.18, VO Package v96 |
| [3.5.1](3.5/release-3-5-1.md)       | 2019-09-19 | High Priority Release: MyProxy 6.2.6, GSI-OpenSSH, Globus GridFTP Server      |
| [3.5.0](3.5/release-3-5-0.md)       | 2019-08-30 | CVMFS 2.6.2, HTCondor 8.8.4, XCache 1.1.1, OSG XRootD 3.5, OSG Configure 3.0.0, XRootD LCMAPS 1.7.4, XRootD HDFS 2.1.6; Upcoming: HTCondor 8.9.2 |

Announcements
-------------

OSG releases are also announced by mail and are sent to the following recipients and lists:

-   [Registered administrative contacts](../common/registration.md#registering-resources)
-   [osg-general@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-GENERAL)
-   [osg-operations@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-OPERATIONS)
-   [osg-sites@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-SITES)
-   [site-announce@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=site-announce)
-   [software-discuss@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=software-discuss)
