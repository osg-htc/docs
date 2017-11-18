OSG Software Release 3.3.16
===========================

**Release Date**: 2016-09-13

Summary of changes
------------------

This release contains:

-   Updated most Globus Packages to latest available from EPEL
    -   Note: Now Globus Toolkit strictly checks host names against certificates
    -   The MyProxy server now produces RFC compliant proxies
-   BLAHP 1.18.25
    -   Added the ability to set SGE parallel environment policy
    -   Added multi-core support for PBS Pro
    -   Added mutli-core, partition, and remote\_cerequirement support for Slurm
-   [GlideinWMS 3.2.15](http://glideinwms.fnal.gov/doc.v3_2_15/history.html)
-   Fixed major scalability problem in GUMS on EL7
-   [HTCondor-CE 2.0.8](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.0.8)
    -   Allow mapping of Terana eScience hostcerts (SOFTWARE-2433)
    -   Force 'condor\_ce\_q -allusers' until QUEUE\_SUPER\_USER is fixed to be able to use CERTIFICATE\_MAPFILE in 8.5.6 (SOFTWARE-2412)
    -   Fixed OnExitHold to be set to expressions rather than their evaluated forms
    -   Ensure lockdir and rundir exist with correct permissions on startup
    -   Removed the HTCondor-CE init script on EL7 (SOFTWARE-2419)
-   Fixed load-balancing in Globus GridFTP when using IPv6 addresses
-   Added the HTCondor CREAM GAHP for EL7 platforms
-   Completed porting components of OSG Software Stack to EL7
-   Added [RSV GlideinWMS Tester](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallRsvGlideinwmsTester) for VO Front-ends to test site support
-   Updated to [VO Package v68](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-68-3): Added project8 VO
-   [osg-pki-tools 1.2.19](https://github.com/opensciencegrid/osg-pki-tools/releases/tag/1.2.19)
    -   Reword 'bad VO info' error from osg-\*cert-request
    -   Fix formatting of CSRs
-   Updated xrootd-dsi RPM to direct administrators where to add configuration changes and not destroy those changes upon update.
-   Updated to lcas-lcmaps-gt4-interface to version 0.3.1: Added support for Globus 'sharing' service
-   Simplified Gratia GridFTP probe by removing dependencies on gums-client
-   Added JSON interfaces in GUMS for VO mapping
-   Updated osg-configure package to require condor-python
-   Added support for user certificates to osg-ca-generator

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.16%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](../../)

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

-   [blahp-1.18.25.bosco-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.25.bosco-1.osg33.el6)
-   [condor-8.4.8-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.8-1.2.osg33.el6)
-   [glideinwms-3.2.15-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.15-1.osg33.el6)
-   [glite-ce-cream-client-api-c-1.15.4-2.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.2.osg33.el6)
-   [glite-ce-wsdl-1.15.1-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-ce-wsdl-1.15.1-1.1.osg33.el6)
-   [glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg33.el6)
-   [glite-lbjp-common-gss-3.2.16-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-lbjp-common-gss-3.2.16-1.osg33.el6)
-   [globus-authz-3.12-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-authz-3.12-1.osg33.el6)
-   [globus-authz-callout-error-3.5-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-authz-callout-error-3.5-2.osg33.el6)
-   [globus-callout-3.14-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-callout-3.14-1.osg33.el6)
-   [globus-common-16.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-common-16.4-1.osg33.el6)
-   [globus-ftp-client-8.29-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-ftp-client-8.29-1.1.osg33.el6)
-   [globus-ftp-control-6.10-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-ftp-control-6.10-1.1.osg33.el6)
-   [globus-gass-cache-9.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-cache-9.8-1.osg33.el6)
-   [globus-gass-cache-program-6.5-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-cache-program-6.5-2.osg33.el6)
-   [globus-gass-copy-9.19-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-copy-9.19-1.osg33.el6)
-   [globus-gass-server-ez-5.7-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-server-ez-5.7-2.osg33.el6)
-   [globus-gass-transfer-8.9-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-transfer-8.9-1.osg33.el6)
-   [globus-gatekeeper-10.10-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gatekeeper-10.10-1.1.osg33.el6)
-   [globus-gfork-4.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gfork-4.8-1.osg33.el6)
-   [globus-gram-audit-4.4-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-audit-4.4-2.osg33.el6)
-   [globus-gram-client-13.13-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-client-13.13-1.osg33.el6)
-   [globus-gram-client-tools-11.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-client-tools-11.8-1.osg33.el6)
-   [globus-gram-job-manager-14.27-3.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-14.27-3.1.osg33.el6)
-   [globus-gram-job-manager-callout-error-3.5-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-callout-error-3.5-2.osg33.el6)
-   [globus-gram-job-manager-condor-2.5-2.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-condor-2.5-2.1.osg33.el6)
-   [globus-gram-job-manager-fork-2.4-2.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-fork-2.4-2.1.osg33.el6)
-   [globus-gram-job-manager-lsf-2.6-2.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-lsf-2.6-2.1.osg33.el6)
-   [globus-gram-job-manager-scripts-6.7-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-scripts-6.7-2.osg33.el6)
-   [globus-gram-protocol-12.12-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-protocol-12.12-3.osg33.el6)
-   [globus-gridftp-server-10.4-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-10.4-1.2.osg33.el6)
-   [globus-gridftp-server-control-4.1-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-4.1-1.2.osg33.el6)
-   [globus-gridmap-callout-error-2.4-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridmap-callout-error-2.4-2.osg33.el6)
-   [globus-gsi-callback-5.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-callback-5.8-1.osg33.el6)
-   [globus-gsi-cert-utils-9.12-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-cert-utils-9.12-1.osg33.el6)
-   [globus-gsi-credential-7.9-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-credential-7.9-1.osg33.el6)
-   [globus-gsi-openssl-error-3.5-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-openssl-error-3.5-2.osg33.el6)
-   [globus-gsi-proxy-core-7.9-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-proxy-core-7.9-1.osg33.el6)
-   [globus-gsi-proxy-ssl-5.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-proxy-ssl-5.8-1.osg33.el6)
-   [globus-gsi-sysconfig-6.9-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-sysconfig-6.9-1.osg33.el6)
-   [globus-gss-assist-10.15-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gss-assist-10.15-1.osg33.el6)
-   [globus-gssapi-error-5.4-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gssapi-error-5.4-2.osg33.el6)
-   [globus-gssapi-gsi-12.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gssapi-gsi-12.1-1.osg33.el6)
-   [globus-io-11.5-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-io-11.5-1.osg33.el6)
-   [globus-openssl-module-4.6-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-openssl-module-4.6-2.osg33.el6)
-   [globus-proxy-utils-6.15-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-proxy-utils-6.15-1.osg33.el6)
-   [globus-rsl-10.10-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-rsl-10.10-1.osg33.el6)
-   [globus-scheduler-event-generator-5.11-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-scheduler-event-generator-5.11-1.1.osg33.el6)
-   [globus-simple-ca-4.22-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-simple-ca-4.22-1.osg33.el6)
-   [globus-usage-4.4-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-usage-4.4-2.osg33.el6)
-   [globus-xio-5.12-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xio-5.12-1.1.osg33.el6)
-   [globus-xio-pipe-driver-3.8-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xio-pipe-driver-3.8-1.osg33.el6)
-   [globus-xio-popen-driver-3.5-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xio-popen-driver-3.5-2.osg33.el6)
-   [globus-xio-udt-driver-1.23-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xio-udt-driver-1.23-1.osg33.el6)
-   [globus-xioperf-4.4-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xioperf-4.4-2.osg33.el6)
-   [gratia-probe-1.17.0-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.0-2.osg33.el6)
-   [gums-1.5.2-9.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.2-9.osg33.el6)
-   [htcondor-ce-2.0.8-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.8-2.osg33.el6)
-   [lcas-lcmaps-gt4-interface-0.3.1-1.2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=lcas-lcmaps-gt4-interface-0.3.1-1.2.osg33.el6)
-   [myproxy-6.1.18-1.1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=myproxy-6.1.18-1.1.osg33.el6)
-   [osg-build-1.7.1-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.7.1-1.osg33.el6)
-   [osg-ca-generator-1.2.0-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-generator-1.2.0-1.osg33.el6)
-   [osg-configure-1.4.2-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.4.2-2.osg33.el6)
-   [osg-gridftp-3.3-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-gridftp-3.3-3.osg33.el6)
-   [osg-gridftp-hdfs-3.3-4.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-gridftp-hdfs-3.3-4.osg33.el6)
-   [osg-gridftp-xrootd-3.3-3.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-gridftp-xrootd-3.3-3.osg33.el6)
-   [osg-pki-tools-1.2.19-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.19-1.osg33.el6)
-   [osg-test-1.8.4-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.8.4-1.osg33.el6)
-   [osg-tested-internal-3.3-13.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-13.osg33.el6)
-   [osg-version-3.3.16-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.16-1.osg33.el6)
-   [rsv-gwms-tester-1.1.2-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-gwms-tester-1.1.2-1.osg33.el6)
-   [vo-client-68-2.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-68-2.osg33.el6)
-   [xrootd-dsi-3.0.4-22.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-dsi-3.0.4-22.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.25.bosco-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.25.bosco-1.osg33.el7)
-   [condor-8.4.8-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.4.8-1.2.osg33.el7)
-   [glideinwms-3.2.15-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glideinwms-3.2.15-1.osg33.el7)
-   [glite-ce-cream-client-api-c-1.15.4-2.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-ce-cream-client-api-c-1.15.4-2.2.osg33.el7)
-   [glite-ce-wsdl-1.15.1-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-ce-wsdl-1.15.1-1.1.osg33.el7)
-   [glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg33.el7)
-   [glite-lbjp-common-gss-3.2.16-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=glite-lbjp-common-gss-3.2.16-1.osg33.el7)
-   [globus-authz-3.12-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-authz-3.12-1.osg33.el7)
-   [globus-authz-callout-error-3.5-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-authz-callout-error-3.5-2.osg33.el7)
-   [globus-callout-3.14-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-callout-3.14-1.osg33.el7)
-   [globus-common-16.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-common-16.4-1.osg33.el7)
-   [globus-ftp-client-8.29-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-ftp-client-8.29-1.1.osg33.el7)
-   [globus-ftp-control-6.10-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-ftp-control-6.10-1.1.osg33.el7)
-   [globus-gass-cache-9.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-cache-9.8-1.osg33.el7)
-   [globus-gass-cache-program-6.5-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-cache-program-6.5-2.osg33.el7)
-   [globus-gass-copy-9.19-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-copy-9.19-1.osg33.el7)
-   [globus-gass-server-ez-5.7-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-server-ez-5.7-2.osg33.el7)
-   [globus-gass-transfer-8.9-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gass-transfer-8.9-1.osg33.el7)
-   [globus-gatekeeper-10.10-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gatekeeper-10.10-1.1.osg33.el7)
-   [globus-gfork-4.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gfork-4.8-1.osg33.el7)
-   [globus-gram-audit-4.4-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-audit-4.4-2.osg33.el7)
-   [globus-gram-client-13.13-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-client-13.13-1.osg33.el7)
-   [globus-gram-client-tools-11.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-client-tools-11.8-1.osg33.el7)
-   [globus-gram-job-manager-14.27-3.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-14.27-3.1.osg33.el7)
-   [globus-gram-job-manager-callout-error-3.5-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-callout-error-3.5-2.osg33.el7)
-   [globus-gram-job-manager-condor-2.5-2.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-condor-2.5-2.1.osg33.el7)
-   [globus-gram-job-manager-fork-2.4-2.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-fork-2.4-2.1.osg33.el7)
-   [globus-gram-job-manager-lsf-2.6-2.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-lsf-2.6-2.1.osg33.el7)
-   [globus-gram-job-manager-scripts-6.7-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-job-manager-scripts-6.7-2.osg33.el7)
-   [globus-gram-protocol-12.12-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gram-protocol-12.12-3.osg33.el7)
-   [globus-gridftp-server-10.4-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-10.4-1.2.osg33.el7)
-   [globus-gridftp-server-control-4.1-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-4.1-1.2.osg33.el7)
-   [globus-gridmap-callout-error-2.4-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gridmap-callout-error-2.4-2.osg33.el7)
-   [globus-gsi-callback-5.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-callback-5.8-1.osg33.el7)
-   [globus-gsi-cert-utils-9.12-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-cert-utils-9.12-1.osg33.el7)
-   [globus-gsi-credential-7.9-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-credential-7.9-1.osg33.el7)
-   [globus-gsi-openssl-error-3.5-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-openssl-error-3.5-2.osg33.el7)
-   [globus-gsi-proxy-core-7.9-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-proxy-core-7.9-1.osg33.el7)
-   [globus-gsi-proxy-ssl-5.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-proxy-ssl-5.8-1.osg33.el7)
-   [globus-gsi-sysconfig-6.9-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gsi-sysconfig-6.9-1.osg33.el7)
-   [globus-gss-assist-10.15-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gss-assist-10.15-1.osg33.el7)
-   [globus-gssapi-error-5.4-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gssapi-error-5.4-2.osg33.el7)
-   [globus-gssapi-gsi-12.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-gssapi-gsi-12.1-1.osg33.el7)
-   [globus-io-11.5-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-io-11.5-1.osg33.el7)
-   [globus-openssl-module-4.6-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-openssl-module-4.6-2.osg33.el7)
-   [globus-proxy-utils-6.15-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-proxy-utils-6.15-1.osg33.el7)
-   [globus-rsl-10.10-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-rsl-10.10-1.osg33.el7)
-   [globus-scheduler-event-generator-5.11-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-scheduler-event-generator-5.11-1.1.osg33.el7)
-   [globus-simple-ca-4.22-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-simple-ca-4.22-1.osg33.el7)
-   [globus-usage-4.4-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-usage-4.4-2.osg33.el7)
-   [globus-xio-5.12-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xio-5.12-1.1.osg33.el7)
-   [globus-xio-pipe-driver-3.8-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xio-pipe-driver-3.8-1.osg33.el7)
-   [globus-xio-popen-driver-3.5-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xio-popen-driver-3.5-2.osg33.el7)
-   [globus-xio-udt-driver-1.23-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xio-udt-driver-1.23-1.osg33.el7)
-   [globus-xioperf-4.4-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=globus-xioperf-4.4-2.osg33.el7)
-   [gratia-probe-1.17.0-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gratia-probe-1.17.0-2.osg33.el7)
-   [gums-1.5.2-9.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=gums-1.5.2-9.osg33.el7)
-   [htcondor-ce-2.0.8-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=htcondor-ce-2.0.8-2.osg33.el7)
-   [lcas-lcmaps-gt4-interface-0.3.1-1.2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=lcas-lcmaps-gt4-interface-0.3.1-1.2.osg33.el7)
-   [myproxy-6.1.18-1.1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=myproxy-6.1.18-1.1.osg33.el7)
-   [osg-build-1.7.1-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-build-1.7.1-1.osg33.el7)
-   [osg-ca-generator-1.2.0-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-generator-1.2.0-1.osg33.el7)
-   [osg-configure-1.4.2-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-configure-1.4.2-2.osg33.el7)
-   [osg-gridftp-3.3-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-gridftp-3.3-3.osg33.el7)
-   [osg-gridftp-hdfs-3.3-4.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-gridftp-hdfs-3.3-4.osg33.el7)
-   [osg-gridftp-xrootd-3.3-3.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-gridftp-xrootd-3.3-3.osg33.el7)
-   [osg-pki-tools-1.2.19-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-pki-tools-1.2.19-1.osg33.el7)
-   [osg-test-1.8.4-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-test-1.8.4-1.osg33.el7)
-   [osg-tested-internal-3.3-13.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-13.osg33.el7)
-   [osg-version-3.3.16-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.16-1.osg33.el7)
-   [rsv-gwms-tester-1.1.2-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=rsv-gwms-tester-1.1.2-1.osg33.el7)
-   [vo-client-68-2.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=vo-client-68-2.osg33.el7)
-   [xrootd-dsi-3.0.4-22.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=xrootd-dsi-3.0.4-22.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp glideinwms-common-tools gl
    ideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-s
    tandalone glite-ce-cream-client-api-c glite-ce-cream-client-devel glite-ce-wsdl glite-lbjp-common-gsoap-plugin glite-lbjp-common-gsoap-plugin-debuginfo glite-lbjp-common-gsoap-plugin-devel glite-lbjp-common-gss glite-lbjp-common-gss-debug
    info glite-lbjp-common-gss-devel globus-authz globus-authz-callout-error globus-authz-callout-error-debuginfo globus-authz-callout-error-devel globus-authz-callout-error-doc globus-authz-debuginfo globus-authz-devel globus-authz-doc globu
    s-callout globus-callout-debuginfo globus-callout-devel globus-callout-doc globus-common globus-common-debuginfo globus-common-devel globus-common-doc globus-common-progs globus-ftp-client globus-ftp-client-debuginfo globus-ftp-client-dev
    el globus-ftp-client-doc globus-ftp-control globus-ftp-control-debuginfo globus-ftp-control-devel globus-ftp-control-doc globus-gass-cache globus-gass-cache-debuginfo globus-gass-cache-devel globus-gass-cache-doc globus-gass-cache-program
     globus-gass-cache-program-debuginfo globus-gass-copy globus-gass-copy-debuginfo globus-gass-copy-devel globus-gass-copy-doc globus-gass-copy-progs globus-gass-server-ez globus-gass-server-ez-debuginfo globus-gass-server-ez-devel globus-g
    ass-server-ez-progs globus-gass-transfer globus-gass-transfer-debuginfo globus-gass-transfer-devel globus-gass-transfer-doc globus-gatekeeper globus-gatekeeper-debuginfo globus-gfork globus-gfork-debuginfo globus-gfork-devel globus-gfork-
    progs globus-gram-audit globus-gram-client globus-gram-client-debuginfo globus-gram-client-devel globus-gram-client-doc globus-gram-client-tools globus-gram-client-tools-debuginfo globus-gram-job-manager globus-gram-job-manager-callout-er
    ror globus-gram-job-manager-callout-error-debuginfo globus-gram-job-manager-callout-error-devel globus-gram-job-manager-callout-error-doc globus-gram-job-manager-condor globus-gram-job-manager-debuginfo globus-gram-job-manager-fork globus
    -gram-job-manager-fork-debuginfo globus-gram-job-manager-fork-setup-poll globus-gram-job-manager-fork-setup-seg globus-gram-job-manager-lsf globus-gram-job-manager-lsf-debuginfo globus-gram-job-manager-lsf-setup-poll globus-gram-job-manag
    er-lsf-setup-seg globus-gram-job-manager-scripts globus-gram-job-manager-scripts-doc globus-gram-protocol globus-gram-protocol-debuginfo globus-gram-protocol-devel globus-gram-protocol-doc globus-gridftp-server globus-gridftp-server-contr
    ol globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs globus-gridmap-callout-error globus-gridmap-callout-error-debuginfo glo
    bus-gridmap-callout-error-devel globus-gridmap-callout-error-doc globus-gsi-callback globus-gsi-callback-debuginfo globus-gsi-callback-devel globus-gsi-callback-doc globus-gsi-cert-utils globus-gsi-cert-utils-debuginfo globus-gsi-cert-uti
    ls-devel globus-gsi-cert-utils-doc globus-gsi-cert-utils-progs globus-gsi-credential globus-gsi-credential-debuginfo globus-gsi-credential-devel globus-gsi-credential-doc globus-gsi-openssl-error globus-gsi-openssl-error-debuginfo globus-
    gsi-openssl-error-devel globus-gsi-openssl-error-doc globus-gsi-proxy-core globus-gsi-proxy-core-debuginfo globus-gsi-proxy-core-devel globus-gsi-proxy-core-doc globus-gsi-proxy-ssl globus-gsi-proxy-ssl-debuginfo globus-gsi-proxy-ssl-deve
    l globus-gsi-proxy-ssl-doc globus-gsi-sysconfig globus-gsi-sysconfig-debuginfo globus-gsi-sysconfig-devel globus-gsi-sysconfig-doc globus-gssapi-error globus-gssapi-error-debuginfo globus-gssapi-error-devel globus-gssapi-error-doc globus-
    gssapi-gsi globus-gssapi-gsi-debuginfo globus-gssapi-gsi-devel globus-gssapi-gsi-doc globus-gss-assist globus-gss-assist-debuginfo globus-gss-assist-devel globus-gss-assist-doc globus-gss-assist-progs globus-io globus-io-debuginfo globus-
    io-devel globus-openssl-module globus-openssl-module-debuginfo globus-openssl-module-devel globus-openssl-module-doc globus-proxy-utils globus-proxy-utils-debuginfo globus-rsl globus-rsl-debuginfo globus-rsl-devel globus-rsl-doc globus-sc
    heduler-event-generator globus-scheduler-event-generator-debuginfo globus-scheduler-event-generator-devel globus-scheduler-event-generator-doc globus-scheduler-event-generator-progs globus-simple-ca globus-usage globus-usage-debuginfo glo
    bus-usage-devel globus-xio globus-xio-debuginfo globus-xio-devel globus-xio-doc globus-xioperf globus-xioperf-debuginfo globus-xio-pipe-driver globus-xio-pipe-driver-debuginfo globus-xio-pipe-driver-devel globus-xio-popen-driver globus-xi
    o-popen-driver-debuginfo globus-xio-popen-driver-devel globus-xio-udt-driver globus-xio-udt-driver-debuginfo globus-xio-udt-driver-devel gratia-probe-bdii-status gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-pr
    obe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glexec gratia-probe-glideinwms 
    gratia-probe-gram gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gr
    atia-probe-xrootd-storage gratia-probe-xrootd-transfer gums gums-client gums-service htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-vie
    w lcas-lcmaps-gt4-interface lcas-lcmaps-gt4-interface-debuginfo myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-build osg-ca-generator osg-configure osg-configure-bosco osg-co
    nfigure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configur
    e-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gridftp osg-gridftp-hdfs osg-gridftp-xrootd osg-gums-config osg-pki-tools osg-pki-tools-tests osg-test osg-tes
    ted-internal osg-tested-internal-gram osg-version rsv-gwms-tester vo-client vo-client-edgmkgridmap xrootd-dsi xrootd-dsi-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.25.bosco-1.osg33.el6
blahp-debuginfo-1.18.25.bosco-1.osg33.el6
condor-8.4.8-1.2.osg33.el6
condor-all-8.4.8-1.2.osg33.el6
condor-bosco-8.4.8-1.2.osg33.el6
condor-classads-8.4.8-1.2.osg33.el6
condor-classads-devel-8.4.8-1.2.osg33.el6
condor-cream-gahp-8.4.8-1.2.osg33.el6
condor-debuginfo-8.4.8-1.2.osg33.el6
condor-kbdd-8.4.8-1.2.osg33.el6
condor-procd-8.4.8-1.2.osg33.el6
condor-python-8.4.8-1.2.osg33.el6
condor-std-universe-8.4.8-1.2.osg33.el6
condor-test-8.4.8-1.2.osg33.el6
condor-vm-gahp-8.4.8-1.2.osg33.el6
glideinwms-3.2.15-1.osg33.el6
glideinwms-common-tools-3.2.15-1.osg33.el6
glideinwms-condor-common-config-3.2.15-1.osg33.el6
glideinwms-factory-3.2.15-1.osg33.el6
glideinwms-factory-condor-3.2.15-1.osg33.el6
glideinwms-glidecondor-tools-3.2.15-1.osg33.el6
glideinwms-libs-3.2.15-1.osg33.el6
glideinwms-minimal-condor-3.2.15-1.osg33.el6
glideinwms-usercollector-3.2.15-1.osg33.el6
glideinwms-userschedd-3.2.15-1.osg33.el6
glideinwms-vofrontend-3.2.15-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.15-1.osg33.el6
glite-ce-cream-client-api-c-1.15.4-2.2.osg33.el6
glite-ce-cream-client-devel-1.15.4-2.2.osg33.el6
glite-ce-wsdl-1.15.1-1.1.osg33.el6
glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg33.el6
glite-lbjp-common-gsoap-plugin-debuginfo-3.2.12-1.1.osg33.el6
glite-lbjp-common-gsoap-plugin-devel-3.2.12-1.1.osg33.el6
glite-lbjp-common-gss-3.2.16-1.osg33.el6
glite-lbjp-common-gss-debuginfo-3.2.16-1.osg33.el6
glite-lbjp-common-gss-devel-3.2.16-1.osg33.el6
globus-authz-3.12-1.osg33.el6
globus-authz-callout-error-3.5-2.osg33.el6
globus-authz-callout-error-debuginfo-3.5-2.osg33.el6
globus-authz-callout-error-devel-3.5-2.osg33.el6
globus-authz-callout-error-doc-3.5-2.osg33.el6
globus-authz-debuginfo-3.12-1.osg33.el6
globus-authz-devel-3.12-1.osg33.el6
globus-authz-doc-3.12-1.osg33.el6
globus-callout-3.14-1.osg33.el6
globus-callout-debuginfo-3.14-1.osg33.el6
globus-callout-devel-3.14-1.osg33.el6
globus-callout-doc-3.14-1.osg33.el6
globus-common-16.4-1.osg33.el6
globus-common-debuginfo-16.4-1.osg33.el6
globus-common-devel-16.4-1.osg33.el6
globus-common-doc-16.4-1.osg33.el6
globus-common-progs-16.4-1.osg33.el6
globus-ftp-client-8.29-1.1.osg33.el6
globus-ftp-client-debuginfo-8.29-1.1.osg33.el6
globus-ftp-client-devel-8.29-1.1.osg33.el6
globus-ftp-client-doc-8.29-1.1.osg33.el6
globus-ftp-control-6.10-1.1.osg33.el6
globus-ftp-control-debuginfo-6.10-1.1.osg33.el6
globus-ftp-control-devel-6.10-1.1.osg33.el6
globus-ftp-control-doc-6.10-1.1.osg33.el6
globus-gass-cache-9.8-1.osg33.el6
globus-gass-cache-debuginfo-9.8-1.osg33.el6
globus-gass-cache-devel-9.8-1.osg33.el6
globus-gass-cache-doc-9.8-1.osg33.el6
globus-gass-cache-program-6.5-2.osg33.el6
globus-gass-cache-program-debuginfo-6.5-2.osg33.el6
globus-gass-copy-9.19-1.osg33.el6
globus-gass-copy-debuginfo-9.19-1.osg33.el6
globus-gass-copy-devel-9.19-1.osg33.el6
globus-gass-copy-doc-9.19-1.osg33.el6
globus-gass-copy-progs-9.19-1.osg33.el6
globus-gass-server-ez-5.7-2.osg33.el6
globus-gass-server-ez-debuginfo-5.7-2.osg33.el6
globus-gass-server-ez-devel-5.7-2.osg33.el6
globus-gass-server-ez-progs-5.7-2.osg33.el6
globus-gass-transfer-8.9-1.osg33.el6
globus-gass-transfer-debuginfo-8.9-1.osg33.el6
globus-gass-transfer-devel-8.9-1.osg33.el6
globus-gass-transfer-doc-8.9-1.osg33.el6
globus-gatekeeper-10.10-1.1.osg33.el6
globus-gatekeeper-debuginfo-10.10-1.1.osg33.el6
globus-gfork-4.8-1.osg33.el6
globus-gfork-debuginfo-4.8-1.osg33.el6
globus-gfork-devel-4.8-1.osg33.el6
globus-gfork-progs-4.8-1.osg33.el6
globus-gram-audit-4.4-2.osg33.el6
globus-gram-client-13.13-1.osg33.el6
globus-gram-client-debuginfo-13.13-1.osg33.el6
globus-gram-client-devel-13.13-1.osg33.el6
globus-gram-client-doc-13.13-1.osg33.el6
globus-gram-client-tools-11.8-1.osg33.el6
globus-gram-client-tools-debuginfo-11.8-1.osg33.el6
globus-gram-job-manager-14.27-3.1.osg33.el6
globus-gram-job-manager-callout-error-3.5-2.osg33.el6
globus-gram-job-manager-callout-error-debuginfo-3.5-2.osg33.el6
globus-gram-job-manager-callout-error-devel-3.5-2.osg33.el6
globus-gram-job-manager-callout-error-doc-3.5-2.osg33.el6
globus-gram-job-manager-condor-2.5-2.1.osg33.el6
globus-gram-job-manager-debuginfo-14.27-3.1.osg33.el6
globus-gram-job-manager-fork-2.4-2.1.osg33.el6
globus-gram-job-manager-fork-debuginfo-2.4-2.1.osg33.el6
globus-gram-job-manager-fork-setup-poll-2.4-2.1.osg33.el6
globus-gram-job-manager-fork-setup-seg-2.4-2.1.osg33.el6
globus-gram-job-manager-lsf-2.6-2.1.osg33.el6
globus-gram-job-manager-lsf-debuginfo-2.6-2.1.osg33.el6
globus-gram-job-manager-lsf-setup-poll-2.6-2.1.osg33.el6
globus-gram-job-manager-lsf-setup-seg-2.6-2.1.osg33.el6
globus-gram-job-manager-scripts-6.7-2.osg33.el6
globus-gram-job-manager-scripts-doc-6.7-2.osg33.el6
globus-gram-protocol-12.12-3.osg33.el6
globus-gram-protocol-debuginfo-12.12-3.osg33.el6
globus-gram-protocol-devel-12.12-3.osg33.el6
globus-gram-protocol-doc-12.12-3.osg33.el6
globus-gridftp-server-10.4-1.2.osg33.el6
globus-gridftp-server-control-4.1-1.2.osg33.el6
globus-gridftp-server-control-debuginfo-4.1-1.2.osg33.el6
globus-gridftp-server-control-devel-4.1-1.2.osg33.el6
globus-gridftp-server-debuginfo-10.4-1.2.osg33.el6
globus-gridftp-server-devel-10.4-1.2.osg33.el6
globus-gridftp-server-progs-10.4-1.2.osg33.el6
globus-gridmap-callout-error-2.4-2.osg33.el6
globus-gridmap-callout-error-debuginfo-2.4-2.osg33.el6
globus-gridmap-callout-error-devel-2.4-2.osg33.el6
globus-gridmap-callout-error-doc-2.4-2.osg33.el6
globus-gsi-callback-5.8-1.osg33.el6
globus-gsi-callback-debuginfo-5.8-1.osg33.el6
globus-gsi-callback-devel-5.8-1.osg33.el6
globus-gsi-callback-doc-5.8-1.osg33.el6
globus-gsi-cert-utils-9.12-1.osg33.el6
globus-gsi-cert-utils-debuginfo-9.12-1.osg33.el6
globus-gsi-cert-utils-devel-9.12-1.osg33.el6
globus-gsi-cert-utils-doc-9.12-1.osg33.el6
globus-gsi-cert-utils-progs-9.12-1.osg33.el6
globus-gsi-credential-7.9-1.osg33.el6
globus-gsi-credential-debuginfo-7.9-1.osg33.el6
globus-gsi-credential-devel-7.9-1.osg33.el6
globus-gsi-credential-doc-7.9-1.osg33.el6
globus-gsi-openssl-error-3.5-2.osg33.el6
globus-gsi-openssl-error-debuginfo-3.5-2.osg33.el6
globus-gsi-openssl-error-devel-3.5-2.osg33.el6
globus-gsi-openssl-error-doc-3.5-2.osg33.el6
globus-gsi-proxy-core-7.9-1.osg33.el6
globus-gsi-proxy-core-debuginfo-7.9-1.osg33.el6
globus-gsi-proxy-core-devel-7.9-1.osg33.el6
globus-gsi-proxy-core-doc-7.9-1.osg33.el6
globus-gsi-proxy-ssl-5.8-1.osg33.el6
globus-gsi-proxy-ssl-debuginfo-5.8-1.osg33.el6
globus-gsi-proxy-ssl-devel-5.8-1.osg33.el6
globus-gsi-proxy-ssl-doc-5.8-1.osg33.el6
globus-gsi-sysconfig-6.9-1.osg33.el6
globus-gsi-sysconfig-debuginfo-6.9-1.osg33.el6
globus-gsi-sysconfig-devel-6.9-1.osg33.el6
globus-gsi-sysconfig-doc-6.9-1.osg33.el6
globus-gssapi-error-5.4-2.osg33.el6
globus-gssapi-error-debuginfo-5.4-2.osg33.el6
globus-gssapi-error-devel-5.4-2.osg33.el6
globus-gssapi-error-doc-5.4-2.osg33.el6
globus-gssapi-gsi-12.1-1.osg33.el6
globus-gssapi-gsi-debuginfo-12.1-1.osg33.el6
globus-gssapi-gsi-devel-12.1-1.osg33.el6
globus-gssapi-gsi-doc-12.1-1.osg33.el6
globus-gss-assist-10.15-1.osg33.el6
globus-gss-assist-debuginfo-10.15-1.osg33.el6
globus-gss-assist-devel-10.15-1.osg33.el6
globus-gss-assist-doc-10.15-1.osg33.el6
globus-gss-assist-progs-10.15-1.osg33.el6
globus-io-11.5-1.osg33.el6
globus-io-debuginfo-11.5-1.osg33.el6
globus-io-devel-11.5-1.osg33.el6
globus-openssl-module-4.6-2.osg33.el6
globus-openssl-module-debuginfo-4.6-2.osg33.el6
globus-openssl-module-devel-4.6-2.osg33.el6
globus-openssl-module-doc-4.6-2.osg33.el6
globus-proxy-utils-6.15-1.osg33.el6
globus-proxy-utils-debuginfo-6.15-1.osg33.el6
globus-rsl-10.10-1.osg33.el6
globus-rsl-debuginfo-10.10-1.osg33.el6
globus-rsl-devel-10.10-1.osg33.el6
globus-rsl-doc-10.10-1.osg33.el6
globus-scheduler-event-generator-5.11-1.1.osg33.el6
globus-scheduler-event-generator-debuginfo-5.11-1.1.osg33.el6
globus-scheduler-event-generator-devel-5.11-1.1.osg33.el6
globus-scheduler-event-generator-doc-5.11-1.1.osg33.el6
globus-scheduler-event-generator-progs-5.11-1.1.osg33.el6
globus-simple-ca-4.22-1.osg33.el6
globus-usage-4.4-2.osg33.el6
globus-usage-debuginfo-4.4-2.osg33.el6
globus-usage-devel-4.4-2.osg33.el6
globus-xio-5.12-1.1.osg33.el6
globus-xio-debuginfo-5.12-1.1.osg33.el6
globus-xio-devel-5.12-1.1.osg33.el6
globus-xio-doc-5.12-1.1.osg33.el6
globus-xioperf-4.4-2.osg33.el6
globus-xioperf-debuginfo-4.4-2.osg33.el6
globus-xio-pipe-driver-3.8-1.osg33.el6
globus-xio-pipe-driver-debuginfo-3.8-1.osg33.el6
globus-xio-pipe-driver-devel-3.8-1.osg33.el6
globus-xio-popen-driver-3.5-2.osg33.el6
globus-xio-popen-driver-debuginfo-3.5-2.osg33.el6
globus-xio-popen-driver-devel-3.5-2.osg33.el6
globus-xio-udt-driver-1.23-1.osg33.el6
globus-xio-udt-driver-debuginfo-1.23-1.osg33.el6
globus-xio-udt-driver-devel-1.23-1.osg33.el6
gratia-probe-1.17.0-2.osg33.el6
gratia-probe-bdii-status-1.17.0-2.osg33.el6
gratia-probe-common-1.17.0-2.osg33.el6
gratia-probe-condor-1.17.0-2.osg33.el6
gratia-probe-condor-events-1.17.0-2.osg33.el6
gratia-probe-dcache-storage-1.17.0-2.osg33.el6
gratia-probe-dcache-storagegroup-1.17.0-2.osg33.el6
gratia-probe-dcache-transfer-1.17.0-2.osg33.el6
gratia-probe-debuginfo-1.17.0-2.osg33.el6
gratia-probe-enstore-storage-1.17.0-2.osg33.el6
gratia-probe-enstore-tapedrive-1.17.0-2.osg33.el6
gratia-probe-enstore-transfer-1.17.0-2.osg33.el6
gratia-probe-glexec-1.17.0-2.osg33.el6
gratia-probe-glideinwms-1.17.0-2.osg33.el6
gratia-probe-gram-1.17.0-2.osg33.el6
gratia-probe-gridftp-transfer-1.17.0-2.osg33.el6
gratia-probe-hadoop-storage-1.17.0-2.osg33.el6
gratia-probe-htcondor-ce-1.17.0-2.osg33.el6
gratia-probe-lsf-1.17.0-2.osg33.el6
gratia-probe-metric-1.17.0-2.osg33.el6
gratia-probe-onevm-1.17.0-2.osg33.el6
gratia-probe-pbs-lsf-1.17.0-2.osg33.el6
gratia-probe-services-1.17.0-2.osg33.el6
gratia-probe-sge-1.17.0-2.osg33.el6
gratia-probe-slurm-1.17.0-2.osg33.el6
gratia-probe-xrootd-storage-1.17.0-2.osg33.el6
gratia-probe-xrootd-transfer-1.17.0-2.osg33.el6
gums-1.5.2-9.osg33.el6
gums-client-1.5.2-9.osg33.el6
gums-service-1.5.2-9.osg33.el6
htcondor-ce-2.0.8-2.osg33.el6
htcondor-ce-bosco-2.0.8-2.osg33.el6
htcondor-ce-client-2.0.8-2.osg33.el6
htcondor-ce-collector-2.0.8-2.osg33.el6
htcondor-ce-condor-2.0.8-2.osg33.el6
htcondor-ce-lsf-2.0.8-2.osg33.el6
htcondor-ce-pbs-2.0.8-2.osg33.el6
htcondor-ce-sge-2.0.8-2.osg33.el6
htcondor-ce-view-2.0.8-2.osg33.el6
lcas-lcmaps-gt4-interface-0.3.1-1.2.osg33.el6
lcas-lcmaps-gt4-interface-debuginfo-0.3.1-1.2.osg33.el6
myproxy-6.1.18-1.1.osg33.el6
myproxy-admin-6.1.18-1.1.osg33.el6
myproxy-debuginfo-6.1.18-1.1.osg33.el6
myproxy-devel-6.1.18-1.1.osg33.el6
myproxy-doc-6.1.18-1.1.osg33.el6
myproxy-libs-6.1.18-1.1.osg33.el6
myproxy-server-6.1.18-1.1.osg33.el6
myproxy-voms-6.1.18-1.1.osg33.el6
osg-build-1.7.1-1.osg33.el6
osg-ca-generator-1.2.0-1.osg33.el6
osg-configure-1.4.2-2.osg33.el6
osg-configure-bosco-1.4.2-2.osg33.el6
osg-configure-ce-1.4.2-2.osg33.el6
osg-configure-cemon-1.4.2-2.osg33.el6
osg-configure-condor-1.4.2-2.osg33.el6
osg-configure-gateway-1.4.2-2.osg33.el6
osg-configure-gip-1.4.2-2.osg33.el6
osg-configure-gratia-1.4.2-2.osg33.el6
osg-configure-infoservices-1.4.2-2.osg33.el6
osg-configure-lsf-1.4.2-2.osg33.el6
osg-configure-managedfork-1.4.2-2.osg33.el6
osg-configure-misc-1.4.2-2.osg33.el6
osg-configure-monalisa-1.4.2-2.osg33.el6
osg-configure-network-1.4.2-2.osg33.el6
osg-configure-pbs-1.4.2-2.osg33.el6
osg-configure-rsv-1.4.2-2.osg33.el6
osg-configure-sge-1.4.2-2.osg33.el6
osg-configure-slurm-1.4.2-2.osg33.el6
osg-configure-squid-1.4.2-2.osg33.el6
osg-configure-tests-1.4.2-2.osg33.el6
osg-gridftp-3.3-3.osg33.el6
osg-gridftp-hdfs-3.3-4.osg33.el6
osg-gridftp-xrootd-3.3-3.osg33.el6
osg-gums-config-68-2.osg33.el6
osg-pki-tools-1.2.19-1.osg33.el6
osg-pki-tools-tests-1.2.19-1.osg33.el6
osg-test-1.8.4-1.osg33.el6
osg-tested-internal-3.3-13.osg33.el6
osg-tested-internal-gram-3.3-13.osg33.el6
osg-version-3.3.16-1.osg33.el6
rsv-gwms-tester-1.1.2-1.osg33.el6
vo-client-68-2.osg33.el6
vo-client-edgmkgridmap-68-2.osg33.el6
xrootd-dsi-3.0.4-22.osg33.el6
xrootd-dsi-debuginfo-3.0.4-22.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.25.bosco-1.osg33.el7
blahp-debuginfo-1.18.25.bosco-1.osg33.el7
condor-8.4.8-1.2.osg33.el7
condor-all-8.4.8-1.2.osg33.el7
condor-bosco-8.4.8-1.2.osg33.el7
condor-classads-8.4.8-1.2.osg33.el7
condor-classads-devel-8.4.8-1.2.osg33.el7
condor-cream-gahp-8.4.8-1.2.osg33.el7
condor-debuginfo-8.4.8-1.2.osg33.el7
condor-kbdd-8.4.8-1.2.osg33.el7
condor-procd-8.4.8-1.2.osg33.el7
condor-python-8.4.8-1.2.osg33.el7
condor-test-8.4.8-1.2.osg33.el7
condor-vm-gahp-8.4.8-1.2.osg33.el7
glideinwms-3.2.15-1.osg33.el7
glideinwms-common-tools-3.2.15-1.osg33.el7
glideinwms-condor-common-config-3.2.15-1.osg33.el7
glideinwms-factory-3.2.15-1.osg33.el7
glideinwms-factory-condor-3.2.15-1.osg33.el7
glideinwms-glidecondor-tools-3.2.15-1.osg33.el7
glideinwms-libs-3.2.15-1.osg33.el7
glideinwms-minimal-condor-3.2.15-1.osg33.el7
glideinwms-usercollector-3.2.15-1.osg33.el7
glideinwms-userschedd-3.2.15-1.osg33.el7
glideinwms-vofrontend-3.2.15-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.15-1.osg33.el7
glite-ce-cream-client-api-c-1.15.4-2.2.osg33.el7
glite-ce-cream-client-devel-1.15.4-2.2.osg33.el7
glite-ce-wsdl-1.15.1-1.1.osg33.el7
glite-lbjp-common-gsoap-plugin-3.2.12-1.1.osg33.el7
glite-lbjp-common-gsoap-plugin-debuginfo-3.2.12-1.1.osg33.el7
glite-lbjp-common-gsoap-plugin-devel-3.2.12-1.1.osg33.el7
glite-lbjp-common-gss-3.2.16-1.osg33.el7
glite-lbjp-common-gss-debuginfo-3.2.16-1.osg33.el7
glite-lbjp-common-gss-devel-3.2.16-1.osg33.el7
globus-authz-3.12-1.osg33.el7
globus-authz-callout-error-3.5-2.osg33.el7
globus-authz-callout-error-debuginfo-3.5-2.osg33.el7
globus-authz-callout-error-devel-3.5-2.osg33.el7
globus-authz-callout-error-doc-3.5-2.osg33.el7
globus-authz-debuginfo-3.12-1.osg33.el7
globus-authz-devel-3.12-1.osg33.el7
globus-authz-doc-3.12-1.osg33.el7
globus-callout-3.14-1.osg33.el7
globus-callout-debuginfo-3.14-1.osg33.el7
globus-callout-devel-3.14-1.osg33.el7
globus-callout-doc-3.14-1.osg33.el7
globus-common-16.4-1.osg33.el7
globus-common-debuginfo-16.4-1.osg33.el7
globus-common-devel-16.4-1.osg33.el7
globus-common-doc-16.4-1.osg33.el7
globus-common-progs-16.4-1.osg33.el7
globus-ftp-client-8.29-1.1.osg33.el7
globus-ftp-client-debuginfo-8.29-1.1.osg33.el7
globus-ftp-client-devel-8.29-1.1.osg33.el7
globus-ftp-client-doc-8.29-1.1.osg33.el7
globus-ftp-control-6.10-1.1.osg33.el7
globus-ftp-control-debuginfo-6.10-1.1.osg33.el7
globus-ftp-control-devel-6.10-1.1.osg33.el7
globus-ftp-control-doc-6.10-1.1.osg33.el7
globus-gass-cache-9.8-1.osg33.el7
globus-gass-cache-debuginfo-9.8-1.osg33.el7
globus-gass-cache-devel-9.8-1.osg33.el7
globus-gass-cache-doc-9.8-1.osg33.el7
globus-gass-cache-program-6.5-2.osg33.el7
globus-gass-cache-program-debuginfo-6.5-2.osg33.el7
globus-gass-copy-9.19-1.osg33.el7
globus-gass-copy-debuginfo-9.19-1.osg33.el7
globus-gass-copy-devel-9.19-1.osg33.el7
globus-gass-copy-doc-9.19-1.osg33.el7
globus-gass-copy-progs-9.19-1.osg33.el7
globus-gass-server-ez-5.7-2.osg33.el7
globus-gass-server-ez-debuginfo-5.7-2.osg33.el7
globus-gass-server-ez-devel-5.7-2.osg33.el7
globus-gass-server-ez-progs-5.7-2.osg33.el7
globus-gass-transfer-8.9-1.osg33.el7
globus-gass-transfer-debuginfo-8.9-1.osg33.el7
globus-gass-transfer-devel-8.9-1.osg33.el7
globus-gass-transfer-doc-8.9-1.osg33.el7
globus-gatekeeper-10.10-1.1.osg33.el7
globus-gatekeeper-debuginfo-10.10-1.1.osg33.el7
globus-gfork-4.8-1.osg33.el7
globus-gfork-debuginfo-4.8-1.osg33.el7
globus-gfork-devel-4.8-1.osg33.el7
globus-gfork-progs-4.8-1.osg33.el7
globus-gram-audit-4.4-2.osg33.el7
globus-gram-client-13.13-1.osg33.el7
globus-gram-client-debuginfo-13.13-1.osg33.el7
globus-gram-client-devel-13.13-1.osg33.el7
globus-gram-client-doc-13.13-1.osg33.el7
globus-gram-client-tools-11.8-1.osg33.el7
globus-gram-client-tools-debuginfo-11.8-1.osg33.el7
globus-gram-job-manager-14.27-3.1.osg33.el7
globus-gram-job-manager-callout-error-3.5-2.osg33.el7
globus-gram-job-manager-callout-error-debuginfo-3.5-2.osg33.el7
globus-gram-job-manager-callout-error-devel-3.5-2.osg33.el7
globus-gram-job-manager-callout-error-doc-3.5-2.osg33.el7
globus-gram-job-manager-condor-2.5-2.1.osg33.el7
globus-gram-job-manager-debuginfo-14.27-3.1.osg33.el7
globus-gram-job-manager-fork-2.4-2.1.osg33.el7
globus-gram-job-manager-fork-debuginfo-2.4-2.1.osg33.el7
globus-gram-job-manager-fork-setup-poll-2.4-2.1.osg33.el7
globus-gram-job-manager-fork-setup-seg-2.4-2.1.osg33.el7
globus-gram-job-manager-lsf-2.6-2.1.osg33.el7
globus-gram-job-manager-lsf-debuginfo-2.6-2.1.osg33.el7
globus-gram-job-manager-lsf-setup-poll-2.6-2.1.osg33.el7
globus-gram-job-manager-lsf-setup-seg-2.6-2.1.osg33.el7
globus-gram-job-manager-scripts-6.7-2.osg33.el7
globus-gram-job-manager-scripts-doc-6.7-2.osg33.el7
globus-gram-protocol-12.12-3.osg33.el7
globus-gram-protocol-debuginfo-12.12-3.osg33.el7
globus-gram-protocol-devel-12.12-3.osg33.el7
globus-gram-protocol-doc-12.12-3.osg33.el7
globus-gridftp-server-10.4-1.2.osg33.el7
globus-gridftp-server-control-4.1-1.2.osg33.el7
globus-gridftp-server-control-debuginfo-4.1-1.2.osg33.el7
globus-gridftp-server-control-devel-4.1-1.2.osg33.el7
globus-gridftp-server-debuginfo-10.4-1.2.osg33.el7
globus-gridftp-server-devel-10.4-1.2.osg33.el7
globus-gridftp-server-progs-10.4-1.2.osg33.el7
globus-gridmap-callout-error-2.4-2.osg33.el7
globus-gridmap-callout-error-debuginfo-2.4-2.osg33.el7
globus-gridmap-callout-error-devel-2.4-2.osg33.el7
globus-gridmap-callout-error-doc-2.4-2.osg33.el7
globus-gsi-callback-5.8-1.osg33.el7
globus-gsi-callback-debuginfo-5.8-1.osg33.el7
globus-gsi-callback-devel-5.8-1.osg33.el7
globus-gsi-callback-doc-5.8-1.osg33.el7
globus-gsi-cert-utils-9.12-1.osg33.el7
globus-gsi-cert-utils-debuginfo-9.12-1.osg33.el7
globus-gsi-cert-utils-devel-9.12-1.osg33.el7
globus-gsi-cert-utils-doc-9.12-1.osg33.el7
globus-gsi-cert-utils-progs-9.12-1.osg33.el7
globus-gsi-credential-7.9-1.osg33.el7
globus-gsi-credential-debuginfo-7.9-1.osg33.el7
globus-gsi-credential-devel-7.9-1.osg33.el7
globus-gsi-credential-doc-7.9-1.osg33.el7
globus-gsi-openssl-error-3.5-2.osg33.el7
globus-gsi-openssl-error-debuginfo-3.5-2.osg33.el7
globus-gsi-openssl-error-devel-3.5-2.osg33.el7
globus-gsi-openssl-error-doc-3.5-2.osg33.el7
globus-gsi-proxy-core-7.9-1.osg33.el7
globus-gsi-proxy-core-debuginfo-7.9-1.osg33.el7
globus-gsi-proxy-core-devel-7.9-1.osg33.el7
globus-gsi-proxy-core-doc-7.9-1.osg33.el7
globus-gsi-proxy-ssl-5.8-1.osg33.el7
globus-gsi-proxy-ssl-debuginfo-5.8-1.osg33.el7
globus-gsi-proxy-ssl-devel-5.8-1.osg33.el7
globus-gsi-proxy-ssl-doc-5.8-1.osg33.el7
globus-gsi-sysconfig-6.9-1.osg33.el7
globus-gsi-sysconfig-debuginfo-6.9-1.osg33.el7
globus-gsi-sysconfig-devel-6.9-1.osg33.el7
globus-gsi-sysconfig-doc-6.9-1.osg33.el7
globus-gssapi-error-5.4-2.osg33.el7
globus-gssapi-error-debuginfo-5.4-2.osg33.el7
globus-gssapi-error-devel-5.4-2.osg33.el7
globus-gssapi-error-doc-5.4-2.osg33.el7
globus-gssapi-gsi-12.1-1.osg33.el7
globus-gssapi-gsi-debuginfo-12.1-1.osg33.el7
globus-gssapi-gsi-devel-12.1-1.osg33.el7
globus-gssapi-gsi-doc-12.1-1.osg33.el7
globus-gss-assist-10.15-1.osg33.el7
globus-gss-assist-debuginfo-10.15-1.osg33.el7
globus-gss-assist-devel-10.15-1.osg33.el7
globus-gss-assist-doc-10.15-1.osg33.el7
globus-gss-assist-progs-10.15-1.osg33.el7
globus-io-11.5-1.osg33.el7
globus-io-debuginfo-11.5-1.osg33.el7
globus-io-devel-11.5-1.osg33.el7
globus-openssl-module-4.6-2.osg33.el7
globus-openssl-module-debuginfo-4.6-2.osg33.el7
globus-openssl-module-devel-4.6-2.osg33.el7
globus-openssl-module-doc-4.6-2.osg33.el7
globus-proxy-utils-6.15-1.osg33.el7
globus-proxy-utils-debuginfo-6.15-1.osg33.el7
globus-rsl-10.10-1.osg33.el7
globus-rsl-debuginfo-10.10-1.osg33.el7
globus-rsl-devel-10.10-1.osg33.el7
globus-rsl-doc-10.10-1.osg33.el7
globus-scheduler-event-generator-5.11-1.1.osg33.el7
globus-scheduler-event-generator-debuginfo-5.11-1.1.osg33.el7
globus-scheduler-event-generator-devel-5.11-1.1.osg33.el7
globus-scheduler-event-generator-doc-5.11-1.1.osg33.el7
globus-scheduler-event-generator-progs-5.11-1.1.osg33.el7
globus-simple-ca-4.22-1.osg33.el7
globus-usage-4.4-2.osg33.el7
globus-usage-debuginfo-4.4-2.osg33.el7
globus-usage-devel-4.4-2.osg33.el7
globus-xio-5.12-1.1.osg33.el7
globus-xio-debuginfo-5.12-1.1.osg33.el7
globus-xio-devel-5.12-1.1.osg33.el7
globus-xio-doc-5.12-1.1.osg33.el7
globus-xioperf-4.4-2.osg33.el7
globus-xioperf-debuginfo-4.4-2.osg33.el7
globus-xio-pipe-driver-3.8-1.osg33.el7
globus-xio-pipe-driver-debuginfo-3.8-1.osg33.el7
globus-xio-pipe-driver-devel-3.8-1.osg33.el7
globus-xio-popen-driver-3.5-2.osg33.el7
globus-xio-popen-driver-debuginfo-3.5-2.osg33.el7
globus-xio-popen-driver-devel-3.5-2.osg33.el7
globus-xio-udt-driver-1.23-1.osg33.el7
globus-xio-udt-driver-debuginfo-1.23-1.osg33.el7
globus-xio-udt-driver-devel-1.23-1.osg33.el7
gratia-probe-1.17.0-2.osg33.el7
gratia-probe-bdii-status-1.17.0-2.osg33.el7
gratia-probe-common-1.17.0-2.osg33.el7
gratia-probe-condor-1.17.0-2.osg33.el7
gratia-probe-condor-events-1.17.0-2.osg33.el7
gratia-probe-dcache-storage-1.17.0-2.osg33.el7
gratia-probe-dcache-storagegroup-1.17.0-2.osg33.el7
gratia-probe-dcache-transfer-1.17.0-2.osg33.el7
gratia-probe-debuginfo-1.17.0-2.osg33.el7
gratia-probe-enstore-storage-1.17.0-2.osg33.el7
gratia-probe-enstore-tapedrive-1.17.0-2.osg33.el7
gratia-probe-enstore-transfer-1.17.0-2.osg33.el7
gratia-probe-glexec-1.17.0-2.osg33.el7
gratia-probe-glideinwms-1.17.0-2.osg33.el7
gratia-probe-gram-1.17.0-2.osg33.el7
gratia-probe-gridftp-transfer-1.17.0-2.osg33.el7
gratia-probe-hadoop-storage-1.17.0-2.osg33.el7
gratia-probe-htcondor-ce-1.17.0-2.osg33.el7
gratia-probe-lsf-1.17.0-2.osg33.el7
gratia-probe-metric-1.17.0-2.osg33.el7
gratia-probe-onevm-1.17.0-2.osg33.el7
gratia-probe-pbs-lsf-1.17.0-2.osg33.el7
gratia-probe-services-1.17.0-2.osg33.el7
gratia-probe-sge-1.17.0-2.osg33.el7
gratia-probe-slurm-1.17.0-2.osg33.el7
gratia-probe-xrootd-storage-1.17.0-2.osg33.el7
gratia-probe-xrootd-transfer-1.17.0-2.osg33.el7
gums-1.5.2-9.osg33.el7
gums-client-1.5.2-9.osg33.el7
gums-service-1.5.2-9.osg33.el7
htcondor-ce-2.0.8-2.osg33.el7
htcondor-ce-bosco-2.0.8-2.osg33.el7
htcondor-ce-client-2.0.8-2.osg33.el7
htcondor-ce-collector-2.0.8-2.osg33.el7
htcondor-ce-condor-2.0.8-2.osg33.el7
htcondor-ce-lsf-2.0.8-2.osg33.el7
htcondor-ce-pbs-2.0.8-2.osg33.el7
htcondor-ce-sge-2.0.8-2.osg33.el7
htcondor-ce-view-2.0.8-2.osg33.el7
lcas-lcmaps-gt4-interface-0.3.1-1.2.osg33.el7
lcas-lcmaps-gt4-interface-debuginfo-0.3.1-1.2.osg33.el7
myproxy-6.1.18-1.1.osg33.el7
myproxy-admin-6.1.18-1.1.osg33.el7
myproxy-debuginfo-6.1.18-1.1.osg33.el7
myproxy-devel-6.1.18-1.1.osg33.el7
myproxy-doc-6.1.18-1.1.osg33.el7
myproxy-libs-6.1.18-1.1.osg33.el7
myproxy-server-6.1.18-1.1.osg33.el7
myproxy-voms-6.1.18-1.1.osg33.el7
osg-build-1.7.1-1.osg33.el7
osg-ca-generator-1.2.0-1.osg33.el7
osg-configure-1.4.2-2.osg33.el7
osg-configure-bosco-1.4.2-2.osg33.el7
osg-configure-ce-1.4.2-2.osg33.el7
osg-configure-cemon-1.4.2-2.osg33.el7
osg-configure-condor-1.4.2-2.osg33.el7
osg-configure-gateway-1.4.2-2.osg33.el7
osg-configure-gip-1.4.2-2.osg33.el7
osg-configure-gratia-1.4.2-2.osg33.el7
osg-configure-infoservices-1.4.2-2.osg33.el7
osg-configure-lsf-1.4.2-2.osg33.el7
osg-configure-managedfork-1.4.2-2.osg33.el7
osg-configure-misc-1.4.2-2.osg33.el7
osg-configure-monalisa-1.4.2-2.osg33.el7
osg-configure-network-1.4.2-2.osg33.el7
osg-configure-pbs-1.4.2-2.osg33.el7
osg-configure-rsv-1.4.2-2.osg33.el7
osg-configure-sge-1.4.2-2.osg33.el7
osg-configure-slurm-1.4.2-2.osg33.el7
osg-configure-squid-1.4.2-2.osg33.el7
osg-configure-tests-1.4.2-2.osg33.el7
osg-gridftp-3.3-3.osg33.el7
osg-gridftp-hdfs-3.3-4.osg33.el7
osg-gridftp-xrootd-3.3-3.osg33.el7
osg-gums-config-68-2.osg33.el7
osg-pki-tools-1.2.19-1.osg33.el7
osg-pki-tools-tests-1.2.19-1.osg33.el7
osg-test-1.8.4-1.osg33.el7
osg-tested-internal-3.3-13.osg33.el7
osg-tested-internal-gram-3.3-13.osg33.el7
osg-version-3.3.16-1.osg33.el7
rsv-gwms-tester-1.1.2-1.osg33.el7
vo-client-68-2.osg33.el7
vo-client-edgmkgridmap-68-2.osg33.el7
xrootd-dsi-3.0.4-22.osg33.el7
xrootd-dsi-debuginfo-3.0.4-22.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.25.bosco-1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.25.bosco-1.osgup.el6)
-   [condor-8.5.6-1.1.osgup.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.6-1.1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.25.bosco-1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=blahp-1.18.25.bosco-1.osgup.el7)
-   [condor-8.5.6-1.1.osgup.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=condor-8.5.6-1.1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.25.bosco-1.osgup.el6
blahp-debuginfo-1.18.25.bosco-1.osgup.el6
condor-8.5.6-1.1.osgup.el6
condor-all-8.5.6-1.1.osgup.el6
condor-bosco-8.5.6-1.1.osgup.el6
condor-classads-8.5.6-1.1.osgup.el6
condor-classads-devel-8.5.6-1.1.osgup.el6
condor-cream-gahp-8.5.6-1.1.osgup.el6
condor-debuginfo-8.5.6-1.1.osgup.el6
condor-kbdd-8.5.6-1.1.osgup.el6
condor-procd-8.5.6-1.1.osgup.el6
condor-python-8.5.6-1.1.osgup.el6
condor-std-universe-8.5.6-1.1.osgup.el6
condor-test-8.5.6-1.1.osgup.el6
condor-vm-gahp-8.5.6-1.1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.25.bosco-1.osgup.el7
blahp-debuginfo-1.18.25.bosco-1.osgup.el7
condor-8.5.6-1.1.osgup.el7
condor-all-8.5.6-1.1.osgup.el7
condor-bosco-8.5.6-1.1.osgup.el7
condor-classads-8.5.6-1.1.osgup.el7
condor-classads-devel-8.5.6-1.1.osgup.el7
condor-cream-gahp-8.5.6-1.1.osgup.el7
condor-debuginfo-8.5.6-1.1.osgup.el7
condor-kbdd-8.5.6-1.1.osgup.el7
condor-procd-8.5.6-1.1.osgup.el7
condor-python-8.5.6-1.1.osgup.el7
condor-test-8.5.6-1.1.osgup.el7
condor-vm-gahp-8.5.6-1.1.osgup.el7
```

