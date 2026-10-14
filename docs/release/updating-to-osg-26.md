title: Updating to OSG 26

Updating to OSG 26
==================

This document provides instructions for upgrading to the OSG 26 series.
Please read through the instructions before upgrading.

!!! note "Updating from OSG <25"
    Instructions in this document pertain to updating from OSG 25 to OSG 26. If you are updating from OSG 24,
    see [Updating to OSG 25](../updating-to-osg-25)

!!! note "Upgrading XRootD on EL 9"
    If you use XRootD, for example on an OSDF Cache or Origin, or a Storage Element, or redirector,
    and your host is running EL 9, you must use EL 9.7 or newer due to an incompatibility between
    OpenSSL 3.0--3.3 and XRootD 6. EL8 and EL10 are not affected.

Updating the OSG Repositories
-----------------------------

1.  Consult the relevant section for the service you're upgrading before updating the OSG Yum repositories:

    -   [Compute Entrypoint](#updating-your-osg-compute-entrypoint)
    -   [HTCondor hosts](#updating-your-htcondor-hosts)
    -   [OSDF Cache or Origin](#updating-your-osdf-cache-or-origin)
    -   [GlideinWMS Frontend](#updating-your-glideinwms-frontend)

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

OSG 26 ships with the Pelican 26 series; note the following changes from 7.26 or earlier:

**All Servers**

-   The database schema has changed to support new user management features.
    Back up your database before upgrading; if you need to downgrade, you will need to restore the database from
    the backup.

    Run the following command to get the location of the database file:

        :::console
        $ pelican-server config get server.dblocation

    Then, use the following command to make a backup to a file named `pelicanbackup.sqlite`
    (replacing `DBLOCATION` with the path to the database file):

        :::console
        $ sqlite3 DBLOCATION ".backup 'pelicanbackup.sqlite'"

    To restore the backup, shut down the `osdf-server` service and overwrite the database with the backup file
    using the following (replacing `DBLOCATION` with the path to the database file):

        :::console
        $ systemctl stop osdf-server
        $ mv -f pelicanbackup.sqlite DBLOCATION


-   If you specify UI admins via `Server.UIAdminUsers` and use OIDC for web UI access, you will need to
    change the listed usernames to Pelican usernames.  **See the post-upgrade steps after upgrading the RPMs.**

    !!! note
        We recommend using admin groups instead of users ([Server.AdminGroups](https://docs.pelicanplatform.org/parameters#Server-AdminGroups))
        to simplify access management going forward.

Also note the changes if upgrading from 7.27 or earlier:

**Origins**

-   If you set `Origin.IssuerMode` to `oa4mp` in your configuration, you must change it to `embedded`.
    Support for the OA4MP issuer has been removed and replaced with a token issuer built into the Pelican server.

After making any necessary config changes and backups,
you may proceed with the [repository and RPM update process](#updating-the-osg-repositories),
then return here for post-upgrade steps.


**Post-upgrade**

If you specify UI admins via `Server.UIAdminUsers` and use OIDC for web UI access, do the following:

1.  Log in to the web interface using the `admin` username and web admin password.
    If you do not have a web admin password,
    follow the [instructions for setting the password](https://docs.pelicanplatform.org/advanced-concepts/server#web-interface-administrator-password).

2.  Go to the Settings page (the gear icon on the left), then "Users".
3.  Find the user names (in the User column) of the people that should have web admin access,
    and replace the `Server.UIAdminUsers` list with those user names.


Updating Your GlideinWMS Frontend
---------------------------------

Verify your frontend configuration and make the following change, if necessary,
before upgrading:

*   In the security section of your frontend configuration (`frontend.xml`),
    replace the `ProxyAll` plugin with `CredentialsBasic`.

You may proceed with the [repository and RPM update process](#updating-the-osg-repositories).


Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
