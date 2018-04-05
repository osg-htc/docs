OSG Software Release 3.3.14
===========================

**Release Date**: 2016-07-12

Summary of changes
------------------

This release contains:

-   CA Certificates based on [IGTF 1.75](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
-   [HTCondor 8.4.8](https://www-auth.cs.wisc.edu/lists/htcondor-users/2016-July/msg00012.shtml) containing the following fixes:
    -   Fixed memory leak triggered by python bindings
    -   Fixed a bug that could cause Bosco file transfers to fail
    -   Fixed a bug that could cause the schedd to crash when using schedd cron jobs
    -   condor\_schedd now rejects jobs when owner has no account on the machine
    -   [Other bug fixes](http://research.cs.wisc.edu/htcondor/manual/v8.4.8/10_3Stable_Release.html)
-   [GlideinWMS 3.2.14.1](http://glideinwms.fnal.gov/doc.v3_2_14_1/history.html)
-   HTCondor-CE 2.0.7: Added htcondor-ce-bosco sub-package
-   blahp 1.18.21: Slurm improvements
-   xrootd-voms-plugin 0.4.0: added support for 'all' group selection
-   gridFTP 7.20-1.2: adler32 support, fix deadlock
-   osg-configure 1.4.1
    -   Set HTCondor-CE configuration for htcondor-ce-bosco
    -   Do not overwrite custom bosco routes
    -   Ensure that GUMS host resolves
    -   Warn user when switching authorization methods in `/etc/lcmaps.db`
-   osg-system-profiler 1.4.0: detect unconfigured trustmanager, no longer create profile in-place
-   gridFTP-HDFS 0.5.4: fixed ability to list/remove empty directories
-   cvmfs-config-osg 1.2.5: use new CVMFS fallback policies
-   bigtop-utils 0.6.0+258-1.cdh4.7.1.p0.13.1: Fix default `JAVA_HOME` to prevent crash in hdfs utils
-   osg-voms 3.3-3: Remove voms-admin (EL7 only)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.14%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   `condor_ce_q` does not show any jobs when run as root with `condor-8.5.5` from upcoming. Work around this by using `condor_ce_q -allusers` instead.

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note "Notes"
    -   Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.1.osg33.el6)
-   [blahp-1.18.21.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.21.bosco-1.osg33.el6)
-   [condor-8.4.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.8-1.osg33.el6)
-   [glideinwms-3.2.14.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.14.1-1.osg33.el6)
-   [globus-gridftp-server-7.20-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-7.20-1.2.osg33.el6)
-   [gridftp-hdfs-0.5.4-25.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-25.1.osg33.el6)
-   [htcondor-ce-2.0.7-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.7-1.osg33.el6)
-   [igtf-ca-certs-1.75-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.75-1.osg33.el6)
-   [osg-build-1.6.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.6.4-1.osg33.el6)
-   [osg-ca-certs-1.56-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.56-1.osg33.el6)
-   [osg-ce-3.3-7.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ce-3.3-7.osg33.el6)
-   [osg-configure-1.4.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.4.1-1.osg33.el6)
-   [osg-system-profiler-1.4.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.0-1.osg33.el6)
-   [osg-test-1.8.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.8.2-1.osg33.el6)
-   [osg-version-3.3.14-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.14-1.osg33.el6)
-   [osg-voms-3.3-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-voms-3.3-3.osg33.el6)
-   [xrootd-voms-plugin-0.4.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-voms-plugin-0.4.0-1.osg33.el6)

#### Enterprise Linux 7

-   [bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.1.osg33.el7)
-   [blahp-1.18.21.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.21.bosco-1.osg33.el7)
-   [condor-8.4.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.8-1.osg33.el7)
-   [glideinwms-3.2.14.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.14.1-1.osg33.el7)
-   [globus-gridftp-server-7.20-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-7.20-1.2.osg33.el7)
-   [gridftp-hdfs-0.5.4-25.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-25.1.osg33.el7)
-   [htcondor-ce-2.0.7-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.7-1.osg33.el7)
-   [igtf-ca-certs-1.75-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.75-1.osg33.el7)
-   [osg-build-1.6.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.6.4-1.osg33.el7)
-   [osg-ca-certs-1.56-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.56-1.osg33.el7)
-   [osg-ce-3.3-7\_clipped.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ce-3.3-7_clipped.osg33.el7)
-   [osg-configure-1.4.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.4.1-1.osg33.el7)
-   [osg-system-profiler-1.4.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.0-1.osg33.el7)
-   [osg-test-1.8.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.8.2-1.osg33.el7)
-   [osg-version-3.3.14-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.14-1.osg33.el7)
-   [osg-voms-3.3-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-voms-3.3-3.osg33.el7)
-   [xrootd-voms-plugin-0.4.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-voms-plugin-0.4.0-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    bigtop-utils blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gridftp-hdfs gridftp-hdfs-debuginfo htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view igtf-ca-certs osg-base-ce osg-base-ce-bosco osg-base-ce-condor osg-base-ce-lsf osg-base-ce-pbs osg-base-ce-sge osg-base-ce-slurm osg-build osg-ca-certs osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-htcondor-ce osg-htcondor-ce-bosco osg-htcondor-ce-condor osg-htcondor-ce-lsf osg-htcondor-ce-pbs osg-htcondor-ce-sge osg-htcondor-ce-slurm osg-system-profiler osg-system-profiler-viewer osg-test osg-version osg-voms xrootd-voms-plugin xrootd-voms-plugin-debuginfo xrootd-voms-plugin-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.1.osg33.el6
blahp-1.18.21.bosco-1.osg33.el6
blahp-debuginfo-1.18.21.bosco-1.osg33.el6
condor-8.4.8-1.osg33.el6
condor-all-8.4.8-1.osg33.el6
condor-bosco-8.4.8-1.osg33.el6
condor-classads-8.4.8-1.osg33.el6
condor-classads-devel-8.4.8-1.osg33.el6
condor-cream-gahp-8.4.8-1.osg33.el6
condor-debuginfo-8.4.8-1.osg33.el6
condor-kbdd-8.4.8-1.osg33.el6
condor-procd-8.4.8-1.osg33.el6
condor-python-8.4.8-1.osg33.el6
condor-std-universe-8.4.8-1.osg33.el6
condor-test-8.4.8-1.osg33.el6
condor-vm-gahp-8.4.8-1.osg33.el6
glideinwms-3.2.14.1-1.osg33.el6
glideinwms-common-tools-3.2.14.1-1.osg33.el6
glideinwms-condor-common-config-3.2.14.1-1.osg33.el6
glideinwms-factory-3.2.14.1-1.osg33.el6
glideinwms-factory-condor-3.2.14.1-1.osg33.el6
glideinwms-glidecondor-tools-3.2.14.1-1.osg33.el6
glideinwms-libs-3.2.14.1-1.osg33.el6
glideinwms-minimal-condor-3.2.14.1-1.osg33.el6
glideinwms-usercollector-3.2.14.1-1.osg33.el6
glideinwms-userschedd-3.2.14.1-1.osg33.el6
glideinwms-vofrontend-3.2.14.1-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.14.1-1.osg33.el6
globus-gridftp-server-7.20-1.2.osg33.el6
globus-gridftp-server-debuginfo-7.20-1.2.osg33.el6
globus-gridftp-server-devel-7.20-1.2.osg33.el6
globus-gridftp-server-progs-7.20-1.2.osg33.el6
gridftp-hdfs-0.5.4-25.1.osg33.el6
gridftp-hdfs-debuginfo-0.5.4-25.1.osg33.el6
htcondor-ce-2.0.7-1.osg33.el6
htcondor-ce-bosco-2.0.7-1.osg33.el6
htcondor-ce-client-2.0.7-1.osg33.el6
htcondor-ce-collector-2.0.7-1.osg33.el6
htcondor-ce-condor-2.0.7-1.osg33.el6
htcondor-ce-lsf-2.0.7-1.osg33.el6
htcondor-ce-pbs-2.0.7-1.osg33.el6
htcondor-ce-sge-2.0.7-1.osg33.el6
htcondor-ce-view-2.0.7-1.osg33.el6
igtf-ca-certs-1.75-1.osg33.el6
osg-base-ce-3.3-7.osg33.el6
osg-base-ce-bosco-3.3-7.osg33.el6
osg-base-ce-condor-3.3-7.osg33.el6
osg-base-ce-lsf-3.3-7.osg33.el6
osg-base-ce-pbs-3.3-7.osg33.el6
osg-base-ce-sge-3.3-7.osg33.el6
osg-base-ce-slurm-3.3-7.osg33.el6
osg-build-1.6.4-1.osg33.el6
osg-ca-certs-1.56-1.osg33.el6
osg-ce-3.3-7.osg33.el6
osg-ce-bosco-3.3-7.osg33.el6
osg-ce-condor-3.3-7.osg33.el6
osg-ce-lsf-3.3-7.osg33.el6
osg-ce-pbs-3.3-7.osg33.el6
osg-ce-sge-3.3-7.osg33.el6
osg-ce-slurm-3.3-7.osg33.el6
osg-configure-1.4.1-1.osg33.el6
osg-configure-bosco-1.4.1-1.osg33.el6
osg-configure-ce-1.4.1-1.osg33.el6
osg-configure-cemon-1.4.1-1.osg33.el6
osg-configure-condor-1.4.1-1.osg33.el6
osg-configure-gateway-1.4.1-1.osg33.el6
osg-configure-gip-1.4.1-1.osg33.el6
osg-configure-gratia-1.4.1-1.osg33.el6
osg-configure-infoservices-1.4.1-1.osg33.el6
osg-configure-lsf-1.4.1-1.osg33.el6
osg-configure-managedfork-1.4.1-1.osg33.el6
osg-configure-misc-1.4.1-1.osg33.el6
osg-configure-monalisa-1.4.1-1.osg33.el6
osg-configure-network-1.4.1-1.osg33.el6
osg-configure-pbs-1.4.1-1.osg33.el6
osg-configure-rsv-1.4.1-1.osg33.el6
osg-configure-sge-1.4.1-1.osg33.el6
osg-configure-slurm-1.4.1-1.osg33.el6
osg-configure-squid-1.4.1-1.osg33.el6
osg-configure-tests-1.4.1-1.osg33.el6
osg-htcondor-ce-3.3-7.osg33.el6
osg-htcondor-ce-bosco-3.3-7.osg33.el6
osg-htcondor-ce-condor-3.3-7.osg33.el6
osg-htcondor-ce-lsf-3.3-7.osg33.el6
osg-htcondor-ce-pbs-3.3-7.osg33.el6
osg-htcondor-ce-sge-3.3-7.osg33.el6
osg-htcondor-ce-slurm-3.3-7.osg33.el6
osg-system-profiler-1.4.0-1.osg33.el6
osg-system-profiler-viewer-1.4.0-1.osg33.el6
osg-test-1.8.2-1.osg33.el6
osg-version-3.3.14-1.osg33.el6
osg-voms-3.3-3.osg33.el6
xrootd-voms-plugin-0.4.0-1.osg33.el6
xrootd-voms-plugin-debuginfo-0.4.0-1.osg33.el6
xrootd-voms-plugin-devel-0.4.0-1.osg33.el6
```

#### Enterprise Linux 7

``` file
bigtop-utils-0.6.0+248-1.cdh4.7.1.p0.13.1.osg33.el7
blahp-1.18.21.bosco-1.osg33.el7
blahp-debuginfo-1.18.21.bosco-1.osg33.el7
condor-8.4.8-1.osg33.el7
condor-all-8.4.8-1.osg33.el7
condor-bosco-8.4.8-1.osg33.el7
condor-classads-8.4.8-1.osg33.el7
condor-classads-devel-8.4.8-1.osg33.el7
condor-debuginfo-8.4.8-1.osg33.el7
condor-kbdd-8.4.8-1.osg33.el7
condor-procd-8.4.8-1.osg33.el7
condor-python-8.4.8-1.osg33.el7
condor-test-8.4.8-1.osg33.el7
condor-vm-gahp-8.4.8-1.osg33.el7
glideinwms-3.2.14.1-1.osg33.el7
glideinwms-common-tools-3.2.14.1-1.osg33.el7
glideinwms-condor-common-config-3.2.14.1-1.osg33.el7
glideinwms-factory-3.2.14.1-1.osg33.el7
glideinwms-factory-condor-3.2.14.1-1.osg33.el7
glideinwms-glidecondor-tools-3.2.14.1-1.osg33.el7
glideinwms-libs-3.2.14.1-1.osg33.el7
glideinwms-minimal-condor-3.2.14.1-1.osg33.el7
glideinwms-usercollector-3.2.14.1-1.osg33.el7
glideinwms-userschedd-3.2.14.1-1.osg33.el7
glideinwms-vofrontend-3.2.14.1-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.14.1-1.osg33.el7
globus-gridftp-server-7.20-1.2.osg33.el7
globus-gridftp-server-debuginfo-7.20-1.2.osg33.el7
globus-gridftp-server-devel-7.20-1.2.osg33.el7
globus-gridftp-server-progs-7.20-1.2.osg33.el7
gridftp-hdfs-0.5.4-25.1.osg33.el7
gridftp-hdfs-debuginfo-0.5.4-25.1.osg33.el7
htcondor-ce-2.0.7-1.osg33.el7
htcondor-ce-bosco-2.0.7-1.osg33.el7
htcondor-ce-client-2.0.7-1.osg33.el7
htcondor-ce-collector-2.0.7-1.osg33.el7
htcondor-ce-condor-2.0.7-1.osg33.el7
htcondor-ce-lsf-2.0.7-1.osg33.el7
htcondor-ce-pbs-2.0.7-1.osg33.el7
htcondor-ce-sge-2.0.7-1.osg33.el7
htcondor-ce-view-2.0.7-1.osg33.el7
igtf-ca-certs-1.75-1.osg33.el7
osg-base-ce-3.3-7_clipped.osg33.el7
osg-base-ce-bosco-3.3-7_clipped.osg33.el7
osg-base-ce-condor-3.3-7_clipped.osg33.el7
osg-base-ce-lsf-3.3-7_clipped.osg33.el7
osg-base-ce-pbs-3.3-7_clipped.osg33.el7
osg-base-ce-sge-3.3-7_clipped.osg33.el7
osg-base-ce-slurm-3.3-7_clipped.osg33.el7
osg-build-1.6.4-1.osg33.el7
osg-ca-certs-1.56-1.osg33.el7
osg-ce-3.3-7_clipped.osg33.el7
osg-ce-bosco-3.3-7_clipped.osg33.el7
osg-ce-condor-3.3-7_clipped.osg33.el7
osg-ce-lsf-3.3-7_clipped.osg33.el7
osg-ce-pbs-3.3-7_clipped.osg33.el7
osg-ce-sge-3.3-7_clipped.osg33.el7
osg-ce-slurm-3.3-7_clipped.osg33.el7
osg-configure-1.4.1-1.osg33.el7
osg-configure-bosco-1.4.1-1.osg33.el7
osg-configure-ce-1.4.1-1.osg33.el7
osg-configure-cemon-1.4.1-1.osg33.el7
osg-configure-condor-1.4.1-1.osg33.el7
osg-configure-gateway-1.4.1-1.osg33.el7
osg-configure-gip-1.4.1-1.osg33.el7
osg-configure-gratia-1.4.1-1.osg33.el7
osg-configure-infoservices-1.4.1-1.osg33.el7
osg-configure-lsf-1.4.1-1.osg33.el7
osg-configure-managedfork-1.4.1-1.osg33.el7
osg-configure-misc-1.4.1-1.osg33.el7
osg-configure-monalisa-1.4.1-1.osg33.el7
osg-configure-network-1.4.1-1.osg33.el7
osg-configure-pbs-1.4.1-1.osg33.el7
osg-configure-rsv-1.4.1-1.osg33.el7
osg-configure-sge-1.4.1-1.osg33.el7
osg-configure-slurm-1.4.1-1.osg33.el7
osg-configure-squid-1.4.1-1.osg33.el7
osg-configure-tests-1.4.1-1.osg33.el7
osg-htcondor-ce-3.3-7_clipped.osg33.el7
osg-htcondor-ce-bosco-3.3-7_clipped.osg33.el7
osg-htcondor-ce-condor-3.3-7_clipped.osg33.el7
osg-htcondor-ce-lsf-3.3-7_clipped.osg33.el7
osg-htcondor-ce-pbs-3.3-7_clipped.osg33.el7
osg-htcondor-ce-sge-3.3-7_clipped.osg33.el7
osg-htcondor-ce-slurm-3.3-7_clipped.osg33.el7
osg-system-profiler-1.4.0-1.osg33.el7
osg-system-profiler-viewer-1.4.0-1.osg33.el7
osg-test-1.8.2-1.osg33.el7
osg-version-3.3.14-1.osg33.el7
osg-voms-3.3-3.osg33.el7
xrootd-voms-plugin-0.4.0-1.osg33.el7
xrootd-voms-plugin-debuginfo-0.4.0-1.osg33.el7
xrootd-voms-plugin-devel-0.4.0-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.21.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.21.bosco-1.osgup.el6)
-   [cvmfs-config-osg-1.2-5.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-5.osgup.el6)
-   [osg-oasis-7-3.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-7-3.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.21.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.21.bosco-1.osgup.el7)
-   [cvmfs-config-osg-1.2-5.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-5.osgup.el7)
-   [osg-oasis-7-3.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-7-3.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo cvmfs-config-osg osg-oasis

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.21.bosco-1.osgup.el6
blahp-debuginfo-1.18.21.bosco-1.osgup.el6
cvmfs-config-osg-1.2-5.osgup.el6
osg-oasis-7-3.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.21.bosco-1.osgup.el7
blahp-debuginfo-1.18.21.bosco-1.osgup.el7
cvmfs-config-osg-1.2-5.osgup.el7
osg-oasis-7-3.osgup.el7
```

