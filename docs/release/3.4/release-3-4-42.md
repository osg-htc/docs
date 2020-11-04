OSG Software Release 3.4.42
===========================

**Release Date**: 2020-01-16    
**Supported OS Versions:** EL7, EL6

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 and 3.4 offer a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Summary of changes
------------------

This release contains:

-   [XRootD 4.11.1](https://github.com/xrootd/xrootd/blob/v4.11.1/docs/ReleaseNotes.txt): Bug fix release
-   VOMS 2.0.14-15: Disable TLS <1.2 and insecure ciphers in VOMS server
-   [HTCondor 8.8.7](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00022.shtml): Bug fix release
-   gratia-probe 1.20.12: Fix silent failure when malformed ClassAd exists
-   osg-xrootd: Enable third party copy and macaroons by default
-   host-ce-tools 0.5-2: Ensure that sudo is installed
-   scitokens-cpp 0.4.0: Support for the WLCG token profile
-   worker-node tarball: Contains 'wget'
-   osg-ce: Minor improvements

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.42%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](/index.md).

-   OSG 3.4 contains only 64-bit components.
-   The StashCache service is only supported on EL7

### GlideinWMS ###

1. GlideinWMS 3.4.6 is the last release supporting Globus GRAM (a.k.a. GT2/GT5).

1. For new Singularity features introduced in GlideinWMS 3.4.1, all factories and frontends need to be >= 3.4.1.

    !!! note
        OSG GlideinWMS factories are running at least 3.4.1

    If some of the connected Factories are <= 3.4.1 you will see an error during reconfig/upgrade if you try to use
    features that require a newer Factory.
    To start using Singularity via GlideinWMS, see:

    - <https://glideinwms.fnal.gov/doc.prd/frontend/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/custom_vars.html#singularity_vars>

1. Upgrades from <= 3.4.0 may require merging `/etc/condor/config.d/*.rpmnew` files and restarting HTCondor.

1. GlideinWMS >= 3.4.5 uses shared port, requiring only port 9618.
   To ease the transition to shared port, the User Collector, secondary collectors, and CCBs support both shared and
   separate, individual ports.
   To start using shared port, change the secondary collectors lines and the CCBs lines (if any) in
   `/etc/gwms-frontend/frontend.xml`, changing the address to include the shared port sinful string:

        <collector DN="/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=gwms-frontend.domain" group="default" node="gwms-frontend.domain:9618?sock=collector0-40" secondary="True"/>

    Replace `gwms-frontend-domain` above with the hostname of your GlideinWMS frontend.
    See the [GlideinWMS documentation](https://glideinwms.fnal.gov/doc.prd/components/condor.html#collectors ) for details.

Known Issues
------------

OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).

Updating to the new release
---------------------------


### Update Repositories

To update to this series, you need to [install the current OSG repositories](/common/yum#install-osg-repositories).

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

Do you need help with this release? [Contact us for help](/common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.8.7-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.7-1.osg34.el6)
-   [gratia-probe-1.20.12-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.12-1.osg34.el6)
-   [osg-ce-3.4-6.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.4-6.osg34.el6)
-   [osg-tested-internal-3.4-8.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-8.osg34.el6)
-   [osg-version-3.4.42-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.42-1.osg34.el6)
-   [osg-xrootd-3.4-12.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.4-12.osg34.el6)
-   [scitokens-cpp-0.4.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.4.0-1.osg34.el6)
-   [voms-2.0.14-1.5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.5.osg34.el6)
-   [xrootd-4.11.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.1-1.osg34.el6)
-   [xrootd-lcmaps-1.7.5-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.5-1.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.8.7-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.7-1.osg34.el7)
-   [gratia-probe-1.20.12-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.12-1.osg34.el7)
-   [hosted-ce-tools-0.5-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.5-2.osg34.el7)
-   [osg-ce-3.4-6.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.4-6.osg34.el7)
-   [osg-tested-internal-3.4-8.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-8.osg34.el7)
-   [osg-version-3.4.42-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.42-1.osg34.el7)
-   [osg-xrootd-3.4-12.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.4-12.osg34.el7)
-   [scitokens-cpp-0.4.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.4.0-1.osg34.el7)
-   [voms-2.0.14-1.5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.5.osg34.el7)
-   [xrootd-4.11.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.1-1.osg34.el7)
-   [xrootd-lcmaps-1.7.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.5-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer hosted-ce-tools minicondor osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-tested-internal osg-version osg-xrootd osg-xrootd-standalone python2-condor python2-xrootd python3-condor scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.8.7-1.osg34.el6
condor-all-8.8.7-1.osg34.el6
condor-annex-ec2-8.8.7-1.osg34.el6
condor-bosco-8.8.7-1.osg34.el6
condor-classads-8.8.7-1.osg34.el6
condor-classads-devel-8.8.7-1.osg34.el6
condor-cream-gahp-8.8.7-1.osg34.el6
condor-debuginfo-8.8.7-1.osg34.el6
condor-kbdd-8.8.7-1.osg34.el6
condor-procd-8.8.7-1.osg34.el6
condor-std-universe-8.8.7-1.osg34.el6
condor-test-8.8.7-1.osg34.el6
condor-vm-gahp-8.8.7-1.osg34.el6
gratia-probe-1.20.12-1.osg34.el6
gratia-probe-common-1.20.12-1.osg34.el6
gratia-probe-condor-1.20.12-1.osg34.el6
gratia-probe-condor-events-1.20.12-1.osg34.el6
gratia-probe-dcache-storage-1.20.12-1.osg34.el6
gratia-probe-dcache-storagegroup-1.20.12-1.osg34.el6
gratia-probe-dcache-transfer-1.20.12-1.osg34.el6
gratia-probe-debuginfo-1.20.12-1.osg34.el6
gratia-probe-enstore-storage-1.20.12-1.osg34.el6
gratia-probe-enstore-tapedrive-1.20.12-1.osg34.el6
gratia-probe-enstore-transfer-1.20.12-1.osg34.el6
gratia-probe-glideinwms-1.20.12-1.osg34.el6
gratia-probe-gridftp-transfer-1.20.12-1.osg34.el6
gratia-probe-hadoop-storage-1.20.12-1.osg34.el6
gratia-probe-htcondor-ce-1.20.12-1.osg34.el6
gratia-probe-lsf-1.20.12-1.osg34.el6
gratia-probe-metric-1.20.12-1.osg34.el6
gratia-probe-onevm-1.20.12-1.osg34.el6
gratia-probe-pbs-lsf-1.20.12-1.osg34.el6
gratia-probe-services-1.20.12-1.osg34.el6
gratia-probe-sge-1.20.12-1.osg34.el6
gratia-probe-slurm-1.20.12-1.osg34.el6
gratia-probe-xrootd-storage-1.20.12-1.osg34.el6
gratia-probe-xrootd-transfer-1.20.12-1.osg34.el6
minicondor-8.8.7-1.osg34.el6
osg-ce-3.4-6.osg34.el6
osg-ce-bosco-3.4-6.osg34.el6
osg-ce-condor-3.4-6.osg34.el6
osg-ce-lsf-3.4-6.osg34.el6
osg-ce-pbs-3.4-6.osg34.el6
osg-ce-sge-3.4-6.osg34.el6
osg-ce-slurm-3.4-6.osg34.el6
osg-tested-internal-3.4-8.osg34.el6
osg-version-3.4.42-1.osg34.el6
osg-xrootd-3.4-12.osg34.el6
osg-xrootd-standalone-3.4-12.osg34.el6
python2-condor-8.8.7-1.osg34.el6
python2-xrootd-4.11.1-1.osg34.el6
scitokens-cpp-0.4.0-1.osg34.el6
scitokens-cpp-debuginfo-0.4.0-1.osg34.el6
scitokens-cpp-devel-0.4.0-1.osg34.el6
voms-2.0.14-1.5.osg34.el6
voms-clients-cpp-2.0.14-1.5.osg34.el6
voms-debuginfo-2.0.14-1.5.osg34.el6
voms-devel-2.0.14-1.5.osg34.el6
voms-doc-2.0.14-1.5.osg34.el6
voms-server-2.0.14-1.5.osg34.el6
xrootd-4.11.1-1.osg34.el6
xrootd-client-4.11.1-1.osg34.el6
xrootd-client-devel-4.11.1-1.osg34.el6
xrootd-client-libs-4.11.1-1.osg34.el6
xrootd-debuginfo-4.11.1-1.osg34.el6
xrootd-devel-4.11.1-1.osg34.el6
xrootd-doc-4.11.1-1.osg34.el6
xrootd-fuse-4.11.1-1.osg34.el6
xrootd-lcmaps-1.7.5-1.osg34.el6
xrootd-lcmaps-debuginfo-1.7.5-1.osg34.el6
xrootd-libs-4.11.1-1.osg34.el6
xrootd-private-devel-4.11.1-1.osg34.el6
xrootd-selinux-4.11.1-1.osg34.el6
xrootd-server-4.11.1-1.osg34.el6
xrootd-server-devel-4.11.1-1.osg34.el6
xrootd-server-libs-4.11.1-1.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.8.7-1.osg34.el7
condor-all-8.8.7-1.osg34.el7
condor-annex-ec2-8.8.7-1.osg34.el7
condor-bosco-8.8.7-1.osg34.el7
condor-classads-8.8.7-1.osg34.el7
condor-classads-devel-8.8.7-1.osg34.el7
condor-cream-gahp-8.8.7-1.osg34.el7
condor-debuginfo-8.8.7-1.osg34.el7
condor-kbdd-8.8.7-1.osg34.el7
condor-procd-8.8.7-1.osg34.el7
condor-test-8.8.7-1.osg34.el7
condor-vm-gahp-8.8.7-1.osg34.el7
gratia-probe-1.20.12-1.osg34.el7
gratia-probe-common-1.20.12-1.osg34.el7
gratia-probe-condor-1.20.12-1.osg34.el7
gratia-probe-condor-events-1.20.12-1.osg34.el7
gratia-probe-dcache-storage-1.20.12-1.osg34.el7
gratia-probe-dcache-storagegroup-1.20.12-1.osg34.el7
gratia-probe-dcache-transfer-1.20.12-1.osg34.el7
gratia-probe-debuginfo-1.20.12-1.osg34.el7
gratia-probe-enstore-storage-1.20.12-1.osg34.el7
gratia-probe-enstore-tapedrive-1.20.12-1.osg34.el7
gratia-probe-enstore-transfer-1.20.12-1.osg34.el7
gratia-probe-glideinwms-1.20.12-1.osg34.el7
gratia-probe-gridftp-transfer-1.20.12-1.osg34.el7
gratia-probe-hadoop-storage-1.20.12-1.osg34.el7
gratia-probe-htcondor-ce-1.20.12-1.osg34.el7
gratia-probe-lsf-1.20.12-1.osg34.el7
gratia-probe-metric-1.20.12-1.osg34.el7
gratia-probe-onevm-1.20.12-1.osg34.el7
gratia-probe-pbs-lsf-1.20.12-1.osg34.el7
gratia-probe-services-1.20.12-1.osg34.el7
gratia-probe-sge-1.20.12-1.osg34.el7
gratia-probe-slurm-1.20.12-1.osg34.el7
gratia-probe-xrootd-storage-1.20.12-1.osg34.el7
gratia-probe-xrootd-transfer-1.20.12-1.osg34.el7
hosted-ce-tools-0.5-2.osg34.el7
minicondor-8.8.7-1.osg34.el7
osg-ce-3.4-6.osg34.el7
osg-ce-bosco-3.4-6.osg34.el7
osg-ce-condor-3.4-6.osg34.el7
osg-ce-lsf-3.4-6.osg34.el7
osg-ce-pbs-3.4-6.osg34.el7
osg-ce-sge-3.4-6.osg34.el7
osg-ce-slurm-3.4-6.osg34.el7
osg-tested-internal-3.4-8.osg34.el7
osg-version-3.4.42-1.osg34.el7
osg-xrootd-3.4-12.osg34.el7
osg-xrootd-standalone-3.4-12.osg34.el7
python2-condor-8.8.7-1.osg34.el7
python2-xrootd-4.11.1-1.osg34.el7
python3-condor-8.8.7-1.osg34.el7
scitokens-cpp-0.4.0-1.osg34.el7
scitokens-cpp-debuginfo-0.4.0-1.osg34.el7
scitokens-cpp-devel-0.4.0-1.osg34.el7
voms-2.0.14-1.5.osg34.el7
voms-clients-cpp-2.0.14-1.5.osg34.el7
voms-debuginfo-2.0.14-1.5.osg34.el7
voms-devel-2.0.14-1.5.osg34.el7
voms-doc-2.0.14-1.5.osg34.el7
voms-server-2.0.14-1.5.osg34.el7
xrootd-4.11.1-1.osg34.el7
xrootd-client-4.11.1-1.osg34.el7
xrootd-client-devel-4.11.1-1.osg34.el7
xrootd-client-libs-4.11.1-1.osg34.el7
xrootd-debuginfo-4.11.1-1.osg34.el7
xrootd-devel-4.11.1-1.osg34.el7
xrootd-doc-4.11.1-1.osg34.el7
xrootd-fuse-4.11.1-1.osg34.el7
xrootd-lcmaps-1.7.5-1.osg34.el7
xrootd-lcmaps-debuginfo-1.7.5-1.osg34.el7
xrootd-libs-4.11.1-1.osg34.el7
xrootd-private-devel-4.11.1-1.osg34.el7
xrootd-selinux-4.11.1-1.osg34.el7
xrootd-server-4.11.1-1.osg34.el7
xrootd-server-devel-4.11.1-1.osg34.el7
xrootd-server-libs-4.11.1-1.osg34.el7
```
