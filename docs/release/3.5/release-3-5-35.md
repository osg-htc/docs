OSG Software Release 3.5.35
===========================

**Release Date:** 2021-05-13  
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

-   [Frontier Squid 4.15-1.2](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES)
    -   [Closes multiple security vulnerabilities](http://lists.squid-cache.org/pipermail/squid-announce/2021-May/000127.html)
-   Updated CA certificates based on [IGTF 1.110](http://dist.eugridpma.info/distribution/igtf/current/CHANGES)
    -   Removed INFN-CA-2015 that has disappeared operationally (IT)
-   osg-ca-certs 1.96
    -   Fixed Let's Encrypt signing policy to accept cross-signing chain


These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.35%2C3.5.35-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [OSG Docker images](https://hub.docker.com/u/opensciencegrid/) have been updated to contain the latest CA certificates.

The [OSG Frontier Squid image](https://hub.docker.com/r/opensciencegrid/frontier-squid) contains the security fixes.

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

-   [frontier-squid-4.15-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.15-1.2.osg35.el7)
-   [igtf-ca-certs-1.110-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.110-1.osg35.el7)
-   [osg-ca-certs-1.96-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.96-1.osg35.el7)

#### Enterprise Linux 8

-   [cilogon-openid-ca-cert-1.1-4.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cilogon-openid-ca-cert-1.1-4.osg35.el8)
-   [frontier-squid-4.15-1.2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.15-1.2.osg35.el8)
-   [igtf-ca-certs-1.110-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.110-1.osg35.el8)
-   [osg-ca-certs-1.96-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.96-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid igtf-ca-certs osg-ca-certs 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
frontier-squid-4.15-1.2.osg35.el7
igtf-ca-certs-1.110-1.osg35.el7
osg-ca-certs-1.96-1.osg35.el7
```

#### Enterprise Linux 8

``` file
cilogon-openid-ca-cert-1.1-4.osg35.el8
frontier-squid-4.15-1.2.osg35.el8
igtf-ca-certs-1.110-1.osg35.el8
osg-ca-certs-1.96-1.osg35.el8
```

