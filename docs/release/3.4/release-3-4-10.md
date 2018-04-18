OSG Software Release 3.4.10
===========================

**Release Date**: 2018-04-18

Summary of changes
------------------

This release contains:

-   [Singularity 2.4.6](https://github.com/singularityware/singularity/releases)

    !!! danger "CMS Sites"
        If you support the CMS VO, do not update Singularity until CMS announces that it is safe to do so

    -   Addresses a high severity security issue with bind mounts on hosts using overlayfs
    -   `/tmp` and `/var/tmp` are automatically scratch-mounted in containers started with the `--contain` option.
        If you are invoking singularity with `--scratch /tmp --scratch /var/tmp --contain`,
        this is redundant and will result in the following error:

            ERROR  : Not mounting requested scratch directory (already mounted in container): /tmp
            ABORT  : Retval = 255

        To fix this, drop any `--scratch /tmp` and/or `--scratch /var/tmp` options.

-   [HTCondor-CE 3.1.1](https://github.com/opensciencegrid/htcondor-ce/releases): now accepts InCommon certificates
-   [HTCondor 8.6.10](https://lists.cs.wisc.edu/archive/htcondor-world/2018/msg00004.shtml): fixed handling of grid jobs when submit fails and other fixes
-   Added [cigetcert 1.16](https://cdcvs.fnal.gov/redmine/projects/fermitools/wiki/Cigetcert)
-   BLAHP 1.18.36
    -   If qsub fails, the BLAHP now honors the blah_debug_save_submit_info setting
    -   The BLAHP now checks that input files are present before submitting to the batch system.
-   xrootd-lcmaps 1.2.1-3: fixed crashes on Enterprise Linux 6 when request were made using HTTPS
-   frontier-squid: fixed startup problem under SELinux
-   osg-configure 2.2.4:
    -   Update comments in storage section to identify that value to be used for OASIS
    -   Properly handle exception when using illegal characters in configuration files
    -   osg-configure no longer requires all site information for a GridFTP server
    -   Warns when the deprecated site_name attribute is used
    -   No longer creates and /etc/condor-ce directory on an SE or standalone GridFTP or XRootD node
    -   Validates properly formed environment variables in the local settings
-   Upcoming:
    -   [HTCondor 8.7.7](https://lists.cs.wisc.edu/archive/htcondor-world/2018/msg00005.shtml)
    -   xrootd-hdfs 2.0.2: Improved write support

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.10%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore (`_`). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](/index.md).

Known Issues
------------

-   Singularity 2.4.6 has [exhibited slow startup times](https://github.com/singularityware/singularity/issues/1447)
    on systems with a high number of maximum open file descriptors.

Updating to the new release
---------------------------

To update to the OSG 3.4 series, please consult the page on [updating between release series](/release/release_series#updating-from-osg-31-32-33-to-33-or-34).

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


#### Enterprise Linux 7


### RPMs

If you wish to manually update your system, you can run yum update against the following packages:


If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
```

#### Enterprise Linux 7

``` file
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6


#### Enterprise Linux 7


### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:


If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
```

#### Enterprise Linux 7

``` file
```
