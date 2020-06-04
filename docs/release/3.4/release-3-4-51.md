OSG Software Release 3.4.51
===========================

**Release Date**: 2020-06-04    
**Supported OS Versions:** EL7, EL6

!!!warning "OSG 3.4 End-of-Life Approaching"
    According to our
    [OSG Software Release Series Support Policy](https://opensciencegrid.org/technology/policy/release-series/),
    the OSG 3.4 series is due to reach
    [end-of-life](https://opensciencegrid.org/technology/policy/release-series/#life-cycle-dates) in **November 2020**.
    Please [upgrade to OSG 3.5](https://opensciencegrid.org/docs/release/release_series/#updating-to-osg-35)
    at your earliest convenience.

Summary of changes
------------------

This release contains:

-   gratia-probe 1.20.13
    -   Fix bug in interacting with Slurm versions earlier than 18
    -   Handle cluster name that contain special characters
-   [VO Package v106](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-106): Fixed WLCG VOMS server host name

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.51%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](/index.md).

-   OSG 3.4 contains only 64-bit components.
-   The StashCache service is only supported on EL7

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

-   [gratia-probe-1.20.13-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.13-1.osg34.el6)
-   [osg-build-1.16.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.16.1-1.osg34.el6)
-   [osg-version-3.4.51-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.51-1.osg34.el6)
-   [vo-client-106-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-106-1.osg34.el6)

#### Enterprise Linux 7

-   [gratia-probe-1.20.13-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.13-1.osg34.el7)
-   [osg-build-1.16.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.16.1-1.osg34.el7)
-   [osg-version-3.4.51-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.51-1.osg34.el7)
-   [vo-client-106-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-106-1.osg34.el7)

If you wish to only update the RPMs that changed, the set of RPMs is:

    gratia-probe gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-version vo-client vo-client-dcache vo-client-lcmaps-voms

#### Enterprise Linux 6

``` file
gratia-probe-1.20.13-1.osg34.el6
gratia-probe-common-1.20.13-1.osg34.el6
gratia-probe-condor-1.20.13-1.osg34.el6
gratia-probe-condor-events-1.20.13-1.osg34.el6
gratia-probe-dcache-storage-1.20.13-1.osg34.el6
gratia-probe-dcache-storagegroup-1.20.13-1.osg34.el6
gratia-probe-dcache-transfer-1.20.13-1.osg34.el6
gratia-probe-debuginfo-1.20.13-1.osg34.el6
gratia-probe-enstore-storage-1.20.13-1.osg34.el6
gratia-probe-enstore-tapedrive-1.20.13-1.osg34.el6
gratia-probe-enstore-transfer-1.20.13-1.osg34.el6
gratia-probe-glideinwms-1.20.13-1.osg34.el6
gratia-probe-gridftp-transfer-1.20.13-1.osg34.el6
gratia-probe-hadoop-storage-1.20.13-1.osg34.el6
gratia-probe-htcondor-ce-1.20.13-1.osg34.el6
gratia-probe-lsf-1.20.13-1.osg34.el6
gratia-probe-metric-1.20.13-1.osg34.el6
gratia-probe-onevm-1.20.13-1.osg34.el6
gratia-probe-pbs-lsf-1.20.13-1.osg34.el6
gratia-probe-services-1.20.13-1.osg34.el6
gratia-probe-sge-1.20.13-1.osg34.el6
gratia-probe-slurm-1.20.13-1.osg34.el6
gratia-probe-xrootd-storage-1.20.13-1.osg34.el6
gratia-probe-xrootd-transfer-1.20.13-1.osg34.el6
osg-build-1.16.1-1.osg34.el6
osg-build-base-1.16.1-1.osg34.el6
osg-build-koji-1.16.1-1.osg34.el6
osg-build-mock-1.16.1-1.osg34.el6
osg-build-tests-1.16.1-1.osg34.el6
osg-version-3.4.51-1.osg34.el6
vo-client-106-1.osg34.el6
vo-client-dcache-106-1.osg34.el6
vo-client-lcmaps-voms-106-1.osg34.el6
```

#### Enterprise Linux 7

``` file
gratia-probe-1.20.13-1.osg34.el7
gratia-probe-common-1.20.13-1.osg34.el7
gratia-probe-condor-1.20.13-1.osg34.el7
gratia-probe-condor-events-1.20.13-1.osg34.el7
gratia-probe-dcache-storage-1.20.13-1.osg34.el7
gratia-probe-dcache-storagegroup-1.20.13-1.osg34.el7
gratia-probe-dcache-transfer-1.20.13-1.osg34.el7
gratia-probe-debuginfo-1.20.13-1.osg34.el7
gratia-probe-enstore-storage-1.20.13-1.osg34.el7
gratia-probe-enstore-tapedrive-1.20.13-1.osg34.el7
gratia-probe-enstore-transfer-1.20.13-1.osg34.el7
gratia-probe-glideinwms-1.20.13-1.osg34.el7
gratia-probe-gridftp-transfer-1.20.13-1.osg34.el7
gratia-probe-hadoop-storage-1.20.13-1.osg34.el7
gratia-probe-htcondor-ce-1.20.13-1.osg34.el7
gratia-probe-lsf-1.20.13-1.osg34.el7
gratia-probe-metric-1.20.13-1.osg34.el7
gratia-probe-onevm-1.20.13-1.osg34.el7
gratia-probe-pbs-lsf-1.20.13-1.osg34.el7
gratia-probe-services-1.20.13-1.osg34.el7
gratia-probe-sge-1.20.13-1.osg34.el7
gratia-probe-slurm-1.20.13-1.osg34.el7
gratia-probe-xrootd-storage-1.20.13-1.osg34.el7
gratia-probe-xrootd-transfer-1.20.13-1.osg34.el7
osg-build-1.16.1-1.osg34.el7
osg-build-base-1.16.1-1.osg34.el7
osg-build-koji-1.16.1-1.osg34.el7
osg-build-mock-1.16.1-1.osg34.el7
osg-build-tests-1.16.1-1.osg34.el7
osg-version-3.4.51-1.osg34.el7
vo-client-106-1.osg34.el7
vo-client-dcache-106-1.osg34.el7
vo-client-lcmaps-voms-106-1.osg34.el7
```
