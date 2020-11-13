OSG Software Release 3.4.35
===========================

**Release Date**: 2019-09-19    
**Supported OS Versions:** EL7, EL6

Summary of changes
------------------

This release contains:

-   Updated: MyProxy, GSI-OpenSSH, and Globus GridFTP Server
    -   Fixed installation failure due to missing globus-usage dependency
    -   Removed usage statistics collection and reporting back to developers
-   [Singularity 3.4.0](https://github.com/sylabs/singularity/releases/tag/v3.4.0): Added encrypted container support
-   [GlideinWMS 3.4.6](https://glideinwms.fnal.gov/doc.v3_4_6/history.html)
    -   Improved Singularity scripts
    -   Made Factory compatible with older 3.4 Frontends

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.35%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

-   OSG 3.4 contains only 64-bit components.
-   StashCache is only supported on EL7

### GlideinWMS ###

1. GlideinWMS 3.4.6 is the last release supporting Globus GRAM (a.k.a. GT2/GT5).

1. For new Singularity features introduced in GlideinWMS 3.4.1, all factories and frontends need to be >= 3.4.1.

    !!! note
        OSG GlideinWMS factories are running at least 3.4.1

    If some of the connected Factories are <= 3.4.1 you will see an error during reconfig/upgrade if you try to use
    features that require a newer Factory.
    To start using Singularity via GlideinWMS, see:

    - <https://glideinwms.fnal.gov/doc.prd/frontend/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/configuration.html#singularity>
    - <https://glideinwms.fnal.gov/doc.prd/factory/custom_vars.html#singularity_vars>

1. Upgrades from <= 3.4.0 may require merging `/etc/condor/config.d/*.rpmnew` files and a restart of HTCondor.

1. GlideinWMS >= 3.4.5 uses shared port, requiring only port 9618.
   To ease the transition to shared port, the User Collector secondary collectors and CCBs support both shared and
   separate, individual ports.
   To start using shared port, change the secondary collectors lines and the CCBs lines (if any) in
   `/etc/gwms-frontend/frontend.xml`, changing the address to include the shared port sinful string:

        <collector DN="/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=gwms-frontend.domain" group="default" node="gwms-frontend.domain:9618?sock=collector0-40" secondary="True"/>

    Replacing `gwms-frontend-domain` with the hostname of your GlideinWMS frontend.
    See the [GlideinWMS documentation](https://glideinwms.fnal.gov/doc.prd/components/condor.html#collectors ) for details.

Known Issues
------------

OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).

Updating to the new release
---------------------------


### Update Repositories

To update to this series, you need to [install the current OSG repositories](../../common/yum.md#install-the-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note "Notes"
    -   Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.
    -   Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been edited, and a new default version was to be installed. In that case, RPM does not overwrite the edited configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help.md).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [glideinwms-3.4.6-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4.6-1.osg34.el6)
-   [globus-gridftp-server-13.11-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.11-1.1.osg34.el6)
-   [gsi-openssh-7.3p1c-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.3p1c-1.2.osg34.el6)
-   [myproxy-6.2.6-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.2.6-1.1.osg34.el6)
-   [osg-version-3.4.35-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.35-1.osg34.el6)
-   [singularity-3.4.0-1.2.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.4.0-1.2.osg34.el6)

#### Enterprise Linux 7

-   [glideinwms-3.4.6-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=glideinwms-3.4.6-1.osg34.el7)
-   [globus-gridftp-server-13.11-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=globus-gridftp-server-13.11-1.1.osg34.el7)
-   [gsi-openssh-7.4p1-4.3.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=gsi-openssh-7.4p1-4.3.osg34.el7)
-   [myproxy-6.2.6-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=myproxy-6.2.6-1.1.osg34.el7)
-   [osg-version-3.4.35-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.35-1.osg34.el7)
-   [singularity-3.4.0-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.4.0-1.2.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    glideinwms-common-tools glideinwms-condor-common-config glideinwms-factory glideinwms-factory-condor glideinwms-glidecondor-tools glideinwms-libs glideinwms-minimal-condor glideinwms-usercollector glideinwms-userschedd glideinwms-vofrontend glideinwms-vofrontend-standalone globus-gridftp-server globus-gridftp-server-debuginfo globus-gridftp-server-devel globus-gridftp-server-progs gsi-openssh gsi-openssh-clients gsi-openssh-debuginfo gsi-openssh-server myproxy myproxy-admin myproxy-debuginfo myproxy-devel myproxy-doc myproxy-libs myproxy-server myproxy-voms osg-version singularity singularity-debuginfo

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
glideinwms-3.4.6-1.osg34.el6
glideinwms-common-tools-3.4.6-1.osg34.el6
glideinwms-condor-common-config-3.4.6-1.osg34.el6
glideinwms-factory-3.4.6-1.osg34.el6
glideinwms-factory-condor-3.4.6-1.osg34.el6
glideinwms-glidecondor-tools-3.4.6-1.osg34.el6
glideinwms-libs-3.4.6-1.osg34.el6
glideinwms-minimal-condor-3.4.6-1.osg34.el6
glideinwms-usercollector-3.4.6-1.osg34.el6
glideinwms-userschedd-3.4.6-1.osg34.el6
glideinwms-vofrontend-3.4.6-1.osg34.el6
glideinwms-vofrontend-standalone-3.4.6-1.osg34.el6
globus-gridftp-server-13.11-1.1.osg34.el6
globus-gridftp-server-debuginfo-13.11-1.1.osg34.el6
globus-gridftp-server-devel-13.11-1.1.osg34.el6
globus-gridftp-server-progs-13.11-1.1.osg34.el6
gsi-openssh-7.3p1c-1.2.osg34.el6
gsi-openssh-clients-7.3p1c-1.2.osg34.el6
gsi-openssh-debuginfo-7.3p1c-1.2.osg34.el6
gsi-openssh-server-7.3p1c-1.2.osg34.el6
myproxy-6.2.6-1.1.osg34.el6
myproxy-admin-6.2.6-1.1.osg34.el6
myproxy-debuginfo-6.2.6-1.1.osg34.el6
myproxy-devel-6.2.6-1.1.osg34.el6
myproxy-doc-6.2.6-1.1.osg34.el6
myproxy-libs-6.2.6-1.1.osg34.el6
myproxy-server-6.2.6-1.1.osg34.el6
myproxy-voms-6.2.6-1.1.osg34.el6
osg-version-3.4.35-1.osg34.el6
singularity-3.4.0-1.2.osg34.el6
singularity-debuginfo-3.4.0-1.2.osg34.el6
```

#### Enterprise Linux 7

``` file
glideinwms-3.4.6-1.osg34.el7
glideinwms-common-tools-3.4.6-1.osg34.el7
glideinwms-condor-common-config-3.4.6-1.osg34.el7
glideinwms-factory-3.4.6-1.osg34.el7
glideinwms-factory-condor-3.4.6-1.osg34.el7
glideinwms-glidecondor-tools-3.4.6-1.osg34.el7
glideinwms-libs-3.4.6-1.osg34.el7
glideinwms-minimal-condor-3.4.6-1.osg34.el7
glideinwms-usercollector-3.4.6-1.osg34.el7
glideinwms-userschedd-3.4.6-1.osg34.el7
glideinwms-vofrontend-3.4.6-1.osg34.el7
glideinwms-vofrontend-standalone-3.4.6-1.osg34.el7
globus-gridftp-server-13.11-1.1.osg34.el7
globus-gridftp-server-debuginfo-13.11-1.1.osg34.el7
globus-gridftp-server-devel-13.11-1.1.osg34.el7
globus-gridftp-server-progs-13.11-1.1.osg34.el7
gsi-openssh-7.4p1-4.3.osg34.el7
gsi-openssh-clients-7.4p1-4.3.osg34.el7
gsi-openssh-debuginfo-7.4p1-4.3.osg34.el7
gsi-openssh-server-7.4p1-4.3.osg34.el7
myproxy-6.2.6-1.1.osg34.el7
myproxy-admin-6.2.6-1.1.osg34.el7
myproxy-debuginfo-6.2.6-1.1.osg34.el7
myproxy-devel-6.2.6-1.1.osg34.el7
myproxy-doc-6.2.6-1.1.osg34.el7
myproxy-libs-6.2.6-1.1.osg34.el7
myproxy-server-6.2.6-1.1.osg34.el7
myproxy-voms-6.2.6-1.1.osg34.el7
osg-version-3.4.35-1.osg34.el7
singularity-3.4.0-1.2.osg34.el7
singularity-debuginfo-3.4.0-1.2.osg34.el7
```
