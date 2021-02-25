OSG Yum Repositories
====================

This document introduces Yum repositories and how they are used in the OSG.
If you are unfamiliar with Yum, see the [documentation on using Yum and RPM](../release/yum-basics.md).

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

-   OS repositories, including the following ones that aren't enabled by default:
    -   `extras` (SL 7, CentOS 7/8)
    -   `Server-Extras` (RHEL 7)
    -   `PowerTools` (CentOS 8.0 through 8.2)
    -   `powertools` (CentOS 8.3 and newer)
    -   `CodeReady Builder` (RHEL 8)
-   EPEL repositories
-   OSG repositories

If any of these repositories are missing, you may end up with installation issues or missing dependencies.

!!! danger
    Other repositories, such as `jpackage`, `dag`, or `rpmforge`, are not supported and you may encounter problems if
    you use them.

!!! note
    If you upgrade from CentOS 8.0 through 8.2 to CentOS 8.3 or newer,
    you may have to re-enable some repos as [described below](#centos-83-and-newer)

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
The rest of the packages will eventually form the basis of the next [OSG release series](../release/release_series.md)
(e.g. "OSG 3.5").

### Contrib Software

In addition to our regular software repositories, we also have a `contrib` (short for "contributed") software repository.
This is software that is does not go through the same software testing and release processes as the official OSG
Software release, but may be useful to you.
Particularly, contrib software is not guaranteed to be compatible with the rest of the OSG Software stack nor is it
supported by the OSG.

The definitive list of software in the contrib repository can be found here:

-   [OSG 3.5 EL8 contrib software repository](https://repo.opensciencegrid.org/osg/3.5/el8/contrib/x86_64/)
-   [OSG 3.5 EL7 contrib software repository](https://repo.opensciencegrid.org/osg/3.5/el7/contrib/x86_64/)

If you would like to distribute your software in the OSG `contrib` repository, please [contact us](../common/help.md) with a
description of your software, what users it serves, and relevant RPM packaging.

Installing Yum Repositories
---------------------------

### Install the Yum priorities plugin (EL7)

The Yum priorities plugin is used to tell Yum to prefer OSG packages over EPEL or OS packages.
It is important to install and enable the Yum priorities plugin before installing grid software to ensure that you are
getting the OSG-supported versions.

This plugin is built into Yum on EL8 distributions.

1.  Install the Yum priorities package:

        :::console
        root@host # yum install yum-plugin-priorities

1.  Ensure that `/etc/yum.conf` has the following line in the `[main]` section:

        :::file
        plugins=1

### Enable additional OS repositories

Some packages depend on packages that are in OS repositories not enabled by default.
The repositories to enable, as well as the instructions to enable them, are OS-dependent.

!!! note
    A repository is enabled if it has `enabled=1` in its definition,
    or if the `enabled` line is missing
    (i.e. it is enabled unless specified otherwise.)

#### SL 7

-   Install the `yum-conf-extras` RPM package.
-   Ensure that the `sl-extras` repo in `/etc/yum.repos.d/sl-extras.repo` is enabled.

#### CentOS 7

-   Ensure that the `extras` repo in `/etc/yum.repos.d/CentOS-Base.repo` is enabled.

#### CentOS 8.0 to 8.2

-   Ensure that the `extras` repo in `/etc/yum.repos.d/CentOS-Extras.repo` is enabled.
-   Ensure that the `PowerTools` repo in `/etc/yum.repos.d/CentOS-PowerTools.repo` is enabled.

#### CentOS 8.3 and newer

-   Ensure that the `extras` repo in `/etc/yum.repos.d/CentOS-Linux-Extras.repo` is enabled.
-   Ensure that the `powertools` repo in `/etc/yum.repos.d/CentOS-Linux-PowerTools.repo` is enabled.

#### RHEL 7

-   Ensure that the `Server-Extras` channel is enabled.

#### RHEL 8

-   Ensure that the `CodeReady Linux Builder` channel is enabled.
    See [Red Hat's instructions](https://access.redhat.com/articles/4348511#enable) on how to enable this repo.

### Install the EPEL repositories

OSG software depends on packages distributed via the [EPEL](https://fedoraproject.org/wiki/EPEL) repositories.
You must install and enable these first.

-   Install the EPEL repository, if not already present.  Choose the right version to match your OS version.

        :::console
        ## EPEL 7 (For RHEL 7, CentOS 7, and SL 7)
        root@host # yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
        ## EPEL 8 (For RHEL 8 and CentOS 8)
        root@host # yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

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
[release series document](../release/updating-to-osg-35.md).

1. Install the OSG repository for your OS version and the [OSG release series](../release/release_series.md) that you wish to
   use:

    - OSG 3.5 EL8:

            :::console
            root@host # yum install https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el8-release-latest.rpm

    - OSG 3.5 EL7:

            :::console
            root@host # yum install https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm

1. The only OSG repository enabled by default is the release one.
   If you want to [enable another one](#repositories) (e.g. `osg-testing`), then edit its file
   (e.g. `/etc/yum.repos.d/osg-testing.repo`) and change the `enabled` option from 0 to 1:

        :::file hl_lines="7"
        [osg-testing]
        name=OSG Software for Enterprise Linux 7 - Testing - $basearch
        #baseurl=https://repo.opensciencegrid.org/osg/3.5/el7/testing/$basearch
        mirrorlist=https://repo.opensciencegrid.org/mirror/osg/3.5/el7/testing/$basearch
        failovermethod=priority
        priority=98
        enabled=1
        gpgcheck=1
        gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG

Optional Configuration
----------------------

### Enable automatic security updates

For production services, we suggest only changing software versions during controlled downtime.
Therefore we recommend security-only automatic updates or disabling automatic updates entirely.

!!! note
    RHEL/CentOS 8 automatic updates are provided in the `dnf-automatic` RPM, which is not installed by default.

To enable only security related automatic updates:

-   On RHEL 7/SL 7, edit `/etc/yum/yum-cron.conf` and set `update_cmd = security`

-   On RHEL 8, edit `/etc/dnf/automatic.conf` and set `upgrade_type = security`

CentOS 7/8 does not support security-only automatic updates;
doing any of the above steps will prevent automatic updates from happening at all.

To disable automatic updates entirely:

-   On EL7, run:

        :::console
        root@host # service yum-cron stop

-   On EL8, run:

        :::console
        root@host # systemctl disable --now dnf-automatic.timer

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
    <RANDOM> * * * * root rsync -aH rsync://repo.opensciencegrid.org/osg/<OSG_RELEASE>/el7/development /var/www/html/osg/<OSG_RELEASE>/el7


Replace `<OSG_RELEASE>` with the OSG release you would like to use (e.g. `3.5`) and `<RANDOM>` with a number between 0
and 59.

On your worker node, you can replace the `baseurl` line of `/etc/yum.repos.d/osg.repo` with the appropriate URL for your
mirror.

If you are interested in having your mirror be part of the OSG's default set of mirrors,
[please file a support ticket](https://support.opensciencegrid.org/helpdesk/tickets/new).

Reference
---------

-   [Basic use of Yum](../release/yum-basics.md)

