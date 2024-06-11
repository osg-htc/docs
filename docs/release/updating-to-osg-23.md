title: Updating to OSG 23

Updating to OSG 23
==================

[OSG 23](release_series.md#series-overviews) (the *new series*) aligns much more closely with HTCondor 23 and
HTCondor-CE 23.

-   [Compute Entrypoints](../compute-element/htcondor-ce-overview.md) should be updated to OSG 23 as soon as possible.

-   [HTCondor pools](#updating-your-htcondor-hosts) and [access points](#updating-your-osg-access-point) should be
    updated to OSG 23 as soon as possible.

-   All other services (e.g., OSG Worker Node clients, Frontier Squids) should be updated to
    [OSG 23](#updating-the-osg-repositories) as soon as possible.

Updating the OSG Repositories
-----------------------------

!!! note
    Before updating the OSG repository, be sure to turn off any OSG services. Consult the sections below
    that match your situation.

1.  Clean the yum cache:

        :::console
        root@host # yum clean all --enablerepo=*

1.  Disable to upcoming repository:

        :::console
        yum-config-manager --disable osg-upcoming

1.  Remove the old series Yum repositories:

        :::console
        root@host # rpm -e osg-release

    This step ensures that any local modifications to `*.repo` files will not prevent installing the new series repos.
    Any modified `*.repo` files should appear under `/etc/yum.repos.d/` with the `*.rpmsave` extension.
    After installing the new OSG repositories (the next step) you may want to apply any changes made in the `*.rpmsave`
    files to the new `*.repo` files.

1.  Update your [Yum repositories](../common/yum.md#install-the-osg-repositories) to OSG 23

1.  Update software:

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

Updating Your OSG Access Point
------------------------------

In OSG 23, some manual configuration changes may be required for an OSG Access Point (APs).

#### HTCondor ####

Consult the [HTCondor upgrade section](#updating-your-htcondor-hosts) for details on updating your HTCondor configuration.

### Restarting HTCondor ###

After updating your RPMs, restart your HTCondor service:

```console
root@host # systemctl restart condor
```

Updating Your OSG Compute Entrypoint
------------------------------------

The OSG 23 release series contains [HTCondor-CE 23](https://htcondor.github.io/htcondor-ce/v23/releases/), a minor
version upgrade from HTCondor-CE 6, which was available in the OSG 3.6 release repositories.

To upgrade your CE to OSG 23, follow the sections below.

### Check for possible incompatibilities ###

1.  Ensure that you have the latest HTCondor installed (either HTCondor 10.9.0 or HTCondor 10.0.9)

1.  Run the `condor_upgrade_check -ce` script and address any issues found.

1.  If you have an HTCondor batch system, also run the `condor_upgrade_check` script and address any issues found.

1.  Also consult the [upgrade documentation](https://htcondor.github.io/htcondor-ce/v23/releases/#updating-to-htcondor-ce-23)
    for more information.

### Turning off CE services ###

1.  Register a [downtime](../common/registration.md#registering-resource-downtimes)

1.  During the update, turn off the following services on your HTCondor-CE host:

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

1.  Ensure that you have the latest HTCondor installed (either HTCondor 10.9.0 or HTCondor 10.0.9).

1.  Run the `condor_upgrade_check` script and address any issues found.

1.  Also consult the [HTCondor 23.0 upgrade instructions](https://htcondor.readthedocs.io/en/23.0/version-history/upgrading-from-10-0-to-23-0-versions.html).

You may proceed with the [repository and RPM update process](#updating-the-osg-repositories).

Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
