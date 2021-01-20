OSG Software Release 3.5.1
===========================

**Release Date:** 2019-09-19    
**Supported OS Versions:** EL7

Summary of changes
------------------

This release contains:

-   Updated: MyProxy, GSI-OpenSSH, and Globus GridFTP Server
    -   Fixed installation failure due to missing globus-usage dependency
    -   Removed usage statistics collection and reporting back to developers

These
[JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.5.1%20)
were addressed in this release.

Known Issues
------------

- CVMFS 2.6.2 has a known memory leak when using an `/etc/hosts` file with lines only containing whitespace
([CVM-1796](https://sft.its.cern.ch/jira/browse/CVM-1796))
- OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).


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

-   [globus-gridftp-server-13.11-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.11-1.1.osg35.el7)
-   [gsi-openssh-7.4p1-4.3.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.4p1-4.3.osg35.el7)
-   [myproxy-6.2.6-1.1.osg35.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.2.6-1.1.osg35.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms

If you wish to only update the RPMs that changed, the set of RPMs is:

``` file
globus-gridftp-server-13.11-1.1.osg35.el7
globus-gridftp-server-debuginfo-13.11-1.1.osg35.el7
globus-gridftp-server-devel-13.11-1.1.osg35.el7
globus-gridftp-server-progs-13.11-1.1.osg35.el7
gsi-openssh-7.4p1-4.3.osg35.el7
gsi-openssh-clients-7.4p1-4.3.osg35.el7
gsi-openssh-debuginfo-7.4p1-4.3.osg35.el7
gsi-openssh-server-7.4p1-4.3.osg35.el7
myproxy-6.2.6-1.1.osg35.el7
myproxy-admin-6.2.6-1.1.osg35.el7
myproxy-debuginfo-6.2.6-1.1.osg35.el7
myproxy-devel-6.2.6-1.1.osg35.el7
myproxy-doc-6.2.6-1.1.osg35.el7
myproxy-libs-6.2.6-1.1.osg35.el7
myproxy-server-6.2.6-1.1.osg35.el7
myproxy-voms-6.2.6-1.1.osg35.el7
```
