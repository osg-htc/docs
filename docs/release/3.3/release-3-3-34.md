OSG Software Release 3.3.34
===========================

**Release Date**: 2018-05-09

!!! warning "Required Actions"
    Due to the retirement of `grid.iu.edu` hosts (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/)
    for details), some software packages require updates to reference new hosts.

    1. Update all packages that may contain references to `grid.iu.edu`:
       (Yum will only update already installed packages.)

            :::console
            root@host # yum update osg-ca-certs-updater osg-ca-scripts osg-release osg-release-itb \
                        osg-test\* rsv\*

    1. If you have `rsv` installed, see [this section](#known-issues) below for rsv-specific instructions.

Summary of changes
------------------

This release contains:

-   Updated all references to grid.iu.edu with opensciencegrid.org
    -   osg-ca-certs-updater
    -   osg-ca-scripts
    -   osg-release
    -   osg-release-itb
    -   osg-test
    -   rsv
-   xrootd-lcmaps 1.2.1-3: fixed crashes on Enterprise Linux 6 when requests were made using HTTPS
-   frontier-squid: Fixed startup problem under SELinux
-   xrootd-hdfs 2.0.2: Improved write support

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.34%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found [here](/index.md).

Known Issues
------------

Due to the central RSV service retirement (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/) for details),
please disable the `gratia-consumer` RSV component that reports to the central service by running the following commands
on your RSV host:

``` console
root@host # rsv-control --disable gratia-consumer
root@host # rsv-control --off gratia-consumer
```

Additionally, if you are using osg-configure, please edit `/etc/osg/config.d/30-rsv.ini` and set the following:

``` file
enable_gratia = False
```

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need to [install the current OSG repositories](/common/yum#install-osg-repositories#updating-from-osg-31-32-33-to-33-or-34).

### Update Software

Once the repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note "Notes"
    -   Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension).

Need help?
----------

Do you need help with this release? [Contact us for help](/common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [frontier-squid-2.7.STABLE9-27.1.1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-2.7.STABLE9-27.1.1.osg33.el6)
-   [htcondor-ce-2.2.4-2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.4-2.osg33.el6)
-   [myproxy-6.1.28-1.2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.1.28-1.2.osg33.el6)
-   [osg-ca-certs-updater-1.8-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.8-1.osg33.el6)
-   [osg-ca-scripts-1.2.3-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.3-1.osg33.el6)
-   [osg-release-3.3-7.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.3-7.osg33.el6)
-   [osg-tested-internal-3.3-20.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-20.osg33.el6)
-   [osg-version-3.3.34-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.34-1.osg33.el6)
-   [rsv-3.16.0-2.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.16.0-2.osg33.el6)
-   [xrootd-hdfs-2.0.2-1.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.0.2-1.osg33.el6)
-   [xrootd-lcmaps-1.2.1-3.osg33.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.2.1-3.osg33.el6)

#### Enterprise Linux 7

-   [frontier-squid-2.7.STABLE9-27.1.1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-2.7.STABLE9-27.1.1.osg33.el7)
-   [htcondor-ce-2.2.4-2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-2.2.4-2.osg33.el7)
-   [myproxy-6.1.28-1.2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.1.28-1.2.osg33.el7)
-   [osg-ca-certs-updater-1.8-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-1.8-1.osg33.el7)
-   [osg-ca-scripts-1.2.3-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-scripts-1.2.3-1.osg33.el7)
-   [osg-release-3.3-7.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.3-7.osg33.el7)
-   [osg-tested-internal-3.3-20.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.3-20.osg33.el7)
-   [osg-version-3.3.34-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.3.34-1.osg33.el7)
-   [rsv-3.16.0-2.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=rsv-3.16.0-2.osg33.el7)
-   [xrootd-hdfs-2.0.2-1.osg33.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.0.2-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid frontier-squid-debuginfo htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-ca-certs osg-ca-certs-updater osg-ca-scripts osg-gums-config osg-release osg-tested-internal osg-tested-internal-gram osg-version rsv rsv-consumers rsv-core rsv-metrics vo-client vo-client-edgmkgridmap vo-client-lcmaps-voms xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
frontier-squid-2.7.STABLE9-27.1.1.osg33.el6
frontier-squid-debuginfo-2.7.STABLE9-27.1.1.osg33.el6
htcondor-ce-2.2.4-2.osg33.el6
htcondor-ce-bosco-2.2.4-2.osg33.el6
htcondor-ce-client-2.2.4-2.osg33.el6
htcondor-ce-collector-2.2.4-2.osg33.el6
htcondor-ce-condor-2.2.4-2.osg33.el6
htcondor-ce-lsf-2.2.4-2.osg33.el6
htcondor-ce-pbs-2.2.4-2.osg33.el6
htcondor-ce-sge-2.2.4-2.osg33.el6
htcondor-ce-slurm-2.2.4-2.osg33.el6
htcondor-ce-view-2.2.4-2.osg33.el6
myproxy-6.1.28-1.2.osg33.el6
myproxy-admin-6.1.28-1.2.osg33.el6
myproxy-debuginfo-6.1.28-1.2.osg33.el6
myproxy-devel-6.1.28-1.2.osg33.el6
myproxy-doc-6.1.28-1.2.osg33.el6
myproxy-libs-6.1.28-1.2.osg33.el6
myproxy-server-6.1.28-1.2.osg33.el6
myproxy-voms-6.1.28-1.2.osg33.el6
osg-ca-certs-updater-1.8-1.osg33.el6
osg-ca-scripts-1.2.3-1.osg33.el6
osg-release-3.3-7.osg33.el6
osg-tested-internal-3.3-20.osg33.el6
osg-tested-internal-gram-3.3-20.osg33.el6
osg-version-3.3.34-1.osg33.el6
rsv-3.16.0-2.osg33.el6
rsv-consumers-3.16.0-2.osg33.el6
rsv-core-3.16.0-2.osg33.el6
rsv-metrics-3.16.0-2.osg33.el6
xrootd-hdfs-2.0.2-1.osg33.el6
xrootd-hdfs-debuginfo-2.0.2-1.osg33.el6
xrootd-hdfs-devel-2.0.2-1.osg33.el6
xrootd-lcmaps-1.2.1-3.osg33.el6
xrootd-lcmaps-debuginfo-1.2.1-3.osg33.el6
```

#### Enterprise Linux 7

``` file
frontier-squid-2.7.STABLE9-27.1.1.osg33.el7
frontier-squid-debuginfo-2.7.STABLE9-27.1.1.osg33.el7
htcondor-ce-2.2.4-2.osg33.el7
htcondor-ce-bosco-2.2.4-2.osg33.el7
htcondor-ce-client-2.2.4-2.osg33.el7
htcondor-ce-collector-2.2.4-2.osg33.el7
htcondor-ce-condor-2.2.4-2.osg33.el7
htcondor-ce-lsf-2.2.4-2.osg33.el7
htcondor-ce-pbs-2.2.4-2.osg33.el7
htcondor-ce-sge-2.2.4-2.osg33.el7
htcondor-ce-slurm-2.2.4-2.osg33.el7
htcondor-ce-view-2.2.4-2.osg33.el7
myproxy-6.1.28-1.2.osg33.el7
myproxy-admin-6.1.28-1.2.osg33.el7
myproxy-debuginfo-6.1.28-1.2.osg33.el7
myproxy-devel-6.1.28-1.2.osg33.el7
myproxy-doc-6.1.28-1.2.osg33.el7
myproxy-libs-6.1.28-1.2.osg33.el7
myproxy-server-6.1.28-1.2.osg33.el7
myproxy-voms-6.1.28-1.2.osg33.el7
osg-ca-certs-updater-1.8-1.osg33.el7
osg-ca-scripts-1.2.3-1.osg33.el7
osg-release-3.3-7.osg33.el7
osg-tested-internal-3.3-20.osg33.el7
osg-tested-internal-gram-3.3-20.osg33.el7
osg-version-3.3.34-1.osg33.el7
rsv-3.16.0-2.osg33.el7
rsv-consumers-3.16.0-2.osg33.el7
rsv-core-3.16.0-2.osg33.el7
rsv-metrics-3.16.0-2.osg33.el7
xrootd-hdfs-2.0.2-1.osg33.el7
xrootd-hdfs-debuginfo-2.0.2-1.osg33.el7
xrootd-hdfs-devel-2.0.2-1.osg33.el7
```
