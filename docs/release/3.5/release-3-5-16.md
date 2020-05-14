OSG Software Release 3.5.16
===========================

**Release Date:** 2020-05-14    
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

-   [CVMFS 2.7.2](https://cvmfs.readthedocs.io/en/2.7/cpt-releasenotes.html)
    -   Optimizes loading of nested catalogs
    -   Improves logging when switching hosts
-   [Frontier Squid 4.11-2.1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt)
    -   Fixed a bug that caused capital 'L's from appearing at the beginning of log lines under heavy load
-   osg-ce 3.5-5: Fixed Hosted CE Gratia schedd cron
-   hosted-ce-tools 0.7: Added worker node client update timeout to prevent hangs
-   [CCTools 7.1.5](https://cclnd.blogspot.com/2020/05/cctools-version-715-released.html): Update from 7.0.22 (minor features and bug fixes)
    -   [CCTools 7.1.2](https://cclnd.blogspot.com/2020/04/cctools-version-712-released.html)
    -   [CCTools 7.1.0](https://cclnd.blogspot.com/2020/03/cctools-710-released.html)
-   [VO Package v105](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-105): Added EIC VO

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.16%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

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

-   [cctools-7.1.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cctools-7.1.5-1.osg35.el7)
-   [cvmfs-2.7.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.2-1.osg35.el7)
-   [frontier-squid-4.11-2.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.11-2.1.osg35.el7)
-   [hosted-ce-tools-0.7-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=hosted-ce-tools-0.7-1.osg35.el7)
-   [osg-ce-3.5-5.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.5-5.osg35.el7)
-   [osg-oasis-16-3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-3.osg35.el7)
-   [vo-client-105-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-105-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cctools cctools-debuginfo cctools-devel cvmfs cvmfs-devel cvmfs-ducc cvmfs-server cvmfs-shrinkwrap cvmfs-unittests cvmfs-x509-helper cvmfs-x509-helper-debuginfo frontier-squid frontier-squid-debuginfo hosted-ce-tools osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-oasis vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
cctools-7.1.5-1.osg35.el7
cctools-debuginfo-7.1.5-1.osg35.el7
cctools-devel-7.1.5-1.osg35.el7
cvmfs-2.7.2-1.osg35.el7
cvmfs-devel-2.7.2-1.osg35.el7
cvmfs-ducc-2.7.2-1.osg35.el7
cvmfs-fuse3-2.7.2-1.osg35.el7
cvmfs-server-2.7.2-1.osg35.el7
cvmfs-shrinkwrap-2.7.2-1.osg35.el7
cvmfs-unittests-2.7.2-1.osg35.el7
frontier-squid-4.11-2.1.osg35.el7
frontier-squid-debuginfo-4.11-2.1.osg35.el7
hosted-ce-tools-0.7-1.osg35.el7
osg-ce-3.5-5.osg35.el7
osg-ce-bosco-3.5-5.osg35.el7
osg-ce-condor-3.5-5.osg35.el7
osg-ce-lsf-3.5-5.osg35.el7
osg-ce-pbs-3.5-5.osg35.el7
osg-ce-sge-3.5-5.osg35.el7
osg-ce-slurm-3.5-5.osg35.el7
osg-oasis-16-3.osg35.el7
vo-client-105-1.osg35.el7
vo-client-dcache-105-1.osg35.el7
vo-client-lcmaps-voms-105-1.osg35.el7
```
