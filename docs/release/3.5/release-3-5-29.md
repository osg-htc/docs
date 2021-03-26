OSG Software Release 3.5.29
===========================

**Release Date:** 2021-01-21    
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

-   Updated CA certificates based on [IGTF 1.109](http://dist.eugridpma.info/distribution/igtf/current/CHANGES):
    -   Removed discontinued DM private IGTF classic CAs (AE)
    -   Removed obsolete QuoVadis-Root-CA1, under which no ICAs are left (BM)
    -   Updated QV Grid ICA G2 intermediary following its re-issuance (BM)
-   [osg-configure 3.11.0](https://github.com/opensciencegrid/osg-configure/releases/tag/v3.11.0)
    -   Added Pilot sections for sites to request different types of pilots from the factory
    -   Make fetch-crl success optional (though give a warning on failure)
    -   Don't try to resolve the Squid server, since it only needs to be visible from the workers, not the CE
-   [htgettoken 1.1](https://github.com/fermitools/htgettoken/releases/tag/v1.1): Additional options to integrate with HTCondor
-   Upcoming: [GlideinWMS 3.7.2](https://glideinwms.fnal.gov/doc.v3_7_2/history.html#development) (EL7 Only)
    -   Can now run custom script at the end of glidein execution
    -   Prevent failures when CE disappears from OSG Collector
    -   Bug fix: Frontend no longer over-generates tokens for entries
    -   Bug fix: Factory does not remove glideins when idle limit is hit

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.29%2C%203.5.29-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.


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

-   [htgettoken-1.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.1-1.osg35.el7)
-   [igtf-ca-certs-1.109-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.109-1.osg35.el7)
-   [osg-ca-certs-1.92-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.92-1.osg35.el7)
-   [osg-configure-3.11.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-3.11.0-1.osg35.el7)

#### Enterprise Linux 8

-   [htgettoken-1.1-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.1-1.osg35.el8)
-   [igtf-ca-certs-1.109-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.109-1.osg35.el8)
-   [osg-ca-certs-1.92-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.92-1.osg35.el8)
-   [osg-configure-3.11.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-configure-3.11.0-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    htgettoken igtf-ca-certs osg-ca-certs osg-configure osg-configure-bosco osg-configure-ce osg-configure-condor osg-configure-gateway osg-configure-gip osg-configure-gratia osg-configure-infoservices osg-configure-lsf osg-configure-misc osg-configure-pbs osg-configure-rsv osg-configure-sge osg-configure-siteinfo osg-configure-slurm osg-configure-squid osg-configure-tests 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
htgettoken-1.1-1.osg35.el7
igtf-ca-certs-1.109-1.osg35.el7
osg-ca-certs-1.92-1.osg35.el7
osg-configure-3.11.0-1.osg35.el7
osg-configure-bosco-3.11.0-1.osg35.el7
osg-configure-ce-3.11.0-1.osg35.el7
osg-configure-condor-3.11.0-1.osg35.el7
osg-configure-gateway-3.11.0-1.osg35.el7
osg-configure-gip-3.11.0-1.osg35.el7
osg-configure-gratia-3.11.0-1.osg35.el7
osg-configure-infoservices-3.11.0-1.osg35.el7
osg-configure-lsf-3.11.0-1.osg35.el7
osg-configure-misc-3.11.0-1.osg35.el7
osg-configure-pbs-3.11.0-1.osg35.el7
osg-configure-rsv-3.11.0-1.osg35.el7
osg-configure-sge-3.11.0-1.osg35.el7
osg-configure-siteinfo-3.11.0-1.osg35.el7
osg-configure-slurm-3.11.0-1.osg35.el7
osg-configure-squid-3.11.0-1.osg35.el7
osg-configure-tests-3.11.0-1.osg35.el7
```

#### Enterprise Linux 8

``` file
htgettoken-1.1-1.osg35.el8
igtf-ca-certs-1.109-1.osg35.el8
osg-ca-certs-1.92-1.osg35.el8
osg-configure-3.11.0-1.osg35.el8
osg-configure-bosco-3.11.0-1.osg35.el8
osg-configure-ce-3.11.0-1.osg35.el8
osg-configure-condor-3.11.0-1.osg35.el8
osg-configure-gateway-3.11.0-1.osg35.el8
osg-configure-gip-3.11.0-1.osg35.el8
osg-configure-gratia-3.11.0-1.osg35.el8
osg-configure-infoservices-3.11.0-1.osg35.el8
osg-configure-lsf-3.11.0-1.osg35.el8
osg-configure-misc-3.11.0-1.osg35.el8
osg-configure-pbs-3.11.0-1.osg35.el8
osg-configure-rsv-3.11.0-1.osg35.el8
osg-configure-sge-3.11.0-1.osg35.el8
osg-configure-siteinfo-3.11.0-1.osg35.el8
osg-configure-slurm-3.11.0-1.osg35.el8
osg-configure-squid-3.11.0-1.osg35.el8
osg-configure-tests-3.11.0-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [glideinwms-3.7.2-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.7.2-1.osgup.el7)

#### Enterprise Linux 8

-   None

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
glideinwms-3.7.2-1.osgup.el7
glideinwms-common-tools-3.7.2-1.osgup.el7
glideinwms-condor-common-config-3.7.2-1.osgup.el7
glideinwms-factory-3.7.2-1.osgup.el7
glideinwms-factory-condor-3.7.2-1.osgup.el7
glideinwms-glidecondor-tools-3.7.2-1.osgup.el7
glideinwms-libs-3.7.2-1.osgup.el7
glideinwms-minimal-condor-3.7.2-1.osgup.el7
glideinwms-usercollector-3.7.2-1.osgup.el7
glideinwms-userschedd-3.7.2-1.osgup.el7
glideinwms-vofrontend-3.7.2-1.osgup.el7
glideinwms-vofrontend-standalone-3.7.2-1.osgup.el7
```

#### Enterprise Linux 8

``` file
```
