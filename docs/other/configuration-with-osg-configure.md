title: Configuration with OSG-Configure

Configuration with OSG-Configure
================================

OSG-Configure and the INI files in `/etc/osg/config.d` allow a high level configuration of OSG services.
This document outlines the settings and options found in the INI files for system administers that are installing and configuring OSG software.

This page gives an overview of the options for each of the sections of the configuration files that `osg-configure` uses.


Invocation and script usage
---------------------------

The `osg-configure` script is used to process the INI files and apply changes to the system.
`osg-configure` must be run as root.

The typical workflow of OSG-Configure is to first edit the INI files, then verify them, then apply the changes.

To verify the config files, run:
``` console
[root@server] osg-configure -v
```

OSG-Configure will list any errors in your configuration, usually including the section and option where the problem is.
Potential problems are:

-   Required option not filled in
-   Invalid value
-   Syntax error
-   Inconsistencies between options

To apply changes, run:
``` console
[root@server] osg-configure -c
```

If your INI files do not change, then re-running `osg-configure -c` will result in the same configuration as when you ran it the last time.
This allows you to experiment with your settings without having to worry about messing up your system.

OSG-Configure is split up into modules. Normally, all modules are run when calling `osg-configure`.
However, it is possible to run specific modules separately.
To see a list of modules, including whether they can be run separately, run:
``` console
[root@server] osg-configure -l
```
If the module can be run separately, specify it with the `-m <MODULE>` option, where `<MODULE>` is one of the items
of the output of the previous command.

``` console
[root@server] osg-configure -c -m <MODULE>
```

Options may be specified in multiple INI files, which may make it hard to determine which value OSG-Configure uses.
You may query the final value of an option via one of these methods:
``` console
[root@server] osg-configure -q -o <OPTION>
[root@server] osg-configure -q -o <SECTION>.<OPTION>
```

Where `<OPTION>` is the variable from which we want to know the value and `<SECTION>` refers to a section in any of the INI
files, i.e. any name between brackets e.g. `[Squid]`.

Logs are written to `/var/log/osg/osg-configure.log`.
If something goes wrong, specify the `-d` flag to add more verbose output to `osg-configure.log`.

The rest of this document will detail what to specify in the INI files.


### Conventions ###

In the tables below:

-   Mandatory options for a section are given in **bold** type. Sometime the default value may be OK and no edit required, but the variable has to be in the file.
-   Options that are not found in the default ini file are in *italics*.



Syntax and layout
-----------------

The configuration files used by `osg-configure` are the one supported by Python's [configparser](https://docs.python.org/library/configparser.html), similar in format to the [INI configuration file](https://en.wikipedia.org/wiki/INI_file) used by MS Windows:

-   Config files are separated into sections, specified by a section name in square brackets (e.g. `[Section 1]`)
-   Options should be set using `name = value` pairs
-   Lines that begin with `;` or `#` are comments
-   Long lines can be split up using continutations: each white space character can be preceded by a newline to fold/continue the field on a new line (same syntax as specified in [email RFC 822](https://tools.ietf.org/html/rfc822.html))
-   Variable substitutions are supported -- [see below](#variable-substitution)

`osg-configure` reads and uses all of the files in `/etc/osg/config.d` that have a ".ini" suffix. The files in this directory are ordered with a numeric prefix with higher numbers being applied later and thus having higher precedence (e.g. 00-foo.ini has a lower precedence than 99-local-site-settings.ini). Configuration sections and options can be specified multiple times in different files. E.g. a section called `[PBS]` can be given in `20-pbs.ini` as well as `99-local-site-settings.ini`.

Each of the files are successively read and merged to create a final configuration that is then used to configure OSG software. Options and settings in files read later override the ones in previous files. This allows admins to create a file with local settings (e.g. `99-local-site-settings.ini`) that can be read last and which will be take precedence over the default settings in configuration files installed by various RPMs and which will not be overwritten if RPMs are updated.


### Variable substitution ###

The osg-configure parser allows variables to be defined and used in the configuration file:
any option set in a given section can be used as a variable in that section.  Assuming that you have set an option with the name `myoption` in the section, you can substitute the value of that option elsewhere in the section by referring to it as `%(myoption)s`.

!!! note
    The trailing `s` is required. Also, option names cannot have a variable subsitution in them.

### Special Settings ###

If a setting is set to UNAVAILABLE or DEFAULT or left blank, osg-configure will try to use a sensible default for setting if possible.

#### Ignore setting ####

The `enabled` option, specifying whether a service is enabled or not, is a boolean but also accepts `Ignore` as a possible value. Using Ignore, results in the service associated with the section being ignored entirely (and any configuration is skipped). This differs from using `False` (or the `%(disabled)s` variable), because using `False` results in the service associated with the section being disabled. `osg-configure` will not change the configuration of the service if the `enabled` is set to `Ignore`.

This is useful, if you have a complex configuration for a given that can't be set up using the ini configuration files. You can manually configure that service by hand editing config files, manually start/stop the service and then use the `Ignore` setting so that `osg-configure` does not alter the service's configuration and status.




Configuration sections
----------------------

The OSG configuration is divided into sections with each section starting with a section name in square brackets (e.g. `[Section 1]`). The configuration is split in multiple files and options form one section can be in more than one files.

The following sections give an overview of the options for each of the sections of the configuration files that `osg-configure` uses.



### Bosco ###

This section is contained in `/etc/osg/config.d/20-bosco.ini` which is provided by the `osg-configure-bosco` RPM.

| Option       | Values Accepted           | Explanation                                                                                                                                                                                                                                                                                                                   |
|--------------|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **enabled**  | `True`, `False`, `Ignore` | This indicates whether the Bosco jobmanager is being used or not.                                                                                                                                                                                                                                                             |
| **users**    | String                    | A comma separated string. The existing usernames on the CE for which to install Bosco and allow submissions. In order to have separate usernames per VO, for example the CMS VO to have the cms username, each user must have Bosco installed. The osg-configure service will install Bosco on each of the users listed here. |
| **endpoint** | String                    | The remote cluster submission host for which Bosco will submit jobs to the scheduler. This is in the form of <user@example.com>, exactly as you would use to ssh into the remote cluster.                                                                                                                                     |
| **batch**    | String                    | The type of scheduler installed on the remote cluster.                                                                                                                                                                                                                                                                        |
| **ssh\_key** | String                    | The location of the ssh key, as created above.                                                                                                                                                                                                                                                                                |


### Condor ###

This section describes the parameters for a Condor jobmanager if it's being used in the current CE installation. If Condor is not being used, the `enabled` setting should be set to `False`.

This section is contained in `/etc/osg/config.d/20-condor.ini` which is provided by the `osg-configure-condor` RPM.

| Option            | Values Accepted           | Explanation                                                                                                                                                                                                                                                                                                                            |
|-------------------|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **enabled**       | `True`, `False`, `Ignore` | This indicates whether the Condor jobmanager is being used or not.                                                                                                                                                                                                                                                                     |
| condor\_location  | String                    | This should be set to be directory where condor is installed. If this is set to a blank variable, DEFAULT or UNAVAILABLE, the `osg-configure` script will try to get this from the CONDOR\_LOCATION environment variable if available otherwise it will use `/usr` which works for the RPM installation.                               |
| condor\_config    | String                    | This should be set to be path where the condor\_config file is located. If this is set to a blank variable, DEFAULT or UNAVAILABLE, the `osg-configure` script will try to get this from the CONDOR\_CONFIG environment variable if available otherwise it will use `/etc/condor/condor_config`, the default for the RPM installation. |


### LSF ###

This section describes the parameters for a LSF jobmanager if it's being used in the current CE installation. If LSF is not being used, the `enabled` setting should be set to `False`.

This section is contained in `/etc/osg/config.d/20-lsf.ini` which is provided by the `osg-configure-lsf` RPM.

| Option             | Values Accepted           | Explanation                                                     |
|--------------------|---------------------------|-----------------------------------------------------------------|
| **enabled**        | `True`, `False`, `Ignore` | This indicates whether the LSF jobmanager is being used or not. |
| lsf\_location      | String                    | This should be set to be directory where lsf is installed       |


### PBS ###

This section describes the parameters for a pbs jobmanager if it's being used in the current CE installation. If PBS is not being used, the `enabled` setting should be set to `False`.

This section is contained in `/etc/osg/config.d/20-pbs.ini` which is provided by the `osg-configure-pbs` RPM.

| Option                         | Values Accepted           | Explanation                                                                                                                               |
|--------------------------------|---------------------------|-------------------------------------------------------------------------------------------------------------------------------------------|
| **enabled**                    | `True`, `False`, `Ignore` | This indicates whether the PBS jobmanager is being used or not.                                                                           |
| pbs\_location                  | String                    | This should be set to be directory where pbs is installed. osg-configure will try to loocation for the pbs binaries in pbs\_location/bin. |
| **accounting\_log\_directory** | String                    | This setting is used to tell Gratia where to find your accounting log files, and it is required for proper accounting.                    |
| pbs\_server                    | String                    | This setting is optional and should point to your PBS server node if it is different from your OSG CE                                     |


### SGE ###

This section describes the parameters for a SGE jobmanager if it's being used in the current CE installation. If SGE is not being used, the `enabled` setting should be set to `False`.

This section is contained in `/etc/osg/config.d/20-sge.ini` which is provided by the `osg-configure-sge` RPM.

| Option            | Values Accepted           | Explanation                                                                                                                                                            |
|-------------------|---------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **enabled**       | `True`, `False`, `Ignore` | This indicates whether the SGE jobmanager is being used or not.                                                                                                        |
| **sge\_root**     | String                    | This should be set to be directory where sge is installed (e.g. same as **$SGE\_ROOT** variable).                                                                      |
| **sge\_cell**     | String                    | The sge\_cell setting should be set to the value of $SGE\_CELL for your SGE install.                                                                                   |


### Slurm ###

This section describes the parameters for a Slurm jobmanager if it's being used in the current CE installation. If Slurm is not being used, the `enabled` setting should be set to `False`.

This section is contained in `/etc/osg/config.d/20-slurm.ini` which is provided by the `osg-configure-slurm` RPM.

| Option              | Values Accepted           | Explanation                                                                                                                                       |
|---------------------|---------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| **enabled**         | `True`, `False`, `Ignore` | This indicates whether the Slurm jobmanager is being used or not.                                                                                 |
| **slurm\_location** | String                    | This should be set to be directory where slurm is installed. osg-configure will try to location for the slurm binaries in slurm\_location/bin.    |
| db\_host            | String                    | Hostname of the machine hosting the SLURM database. This information is needed to configure the SLURM gratia probe.                               |
| db\_port            | String                    | Port of where the SLURM database is listening. This information is needed to configure the SLURM gratia probe.                                    |
| db\_user            | String                    | Username used to access the SLURM database. This information is needed to configure the SLURM gratia probe.                                       |
| db\_pass            | String                    | The location of a file containing the password used to access the SLURM database. This information is needed to configure the SLURM gratia probe. |
| db\_name            | String                    | Name of the SLURM database. This information is needed to configure the SLURM gratia probe.                                                       |
| slurm\_cluster      | String                    | The name of the Slurm cluster                                                                                                                     |


### Gratia ###

This section configures Gratia. If `probes` is set to `UNAVAILABLE`, then `osg-configure` will use appropriate default values. If you need to specify custom reporting (e.g. a local gratia collector) in addition to the default probes, `%(osg-jobmanager-gratia)s`, and `%(itb-jobmanager-gratia)s` are defined in the default configuration files to make it easier to specify the standard osg reporting.

This section is contained in `/etc/osg/config.d/30-gratia.ini` which is provided by the `osg-configure-gratia` RPM.

| Option       | Values Accepted            | Explanation                                                                                                                           |
|--------------|----------------------------|---------------------------------------------------------------------------------------------------------------------------------------|
| **enabled**  | `True` , `False`, `Ignore` | This should be set to True if gratia should be configured and enabled on the installation being configured.                           |
| **resource** | String                     | This should be set to the resource name as given in the OIM registration                                                              |
| **probes**   | String                     | This should be set to the gratia probes that should be enabled. A probe is specified by using as `[probe_type]:server:port`. See note |

!!! note
    **probes**:<br/>
    Legal values for `probe_type` are:

    -   `jobmanager` (for the HTCondor-CE probe)


### Info Services ###

Reporting to the central CE Collectors is configured in this section.  In the majority of cases, this file can be left untouched; you only need to configure this section if you wish to report to your own CE Collector instead of the ones run by OSG Operations.

This section is contained in `/etc/osg/config.d/30-infoservices.ini`, which is provided by the `osg-configure-infoservices` RPM. (This is for historical reasons.)

| Option        | Values Accepted           | Explanation                                                       |
|---------------|---------------------------|-------------------------------------------------------------------|
| **enabled**   | `True`, `False`, `Ignore` | True if reporting should be configured and enabled                |
| ce_collectors | String                    | The server(s) HTCondor-CE information should be sent to. See note |

!!! note
    **ce_collectors**:

    -   Set this to `DEFAULT` to report to the OSG Production or ITB servers (depending on your [Site Information](#site-information) configuration).
    -   Set this to `PRODUCTION` to report to the OSG Production servers
    -   Set this to `ITB` to report to the OSG ITB servers
    -   Otherwise, set this to the `hostname:port` of a host running a `condor-ce-collector` daemon


### Subcluster / Resource Entry for AGIS / GlideinWMS Entry ###

Subcluster and Resource Entry configuration is for reporting about the worker resources on your site. A **subcluster** is a homogeneous set of worker node hardware; a **resource** is a set of subcluster(s) with common capabilities that will be reported to the ATLAS AGIS system.

**At least one Subcluster, Resource Entry, or Pilot section** is required on a CE; please populate the information for all your subclusters. This information will be reported to a central collector and will be used to send GlideIns / pilot jobs to your site; having accurate information is necessary for OSG jobs to effectively use your resources.

These configuration files are provided by the `osg-configure-cluster` RPM.

This configuration uses multiple sections of the OSG configuration files:

-   [Subcluster\*](#subcluster-configuration) in `/etc/osg/config.d/31-cluster.ini`: options about homogeneous subclusters
-   [Resource Entry\*](#resource-entry-configuration-atlas-only) in `/etc/osg/config.d/31-cluster.ini`: options for specifying ATLAS queues for AGIS
-   [Pilot\*](#pilot-cms-and-osg-glideinwms-pilot-factories) in `/etc/osg/config.d/35-pilot.ini`: options for specifying queues for the CMS and OSG GlideinWMS factories

#### Notes for multi-CE sites. ####

If you would like to properly advertise multiple CEs per cluster, make sure that you:

-   Set the value of site\_name in the "Site Information" section to be the same for each CE.
-   Have the **exact** same configuration values for the Subcluster\* and Resource Entry\* sections in each CE.


#### Subcluster Configuration ####

Each homogeneous set of worker node hardware is called a **subcluster**. For each subcluster in your cluster, fill in the information about the worker node hardware by creating a new Subcluster section with a unique name in the following format: `[Subcluster CHANGEME]`, where CHANGEME is the globally unique subcluster name (yes, it must be a **globally** unique name for the whole grid, not just unique to your site. Get creative.)

| Option               | Values Accepted             | Explanation                                                                                        |
|----------------------|-----------------------------|----------------------------------------------------------------------------------------------------|
| **name**             | String                      | The same name that is in the Section label; it should be **globally unique**                       |
| **ram\_mb**          | Positive Integer            | Megabytes of RAM per node                                                                          |
| **cores\_per\_node** | Positive Integer            | Number of cores per node                                                                           |
| **allowed\_vos**     | Comma-separated List or `*` | The collaborations that are allowed to run jobs on this subcluster                                 |

The following attributes are optional:

| Option            | Values Accepted  | Explanation                                                                                                                |
|-------------------|------------------|----------------------------------------------------------------------------------------------------------------------------|
| max\_wall\_time   | Positive Integer | Maximum wall-clock time, in minutes, that a job is allowed to run on this subcluster. The default is 1440, or the equivalent of one day.
| queue             | String           | The queue to which jobs should be submitted in order to run on this subcluster                                             |
| extra\_transforms | Classad          | Transformation attributes which the HTCondor Job Router should apply to incoming jobs so they can run on this subcluster   |


#### Resource Entry Configuration (ATLAS only) ####

If you are configuring a CE for the ATLAS VO, you must provide hardware information to advertise the queues that are available to AGIS. For each queue, create a new `Resource Entry` section with a unique name in the following format: `[Resource Entry RESOURCE]` where RESOURCE is a globally unique resource name (it must be a **globally** unique name for the whole grid, not just unique to your site). The following options are required for the `Resource Entry` section and are used to generate the data required by AGIS:

| Option                                    | Values Accepted             | Explanation                                                                                      |
|-------------------------------------------|-----------------------------|--------------------------------------------------------------------------------------------------|
| **name**                                  | String                      | The same name that is in the `Resource Entry` label; it must be **globally unique**              |
| **max\_wall\_time**                       | Positive Integer            | Maximum wall-clock time, in minutes, that a job is allowed to run on this resource               |
| **queue**                                 | String                      | The queue to which jobs should be submitted to run on this resource                              |
| **cpucount** (alias **cores\_per\_node**) | Positive Integer            | Number of cores that a job using this resource can get                                           |
| **maxmemory** (alias **ram\_mb**)         | Positive Integer            | Maximum amount of memory (in MB) that a job using this resource can get                          |
| **allowed\_vos**                          | Comma-separated List or `*` | The collaborations that are allowed to run jobs on this resource                                 |

The following attributes are optional:

| Option      | Values Accepted      | Explanation                                                                                                         |
|-------------|----------------------|---------------------------------------------------------------------------------------------------------------------|
| subclusters | Comma-separated List | The physical subclusters the resource entry refers to; must be defined as Subcluster sections elsewhere in the file |
| vo\_tag     | String               | An arbitrary label that is added to jobs routed through this resource                                               |


#### Pilot (CMS and OSG GlideinWMS pilot factories) ####

If you are configuring a CE that is going to receive pilot jobs from the CMS or the OSG factories (CMS, OSG, LIGO, CLAS12, DUNE, Glow, IceCube, ...), you can provide pilot job specifications to help operators automatically configure the factory entries in GlideinWMS. For each pilot type, create a new `Pilot` section with a unique name in the following format: `[Pilot NAME]` where NAME is a string describing the pilot type (e.g.: GPU, WholeNode, default). The following options can be specified in the `Pilot` section:

This section is contained in `/etc/osg/config.d/35-pilot.ini`

| Option                                    | Values Accepted             | Explanation                                                                                                                                                          |
|-------------------------------------------|-----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **cpucount**                              | Positive Integer            | The number of cores for this pilot type.                                                                                                                             |
| **ram\_mb**                               | Positive Integer            | The amount of memory (in megabytes) for this pilot type.                                                                                                             |
| **whole\_node**                           | true, false                 | This is a whole node pilot; cpucount and ram_mb are ignored if this is true.                                                                                         |
| **gpucount**                              | Positive Integer            | The number of GPUs available                                                                                                                                         |
| **max\_pilots**                           | Positive Integer            | The maximum number of pilots of this type that can be sent                                                                                                           |
| **max\_wall\_time**                       | Positive Integer            | The maximum wall-clock time a job is allowed to run for this pilot type, in minutes                                                                                  |
| **queue**                                 | String                      | The queue or partition which jobs should be submitted to in order to run on this resource. Equivalent to the HTCondor grid universe classad attribute `remote_queue` |
| **require\_singularity**                  | true, false                 | True if the pilot should require singularity or apptainer on the workers.                                                                                                         |
| **os**                                    | Comma-separated List        | The OS of the workers; allowed values are `rhel8` and `rhel9`. This is required unless require_singularity = true                               |
| **send\_tests*                            | true, false                 | Send test pilots? Currently not working, placeholder                                                                                                                 |
| **allowed\_vos**                          | Comma-separated List or `*` | A comma-separated list of collaborations that are allowed to submit to this subcluster                                                                               |


### Gateway ###

This section gives information about the options in the Gateway section of the configuration files. These options control the behavior of job gateways on the CE. CEs are based on HTCondor-CE, which uses `condor-ce` as the gateway.

This section is contained in `/etc/osg/config.d/10-gateway.ini` which is provided by the `osg-configure-gateway` RPM.

| Option                         | Values Accepted | Explanation                                                                                                                                                                                                            |
|--------------------------------|-----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **htcondor\_gateway\_enabled** | `True`, `False` | (default True). True if the CE is using HTCondor-CE, False otherwise. HTCondor-CE will be configured to support enabled batch systems. RSV will use HTCondor-CE to launch remote probes.                               |
| **job\_envvar\_path**          | String          | The value of the PATH environment variable to put into HTCondor jobs running with HTCondor-CE. This value is ignored if not using that batch system/gateway combination.                                               |


### Local Settings ###

This section differs from other sections in that there are no set options in this section. Rather, the options set in this section will be placed in the `osg-local-job-environment.conf` verbatim. The options in this section are case sensitive and the case will be preserved when they are converted to environment variables. The `osg-local-job-environment.conf` file gets sourced by jobs run on your cluster so any variables set in this section will appear in the environment of jobs run on your system.

Adding a line such as `My_Setting = my_Value` would result in the an environment variable called `My_Setting` set to `my_Value` in the job's environment. `my_Value` can also be defined in terms of an environment variable (i.e `My_Setting = $my_Value`) that will be evaluated on the worker node. For example, to add a variable `MY_PATH` set to `/usr/local/myapp`, you'd have the following:

``` ini
[Local Settings]

MY_PATH = /usr/local/myapp
```

This section is contained in `/etc/osg/config.d/40-localsettings.ini` which is provided by the `osg-configure-ce` RPM.


### Site Information ###

The settings found in the `Site Information` section are described below. This section is used to give information about a resource such as resource name, site sponsors, administrators, etc.

This section is contained in `/etc/osg/config.d/40-siteinfo.ini` which is provided by the `osg-configure-ce` RPM.

| Option              | Values Accepted   | Description                                                                                                                                  |
|---------------------|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| **group**           | `OSG` , `OSG-ITB` | This should be set to either OSG or OSG-ITB depending on whether your resource is in the OSG or OSG-ITB group. Most sites should specify OSG |
| **host\_name**      | String            | This should be set to be hostname of the CE that is being configured                                                                         |
| **resource**        | String            | The resource name of this CE endpoint as registered in OIM.                                                                                  |
| **resource\_group** | String            | The resource\_group of this CE as registered in OIM.                                                                                         |
| **sponsor**         | String            | This should be set to the sponsor of the resource. See note.                                                                                 |
| **site\_policy**    | Url               | This should be a url pointing to the resource's usage policy                                                                                 |
| **contact**         | String            | This should be the name of the resource's admin contact                                                                                      |
| **email**           | Email address     | This should be the email address of the admin contact for the resource                                                                       |
| **city**            | String            | This should be the city that the resource is located in                                                                                      |
| **country**         | String            | This should be two letter country code for the country that the resource is located in.                                                      |
| **longitude**       | Number            | This should be the longitude of the resource. It should be a number between -180 and 180.                                                    |
| **latitude**        | Number            | This should be the latitude of the resource. It should be a number between -90 and 90.                                                       |

!!! note
    **sponsor**:<br/>
    If your resource has multiple sponsors, you can separate them using commas
    or specify the percentage using the following format 'osg, atlas, cms' or
    'osg:10, atlas:45, cms:45'. The percentages must add up to 100 if multiple
    sponsors are used. If you have a sponsor that is not an OSG VO, you can
    indicate this by using 'local' as the VO.


### Squid ###

This section handles the configuration and setup of the squid web caching and proxy service.

This section is contained in `/etc/osg/config.d/01-squid.ini` which is provided by the `osg-configure-squid` RPM.

| Option      | Values Accepted           | Explanation                                                    |
|-------------|---------------------------|----------------------------------------------------------------|
| **enabled** | `True`, `False`, `Ignore` | This indicates whether the squid service is being used or not. |
| location    | String                    | This should be set to the `hostname:port` of the squid server. |


### Storage ###

This section gives information about the options in the Storage section of the configuration file.
Several of these values are constrained and need to be set in a way that is consistent with one of the OSG storage models.
Please review the Storage Related Parameters section of the
[Environment Variables](../worker-node/using-wn.md)
description and [Site Planning](../site-planning.md) discussions for explanations of the various storage models and the requirements for them.

This section is contained in `/etc/osg/config.d/10-storage.ini` which is provided by the `osg-configure-ce` RPM.

| Option           | Values Accepted | Explanation                                                                                                                                                                                                    |
|------------------|-----------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **se_available** | `True`, `False` | This indicates whether there is an associated SE available.                                                                                                                                                    |
| default_se       | String          | If an SE is available at your cluster, set default_se to the hostname of this SE, otherwise set default_se to UNAVAILABLE.                                                                                     |
| **grid_dir**     | String          | This setting should point to the directory which holds the files from the OSG worker node package. See note                                                                                                    |
| **app_dir**      | String          | This setting should point to the directory which contains the VO specific applications. See note                                                                                                               |
| data_dir         | String          | This setting should point to a directory that can be used to store and stage data in and out of the cluster. See note                                                                                          |
| worker_node_temp | String          | This directory should point to a directory that can be used as scratch space on compute nodes. If not set, the default is UNAVAILABLE. See note                                                                |
| site_read        | String          | This setting should be the location or url to a directory that can be read to stage in data via the variable `$OSG_SITE_READ`. This is an url if you are using a SE. If not set, the default is UNAVAILABLE    |
| site_write       | String          | This setting should be the location or url to a directory that can be write to stage out data via the variable `$OSG_SITE_WRITE`. This is an url if you are using a SE. If not set, the default is UNAVAILABLE |


!!! note "Dynamic worker node paths"
    The above variables may be set to an environment variable that is set on your site's worker nodes.
    For example, if each of your worker nodes has a different location for its scratch directory specified by
    `LOCAL_SCRATCH_DIR`, set the following configuration:

        [Storage]
        worker_node_temp = $LOCAL_SCRATCH_DIR

**grid_dir**:<br/>
If you have installed the worker node client via RPM (the normal case) it
should be `/etc/osg/wn-client`.  If you have installed the worker node in a
special location (perhaps via the worker node client tarball or via OASIS),
it should be the location of that directory.

This directory will be accessed via the `$OSG_GRID` environment variable.
It should be visible on all of the compute nodes. Read access is required,
though worker nodes don't need write access.

**app_dir**:<br/>
This directory will be accesed via the `$OSG_APP` environment variable. It
should be visible on both the CE and worker nodes. Only the CE needs to
have write access to this directory. This directory must also contain a
sub-directory `etc/` with 1777 permissions.

This directory may also be in OASIS, in which case set `app_dir` to
`/cvmfs/oasis.opensciencegrid.org`. (The CE does not need write access in
that case.)

**data_dir**:<br/>
This directory can be accessed via the `$OSG_DATA` environment variable. It
should be readable and writable on both the CE and worker nodes.

**worker_node_temp**:<br/>
This directory will be accessed via the `$OSG_WN_TMP` environment variable.
It should allow read and write access on a worker node and can be visible
to just that worker node.

