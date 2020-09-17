OSG Software Release 3.5.24
===========================

**Release Date:** 2020-09-17    
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

This release contains:

-   [VO Package v108](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-108)
    -   Adding the KAGRA VO
    -   Updating the VOMS of VIRGO
-   [CVMFS 2.7.4](https://cvmfs.readthedocs.io/en/2.7/cpt-releasenotes.html#release-notes-for-cernvm-fs-2-7-4)
    -   Server: fix ingestion of tarballs with leading slashes
    -   Server: fix name clash with certain, concurrently hosted repository names
    -   Gateway: fix statistics counting when renaming trees with nested catalogs
-   stashcache-client 6.1.0: Fixes to avoid overloading origin servers
-   hosted-ce-tools 0.8.2: Fix CA update failure when using mixed OS versions
-   [CCTools 7.1.7](http://cclnd.blogspot.com/2020/08/cctools-version-717-released.html): Bug fix release (EL7 Only)
-   Packages new to Enterprise Linux 8:
    -   Frontier-Squid 4.13-1.1
    -   stashcache-client 6.1.0
    -   hosted-ce-tools 0.8.2
    -   oidc-agent 3.3.3-1.1

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.24%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The following containers are available and have been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [CMS XCache](https://hub.docker.com/r/opensciencegrid/cms-xcache/)
-   [Frontier Squid](https://hub.docker.com/r/opensciencegrid/frontier-squid/)
-   [Hosted CE](https://hub.docker.com/r/opensciencegrid/hosted-ce/)
-   [Stash Cache](https://hub.docker.com/r/opensciencegrid/stash-cache/)
-   [Stash Origin](https://hub.docker.com/r/opensciencegrid/stash-origin/)

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

Known Issues
------------

There is a known bug in XRootD 5.0.1 that prevents HTTP-TPC from working with X.509 proxies. Sites that utilize HTTP-TPC to move data with FTS should not upgrade to this release. See [Gitub xrootd issue #1276](https://github.com/xrootd/xrootd/issues/1276) for technical details.


Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](/release/release_series#updating-to-osg-35).

For sites using non-RPM worker node client installations, new [tarballs](/worker-node/install-wn-tarball) and
[container images](/worker-node/using-wn-containers) are available:

- Tarball: <https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz>
- Container Images: <https://hub.docker.com/r/opensciencegrid/osg-wn/>

Need Help?
----------

Do you need help with this release? [Contact us for help](/common/help).

Detailed Changes in This Release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list [below](#rpms).

#### Enterprise Linux 7

-   [cctools-7.1.7-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.1.7-1.osg35.el7)
-   [cvmfs-2.7.4-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.4-1.osg35.el7)
-   [hosted-ce-tools-0.8-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.8-2.osg35.el7)
-   [osg-oasis-16-6.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-6.osg35.el7)
-   [stashcache-client-6.1.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-6.1.0-1.osg35.el7)
-   [vo-client-108-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-108-1.osg35.el7)

#### Enterprise Linux 8

-   [cvmfs-2.7.4-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.4-1.osg35.el8)
-   [frontier-squid-4.13-1.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.13-1.1.osg35.el8)
-   [hosted-ce-tools-0.8-2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.8-2.osg35.el8)
-   [oidc-agent-3.3.3-1.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=oidc-agent-3.3.3-1.1.osg35.el8)
-   [osg-oasis-16-6.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-6.osg35.el8)
-   [osg-release-3.5-4.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.5-4.osg35.el8)
-   [stashcache-client-6.1.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-6.1.0-1.osg35.el8)
-   [vo-client-108-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-108-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cctools cctools-debuginfo cctools-devel cvmfs cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests hosted-ce-tools osg-oasis stashcache-client vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
cctools-7.1.7-1.osg35.el7
cctools-debuginfo-7.1.7-1.osg35.el7
cctools-devel-7.1.7-1.osg35.el7
cvmfs-2.7.4-1.osg35.el7
cvmfs-devel-2.7.4-1.osg35.el7
cvmfs-ducc-2.7.4-1.osg35.el7
cvmfs-fuse3-2.7.4-1.osg35.el7
cvmfs-server-2.7.4-1.osg35.el7
cvmfs-shrinkwrap-2.7.4-1.osg35.el7
cvmfs-unittests-2.7.4-1.osg35.el7
hosted-ce-tools-0.8-2.osg35.el7
osg-oasis-16-6.osg35.el7
stashcache-client-6.1.0-1.osg35.el7
vo-client-108-1.osg35.el7
vo-client-dcache-108-1.osg35.el7
vo-client-lcmaps-voms-108-1.osg35.el7
```

#### Enterprise Linux 8

``` file
cvmfs-2.7.4-1.osg35.el8
cvmfs-devel-2.7.4-1.osg35.el8
cvmfs-ducc-2.7.4-1.osg35.el8
cvmfs-fuse3-2.7.4-1.osg35.el8
cvmfs-server-2.7.4-1.osg35.el8
cvmfs-shrinkwrap-2.7.4-1.osg35.el8
cvmfs-unittests-2.7.4-1.osg35.el8
frontier-squid-4.13-1.1.osg35.el8
hosted-ce-tools-0.8-2.osg35.el8
oidc-agent-3.3.3-1.1.osg35.el8
oidc-agent-debuginfo-3.3.3-1.1.osg35.el8
oidc-agent-debugsource-3.3.3-1.1.osg35.el8
osg-oasis-16-6.osg35.el8
osg-release-3.5-4.osg35.el8
stashcache-client-6.1.0-1.osg35.el8
vo-client-108-1.osg35.el8
vo-client-dcache-108-1.osg35.el8
vo-client-lcmaps-voms-108-1.osg35.el8
```
OSG Data Release 3.4.54-2
=========================

**Release Date:** 2020-09-17    
**Supported OS Versions:** EL7, EL6

!!!warning "OSG 3.4 End-of-Life Approaching"
    According to our
    [OSG Software Release Series Support Policy](https://opensciencegrid.org/technology/policy/release-series/),
    the OSG 3.4 series is due to reach
    [end-of-life](https://opensciencegrid.org/technology/policy/release-series/#life-cycle-dates) in **November 2020**.
    Please [upgrade to OSG 3.5](https://opensciencegrid.org/docs/release/release_series/#updating-to-osg-35)
    at your earliest convenience.

Summary of changes
------------------


These [JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.54-2%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

Updating to the new release
---------------------------

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

-   [vo-client-108-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-108-1.osg34.el6)

#### Enterprise Linux 7

-   [vo-client-108-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-108-1.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
vo-client-108-1.osg34.el6
vo-client-dcache-108-1.osg34.el6
vo-client-lcmaps-voms-108-1.osg34.el6
```

#### Enterprise Linux 7

``` file
vo-client-108-1.osg34.el7
vo-client-dcache-108-1.osg34.el7
vo-client-lcmaps-voms-108-1.osg34.el7
```
