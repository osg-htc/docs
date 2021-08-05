OSG Software Release 3.5.44
===========================

**Release Date:** 2021-08-05  
**Supported OS Versions:** EL7, EL8

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 offers a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Summary of Changes
------------------

This release contains:

-   VOMS 2.0.16-1.2 (EL7) and VOMS 2.1.0-0.14.rc2.2 (EL8)
    -   Add IAM and TLS SNI support
-   htvault-config 1.4 and htgettoken 1.3
    -   Improved security through more fine-grained vault tokens and detailed logging
    -   Miscellaneous improvements
-   Upcoming
    -   XCache 2.1.0-3: Update to scripts to Python 3

!!! bug "Known Issue"
    -   HTCondor-CE 5.3.0: caches or proxy servers may crash under heavy load
        -   Add "xrootd.async off" to your configuration file to avoid the issue

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.44%2C3.5.44-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [OSG Docker images](https://hub.docker.com/u/opensciencegrid/) have been updated to contain the new software.

Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](../updating-to-osg-35.md).

For sites using non-RPM worker node client installations, new [tarballs](../../worker-node/install-wn-tarball.md) and
[container images](../../worker-node/using-wn-containers.md) are available:

- Tarball: <https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz>
- Container Images: <https://hub.docker.com/r/opensciencegrid/osg-wn/>

Need Help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed Changes in This Release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list [below](#rpms).

#### Enterprise Linux 7

-   [htgettoken-1.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.3-1.osg35.el7)
-   [htvault-config-1.4-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.4-1.osg35.el7)
-   [voms-2.0.16-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.16-1.2.osg35.el7)

#### Enterprise Linux 8

-   [htgettoken-1.3-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.3-1.osg35.el8)
-   [htvault-config-1.4-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.4-1.osg35.el8)
-   [voms-2.1.0-0.14.rc2.2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.1.0-0.14.rc2.2.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    htgettoken htvault-config voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
htgettoken-1.3-1.osg35.el7
htvault-config-1.4-1.osg35.el7
voms-2.0.16-1.2.osg35.el7
voms-clients-cpp-2.0.16-1.2.osg35.el7
voms-debuginfo-2.0.16-1.2.osg35.el7
voms-devel-2.0.16-1.2.osg35.el7
voms-doc-2.0.16-1.2.osg35.el7
voms-server-2.0.16-1.2.osg35.el7
```

#### Enterprise Linux 8

``` file
htgettoken-1.3-1.osg35.el8
htvault-config-1.4-1.osg35.el8
voms-2.1.0-0.14.rc2.2.osg35.el8
voms-clients-cpp-2.1.0-0.14.rc2.2.osg35.el8
voms-clients-cpp-debuginfo-2.1.0-0.14.rc2.2.osg35.el8
voms-debuginfo-2.1.0-0.14.rc2.2.osg35.el8
voms-debugsource-2.1.0-0.14.rc2.2.osg35.el8
voms-devel-2.1.0-0.14.rc2.2.osg35.el8
voms-doc-2.1.0-0.14.rc2.2.osg35.el8
voms-server-2.1.0-0.14.rc2.2.osg35.el8
voms-server-debuginfo-2.1.0-0.14.rc2.2.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [xcache-2.0.1-3.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-2.0.1-3.osg35up.el7)

#### Enterprise Linux 8

-   [xcache-2.0.1-3.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-2.0.1-3.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    atlas-xcache cms-xcache stash-cache stash-origin xcache xcache-consistency-check xcache-redirector 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
atlas-xcache-2.0.1-3.osg35up.el7
cms-xcache-2.0.1-3.osg35up.el7
stash-cache-2.0.1-3.osg35up.el7
stash-origin-2.0.1-3.osg35up.el7
xcache-2.0.1-3.osg35up.el7
xcache-consistency-check-2.0.1-3.osg35up.el7
xcache-redirector-2.0.1-3.osg35up.el7
```

#### Enterprise Linux 8

``` file
atlas-xcache-2.0.1-3.osg35up.el8
cms-xcache-2.0.1-3.osg35up.el8
stash-cache-2.0.1-3.osg35up.el8
stash-origin-2.0.1-3.osg35up.el8
xcache-2.0.1-3.osg35up.el8
xcache-consistency-check-2.0.1-3.osg35up.el8
xcache-redirector-2.0.1-3.osg35up.el8
```
