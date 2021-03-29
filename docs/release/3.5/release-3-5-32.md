OSG Software Release 3.5.32
===========================

**Release Date:** 2021-03-25  
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

-   `HTCondor 8.9.11-1.1` (Upcoming, EL7 only)
    -   Fixes a potential SchedD crash when using malformed tokens
    -   `condor_watch_q` now works on DAGs
-   `blahp-1.18.48-2.4` a rebuild against HTCondor 8.9.11
-   `osg-release-3.5-6` including the OSG 3.6 RPM signing key to ease updates between release series
-   `vo-client-110-1` with updated WeNMR VOMS information
-   `osg-scitokens-mapfile-1-1` containing a new HTCondor-CE mapfile for VO token issuers
-   `vault-1.6.2-1` and `htvault-config-0.5-1` for managing tokens
-   `cvmfs-gateway-1.2.0-1`: note the
    [upstream documentation](https://cvmfs.readthedocs.io/en/latest/cpt-repository-gateway.html#updating-from-cvmfs-gateway-0-2-5)
    for updating from version 0.2.5


These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.32%2C3.5.32-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [cvmfs-gateway-1.2.0-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-gateway-1.2.0-1.osg35.el7)
-   [htvault-config-0.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-0.5-1.osg35.el7)
-   [osg-ce-3.5-6.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.5-6.osg35.el7)
-   [osg-release-3.5-7.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.5-7.osg35.el7)
-   [osg-scitokens-mapfile-1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-scitokens-mapfile-1-1.osg35.el7)
-   [vault-1.6.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.6.2-1.osg35.el7)
-   [vo-client-110-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-110-1.osg35.el7)

#### Enterprise Linux 8

-   [cvmfs-gateway-1.2.0-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-gateway-1.2.0-1.osg35.el8)
-   [htvault-config-0.5-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-0.5-1.osg35.el8)
-   [osg-ce-3.5-6.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-ce-3.5-6.osg35.el8)
-   [osg-release-3.5-7.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-release-3.5-7.osg35.el8)
-   [osg-scitokens-mapfile-1-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-scitokens-mapfile-1-1.osg35.el8)
-   [vault-1.6.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.6.2-1.osg35.el8)
-   [vo-client-110-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vo-client-110-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    cvmfs-gateway htvault-config osg-ce osg-ce-bosco osg-ce-condor osg-ce-lsf osg-ce-pbs osg-ce-sge osg-ce-slurm osg-release osg-scitokens-mapfile vault vo-client vo-client-dcache vo-client-lcmaps-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
cvmfs-gateway-1.2.0-1.osg35.el7.x86_64
htvault-config-0.5-1.osg35.el7.x86_64
osg-ce-3.5-6.osg35.el7.x86_64
osg-ce-bosco-3.5-6.osg35.el7.x86_64
osg-ce-condor-3.5-6.osg35.el7.x86_64
osg-ce-lsf-3.5-6.osg35.el7.x86_64
osg-ce-pbs-3.5-6.osg35.el7.x86_64
osg-ce-sge-3.5-6.osg35.el7.x86_64
osg-ce-slurm-3.5-6.osg35.el7.x86_64
osg-release-3.5-7.osg35.el7.noarch
osg-scitokens-mapfile-1-1.osg35.el7.x86_64
vault-1.6.2-1.osg35.el7.x86_64
vo-client-110-1.osg35.el7.noarch
vo-client-dcache-110-1.osg35.el7.noarch
vo-client-lcmaps-voms-110-1.osg35.el7.noarch
```

#### Enterprise Linux 8

``` file
cvmfs-gateway-1.2.0-1.osg35.el8.x86_64
htvault-config-0.5-1.osg35.el8.x86_64
osg-ce-3.5-6.osg35.el8.x86_64
osg-ce-bosco-3.5-6.osg35.el8.x86_64
osg-ce-condor-3.5-6.osg35.el8.x86_64
osg-ce-lsf-3.5-6.osg35.el8.x86_64
osg-ce-pbs-3.5-6.osg35.el8.x86_64
osg-ce-sge-3.5-6.osg35.el8.x86_64
osg-ce-slurm-3.5-6.osg35.el8.x86_64
osg-release-3.5-7.osg35.el8.noarch
osg-scitokens-mapfile-1-1.osg35.el8.x86_64
vault-1.6.2-1.osg35.el8.x86_64
vo-client-110-1.osg35.el8.noarch
vo-client-dcache-110-1.osg35.el8.noarch
vo-client-lcmaps-voms-110-1.osg35.el8.noarch
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [blahp-1.18.48-2.4.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.48-2.4.osg35up.el7)
-   [condor-8.9.11-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.9.11-1.1.osg35up.el7)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python3-condor

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-1.18.48-2.4.osg35up.el7.x86_64
blahp-debuginfo-1.18.48-2.4.osg35up.el7.x86_64
condor-8.9.11-1.1.osg35up.el7.x86_64
condor-all-8.9.11-1.1.osg35up.el7.x86_64
condor-annex-ec2-8.9.11-1.1.osg35up.el7.x86_64
condor-bosco-8.9.11-1.1.osg35up.el7.x86_64
condor-classads-8.9.11-1.1.osg35up.el7.x86_64
condor-classads-devel-8.9.11-1.1.osg35up.el7.x86_64
condor-credmon-oauth-8.9.11-1.1.osg35up.el7.x86_64
condor-debuginfo-8.9.11-1.1.osg35up.el7.x86_64
condor-kbdd-8.9.11-1.1.osg35up.el7.x86_64
condor-procd-8.9.11-1.1.osg35up.el7.x86_64
condor-test-8.9.11-1.1.osg35up.el7.x86_64
condor-vm-gahp-8.9.11-1.1.osg35up.el7.x86_64
minicondor-8.9.11-1.1.osg35up.el7.x86_64
python2-condor-8.9.11-1.1.osg35up.el7.x86_64
python3-condor-8.9.11-1.1.osg35up.el7.x86_64
```
