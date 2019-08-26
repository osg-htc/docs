OSG Software Release 3.4.20
===========================

**Release Date**: 2018-11-01

Summary of changes
------------------

This release contains:

-   [GlideinWMS 3.4.2](http://glideinwms.fnal.gov/doc.v3_4_2/history.html): improved Singularity support
-   [SciTokens 1.2.1](https://github.com/scitokens/scitokens/releases/tag/v1.2.1): bug fix for multiple audience support in the verifier
-   StashCache-Daemon: improved statistics collection
-   StashCache-Client: new RPM packaging for stashcp
-   [HTCondor 8.6.13](https://www-auth.cs.wisc.edu/lists/htcondor-world/2018/msg00019.shtml): bug fix release
    -   Fixed a bug where job start date was not recorded for hosted CEs
    -   Made the Python 'in' operator case-insensitive for ClassAd attributes
    -   Python bindings are now built for the Debian and Ubuntu platforms
    -   Fixed a memory leak in the Python bindings
    -   Fixed a bug where absolute paths failed for output/error files on Windows
    -   Fixed a bug using Condor-C to run Condor-C jobs
    -   Fixed a bug where Singularity could not be used if Docker was not present
-   Upcoming: [HTCondor 8.7.10](https://www-auth.cs.wisc.edu/lists/htcondor-world/2018/msg00020.shtml): final 8.7.x release
    -   Can now interactively submit Docker jobs
    -   The administrator can now add arguments to the Singularity command line
    -   The MUNGE security method is now supported on all Linux platforms
    -   The grid universe can create and manage VM instances in Microsoft Azure
    -   Added a single-node package to facilitate using a personal HTCondor

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.20%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.

Detailed changes are below. All of the documentation can be found [here](/index.md).

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

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-to-osg-35).

### Update Repositories

To update to this series, you need to [install the current OSG repositories](/common/yum#install-osg-repositories).

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

Do you need help with this release? [Contact us for help](/common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.6.13-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.13-1.osg34.el6)
-   [glideinwms-3.4.2-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4.2-1.osg34.el6)
-   [osg-version-3.4.20-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.20-1.osg34.el6)
-   [stashcache-client-5.1.0-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-5.1.0-4.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.6.13-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.6.13-1.osg34.el7)
-   [glideinwms-3.4.2-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4.2-1.osg34.el7)
-   [osg-version-3.4.20-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.20-1.osg34.el7)
-   [python-jwt-1.6.1-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-jwt-1.6.1-1.osg34.el7)
-   [python-scitokens-1.2.1-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.2.1-2.osg34.el7)
-   [stashcache-0.10-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-0.10-1.osg34.el7)
-   [stashcache-client-5.1.0-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-5.1.0-4.osg34.el7)
-   [xrootd-scitokens-0.6.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-0.6.0-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone osg-version python2-jwt python2-scitokens python34-jwt stashcache-cache-server stashcache-cache-server-auth stashcache-client stashcache-daemon stashcache-origin-server xrootd-scitokens xrootd-scitokens-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.6.13-1.osg34.el6
condor-all-8.6.13-1.osg34.el6
condor-bosco-8.6.13-1.osg34.el6
condor-classads-8.6.13-1.osg34.el6
condor-classads-devel-8.6.13-1.osg34.el6
condor-cream-gahp-8.6.13-1.osg34.el6
condor-debuginfo-8.6.13-1.osg34.el6
condor-kbdd-8.6.13-1.osg34.el6
condor-procd-8.6.13-1.osg34.el6
condor-python-8.6.13-1.osg34.el6
condor-std-universe-8.6.13-1.osg34.el6
condor-test-8.6.13-1.osg34.el6
condor-vm-gahp-8.6.13-1.osg34.el6
glideinwms-3.4.2-1.osg34.el6
glideinwms-common-tools-3.4.2-1.osg34.el6
glideinwms-condor-common-config-3.4.2-1.osg34.el6
glideinwms-factory-3.4.2-1.osg34.el6
glideinwms-factory-condor-3.4.2-1.osg34.el6
glideinwms-glidecondor-tools-3.4.2-1.osg34.el6
glideinwms-libs-3.4.2-1.osg34.el6
glideinwms-minimal-condor-3.4.2-1.osg34.el6
glideinwms-usercollector-3.4.2-1.osg34.el6
glideinwms-userschedd-3.4.2-1.osg34.el6
glideinwms-vofrontend-3.4.2-1.osg34.el6
glideinwms-vofrontend-standalone-3.4.2-1.osg34.el6
osg-version-3.4.20-1.osg34.el6
stashcache-client-5.1.0-4.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.6.13-1.osg34.el7
condor-all-8.6.13-1.osg34.el7
condor-bosco-8.6.13-1.osg34.el7
condor-classads-8.6.13-1.osg34.el7
condor-classads-devel-8.6.13-1.osg34.el7
condor-cream-gahp-8.6.13-1.osg34.el7
condor-debuginfo-8.6.13-1.osg34.el7
condor-kbdd-8.6.13-1.osg34.el7
condor-procd-8.6.13-1.osg34.el7
condor-python-8.6.13-1.osg34.el7
condor-test-8.6.13-1.osg34.el7
condor-vm-gahp-8.6.13-1.osg34.el7
glideinwms-3.4.2-1.osg34.el7
glideinwms-common-tools-3.4.2-1.osg34.el7
glideinwms-condor-common-config-3.4.2-1.osg34.el7
glideinwms-factory-3.4.2-1.osg34.el7
glideinwms-factory-condor-3.4.2-1.osg34.el7
glideinwms-glidecondor-tools-3.4.2-1.osg34.el7
glideinwms-libs-3.4.2-1.osg34.el7
glideinwms-minimal-condor-3.4.2-1.osg34.el7
glideinwms-usercollector-3.4.2-1.osg34.el7
glideinwms-userschedd-3.4.2-1.osg34.el7
glideinwms-vofrontend-3.4.2-1.osg34.el7
glideinwms-vofrontend-standalone-3.4.2-1.osg34.el7
osg-version-3.4.20-1.osg34.el7
python2-jwt-1.6.1-1.osg34.el7
python2-scitokens-1.2.1-2.osg34.el7
python34-jwt-1.6.1-1.osg34.el7
python-jwt-1.6.1-1.osg34.el7
python-scitokens-1.2.1-2.osg34.el7
stashcache-0.10-1.osg34.el7
stashcache-cache-server-0.10-1.osg34.el7
stashcache-cache-server-auth-0.10-1.osg34.el7
stashcache-client-5.1.0-4.osg34.el7
stashcache-daemon-0.10-1.osg34.el7
stashcache-origin-server-0.10-1.osg34.el7
xrootd-scitokens-0.6.0-1.osg34.el7
xrootd-scitokens-debuginfo-0.6.0-1.osg34.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [condor-8.7.10-1.osgup.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.10-1.osgup.el6)

#### Enterprise Linux 7

-   [condor-8.7.10-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.7.10-1.osgup.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-config-single-node condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-python condor-std-universe condor-test condor-vm-gahp

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
condor-8.7.10-1.osgup.el6
condor-all-8.7.10-1.osgup.el6
condor-annex-ec2-8.7.10-1.osgup.el6
condor-bosco-8.7.10-1.osgup.el6
condor-classads-8.7.10-1.osgup.el6
condor-classads-devel-8.7.10-1.osgup.el6
condor-config-single-node-8.7.10-1.osgup.el6
condor-cream-gahp-8.7.10-1.osgup.el6
condor-debuginfo-8.7.10-1.osgup.el6
condor-kbdd-8.7.10-1.osgup.el6
condor-procd-8.7.10-1.osgup.el6
condor-python-8.7.10-1.osgup.el6
condor-std-universe-8.7.10-1.osgup.el6
condor-test-8.7.10-1.osgup.el6
condor-vm-gahp-8.7.10-1.osgup.el6
```

#### Enterprise Linux 7

``` file
condor-8.7.10-1.osgup.el7
condor-all-8.7.10-1.osgup.el7
condor-annex-ec2-8.7.10-1.osgup.el7
condor-bosco-8.7.10-1.osgup.el7
condor-classads-8.7.10-1.osgup.el7
condor-classads-devel-8.7.10-1.osgup.el7
condor-config-single-node-8.7.10-1.osgup.el7
condor-cream-gahp-8.7.10-1.osgup.el7
condor-debuginfo-8.7.10-1.osgup.el7
condor-kbdd-8.7.10-1.osgup.el7
condor-procd-8.7.10-1.osgup.el7
condor-python-8.7.10-1.osgup.el7
condor-test-8.7.10-1.osgup.el7
condor-vm-gahp-8.7.10-1.osgup.el7
```
