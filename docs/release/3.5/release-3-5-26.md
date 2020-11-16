OSG Software Release 3.5.26
===========================

**Release Date:** 2020-11-05    
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

-   gfal2 2.18.1: compatible with XRootD-4 to correct installation failures
-   [HTCondor 8.8.11](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00021.shtml)
    -   HTCondor now properly tracks usage over vanilla universe checkpoints
    -   New ClassAd equality and inequality operators in the Python bindings
    -   Fixed a bug where removing in-use routes could crash the job router
    -   Fixed a bug where condor\_chirp would abort after success on Windows
    -   Fixed a bug where using MACHINE\_RESOURCE\_NAMES could crash the startd
    -   Improved condor c-gahp to prioritize commands over file transfers
    -   Fixed a rare crash in the schedd when running many local universe jobs
    -   With GSI, avoid unnecessary reverse DNS lookup when HOST\_ALIAS is set
    -   Fix a bug that could cause grid universe jobs to fail upon proxy refresh
-   [CVMFS 2.7.5](https://cvmfs.readthedocs.io/en/2.7/cpt-releasenotes.html)
    -   [client] fix rare crash when kernel meta-data caches operate close to 4GB
    -   [client] let mount helper detect when CVMFS\_HTTP\_PROXY is defined but empty
    -   [client] add CVMFS\_CLIENT\_PROFILE and CVMFS\_USE\_CDN to the list of known parameters in cvmfs\_config
-   osg-flock 1.2: Updated to use HTCondor IDTOKENs
-   python-scitokens: Add Python 3 implementation
-   scitokens-credmon 0.8.1
    -   The Credmon should work with Python 3 now
    -   The Credmon subprocess child no longer stalls when the parent goes away
    -   The Credmon signals readiness to the condor\_master
    -   The Credmon Webserver no longer depends on an older version of requests\_oauthlib
    -   The LocalCredmon has the right parameters when calling "should\_renew()" so
    -   it no longer refreshes every loop
    -   The OAuthCredmon no longer excepts when computing token lifetimes
    -   in the case of missing metadata
-   Upcoming: [XRootD 5.0.2](https://github.com/xrootd/xrootd/blob/v5.0.2/docs/ReleaseNotes.txt)
    -   New Features
        -   [Xcache] Phase 1 of checksum integrity implementation (a.k.a pgread).
        -   [Monitoring] Implement extensive g-stream enhancements.
    -    Major bug fixes
        -   [Server] Avoid POSC (persistent-on-succesful-close) deletion when file creation fails because it exists.
    -    Minor bug fixes
        -   [OFS] Correct missparsing '+cksio' option to avoid config failure.
        -   [XRootD] Correct flag reset code for esoteric ssq monitor option.

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.26%2C%203.5.26-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
were addressed in this release.

Containers
----------

The following container is available and has been tagged as `stable` in accordance with our
[Container Release Policy](https://opensciencegrid.org/technology/policy/container-release/)

-   [Stash Origin](https://hub.docker.com/r/opensciencegrid/stash-origin/)

The [Worker node containers](../../worker-node/using-wn-containers.md) have been updated to this release.


Updating to the New Release
---------------------------

To update to the OSG 3.5 series, please consult the page on
[updating between release series](../release_series.md#updating-to-osg-35).

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

-   [condor-8.8.11-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.11-1.osg35.el7)
-   [cvmfs-2.7.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.5-1.osg35.el7)
-   [cvmfs-config-osg-2.5-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.5-1.osg35.el7)
-   [gfal2-2.18.1-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gfal2-2.18.1-1.osg35.el7)
-   [osg-flock-1.2-2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.2-2.osg35.el7)
-   [osg-oasis-16-7.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-7.osg35.el7)
-   [python-scitokens-1.2.4-3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=python-scitokens-1.2.4-3.osg35.el7)
-   [scitokens-credmon-0.8.1-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-credmon-0.8.1-1.2.osg35.el7)

#### Enterprise Linux 8

-   [cvmfs-2.7.5-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-2.7.5-1.osg35.el8)
-   [cvmfs-config-osg-2.5-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=cvmfs-config-osg-2.5-1.osg35.el8)
-   [osg-oasis-16-7.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-oasis-16-7.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp cvmfs cvmfs-config-osg cvmfs-devel cvmfs-ducc cvmfs-fuse3 cvmfs-server cvmfs-shrinkwrap cvmfs-unittests gfal2 gfal2-all gfal2-debuginfo gfal2-devel gfal2-doc gfal2-plugin-dcap gfal2-plugin-file gfal2-plugin-gridftp gfal2-plugin-http gfal2-plugin-lfc gfal2-plugin-mock gfal2-plugin-rfio gfal2-plugin-sftp gfal2-plugin-srm gfal2-plugin-xrootd minicondor osg-flock osg-oasis python2-condor python2-scitokens python2-scitokens-credmon python3-condor python3-scitokens python-scitokens scitokens-credmon

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
condor-8.8.11-1.osg35.el7
condor-all-8.8.11-1.osg35.el7
condor-annex-ec2-8.8.11-1.osg35.el7
condor-bosco-8.8.11-1.osg35.el7
condor-classads-8.8.11-1.osg35.el7
condor-classads-devel-8.8.11-1.osg35.el7
condor-debuginfo-8.8.11-1.osg35.el7
condor-kbdd-8.8.11-1.osg35.el7
condor-procd-8.8.11-1.osg35.el7
condor-test-8.8.11-1.osg35.el7
condor-vm-gahp-8.8.11-1.osg35.el7
cvmfs-2.7.5-1.osg35.el7
cvmfs-config-osg-2.5-1.osg35.el7
cvmfs-devel-2.7.5-1.osg35.el7
cvmfs-ducc-2.7.5-1.osg35.el7
cvmfs-fuse3-2.7.5-1.osg35.el7
cvmfs-server-2.7.5-1.osg35.el7
cvmfs-shrinkwrap-2.7.5-1.osg35.el7
cvmfs-unittests-2.7.5-1.osg35.el7
gfal2-2.18.1-1.osg35.el7
gfal2-all-2.18.1-1.osg35.el7
gfal2-debuginfo-2.18.1-1.osg35.el7
gfal2-devel-2.18.1-1.osg35.el7
gfal2-doc-2.18.1-1.osg35.el7
gfal2-plugin-dcap-2.18.1-1.osg35.el7
gfal2-plugin-file-2.18.1-1.osg35.el7
gfal2-plugin-gridftp-2.18.1-1.osg35.el7
gfal2-plugin-http-2.18.1-1.osg35.el7
gfal2-plugin-lfc-2.18.1-1.osg35.el7
gfal2-plugin-mock-2.18.1-1.osg35.el7
gfal2-plugin-rfio-2.18.1-1.osg35.el7
gfal2-plugin-sftp-2.18.1-1.osg35.el7
gfal2-plugin-srm-2.18.1-1.osg35.el7
gfal2-plugin-xrootd-2.18.1-1.osg35.el7
minicondor-8.8.11-1.osg35.el7
osg-flock-1.2-2.osg35.el7
osg-oasis-16-7.osg35.el7
python2-condor-8.8.11-1.osg35.el7
python2-scitokens-1.2.4-3.osg35.el7
python2-scitokens-credmon-0.8.1-1.2.osg35.el7
python3-condor-8.8.11-1.osg35.el7
python3-scitokens-1.2.4-3.osg35.el7
python-scitokens-1.2.4-3.osg35.el7
scitokens-credmon-0.8.1-1.2.osg35.el7
```

#### Enterprise Linux 8

``` file
cvmfs-2.7.5-1.osg35.el8
cvmfs-config-osg-2.5-1.osg35.el8
cvmfs-devel-2.7.5-1.osg35.el8
cvmfs-ducc-2.7.5-1.osg35.el8
cvmfs-fuse3-2.7.5-1.osg35.el8
cvmfs-server-2.7.5-1.osg35.el8
cvmfs-shrinkwrap-2.7.5-1.osg35.el8
cvmfs-unittests-2.7.5-1.osg35.el8
osg-oasis-16-7.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [xrootd-5.0.2-1.osgup.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-5.0.2-1.osgup.el7)

#### Enterprise Linux 8

-   None

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    python2-xrootd python3-xrootd xrootd xrootd-client xrootd-client-compat xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-libs xrootd-private-devel xrootd-selinux xrootd-server xrootd-server-compat xrootd-server-devel xrootd-server-libs xrootd-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
python2-xrootd-5.0.2-1.osgup.el7
python3-xrootd-5.0.2-1.osgup.el7
xrootd-5.0.2-1.osgup.el7
xrootd-client-5.0.2-1.osgup.el7
xrootd-client-compat-5.0.2-1.osgup.el7
xrootd-client-devel-5.0.2-1.osgup.el7
xrootd-client-libs-5.0.2-1.osgup.el7
xrootd-debuginfo-5.0.2-1.osgup.el7
xrootd-devel-5.0.2-1.osgup.el7
xrootd-doc-5.0.2-1.osgup.el7
xrootd-fuse-5.0.2-1.osgup.el7
xrootd-libs-5.0.2-1.osgup.el7
xrootd-private-devel-5.0.2-1.osgup.el7
xrootd-selinux-5.0.2-1.osgup.el7
xrootd-server-5.0.2-1.osgup.el7
xrootd-server-compat-5.0.2-1.osgup.el7
xrootd-server-devel-5.0.2-1.osgup.el7
xrootd-server-libs-5.0.2-1.osgup.el7
xrootd-voms-5.0.2-1.osgup.el7
```

#### Enterprise Linux 8

``` file
```
