OSG Software Release 3.5.0
===========================

**Release Date:** 2019-08-30    
**Supported OS Versions:** EL7

Summary of changes
------------------

This initial release of the OSG 3.5 release series is based on the packages available in
[OSG 3.4.33](/release/3.4/release-3-4-33#) with some [additions](#package-updates) and [subtractions](#package-removals).
Additionally, the contents of the [upcoming repository](/release/release_series#osg-upcoming) have been emptied
of packages related to OSG 3.4 and replaced with packages for OSG 3.5.
Other notable changes in this release series include dropping support for Enterprise Linux 6 and
[CREAM CEs](https://opensciencegrid.org/technology/policy/cream-support/).

To update to the OSG 3.5 release series, please consult the page on
[updating between release series](/release/release_series#updating-to-osg-35).

!!! question "Where are GlideinWMS and HTCondor-CE?"
    HTCondor-CE (including `osg-ce` metapackages) and GlideinWMS are both absent in OSG 3.5.0:
    we expect major version updates that may require manual intervention for both of these packages so we are holding
    their initial releases in this series until they are ready.

!!! warning "OSG 3.4 end-of-life"
    As a result of this initial OSG 3.5 release, the end-of-life dates have been set for OSG 3.4 per our
    [policy](https://opensciencegrid.org/technology/policy/release-series/):
    regular support will end in **February 2020** and critical bug/security support will end in **November 2020**.

### Package updates ###

In addition to the packages that were carried over from [OSG 3.4.33](/release/3.4/release-3-4-33#),
this release contains the following package updates:

-   HTCondor 8.8.4: The current HTCondor [stable release](https://htcondor.readthedocs.io/en/v8_8_4/version-history/stable-release-series-88.html).
    See the [manual update instructions](/release/release_series#updating-to-htcondor-88x_1) before
    updating to this version.
    Some highlights from the 8.8 release series include:
    -   Automatically add AWS resources to your pool using HTCondor Annex
    -   The Python bindings now include submit functionality
    -   Added the ability to run a job immediately by replacing a running job
    -   HTCondor now tracks and reports GPU utilization
    -   Several performance enhancements in the collector
    -   The grid universe can create and manage VM instances in Microsoft Azure
    -   The MUNGE security method is now supported on all Linux platforms
-   CVMFS 2.6.2: A [bug fix release](https://cvmfs.readthedocs.io/en/2.6/cpt-releasenotes.html).
    Note the update recommendations from the developers:

    > As with previous releases, upgrading clients should be seamless just by installing the new package from the
    > repository.
    > As usual, we recommend to update only a few worker nodes first and gradually ramp up once the new version proves
    > to work correctly.
    > Please take special care when upgrading a cvmfs client in NFS mode.

    > For Stratum 1 servers, there should be no running snapshots during the upgrade.
    > For publisher and gateway nodes, all transactions must be closed and no active leases must be present before
    > upgrading.

    See the known issue with this version [below](#known-issues).

-   XCache 1.1.1: This release includes packages for ATLAS and CMS XCaches as well as Stash Origin HTTP/S support.
-   OSG Configure 3.0.0: A [major version release](https://github.com/opensciencegrid/osg-configure/releases/tag/v3.0.0),
    including changes from the OSG Configure 2.4 series and dropping some deprecated features.
    See the [manual update instructions](/release/release_series#updating-to-osg-configure-3) before updating to this
    version.
-   OSG XRootD 3.5: A meta-package including common configuration across [standalone](/data/xrootd/install-standalone),
    [storage element](/data/xrootd/install-storage-element), and [caching](/data/stashcache/overview) installations of
    XRootD.
-   XRootD LCMAPS 1.7.4: includes default authorization configuration in `/etc/xrootd/config.d/40-xrootd-lcmaps.cfg`.
    To use the default configuration, uncomment the `# set EnableLcmaps = 1` line in `/etc/xrootd/config.d/10-xrootd-lcmaps.cfg`.
-   XRootD HDFS 2.1.6: includes default configuration in `/etc/xrootd/40-xrootd-hdfs.cfg`.
-   MyProxy 6.2.4: Remove usage statistics collection support
-   [CCTools 7.0.14](http://ccl.cse.nd.edu/software/): Bug fix release
-   OSG System Profiler 1.4.3: Remove collection of obsolete information
    See the known issue with this version [below](#known-issues).
-   HTCondor 8.9.2 (upcoming): The current HTCondor
    [development release](https://htcondor.readthedocs.io/en/v8_9_2/version-history/development-release-series-89.html).
    Some highlights from the 8.9 release series include:
    -   New TOKEN authentication method enables fine-grained authorization control
    -   All HTCondor daemons run under a condor\_master share a security session
    -   An efficient HTTP/S plugin that supports uploads and authentication tokens
    -   The HTTP/HTTPS file transfer plugin will timeout and retry transfers
    -   HTCondor automatically supports GPU jobs in Docker and Singularity
    -   File transfer times are now recorded in the user job log and the job ad
    -   A new multi-file box.com file transfer plugin to download files
    -   Configuration options for job-log time-stamps (UTC, ISO 8601, sub-second)
    -   Several improvements to SSL authentication

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.0%20)
were addressed in this release.


### Package removals ###

A new [OSG release series](/release/release_series/), gives us the opportunity to clean up our
[Yum repositories](/common/yum#repositories):
either removing packages that are the same version of those available in EPEL;
or removing pacakges that are now obsolete in the OSG Software stack.
Below, you will find a list of packages that were in OSG 3.4 but have been removed in OSG 3.5.
If you believe any of the following packages have been removed in error, please [contact us](/common/help).

The following packages were removed from the OSG 3.5 Yum repositories but are available via
[EPEL repositories](/common/yum#install-the-epel-repositories):

- singularity
- globus-ftp-client
- globus-gridftp-server-control

The following packages are obsolete and have been removed from the OSG 3.5 Yum repositories:

- autopyfactory
- CREAM packages:
    - glite-ce-cream-client-api-c (replaced by an empty package to ease updates to 3.5)
    - glite-ce-wsdl
    - glite-build-common-cpp
- PerfSONAR client tools:
    - bwctl
    - l2util
    - nuttcp
    - owamp
    - perfsonar-tools
- lcmaps-plugins-scas-client
- osg-control
- osg-version
- osg-vo-map
- rsv (replaced by an empty package to ease updates to 3.5)
- xacml

Known Issues
------------

- CVMFS 2.6.2 has a known memory leak when using an `/etc/hosts` file with lines only containing whitespace
([CVM-1796](https://sft.its.cern.ch/jira/browse/CVM-1796))
- OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).


Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](/release/release_series#updating-to-osg-35).

For sites using non-RPM worker node client installations, new [tarballs](/worker-node/install-wn-tarball) and
[container images](/worker-node/using-wn-containers) are available:

- Tarball: <https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz>
- Container Images: <https://hub.docker.com/r/opensciencegrid/osg-wn/>

Need Help?
----------

Do you need help with this release? [Contact us for help](/common/help).

Detailed Changes in This Release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list [below](#rpms).

-   [avro-libs-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=avro-libs-1.7.6%2Bcdh5.13.0%2B135-1.cdh5.13.0.p0.34.2.osg35.el7)
-   [bigtop-jsvc-0.3.0-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bigtop-jsvc-0.3.0-1.2.osg35.el7)
-   [bigtop-utils-0.7.0+cdh5.13.0+0-1.cdh5.13.0.p0.34.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bigtop-utils-0.7.0%2Bcdh5.13.0%2B0-1.cdh5.13.0.p0.34.1.osg35.el7)
-   [blahp-1.18.41.bosco-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.41.bosco-1.osg35.el7)
-   [cctools-7.0.14-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.0.14-1.osg35.el7)
-   [cigetcert-1.16-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cigetcert-1.16-2.osg35.el7)
-   [cilogon-openid-ca-cert-1.1-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cilogon-openid-ca-cert-1.1-4.osg35.el7)
-   [condor-8.8.4-1.8.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.4-1.8.osg35.el7)
-   [cvmfs-2.6.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.6.2-1.osg35.el7)
-   [cvmfs-config-osg-2.4-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.4-1.osg35.el7)
-   [cvmfs-gateway-0.3.1-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-gateway-0.3.1-1.1.osg35.el7)
-   [cvmfs-x509-helper-2.0-3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-2.0-3.osg35.el7)
-   [frontier-squid-4.8-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.8-1.1.osg35.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.5.osg35.el7)
-   [globus-gridftp-osg-extensions-0.4-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.4-1.osg35.el7)
-   [globus-gridftp-server-13.9-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.9-1.1.osg35.el7)
-   [gratia-probe-1.20.8-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.8-1.osg35.el7)
-   [gridftp-dsi-posix-1.4-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-dsi-posix-1.4-2.osg35.el7)
-   [gridftp-hdfs-1.1.1-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-hdfs-1.1.1-1.2.osg35.el7)
-   [gsi-openssh-7.4p1-2.3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.4p1-2.3.osg35.el7)
-   [hadoop-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hadoop-2.6.0%2Bcdh5.12.1%2B2540-1.cdh5.12.1.p0.3.8.osg35.el7)
-   [igtf-ca-certs-1.101-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.101-1.osg35.el7)
-   [javascriptrrd-1.1.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=javascriptrrd-1.1.1-1.osg35.el7)
-   [lcas-lcmaps-gt4-interface-0.3.1-1.3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcas-lcmaps-gt4-interface-0.3.1-1.3.osg35.el7)
-   [lcmaps-1.6.6-1.10.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.10.osg35.el7)
-   [lcmaps-plugins-basic-1.7.0-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-basic-1.7.0-2.osg35.el7)
-   [lcmaps-plugins-verify-proxy-1.5.11-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.11-1.1.osg35.el7)
-   [lcmaps-plugins-voms-1.7.1-1.6.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.6.osg35.el7)
-   [llrun-0.1.3-1.3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=llrun-0.1.3-1.3.osg35.el7)
-   [myproxy-6.2.4-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.2.4-1.1.osg35.el7)
-   [osg-ca-certs-1.83-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.83-1.osg35.el7)
-   [osg-ca-certs-updater-1.8-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.8-1.osg35.el7)
-   [osg-ca-scripts-1.2.4-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.4-1.osg35.el7)
-   [osg-configure-3.0.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-3.0.0-1.osg35.el7)
-   [osg-flock-1.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.1-1.osg35.el7)
-   [osg-gridftp-3.5-3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.5-3.osg35.el7)
-   [osg-oasis-15-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-15-2.osg35.el7)
-   [osg-pki-tools-3.3.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-3.3.0-1.osg35.el7)
-   [osg-release-itb-3.5-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-itb-3.5-2.osg35.el7)
-   [osg-se-hadoop-3.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-se-hadoop-3.5-1.osg35.el7)
-   [osg-system-profiler-1.4.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.3-1.osg35.el7)
-   [osg-update-vos-1.4.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-update-vos-1.4.0-1.osg35.el7)
-   [osg-wn-client-3.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.5-1.osg35.el7)
-   [osg-xrootd-3.5-3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5-3.osg35.el7)
-   [pegasus-4.9.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.9.1-1.osg35.el7)
-   [python-jwt-1.6.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-jwt-1.6.1-1.osg35.el7)
-   [python-scitokens-1.2.1-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.2.1-2.osg35.el7)
-   [rsv-3.19.8-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.19.8-2.osg35.el7)
-   [scitokens-cpp-0.3.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.3.3-1.osg35.el7)
-   [stashcache-client-5.2.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-5.2.0-1.osg35.el7)
-   [uberftp-2.8-2.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=uberftp-2.8-2.1.osg35.el7)
-   [vo-client-94-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-94-1.osg35.el7)
-   [voms-2.0.14-1.4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.4.osg35.el7)
-   [vomsxrd-0.6.0-3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vomsxrd-0.6.0-3.osg35.el7)
-   [xcache-1.1.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-1.1.1-1.osg35.el7)
-   [xrootd-4.10.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.10.0-1.osg35.el7)
-   [xrootd-hdfs-2.1.6-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.6-1.osg35.el7)
-   [xrootd-lcmaps-1.7.4-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.4-2.osg35.el7)
-   [xrootd-multiuser-0.4.2-4.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.2-4.osg35.el7)
-   [xrootd-scitokens-1.0.0-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.0.0-1.1.osg35.el7)
-   [zookeeper-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=zookeeper-3.4.5%2Bcdh5.14.2%2B142-1.cdh5.14.2.p0.11.1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    atlas-xcache avro-doc avro-libs avro-tools bigtop-jsvc bigtop-jsvc-debuginfo bigtop-utils blahp blahp-debuginfo cctools cctools-debuginfo cctools-devel cigetcert cilogon-openid-ca-cert cms-xcache condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp cvmfs cvmfs-config-osg cvmfs-devel cvmfs-ducc cvmfs-gateway cvmfs-server cvmfs-shrinkwrap cvmfs-unittests cvmfs-x509-helper cvmfs-x509-helper-debuginfo frontier-squid frontier-squid-debuginfo glite-ce-cream-client-api-c glite-ce-cream-client-devel globus-gridftp-osg-extensions globus-gridftp-osg-extensions-debuginfo globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer gridftp-dsi-posix gridftp-dsi-posix-debuginfo gridftp-hdfs gridftp-hdfs-debuginfo gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server hadoop hadoop-0.20-conf-pseudo hadoop-0.20-mapreduce hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-journalnode hadoop-hdfs-namenode hadoop-hdfs-nfs3 hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-kms hadoop-kms-server hadoop-libhdfs hadoop-libhdfs-devel hadoop-mapreduce hadoop-yarn igtf-ca-certs javascriptrrd lcas-lcmaps-gt4-interface lcas-lcmaps-gt4-interface-debuginfo lcmaps lcmaps-common-devel lcmaps-db-templates lcmaps-debuginfo lcmaps-devel lcmaps-plugins-basic lcmaps-plugins-basic-debuginfo lcmaps-plugins-basic-ldap lcmaps-plugins-verify-proxy lcmaps-plugins-verify-proxy-debuginfo lcmaps-plugins-voms lcmaps-plugins-voms-debuginfo lcmaps-without-gsi lcmaps-without-gsi-devel llrun llrun-debuginfo minicondor myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-ca-certs osg-ca-certs-updater osg-ca-scripts osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-flock osg-gridftp osg-gridftp-hdfs osg-gridftp-xrootd osg-oasis osg-pki-tools osg-release osg-release-itb osg-se-hadoop osg-se-hadoop-client osg-se-hadoop-datanode osg-se-hadoop-gridftp osg-se-hadoop-namenode osg-se-hadoop-secondarynamenode osg-system-profiler osg-system-profiler-viewer osg-update-data osg-update-vos osg-wn-client osg-xrootd osg-xrootd-standalone pegasus pegasus-debuginfo python2-condor python2-jwt python2-scitokens python2-xrootd python36-jwt python3-condor rsv rsv-consumers rsv-core rsv-metrics scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel stash-cache stashcache-client stash-origin uberftp uberftp-debuginfo vo-client vo-client-dcache vo-client-lcmaps-voms voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server vomsxrd vomsxrd-debuginfo vomsxrd-devel xcache xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs zookeeper zookeeper-debuginfo zookeeper-native zookeeper-server

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
atlas-xcache-1.1.1-1.osg35.el7
avro-doc-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.2.osg35.el7
avro-libs-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.2.osg35.el7
avro-tools-1.7.6+cdh5.13.0+135-1.cdh5.13.0.p0.34.2.osg35.el7
bigtop-jsvc-0.3.0-1.2.osg35.el7
bigtop-jsvc-debuginfo-0.3.0-1.2.osg35.el7
bigtop-utils-0.7.0+cdh5.13.0+0-1.cdh5.13.0.p0.34.1.osg35.el7
blahp-1.18.41.bosco-1.osg35.el7
blahp-debuginfo-1.18.41.bosco-1.osg35.el7
cctools-7.0.14-1.osg35.el7
cctools-debuginfo-7.0.14-1.osg35.el7
cctools-devel-7.0.14-1.osg35.el7
cigetcert-1.16-2.osg35.el7
cilogon-openid-ca-cert-1.1-4.osg35.el7
cms-xcache-1.1.1-1.osg35.el7
condor-8.8.4-1.8.osg35.el7
condor-all-8.8.4-1.8.osg35.el7
condor-annex-ec2-8.8.4-1.8.osg35.el7
condor-bosco-8.8.4-1.8.osg35.el7
condor-classads-8.8.4-1.8.osg35.el7
condor-classads-devel-8.8.4-1.8.osg35.el7
condor-debuginfo-8.8.4-1.8.osg35.el7
condor-kbdd-8.8.4-1.8.osg35.el7
condor-procd-8.8.4-1.8.osg35.el7
condor-test-8.8.4-1.8.osg35.el7
condor-vm-gahp-8.8.4-1.8.osg35.el7
cvmfs-2.6.2-1.osg35.el7
cvmfs-config-osg-2.4-1.osg35.el7
cvmfs-devel-2.6.2-1.osg35.el7
cvmfs-ducc-2.6.2-1.osg35.el7
cvmfs-gateway-0.3.1-1.1.osg35.el7
cvmfs-server-2.6.2-1.osg35.el7
cvmfs-shrinkwrap-2.6.2-1.osg35.el7
cvmfs-unittests-2.6.2-1.osg35.el7
cvmfs-x509-helper-2.0-3.osg35.el7
cvmfs-x509-helper-debuginfo-2.0-3.osg35.el7
frontier-squid-4.8-1.1.osg35.el7
frontier-squid-debuginfo-4.8-1.1.osg35.el7
glite-ce-cream-client-api-c-1.15.4-2.5.osg35.el7
glite-ce-cream-client-devel-1.15.4-2.5.osg35.el7
globus-gridftp-osg-extensions-0.4-1.osg35.el7
globus-gridftp-osg-extensions-debuginfo-0.4-1.osg35.el7
globus-gridftp-server-13.9-1.1.osg35.el7
globus-gridftp-server-debuginfo-13.9-1.1.osg35.el7
globus-gridftp-server-devel-13.9-1.1.osg35.el7
globus-gridftp-server-progs-13.9-1.1.osg35.el7
gratia-probe-1.20.8-1.osg35.el7
gratia-probe-common-1.20.8-1.osg35.el7
gratia-probe-condor-1.20.8-1.osg35.el7
gratia-probe-condor-events-1.20.8-1.osg35.el7
gratia-probe-dcache-storage-1.20.8-1.osg35.el7
gratia-probe-dcache-storagegroup-1.20.8-1.osg35.el7
gratia-probe-dcache-transfer-1.20.8-1.osg35.el7
gratia-probe-debuginfo-1.20.8-1.osg35.el7
gratia-probe-enstore-storage-1.20.8-1.osg35.el7
gratia-probe-enstore-tapedrive-1.20.8-1.osg35.el7
gratia-probe-enstore-transfer-1.20.8-1.osg35.el7
gratia-probe-glideinwms-1.20.8-1.osg35.el7
gratia-probe-gridftp-transfer-1.20.8-1.osg35.el7
gratia-probe-hadoop-storage-1.20.8-1.osg35.el7
gratia-probe-htcondor-ce-1.20.8-1.osg35.el7
gratia-probe-lsf-1.20.8-1.osg35.el7
gratia-probe-metric-1.20.8-1.osg35.el7
gratia-probe-onevm-1.20.8-1.osg35.el7
gratia-probe-pbs-lsf-1.20.8-1.osg35.el7
gratia-probe-services-1.20.8-1.osg35.el7
gratia-probe-sge-1.20.8-1.osg35.el7
gratia-probe-slurm-1.20.8-1.osg35.el7
gratia-probe-xrootd-storage-1.20.8-1.osg35.el7
gratia-probe-xrootd-transfer-1.20.8-1.osg35.el7
gridftp-dsi-posix-1.4-2.osg35.el7
gridftp-dsi-posix-debuginfo-1.4-2.osg35.el7
gridftp-hdfs-1.1.1-1.2.osg35.el7
gridftp-hdfs-debuginfo-1.1.1-1.2.osg35.el7
gsi-openssh-7.4p1-2.3.osg35.el7
gsi-openssh-clients-7.4p1-2.3.osg35.el7
gsi-openssh-debuginfo-7.4p1-2.3.osg35.el7
gsi-openssh-server-7.4p1-2.3.osg35.el7
hadoop-0.20-conf-pseudo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-0.20-mapreduce-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-client-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-conf-pseudo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-debuginfo-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-doc-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-hdfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-hdfs-datanode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-hdfs-fuse-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-hdfs-journalnode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-hdfs-namenode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-hdfs-nfs3-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-hdfs-secondarynamenode-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-hdfs-zkfc-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-httpfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-kms-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-kms-server-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-libhdfs-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-libhdfs-devel-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-mapreduce-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
hadoop-yarn-2.6.0+cdh5.12.1+2540-1.cdh5.12.1.p0.3.8.osg35.el7
igtf-ca-certs-1.101-1.osg35.el7
javascriptrrd-1.1.1-1.osg35.el7
lcas-lcmaps-gt4-interface-0.3.1-1.3.osg35.el7
lcas-lcmaps-gt4-interface-debuginfo-0.3.1-1.3.osg35.el7
lcmaps-1.6.6-1.10.osg35.el7
lcmaps-common-devel-1.6.6-1.10.osg35.el7
lcmaps-db-templates-1.6.6-1.10.osg35.el7
lcmaps-debuginfo-1.6.6-1.10.osg35.el7
lcmaps-devel-1.6.6-1.10.osg35.el7
lcmaps-plugins-basic-1.7.0-2.osg35.el7
lcmaps-plugins-basic-debuginfo-1.7.0-2.osg35.el7
lcmaps-plugins-basic-ldap-1.7.0-2.osg35.el7
lcmaps-plugins-verify-proxy-1.5.11-1.1.osg35.el7
lcmaps-plugins-verify-proxy-debuginfo-1.5.11-1.1.osg35.el7
lcmaps-plugins-voms-1.7.1-1.6.osg35.el7
lcmaps-plugins-voms-debuginfo-1.7.1-1.6.osg35.el7
lcmaps-without-gsi-1.6.6-1.10.osg35.el7
lcmaps-without-gsi-devel-1.6.6-1.10.osg35.el7
llrun-0.1.3-1.3.osg35.el7
llrun-debuginfo-0.1.3-1.3.osg35.el7
minicondor-8.8.4-1.8.osg35.el7
myproxy-6.2.4-1.1.osg35.el7
myproxy-admin-6.2.4-1.1.osg35.el7
myproxy-debuginfo-6.2.4-1.1.osg35.el7
myproxy-devel-6.2.4-1.1.osg35.el7
myproxy-doc-6.2.4-1.1.osg35.el7
myproxy-libs-6.2.4-1.1.osg35.el7
myproxy-server-6.2.4-1.1.osg35.el7
myproxy-voms-6.2.4-1.1.osg35.el7
osg-ca-certs-1.83-1.osg35.el7
osg-ca-certs-updater-1.8-1.osg35.el7
osg-ca-scripts-1.2.4-1.osg35.el7
osg-configure-3.0.0-1.osg35.el7
osg-configure-bosco-3.0.0-1.osg35.el7
osg-configure-ce-3.0.0-1.osg35.el7
osg-configure-condor-3.0.0-1.osg35.el7
osg-configure-gateway-3.0.0-1.osg35.el7
osg-configure-gip-3.0.0-1.osg35.el7
osg-configure-gratia-3.0.0-1.osg35.el7
osg-configure-infoservices-3.0.0-1.osg35.el7
osg-configure-lsf-3.0.0-1.osg35.el7
osg-configure-misc-3.0.0-1.osg35.el7
osg-configure-pbs-3.0.0-1.osg35.el7
osg-configure-rsv-3.0.0-1.osg35.el7
osg-configure-sge-3.0.0-1.osg35.el7
osg-configure-siteinfo-3.0.0-1.osg35.el7
osg-configure-slurm-3.0.0-1.osg35.el7
osg-configure-squid-3.0.0-1.osg35.el7
osg-configure-tests-3.0.0-1.osg35.el7
osg-flock-1.1-1.osg35.el7
osg-gridftp-3.5-3.osg35.el7
osg-gridftp-hdfs-3.5-3.osg35.el7
osg-gridftp-xrootd-3.5-3.osg35.el7
osg-oasis-15-2.osg35.el7
osg-pki-tools-3.3.0-1.osg35.el7
osg-release-itb-3.5-2.osg35.el7
osg-se-hadoop-3.5-1.osg35.el7
osg-se-hadoop-client-3.5-1.osg35.el7
osg-se-hadoop-datanode-3.5-1.osg35.el7
osg-se-hadoop-gridftp-3.5-1.osg35.el7
osg-se-hadoop-namenode-3.5-1.osg35.el7
osg-se-hadoop-secondarynamenode-3.5-1.osg35.el7
osg-system-profiler-1.4.3-1.osg35.el7
osg-system-profiler-viewer-1.4.3-1.osg35.el7
osg-update-data-1.4.0-1.osg35.el7
osg-update-vos-1.4.0-1.osg35.el7
osg-wn-client-3.5-1.osg35.el7
osg-xrootd-3.5-3.osg35.el7
osg-xrootd-standalone-3.5-3.osg35.el7
pegasus-4.9.1-1.osg35.el7
pegasus-debuginfo-4.9.1-1.osg35.el7
python2-condor-8.8.4-1.8.osg35.el7
python2-jwt-1.6.1-1.osg35.el7
python2-scitokens-1.2.1-2.osg35.el7
python2-xrootd-4.10.0-1.osg35.el7
python36-jwt-1.6.1-1.osg35.el7
python3-condor-8.8.4-1.8.osg35.el7
python-jwt-1.6.1-1.osg35.el7
python-scitokens-1.2.1-2.osg35.el7
rsv-3.19.8-2.osg35.el7
rsv-consumers-3.19.8-2.osg35.el7
rsv-core-3.19.8-2.osg35.el7
rsv-metrics-3.19.8-2.osg35.el7
scitokens-cpp-0.3.3-1.osg35.el7
scitokens-cpp-debuginfo-0.3.3-1.osg35.el7
scitokens-cpp-devel-0.3.3-1.osg35.el7
stash-cache-1.1.1-1.osg35.el7
stashcache-client-5.2.0-1.osg35.el7
stash-origin-1.1.1-1.osg35.el7
uberftp-2.8-2.1.osg35.el7
uberftp-debuginfo-2.8-2.1.osg35.el7
vo-client-94-1.osg35.el7
vo-client-dcache-94-1.osg35.el7
vo-client-lcmaps-voms-94-1.osg35.el7
voms-2.0.14-1.4.osg35.el7
voms-clients-cpp-2.0.14-1.4.osg35.el7
voms-debuginfo-2.0.14-1.4.osg35.el7
voms-devel-2.0.14-1.4.osg35.el7
voms-doc-2.0.14-1.4.osg35.el7
voms-server-2.0.14-1.4.osg35.el7
vomsxrd-0.6.0-3.osg35.el7
vomsxrd-debuginfo-0.6.0-3.osg35.el7
vomsxrd-devel-0.6.0-3.osg35.el7
xcache-1.1.1-1.osg35.el7
xrootd-4.10.0-1.osg35.el7
xrootd-client-4.10.0-1.osg35.el7
xrootd-client-devel-4.10.0-1.osg35.el7
xrootd-client-libs-4.10.0-1.osg35.el7
xrootd-debuginfo-4.10.0-1.osg35.el7
xrootd-devel-4.10.0-1.osg35.el7
xrootd-doc-4.10.0-1.osg35.el7
xrootd-fuse-4.10.0-1.osg35.el7
xrootd-hdfs-2.1.6-1.osg35.el7
xrootd-hdfs-debuginfo-2.1.6-1.osg35.el7
xrootd-hdfs-devel-2.1.6-1.osg35.el7
xrootd-lcmaps-1.7.4-2.osg35.el7
xrootd-lcmaps-debuginfo-1.7.4-2.osg35.el7
xrootd-libs-4.10.0-1.osg35.el7
xrootd-multiuser-0.4.2-4.osg35.el7
xrootd-multiuser-debuginfo-0.4.2-4.osg35.el7
xrootd-private-devel-4.10.0-1.osg35.el7
xrootd-scitokens-1.0.0-1.1.osg35.el7
xrootd-scitokens-debuginfo-1.0.0-1.1.osg35.el7
xrootd-selinux-4.10.0-1.osg35.el7
xrootd-server-4.10.0-1.osg35.el7
xrootd-server-devel-4.10.0-1.osg35.el7
xrootd-server-libs-4.10.0-1.osg35.el7
zookeeper-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg35.el7
zookeeper-debuginfo-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg35.el7
zookeeper-native-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg35.el7
zookeeper-server-3.4.5+cdh5.14.2+142-1.cdh5.14.2.p0.11.1.osg35.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

-   [blahp-1.18.41.bosco-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.41.bosco-2.osgup.el7)
-   [condor-8.9.2-1.4.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.2-1.4.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp glite-ce-cream-client-api-c glite-ce-cream-client-devel minicondor osg-gridftp osg-gridftp-hdfs osg-gridftp-xrootd python2-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
blahp-1.18.41.bosco-2.osgup.el7
blahp-debuginfo-1.18.41.bosco-2.osgup.el7
condor-8.9.2-1.4.osgup.el7
condor-all-8.9.2-1.4.osgup.el7
condor-annex-ec2-8.9.2-1.4.osgup.el7
condor-bosco-8.9.2-1.4.osgup.el7
condor-classads-8.9.2-1.4.osgup.el7
condor-classads-devel-8.9.2-1.4.osgup.el7
condor-debuginfo-8.9.2-1.4.osgup.el7
condor-kbdd-8.9.2-1.4.osgup.el7
condor-procd-8.9.2-1.4.osgup.el7
condor-test-8.9.2-1.4.osgup.el7
condor-vm-gahp-8.9.2-1.4.osgup.el7
minicondor-8.9.2-1.4.osgup.el7
python2-condor-8.9.2-1.4.osgup.el7
```
