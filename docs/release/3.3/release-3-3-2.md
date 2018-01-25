OSG Software Release 3.3.2
==========================

**Release Date**: 2015-10-13

Summary of changes
------------------

This release contains:

-   [GlideinWMS 3.2.11.2](http://glideinwms.fnal.gov/doc.prd/history.html)
-   [XRootD 4.2.3](https://github.com/xrootd/xrootd/blob/v4.2.3/docs/ReleaseNotes.txt)
-   [HTCondor 8.4.0](https://www-auth.cs.wisc.edu/lists/htcondor-users/2015-September/msg00029.shtml)
-   StashCache 0.6
    -   daemon refuses to start if host certificate is not present
    -   use FQDN in stashcache-daemon
-   GUMS 1.5.1
    -   Return groupName for pool account mappers
    -   Bug fixes
-   HTCondor-CE 1.16
    -   Updates for PBS variants
    -   Add CERN host DN format to HTCondor-CE configuration defaults
-   GIP support multiple SLURM queues
-   osg-configure 1.2.2
    -   Support IPv6 IP addresses in configuration files
    -   Add sensible default values for Allowed VOs
-   RSV - srmcp-srm-probe (delays to account for NFS caching behavior)
-   Add lcmaps-plugins-mount-under-scratch package
-   Update to edg-mkgridmap 4.0.3, so it works on EL 7
-   CA certificates based on [IGTF 1.68](https://dist.eugridpma.info/distribution/igtf/current/CHANGES)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.2%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   HTCondor 8.4.0 has changed it's behavior in ways that cause the GlideinWMS frontend configuration to break. In order to correct this, the following setting needs to be added to the configuration file:

        :::file
        COLLECTOR_USES_SHARED_PORT = False

-   StashCache packages need to be manually configured
    -   Manual configuration for origin server
        -   Assuming that the origin server connects only to a redirector (not directly to cache server), minimal xrootd configuration is required. The configuration file, /etc/xrootd/xrootd-stashcache-origin-server.cfg, in this release is overkill. Here are recommended settings to use:

                :::file
                xrd.port 1094
                all.role server
                all.manager stash-redirector.example.com 1213
                all.export / nostage
                xrootd.trace emsg login stall redirect
                ofs.trace none
                xrd.trace conn
                cms.trace all
                sec.protocol  host
                sec.protbind  * none
                all.adminpath /var/run/xrootd
                all.pidpath /var/run/xrootd

-   Manual configuration for cache server
    -   In contrast to the origin server configuration, one needs to declare `pss.origin <stash-redirector.example.com>` instead of configuring the cmsd or manager (only the xrootd daemon is required on the cache server). More detailed configuration of cache server for StashCache is [here](http://opensciencegrid.github.io/StashCache/admin/configure-cache/).
-   In both cases, administrator needs to set the path of custom configuration file for its xrootd/cmds instance in /etc/sysconfig/xrootd, For example, change the cmds default from:

        :::file
        CMSD_DEFAULT_OPTIONS="-l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-clustered.cfg -k fifo"
<br/>

    to

        :::file
        CMSD_DEFAULT_OPTIONS="-l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-stashcache-origin-server.marian -k fifo" 

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
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [bestman2-2.3.0-26.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=bestman2-2.3.0-26.osg33.el6)
-   [blahp-1.18.14.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.14.bosco-1.osg33.el6)
-   [condor-8.4.0-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.0-1.2.osg33.el6)
-   [edg-mkgridmap-4.0.3-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=edg-mkgridmap-4.0.3-2.osg33.el6)
-   [gip-1.3.11-7.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gip-1.3.11-7.osg33.el6)
-   [glideinwms-3.2.11.2-4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.11.2-4.osg33.el6)
-   [gridftp-hdfs-0.5.4-22.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gridftp-hdfs-0.5.4-22.osg33.el6)
-   [gums-1.5.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.1-1.osg33.el6)
-   [htcondor-ce-1.16-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-1.16-1.osg33.el6)
-   [igtf-ca-certs-1.68-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.68-1.osg33.el6)
-   [jglobus-2.1.0-5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=jglobus-2.1.0-5.osg33.el6)
-   [lcmaps-plugins-mount-under-scratch-0.0.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=lcmaps-plugins-mount-under-scratch-0.0.4-1.osg33.el6)
-   [osg-ca-certs-1.49-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.49-1.osg33.el6)
-   [osg-configure-1.2.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.2.2-1.osg33.el6)
-   [osg-test-1.4.30-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.4.30-1.osg33.el6)
-   [osg-tested-internal-3.3-5.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-5.osg33.el6)
-   [osg-version-3.3.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.2-1.osg33.el6)
-   [privilege-xacml-2.6.5-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=privilege-xacml-2.6.5-1.osg33.el6)
-   [rsv-3.10.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.10.4-1.osg33.el6)
-   [stashcache-0.6-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=stashcache-0.6-1.osg33.el6)
-   [xrootd-4.2.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.2.3-1.osg33.el6)

#### Enterprise Linux 7

-   [axis-1.4-23.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=axis-1.4-23.1.osg33.el7)
-   [blahp-1.18.14.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.14.bosco-1.osg33.el7)
-   [condor-8.4.0-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.0-1.2.osg33.el7)
-   [edg-mkgridmap-4.0.3-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=edg-mkgridmap-4.0.3-2.osg33.el7)
-   [gip-1.3.11-7.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gip-1.3.11-7.osg33.el7)
-   [glideinwms-3.2.11.2-4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.11.2-4.osg33.el7)
-   [htcondor-ce-1.16-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-1.16-1.osg33.el7)
-   [igtf-ca-certs-1.68-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.68-1.osg33.el7)
-   [javamail-1.5.0-6.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=javamail-1.5.0-6.osg33.el7)
-   [lcmaps-plugins-mount-under-scratch-0.0.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=lcmaps-plugins-mount-under-scratch-0.0.4-1.osg33.el7)
-   [osg-ca-certs-1.49-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.49-1.osg33.el7)
-   [osg-configure-1.2.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.2.2-1.osg33.el7)
-   [osg-test-1.4.30-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.4.30-1.osg33.el7)
-   [osg-tested-internal-3.3-5.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-5.osg33.el7)
-   [osg-version-3.3.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.2-1.osg33.el7)
-   [rsv-3.10.4-1\_clipped.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-3.10.4-1_clipped.osg33.el7)
-   [stashcache-0.6-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=stashcache-0.6-1.osg33.el7)
-   [wsdl4j-1.6.3-3.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=wsdl4j-1.6.3-3.1.osg33.el7)
-   [xrootd-4.2.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-4.2.3-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    bestman2-client bestman2-client-libs bestman2-common-libs bestman2-server bestman2-server-dep-libs bestman2-server-libs bestman2-tester bestman2-tester-libs blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp edg-mkgridmap gip glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone gridftp-hdfs gridftp-hdfs-debuginfo gums gums-client gums-service htcondor-ce htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-debuginfo htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge igtf-ca-certs jglobus lcmaps-plugins-mount-under-scratch lcmaps-plugins-mount-under-scratch-debuginfo osg-ca-certs osg-configure osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-test osg-tested-internal osg-version privilege-xacml python-argparse python-backports-ssl_match_hostname python-requests python-urllib3 rsv rsv-consumers rsv-core rsv-metrics stashcache-cache-server stashcache-daemon stashcache-origin-server xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
bestman2-2.3.0-26.osg33.el6
bestman2-client-2.3.0-26.osg33.el6
bestman2-client-libs-2.3.0-26.osg33.el6
bestman2-common-libs-2.3.0-26.osg33.el6
bestman2-server-2.3.0-26.osg33.el6
bestman2-server-dep-libs-2.3.0-26.osg33.el6
bestman2-server-libs-2.3.0-26.osg33.el6
bestman2-tester-2.3.0-26.osg33.el6
bestman2-tester-libs-2.3.0-26.osg33.el6
blahp-1.18.14.bosco-1.osg33.el6
blahp-debuginfo-1.18.14.bosco-1.osg33.el6
condor-8.4.0-1.2.osg33.el6
condor-all-8.4.0-1.2.osg33.el6
condor-bosco-8.4.0-1.2.osg33.el6
condor-classads-8.4.0-1.2.osg33.el6
condor-classads-devel-8.4.0-1.2.osg33.el6
condor-cream-gahp-8.4.0-1.2.osg33.el6
condor-debuginfo-8.4.0-1.2.osg33.el6
condor-kbdd-8.4.0-1.2.osg33.el6
condor-procd-8.4.0-1.2.osg33.el6
condor-python-8.4.0-1.2.osg33.el6
condor-std-universe-8.4.0-1.2.osg33.el6
condor-test-8.4.0-1.2.osg33.el6
condor-vm-gahp-8.4.0-1.2.osg33.el6
edg-mkgridmap-4.0.3-2.osg33.el6
gip-1.3.11-7.osg33.el6
glideinwms-3.2.11.2-4.osg33.el6
glideinwms-common-tools-3.2.11.2-4.osg33.el6
glideinwms-condor-common-config-3.2.11.2-4.osg33.el6
glideinwms-factory-3.2.11.2-4.osg33.el6
glideinwms-factory-condor-3.2.11.2-4.osg33.el6
glideinwms-glidecondor-tools-3.2.11.2-4.osg33.el6
glideinwms-libs-3.2.11.2-4.osg33.el6
glideinwms-minimal-condor-3.2.11.2-4.osg33.el6
glideinwms-usercollector-3.2.11.2-4.osg33.el6
glideinwms-userschedd-3.2.11.2-4.osg33.el6
glideinwms-vofrontend-3.2.11.2-4.osg33.el6
glideinwms-vofrontend-standalone-3.2.11.2-4.osg33.el6
gridftp-hdfs-0.5.4-22.osg33.el6
gridftp-hdfs-debuginfo-0.5.4-22.osg33.el6
gums-1.5.1-1.osg33.el6
gums-client-1.5.1-1.osg33.el6
gums-service-1.5.1-1.osg33.el6
htcondor-ce-1.16-1.osg33.el6
htcondor-ce-client-1.16-1.osg33.el6
htcondor-ce-collector-1.16-1.osg33.el6
htcondor-ce-condor-1.16-1.osg33.el6
htcondor-ce-debuginfo-1.16-1.osg33.el6
htcondor-ce-lsf-1.16-1.osg33.el6
htcondor-ce-pbs-1.16-1.osg33.el6
htcondor-ce-sge-1.16-1.osg33.el6
igtf-ca-certs-1.68-1.osg33.el6
jglobus-2.1.0-5.osg33.el6
lcmaps-plugins-mount-under-scratch-0.0.4-1.osg33.el6
lcmaps-plugins-mount-under-scratch-debuginfo-0.0.4-1.osg33.el6
osg-ca-certs-1.49-1.osg33.el6
osg-configure-1.2.2-1.osg33.el6
osg-configure-ce-1.2.2-1.osg33.el6
osg-configure-cemon-1.2.2-1.osg33.el6
osg-configure-condor-1.2.2-1.osg33.el6
osg-configure-gateway-1.2.2-1.osg33.el6
osg-configure-gip-1.2.2-1.osg33.el6
osg-configure-gratia-1.2.2-1.osg33.el6
osg-configure-infoservices-1.2.2-1.osg33.el6
osg-configure-lsf-1.2.2-1.osg33.el6
osg-configure-managedfork-1.2.2-1.osg33.el6
osg-configure-misc-1.2.2-1.osg33.el6
osg-configure-monalisa-1.2.2-1.osg33.el6
osg-configure-network-1.2.2-1.osg33.el6
osg-configure-pbs-1.2.2-1.osg33.el6
osg-configure-rsv-1.2.2-1.osg33.el6
osg-configure-sge-1.2.2-1.osg33.el6
osg-configure-slurm-1.2.2-1.osg33.el6
osg-configure-squid-1.2.2-1.osg33.el6
osg-configure-tests-1.2.2-1.osg33.el6
osg-test-1.4.30-1.osg33.el6
osg-tested-internal-3.3-5.osg33.el6
osg-version-3.3.2-1.osg33.el6
privilege-xacml-2.6.5-1.osg33.el6
rsv-3.10.4-1.osg33.el6
rsv-consumers-3.10.4-1.osg33.el6
rsv-core-3.10.4-1.osg33.el6
rsv-metrics-3.10.4-1.osg33.el6
stashcache-0.6-1.osg33.el6
stashcache-cache-server-0.6-1.osg33.el6
stashcache-daemon-0.6-1.osg33.el6
stashcache-origin-server-0.6-1.osg33.el6
xrootd-4.2.3-1.osg33.el6
xrootd-client-4.2.3-1.osg33.el6
xrootd-client-devel-4.2.3-1.osg33.el6
xrootd-client-libs-4.2.3-1.osg33.el6
xrootd-debuginfo-4.2.3-1.osg33.el6
xrootd-devel-4.2.3-1.osg33.el6
xrootd-doc-4.2.3-1.osg33.el6
xrootd-fuse-4.2.3-1.osg33.el6
xrootd-libs-4.2.3-1.osg33.el6
xrootd-private-devel-4.2.3-1.osg33.el6
xrootd-python-4.2.3-1.osg33.el6
xrootd-selinux-4.2.3-1.osg33.el6
xrootd-server-4.2.3-1.osg33.el6
xrootd-server-devel-4.2.3-1.osg33.el6
xrootd-server-libs-4.2.3-1.osg33.el6
```

#### Enterprise Linux 7

``` file
axis-1.4-23.1.osg33.el7
axis-javadoc-1.4-23.1.osg33.el7
axis-manual-1.4-23.1.osg33.el7
blahp-1.18.14.bosco-1.osg33.el7
blahp-debuginfo-1.18.14.bosco-1.osg33.el7
condor-8.4.0-1.2.osg33.el7
condor-all-8.4.0-1.2.osg33.el7
condor-bosco-8.4.0-1.2.osg33.el7
condor-classads-8.4.0-1.2.osg33.el7
condor-classads-devel-8.4.0-1.2.osg33.el7
condor-debuginfo-8.4.0-1.2.osg33.el7
condor-kbdd-8.4.0-1.2.osg33.el7
condor-procd-8.4.0-1.2.osg33.el7
condor-python-8.4.0-1.2.osg33.el7
condor-test-8.4.0-1.2.osg33.el7
condor-vm-gahp-8.4.0-1.2.osg33.el7
edg-mkgridmap-4.0.3-2.osg33.el7
gip-1.3.11-7.osg33.el7
glideinwms-3.2.11.2-4.osg33.el7
glideinwms-common-tools-3.2.11.2-4.osg33.el7
glideinwms-condor-common-config-3.2.11.2-4.osg33.el7
glideinwms-factory-3.2.11.2-4.osg33.el7
glideinwms-factory-condor-3.2.11.2-4.osg33.el7
glideinwms-glidecondor-tools-3.2.11.2-4.osg33.el7
glideinwms-libs-3.2.11.2-4.osg33.el7
glideinwms-minimal-condor-3.2.11.2-4.osg33.el7
glideinwms-usercollector-3.2.11.2-4.osg33.el7
glideinwms-userschedd-3.2.11.2-4.osg33.el7
glideinwms-vofrontend-3.2.11.2-4.osg33.el7
glideinwms-vofrontend-standalone-3.2.11.2-4.osg33.el7
htcondor-ce-1.16-1.osg33.el7
htcondor-ce-client-1.16-1.osg33.el7
htcondor-ce-collector-1.16-1.osg33.el7
htcondor-ce-condor-1.16-1.osg33.el7
htcondor-ce-debuginfo-1.16-1.osg33.el7
htcondor-ce-lsf-1.16-1.osg33.el7
htcondor-ce-pbs-1.16-1.osg33.el7
htcondor-ce-sge-1.16-1.osg33.el7
igtf-ca-certs-1.68-1.osg33.el7
javamail-1.5.0-6.osg33.el7
javamail-javadoc-1.5.0-6.osg33.el7
lcmaps-plugins-mount-under-scratch-0.0.4-1.osg33.el7
lcmaps-plugins-mount-under-scratch-debuginfo-0.0.4-1.osg33.el7
osg-ca-certs-1.49-1.osg33.el7
osg-configure-1.2.2-1.osg33.el7
osg-configure-ce-1.2.2-1.osg33.el7
osg-configure-cemon-1.2.2-1.osg33.el7
osg-configure-condor-1.2.2-1.osg33.el7
osg-configure-gateway-1.2.2-1.osg33.el7
osg-configure-gip-1.2.2-1.osg33.el7
osg-configure-gratia-1.2.2-1.osg33.el7
osg-configure-infoservices-1.2.2-1.osg33.el7
osg-configure-lsf-1.2.2-1.osg33.el7
osg-configure-managedfork-1.2.2-1.osg33.el7
osg-configure-misc-1.2.2-1.osg33.el7
osg-configure-monalisa-1.2.2-1.osg33.el7
osg-configure-network-1.2.2-1.osg33.el7
osg-configure-pbs-1.2.2-1.osg33.el7
osg-configure-rsv-1.2.2-1.osg33.el7
osg-configure-sge-1.2.2-1.osg33.el7
osg-configure-slurm-1.2.2-1.osg33.el7
osg-configure-squid-1.2.2-1.osg33.el7
osg-configure-tests-1.2.2-1.osg33.el7
osg-test-1.4.30-1.osg33.el7
osg-tested-internal-3.3-5.osg33.el7
osg-version-3.3.2-1.osg33.el7
rsv-3.10.4-1_clipped.osg33.el7
rsv-consumers-3.10.4-1_clipped.osg33.el7
rsv-core-3.10.4-1_clipped.osg33.el7
rsv-metrics-3.10.4-1_clipped.osg33.el7
stashcache-0.6-1.osg33.el7
stashcache-cache-server-0.6-1.osg33.el7
stashcache-daemon-0.6-1.osg33.el7
stashcache-origin-server-0.6-1.osg33.el7
wsdl4j-1.6.3-3.1.osg33.el7
wsdl4j-javadoc-1.6.3-3.1.osg33.el7
xrootd-4.2.3-1.osg33.el7
xrootd-client-4.2.3-1.osg33.el7
xrootd-client-devel-4.2.3-1.osg33.el7
xrootd-client-libs-4.2.3-1.osg33.el7
xrootd-debuginfo-4.2.3-1.osg33.el7
xrootd-devel-4.2.3-1.osg33.el7
xrootd-doc-4.2.3-1.osg33.el7
xrootd-fuse-4.2.3-1.osg33.el7
xrootd-libs-4.2.3-1.osg33.el7
xrootd-private-devel-4.2.3-1.osg33.el7
xrootd-python-4.2.3-1.osg33.el7
xrootd-selinux-4.2.3-1.osg33.el7
xrootd-server-4.2.3-1.osg33.el7
xrootd-server-devel-4.2.3-1.osg33.el7
xrootd-server-libs-4.2.3-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

#### Enterprise Linux 7

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
```

#### Enterprise Linux 7

``` file
```

