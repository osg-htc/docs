OSG Software Release 3.5.13
===========================

**Release Date:** 2020-04-02    
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

-   [GlideinWMS 3.6.2](https://glideinwms.fnal.gov/doc.v3_6_2/history.html)
    -   Add a portable condor\_chirp for user jobs running in the glideins
    -   Adding GPU monitor as default for pilots
    -   Reduce number of queries from Frontend to User collector
    -   Bug fix: Incorrect CERTIFICATE\_MAPFILE used when using HTCondor python binding (failed schedd authentication)
    -   Bug fix: Broken submission to GCE and AWS
-   Updated CA certificates based on [IGTF 1.105](http://dist.eugridpma.info/distribution/igtf/current/CHANGES):
    -   Discontinued CERN-LCG-IOTA-CA following decommissioning by authority (CERN)
    -   Added new G4 intermediates for the GEANT TCS service and supporting self-signed USERTrust RSA Root (EU)
    -   Updated AddTrust External CA Root signing policy to support legacy UTN chains for GEANT TCS G4 (EU)
-   [HTCondor-CE 4.2.1](https://github.com/htcondor/htcondor-ce/releases/tag/v4.2.1): Advertise to the central collector via SSL
-   [Pegasus 4.9.3](https://pegasus.isi.edu/2020/01/31/pegasus-4-9-3-released/): Update from 4.9.1
    -   Support for getting images from Singularity Library
    -   Updates from [Pegasus 4.9.2](https://pegasus.isi.edu/2019/08/07/pegasus-4-9-2-released/)
-   globus-gridftp-server-13.20-1.1: Fix transfer logging
-   LCMAPS 1.6.6-1.12: Use VOMS mappings by default
-   scitokens-cpp 0.5.0: Added API to retrieve string lists

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.13%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The `Hosted CE` container is available and has been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [Hosted CE](https://hub.docker.com/r/opensciencegrid/hosted-ce/)


The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.


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

-   [glideinwms-3.6.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.6.2-1.osg35.el7)
-   [globus-gridftp-server-13.20-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.20-1.1.osg35.el7)
-   [htcondor-ce-4.2.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-4.2.1-1.osg35.el7)
-   [igtf-ca-certs-1.105-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.105-1.osg35.el7)
-   [lcmaps-1.6.6-1.12.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=lcmaps-1.6.6-1.12.osg35.el7)
-   [osg-ca-certs-1.87-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ca-certs-1.87-1.osg35.el7)
-   [pegasus-4.9.3-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=pegasus-4.9.3-1.2.osg35.el7)
-   [scitokens-cpp-0.5.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.5.0-1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view igtf-ca-certs lcmaps lcmaps-common-devel lcmaps-db-templates lcmaps-debuginfo lcmaps-devel lcmaps-without-gsi lcmaps-without-gsi-devel osg-ca-certs pegasus pegasus-debuginfo scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
glideinwms-3.6.2-1.osg35.el7
glideinwms-common-tools-3.6.2-1.osg35.el7
glideinwms-condor-common-config-3.6.2-1.osg35.el7
glideinwms-factory-3.6.2-1.osg35.el7
glideinwms-factory-condor-3.6.2-1.osg35.el7
glideinwms-glidecondor-tools-3.6.2-1.osg35.el7
glideinwms-libs-3.6.2-1.osg35.el7
glideinwms-minimal-condor-3.6.2-1.osg35.el7
glideinwms-usercollector-3.6.2-1.osg35.el7
glideinwms-userschedd-3.6.2-1.osg35.el7
glideinwms-vofrontend-3.6.2-1.osg35.el7
glideinwms-vofrontend-standalone-3.6.2-1.osg35.el7
globus-gridftp-server-13.20-1.1.osg35.el7
globus-gridftp-server-debuginfo-13.20-1.1.osg35.el7
globus-gridftp-server-devel-13.20-1.1.osg35.el7
globus-gridftp-server-progs-13.20-1.1.osg35.el7
htcondor-ce-4.2.1-1.osg35.el7
htcondor-ce-bosco-4.2.1-1.osg35.el7
htcondor-ce-client-4.2.1-1.osg35.el7
htcondor-ce-collector-4.2.1-1.osg35.el7
htcondor-ce-condor-4.2.1-1.osg35.el7
htcondor-ce-lsf-4.2.1-1.osg35.el7
htcondor-ce-pbs-4.2.1-1.osg35.el7
htcondor-ce-sge-4.2.1-1.osg35.el7
htcondor-ce-slurm-4.2.1-1.osg35.el7
htcondor-ce-view-4.2.1-1.osg35.el7
igtf-ca-certs-1.105-1.osg35.el7
lcmaps-1.6.6-1.12.osg35.el7
lcmaps-common-devel-1.6.6-1.12.osg35.el7
lcmaps-db-templates-1.6.6-1.12.osg35.el7
lcmaps-debuginfo-1.6.6-1.12.osg35.el7
lcmaps-devel-1.6.6-1.12.osg35.el7
lcmaps-without-gsi-1.6.6-1.12.osg35.el7
lcmaps-without-gsi-devel-1.6.6-1.12.osg35.el7
osg-ca-certs-1.87-1.osg35.el7
pegasus-4.9.3-1.2.osg35.el7
pegasus-debuginfo-4.9.3-1.2.osg35.el7
scitokens-cpp-0.5.0-1.osg35.el7
scitokens-cpp-debuginfo-0.5.0-1.osg35.el7
scitokens-cpp-devel-0.5.0-1.osg35.el7
```
