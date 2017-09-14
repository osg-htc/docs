OSG Software Release 3.3.18
===========================

**Release Date**: 2016-11-08

Summary of changes
------------------

This release contains:

-   [GlideinWMS 3.2.16](http://glideinwms.fnal.gov/doc.v3_2_16/history.html)
    -   Enhancements
        -   able to specify the BOSCO user in the frontend
        -   can start a glidein manually
    -   Bug fixes
        -   correction of some job counters
        -   more resiliency in the communication with the HTCondor daemons
-   SSLv3 is disabled on the following Globus tools
    -   GRAM gatekeeper
    -   GridFTP server
    -   MyProxy
    -   gsissh
-   Globus GridFTP server control patch: Avoid server process hang when client immediately closes a new connection
-   edg-mkgridmap 4.0.4: fix simple omission that caused fatal errors on EL7 (worked fine on EL6)
-   PKI tools now generate Certificate Signing Requests using SHA2
-   Fix blahp qstat call to support torque-4.2.9
-   Blahp: Fix crash when using glexec and limited proxies
-   Augment Gratia PBS probe to process "exec\_host" when "ALLPROCS" flag is present, to accurately account for resource utilization
-   [HTCondor-CE 2.0.11](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.0.11): Minor fixes
    -   Accept all DaemonCore options in htcondor-ce-view
    -   Fix incorrect comment in htcondor-ce-pbs template config
-   GridFTP server script now returns correct value when the service isn't running
-   Add htcondor-ce-view test to the automated test suite

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.18%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   On EL7, your version of voms-proxy-init may come from the voms-clients-java package; this version will continue to make legacy proxies by default. If you want the new behavior, install the voms-clients-cpp package and uninstall the voms-clients-java package.

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
[root@client ~] $ yum update
```

<span class="twiki-macro NOTE"></span> Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

<span class="twiki-macro NOTE"></span> Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.28.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.28.bosco-1.osg33.el6)
-   [edg-mkgridmap-4.0.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=edg-mkgridmap-4.0.4-1.osg33.el6)
-   [glideinwms-3.2.16-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.16-1.osg33.el6)
-   [globus-gatekeeper-10.10-1.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gatekeeper-10.10-1.3.osg33.el6)
-   [globus-gridftp-server-10.4-1.4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-10.4-1.4.osg33.el6)
-   [globus-gridftp-server-control-4.1-1.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-4.1-1.3.osg33.el6)
-   [gratia-probe-1.17.0-2.5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.0-2.5.osg33.el6)
-   [gsi-openssh-7.1p2f-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gsi-openssh-7.1p2f-1.2.osg33.el6)
-   [htcondor-ce-2.0.11-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.11-1.osg33.el6)
-   [myproxy-6.1.18-1.3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=myproxy-6.1.18-1.3.osg33.el6)
-   [osg-pki-tools-1.2.20-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.20-1.osg33.el6)
-   [osg-test-1.9.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.9.1-1.osg33.el6)
-   [osg-tested-internal-3.3-16.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-16.osg33.el6)
-   [osg-version-3.3.18-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.18-1.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.28.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.28.bosco-1.osg33.el7)
-   [edg-mkgridmap-4.0.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=edg-mkgridmap-4.0.4-1.osg33.el7)
-   [glideinwms-3.2.16-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.16-1.osg33.el7)
-   [globus-gatekeeper-10.10-1.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gatekeeper-10.10-1.3.osg33.el7)
-   [globus-gridftp-server-10.4-1.4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-10.4-1.4.osg33.el7)
-   [globus-gridftp-server-control-4.1-1.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-4.1-1.3.osg33.el7)
-   [gratia-probe-1.17.0-2.5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.0-2.5.osg33.el7)
-   [gsi-openssh-7.1p2f-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gsi-openssh-7.1p2f-1.2.osg33.el7)
-   [htcondor-ce-2.0.11-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.11-1.osg33.el7)
-   [myproxy-6.1.18-1.3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=myproxy-6.1.18-1.3.osg33.el7)
-   [osg-pki-tools-1.2.20-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.20-1.osg33.el7)
-   [osg-test-1.9.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.9.1-1.osg33.el7)
-   [osg-tested-internal-3.3-16.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-16.osg33.el7)
-   [osg-version-3.3.18-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.18-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo edg-mkgridmap glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone globus-gatekeeper globus-gatekeeper-debuginfo globus-gridftp-server globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-view igtf-ca-certs myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-ca-certs osg-pki-tools osg-pki-tools-tests osg-test osg-tested-internal osg-tested-internal-gram osg-version

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.28.bosco-1.osg33.el6
blahp-debuginfo-1.18.28.bosco-1.osg33.el6
edg-mkgridmap-4.0.4-1.osg33.el6
glideinwms-3.2.16-1.osg33.el6
glideinwms-common-tools-3.2.16-1.osg33.el6
glideinwms-condor-common-config-3.2.16-1.osg33.el6
glideinwms-factory-3.2.16-1.osg33.el6
glideinwms-factory-condor-3.2.16-1.osg33.el6
glideinwms-glidecondor-tools-3.2.16-1.osg33.el6
glideinwms-libs-3.2.16-1.osg33.el6
glideinwms-minimal-condor-3.2.16-1.osg33.el6
glideinwms-usercollector-3.2.16-1.osg33.el6
glideinwms-userschedd-3.2.16-1.osg33.el6
glideinwms-vofrontend-3.2.16-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.16-1.osg33.el6
globus-gatekeeper-10.10-1.3.osg33.el6
globus-gatekeeper-debuginfo-10.10-1.3.osg33.el6
globus-gridftp-server-10.4-1.4.osg33.el6
globus-gridftp-server-control-4.1-1.3.osg33.el6
globus-gridftp-server-control-debuginfo-4.1-1.3.osg33.el6
globus-gridftp-server-control-devel-4.1-1.3.osg33.el6
globus-gridftp-server-debuginfo-10.4-1.4.osg33.el6
globus-gridftp-server-devel-10.4-1.4.osg33.el6
globus-gridftp-server-progs-10.4-1.4.osg33.el6
gratia-probe-1.17.0-2.5.osg33.el6
gratia-probe-bdii-status-1.17.0-2.5.osg33.el6
gratia-probe-common-1.17.0-2.5.osg33.el6
gratia-probe-condor-1.17.0-2.5.osg33.el6
gratia-probe-condor-events-1.17.0-2.5.osg33.el6
gratia-probe-dcache-storage-1.17.0-2.5.osg33.el6
gratia-probe-dcache-storagegroup-1.17.0-2.5.osg33.el6
gratia-probe-dcache-transfer-1.17.0-2.5.osg33.el6
gratia-probe-debuginfo-1.17.0-2.5.osg33.el6
gratia-probe-enstore-storage-1.17.0-2.5.osg33.el6
gratia-probe-enstore-tapedrive-1.17.0-2.5.osg33.el6
gratia-probe-enstore-transfer-1.17.0-2.5.osg33.el6
gratia-probe-glexec-1.17.0-2.5.osg33.el6
gratia-probe-glideinwms-1.17.0-2.5.osg33.el6
gratia-probe-gram-1.17.0-2.5.osg33.el6
gratia-probe-gridftp-transfer-1.17.0-2.5.osg33.el6
gratia-probe-hadoop-storage-1.17.0-2.5.osg33.el6
gratia-probe-htcondor-ce-1.17.0-2.5.osg33.el6
gratia-probe-lsf-1.17.0-2.5.osg33.el6
gratia-probe-metric-1.17.0-2.5.osg33.el6
gratia-probe-onevm-1.17.0-2.5.osg33.el6
gratia-probe-pbs-lsf-1.17.0-2.5.osg33.el6
gratia-probe-services-1.17.0-2.5.osg33.el6
gratia-probe-sge-1.17.0-2.5.osg33.el6
gratia-probe-slurm-1.17.0-2.5.osg33.el6
gratia-probe-xrootd-storage-1.17.0-2.5.osg33.el6
gratia-probe-xrootd-transfer-1.17.0-2.5.osg33.el6
gsi-openssh-7.1p2f-1.2.osg33.el6
gsi-openssh-clients-7.1p2f-1.2.osg33.el6
gsi-openssh-debuginfo-7.1p2f-1.2.osg33.el6
gsi-openssh-server-7.1p2f-1.2.osg33.el6
htcondor-ce-2.0.11-1.osg33.el6
htcondor-ce-bosco-2.0.11-1.osg33.el6
htcondor-ce-client-2.0.11-1.osg33.el6
htcondor-ce-collector-2.0.11-1.osg33.el6
htcondor-ce-condor-2.0.11-1.osg33.el6
htcondor-ce-lsf-2.0.11-1.osg33.el6
htcondor-ce-pbs-2.0.11-1.osg33.el6
htcondor-ce-sge-2.0.11-1.osg33.el6
htcondor-ce-view-2.0.11-1.osg33.el6
myproxy-6.1.18-1.3.osg33.el6
myproxy-admin-6.1.18-1.3.osg33.el6
myproxy-debuginfo-6.1.18-1.3.osg33.el6
myproxy-devel-6.1.18-1.3.osg33.el6
myproxy-doc-6.1.18-1.3.osg33.el6
myproxy-libs-6.1.18-1.3.osg33.el6
myproxy-server-6.1.18-1.3.osg33.el6
myproxy-voms-6.1.18-1.3.osg33.el6
osg-pki-tools-1.2.20-1.osg33.el6
osg-pki-tools-tests-1.2.20-1.osg33.el6
osg-test-1.9.1-1.osg33.el6
osg-tested-internal-3.3-16.osg33.el6
osg-tested-internal-gram-3.3-16.osg33.el6
osg-version-3.3.18-1.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.28.bosco-1.osg33.el7
blahp-debuginfo-1.18.28.bosco-1.osg33.el7
edg-mkgridmap-4.0.4-1.osg33.el7
glideinwms-3.2.16-1.osg33.el7
glideinwms-common-tools-3.2.16-1.osg33.el7
glideinwms-condor-common-config-3.2.16-1.osg33.el7
glideinwms-factory-3.2.16-1.osg33.el7
glideinwms-factory-condor-3.2.16-1.osg33.el7
glideinwms-glidecondor-tools-3.2.16-1.osg33.el7
glideinwms-libs-3.2.16-1.osg33.el7
glideinwms-minimal-condor-3.2.16-1.osg33.el7
glideinwms-usercollector-3.2.16-1.osg33.el7
glideinwms-userschedd-3.2.16-1.osg33.el7
glideinwms-vofrontend-3.2.16-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.16-1.osg33.el7
globus-gatekeeper-10.10-1.3.osg33.el7
globus-gatekeeper-debuginfo-10.10-1.3.osg33.el7
globus-gridftp-server-10.4-1.4.osg33.el7
globus-gridftp-server-control-4.1-1.3.osg33.el7
globus-gridftp-server-control-debuginfo-4.1-1.3.osg33.el7
globus-gridftp-server-control-devel-4.1-1.3.osg33.el7
globus-gridftp-server-debuginfo-10.4-1.4.osg33.el7
globus-gridftp-server-devel-10.4-1.4.osg33.el7
globus-gridftp-server-progs-10.4-1.4.osg33.el7
gratia-probe-1.17.0-2.5.osg33.el7
gratia-probe-bdii-status-1.17.0-2.5.osg33.el7
gratia-probe-common-1.17.0-2.5.osg33.el7
gratia-probe-condor-1.17.0-2.5.osg33.el7
gratia-probe-condor-events-1.17.0-2.5.osg33.el7
gratia-probe-dcache-storage-1.17.0-2.5.osg33.el7
gratia-probe-dcache-storagegroup-1.17.0-2.5.osg33.el7
gratia-probe-dcache-transfer-1.17.0-2.5.osg33.el7
gratia-probe-debuginfo-1.17.0-2.5.osg33.el7
gratia-probe-enstore-storage-1.17.0-2.5.osg33.el7
gratia-probe-enstore-tapedrive-1.17.0-2.5.osg33.el7
gratia-probe-enstore-transfer-1.17.0-2.5.osg33.el7
gratia-probe-glexec-1.17.0-2.5.osg33.el7
gratia-probe-glideinwms-1.17.0-2.5.osg33.el7
gratia-probe-gram-1.17.0-2.5.osg33.el7
gratia-probe-gridftp-transfer-1.17.0-2.5.osg33.el7
gratia-probe-hadoop-storage-1.17.0-2.5.osg33.el7
gratia-probe-htcondor-ce-1.17.0-2.5.osg33.el7
gratia-probe-lsf-1.17.0-2.5.osg33.el7
gratia-probe-metric-1.17.0-2.5.osg33.el7
gratia-probe-onevm-1.17.0-2.5.osg33.el7
gratia-probe-pbs-lsf-1.17.0-2.5.osg33.el7
gratia-probe-services-1.17.0-2.5.osg33.el7
gratia-probe-sge-1.17.0-2.5.osg33.el7
gratia-probe-slurm-1.17.0-2.5.osg33.el7
gratia-probe-xrootd-storage-1.17.0-2.5.osg33.el7
gratia-probe-xrootd-transfer-1.17.0-2.5.osg33.el7
gsi-openssh-7.1p2f-1.2.osg33.el7
gsi-openssh-clients-7.1p2f-1.2.osg33.el7
gsi-openssh-debuginfo-7.1p2f-1.2.osg33.el7
gsi-openssh-server-7.1p2f-1.2.osg33.el7
htcondor-ce-2.0.11-1.osg33.el7
htcondor-ce-bosco-2.0.11-1.osg33.el7
htcondor-ce-client-2.0.11-1.osg33.el7
htcondor-ce-collector-2.0.11-1.osg33.el7
htcondor-ce-condor-2.0.11-1.osg33.el7
htcondor-ce-lsf-2.0.11-1.osg33.el7
htcondor-ce-pbs-2.0.11-1.osg33.el7
htcondor-ce-sge-2.0.11-1.osg33.el7
htcondor-ce-view-2.0.11-1.osg33.el7
myproxy-6.1.18-1.3.osg33.el7
myproxy-admin-6.1.18-1.3.osg33.el7
myproxy-debuginfo-6.1.18-1.3.osg33.el7
myproxy-devel-6.1.18-1.3.osg33.el7
myproxy-doc-6.1.18-1.3.osg33.el7
myproxy-libs-6.1.18-1.3.osg33.el7
myproxy-server-6.1.18-1.3.osg33.el7
myproxy-voms-6.1.18-1.3.osg33.el7
osg-pki-tools-1.2.20-1.osg33.el7
osg-pki-tools-tests-1.2.20-1.osg33.el7
osg-test-1.9.1-1.osg33.el7
osg-tested-internal-3.3-16.osg33.el7
osg-tested-internal-gram-3.3-16.osg33.el7
osg-version-3.3.18-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.28.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.28.bosco-1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.28.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.28.bosco-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.28.bosco-1.osgup.el6
blahp-debuginfo-1.18.28.bosco-1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.28.bosco-1.osgup.el7
blahp-debuginfo-1.18.28.bosco-1.osgup.el7
```

