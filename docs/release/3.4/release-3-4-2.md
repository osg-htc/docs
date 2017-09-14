OSG Software Release 3.4.2
==========================

**Release Date**: 2017-08-08

Summary of changes
------------------

This release contains:

-   [HTCondor 8.6.5](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00021.shtml)
    -   Updated SELinux profile which is required on Red Hat 7.4
    -   Fixed a memory leak that would cause the condor\_collector to slowly grow
    -   Fixed several issues that occur when IPv6 is in use
    -   Fixed a bug where condor\_rm rarely removed another one of the user's jobs
    -   Fixed a bug with parallel universe jobs starting on partitionable slots
-   HTCondor-CE
    -   Added pilot payload auditing
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
-   Reorganize the osg-ce packages [SOFTWARE-2768](https://jira.opensciencegrid.org/browse/SOFTWARE-2768)
-   Upcoming: patched HTCondor 8.7.2
    -   Updated SELinux profile which is required on Red Hat 7.4

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.2%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

<span class="twiki-macro NOTE"></span> OSG 3.4 contains only 64-bit components. <span class="twiki-macro NOTE"></span> StashCache is supported on EL7 only. <span class="twiki-macro NOTE"></span> xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found in the [Release3](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/) area of the TWiki.

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details.`. This warning can safely be ignored.
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the August release.
-   In GlideinWMS, a small configuration change must be added to account for changes in HTCondor 8.6. Add the following line to the HTCondor configuration.

``` file
COLLECTOR.USE_SHARED_PORT=False
```

Updating to the new release
---------------------------

To update to the OSG 3.4 series, please consult the page on [updating between release series](Documentation/Release3/OSGReleaseSeries).

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum#install-osg-repositories).

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

-   [blahp-1.18.32.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.32.bosco-1.osg34.el6)
-   [condor-8.6.5-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.5-2.osg34.el6)
-   [condor-cron-1.1.3-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.3-1.osg34.el6)
-   [htcondor-ce-3.0.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.0.1-1.osg34.el6)
-   [osg-ce-3.4-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.4-3.osg34.el6)
-   [osg-configure-2.1.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.1.1-1.osg34.el6)
-   [osg-test-1.11.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.1-1.osg34.el6)
-   [osg-tested-internal-3.4-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-4.osg34.el6)
-   [osg-version-3.4.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.2-1.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.32.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.32.bosco-1.osg34.el7)
-   [condor-8.6.5-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.5-2.osg34.el7)
-   [condor-cron-1.1.3-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-cron-1.1.3-1.osg34.el7)
-   [htcondor-ce-3.0.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.0.1-1.osg34.el7)
-   [osg-ce-3.4-3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.4-3.osg34.el7)
-   [osg-configure-2.1.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.1.1-1.osg34.el7)
-   [osg-test-1.11.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-test-1.11.1-1.osg34.el7)
-   [osg-tested-internal-3.4-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-4.osg34.el7)
-   [osg-version-3.4.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.2-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-cron condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs osg-ca-certs osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-test osg-tested-internal osg-test-log-viewer osg-version

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.32.bosco-1.osg34.el6
blahp-debuginfo-1.18.32.bosco-1.osg34.el6
condor-8.6.5-2.osg34.el6
condor-all-8.6.5-2.osg34.el6
condor-bosco-8.6.5-2.osg34.el6
condor-classads-8.6.5-2.osg34.el6
condor-classads-devel-8.6.5-2.osg34.el6
condor-cream-gahp-8.6.5-2.osg34.el6
condor-cron-1.1.3-1.osg34.el6
condor-debuginfo-8.6.5-2.osg34.el6
condor-kbdd-8.6.5-2.osg34.el6
condor-procd-8.6.5-2.osg34.el6
condor-python-8.6.5-2.osg34.el6
condor-std-universe-8.6.5-2.osg34.el6
condor-test-8.6.5-2.osg34.el6
condor-vm-gahp-8.6.5-2.osg34.el6
htcondor-ce-3.0.1-1.osg34.el6
htcondor-ce-bosco-3.0.1-1.osg34.el6
htcondor-ce-client-3.0.1-1.osg34.el6
htcondor-ce-collector-3.0.1-1.osg34.el6
htcondor-ce-condor-3.0.1-1.osg34.el6
htcondor-ce-lsf-3.0.1-1.osg34.el6
htcondor-ce-pbs-3.0.1-1.osg34.el6
htcondor-ce-sge-3.0.1-1.osg34.el6
htcondor-ce-slurm-3.0.1-1.osg34.el6
htcondor-ce-view-3.0.1-1.osg34.el6
osg-ce-3.4-3.osg34.el6
osg-ce-bosco-3.4-3.osg34.el6
osg-ce-condor-3.4-3.osg34.el6
osg-ce-lsf-3.4-3.osg34.el6
osg-ce-pbs-3.4-3.osg34.el6
osg-ce-sge-3.4-3.osg34.el6
osg-ce-slurm-3.4-3.osg34.el6
osg-configure-2.1.1-1.osg34.el6
osg-configure-bosco-2.1.1-1.osg34.el6
osg-configure-ce-2.1.1-1.osg34.el6
osg-configure-condor-2.1.1-1.osg34.el6
osg-configure-gateway-2.1.1-1.osg34.el6
osg-configure-gip-2.1.1-1.osg34.el6
osg-configure-gratia-2.1.1-1.osg34.el6
osg-configure-infoservices-2.1.1-1.osg34.el6
osg-configure-lsf-2.1.1-1.osg34.el6
osg-configure-managedfork-2.1.1-1.osg34.el6
osg-configure-misc-2.1.1-1.osg34.el6
osg-configure-network-2.1.1-1.osg34.el6
osg-configure-pbs-2.1.1-1.osg34.el6
osg-configure-rsv-2.1.1-1.osg34.el6
osg-configure-sge-2.1.1-1.osg34.el6
osg-configure-slurm-2.1.1-1.osg34.el6
osg-configure-squid-2.1.1-1.osg34.el6
osg-configure-tests-2.1.1-1.osg34.el6
osg-test-1.11.1-1.osg34.el6
osg-tested-internal-3.4-4.osg34.el6
osg-test-log-viewer-1.11.1-1.osg34.el6
osg-version-3.4.2-1.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.32.bosco-1.osg34.el7
blahp-debuginfo-1.18.32.bosco-1.osg34.el7
condor-8.6.5-2.osg34.el7
condor-all-8.6.5-2.osg34.el7
condor-bosco-8.6.5-2.osg34.el7
condor-classads-8.6.5-2.osg34.el7
condor-classads-devel-8.6.5-2.osg34.el7
condor-cream-gahp-8.6.5-2.osg34.el7
condor-cron-1.1.3-1.osg34.el7
condor-debuginfo-8.6.5-2.osg34.el7
condor-kbdd-8.6.5-2.osg34.el7
condor-procd-8.6.5-2.osg34.el7
condor-python-8.6.5-2.osg34.el7
condor-test-8.6.5-2.osg34.el7
condor-vm-gahp-8.6.5-2.osg34.el7
htcondor-ce-3.0.1-1.osg34.el7
htcondor-ce-bosco-3.0.1-1.osg34.el7
htcondor-ce-client-3.0.1-1.osg34.el7
htcondor-ce-collector-3.0.1-1.osg34.el7
htcondor-ce-condor-3.0.1-1.osg34.el7
htcondor-ce-lsf-3.0.1-1.osg34.el7
htcondor-ce-pbs-3.0.1-1.osg34.el7
htcondor-ce-sge-3.0.1-1.osg34.el7
htcondor-ce-slurm-3.0.1-1.osg34.el7
htcondor-ce-view-3.0.1-1.osg34.el7
osg-ce-3.4-3.osg34.el7
osg-ce-bosco-3.4-3.osg34.el7
osg-ce-condor-3.4-3.osg34.el7
osg-ce-lsf-3.4-3.osg34.el7
osg-ce-pbs-3.4-3.osg34.el7
osg-ce-sge-3.4-3.osg34.el7
osg-ce-slurm-3.4-3.osg34.el7
osg-configure-2.1.1-1.osg34.el7
osg-configure-bosco-2.1.1-1.osg34.el7
osg-configure-ce-2.1.1-1.osg34.el7
osg-configure-condor-2.1.1-1.osg34.el7
osg-configure-gateway-2.1.1-1.osg34.el7
osg-configure-gip-2.1.1-1.osg34.el7
osg-configure-gratia-2.1.1-1.osg34.el7
osg-configure-infoservices-2.1.1-1.osg34.el7
osg-configure-lsf-2.1.1-1.osg34.el7
osg-configure-managedfork-2.1.1-1.osg34.el7
osg-configure-misc-2.1.1-1.osg34.el7
osg-configure-network-2.1.1-1.osg34.el7
osg-configure-pbs-2.1.1-1.osg34.el7
osg-configure-rsv-2.1.1-1.osg34.el7
osg-configure-sge-2.1.1-1.osg34.el7
osg-configure-slurm-2.1.1-1.osg34.el7
osg-configure-squid-2.1.1-1.osg34.el7
osg-configure-tests-2.1.1-1.osg34.el7
osg-test-1.11.1-1.osg34.el7
osg-tested-internal-3.4-4.osg34.el7
osg-test-log-viewer-1.11.1-1.osg34.el7
osg-version-3.4.2-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.32.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.32.bosco-1.osgup.el6)
-   [condor-8.7.2-2.1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.2-2.1.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.32.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.32.bosco-1.osgup.el7)
-   [condor-8.7.2-2.1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.2-2.1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.32.bosco-1.osgup.el6
blahp-debuginfo-1.18.32.bosco-1.osgup.el6
condor-8.7.2-2.1.osgup.el6
condor-all-8.7.2-2.1.osgup.el6
condor-annex-ec2-8.7.2-2.1.osgup.el6
condor-bosco-8.7.2-2.1.osgup.el6
condor-classads-8.7.2-2.1.osgup.el6
condor-classads-devel-8.7.2-2.1.osgup.el6
condor-cream-gahp-8.7.2-2.1.osgup.el6
condor-debuginfo-8.7.2-2.1.osgup.el6
condor-kbdd-8.7.2-2.1.osgup.el6
condor-procd-8.7.2-2.1.osgup.el6
condor-python-8.7.2-2.1.osgup.el6
condor-std-universe-8.7.2-2.1.osgup.el6
condor-test-8.7.2-2.1.osgup.el6
condor-vm-gahp-8.7.2-2.1.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.32.bosco-1.osgup.el7
blahp-debuginfo-1.18.32.bosco-1.osgup.el7
condor-8.7.2-2.1.osgup.el7
condor-all-8.7.2-2.1.osgup.el7
condor-annex-ec2-8.7.2-2.1.osgup.el7
condor-bosco-8.7.2-2.1.osgup.el7
condor-classads-8.7.2-2.1.osgup.el7
condor-classads-devel-8.7.2-2.1.osgup.el7
condor-cream-gahp-8.7.2-2.1.osgup.el7
condor-debuginfo-8.7.2-2.1.osgup.el7
condor-kbdd-8.7.2-2.1.osgup.el7
condor-procd-8.7.2-2.1.osgup.el7
condor-python-8.7.2-2.1.osgup.el7
condor-test-8.7.2-2.1.osgup.el7
condor-vm-gahp-8.7.2-2.1.osgup.el7
```

