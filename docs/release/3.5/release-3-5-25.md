OSG Software Release 3.5.25
===========================

**Release Date:** 2020-10-08    
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

-   [GlideinWMS 3.6.5](https://glideinwms.fnal.gov/doc.v3_6_5/history.html) Upgrade from 3.6.2
    -   Improved Singularity support
    -   HTCondor's Python based condor\_chip in the PATH
    -   Support for EL8 worker nodes
-   [BLAHP 1.18.48](https://github.com/htcondor/BLAH/releases/tag/v1.18.48)
    -   Add efficient querying of LSF job statuses
    -   Improve logic when proxy refresh is disabled 

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.25%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The following containers are available and have been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [CMS XCache](https://hub.docker.com/r/opensciencegrid/cms-xcache/)
-   [Hosted CE](https://hub.docker.com/r/opensciencegrid/hosted-ce/)
-   [Stash Cache](https://hub.docker.com/r/opensciencegrid/stash-cache/)

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

-   [blahp-1.18.48-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.48-2.osg35.el7)
-   [glideinwms-3.6.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6.5-1.osg35.el7)

#### Enterprise Linux 8

-   None

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-1.18.48-2.osg35.el7
blahp-debuginfo-1.18.48-2.osg35.el7
glideinwms-3.6.5-1.osg35.el7
glideinwms-common-tools-3.6.5-1.osg35.el7
glideinwms-condor-common-config-3.6.5-1.osg35.el7
glideinwms-factory-3.6.5-1.osg35.el7
glideinwms-factory-condor-3.6.5-1.osg35.el7
glideinwms-glidecondor-tools-3.6.5-1.osg35.el7
glideinwms-libs-3.6.5-1.osg35.el7
glideinwms-minimal-condor-3.6.5-1.osg35.el7
glideinwms-usercollector-3.6.5-1.osg35.el7
glideinwms-userschedd-3.6.5-1.osg35.el7
glideinwms-vofrontend-3.6.5-1.osg35.el7
glideinwms-vofrontend-standalone-3.6.5-1.osg35.el7
```

#### Enterprise Linux 8

``` file
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [blahp-1.18.48-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.48-2.osgup.el7)

#### Enterprise Linux 8

-   None

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-1.18.48-2.osgup.el7
blahp-debuginfo-1.18.48-2.osgup.el7
```

#### Enterprise Linux 8

``` file
```
