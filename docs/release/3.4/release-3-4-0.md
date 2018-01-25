OSG Software Release 3.4.0
==========================

**Release Date**: 2017-06-14

What's New in OSG 3.4
---------------------

The OSG 3.4.0 software stack features a more streamlined and consolidated package list. Specifically, the varied authentication solutions proved to be good candidates for consolidation and a new piece of software, the LCMAPS VOMS plugin, has been designed to replace both edg-mkgridmap and GUMS.

See [install the LCMAPS VOMS plugin](../../security/lcmaps-voms-authentication) to replace GUMS + edg-mkgridmap.

See [migrating from edg-mkgridmap to lcmaps VOMS plugin](../../security/lcmaps-voms-authentication#migrating-from-edg-mkgridmap) to transistion from edg-mkgridmap.

In 3.4.0, we dropped HDFS 2.x with the intention of adding HDFS 3.x in a subsequent OSG 3.4 release when it becomes available upstream.

In addition to GUMS, edg-mkgridmap, and HDFS 2.x, we dropped packages related to the following software:

-   VOMS Admin Server − [Retirement Policy](https://opensciencegrid.github.io/technology/policy/voms-admin-retire/)
-   BeStMan − replaced by [Load Balanced GridFTP](../../data/load-balanced-gridftp)
-   GLExec − replaced by [Singularty](http://singularity.lbl.gov/)
-   Globus GRAM − available from EPEL
-   GIP and OSG Info Services − BDII servers retired

The aforementioned packages are still be available in OSG 3.3 and will receive regular support until December 2017 and security updates until June 2018 per our [release policy](https://opensciencegrid.github.io/technology/policy/release-series/). See [this section](#PackagesRemoved) for the complete list of packages removed from OSG 3.4.

!!! note
    OSG 3.4 contains only 64-bit components.

!!! note
    StashCache is supported on EL7 only.

!!! note
    xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Summary of changes
------------------

This release contains:

-   OSG 3.4.0
    -   [HTCondor 8.6.3](https://lists.cs.wisc.edu/archive/htcondor-world/2017/msg00017.shtml): See [Upgrading from 8.4](http://research.cs.wisc.edu/htcondor//manual/v8.6.3/10_2Upgrading_from.html) for additional information
    -   [Frontier squid 3.5.24-3.1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): See [Upgrading from 2.x to 3.x](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Upgrading) for additional information
    -   Update to [XRootD 4.6.1](https://github.com/xrootd/xrootd/blob/v4.6.1/docs/ReleaseNotes.txt)
        -   Update to xrootd-lcmaps 1.3.3 for EL7
    -   Update StashCache meta-packages to require XRootD 4.6.1
    -   Update to [GlideinWMS 3.2.19](http://glideinwms.fnal.gov/doc.v3_2_19/history.html)
    -   Make the LCMAPS VOMS plugin consider only the first FQAN to be consistent with GUMS
    -   HTCondor-CE: Add WholeNodeWanted ClassAd expression so jobs can request a whole node from the batch system
    -   [HTCondor 8.6.3](https://lists.cs.wisc.edu/archive/htcondor-world/2017/msg00017.shtml): See [Upgrading from 8.4](http://research.cs.wisc.edu/htcondor//manual/v8.6.3/10_2Upgrading_from.html) for additional information
    -   OSG CE 3.4
        -   Add vo-client-lcmaps-voms dependency
        -   Remove gridftp dependency
        -   Drop client tools
    -   Add vo-client-lcmaps-voms dependency to osg-gridftp
    -   Fix osg-update-vos script to clean yum cache in order pick up the latest vo-client RPM
    -   osg-ca-scripts now refers to repo.grid.iu.edu (rather than the retired software.grid.iu.edu)
    -   osg-configure 2.0.0
        -   reject empty `allowed_vos` in subclusters
        -   get default `allowed_vos` from LCMAPS VOMS plugin
        -   issue warning (rather than error out) if OSG\_APP or OSG\_DATA directories are not present
        -   drop 'RSV is not installed' warning
        -   remove configure-osg alias
        -   deprecate GUMS support
        -   disable GRAM configuration
        -   drop managedfork and network modules
        -   drop glexec support
        -   remove nonfunctional osg-cleanup
    -   Drop glexec and java from osg-wn-client
    -   BeSTMan 2 is no longer part of the OSG Software Stack
    -   GUMS is no longer part of the OSG Software Stack
    -   edg-mkgridmap in no longer part of the OSG Software Stack
    -   Drop bestman2 and globus\*run RSV metrics
    -   osg-build 1.10.0
        -   drop vdt-build alias
        -   drop ~/.osg-build.ini configuration file

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.0%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   Currently, OSG 3.4 CEs cannot be configured to authenticate via GUMS ([SOFTWARE-2482](https://jira.opensciencegrid.org/browse/SOFTWARE-2482)). This issue is expected to be fixed in the July release.
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the July release.
-   In GlideinWMS, a small configuration change must be added to account for changes in HTCondor 8.6. Add the following line to the HTCondor configuration.

``` file
COLLECTOR.USE_SHARED_PORT=False
```

Updating to the new release
---------------------------

To update to the OSG 3.4 series, please consult the page on [updating between release series](../release_series).

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
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [autopyfactory-2.4.6-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=autopyfactory-2.4.6-4.osg34.el6)
-   [blahp-1.18.29.bosco-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.29.bosco-3.osg34.el6)
-   [bwctl-1.4-7.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bwctl-1.4-7.osg34.el6)
-   [cctools-4.4.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-4.4.3-1.osg34.el6)
-   [condor-8.6.3-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.3-1.1.osg34.el6)
-   [condor-cron-1.1.1-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.1-2.osg34.el6)
-   [cvmfs-2.3.5-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.3.5-1.osg34.el6)
-   [cvmfs-config-osg-2.0-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.0-2.osg34.el6)
-   [cvmfs-x509-helper-1.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-1.0-1.osg34.el6)
-   [frontier-squid-3.5.24-3.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.24-3.1.osg34.el6)
-   [glideinwms-3.2.19-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.19-2.osg34.el6)
-   [glite-build-common-cpp-3.3.0.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-build-common-cpp-3.3.0.2-1.osg34.el6)
-   [glite-ce-cream-client-api-c-1.15.4-2.3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.3.osg34.el6)
-   [glite-ce-wsdl-1.15.1-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-wsdl-1.15.1-1.1.osg34.el6)
-   [glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg34.el6)
-   [globus-ftp-client-8.29-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-8.29-1.1.osg34.el6)
-   [globus-gridftp-osg-extensions-0.3-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.3-2.osg34.el6)
-   [globus-gridftp-server-11.8-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-11.8-1.1.osg34.el6)
-   [globus-gridftp-server-control-4.1-1.3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-4.1-1.3.osg34.el6)
-   [gratia-probe-1.17.5-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.17.5-1.osg34.el6)
-   [gsi-openssh-7.1p2f-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.1p2f-1.2.osg34.el6)
-   [htcondor-ce-2.2.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.0-1.osg34.el6)
-   [igtf-ca-certs-1.82-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.82-1.osg34.el6)
-   [javascriptrrd-1.1.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=javascriptrrd-1.1.1-1.osg34.el6)
-   [koji-1.11.0-1.5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.11.0-1.5.osg34.el6)
-   [lcas-lcmaps-gt4-interface-0.3.1-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcas-lcmaps-gt4-interface-0.3.1-1.2.osg34.el6)
-   [lcmaps-1.6.6-1.6.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.6.osg34.el6)
-   [lcmaps-plugins-basic-1.7.0-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-basic-1.7.0-2.osg34.el6)
-   [lcmaps-plugins-scas-client-0.5.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-scas-client-0.5.6-1.osg34.el6)
-   [lcmaps-plugins-verify-proxy-1.5.9-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.9-1.1.osg34.el6)
-   [lcmaps-plugins-voms-1.7.1-1.4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.4.osg34.el6)
-   [llrun-0.1.3-1.3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=llrun-0.1.3-1.3.osg34.el6)
-   [mash-0.5.22-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=mash-0.5.22-3.osg34.el6)
-   [myproxy-6.1.18-1.4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.1.18-1.4.osg34.el6)
-   [nuttcp-6.1.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=nuttcp-6.1.2-1.osg34.el6)
-   [osg-build-1.10.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.0-1.osg34.el6)
-   [osg-ca-certs-1.62-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.62-1.osg34.el6)
-   [osg-ca-certs-updater-1.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.4-1.osg34.el6)
-   [osg-ca-generator-1.2.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-generator-1.2.0-1.osg34.el6)
-   [osg-ca-scripts-1.1.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.6-1.osg34.el6)
-   [osg-ce-3.4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.4-2.osg34.el6)
-   [osg-configure-2.0.0-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.0.0-3.osg34.el6)
-   [osg-control-1.1.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-control-1.1.0-1.osg34.el6)
-   [osg-gridftp-3.4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-2.osg34.el6)
-   [osg-gridftp-xrootd-3.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-xrootd-3.4-1.osg34.el6)
-   [osg-oasis-7-9.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-7-9.osg34.el6)
-   [osg-pki-tools-1.2.20-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.20-1.osg34.el6)
-   [osg-system-profiler-1.4.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.0-1.osg34.el6)
-   [osg-test-1.10.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.10.1-1.osg34.el6)
-   [osg-tested-internal-3.4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-2.osg34.el6)
-   [osg-update-vos-1.4.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-update-vos-1.4.0-1.osg34.el6)
-   [osg-version-3.4.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.0-1.osg34.el6)
-   [osg-vo-map-0.0.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-vo-map-0.0.2-1.osg34.el6)
-   [osg-wn-client-3.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.4-1.osg34.el6)
-   [owamp-3.2rc4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=owamp-3.2rc4-2.osg34.el6)
-   [pegasus-4.7.4-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.7.4-1.1.osg34.el6)
-   [rsv-3.14.0-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.14.0-2.osg34.el6)
-   [rsv-gwms-tester-1.1.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-gwms-tester-1.1.2-1.osg34.el6)
-   [uberftp-2.8-2.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=uberftp-2.8-2.1.osg34.el6)
-   [vo-client-73-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-73-1.osg34.el6)
-   [voms-2.0.14-1.3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.3.osg34.el6)
-   [xacml-1.5.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xacml-1.5.0-1.osg34.el6)
-   [xrootd-4.6.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.6.1-1.osg34.el6)
-   [xrootd-dsi-3.0.4-22.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-dsi-3.0.4-22.osg34.el6)
-   [xrootd-lcmaps-1.2.1-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.2.1-2.osg34.el6)
-   [xrootd-voms-plugin-0.4.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-voms-plugin-0.4.0-1.osg34.el6)

#### Enterprise Linux 7

-   [autopyfactory-2.4.6-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=autopyfactory-2.4.6-4.osg34.el7)
-   [blahp-1.18.29.bosco-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.29.bosco-3.osg34.el7)
-   [bwctl-1.4-7.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bwctl-1.4-7.osg34.el7)
-   [cctools-4.4.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-4.4.3-1.osg34.el7)
-   [condor-8.6.3-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.3-1.1.osg34.el7)
-   [condor-cron-1.1.1-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.1-2.osg34.el7)
-   [cvmfs-2.3.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.3.5-1.osg34.el7)
-   [cvmfs-config-osg-2.0-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.0-2.osg34.el7)
-   [cvmfs-x509-helper-1.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-x509-helper-1.0-1.osg34.el7)
-   [frontier-squid-3.5.24-3.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.24-3.1.osg34.el7)
-   [glideinwms-3.2.19-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.19-2.osg34.el7)
-   [glite-build-common-cpp-3.3.0.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-build-common-cpp-3.3.0.2-1.osg34.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.3.osg34.el7)
-   [glite-ce-wsdl-1.15.1-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-ce-wsdl-1.15.1-1.1.osg34.el7)
-   [glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg34.el7)
-   [globus-ftp-client-8.29-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-8.29-1.1.osg34.el7)
-   [globus-gridftp-osg-extensions-0.3-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.3-2.osg34.el7)
-   [globus-gridftp-server-11.8-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-11.8-1.1.osg34.el7)
-   [globus-gridftp-server-control-4.1-1.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-4.1-1.3.osg34.el7)
-   [gratia-probe-1.17.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.17.5-1.osg34.el7)
-   [gsi-openssh-7.1p2f-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.1p2f-1.2.osg34.el7)
-   [htcondor-ce-2.2.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.0-1.osg34.el7)
-   [igtf-ca-certs-1.82-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.82-1.osg34.el7)
-   [javascriptrrd-1.1.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=javascriptrrd-1.1.1-1.osg34.el7)
-   [koji-1.11.0-1.5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.11.0-1.5.osg34.el7)
-   [lcas-lcmaps-gt4-interface-0.3.1-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcas-lcmaps-gt4-interface-0.3.1-1.2.osg34.el7)
-   [lcmaps-1.6.6-1.6.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.6.osg34.el7)
-   [lcmaps-plugins-basic-1.7.0-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-basic-1.7.0-2.osg34.el7)
-   [lcmaps-plugins-scas-client-0.5.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-scas-client-0.5.6-1.osg34.el7)
-   [lcmaps-plugins-verify-proxy-1.5.9-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-verify-proxy-1.5.9-1.1.osg34.el7)
-   [lcmaps-plugins-voms-1.7.1-1.4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.4.osg34.el7)
-   [llrun-0.1.3-1.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=llrun-0.1.3-1.3.osg34.el7)
-   [mash-0.5.22-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=mash-0.5.22-3.osg34.el7)
-   [myproxy-6.1.18-1.4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.1.18-1.4.osg34.el7)
-   [nuttcp-6.1.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=nuttcp-6.1.2-1.osg34.el7)
-   [osg-build-1.10.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.0-1.osg34.el7)
-   [osg-ca-certs-1.62-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.62-1.osg34.el7)
-   [osg-ca-certs-updater-1.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.4-1.osg34.el7)
-   [osg-ca-generator-1.2.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-generator-1.2.0-1.osg34.el7)
-   [osg-ca-scripts-1.1.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.6-1.osg34.el7)
-   [osg-ce-3.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.4-2.osg34.el7)
-   [osg-configure-2.0.0-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.0.0-3.osg34.el7)
-   [osg-control-1.1.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-control-1.1.0-1.osg34.el7)
-   [osg-gridftp-3.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-2.osg34.el7)
-   [osg-gridftp-xrootd-3.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-xrootd-3.4-1.osg34.el7)
-   [osg-oasis-7-9.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-7-9.osg34.el7)
-   [osg-pki-tools-1.2.20-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.20-1.osg34.el7)
-   [osg-system-profiler-1.4.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-system-profiler-1.4.0-1.osg34.el7)
-   [osg-test-1.10.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.10.1-1.osg34.el7)
-   [osg-tested-internal-3.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-2.osg34.el7)
-   [osg-update-vos-1.4.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-update-vos-1.4.0-1.osg34.el7)
-   [osg-version-3.4.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.0-1.osg34.el7)
-   [osg-vo-map-0.0.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-vo-map-0.0.2-1.osg34.el7)
-   [osg-wn-client-3.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-wn-client-3.4-1.osg34.el7)
-   [owamp-3.2rc4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=owamp-3.2rc4-2.osg34.el7)
-   [pegasus-4.7.4-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.7.4-1.1.osg34.el7)
-   [rsv-3.14.0-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.14.0-2.osg34.el7)
-   [rsv-gwms-tester-1.1.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-gwms-tester-1.1.2-1.osg34.el7)
-   [stashcache-0.7-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-0.7-2.osg34.el7)
-   [uberftp-2.8-2.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=uberftp-2.8-2.1.osg34.el7)
-   [vo-client-73-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-73-1.osg34.el7)
-   [voms-2.0.14-1.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.3.osg34.el7)
-   [xacml-1.5.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xacml-1.5.0-1.osg34.el7)
-   [xrootd-4.6.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.6.1-1.osg34.el7)
-   [xrootd-dsi-3.0.4-22.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-dsi-3.0.4-22.osg34.el7)
-   [xrootd-lcmaps-1.3.3-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.3.3-3.osg34.el7)
-   [xrootd-voms-plugin-0.4.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-voms-plugin-0.4.0-1.osg34.el7)

\#PackagesRemoved

### Packages Removed from OSG 3.4

Many packages that were available in OSG 3.3 will not be included in the OSG 3.4 software stack. The following packages are not in the 3.4 repositories.

#### Enterprise Linux 6

``` file
bestman2
bigtop-jsvc
bigtop-utils
cilogon-openid-ca-cert
cilogon-osg-ca-cert
cog-jglobus-axis
edg-mkgridmap
emi-trustmanager
emi-trustmanager-axis
emi-trustmanager-tomcat
gip
glexec
glexec-wrapper-scripts
glite-ce-cream-utils
glite-lbjp-common-gss
globus-authz
globus-authz-callout-error
globus-callout
globus-common
globus-ftp-control
globus-gass-cache
globus-gass-cache-program
globus-gass-copy
globus-gass-server-ez
globus-gass-transfer
globus-gatekeeper
globus-gfork
globus-gram-audit
globus-gram-client
globus-gram-client-tools
globus-gram-job-manager
globus-gram-job-manager-callout-error
globus-gram-job-manager-condor
globus-gram-job-manager-fork
globus-gram-job-manager-lsf
globus-gram-job-manager-managedfork
globus-gram-job-manager-pbs
globus-gram-job-manager-scripts
globus-gram-job-manager-sge
globus-gram-protocol
globus-gridmap-callout-error
globus-gsi-callback
globus-gsi-cert-utils
globus-gsi-credential
globus-gsi-openssl-error
globus-gsi-proxy-core
globus-gsi-proxy-ssl
globus-gsi-sysconfig
globus-gssapi-error
globus-gssapi-gsi
globus-gss-assist
globus-io
globus-openssl-module
globus-proxy-utils
globus-rsl
globus-scheduler-event-generator
globus-simple-ca
globus-usage
globus-xio
globus-xio-gsi-driver
globus-xioperf
globus-xio-pipe-driver
globus-xio-popen-driver
globus-xio-udt-driver
gratia
gratia-reporting-email
gridftp-hdfs
gums
hadoop
I2util
jetty
jglobus
joda-time
lcmaps-plugins-glexec-tracking
lcmaps-plugins-gums-client
lcmaps-plugins-mount-under-scratch
lcmaps-plugins-process-tracking
mkgltempdir
ndt
netlogger
osg-cert-scripts
osg-cleanup
osg-gridftp-hdfs
osg-gums
osg-info-services
osg-java7-compat
osg-release
osg-release-itb
osg-se-bestman
osg-se-bestman-xrootd
osg-se-hadoop
osg-voms
osg-webapp-common
privilege-xacml
rsv-vo-gwms
stashcache
stashcache-daemon
voms-admin-client
voms-admin-server
voms-api-java
voms-mysql-plugin
web100_userland
xrootd-hdfs
xrootd-status-probe
zookeeper
```

#### Enterprise Linux 7

``` file
axis
bestman2
bigtop-jsvc
bigtop-utils
cilogon-openid-ca-cert
cilogon-osg-ca-cert
cog-jglobus-axis
edg-mkgridmap
emi-trustmanager
emi-trustmanager-axis
emi-trustmanager-tomcat
gip
glexec
glexec-wrapper-scripts
glite-lbjp-common-gss
globus-authz
globus-authz-callout-error
globus-callout
globus-common
globus-ftp-control
globus-gass-cache
globus-gass-cache-program
globus-gass-copy
globus-gass-server-ez
globus-gass-transfer
globus-gatekeeper
globus-gfork
globus-gram-audit
globus-gram-client
globus-gram-client-tools
globus-gram-job-manager
globus-gram-job-manager-callout-error
globus-gram-job-manager-condor
globus-gram-job-manager-fork
globus-gram-job-manager-lsf
globus-gram-job-manager-managedfork
globus-gram-job-manager-pbs
globus-gram-job-manager-scripts
globus-gram-job-manager-sge
globus-gram-protocol
globus-gridmap-callout-error
globus-gsi-callback
globus-gsi-cert-utils
globus-gsi-credential
globus-gsi-openssl-error
globus-gsi-proxy-core
globus-gsi-proxy-ssl
globus-gsi-sysconfig
globus-gssapi-error
globus-gssapi-gsi
globus-gss-assist
globus-io
globus-openssl-module
globus-proxy-utils
globus-rsl
globus-scheduler-event-generator
globus-simple-ca
globus-usage
globus-xio
globus-xio-gsi-driver
globus-xioperf
globus-xio-pipe-driver
globus-xio-popen-driver
globus-xio-udt-driver
gratia
gratia-reporting-email
gridftp-hdfs
gums
hadoop
I2util
javamail
jetty
jglobus
joda-time
lcmaps-plugins-glexec-tracking
lcmaps-plugins-gums-client
lcmaps-plugins-mount-under-scratch
lcmaps-plugins-process-tracking
mkgltempdir
ndt
netlogger
osg-cert-scripts
osg-cleanup
osg-gridftp-hdfs
osg-gums
osg-info-services
osg-java7-compat
osg-release
osg-release-itb
osg-se-bestman
osg-se-bestman-xrootd
osg-se-hadoop
osg-voms
osg-webapp-common
privilege-xacml
python-ZSI
PyXML
rsv-vo-gwms
stashcache-daemon
voms-admin-client
voms-mysql-plugin
web100_userland
wsdl4j
xrootd-hdfs
xrootd-status-probe
zookeeper
```

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    autopyfactory-cloud autopyfactory-common autopyfactory-panda autopyfactory-plugins-cloud autopyfactory-plugins-local autopyfactory-plugins-monitor autopyfactory-plugins-panda autopyfactory-plugins-remote autopyfactory-plugins-scheds autopyfactory-proxymanager autopyfactory-remote autopyfactory-wms blahp blahp-debuginfo bwctl bwctl-client bwctl-debuginfo bwctl-devel bwctl-server cctools-chirp cctools-debuginfo cctools-doc cctools-dttools cctools-makeflow cctools-parrot cctools-resource_monitor cctools-sand cctools-wavefront cctools-weaver cctools-work_queue condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-cron condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp cvmfs cvmfs-config-osg cvmfs-devel cvmfs-server cvmfs-unittests cvmfs-x509-helper cvmfs-x509-helper-debuginfo frontier-squid frontier-squid-debuginfo glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone glite-build-common-cpp glite-ce-cream-client-api-c glite-ce-cream-client-devel glite-ce-wsdl glite-lbjp-common-gsoap-plugin glite-lbjp-common-gsoap-plugin-debuginfo glite-lbjp-common-gsoap-plugin-devel globus-ftp-client globus-ftp-client-debuginfo globus-ftp-client-devel globus-ftp-client-doc globus-gridftp-osg-extensions globus-gridftp-osg-extensions-debuginfo globus-gridftp-server globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs javascriptrrd koji koji-builder koji-hub koji-hub-plugins koji-utils koji-vm koji-web lcas-lcmaps-gt4-interface lcas-lcmaps-gt4-interface-debuginfo lcmaps lcmaps-common-devel lcmaps-db-templates lcmaps-debuginfo lcmaps-devel lcmaps-plugins-basic lcmaps-plugins-basic-debuginfo lcmaps-plugins-basic-ldap lcmaps-plugins-scas-client lcmaps-plugins-scas-client-debuginfo lcmaps-plugins-verify-proxy lcmaps-plugins-verify-proxy-debuginfo lcmaps-plugins-voms lcmaps-plugins-voms-debuginfo lcmaps-without-gsi lcmaps-without-gsi-devel llrun llrun-debuginfo mash myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms nuttcp nuttcp-debuginfo osg-base-ce osg-base-ce-bosco osg-base-ce-condor osg-base-ce-lsf osg-base-ce-pbs osg-base-ce-sge osg-base-ce-slurm osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-ca-certs osg-ca-certs-updater osg-ca-generator osg-ca-scripts osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-control osg-gridftp osg-gridftp-xrootd osg-gums-config osg-htcondor-ce osg-htcondor-ce-bosco osg-htcondor-ce-condor osg-htcondor-ce-lsf osg-htcondor-ce-pbs osg-htcondor-ce-sge osg-htcondor-ce-slurm osg-oasis osg-pki-tools osg-pki-tools-tests osg-release osg-release-itb osg-system-profiler osg-system-profiler-viewer osg-test osg-tested-internal osg-test-log-viewer osg-update-data osg-update-vos osg-version osg-vo-map osg-wn-client owamp owamp-client owamp-debuginfo owamp-server pegasus pegasus-debuginfo rsv rsv-consumers rsv-core rsv-gwms-tester rsv-metrics uberftp uberftp-debuginfo vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server xacml xacml-debuginfo xacml-devel xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-dsi xrootd-dsi-debuginfo xrootd-fuse xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs xrootd-voms-plugin xrootd-voms-plugin-debuginfo xrootd-voms-plugin-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
autopyfactory-2.4.6-4.osg34.el6
autopyfactory-cloud-2.4.6-4.osg34.el6
autopyfactory-common-2.4.6-4.osg34.el6
autopyfactory-panda-2.4.6-4.osg34.el6
autopyfactory-plugins-cloud-2.4.6-4.osg34.el6
autopyfactory-plugins-local-2.4.6-4.osg34.el6
autopyfactory-plugins-monitor-2.4.6-4.osg34.el6
autopyfactory-plugins-panda-2.4.6-4.osg34.el6
autopyfactory-plugins-remote-2.4.6-4.osg34.el6
autopyfactory-plugins-scheds-2.4.6-4.osg34.el6
autopyfactory-proxymanager-2.4.6-4.osg34.el6
autopyfactory-remote-2.4.6-4.osg34.el6
autopyfactory-wms-2.4.6-4.osg34.el6
blahp-1.18.29.bosco-3.osg34.el6
blahp-debuginfo-1.18.29.bosco-3.osg34.el6
bwctl-1.4-7.osg34.el6
bwctl-client-1.4-7.osg34.el6
bwctl-debuginfo-1.4-7.osg34.el6
bwctl-devel-1.4-7.osg34.el6
bwctl-server-1.4-7.osg34.el6
cctools-4.4.3-1.osg34.el6
cctools-chirp-4.4.3-1.osg34.el6
cctools-debuginfo-4.4.3-1.osg34.el6
cctools-doc-4.4.3-1.osg34.el6
cctools-dttools-4.4.3-1.osg34.el6
cctools-makeflow-4.4.3-1.osg34.el6
cctools-parrot-4.4.3-1.osg34.el6
cctools-resource_monitor-4.4.3-1.osg34.el6
cctools-sand-4.4.3-1.osg34.el6
cctools-wavefront-4.4.3-1.osg34.el6
cctools-weaver-4.4.3-1.osg34.el6
cctools-work_queue-4.4.3-1.osg34.el6
condor-8.6.3-1.1.osg34.el6
condor-all-8.6.3-1.1.osg34.el6
condor-bosco-8.6.3-1.1.osg34.el6
condor-classads-8.6.3-1.1.osg34.el6
condor-classads-devel-8.6.3-1.1.osg34.el6
condor-cream-gahp-8.6.3-1.1.osg34.el6
condor-cron-1.1.1-2.osg34.el6
condor-debuginfo-8.6.3-1.1.osg34.el6
condor-kbdd-8.6.3-1.1.osg34.el6
condor-procd-8.6.3-1.1.osg34.el6
condor-python-8.6.3-1.1.osg34.el6
condor-std-universe-8.6.3-1.1.osg34.el6
condor-test-8.6.3-1.1.osg34.el6
condor-vm-gahp-8.6.3-1.1.osg34.el6
cvmfs-2.3.5-1.osg34.el6
cvmfs-config-osg-2.0-2.osg34.el6
cvmfs-devel-2.3.5-1.osg34.el6
cvmfs-server-2.3.5-1.osg34.el6
cvmfs-unittests-2.3.5-1.osg34.el6
cvmfs-x509-helper-1.0-1.osg34.el6
cvmfs-x509-helper-debuginfo-1.0-1.osg34.el6
frontier-squid-3.5.24-3.1.osg34.el6
frontier-squid-debuginfo-3.5.24-3.1.osg34.el6
glideinwms-3.2.19-2.osg34.el6
glideinwms-common-tools-3.2.19-2.osg34.el6
glideinwms-condor-common-config-3.2.19-2.osg34.el6
glideinwms-factory-3.2.19-2.osg34.el6
glideinwms-factory-condor-3.2.19-2.osg34.el6
glideinwms-glidecondor-tools-3.2.19-2.osg34.el6
glideinwms-libs-3.2.19-2.osg34.el6
glideinwms-minimal-condor-3.2.19-2.osg34.el6
glideinwms-usercollector-3.2.19-2.osg34.el6
glideinwms-userschedd-3.2.19-2.osg34.el6
glideinwms-vofrontend-3.2.19-2.osg34.el6
glideinwms-vofrontend-standalone-3.2.19-2.osg34.el6
glite-build-common-cpp-3.3.0.2-1.osg34.el6
glite-ce-cream-client-api-c-1.15.4-2.3.osg34.el6
glite-ce-cream-client-devel-1.15.4-2.3.osg34.el6
glite-ce-wsdl-1.15.1-1.1.osg34.el6
glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg34.el6
glite-lbjp-common-gsoap-plugin-debuginfo-3.2.12-1.1.osg34.el6
glite-lbjp-common-gsoap-plugin-devel-3.2.12-1.1.osg34.el6
globus-ftp-client-8.29-1.1.osg34.el6
globus-ftp-client-debuginfo-8.29-1.1.osg34.el6
globus-ftp-client-devel-8.29-1.1.osg34.el6
globus-ftp-client-doc-8.29-1.1.osg34.el6
globus-gridftp-osg-extensions-0.3-2.osg34.el6
globus-gridftp-osg-extensions-debuginfo-0.3-2.osg34.el6
globus-gridftp-server-11.8-1.1.osg34.el6
globus-gridftp-server-control-4.1-1.3.osg34.el6
globus-gridftp-server-control-debuginfo-4.1-1.3.osg34.el6
globus-gridftp-server-control-devel-4.1-1.3.osg34.el6
globus-gridftp-server-debuginfo-11.8-1.1.osg34.el6
globus-gridftp-server-devel-11.8-1.1.osg34.el6
globus-gridftp-server-progs-11.8-1.1.osg34.el6
gratia-probe-1.17.5-1.osg34.el6
gratia-probe-bdii-status-1.17.5-1.osg34.el6
gratia-probe-common-1.17.5-1.osg34.el6
gratia-probe-condor-1.17.5-1.osg34.el6
gratia-probe-condor-events-1.17.5-1.osg34.el6
gratia-probe-dcache-storage-1.17.5-1.osg34.el6
gratia-probe-dcache-storagegroup-1.17.5-1.osg34.el6
gratia-probe-dcache-transfer-1.17.5-1.osg34.el6
gratia-probe-debuginfo-1.17.5-1.osg34.el6
gratia-probe-enstore-storage-1.17.5-1.osg34.el6
gratia-probe-enstore-tapedrive-1.17.5-1.osg34.el6
gratia-probe-enstore-transfer-1.17.5-1.osg34.el6
gratia-probe-glexec-1.17.5-1.osg34.el6
gratia-probe-glideinwms-1.17.5-1.osg34.el6
gratia-probe-gram-1.17.5-1.osg34.el6
gratia-probe-gridftp-transfer-1.17.5-1.osg34.el6
gratia-probe-hadoop-storage-1.17.5-1.osg34.el6
gratia-probe-htcondor-ce-1.17.5-1.osg34.el6
gratia-probe-lsf-1.17.5-1.osg34.el6
gratia-probe-metric-1.17.5-1.osg34.el6
gratia-probe-onevm-1.17.5-1.osg34.el6
gratia-probe-pbs-lsf-1.17.5-1.osg34.el6
gratia-probe-services-1.17.5-1.osg34.el6
gratia-probe-sge-1.17.5-1.osg34.el6
gratia-probe-slurm-1.17.5-1.osg34.el6
gratia-probe-xrootd-storage-1.17.5-1.osg34.el6
gratia-probe-xrootd-transfer-1.17.5-1.osg34.el6
gsi-openssh-7.1p2f-1.2.osg34.el6
gsi-openssh-clients-7.1p2f-1.2.osg34.el6
gsi-openssh-debuginfo-7.1p2f-1.2.osg34.el6
gsi-openssh-server-7.1p2f-1.2.osg34.el6
htcondor-ce-2.2.0-1.osg34.el6
htcondor-ce-bosco-2.2.0-1.osg34.el6
htcondor-ce-client-2.2.0-1.osg34.el6
htcondor-ce-collector-2.2.0-1.osg34.el6
htcondor-ce-condor-2.2.0-1.osg34.el6
htcondor-ce-lsf-2.2.0-1.osg34.el6
htcondor-ce-pbs-2.2.0-1.osg34.el6
htcondor-ce-sge-2.2.0-1.osg34.el6
htcondor-ce-slurm-2.2.0-1.osg34.el6
htcondor-ce-view-2.2.0-1.osg34.el6
igtf-ca-certs-1.82-1.osg34.el6
javascriptrrd-1.1.1-1.osg34.el6
koji-1.11.0-1.5.osg34.el6
koji-builder-1.11.0-1.5.osg34.el6
koji-hub-1.11.0-1.5.osg34.el6
koji-hub-plugins-1.11.0-1.5.osg34.el6
koji-utils-1.11.0-1.5.osg34.el6
koji-vm-1.11.0-1.5.osg34.el6
koji-web-1.11.0-1.5.osg34.el6
lcas-lcmaps-gt4-interface-0.3.1-1.2.osg34.el6
lcas-lcmaps-gt4-interface-debuginfo-0.3.1-1.2.osg34.el6
lcmaps-1.6.6-1.6.osg34.el6
lcmaps-common-devel-1.6.6-1.6.osg34.el6
lcmaps-db-templates-1.6.6-1.6.osg34.el6
lcmaps-debuginfo-1.6.6-1.6.osg34.el6
lcmaps-devel-1.6.6-1.6.osg34.el6
lcmaps-plugins-basic-1.7.0-2.osg34.el6
lcmaps-plugins-basic-debuginfo-1.7.0-2.osg34.el6
lcmaps-plugins-basic-ldap-1.7.0-2.osg34.el6
lcmaps-plugins-scas-client-0.5.6-1.osg34.el6
lcmaps-plugins-scas-client-debuginfo-0.5.6-1.osg34.el6
lcmaps-plugins-verify-proxy-1.5.9-1.1.osg34.el6
lcmaps-plugins-verify-proxy-debuginfo-1.5.9-1.1.osg34.el6
lcmaps-plugins-voms-1.7.1-1.4.osg34.el6
lcmaps-plugins-voms-debuginfo-1.7.1-1.4.osg34.el6
lcmaps-without-gsi-1.6.6-1.6.osg34.el6
lcmaps-without-gsi-devel-1.6.6-1.6.osg34.el6
llrun-0.1.3-1.3.osg34.el6
llrun-debuginfo-0.1.3-1.3.osg34.el6
mash-0.5.22-3.osg34.el6
myproxy-6.1.18-1.4.osg34.el6
myproxy-admin-6.1.18-1.4.osg34.el6
myproxy-debuginfo-6.1.18-1.4.osg34.el6
myproxy-devel-6.1.18-1.4.osg34.el6
myproxy-doc-6.1.18-1.4.osg34.el6
myproxy-libs-6.1.18-1.4.osg34.el6
myproxy-server-6.1.18-1.4.osg34.el6
myproxy-voms-6.1.18-1.4.osg34.el6
nuttcp-6.1.2-1.osg34.el6
nuttcp-debuginfo-6.1.2-1.osg34.el6
osg-base-ce-3.4-2.osg34.el6
osg-base-ce-bosco-3.4-2.osg34.el6
osg-base-ce-condor-3.4-2.osg34.el6
osg-base-ce-lsf-3.4-2.osg34.el6
osg-base-ce-pbs-3.4-2.osg34.el6
osg-base-ce-sge-3.4-2.osg34.el6
osg-base-ce-slurm-3.4-2.osg34.el6
osg-build-1.10.0-1.osg34.el6
osg-build-base-1.10.0-1.osg34.el6
osg-build-koji-1.10.0-1.osg34.el6
osg-build-mock-1.10.0-1.osg34.el6
osg-build-tests-1.10.0-1.osg34.el6
osg-ca-certs-1.62-1.osg34.el6
osg-ca-certs-updater-1.4-1.osg34.el6
osg-ca-generator-1.2.0-1.osg34.el6
osg-ca-scripts-1.1.6-1.osg34.el6
osg-ce-3.4-2.osg34.el6
osg-ce-bosco-3.4-2.osg34.el6
osg-ce-condor-3.4-2.osg34.el6
osg-ce-lsf-3.4-2.osg34.el6
osg-ce-pbs-3.4-2.osg34.el6
osg-ce-sge-3.4-2.osg34.el6
osg-ce-slurm-3.4-2.osg34.el6
osg-configure-2.0.0-3.osg34.el6
osg-configure-bosco-2.0.0-3.osg34.el6
osg-configure-ce-2.0.0-3.osg34.el6
osg-configure-condor-2.0.0-3.osg34.el6
osg-configure-gateway-2.0.0-3.osg34.el6
osg-configure-gip-2.0.0-3.osg34.el6
osg-configure-gratia-2.0.0-3.osg34.el6
osg-configure-infoservices-2.0.0-3.osg34.el6
osg-configure-lsf-2.0.0-3.osg34.el6
osg-configure-managedfork-2.0.0-3.osg34.el6
osg-configure-misc-2.0.0-3.osg34.el6
osg-configure-network-2.0.0-3.osg34.el6
osg-configure-pbs-2.0.0-3.osg34.el6
osg-configure-rsv-2.0.0-3.osg34.el6
osg-configure-sge-2.0.0-3.osg34.el6
osg-configure-slurm-2.0.0-3.osg34.el6
osg-configure-squid-2.0.0-3.osg34.el6
osg-configure-tests-2.0.0-3.osg34.el6
osg-control-1.1.0-1.osg34.el6
osg-gridftp-3.4-2.osg34.el6
osg-gridftp-xrootd-3.4-1.osg34.el6
osg-gums-config-73-1.osg34.el6
osg-htcondor-ce-3.4-2.osg34.el6
osg-htcondor-ce-bosco-3.4-2.osg34.el6
osg-htcondor-ce-condor-3.4-2.osg34.el6
osg-htcondor-ce-lsf-3.4-2.osg34.el6
osg-htcondor-ce-pbs-3.4-2.osg34.el6
osg-htcondor-ce-sge-3.4-2.osg34.el6
osg-htcondor-ce-slurm-3.4-2.osg34.el6
osg-oasis-7-9.osg34.el6
osg-pki-tools-1.2.20-1.osg34.el6
osg-pki-tools-tests-1.2.20-1.osg34.el6
osg-system-profiler-1.4.0-1.osg34.el6
osg-system-profiler-viewer-1.4.0-1.osg34.el6
osg-test-1.10.1-1.osg34.el6
osg-tested-internal-3.4-2.osg34.el6
osg-test-log-viewer-1.10.1-1.osg34.el6
osg-update-data-1.4.0-1.osg34.el6
osg-update-vos-1.4.0-1.osg34.el6
osg-version-3.4.0-1.osg34.el6
osg-vo-map-0.0.2-1.osg34.el6
osg-wn-client-3.4-1.osg34.el6
owamp-3.2rc4-2.osg34.el6
owamp-client-3.2rc4-2.osg34.el6
owamp-debuginfo-3.2rc4-2.osg34.el6
owamp-server-3.2rc4-2.osg34.el6
pegasus-4.7.4-1.1.osg34.el6
pegasus-debuginfo-4.7.4-1.1.osg34.el6
rsv-3.14.0-2.osg34.el6
rsv-consumers-3.14.0-2.osg34.el6
rsv-core-3.14.0-2.osg34.el6
rsv-gwms-tester-1.1.2-1.osg34.el6
rsv-metrics-3.14.0-2.osg34.el6
uberftp-2.8-2.1.osg34.el6
uberftp-debuginfo-2.8-2.1.osg34.el6
vo-client-73-1.osg34.el6
vo-client-edgmkgridmap-73-1.osg34.el6
vo-client-lcmaps-voms-73-1.osg34.el6
voms-2.0.14-1.3.osg34.el6
voms-clients-cpp-2.0.14-1.3.osg34.el6
voms-debuginfo-2.0.14-1.3.osg34.el6
voms-devel-2.0.14-1.3.osg34.el6
voms-doc-2.0.14-1.3.osg34.el6
voms-server-2.0.14-1.3.osg34.el6
xacml-1.5.0-1.osg34.el6
xacml-debuginfo-1.5.0-1.osg34.el6
xacml-devel-1.5.0-1.osg34.el6
xrootd-4.6.1-1.osg34.el6
xrootd-client-4.6.1-1.osg34.el6
xrootd-client-devel-4.6.1-1.osg34.el6
xrootd-client-libs-4.6.1-1.osg34.el6
xrootd-debuginfo-4.6.1-1.osg34.el6
xrootd-devel-4.6.1-1.osg34.el6
xrootd-doc-4.6.1-1.osg34.el6
xrootd-dsi-3.0.4-22.osg34.el6
xrootd-dsi-debuginfo-3.0.4-22.osg34.el6
xrootd-fuse-4.6.1-1.osg34.el6
xrootd-lcmaps-1.2.1-2.osg34.el6
xrootd-lcmaps-debuginfo-1.2.1-2.osg34.el6
xrootd-libs-4.6.1-1.osg34.el6
xrootd-private-devel-4.6.1-1.osg34.el6
xrootd-python-4.6.1-1.osg34.el6
xrootd-selinux-4.6.1-1.osg34.el6
xrootd-server-4.6.1-1.osg34.el6
xrootd-server-devel-4.6.1-1.osg34.el6
xrootd-server-libs-4.6.1-1.osg34.el6
xrootd-voms-plugin-0.4.0-1.osg34.el6
xrootd-voms-plugin-debuginfo-0.4.0-1.osg34.el6
xrootd-voms-plugin-devel-0.4.0-1.osg34.el6
```

#### Enterprise Linux 7

``` file
autopyfactory-2.4.6-4.osg34.el7
autopyfactory-cloud-2.4.6-4.osg34.el7
autopyfactory-common-2.4.6-4.osg34.el7
autopyfactory-panda-2.4.6-4.osg34.el7
autopyfactory-plugins-cloud-2.4.6-4.osg34.el7
autopyfactory-plugins-local-2.4.6-4.osg34.el7
autopyfactory-plugins-monitor-2.4.6-4.osg34.el7
autopyfactory-plugins-panda-2.4.6-4.osg34.el7
autopyfactory-plugins-remote-2.4.6-4.osg34.el7
autopyfactory-plugins-scheds-2.4.6-4.osg34.el7
autopyfactory-proxymanager-2.4.6-4.osg34.el7
autopyfactory-remote-2.4.6-4.osg34.el7
autopyfactory-wms-2.4.6-4.osg34.el7
blahp-1.18.29.bosco-3.osg34.el7
blahp-debuginfo-1.18.29.bosco-3.osg34.el7
bwctl-1.4-7.osg34.el7
bwctl-client-1.4-7.osg34.el7
bwctl-debuginfo-1.4-7.osg34.el7
bwctl-devel-1.4-7.osg34.el7
bwctl-server-1.4-7.osg34.el7
cctools-4.4.3-1.osg34.el7
cctools-chirp-4.4.3-1.osg34.el7
cctools-debuginfo-4.4.3-1.osg34.el7
cctools-doc-4.4.3-1.osg34.el7
cctools-dttools-4.4.3-1.osg34.el7
cctools-makeflow-4.4.3-1.osg34.el7
cctools-parrot-4.4.3-1.osg34.el7
cctools-resource_monitor-4.4.3-1.osg34.el7
cctools-sand-4.4.3-1.osg34.el7
cctools-wavefront-4.4.3-1.osg34.el7
cctools-weaver-4.4.3-1.osg34.el7
cctools-work_queue-4.4.3-1.osg34.el7
condor-8.6.3-1.1.osg34.el7
condor-all-8.6.3-1.1.osg34.el7
condor-bosco-8.6.3-1.1.osg34.el7
condor-classads-8.6.3-1.1.osg34.el7
condor-classads-devel-8.6.3-1.1.osg34.el7
condor-cream-gahp-8.6.3-1.1.osg34.el7
condor-cron-1.1.1-2.osg34.el7
condor-debuginfo-8.6.3-1.1.osg34.el7
condor-kbdd-8.6.3-1.1.osg34.el7
condor-procd-8.6.3-1.1.osg34.el7
condor-python-8.6.3-1.1.osg34.el7
condor-test-8.6.3-1.1.osg34.el7
condor-vm-gahp-8.6.3-1.1.osg34.el7
cvmfs-2.3.5-1.osg34.el7
cvmfs-config-osg-2.0-2.osg34.el7
cvmfs-devel-2.3.5-1.osg34.el7
cvmfs-server-2.3.5-1.osg34.el7
cvmfs-unittests-2.3.5-1.osg34.el7
cvmfs-x509-helper-1.0-1.osg34.el7
cvmfs-x509-helper-debuginfo-1.0-1.osg34.el7
frontier-squid-3.5.24-3.1.osg34.el7
frontier-squid-debuginfo-3.5.24-3.1.osg34.el7
glideinwms-3.2.19-2.osg34.el7
glideinwms-common-tools-3.2.19-2.osg34.el7
glideinwms-condor-common-config-3.2.19-2.osg34.el7
glideinwms-factory-3.2.19-2.osg34.el7
glideinwms-factory-condor-3.2.19-2.osg34.el7
glideinwms-glidecondor-tools-3.2.19-2.osg34.el7
glideinwms-libs-3.2.19-2.osg34.el7
glideinwms-minimal-condor-3.2.19-2.osg34.el7
glideinwms-usercollector-3.2.19-2.osg34.el7
glideinwms-userschedd-3.2.19-2.osg34.el7
glideinwms-vofrontend-3.2.19-2.osg34.el7
glideinwms-vofrontend-standalone-3.2.19-2.osg34.el7
glite-build-common-cpp-3.3.0.2-1.osg34.el7
glite-ce-cream-client-api-c-1.15.4-2.3.osg34.el7
glite-ce-cream-client-devel-1.15.4-2.3.osg34.el7
glite-ce-wsdl-1.15.1-1.1.osg34.el7
glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg34.el7
glite-lbjp-common-gsoap-plugin-debuginfo-3.2.12-1.1.osg34.el7
glite-lbjp-common-gsoap-plugin-devel-3.2.12-1.1.osg34.el7
globus-ftp-client-8.29-1.1.osg34.el7
globus-ftp-client-debuginfo-8.29-1.1.osg34.el7
globus-ftp-client-devel-8.29-1.1.osg34.el7
globus-ftp-client-doc-8.29-1.1.osg34.el7
globus-gridftp-osg-extensions-0.3-2.osg34.el7
globus-gridftp-osg-extensions-debuginfo-0.3-2.osg34.el7
globus-gridftp-server-11.8-1.1.osg34.el7
globus-gridftp-server-control-4.1-1.3.osg34.el7
globus-gridftp-server-control-debuginfo-4.1-1.3.osg34.el7
globus-gridftp-server-control-devel-4.1-1.3.osg34.el7
globus-gridftp-server-debuginfo-11.8-1.1.osg34.el7
globus-gridftp-server-devel-11.8-1.1.osg34.el7
globus-gridftp-server-progs-11.8-1.1.osg34.el7
gratia-probe-1.17.5-1.osg34.el7
gratia-probe-bdii-status-1.17.5-1.osg34.el7
gratia-probe-common-1.17.5-1.osg34.el7
gratia-probe-condor-1.17.5-1.osg34.el7
gratia-probe-condor-events-1.17.5-1.osg34.el7
gratia-probe-dcache-storage-1.17.5-1.osg34.el7
gratia-probe-dcache-storagegroup-1.17.5-1.osg34.el7
gratia-probe-dcache-transfer-1.17.5-1.osg34.el7
gratia-probe-debuginfo-1.17.5-1.osg34.el7
gratia-probe-enstore-storage-1.17.5-1.osg34.el7
gratia-probe-enstore-tapedrive-1.17.5-1.osg34.el7
gratia-probe-enstore-transfer-1.17.5-1.osg34.el7
gratia-probe-glexec-1.17.5-1.osg34.el7
gratia-probe-glideinwms-1.17.5-1.osg34.el7
gratia-probe-gram-1.17.5-1.osg34.el7
gratia-probe-gridftp-transfer-1.17.5-1.osg34.el7
gratia-probe-hadoop-storage-1.17.5-1.osg34.el7
gratia-probe-htcondor-ce-1.17.5-1.osg34.el7
gratia-probe-lsf-1.17.5-1.osg34.el7
gratia-probe-metric-1.17.5-1.osg34.el7
gratia-probe-onevm-1.17.5-1.osg34.el7
gratia-probe-pbs-lsf-1.17.5-1.osg34.el7
gratia-probe-services-1.17.5-1.osg34.el7
gratia-probe-sge-1.17.5-1.osg34.el7
gratia-probe-slurm-1.17.5-1.osg34.el7
gratia-probe-xrootd-storage-1.17.5-1.osg34.el7
gratia-probe-xrootd-transfer-1.17.5-1.osg34.el7
gsi-openssh-7.1p2f-1.2.osg34.el7
gsi-openssh-clients-7.1p2f-1.2.osg34.el7
gsi-openssh-debuginfo-7.1p2f-1.2.osg34.el7
gsi-openssh-server-7.1p2f-1.2.osg34.el7
htcondor-ce-2.2.0-1.osg34.el7
htcondor-ce-bosco-2.2.0-1.osg34.el7
htcondor-ce-client-2.2.0-1.osg34.el7
htcondor-ce-collector-2.2.0-1.osg34.el7
htcondor-ce-condor-2.2.0-1.osg34.el7
htcondor-ce-lsf-2.2.0-1.osg34.el7
htcondor-ce-pbs-2.2.0-1.osg34.el7
htcondor-ce-sge-2.2.0-1.osg34.el7
htcondor-ce-slurm-2.2.0-1.osg34.el7
htcondor-ce-view-2.2.0-1.osg34.el7
igtf-ca-certs-1.82-1.osg34.el7
javascriptrrd-1.1.1-1.osg34.el7
koji-1.11.0-1.5.osg34.el7
koji-builder-1.11.0-1.5.osg34.el7
koji-hub-1.11.0-1.5.osg34.el7
koji-hub-plugins-1.11.0-1.5.osg34.el7
koji-utils-1.11.0-1.5.osg34.el7
koji-vm-1.11.0-1.5.osg34.el7
koji-web-1.11.0-1.5.osg34.el7
lcas-lcmaps-gt4-interface-0.3.1-1.2.osg34.el7
lcas-lcmaps-gt4-interface-debuginfo-0.3.1-1.2.osg34.el7
lcmaps-1.6.6-1.6.osg34.el7
lcmaps-common-devel-1.6.6-1.6.osg34.el7
lcmaps-db-templates-1.6.6-1.6.osg34.el7
lcmaps-debuginfo-1.6.6-1.6.osg34.el7
lcmaps-devel-1.6.6-1.6.osg34.el7
lcmaps-plugins-basic-1.7.0-2.osg34.el7
lcmaps-plugins-basic-debuginfo-1.7.0-2.osg34.el7
lcmaps-plugins-basic-ldap-1.7.0-2.osg34.el7
lcmaps-plugins-scas-client-0.5.6-1.osg34.el7
lcmaps-plugins-scas-client-debuginfo-0.5.6-1.osg34.el7
lcmaps-plugins-verify-proxy-1.5.9-1.1.osg34.el7
lcmaps-plugins-verify-proxy-debuginfo-1.5.9-1.1.osg34.el7
lcmaps-plugins-voms-1.7.1-1.4.osg34.el7
lcmaps-plugins-voms-debuginfo-1.7.1-1.4.osg34.el7
lcmaps-without-gsi-1.6.6-1.6.osg34.el7
lcmaps-without-gsi-devel-1.6.6-1.6.osg34.el7
llrun-0.1.3-1.3.osg34.el7
llrun-debuginfo-0.1.3-1.3.osg34.el7
mash-0.5.22-3.osg34.el7
myproxy-6.1.18-1.4.osg34.el7
myproxy-admin-6.1.18-1.4.osg34.el7
myproxy-debuginfo-6.1.18-1.4.osg34.el7
myproxy-devel-6.1.18-1.4.osg34.el7
myproxy-doc-6.1.18-1.4.osg34.el7
myproxy-libs-6.1.18-1.4.osg34.el7
myproxy-server-6.1.18-1.4.osg34.el7
myproxy-voms-6.1.18-1.4.osg34.el7
nuttcp-6.1.2-1.osg34.el7
nuttcp-debuginfo-6.1.2-1.osg34.el7
osg-base-ce-3.4-2.osg34.el7
osg-base-ce-bosco-3.4-2.osg34.el7
osg-base-ce-condor-3.4-2.osg34.el7
osg-base-ce-lsf-3.4-2.osg34.el7
osg-base-ce-pbs-3.4-2.osg34.el7
osg-base-ce-sge-3.4-2.osg34.el7
osg-base-ce-slurm-3.4-2.osg34.el7
osg-build-1.10.0-1.osg34.el7
osg-build-base-1.10.0-1.osg34.el7
osg-build-koji-1.10.0-1.osg34.el7
osg-build-mock-1.10.0-1.osg34.el7
osg-build-tests-1.10.0-1.osg34.el7
osg-ca-certs-1.62-1.osg34.el7
osg-ca-certs-updater-1.4-1.osg34.el7
osg-ca-generator-1.2.0-1.osg34.el7
osg-ca-scripts-1.1.6-1.osg34.el7
osg-ce-3.4-2.osg34.el7
osg-ce-bosco-3.4-2.osg34.el7
osg-ce-condor-3.4-2.osg34.el7
osg-ce-lsf-3.4-2.osg34.el7
osg-ce-pbs-3.4-2.osg34.el7
osg-ce-sge-3.4-2.osg34.el7
osg-ce-slurm-3.4-2.osg34.el7
osg-configure-2.0.0-3.osg34.el7
osg-configure-bosco-2.0.0-3.osg34.el7
osg-configure-ce-2.0.0-3.osg34.el7
osg-configure-condor-2.0.0-3.osg34.el7
osg-configure-gateway-2.0.0-3.osg34.el7
osg-configure-gip-2.0.0-3.osg34.el7
osg-configure-gratia-2.0.0-3.osg34.el7
osg-configure-infoservices-2.0.0-3.osg34.el7
osg-configure-lsf-2.0.0-3.osg34.el7
osg-configure-managedfork-2.0.0-3.osg34.el7
osg-configure-misc-2.0.0-3.osg34.el7
osg-configure-network-2.0.0-3.osg34.el7
osg-configure-pbs-2.0.0-3.osg34.el7
osg-configure-rsv-2.0.0-3.osg34.el7
osg-configure-sge-2.0.0-3.osg34.el7
osg-configure-slurm-2.0.0-3.osg34.el7
osg-configure-squid-2.0.0-3.osg34.el7
osg-configure-tests-2.0.0-3.osg34.el7
osg-control-1.1.0-1.osg34.el7
osg-gridftp-3.4-2.osg34.el7
osg-gridftp-xrootd-3.4-1.osg34.el7
osg-gums-config-73-1.osg34.el7
osg-htcondor-ce-3.4-2.osg34.el7
osg-htcondor-ce-bosco-3.4-2.osg34.el7
osg-htcondor-ce-condor-3.4-2.osg34.el7
osg-htcondor-ce-lsf-3.4-2.osg34.el7
osg-htcondor-ce-pbs-3.4-2.osg34.el7
osg-htcondor-ce-sge-3.4-2.osg34.el7
osg-htcondor-ce-slurm-3.4-2.osg34.el7
osg-oasis-7-9.osg34.el7
osg-pki-tools-1.2.20-1.osg34.el7
osg-pki-tools-tests-1.2.20-1.osg34.el7
osg-system-profiler-1.4.0-1.osg34.el7
osg-system-profiler-viewer-1.4.0-1.osg34.el7
osg-test-1.10.1-1.osg34.el7
osg-tested-internal-3.4-2.osg34.el7
osg-test-log-viewer-1.10.1-1.osg34.el7
osg-update-data-1.4.0-1.osg34.el7
osg-update-vos-1.4.0-1.osg34.el7
osg-version-3.4.0-1.osg34.el7
osg-vo-map-0.0.2-1.osg34.el7
osg-wn-client-3.4-1.osg34.el7
owamp-3.2rc4-2.osg34.el7
owamp-client-3.2rc4-2.osg34.el7
owamp-debuginfo-3.2rc4-2.osg34.el7
owamp-server-3.2rc4-2.osg34.el7
pegasus-4.7.4-1.1.osg34.el7
pegasus-debuginfo-4.7.4-1.1.osg34.el7
rsv-3.14.0-2.osg34.el7
rsv-consumers-3.14.0-2.osg34.el7
rsv-core-3.14.0-2.osg34.el7
rsv-gwms-tester-1.1.2-1.osg34.el7
rsv-metrics-3.14.0-2.osg34.el7
stashcache-0.7-2.osg34.el7
stashcache-cache-server-0.7-2.osg34.el7
stashcache-daemon-0.7-2.osg34.el7
stashcache-origin-server-0.7-2.osg34.el7
uberftp-2.8-2.1.osg34.el7
uberftp-debuginfo-2.8-2.1.osg34.el7
vo-client-73-1.osg34.el7
vo-client-edgmkgridmap-73-1.osg34.el7
vo-client-lcmaps-voms-73-1.osg34.el7
voms-2.0.14-1.3.osg34.el7
voms-clients-cpp-2.0.14-1.3.osg34.el7
voms-debuginfo-2.0.14-1.3.osg34.el7
voms-devel-2.0.14-1.3.osg34.el7
voms-doc-2.0.14-1.3.osg34.el7
voms-server-2.0.14-1.3.osg34.el7
xacml-1.5.0-1.osg34.el7
xacml-debuginfo-1.5.0-1.osg34.el7
xacml-devel-1.5.0-1.osg34.el7
xrootd-4.6.1-1.osg34.el7
xrootd-client-4.6.1-1.osg34.el7
xrootd-client-devel-4.6.1-1.osg34.el7
xrootd-client-libs-4.6.1-1.osg34.el7
xrootd-debuginfo-4.6.1-1.osg34.el7
xrootd-devel-4.6.1-1.osg34.el7
xrootd-doc-4.6.1-1.osg34.el7
xrootd-dsi-3.0.4-22.osg34.el7
xrootd-dsi-debuginfo-3.0.4-22.osg34.el7
xrootd-fuse-4.6.1-1.osg34.el7
xrootd-lcmaps-1.3.3-3.osg34.el7
xrootd-lcmaps-debuginfo-1.3.3-3.osg34.el7
xrootd-libs-4.6.1-1.osg34.el7
xrootd-private-devel-4.6.1-1.osg34.el7
xrootd-python-4.6.1-1.osg34.el7
xrootd-selinux-4.6.1-1.osg34.el7
xrootd-server-4.6.1-1.osg34.el7
xrootd-server-devel-4.6.1-1.osg34.el7
xrootd-server-libs-4.6.1-1.osg34.el7
xrootd-voms-plugin-0.4.0-1.osg34.el7
xrootd-voms-plugin-debuginfo-0.4.0-1.osg34.el7
xrootd-voms-plugin-devel-0.4.0-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [glideinwms-3.3.2-2.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.3.2-2.osgup.el6)

#### Enterprise Linux 7

-   [glideinwms-3.3.2-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.3.2-2.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
glideinwms-3.3.2-2.osgup.el6
glideinwms-common-tools-3.3.2-2.osgup.el6
glideinwms-condor-common-config-3.3.2-2.osgup.el6
glideinwms-factory-3.3.2-2.osgup.el6
glideinwms-factory-condor-3.3.2-2.osgup.el6
glideinwms-glidecondor-tools-3.3.2-2.osgup.el6
glideinwms-libs-3.3.2-2.osgup.el6
glideinwms-minimal-condor-3.3.2-2.osgup.el6
glideinwms-usercollector-3.3.2-2.osgup.el6
glideinwms-userschedd-3.3.2-2.osgup.el6
glideinwms-vofrontend-3.3.2-2.osgup.el6
glideinwms-vofrontend-standalone-3.3.2-2.osgup.el6
```

#### Enterprise Linux 7

``` file
glideinwms-3.3.2-2.osgup.el7
glideinwms-common-tools-3.3.2-2.osgup.el7
glideinwms-condor-common-config-3.3.2-2.osgup.el7
glideinwms-factory-3.3.2-2.osgup.el7
glideinwms-factory-condor-3.3.2-2.osgup.el7
glideinwms-glidecondor-tools-3.3.2-2.osgup.el7
glideinwms-libs-3.3.2-2.osgup.el7
glideinwms-minimal-condor-3.3.2-2.osgup.el7
glideinwms-usercollector-3.3.2-2.osgup.el7
glideinwms-userschedd-3.3.2-2.osgup.el7
glideinwms-vofrontend-3.3.2-2.osgup.el7
glideinwms-vofrontend-standalone-3.3.2-2.osgup.el7
```

