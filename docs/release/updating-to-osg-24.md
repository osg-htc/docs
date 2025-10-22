title: Updating to OSG 24

Updating to OSG 24
==================

[OSG 24](release_series.md#series-overviews) (the *new series*) introduces support for the ARM architecture. Changes
required to upgrade from OSG 23 are relatively minor.
Please update all services to OSG 24 as soon as possible.

Updating the OSG Repositories
-----------------------------

1.  Consult the relevant section for the service you're upgrading before updating the OSG Yum repositories:

    -   [Access Point](#updating-your-osg-access-point)
    -   [Compute Entrypoint](#updating-your-osg-compute-entrypoint)
    -   [HTCondor hosts](#updating-your-htcondor-hosts)
    -   [OSDF Origin](#updating-your-osdf-origin)

1.  Clean the yum cache:

        :::console
        root@host # yum clean all --enablerepo=*

1.  Remove the old series Yum repositories:

        :::console
        root@host # yum erase osg-release

    This step ensures that any local modifications to `*.repo` files will not prevent installing the new series repositories.
    Any modified `*.repo` files should appear under `/etc/yum.repos.d/` with the `*.rpmsave` extension.
    After installing the new OSG repositories (the next step) you may want to apply any changes made in the `*.rpmsave`
    files to the new `*.repo` files.

1.  Update your [Yum repositories](../common/yum.md#install-the-osg-repositories) to OSG 24

1.  Update software:

    !!! note
        Because configuration updates will be necessary, be sure to turn off any OSG services
        before updating them. Consult the sections below that match your situation.

            :::console
            root@host # yum update

    !!! warning
        -   Please be aware that running `yum update` may also update other RPMs.
            You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the
            `yum` command.
        -   Watch the yum update carefully for any messages about a `.rpmnew` file being created.
            That means that a configuration file had been edited, and a new default version was to be installed.
            In that case, RPM does not overwrite the edited configuration file but instead installs the new version with
            a `.rpmnew` extension.
            You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version
            into place (that is, without the `.rpmnew` extension).

1.  Continue on to any update instructions that match the role(s) that the host performs.

Updating Container-based OSPool EP Deployments
-----------------------------

In OSG 24, the `opensciencegrid/osgvo-docker-pilot` worker node docker image has been renamed to `osg-htc/ospool-ep`.
To upgrade your docker-based worker nodes from OSG 23 to OSG 24, follow the sections below:

#### Via Docker Run ####

For sites running the container [directly via docker](../resource-sharing/os-backfill-containers.md#running-the-container-with-docker),
the EP container can be updated by changing the image name referenced in the `docker run` command. All other arguments to the 
`docker run` command may remain the same. 

```console
root@host # docker run <existing docker args> hub.opensciencegrid.org/osg-htc/ospool-ep:24-release
```

#### Via RPM ####

For sites running the EP container [via rpm installation](../resource-sharing/os-backfill-containers.md#running-the-container-via-rpm),
the container can be upgraded by updating the RPM.

1. [Install](../common/yum.md#install-the-osg-repositories) the OSG 24 Yum repositories

1. Upgrade the `ospool-ep` rpm:

        :::console
        root@host # yum install ospool-ep

1. (Optional) Clean up `/etc/osg/ospool-ep.cfg`:
    - A bug in the OSG 23 release of ospool-ep required users to add a `WORK_TEMP_DIR` configuration field as a copy of the default `WORKER_TEMP_DIR`.
    When upgrading to OSG 24, remove the duplicated `WORK_TEMP_DIR` field.

1. Restart the ospool-ep systemctl service:

        :::console
        root@host # systemctl restart ospool-ep

Updating Your OSG Access Point
------------------------------

In OSG 24, some manual configuration changes may be required for an OSG Access Point (APs).

#### HTCondor ####

Consult the [HTCondor upgrade section](#updating-your-htcondor-hosts) for details on updating your HTCondor configuration.

### Restarting HTCondor ###

After updating your RPMs, restart your HTCondor service:

```console
root@host # systemctl restart condor
```

Updating Your OSG Compute Entrypoint
------------------------------------

The OSG 24 release series contains [HTCondor-CE 24](https://htcondor.github.io/htcondor-ce/v24/releases/).
HTCondor-CE 24 no longer accepts the original job router syntax.
If you have custom job routes, you must use the new, more flexible,
[ClassAd transform](https://htcondor.com/htcondor-ce/v24/configuration/job-router-overview/#classad-transforms)
job router syntax.

To upgrade your CE to OSG 24, follow the sections below.

### Check for possible incompatibilities ###

1.  Ensure that you have the latest HTCondor installed (at least HTCondor 23.10.2 or HTCondor 23.0.17).

1.  Run the `condor_ce_upgrade_check` script and address any issues found.

1.  If you have added custom job routes, make sure that you
    [convert](https://htcondor.com/htcondor-ce/v23/configuration/job-router-overview/#converting-to-classad-transforms)
    any jobs routes to the new, more flexible,
    [ClassAd transform](https://htcondor.com/htcondor-ce/v24/configuration/job-router-overview/#classad-transforms)
    syntax.

1.  If you have an HTCondor batch system, also run the `condor_upgrade_check` script and address any issues found.

1.  Also consult the [upgrade documentation](https://htcondor.github.io/htcondor-ce/v24/releases/#updating-to-htcondor-ce-24)
    for more information.

### Turning off CE services ###

1.  Register a [downtime](../common/registration.md#registering-resource-downtimes)

1.  Before the update, turn off the following services on your HTCondor-CE host:

        :::console
        root@host # systemctl stop condor-ce

### Updating CE packages ###

!!! note "For OSG CEs serving an HTCondor pool"
    If your OSG CE routes pilot jobs to a local HTCondor pool, also
    see the section for [updating your HTCondor hosts](#updating-your-htcondor-hosts)

After turning off your CE's services, you may proceed with the [repository and RPM update process](#updating-the-osg-repositories).

### Starting CE services ###

After updating your RPMs and updating your configuration, turn on the HTCondor-CE service:

    :::console
    root@host # systemctl start condor-ce

Updating Your HTCondor Hosts
----------------------------

!!! warning "HTCondor-CE hosts"
    Consult [this section](#updating-your-osg-compute-entrypoint) before updating the `condor` package on your
    HTCondor-CE hosts.

If you are running an HTCondor pool, consult the following instructions to update to HTCondor from OSG 23.

1.  Ensure that you have the latest HTCondor installed (at least HTCondor 23.10.2 or HTCondor 23.0.17).

1.  Run the `condor_upgrade_check` script and address any issues found.

1.  Also consult the [HTCondor 24.0 upgrade instructions](https://htcondor.readthedocs.io/en/24.0/version-history/upgrading-from-23-0-to-24-0-versions.html).

You may proceed with the [repository and RPM update process](#updating-the-osg-repositories).


Updating Your OSDF Origin
-------------------------

In OSG 24, the OSDF Origin has been updated to use the [Pelican Platform](https://pelicanplatform.org/).
To update your OSG 23 OSDF Origin, follow the instructions below to minimize service disruptions.

1.  Before installing the OSG 24 Yum repositories,
    update your OSG packages (see [warnings above](#updating-the-osg-repositories)):

        :::console
        root@host # yum update

1.  Follow the documentation in the [OSDF origin installation guide](../data/osdf/install-origin-rpm.md) and watch out
    for upgrade-specific instructions.


Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
