OSG Software Release 3.3.29
===========================

**Release Date**: 2017-10-10

Summary of changes
------------------

This release contains:

-   voms-admin-server: Updated to fix Apache struts vulnerability
-   Updated gsi-openssh-server to interoperate with clients using OpenSSL 1.1
-   globus-gridftp-server-control 5.2: Allow 400 responses to stat failures
-   osg-ca-scripts now properly declares its dependency on the wget package
-   Updated osg-configure to work properly when fetch-crl is missing

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.29%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note
    StashCache is supported on EL7 only.

!!! note
    xrootd-lcmaps will remain at 1.2.1-1 on EL6.

Detailed changes are below. All of the documentation can be found in the [Release3](Documentation.Release3) area of the TWiki.

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details.`. This warning can safely be ignored.
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the November release.
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

To update to this series, you need [install the current OSG repositories](Documentation.Release3.YumRepositories#Install_OSG_Repositories).

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

Do you need help with this release? [Contact us for help](HelpProcedure).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

   * [globus-gridftp-server-control-5.2-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-5.2-1.1.osg33.el6)
   * [gsi-openssh-7.3p1c-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.3p1c-1.1.osg33.el6)
   * [osg-build-1.10.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.2-1.osg33.el6)
   * [osg-ca-scripts-1.1.7-2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.7-2.osg33.el6)
   * [osg-configure-1.10.1-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.10.1-1.osg33.el6)
   * [osg-release-3.3-6.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.3-6.osg33.el6)
   * [osg-release-itb-3.3-6.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-itb-3.3-6.osg33.el6)
   * [osg-version-3.3.29-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.29-1.osg33.el6)
   * [voms-admin-server-2.7.0-1.23.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-admin-server-2.7.0-1.23.osg33.el6)

#### Enterprise Linux 7

   * [globus-gridftp-server-control-5.2-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-5.2-1.1.osg33.el6)
   * [gsi-openssh-7.3p1c-1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.3p1c-1.1.osg33.el6)
   * [osg-build-1.10.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.2-1.osg33.el6)
   * [osg-ca-scripts-1.1.7-2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.7-2.osg33.el6)
   * [osg-configure-1.10.1-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.10.1-1.osg33.el6)
   * [osg-release-3.3-6.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.3-6.osg33.el6)
   * [osg-release-itb-3.3-6.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-itb-3.3-6.osg33.el6)
   * [osg-version-3.3.29-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.29-1.osg33.el6)
   * [voms-admin-server-2.7.0-1.23.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-admin-server-2.7.0-1.23.osg33.el6)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-ca-scripts osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-release osg-release-itb osg-version voms-admin-server

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file

bus-gridftp-server-control-5.2-1.1.osg33.el6
globus-gridftp-server-control-debuginfo-5.2-1.1.osg33.el6
globus-gridftp-server-control-devel-5.2-1.1.osg33.el6
gsi-openssh-7.3p1c-1.1.osg33.el6
gsi-openssh-clients-7.3p1c-1.1.osg33.el6
gsi-openssh-debuginfo-7.3p1c-1.1.osg33.el6
gsi-openssh-server-7.3p1c-1.1.osg33.el6
osg-build-1.10.2-1.osg33.el6
osg-build-base-1.10.2-1.osg33.el6
osg-build-koji-1.10.2-1.osg33.el6
osg-build-mock-1.10.2-1.osg33.el6
osg-build-tests-1.10.2-1.osg33.el6
osg-ca-scripts-1.1.7-2.osg33.el6
osg-configure-1.10.1-1.osg33.el6
osg-configure-bosco-1.10.1-1.osg33.el6
osg-configure-ce-1.10.1-1.osg33.el6
osg-configure-cemon-1.10.1-1.osg33.el6
osg-configure-condor-1.10.1-1.osg33.el6
osg-configure-gateway-1.10.1-1.osg33.el6
osg-configure-gip-1.10.1-1.osg33.el6
osg-configure-gratia-1.10.1-1.osg33.el6
osg-configure-infoservices-1.10.1-1.osg33.el6
osg-configure-lsf-1.10.1-1.osg33.el6
osg-configure-managedfork-1.10.1-1.osg33.el6
osg-configure-misc-1.10.1-1.osg33.el6
osg-configure-monalisa-1.10.1-1.osg33.el6
osg-configure-network-1.10.1-1.osg33.el6
osg-configure-pbs-1.10.1-1.osg33.el6
osg-configure-rsv-1.10.1-1.osg33.el6
osg-configure-sge-1.10.1-1.osg33.el6
osg-configure-slurm-1.10.1-1.osg33.el6
osg-configure-squid-1.10.1-1.osg33.el6
osg-configure-tests-1.10.1-1.osg33.el6
osg-release-3.3-6.osg33.el6
osg-release-itb-3.3-6.osg33.el6
osg-version-3.3.29-1.osg33.el6
voms-admin-server-2.7.0-1.23.osg33.el6
```

#### Enterprise Linux 7

``` file
globus-gridftp-server-control-5.2-1.1.osg33.el7
globus-gridftp-server-control-debuginfo-5.2-1.1.osg33.el7
globus-gridftp-server-control-devel-5.2-1.1.osg33.el7
gsi-openssh-7.3p1c-1.1.osg33.el7
gsi-openssh-clients-7.3p1c-1.1.osg33.el7
gsi-openssh-debuginfo-7.3p1c-1.1.osg33.el7
gsi-openssh-server-7.3p1c-1.1.osg33.el7
osg-build-1.10.2-1.osg33.el7
osg-build-base-1.10.2-1.osg33.el7
osg-build-koji-1.10.2-1.osg33.el7
osg-build-mock-1.10.2-1.osg33.el7
osg-build-tests-1.10.2-1.osg33.el7
osg-ca-scripts-1.1.7-2.osg33.el7
osg-configure-1.10.1-1.osg33.el7
osg-configure-bosco-1.10.1-1.osg33.el7
osg-configure-ce-1.10.1-1.osg33.el7
osg-configure-cemon-1.10.1-1.osg33.el7
osg-configure-condor-1.10.1-1.osg33.el7
osg-configure-gateway-1.10.1-1.osg33.el7
osg-configure-gip-1.10.1-1.osg33.el7
osg-configure-gratia-1.10.1-1.osg33.el7
osg-configure-infoservices-1.10.1-1.osg33.el7
osg-configure-lsf-1.10.1-1.osg33.el7
osg-configure-managedfork-1.10.1-1.osg33.el7
osg-configure-misc-1.10.1-1.osg33.el7
osg-configure-monalisa-1.10.1-1.osg33.el7
osg-configure-network-1.10.1-1.osg33.el7
osg-configure-pbs-1.10.1-1.osg33.el7
osg-configure-rsv-1.10.1-1.osg33.el7
osg-configure-sge-1.10.1-1.osg33.el7
osg-configure-slurm-1.10.1-1.osg33.el7
osg-configure-squid-1.10.1-1.osg33.el7
osg-configure-tests-1.10.1-1.osg33.el7
osg-release-3.3-6.osg33.el7
osg-release-itb-3.3-6.osg33.el7
osg-version-3.3.29-1.osg33.el7
```
