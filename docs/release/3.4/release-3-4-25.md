OSG Software Release 3.4.25
===========================

**Release Date**: 2019-03-07

Summary of changes
------------------

This release contains:

-   gsi-openssh 7.4p1: Update from [OpenSSH 7.3](https://www.openssh.com/txt/release-7.4)
-   HTCondor 8.6.13: Fixed duplicate accounting records when HTCondor-CE has a HTCondor backend
-   xrootd-lcmaps 1.7.0: Added --no-authz flag for StashCache cache servers
-   Upcoming Repository
    -   [HTCondor 8.8.1](https://www-auth.cs.wisc.edu/lists/htcondor-world/2019/msg00001.shtml): Bug fix release

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.25%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is only supported on EL7

Detailed changes are below. All of the documentation can be found [here](../../index.md).

Known Issues
------------

Due to the central RSV service retirement (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/) for details),
the new version of RSV will disable the `gratia-consumer` component that reports to the central service.
Please update _all_ RSV packages by running the following command on your RSV host:

``` console
root@host # yum update rsv\*
```

Additionally, if you are using osg-configure, please edit `/etc/osg/config.d/30-rsv.ini` and set the following:

``` file
enable_gratia = False
```

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

-   [condor-8.6.13-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.13-1.2.osg34.el6)
-   [koji-1.11.1-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.11.1-1.osg34.el6)
-   [osg-tested-internal-3.4-7.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-7.osg34.el6)
-   [osg-version-3.4.25-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.25-1.osg34.el6)
-   [xrootd-lcmaps-1.7.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.0-1.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.6.13-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.13-1.2.osg34.el7)
-   [gsi-openssh-7.4p1-2.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.4p1-2.3.osg34.el7)
-   [koji-1.11.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=koji-1.11.1-1.osg34.el7)
-   [osg-tested-internal-3.4-7.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-tested-internal-3.4-7.osg34.el7)
-   [osg-version-3.4.25-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.25-1.osg34.el7)
-   [xrootd-lcmaps-1.7.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.0-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server igtf-ca-certs koji koji-builder koji-hub koji-hub-plugins koji-utils koji-vm koji-web osg-ca-certs osg-tested-internal osg-version vo-client vo-client-dcache vo-client-lcmaps-voms xrootd-lcmaps xrootd-lcmaps-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.6.13-1.2.osg34.el6
condor-all-8.6.13-1.2.osg34.el6
condor-bosco-8.6.13-1.2.osg34.el6
condor-classads-8.6.13-1.2.osg34.el6
condor-classads-devel-8.6.13-1.2.osg34.el6
condor-cream-gahp-8.6.13-1.2.osg34.el6
condor-debuginfo-8.6.13-1.2.osg34.el6
condor-kbdd-8.6.13-1.2.osg34.el6
condor-procd-8.6.13-1.2.osg34.el6
condor-python-8.6.13-1.2.osg34.el6
condor-std-universe-8.6.13-1.2.osg34.el6
condor-test-8.6.13-1.2.osg34.el6
condor-vm-gahp-8.6.13-1.2.osg34.el6
koji-1.11.1-1.osg34.el6
koji-builder-1.11.1-1.osg34.el6
koji-hub-1.11.1-1.osg34.el6
koji-hub-plugins-1.11.1-1.osg34.el6
koji-utils-1.11.1-1.osg34.el6
koji-vm-1.11.1-1.osg34.el6
koji-web-1.11.1-1.osg34.el6
osg-tested-internal-3.4-7.osg34.el6
osg-version-3.4.25-1.osg34.el6
xrootd-lcmaps-1.7.0-1.osg34.el6
xrootd-lcmaps-debuginfo-1.7.0-1.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.6.13-1.2.osg34.el7
condor-all-8.6.13-1.2.osg34.el7
condor-bosco-8.6.13-1.2.osg34.el7
condor-classads-8.6.13-1.2.osg34.el7
condor-classads-devel-8.6.13-1.2.osg34.el7
condor-cream-gahp-8.6.13-1.2.osg34.el7
condor-debuginfo-8.6.13-1.2.osg34.el7
condor-kbdd-8.6.13-1.2.osg34.el7
condor-procd-8.6.13-1.2.osg34.el7
condor-python-8.6.13-1.2.osg34.el7
condor-test-8.6.13-1.2.osg34.el7
condor-vm-gahp-8.6.13-1.2.osg34.el7
gsi-openssh-7.4p1-2.3.osg34.el7
gsi-openssh-clients-7.4p1-2.3.osg34.el7
gsi-openssh-debuginfo-7.4p1-2.3.osg34.el7
gsi-openssh-server-7.4p1-2.3.osg34.el7
koji-1.11.1-1.osg34.el7
koji-builder-1.11.1-1.osg34.el7
koji-hub-1.11.1-1.osg34.el7
koji-hub-plugins-1.11.1-1.osg34.el7
koji-utils-1.11.1-1.osg34.el7
koji-vm-1.11.1-1.osg34.el7
koji-web-1.11.1-1.osg34.el7
osg-tested-internal-3.4-7.osg34.el7
osg-version-3.4.25-1.osg34.el7
xrootd-lcmaps-1.7.0-1.osg34.el7
xrootd-lcmaps-debuginfo-1.7.0-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.8.1-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.1-1.osgup.el6)

#### Enterprise Linux 7

-   [condor-8.8.1-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.1-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-std-universe condor-test condor-vm-gahp minicondor python2-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.8.1-1.osgup.el6
condor-all-8.8.1-1.osgup.el6
condor-annex-ec2-8.8.1-1.osgup.el6
condor-bosco-8.8.1-1.osgup.el6
condor-classads-8.8.1-1.osgup.el6
condor-classads-devel-8.8.1-1.osgup.el6
condor-cream-gahp-8.8.1-1.osgup.el6
condor-debuginfo-8.8.1-1.osgup.el6
condor-kbdd-8.8.1-1.osgup.el6
condor-procd-8.8.1-1.osgup.el6
condor-std-universe-8.8.1-1.osgup.el6
condor-test-8.8.1-1.osgup.el6
condor-vm-gahp-8.8.1-1.osgup.el6
minicondor-8.8.1-1.osgup.el6
python2-condor-8.8.1-1.osgup.el6
```

#### Enterprise Linux 7

``` file
condor-8.8.1-1.osgup.el7
condor-all-8.8.1-1.osgup.el7
condor-annex-ec2-8.8.1-1.osgup.el7
condor-bosco-8.8.1-1.osgup.el7
condor-classads-8.8.1-1.osgup.el7
condor-classads-devel-8.8.1-1.osgup.el7
condor-cream-gahp-8.8.1-1.osgup.el7
condor-debuginfo-8.8.1-1.osgup.el7
condor-kbdd-8.8.1-1.osgup.el7
condor-procd-8.8.1-1.osgup.el7
condor-test-8.8.1-1.osgup.el7
condor-vm-gahp-8.8.1-1.osgup.el7
minicondor-8.8.1-1.osgup.el7
python2-condor-8.8.1-1.osgup.el7
```
