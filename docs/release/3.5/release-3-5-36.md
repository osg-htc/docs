OSG Software Release 3.5.36
===========================

**Release Date:** 2021-05-17  
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

-   [HTCondor 8.8.13](https://www-auth.cs.wisc.edu/lists/htcondor-world/2021/msg00003.shtml): Bug fix release
-   osg-scitokens-mapfile 3: Updated to support HTCondor-CE 5.1.0
-   osg-ce: now requires osg-scitokens-mapfile
-   vault 1.7.1: Update to latest upstream release
-   htvault-config 1.1: Uses yaml configuration files
-   htgettoken 1.2: improved error message handling and bug fixes
-   Upcoming: [GlideinWMS 3.7.3](https://glideinwms.fnal.gov/doc.v3_7_3/history.html#development)

!!! bug "Known Issue"
    - GlideinWMS 3.7.3: submissions from 3.6.5 frontends to 3.7.3 factory go on hold
    - HTCondor-CE 5.1.0: batch system max walltime requests are always set to 3 days.
      Details and workaround can be found in the
      [upstream bug tracker](https://opensciencegrid.atlassian.net/browse/HTCONDOR-506).

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.36%2C3.5.36-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [blahp-1.18.48-2.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.48-2.2.osg35.el7)
-   [condor-8.8.13-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.13-1.osg35.el7)
-   [htgettoken-1.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.2-1.osg35.el7)
-   [htvault-config-1.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.1-1.osg35.el7)
-   [osg-ce-3.5-7.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.5-7.osg35.el7)
-   [osg-scitokens-mapfile-3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-scitokens-mapfile-3-1.osg35.el7)
-   [vault-1.7.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.7.1-1.osg35.el7)

#### Enterprise Linux 8

-   [blahp-1.18.48-2.2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.48-2.2.osg35.el8)
-   [condor-8.8.13-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.13-1.osg35.el8)
-   [htgettoken-1.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.2-1.osg35.el8)
-   [htvault-config-1.1-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.1-1.osg35.el8)
-   [osg-ce-3.5-7.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.5-7.osg35.el8)
-   [osg-scitokens-mapfile-3-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-scitokens-mapfile-3-1.osg35.el8)
-   [vault-1.7.1-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.7.1-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp htgettoken htvault-config minicondor osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-scitokens-mapfile python2-condor python3-condor vault 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-1.18.48-2.2.osg35.el7
blahp-debuginfo-1.18.48-2.2.osg35.el7
condor-8.8.13-1.osg35.el7
condor-all-8.8.13-1.osg35.el7
condor-annex-ec2-8.8.13-1.osg35.el7
condor-bosco-8.8.13-1.osg35.el7
condor-classads-8.8.13-1.osg35.el7
condor-classads-devel-8.8.13-1.osg35.el7
condor-debuginfo-8.8.13-1.osg35.el7
condor-kbdd-8.8.13-1.osg35.el7
condor-procd-8.8.13-1.osg35.el7
condor-test-8.8.13-1.osg35.el7
condor-vm-gahp-8.8.13-1.osg35.el7
htgettoken-1.2-1.osg35.el7
htvault-config-1.1-1.osg35.el7
minicondor-8.8.13-1.osg35.el7
osg-ce-3.5-7.osg35.el7
osg-ce-bosco-3.5-7.osg35.el7
osg-ce-condor-3.5-7.osg35.el7
osg-ce-lsf-3.5-7.osg35.el7
osg-ce-pbs-3.5-7.osg35.el7
osg-ce-sge-3.5-7.osg35.el7
osg-ce-slurm-3.5-7.osg35.el7
osg-scitokens-mapfile-3-1.osg35.el7
python2-condor-8.8.13-1.osg35.el7
python3-condor-8.8.13-1.osg35.el7
vault-1.7.1-1.osg35.el7
```

#### Enterprise Linux 8

``` file
blahp-1.18.48-2.2.osg35.el8
blahp-debuginfo-1.18.48-2.2.osg35.el8
blahp-debugsource-1.18.48-2.2.osg35.el8
condor-8.8.13-1.osg35.el8
condor-all-8.8.13-1.osg35.el8
condor-annex-ec2-8.8.13-1.osg35.el8
condor-bosco-8.8.13-1.osg35.el8
condor-bosco-debuginfo-8.8.13-1.osg35.el8
condor-classads-8.8.13-1.osg35.el8
condor-classads-debuginfo-8.8.13-1.osg35.el8
condor-classads-devel-8.8.13-1.osg35.el8
condor-classads-devel-debuginfo-8.8.13-1.osg35.el8
condor-debuginfo-8.8.13-1.osg35.el8
condor-debugsource-8.8.13-1.osg35.el8
condor-kbdd-8.8.13-1.osg35.el8
condor-kbdd-debuginfo-8.8.13-1.osg35.el8
condor-procd-8.8.13-1.osg35.el8
condor-procd-debuginfo-8.8.13-1.osg35.el8
condor-test-8.8.13-1.osg35.el8
condor-test-debuginfo-8.8.13-1.osg35.el8
condor-vm-gahp-8.8.13-1.osg35.el8
condor-vm-gahp-debuginfo-8.8.13-1.osg35.el8
htgettoken-1.2-1.osg35.el8
htvault-config-1.1-1.osg35.el8
minicondor-8.8.13-1.osg35.el8
osg-ce-3.5-7.osg35.el8
osg-ce-bosco-3.5-7.osg35.el8
osg-ce-condor-3.5-7.osg35.el8
osg-ce-lsf-3.5-7.osg35.el8
osg-ce-pbs-3.5-7.osg35.el8
osg-ce-sge-3.5-7.osg35.el8
osg-ce-slurm-3.5-7.osg35.el8
osg-scitokens-mapfile-3-1.osg35.el8
python3-condor-8.8.13-1.osg35.el8
python3-condor-debuginfo-8.8.13-1.osg35.el8
vault-1.7.1-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [blahp-2.0.2-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-2.0.2-1.osg35up.el7)
-   [condor-9.0.0-1.5.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.0-1.5.osg35up.el7)
-   [glideinwms-3.7.3-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.7.3-1.osg35up.el7)
-   [htcondor-ce-5.1.0-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-5.1.0-1.osg35up.el7)

#### Enterprise Linux 7

-   [blahp-2.0.2-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-2.0.2-1.osg35up.el8)
-   [condor-9.0.0-1.5.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.0-1.5.osg35up.el8)
-   [htcondor-ce-5.1.0-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htcondor-ce-5.1.0-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-factory-core glideinwms-factory-httpd glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-core glideinwms-vofrontend-httpd glideinwms-vofrontend-standalone htcondor-ce htcondor-ce-bosco htcondor-ce-client htcondor-ce-collector htcondor-ce-condor htcondor-ce-lsf htcondor-ce-pbs htcondor-ce-sge htcondor-ce-slurm htcondor-ce-view minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-2.0.2-1.osg35up.el7
blahp-debuginfo-2.0.2-1.osg35up.el7
condor-9.0.0-1.5.osg35up.el7
condor-all-9.0.0-1.5.osg35up.el7
condor-annex-ec2-9.0.0-1.5.osg35up.el7
condor-bosco-9.0.0-1.5.osg35up.el7
condor-classads-9.0.0-1.5.osg35up.el7
condor-classads-devel-9.0.0-1.5.osg35up.el7
condor-credmon-oauth-9.0.0-1.5.osg35up.el7
condor-credmon-vault-9.0.0-1.5.osg35up.el7
condor-debuginfo-9.0.0-1.5.osg35up.el7
condor-devel-9.0.0-1.5.osg35up.el7
condor-kbdd-9.0.0-1.5.osg35up.el7
condor-procd-9.0.0-1.5.osg35up.el7
condor-test-9.0.0-1.5.osg35up.el7
condor-vm-gahp-9.0.0-1.5.osg35up.el7
glideinwms-3.7.3-1.osg35up.el7
glideinwms-common-tools-3.7.3-1.osg35up.el7
glideinwms-condor-common-config-3.7.3-1.osg35up.el7
glideinwms-factory-3.7.3-1.osg35up.el7
glideinwms-factory-condor-3.7.3-1.osg35up.el7
glideinwms-factory-core-3.7.3-1.osg35up.el7
glideinwms-factory-httpd-3.7.3-1.osg35up.el7
glideinwms-glidecondor-tools-3.7.3-1.osg35up.el7
glideinwms-libs-3.7.3-1.osg35up.el7
glideinwms-minimal-condor-3.7.3-1.osg35up.el7
glideinwms-usercollector-3.7.3-1.osg35up.el7
glideinwms-userschedd-3.7.3-1.osg35up.el7
glideinwms-vofrontend-3.7.3-1.osg35up.el7
glideinwms-vofrontend-core-3.7.3-1.osg35up.el7
glideinwms-vofrontend-httpd-3.7.3-1.osg35up.el7
glideinwms-vofrontend-standalone-3.7.3-1.osg35up.el7
htcondor-ce-5.1.0-1.osg35up.el7
htcondor-ce-bosco-5.1.0-1.osg35up.el7
htcondor-ce-client-5.1.0-1.osg35up.el7
htcondor-ce-collector-5.1.0-1.osg35up.el7
htcondor-ce-condor-5.1.0-1.osg35up.el7
htcondor-ce-lsf-5.1.0-1.osg35up.el7
htcondor-ce-pbs-5.1.0-1.osg35up.el7
htcondor-ce-sge-5.1.0-1.osg35up.el7
htcondor-ce-slurm-5.1.0-1.osg35up.el7
htcondor-ce-view-5.1.0-1.osg35up.el7
minicondor-9.0.0-1.5.osg35up.el7
python2-condor-9.0.0-1.5.osg35up.el7
python3-condor-9.0.0-1.5.osg35up.el7
```

#### Enterprise Linux 7

``` file
blahp-2.0.2-1.osg35up.el8
blahp-debuginfo-2.0.2-1.osg35up.el8
blahp-debugsource-2.0.2-1.osg35up.el8
condor-9.0.0-1.5.osg35up.el8
condor-all-9.0.0-1.5.osg35up.el8
condor-annex-ec2-9.0.0-1.5.osg35up.el8
condor-bosco-9.0.0-1.5.osg35up.el8
condor-bosco-debuginfo-9.0.0-1.5.osg35up.el8
condor-classads-9.0.0-1.5.osg35up.el8
condor-classads-debuginfo-9.0.0-1.5.osg35up.el8
condor-classads-devel-9.0.0-1.5.osg35up.el8
condor-classads-devel-debuginfo-9.0.0-1.5.osg35up.el8
condor-credmon-vault-9.0.0-1.5.osg35up.el8
condor-debuginfo-9.0.0-1.5.osg35up.el8
condor-debugsource-9.0.0-1.5.osg35up.el8
condor-devel-9.0.0-1.5.osg35up.el8
condor-kbdd-9.0.0-1.5.osg35up.el8
condor-kbdd-debuginfo-9.0.0-1.5.osg35up.el8
condor-procd-9.0.0-1.5.osg35up.el8
condor-procd-debuginfo-9.0.0-1.5.osg35up.el8
condor-test-9.0.0-1.5.osg35up.el8
condor-test-debuginfo-9.0.0-1.5.osg35up.el8
condor-vm-gahp-9.0.0-1.5.osg35up.el8
condor-vm-gahp-debuginfo-9.0.0-1.5.osg35up.el8
htcondor-ce-5.1.0-1.osg35up.el8
htcondor-ce-bosco-5.1.0-1.osg35up.el8
htcondor-ce-client-5.1.0-1.osg35up.el8
htcondor-ce-collector-5.1.0-1.osg35up.el8
htcondor-ce-condor-5.1.0-1.osg35up.el8
htcondor-ce-lsf-5.1.0-1.osg35up.el8
htcondor-ce-pbs-5.1.0-1.osg35up.el8
htcondor-ce-sge-5.1.0-1.osg35up.el8
htcondor-ce-slurm-5.1.0-1.osg35up.el8
htcondor-ce-view-5.1.0-1.osg35up.el8
minicondor-9.0.0-1.5.osg35up.el8
python3-condor-9.0.0-1.5.osg35up.el8
python3-condor-debuginfo-9.0.0-1.5.osg35up.el8
```
