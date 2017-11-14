OSG Software Release 3.3.30
===========================

**Release Date**: 2017-11-14

Summary of changes
------------------

This release contains:


These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.30%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

!!! note
    StashCache is supported on EL7 only.

!!! note
    xrootd-lcmaps will remain at 1.2.1-1 on EL6.

Detailed changes are below. All of the documentation can be found [here](../../).

Known Issues
------------

-   Because the Gratia system has been turned off, RSV emits the following warning: `WARNING: Gratia server gratia-osg-prod.opensciencegrid.org:80 not responding to obtain last contact details.`. This warning can safely be ignored.
-   Updates to VOMS admin server require the updated emi-trustmanager-tomcat and re-running the configure script:

        :::console
        root@host # /var/lib/trustmanager-tomcat/configure.sh

-   VOMS admin server shows an error when modifying/adding/signing AUPs, but all the actions still work.
-   After updating OSG-CE to version 3.3-12, please disable and remove OSG Info Services via the following procedure:

        :::console
        root@host # service osg-info-services stop
        root@host # yum erase gip osg-info-services

-   The Koji client config has changed in the new version of Koji: `pkgurl=http://koji.chtc.wisc.edu/packages` has been replaced by `topurl=http://koji.chtc.wisc.edu` and the Koji client will give a harmless but annoying warning when it finds `pkgurl`. To get rid of the warning, update to osg-build > `1.8.0`, rerun `osg-koji setup`, and say 'yes' when asked to replace the Koji configuration file; or, you may make the above change manually.
-   A previous version (`1.17.0-2.5`) of the Gratia probes required changes in the HTCondor configuration to operate properly. Now, these changes need to be reverted to use verison `1.17.0-2.6` and later of the probes. The lines below are likely to be found in `condor_config.local` or a new file in `/etc/condor/config.d` directory. Delete these lines and run `condor_reconfig`.

        # GlideinWMS Gratia commands
        PER_JOB_HISTORY_DIR = /var/lib/gratia/data
        JOBGLIDEIN_ResourceName="$$([IfThenElse(IsUndefined(TARGET.GLIDEIN_ResourceName), IfThenElse(IsUndefined(TARGET.GLIDEIN_Site), IfThenElse(IsUndefined(TARGET.FileSystemDomain), \"Local Job\", TARGET.FileSystemDomain), TARGET.GLIDEIN_Site), TARGET.GLIDEIN_ResourceName)])"
        SUBMIT_EXPRS = $(SUBMIT_EXPRS) JOBGLIDEIN_ResourceName

-   On EL7, your version of voms-proxy-init may come from the voms-clients-java package; this version will continue to make legacy proxies by default. If you want the new behavior, install the voms-clients-cpp package and uninstall the voms-clients-java package.

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need [install the current OSG repositories](../../common/yum#install-osg-repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
root@host # yum update
```

!!! note
    Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

!!! note
    Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](../../common/help).

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
