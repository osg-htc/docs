OSG Software Release 3.3.1
==========================

**Release Date**: 2015-09-08

Summary of changes
------------------

This release contains:

-   Enterprise Linux 7: Worker node support only
-   GUMS 1.5.0
    -   A security-related bug was found in the GUMS administrative interface. The risk of this vulnerability has been assessed by OSG Security Team as “Critical”. A new GUMS version 1.5.0 has been released and it is included in OSG Software version 3.2.27/3.3.1. Site administrators should update ASAP.
-   [HTCondor 8.3.8](https://www-auth.cs.wisc.edu/lists/htcondor-users/2015-August/msg00153.shtml)
-   HTCondor CE 1.15
    -   Add 'default\_remote\_cerequirements' attribute to the JOB\_ROUTER\_DEFAULTS
    -   Verify the first route in JOB\_ROUTER\_ENTRIES in the init script
    -   htcondor-ce-collecotr now uses /etc/sysconfig/condor-ce-collector for additional configuration
-   gridFTP-HDFS checksum verification improvements
    -   Checksum algorithm names are checked with a case insensitive comparison
    -   Error codes are properly returned to the user
-   CA certificates based on [IGTF 1.67](https://dist.eugridpma.info/distribution/igtf/current/CHANGES)
-   StashCache improvements
    -   Added logging to the StashCache daemon
    -   Advertise the StashCache daemon version to the master ClassAd
    -   Improved example configuration files to include "pss.trace all"

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.1%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   The HTCondor shared port daemon can run out of file descriptors.
    -   This is a problem with HTCondor 8.3.7 and 8.3.8.
    -   The problem will be fixed in the HTCondor 8.4.0 release.
    -   The glideInWMS factories (and possibly front-ends) using the following configuration model will cause the HTCondor shared port daemon to leak file descriptors. The relevant configuration fragment is similar to:

            :::file
            USE_SHARED_PORT = FALSE
            DAEMON_LIST = $(DAEMON_LIST) SHARED_PORT
            SCHEDD.USE_SHARED_PORT = TRUE
            SHADOW.USE_SHADED_PORT = TRUE

-   This non-standard shared-port configuration is probably used to avoid dealing with shared-port collector trees.
-   The work-around is to start the HTCondor master with CONDOR\_PRIVATE\_SHARED\_PORT\_COOKIE set in the environment, as it will propagate down to the target daemons. CONDOR\_PRIVATE\_SHARED\_PORT\_COOKIE should contain a 32-byte random number in hexadecimal format (64 characters). **Note:** care must be taken to ensure that this value is private. Upgrade to HTCondor 8.4.0 as soon as possible and stop using this workaround. \* Running osg-configure with the new version of HTCondor installed causes a deprecation warning to be emitted. The warning does not affect the services. \* StashCache packages need to be manually configured
-   Manual configuration for origin server
    -   Assuming that the origin server connects only to a redirector (not directly to cache server), minimal xrootd configuration is required. The configuration file, /etc/xrootd/xrootd-stashcache-origin-server.cfg, in this release is overkill. Here are recommended settings to use:

            :::file
            xrd.port 1094
            all.role server
            all.manager stash-redirector.example.com 1213
            all.export / nostage
            xrootd.trace emsg login stall redirect
            ofs.trace none
            xrd.trace conn
            cms.trace all
            sec.protocol  host
            sec.protbind  * none
            all.adminpath /var/run/xrootd
            all.pidpath /var/run/xrootd

-   Manual configuration for cache server
    -   In contrast to the origin server configuration, one needs to declare `pss.origin <stash-redirector.example.com>` instead of configuring the cmsd or manager (only the xrootd daemon is required on the cache server). More detailed configuration of cache server for StashCache is [here](http://opensciencegrid.github.io/StashCache/admin/configure-cache/).
-   In both cases, administrator needs to set the path of custom configuration file for its xrootd/cmds instance in /etc/sysconfig/xrootd, For example, change the cmds default from:

        :::file
        CMSD_DEFAULT_OPTIONS="-l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-clustered.cfg -k fifo"
<br/>

    to

        :::file
        CMSD_DEFAULT_OPTIONS="-l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-stashcache-origin-server.marian -k fifo" 

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note
    Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

!!! note
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.13.bosco-4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.13.bosco-4.osg33.el6)
-   [condor-8.3.8-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.3.8-1.1.osg33.el6)
-   [emi-trustmanager-tomcat-3.0.0-12.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-tomcat-3.0.0-12.osg33.el6)
-   [gridftp-hdfs-0.5.4-20.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-20.osg33.el6)
-   [gums-1.5.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.0-1.osg33.el6)
-   [hadoop-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=hadoop-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6)
-   [htcondor-ce-1.15-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-1.15-2.osg33.el6)
-   [igtf-ca-certs-1.67-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.67-1.osg33.el6)
-   [osg-build-1.6.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.6.1-1.osg33.el6)
-   [osg-ca-certs-1.48-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.48-1.osg33.el6)
-   [osg-test-1.4.29-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.4.29-1.osg33.el6)
-   [osg-tested-internal-3.3-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-3.osg33.el6)
-   [osg-version-3.3.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.1-1.osg33.el6)
-   [rsv-3.10.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.10.3-1.osg33.el6)
-   [stashcache-0.4-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=stashcache-0.4-2.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.13.bosco-4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.13.bosco-4.osg33.el7)
-   [condor-8.3.8-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.3.8-1.1.osg33.el7)
-   [emi-trustmanager-tomcat-3.0.0-12.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=emi-trustmanager-tomcat-3.0.0-12.osg33.el7)
-   [htcondor-ce-1.15-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-1.15-2.osg33.el7)
-   [igtf-ca-certs-1.67-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.67-1.osg33.el7)
-   [osg-build-1.6.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.6.1-1.osg33.el7)
-   [osg-ca-certs-1.48-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.48-1.osg33.el7)
-   [osg-test-1.4.29-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.4.29-1.osg33.el7)
-   [osg-tested-internal-3.3-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-3.osg33.el7)
-   [osg-version-3.3.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.1-1.osg33.el7)
-   [rsv-3.10.3-1\_clipped.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.10.3-1_clipped.osg33.el7)
-   [stashcache-0.4-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=stashcache-0.4-2.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp emi-trustmanager-tomcat gridftp-hdfs gridftp-hdfs-debuginfo gums gums-client gums-service hadoop hadoop-client hadoop-conf-pseudo hadoop-debuginfo hadoop-doc hadoop-hdfs hadoop-hdfs-datanode hadoop-hdfs-fuse hadoop-hdfs-fuse-selinux hadoop-hdfs-journalnode hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode hadoop-hdfs-zkfc hadoop-httpfs hadoop-libhdfs hadoop-mapreduce hadoop-yarn htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-debuginfo htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge igtf-ca-certs osg-build osg-ca-certs osg-test osg-tested-internal osg-version python-six rsv rsv-consumers rsv-core rsv-metrics stashcache-cache-server stashcache-daemon stashcache-origin-server

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.13.bosco-4.osg33.el6
blahp-debuginfo-1.18.13.bosco-4.osg33.el6
condor-8.3.8-1.1.osg33.el6
condor-all-8.3.8-1.1.osg33.el6
condor-bosco-8.3.8-1.1.osg33.el6
condor-classads-8.3.8-1.1.osg33.el6
condor-classads-devel-8.3.8-1.1.osg33.el6
condor-cream-gahp-8.3.8-1.1.osg33.el6
condor-debuginfo-8.3.8-1.1.osg33.el6
condor-kbdd-8.3.8-1.1.osg33.el6
condor-procd-8.3.8-1.1.osg33.el6
condor-python-8.3.8-1.1.osg33.el6
condor-std-universe-8.3.8-1.1.osg33.el6
condor-test-8.3.8-1.1.osg33.el6
condor-vm-gahp-8.3.8-1.1.osg33.el6
emi-trustmanager-tomcat-3.0.0-12.osg33.el6
gridftp-hdfs-0.5.4-20.osg33.el6
gridftp-hdfs-debuginfo-0.5.4-20.osg33.el6
gums-1.5.0-1.osg33.el6
gums-client-1.5.0-1.osg33.el6
gums-service-1.5.0-1.osg33.el6
hadoop-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-client-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-conf-pseudo-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-debuginfo-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-doc-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-hdfs-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-hdfs-datanode-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-hdfs-fuse-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-hdfs-fuse-selinux-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-hdfs-journalnode-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-hdfs-namenode-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-hdfs-secondarynamenode-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-hdfs-zkfc-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-httpfs-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-libhdfs-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-mapreduce-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
hadoop-yarn-2.0.0+545-1.cdh4.1.1.p0.21.osg33.el6
htcondor-ce-1.15-2.osg33.el6
htcondor-ce-client-1.15-2.osg33.el6
htcondor-ce-collector-1.15-2.osg33.el6
htcondor-ce-condor-1.15-2.osg33.el6
htcondor-ce-debuginfo-1.15-2.osg33.el6
htcondor-ce-lsf-1.15-2.osg33.el6
htcondor-ce-pbs-1.15-2.osg33.el6
htcondor-ce-sge-1.15-2.osg33.el6
igtf-ca-certs-1.67-1.osg33.el6
osg-build-1.6.1-1.osg33.el6
osg-ca-certs-1.48-1.osg33.el6
osg-test-1.4.29-1.osg33.el6
osg-tested-internal-3.3-3.osg33.el6
osg-version-3.3.1-1.osg33.el6
rsv-3.10.3-1.osg33.el6
rsv-consumers-3.10.3-1.osg33.el6
rsv-core-3.10.3-1.osg33.el6
rsv-metrics-3.10.3-1.osg33.el6
stashcache-0.4-2.osg33.el6
stashcache-cache-server-0.4-2.osg33.el6
stashcache-daemon-0.4-2.osg33.el6
stashcache-origin-server-0.4-2.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.13.bosco-4.osg33.el7
blahp-debuginfo-1.18.13.bosco-4.osg33.el7
condor-8.3.8-1.1.osg33.el7
condor-all-8.3.8-1.1.osg33.el7
condor-bosco-8.3.8-1.1.osg33.el7
condor-classads-8.3.8-1.1.osg33.el7
condor-classads-devel-8.3.8-1.1.osg33.el7
condor-debuginfo-8.3.8-1.1.osg33.el7
condor-kbdd-8.3.8-1.1.osg33.el7
condor-procd-8.3.8-1.1.osg33.el7
condor-python-8.3.8-1.1.osg33.el7
condor-test-8.3.8-1.1.osg33.el7
condor-vm-gahp-8.3.8-1.1.osg33.el7
emi-trustmanager-tomcat-3.0.0-12.osg33.el7
htcondor-ce-1.15-2.osg33.el7
htcondor-ce-client-1.15-2.osg33.el7
htcondor-ce-collector-1.15-2.osg33.el7
htcondor-ce-condor-1.15-2.osg33.el7
htcondor-ce-debuginfo-1.15-2.osg33.el7
htcondor-ce-lsf-1.15-2.osg33.el7
htcondor-ce-pbs-1.15-2.osg33.el7
htcondor-ce-sge-1.15-2.osg33.el7
igtf-ca-certs-1.67-1.osg33.el7
osg-build-1.6.1-1.osg33.el7
osg-ca-certs-1.48-1.osg33.el7
osg-test-1.4.29-1.osg33.el7
osg-tested-internal-3.3-3.osg33.el7
osg-version-3.3.1-1.osg33.el7
rsv-3.10.3-1_clipped.osg33.el7
rsv-consumers-3.10.3-1_clipped.osg33.el7
rsv-core-3.10.3-1_clipped.osg33.el7
rsv-metrics-3.10.3-1_clipped.osg33.el7
stashcache-0.4-2.osg33.el7
stashcache-cache-server-0.4-2.osg33.el7
stashcache-daemon-0.4-2.osg33.el7
stashcache-origin-server-0.4-2.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 5

#### Enterprise Linux 6

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 5

``` file
```

#### Enterprise Linux 6

``` file
```

