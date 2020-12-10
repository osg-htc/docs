OSG Software Release 3.5.18
===========================

**Release Date:** 2020-06-11    
**Supported OS Versions:** EL7

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

This release contains:

-   [Frontier Squid 4.11-3.1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): Fixed critical bug that causes server errors to be cached indefinitely which may require caches to be cleared. The bug was introduced in version 4.10-3.1
-   VOMS 2.0.14-1.6: Allow VOMS libraries to accept certificates with VOMS attributes that only have a top-level component, such as those provided by the WLCG VO
-   XCache 1.4
    -   added xcache-consistency-check
    -   advertise to the OSG Central Collector via SSL
    -   reduced default XRootD logging verbosity
-   stashcache-client 5.6.1: reads the list of caches from the globally available WLCG-WPAD service; this allows updates to the cache list without a new release of stashcache-client

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.18%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.


Containers
----------

The `Frontier Squid` and `Hosted CE` containers are available and have been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [Frontier Squid](https://hub.docker.com/r/opensciencegrid/frontier-squid/)
-   [Hosted CE](https://hub.docker.com/r/opensciencegrid/hosted-ce/)


The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.


Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
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

-   [frontier-squid-4.11-3.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.11-3.1.osg35.el7)
-   [stashcache-client-5.6.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-5.6.1-1.osg35.el7)
-   [voms-2.0.14-1.6.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=voms-2.0.14-1.6.osg35.el7)
-   [xcache-1.4.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-1.4.0-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    atlas-xcache cms-xcache frontier-squid frontier-squid-debuginfo stash-cache stashcache-client stash-origin voms voms-clients-cpp voms-debuginfo voms-devel voms-doc voms-server xcache xcache-consistency-check xcache-redirector

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
atlas-xcache-1.4.0-1.osg35.el7
cms-xcache-1.4.0-1.osg35.el7
frontier-squid-4.11-3.1.osg35.el7
frontier-squid-debuginfo-4.11-3.1.osg35.el7
stash-cache-1.4.0-1.osg35.el7
stashcache-client-5.6.1-1.osg35.el7
stash-origin-1.4.0-1.osg35.el7
voms-2.0.14-1.6.osg35.el7
voms-clients-cpp-2.0.14-1.6.osg35.el7
voms-debuginfo-2.0.14-1.6.osg35.el7
voms-devel-2.0.14-1.6.osg35.el7
voms-doc-2.0.14-1.6.osg35.el7
voms-server-2.0.14-1.6.osg35.el7
xcache-1.4.0-1.osg35.el7
xcache-consistency-check-1.4.0-1.osg35.el7
xcache-redirector-1.4.0-1.osg35.el7
```
