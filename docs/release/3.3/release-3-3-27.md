OSG Software Release 3.3.27
===========================

**Release Date**: 2017-08-08

Summary of changes
------------------

This release contains:

-   HTCondor 8.4.12
    -   Updated SELinux profile which is required on Red Hat 7.4
-   HTCondor-CE
    -   Do not hold running jobs with an expired proxy
    -   Initialize `$SPOOL/ceview/vos` directory at installation time so that the VO tab functions in CEView before any pilots are received
    -   Don't warn about not running osg-configure, if osg-configure is not installed
-   Default configuration improvements for condor-cron
    -   Clarified how to override the `CONDOR_IDS`
    -   Disable the unused GSI authentication that was producing spurious log messages.
-   Several improvements to osg-configure
    -   Ensure that GUMS is configured before trying to query the GUMS server
    -   Progress updates (such as informing when an operation is expected to take a while) during the user VO file validation are presented to the user rather than being sent to the log file.
    -   osg-configure will issue same warnings and errors with -v option as it does with the -c option.
-   Added blahp configuration option for PBS Pro. This option must be used when the disambiguation code does not correctly determine which PBS is in use.
-   Relaxed proxy validation in jGlobus to be RFC-3820 compliant in order for proxies to work properly with BeStMan

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.27%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note
    StashCache is supported on EL7 only.

!!! note
    xrootd-lcmaps will remain at 1.2.1-1 on EL6.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details.`. This warning can safely be ignored.
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the September release.
-   Updates to VOMS admin server require the updated emi-trustmanager-tomcat and re-running the configure script:\\ <pre class=rootscreen>root@host # /var/lib/trustmanager-tomcat/configure.sh</pre>
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

-   [blahp-1.18.32.bosco-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.32.bosco-1.osg33.el6)
-   [condor-8.4.12-2.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.4.12-2.1.osg33.el6)
-   [condor-cron-1.1.3-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.3-1.osg33.el6)
-   [htcondor-ce-2.2.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.2-1.osg33.el6)
-   [jglobus-2.1.0-9.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=jglobus-2.1.0-9.osg33.el6)
-   [osg-configure-1.9.1-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.9.1-1.osg33.el6)
-   [osg-test-1.11.1-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.1-1.osg33.el6)
-   [osg-tested-internal-3.3-18.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-18.osg33.el6)
-   [osg-version-3.3.27-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.27-1.osg33.el6)

#### Enterprise Linux 7

-   [blahp-1.18.32.bosco-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.32.bosco-1.osg33.el7)
-   [condor-8.4.12-2.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.4.12-2.1.osg33.el7)
-   [condor-cron-1.1.3-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.3-1.osg33.el7)
-   [htcondor-ce-2.2.2-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.2-1.osg33.el7)
-   [jglobus-2.1.0-9.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=jglobus-2.1.0-9.osg33.el7)
-   [osg-configure-1.9.1-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-1.9.1-1.osg33.el7)
-   [osg-test-1.11.1-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.1-1.osg33.el7)
-   [osg-tested-internal-3.3-18.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-18.osg33.el7)
-   [osg-version-3.3.27-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.27-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-cron condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs jglobus osg-ca-certs osg-configure osg-configure-bosco osg-configure-ce osg-configure-cemon osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-monalisa osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-test osg-tested-internal osg-tested-internal-gram osg-test-log-viewer osg-version

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.32.bosco-1.osg33.el6
blahp-debuginfo-1.18.32.bosco-1.osg33.el6
condor-8.4.12-2.1.osg33.el6
condor-all-8.4.12-2.1.osg33.el6
condor-bosco-8.4.12-2.1.osg33.el6
condor-classads-8.4.12-2.1.osg33.el6
condor-classads-devel-8.4.12-2.1.osg33.el6
condor-cream-gahp-8.4.12-2.1.osg33.el6
condor-cron-1.1.3-1.osg33.el6
condor-debuginfo-8.4.12-2.1.osg33.el6
condor-kbdd-8.4.12-2.1.osg33.el6
condor-procd-8.4.12-2.1.osg33.el6
condor-python-8.4.12-2.1.osg33.el6
condor-std-universe-8.4.12-2.1.osg33.el6
condor-test-8.4.12-2.1.osg33.el6
condor-vm-gahp-8.4.12-2.1.osg33.el6
htcondor-ce-2.2.2-1.osg33.el6
htcondor-ce-bosco-2.2.2-1.osg33.el6
htcondor-ce-client-2.2.2-1.osg33.el6
htcondor-ce-collector-2.2.2-1.osg33.el6
htcondor-ce-condor-2.2.2-1.osg33.el6
htcondor-ce-lsf-2.2.2-1.osg33.el6
htcondor-ce-pbs-2.2.2-1.osg33.el6
htcondor-ce-sge-2.2.2-1.osg33.el6
htcondor-ce-slurm-2.2.2-1.osg33.el6
htcondor-ce-view-2.2.2-1.osg33.el6
jglobus-2.1.0-9.osg33.el6
osg-configure-1.9.1-1.osg33.el6
osg-configure-bosco-1.9.1-1.osg33.el6
osg-configure-ce-1.9.1-1.osg33.el6
osg-configure-cemon-1.9.1-1.osg33.el6
osg-configure-condor-1.9.1-1.osg33.el6
osg-configure-gateway-1.9.1-1.osg33.el6
osg-configure-gip-1.9.1-1.osg33.el6
osg-configure-gratia-1.9.1-1.osg33.el6
osg-configure-infoservices-1.9.1-1.osg33.el6
osg-configure-lsf-1.9.1-1.osg33.el6
osg-configure-managedfork-1.9.1-1.osg33.el6
osg-configure-misc-1.9.1-1.osg33.el6
osg-configure-monalisa-1.9.1-1.osg33.el6
osg-configure-network-1.9.1-1.osg33.el6
osg-configure-pbs-1.9.1-1.osg33.el6
osg-configure-rsv-1.9.1-1.osg33.el6
osg-configure-sge-1.9.1-1.osg33.el6
osg-configure-slurm-1.9.1-1.osg33.el6
osg-configure-squid-1.9.1-1.osg33.el6
osg-configure-tests-1.9.1-1.osg33.el6
osg-test-1.11.1-1.osg33.el6
osg-tested-internal-3.3-18.osg33.el6
osg-tested-internal-gram-3.3-18.osg33.el6
osg-test-log-viewer-1.11.1-1.osg33.el6
osg-version-3.3.27-1.osg33.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.32.bosco-1.osg33.el7
blahp-debuginfo-1.18.32.bosco-1.osg33.el7
condor-8.4.12-2.1.osg33.el7
condor-all-8.4.12-2.1.osg33.el7
condor-bosco-8.4.12-2.1.osg33.el7
condor-classads-8.4.12-2.1.osg33.el7
condor-classads-devel-8.4.12-2.1.osg33.el7
condor-cream-gahp-8.4.12-2.1.osg33.el7
condor-cron-1.1.3-1.osg33.el7
condor-debuginfo-8.4.12-2.1.osg33.el7
condor-kbdd-8.4.12-2.1.osg33.el7
condor-procd-8.4.12-2.1.osg33.el7
condor-python-8.4.12-2.1.osg33.el7
condor-test-8.4.12-2.1.osg33.el7
condor-vm-gahp-8.4.12-2.1.osg33.el7
htcondor-ce-2.2.2-1.osg33.el7
htcondor-ce-bosco-2.2.2-1.osg33.el7
htcondor-ce-client-2.2.2-1.osg33.el7
htcondor-ce-collector-2.2.2-1.osg33.el7
htcondor-ce-condor-2.2.2-1.osg33.el7
htcondor-ce-lsf-2.2.2-1.osg33.el7
htcondor-ce-pbs-2.2.2-1.osg33.el7
htcondor-ce-sge-2.2.2-1.osg33.el7
htcondor-ce-slurm-2.2.2-1.osg33.el7
htcondor-ce-view-2.2.2-1.osg33.el7
jglobus-2.1.0-9.osg33.el7
osg-configure-1.9.1-1.osg33.el7
osg-configure-bosco-1.9.1-1.osg33.el7
osg-configure-ce-1.9.1-1.osg33.el7
osg-configure-cemon-1.9.1-1.osg33.el7
osg-configure-condor-1.9.1-1.osg33.el7
osg-configure-gateway-1.9.1-1.osg33.el7
osg-configure-gip-1.9.1-1.osg33.el7
osg-configure-gratia-1.9.1-1.osg33.el7
osg-configure-infoservices-1.9.1-1.osg33.el7
osg-configure-lsf-1.9.1-1.osg33.el7
osg-configure-managedfork-1.9.1-1.osg33.el7
osg-configure-misc-1.9.1-1.osg33.el7
osg-configure-monalisa-1.9.1-1.osg33.el7
osg-configure-network-1.9.1-1.osg33.el7
osg-configure-pbs-1.9.1-1.osg33.el7
osg-configure-rsv-1.9.1-1.osg33.el7
osg-configure-sge-1.9.1-1.osg33.el7
osg-configure-slurm-1.9.1-1.osg33.el7
osg-configure-squid-1.9.1-1.osg33.el7
osg-configure-tests-1.9.1-1.osg33.el7
osg-test-1.11.1-1.osg33.el7
osg-tested-internal-3.3-18.osg33.el7
osg-tested-internal-gram-3.3-18.osg33.el7
osg-test-log-viewer-1.11.1-1.osg33.el7
osg-version-3.3.27-1.osg33.el7
```

