Release Notes
=============

This page contains links to detailed notes for release in the currently supported
[OSG release series](/release/release_series).
For our policy on release series support, please consult
[this page](https://opensciencegrid.org/technology/policy/release-series/).

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 and 3.4 offer a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

OSG 3.5
-------

**Supported OS Versions:** EL7

The OSG 3.5 release series introduces HTCondor 8.8 and 8.9, available in `osg-release` and `osg-upcoming`, respectively.
It also drops support for the RSV monitoring probes, CREAM CEs, and Enterprise Linux 6.
See the initial [OSG 3.5.0 release notes](/release/3.5/release-3-5-0) for additional details.

To update to the OSG 3.5 series, please consult the page on
[updating between release series](/release/release_series#updating-to-osg-35).

| Version                                   | Date       | Summary                                                                 |
|:------------------------------------------|:-----------|:------------------------------------------------------------------------|
| [3.5.15-2](/release/3.5/release-3-5-15-2) | 2020-04-15 | VO Package v104                                                         |
| [3.5.15](/release/3.5/release-3-5-15)     | 2020-04-08 | Frontier Squid 4.10.3, VO Package v103, XRootD 4.11.3, osg-xrootd 3.5-12|
| [3.5.14](/release/3.5/release-3-5-14)     | 2020-04-07 | High Priority Release: HTCondor 8.8.8; Upcoming: HTCondor 8.9.6         |
| [3.5.13](/release/3.5/release-3-5-13)     | 2020-04-02 | GlideinWMS 3.6.2, IGTF 1.105, HTCondor-CE 4.2.1, Pegasus 4.9.3, LCMAPS 1.6.6-1.12, globus-gridftp-server 13.20-1.1, scitokens-cpp 0.5.0 |
| [3.5.12](/release/3.5/release-3-5-12)     | 2020-03-26 | High Priority Release: XRootD-SciTokens 1.2.0                           |
| [3.5.11](/release/3.5/release-3-5-11)     | 2020-03-11 | CVMFS 2.7.1, oidc-agent 3.3.1, CCTools 7.0.22, GSI-OpenSSH 7.4p1-5, VO Package v101 |
| [3.5.10-2](/release/3.5/release-3-5-10-2) | 2020-03-04 | VO Package v100                                                         |
| [3.5.10](/release/3.5/release-3-5-10)     | 2020-02-20 | XRootD 4.11.2, XCache 1.2.1, VO Package v99, UberFTP 2.8-3, osg-configure 3.1.1, osg-system-profiler 1.5.0 |
| [3.5.9](/release/3.5/release-3-5-9)       | 2020-02-06 | High Priority Release: Frontier Squid 4.10                              |
| [3.5.8-4](/release/3.5/release-3-5-8-4)   | 2020-01-30 | High Priority Release: IGTF 1.104                                       |
| [3.5.8-3](/release/3.5/release-3-5-8-3)   | 2020-01-29 | High Priority Release: OSG CA certs based on IGTF 1.104 pre-release     |
| [3.5.8-2](/release/3.5/release-3-5-8-2)   | 2020-01-28 | IGTF 1.103                                                              |
| [3.5.8](/release/3.5/release-3-5-8)       | 2020-01-16 | XRootD 4.11.1, VOMS 2.0.14-15, HTCondor 8.8.7, gratia-probe 1.20.12, osg-xrootd, host-ce-tools 0.5-2, scitokens-cpp 0.4.0, osg-ce, gsi-openssh, globus-gridftp-server, Upcoming: HTCondor 8.9.5 |
| [3.5.7](/release/3.5/release-3-5-7)       | 2019-12-19 | HTCondor-CE 4.1.0, CVMFS 2.7.0, GlideinWMS 3.6.1, HTCondor 8.8.6; Upcoming: HTCondor 8.9.4 |
| [3.5.6](/release/3.5/release-3-5-6)       | 2019-11-26 | XCache 1.2, CCTools 7.0.21, osg-release 3.5-3                           |
| [3.5.5](/release/3.5/release-3-5-5)       | 2019-11-14 | High Priority Release: Frontier Squid 4.9, XRootD 4.11.0, BLAHP 1.81.45, scitokens-credmon 0.4.2, scitokens-cpp 0.3.5 |
| [3.5.4](/release/3.5/release-3-5-4)       | 2019-10-23 | HTCondor 8.8.5-1.7, StashCache-Client 5.5.0, IGTF 1.102, VO Package v97 |
| [3.5.3](/release/3.5/release-3-5-3)       | 2019-10-17 | GlideinWMS 3.6, oidc-agent 3.2.6, scitokens-cpp 0.3.4, XRootD 4.10.1, HTCondor 8.8.5, osg-configure 3.1.0, gratia-probe 1.20.11; Upcoming: HTCondor 8.9.3 |
| [3.5.2](/release/3.5/release-3-5-2)       | 2019-10-10 | HTCondor-CE 4.0.1, OSG CE 3.5-2, CVMFS 2.6.3, Frontier-Squid 4.8-2, CCTools 7.0.18, VO Package v96 |
| [3.5.1](/release/3.5/release-3-5-1)       | 2019-09-19 | High Priority Release: MyProxy 6.2.6, GSI-OpenSSH, Globus GridFTP Server|
| [3.5.0](/release/3.5/release-3-5-0)       | 2019-08-30 | CVMFS 2.6.2, HTCondor 8.8.4, XCache 1.1.1, OSG XRootD 3.5, OSG Configure 3.0.0, XRootD LCMAPS 1.7.4, XRootD HDFS 2.1.6; Upcoming: HTCondor 8.9.2 |

OSG 3.4
-------

**Supported OS Versions:** EL7, EL6

!!!warning "OSG 3.4 End-of-Life Approaching"
    According to our
    [OSG Software Release Series Support Policy](https://opensciencegrid.org/technology/policy/release-series/),
    the OSG 3.4 series is due to reach
    [end-of-life](https://opensciencegrid.org/technology/policy/release-series/#life-cycle-dates) in **November 2020**.
    Please [upgrade to OSG 3.5](https://opensciencegrid.org/docs/release/release_series/#updating-to-osg-35)
    at your earliest convenience.


| Version                                   | Date       | Summary                                                                 |
|:------------------------------------------|:-----------|:------------------------------------------------------------------------|
| [3.4.49-2](/release/3.4/release-3-4-49-2) | 2020-04-15 | VO Package v104                                                         |
| [3.4.49](/release/3.4/release-3-4-49)     | 2020-04-08 | Frontier Squid 4.10.3, VO Package v103                                  |
| [3.4.48](/release/3.4/release-3-4-48)     | 2020-04-07 | High Priority Release: HTCondor 8.8.8                                   |
| [3.4.47](/release/3.4/release-3-4-47)     | 2020-04-02 | GlideinWMS 3.6.2, IGTF 1.105                                            |
| [3.4.46](/release/3.4/release-3-4-46)     | 2020-03-26 | High Priority Release: XRootD-SciTokens 1.2.0                           |
| [3.4.45](/release/3.4/release-3-4-45)     | 2020-03-11 | Singularity 3.5.3, VO Package v101                                      |
| [3.4.44-2](/release/3.4/release-3-4-44-2) | 2020-03-04 | VO Package v100                                                         |
| [3.4.44](/release/3.4/release-3-4-44)     | 2020-02-20 | XRootD 4.11.2, XCache 1.2.1, VO Package v99, UberFTP 2.8-3, osg-configure 2.5.1, osg-system-profiler 1.5.0 |
| [3.4.43](/release/3.4/release-3-4-43)     | 2020-02-06 | High Priority Release: Frontier Squid 4.10                              |
| [3.4.42-4](/release/3.4/release-3-4-42-4) | 2020-01-30 | High Priority Release: IGTF 1.104                                       |
| [3.4.42-3](/release/3.4/release-3-4-42-3) | 2020-01-29 | High Priority Release: OSG CA certs based on IGTF 1.104 pre-release     |
| [3.4.42-2](/release/3.4/release-3-4-42-2) | 2020-01-28 | IGTF 1.103                                                              |
| [3.4.42](/release/3.4/release-3-4-42)     | 2020-01-16 | XRootD 4.11.1, VOMS 2.0.14-15, HTCondor 8.8.7, gratia-probe 1.20.12, osg-xrootd, host-ce-tools 0.5-2, scitokens-cpp 0.4.0, osg-ce |
| [3.4.41](/release/3.4/release-3-4-41)     | 2019-12-19 | Singularity 3.5.2, HTCondor-CE 3.4.0, CVMFS 2.7.0, GlideinWMS 3.6.1, HTCondor 8.8.6 |
| [3.4.40](/release/3.4/release-3-4-40)     | 2019-11-26 | XCache 1.2, CCTools 7.0.21, osg-release 3.4-9                           |
| [3.4.39](/release/3.4/release-3-4-39)     | 2019-11-14 | High Priority Release: Frontier Squid 4.9, XRootD 4.11.0, BLAHP 1.81.45, scitokens-credmon 0.4.2, scitokens-cpp 0.3.5, Singularity 3.4.2 |
| [3.4.38](/release/3.4/release-3-4-38)     | 2019-10-23 | StashCache-Client 5.5.0, IGTF 1.102, VO Package v97                     |
| [3.4.37](/release/3.4/release-3-4-37)     | 2019-10-17 | GlideinWMS 3.6, oidc-agent 3.2.6, scitokens-cpp 0.3.4, XRootD 4.10.1, HTCondor 8.8.5, osg-configure 2.5.0, gratia-probe 1.20.11 |
| [3.4.36](/release/3.4/release-3-4-36)     | 2019-10-10 | CVMFS 2.6.3, Frontier-Squid 4.8-2, CCTools 7.0.18, Singularity 3.4.1, LCMAPS 1.6.6-1.9, VO Package v96 |
| [3.4.35](/release/3.4/release-3-4-35)     | 2019-09-19 | High Priority Release: MyProxy 6.2.6, GSI-OpenSSH, Globus GridFTP Server, Singularity 3.4.0, GlideinWMS 3.4.6 |
| [3.4.34](/release/3.4/release-3-4-34)     | 2019-08-29 | XCache 1.1.1, osg-configure 2.4.1, osg-xrootd 3.4.4, xrootd-hdfs 2.1.6, xrootd-lcmaps 1.7.4, MyProxy 6.2.4, CCTools 7.0.14, osg-system-profiler 1.4.3 |
| [3.4.33](/release/3.4/release-3-4-33)     | 2019-08-01 | Frontier Squid 4.8, XRootD 4.10.0, cvmfs-x509-helper 2.0                |
| [3.4.32](/release/3.4/release-3-4-32)     | 2019-07-25 | Frontier Squid 4.4-2.1, Singularity 3.2.1-1.1, VO Package v94; Upcoming: HTCondor 8.8.4 |
| [3.4.31-2](/release/3.4/release-3-4-31-2) | 2019-07-02 | IGTF 1.101                                                              |
| [3.4.31](/release/3.4/release-3-4-31)     | 2019-06-13 | Singularity 3.2.1, GlideinWMS 3.4.5-2, HTCondor 8.6.13-1.4, VO Package v93; Upcoming: HTCondor 8.8.3 |
| [3.4.30-2](/release/3.4/release-3-4-30-2) | 2019-05-30 | IGTF 1.99, VO Package v92                                               |
| [3.4.30](/release/3.4/release-3-4-30)     | 2019-05-16 | BLAHP 1.81.41, VO Package V91, xrootd-voms-plugin 0.6.0, osg-pki-tools 3.3.0; Upcoming: Singularity 3.1.1-1.1, osg-se-hadoop, BLAHP 1.18.41 |
| [3.4.29-2](/release/3.4/release-3-4-29-2) | 2019-05-07 | VO Package v90                                                          |
| [3.4.29](/release/3.4/release-3-4-29)     | 2019-05-02 | XCache 1.0.5, MyProxy 6.2.3                                             |
| [3.4.28-2](/release/3.4/release-3-4-28-2) | 2019-04-30 | IGTF 1.98                                                               |
| [3.4.28](/release/3.4/release-3-4-28)     | 2019-04-25 | XRootD 4.9.1, xrootd-hdfs 2.1.4, GlideinWMS 3.4.5, osg-flock 1.1, VO Package v89; Upcoming: HTCondor 8.8.2 |
| [3.4.27-2](/release/3.4/release-3-4-27-2) | 2019-04-16 | VO Package v88                                                          |
| [3.4.27](/release/3.4/release-3-4-27)     | 2019-04-11 | Globus GridFTP uses GCT, CVMFS 2.6.0, HTCondor-CE 3.2.2, cctools 7.0.11, osg-pki-tools 3.2.2; Upcoming: Singularity 3.1.1 |
| [3.4.26-2](/release/3.4/release-3-4-26-2) | 2019-04-02 | IGTF 1.97, VO Package v87                                               |
| [3.4.26](/release/3.4/release-3-4-26)     | 2019-03-14 | cctools 7.0.9, Pegasus 4.9.1, osg-pki-tools 3.1.0; Upcoming: Singularity 3.1.0 |
| [3.4.25](/release/3.4/release-3-4-25)     | 2019-03-07 | gsi-openssh 7.4p1, HTCondor 8.6.13 patched, xrootd-lcmaps 1.7.0; Upcoming: HTCondor 8.8.1 |
| [3.4.24-2](/release/3.4/release-3-4-24-2) | 2019-03-05 | IGTF 1.96, VO Package v86                                               |
| [3.4.24](/release/3.4/release-3-4-24)     | 2019-02-21 | BLAHP 1.18.39, osg-pki-tools 3.0.1, HTCondor-CE 3.2.1, condor-cron 1.14.1; Upcoming: Singularity 3.0.3, HDFS on EL6 |
| [3.4.23](/release/3.4/release-3-4-23)     | 2019-01-23 | Gratia probes 1.20.8; Upcoming: Singularity 3.0.2, HTCondor 8.8.0       |
| [3.4.22-2](/release/3.4/release-3-4-22-2) | 2019-01-14 | IGTF 1.95                                                               |
| [3.4.22](/release/3.4/release-3-4-22)     | 2018-12-20 | HTCondor-CE 3.2.0, frontier-squid 4.4, Pegasus 4.9.0, CVMFS 2.5.2, IGTF 1.94, VO Package v85 |
| [3.4.21](/release/3.4/release-3-4-21)     | 2018-12-12 | High Priority Release: Singularity 2.6.1                                |
| [3.4.20](/release/3.4/release-3-4-20)     | 2018-11-01 | GlideinWM 3.4.2, SciTokens 1.2.1, stashcache 0.10, stashcache-client 5.1.0-4, HTCondor 8.6.13; Upcoming: HTCondor 8.7.10 |
| [3.4.19](/release/3.4/release-3-4-19)     | 2018-10-25 | Patched tarball, XRootD 4.8.5, osg-flock 1.0, stashcache 0.9, autopyfactory 2.4.9 |
| [3.4.18-2](/release/3.4/release-3-4-18-2) | 2018-10-03 | VO Package v84                                                          |
| [3.4.18](/release/3.4/release-3-4-18)     | 2018-09-27 | XRootD 4.8.4 + HTTP Patches, xrootd-lcmaps 1.4.1, xrootd-hdfs 2.1.3, HTCondor CE 3.1.4, CernVM-FS 2.5.1, Gratia probes 1.20.7, Pegasus 4.8.4, GlideinWMS 3.4, RSV 3.19.8, BLAHP 1.18.38 |
| [3.4.17-3](/release/3.4/release-3-4-17-3) | 2018-09-26 | IGTF 1.93                                                               |
| [3.4.17-2](/release/3.4/release-3-4-17-2) | 2018-09-13 | VO Package v83                                                          |
| [3.4.17](/release/3.4/release-3-4-17)     | 2018-08-16 | Singularity 2.6.0, HTCondor 8.6.12, Pegasus 4.8.3, HTCondor-CE 3.1.3, xrootd-lcmaps 1.4.0; Upcoming: HTCondor 8.7.9 |
| [3.4.16-2](/release/3.4/release-3-4-16-2) | 2018-08-08 | CILogon OpenID Certification Authority Certificate                      |
| [3.4.16](/release/3.4/release-3-4-16)     | 2018-08-01 | Frontier Squid 3.5.27-5.1, XRootD 4.8.4, SciTokens 1.2.0                |
| [3.4.15](/release/3.4/release-3-4-15)     | 2018-07-06 | High Priority Release: Singularity 2.5.2                                |
| [3.4.14-2](/release/3.4/release-3-4-14-2) | 2018-07-05 | IGTF 1.92                                                               |
| [3.4.14](/release/3.4/release-3-4-14)     | 2018-07-02 | HDFS 2.6(EL7), osg-configure 2.3.1, RSV 3.19.7, lcmaps-plugins-voms 1.7.1-1.6, Gratia probes 1.20.3, osg-pki-tools 3.0.0, GridFTP-HDFS 1.1.1-1.2(EL7), lcmaps-plugins-verify-proxy 1.5.11, OWAMP 3.5.6 BLAHP 1.18.37; Upcoming: GlideinWMS 3.4, BLAHP 1.18.37 |
| [3.4.13](/release/3.4/release-3-4-13)     | 2018-06-12 | CVMFS 2.5.0, HTCondor 8.6.11, Singularity 2.5.1, Pegasus 4.8.2, voms-proxy-direct; Upcoming: HTCondor 8.7.8 |
| [3.4.12-3](/release/3.4/release-3-4-12-3) | 2018-05-21 | IGTF 1.91                                                               |
| [3.4.12-2](/release/3.4/release-3-4-12-2) | 2018-05-10 | Added Let's Encrypt CA, VO Package v79                                  |
| [3.4.12](/release/3.4/release-3-4-12)     | 2018-05-10 | HTCondor-CE 3.1.2, GlideinWMS 3.2.22.2, XRootD 4.8.3, Gratia probes 1.20, RSV 3.18; Upcoming: GlideinWMS 3.3.3 |
| [3.4.11](/release/3.4/release-3-4-11)     | 2018-05-01 | High Priority Release: Singularity 2.5.0                                |
| [3.4.10](/release/3.4/release-3-4-10)     | 2018-04-18 | Singularity 2.4.6, HTCondor-CE 3.1.1, HTCondor 8.6.10, gigetcert 1.16, BLAHP 1.18.36, xrootd-lcmaps 1.2.1-3, osg-configure 2.2.4; Upcoming: HTCondor 8.7.7, xrootd-hdfs 2.0.2 |
| [3.4.9-2](/release/3.4/release-3-4-9-2)   | 2018-04-05 | IGTF 1.90, VO Package v78                                               |
| [3.4.9](/release/3.4/release-3-4-9)       | 2018-03-08 | XRootD 4.8.1, GlideinWMS 3.2.21, Frontier Squid 3.5.27-3, RSV 3.17.0, osg-release 3.4-4 |
| [3.4.8](/release/3.4/release-3-4-8)       | 2018-02-08 | GlideinWMS 3.2.20-2                                                     |
| [3.4.7](/release/3.4/release-3-4-7)       | 2018-02-01 | Singularity 2.4.2, Pegasus 4.8.1, gratia-probe 1.19.0, perfsonar-tools 4.0.1, HTCondor 8.6.9, frontier-squid 3.5.27-2.1, osg-pki-tools 2.1.4; Upcoming: HDFS 2.6, HTCondor 8.7.6 |
| [3.4.6-2](/release/3.4/release-3-4-6-2)   | 2018-01-24 | IGTF 1.89                                                               |
| [3.4.6](/release/3.4/release-3-4-6)       | 2017-12-21 | XRootD 4.8.0, CernVM-FS 2.4.4, GlideinWMS 3.2.20, osg-pki-tools 2.1.2, HTCondor-CE 3.0.4, osg-configure 2.2.3 |
| [3.4.5-4](/release/3.4/release-3-4-5-4)   | 2017-12-20 | VO Package v77                                                          |
| [3.4.5-3](/release/3.4/release-3-4-5-3)   | 2017-11-29 | IGTF 1.88                                                               |
| [3.4.5-2](/release/3.4/release-3-4-5-2)   | 2017-11-20 | VO Package v76                                                          |
| [3.4.5](/release/3.4/release-3-4-5)       | 2017-11-14 | osg-pki-tools 2.0.0, BLAHP 1.18.34, HTCondor 8.6.8, XRootD 4.7.1, CMVFS 2.4.2 globus-gridftp-server 12.2-1.2, globus-gridftp-server-control 6.0, RSV 3.16.0; Upcoming: HTCondor 8.7.5 |
| [3.4.4-3](/release/3.4/release-3-4-4-3)   | 2017-11-01 | IGTF 1.87                                                               |
| [3.4.4-2](/release/3.4/release-3-4-4-2)   | 2017-10-11 | IGTF 1.86, VO Package v75                                               |
| [3.4.4](/release/3.4/release-3-4-4)       | 2017-10-10 | gsi-openssh 7.3p1c, Singularity 2.3.2, HTCondor 8.6.6, globus-gridftp-server-control 5.2, osg-ca-scripts 1.1.7-2, osg-configure 2.2.1; Upcoming: HTCondor 8.7.3 |
| [3.4.3](/release/3.4/release-3-4-3)       | 2017-09-12 | CVMFS 2.4.1, Singularity 2.3.1, BLAHP 1.18.33, XRootD 4.7.0, StashCache 0.8, Globus update, osg-ca-scripts 1.1.7, globus-gridftp-osg-extensions 0.4, xrootd-lcmaps 1.3.4, HTCondor-CE 3.0.2 |
| [3.4.2-2](/release/3.4/release-3-4-2-2)   | 2017-08-14 | IGTF 1.85                                                               |
| [3.4.2](/release/3.4/release-3-4-2)       | 2017-08-08 | HTCondor 8.6.5, HTCondor-CE 3.0.1, condor-cron 1.1.3, osg-configure 2.1.1, BLAHP 1.18.32, osg-ce 3.4-3 |
| [3.4.1-2](/release/3.4/release-3-4-1-2)   | 2017-07-13 | IGTF 1.84                                                               |
| [3.4.1](/release/3.4/release-3-4-1)       | 2017-07-12 | lcmaps-plugins-verify-proxy 1.5.9-1.2, osg-configure 2.1.0, BLAHP 1.18.30, HTCondor-CE 2.2.1, Gratia probes 1.18.1, CVMFS 2.3.5, globus-gridftp-server 11.8, gridftp-dsi-posix 1.4, HTCondor 8.6.4; Upcoming: HTCondor 8.7.2 |
| [3.4.0-2](/release/3.4/release-3-4-0-2)   | 2017-06-15 | IGTF 1.83, VO Package v74                                               |
| [3.4.0](/release/3.4/release-3-4-0)       | 2017-06-14 | HTCondor 8.6.3, Frontier-squid 3.5.24-3.1, lcmaps-plugins-voms 1.7.1, XRootD 4.6.1, GlideinWMS 3.2.19, HTCondor CE 2.2.0, voms-admin-server 1.7.0-1.22, osg-configure 2.0.0, osg-ca-scripts 1.1.6; Upcoming: GlideinWMS 3.3.2 |

Announcements
-------------

OSG releases are also announced by mail and are sent to the following recipients and lists:

-   [Registered administrative contacts](/common/registration#register-resources)
-   [osg-general@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-GENERAL)
-   [osg-operations@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-OPERATIONS)
-   [osg-sites@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-SITES)
-   [vdt-discuss@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=vdt-discuss)
