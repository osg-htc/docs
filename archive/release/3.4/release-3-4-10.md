OSG Software Release 3.4.10
===========================

**Release Date**: 2018-04-18

Summary of changes
------------------

This release contains:

-   [Singularity 2.4.6](https://github.com/singularityware/singularity/releases)

    !!! danger "CMS Sites"
        If you support the CMS VO, do not update Singularity until CMS announces that it is safe to do so

    -   Addresses a high severity security issue with bind mounts on hosts using overlayfs
    -   `/tmp` and `/var/tmp` are automatically scratch-mounted in containers started with the `--contain` option.
        If you are invoking singularity with `--scratch /tmp --scratch /var/tmp --contain`,
        this is redundant and will result in the following error:

            ERROR  : Not mounting requested scratch directory (already mounted in container): /tmp
            ABORT  : Retval = 255

        To fix this, drop any `--scratch /tmp` and/or `--scratch /var/tmp` options.

-   [HTCondor-CE 3.1.1](https://github.com/opensciencegrid/htcondor-ce/releases): now accepts InCommon certificates
-   [HTCondor 8.6.10](https://lists.cs.wisc.edu/archive/htcondor-world/2018/msg00004.shtml): fixed handling of grid jobs when submit fails and other fixes
-   [cigetcert 1.16](https://cdcvs.fnal.gov/redmine/projects/fermitools/wiki/Cigetcert): first release in the OSG Software Stack
-   BLAHP 1.18.36
    -   If `qsub` fails, the BLAHP now honors the `blah_debug_save_submit_info` setting
    -   The BLAHP now checks that input files are present before submitting to the batch system.
-   xrootd-lcmaps 1.2.1-3: fixed crashes on Enterprise Linux 6 when request were made using HTTPS
-   frontier-squid: fixed startup problem under SELinux
-   osg-configure 2.2.4:
    -   Update comments in storage section to identify that value to be used for OASIS
    -   Properly handle exceptions when using illegal characters in configuration files
    -   osg-configure no longer requires all site information for a GridFTP server
    -   Warns when the deprecated `site_name` attribute is used
    -   No longer creates and `/etc/condor-ce` directory on an SE or standalone GridFTP or XRootD node
    -   Validates properly formed environment variables in the local settings
-   Upcoming:
    -   [HTCondor 8.7.7](https://lists.cs.wisc.edu/archive/htcondor-world/2018/msg00005.shtml)
    -   xrootd-hdfs 2.0.2: Improved write support

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.10%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore (`_`). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](../../index.md).

Known Issues
------------

-   Singularity 2.4.6 has [exhibited slow startup times](https://github.com/singularityware/singularity/issues/1447)
    on systems with a high number of maximum open file descriptors.

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-the-osg-repositories).

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

-   [I2util-1.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=I2util-1.6-1.osg34.el6)
-   [blahp-1.18.36.bosco-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.36.bosco-1.osg34.el6)
-   [bwctl-1.6.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bwctl-1.6.6-1.osg34.el6)
-   [cigetcert-1.16-2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cigetcert-1.16-2.osg34.el6)
-   [condor-8.6.10-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.10-1.osg34.el6)
-   [frontier-squid-3.5.27-3.1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.27-3.1.1.osg34.el6)
-   [htcondor-ce-3.1.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.1.1-1.osg34.el6)
-   [osg-build-1.12.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.12.2-1.osg34.el6)
-   [osg-configure-2.2.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.4-1.osg34.el6)
-   [osg-version-3.4.10-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.10-1.osg34.el6)
-   [owamp-3.5.4-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=owamp-3.5.4-1.osg34.el6)
-   [singularity-2.4.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.4.6-1.osg34.el6)
-   [xrootd-lcmaps-1.2.1-3.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.2.1-3.osg34.el6)

#### Enterprise Linux 7

-   [I2util-1.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=I2util-1.6-1.osg34.el7)
-   [blahp-1.18.36.bosco-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.36.bosco-1.osg34.el7)
-   [bwctl-1.6.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=bwctl-1.6.6-1.osg34.el7)
-   [cigetcert-1.16-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cigetcert-1.16-2.osg34.el7)
-   [condor-8.6.10-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.10-1.osg34.el7)
-   [frontier-squid-3.5.27-3.1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-3.5.27-3.1.1.osg34.el7)
-   [htcondor-ce-3.1.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-3.1.1-1.osg34.el7)
-   [osg-build-1.12.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-build-1.12.2-1.osg34.el7)
-   [osg-configure-2.2.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-2.2.4-1.osg34.el7)
-   [osg-version-3.4.10-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.10-1.osg34.el7)
-   [owamp-3.5.4-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=owamp-3.5.4-1.osg34.el7)
-   [singularity-2.4.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-2.4.6-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo bwctl bwctl-client bwctl-debuginfo bwctl-devel bwctl-server cigetcert condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp frontier-squid frontier-squid-debuginfo htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view I2util I2util-debuginfo igtf-ca-certs osg-build osg-build-base osg-build-koji osg-build-mock osg-build-tests osg-ca-certs osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests osg-gums-config osg-version owamp owamp-client owamp-debuginfo owamp-server singularity singularity-debuginfo singularity-devel singularity-runtime vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd-lcmaps xrootd-lcmaps-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.36.bosco-1.osg34.el6
blahp-debuginfo-1.18.36.bosco-1.osg34.el6
bwctl-1.6.6-1.osg34.el6
bwctl-client-1.6.6-1.osg34.el6
bwctl-debuginfo-1.6.6-1.osg34.el6
bwctl-devel-1.6.6-1.osg34.el6
bwctl-server-1.6.6-1.osg34.el6
cigetcert-1.16-2.osg34.el6
condor-8.6.10-1.osg34.el6
condor-all-8.6.10-1.osg34.el6
condor-bosco-8.6.10-1.osg34.el6
condor-classads-8.6.10-1.osg34.el6
condor-classads-devel-8.6.10-1.osg34.el6
condor-cream-gahp-8.6.10-1.osg34.el6
condor-debuginfo-8.6.10-1.osg34.el6
condor-kbdd-8.6.10-1.osg34.el6
condor-procd-8.6.10-1.osg34.el6
condor-python-8.6.10-1.osg34.el6
condor-std-universe-8.6.10-1.osg34.el6
condor-test-8.6.10-1.osg34.el6
condor-vm-gahp-8.6.10-1.osg34.el6
frontier-squid-3.5.27-3.1.1.osg34.el6
frontier-squid-debuginfo-3.5.27-3.1.1.osg34.el6
htcondor-ce-3.1.1-1.osg34.el6
htcondor-ce-bosco-3.1.1-1.osg34.el6
htcondor-ce-client-3.1.1-1.osg34.el6
htcondor-ce-collector-3.1.1-1.osg34.el6
htcondor-ce-condor-3.1.1-1.osg34.el6
htcondor-ce-lsf-3.1.1-1.osg34.el6
htcondor-ce-pbs-3.1.1-1.osg34.el6
htcondor-ce-sge-3.1.1-1.osg34.el6
htcondor-ce-slurm-3.1.1-1.osg34.el6
htcondor-ce-view-3.1.1-1.osg34.el6
I2util-1.6-1.osg34.el6
I2util-debuginfo-1.6-1.osg34.el6
osg-build-1.12.2-1.osg34.el6
osg-build-base-1.12.2-1.osg34.el6
osg-build-koji-1.12.2-1.osg34.el6
osg-build-mock-1.12.2-1.osg34.el6
osg-build-tests-1.12.2-1.osg34.el6
osg-configure-2.2.4-1.osg34.el6
osg-configure-bosco-2.2.4-1.osg34.el6
osg-configure-ce-2.2.4-1.osg34.el6
osg-configure-condor-2.2.4-1.osg34.el6
osg-configure-gateway-2.2.4-1.osg34.el6
osg-configure-gip-2.2.4-1.osg34.el6
osg-configure-gratia-2.2.4-1.osg34.el6
osg-configure-infoservices-2.2.4-1.osg34.el6
osg-configure-lsf-2.2.4-1.osg34.el6
osg-configure-misc-2.2.4-1.osg34.el6
osg-configure-pbs-2.2.4-1.osg34.el6
osg-configure-rsv-2.2.4-1.osg34.el6
osg-configure-sge-2.2.4-1.osg34.el6
osg-configure-siteinfo-2.2.4-1.osg34.el6
osg-configure-slurm-2.2.4-1.osg34.el6
osg-configure-squid-2.2.4-1.osg34.el6
osg-configure-tests-2.2.4-1.osg34.el6
osg-version-3.4.10-1.osg34.el6
owamp-3.5.4-1.osg34.el6
owamp-client-3.5.4-1.osg34.el6
owamp-debuginfo-3.5.4-1.osg34.el6
owamp-server-3.5.4-1.osg34.el6
singularity-2.4.6-1.osg34.el6
singularity-debuginfo-2.4.6-1.osg34.el6
singularity-devel-2.4.6-1.osg34.el6
singularity-runtime-2.4.6-1.osg34.el6
xrootd-lcmaps-1.2.1-3.osg34.el6
xrootd-lcmaps-debuginfo-1.2.1-3.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.36.bosco-1.osg34.el7
blahp-debuginfo-1.18.36.bosco-1.osg34.el7
bwctl-1.6.6-1.osg34.el7
bwctl-client-1.6.6-1.osg34.el7
bwctl-debuginfo-1.6.6-1.osg34.el7
bwctl-devel-1.6.6-1.osg34.el7
bwctl-server-1.6.6-1.osg34.el7
cigetcert-1.16-2.osg34.el7
condor-8.6.10-1.osg34.el7
condor-all-8.6.10-1.osg34.el7
condor-bosco-8.6.10-1.osg34.el7
condor-classads-8.6.10-1.osg34.el7
condor-classads-devel-8.6.10-1.osg34.el7
condor-cream-gahp-8.6.10-1.osg34.el7
condor-debuginfo-8.6.10-1.osg34.el7
condor-kbdd-8.6.10-1.osg34.el7
condor-procd-8.6.10-1.osg34.el7
condor-python-8.6.10-1.osg34.el7
condor-test-8.6.10-1.osg34.el7
condor-vm-gahp-8.6.10-1.osg34.el7
frontier-squid-3.5.27-3.1.1.osg34.el7
frontier-squid-debuginfo-3.5.27-3.1.1.osg34.el7
htcondor-ce-3.1.1-1.osg34.el7
htcondor-ce-bosco-3.1.1-1.osg34.el7
htcondor-ce-client-3.1.1-1.osg34.el7
htcondor-ce-collector-3.1.1-1.osg34.el7
htcondor-ce-condor-3.1.1-1.osg34.el7
htcondor-ce-lsf-3.1.1-1.osg34.el7
htcondor-ce-pbs-3.1.1-1.osg34.el7
htcondor-ce-sge-3.1.1-1.osg34.el7
htcondor-ce-slurm-3.1.1-1.osg34.el7
htcondor-ce-view-3.1.1-1.osg34.el7
I2util-1.6-1.osg34.el7
I2util-debuginfo-1.6-1.osg34.el7
osg-build-1.12.2-1.osg34.el7
osg-build-base-1.12.2-1.osg34.el7
osg-build-koji-1.12.2-1.osg34.el7
osg-build-mock-1.12.2-1.osg34.el7
osg-build-tests-1.12.2-1.osg34.el7
osg-configure-2.2.4-1.osg34.el7
osg-configure-bosco-2.2.4-1.osg34.el7
osg-configure-ce-2.2.4-1.osg34.el7
osg-configure-condor-2.2.4-1.osg34.el7
osg-configure-gateway-2.2.4-1.osg34.el7
osg-configure-gip-2.2.4-1.osg34.el7
osg-configure-gratia-2.2.4-1.osg34.el7
osg-configure-infoservices-2.2.4-1.osg34.el7
osg-configure-lsf-2.2.4-1.osg34.el7
osg-configure-misc-2.2.4-1.osg34.el7
osg-configure-pbs-2.2.4-1.osg34.el7
osg-configure-rsv-2.2.4-1.osg34.el7
osg-configure-sge-2.2.4-1.osg34.el7
osg-configure-siteinfo-2.2.4-1.osg34.el7
osg-configure-slurm-2.2.4-1.osg34.el7
osg-configure-squid-2.2.4-1.osg34.el7
osg-configure-tests-2.2.4-1.osg34.el7
osg-version-3.4.10-1.osg34.el7
owamp-3.5.4-1.osg34.el7
owamp-client-3.5.4-1.osg34.el7
owamp-debuginfo-3.5.4-1.osg34.el7
owamp-server-3.5.4-1.osg34.el7
singularity-2.4.6-1.osg34.el7
singularity-debuginfo-2.4.6-1.osg34.el7
singularity-devel-2.4.6-1.osg34.el7
singularity-runtime-2.4.6-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.36.bosco-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.36.bosco-1.osgup.el6)
-   [condor-8.7.7-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.7-1.osgup.el6)
-   [osg-gridftp-3.4-8.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-8.osgup.el6)

#### Enterprise Linux 7

-   [blahp-1.18.36.bosco-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.36.bosco-1.osgup.el7)
-   [condor-8.7.7-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.7-1.osgup.el7)
-   [osg-gridftp-3.4-8.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-gridftp-3.4-8.osgup.el7)
-   [osg-se-hadoop-3.4-5.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-se-hadoop-3.4-5.osgup.el7)
-   [xrootd-hdfs-2.0.2-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.0.2-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp osg-gridftp osg-gridftp-hdfs osg-gridftp-xrootd osg-se-hadoop osg-se-hadoop-client osg-se-hadoop-datanode osg-se-hadoop-gridftp osg-se-hadoop-namenode osg-se-hadoop-secondarynamenode xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.36.bosco-1.osgup.el6
blahp-debuginfo-1.18.36.bosco-1.osgup.el6
condor-8.7.7-1.osgup.el6
condor-all-8.7.7-1.osgup.el6
condor-annex-ec2-8.7.7-1.osgup.el6
condor-bosco-8.7.7-1.osgup.el6
condor-classads-8.7.7-1.osgup.el6
condor-classads-devel-8.7.7-1.osgup.el6
condor-cream-gahp-8.7.7-1.osgup.el6
condor-debuginfo-8.7.7-1.osgup.el6
condor-kbdd-8.7.7-1.osgup.el6
condor-procd-8.7.7-1.osgup.el6
condor-python-8.7.7-1.osgup.el6
condor-std-universe-8.7.7-1.osgup.el6
condor-test-8.7.7-1.osgup.el6
condor-vm-gahp-8.7.7-1.osgup.el6
osg-gridftp-3.4-8.osgup.el6
osg-gridftp-xrootd-3.4-8.osgup.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.36.bosco-1.osgup.el7
blahp-debuginfo-1.18.36.bosco-1.osgup.el7
condor-8.7.7-1.osgup.el7
condor-all-8.7.7-1.osgup.el7
condor-annex-ec2-8.7.7-1.osgup.el7
condor-bosco-8.7.7-1.osgup.el7
condor-classads-8.7.7-1.osgup.el7
condor-classads-devel-8.7.7-1.osgup.el7
condor-cream-gahp-8.7.7-1.osgup.el7
condor-debuginfo-8.7.7-1.osgup.el7
condor-kbdd-8.7.7-1.osgup.el7
condor-procd-8.7.7-1.osgup.el7
condor-python-8.7.7-1.osgup.el7
condor-test-8.7.7-1.osgup.el7
condor-vm-gahp-8.7.7-1.osgup.el7
osg-gridftp-3.4-8.osgup.el7
osg-gridftp-hdfs-3.4-8.osgup.el7
osg-gridftp-xrootd-3.4-8.osgup.el7
osg-se-hadoop-3.4-5.osgup.el7
osg-se-hadoop-client-3.4-5.osgup.el7
osg-se-hadoop-datanode-3.4-5.osgup.el7
osg-se-hadoop-gridftp-3.4-5.osgup.el7
osg-se-hadoop-namenode-3.4-5.osgup.el7
osg-se-hadoop-secondarynamenode-3.4-5.osgup.el7
xrootd-hdfs-2.0.2-1.osgup.el7
xrootd-hdfs-debuginfo-2.0.2-1.osgup.el7
xrootd-hdfs-devel-2.0.2-1.osgup.el7
```
