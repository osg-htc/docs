OSG Software Release 3.5.52
===========================

**Release Date:** 2021-12-09  
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

-   Upcoming

    !!!warning "Problem interoperating with older origin servers"
        If an XRootD 5.3.4 cache interacts with a 5.1 or 5.2 origin and there is an asyncio error, it may crash the origin.
        Please upgrade your origin at your earliest convenience.
        You may turn off asyncio (`async off`) on either end to avoid the problem.

    -   [XRootD 5.3.4](https://github.com/xrootd/xrootd/blob/v5.3.4/docs/ReleaseNotes.txt)
        -   Fix uncorrectable checksum errors in XCache Origins
    -   [HTCondor 9.0.8 LTS](https://htcondor.org/news/HTCondor_9.0.8_released/)
        -   Fix bug where huge values of ImageSize and others would end up negative
        -   Fix bug in how MAX_JOBS_PER_OWNER applied to late materialization jobs
        -   Fix bug where the schedd could choose a slot with insufficient disk space
        -   Fix crash in ClassAd substr() function when the offset is out of range
        -   Fix bug in Kerberos code that can crash on macOS and could leak memory
        -   Fix bug where a job is ignored for 20 minutes if the startd claim fails

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.52-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [condor-9.0.8-1.1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.8-1.1.osg35up.el7)
-   [xrootd-5.3.4-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.3.4-1.osg35up.el7)

#### Enterprise Linux 8

-   [condor-9.0.8-1.1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-9.0.8-1.1.osg35up.el8)
-   [xrootd-5.3.4-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.3.4-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-credmon-oauth condor-credmon-vault condor-debuginfo condor-devel condor-kbdd condor-procd condor-test condor-vm-gahp minicondor python2-condor python2-xrootd python36-xrootd python3-condor xrootd xrootd-client xrootd-client-compat xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-scitokens xrootd-selinux xrootd-server xrootd-server-compat xrootd-server-devel xrootd-server-libs xrootd-voms 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-9.0.8-1.1.osg35up.el7
condor-all-9.0.8-1.1.osg35up.el7
condor-annex-ec2-9.0.8-1.1.osg35up.el7
condor-bosco-9.0.8-1.1.osg35up.el7
condor-classads-9.0.8-1.1.osg35up.el7
condor-classads-devel-9.0.8-1.1.osg35up.el7
condor-credmon-oauth-9.0.8-1.1.osg35up.el7
condor-credmon-vault-9.0.8-1.1.osg35up.el7
condor-debuginfo-9.0.8-1.1.osg35up.el7
condor-devel-9.0.8-1.1.osg35up.el7
condor-kbdd-9.0.8-1.1.osg35up.el7
condor-procd-9.0.8-1.1.osg35up.el7
condor-test-9.0.8-1.1.osg35up.el7
condor-vm-gahp-9.0.8-1.1.osg35up.el7
minicondor-9.0.8-1.1.osg35up.el7
python2-condor-9.0.8-1.1.osg35up.el7
python2-xrootd-5.3.4-1.osg35up.el7
python36-xrootd-5.3.4-1.osg35up.el7
python3-condor-9.0.8-1.1.osg35up.el7
xrootd-5.3.4-1.osg35up.el7
xrootd-client-5.3.4-1.osg35up.el7
xrootd-client-compat-5.3.4-1.osg35up.el7
xrootd-client-devel-5.3.4-1.osg35up.el7
xrootd-client-libs-5.3.4-1.osg35up.el7
xrootd-debuginfo-5.3.4-1.osg35up.el7
xrootd-devel-5.3.4-1.osg35up.el7
xrootd-doc-5.3.4-1.osg35up.el7
xrootd-fuse-5.3.4-1.osg35up.el7
xrootd-libs-5.3.4-1.osg35up.el7
xrootd-private-devel-5.3.4-1.osg35up.el7
xrootd-scitokens-5.3.4-1.osg35up.el7
xrootd-selinux-5.3.4-1.osg35up.el7
xrootd-server-5.3.4-1.osg35up.el7
xrootd-server-compat-5.3.4-1.osg35up.el7
xrootd-server-devel-5.3.4-1.osg35up.el7
xrootd-server-libs-5.3.4-1.osg35up.el7
xrootd-voms-5.3.4-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
condor-9.0.8-1.1.osg35up.el8
condor-all-9.0.8-1.1.osg35up.el8
condor-annex-ec2-9.0.8-1.1.osg35up.el8
condor-bosco-9.0.8-1.1.osg35up.el8
condor-bosco-debuginfo-9.0.8-1.1.osg35up.el8
condor-classads-9.0.8-1.1.osg35up.el8
condor-classads-debuginfo-9.0.8-1.1.osg35up.el8
condor-classads-devel-9.0.8-1.1.osg35up.el8
condor-classads-devel-debuginfo-9.0.8-1.1.osg35up.el8
condor-credmon-vault-9.0.8-1.1.osg35up.el8
condor-debuginfo-9.0.8-1.1.osg35up.el8
condor-debugsource-9.0.8-1.1.osg35up.el8
condor-devel-9.0.8-1.1.osg35up.el8
condor-kbdd-9.0.8-1.1.osg35up.el8
condor-kbdd-debuginfo-9.0.8-1.1.osg35up.el8
condor-procd-9.0.8-1.1.osg35up.el8
condor-procd-debuginfo-9.0.8-1.1.osg35up.el8
condor-test-9.0.8-1.1.osg35up.el8
condor-test-debuginfo-9.0.8-1.1.osg35up.el8
condor-vm-gahp-9.0.8-1.1.osg35up.el8
condor-vm-gahp-debuginfo-9.0.8-1.1.osg35up.el8
minicondor-9.0.8-1.1.osg35up.el8
python3-condor-9.0.8-1.1.osg35up.el8
python3-condor-debuginfo-9.0.8-1.1.osg35up.el8
python3-xrootd-5.3.4-1.osg35up.el8
python3-xrootd-debuginfo-5.3.4-1.osg35up.el8
xrootd-5.3.4-1.osg35up.el8
xrootd-client-5.3.4-1.osg35up.el8
xrootd-client-compat-5.3.4-1.osg35up.el8
xrootd-client-compat-debuginfo-5.3.4-1.osg35up.el8
xrootd-client-debuginfo-5.3.4-1.osg35up.el8
xrootd-client-devel-5.3.4-1.osg35up.el8
xrootd-client-devel-debuginfo-5.3.4-1.osg35up.el8
xrootd-client-libs-5.3.4-1.osg35up.el8
xrootd-client-libs-debuginfo-5.3.4-1.osg35up.el8
xrootd-debuginfo-5.3.4-1.osg35up.el8
xrootd-debugsource-5.3.4-1.osg35up.el8
xrootd-devel-5.3.4-1.osg35up.el8
xrootd-doc-5.3.4-1.osg35up.el8
xrootd-fuse-5.3.4-1.osg35up.el8
xrootd-fuse-debuginfo-5.3.4-1.osg35up.el8
xrootd-libs-5.3.4-1.osg35up.el8
xrootd-libs-debuginfo-5.3.4-1.osg35up.el8
xrootd-private-devel-5.3.4-1.osg35up.el8
xrootd-scitokens-5.3.4-1.osg35up.el8
xrootd-scitokens-debuginfo-5.3.4-1.osg35up.el8
xrootd-selinux-5.3.4-1.osg35up.el8
xrootd-server-5.3.4-1.osg35up.el8
xrootd-server-compat-5.3.4-1.osg35up.el8
xrootd-server-compat-debuginfo-5.3.4-1.osg35up.el8
xrootd-server-debuginfo-5.3.4-1.osg35up.el8
xrootd-server-devel-5.3.4-1.osg35up.el8
xrootd-server-libs-5.3.4-1.osg35up.el8
xrootd-server-libs-debuginfo-5.3.4-1.osg35up.el8
xrootd-voms-5.3.4-1.osg35up.el8
xrootd-voms-debuginfo-5.3.4-1.osg35up.el8
```
