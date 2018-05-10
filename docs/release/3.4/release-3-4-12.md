OSG Software Release 3.4.12
===========================

**Release Date**: 2018-05-10

!!! warning "Required Actions"
    Due to the retirement of `grid.iu.edu` hosts (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/)
    for details), some software packages require updates to reference new hosts.

    1. Find all packages that may contain references to `grid.iu.edu`:

            :::console
            root@host # rpm -q osg-ca-certs-updater osg-ca-scripts osg-release osg-release-itb \
                        osg-test rsv

    1. Update each package above that is already installed on your host:

            :::console
            root@host # yum update %RED%<LIST OF INSTALLED PACKAGES>%ENDCOLOR%

    1. If you have `rsv` installed, see [this section](#known-issues) below for rsv-specific instructions.

Summary of changes
------------------

This release contains:

-   Updated references to grid.iu.edu with opensciencegrid.org in the following packages:
    -   osg-ca-certs-updater
    -   osg-ca-scripts
    -   osg-release
    -   osg-release-itb
    -   osg-test
    -   rsv
-   [HTCondor-CE 3.1.2](https://github.com/opensciencegrid/htcondor-ce/releases/tag/v3.1.2): Added mapping for Let's Encrypt
-   [GlideinWMS 3.2.22.2](http://glideinwms.fnal.gov/doc.v3_2_22_2/history.html)
    -   Improved interoperation with Singularity
    -   Improved proxy renewal support
-   [XRootD 4.8.3](https://github.com/xrootd/xrootd/blob/v4.8.3/docs/ReleaseNotes.txt)
-   Gratia probes 1.20
    -   More flexible parsing of PBS wall time
    -   Fixed bug in interaction with Slurm
    -   Made ProjectName comparision case insensitive
    -   Dropped GRAM and glexec probes
-   RSV 3.18
    -   Enhanced java version probe to detect Tomcat on Enterprize Linux 7
    -   Disable deprecated probes by default
    -   Drop gratia-consumer probe
-   Upcoming:
    -   [GlideinWMS 3.3.3](http://glideinwms.fnal.gov/doc.v3_3_3/history.html#development)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.12%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note "Notes"
    -   OSG 3.4 contains only 64-bit components.
    -   StashCache is supported on EL7 only.
    -   xrootd-lcmaps will remain at 1.2.1-2 on EL6.
    -   OSG PKI tools now create service certificate files where the service tag is separated from the hostname with an underscore (`_`). This new format first appeared in OSG PKI tools version 2.1.2.

Detailed changes are below. All of the documentation can be found [here](/index.md).

Known Issues
------------

Due to the central RSV service retirement (see [this document](https://opensciencegrid.org/technology/policy/service-migrations-spring-2018/) for details),
the new version of RSV will disable the `gratia-consumer` component that reports to the central service.
Please update _all_ RSV packages by running the following command on your RSV host:

``` console
root@host # yum update rsv\*
```

Additionally, if you are using osg-configure, please edit `/etc/osg/config.d/30-rsv.ini` and set the following:

``` file
enable_gratia = False
```

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
