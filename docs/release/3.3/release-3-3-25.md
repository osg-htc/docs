OSG Software Release 3.3.25
===========================

**Release Date**: 2017-06-14

Summary of changes
------------------

This release contains:

-   OSG 3.3.25
    -   Make the LCMAPS VOMS plugin consider only the first FQAN to be consistent with GUMS
    -   Update to [XRootD 4.6.1](https://github.com/xrootd/xrootd/blob/v4.6.1/docs/ReleaseNotes.txt)
        -   Update to xrootd-lcmaps 1.3.3 for EL7
    -   Update StashCache meta-packages to require XRootD 4.6.1
    -   Update to [GlideinWMS 3.2.19](http://glideinwms.fnal.gov/doc.v3_2_19/history.html)
    -   HTCondor-CE: Add WholeNodeWanted ClassAd expression so jobs can request a whole node from the batch system
    -   Add vo-client-lcmaps-voms dependency to osg-gridftp and osg-ce
    -   Updated to voms-admin-server 2.7.0-1.22 (security update)
    -   Fix osg-update-vos script to clean yum cache in order pick up the latest vo-client RPM
    -   osg-configure 1.8.1
        -   reject empty `allowed_vos` in subclusters
        -   get default `allowed_vos` from LCMAPS VOMS plugin
        -   issue warning (rather than error out) if OSG\_APP or OSG\_DATA directories are not present
    -   osg-ca-scripts now refers to repo.grid.iu.edu (rather than the retired software.grid.iu.edu)
    -   No patch to globus-xio, drop the unneeded one
    -   osg-build 1.10.0
        -   drop vdt-build alias
        -   drop ~/.osg-build.ini configuration file

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.25%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note
    StashCache is supported on EL7 only. 

!!! note
    xrootd-lcmaps will remain at 1.2.1-1 on EL6.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   Updates to VOMS admin server require the updated emi-trustmanager-tomcat and re-running the configure script:\\ <pre class=rootscreen>root@host # /var/lib/trustmanager-tomcat/configure.sh</pre>
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the July release.
-   VOMS admin server shows an error when modifying/adding/signing AUPs, but all the actions still work.
-   After updating OSG-CE to version 3.3-12, please disable and remove OSG Info Services via the following procedure:

``` console
root@host # service osg-info-services stop
root@host # yum erase gip osg-info-services
```

-   The Koji client config has changed in the new version of Koji: \`pkgurl`` http://koji.chtc.wisc.edu/packages` has been replaced by `topurl=http://koji.chtc.wisc.edu` and the Koji client will give a harmless but annoying warning when it finds `pkgurl`. To get rid of the warning, update to osg-build > `` 1.8.0, rerun \`osg-koji setup\`, and say 'yes' when asked to replace the Koji configuration file; or, you may make the above change manually.
-   A previous version (`1.17.0-2.5`) of the Gratia probes required changes in the HTCondor configuration to operate properly. Now, these changes need to be reverted to use verison `1.17.0-2.6` and later of the probes. The lines below are likely to be found in `condor_config.local` or a new file in `/etc/condor/config.d` directory. Delete these lines and run `condor_reconfig`.

``` file
# GlideinWMS Gratia commands
PER_JOB_HISTORY_DIR = /var/lib/gratia/data
JOBGLIDEIN_ResourceName="$$([IfThenElse(IsUndefined(TARGET.GLIDEIN_ResourceName), IfThenElse(IsUndefined(TARGET.GLIDEIN_Site), IfThenElse(IsUndefined(TARGET.FileSystemDomain), \"Local Job\", TARGET.FileSystemDomain), TARGET.GLIDEIN_Site), TARGET.GLIDEIN_ResourceName)])"
SUBMIT_EXPRS = $(SUBMIT_EXPRS) JOBGLIDEIN_ResourceName   
```

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

-   [emi-trustmanager-tomcat-3.0.0-15.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=emi-trustmanager-tomcat-3.0.0-15.osg33.el6)
-   [glideinwms-3.2.19-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.19-1.osg33.el6)
-   [globus-xio-5.12-1.2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-5.12-1.2.osg33.el6)
-   [htcondor-ce-2.2.0-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.0-1.osg33.el6)
-   [lcmaps-plugins-voms-1.7.1-1.4.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.4.osg33.el6)
-   [osg-build-1.10.0-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.0-1.osg33.el6)
-   [osg-ca-scripts-1.1.6-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.6-1.osg33.el6)
-   [osg-ce-3.3-13.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.3-13.osg33.el6)
-   [osg-configure-1.8.1-2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.8.1-2.osg33.el6)
-   [osg-gridftp-3.3-4.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.3-4.osg33.el6)
-   [osg-update-vos-1.4.0-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-update-vos-1.4.0-1.osg33.el6)
-   [osg-version-3.3.25-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.25-1.osg33.el6)
-   [voms-admin-server-2.7.0-1.22.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-admin-server-2.7.0-1.22.osg33.el6)
-   [xrootd-4.6.1-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.6.1-1.osg33.el6)

#### Enterprise Linux 7

-   [emi-trustmanager-tomcat-3.0.0-15.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=emi-trustmanager-tomcat-3.0.0-15.osg33.el7)
-   [glideinwms-3.2.19-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.2.19-1.osg33.el7)
-   [globus-xio-5.12-1.2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-xio-5.12-1.2.osg33.el7)
-   [htcondor-ce-2.2.0-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.0-1.osg33.el7)
-   [lcmaps-plugins-voms-1.7.1-1.4.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-plugins-voms-1.7.1-1.4.osg33.el7)
-   [osg-build-1.10.0-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.0-1.osg33.el7)
-   [osg-ca-scripts-1.1.6-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.6-1.osg33.el7)
-   [osg-ce-3.3-13.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.3-13.osg33.el7)
-   [osg-configure-1.8.1-2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.8.1-2.osg33.el7)
-   [osg-gridftp-3.3-4.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.3-4.osg33.el7)
-   [osg-update-vos-1.4.0-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-update-vos-1.4.0-1.osg33.el7)
-   [osg-version-3.3.25-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.25-1.osg33.el7)
-   [stashcache-0.7-2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-0.7-2.osg33.el7)
-   [xrootd-4.6.1-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.6.1-1.osg33.el7)
-   [xrootd-lcmaps-1.3.3-3.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.3.3-3.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    emi-trustmanager-tomcat glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone globus-xio globus-xio-debuginfo globus-xio-devel globus-xio-doc htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view lcmaps-plugins-voms lcmaps-plugins-voms-debuginfo osg-base-ce osg-base-ce-bosco osg-base-ce-condor osg-base-ce-lsf osg-base-ce-pbs osg-base-ce-sge osg-base-ce-slurm osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-ca-scripts osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-gridftp osg-htcondor-ce osg-htcondor-ce-bosco osg-htcondor-ce-condor osg-htcondor-ce-lsf osg-htcondor-ce-pbs osg-htcondor-ce-sge osg-htcondor-ce-slurm osg-update-data osg-update-vos osg-version voms-admin-server xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-python xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
emi-trustmanager-tomcat-3.0.0-15.osg33.el6
glideinwms-3.2.19-1.osg33.el6
glideinwms-common-tools-3.2.19-1.osg33.el6
glideinwms-condor-common-config-3.2.19-1.osg33.el6
glideinwms-factory-3.2.19-1.osg33.el6
glideinwms-factory-condor-3.2.19-1.osg33.el6
glideinwms-glidecondor-tools-3.2.19-1.osg33.el6
glideinwms-libs-3.2.19-1.osg33.el6
glideinwms-minimal-condor-3.2.19-1.osg33.el6
glideinwms-usercollector-3.2.19-1.osg33.el6
glideinwms-userschedd-3.2.19-1.osg33.el6
glideinwms-vofrontend-3.2.19-1.osg33.el6
glideinwms-vofrontend-standalone-3.2.19-1.osg33.el6
globus-xio-5.12-1.2.osg33.el6
globus-xio-debuginfo-5.12-1.2.osg33.el6
globus-xio-devel-5.12-1.2.osg33.el6
globus-xio-doc-5.12-1.2.osg33.el6
htcondor-ce-2.2.0-1.osg33.el6
htcondor-ce-bosco-2.2.0-1.osg33.el6
htcondor-ce-client-2.2.0-1.osg33.el6
htcondor-ce-collector-2.2.0-1.osg33.el6
htcondor-ce-condor-2.2.0-1.osg33.el6
htcondor-ce-lsf-2.2.0-1.osg33.el6
htcondor-ce-pbs-2.2.0-1.osg33.el6
htcondor-ce-sge-2.2.0-1.osg33.el6
htcondor-ce-slurm-2.2.0-1.osg33.el6
htcondor-ce-view-2.2.0-1.osg33.el6
lcmaps-plugins-voms-1.7.1-1.4.osg33.el6
lcmaps-plugins-voms-debuginfo-1.7.1-1.4.osg33.el6
osg-base-ce-3.3-13.osg33.el6
osg-base-ce-bosco-3.3-13.osg33.el6
osg-base-ce-condor-3.3-13.osg33.el6
osg-base-ce-lsf-3.3-13.osg33.el6
osg-base-ce-pbs-3.3-13.osg33.el6
osg-base-ce-sge-3.3-13.osg33.el6
osg-base-ce-slurm-3.3-13.osg33.el6
osg-build-1.10.0-1.osg33.el6
osg-build-base-1.10.0-1.osg33.el6
osg-build-koji-1.10.0-1.osg33.el6
osg-build-mock-1.10.0-1.osg33.el6
osg-build-tests-1.10.0-1.osg33.el6
osg-ca-scripts-1.1.6-1.osg33.el6
osg-ce-3.3-13.osg33.el6
osg-ce-bosco-3.3-13.osg33.el6
osg-ce-condor-3.3-13.osg33.el6
osg-ce-lsf-3.3-13.osg33.el6
osg-ce-pbs-3.3-13.osg33.el6
osg-ce-sge-3.3-13.osg33.el6
osg-ce-slurm-3.3-13.osg33.el6
osg-configure-1.8.1-2.osg33.el6
osg-configure-bosco-1.8.1-2.osg33.el6
osg-configure-ce-1.8.1-2.osg33.el6
osg-configure-cemon-1.8.1-2.osg33.el6
osg-configure-condor-1.8.1-2.osg33.el6
osg-configure-gateway-1.8.1-2.osg33.el6
osg-configure-gip-1.8.1-2.osg33.el6
osg-configure-gratia-1.8.1-2.osg33.el6
osg-configure-infoservices-1.8.1-2.osg33.el6
osg-configure-lsf-1.8.1-2.osg33.el6
osg-configure-managedfork-1.8.1-2.osg33.el6
osg-configure-misc-1.8.1-2.osg33.el6
osg-configure-monalisa-1.8.1-2.osg33.el6
osg-configure-network-1.8.1-2.osg33.el6
osg-configure-pbs-1.8.1-2.osg33.el6
osg-configure-rsv-1.8.1-2.osg33.el6
osg-configure-sge-1.8.1-2.osg33.el6
osg-configure-slurm-1.8.1-2.osg33.el6
osg-configure-squid-1.8.1-2.osg33.el6
osg-configure-tests-1.8.1-2.osg33.el6
osg-gridftp-3.3-4.osg33.el6
osg-htcondor-ce-3.3-13.osg33.el6
osg-htcondor-ce-bosco-3.3-13.osg33.el6
osg-htcondor-ce-condor-3.3-13.osg33.el6
osg-htcondor-ce-lsf-3.3-13.osg33.el6
osg-htcondor-ce-pbs-3.3-13.osg33.el6
osg-htcondor-ce-sge-3.3-13.osg33.el6
osg-htcondor-ce-slurm-3.3-13.osg33.el6
osg-update-data-1.4.0-1.osg33.el6
osg-update-vos-1.4.0-1.osg33.el6
osg-version-3.3.25-1.osg33.el6
voms-admin-server-2.7.0-1.22.osg33.el6
xrootd-4.6.1-1.osg33.el6
xrootd-client-4.6.1-1.osg33.el6
xrootd-client-devel-4.6.1-1.osg33.el6
xrootd-client-libs-4.6.1-1.osg33.el6
xrootd-debuginfo-4.6.1-1.osg33.el6
xrootd-devel-4.6.1-1.osg33.el6
xrootd-doc-4.6.1-1.osg33.el6
xrootd-fuse-4.6.1-1.osg33.el6
xrootd-libs-4.6.1-1.osg33.el6
xrootd-private-devel-4.6.1-1.osg33.el6
xrootd-python-4.6.1-1.osg33.el6
xrootd-selinux-4.6.1-1.osg33.el6
xrootd-server-4.6.1-1.osg33.el6
xrootd-server-devel-4.6.1-1.osg33.el6
xrootd-server-libs-4.6.1-1.osg33.el6
```

#### Enterprise Linux 7

``` file
emi-trustmanager-tomcat-3.0.0-15.osg33.el7
glideinwms-3.2.19-1.osg33.el7
glideinwms-common-tools-3.2.19-1.osg33.el7
glideinwms-condor-common-config-3.2.19-1.osg33.el7
glideinwms-factory-3.2.19-1.osg33.el7
glideinwms-factory-condor-3.2.19-1.osg33.el7
glideinwms-glidecondor-tools-3.2.19-1.osg33.el7
glideinwms-libs-3.2.19-1.osg33.el7
glideinwms-minimal-condor-3.2.19-1.osg33.el7
glideinwms-usercollector-3.2.19-1.osg33.el7
glideinwms-userschedd-3.2.19-1.osg33.el7
glideinwms-vofrontend-3.2.19-1.osg33.el7
glideinwms-vofrontend-standalone-3.2.19-1.osg33.el7
globus-xio-5.12-1.2.osg33.el7
globus-xio-debuginfo-5.12-1.2.osg33.el7
globus-xio-devel-5.12-1.2.osg33.el7
globus-xio-doc-5.12-1.2.osg33.el7
htcondor-ce-2.2.0-1.osg33.el7
htcondor-ce-bosco-2.2.0-1.osg33.el7
htcondor-ce-client-2.2.0-1.osg33.el7
htcondor-ce-collector-2.2.0-1.osg33.el7
htcondor-ce-condor-2.2.0-1.osg33.el7
htcondor-ce-lsf-2.2.0-1.osg33.el7
htcondor-ce-pbs-2.2.0-1.osg33.el7
htcondor-ce-sge-2.2.0-1.osg33.el7
htcondor-ce-slurm-2.2.0-1.osg33.el7
htcondor-ce-view-2.2.0-1.osg33.el7
lcmaps-plugins-voms-1.7.1-1.4.osg33.el7
lcmaps-plugins-voms-debuginfo-1.7.1-1.4.osg33.el7
osg-base-ce-3.3-13.osg33.el7
osg-base-ce-bosco-3.3-13.osg33.el7
osg-base-ce-condor-3.3-13.osg33.el7
osg-base-ce-lsf-3.3-13.osg33.el7
osg-base-ce-pbs-3.3-13.osg33.el7
osg-base-ce-sge-3.3-13.osg33.el7
osg-base-ce-slurm-3.3-13.osg33.el7
osg-build-1.10.0-1.osg33.el7
osg-build-base-1.10.0-1.osg33.el7
osg-build-koji-1.10.0-1.osg33.el7
osg-build-mock-1.10.0-1.osg33.el7
osg-build-tests-1.10.0-1.osg33.el7
osg-ca-scripts-1.1.6-1.osg33.el7
osg-ce-3.3-13.osg33.el7
osg-ce-bosco-3.3-13.osg33.el7
osg-ce-condor-3.3-13.osg33.el7
osg-ce-lsf-3.3-13.osg33.el7
osg-ce-pbs-3.3-13.osg33.el7
osg-ce-sge-3.3-13.osg33.el7
osg-ce-slurm-3.3-13.osg33.el7
osg-configure-1.8.1-2.osg33.el7
osg-configure-bosco-1.8.1-2.osg33.el7
osg-configure-ce-1.8.1-2.osg33.el7
osg-configure-cemon-1.8.1-2.osg33.el7
osg-configure-condor-1.8.1-2.osg33.el7
osg-configure-gateway-1.8.1-2.osg33.el7
osg-configure-gip-1.8.1-2.osg33.el7
osg-configure-gratia-1.8.1-2.osg33.el7
osg-configure-infoservices-1.8.1-2.osg33.el7
osg-configure-lsf-1.8.1-2.osg33.el7
osg-configure-managedfork-1.8.1-2.osg33.el7
osg-configure-misc-1.8.1-2.osg33.el7
osg-configure-monalisa-1.8.1-2.osg33.el7
osg-configure-network-1.8.1-2.osg33.el7
osg-configure-pbs-1.8.1-2.osg33.el7
osg-configure-rsv-1.8.1-2.osg33.el7
osg-configure-sge-1.8.1-2.osg33.el7
osg-configure-slurm-1.8.1-2.osg33.el7
osg-configure-squid-1.8.1-2.osg33.el7
osg-configure-tests-1.8.1-2.osg33.el7
osg-gridftp-3.3-4.osg33.el7
osg-htcondor-ce-3.3-13.osg33.el7
osg-htcondor-ce-bosco-3.3-13.osg33.el7
osg-htcondor-ce-condor-3.3-13.osg33.el7
osg-htcondor-ce-lsf-3.3-13.osg33.el7
osg-htcondor-ce-pbs-3.3-13.osg33.el7
osg-htcondor-ce-sge-3.3-13.osg33.el7
osg-htcondor-ce-slurm-3.3-13.osg33.el7
osg-update-data-1.4.0-1.osg33.el7
osg-update-vos-1.4.0-1.osg33.el7
osg-version-3.3.25-1.osg33.el7
stashcache-0.7-2.osg33.el7
stashcache-cache-server-0.7-2.osg33.el7
stashcache-daemon-0.7-2.osg33.el7
stashcache-origin-server-0.7-2.osg33.el7
xrootd-4.6.1-1.osg33.el7
xrootd-client-4.6.1-1.osg33.el7
xrootd-client-devel-4.6.1-1.osg33.el7
xrootd-client-libs-4.6.1-1.osg33.el7
xrootd-debuginfo-4.6.1-1.osg33.el7
xrootd-devel-4.6.1-1.osg33.el7
xrootd-doc-4.6.1-1.osg33.el7
xrootd-fuse-4.6.1-1.osg33.el7
xrootd-lcmaps-1.3.3-3.osg33.el7
xrootd-lcmaps-debuginfo-1.3.3-3.osg33.el7
xrootd-libs-4.6.1-1.osg33.el7
xrootd-private-devel-4.6.1-1.osg33.el7
xrootd-python-4.6.1-1.osg33.el7
xrootd-selinux-4.6.1-1.osg33.el7
xrootd-server-4.6.1-1.osg33.el7
xrootd-server-devel-4.6.1-1.osg33.el7
xrootd-server-libs-4.6.1-1.osg33.el7
```

