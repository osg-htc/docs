OSG Software Release 3.3.5
==========================

**Release Date**: 2015-11-19

Summary of changes
------------------

This release contains:

-   lcmaps-plugins-scas-client
    -   Fixed a leak that caused HTCondor CE to use excessive memory
-   osg-configure
    -   Fixed a crash when attempting to connect to the recently retired ReSS servers while configuring a CE
    -   Now reconfigures the HTCondor CE after generating job environment files
-   HTCondor CE 1.20
    -   Users can now add onto accounting group defaults set by the job router
    -   Use GSI mapping cache to reduce calls to GSI
-   [HTCondor 8.4.2](https://www-auth.cs.wisc.edu/lists/htcondor-users/2015-November/msg00083.shtml)
-   RSV
    -   Corrected log rotation configuration error introduced in 3.2.30/3.3.4

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.5%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   CILogon CA certificate files have been reorganized between our various CA certificate packages.  
To avoid file conflicts, you should upgrade your CA certificate RPMs at the same time, such as via the following command:  
<pre class="rootscreen">root@host # yum update '\*-ca-cert\*'</pre>

<!-- -->

-   HTCondor 8.4.0 has changed it's behavior in ways that cause the GlideinWMS frontend configuration to break. In order to correct this, the following setting needs to be added to the configuration file:

        :::file
        COLLECTOR_USES_SHARED_PORT = False

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

-   [blahp-1.18.15.bosco-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.15.bosco-3.osg33.el6)
-   [condor-8.4.2-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.2-1.1.osg33.el6)
-   [htcondor-ce-1.20-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-1.20-1.osg33.el6)
-   [lcmaps-plugins-scas-client-0.5.5-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=lcmaps-plugins-scas-client-0.5.5-1.1.osg33.el6)
-   [osg-configure-1.2.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.2.4-1.osg33.el6)
-   [osg-version-3.3.5-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.5-1.osg33.el6)
-   [rsv-3.12.5-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.12.5-1.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.15.bosco-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.15.bosco-3.osg33.el7)
-   [condor-8.4.2-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.2-1.1.osg33.el7)
-   [htcondor-ce-1.20-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-1.20-1.osg33.el7)
-   [lcmaps-plugins-scas-client-0.5.5-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=lcmaps-plugins-scas-client-0.5.5-1.1.osg33.el7)
-   [osg-configure-1.2.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.2.4-1.osg33.el7)
-   [osg-version-3.3.5-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.5-1.osg33.el7)
-   [rsv-3.12.5-1\_clipped.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.12.5-1_clipped.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-debuginfo htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge lcmaps-plugins-scas-client lcmaps-plugins-scas-client-debuginfo osg-configure osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-version rsv rsv-consumers rsv-core rsv-metrics

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.15.bosco-3.osg33.el6
blahp-debuginfo-1.18.15.bosco-3.osg33.el6
condor-8.4.2-1.1.osg33.el6
condor-all-8.4.2-1.1.osg33.el6
condor-bosco-8.4.2-1.1.osg33.el6
condor-classads-8.4.2-1.1.osg33.el6
condor-classads-devel-8.4.2-1.1.osg33.el6
condor-cream-gahp-8.4.2-1.1.osg33.el6
condor-debuginfo-8.4.2-1.1.osg33.el6
condor-kbdd-8.4.2-1.1.osg33.el6
condor-procd-8.4.2-1.1.osg33.el6
condor-python-8.4.2-1.1.osg33.el6
condor-std-universe-8.4.2-1.1.osg33.el6
condor-test-8.4.2-1.1.osg33.el6
condor-vm-gahp-8.4.2-1.1.osg33.el6
htcondor-ce-1.20-1.osg33.el6
htcondor-ce-client-1.20-1.osg33.el6
htcondor-ce-collector-1.20-1.osg33.el6
htcondor-ce-condor-1.20-1.osg33.el6
htcondor-ce-debuginfo-1.20-1.osg33.el6
htcondor-ce-lsf-1.20-1.osg33.el6
htcondor-ce-pbs-1.20-1.osg33.el6
htcondor-ce-sge-1.20-1.osg33.el6
lcmaps-plugins-scas-client-0.5.5-1.1.osg33.el6
lcmaps-plugins-scas-client-debuginfo-0.5.5-1.1.osg33.el6
osg-configure-1.2.4-1.osg33.el6
osg-configure-ce-1.2.4-1.osg33.el6
osg-configure-cemon-1.2.4-1.osg33.el6
osg-configure-condor-1.2.4-1.osg33.el6
osg-configure-gateway-1.2.4-1.osg33.el6
osg-configure-gip-1.2.4-1.osg33.el6
osg-configure-gratia-1.2.4-1.osg33.el6
osg-configure-infoservices-1.2.4-1.osg33.el6
osg-configure-lsf-1.2.4-1.osg33.el6
osg-configure-managedfork-1.2.4-1.osg33.el6
osg-configure-misc-1.2.4-1.osg33.el6
osg-configure-monalisa-1.2.4-1.osg33.el6
osg-configure-network-1.2.4-1.osg33.el6
osg-configure-pbs-1.2.4-1.osg33.el6
osg-configure-rsv-1.2.4-1.osg33.el6
osg-configure-sge-1.2.4-1.osg33.el6
osg-configure-slurm-1.2.4-1.osg33.el6
osg-configure-squid-1.2.4-1.osg33.el6
osg-configure-tests-1.2.4-1.osg33.el6
osg-version-3.3.5-1.osg33.el6
rsv-3.12.5-1.osg33.el6
rsv-consumers-3.12.5-1.osg33.el6
rsv-core-3.12.5-1.osg33.el6
rsv-metrics-3.12.5-1.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.15.bosco-3.osg33.el7
blahp-debuginfo-1.18.15.bosco-3.osg33.el7
condor-8.4.2-1.1.osg33.el7
condor-all-8.4.2-1.1.osg33.el7
condor-bosco-8.4.2-1.1.osg33.el7
condor-classads-8.4.2-1.1.osg33.el7
condor-classads-devel-8.4.2-1.1.osg33.el7
condor-debuginfo-8.4.2-1.1.osg33.el7
condor-kbdd-8.4.2-1.1.osg33.el7
condor-procd-8.4.2-1.1.osg33.el7
condor-python-8.4.2-1.1.osg33.el7
condor-test-8.4.2-1.1.osg33.el7
condor-vm-gahp-8.4.2-1.1.osg33.el7
htcondor-ce-1.20-1.osg33.el7
htcondor-ce-client-1.20-1.osg33.el7
htcondor-ce-collector-1.20-1.osg33.el7
htcondor-ce-condor-1.20-1.osg33.el7
htcondor-ce-debuginfo-1.20-1.osg33.el7
htcondor-ce-lsf-1.20-1.osg33.el7
htcondor-ce-pbs-1.20-1.osg33.el7
htcondor-ce-sge-1.20-1.osg33.el7
lcmaps-plugins-scas-client-0.5.5-1.1.osg33.el7
lcmaps-plugins-scas-client-debuginfo-0.5.5-1.1.osg33.el7
osg-configure-1.2.4-1.osg33.el7
osg-configure-ce-1.2.4-1.osg33.el7
osg-configure-cemon-1.2.4-1.osg33.el7
osg-configure-condor-1.2.4-1.osg33.el7
osg-configure-gateway-1.2.4-1.osg33.el7
osg-configure-gip-1.2.4-1.osg33.el7
osg-configure-gratia-1.2.4-1.osg33.el7
osg-configure-infoservices-1.2.4-1.osg33.el7
osg-configure-lsf-1.2.4-1.osg33.el7
osg-configure-managedfork-1.2.4-1.osg33.el7
osg-configure-misc-1.2.4-1.osg33.el7
osg-configure-monalisa-1.2.4-1.osg33.el7
osg-configure-network-1.2.4-1.osg33.el7
osg-configure-pbs-1.2.4-1.osg33.el7
osg-configure-rsv-1.2.4-1.osg33.el7
osg-configure-sge-1.2.4-1.osg33.el7
osg-configure-slurm-1.2.4-1.osg33.el7
osg-configure-squid-1.2.4-1.osg33.el7
osg-configure-tests-1.2.4-1.osg33.el7
osg-version-3.3.5-1.osg33.el7
rsv-3.12.5-1_clipped.osg33.el7
rsv-consumers-3.12.5-1_clipped.osg33.el7
rsv-core-3.12.5-1_clipped.osg33.el7
rsv-metrics-3.12.5-1_clipped.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

#### Enterprise Linux 7

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
```

#### Enterprise Linux 7

``` file
```

