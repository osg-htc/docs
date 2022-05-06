!!! failure "OSG 3.5 end-of-life"
    The OSG 3.5 end-of-life date was May 1, 2022 per our
    [release policy](https://opensciencegrid.org/technology/policy/release-series/).
    We recommend
    [updating to OSG 3.6](https://opensciencegrid.org/docs/release/updating-to-osg-36/)
    at your earliest convenience.```

OSG Software Release 3.5.59
===========================

**Release Date:** 2022-03-22  
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

-   [scitokens-cpp 0.7.0](https://github.com/scitokens/scitokens-cpp/releases/tag/v0.7.0): Extends token issuer certificate cache to four days
-   Upcoming
    -   [gfal2 2.20.5](https://gitlab.cern.ch/dmc/gfal2/-/blob/2.20.x/RELEASE-NOTES): Important bug fixes and features for HTTP, XRootD, and tokens

!!! Note
    -   XRootD 4 and gfal2 2.20 are incompatible
    -   You must enable 'osg-upcoming' when installing the OSG worker node client from 3.5

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.59%2C3.5.59-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [scitokens-cpp-0.7.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.7.0-1.osg35.el7)

#### Enterprise Linux 8

-   [scitokens-cpp-0.7.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.7.0-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
scitokens-cpp-0.7.0-1.osg35.el7
scitokens-cpp-debuginfo-0.7.0-1.osg35.el7
scitokens-cpp-devel-0.7.0-1.osg35.el7
```

#### Enterprise Linux 8

``` file
scitokens-cpp-0.7.0-1.osg35.el8
scitokens-cpp-debuginfo-0.7.0-1.osg35.el8
scitokens-cpp-debugsource-0.7.0-1.osg35.el8
scitokens-cpp-devel-0.7.0-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [gfal2-2.20.5-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gfal2-2.20.5-1.osg35up.el7)

#### Enterprise Linux 8

-   [gfal2-2.20.5-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gfal2-2.20.5-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    gfal2 gfal2-all gfal2-debuginfo gfal2-devel gfal2-doc gfal2-plugin-dcap gfal2-plugin-file gfal2-plugin-gridftp gfal2-plugin-http gfal2-plugin-lfc gfal2-plugin-mock gfal2-plugin-rfio gfal2-plugin-sftp gfal2-plugin-srm gfal2-plugin-xrootd gfal2-tests 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
gfal2-2.20.5-1.osg35up.el7
gfal2-all-2.20.5-1.osg35up.el7
gfal2-debuginfo-2.20.5-1.osg35up.el7
gfal2-devel-2.20.5-1.osg35up.el7
gfal2-doc-2.20.5-1.osg35up.el7
gfal2-plugin-dcap-2.20.5-1.osg35up.el7
gfal2-plugin-file-2.20.5-1.osg35up.el7
gfal2-plugin-gridftp-2.20.5-1.osg35up.el7
gfal2-plugin-http-2.20.5-1.osg35up.el7
gfal2-plugin-lfc-2.20.5-1.osg35up.el7
gfal2-plugin-mock-2.20.5-1.osg35up.el7
gfal2-plugin-rfio-2.20.5-1.osg35up.el7
gfal2-plugin-sftp-2.20.5-1.osg35up.el7
gfal2-plugin-srm-2.20.5-1.osg35up.el7
gfal2-plugin-xrootd-2.20.5-1.osg35up.el7
gfal2-tests-2.20.5-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
gfal2-2.20.5-1.osg35up.el8
gfal2-all-2.20.5-1.osg35up.el8
gfal2-debuginfo-2.20.5-1.osg35up.el8
gfal2-debugsource-2.20.5-1.osg35up.el8
gfal2-devel-2.20.5-1.osg35up.el8
gfal2-doc-2.20.5-1.osg35up.el8
gfal2-plugin-dcap-2.20.5-1.osg35up.el8
gfal2-plugin-dcap-debuginfo-2.20.5-1.osg35up.el8
gfal2-plugin-file-2.20.5-1.osg35up.el8
gfal2-plugin-file-debuginfo-2.20.5-1.osg35up.el8
gfal2-plugin-gridftp-2.20.5-1.osg35up.el8
gfal2-plugin-gridftp-debuginfo-2.20.5-1.osg35up.el8
gfal2-plugin-http-2.20.5-1.osg35up.el8
gfal2-plugin-http-debuginfo-2.20.5-1.osg35up.el8
gfal2-plugin-mock-2.20.5-1.osg35up.el8
gfal2-plugin-mock-debuginfo-2.20.5-1.osg35up.el8
gfal2-plugin-sftp-2.20.5-1.osg35up.el8
gfal2-plugin-sftp-debuginfo-2.20.5-1.osg35up.el8
gfal2-plugin-srm-2.20.5-1.osg35up.el8
gfal2-plugin-srm-debuginfo-2.20.5-1.osg35up.el8
gfal2-plugin-xrootd-2.20.5-1.osg35up.el8
gfal2-plugin-xrootd-debuginfo-2.20.5-1.osg35up.el8
gfal2-tests-2.20.5-1.osg35up.el8
gfal2-tests-debuginfo-2.20.5-1.osg35up.el8
```
