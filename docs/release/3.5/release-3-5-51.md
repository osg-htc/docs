OSG Software Release 3.5.51
===========================

**Release Date:** 2021-12-01  
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

-   [VO Package v115](https://github.com/opensciencegrid/osg-vo-config/releases/tag/release-115)
    -   Add CMS IAM vomses entry
    -   Update WLCG VO certificate
-   vault 1.8.4, htvault-config 1.10, htgettoken 1.8
    -   htgettoken package includes a tool called httokendecode to decode JWTs
    -   other minor improvements
-   [python-scitokens 1.6.2](https://github.com/scitokens/scitokens/releases/tag/v1.6.0)
    -   Ensure compatibility with older versions of PyJWT
    -   Add multiple aud in token support
-   Upcoming
    -   [HTCondor 9.0.7 LTS](https://htcondor.org/news/HTCondor_9.0.7_released/): Bug fix release
        -   Fix bug where condor_gpu_discovery could crash with older CUDA libraries
        -   Fix bug where condor_watch_q would fail on machines with older kernels
        -   condor_watch_q no longer has a limit on the number of job event log files
        -   Fix bug where a startd could crash claiming a slot with p-slot preemption
        -   Fix bug where a job start would not be recorded when a shadow reconnects

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.51%2C3.5.51-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [htgettoken-1.8-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.8-1.osg35.el7)
-   [htvault-config-1.10-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.10-1.osg35.el7)
-   [python-scitokens-1.6.2-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.6.2-2.osg35.el7)
-   [vault-1.8.4-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.8.4-1.osg35.el7)
-   [vo-client-115-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-115-1.osg35.el7)

#### Enterprise Linux 8

-   [htgettoken-1.8-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htgettoken-1.8-1.osg35.el8)
-   [htvault-config-1.10-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.10-1.osg35.el8)
-   [python-scitokens-1.6.2-2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.6.2-2.osg35.el8)
-   [vault-1.8.4-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.8.4-1.osg35.el8)
-   [vo-client-115-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-115-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    htgettoken htvault-config python36-scitokens python-scitokens vault vo-client vo-client-dcache vo-client-lcmaps-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
htgettoken-1.8-1.osg35.el7
htvault-config-1.10-1.osg35.el7
python36-scitokens-1.6.2-2.osg35.el7
python-scitokens-1.6.2-2.osg35.el7
vault-1.8.4-1.osg35.el7
vo-client-115-1.osg35.el7
vo-client-dcache-115-1.osg35.el7
vo-client-lcmaps-voms-115-1.osg35.el7
```

#### Enterprise Linux 8

``` file
htgettoken-1.8-1.osg35.el8
htvault-config-1.10-1.osg35.el8
python3-scitokens-1.6.2-2.osg35.el8
python-scitokens-1.6.2-2.osg35.el8
vault-1.8.4-1.osg35.el8
vo-client-115-1.osg35.el8
vo-client-dcache-115-1.osg35.el8
vo-client-lcmaps-voms-115-1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-9.0.7-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.7-1.1.osg35up.el7)

#### Enterprise Linux 8

-   [condor-9.0.7-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.7-1.1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-9.0.7-1.1.osg35up.el7
condor-all-9.0.7-1.1.osg35up.el7
condor-annex-ec2-9.0.7-1.1.osg35up.el7
condor-bosco-9.0.7-1.1.osg35up.el7
condor-classads-9.0.7-1.1.osg35up.el7
condor-classads-devel-9.0.7-1.1.osg35up.el7
condor-credmon-oauth-9.0.7-1.1.osg35up.el7
condor-credmon-vault-9.0.7-1.1.osg35up.el7
condor-debuginfo-9.0.7-1.1.osg35up.el7
condor-devel-9.0.7-1.1.osg35up.el7
condor-kbdd-9.0.7-1.1.osg35up.el7
condor-procd-9.0.7-1.1.osg35up.el7
condor-test-9.0.7-1.1.osg35up.el7
condor-vm-gahp-9.0.7-1.1.osg35up.el7
minicondor-9.0.7-1.1.osg35up.el7
python2-condor-9.0.7-1.1.osg35up.el7
python3-condor-9.0.7-1.1.osg35up.el7
```

#### Enterprise Linux 8

``` file
condor-9.0.7-1.1.osg35up.el8
condor-all-9.0.7-1.1.osg35up.el8
condor-annex-ec2-9.0.7-1.1.osg35up.el8
condor-bosco-9.0.7-1.1.osg35up.el8
condor-bosco-debuginfo-9.0.7-1.1.osg35up.el8
condor-classads-9.0.7-1.1.osg35up.el8
condor-classads-debuginfo-9.0.7-1.1.osg35up.el8
condor-classads-devel-9.0.7-1.1.osg35up.el8
condor-classads-devel-debuginfo-9.0.7-1.1.osg35up.el8
condor-credmon-vault-9.0.7-1.1.osg35up.el8
condor-debuginfo-9.0.7-1.1.osg35up.el8
condor-debugsource-9.0.7-1.1.osg35up.el8
condor-devel-9.0.7-1.1.osg35up.el8
condor-kbdd-9.0.7-1.1.osg35up.el8
condor-kbdd-debuginfo-9.0.7-1.1.osg35up.el8
condor-procd-9.0.7-1.1.osg35up.el8
condor-procd-debuginfo-9.0.7-1.1.osg35up.el8
condor-test-9.0.7-1.1.osg35up.el8
condor-test-debuginfo-9.0.7-1.1.osg35up.el8
condor-vm-gahp-9.0.7-1.1.osg35up.el8
condor-vm-gahp-debuginfo-9.0.7-1.1.osg35up.el8
minicondor-9.0.7-1.1.osg35up.el8
python3-condor-9.0.7-1.1.osg35up.el8
python3-condor-debuginfo-9.0.7-1.1.osg35up.el8
```
