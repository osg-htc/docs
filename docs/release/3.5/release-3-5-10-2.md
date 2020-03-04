OSG Data Release 3.5.10-2
========================

**Release Date:** 2020-03-04    
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

This release contains [VO Package v100](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-100):

- New cert for GLOW (SOFTWARE-4006)
- Replace one of the certs for OSG (SOFTWARE-4007)
- Update voms2.fnal.gov DN for DES, DUNE, Fermilab (SOFTWARE-4012)
- Map FQANs from Fermilab VO subgroups to the same user as the VO-wide target (SOFTWARE-4005)
- Drop CDF (SOFTWARE-4012)
- Drop MIS VO (SOFTWARE-3575)

These [JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.10-2%2C%203.4.44-2)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The [Worker Node containers](/worker-node/using-wn-containers/) have been updated to this release.

Updating to the New Release
---------------------------

To update to the OSG 3.5 series from an earlier release series, please consult the page on
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

-   [vo-client-100-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-100-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
vo-client-100-1.osg35.el7
vo-client-dcache-100-1.osg35.el7
vo-client-lcmaps-voms-100-1.osg35.el7
```
