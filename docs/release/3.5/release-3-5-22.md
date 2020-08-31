OSG Software Release 3.5.22
===========================

**Release Date:** 2020-08-27    
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

-   [HTCondor 8.8.10](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00017.shtml)
    -   condor\_qedit can no longer be used to disrupt the condor\_schedd
    -   Fixed a bug where the SHARED\_PORT\_PORT configuration setting was ignored
-   [Frontier Squid 4.13-1.1](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES)
    -   The [release notes](https://www.mail-archive.com/squid-announce@lists.squid-cache.org/msg00117.html) contains a couple of relevant security advisories related to cache poisoning.
    -   Removed the recursion on the restorecon for SELinux in the %post install step, to avoid taking a long time when going through a large cache.
-   XCache 1.5.2: Added SciTokens support
-   [xrootd-scitokens 1.2.2](https://github.com/scitokens/xrootd-scitokens/releases/tag/v1.2.2): Bug fix for allowed issuers
-   gratia-probe 1.20.14
    -   Improved handling of special characters in Slurm cluster names
    -   Detect condor/htcondor-ce probe configuration automatically
-   [BLAHP 1.18.47](https://github.com/htcondor/BLAH/releases/tag/v1.18.47): Added HTCondor submit debugging support
-   oidc-agent 3.3.3: Various bug fixes
-   XRootD plugins: Loosen XRootD version requirements

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.22%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

!!!note 
    To enable OSG repositories on Enterprise Linux 8, follow the OSG repository [instructions](/common/yum/#enable-additional-os-repositories).

Containers
----------

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

#### Enterprise Linux 7

-   [blahp-1.18.47-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.47-1.osg35.el7)
-   [condor-8.8.10-1.3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.10-1.3.osg35.el7)
-   [frontier-squid-4.13-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.13-1.1.osg35.el7)
-   [gratia-probe-1.20.14-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gratia-probe-1.20.14-1.osg35.el7)
-   [oidc-agent-3.3.3-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=oidc-agent-3.3.3-1.1.osg35.el7)
-   [xcache-1.5.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xcache-1.5.2-1.osg35.el7)
-   [xrootd-hdfs-2.1.7-8.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.7-8.osg35.el7)
-   [xrootd-lcmaps-1.7.8-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.8-2.osg35.el7)
-   [xrootd-multiuser-0.4.3-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.3-2.osg35.el7)
-   [xrootd-scitokens-1.2.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.2.2-1.osg35.el7)

#### Enterprise Linux 8

-   None

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    atlas-xcache blahp blahp-debuginfo cms-xcache condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp frontier-squid gratia-probe gratia-probe-common gratia-probe-condor gratia-probe-condor-events gratia-probe-dcache-storage gratia-probe-dcache-storagegroup gratia-probe-dcache-transfer gratia-probe-debuginfo gratia-probe-enstore-storage gratia-probe-enstore-tapedrive gratia-probe-enstore-transfer gratia-probe-glideinwms gratia-probe-gridftp-transfer gratia-probe-hadoop-storage gratia-probe-htcondor-ce gratia-probe-lsf gratia-probe-metric gratia-probe-onevm gratia-probe-pbs-lsf gratia-probe-services gratia-probe-sge gratia-probe-slurm gratia-probe-xrootd-storage gratia-probe-xrootd-transfer minicondor oidc-agent oidc-agent-debuginfo python2-condor python3-condor stash-cache stash-origin xcache xcache-consistency-check xcache-redirector xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-multiuser xrootd-multiuser-debuginfo xrootd-scitokens xrootd-scitokens-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
atlas-xcache-1.5.2-1.osg35.el7
blahp-1.18.47-1.osg35.el7
blahp-debuginfo-1.18.47-1.osg35.el7
cms-xcache-1.5.2-1.osg35.el7
condor-8.8.10-1.3.osg35.el7
condor-all-8.8.10-1.3.osg35.el7
condor-annex-ec2-8.8.10-1.3.osg35.el7
condor-bosco-8.8.10-1.3.osg35.el7
condor-classads-8.8.10-1.3.osg35.el7
condor-classads-devel-8.8.10-1.3.osg35.el7
condor-debuginfo-8.8.10-1.3.osg35.el7
condor-kbdd-8.8.10-1.3.osg35.el7
condor-procd-8.8.10-1.3.osg35.el7
condor-test-8.8.10-1.3.osg35.el7
condor-vm-gahp-8.8.10-1.3.osg35.el7
frontier-squid-4.13-1.1.osg35.el7
gratia-probe-1.20.14-1.osg35.el7
gratia-probe-common-1.20.14-1.osg35.el7
gratia-probe-condor-1.20.14-1.osg35.el7
gratia-probe-condor-events-1.20.14-1.osg35.el7
gratia-probe-dcache-storage-1.20.14-1.osg35.el7
gratia-probe-dcache-storagegroup-1.20.14-1.osg35.el7
gratia-probe-dcache-transfer-1.20.14-1.osg35.el7
gratia-probe-debuginfo-1.20.14-1.osg35.el7
gratia-probe-enstore-storage-1.20.14-1.osg35.el7
gratia-probe-enstore-tapedrive-1.20.14-1.osg35.el7
gratia-probe-enstore-transfer-1.20.14-1.osg35.el7
gratia-probe-glideinwms-1.20.14-1.osg35.el7
gratia-probe-gridftp-transfer-1.20.14-1.osg35.el7
gratia-probe-hadoop-storage-1.20.14-1.osg35.el7
gratia-probe-htcondor-ce-1.20.14-1.osg35.el7
gratia-probe-lsf-1.20.14-1.osg35.el7
gratia-probe-metric-1.20.14-1.osg35.el7
gratia-probe-onevm-1.20.14-1.osg35.el7
gratia-probe-pbs-lsf-1.20.14-1.osg35.el7
gratia-probe-services-1.20.14-1.osg35.el7
gratia-probe-sge-1.20.14-1.osg35.el7
gratia-probe-slurm-1.20.14-1.osg35.el7
gratia-probe-xrootd-storage-1.20.14-1.osg35.el7
gratia-probe-xrootd-transfer-1.20.14-1.osg35.el7
minicondor-8.8.10-1.3.osg35.el7
oidc-agent-3.3.3-1.1.osg35.el7
oidc-agent-debuginfo-3.3.3-1.1.osg35.el7
python2-condor-8.8.10-1.3.osg35.el7
python3-condor-8.8.10-1.3.osg35.el7
stash-cache-1.5.2-1.osg35.el7
stash-origin-1.5.2-1.osg35.el7
xcache-1.5.2-1.osg35.el7
xcache-consistency-check-1.5.2-1.osg35.el7
xcache-redirector-1.5.2-1.osg35.el7
xrootd-hdfs-2.1.7-8.osg35.el7
xrootd-hdfs-debuginfo-2.1.7-8.osg35.el7
xrootd-hdfs-devel-2.1.7-8.osg35.el7
xrootd-lcmaps-1.7.8-2.osg35.el7
xrootd-lcmaps-debuginfo-1.7.8-2.osg35.el7
xrootd-multiuser-0.4.3-2.osg35.el7
xrootd-multiuser-debuginfo-0.4.3-2.osg35.el7
xrootd-scitokens-1.2.2-1.osg35.el7
xrootd-scitokens-debuginfo-1.2.2-1.osg35.el7
```

#### Enterprise Linux 8

``` file
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [blahp-1.18.47-2.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.47-2.osgup.el7)

#### Enterprise Linux 8

-   None

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
blahp-1.18.47-2.osgup.el7
blahp-debuginfo-1.18.47-2.osgup.el7
```

#### Enterprise Linux 8

``` file
```
