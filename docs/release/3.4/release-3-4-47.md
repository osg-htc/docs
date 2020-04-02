OSG Software Release 3.4.47
===========================

**Release Date**: 2020-04-02    
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

-   [GlideinWMS 3.6.2](https://glideinwms.fnal.gov/doc.v3_6_2/history.html)
    -   Add a portable condor\_chirp for user jobs running in the glideins
    -   Adding GPU monitor as default for pilots
    -   Reduce number of queries from Frontend to User collector
    -   Bug fix: Incorrect CERTIFICATE\_MAPFILE used when using HTCondor python binding (failed schedd authentication)
    -   Bug fix: Broken submission to GCE and AWS
-   Updated CA certificates based on [IGTF 1.105](http://dist.eugridpma.info/distribution/igtf/current/CHANGES):
    -   Discontinued CERN-LCG-IOTA-CA following decommissioning by authority (CERN)
    -   Added new G4 intermediates for the GEANT TCS service and supporting self-signed USERTrust RSA Root (EU)
    -   Updated AddTrust External CA Root signing policy to support legacy UTN chains for GEANT TCS G4 (EU)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.47%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

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

-   [glideinwms-3.6.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6.2-1.osg34.el6)
-   [igtf-ca-certs-1.105-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.105-1.osg34.el6)
-   [osg-ca-certs-1.87-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.87-1.osg34.el6)
-   [osg-version-3.4.47-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.47-1.osg34.el6)

#### Enterprise Linux 7

-   [glideinwms-3.6.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6.2-1.osg34.el7)
-   [igtf-ca-certs-1.105-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.105-1.osg34.el7)
-   [osg-ca-certs-1.87-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.87-1.osg34.el7)
-   [osg-version-3.4.47-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.47-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone igtf-ca-certs osg-ca-certs osg-version

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
glideinwms-3.6.2-1.osg34.el6
glideinwms-common-tools-3.6.2-1.osg34.el6
glideinwms-condor-common-config-3.6.2-1.osg34.el6
glideinwms-factory-3.6.2-1.osg34.el6
glideinwms-factory-condor-3.6.2-1.osg34.el6
glideinwms-glidecondor-tools-3.6.2-1.osg34.el6
glideinwms-libs-3.6.2-1.osg34.el6
glideinwms-minimal-condor-3.6.2-1.osg34.el6
glideinwms-usercollector-3.6.2-1.osg34.el6
glideinwms-userschedd-3.6.2-1.osg34.el6
glideinwms-vofrontend-3.6.2-1.osg34.el6
glideinwms-vofrontend-standalone-3.6.2-1.osg34.el6
igtf-ca-certs-1.105-1.osg34.el6
osg-ca-certs-1.87-1.osg34.el6
osg-version-3.4.47-1.osg34.el6
```

#### Enterprise Linux 7

``` file
glideinwms-3.6.2-1.osg34.el7
glideinwms-common-tools-3.6.2-1.osg34.el7
glideinwms-condor-common-config-3.6.2-1.osg34.el7
glideinwms-factory-3.6.2-1.osg34.el7
glideinwms-factory-condor-3.6.2-1.osg34.el7
glideinwms-glidecondor-tools-3.6.2-1.osg34.el7
glideinwms-libs-3.6.2-1.osg34.el7
glideinwms-minimal-condor-3.6.2-1.osg34.el7
glideinwms-usercollector-3.6.2-1.osg34.el7
glideinwms-userschedd-3.6.2-1.osg34.el7
glideinwms-vofrontend-3.6.2-1.osg34.el7
glideinwms-vofrontend-standalone-3.6.2-1.osg34.el7
igtf-ca-certs-1.105-1.osg34.el7
osg-ca-certs-1.87-1.osg34.el7
osg-version-3.4.47-1.osg34.el7
```
