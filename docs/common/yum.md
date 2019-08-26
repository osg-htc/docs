OSG Yum Repositories
====================

This document introduces Yum repositories and how they are used in the OSG.
If you are unfamiliar with Yum, see the [documentation on using Yum and RPM](/release/yum-basics).

Repositories
------------

The OSG hosts multiple repositories at [repo.opensciencegrid.org](https://repo.opensciencegrid.org/osg/) that are
intended for public use:

| The OSG Yum repository...                                                                  | Contains RPMs that...                                                                                                                |
|--------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| `osg`                                                                                      | are considered production-ready (default).                                                                                           |
| `osg-rolling`                                                                              | are considered production-ready but are released at faster pace than the `osg` repository.                                           |
| `osg-testing`                                                                              | have passed developer or integration testing but not acceptance testing                                                              |
| `osg-development`                                                                          | have not passed developer, integration or acceptance testing. Do not use without instruction from the OSG Software and Release Team. |
| `osg-upcoming`, `osg-upcoming-rolling`, `osg-upcoming-testing`, `osg-upcoming-development` | have newer versions that may require manual action after an update. See [this section](#upcoming-software) for details.              |
| `osg-contrib`                                                                              | have been contributed from outside of the OSG Software and Release Team. See [this section](#contrib-software) for details.          |

OSG's RPM packages also rely on external packages provided by supported OSes and EPEL.
You must have the following repositories available and enabled:

-   OS repositories (SL 6/7, CentOS 6/7, or RHEL 6/7 repositories, including "extras" repositories)
-   EPEL repositories
-   OSG repositories

If any of these repositories are missing, you may end up with installation issues or missing dependencies.

!!! danger
    Other repositories, such as `jpackage`, `dag`, or `rpmforge`, are not supported and you may encounter problems if
    you use them.

### Upcoming Software

Certain sites have requested new versions of software that would be considered "disruptive" or "experimental":
upgrading to them would likely require manual intervention after their installation.
We do not want sites to unwittingly upgrade to these versions.
For the benefit of the sites that are interested in upgrading to these versions, we want to provide the same assurance
of quality and production-readiness that we guarantee for the `osg` release repository.

Due to the relatively small number of such packages, a full fork of the OSG 3 distribution is not warranted.
Instead, we have created a separate set of repositories that contain only the "disruptive" versions of the software.

These repositories have the same structure as our standard repositories.
For example, there are `osg-upcoming-testing` and `osg-upcoming` repositories, which are analagous to the `osg-testing`
and `osg` repositories, respectively.

A full installation of our software stack is *not* possible using only the `osg-upcoming` repositories, since they
contain a small subset of the software we ship.
Both the main `osg` and the `osg-upcoming` repositories will need to be enabled for the installation to work.
Because of this, interoperability will be maintained between the main `osg` and `osg-upcoming`.

Depending on test results from sites, some packages in `osg-upcoming` may eventually end up in the main `osg` branch.
The rest of the packages will eventually form the basis of the next [OSG release series](/release/release_series)
(e.g. "OSG 3.5").

### Contrib Software

In addition to our regular software repositories, we also have a `contrib` (short for "contributed") software repository.
This is software that is does not go through the same software testing and release processes as the official OSG
Software release, but may be useful to you.
Particularly, contrib software is not guaranteed to be compatible with the rest of the OSG Software stack nor is it
supported by the OSG.

The definitive list of software in the contrib repository can be found here:

-   [OSG 3.4 EL6 contrib software repository](http://repo.opensciencegrid.org/osg/3.4/el6/contrib/x86_64/)
-   [OSG 3.4 EL7 contrib software repository](http://repo.opensciencegrid.org/osg/3.4/el7/contrib/x86_64/)

If you would like to distribute your software in the OSG `contrib` repository, please [contact us](/common/help) with a
description of your software, what users it serves, and relevant RPM packaging.

Installing Yum Repositories
---------------------------

### Install the Yum priorities plugin

The Yum priorities plugin is used to tell Yum to prefer OSG packages over EPEL or OS packages.
It is important to install and enable the Yum priorities plugin before installing grid software to ensure that you are
getting the OSG-supported versions.

1.  Install the Yum priorities package:

        :::console
        root@host # yum install yum-plugin-priorities

1.  Ensure that `/etc/yum.conf` has the following line in the `[main]` section:

        :::file
        plugins=1

### Enable the "extras" OS repositories

Some packages depend on packages in the "extras" repositories of your OS,
so you must ensure that those repositories are enabled.

The instructions for this vary based on your OS:

- On Scientific Linux, install the `yum-conf-extras` RPM package,
  and ensure that the `sl-extras` repo in `/etc/yum.repos.d/sl-extras.repo` is enabled.
  
- On CentOS, ensure that the `extras` repo in `/etc/yum.repos.d/CentOS-Base.repo` is enabled.

- On Red Hat Enterprise Linux, ensure that the `Server-Extras` channel is enabled.

!!! note
    A repository is enabled if it has `enabled=1` in its definition,
    or if the `enabled` line is missing
    (i.e. it is enabled unless specified otherwise.)

### Install the EPEL repositories

OSG software depends on packages distributed via the [EPEL](http://fedoraproject.org/wiki/EPEL) repositories.
You must install and enable these first.

-   Install the EPEL repository, if not already present.  Choose the right version to match your OS version.

        :::console
        ## EPEL 6 (For RHEL 6, CentOS 6, and SL 6)
        root@host # yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
        ## EPEL 7 (For RHEL 7, CentOS 7, and SL 7)
        root@host # yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

-   Verify that `/etc/yum.repos.d/epel.repo` exists; the `[epel]` section should contain:

    -   The line `enabled=1`

    -   Either no `priority` setting, or a `priority` setting that is 99 or higher

!!! warning
    If you have your own mirror or configuration of the EPEL repository, you **MUST** verify that the priority of the
    EPEL repository is either missing, or 99 or a higher number.
    The OSG repositories must have a better (numerically lower) priority than the EPEL repositories;
    otherwise, you might have dependency resolution ("depsolving") issues.

### Install the OSG Repositories

This document assumes a fresh install.
For instructions on upgrading from one OSG series to another, see the
[release series document](/release/release_series#updating-from-old).

Install the OSG repositories:

    :::console
    ## EPEL 6 (For RHEL 6, CentOS 6, and SL 6)
    root@host # yum install https://repo.opensciencegrid.org/osg/3.4/osg-3.4-el6-release-latest.rpm
    ## EPEL 7 (For RHEL 7, CentOS 7, and SL 7)
    root@host # yum install https://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm

The only OSG repository enabled by default is the release one.
If you want to [enable another one](#repositories) (e.g. `osg-testing`), then edit its file
(e.g. `/etc/yum.repos.d/osg-testing.repo`) and change the `enabled` option from 0 to 1:

``` file hl_lines="7"
[osg-testing]
name=OSG Software for Enterprise Linux 7 - Testing - $basearch
#baseurl=https://repo.opensciencegrid.org/osg/3.4/el7/testing/$basearch
mirrorlist=https://repo.opensciencegrid.org/mirror/osg/3.4/el7/testing/$basearch
failovermethod=priority
priority=98
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
```

Optional Configuration
----------------------

### Enable automatic security updates

For production services, we suggest only changing software versions during controlled downtime.
Therefore we recommend security-only automatic updates or disabling automatic updates entirely.


To enable only security related automatic updates:

-   On Enterprise Linux 6, edit `/etc/sysconfig/yum-autoupdate` and set `USE_YUMSEC="true"`

-   On Enterprise Linux 7, edit `/etc/yum/yum-cron.conf` and set `update_cmd = security`


To disable automatic updates entirely:

-   On Enterprise Linux 6, edit `/etc/sysconfig/yum-autoupdate` and set `ENABLED="false"`

-   On Enterprise Linux 7, run:

        :::console
        root@host # service yum-cron stop

### Configuring Spacewalk priorities ###

Sites using [Spacewalk](https://spacewalkproject.github.io/) to manage RPM packages will need to configure OSG Yum
repository priorities using their Spacewalk ID. For example, if the OSG 3.4 repository's Spacewalk ID is
`centos_7_osg34_dev`, modify `/etc/yum/pluginconf.d/90-osg.conf` to include the following:

```
[centos_7_osg_34_dev]
priority = 98
```

Repository Mirrors
------------------

If you run a large site (>20 nodes), you should consider setting up a local mirror for the OSG repositories.
A local Yum mirror allows you to reduce the amount of external bandwidth used when updating or installing packages.

Add the following to a file in `/etc/cron.d`:

    :::file
    <RANDOM> * * * * root rsync -aH rsync://repo.opensciencegrid.org/osg/ /var/www/html/osg/

Or, to mirror only a single repository:

    :::file
    <RANDOM> * * * * root rsync -aH rsync://repo.opensciencegrid.org/osg/<OSG_RELEASE>/el6/development /var/www/html/osg/<OSG_RELEASE>/el6


Replace `<OSG_RELEASE>` with the OSG release you would like to use (e.g. `3.4`) and `<RANDOM>` with a number between 0
and 59.

On your worker node, you can replace the `baseurl` line of `/etc/yum.repos.d/osg.repo` with the appropriate URL for your
mirror.

If you are interested in having your mirror be part of the OSG's default set of mirrors,
[please file a support ticket](https://support.opensciencegrid.org/helpdesk/tickets/new).

Reference
---------

-   [Basic use of Yum](/release/yum-basics.md)

