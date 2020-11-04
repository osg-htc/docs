OSG Software Release 3.4.39
===========================

**Release Date**: 2019-11-14
**Supported OS Versions:** EL7, EL6

Summary of changes
------------------

This release contains:

-   [Frontier-Squid 4.9-2.1](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES): [Fixed security vulnerabilities](https://opensciencegrid.org/security/vulns/OSG-SEC-2019-11-11-Vulnerability-in-Squid-UPDATE/)
    -   Heap Overflow issue in URN processing
    -   Multiple issues in URI processing
-   [XRootD 4.11.0](https://github.com/xrootd/xrootd/blob/v4.11.0/docs/ReleaseNotes.txt): New feature release
-   [BLAHP 1.18.45](https://github.com/htcondor/BLAH/releases/tag/v1.18.44)
    -   Add SystemCpu accounting when Slurm jobs complete
    -   Add support for decimal seconds fields from Slurm
    -   Move local submit attributes scripts from spec to sources
    -   Pull in various updates to Slurm scripts from HTCondor's BLAHP
        -   Add BLAHP options for project name (-A, BatchProject) and runtime limit (-t, BatchRuntime).
            -   The `BatchProject` HTCondor job attribute is a string that's used with the project or allocation option of the batch system's submission interface.
            -   The `BatchRuntime` HTCondor job attribute is an integer that limits the job's wall-clock execution time, expressed in seconds.
        -   Detect and handle Slurm jobs in the TIMEOUT state
        -   Explicitly specify `/bin/bash` for shell scripts rather than `/bin/sh`
        -   Minor python bug fixes for comparing variables against None
        -   Support multiple Slurm clusters. The batch queue job parameter to the BLAHP now accepts an optional `@<CLUSTER NAME>` suffix. The job id generated for the BLAHP will include the cluster name to allow subsequent actions to target the specified cluster.
-   scitokens-credmon 0.4.2: Provide configuration files in examples directory
-   scitokens-cpp 0.3.5: Fixed Elliptic-curve public key handling
-   [Singularity 3.4.2](https://github.com/sylabs/singularity/releases/tag/v3.4.2): Bug fix release

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.39%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Containers
----------

The [Worker node containers](/worker-node/using-wn-containers/) have been updated to this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](/index.md).

-   OSG 3.4 contains only 64-bit components.
-   The StashCache service is only supported on EL7

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

1. Upgrades from <= 3.4.0 may require merging `/etc/condor/config.d/*.rpmnew` files and restarting HTCondor.

1. GlideinWMS >= 3.4.5 uses shared port, requiring only port 9618.
   To ease the transition to shared port, the User Collector, secondary collectors, and CCBs support both shared and
   separate, individual ports.
   To start using shared port, change the secondary collectors lines and the CCBs lines (if any) in
   `/etc/gwms-frontend/frontend.xml`, changing the address to include the shared port sinful string:

        <collector DN="/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=gwms-frontend.domain" group="default" node="gwms-frontend.domain:9618?sock=collector0-40" secondary="True"/>

    Replace `gwms-frontend-domain` above with the hostname of your GlideinWMS frontend.
    See the [GlideinWMS documentation](https://glideinwms.fnal.gov/doc.prd/components/condor.html#collectors ) for details.

Known Issues
------------

OSG System Profiler verifies all installed packages, which may result in
[excessively long run times](https://opensciencegrid.atlassian.net/browse/SOFTWARE-3804).

Updating to the new release
---------------------------


### Update Repositories

To update to this series, you need to [install the current OSG repositories](/common/yum#install-osg-repositories).

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

Do you need help with this release? [Contact us for help](/common/help).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [blahp-1.18.45-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.45-1.osg34.el6)
-   [frontier-squid-4.9-2.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.9-2.1.osg34.el6)
-   [osg-version-3.4.39-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.39-1.osg34.el6)
-   [scitokens-cpp-0.3.5-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.3.5-1.osg34.el6)
-   [singularity-3.4.2-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.4.2-1.1.osg34.el6)
-   [xrootd-4.11.0-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.0-1.osg34.el6)
-   [xrootd-lcmaps-1.7.4-4.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.4-4.osg34.el6)

#### Enterprise Linux 7

-   [blahp-1.18.45-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=blahp-1.18.45-1.osg34.el7)
-   [frontier-squid-4.9-2.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.9-2.1.osg34.el7)
-   [osg-version-3.4.39-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.39-1.osg34.el7)
-   [scitokens-cpp-0.3.5-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-cpp-0.3.5-1.osg34.el7)
-   [scitokens-credmon-0.4-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=scitokens-credmon-0.4-2.osg34.el7)
-   [singularity-3.4.2-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=singularity-3.4.2-1.1.osg34.el7)
-   [xrootd-4.11.0-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-4.11.0-1.osg34.el7)
-   [xrootd-hdfs-2.1.7-2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-hdfs-2.1.7-2.osg34.el7)
-   [xrootd-lcmaps-1.7.4-4.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-lcmaps-1.7.4-4.osg34.el7)
-   [xrootd-multiuser-0.4.2-5.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-multiuser-0.4.2-5.osg34.el7)
-   [xrootd-scitokens-1.0.0-1.2.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=xrootd-scitokens-1.0.0-1.2.osg34.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    blahp blahp-debuginfo frontier-squid frontier-squid-debuginfo osg-version python2-scitokens-credmon python2-xrootd scitokens-cpp scitokens-cpp-debuginfo scitokens-cpp-devel singularity singularity-debuginfo xrootd xrootd-client xrootd-client-devel xrootd-client-libs xrootd-debuginfo xrootd-devel xrootd-doc xrootd-fuse xrootd-hdfs xrootd-hdfs-debuginfo xrootd-hdfs-devel xrootd-lcmaps xrootd-lcmaps-debuginfo xrootd-libs xrootd-multiuser xrootd-multiuser-debuginfo xrootd-private-devel xrootd-scitokens xrootd-scitokens-debuginfo xrootd-selinux xrootd-server xrootd-server-devel xrootd-server-libs

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
blahp-1.18.45-1.osg34.el6
blahp-debuginfo-1.18.45-1.osg34.el6
frontier-squid-4.9-2.1.osg34.el6
frontier-squid-debuginfo-4.9-2.1.osg34.el6
osg-version-3.4.39-1.osg34.el6
python2-xrootd-4.11.0-1.osg34.el6
scitokens-cpp-0.3.5-1.osg34.el6
scitokens-cpp-debuginfo-0.3.5-1.osg34.el6
scitokens-cpp-devel-0.3.5-1.osg34.el6
singularity-3.4.2-1.1.osg34.el6
singularity-debuginfo-3.4.2-1.1.osg34.el6
xrootd-4.11.0-1.osg34.el6
xrootd-client-4.11.0-1.osg34.el6
xrootd-client-devel-4.11.0-1.osg34.el6
xrootd-client-libs-4.11.0-1.osg34.el6
xrootd-debuginfo-4.11.0-1.osg34.el6
xrootd-devel-4.11.0-1.osg34.el6
xrootd-doc-4.11.0-1.osg34.el6
xrootd-fuse-4.11.0-1.osg34.el6
xrootd-lcmaps-1.7.4-4.osg34.el6
xrootd-lcmaps-debuginfo-1.7.4-4.osg34.el6
xrootd-libs-4.11.0-1.osg34.el6
xrootd-private-devel-4.11.0-1.osg34.el6
xrootd-selinux-4.11.0-1.osg34.el6
xrootd-server-4.11.0-1.osg34.el6
xrootd-server-devel-4.11.0-1.osg34.el6
xrootd-server-libs-4.11.0-1.osg34.el6
```

#### Enterprise Linux 7

``` file
blahp-1.18.45-1.osg34.el7
blahp-debuginfo-1.18.45-1.osg34.el7
frontier-squid-4.9-2.1.osg34.el7
frontier-squid-debuginfo-4.9-2.1.osg34.el7
osg-version-3.4.39-1.osg34.el7
python2-scitokens-credmon-0.4-2.osg34.el7
python2-xrootd-4.11.0-1.osg34.el7
scitokens-cpp-0.3.5-1.osg34.el7
scitokens-cpp-debuginfo-0.3.5-1.osg34.el7
scitokens-cpp-devel-0.3.5-1.osg34.el7
scitokens-credmon-0.4-2.osg34.el7
singularity-3.4.2-1.1.osg34.el7
singularity-debuginfo-3.4.2-1.1.osg34.el7
xrootd-4.11.0-1.osg34.el7
xrootd-client-4.11.0-1.osg34.el7
xrootd-client-devel-4.11.0-1.osg34.el7
xrootd-client-libs-4.11.0-1.osg34.el7
xrootd-debuginfo-4.11.0-1.osg34.el7
xrootd-devel-4.11.0-1.osg34.el7
xrootd-doc-4.11.0-1.osg34.el7
xrootd-fuse-4.11.0-1.osg34.el7
xrootd-hdfs-2.1.7-2.osg34.el7
xrootd-hdfs-debuginfo-2.1.7-2.osg34.el7
xrootd-hdfs-devel-2.1.7-2.osg34.el7
xrootd-lcmaps-1.7.4-4.osg34.el7
xrootd-lcmaps-debuginfo-1.7.4-4.osg34.el7
xrootd-libs-4.11.0-1.osg34.el7
xrootd-multiuser-0.4.2-5.osg34.el7
xrootd-multiuser-debuginfo-0.4.2-5.osg34.el7
xrootd-private-devel-4.11.0-1.osg34.el7
xrootd-scitokens-1.0.0-1.2.osg34.el7
xrootd-scitokens-debuginfo-1.0.0-1.2.osg34.el7
xrootd-selinux-4.11.0-1.osg34.el7
xrootd-server-4.11.0-1.osg34.el7
xrootd-server-devel-4.11.0-1.osg34.el7
xrootd-server-libs-4.11.0-1.osg34.el7
```
