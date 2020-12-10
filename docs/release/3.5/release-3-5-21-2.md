OSG Data Release 3.5.21-2
=========================

**Release Date:** 2020-08-10    
**Supported OS Versions:** EL7, EL8

!!!tip "Want faster access to production-ready software?"
    OSG 3.5 and 3.4 offer a rolling release repository where packages are added as soon as they pass acceptance testing.
    To install packages from this repository, enable `[osg-rolling]` in `/etc/yum.repos.d/osg-rolling.repo`:

        [osg-rolling]
        ...
        enabled=1

    Or for one-time installations, append the following to your `yum` command:

        --enablerepo=osg-rolling

Summary of Changes
------------------

CA Certificates based on [IGTF 1.107](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)

-   Retired DarkMatterSecureCA and DarkMatterAssuredCA (AE)
-   Removed superseded PolishGrid CA (PL)
-   Added TCS G4 ECC trust anchors to accredited set (EU)

[VO Package v107](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-107)

-   Update SLAC VOMS server DN


These [JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.21-2%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

- [Worker Node containers](../../worker-node/using-wn-containers.md) have been updated to this release.

Updating to the New Release
---------------------------

To update to the OSG 3.5 series from an earlier release series, please consult the page on
[updating between release series](../release_series.md#updating-to-osg-35).

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

-   [igtf-ca-certs-1.107-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.107-1.osg35.el7)
-   [osg-ca-certs-1.89-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.89-1.osg35.el7)
-   [vo-client-107-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-107-1.osg35.el7)

#### Enterprise Linux 8

-   [igtf-ca-certs-1.107-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.107-1.osg35.el8)
-   [osg-ca-certs-1.89-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.89-1.osg35.el8)
-   [vo-client-107-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-107-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    igtf-ca-certs osg-ca-certs vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
igtf-ca-certs-1.107-1.osg35.el7
osg-ca-certs-1.89-1.osg35.el7
vo-client-107-1.osg35.el7
vo-client-dcache-107-1.osg35.el7
vo-client-lcmaps-voms-107-1.osg35.el7
```

#### Enterprise Linux 8

``` file
igtf-ca-certs-1.107-1.osg35.el8
osg-ca-certs-1.89-1.osg35.el8
vo-client-107-1.osg35.el8
vo-client-dcache-107-1.osg35.el8
vo-client-lcmaps-voms-107-1.osg35.el8
```
