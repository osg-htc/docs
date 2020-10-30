OSG Software Release 3.4.4
==========================

**Release Date**: 2017-10-10

Summary of changes
------------------

This release contains:

-   Updated gsi-openssh-server to interoperate with clients using OpenSSL 1.1
-   [Singularity 2.3.2](http://singularity.lbl.gov/release-2-3-2): Now works with Docker's updated registry RESTful API
-   [HTCondor 8.6.6](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00023.shtml): Bug fix release
-   globus-gridftp-server-control 5.2: Allow 400 responses to stat failures
-   osg-ca-scripts now properly requires wget to be installed
-   Updated osg-configure
    -   to work properly when fetch-crl is missing
    -   to work properly with HTCondor 8.7.2+
-   [HTCondor 8.7.3](https://www-auth.cs.wisc.edu/lists/htcondor-world/2017/msg00024.shtml) in Upcoming

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.4%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found [here](../../index.md).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details`. This warning can safely be ignored.
-   Using the LCMAPS VOMS will result in a failing "supported VO" RSV test ([SOFTWARE-2763](https://jira.opensciencegrid.org/browse/SOFTWARE-2763)). This can be ignored and a fix is targeted for the November release.
-   In GlideinWMS, a small configuration change must be added to account for changes in HTCondor 8.6. Add the following line to the HTCondor configuration.

        COLLECTOR.USE_SHARED_PORT=False

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note "Notes"
    -   Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

   * [condor-8.6.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.6-1.osg34.el6)
   * [globus-gridftp-server-control-5.2-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-5.2-1.1.osg34.el6)
   * [gsi-openssh-7.3p1c-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.3p1c-1.1.osg34.el6)
   * [osg-build-1.10.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.2-1.osg34.el6)
   * [osg-ca-scripts-1.1.7-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.7-2.osg34.el6)
   * [osg-configure-2.2.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.1-1.osg34.el6)
   * [osg-release-3.4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-2.osg34.el6)
   * [osg-release-itb-3.4-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-itb-3.4-2.osg34.el6)
   * [osg-tested-internal-3.4-5.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-5.osg34.el6)
   * [osg-version-3.4.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.4-1.osg34.el6)
   * [singularity-2.3.2-0.1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.3.2-0.1.1.osg34.el6)

#### Enterprise Linux 7

   * [condor-8.6.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.6-1.osg34.el7)
   * [globus-gridftp-server-control-5.2-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-control-5.2-1.1.osg34.el7)
   * [gsi-openssh-7.3p1c-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.3p1c-1.1.osg34.el7)
   * [osg-build-1.10.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.10.2-1.osg34.el7)
   * [osg-ca-scripts-1.1.7-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.1.7-2.osg34.el7)
   * [osg-configure-2.2.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.1-1.osg34.el7)
   * [osg-release-3.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.4-2.osg34.el7)
   * [osg-release-itb-3.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-itb-3.4-2.osg34.el7)
   * [osg-tested-internal-3.4-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-5.osg34.el7)
   * [osg-version-3.4.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.4-1.osg34.el7)
   * [singularity-2.3.2-0.1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.3.2-0.1.1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp globus-gridftp-server-control globus-gridftp-server-control-debuginfo globus-gridftp-server-control-devel gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-ca-scripts osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-managedfork osg-configure-misc osg-configure-network osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-slurm osg-configure-squid osg-configure-tests osg-release osg-release-itb osg-tested-internal osg-version singularity singularity-debuginfo singularity-devel singularity-runtime

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.6.6-1.osg34.el6
condor-all-8.6.6-1.osg34.el6
condor-bosco-8.6.6-1.osg34.el6
condor-classads-8.6.6-1.osg34.el6
condor-classads-devel-8.6.6-1.osg34.el6
condor-cream-gahp-8.6.6-1.osg34.el6
condor-debuginfo-8.6.6-1.osg34.el6
condor-kbdd-8.6.6-1.osg34.el6
condor-procd-8.6.6-1.osg34.el6
condor-python-8.6.6-1.osg34.el6
condor-std-universe-8.6.6-1.osg34.el6
condor-test-8.6.6-1.osg34.el6
condor-vm-gahp-8.6.6-1.osg34.el6
globus-gridftp-server-control-5.2-1.1.osg34.el6
globus-gridftp-server-control-debuginfo-5.2-1.1.osg34.el6
globus-gridftp-server-control-devel-5.2-1.1.osg34.el6
gsi-openssh-7.3p1c-1.1.osg34.el6
gsi-openssh-clients-7.3p1c-1.1.osg34.el6
gsi-openssh-debuginfo-7.3p1c-1.1.osg34.el6
gsi-openssh-server-7.3p1c-1.1.osg34.el6
osg-build-1.10.2-1.osg34.el6
osg-build-base-1.10.2-1.osg34.el6
osg-build-koji-1.10.2-1.osg34.el6
osg-build-mock-1.10.2-1.osg34.el6
osg-build-tests-1.10.2-1.osg34.el6
osg-ca-scripts-1.1.7-2.osg34.el6
osg-configure-2.2.1-1.osg34.el6
osg-configure-bosco-2.2.1-1.osg34.el6
osg-configure-ce-2.2.1-1.osg34.el6
osg-configure-condor-2.2.1-1.osg34.el6
osg-configure-gateway-2.2.1-1.osg34.el6
osg-configure-gip-2.2.1-1.osg34.el6
osg-configure-gratia-2.2.1-1.osg34.el6
osg-configure-infoservices-2.2.1-1.osg34.el6
osg-configure-lsf-2.2.1-1.osg34.el6
osg-configure-managedfork-2.2.1-1.osg34.el6
osg-configure-misc-2.2.1-1.osg34.el6
osg-configure-network-2.2.1-1.osg34.el6
osg-configure-pbs-2.2.1-1.osg34.el6
osg-configure-rsv-2.2.1-1.osg34.el6
osg-configure-sge-2.2.1-1.osg34.el6
osg-configure-slurm-2.2.1-1.osg34.el6
osg-configure-squid-2.2.1-1.osg34.el6
osg-configure-tests-2.2.1-1.osg34.el6
osg-release-3.4-2.osg34.el6
osg-release-itb-3.4-2.osg34.el6
osg-tested-internal-3.4-5.osg34.el6
osg-version-3.4.4-1.osg34.el6
singularity-2.3.2-0.1.1.osg34.el6
singularity-debuginfo-2.3.2-0.1.1.osg34.el6
singularity-devel-2.3.2-0.1.1.osg34.el6
singularity-runtime-2.3.2-0.1.1.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.6.6-1.osg34.el7
condor-all-8.6.6-1.osg34.el7
condor-bosco-8.6.6-1.osg34.el7
condor-classads-8.6.6-1.osg34.el7
condor-classads-devel-8.6.6-1.osg34.el7
condor-cream-gahp-8.6.6-1.osg34.el7
condor-debuginfo-8.6.6-1.osg34.el7
condor-kbdd-8.6.6-1.osg34.el7
condor-procd-8.6.6-1.osg34.el7
condor-python-8.6.6-1.osg34.el7
condor-test-8.6.6-1.osg34.el7
condor-vm-gahp-8.6.6-1.osg34.el7
globus-gridftp-server-control-5.2-1.1.osg34.el7
globus-gridftp-server-control-debuginfo-5.2-1.1.osg34.el7
globus-gridftp-server-control-devel-5.2-1.1.osg34.el7
gsi-openssh-7.3p1c-1.1.osg34.el7
gsi-openssh-clients-7.3p1c-1.1.osg34.el7
gsi-openssh-debuginfo-7.3p1c-1.1.osg34.el7
gsi-openssh-server-7.3p1c-1.1.osg34.el7
osg-build-1.10.2-1.osg34.el7
osg-build-base-1.10.2-1.osg34.el7
osg-build-koji-1.10.2-1.osg34.el7
osg-build-mock-1.10.2-1.osg34.el7
osg-build-tests-1.10.2-1.osg34.el7
osg-ca-scripts-1.1.7-2.osg34.el7
osg-configure-2.2.1-1.osg34.el7
osg-configure-bosco-2.2.1-1.osg34.el7
osg-configure-ce-2.2.1-1.osg34.el7
osg-configure-condor-2.2.1-1.osg34.el7
osg-configure-gateway-2.2.1-1.osg34.el7
osg-configure-gip-2.2.1-1.osg34.el7
osg-configure-gratia-2.2.1-1.osg34.el7
osg-configure-infoservices-2.2.1-1.osg34.el7
osg-configure-lsf-2.2.1-1.osg34.el7
osg-configure-managedfork-2.2.1-1.osg34.el7
osg-configure-misc-2.2.1-1.osg34.el7
osg-configure-network-2.2.1-1.osg34.el7
osg-configure-pbs-2.2.1-1.osg34.el7
osg-configure-rsv-2.2.1-1.osg34.el7
osg-configure-sge-2.2.1-1.osg34.el7
osg-configure-slurm-2.2.1-1.osg34.el7
osg-configure-squid-2.2.1-1.osg34.el7
osg-configure-tests-2.2.1-1.osg34.el7
osg-release-3.4-2.osg34.el7
osg-release-itb-3.4-2.osg34.el7
osg-tested-internal-3.4-5.osg34.el7
osg-version-3.4.4-1.osg34.el7
singularity-2.3.2-0.1.1.osg34.el7
singularity-debuginfo-2.3.2-0.1.1.osg34.el7
singularity-devel-2.3.2-0.1.1.osg34.el7
singularity-runtime-2.3.2-0.1.1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

   * [condor-8.7.3-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.3-1.osgup.el6)

#### Enterprise Linux 7

   * [condor-8.7.3-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.3-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.7.3-1.osgup.el6
condor-all-8.7.3-1.osgup.el6
condor-annex-ec2-8.7.3-1.osgup.el6
condor-bosco-8.7.3-1.osgup.el6
condor-classads-8.7.3-1.osgup.el6
condor-classads-devel-8.7.3-1.osgup.el6
condor-cream-gahp-8.7.3-1.osgup.el6
condor-debuginfo-8.7.3-1.osgup.el6
condor-kbdd-8.7.3-1.osgup.el6
condor-procd-8.7.3-1.osgup.el6
condor-python-8.7.3-1.osgup.el6
condor-std-universe-8.7.3-1.osgup.el6
condor-test-8.7.3-1.osgup.el6
condor-vm-gahp-8.7.3-1.osgup.el6
```

#### Enterprise Linux 7

``` file
condor-8.7.3-1.osgup.el7
condor-all-8.7.3-1.osgup.el7
condor-annex-ec2-8.7.3-1.osgup.el7
condor-bosco-8.7.3-1.osgup.el7
condor-classads-8.7.3-1.osgup.el7
condor-classads-devel-8.7.3-1.osgup.el7
condor-cream-gahp-8.7.3-1.osgup.el7
condor-debuginfo-8.7.3-1.osgup.el7
condor-kbdd-8.7.3-1.osgup.el7
condor-procd-8.7.3-1.osgup.el7
condor-python-8.7.3-1.osgup.el7
condor-test-8.7.3-1.osgup.el7
condor-vm-gahp-8.7.3-1.osgup.el7
```

