OSG Software Release 3.4.54
===========================

**Release Date**: 2020-08-27    
**Supported OS Versions:** EL7, EL6

!!!warning "OSG 3.4 End-of-Life Approaching"
    According to our
    [OSG Software Release Series Support Policy](https://opensciencegrid.org/technology/policy/release-series/),
    the OSG 3.4 series is due to reach
    [end-of-life](https://opensciencegrid.org/technology/policy/release-series/#life-cycle-dates) in **November 2020**.
    Please [upgrade to OSG 3.5](https://opensciencegrid.org/docs/release/release_series/#updating-to-osg-35)
    at your earliest convenience.

Summary of changes
------------------

This release contains:

-   [HTCondor 8.8.10](https://www-auth.cs.wisc.edu/lists/htcondor-world/2020/msg00017.shtml)
    -   condor\_qedit can no longer be used to disrupt the condor\_schedd
    -   Fixed a bug where the SHARED\_PORT\_PORT configuration setting was ignored
-   [Frontier Squid 4.13-1.1](http://frontier.cern.ch/dist/rpms/frontier-squidRELEASE_NOTES)
    -   The [release notes](https://www.mail-archive.com/squid-announce@lists.squid-cache.org/msg00117.html) contains a couple of relevant security advisories related to cache poisoning.
    -   Removed the recursion on the restorecon for SELinux in the %post install step, to avoid taking a long time when going through a large cache.

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.4.54%20ORDER%20BY%20priority%20DESC%2C%20key%20DESC) were addressed in this release.

Notes
-----

This section describes important upgrade notes and/or caveats for packages available in the OSG release repositories.
Detailed changes are below. All of the documentation can be found [here](../../index.md).

-   OSG 3.4 contains only 64-bit components.
-   The StashCache service is only supported on EL7

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

-   [condor-8.8.10-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.10-1.1.osg34.el6)
-   [frontier-squid-4.13-1.1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.13-1.1.osg34.el6)
-   [osg-version-3.4.54-1.osg34.el6](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.54-1.osg34.el6)

#### Enterprise Linux 7

-   [condor-8.8.10-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=condor-8.8.10-1.1.osg34.el7)
-   [frontier-squid-4.13-1.1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=frontier-squid-4.13-1.1.osg34.el7)
-   [osg-version-3.4.54-1.osg34.el7](https://koji.chtc.wisc.edu/koji/search?match=glob&type=build&terms=osg-version-3.4.54-1.osg34.el7)

If you wish to only update the RPMs that changed, the set of RPMs is:

    condor condor-all condor-annex-ec2 condor-bosco condor-classads condor-classads-devel condor-cream-gahp condor-debuginfo condor-kbdd condor-procd condor-test condor-vm-gahp frontier-squid minicondor osg-version python2-condor python3-condor

#### Enterprise Linux 6

``` file
condor-8.8.10-1.1.osg34.el6
condor-all-8.8.10-1.1.osg34.el6
condor-annex-ec2-8.8.10-1.1.osg34.el6
condor-bosco-8.8.10-1.1.osg34.el6
condor-classads-8.8.10-1.1.osg34.el6
condor-classads-devel-8.8.10-1.1.osg34.el6
condor-cream-gahp-8.8.10-1.1.osg34.el6
condor-debuginfo-8.8.10-1.1.osg34.el6
condor-kbdd-8.8.10-1.1.osg34.el6
condor-procd-8.8.10-1.1.osg34.el6
condor-std-universe-8.8.10-1.1.osg34.el6
condor-test-8.8.10-1.1.osg34.el6
condor-vm-gahp-8.8.10-1.1.osg34.el6
frontier-squid-4.13-1.1.osg34.el6
minicondor-8.8.10-1.1.osg34.el6
osg-version-3.4.54-1.osg34.el6
python2-condor-8.8.10-1.1.osg34.el6
```

#### Enterprise Linux 7

``` file
condor-8.8.10-1.1.osg34.el7
condor-all-8.8.10-1.1.osg34.el7
condor-annex-ec2-8.8.10-1.1.osg34.el7
condor-bosco-8.8.10-1.1.osg34.el7
condor-classads-8.8.10-1.1.osg34.el7
condor-classads-devel-8.8.10-1.1.osg34.el7
condor-cream-gahp-8.8.10-1.1.osg34.el7
condor-debuginfo-8.8.10-1.1.osg34.el7
condor-kbdd-8.8.10-1.1.osg34.el7
condor-procd-8.8.10-1.1.osg34.el7
condor-test-8.8.10-1.1.osg34.el7
condor-vm-gahp-8.8.10-1.1.osg34.el7
frontier-squid-4.13-1.1.osg34.el7
minicondor-8.8.10-1.1.osg34.el7
osg-version-3.4.54-1.osg34.el7
python2-condor-8.8.10-1.1.osg34.el7
python3-condor-8.8.10-1.1.osg34.el7
```
