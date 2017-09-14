OSG Software Release 3.3.15
===========================

**Release Date**: 2016-08-09

Summary of changes
------------------

This release contains:

-   CA Certificates based on [IGTF 1.76](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
-   Updated to [VO Package v67](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-67)
-   Implemented SLURM scalability enhancements in the BLAHP
-   Fixed a bug in the BLAHP where HTCondor could not remove a SLURM job
-   Enabled XRootD-HDFS to use native HDFS libraries if available
-   Added an extension to the GridFTP server to report space usage on the server
-   Fixed GUMS to properly display long Pool Account lists
-   Updated the RSV service will start even though its state file is corrupt
-   Updated GSI-OpenSSH from [5.7-4.3](http://grid.ncsa.illinois.edu/ssh/history.html) to [7.1p2f](https://github.com/globus/gsi-openssh/releases)
-   Updated voms-proxy-init to generate RFC compliant proxies by default
-   Configured voms-server for systemd startup in EL7
-   Added voms-admin-client for EL7
-   Updated to [HTCondor 8.5.6](https://lists.cs.wisc.edu/archive/htcondor-users/2016-August/msg00017.shtml) in the upcoming repository

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.15%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found in the [Release3](Documentation.Release3) area of the TWiki.

Known Issues
------------

-   On EL7, your version of voms-proxy-init may come from the voms-clients-java package; this version will continue to make legacy proxies by default. If you want the new behavior, install the voms-clients-cpp package and uninstall the voms-clients-java package.

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need [install the current OSG repositories](Documentation.Release3.YumRepositories#Install_OSG_Repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
[root@client ~] $ yum update
```

<span class="twiki-macro NOTE"></span> Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

<span class="twiki-macro NOTE"></span> Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](HelpProcedure).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.23.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.23.bosco-1.osg33.el6)
-   [globus-gridftp-osg-extensions-0.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.3-1.osg33.el6)
-   [globus-gridftp-server-7.20-1.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-7.20-1.3.osg33.el6)
-   [gridftp-hdfs-0.5.4-25.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-25.3.osg33.el6)
-   [gsi-openssh-7.1p2f-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gsi-openssh-7.1p2f-1.1.osg33.el6)
-   [gums-1.5.2-4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.2-4.osg33.el6)
-   [igtf-ca-certs-1.76-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.76-1.osg33.el6)
-   [osg-ca-certs-1.57-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.57-1.osg33.el6)
-   [osg-configure-1.4.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.4.2-1.osg33.el6)
-   [osg-version-3.3.15-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.15-1.osg33.el6)
-   [rsv-3.13.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.13.1-1.osg33.el6)
-   [rsv-perfsonar-1.1.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-perfsonar-1.1.3-1.osg33.el6)
-   [vo-client-67-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-67-1.osg33.el6)
-   [voms-2.0.12-3.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-2.0.12-3.3.osg33.el6)
-   [xrootd-dsi-3.0.4-20.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-dsi-3.0.4-20.osg33.el6)
-   [xrootd-hdfs-1.8.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.8.8-1.osg33.el6)

#### Enterprise Linux 7

-   [PyXML-0.8.4-29.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=PyXML-0.8.4-29.1.osg33.el7)
-   [blahp-1.18.23.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.23.bosco-1.osg33.el7)
-   [globus-gridftp-osg-extensions-0.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.3-1.osg33.el7)
-   [globus-gridftp-server-7.20-1.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-7.20-1.3.osg33.el7)
-   [gridftp-hdfs-0.5.4-25.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-25.3.osg33.el7)
-   [gsi-openssh-7.1p2f-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gsi-openssh-7.1p2f-1.1.osg33.el7)
-   [gums-1.5.2-4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.2-4.osg33.el7)
-   [igtf-ca-certs-1.76-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.76-1.osg33.el7)
-   [osg-ca-certs-1.57-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.57-1.osg33.el7)
-   [osg-configure-1.4.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.4.2-1.osg33.el7)
-   [osg-version-3.3.15-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.15-1.osg33.el7)
-   [python-ZSI-2.0-6.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=python-ZSI-2.0-6.2.osg33.el7)
-   [rsv-3.13.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.13.1-1.osg33.el7)
-   [vo-client-67-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-67-1.osg33.el7)
-   [voms-2.0.12-3.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-2.0.12-3.3.osg33.el7)
-   [voms-admin-client-2.0.17-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=voms-admin-client-2.0.17-1.1.osg33.el7)
-   [xrootd-dsi-3.0.4-20.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-dsi-3.0.4-20.osg33.el7)
-   [xrootd-hdfs-1.8.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.8.8-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo globus-gridftp-osg-extensions globus-gridftp-osg-extensions-debuginfo globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gridftp-hdfs gridftp-hdfs-debuginfo gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server gums gums-client gums-service igtf-ca-certs osg-ca-certs osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gums-config osg-version rsv rsv-consumers rsv-core rsv-metrics rsv-perfsonar vo-client vo-client-edgmkgridmap voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server xrootd-dsi xrootd-dsi-debuginfo xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.23.bosco-1.osg33.el6
blahp-debuginfo-1.18.23.bosco-1.osg33.el6
globus-gridftp-osg-extensions-0.3-1.osg33.el6
globus-gridftp-osg-extensions-debuginfo-0.3-1.osg33.el6
globus-gridftp-server-7.20-1.3.osg33.el6
globus-gridftp-server-debuginfo-7.20-1.3.osg33.el6
globus-gridftp-server-devel-7.20-1.3.osg33.el6
globus-gridftp-server-progs-7.20-1.3.osg33.el6
gridftp-hdfs-0.5.4-25.3.osg33.el6
gridftp-hdfs-debuginfo-0.5.4-25.3.osg33.el6
gsi-openssh-7.1p2f-1.1.osg33.el6
gsi-openssh-clients-7.1p2f-1.1.osg33.el6
gsi-openssh-debuginfo-7.1p2f-1.1.osg33.el6
gsi-openssh-server-7.1p2f-1.1.osg33.el6
gums-1.5.2-4.osg33.el6
gums-client-1.5.2-4.osg33.el6
gums-service-1.5.2-4.osg33.el6
igtf-ca-certs-1.76-1.osg33.el6
osg-ca-certs-1.57-1.osg33.el6
osg-configure-1.4.2-1.osg33.el6
osg-configure-bosco-1.4.2-1.osg33.el6
osg-configure-ce-1.4.2-1.osg33.el6
osg-configure-cemon-1.4.2-1.osg33.el6
osg-configure-condor-1.4.2-1.osg33.el6
osg-configure-gateway-1.4.2-1.osg33.el6
osg-configure-gip-1.4.2-1.osg33.el6
osg-configure-gratia-1.4.2-1.osg33.el6
osg-configure-infoservices-1.4.2-1.osg33.el6
osg-configure-lsf-1.4.2-1.osg33.el6
osg-configure-managedfork-1.4.2-1.osg33.el6
osg-configure-misc-1.4.2-1.osg33.el6
osg-configure-monalisa-1.4.2-1.osg33.el6
osg-configure-network-1.4.2-1.osg33.el6
osg-configure-pbs-1.4.2-1.osg33.el6
osg-configure-rsv-1.4.2-1.osg33.el6
osg-configure-sge-1.4.2-1.osg33.el6
osg-configure-slurm-1.4.2-1.osg33.el6
osg-configure-squid-1.4.2-1.osg33.el6
osg-configure-tests-1.4.2-1.osg33.el6
osg-gums-config-67-1.osg33.el6
osg-version-3.3.15-1.osg33.el6
rsv-3.13.1-1.osg33.el6
rsv-consumers-3.13.1-1.osg33.el6
rsv-core-3.13.1-1.osg33.el6
rsv-metrics-3.13.1-1.osg33.el6
rsv-perfsonar-1.1.3-1.osg33.el6
vo-client-67-1.osg33.el6
vo-client-edgmkgridmap-67-1.osg33.el6
voms-2.0.12-3.3.osg33.el6
voms-clients-cpp-2.0.12-3.3.osg33.el6
voms-debuginfo-2.0.12-3.3.osg33.el6
voms-devel-2.0.12-3.3.osg33.el6
voms-doc-2.0.12-3.3.osg33.el6
voms-server-2.0.12-3.3.osg33.el6
xrootd-dsi-3.0.4-20.osg33.el6
xrootd-dsi-debuginfo-3.0.4-20.osg33.el6
xrootd-hdfs-1.8.8-1.osg33.el6
xrootd-hdfs-debuginfo-1.8.8-1.osg33.el6
xrootd-hdfs-devel-1.8.8-1.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.23.bosco-1.osg33.el7
blahp-debuginfo-1.18.23.bosco-1.osg33.el7
globus-gridftp-osg-extensions-0.3-1.osg33.el7
globus-gridftp-osg-extensions-debuginfo-0.3-1.osg33.el7
globus-gridftp-server-7.20-1.3.osg33.el7
globus-gridftp-server-debuginfo-7.20-1.3.osg33.el7
globus-gridftp-server-devel-7.20-1.3.osg33.el7
globus-gridftp-server-progs-7.20-1.3.osg33.el7
gridftp-hdfs-0.5.4-25.3.osg33.el7
gridftp-hdfs-debuginfo-0.5.4-25.3.osg33.el7
gsi-openssh-7.1p2f-1.1.osg33.el7
gsi-openssh-clients-7.1p2f-1.1.osg33.el7
gsi-openssh-debuginfo-7.1p2f-1.1.osg33.el7
gsi-openssh-server-7.1p2f-1.1.osg33.el7
gums-1.5.2-4.osg33.el7
gums-client-1.5.2-4.osg33.el7
gums-service-1.5.2-4.osg33.el7
igtf-ca-certs-1.76-1.osg33.el7
osg-ca-certs-1.57-1.osg33.el7
osg-configure-1.4.2-1.osg33.el7
osg-configure-bosco-1.4.2-1.osg33.el7
osg-configure-ce-1.4.2-1.osg33.el7
osg-configure-cemon-1.4.2-1.osg33.el7
osg-configure-condor-1.4.2-1.osg33.el7
osg-configure-gateway-1.4.2-1.osg33.el7
osg-configure-gip-1.4.2-1.osg33.el7
osg-configure-gratia-1.4.2-1.osg33.el7
osg-configure-infoservices-1.4.2-1.osg33.el7
osg-configure-lsf-1.4.2-1.osg33.el7
osg-configure-managedfork-1.4.2-1.osg33.el7
osg-configure-misc-1.4.2-1.osg33.el7
osg-configure-monalisa-1.4.2-1.osg33.el7
osg-configure-network-1.4.2-1.osg33.el7
osg-configure-pbs-1.4.2-1.osg33.el7
osg-configure-rsv-1.4.2-1.osg33.el7
osg-configure-sge-1.4.2-1.osg33.el7
osg-configure-slurm-1.4.2-1.osg33.el7
osg-configure-squid-1.4.2-1.osg33.el7
osg-configure-tests-1.4.2-1.osg33.el7
osg-gums-config-67-1.osg33.el7
osg-version-3.3.15-1.osg33.el7
python-ZSI-2.0-6.2.osg33.el7
PyXML-0.8.4-29.1.osg33.el7
PyXML-debuginfo-0.8.4-29.1.osg33.el7
rsv-3.13.1-1.osg33.el7
rsv-consumers-3.13.1-1.osg33.el7
rsv-core-3.13.1-1.osg33.el7
rsv-metrics-3.13.1-1.osg33.el7
vo-client-67-1.osg33.el7
vo-client-edgmkgridmap-67-1.osg33.el7
voms-2.0.12-3.3.osg33.el7
voms-admin-client-2.0.17-1.1.osg33.el7
voms-clients-cpp-2.0.12-3.3.osg33.el7
voms-debuginfo-2.0.12-3.3.osg33.el7
voms-devel-2.0.12-3.3.osg33.el7
voms-doc-2.0.12-3.3.osg33.el7
voms-server-2.0.12-3.3.osg33.el7
xrootd-dsi-3.0.4-20.osg33.el7
xrootd-dsi-debuginfo-3.0.4-20.osg33.el7
xrootd-hdfs-1.8.8-1.osg33.el7
xrootd-hdfs-debuginfo-1.8.8-1.osg33.el7
xrootd-hdfs-devel-1.8.8-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.23.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.23.bosco-1.osgup.el6)
-   [condor-8.5.6-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.6-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.23.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.23.bosco-1.osgup.el7)
-   [condor-8.5.6-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.6-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.23.bosco-1.osgup.el6
blahp-debuginfo-1.18.23.bosco-1.osgup.el6
condor-8.5.6-1.osgup.el6
condor-all-8.5.6-1.osgup.el6
condor-bosco-8.5.6-1.osgup.el6
condor-classads-8.5.6-1.osgup.el6
condor-classads-devel-8.5.6-1.osgup.el6
condor-cream-gahp-8.5.6-1.osgup.el6
condor-debuginfo-8.5.6-1.osgup.el6
condor-kbdd-8.5.6-1.osgup.el6
condor-procd-8.5.6-1.osgup.el6
condor-python-8.5.6-1.osgup.el6
condor-std-universe-8.5.6-1.osgup.el6
condor-test-8.5.6-1.osgup.el6
condor-vm-gahp-8.5.6-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.23.bosco-1.osgup.el7
blahp-debuginfo-1.18.23.bosco-1.osgup.el7
condor-8.5.6-1.osgup.el7
condor-all-8.5.6-1.osgup.el7
condor-bosco-8.5.6-1.osgup.el7
condor-classads-8.5.6-1.osgup.el7
condor-classads-devel-8.5.6-1.osgup.el7
condor-debuginfo-8.5.6-1.osgup.el7
condor-kbdd-8.5.6-1.osgup.el7
condor-procd-8.5.6-1.osgup.el7
condor-python-8.5.6-1.osgup.el7
condor-test-8.5.6-1.osgup.el7
condor-vm-gahp-8.5.6-1.osgup.el7
```

