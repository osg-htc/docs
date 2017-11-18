OSG Software Release 3.3.12
===========================

**Release Date**: 2016-05-10

Summary of changes
------------------

This release contains:

-   [VO Package v66](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-66-2) - More OSG CA migrations
-   HTCondor-CE-BOSCO: Setup a CE with only SSH access to the cluster
    -   The HTCondor-CE-Bosco is designed to make it easier to contribute opportunistic resources to the OSG. With the HTCondor-CE-Bosco, an organization can setup a CE with only SSH access to the cluster, rather than the long list of requirements for a regular HTCondor-CE.
    -   [HTCondor-CE-Bosco talk at OSG All Hands Meeting 2016](https://indico.fnal.gov/getFile.py/access?contribId=32&sessionId=7&resId=0&materialId=slides&confId=10571)
    -   [Author’s Blog post](https://djw8605.github.io/2016/04/26/2016-04-25-htcondor-ce-bosco-release/)
-   [HTCondor 8.4.6](https://lists.cs.wisc.edu/archive/htcondor-users/2016-April/msg00069.shtml): Fixes serious regression in HTCondor 8.4.5
-   [CVMFS 2.2.2](http://cvmfs.readthedocs.io/en/2.2/cpt-releasenotes.html)
    -   The update to CVMFS 2.2.1 includes a major overhaul to the default OSG configuration. Sites who have performed extensive changes to the default configuration are advised to verify their configurations before deploying.
-   OSG CE packages will no longer install GRAM components
-   BeStMan on EL7 platforms
-   [HTCondor-CE 2.0.5](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.0.5): HTCondor-CE-CEView bug fixes, support HTCondor-CE-BOSCO
-   BLAHP 1.18.19: Fix memory request for PBS, updated SLURM support
-   [Pegasus 4.6.1](https://pegasus.isi.edu/2016/04/22/pegasus-4-6-1-release/): Updated from version 4.3.1
-   osg-pki-tools 1.2.17:
    -   [Fix timeout handling, improved error messages](https://github.com/opensciencegrid/osg-pki-tools/releases/tag/1.2.16)
    -   [Another bug fix](https://github.com/opensciencegrid/osg-pki-tools/releases/tag/1.2.17)
-   osg-configure 1.4.0
    -   Added support for configuring HTCondor-CE-Bosco
    -   Fixed bug in RSV configuration where HTCondor-CE probes are sometimes not enabled
    -   Add the "slurm\_cluster" configuration option to the 20-slurm.ini configuraton file
    -   Added updating the LCMAPS configuration when changing the security mechanism in 10-misc.ini
-   [HTCondor 8.5.4](https://lists.cs.wisc.edu/archive/htcondor-users/2016-May/msg00002.shtml) in the Upcoming repository

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.12%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   `condor_ce_q` does not show any jobs when run as root with `condor-8.5.4` from upcoming. Work around this by using `condor_ce_q -allusers` instead.

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

-   [bestman2-2.3.0-29.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=bestman2-2.3.0-29.osg33.el6)
-   [blahp-1.18.19.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.19.bosco-1.osg33.el6)
-   [condor-8.4.6-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.6-1.osg33.el6)
-   [cvmfs-2.2.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.2.2-1.osg33.el6)
-   [cvmfs-config-osg-1.2-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-3.osg33.el6)
-   [globus-gram-job-manager-pbs-2.5-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-pbs-2.5-1.1.osg33.el6)
-   [gratia-probe-1.16.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.16.0-1.osg33.el6)
-   [htcondor-ce-2.0.5-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.5-1.osg33.el6)
-   [osg-build-1.6.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.6.3-1.osg33.el6)
-   [osg-ce-3.3-6.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ce-3.3-6.osg33.el6)
-   [osg-configure-1.4.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.4.0-1.osg33.el6)
-   [osg-info-services-1.2.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-info-services-1.2.1-1.osg33.el6)
-   [osg-oasis-6-4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-6-4.osg33.el6)
-   [osg-pki-tools-1.2.17-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.17-1.osg33.el6)
-   [osg-se-bestman-3.3-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-se-bestman-3.3-3.osg33.el6)
-   [osg-se-bestman-xrootd-3.3-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-se-bestman-xrootd-3.3-3.osg33.el6)
-   [osg-system-profiler-1.3.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-system-profiler-1.3.0-1.osg33.el6)
-   [osg-test-1.7.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.7.0-1.osg33.el6)
-   [osg-tested-internal-3.3-11.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-11.osg33.el6)
-   [osg-version-3.3.12-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.12-1.osg33.el6)
-   [pegasus-4.6.1-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=pegasus-4.6.1-1.1.osg33.el6)
-   [privilege-xacml-2.6.5-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=privilege-xacml-2.6.5-2.osg33.el6)
-   [vo-client-66-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-66-1.osg33.el6)

#### Enterprise Linux 7

-   [bestman2-2.3.0-29.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=bestman2-2.3.0-29.osg33.el7)
-   [blahp-1.18.19.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.19.bosco-1.osg33.el7)
-   [condor-8.4.6-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.6-1.osg33.el7)
-   [cvmfs-2.2.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-2.2.2-1.osg33.el7)
-   [cvmfs-config-osg-1.2-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=cvmfs-config-osg-1.2-3.osg33.el7)
-   [globus-gram-job-manager-pbs-2.5-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-pbs-2.5-1.1.osg33.el7)
-   [gratia-probe-1.16.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.16.0-1.osg33.el7)
-   [htcondor-ce-2.0.5-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.5-1.osg33.el7)
-   [osg-build-1.6.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.6.3-1.osg33.el7)
-   [osg-ce-3.3-6\_clipped.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ce-3.3-6_clipped.osg33.el7)
-   [osg-configure-1.4.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.4.0-1.osg33.el7)
-   [osg-info-services-1.2.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-info-services-1.2.1-1.osg33.el7)
-   [osg-oasis-6-4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-oasis-6-4.osg33.el7)
-   [osg-pki-tools-1.2.17-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.17-1.osg33.el7)
-   [osg-se-bestman-3.3-3\_clipped.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-se-bestman-3.3-3_clipped.osg33.el7)
-   [osg-se-bestman-xrootd-3.3-3\_clipped.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-se-bestman-xrootd-3.3-3_clipped.osg33.el7)
-   [osg-system-profiler-1.3.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-system-profiler-1.3.0-1.osg33.el7)
-   [osg-test-1.7.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.7.0-1.osg33.el7)
-   [osg-tested-internal-3.3-11.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-11.osg33.el7)
-   [osg-version-3.3.12-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.12-1.osg33.el7)
-   [pegasus-4.6.1-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=pegasus-4.6.1-1.1.osg33.el7)
-   [privilege-xacml-2.6.5-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=privilege-xacml-2.6.5-2.osg33.el7)
-   [vo-client-66-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-66-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    bestman2-client bestman2-client-libs bestman2-common-libs bestman2-server bestman2-server-dep-libs bestman2-server-libs bestman2-tester bestman2-tester-libs blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-config-osg cvmfs-devel cvmfs-server cvmfs-unittests globus-gram-job-manager-pbs globus-gram-job-manager-pbs-debuginfo globus-gram-job-manager-pbs-setup-poll globus-gram-job-manager-pbs-setup-seg gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view osg-base-ce osg-base-ce-bosco osg-base-ce-condor osg-base-ce-lsf osg-base-ce-pbs osg-base-ce-sge osg-base-ce-slurm osg-build osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gums-config osg-htcondor-ce osg-htcondor-ce-bosco osg-htcondor-ce-condor osg-htcondor-ce-lsf osg-htcondor-ce-pbs osg-htcondor-ce-sge osg-htcondor-ce-slurm osg-info-services osg-oasis osg-pki-tools osg-pki-tools-tests osg-se-bestman osg-se-bestman-xrootd osg-system-profiler osg-system-profiler-viewer osg-test osg-tested-internal osg-version pegasus pegasus-debuginfo privilege-xacml vo-client vo-client-edgmkgridmap

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
bestman2-2.3.0-29.osg33.el6
bestman2-client-2.3.0-29.osg33.el6
bestman2-client-libs-2.3.0-29.osg33.el6
bestman2-common-libs-2.3.0-29.osg33.el6
bestman2-server-2.3.0-29.osg33.el6
bestman2-server-dep-libs-2.3.0-29.osg33.el6
bestman2-server-libs-2.3.0-29.osg33.el6
bestman2-tester-2.3.0-29.osg33.el6
bestman2-tester-libs-2.3.0-29.osg33.el6
blahp-1.18.19.bosco-1.osg33.el6
blahp-debuginfo-1.18.19.bosco-1.osg33.el6
condor-8.4.6-1.osg33.el6
condor-all-8.4.6-1.osg33.el6
condor-bosco-8.4.6-1.osg33.el6
condor-classads-8.4.6-1.osg33.el6
condor-classads-devel-8.4.6-1.osg33.el6
condor-cream-gahp-8.4.6-1.osg33.el6
condor-debuginfo-8.4.6-1.osg33.el6
condor-kbdd-8.4.6-1.osg33.el6
condor-procd-8.4.6-1.osg33.el6
condor-python-8.4.6-1.osg33.el6
condor-std-universe-8.4.6-1.osg33.el6
condor-test-8.4.6-1.osg33.el6
condor-vm-gahp-8.4.6-1.osg33.el6
cvmfs-2.2.2-1.osg33.el6
cvmfs-config-osg-1.2-3.osg33.el6
cvmfs-devel-2.2.2-1.osg33.el6
cvmfs-server-2.2.2-1.osg33.el6
cvmfs-unittests-2.2.2-1.osg33.el6
globus-gram-job-manager-pbs-2.5-1.1.osg33.el6
globus-gram-job-manager-pbs-debuginfo-2.5-1.1.osg33.el6
globus-gram-job-manager-pbs-setup-poll-2.5-1.1.osg33.el6
globus-gram-job-manager-pbs-setup-seg-2.5-1.1.osg33.el6
gratia-probe-1.16.0-1.osg33.el6
gratia-probe-bdii-status-1.16.0-1.osg33.el6
gratia-probe-common-1.16.0-1.osg33.el6
gratia-probe-condor-1.16.0-1.osg33.el6
gratia-probe-condor-events-1.16.0-1.osg33.el6
gratia-probe-dcache-storage-1.16.0-1.osg33.el6
gratia-probe-dcache-storagegroup-1.16.0-1.osg33.el6
gratia-probe-dcache-transfer-1.16.0-1.osg33.el6
gratia-probe-debuginfo-1.16.0-1.osg33.el6
gratia-probe-enstore-storage-1.16.0-1.osg33.el6
gratia-probe-enstore-tapedrive-1.16.0-1.osg33.el6
gratia-probe-enstore-transfer-1.16.0-1.osg33.el6
gratia-probe-glexec-1.16.0-1.osg33.el6
gratia-probe-glideinwms-1.16.0-1.osg33.el6
gratia-probe-gram-1.16.0-1.osg33.el6
gratia-probe-gridftp-transfer-1.16.0-1.osg33.el6
gratia-probe-hadoop-storage-1.16.0-1.osg33.el6
gratia-probe-htcondor-ce-1.16.0-1.osg33.el6
gratia-probe-lsf-1.16.0-1.osg33.el6
gratia-probe-metric-1.16.0-1.osg33.el6
gratia-probe-onevm-1.16.0-1.osg33.el6
gratia-probe-pbs-lsf-1.16.0-1.osg33.el6
gratia-probe-services-1.16.0-1.osg33.el6
gratia-probe-sge-1.16.0-1.osg33.el6
gratia-probe-slurm-1.16.0-1.osg33.el6
gratia-probe-xrootd-storage-1.16.0-1.osg33.el6
gratia-probe-xrootd-transfer-1.16.0-1.osg33.el6
htcondor-ce-2.0.5-1.osg33.el6
htcondor-ce-client-2.0.5-1.osg33.el6
htcondor-ce-collector-2.0.5-1.osg33.el6
htcondor-ce-condor-2.0.5-1.osg33.el6
htcondor-ce-lsf-2.0.5-1.osg33.el6
htcondor-ce-pbs-2.0.5-1.osg33.el6
htcondor-ce-sge-2.0.5-1.osg33.el6
htcondor-ce-view-2.0.5-1.osg33.el6
osg-base-ce-3.3-6.osg33.el6
osg-base-ce-bosco-3.3-6.osg33.el6
osg-base-ce-condor-3.3-6.osg33.el6
osg-base-ce-lsf-3.3-6.osg33.el6
osg-base-ce-pbs-3.3-6.osg33.el6
osg-base-ce-sge-3.3-6.osg33.el6
osg-base-ce-slurm-3.3-6.osg33.el6
osg-build-1.6.3-1.osg33.el6
osg-ce-3.3-6.osg33.el6
osg-ce-bosco-3.3-6.osg33.el6
osg-ce-condor-3.3-6.osg33.el6
osg-ce-lsf-3.3-6.osg33.el6
osg-ce-pbs-3.3-6.osg33.el6
osg-ce-sge-3.3-6.osg33.el6
osg-ce-slurm-3.3-6.osg33.el6
osg-configure-1.4.0-1.osg33.el6
osg-configure-bosco-1.4.0-1.osg33.el6
osg-configure-ce-1.4.0-1.osg33.el6
osg-configure-cemon-1.4.0-1.osg33.el6
osg-configure-condor-1.4.0-1.osg33.el6
osg-configure-gateway-1.4.0-1.osg33.el6
osg-configure-gip-1.4.0-1.osg33.el6
osg-configure-gratia-1.4.0-1.osg33.el6
osg-configure-infoservices-1.4.0-1.osg33.el6
osg-configure-lsf-1.4.0-1.osg33.el6
osg-configure-managedfork-1.4.0-1.osg33.el6
osg-configure-misc-1.4.0-1.osg33.el6
osg-configure-monalisa-1.4.0-1.osg33.el6
osg-configure-network-1.4.0-1.osg33.el6
osg-configure-pbs-1.4.0-1.osg33.el6
osg-configure-rsv-1.4.0-1.osg33.el6
osg-configure-sge-1.4.0-1.osg33.el6
osg-configure-slurm-1.4.0-1.osg33.el6
osg-configure-squid-1.4.0-1.osg33.el6
osg-configure-tests-1.4.0-1.osg33.el6
osg-gums-config-66-1.osg33.el6
osg-htcondor-ce-3.3-6.osg33.el6
osg-htcondor-ce-bosco-3.3-6.osg33.el6
osg-htcondor-ce-condor-3.3-6.osg33.el6
osg-htcondor-ce-lsf-3.3-6.osg33.el6
osg-htcondor-ce-pbs-3.3-6.osg33.el6
osg-htcondor-ce-sge-3.3-6.osg33.el6
osg-htcondor-ce-slurm-3.3-6.osg33.el6
osg-info-services-1.2.1-1.osg33.el6
osg-oasis-6-4.osg33.el6
osg-pki-tools-1.2.17-1.osg33.el6
osg-pki-tools-tests-1.2.17-1.osg33.el6
osg-se-bestman-3.3-3.osg33.el6
osg-se-bestman-xrootd-3.3-3.osg33.el6
osg-system-profiler-1.3.0-1.osg33.el6
osg-system-profiler-viewer-1.3.0-1.osg33.el6
osg-test-1.7.0-1.osg33.el6
osg-tested-internal-3.3-11.osg33.el6
osg-version-3.3.12-1.osg33.el6
pegasus-4.6.1-1.1.osg33.el6
pegasus-debuginfo-4.6.1-1.1.osg33.el6
privilege-xacml-2.6.5-2.osg33.el6
vo-client-66-1.osg33.el6
vo-client-edgmkgridmap-66-1.osg33.el6
```

#### Enterprise Linux 7

``` file
bestman2-2.3.0-29.osg33.el7
bestman2-client-2.3.0-29.osg33.el7
bestman2-client-libs-2.3.0-29.osg33.el7
bestman2-common-libs-2.3.0-29.osg33.el7
bestman2-server-2.3.0-29.osg33.el7
bestman2-server-dep-libs-2.3.0-29.osg33.el7
bestman2-server-libs-2.3.0-29.osg33.el7
bestman2-tester-2.3.0-29.osg33.el7
bestman2-tester-libs-2.3.0-29.osg33.el7
blahp-1.18.19.bosco-1.osg33.el7
blahp-debuginfo-1.18.19.bosco-1.osg33.el7
condor-8.4.6-1.osg33.el7
condor-all-8.4.6-1.osg33.el7
condor-bosco-8.4.6-1.osg33.el7
condor-classads-8.4.6-1.osg33.el7
condor-classads-devel-8.4.6-1.osg33.el7
condor-debuginfo-8.4.6-1.osg33.el7
condor-kbdd-8.4.6-1.osg33.el7
condor-procd-8.4.6-1.osg33.el7
condor-python-8.4.6-1.osg33.el7
condor-test-8.4.6-1.osg33.el7
condor-vm-gahp-8.4.6-1.osg33.el7
cvmfs-2.2.2-1.osg33.el7
cvmfs-config-osg-1.2-3.osg33.el7
cvmfs-devel-2.2.2-1.osg33.el7
cvmfs-server-2.2.2-1.osg33.el7
cvmfs-unittests-2.2.2-1.osg33.el7
globus-gram-job-manager-pbs-2.5-1.1.osg33.el7
globus-gram-job-manager-pbs-debuginfo-2.5-1.1.osg33.el7
globus-gram-job-manager-pbs-setup-poll-2.5-1.1.osg33.el7
globus-gram-job-manager-pbs-setup-seg-2.5-1.1.osg33.el7
gratia-probe-1.16.0-1.osg33.el7
gratia-probe-bdii-status-1.16.0-1.osg33.el7
gratia-probe-common-1.16.0-1.osg33.el7
gratia-probe-condor-1.16.0-1.osg33.el7
gratia-probe-condor-events-1.16.0-1.osg33.el7
gratia-probe-dcache-storage-1.16.0-1.osg33.el7
gratia-probe-dcache-storagegroup-1.16.0-1.osg33.el7
gratia-probe-dcache-transfer-1.16.0-1.osg33.el7
gratia-probe-debuginfo-1.16.0-1.osg33.el7
gratia-probe-enstore-storage-1.16.0-1.osg33.el7
gratia-probe-enstore-tapedrive-1.16.0-1.osg33.el7
gratia-probe-enstore-transfer-1.16.0-1.osg33.el7
gratia-probe-glexec-1.16.0-1.osg33.el7
gratia-probe-glideinwms-1.16.0-1.osg33.el7
gratia-probe-gram-1.16.0-1.osg33.el7
gratia-probe-gridftp-transfer-1.16.0-1.osg33.el7
gratia-probe-hadoop-storage-1.16.0-1.osg33.el7
gratia-probe-htcondor-ce-1.16.0-1.osg33.el7
gratia-probe-lsf-1.16.0-1.osg33.el7
gratia-probe-metric-1.16.0-1.osg33.el7
gratia-probe-onevm-1.16.0-1.osg33.el7
gratia-probe-pbs-lsf-1.16.0-1.osg33.el7
gratia-probe-services-1.16.0-1.osg33.el7
gratia-probe-sge-1.16.0-1.osg33.el7
gratia-probe-slurm-1.16.0-1.osg33.el7
gratia-probe-xrootd-storage-1.16.0-1.osg33.el7
gratia-probe-xrootd-transfer-1.16.0-1.osg33.el7
htcondor-ce-2.0.5-1.osg33.el7
htcondor-ce-client-2.0.5-1.osg33.el7
htcondor-ce-collector-2.0.5-1.osg33.el7
htcondor-ce-condor-2.0.5-1.osg33.el7
htcondor-ce-lsf-2.0.5-1.osg33.el7
htcondor-ce-pbs-2.0.5-1.osg33.el7
htcondor-ce-sge-2.0.5-1.osg33.el7
htcondor-ce-view-2.0.5-1.osg33.el7
osg-base-ce-3.3-6_clipped.osg33.el7
osg-base-ce-bosco-3.3-6_clipped.osg33.el7
osg-base-ce-condor-3.3-6_clipped.osg33.el7
osg-base-ce-lsf-3.3-6_clipped.osg33.el7
osg-base-ce-pbs-3.3-6_clipped.osg33.el7
osg-base-ce-sge-3.3-6_clipped.osg33.el7
osg-base-ce-slurm-3.3-6_clipped.osg33.el7
osg-build-1.6.3-1.osg33.el7
osg-ce-3.3-6_clipped.osg33.el7
osg-ce-bosco-3.3-6_clipped.osg33.el7
osg-ce-condor-3.3-6_clipped.osg33.el7
osg-ce-lsf-3.3-6_clipped.osg33.el7
osg-ce-pbs-3.3-6_clipped.osg33.el7
osg-ce-sge-3.3-6_clipped.osg33.el7
osg-ce-slurm-3.3-6_clipped.osg33.el7
osg-configure-1.4.0-1.osg33.el7
osg-configure-bosco-1.4.0-1.osg33.el7
osg-configure-ce-1.4.0-1.osg33.el7
osg-configure-cemon-1.4.0-1.osg33.el7
osg-configure-condor-1.4.0-1.osg33.el7
osg-configure-gateway-1.4.0-1.osg33.el7
osg-configure-gip-1.4.0-1.osg33.el7
osg-configure-gratia-1.4.0-1.osg33.el7
osg-configure-infoservices-1.4.0-1.osg33.el7
osg-configure-lsf-1.4.0-1.osg33.el7
osg-configure-managedfork-1.4.0-1.osg33.el7
osg-configure-misc-1.4.0-1.osg33.el7
osg-configure-monalisa-1.4.0-1.osg33.el7
osg-configure-network-1.4.0-1.osg33.el7
osg-configure-pbs-1.4.0-1.osg33.el7
osg-configure-rsv-1.4.0-1.osg33.el7
osg-configure-sge-1.4.0-1.osg33.el7
osg-configure-slurm-1.4.0-1.osg33.el7
osg-configure-squid-1.4.0-1.osg33.el7
osg-configure-tests-1.4.0-1.osg33.el7
osg-gums-config-66-1.osg33.el7
osg-htcondor-ce-3.3-6_clipped.osg33.el7
osg-htcondor-ce-bosco-3.3-6_clipped.osg33.el7
osg-htcondor-ce-condor-3.3-6_clipped.osg33.el7
osg-htcondor-ce-lsf-3.3-6_clipped.osg33.el7
osg-htcondor-ce-pbs-3.3-6_clipped.osg33.el7
osg-htcondor-ce-sge-3.3-6_clipped.osg33.el7
osg-htcondor-ce-slurm-3.3-6_clipped.osg33.el7
osg-info-services-1.2.1-1.osg33.el7
osg-oasis-6-4.osg33.el7
osg-pki-tools-1.2.17-1.osg33.el7
osg-pki-tools-tests-1.2.17-1.osg33.el7
osg-se-bestman-3.3-3_clipped.osg33.el7
osg-se-bestman-xrootd-3.3-3_clipped.osg33.el7
osg-system-profiler-1.3.0-1.osg33.el7
osg-system-profiler-viewer-1.3.0-1.osg33.el7
osg-test-1.7.0-1.osg33.el7
osg-tested-internal-3.3-11.osg33.el7
osg-version-3.3.12-1.osg33.el7
pegasus-4.6.1-1.1.osg33.el7
pegasus-debuginfo-4.6.1-1.1.osg33.el7
privilege-xacml-2.6.5-2.osg33.el7
vo-client-66-1.osg33.el7
vo-client-edgmkgridmap-66-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.19.bosco-2.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.19.bosco-2.osgup.el6)
-   [condor-8.5.4-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.4-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.19.bosco-2.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.19.bosco-2.osgup.el7)
-   [condor-8.5.4-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.4-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.19.bosco-2.osgup.el6
blahp-debuginfo-1.18.19.bosco-2.osgup.el6
condor-8.5.4-1.osgup.el6
condor-all-8.5.4-1.osgup.el6
condor-bosco-8.5.4-1.osgup.el6
condor-classads-8.5.4-1.osgup.el6
condor-classads-devel-8.5.4-1.osgup.el6
condor-cream-gahp-8.5.4-1.osgup.el6
condor-debuginfo-8.5.4-1.osgup.el6
condor-kbdd-8.5.4-1.osgup.el6
condor-procd-8.5.4-1.osgup.el6
condor-python-8.5.4-1.osgup.el6
condor-std-universe-8.5.4-1.osgup.el6
condor-test-8.5.4-1.osgup.el6
condor-vm-gahp-8.5.4-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.19.bosco-2.osgup.el7
blahp-debuginfo-1.18.19.bosco-2.osgup.el7
condor-8.5.4-1.osgup.el7
condor-all-8.5.4-1.osgup.el7
condor-bosco-8.5.4-1.osgup.el7
condor-classads-8.5.4-1.osgup.el7
condor-classads-devel-8.5.4-1.osgup.el7
condor-debuginfo-8.5.4-1.osgup.el7
condor-kbdd-8.5.4-1.osgup.el7
condor-procd-8.5.4-1.osgup.el7
condor-python-8.5.4-1.osgup.el7
condor-test-8.5.4-1.osgup.el7
condor-vm-gahp-8.5.4-1.osgup.el7
```

