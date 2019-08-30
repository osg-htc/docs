OSG Software Release 3.5.0
===========================

**Release Date:** 2019-08-30    
**Supported OS Versions:** EL7

Summary of changes
------------------

This initial release of the OSG 3.5 release series is based on the packages available in
[OSG 3.4.33](/release/3.4/release-3-4-33#) with some [additions](#package-updates) and [subtractions](#package-removals).
Other notable changes in this release series include dropping support for Enterprise Linux 6 and
[CREAM CEs](https://opensciencegrid.org/technology/policy/cream-support/).

To update to the OSG 3.5 release series, please consult the page on
[updating between release series](/release/release_series#updating-to-osg-35).

!!! question "Where are GlideinWMS and HTCondor-CE?"
    HTCondor-CE (including `osg-ce` metapackages) and GlideinWMS are both absent in OSG 3.5.0:
    we expect major version upgrades that may require manual intervention for both of these packages so we are holding
    their initial releases in this series until they are ready.

!!! warning "OSG 3.4 end-of-life"
    As a result of this initial OSG 3.5 release, the end-of-life dates have been set for OSG 3.4 per our
    [policy](https://opensciencegrid.org/technology/policy/release-series/):
    regular support will end in **February 2020** and critical bug/security support will end in **November 2020**.

### Package updates ###

In addition to the packages that were carried over from [OSG 3.4.33](/release/3.4/release-3-4-33#),
this release contains the following package updates:

-   HTCondor 8.8.4: The current HTCondor [stable release](https://htcondor.readthedocs.io/en/v8_8_4/version-history/stable-release-series-88.html).
    See the [manual update instructions](/release/release_series#updating-to-htcondor-8.8.x) before
    updating to this version.
-   CVMFS 2.6.2: A [bug fix release](https://cvmfs.readthedocs.io/en/2.6/cpt-releasenotes.html).
    Note the upgrade recommendations from the developers:

    > As with previous releases, upgrading clients should be seamless just by installing the new package from the
    > repository.
    > As usual, we recommend to update only a few worker nodes first and gradually ramp up once the new version proves
    > to work correctly.
    > Please take special care when upgrading a cvmfs client in NFS mode.

    > For Stratum 1 servers, there should be no running snapshots during the upgrade.
    > For publisher and gateway nodes, all transactions must be closed and no active leases must be present before
    > upgrading.

    See the known issue with this version [below](#known-issues).

-   XCache 1.1.1: This release includes packages for ATLAS and CMS XCaches as well as Stash Origin HTTP/S support.
-   OSG Configure 3.0.0: A [major version release](https://github.com/opensciencegrid/osg-configure/releases/tag/v3.0.0),
    including changes from the OSG Configure 2.4 series and dropping some deprecated features.
    See the [manual update instructions](/release/release_series#updating-to-osg-configure-3) before updating to this
    version.
-   OSG XRootD 3.5: A meta-package including common configuration across [standalone](/data/xrootd/install-standalone),
    [storage element](/data/xrootd/install-storage-element), and [caching](/data/stashcache/overview) installations of
    XRootD.
-   XRootD LCMAPS 1.7.4: includes default authorization configuration in `/etc/xrootd/config.d/40-xrootd-lcmaps.cfg`.
    To use the default configuration, uncomment the `# set EnableLcmaps = 1` line in `/etc/xrootd/config.d/10-xrootd-lcmaps.cfg`.
-   XRootD HDFS 2.1.6: includes default configuration in `/etc/xrootd/40-xrootd-hdfs.cfg`.
-   MyProxy 6.2.4: Remove usage statistics collection support
-   [CCTools 7.0.14](http://ccl.cse.nd.edu/software/): Bug fix release
-   OSG System Profiler 1.4.3: Remove collection of obsolete information
    See the known issue with this version [below](#known-issues).
-   Upcoming repository:
    - HTCondor 8.9.2: The current HTCondor [development release](https://htcondor.readthedocs.io/en/v8_9_2/version-history/development-release-series-89.html)

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.0%20)
were addressed in this release.


### Package removals ###

A new [OSG release series](/release/release_series/), gives us the opportunity to clean up our
[Yum repositories](/common/yum#repositories):
either removing packages that are the same version of those available in EPEL;
or removing pacakges that are now obsolete in the OSG Software stack.
Below, you will find a list of packages that were in OSG 3.4 but have been removed in OSG 3.5.
If you believe any of the following packages have been removed in error, please [contact us](/common/help).

The following packages were removed from the OSG 3.5 Yum repositories but are available via
[EPEL repositories](/common/yum#install-the-epel-repositories):

- singularity
- globus-ftp-client
- globus-gridftp-server-control

The following packages are obsolete and have been removed from the OSG 3.5 Yum repositories:

- autopyfactory
- CREAM packages:
    - glite-ce-cream-client-api-c
    - glite-ce-wsdl
    - glite-build-common-cpp
- PerfSONAR client tools:
    - bwctl
    - l2util
    - nuttcp
    - owamp
    - perfsonar-tools
- lcmaps-plugins-scas-client
- osg-control
- osg-version
- osg-vo-map
- rsv
- xacml

Known Issues
------------

- CVMFS 2.6.2 has a known memory leak when using an `/etc/hosts` file with lines only containing whitespace
([CVM-1796](https://sft.its.cern.ch/jira/browse/CVM-1796))
- OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).


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

-

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    <rpm list here>

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
```
