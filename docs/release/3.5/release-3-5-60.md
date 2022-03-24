OSG Software Release 3.5.60
===========================

**Release Date:** 2022-03-24  
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

-   [python-scitokens 1.7.0](https://github.com/scitokens/scitokens/releases/tag/v1.7.0)
-   osg-token-renewer 0.8.1: Add support for manual client registration
-   [HTCondor 8.8.17](https://htcondor.readthedocs.io/en/v8_8/version-history/stable-release-series-88.html#version-8-8-17): Fix memory leak in the Job Router
-   Upcoming
    -   [HTCondor 9.0.11](https://htcondor.readthedocs.io/en/v9_0/version-history/stable-release-series-90.html#version-9-0-11)
        -   The Job Router can now create an IDTOKEN for use by the job
        -   Fix bug where a self-checkpointing job may erroneously be held
        -   Fix bug where the Job Router erroneously substitutes a default value
        -   Fix bug where a file transfer error may identify the wrong file
        -   Fix bug where condor_ssh_to_job may fail to connect
    -   [XRootD 5.4.2](https://github.com/xrootd/xrootd/blob/v5.4.2/docs/ReleaseNotes.txt): Bug fix release
    -   [GlideinWMS 3.7.6](https://glideinwms.fnal.gov/doc.v3_7_6/history.html#development)
        -   Add flexible mount points for CVMFS in the Glideins (not always /cvmfs)
        -   Per-Entry IDTOKENS
        -   Support per-group SciTokens
        -   Frontend and Factory check the expiration of SciTokens, other JWT tokens
        -   Bug Fixes:
            -   IDTOKEN issuer changed from collector host to trust domain
            -   X.509 proxy is now renewed also when using also tokens 
        -   Shared port is now the default in the User (VO) Collector HTCondor


These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.60%2C3.5.60-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The [OSG Docker images](https://hub.docker.com/u/opensciencegrid/) have been updated to contain the new software.

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

-   [condor-8.8.17-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.17-1.1.osg35.el7)
-   [osg-token-renewer-0.8.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-token-renewer-0.8.1-1.osg35.el7)
-   [python-scitokens-1.7.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.7.0-1.osg35.el7)

#### Enterprise Linux 8

-   [condor-8.8.17-1.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.17-1.1.osg35.el8)
-   [osg-token-renewer-0.8.1-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-token-renewer-0.8.1-1.osg35.el8)
-   [python-scitokens-1.7.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.7.0-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor osg-token-renewer python2-condor python36-scitokens python3-condor python-scitokens 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-8.8.17-1.1.osg35.el7
condor-all-8.8.17-1.1.osg35.el7
condor-annex-ec2-8.8.17-1.1.osg35.el7
condor-bosco-8.8.17-1.1.osg35.el7
condor-classads-8.8.17-1.1.osg35.el7
condor-classads-devel-8.8.17-1.1.osg35.el7
condor-debuginfo-8.8.17-1.1.osg35.el7
condor-kbdd-8.8.17-1.1.osg35.el7
condor-procd-8.8.17-1.1.osg35.el7
condor-test-8.8.17-1.1.osg35.el7
condor-vm-gahp-8.8.17-1.1.osg35.el7
minicondor-8.8.17-1.1.osg35.el7
osg-token-renewer-0.8.1-1.osg35.el7
python2-condor-8.8.17-1.1.osg35.el7
python36-scitokens-1.7.0-1.osg35.el7
python3-condor-8.8.17-1.1.osg35.el7
python-scitokens-1.7.0-1.osg35.el7
```

#### Enterprise Linux 8

``` file
condor-8.8.17-1.1.osg35.el8
condor-all-8.8.17-1.1.osg35.el8
condor-annex-ec2-8.8.17-1.1.osg35.el8
condor-bosco-8.8.17-1.1.osg35.el8
condor-bosco-debuginfo-8.8.17-1.1.osg35.el8
condor-classads-8.8.17-1.1.osg35.el8
condor-classads-debuginfo-8.8.17-1.1.osg35.el8
condor-classads-devel-8.8.17-1.1.osg35.el8
condor-classads-devel-debuginfo-8.8.17-1.1.osg35.el8
condor-debuginfo-8.8.17-1.1.osg35.el8
condor-debugsource-8.8.17-1.1.osg35.el8
condor-kbdd-8.8.17-1.1.osg35.el8
condor-kbdd-debuginfo-8.8.17-1.1.osg35.el8
condor-procd-8.8.17-1.1.osg35.el8
condor-procd-debuginfo-8.8.17-1.1.osg35.el8
condor-test-8.8.17-1.1.osg35.el8
condor-test-debuginfo-8.8.17-1.1.osg35.el8
condor-vm-gahp-8.8.17-1.1.osg35.el8
condor-vm-gahp-debuginfo-8.8.17-1.1.osg35.el8
minicondor-8.8.17-1.1.osg35.el8
osg-token-renewer-0.8.1-1.osg35.el8
python3-condor-8.8.17-1.1.osg35.el8
python3-condor-debuginfo-8.8.17-1.1.osg35.el8
python3-scitokens-1.7.0-1.osg35.el8
python-scitokens-1.7.0-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-9.0.11-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.11-1.1.osg35up.el7)
-   [glideinwms-3.7.6-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.7.6-1.osg35up.el7)
-   [xrootd-5.4.2-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.4.2-1.osg35up.el7)

#### Enterprise Linux 8

-   [condor-9.0.11-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.11-1.1.osg35up.el8)
-   [xrootd-5.4.2-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.4.2-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp glideinwms glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-factory-core glideinwms-factory-httpd glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-core glideinwms-vofrontend-httpd glideinwms-vofrontend-standalone minicondor python2-condor python2-xrootd python36-xrootd python3-condor xrootd xrootd-client xrootd-client-compat xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-scitokens xrootd-selinux xrootd-server xrootd-server-compat xrootd-server-devel xrootd-server-libs xrootd-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-9.0.11-1.1.osg35up.el7
condor-all-9.0.11-1.1.osg35up.el7
condor-annex-ec2-9.0.11-1.1.osg35up.el7
condor-bosco-9.0.11-1.1.osg35up.el7
condor-classads-9.0.11-1.1.osg35up.el7
condor-classads-devel-9.0.11-1.1.osg35up.el7
condor-credmon-oauth-9.0.11-1.1.osg35up.el7
condor-credmon-vault-9.0.11-1.1.osg35up.el7
condor-debuginfo-9.0.11-1.1.osg35up.el7
condor-devel-9.0.11-1.1.osg35up.el7
condor-kbdd-9.0.11-1.1.osg35up.el7
condor-procd-9.0.11-1.1.osg35up.el7
condor-test-9.0.11-1.1.osg35up.el7
condor-vm-gahp-9.0.11-1.1.osg35up.el7
glideinwms-3.7.6-1.osg35up.el7
glideinwms-common-tools-3.7.6-1.osg35up.el7
glideinwms-condor-common-config-3.7.6-1.osg35up.el7
glideinwms-factory-3.7.6-1.osg35up.el7
glideinwms-factory-condor-3.7.6-1.osg35up.el7
glideinwms-factory-core-3.7.6-1.osg35up.el7
glideinwms-factory-httpd-3.7.6-1.osg35up.el7
glideinwms-glidecondor-tools-3.7.6-1.osg35up.el7
glideinwms-libs-3.7.6-1.osg35up.el7
glideinwms-minimal-condor-3.7.6-1.osg35up.el7
glideinwms-usercollector-3.7.6-1.osg35up.el7
glideinwms-userschedd-3.7.6-1.osg35up.el7
glideinwms-vofrontend-3.7.6-1.osg35up.el7
glideinwms-vofrontend-core-3.7.6-1.osg35up.el7
glideinwms-vofrontend-httpd-3.7.6-1.osg35up.el7
glideinwms-vofrontend-standalone-3.7.6-1.osg35up.el7
minicondor-9.0.11-1.1.osg35up.el7
python2-condor-9.0.11-1.1.osg35up.el7
python2-xrootd-5.4.2-1.osg35up.el7
python36-xrootd-5.4.2-1.osg35up.el7
python3-condor-9.0.11-1.1.osg35up.el7
xrootd-5.4.2-1.osg35up.el7
xrootd-client-5.4.2-1.osg35up.el7
xrootd-client-compat-5.4.2-1.osg35up.el7
xrootd-client-devel-5.4.2-1.osg35up.el7
xrootd-client-libs-5.4.2-1.osg35up.el7
xrootd-debuginfo-5.4.2-1.osg35up.el7
xrootd-devel-5.4.2-1.osg35up.el7
xrootd-doc-5.4.2-1.osg35up.el7
xrootd-fuse-5.4.2-1.osg35up.el7
xrootd-libs-5.4.2-1.osg35up.el7
xrootd-private-devel-5.4.2-1.osg35up.el7
xrootd-scitokens-5.4.2-1.osg35up.el7
xrootd-selinux-5.4.2-1.osg35up.el7
xrootd-server-5.4.2-1.osg35up.el7
xrootd-server-compat-5.4.2-1.osg35up.el7
xrootd-server-devel-5.4.2-1.osg35up.el7
xrootd-server-libs-5.4.2-1.osg35up.el7
xrootd-voms-5.4.2-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
condor-9.0.11-1.1.osg35up.el8
condor-all-9.0.11-1.1.osg35up.el8
condor-annex-ec2-9.0.11-1.1.osg35up.el8
condor-bosco-9.0.11-1.1.osg35up.el8
condor-bosco-debuginfo-9.0.11-1.1.osg35up.el8
condor-classads-9.0.11-1.1.osg35up.el8
condor-classads-debuginfo-9.0.11-1.1.osg35up.el8
condor-classads-devel-9.0.11-1.1.osg35up.el8
condor-classads-devel-debuginfo-9.0.11-1.1.osg35up.el8
condor-credmon-oauth-9.0.11-1.1.osg35up.el8
condor-credmon-vault-9.0.11-1.1.osg35up.el8
condor-debuginfo-9.0.11-1.1.osg35up.el8
condor-debugsource-9.0.11-1.1.osg35up.el8
condor-devel-9.0.11-1.1.osg35up.el8
condor-kbdd-9.0.11-1.1.osg35up.el8
condor-kbdd-debuginfo-9.0.11-1.1.osg35up.el8
condor-procd-9.0.11-1.1.osg35up.el8
condor-procd-debuginfo-9.0.11-1.1.osg35up.el8
condor-test-9.0.11-1.1.osg35up.el8
condor-test-debuginfo-9.0.11-1.1.osg35up.el8
condor-vm-gahp-9.0.11-1.1.osg35up.el8
condor-vm-gahp-debuginfo-9.0.11-1.1.osg35up.el8
minicondor-9.0.11-1.1.osg35up.el8
python3-condor-9.0.11-1.1.osg35up.el8
python3-condor-debuginfo-9.0.11-1.1.osg35up.el8
python3-xrootd-5.4.2-1.osg35up.el8
python3-xrootd-debuginfo-5.4.2-1.osg35up.el8
xrootd-5.4.2-1.osg35up.el8
xrootd-client-5.4.2-1.osg35up.el8
xrootd-client-compat-5.4.2-1.osg35up.el8
xrootd-client-compat-debuginfo-5.4.2-1.osg35up.el8
xrootd-client-debuginfo-5.4.2-1.osg35up.el8
xrootd-client-devel-5.4.2-1.osg35up.el8
xrootd-client-devel-debuginfo-5.4.2-1.osg35up.el8
xrootd-client-libs-5.4.2-1.osg35up.el8
xrootd-client-libs-debuginfo-5.4.2-1.osg35up.el8
xrootd-debuginfo-5.4.2-1.osg35up.el8
xrootd-debugsource-5.4.2-1.osg35up.el8
xrootd-devel-5.4.2-1.osg35up.el8
xrootd-doc-5.4.2-1.osg35up.el8
xrootd-fuse-5.4.2-1.osg35up.el8
xrootd-fuse-debuginfo-5.4.2-1.osg35up.el8
xrootd-libs-5.4.2-1.osg35up.el8
xrootd-libs-debuginfo-5.4.2-1.osg35up.el8
xrootd-private-devel-5.4.2-1.osg35up.el8
xrootd-scitokens-5.4.2-1.osg35up.el8
xrootd-scitokens-debuginfo-5.4.2-1.osg35up.el8
xrootd-selinux-5.4.2-1.osg35up.el8
xrootd-server-5.4.2-1.osg35up.el8
xrootd-server-compat-5.4.2-1.osg35up.el8
xrootd-server-compat-debuginfo-5.4.2-1.osg35up.el8
xrootd-server-debuginfo-5.4.2-1.osg35up.el8
xrootd-server-devel-5.4.2-1.osg35up.el8
xrootd-server-libs-5.4.2-1.osg35up.el8
xrootd-server-libs-debuginfo-5.4.2-1.osg35up.el8
xrootd-voms-5.4.2-1.osg35up.el8
xrootd-voms-debuginfo-5.4.2-1.osg35up.el8
```
