!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    OSG 3.6 is under active development and is not currently supported for production use.

    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](notes.md)

Updating to OSG 3.6
===================

[OSG 3.6](release_series.md#series-overviews) (the *new series*) is a major overhaul of the OSG software stack compared
to OSG 3.5 (the *old series*) with changes to core protocols used for authentication and data transfer.
Depending on the VO(s) that you support, updating to the new series could result in issues with your site receiving
pilot jobs and/or issues with data transfer.

If you have verified that your VO(s) support token-based pilot submission and HTTP-based data transfers,
use this document to update your OSG software to OSG 3.6.

Updating Your OSG Compute Entrypoint
------------------------------------

!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    OSG 3.6 is under active development and is not currently supported for production use.

    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](notes.md)

In OSG 3.6, OSG Compute Entrypoints (CEs) only accept token-based pilot job submissions.
If you need to support token-based and GSI proxy-based pilot job submission,
you must install or remain on [OSG 3.5](notes.md).
If the VOs that you support have the capability to submit token-based pilots, you may update your CE to OSG 3.6.

In addition to the change in authentication protocol, OSG 3.6 CEs include new major versions of software that require
manual updates.
To upgrade your CE to OSG 3.6, follow the sections below to make your configuration OSG 3.6-compatible.

### Turning off CE services ###

1.  Register a [downtime](../common/registration.md#registering-resource-downtimes)
1.  During the update, turn off the following services on your HTCondor-CE host:

        :::console
        root@host # systemctl stop condor-ce
        root@host # systemctl stop gratia-probes-cron

1.  Run the command corresponding to your batch system to upload any remaining accounting records to the GRACC:

    | If your batch system is... | Then run the following command...                 |
    |:---------------------------|:--------------------------------------------------|
    | HTCondor                   | `/usr/share/gratia/condor/condor_meter`           |
    | LSF                        | `/usr/share/gratia/lsf/lsf`                       |
    | PBS                        | `/usr/share/gratia/pbs-lsf/pbs-lsf_meter.cron.sh` |
    | SGE                        | `/usr/share/gratia/sge/sge_meter.cron.sh`         |
    | Slurm                      | `/usr/share/gratia/slurm/slurm_meter -c`          |

1.  Disable the `gratia-probes-cron` service:

        :::console
        root@host # systemctl disable gratia-probes-cron

### Updating CE packages ###

After turning off your CE's services, you may proceed with the RPM update process.

1.  First, remove the old series Yum repositories:

        :::console
        root@host # rpm -e osg-release

    This step ensures that any local modifications to `*.repo` files will not prevent installing the new series repos.
    Any modified `*.repo` files should appear under `/etc/yum.repos.d/` with the `*.rpmsave` extension.
    After installing the new OSG repositories (the next step) you may want to apply any changes made in the `*.rpmsave`
    files to the new `*.repo` files.

1.  Update your [Yum repositories](../common/yum.md#install-the-osg-repositories) to OSG 3.6

1.  Clean yum cache:

        :::console
        root@host # yum clean all --enablerepo=*

1. Update software:

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
            Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

### Updating CE configuration ###

#### Gratia Probe ####

The OSG 3.6 release series contains [Gratia Probe 2](https://github.com/opensciencegrid/gratia-probe/releases/tag/v2.0.0-2),
which uses the non-root HTCondor-CE probe to account for your site's resource contributions.
To ensure that your contributions continue to be properly accounted for, verify that your HTCondor-CE's
`PER_JOB_HISTORY_DIR` is set to `/var/lib/condor-ce/gratia/data`:

```console
root@host # condor_ce_config_val -v PER_JOB_HISTORY_DIR
PER_JOB_HISTORY_DIR = /var/lib/condor-ce/gratia/data
# at: /etc/condor-ce/config.d/99_gratia-ce.conf, line 5
# raw: PER_JOB_HISTORY_DIR = /var/lib/condor-ce/gratia/data
```

- **If you see the above output**, your Gratia Probe configuration is correct and you may continue onto the
  [next section](#osg-configure).

- **If you do not see the above output**, visit the file listed in the output of `condor_ce_config_val`, remove the
  offending value, and repeat until the proper value is returned.

#### OSG-Configure ####

The OSG 3.6 release series contains OSG-Configure 4, a major version upgrade from the previously released versions in the OSG.
See the [OSG-Configure 4.0.0 release notes](https://github.com/opensciencegrid/osg-configure/releases/tag/v4.0.0)
for an overview of the changes.
Several configuration modules and options were removed or deprecated and CE configuration has been simplified;
the update from version 3 to version 4 will require some manual changes to your configuration.

To update OSG-Configure, perform the following steps:

1.  Merge any `*.rpmnew` files in `/etc/osg/config.d/`

1.  Uninstall `osg-configure-gip` and `osg-configure-misc` if they are installed:

        :::console
        root@host# yum erase osg-configure-gip osg-configure-misc

1.  If `/etc/osg/config.d/30-gip.ini.rpmsave` exists, merge its contents into `31-cluster.ini`

1.  Edit the `Site Information` configuration section (in `40-siteinfo.ini`):
    -   If `resource_group` is not set, add:

                resource_group = <TOPOLOGY RESOURCE GROUP FOR THIS HOST>

    -   Delete the following attributes:
        -   `sponsor`
        -   `site_policy
        -   `contact`
        -   `email`
        -   `city`
        -   `country`
        -   `latitude`
        -   `longitude`

1.  Run osg-configure to apply your changes:

        osg-configure -dc


#### HTCondor-CE ####

The OSG 3.6 release series contains [HTCondor-CE 5](https://htcondor.github.io/htcondor-ce/v5/releases/), a major
version upgrade from HTCondor-CE 4, which was available in the OSG 3.5 release repositories.
To update HTCondor-CE, perform the following steps:

1.  Merge any `*.rpmnew` files in `/etc/condor-ce/`

1.  HTCondor-CE <= 4 set `$HOME` in the routed job to the user's `$HOME` directory on the HTCondor-CE but this is no
    longer the default.
    If you want to ensure that a routed job's `$HOME` is set to the same directory as the user on the CE,
    set `USE_CE_HOME_DIR = True` in `/etc/condor-ce/config.d/`.

!!! note "For OSG CEs serving an HTCondor pool"
    If your OSG CE routes pilot jobs to a local HTCondor pool, also
    see the section for [updating your HTCondor hosts](#updating-your-htcondor-hosts)

### Starting CE services ###

After updating your RPMs and updating your configuration, turn on the HTCondor-CE service:

```console
root@host # systemctl start condor-ce
```

!!! question "What about `gratia-probes-cron`?
    In OSG 3.6, the OSG CE no longer needs a separate service for Gratia Probe.
    Instead, the default CE configuration runs its Gratia Probe as a periodic process under the HTCondor-CE process tree.


Updating Your HTCondor Hosts
----------------------------

!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    OSG 3.6 is under active development and is not currently supported for production use.

    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](notes.md)

1.  The `ALLOW_DAEMON` permission no longer inherits from `ALLOW_WRITE`.
    To revert to the old behavior you can add ``ALLOW_DAEMON = ALLOW_WRITE``.
    However this is not recommended, since re-enabling this configuration means anyone that can submit jobs can also
    manipulate your HTCondor daemons.

1.  The following OSG specific configuration was dropped in anticipation of HTCondor's new secure by default
    configuration coming in HTCondor version 9.0.

        CONDOR_HOST = $(FULL_HOSTNAME)
        DAEMON_LIST = COLLECTOR, MASTER, NEGOTIATOR, SCHEDD, STARTD

        # require authentication and integrity for everything...
        SEC_DEFAULT_AUTHENTICATION=REQUIRED
        SEC_DEFAULT_INTEGRITY=REQUIRED

        # ...except read access...
        SEC_READ_AUTHENTICATION=OPTIONAL
        SEC_READ_INTEGRITY=OPTIONAL

        # ...and the outgoing (client side) connection since the server side will enforce its policy
        SEC_CLIENT_AUTHENTICATION=OPTIONAL
        SEC_CLIENT_INTEGRITY=OPTIONAL

        # this will required PASSWORD authentications for daemon-to-daemon, and
        # allow FS authentication for submitting jobs and running administrator commands
        SEC_DEFAULT_AUTHENTICATION_METHODS = FS, PASSWORD
        SEC_DAEMON_AUTHENTICATION_METHODS = PASSWORD
        SEC_NEGOTIATOR_AUTHENTICATION_METHODS = PASSWORD
        SEC_PASSWORD_FILE = /etc/condor/passwords.d/POOL

        # admin commands (e.g. condor_off) can be run by:
        #  1. root on the local host or the central manager
        #  2. condor user on the local host or the central manager
        ALLOW_ADMINISTRATOR = condor@*/$(FULL_HOSTNAME) condor@*/$(CONDOR_HOST) condor_pool@*/$(FULL_HOSTNAME) condor_pool@*/$(CONDOR_HOST)  root@$(UID_DOMAIN)/$(FULL_HOSTNAME)
        # only the condor daemons on the central manager can negotiate
        ALLOW_NEGOTIATOR = condor@*/$(CONDOR_HOST) condor_pool@*/$(CONDOR_HOST)
        # any authenticated daemons in the pool can read/write/advertise
        ALLOW_DAEMON = condor@* condor_pool@*

For more information about the HTCondor 8.9 series, consult the
    [upstream version history](https://htcondor.readthedocs.io/en/latest/version-history/development-release-series-89.html).

Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
