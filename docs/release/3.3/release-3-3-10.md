OSG Software Release 3.3.10
===========================

**Release Date**: 2016-03-08

Summary of changes
------------------

This release contains:

-   [VO Package v64](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-64) - More OSG CA migrations
-   CA Certificates based on [IGTF 1.72](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
-   osg-ca-certs-updater no longer requires certificate compatibility packages
-   GFAL environment variables are now set in the client tarballs
-   BLAHP 1.18.17: Additional support for LSF, SGE, and BOSCO
    -   LSF: Properly handle LSF suspended jobs states
    -   SGE: Fixed scripts to work with SGE
    -   BOSCO: Report RemoteSysCpu so that a gratia record can be created
-   osg-configure: Propagate SGE parameters into the BLAHP
-   [HTCondor 8.4.4](https://www-auth.cs.wisc.edu/lists/htcondor-users/2016-February/msg00040.shtml): Various bug fixes
-   GUMS 1.5.2: Bug fix for LDAP-based user groups
-   Gratia probes: Improve robustness of handling batch system records
    -   Fixed parsing of GridJobIds that start with "batch"
    -   Improve performance of certinfo file lookup
-   StashCache: Updated configuration templates
-   AutoPyFactory 2.4.6: a provisioning factory layered on top of HTCondor
-   Support for XRootD and GridFTP HDFS plugins on EL7 platforms
-   HTCondor CE 2.0.2: HTCondor CE view installable with HTCondor CE collector
-   [HTCondor 8.5.2](https://www-auth.cs.wisc.edu/lists/htcondor-users/2016-February/msg00138.shtml) in the Upcoming repository

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.10%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   `condor_ce_q` does not show any jobs when run as root with `condor-8.5.2` from upcoming. Work around this by using `condor_ce_q -allusers` instead.

<!-- -->

-   The new HTCondor-CE View has a bug where some graphs show up blank. This may also manifest in errors like the following in `/var/log/condor-ce/GangliadLog`: \\ <pre class="file">

1/11/16 15:05:54 Failed to execute /usr/share/condor-ce/condor\_ce\_metric --conf /etc/ganglia/gmond.conf --group HTCondor.Schedd --name SchedulerRecentDaemonCoreDutyCycle --value 1.04449 --type float --units % --slope both --spoof 192.170.227.226:itbv-ce-htcondor.mwt2.org --tmax 120 --dmax 86400: Usage: condor\_ce\_metric \[options\]

condor\_ce\_metric: error: no such option: --conf

01/11/16 15:05:54 Failed to publish metric SchedulerRecentDaemonCoreDutyCycle for itbv-ce-htcondor.mwt2.org </pre>

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note
    Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

!!! note
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [autopyfactory-2.4.6-4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=autopyfactory-2.4.6-4.osg33.el6)
-   [blahp-1.18.17.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.17.bosco-1.osg33.el6)
-   [condor-8.4.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.4-1.osg33.el6)
-   [gratia-probe-1.15.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.15.0-1.osg33.el6)
-   [gums-1.5.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.2-1.osg33.el6)
-   [htcondor-ce-2.0.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.2-1.osg33.el6)
-   [igtf-ca-certs-1.72-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.72-1.osg33.el6)
-   [osg-build-1.6.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.6.2-1.osg33.el6)
-   [osg-ca-certs-1.53-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.53-1.osg33.el6)
-   [osg-ca-certs-updater-1.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.4-1.osg33.el6)
-   [osg-ca-generator-1.0.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-generator-1.0.4-1.osg33.el6)
-   [osg-configure-1.2.6-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.2.6-1.osg33.el6)
-   [osg-gridftp-hdfs-3.3-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-gridftp-hdfs-3.3-3.osg33.el6)
-   [osg-se-hadoop-3.3-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-se-hadoop-3.3-3.osg33.el6)
-   [osg-test-1.5.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.5.3-1.osg33.el6)
-   [osg-tested-internal-3.3-10.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-10.osg33.el6)
-   [osg-version-3.3.10-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.10-1.osg33.el6)
-   [stashcache-0.6-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=stashcache-0.6-2.osg33.el6)
-   [vo-client-64-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-64-1.osg33.el6)
-   [xrootd-hdfs-1.8.7-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.8.7-1.osg33.el6)

#### Enterprise Linux 7

-   [autopyfactory-2.4.6-4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=autopyfactory-2.4.6-4.osg33.el7)
-   [blahp-1.18.17.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.17.bosco-1.osg33.el7)
-   [condor-8.4.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.4-1.osg33.el7)
-   [gratia-probe-1.15.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.15.0-1.osg33.el7)
-   [gridftp-hdfs-0.5.4-24.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-24.osg33.el7)
-   [htcondor-ce-2.0.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.2-1.osg33.el7)
-   [igtf-ca-certs-1.72-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.72-1.osg33.el7)
-   [osg-build-1.6.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.6.2-1.osg33.el7)
-   [osg-ca-certs-1.53-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.53-1.osg33.el7)
-   [osg-ca-certs-updater-1.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.4-1.osg33.el7)
-   [osg-ca-generator-1.0.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-generator-1.0.4-1.osg33.el7)
-   [osg-configure-1.2.6-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.2.6-1.osg33.el7)
-   [osg-gridftp-hdfs-3.3-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-gridftp-hdfs-3.3-3.osg33.el7)
-   [osg-se-hadoop-3.3-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-se-hadoop-3.3-3.osg33.el7)
-   [osg-test-1.5.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.5.3-1.osg33.el7)
-   [osg-tested-internal-3.3-10.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-10.osg33.el7)
-   [osg-version-3.3.10-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.10-1.osg33.el7)
-   [stashcache-0.6-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=stashcache-0.6-2.osg33.el7)
-   [vo-client-64-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-64-1.osg33.el7)
-   [xrootd-hdfs-1.8.7-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.8.7-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    autopyfactory-cloud autopyfactory-common autopyfactory-panda autopyfactory-plugins-cloud autopyfactory-plugins-local autopyfactory-plugins-monitor autopyfactory-plugins-panda autopyfactory-plugins-remote autopyfactory-plugins-scheds autopyfactory-proxymanager autopyfactory-remote autopyfactory-wms blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer gums gums-client gums-service htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-debuginfo htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view igtf-ca-certs osg-build osg-ca-certs osg-ca-certs-updater osg-ca-generator osg-configure osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gridftp-hdfs osg-gums-config osg-se-hadoop osg-se-hadoop-client osg-se-hadoop-datanode osg-se-hadoop-gridftp osg-se-hadoop-namenode osg-se-hadoop-secondarynamenode osg-se-hadoop-srm osg-test osg-tested-internal osg-version stashcache-cache-server stashcache-daemon stashcache-origin-server vo-client vo-client-edgmkgridmap xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
autopyfactory-2.4.6-4.osg33.el6
autopyfactory-cloud-2.4.6-4.osg33.el6
autopyfactory-common-2.4.6-4.osg33.el6
autopyfactory-panda-2.4.6-4.osg33.el6
autopyfactory-plugins-cloud-2.4.6-4.osg33.el6
autopyfactory-plugins-local-2.4.6-4.osg33.el6
autopyfactory-plugins-monitor-2.4.6-4.osg33.el6
autopyfactory-plugins-panda-2.4.6-4.osg33.el6
autopyfactory-plugins-remote-2.4.6-4.osg33.el6
autopyfactory-plugins-scheds-2.4.6-4.osg33.el6
autopyfactory-proxymanager-2.4.6-4.osg33.el6
autopyfactory-remote-2.4.6-4.osg33.el6
autopyfactory-wms-2.4.6-4.osg33.el6
blahp-1.18.17.bosco-1.osg33.el6
blahp-debuginfo-1.18.17.bosco-1.osg33.el6
condor-8.4.4-1.osg33.el6
condor-all-8.4.4-1.osg33.el6
condor-bosco-8.4.4-1.osg33.el6
condor-classads-8.4.4-1.osg33.el6
condor-classads-devel-8.4.4-1.osg33.el6
condor-cream-gahp-8.4.4-1.osg33.el6
condor-debuginfo-8.4.4-1.osg33.el6
condor-kbdd-8.4.4-1.osg33.el6
condor-procd-8.4.4-1.osg33.el6
condor-python-8.4.4-1.osg33.el6
condor-std-universe-8.4.4-1.osg33.el6
condor-test-8.4.4-1.osg33.el6
condor-vm-gahp-8.4.4-1.osg33.el6
gratia-probe-1.15.0-1.osg33.el6
gratia-probe-bdii-status-1.15.0-1.osg33.el6
gratia-probe-common-1.15.0-1.osg33.el6
gratia-probe-condor-1.15.0-1.osg33.el6
gratia-probe-condor-events-1.15.0-1.osg33.el6
gratia-probe-dcache-storage-1.15.0-1.osg33.el6
gratia-probe-dcache-storagegroup-1.15.0-1.osg33.el6
gratia-probe-dcache-transfer-1.15.0-1.osg33.el6
gratia-probe-debuginfo-1.15.0-1.osg33.el6
gratia-probe-enstore-storage-1.15.0-1.osg33.el6
gratia-probe-enstore-tapedrive-1.15.0-1.osg33.el6
gratia-probe-enstore-transfer-1.15.0-1.osg33.el6
gratia-probe-glexec-1.15.0-1.osg33.el6
gratia-probe-glideinwms-1.15.0-1.osg33.el6
gratia-probe-gram-1.15.0-1.osg33.el6
gratia-probe-gridftp-transfer-1.15.0-1.osg33.el6
gratia-probe-hadoop-storage-1.15.0-1.osg33.el6
gratia-probe-lsf-1.15.0-1.osg33.el6
gratia-probe-metric-1.15.0-1.osg33.el6
gratia-probe-onevm-1.15.0-1.osg33.el6
gratia-probe-pbs-lsf-1.15.0-1.osg33.el6
gratia-probe-services-1.15.0-1.osg33.el6
gratia-probe-sge-1.15.0-1.osg33.el6
gratia-probe-slurm-1.15.0-1.osg33.el6
gratia-probe-xrootd-storage-1.15.0-1.osg33.el6
gratia-probe-xrootd-transfer-1.15.0-1.osg33.el6
gums-1.5.2-1.osg33.el6
gums-client-1.5.2-1.osg33.el6
gums-service-1.5.2-1.osg33.el6
htcondor-ce-2.0.2-1.osg33.el6
htcondor-ce-client-2.0.2-1.osg33.el6
htcondor-ce-collector-2.0.2-1.osg33.el6
htcondor-ce-condor-2.0.2-1.osg33.el6
htcondor-ce-debuginfo-2.0.2-1.osg33.el6
htcondor-ce-lsf-2.0.2-1.osg33.el6
htcondor-ce-pbs-2.0.2-1.osg33.el6
htcondor-ce-sge-2.0.2-1.osg33.el6
htcondor-ce-view-2.0.2-1.osg33.el6
igtf-ca-certs-1.72-1.osg33.el6
osg-build-1.6.2-1.osg33.el6
osg-ca-certs-1.53-1.osg33.el6
osg-ca-certs-updater-1.4-1.osg33.el6
osg-ca-generator-1.0.4-1.osg33.el6
osg-configure-1.2.6-1.osg33.el6
osg-configure-ce-1.2.6-1.osg33.el6
osg-configure-cemon-1.2.6-1.osg33.el6
osg-configure-condor-1.2.6-1.osg33.el6
osg-configure-gateway-1.2.6-1.osg33.el6
osg-configure-gip-1.2.6-1.osg33.el6
osg-configure-gratia-1.2.6-1.osg33.el6
osg-configure-infoservices-1.2.6-1.osg33.el6
osg-configure-lsf-1.2.6-1.osg33.el6
osg-configure-managedfork-1.2.6-1.osg33.el6
osg-configure-misc-1.2.6-1.osg33.el6
osg-configure-monalisa-1.2.6-1.osg33.el6
osg-configure-network-1.2.6-1.osg33.el6
osg-configure-pbs-1.2.6-1.osg33.el6
osg-configure-rsv-1.2.6-1.osg33.el6
osg-configure-sge-1.2.6-1.osg33.el6
osg-configure-slurm-1.2.6-1.osg33.el6
osg-configure-squid-1.2.6-1.osg33.el6
osg-configure-tests-1.2.6-1.osg33.el6
osg-gridftp-hdfs-3.3-3.osg33.el6
osg-gums-config-64-1.osg33.el6
osg-se-hadoop-3.3-3.osg33.el6
osg-se-hadoop-client-3.3-3.osg33.el6
osg-se-hadoop-datanode-3.3-3.osg33.el6
osg-se-hadoop-gridftp-3.3-3.osg33.el6
osg-se-hadoop-namenode-3.3-3.osg33.el6
osg-se-hadoop-secondarynamenode-3.3-3.osg33.el6
osg-se-hadoop-srm-3.3-3.osg33.el6
osg-test-1.5.3-1.osg33.el6
osg-tested-internal-3.3-10.osg33.el6
osg-version-3.3.10-1.osg33.el6
stashcache-0.6-2.osg33.el6
stashcache-cache-server-0.6-2.osg33.el6
stashcache-daemon-0.6-2.osg33.el6
stashcache-origin-server-0.6-2.osg33.el6
vo-client-64-1.osg33.el6
vo-client-edgmkgridmap-64-1.osg33.el6
xrootd-hdfs-1.8.7-1.osg33.el6
xrootd-hdfs-debuginfo-1.8.7-1.osg33.el6
xrootd-hdfs-devel-1.8.7-1.osg33.el6
```

#### Enterprise Linux 7

``` file
autopyfactory-2.4.6-4.osg33.el7
autopyfactory-cloud-2.4.6-4.osg33.el7
autopyfactory-common-2.4.6-4.osg33.el7
autopyfactory-panda-2.4.6-4.osg33.el7
autopyfactory-plugins-cloud-2.4.6-4.osg33.el7
autopyfactory-plugins-local-2.4.6-4.osg33.el7
autopyfactory-plugins-monitor-2.4.6-4.osg33.el7
autopyfactory-plugins-panda-2.4.6-4.osg33.el7
autopyfactory-plugins-remote-2.4.6-4.osg33.el7
autopyfactory-plugins-scheds-2.4.6-4.osg33.el7
autopyfactory-proxymanager-2.4.6-4.osg33.el7
autopyfactory-remote-2.4.6-4.osg33.el7
autopyfactory-wms-2.4.6-4.osg33.el7
blahp-1.18.17.bosco-1.osg33.el7
blahp-debuginfo-1.18.17.bosco-1.osg33.el7
condor-8.4.4-1.osg33.el7
condor-all-8.4.4-1.osg33.el7
condor-bosco-8.4.4-1.osg33.el7
condor-classads-8.4.4-1.osg33.el7
condor-classads-devel-8.4.4-1.osg33.el7
condor-debuginfo-8.4.4-1.osg33.el7
condor-kbdd-8.4.4-1.osg33.el7
condor-procd-8.4.4-1.osg33.el7
condor-python-8.4.4-1.osg33.el7
condor-test-8.4.4-1.osg33.el7
condor-vm-gahp-8.4.4-1.osg33.el7
gratia-probe-1.15.0-1.osg33.el7
gratia-probe-bdii-status-1.15.0-1.osg33.el7
gratia-probe-common-1.15.0-1.osg33.el7
gratia-probe-condor-1.15.0-1.osg33.el7
gratia-probe-condor-events-1.15.0-1.osg33.el7
gratia-probe-dcache-storage-1.15.0-1.osg33.el7
gratia-probe-dcache-storagegroup-1.15.0-1.osg33.el7
gratia-probe-dcache-transfer-1.15.0-1.osg33.el7
gratia-probe-debuginfo-1.15.0-1.osg33.el7
gratia-probe-enstore-storage-1.15.0-1.osg33.el7
gratia-probe-enstore-tapedrive-1.15.0-1.osg33.el7
gratia-probe-enstore-transfer-1.15.0-1.osg33.el7
gratia-probe-glexec-1.15.0-1.osg33.el7
gratia-probe-glideinwms-1.15.0-1.osg33.el7
gratia-probe-gram-1.15.0-1.osg33.el7
gratia-probe-gridftp-transfer-1.15.0-1.osg33.el7
gratia-probe-hadoop-storage-1.15.0-1.osg33.el7
gratia-probe-lsf-1.15.0-1.osg33.el7
gratia-probe-metric-1.15.0-1.osg33.el7
gratia-probe-onevm-1.15.0-1.osg33.el7
gratia-probe-pbs-lsf-1.15.0-1.osg33.el7
gratia-probe-services-1.15.0-1.osg33.el7
gratia-probe-sge-1.15.0-1.osg33.el7
gratia-probe-slurm-1.15.0-1.osg33.el7
gratia-probe-xrootd-storage-1.15.0-1.osg33.el7
gratia-probe-xrootd-transfer-1.15.0-1.osg33.el7
gridftp-hdfs-0.5.4-24.osg33.el7
gridftp-hdfs-debuginfo-0.5.4-24.osg33.el7
htcondor-ce-2.0.2-1.osg33.el7
htcondor-ce-client-2.0.2-1.osg33.el7
htcondor-ce-collector-2.0.2-1.osg33.el7
htcondor-ce-condor-2.0.2-1.osg33.el7
htcondor-ce-debuginfo-2.0.2-1.osg33.el7
htcondor-ce-lsf-2.0.2-1.osg33.el7
htcondor-ce-pbs-2.0.2-1.osg33.el7
htcondor-ce-sge-2.0.2-1.osg33.el7
htcondor-ce-view-2.0.2-1.osg33.el7
igtf-ca-certs-1.72-1.osg33.el7
osg-build-1.6.2-1.osg33.el7
osg-ca-certs-1.53-1.osg33.el7
osg-ca-certs-updater-1.4-1.osg33.el7
osg-ca-generator-1.0.4-1.osg33.el7
osg-configure-1.2.6-1.osg33.el7
osg-configure-ce-1.2.6-1.osg33.el7
osg-configure-cemon-1.2.6-1.osg33.el7
osg-configure-condor-1.2.6-1.osg33.el7
osg-configure-gateway-1.2.6-1.osg33.el7
osg-configure-gip-1.2.6-1.osg33.el7
osg-configure-gratia-1.2.6-1.osg33.el7
osg-configure-infoservices-1.2.6-1.osg33.el7
osg-configure-lsf-1.2.6-1.osg33.el7
osg-configure-managedfork-1.2.6-1.osg33.el7
osg-configure-misc-1.2.6-1.osg33.el7
osg-configure-monalisa-1.2.6-1.osg33.el7
osg-configure-network-1.2.6-1.osg33.el7
osg-configure-pbs-1.2.6-1.osg33.el7
osg-configure-rsv-1.2.6-1.osg33.el7
osg-configure-sge-1.2.6-1.osg33.el7
osg-configure-slurm-1.2.6-1.osg33.el7
osg-configure-squid-1.2.6-1.osg33.el7
osg-configure-tests-1.2.6-1.osg33.el7
osg-gridftp-hdfs-3.3-3.osg33.el7
osg-gums-config-64-1.osg33.el7
osg-se-hadoop-3.3-3.osg33.el7
osg-se-hadoop-client-3.3-3.osg33.el7
osg-se-hadoop-datanode-3.3-3.osg33.el7
osg-se-hadoop-gridftp-3.3-3.osg33.el7
osg-se-hadoop-namenode-3.3-3.osg33.el7
osg-se-hadoop-secondarynamenode-3.3-3.osg33.el7
osg-se-hadoop-srm-3.3-3.osg33.el7
osg-test-1.5.3-1.osg33.el7
osg-tested-internal-3.3-10.osg33.el7
osg-version-3.3.10-1.osg33.el7
stashcache-0.6-2.osg33.el7
stashcache-cache-server-0.6-2.osg33.el7
stashcache-daemon-0.6-2.osg33.el7
stashcache-origin-server-0.6-2.osg33.el7
vo-client-64-1.osg33.el7
vo-client-edgmkgridmap-64-1.osg33.el7
xrootd-hdfs-1.8.7-1.osg33.el7
xrootd-hdfs-debuginfo-1.8.7-1.osg33.el7
xrootd-hdfs-devel-1.8.7-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.17.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.17.bosco-1.osgup.el6)
-   [condor-8.5.2-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.2-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.17.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.17.bosco-1.osgup.el7)
-   [condor-8.5.2-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.2-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.17.bosco-1.osgup.el6
blahp-debuginfo-1.18.17.bosco-1.osgup.el6
condor-8.5.2-1.osgup.el6
condor-all-8.5.2-1.osgup.el6
condor-bosco-8.5.2-1.osgup.el6
condor-classads-8.5.2-1.osgup.el6
condor-classads-devel-8.5.2-1.osgup.el6
condor-cream-gahp-8.5.2-1.osgup.el6
condor-debuginfo-8.5.2-1.osgup.el6
condor-kbdd-8.5.2-1.osgup.el6
condor-procd-8.5.2-1.osgup.el6
condor-python-8.5.2-1.osgup.el6
condor-std-universe-8.5.2-1.osgup.el6
condor-test-8.5.2-1.osgup.el6
condor-vm-gahp-8.5.2-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.17.bosco-1.osgup.el7
blahp-debuginfo-1.18.17.bosco-1.osgup.el7
condor-8.5.2-1.osgup.el7
condor-all-8.5.2-1.osgup.el7
condor-bosco-8.5.2-1.osgup.el7
condor-classads-8.5.2-1.osgup.el7
condor-classads-devel-8.5.2-1.osgup.el7
condor-debuginfo-8.5.2-1.osgup.el7
condor-kbdd-8.5.2-1.osgup.el7
condor-procd-8.5.2-1.osgup.el7
condor-python-8.5.2-1.osgup.el7
condor-test-8.5.2-1.osgup.el7
condor-vm-gahp-8.5.2-1.osgup.el7
```

