OSG Software Release 3.4.9
==========================

**Release Date**: 2018-03-08

Summary of changes
------------------

This release contains:

-   [XRootD 4.8.1](https://github.com/xrootd/xrootd/blob/v4.8.1/docs/ReleaseNotes.txt): Several important bug fixes
-   [GlideinWMS 3.2.21](http://glideinwms.fnal.gov/doc.v3_2_21/history.html)
    -   Enhanced Singularity support
    -   [Automatic proxy renewal](http://opensciencegrid.org/docs/other/install-gwms-frontend/#proxy-configuration)
-   [Frontier Squid 3.5.27-3](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt)
    -   Honor "Pragma: no-cache" directive
    -   Included patches from recent Squid security advisories
-   RSV 3.17.0
    -   Enhanced security by verifying certificates with SHA256
    -   Use GRACC (rather than the retired Gratia service) to verify the last upload time of job records
    -   Added CREAM and nordugrid support back
    -   Change the Java probe to not emit the pipe character which is a problem for the Gratia service
-   osg-release: Use HTTPS protocol for OSG repositories

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.9%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore (`_`). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](/index.md).

Known Issues
------------

-   None.

Updating to the new release
---------------------------

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-to-osg-35).

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

-   [frontier-squid-3.5.27-3.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.27-3.1.osg34.el6)
-   [glideinwms-3.2.21-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.21-2.osg34.el6)
-   [osg-gridftp-3.4-7.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-7.osg34.el6)
-   [osg-release-3.4-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-4.osg34.el6)
-   [osg-release-itb-3.4-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-itb-3.4-4.osg34.el6)
-   [osg-test-2.1.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.1.0-1.osg34.el6)
-   [osg-version-3.4.9-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.9-1.osg34.el6)
-   [rsv-3.17.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.17.0-1.osg34.el6)
-   [xrootd-4.8.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.1-1.osg34.el6)

#### Enterprise Linux 7

-   [frontier-squid-3.5.27-3.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.27-3.1.osg34.el7)
-   [glideinwms-3.2.21-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.21-2.osg34.el7)
-   [osg-gridftp-3.4-7.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-7.osg34.el7)
-   [osg-release-3.4-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-4.osg34.el7)
-   [osg-release-itb-3.4-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-itb-3.4-4.osg34.el7)
-   [osg-test-2.1.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-2.1.0-1.osg34.el7)
-   [osg-version-3.4.9-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.9-1.osg34.el7)
-   [rsv-3.17.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.17.0-1.osg34.el7)
-   [xrootd-4.8.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.8.1-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid frontier-squid-debuginfo glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone osg-gridftp osg-gridftp-xrootd osg-release osg-release-itb osg-test osg-test-log-viewer osg-version python2-xrootd python3-xrootd rsv rsv-consumers rsv-core rsv-metrics xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
frontier-squid-3.5.27-3.1.osg34.el6
frontier-squid-debuginfo-3.5.27-3.1.osg34.el6
glideinwms-3.2.21-2.osg34.el6
glideinwms-common-tools-3.2.21-2.osg34.el6
glideinwms-condor-common-config-3.2.21-2.osg34.el6
glideinwms-factory-3.2.21-2.osg34.el6
glideinwms-factory-condor-3.2.21-2.osg34.el6
glideinwms-glidecondor-tools-3.2.21-2.osg34.el6
glideinwms-libs-3.2.21-2.osg34.el6
glideinwms-minimal-condor-3.2.21-2.osg34.el6
glideinwms-usercollector-3.2.21-2.osg34.el6
glideinwms-userschedd-3.2.21-2.osg34.el6
glideinwms-vofrontend-3.2.21-2.osg34.el6
glideinwms-vofrontend-standalone-3.2.21-2.osg34.el6
osg-gridftp-3.4-7.osg34.el6
osg-gridftp-xrootd-3.4-7.osg34.el6
osg-release-3.4-4.osg34.el6
osg-release-itb-3.4-4.osg34.el6
osg-test-2.1.0-1.osg34.el6
osg-test-log-viewer-2.1.0-1.osg34.el6
osg-version-3.4.9-1.osg34.el6
python2-xrootd-4.8.1-1.osg34.el6
python3-xrootd-4.8.1-1.osg34.el6
rsv-3.17.0-1.osg34.el6
rsv-consumers-3.17.0-1.osg34.el6
rsv-core-3.17.0-1.osg34.el6
rsv-metrics-3.17.0-1.osg34.el6
xrootd-4.8.1-1.osg34.el6
xrootd-client-4.8.1-1.osg34.el6
xrootd-client-devel-4.8.1-1.osg34.el6
xrootd-client-libs-4.8.1-1.osg34.el6
xrootd-debuginfo-4.8.1-1.osg34.el6
xrootd-devel-4.8.1-1.osg34.el6
xrootd-doc-4.8.1-1.osg34.el6
xrootd-fuse-4.8.1-1.osg34.el6
xrootd-libs-4.8.1-1.osg34.el6
xrootd-private-devel-4.8.1-1.osg34.el6
xrootd-selinux-4.8.1-1.osg34.el6
xrootd-server-4.8.1-1.osg34.el6
xrootd-server-devel-4.8.1-1.osg34.el6
xrootd-server-libs-4.8.1-1.osg34.el6
```

#### Enterprise Linux 7

``` file
frontier-squid-3.5.27-3.1.osg34.el7
frontier-squid-debuginfo-3.5.27-3.1.osg34.el7
glideinwms-3.2.21-2.osg34.el7
glideinwms-common-tools-3.2.21-2.osg34.el7
glideinwms-condor-common-config-3.2.21-2.osg34.el7
glideinwms-factory-3.2.21-2.osg34.el7
glideinwms-factory-condor-3.2.21-2.osg34.el7
glideinwms-glidecondor-tools-3.2.21-2.osg34.el7
glideinwms-libs-3.2.21-2.osg34.el7
glideinwms-minimal-condor-3.2.21-2.osg34.el7
glideinwms-usercollector-3.2.21-2.osg34.el7
glideinwms-userschedd-3.2.21-2.osg34.el7
glideinwms-vofrontend-3.2.21-2.osg34.el7
glideinwms-vofrontend-standalone-3.2.21-2.osg34.el7
osg-gridftp-3.4-7.osg34.el7
osg-gridftp-xrootd-3.4-7.osg34.el7
osg-release-3.4-4.osg34.el7
osg-release-itb-3.4-4.osg34.el7
osg-test-2.1.0-1.osg34.el7
osg-test-log-viewer-2.1.0-1.osg34.el7
osg-version-3.4.9-1.osg34.el7
python2-xrootd-4.8.1-1.osg34.el7
python3-xrootd-4.8.1-1.osg34.el7
rsv-3.17.0-1.osg34.el7
rsv-consumers-3.17.0-1.osg34.el7
rsv-core-3.17.0-1.osg34.el7
rsv-metrics-3.17.0-1.osg34.el7
xrootd-4.8.1-1.osg34.el7
xrootd-client-4.8.1-1.osg34.el7
xrootd-client-devel-4.8.1-1.osg34.el7
xrootd-client-libs-4.8.1-1.osg34.el7
xrootd-debuginfo-4.8.1-1.osg34.el7
xrootd-devel-4.8.1-1.osg34.el7
xrootd-doc-4.8.1-1.osg34.el7
xrootd-fuse-4.8.1-1.osg34.el7
xrootd-libs-4.8.1-1.osg34.el7
xrootd-private-devel-4.8.1-1.osg34.el7
xrootd-selinux-4.8.1-1.osg34.el7
xrootd-server-4.8.1-1.osg34.el7
xrootd-server-devel-4.8.1-1.osg34.el7
xrootd-server-libs-4.8.1-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [osg-gridftp-hdfs-3.4-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-hdfs-3.4-2.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-gridftp-hdfs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
osg-gridftp-hdfs-3.4-2.osgup.el7
```
