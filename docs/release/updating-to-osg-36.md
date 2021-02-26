Updating to OSG 3.6
===================



Updating Your OSG Compute Entrypoint
------------------------------------

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

1.  Update your [Yum repositories](../common/yum/#install-the-osg-repositories) to OSG 3.6

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

1.  Edit the `Site Information` configuration section (in `40-siteinfo.ini`).
    If `resource_group` is not set, add:

        resource_group = <TOPOLOGY RESOURCE GROUP FOR THIS HOST>

1.  Run osg-configure to apply your changes:

        osg-configure -dc


#### HTCondor-CE ####

AI (BrianL): https://opensciencegrid.atlassian.net/browse/SOFTWARE-4501
HTCondor-CE in front of HTCondor CE, [see updating your HTCondor Hosts](#updating-your-htcondor-hosts)

### Starting CE services ###


Updating Your HTCondor Hosts
----------------------------

TimT: Insert text for updates to HTCondor (https://opensciencegrid.atlassian.net/browse/SOFTWARE-4508)
