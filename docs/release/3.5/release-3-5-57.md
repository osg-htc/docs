!!! failure "OSG 3.5 end-of-life"
    The OSG 3.5 end-of-life date was May 1, 2022 per our
    [release policy](https://opensciencegrid.org/technology/policy/release-series/).
    We recommend
    [updating to OSG 3.6](../updating-to-osg-36.md)
    at your earliest convenience.

OSG Software Release 3.5.57
===========================

**Release Date:** 2022-03-03  
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

-   osg-scitokens-mapfile 6
    -   Add default mappings for CLAS12, CMS, EIC, GlueX, IceCube, and IGWN
-   Upcoming
    -   [XRootD 5.4.1](https://github.com/xrootd/xrootd/blob/v5.4.1/docs/ReleaseNotes.txt): Bug fix release

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.57%2C3.5.57-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [osg-scitokens-mapfile-6-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-scitokens-mapfile-6-1.osg35.el7)

#### Enterprise Linux 8

-   [osg-scitokens-mapfile-6-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-scitokens-mapfile-6-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-scitokens-mapfile 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
osg-scitokens-mapfile-6-1.osg35.el7
```

#### Enterprise Linux 8

``` file
osg-scitokens-mapfile-6-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [osg-xrootd-3.5.upcoming-6.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5.upcoming-6.osg35up.el7)
-   [xrootd-5.4.1-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.4.1-1.osg35up.el7)

#### Enterprise Linux 8

-   [osg-xrootd-3.5.upcoming-6.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-xrootd-3.5.upcoming-6.osg35up.el8)
-   [xrootd-5.4.1-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.4.1-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    osg-xrootd osg-xrootd-standalone python2-xrootd python36-xrootd xrootd xrootd-client xrootd-client-compat xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-scitokens xrootd-selinux xrootd-server xrootd-server-compat xrootd-server-devel xrootd-server-libs xrootd-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
osg-xrootd-3.5.upcoming-6.osg35up.el7
osg-xrootd-standalone-3.5.upcoming-6.osg35up.el7
python2-xrootd-5.4.1-1.osg35up.el7
python36-xrootd-5.4.1-1.osg35up.el7
xrootd-5.4.1-1.osg35up.el7
xrootd-client-5.4.1-1.osg35up.el7
xrootd-client-compat-5.4.1-1.osg35up.el7
xrootd-client-devel-5.4.1-1.osg35up.el7
xrootd-client-libs-5.4.1-1.osg35up.el7
xrootd-debuginfo-5.4.1-1.osg35up.el7
xrootd-devel-5.4.1-1.osg35up.el7
xrootd-doc-5.4.1-1.osg35up.el7
xrootd-fuse-5.4.1-1.osg35up.el7
xrootd-libs-5.4.1-1.osg35up.el7
xrootd-private-devel-5.4.1-1.osg35up.el7
xrootd-scitokens-5.4.1-1.osg35up.el7
xrootd-selinux-5.4.1-1.osg35up.el7
xrootd-server-5.4.1-1.osg35up.el7
xrootd-server-compat-5.4.1-1.osg35up.el7
xrootd-server-devel-5.4.1-1.osg35up.el7
xrootd-server-libs-5.4.1-1.osg35up.el7
xrootd-voms-5.4.1-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
osg-xrootd-3.5.upcoming-6.osg35up.el8
osg-xrootd-standalone-3.5.upcoming-6.osg35up.el8
python3-xrootd-5.4.1-1.osg35up.el8
python3-xrootd-debuginfo-5.4.1-1.osg35up.el8
xrootd-5.4.1-1.osg35up.el8
xrootd-client-5.4.1-1.osg35up.el8
xrootd-client-compat-5.4.1-1.osg35up.el8
xrootd-client-compat-debuginfo-5.4.1-1.osg35up.el8
xrootd-client-debuginfo-5.4.1-1.osg35up.el8
xrootd-client-devel-5.4.1-1.osg35up.el8
xrootd-client-devel-debuginfo-5.4.1-1.osg35up.el8
xrootd-client-libs-5.4.1-1.osg35up.el8
xrootd-client-libs-debuginfo-5.4.1-1.osg35up.el8
xrootd-debuginfo-5.4.1-1.osg35up.el8
xrootd-debugsource-5.4.1-1.osg35up.el8
xrootd-devel-5.4.1-1.osg35up.el8
xrootd-doc-5.4.1-1.osg35up.el8
xrootd-fuse-5.4.1-1.osg35up.el8
xrootd-fuse-debuginfo-5.4.1-1.osg35up.el8
xrootd-libs-5.4.1-1.osg35up.el8
xrootd-libs-debuginfo-5.4.1-1.osg35up.el8
xrootd-private-devel-5.4.1-1.osg35up.el8
xrootd-scitokens-5.4.1-1.osg35up.el8
xrootd-scitokens-debuginfo-5.4.1-1.osg35up.el8
xrootd-selinux-5.4.1-1.osg35up.el8
xrootd-server-5.4.1-1.osg35up.el8
xrootd-server-compat-5.4.1-1.osg35up.el8
xrootd-server-compat-debuginfo-5.4.1-1.osg35up.el8
xrootd-server-debuginfo-5.4.1-1.osg35up.el8
xrootd-server-devel-5.4.1-1.osg35up.el8
xrootd-server-libs-5.4.1-1.osg35up.el8
xrootd-server-libs-debuginfo-5.4.1-1.osg35up.el8
xrootd-voms-5.4.1-1.osg35up.el8
xrootd-voms-debuginfo-5.4.1-1.osg35up.el8
```
