title: Updating to OSG 25

Updating to OSG 25
==================

[OSG 25](release_series.md#series-overviews) (the *new series*) introduces support for EL10. Changes
required to upgrade from OSG 24 are relatively minor.
Please update all services to OSG 25 as soon as possible.

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

1.  Update your [Yum repositories](../common/yum.md#install-the-osg-repositories) to OSG 25

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

The OSG 25 release series contains [HTCondor-CE 25](https://htcondor.github.io/htcondor-ce/v25/releases/).

To upgrade your CE to OSG 25, follow the sections below.

1.  Ensure that you have the latest HTCondor installed (at least HTCondor 24.12.4 or HTCondor 24.0.13).

    !!! warning "New HTCondor Python Bindings"
        The initial version of the HTCondor Python bindings were removed in HTCondor 25.
        If you have any Python scripts using the HTCondor Python bindings, please refer to the
        [migration guide](https://htcondor.readthedocs.io/en/25.0/apis/python-bindings/api/version2/migration-guide.html).

1.  Run the `condor_ce_upgrade_check` script and address any issues found.

1.  If you have an HTCondor batch system, also run the `condor_upgrade_check` script and address any issues found.

1.  Also consult the [upgrade documentation](https://htcondor.github.io/htcondor-ce/v25/releases/#updating-to-htcondor-ce-25)
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

If you are running an HTCondor pool, consult the following instructions to update to HTCondor from OSG 24.

1.  Ensure that you have the latest HTCondor installed (at least HTCondor 24.12.4 or HTCondor 24.0.13).

    !!! warning "New HTCondor Python Bindings"
        The initial version of the HTCondor Python bindings were removed in HTCondor 25.
        If you have any Python scripts using the HTCondor Python bindings, please refer to the
        [migration guide](https://htcondor.readthedocs.io/en/25.0/apis/python-bindings/api/version2/migration-guide.html).

1.  Run the `condor_upgrade_check` script and address any issues found.

1.  Also consult the [HTCondor 25.0 upgrade instructions](https://htcondor.readthedocs.io/en/25.0/version-history/upgrading-from-24-0-to-25-0-versions.html).

You may proceed with the [repository and RPM update process](#updating-the-osg-repositories).


Updating Your OSDF Cache or Origin
----------------------------------

The `osdf-cache`, `osdf-origin`, `osdf-director`, and `osdf-registry` packages have been merged
into a single package named `osdf-server`.
In addition, the corresponding SystemD services have been renamed to `pelican-cache`,
`pelican-origin`, `pelican-director`, and `pelican-registry`.

After upgrading the RPMs using the [repository and RPM update process](#updating-the-osg-repositories),
you will need to be aware of the following configuration and service changes and, if you are using configuration management,
update the configuration files accordingly.

Note: `/etc/pelican/config.d` will contain template configuration files for both a cache and an origin;
ignore the files for the service you are not using.


### For all OSDF services

The default location for the host certificate chain has moved from `/etc/pki/tls/certs/pelican.crt`
to `/etc/pelican/certificates/tls.crt`.

The default location for the host key has moved from `/etc/pki/tls/private/pelican.key`
to `/etc/pelican/certificates/tls.key`.

To restore the previous locations, create a .yaml file in `/etc/pelican/config.d` containing:

```yaml
Server:
  TLSCertificateChain: /etc/pki/tls/certs/pelican.crt
  TLSKey: /etc/pki/tls/private/pelican.key
```


### For caches

1.  If you had any SystemD overrides for `osdf-cache` in `/etc/systemd/system/osdf-cache.service.d`,
    you must move them to `/etc/systemd/system/pelican-cache.service.d`.

1.  If you had a sysconfig file at `/etc/sysconfig/osdf-cache`, you must move it to `/etc/sysconfig/pelican-cache`.

1.  The default log file for a cache is now `/var/log/pelican/pelican-cache.log` instead of `/var/log/pelican/osdf-cache.log`.
    To restore the previous log file location, create a .yaml file in `/etc/pelican/config.d` containing:
    
        :::yaml
        Logging:
          LogLocation: /var/log/pelican/osdf-cache.log

1.  After making changes to the configuration, restart the service with `systemctl restart pelican-cache`.

The file `/etc/pelican/osdf-cache.yaml` has been replaced with `/etc/pelican/pelican-cache.yaml`.
Note that you should not edit `/etc/pelican/pelican-cache.yaml` --
all configuration changes should be made in `/etc/pelican/config.d`.

### For origins

1.  If you had any SystemD overrides for `osdf-origin` in `/etc/systemd/system/osdf-origin.service.d`,
    you must move them to `/etc/systemd/system/pelican-origin.service.d`.

1.  If you had a sysconfig file at `/etc/sysconfig/osdf-origin`, you must move it to `/etc/sysconfig/pelican-origin`.

1.  The default log file for a cache is now `/var/log/pelican/pelican-origin.log` instead of `/var/log/pelican/osdf-origin.log`.
    To restore the previous log file location, create a .yaml file in `/etc/pelican/config.d` containing:
    
        :::yaml
        Logging:
          LogLocation: /var/log/pelican/osdf-origin.log

1.  After making changes to the configuration, restart the service with `systemctl restart pelican-origin`.

The file `/etc/pelican/osdf-origin.yaml` has been replaced with `/etc/pelican/pelican-origin.yaml`.
Note that you should not edit `/etc/pelican/pelican-origin.yaml` --
all configuration changes should be made in `/etc/pelican/config.d`.


Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
