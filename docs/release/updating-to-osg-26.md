title: Updating to OSG 26

Updating to OSG 26
==================

[OSG 26](release_series.md#series-overviews) (the *new series*) introduces support for EL10. Changes
required to upgrade from OSG 25 are relatively minor.
Please update all services to OSG 26 as soon as possible.

!!! note "Updating from OSG <25"
    Instructions in this document pertain to updating from OSG 25 to OSG 26. If you are updating from OSG 24,
    see [Updating to OSG 25](../updating-to-osg-25)

Updating the OSG Repositories
-----------------------------

1.  Consult the relevant section for the service you're upgrading before updating the OSG Yum repositories:

    -   [Compute Entrypoint](#updating-your-osg-compute-entrypoint)
    -   [HTCondor hosts](#updating-your-htcondor-hosts)
    -   [OSDF Cache or Origin](#updating-your-osdf-cache-or-origin)

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

1.  Update your [Yum repositories](../common/yum.md#install-the-osg-repositories) to OSG 26

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

Updating Your OSG Compute Entrypoint
------------------------------------

The OSG 26 release series contains [HTCondor-CE 26](https://htcondor.github.io/htcondor-ce/v26/releases/).

To upgrade your CE to OSG 26, follow the sections below.

1.  Ensure that you have the latest HTCondor installed (at least HTCondor 25.15.15 or HTCondor 25.0.15).

1.  Run the `condor_ce_upgrade_check` script and address any issues found.

1.  If you have an HTCondor batch system, also run the `condor_upgrade_check` script and address any issues found.

1.  Also consult the [upgrade documentation](https://htcondor.github.io/htcondor-ce/v26/releases/#updating-to-htcondor-ce-26)
    for more information.

!!! note "For OSG CEs serving an HTCondor pool"
    If your OSG CE routes pilot jobs to a local HTCondor pool, also
    see the section for [updating your HTCondor hosts](#updating-your-htcondor-hosts)

You may proceed with the [repository and RPM update process](#updating-the-osg-repositories).

Updating Your HTCondor Hosts
----------------------------

!!! warning "HTCondor-CE hosts"
    Consult [this section](#updating-your-osg-compute-entrypoint) before updating the `condor` package on your
    HTCondor-CE hosts.

If you are running an HTCondor pool, consult the following instructions to update to HTCondor from OSG 25.

1.  Ensure that you have the latest HTCondor installed (at least HTCondor 25.15.15 or HTCondor 25.0.15).

1.  Run the `condor_upgrade_check` script and address any issues found.

1.  Also consult the [HTCondor 26.0 upgrade instructions](https://htcondor.readthedocs.io/en/26.0/version-history/upgrading-from-25-0-to-26-0-versions.html).

You may proceed with the [repository and RPM update process](#updating-the-osg-repositories).


Updating Your OSDF Cache or Origin
----------------------------------

Upgrade the `osdf-server` RPM using the [repository and RPM update process](#updating-the-osg-repositories).

Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
