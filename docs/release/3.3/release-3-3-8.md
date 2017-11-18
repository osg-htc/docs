OSG Software Release 3.3.8
==========================

**Release Date**: 2016-01-12

Summary of changes
------------------

This release contains:

-   HTCondor-CE 2.0.0
    -   HTCondor-CE View web app
    -   Custom formatting for condor\_ce\_status
    -   blahp updates
        -   fixed crash in pbs\_status.py when /tmp and /var/tmp on different file systems
        -   added disable limited proxies option
-   [HTCondor 8.4.3](https://www-auth.cs.wisc.edu/lists/htcondor-users/2015-December/msg00028.shtml)
-   [HTCondor 8.5.1](https://www-auth.cs.wisc.edu/lists/htcondor-users/2015-December/msg00076.shtml) in Upcoming
-   [VO Package v62](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-62-2)
-   PKI tools: Accept hostname aliases in certificate requests
-   gridftp-hdfs
    -   support rename and rmdir
    -   Add load (connection) limits
-   cctools 4.4.3
-   GUMS: fix locale specific crash
-   condor-cron: configuration fixes
-   MyProxy updated to a version with no OSG patches (strict pass-through)
-   gratia
    -   closed a couple of vulnerabilities
    -   fixed bug where configure\_tomcat breaks the init script

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.8%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   HTCondor 8.4.0 has changed it's behavior in ways that cause the GlideinWMS frontend configuration to break. In order to correct this, the following setting needs to be added to the configuration file:

        :::file
        COLLECTOR_USES_SHARED_PORT = False

-   The new HTCondor-CE View has a bug where some graphs show up blank. This may also manifest in errors like the following in `/var/log/condor-ce/GangliadLog`:  
<pre class="file">

1/11/16 15:05:54 Failed to execute /usr/share/condor-ce/condor\_ce\_metric --conf /etc/ganglia/gmond.conf --group HTCondor.Schedd --name SchedulerRecentDaemonCoreDutyCycle --value 1.04449 --type float --units % --slope both --spoof 192.170.227.226:itbv-ce-htcondor.mwt2.org --tmax 120 --dmax 86400: Usage: condor\_ce\_metric \[options\]

condor\_ce\_metric: error: no such option: --conf

01/11/16 15:05:54 Failed to publish metric SchedulerRecentDaemonCoreDutyCycle for itbv-ce-htcondor.mwt2.org </pre>

-   Since version 1.14, HTCondor-CE has required condor >= 8.3.7 but this was not reflected in the packaging. If your routed jobs do not have the proper environment set, your version of HTCondor-CE is newer than 1.14, and your version of condor is older than 8.3.7, consider upgrading your version of condor. This will be fixed in the next release.
-   StashCache packages need to be manually configured
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

-   [blahp-1.18.16.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.16.bosco-1.osg33.el6)
-   [cctools-4.4.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cctools-4.4.3-1.osg33.el6)
-   [condor-8.4.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.3-1.osg33.el6)
-   [condor-cron-1.0.11-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-cron-1.0.11-1.osg33.el6)
-   [gratia-1.16.2-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-1.16.2-1.2.osg33.el6)
-   [gridftp-hdfs-0.5.4-24.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-24.osg33.el6)
-   [gums-1.5.1-6.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.1-6.osg33.el6)
-   [htcondor-ce-2.0.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.0-1.osg33.el6)
-   [myproxy-6.1.15-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=myproxy-6.1.15-2.osg33.el6)
-   [osg-pki-tools-1.2.14-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.14-1.osg33.el6)
-   [osg-release-3.3-4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-release-3.3-4.osg33.el6)
-   [osg-test-1.4.33-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.4.33-1.osg33.el6)
-   [osg-tested-internal-3.3-6.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-6.osg33.el6)
-   [osg-version-3.3.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.8-1.osg33.el6)
-   [vo-client-62-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-62-2.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.16.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.16.bosco-1.osg33.el7)
-   [cctools-4.4.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cctools-4.4.3-1.osg33.el7)
-   [condor-8.4.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.3-1.osg33.el7)
-   [condor-cron-1.0.11-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-cron-1.0.11-1.osg33.el7)
-   [gratia-1.16.2-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-1.16.2-1.2.osg33.el7)
-   [gums-1.5.1-6.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.1-6.osg33.el7)
-   [htcondor-ce-2.0.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.0-1.osg33.el7)
-   [myproxy-6.1.15-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=myproxy-6.1.15-2.osg33.el7)
-   [osg-pki-tools-1.2.14-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.14-1.osg33.el7)
-   [osg-release-3.3-4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-release-3.3-4.osg33.el7)
-   [osg-test-1.4.33-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.4.33-1.osg33.el7)
-   [osg-tested-internal-3.3-6.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-6.osg33.el7)
-   [osg-version-3.3.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.8-1.osg33.el7)
-   [vo-client-62-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-62-2.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo cctools-chirp cctools-debuginfo cctools-doc cctools-dttools cctools-makeflow cctools-parrot cctools-resource_monitor cctools-sand cctools-wavefront cctools-weaver cctools-work_queue condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-cron condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp gratia-debuginfo gratia-service gridftp-hdfs gridftp-hdfs-debuginfo gums gums-client gums-service htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-debuginfo htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-gums-config osg-pki-tools osg-pki-tools-tests osg-release osg-test osg-tested-internal osg-version vo-client vo-client-edgmkgridmap

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.16.bosco-1.osg33.el6
blahp-debuginfo-1.18.16.bosco-1.osg33.el6
cctools-4.4.3-1.osg33.el6
cctools-chirp-4.4.3-1.osg33.el6
cctools-debuginfo-4.4.3-1.osg33.el6
cctools-doc-4.4.3-1.osg33.el6
cctools-dttools-4.4.3-1.osg33.el6
cctools-makeflow-4.4.3-1.osg33.el6
cctools-parrot-4.4.3-1.osg33.el6
cctools-resource_monitor-4.4.3-1.osg33.el6
cctools-sand-4.4.3-1.osg33.el6
cctools-wavefront-4.4.3-1.osg33.el6
cctools-weaver-4.4.3-1.osg33.el6
cctools-work_queue-4.4.3-1.osg33.el6
condor-8.4.3-1.osg33.el6
condor-all-8.4.3-1.osg33.el6
condor-bosco-8.4.3-1.osg33.el6
condor-classads-8.4.3-1.osg33.el6
condor-classads-devel-8.4.3-1.osg33.el6
condor-cream-gahp-8.4.3-1.osg33.el6
condor-cron-1.0.11-1.osg33.el6
condor-debuginfo-8.4.3-1.osg33.el6
condor-kbdd-8.4.3-1.osg33.el6
condor-procd-8.4.3-1.osg33.el6
condor-python-8.4.3-1.osg33.el6
condor-std-universe-8.4.3-1.osg33.el6
condor-test-8.4.3-1.osg33.el6
condor-vm-gahp-8.4.3-1.osg33.el6
gratia-1.16.2-1.2.osg33.el6
gratia-debuginfo-1.16.2-1.2.osg33.el6
gratia-service-1.16.2-1.2.osg33.el6
gridftp-hdfs-0.5.4-24.osg33.el6
gridftp-hdfs-debuginfo-0.5.4-24.osg33.el6
gums-1.5.1-6.osg33.el6
gums-client-1.5.1-6.osg33.el6
gums-service-1.5.1-6.osg33.el6
htcondor-ce-2.0.0-1.osg33.el6
htcondor-ce-client-2.0.0-1.osg33.el6
htcondor-ce-collector-2.0.0-1.osg33.el6
htcondor-ce-condor-2.0.0-1.osg33.el6
htcondor-ce-debuginfo-2.0.0-1.osg33.el6
htcondor-ce-lsf-2.0.0-1.osg33.el6
htcondor-ce-pbs-2.0.0-1.osg33.el6
htcondor-ce-sge-2.0.0-1.osg33.el6
htcondor-ce-view-2.0.0-1.osg33.el6
myproxy-6.1.15-2.osg33.el6
myproxy-admin-6.1.15-2.osg33.el6
myproxy-debuginfo-6.1.15-2.osg33.el6
myproxy-devel-6.1.15-2.osg33.el6
myproxy-doc-6.1.15-2.osg33.el6
myproxy-libs-6.1.15-2.osg33.el6
myproxy-server-6.1.15-2.osg33.el6
myproxy-voms-6.1.15-2.osg33.el6
osg-gums-config-62-2.osg33.el6
osg-pki-tools-1.2.14-1.osg33.el6
osg-pki-tools-tests-1.2.14-1.osg33.el6
osg-release-3.3-4.osg33.el6
osg-test-1.4.33-1.osg33.el6
osg-tested-internal-3.3-6.osg33.el6
osg-version-3.3.8-1.osg33.el6
vo-client-62-2.osg33.el6
vo-client-edgmkgridmap-62-2.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.16.bosco-1.osg33.el7
blahp-debuginfo-1.18.16.bosco-1.osg33.el7
cctools-4.4.3-1.osg33.el7
cctools-chirp-4.4.3-1.osg33.el7
cctools-debuginfo-4.4.3-1.osg33.el7
cctools-doc-4.4.3-1.osg33.el7
cctools-dttools-4.4.3-1.osg33.el7
cctools-makeflow-4.4.3-1.osg33.el7
cctools-parrot-4.4.3-1.osg33.el7
cctools-resource_monitor-4.4.3-1.osg33.el7
cctools-sand-4.4.3-1.osg33.el7
cctools-wavefront-4.4.3-1.osg33.el7
cctools-weaver-4.4.3-1.osg33.el7
cctools-work_queue-4.4.3-1.osg33.el7
condor-8.4.3-1.osg33.el7
condor-all-8.4.3-1.osg33.el7
condor-bosco-8.4.3-1.osg33.el7
condor-classads-8.4.3-1.osg33.el7
condor-classads-devel-8.4.3-1.osg33.el7
condor-cron-1.0.11-1.osg33.el7
condor-debuginfo-8.4.3-1.osg33.el7
condor-kbdd-8.4.3-1.osg33.el7
condor-procd-8.4.3-1.osg33.el7
condor-python-8.4.3-1.osg33.el7
condor-test-8.4.3-1.osg33.el7
condor-vm-gahp-8.4.3-1.osg33.el7
gratia-1.16.2-1.2.osg33.el7
gratia-debuginfo-1.16.2-1.2.osg33.el7
gratia-service-1.16.2-1.2.osg33.el7
gums-1.5.1-6.osg33.el7
gums-client-1.5.1-6.osg33.el7
gums-service-1.5.1-6.osg33.el7
htcondor-ce-2.0.0-1.osg33.el7
htcondor-ce-client-2.0.0-1.osg33.el7
htcondor-ce-collector-2.0.0-1.osg33.el7
htcondor-ce-condor-2.0.0-1.osg33.el7
htcondor-ce-debuginfo-2.0.0-1.osg33.el7
htcondor-ce-lsf-2.0.0-1.osg33.el7
htcondor-ce-pbs-2.0.0-1.osg33.el7
htcondor-ce-sge-2.0.0-1.osg33.el7
htcondor-ce-view-2.0.0-1.osg33.el7
myproxy-6.1.15-2.osg33.el7
myproxy-admin-6.1.15-2.osg33.el7
myproxy-debuginfo-6.1.15-2.osg33.el7
myproxy-devel-6.1.15-2.osg33.el7
myproxy-doc-6.1.15-2.osg33.el7
myproxy-libs-6.1.15-2.osg33.el7
myproxy-server-6.1.15-2.osg33.el7
myproxy-voms-6.1.15-2.osg33.el7
osg-gums-config-62-2.osg33.el7
osg-pki-tools-1.2.14-1.osg33.el7
osg-pki-tools-tests-1.2.14-1.osg33.el7
osg-release-3.3-4.osg33.el7
osg-test-1.4.33-1.osg33.el7
osg-tested-internal-3.3-6.osg33.el7
osg-version-3.3.8-1.osg33.el7
vo-client-62-2.osg33.el7
vo-client-edgmkgridmap-62-2.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.16.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.16.bosco-1.osgup.el6)
-   [condor-8.5.1-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.1-1.osgup.el6)
-   [htcondor-ce-2.0.0-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.0-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.16.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.16.bosco-1.osgup.el7)
-   [condor-8.5.1-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.1-1.osgup.el7)
-   [htcondor-ce-2.0.0-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.0-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-debuginfo htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.16.bosco-1.osgup.el6
blahp-debuginfo-1.18.16.bosco-1.osgup.el6
condor-8.5.1-1.osgup.el6
condor-all-8.5.1-1.osgup.el6
condor-bosco-8.5.1-1.osgup.el6
condor-classads-8.5.1-1.osgup.el6
condor-classads-devel-8.5.1-1.osgup.el6
condor-cream-gahp-8.5.1-1.osgup.el6
condor-debuginfo-8.5.1-1.osgup.el6
condor-kbdd-8.5.1-1.osgup.el6
condor-procd-8.5.1-1.osgup.el6
condor-python-8.5.1-1.osgup.el6
condor-std-universe-8.5.1-1.osgup.el6
condor-test-8.5.1-1.osgup.el6
condor-vm-gahp-8.5.1-1.osgup.el6
htcondor-ce-2.0.0-1.osgup.el6
htcondor-ce-client-2.0.0-1.osgup.el6
htcondor-ce-collector-2.0.0-1.osgup.el6
htcondor-ce-condor-2.0.0-1.osgup.el6
htcondor-ce-debuginfo-2.0.0-1.osgup.el6
htcondor-ce-lsf-2.0.0-1.osgup.el6
htcondor-ce-pbs-2.0.0-1.osgup.el6
htcondor-ce-sge-2.0.0-1.osgup.el6
htcondor-ce-view-2.0.0-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.16.bosco-1.osgup.el7
blahp-debuginfo-1.18.16.bosco-1.osgup.el7
condor-8.5.1-1.osgup.el7
condor-all-8.5.1-1.osgup.el7
condor-bosco-8.5.1-1.osgup.el7
condor-classads-8.5.1-1.osgup.el7
condor-classads-devel-8.5.1-1.osgup.el7
condor-debuginfo-8.5.1-1.osgup.el7
condor-kbdd-8.5.1-1.osgup.el7
condor-procd-8.5.1-1.osgup.el7
condor-python-8.5.1-1.osgup.el7
condor-test-8.5.1-1.osgup.el7
condor-vm-gahp-8.5.1-1.osgup.el7
htcondor-ce-2.0.0-1.osgup.el7
htcondor-ce-client-2.0.0-1.osgup.el7
htcondor-ce-collector-2.0.0-1.osgup.el7
htcondor-ce-condor-2.0.0-1.osgup.el7
htcondor-ce-debuginfo-2.0.0-1.osgup.el7
htcondor-ce-lsf-2.0.0-1.osgup.el7
htcondor-ce-pbs-2.0.0-1.osgup.el7
htcondor-ce-sge-2.0.0-1.osgup.el7
htcondor-ce-view-2.0.0-1.osgup.el7
```

