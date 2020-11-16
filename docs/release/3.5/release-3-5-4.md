OSG Software Release 3.5.4
===========================

**Release Date:** 2019-10-23
**Supported OS Versions:** EL7

Summary of Changes
------------------

This release contains:

-   HTCondor 8.8.5-1.7: Addressed issue when updating from OSG 3.4
-   [StashCache-Client 5.5.0](https://github.com/opensciencegrid/StashCache/releases): Update from 5.2.0: Improved SciTokens support plus bug fixes
-   Updated CA certificates based on [IGTF 1.102](http://dist.eugridpma.info/distribution/igtf/current/CHANGES):
    -   Added CESNET-CA-4 ICA accredited classic CA for issuer roll-over (CZ)
-   [VO Package v97](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-97): Added CLAS12 VO for Jefferson Lab

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.4%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.

Known Issues
------------

- OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).


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

-   [condor-8.8.5-1.7.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.5-1.7.osg35.el7)
-   [igtf-ca-certs-1.102-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.102-1.osg35.el7)
-   [osg-ca-certs-1.84-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.84-1.osg35.el7)
-   [stashcache-client-5.5.0-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=stashcache-client-5.5.0-2.osg35.el7)
-   [vo-client-97-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-97-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp igtf-ca-certs minicondor osg-ca-certs python2-condor python3-condor stashcache-client vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
condor-8.8.5-1.7.osg35.el7
condor-all-8.8.5-1.7.osg35.el7
condor-annex-ec2-8.8.5-1.7.osg35.el7
condor-bosco-8.8.5-1.7.osg35.el7
condor-classads-8.8.5-1.7.osg35.el7
condor-classads-devel-8.8.5-1.7.osg35.el7
condor-debuginfo-8.8.5-1.7.osg35.el7
condor-kbdd-8.8.5-1.7.osg35.el7
condor-procd-8.8.5-1.7.osg35.el7
condor-test-8.8.5-1.7.osg35.el7
condor-vm-gahp-8.8.5-1.7.osg35.el7
igtf-ca-certs-1.102-1.osg35.el7
minicondor-8.8.5-1.7.osg35.el7
osg-ca-certs-1.84-1.osg35.el7
python2-condor-8.8.5-1.7.osg35.el7
python3-condor-8.8.5-1.7.osg35.el7
stashcache-client-5.5.0-2.osg35.el7
vo-client-97-1.osg35.el7
vo-client-dcache-97-1.osg35.el7
vo-client-lcmaps-voms-97-1.osg35.el7
```
