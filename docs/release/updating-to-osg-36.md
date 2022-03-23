!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, consult the
    [collaboration support tables](../security/tokens/overview.md#collaboration-support) to verify that your
    collaboration(s) support token-based authentication and/or WebDAV/XRootD-based data transfer before considering an
    upgrade to OSG 3.6.
    If your collaboration(s) don't support these new protocols, install or remain on the
    [OSG 3.5 release series, with the osg-upcoming repositories enabled](notes.md).

Updating to OSG 3.6
===================

[OSG 3.6](release_series.md#series-overviews) (the *new series*) is a major overhaul of the OSG software stack compared
to OSG 3.5 (the *old series*) with changes to core protocols used for authentication and data transfer.
See [this page](https://opensciencegrid.org/technology/policy/gridftp-gsi-migration/) for more details regarding this
transition.

Depending on the [collaboration(s) that you support](../security/tokens/overview.md#collaboration-support),
updating to the new series could result in issues with your site receiving pilot jobs and/or issues with data transfer.
See the list of services below for any special considerations for the OSG 3.6 update:

-   [Compute Entrypoints](../compute-element/htcondor-ce-overview.md) should be updated to OSG 3.6 with care:

    -   If your [collaboration(s)](../security/tokens/overview.md#pilot-job-submission) support bearer tokens,
        update your [OSG Compute Entrypoints](#updating-your-osg-compute-entrypoint) at your earliest convenience.

    -   If the collaborations that you support have NOT moved to bearer token pilot job submission, update to
        HTCondor-CE 5 available in [OSG 3.5 upcoming](updating-to-osg-35.md#updating-to-htcondor-ce-5) to help your
        collaborations transition to bearer tokens.

        !!! warning "OSG 3.5 end-of-life"
            OSG 3.5 support is scheduled to end on [May 1, 2022](https://opensciencegrid.org/technology/policy/release-series/#life-cycle-dates).
            If your collaboration does not yet support token-based pilot job submission, please contact them directly
            for their timeline.

-   XRootD will continue to support GSI and VOMS proxies in OSG 3.6 directly
    (instead of through Grid Community Toolkit libraries).
    Therefore, XRootD hosts (i.e., standalone installations, caches and origins) should be updated to
    [OSG 3.6](#updating-the-OSG-repositories) at your earliest convenience.

-   [GridFTP services](#replacing-your-gridftp-service) should be replaced with an installation of XRootD standalone.

-   [HTCondor pools and access points](#updating-your-htcondor-hosts) should be updated to OSG 3.6 at your earliest
    convenience.
    Note that any pools using GSI authentication will need to transition to a different authentication method, such as
    IDTOKENS.

-   All other services (e.g., OSG Worker Node clients, Frontier Squids) should be updated to
    [OSG 3.6](#updating-the-OSG-repositories) at your earliest convenience.

Updating the OSG Repositories
-----------------------------

!!! tip "Python 3 support"
    Many software packages, such as HTCondor and HTCondor-CE, use Python 3 scripts. If you are using Enterprise Linux 7,
    you must upgrade to at least version 7.8 for Python 3 support.

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

1.  Update your [Yum repositories](../common/yum.md#install-the-osg-repositories) to OSG 3.6

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

Updating Your OSG Compute Entrypoint
------------------------------------

!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, consult the
    [collaboration support tables](../security/tokens/overview.md#pilot-job-submission) to verify that your
    collaboration(s) support token-based authentication before considering an upgrade to OSG 3.6.
    If your collaboration(s) don't support these new authentication methods, install or remain on the
    [OSG 3.5 release series, with the osg-upcoming repositories enabled](notes.md)

In OSG 3.6, OSG Compute Entrypoints (CEs) only accept token-based pilot job submissions.
If you need to support token-based and GSI proxy-based pilot job submission,
you must install or remain on [OSG 3.5, with the osg-upcoming repositories enabled](notes.md).
If the collaborations that you support have the capability to submit token-based pilots, you may update your CE to OSG 3.6.

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

After turning off your CE's services, you may proceed with the [repository and RPM update process](#updating-the-osg-repositories).

### Updating CE configuration ###

#### Gratia Probe ####

The OSG 3.6 release series contains [Gratia Probe 2](https://github.com/opensciencegrid/gratia-probe/releases/tag/v2.0.0-2),
which uses the non-root HTCondor-CE probe to account for your site's resource contributions.
To ensure that your contributions continue to be properly accounted for,
perform the following steps based on the type of batch system running at your site.

##### HTCondor batch systems #####

After updating your `gratia-probe-*` packages,
verify the values of your HTCondor and HTCondor-CE `PER_JOB_HISTORY_DIR` configurations match the output below:

``` console
# condor_ce_config_val -v PER_JOB_HISTORY_DIR
Not defined: PER_JOB_HISTORY_DIR
 # at: <Default>
 # raw: PER_JOB_HISTORY_DIR = 

# condor_config_val -v PER_JOB_HISTORY_DIR
PER_JOB_HISTORY_DIR = /var/lib/condor-ce/gratia/data
 # at: /etc/condor/config.d/99-gratia.conf, line 5
 # raw: PER_JOB_HISTORY_DIR = /var/lib/condor-ce/gratia/data
```

- **If you see the above output**, your Gratia Probe configuration is correct and you may continue onto the
  [next section](#osg-configure).

- **If you do not see the above output**:

    1.  If the value of `condor_config_val -v PER_JOB_HISTORY_DIR` is not `/var/lib/condor-ce/gratia/data`
        note its value.
        Then visit the referenced file, remove the offending configuration and repeat until the output of
        `condor_config_val -v PER_JOB_HISTORY_DIR` matches the above output.

    1.  If the value of `condor_ce_config_val -v PER_JOB_HISTORY_DIR` is set,
        visit the referenced file and remove the offending configuration.
        Repeat until the output of `condor_ce_config_val -v PER_JOB_HISTORY_DIR` matches the above output.

    1.  If you noted a different value in step a, copy data from the old directory to the new directory and fix ensure
        that ownership is correct:

            :::console
            root@host # cp  <ORIGINAL DIR>/* /var/lib/condor-ce/gratia/data/
            root@host # chown -R condor:condor /var/lib/condor-ce/gratia/data/

        Replacing `<ORIGINAL_DIR>` with the value that you noted in step a.

##### Non-HTCondor batch systems #####

After updating your `gratia-probe-*` packages,
verify that your HTCondor-CE's `PER_JOB_HISTORY_DIR` is set to `/var/lib/condor-ce/gratia/data`:

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
        -   `site_policy`
        -   `contact`
        -   `email`
        -   `city`
        -   `country`
        -   `latitude`
        -   `longitude`

1.  Run osg-configure to apply your changes:

        osg-configure -dc


#### HTCondor-CE ####

!!! bug "Passing along non-HTCondor batch system directives"
    `default_CERequirements` in the the new Job Router ClassAd transform syntax is ignored.
    To fix this, apply the change in [this patch](https://github.com/htcondor/htcondor-ce/pull/530/files) to
    `/usr/share/condor-ce/config.d/01-ce-router-defaults.conf`.
    The next release of HTCondor-CE will contain this fix and will not require any additional action post-update.

The OSG 3.6 release series contains [HTCondor-CE 5](https://htcondor.github.io/htcondor-ce/v5/releases/), a major
version upgrade from HTCondor-CE 4, which was available in the OSG 3.5 release repositories.
To update HTCondor-CE, perform the following steps:

1.  If the collaboration(s) that you support submit token-based pilots and you map these pilots to non-default local
    Unix accounts:

    1.  Copy the relevant default mappings from `/usr/share/condor-ce/mapfiles.d/osg-scitokens-mapfile.conf` (provided
        by the `osg-scitokens-mapfile` package) to a file in `/etc/condor-ce/mapfiles.d/`
    1.  Replacing the third field with the local Unix account.

1.  Also consult the [upgrade documentation](https://htcondor.github.io/htcondor-ce/v5/releases/#updating-to-htcondor-ce-5)
    for other required configuration updates.

!!! note "For OSG CEs serving an HTCondor pool"
    If your OSG CE routes pilot jobs to a local HTCondor pool, also
    see the section for [updating your HTCondor hosts](#updating-your-htcondor-hosts)

### Starting CE services ###

After updating your RPMs and updating your configuration, turn on the HTCondor-CE service:

```console
root@host # systemctl start condor-ce
```

!!! question "What about `gratia-probes-cron`?"
    In OSG 3.6, the OSG CE no longer needs a separate service for Gratia Probe.
    Instead, the default CE configuration runs its Gratia Probe as a periodic process under the HTCondor-CE process tree.


Updating Your HTCondor Hosts
----------------------------

!!! warning "HTCondor-CE hosts"
    Consult [this section](#updating-your-osg-compute-entrypoint) before updating the `condor` package on your
    HTCondor-CE hosts.

If you are running an HTCondor pool, consult the following instructions to update to HTCondor from OSG 3.6.
Note that the version of HTCondor available in OSG 3.6 does not support GSI authentication.
If your pool is configured to authenticate with GSI, we recommend using HTCondor's "IDTOKENS" configuration for
host-to-host authentication.

1.  The following OSG specific configuration was dropped in anticipation of HTCondor's new secure by default
    configuration coming in HTCondor version 9.0. HTCondor's 9.0 recommended security configuration requires
    authentication for all access (including read access).

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

1.  Manual intervention may be required to upgrade from the HTCondor 8.8 series to HTCondor 9.0.x.
    Please consult the [HTCondor 9.0 upgrade instructions](https://htcondor.readthedocs.io/en/v9_0/version-history/upgrading-from-88-to-90-series.html).

1.  If you are upgrading from the HTCondor 8.9 series (8.9.11 and earlier), please consult the [Upgrading to 9.0 instructions](https://htcondor-wiki.cs.wisc.edu/index.cgi/wiki?p=UpgradingToNineDotZero)

Replacing Your GridFTP Service
------------------------------

!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, consult the
    [collaboration support tables](../security/tokens/overview.md#collaboration-support) to verify that your
    collaboration(s) support WebDAV/XRootD-based data transfer before considering an upgrade to OSG 3.6.
    If your collaboration(s) don't support these new protocols, install or remain on the
    [OSG 3.5 release series, with the osg-upcoming repositories enabled](notes.md).

!!! bug "VOMS attribute mappings incompatible with `xrootd-multiuser` in OSG 3.6"
    The OSG 3.6 configuration of XRootD uses the `XrdVoms` plugin, which pass along the entire VOMS FQAN as the
    groupname to the authorization layer (see the section on
    [authorization database file formatting](../data/xrootd/xrootd-authorization.md#formatting)).
    Some characters in VOMS FQANs are not legal in Unix usernames, therefore VOMS attributes mappings are incompatible
    with `xrootd-multiuser`.
    See [XRootD GitHub issue #1538](https://github.com/xrootd/xrootd/issues/1538) for more details.

As part of the [GridFTP and GSI migration](https://opensciencegrid.org/technology/policy/gridftp-gsi-migration/),
GridFTP is no longer available in the OSG 3.6 repositories.
If you need to continue to provide remote access to local storage at your site,
follow the instructions to install the OSG's configuration of [XRootD Standalone](../data/xrootd/install-standalone.md).

Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
