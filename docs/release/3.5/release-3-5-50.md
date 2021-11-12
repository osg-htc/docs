OSG Software Release 3.5.50
===========================

**Release Date:** 2021-10-13  
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

-   osg-ca-certs-updater 2.0: Update to Python 3 for EL8
-   Upcoming
    -   xrootd-multiuser 2.0.3: Fix bug in lfn2pfn function

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.50%2C3.5.50-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [osg-ca-certs-updater-2.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-2.0-1.osg35.el7)

#### Enterprise Linux 8

-   [osg-ca-certs-updater-2.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-updater-2.0-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-ca-certs-updater 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
osg-ca-certs-updater-2.0-1.osg35.el7
```

#### Enterprise Linux 8

``` file
osg-ca-certs-updater-2.0-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [xrootd-multiuser-2.0.3-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-2.0.3-1.osg35up.el7)

#### Enterprise Linux 8

-   [xrootd-multiuser-2.0.3-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-2.0.3-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    xrootd-multiuser xrootd-multiuser-debuginfo 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
xrootd-multiuser-2.0.3-1.osg35up.el7
xrootd-multiuser-debuginfo-2.0.3-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
xrootd-multiuser-2.0.3-1.osg35up.el8
xrootd-multiuser-debuginfo-2.0.3-1.osg35up.el8
xrootd-multiuser-debugsource-2.0.3-1.osg35up.el8
```
