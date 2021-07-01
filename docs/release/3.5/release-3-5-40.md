OSG Software Release 3.5.40
===========================

**Release Date:** 2021-07-01  
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

-   [Frontier Squid 4.15-2.1](http://frontier.cern.ch/dist/frontier-squid-releasenotes.txt): Fix log rotation when not compressing
-   [Vault 1.7.3](https://discuss.hashicorp.com/t/ann-vault-1-7-3-released/25558): Bug fix release
-   htvault-config 1.2: Updated to match vault 1.7.3
-   Updates on Enterprise Linux 8
    -   [XRootD 4.12.6](https://github.com/xrootd/xrootd/blob/v4.12.6/docs/ReleaseNotes.txt) and plugins
    -   osg-flock 1.3
-   Upcoming
    -   xrootd-multiuser 1.1.0: Administrator can specify the default umask again

These
[JIRA tickets](https://opensciencegrid.atlassian.net/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20in%20(3.5.40%2C3.5.40-upcoming)%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC)
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

-   [frontier-squid-4.15-2.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.15-2.1.osg35.el7)
-   [gfal2-2.18.1-1.2.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gfal2-2.18.1-1.2.osg35.el7)
-   [htvault-config-1.2-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.2-1.osg35.el7)
-   [vault-1.7.3-1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.7.3-1.osg35.el7)

#### Enterprise Linux 8

-   [frontier-squid-4.15-2.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.15-2.1.osg35.el8)
-   [gfal2-2.18.1-1.2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gfal2-2.18.1-1.2.osg35.el8)
-   [htvault-config-1.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=htvault-config-1.2-1.osg35.el8)
-   [osg-flock-1.3-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-flock-1.3-1.osg35.el8)
-   [vault-1.7.3-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=vault-1.7.3-1.osg35.el8)
-   [xrootd-4.12.6-1.1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.12.6-1.1.osg35.el8)
-   [xrootd-lcmaps-1.7.8-2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.8-2.osg35.el8)
-   [xrootd-multiuser-0.4.4-2.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.4-2.osg35.el8)
-   [xrootd-scitokens-1.2.2-1.osg35.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.2.2-1.osg35.el8)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    frontier-squid gfal2 gfal2-all gfal2-debuginfo gfal2-devel gfal2-doc gfal2-plugin-dcap gfal2-plugin-file gfal2-plugin-gridftp gfal2-plugin-http gfal2-plugin-lfc gfal2-plugin-mock gfal2-plugin-rfio gfal2-plugin-sftp gfal2-plugin-srm gfal2-plugin-xrootd htvault-config vault 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
frontier-squid-4.15-2.1.osg35.el7
gfal2-2.18.1-1.2.osg35.el7
gfal2-all-2.18.1-1.2.osg35.el7
gfal2-debuginfo-2.18.1-1.2.osg35.el7
gfal2-devel-2.18.1-1.2.osg35.el7
gfal2-doc-2.18.1-1.2.osg35.el7
gfal2-plugin-dcap-2.18.1-1.2.osg35.el7
gfal2-plugin-file-2.18.1-1.2.osg35.el7
gfal2-plugin-gridftp-2.18.1-1.2.osg35.el7
gfal2-plugin-http-2.18.1-1.2.osg35.el7
gfal2-plugin-lfc-2.18.1-1.2.osg35.el7
gfal2-plugin-mock-2.18.1-1.2.osg35.el7
gfal2-plugin-rfio-2.18.1-1.2.osg35.el7
gfal2-plugin-sftp-2.18.1-1.2.osg35.el7
gfal2-plugin-srm-2.18.1-1.2.osg35.el7
gfal2-plugin-xrootd-2.18.1-1.2.osg35.el7
htvault-config-1.2-1.osg35.el7
vault-1.7.3-1.osg35.el7
```

#### Enterprise Linux 8

``` file
frontier-squid-4.15-2.1.osg35.el8
gfal2-2.18.1-1.2.osg35.el8
gfal2-all-2.18.1-1.2.osg35.el8
gfal2-debuginfo-2.18.1-1.2.osg35.el8
gfal2-debugsource-2.18.1-1.2.osg35.el8
gfal2-devel-2.18.1-1.2.osg35.el8
gfal2-doc-2.18.1-1.2.osg35.el8
gfal2-plugin-dcap-2.18.1-1.2.osg35.el8
gfal2-plugin-dcap-debuginfo-2.18.1-1.2.osg35.el8
gfal2-plugin-file-2.18.1-1.2.osg35.el8
gfal2-plugin-file-debuginfo-2.18.1-1.2.osg35.el8
gfal2-plugin-gridftp-2.18.1-1.2.osg35.el8
gfal2-plugin-gridftp-debuginfo-2.18.1-1.2.osg35.el8
gfal2-plugin-http-2.18.1-1.2.osg35.el8
gfal2-plugin-http-debuginfo-2.18.1-1.2.osg35.el8
gfal2-plugin-mock-2.18.1-1.2.osg35.el8
gfal2-plugin-mock-debuginfo-2.18.1-1.2.osg35.el8
gfal2-plugin-sftp-2.18.1-1.2.osg35.el8
gfal2-plugin-sftp-debuginfo-2.18.1-1.2.osg35.el8
gfal2-plugin-srm-2.18.1-1.2.osg35.el8
gfal2-plugin-srm-debuginfo-2.18.1-1.2.osg35.el8
gfal2-plugin-xrootd-2.18.1-1.2.osg35.el8
gfal2-plugin-xrootd-debuginfo-2.18.1-1.2.osg35.el8
htvault-config-1.2-1.osg35.el8
osg-flock-1.3-1.osg35.el8
python2-xrootd-4.12.6-1.1.osg35.el8
python2-xrootd-debuginfo-4.12.6-1.1.osg35.el8
python3-xrootd-4.12.6-1.1.osg35.el8
python3-xrootd-debuginfo-4.12.6-1.1.osg35.el8
vault-1.7.3-1.osg35.el8
xrootd-4.12.6-1.1.osg35.el8
xrootd-client-4.12.6-1.1.osg35.el8
xrootd-client-debuginfo-4.12.6-1.1.osg35.el8
xrootd-client-devel-4.12.6-1.1.osg35.el8
xrootd-client-devel-debuginfo-4.12.6-1.1.osg35.el8
xrootd-client-libs-4.12.6-1.1.osg35.el8
xrootd-client-libs-debuginfo-4.12.6-1.1.osg35.el8
xrootd-debuginfo-4.12.6-1.1.osg35.el8
xrootd-debugsource-4.12.6-1.1.osg35.el8
xrootd-devel-4.12.6-1.1.osg35.el8
xrootd-doc-4.12.6-1.1.osg35.el8
xrootd-fuse-4.12.6-1.1.osg35.el8
xrootd-fuse-debuginfo-4.12.6-1.1.osg35.el8
xrootd-lcmaps-1.7.8-2.osg35.el8
xrootd-lcmaps-debuginfo-1.7.8-2.osg35.el8
xrootd-lcmaps-debugsource-1.7.8-2.osg35.el8
xrootd-libs-4.12.6-1.1.osg35.el8
xrootd-libs-debuginfo-4.12.6-1.1.osg35.el8
xrootd-multiuser-0.4.4-2.osg35.el8
xrootd-multiuser-debuginfo-0.4.4-2.osg35.el8
xrootd-multiuser-debugsource-0.4.4-2.osg35.el8
xrootd-private-devel-4.12.6-1.1.osg35.el8
xrootd-scitokens-1.2.2-1.osg35.el8
xrootd-scitokens-debuginfo-1.2.2-1.osg35.el8
xrootd-scitokens-debugsource-1.2.2-1.osg35.el8
xrootd-selinux-4.12.6-1.1.osg35.el8
xrootd-server-4.12.6-1.1.osg35.el8
xrootd-server-debuginfo-4.12.6-1.1.osg35.el8
xrootd-server-devel-4.12.6-1.1.osg35.el8
xrootd-server-libs-4.12.6-1.1.osg35.el8
xrootd-server-libs-debuginfo-4.12.6-1.1.osg35.el8
xrootd-voms-4.12.6-1.1.osg35.el8
xrootd-voms-debuginfo-4.12.6-1.1.osg35.el8
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG Yum repository.
Note that in some cases, there are multiple RPMs for each package.
You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 7

-   [xrootd-multiuser-1.1.0-1.osg35up.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-1.1.0-1.osg35up.el7)

#### Enterprise Linux 8

-   [xrootd-multiuser-1.1.0-1.osg35up.el8](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-1.1.0-1.osg35up.el8)

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    xrootd-multiuser xrootd-multiuser-debuginfo 

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 7

``` file
xrootd-multiuser-1.1.0-1.osg35up.el7
xrootd-multiuser-debuginfo-1.1.0-1.osg35up.el7
```

#### Enterprise Linux 8

``` file
xrootd-multiuser-1.1.0-1.osg35up.el8
xrootd-multiuser-debuginfo-1.1.0-1.osg35up.el8
xrootd-multiuser-debugsource-1.1.0-1.osg35up.el8
```
