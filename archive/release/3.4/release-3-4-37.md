OSG Software Release 3.4.37
===========================

**Release Date**: 2019-10-17
**Supported OS Versions:** EL7, EL6

Summary of changes
------------------

This release contains:

-   [GlideinWMS 3.6](https://glideinwms.fnal.gov/doc.v3_6/history.html): New stable version
    -   [Manual adjustments required](https://glideinwms.fnal.gov/doc.dev/factory/configuration.html#single_user) when updating a GlideinWMS factory
    -   Compatible with HTCondor 8.6.x, 8.8.x, and 8.9.x
-   [oidc-agent 3.2.6](https://github.com/indigo-dc/oidc-agent/releases/tag/v3.2.6): Tools for managing OpenID Connect tokens (EL7 Only)
-   [scitokens-cpp 0.3.4](https://github.com/scitokens/scitokens-cpp/pull/14): Add support for Identity and Access Management (IAM)
-   [XRootD 4.10.1](https://github.com/xrootd/xrootd/blob/bced78a4a3f4a1ea34ffd8684cec1d99107b588a/docs/ReleaseNotes.txt): Make third party client check bogus-response proof
-   [HTCondor 8.8.5](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00017.shtml)
    -   Major upgrade from version 8.6.13
        -   [OSG Upgrade Instructions](https://opensciencegrid.org/docs/release/release_series/#updating-to-htcondor-88x_1)
        -   [HTCondor Upgrade Release Notes](https://htcondor.readthedocs.io/en/stable/version-history/upgrading-from-86-to-88-series.html)
    -   `bosco_cluster` pulls tarball via HTTPS
    -   Added support for customizations to remote BOSCO installations
-   [osg-configure 2.5.0](https://github.com/opensciencegrid/osg-configure/releases/tag/v2.5.0): Add support for `bosco_cluster` override directories
-   gratia-probe 1.20.11: Updates to work better with Slurm

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.37%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

-   OSG 3.4 contains only 64-bit components.
-   StashCache is only supported on EL7

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

1. Upgrades from <= 3.4.0 may require merging `/etc/condor/config.d/*.rpmnew` files and a restart of HTCondor.

1. GlideinWMS >= 3.4.5 uses shared port, requiring only port 9618.
   To ease the transition to shared port, the User Collector secondary collectors and CCBs support both shared and
   separate, individual ports.
   To start using shared port, change the secondary collectors lines and the CCBs lines (if any) in
   `/etc/gwms-frontend/frontend.xml`, changing the address to include the shared port sinful string:

        <collector DN="/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=gwms-frontend.domain" group="default" node="gwms-frontend.domain:9618?sock=collector0-40" secondary="True"/>

    Replacing `gwms-frontend-domain` with the hostname of your GlideinWMS frontend.
    See the [GlideinWMS documentation](https://glideinwms.fnal.gov/doc.prd/components/condor.html#collectors ) for details.

Known Issues
------------

OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).

Updating to the new release
---------------------------


### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-the-osg-repositories).

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

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.41.bosco-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.41.bosco-2.osg34.el6)
-   [condor-8.8.5-1.4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.5-1.4.osg34.el6)
-   [glideinwms-3.6-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6-2.osg34.el6)
-   [glite-ce-cream-client-api-c-1.15.4-2.5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.5.osg34.el6)
-   [gratia-probe-1.20.11-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.11-1.osg34.el6)
-   [koji-1.11.1-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.11.1-1.2.osg34.el6)
-   [osg-build-1.15.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.15.1-1.osg34.el6)
-   [osg-configure-2.5.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.5.0-1.osg34.el6)
-   [osg-version-3.4.37-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.37-1.osg34.el6)
-   [scitokens-cpp-0.3.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.3.4-1.osg34.el6)
-   [xrootd-4.10.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.10.1-1.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.41.bosco-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.41.bosco-2.osg34.el7)
-   [condor-8.8.5-1.4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.5-1.4.osg34.el7)
-   [glideinwms-3.6-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6-2.osg34.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.5.osg34.el7)
-   [gratia-probe-1.20.11-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.11-1.osg34.el7)
-   [koji-1.11.1-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.11.1-1.2.osg34.el7)
-   [oidc-agent-3.2.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=oidc-agent-3.2.6-1.osg34.el7)
-   [osg-build-1.15.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.15.1-1.osg34.el7)
-   [osg-configure-2.5.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.5.0-1.osg34.el7)
-   [osg-version-3.4.37-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.37-1.osg34.el7)
-   [scitokens-cpp-0.3.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.3.4-1.osg34.el7)
-   [xrootd-4.10.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.10.1-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone glite-ce-cream-client-api-c glite-ce-cream-client-devel gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer koji koji-builder koji-hub koji-hub-plugins koji-utils koji-vm koji-web minicondor oidc-agent oidc-agent-debuginfo osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-version python2-condor python2-xrootd python3-condor scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.41.bosco-2.osg34.el6
blahp-debuginfo-1.18.41.bosco-2.osg34.el6
condor-8.8.5-1.4.osg34.el6
condor-all-8.8.5-1.4.osg34.el6
condor-annex-ec2-8.8.5-1.4.osg34.el6
condor-bosco-8.8.5-1.4.osg34.el6
condor-classads-8.8.5-1.4.osg34.el6
condor-classads-devel-8.8.5-1.4.osg34.el6
condor-cream-gahp-8.8.5-1.4.osg34.el6
condor-debuginfo-8.8.5-1.4.osg34.el6
condor-kbdd-8.8.5-1.4.osg34.el6
condor-procd-8.8.5-1.4.osg34.el6
condor-std-universe-8.8.5-1.4.osg34.el6
condor-test-8.8.5-1.4.osg34.el6
condor-vm-gahp-8.8.5-1.4.osg34.el6
glideinwms-3.6-2.osg34.el6
glideinwms-common-tools-3.6-2.osg34.el6
glideinwms-condor-common-config-3.6-2.osg34.el6
glideinwms-factory-3.6-2.osg34.el6
glideinwms-factory-condor-3.6-2.osg34.el6
glideinwms-glidecondor-tools-3.6-2.osg34.el6
glideinwms-libs-3.6-2.osg34.el6
glideinwms-minimal-condor-3.6-2.osg34.el6
glideinwms-usercollector-3.6-2.osg34.el6
glideinwms-userschedd-3.6-2.osg34.el6
glideinwms-vofrontend-3.6-2.osg34.el6
glideinwms-vofrontend-standalone-3.6-2.osg34.el6
glite-ce-cream-client-api-c-1.15.4-2.5.osg34.el6
glite-ce-cream-client-devel-1.15.4-2.5.osg34.el6
gratia-probe-1.20.11-1.osg34.el6
gratia-probe-common-1.20.11-1.osg34.el6
gratia-probe-condor-1.20.11-1.osg34.el6
gratia-probe-condor-events-1.20.11-1.osg34.el6
gratia-probe-dcache-storage-1.20.11-1.osg34.el6
gratia-probe-dcache-storagegroup-1.20.11-1.osg34.el6
gratia-probe-dcache-transfer-1.20.11-1.osg34.el6
gratia-probe-debuginfo-1.20.11-1.osg34.el6
gratia-probe-enstore-storage-1.20.11-1.osg34.el6
gratia-probe-enstore-tapedrive-1.20.11-1.osg34.el6
gratia-probe-enstore-transfer-1.20.11-1.osg34.el6
gratia-probe-glideinwms-1.20.11-1.osg34.el6
gratia-probe-gridftp-transfer-1.20.11-1.osg34.el6
gratia-probe-hadoop-storage-1.20.11-1.osg34.el6
gratia-probe-htcondor-ce-1.20.11-1.osg34.el6
gratia-probe-lsf-1.20.11-1.osg34.el6
gratia-probe-metric-1.20.11-1.osg34.el6
gratia-probe-onevm-1.20.11-1.osg34.el6
gratia-probe-pbs-lsf-1.20.11-1.osg34.el6
gratia-probe-services-1.20.11-1.osg34.el6
gratia-probe-sge-1.20.11-1.osg34.el6
gratia-probe-slurm-1.20.11-1.osg34.el6
gratia-probe-xrootd-storage-1.20.11-1.osg34.el6
gratia-probe-xrootd-transfer-1.20.11-1.osg34.el6
koji-1.11.1-1.2.osg34.el6
koji-builder-1.11.1-1.2.osg34.el6
koji-hub-1.11.1-1.2.osg34.el6
koji-hub-plugins-1.11.1-1.2.osg34.el6
koji-utils-1.11.1-1.2.osg34.el6
koji-vm-1.11.1-1.2.osg34.el6
koji-web-1.11.1-1.2.osg34.el6
minicondor-8.8.5-1.4.osg34.el6
osg-build-1.15.1-1.osg34.el6
osg-build-base-1.15.1-1.osg34.el6
osg-build-koji-1.15.1-1.osg34.el6
osg-build-mock-1.15.1-1.osg34.el6
osg-build-tests-1.15.1-1.osg34.el6
osg-configure-2.5.0-1.osg34.el6
osg-configure-bosco-2.5.0-1.osg34.el6
osg-configure-ce-2.5.0-1.osg34.el6
osg-configure-condor-2.5.0-1.osg34.el6
osg-configure-gateway-2.5.0-1.osg34.el6
osg-configure-gip-2.5.0-1.osg34.el6
osg-configure-gratia-2.5.0-1.osg34.el6
osg-configure-infoservices-2.5.0-1.osg34.el6
osg-configure-lsf-2.5.0-1.osg34.el6
osg-configure-misc-2.5.0-1.osg34.el6
osg-configure-pbs-2.5.0-1.osg34.el6
osg-configure-rsv-2.5.0-1.osg34.el6
osg-configure-sge-2.5.0-1.osg34.el6
osg-configure-siteinfo-2.5.0-1.osg34.el6
osg-configure-slurm-2.5.0-1.osg34.el6
osg-configure-squid-2.5.0-1.osg34.el6
osg-configure-tests-2.5.0-1.osg34.el6
osg-version-3.4.37-1.osg34.el6
python2-condor-8.8.5-1.4.osg34.el6
python2-xrootd-4.10.1-1.osg34.el6
scitokens-cpp-0.3.4-1.osg34.el6
scitokens-cpp-debuginfo-0.3.4-1.osg34.el6
scitokens-cpp-devel-0.3.4-1.osg34.el6
xrootd-4.10.1-1.osg34.el6
xrootd-client-4.10.1-1.osg34.el6
xrootd-client-devel-4.10.1-1.osg34.el6
xrootd-client-libs-4.10.1-1.osg34.el6
xrootd-debuginfo-4.10.1-1.osg34.el6
xrootd-devel-4.10.1-1.osg34.el6
xrootd-doc-4.10.1-1.osg34.el6
xrootd-fuse-4.10.1-1.osg34.el6
xrootd-libs-4.10.1-1.osg34.el6
xrootd-private-devel-4.10.1-1.osg34.el6
xrootd-selinux-4.10.1-1.osg34.el6
xrootd-server-4.10.1-1.osg34.el6
xrootd-server-devel-4.10.1-1.osg34.el6
xrootd-server-libs-4.10.1-1.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.41.bosco-2.osg34.el7
blahp-debuginfo-1.18.41.bosco-2.osg34.el7
condor-8.8.5-1.4.osg34.el7
condor-all-8.8.5-1.4.osg34.el7
condor-annex-ec2-8.8.5-1.4.osg34.el7
condor-bosco-8.8.5-1.4.osg34.el7
condor-classads-8.8.5-1.4.osg34.el7
condor-classads-devel-8.8.5-1.4.osg34.el7
condor-cream-gahp-8.8.5-1.4.osg34.el7
condor-debuginfo-8.8.5-1.4.osg34.el7
condor-kbdd-8.8.5-1.4.osg34.el7
condor-procd-8.8.5-1.4.osg34.el7
condor-test-8.8.5-1.4.osg34.el7
condor-vm-gahp-8.8.5-1.4.osg34.el7
glideinwms-3.6-2.osg34.el7
glideinwms-common-tools-3.6-2.osg34.el7
glideinwms-condor-common-config-3.6-2.osg34.el7
glideinwms-factory-3.6-2.osg34.el7
glideinwms-factory-condor-3.6-2.osg34.el7
glideinwms-glidecondor-tools-3.6-2.osg34.el7
glideinwms-libs-3.6-2.osg34.el7
glideinwms-minimal-condor-3.6-2.osg34.el7
glideinwms-usercollector-3.6-2.osg34.el7
glideinwms-userschedd-3.6-2.osg34.el7
glideinwms-vofrontend-3.6-2.osg34.el7
glideinwms-vofrontend-standalone-3.6-2.osg34.el7
glite-ce-cream-client-api-c-1.15.4-2.5.osg34.el7
glite-ce-cream-client-devel-1.15.4-2.5.osg34.el7
gratia-probe-1.20.11-1.osg34.el7
gratia-probe-common-1.20.11-1.osg34.el7
gratia-probe-condor-1.20.11-1.osg34.el7
gratia-probe-condor-events-1.20.11-1.osg34.el7
gratia-probe-dcache-storage-1.20.11-1.osg34.el7
gratia-probe-dcache-storagegroup-1.20.11-1.osg34.el7
gratia-probe-dcache-transfer-1.20.11-1.osg34.el7
gratia-probe-debuginfo-1.20.11-1.osg34.el7
gratia-probe-enstore-storage-1.20.11-1.osg34.el7
gratia-probe-enstore-tapedrive-1.20.11-1.osg34.el7
gratia-probe-enstore-transfer-1.20.11-1.osg34.el7
gratia-probe-glideinwms-1.20.11-1.osg34.el7
gratia-probe-gridftp-transfer-1.20.11-1.osg34.el7
gratia-probe-hadoop-storage-1.20.11-1.osg34.el7
gratia-probe-htcondor-ce-1.20.11-1.osg34.el7
gratia-probe-lsf-1.20.11-1.osg34.el7
gratia-probe-metric-1.20.11-1.osg34.el7
gratia-probe-onevm-1.20.11-1.osg34.el7
gratia-probe-pbs-lsf-1.20.11-1.osg34.el7
gratia-probe-services-1.20.11-1.osg34.el7
gratia-probe-sge-1.20.11-1.osg34.el7
gratia-probe-slurm-1.20.11-1.osg34.el7
gratia-probe-xrootd-storage-1.20.11-1.osg34.el7
gratia-probe-xrootd-transfer-1.20.11-1.osg34.el7
koji-1.11.1-1.2.osg34.el7
koji-builder-1.11.1-1.2.osg34.el7
koji-hub-1.11.1-1.2.osg34.el7
koji-hub-plugins-1.11.1-1.2.osg34.el7
koji-utils-1.11.1-1.2.osg34.el7
koji-vm-1.11.1-1.2.osg34.el7
koji-web-1.11.1-1.2.osg34.el7
minicondor-8.8.5-1.4.osg34.el7
oidc-agent-3.2.6-1.osg34.el7
oidc-agent-debuginfo-3.2.6-1.osg34.el7
osg-build-1.15.1-1.osg34.el7
osg-build-base-1.15.1-1.osg34.el7
osg-build-koji-1.15.1-1.osg34.el7
osg-build-mock-1.15.1-1.osg34.el7
osg-build-tests-1.15.1-1.osg34.el7
osg-configure-2.5.0-1.osg34.el7
osg-configure-bosco-2.5.0-1.osg34.el7
osg-configure-ce-2.5.0-1.osg34.el7
osg-configure-condor-2.5.0-1.osg34.el7
osg-configure-gateway-2.5.0-1.osg34.el7
osg-configure-gip-2.5.0-1.osg34.el7
osg-configure-gratia-2.5.0-1.osg34.el7
osg-configure-infoservices-2.5.0-1.osg34.el7
osg-configure-lsf-2.5.0-1.osg34.el7
osg-configure-misc-2.5.0-1.osg34.el7
osg-configure-pbs-2.5.0-1.osg34.el7
osg-configure-rsv-2.5.0-1.osg34.el7
osg-configure-sge-2.5.0-1.osg34.el7
osg-configure-siteinfo-2.5.0-1.osg34.el7
osg-configure-slurm-2.5.0-1.osg34.el7
osg-configure-squid-2.5.0-1.osg34.el7
osg-configure-tests-2.5.0-1.osg34.el7
osg-version-3.4.37-1.osg34.el7
python2-condor-8.8.5-1.4.osg34.el7
python2-xrootd-4.10.1-1.osg34.el7
python3-condor-8.8.5-1.4.osg34.el7
scitokens-cpp-0.3.4-1.osg34.el7
scitokens-cpp-debuginfo-0.3.4-1.osg34.el7
scitokens-cpp-devel-0.3.4-1.osg34.el7
xrootd-4.10.1-1.osg34.el7
xrootd-client-4.10.1-1.osg34.el7
xrootd-client-devel-4.10.1-1.osg34.el7
xrootd-client-libs-4.10.1-1.osg34.el7
xrootd-debuginfo-4.10.1-1.osg34.el7
xrootd-devel-4.10.1-1.osg34.el7
xrootd-doc-4.10.1-1.osg34.el7
xrootd-fuse-4.10.1-1.osg34.el7
xrootd-libs-4.10.1-1.osg34.el7
xrootd-private-devel-4.10.1-1.osg34.el7
xrootd-selinux-4.10.1-1.osg34.el7
xrootd-server-4.10.1-1.osg34.el7
xrootd-server-devel-4.10.1-1.osg34.el7
xrootd-server-libs-4.10.1-1.osg34.el7
```
