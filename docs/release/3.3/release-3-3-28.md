OSG Software Release 3.3.28
===========================

**Release Date**: 2017-09-12

Summary of changes
------------------

This release contains:

-   Updated to BLAHP 1.18.33
    -   Properly parses times from Slurm's sacct command
    -   pbs\_pro does not need to be defined to query PBS for job status
-   Updated to [XRootD 4.7.0](https://github.com/xrootd/xrootd/blob/v4.7.0/docs/ReleaseNotes.txt)
-   Updated to [StashCache 0.8](https://github.com/opensciencegrid/StashCache-Daemon/releases/tag/v0.8)
-   Updated Globus packages to latest EPEL versions
-   osg-ca-scripts now use HTTPS to download CA certificates
-   Added the ability to limit transfer load in the globus-gridftp-osg-extensions
-   Fixed a few memory management bugs in [xrootd-lcmaps](https://github.com/opensciencegrid/xrootd-lcmaps/releases/tag/v1.3.4)
-   Updated to [xrootd-hdfs 1.9.2](https://github.com/opensciencegrid/xrootd-hdfs/releases/tag/v1.9.2)
-   [HTCondor CE 2.2.3](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v2.2.3) reports an error if `JOB_ROUTER_ENTRIES` are not defined
-   GridFTP-HDFS now built from OSG sources
-   Updated SELinux profile to allow GUMS to access the MySQL port
-   osg-configure 1.10.0 - removed the last vestiges of GRAM

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.28%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note
    StashCache is supported on EL7 only.

!!! note
    xrootd-lcmaps will remain at 1.2.1-1 on EL6.

Detailed changes are below. All of the documentation can be found [here](../../)

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details.`. This warning can safely be ignored.
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the October release.
-   Updates to VOMS admin server require the updated emi-trustmanager-tomcat and re-running the configure script:

        :::console
        root@host # /var/lib/trustmanager-tomcat/configure.sh

-   VOMS admin server shows an error when modifying/adding/signing AUPs, but all the actions still work.
-   After updating OSG-CE to version 3.3-12, please disable and remove OSG Info Services via the following procedure:

        :::console
        root@host # service osg-info-services stop
        root@host # yum erase gip osg-info-services

-   The Koji client config has changed in the new version of Koji: `pkgurl=http://koji.chtc.wisc.edu/packages` has been replaced by `topurl=http://koji.chtc.wisc.edu` and the Koji client will give a harmless but annoying warning when it finds `pkgurl`. To get rid of the warning, update to osg-build > `1.8.0`, rerun `osg-koji setup`, and say 'yes' when asked to replace the Koji configuration file; or, you may make the above change manually.
-   A previous version (`1.17.0-2.5`) of the Gratia probes required changes in the HTCondor configuration to operate properly. Now, these changes need to be reverted to use verison `1.17.0-2.6` and later of the probes. The lines below are likely to be found in `condor_config.local` or a new file in `/etc/condor/config.d` directory. Delete these lines and run `condor_reconfig`.

        # GlideinWMS Gratia commands
        PER_JOB_HISTORY_DIR = /var/lib/gratia/data
        JOBGLIDEIN_ResourceName="$$([IfThenElse(IsUndefined(TARGET.GLIDEIN_ResourceName), IfThenElse(IsUndefined(TARGET.GLIDEIN_Site), IfThenElse(IsUndefined(TARGET.FileSystemDomain), \"Local Job\", TARGET.FileSystemDomain), TARGET.GLIDEIN_Site), TARGET.GLIDEIN_ResourceName)])"
        SUBMIT_EXPRS = $(SUBMIT_EXPRS) JOBGLIDEIN_ResourceName

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
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.33.bosco-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.33.bosco-1.osg33.el6)
-   [globus-authz-3.15-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-authz-3.15-1.osg33.el6)
-   [globus-authz-callout-error-3.6-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-authz-callout-error-3.6-1.osg33.el6)
-   [globus-callout-3.15-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-callout-3.15-1.osg33.el6)
-   [globus-common-17.1-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-common-17.1-1.osg33.el6)
-   [globus-ftp-client-8.36-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-8.36-1.1.osg33.el6)
-   [globus-ftp-control-7.8-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-control-7.8-1.osg33.el6)
-   [globus-gass-cache-9.10-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-cache-9.10-1.osg33.el6)
-   [globus-gass-cache-program-6.7-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-cache-program-6.7-1.osg33.el6)
-   [globus-gass-copy-9.27-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-copy-9.27-1.osg33.el6)
-   [globus-gass-server-ez-5.8-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-server-ez-5.8-1.osg33.el6)
-   [globus-gass-transfer-8.10-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-transfer-8.10-1.osg33.el6)
-   [globus-gfork-4.9-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gfork-4.9-1.osg33.el6)
-   [globus-gridftp-osg-extensions-0.4-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.4-1.osg33.el6)
-   [globus-gridftp-server-12.2-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.2-1.1.osg33.el6)
-   [globus-gridftp-server-control-5.1-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-5.1-1.1.osg33.el6)
-   [globus-gridmap-callout-error-2.5-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridmap-callout-error-2.5-1.osg33.el6)
-   [globus-gsi-callback-5.13-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-callback-5.13-1.osg33.el6)
-   [globus-gsi-cert-utils-9.16-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-cert-utils-9.16-1.osg33.el6)
-   [globus-gsi-credential-7.11-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-credential-7.11-1.osg33.el6)
-   [globus-gsi-openssl-error-3.8-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-openssl-error-3.8-1.osg33.el6)
-   [globus-gsi-proxy-core-8.6-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-proxy-core-8.6-1.osg33.el6)
-   [globus-gsi-proxy-ssl-5.10-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-proxy-ssl-5.10-1.osg33.el6)
-   [globus-gsi-sysconfig-6.11-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-sysconfig-6.11-1.osg33.el6)
-   [globus-gss-assist-10.21-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gss-assist-10.21-1.osg33.el6)
-   [globus-gssapi-error-5.5-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gssapi-error-5.5-1.osg33.el6)
-   [globus-gssapi-gsi-12.17-3.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gssapi-gsi-12.17-3.osg33.el6)
-   [globus-io-11.9-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-io-11.9-1.osg33.el6)
-   [globus-openssl-module-4.8-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-openssl-module-4.8-1.osg33.el6)
-   [globus-proxy-utils-6.19-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-proxy-utils-6.19-1.osg33.el6)
-   [globus-rsl-10.11-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-rsl-10.11-1.osg33.el6)
-   [globus-simple-ca-4.24-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-simple-ca-4.24-1.osg33.el6)
-   [globus-usage-4.5-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-usage-4.5-1.osg33.el6)
-   [globus-xio-5.16-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-5.16-1.osg33.el6)
-   [globus-xio-gsi-driver-3.11-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-gsi-driver-3.11-1.osg33.el6)
-   [globus-xio-pipe-driver-3.10-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-pipe-driver-3.10-1.osg33.el6)
-   [globus-xio-popen-driver-3.6-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-popen-driver-3.6-1.osg33.el6)
-   [globus-xio-udt-driver-1.28-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-udt-driver-1.28-1.osg33.el6)
-   [globus-xioperf-4.5-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xioperf-4.5-1.osg33.el6)
-   [gridftp-hdfs-1.0-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-hdfs-1.0-1.1.osg33.el6)
-   [gums-1.5.2-10.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gums-1.5.2-10.osg33.el6)
-   [htcondor-ce-2.2.3-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.3-1.osg33.el6)
-   [myproxy-6.1.28-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.1.28-1.1.osg33.el6)
-   [osg-ca-scripts-1.1.7-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.7-1.osg33.el6)
-   [osg-configure-1.10.0-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.10.0-1.osg33.el6)
-   [osg-test-1.11.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.2-1.osg33.el6)
-   [osg-version-3.3.28-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.28-1.osg33.el6)
-   [xrootd-4.7.0-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.7.0-1.osg33.el6)
-   [xrootd-hdfs-1.9.2-2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.9.2-2.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.33.bosco-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.33.bosco-1.osg33.el7)
-   [globus-authz-3.15-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-authz-3.15-1.osg33.el7)
-   [globus-authz-callout-error-3.6-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-authz-callout-error-3.6-1.osg33.el7)
-   [globus-callout-3.15-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-callout-3.15-1.osg33.el7)
-   [globus-common-17.1-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-common-17.1-1.osg33.el7)
-   [globus-ftp-client-8.36-1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-client-8.36-1.1.osg33.el7)
-   [globus-ftp-control-7.8-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-ftp-control-7.8-1.osg33.el7)
-   [globus-gass-cache-9.10-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-cache-9.10-1.osg33.el7)
-   [globus-gass-cache-program-6.7-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-cache-program-6.7-1.osg33.el7)
-   [globus-gass-copy-9.27-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-copy-9.27-1.osg33.el7)
-   [globus-gass-server-ez-5.8-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-server-ez-5.8-1.osg33.el7)
-   [globus-gass-transfer-8.10-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gass-transfer-8.10-1.osg33.el7)
-   [globus-gfork-4.9-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gfork-4.9-1.osg33.el7)
-   [globus-gridftp-osg-extensions-0.4-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-osg-extensions-0.4-1.osg33.el7)
-   [globus-gridftp-server-12.2-1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-12.2-1.1.osg33.el7)
-   [globus-gridftp-server-control-5.1-1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-5.1-1.1.osg33.el7)
-   [globus-gridmap-callout-error-2.5-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridmap-callout-error-2.5-1.osg33.el7)
-   [globus-gsi-callback-5.13-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-callback-5.13-1.osg33.el7)
-   [globus-gsi-cert-utils-9.16-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-cert-utils-9.16-1.osg33.el7)
-   [globus-gsi-credential-7.11-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-credential-7.11-1.osg33.el7)
-   [globus-gsi-openssl-error-3.8-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-openssl-error-3.8-1.osg33.el7)
-   [globus-gsi-proxy-core-8.6-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-proxy-core-8.6-1.osg33.el7)
-   [globus-gsi-proxy-ssl-5.10-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-proxy-ssl-5.10-1.osg33.el7)
-   [globus-gsi-sysconfig-6.11-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gsi-sysconfig-6.11-1.osg33.el7)
-   [globus-gss-assist-10.21-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gss-assist-10.21-1.osg33.el7)
-   [globus-gssapi-error-5.5-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gssapi-error-5.5-1.osg33.el7)
-   [globus-gssapi-gsi-12.17-3.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gssapi-gsi-12.17-3.osg33.el7)
-   [globus-io-11.9-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-io-11.9-1.osg33.el7)
-   [globus-openssl-module-4.8-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-openssl-module-4.8-1.osg33.el7)
-   [globus-proxy-utils-6.19-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-proxy-utils-6.19-1.osg33.el7)
-   [globus-rsl-10.11-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-rsl-10.11-1.osg33.el7)
-   [globus-simple-ca-4.24-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-simple-ca-4.24-1.osg33.el7)
-   [globus-usage-4.5-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-usage-4.5-1.osg33.el7)
-   [globus-xio-5.16-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-5.16-1.osg33.el7)
-   [globus-xio-gsi-driver-3.11-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-gsi-driver-3.11-1.osg33.el7)
-   [globus-xio-pipe-driver-3.10-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-pipe-driver-3.10-1.osg33.el7)
-   [globus-xio-popen-driver-3.6-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-popen-driver-3.6-1.osg33.el7)
-   [globus-xio-udt-driver-1.28-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-udt-driver-1.28-1.osg33.el7)
-   [globus-xioperf-4.5-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xioperf-4.5-1.osg33.el7)
-   [gridftp-hdfs-1.0-1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gridftp-hdfs-1.0-1.1.osg33.el7)
-   [gums-1.5.2-10.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gums-1.5.2-10.osg33.el7)
-   [htcondor-ce-2.2.3-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.3-1.osg33.el7)
-   [myproxy-6.1.28-1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.1.28-1.1.osg33.el7)
-   [osg-ca-scripts-1.1.7-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.7-1.osg33.el7)
-   [osg-configure-1.10.0-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.10.0-1.osg33.el7)
-   [osg-test-1.11.2-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.2-1.osg33.el7)
-   [osg-version-3.3.28-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.28-1.osg33.el7)
-   [stashcache-0.8-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-0.8-1.osg33.el7)
-   [xrootd-4.7.0-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.7.0-1.osg33.el7)
-   [xrootd-hdfs-1.9.2-2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-1.9.2-2.osg33.el7)
-   [xrootd-lcmaps-1.3.4-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.3.4-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo globus-authz globus-authz-callout-error globus-authz-callout-error-debuginfo globus-authz-callout-error-devel globus-authz-callout-error-doc globus-authz-debuginfo globus-authz-devel globus-authz-doc globus-callout globus-callout-debuginfo globus-callout-devel globus-callout-doc globus-common globus-common-debuginfo globus-common-devel globus-common-doc globus-common-progs globus-ftp-client globus-ftp-client-debuginfo globus-ftp-client-devel globus-ftp-client-doc globus-ftp-control globus-ftp-control-debuginfo globus-ftp-control-devel globus-ftp-control-doc globus-gass-cache globus-gass-cache-debuginfo globus-gass-cache-devel globus-gass-cache-doc globus-gass-cache-program globus-gass-cache-program-debuginfo globus-gass-copy globus-gass-copy-debuginfo globus-gass-copy-devel globus-gass-copy-doc globus-gass-copy-progs globus-gass-server-ez globus-gass-server-ez-debuginfo globus-gass-server-ez-devel globus-gass-server-ez-progs globus-gass-transfer globus-gass-transfer-debuginfo globus-gass-transfer-devel globus-gass-transfer-doc globus-gfork globus-gfork-debuginfo globus-gfork-devel globus-gfork-progs globus-gridftp-osg-extensions globus-gridftp-osg-extensions-debuginfo globus-gridftp-server globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs globus-gridmap-callout-error globus-gridmap-callout-error-debuginfo globus-gridmap-callout-error-devel globus-gridmap-callout-error-doc globus-gsi-callback globus-gsi-callback-debuginfo globus-gsi-callback-devel globus-gsi-callback-doc globus-gsi-cert-utils globus-gsi-cert-utils-debuginfo globus-gsi-cert-utils-devel globus-gsi-cert-utils-doc globus-gsi-cert-utils-progs globus-gsi-credential globus-gsi-credential-debuginfo globus-gsi-credential-devel globus-gsi-credential-doc globus-gsi-openssl-error globus-gsi-openssl-error-debuginfo globus-gsi-openssl-error-devel globus-gsi-openssl-error-doc globus-gsi-proxy-core globus-gsi-proxy-core-debuginfo globus-gsi-proxy-core-devel globus-gsi-proxy-core-doc globus-gsi-proxy-ssl globus-gsi-proxy-ssl-debuginfo globus-gsi-proxy-ssl-devel globus-gsi-proxy-ssl-doc globus-gsi-sysconfig globus-gsi-sysconfig-debuginfo globus-gsi-sysconfig-devel globus-gsi-sysconfig-doc globus-gssapi-error globus-gssapi-error-debuginfo globus-gssapi-error-devel globus-gssapi-error-doc globus-gssapi-gsi globus-gssapi-gsi-debuginfo globus-gssapi-gsi-devel globus-gssapi-gsi-doc globus-gss-assist globus-gss-assist-debuginfo globus-gss-assist-devel globus-gss-assist-doc globus-gss-assist-progs globus-io globus-io-debuginfo globus-io-devel globus-openssl-module globus-openssl-module-debuginfo globus-openssl-module-devel globus-openssl-module-doc globus-proxy-utils globus-proxy-utils-debuginfo globus-rsl globus-rsl-debuginfo globus-rsl-devel globus-rsl-doc globus-simple-ca globus-usage globus-usage-debuginfo globus-usage-devel globus-xio globus-xio-debuginfo globus-xio-devel globus-xio-doc globus-xio-gsi-driver globus-xio-gsi-driver-debuginfo globus-xio-gsi-driver-devel globus-xio-gsi-driver-doc globus-xioperf globus-xioperf-debuginfo globus-xio-pipe-driver globus-xio-pipe-driver-debuginfo globus-xio-pipe-driver-devel globus-xio-popen-driver globus-xio-popen-driver-debuginfo globus-xio-popen-driver-devel globus-xio-udt-driver globus-xio-udt-driver-debuginfo globus-xio-udt-driver-devel gridftp-hdfs gridftp-hdfs-debuginfo gums gums-client gums-service htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-ca-certs osg-ca-scripts osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-test osg-test-log-viewer osg-version xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.33.bosco-1.osg33.el6
blahp-debuginfo-1.18.33.bosco-1.osg33.el6
globus-authz-3.15-1.osg33.el6
globus-authz-callout-error-3.6-1.osg33.el6
globus-authz-callout-error-debuginfo-3.6-1.osg33.el6
globus-authz-callout-error-devel-3.6-1.osg33.el6
globus-authz-callout-error-doc-3.6-1.osg33.el6
globus-authz-debuginfo-3.15-1.osg33.el6
globus-authz-devel-3.15-1.osg33.el6
globus-authz-doc-3.15-1.osg33.el6
globus-callout-3.15-1.osg33.el6
globus-callout-debuginfo-3.15-1.osg33.el6
globus-callout-devel-3.15-1.osg33.el6
globus-callout-doc-3.15-1.osg33.el6
globus-common-17.1-1.osg33.el6
globus-common-debuginfo-17.1-1.osg33.el6
globus-common-devel-17.1-1.osg33.el6
globus-common-doc-17.1-1.osg33.el6
globus-common-progs-17.1-1.osg33.el6
globus-ftp-client-8.36-1.1.osg33.el6
globus-ftp-client-debuginfo-8.36-1.1.osg33.el6
globus-ftp-client-devel-8.36-1.1.osg33.el6
globus-ftp-client-doc-8.36-1.1.osg33.el6
globus-ftp-control-7.8-1.osg33.el6
globus-ftp-control-debuginfo-7.8-1.osg33.el6
globus-ftp-control-devel-7.8-1.osg33.el6
globus-ftp-control-doc-7.8-1.osg33.el6
globus-gass-cache-9.10-1.osg33.el6
globus-gass-cache-debuginfo-9.10-1.osg33.el6
globus-gass-cache-devel-9.10-1.osg33.el6
globus-gass-cache-doc-9.10-1.osg33.el6
globus-gass-cache-program-6.7-1.osg33.el6
globus-gass-cache-program-debuginfo-6.7-1.osg33.el6
globus-gass-copy-9.27-1.osg33.el6
globus-gass-copy-debuginfo-9.27-1.osg33.el6
globus-gass-copy-devel-9.27-1.osg33.el6
globus-gass-copy-doc-9.27-1.osg33.el6
globus-gass-copy-progs-9.27-1.osg33.el6
globus-gass-server-ez-5.8-1.osg33.el6
globus-gass-server-ez-debuginfo-5.8-1.osg33.el6
globus-gass-server-ez-devel-5.8-1.osg33.el6
globus-gass-server-ez-progs-5.8-1.osg33.el6
globus-gass-transfer-8.10-1.osg33.el6
globus-gass-transfer-debuginfo-8.10-1.osg33.el6
globus-gass-transfer-devel-8.10-1.osg33.el6
globus-gass-transfer-doc-8.10-1.osg33.el6
globus-gfork-4.9-1.osg33.el6
globus-gfork-debuginfo-4.9-1.osg33.el6
globus-gfork-devel-4.9-1.osg33.el6
globus-gfork-progs-4.9-1.osg33.el6
globus-gridftp-osg-extensions-0.4-1.osg33.el6
globus-gridftp-osg-extensions-debuginfo-0.4-1.osg33.el6
globus-gridftp-server-12.2-1.1.osg33.el6
globus-gridftp-server-control-5.1-1.1.osg33.el6
globus-gridftp-server-control-debuginfo-5.1-1.1.osg33.el6
globus-gridftp-server-control-devel-5.1-1.1.osg33.el6
globus-gridftp-server-debuginfo-12.2-1.1.osg33.el6
globus-gridftp-server-devel-12.2-1.1.osg33.el6
globus-gridftp-server-progs-12.2-1.1.osg33.el6
globus-gridmap-callout-error-2.5-1.osg33.el6
globus-gridmap-callout-error-debuginfo-2.5-1.osg33.el6
globus-gridmap-callout-error-devel-2.5-1.osg33.el6
globus-gridmap-callout-error-doc-2.5-1.osg33.el6
globus-gsi-callback-5.13-1.osg33.el6
globus-gsi-callback-debuginfo-5.13-1.osg33.el6
globus-gsi-callback-devel-5.13-1.osg33.el6
globus-gsi-callback-doc-5.13-1.osg33.el6
globus-gsi-cert-utils-9.16-1.osg33.el6
globus-gsi-cert-utils-debuginfo-9.16-1.osg33.el6
globus-gsi-cert-utils-devel-9.16-1.osg33.el6
globus-gsi-cert-utils-doc-9.16-1.osg33.el6
globus-gsi-cert-utils-progs-9.16-1.osg33.el6
globus-gsi-credential-7.11-1.osg33.el6
globus-gsi-credential-debuginfo-7.11-1.osg33.el6
globus-gsi-credential-devel-7.11-1.osg33.el6
globus-gsi-credential-doc-7.11-1.osg33.el6
globus-gsi-openssl-error-3.8-1.osg33.el6
globus-gsi-openssl-error-debuginfo-3.8-1.osg33.el6
globus-gsi-openssl-error-devel-3.8-1.osg33.el6
globus-gsi-openssl-error-doc-3.8-1.osg33.el6
globus-gsi-proxy-core-8.6-1.osg33.el6
globus-gsi-proxy-core-debuginfo-8.6-1.osg33.el6
globus-gsi-proxy-core-devel-8.6-1.osg33.el6
globus-gsi-proxy-core-doc-8.6-1.osg33.el6
globus-gsi-proxy-ssl-5.10-1.osg33.el6
globus-gsi-proxy-ssl-debuginfo-5.10-1.osg33.el6
globus-gsi-proxy-ssl-devel-5.10-1.osg33.el6
globus-gsi-proxy-ssl-doc-5.10-1.osg33.el6
globus-gsi-sysconfig-6.11-1.osg33.el6
globus-gsi-sysconfig-debuginfo-6.11-1.osg33.el6
globus-gsi-sysconfig-devel-6.11-1.osg33.el6
globus-gsi-sysconfig-doc-6.11-1.osg33.el6
globus-gssapi-error-5.5-1.osg33.el6
globus-gssapi-error-debuginfo-5.5-1.osg33.el6
globus-gssapi-error-devel-5.5-1.osg33.el6
globus-gssapi-error-doc-5.5-1.osg33.el6
globus-gssapi-gsi-12.17-3.osg33.el6
globus-gssapi-gsi-debuginfo-12.17-3.osg33.el6
globus-gssapi-gsi-devel-12.17-3.osg33.el6
globus-gssapi-gsi-doc-12.17-3.osg33.el6
globus-gss-assist-10.21-1.osg33.el6
globus-gss-assist-debuginfo-10.21-1.osg33.el6
globus-gss-assist-devel-10.21-1.osg33.el6
globus-gss-assist-doc-10.21-1.osg33.el6
globus-gss-assist-progs-10.21-1.osg33.el6
globus-io-11.9-1.osg33.el6
globus-io-debuginfo-11.9-1.osg33.el6
globus-io-devel-11.9-1.osg33.el6
globus-openssl-module-4.8-1.osg33.el6
globus-openssl-module-debuginfo-4.8-1.osg33.el6
globus-openssl-module-devel-4.8-1.osg33.el6
globus-openssl-module-doc-4.8-1.osg33.el6
globus-proxy-utils-6.19-1.osg33.el6
globus-proxy-utils-debuginfo-6.19-1.osg33.el6
globus-rsl-10.11-1.osg33.el6
globus-rsl-debuginfo-10.11-1.osg33.el6
globus-rsl-devel-10.11-1.osg33.el6
globus-rsl-doc-10.11-1.osg33.el6
globus-simple-ca-4.24-1.osg33.el6
globus-usage-4.5-1.osg33.el6
globus-usage-debuginfo-4.5-1.osg33.el6
globus-usage-devel-4.5-1.osg33.el6
globus-xio-5.16-1.osg33.el6
globus-xio-debuginfo-5.16-1.osg33.el6
globus-xio-devel-5.16-1.osg33.el6
globus-xio-doc-5.16-1.osg33.el6
globus-xio-gsi-driver-3.11-1.osg33.el6
globus-xio-gsi-driver-debuginfo-3.11-1.osg33.el6
globus-xio-gsi-driver-devel-3.11-1.osg33.el6
globus-xio-gsi-driver-doc-3.11-1.osg33.el6
globus-xioperf-4.5-1.osg33.el6
globus-xioperf-debuginfo-4.5-1.osg33.el6
globus-xio-pipe-driver-3.10-1.osg33.el6
globus-xio-pipe-driver-debuginfo-3.10-1.osg33.el6
globus-xio-pipe-driver-devel-3.10-1.osg33.el6
globus-xio-popen-driver-3.6-1.osg33.el6
globus-xio-popen-driver-debuginfo-3.6-1.osg33.el6
globus-xio-popen-driver-devel-3.6-1.osg33.el6
globus-xio-udt-driver-1.28-1.osg33.el6
globus-xio-udt-driver-debuginfo-1.28-1.osg33.el6
globus-xio-udt-driver-devel-1.28-1.osg33.el6
gridftp-hdfs-1.0-1.1.osg33.el6
gridftp-hdfs-debuginfo-1.0-1.1.osg33.el6
gums-1.5.2-10.osg33.el6
gums-client-1.5.2-10.osg33.el6
gums-service-1.5.2-10.osg33.el6
htcondor-ce-2.2.3-1.osg33.el6
htcondor-ce-bosco-2.2.3-1.osg33.el6
htcondor-ce-client-2.2.3-1.osg33.el6
htcondor-ce-collector-2.2.3-1.osg33.el6
htcondor-ce-condor-2.2.3-1.osg33.el6
htcondor-ce-lsf-2.2.3-1.osg33.el6
htcondor-ce-pbs-2.2.3-1.osg33.el6
htcondor-ce-sge-2.2.3-1.osg33.el6
htcondor-ce-slurm-2.2.3-1.osg33.el6
htcondor-ce-view-2.2.3-1.osg33.el6
myproxy-6.1.28-1.1.osg33.el6
myproxy-admin-6.1.28-1.1.osg33.el6
myproxy-debuginfo-6.1.28-1.1.osg33.el6
myproxy-devel-6.1.28-1.1.osg33.el6
myproxy-doc-6.1.28-1.1.osg33.el6
myproxy-libs-6.1.28-1.1.osg33.el6
myproxy-server-6.1.28-1.1.osg33.el6
myproxy-voms-6.1.28-1.1.osg33.el6
osg-ca-scripts-1.1.7-1.osg33.el6
osg-configure-1.10.0-1.osg33.el6
osg-configure-bosco-1.10.0-1.osg33.el6
osg-configure-ce-1.10.0-1.osg33.el6
osg-configure-cemon-1.10.0-1.osg33.el6
osg-configure-condor-1.10.0-1.osg33.el6
osg-configure-gateway-1.10.0-1.osg33.el6
osg-configure-gip-1.10.0-1.osg33.el6
osg-configure-gratia-1.10.0-1.osg33.el6
osg-configure-infoservices-1.10.0-1.osg33.el6
osg-configure-lsf-1.10.0-1.osg33.el6
osg-configure-managedfork-1.10.0-1.osg33.el6
osg-configure-misc-1.10.0-1.osg33.el6
osg-configure-monalisa-1.10.0-1.osg33.el6
osg-configure-network-1.10.0-1.osg33.el6
osg-configure-pbs-1.10.0-1.osg33.el6
osg-configure-rsv-1.10.0-1.osg33.el6
osg-configure-sge-1.10.0-1.osg33.el6
osg-configure-slurm-1.10.0-1.osg33.el6
osg-configure-squid-1.10.0-1.osg33.el6
osg-configure-tests-1.10.0-1.osg33.el6
osg-test-1.11.2-1.osg33.el6
osg-test-log-viewer-1.11.2-1.osg33.el6
osg-version-3.3.28-1.osg33.el6
xrootd-4.7.0-1.osg33.el6
xrootd-client-4.7.0-1.osg33.el6
xrootd-client-devel-4.7.0-1.osg33.el6
xrootd-client-libs-4.7.0-1.osg33.el6
xrootd-debuginfo-4.7.0-1.osg33.el6
xrootd-devel-4.7.0-1.osg33.el6
xrootd-doc-4.7.0-1.osg33.el6
xrootd-fuse-4.7.0-1.osg33.el6
xrootd-hdfs-1.9.2-2.osg33.el6
xrootd-hdfs-debuginfo-1.9.2-2.osg33.el6
xrootd-hdfs-devel-1.9.2-2.osg33.el6
xrootd-libs-4.7.0-1.osg33.el6
xrootd-private-devel-4.7.0-1.osg33.el6
xrootd-python-4.7.0-1.osg33.el6
xrootd-selinux-4.7.0-1.osg33.el6
xrootd-server-4.7.0-1.osg33.el6
xrootd-server-devel-4.7.0-1.osg33.el6
xrootd-server-libs-4.7.0-1.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.33.bosco-1.osg33.el7
blahp-debuginfo-1.18.33.bosco-1.osg33.el7
globus-authz-3.15-1.osg33.el7
globus-authz-callout-error-3.6-1.osg33.el7
globus-authz-callout-error-debuginfo-3.6-1.osg33.el7
globus-authz-callout-error-devel-3.6-1.osg33.el7
globus-authz-callout-error-doc-3.6-1.osg33.el7
globus-authz-debuginfo-3.15-1.osg33.el7
globus-authz-devel-3.15-1.osg33.el7
globus-authz-doc-3.15-1.osg33.el7
globus-callout-3.15-1.osg33.el7
globus-callout-debuginfo-3.15-1.osg33.el7
globus-callout-devel-3.15-1.osg33.el7
globus-callout-doc-3.15-1.osg33.el7
globus-common-17.1-1.osg33.el7
globus-common-debuginfo-17.1-1.osg33.el7
globus-common-devel-17.1-1.osg33.el7
globus-common-doc-17.1-1.osg33.el7
globus-common-progs-17.1-1.osg33.el7
globus-ftp-client-8.36-1.1.osg33.el7
globus-ftp-client-debuginfo-8.36-1.1.osg33.el7
globus-ftp-client-devel-8.36-1.1.osg33.el7
globus-ftp-client-doc-8.36-1.1.osg33.el7
globus-ftp-control-7.8-1.osg33.el7
globus-ftp-control-debuginfo-7.8-1.osg33.el7
globus-ftp-control-devel-7.8-1.osg33.el7
globus-ftp-control-doc-7.8-1.osg33.el7
globus-gass-cache-9.10-1.osg33.el7
globus-gass-cache-debuginfo-9.10-1.osg33.el7
globus-gass-cache-devel-9.10-1.osg33.el7
globus-gass-cache-doc-9.10-1.osg33.el7
globus-gass-cache-program-6.7-1.osg33.el7
globus-gass-cache-program-debuginfo-6.7-1.osg33.el7
globus-gass-copy-9.27-1.osg33.el7
globus-gass-copy-debuginfo-9.27-1.osg33.el7
globus-gass-copy-devel-9.27-1.osg33.el7
globus-gass-copy-doc-9.27-1.osg33.el7
globus-gass-copy-progs-9.27-1.osg33.el7
globus-gass-server-ez-5.8-1.osg33.el7
globus-gass-server-ez-debuginfo-5.8-1.osg33.el7
globus-gass-server-ez-devel-5.8-1.osg33.el7
globus-gass-server-ez-progs-5.8-1.osg33.el7
globus-gass-transfer-8.10-1.osg33.el7
globus-gass-transfer-debuginfo-8.10-1.osg33.el7
globus-gass-transfer-devel-8.10-1.osg33.el7
globus-gass-transfer-doc-8.10-1.osg33.el7
globus-gfork-4.9-1.osg33.el7
globus-gfork-debuginfo-4.9-1.osg33.el7
globus-gfork-devel-4.9-1.osg33.el7
globus-gfork-progs-4.9-1.osg33.el7
globus-gridftp-osg-extensions-0.4-1.osg33.el7
globus-gridftp-osg-extensions-debuginfo-0.4-1.osg33.el7
globus-gridftp-server-12.2-1.1.osg33.el7
globus-gridftp-server-control-5.1-1.1.osg33.el7
globus-gridftp-server-control-debuginfo-5.1-1.1.osg33.el7
globus-gridftp-server-control-devel-5.1-1.1.osg33.el7
globus-gridftp-server-debuginfo-12.2-1.1.osg33.el7
globus-gridftp-server-devel-12.2-1.1.osg33.el7
globus-gridftp-server-progs-12.2-1.1.osg33.el7
globus-gridmap-callout-error-2.5-1.osg33.el7
globus-gridmap-callout-error-debuginfo-2.5-1.osg33.el7
globus-gridmap-callout-error-devel-2.5-1.osg33.el7
globus-gridmap-callout-error-doc-2.5-1.osg33.el7
globus-gsi-callback-5.13-1.osg33.el7
globus-gsi-callback-debuginfo-5.13-1.osg33.el7
globus-gsi-callback-devel-5.13-1.osg33.el7
globus-gsi-callback-doc-5.13-1.osg33.el7
globus-gsi-cert-utils-9.16-1.osg33.el7
globus-gsi-cert-utils-debuginfo-9.16-1.osg33.el7
globus-gsi-cert-utils-devel-9.16-1.osg33.el7
globus-gsi-cert-utils-doc-9.16-1.osg33.el7
globus-gsi-cert-utils-progs-9.16-1.osg33.el7
globus-gsi-credential-7.11-1.osg33.el7
globus-gsi-credential-debuginfo-7.11-1.osg33.el7
globus-gsi-credential-devel-7.11-1.osg33.el7
globus-gsi-credential-doc-7.11-1.osg33.el7
globus-gsi-openssl-error-3.8-1.osg33.el7
globus-gsi-openssl-error-debuginfo-3.8-1.osg33.el7
globus-gsi-openssl-error-devel-3.8-1.osg33.el7
globus-gsi-openssl-error-doc-3.8-1.osg33.el7
globus-gsi-proxy-core-8.6-1.osg33.el7
globus-gsi-proxy-core-debuginfo-8.6-1.osg33.el7
globus-gsi-proxy-core-devel-8.6-1.osg33.el7
globus-gsi-proxy-core-doc-8.6-1.osg33.el7
globus-gsi-proxy-ssl-5.10-1.osg33.el7
globus-gsi-proxy-ssl-debuginfo-5.10-1.osg33.el7
globus-gsi-proxy-ssl-devel-5.10-1.osg33.el7
globus-gsi-proxy-ssl-doc-5.10-1.osg33.el7
globus-gsi-sysconfig-6.11-1.osg33.el7
globus-gsi-sysconfig-debuginfo-6.11-1.osg33.el7
globus-gsi-sysconfig-devel-6.11-1.osg33.el7
globus-gsi-sysconfig-doc-6.11-1.osg33.el7
globus-gssapi-error-5.5-1.osg33.el7
globus-gssapi-error-debuginfo-5.5-1.osg33.el7
globus-gssapi-error-devel-5.5-1.osg33.el7
globus-gssapi-error-doc-5.5-1.osg33.el7
globus-gssapi-gsi-12.17-3.osg33.el7
globus-gssapi-gsi-debuginfo-12.17-3.osg33.el7
globus-gssapi-gsi-devel-12.17-3.osg33.el7
globus-gssapi-gsi-doc-12.17-3.osg33.el7
globus-gss-assist-10.21-1.osg33.el7
globus-gss-assist-debuginfo-10.21-1.osg33.el7
globus-gss-assist-devel-10.21-1.osg33.el7
globus-gss-assist-doc-10.21-1.osg33.el7
globus-gss-assist-progs-10.21-1.osg33.el7
globus-io-11.9-1.osg33.el7
globus-io-debuginfo-11.9-1.osg33.el7
globus-io-devel-11.9-1.osg33.el7
globus-openssl-module-4.8-1.osg33.el7
globus-openssl-module-debuginfo-4.8-1.osg33.el7
globus-openssl-module-devel-4.8-1.osg33.el7
globus-openssl-module-doc-4.8-1.osg33.el7
globus-proxy-utils-6.19-1.osg33.el7
globus-proxy-utils-debuginfo-6.19-1.osg33.el7
globus-rsl-10.11-1.osg33.el7
globus-rsl-debuginfo-10.11-1.osg33.el7
globus-rsl-devel-10.11-1.osg33.el7
globus-rsl-doc-10.11-1.osg33.el7
globus-simple-ca-4.24-1.osg33.el7
globus-usage-4.5-1.osg33.el7
globus-usage-debuginfo-4.5-1.osg33.el7
globus-usage-devel-4.5-1.osg33.el7
globus-xio-5.16-1.osg33.el7
globus-xio-debuginfo-5.16-1.osg33.el7
globus-xio-devel-5.16-1.osg33.el7
globus-xio-doc-5.16-1.osg33.el7
globus-xio-gsi-driver-3.11-1.osg33.el7
globus-xio-gsi-driver-debuginfo-3.11-1.osg33.el7
globus-xio-gsi-driver-devel-3.11-1.osg33.el7
globus-xio-gsi-driver-doc-3.11-1.osg33.el7
globus-xioperf-4.5-1.osg33.el7
globus-xioperf-debuginfo-4.5-1.osg33.el7
globus-xio-pipe-driver-3.10-1.osg33.el7
globus-xio-pipe-driver-debuginfo-3.10-1.osg33.el7
globus-xio-pipe-driver-devel-3.10-1.osg33.el7
globus-xio-popen-driver-3.6-1.osg33.el7
globus-xio-popen-driver-debuginfo-3.6-1.osg33.el7
globus-xio-popen-driver-devel-3.6-1.osg33.el7
globus-xio-udt-driver-1.28-1.osg33.el7
globus-xio-udt-driver-debuginfo-1.28-1.osg33.el7
globus-xio-udt-driver-devel-1.28-1.osg33.el7
gridftp-hdfs-1.0-1.1.osg33.el7
gridftp-hdfs-debuginfo-1.0-1.1.osg33.el7
gums-1.5.2-10.osg33.el7
gums-client-1.5.2-10.osg33.el7
gums-service-1.5.2-10.osg33.el7
htcondor-ce-2.2.3-1.osg33.el7
htcondor-ce-bosco-2.2.3-1.osg33.el7
htcondor-ce-client-2.2.3-1.osg33.el7
htcondor-ce-collector-2.2.3-1.osg33.el7
htcondor-ce-condor-2.2.3-1.osg33.el7
htcondor-ce-lsf-2.2.3-1.osg33.el7
htcondor-ce-pbs-2.2.3-1.osg33.el7
htcondor-ce-sge-2.2.3-1.osg33.el7
htcondor-ce-slurm-2.2.3-1.osg33.el7
htcondor-ce-view-2.2.3-1.osg33.el7
myproxy-6.1.28-1.1.osg33.el7
myproxy-admin-6.1.28-1.1.osg33.el7
myproxy-debuginfo-6.1.28-1.1.osg33.el7
myproxy-devel-6.1.28-1.1.osg33.el7
myproxy-doc-6.1.28-1.1.osg33.el7
myproxy-libs-6.1.28-1.1.osg33.el7
myproxy-server-6.1.28-1.1.osg33.el7
myproxy-voms-6.1.28-1.1.osg33.el7
osg-ca-scripts-1.1.7-1.osg33.el7
osg-configure-1.10.0-1.osg33.el7
osg-configure-bosco-1.10.0-1.osg33.el7
osg-configure-ce-1.10.0-1.osg33.el7
osg-configure-cemon-1.10.0-1.osg33.el7
osg-configure-condor-1.10.0-1.osg33.el7
osg-configure-gateway-1.10.0-1.osg33.el7
osg-configure-gip-1.10.0-1.osg33.el7
osg-configure-gratia-1.10.0-1.osg33.el7
osg-configure-infoservices-1.10.0-1.osg33.el7
osg-configure-lsf-1.10.0-1.osg33.el7
osg-configure-managedfork-1.10.0-1.osg33.el7
osg-configure-misc-1.10.0-1.osg33.el7
osg-configure-monalisa-1.10.0-1.osg33.el7
osg-configure-network-1.10.0-1.osg33.el7
osg-configure-pbs-1.10.0-1.osg33.el7
osg-configure-rsv-1.10.0-1.osg33.el7
osg-configure-sge-1.10.0-1.osg33.el7
osg-configure-slurm-1.10.0-1.osg33.el7
osg-configure-squid-1.10.0-1.osg33.el7
osg-configure-tests-1.10.0-1.osg33.el7
osg-test-1.11.2-1.osg33.el7
osg-test-log-viewer-1.11.2-1.osg33.el7
osg-version-3.3.28-1.osg33.el7
stashcache-0.8-1.osg33.el7
stashcache-cache-server-0.8-1.osg33.el7
stashcache-daemon-0.8-1.osg33.el7
stashcache-origin-server-0.8-1.osg33.el7
xrootd-4.7.0-1.osg33.el7
xrootd-client-4.7.0-1.osg33.el7
xrootd-client-devel-4.7.0-1.osg33.el7
xrootd-client-libs-4.7.0-1.osg33.el7
xrootd-debuginfo-4.7.0-1.osg33.el7
xrootd-devel-4.7.0-1.osg33.el7
xrootd-doc-4.7.0-1.osg33.el7
xrootd-fuse-4.7.0-1.osg33.el7
xrootd-hdfs-1.9.2-2.osg33.el7
xrootd-hdfs-debuginfo-1.9.2-2.osg33.el7
xrootd-hdfs-devel-1.9.2-2.osg33.el7
xrootd-lcmaps-1.3.4-1.osg33.el7
xrootd-lcmaps-debuginfo-1.3.4-1.osg33.el7
xrootd-libs-4.7.0-1.osg33.el7
xrootd-private-devel-4.7.0-1.osg33.el7
xrootd-python-4.7.0-1.osg33.el7
xrootd-selinux-4.7.0-1.osg33.el7
xrootd-server-4.7.0-1.osg33.el7
xrootd-server-devel-4.7.0-1.osg33.el7
xrootd-server-libs-4.7.0-1.osg33.el7
```

