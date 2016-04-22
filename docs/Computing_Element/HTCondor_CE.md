---
current_menu: ce
---
Installing and Maintaining HTCondor-CE
======================================


About This Guide
----------------

The HTCondor-CE software is a *job gateway* for an OSG Compute Element
(CE). As such, HTCondor-CE is the entry point for jobs coming from the
OSG — it handles authorization and delegation of jobs to your local
batch system. In OSG today, most CEs accept *pilot jobs* from a factory,
which in turn are able to accept and run end-user jobs.

Use this page to learn how to install, configure, run, test, and
troubleshoot HTCondor-CE from the OSG software repositories.

Before Starting
---------------

Before starting the installation process, consider the following points
(consulting [the Reference section below](#ReferenceSection) as needed):

-   *User IDs:* If they do not exist already, the installation will
    create the Linux user IDs `condor` (UID 4716), `tomcat` (UID 91) and
    `gratia` (UID 42401)
-   **Service certificate:** The HTCondor-CE service uses a host
    certificate at `/etc/grid-security/host*.pem`
-   **Network ports:** The pilot factories must be able to contact your
    HTCondor-CE service on ports 9619 and 9620 (TCP)
-   **Host choice:** HTCondor-CE should be installed on a host that
    already has the ability to submit jobs into your local cluster

As with all OSG software installations, there are some one-time (per
host) steps to prepare in advance:

-   Ensure the host has [a supported operating
    system](SupportedOperatingSystems)
-   Obtain root access to the host
-   Prepare [the required Yum repositories](../Common/yum.md)
-   Install [CA certificates](InstallCertAuth)

Installing HTCondor-CE
----------------------

An HTCondor-CE installation consists of the job gateway (i.e., the
HTCondor CE job router) and other support software (e.g., GridFTP, a
Gratia probe, authorization software). To simplify installation, OSG
provides convenience RPMs that install all required software with a
single command.

1. If your batch system is already installed via non-RPM means and is
   in the following list, install the appropriate 'empty' RPM. Otherwise,
   skip to the next step.

   |If your batch system is…  | Then run the following command…|
   |--------------------------|-------------------------------------------------------|
   |HTCondor                  |`yum install empty-condor --enablerepo=osg-empty`|
   |PBS                       |`yum install empty-torque --enablerepo=osg-empty`|
   |SGE                       |`yum install empty-gridengine --enablerepo=osg-empty`|

2. Select the appropriate convenience RPM(s):

   |If your batch system is…  |Then use the following package(s)…  |
   |--------------------------|------------------------------------|
   |HTCondor                  |`osg-ce-condor`                     |
   |LSF                       |`osg-ce-lsf`                        |
   |PBS                       |`osg-ce-pbs`                        |
   |SGE                       |`osg-ce-sge`                        |
   |SLURM                     |`osg-ce-slurm`                      |

3. Install the CE software: <pre class="rootscreen"> $yum install *PACKAGE(S)*</pre>

To ease the transition from GRAM
to HTCondor-CEs, the convenience RPMs install both types of job gateway
software. By default, the HTCondor gateway is enabled and the GRAM
gateway is disabled, which is the correct configuration for most
HTCondor-CE-based sites (but see the gateway configuration section below
for more options).

**NOTE**: HTCondor CE version 1.6 or later
is required to send site resource information to OSG for matching jobs
to resources.

Configuring HTCondor-CE
-----------------------

There are a few required configuration steps to connect HTCondor CE with
your batch system and authorization method. For more advanced
configuration, see the section on [optional
configurations](#OptionalConfig).

### Enabling HTCondor-CE

If you are installing HTCondor CE on a new host, the default
configuration is correct and you can [skip](#BatchSystem) this step!
However, if you are updating a host that used a Globus GRAM job gateway
(aka the Globus gatekeeper), you must enable the HTCondor job gateway.

1.  Decide whether to disable GRAM (the preferred option) or run
    both HTCondor and GRAM CEs
2.  Edit the gateway configuration file
    `/etc/osg/config.d/10-gateway.ini` to reflect your choice
    To enable HTCondor CE and disable GRAM CE:

    ```
    gram_gateway_enabled = False
    htcondor_gateway_enabled = True
    ```
    To enable both HTCondor and GRAM CEs:
    
    ```
    gram_gateway_enabled = True
    htcondor_gateway_enabled = True
    ```

More information about the Globus GRAM CE can be found [here](Computing_Element/InstallComputeElement).

Batch System
------------

### Configuring the batch system

Enable your batch system by editing the `enabled` field in the
`/etc/osg/config.d/20-YOUR-BATCH-SYSTEM.ini`
file:

```
enabled = True
```

#### Batch systems other than HTCondor

If you are using HTCondor as your **local batch system** (i.e., in
addition to your HTCondor CE), skip to the [configuring
authorization](#ConfiguringAuthorization) section. For other batch
systems (e.g., PBS, LSF, SGE, SLURM), keep reading.

##### Sharing the spool directory

To transfer files between the CE and the batch system, HTCondor CE
requires a shared file system. The current recommendation is to run a
dedicated NFS server (whose installation is beyond the scope of this
document) on the **CE host**. In this setup, HTCondor-CE writes to the
local spool directory, the NFS server exports the it, and the NFS server
shares the it with all of the worker nodes.

**NOTE**: If you choose not to host the NFS
server on your CE, you will need to turn off root squash so that the
HTCondor-CE daemons can write to the spool directory.

By default, the spool directory is `/var/lib/condor-ce` but you can
control this by setting `SPOOL` in
`/etc/condor-ce/config.d/99-local.conf`. For example, the following sets
the `SPOOL` directory to `/home/condor`:

```
SPOOL=/home/condor
```

**NOTE**: The shared spool directory must
be readable and writeable by the `condor` user for HTCondor CE to
function correctly.

##### Disable worker node proxy renewal

Worker node proxy renewal is not used by HTCondor-CE and leaving it on
will cause some jobs to be held. Edit `/etc/blah.config` on the
HTCondor CE host and set the following two values:

```
blah_disable_wn_proxy_renewal=yes
blah_delegate_renewed_proxies=no
```

**NOTE**: This configuration file uses bash syntax rules; there should be no whitespace around the `=`.

### Configuring authorization

There are two methods to manage authorization for incoming jobs,
`edg-mkgridmap` and GUMS. `edg-mkgridmap` is easy to set up and maintain,
and GUMS has more features and capabilities. We recommend using
`edg-mkgridmap` unless you have specific needs that require the use of
GUMS. Some examples of these specific requirements are:

-   You want to map users based on rules
-   You need to support multiple VO roles
-   You need to support gLExec for pilot jobs

#### Authorization with edg-mkgridmap

To configure your CE to use `edg-mkgridmap`:

1.  Follow the configuration instructions in [the edg-mkgridmap
    document](Edg-mkgridmap) to define the VOs that your site
    accepts
2.  Set some critical gridmap attributes by editing the
    `/etc/osg/config.d/10-misc.ini` file on the HTCondor CE
    host:

    ```
    authorization_method = gridmap
    ```

1.  Enable edg-mkgridmap and disable GUMS in the `/etc/lcmaps.db`
    file.

    In the `authorize_only` section, comment out the
    `gumsclient` line and uncomment the `gridmapfile` line. The result
    should be as follows:
    
    ```
    authorize_only:
    # gumsclient -> good | bad
    gridmapfile -> good | bad
    ```

2.  Specify the location of your grid mapfile in
    `/etc/condor-ce/config.d/01-common-auth.conf`:

    ```
    GRIDMAP = /etc/grid-security/grid-mapfile
    ```
    **Note:** The standard location for the grid mapfile is shown
    above. Use that location unless you have specific reasons to put the
    file somewhere else.

#### Authorization with GUMS

1.  Follow the instructions in [the GUMS installation and
    configuration document](InstallGums) to prepare GUMS
2.  Set some critical GUMS attributes by editing the
    `/etc/osg/config.d/10-misc.ini` file on the HTCondor CE
    host:

    ```
    authorization_method = xacml
    gums_host = YOUR GUMS HOSTNAME
    ```

**NOTE** Once `gsi-authz.conf` is in place,
your local HTCondor will attempt to utilize the LCMAPS callouts if
enabled in the `condor_mapfile`. If this is not the desired behavior, set
`GSI_AUTHZ_CONF=/dev/null` in the local HTCondor configuration.

### Configuring information systems

To split jobs between the various sites of the OSG, information about
each site’s availability is uploaded to a central collector. The job
factories then query the central collector for idle resources and submit
pilot jobs to the available sites. To advertise your site, you will need
to run the Generic Information Provider and OSG Info Services.

#### Generic Information Provider (GIP)

The `GIP` is a service that discovers information about your site
resources like the number of available cores and what VO's are allowed
to run on your site. Consult the [GIP configuration
document](Documentation.Release3.GipConfiguration) for instructions on
how to set up your `GIP` service.

**NOTE**: If you have `gip-1.3.11-4`
installed, manual intervention is required for correct reporting to
BDII. See [3.2.20 known
issues](Documentation/Release3.Release3220#KnownIssues).

#### OSG Info Services

`osg-info-services` takes the information collected from `GIP` and
uploads it to OSG's central collector. For `osg-info-services` to
communicate with the appropriate servers, it needs a service certificate
and key located at `/etc/grid-security/http/httpcert.pem` and
`/etc/grid-security/http/httpkey.pem`, respectively. Additionally, the
service runs as either the `tomcat` user or the account specified by the
`user` option in `/etc/osg/config.d/30-gip.ini`, thus your service
certificates need to be owned by the appropriate user.

1.  Enable osg-info-services in
    `/etc/osg/config.d/30-infoservices.ini`:

    ```
    enabled = *True*
    ```
2.  Generate a `user-vo-map` file with your authorization set
    up:
    i.  If you're using edg-mkgridmap, run the following:

    ```
    edg-mkgridmap
    ```
    ii. If you're using GUMS, run the following:
    
    ```
    gums-host-cron
    ```

### Applying configuration settings

Making changes to the OSG configuration files in the `/etc/osg/config.d`
directory does not apply those settings to software automatically.
Settings that are made outside of the OSG directory take effect
immediately or at least when the relevant service is restarted. For the
OSG settings, use the [osg-configure](IniConfigurationOptions) tool to
validate (to a limited extent) and apply the settings to the relevant
software components. The `osg-configure` software is included
automatically in an HTCondor CE installation.

1.  Make all changes to `.ini` files in the `/etc/osg/config.d`
    directory

    **Note:** This document describes the
    critical settings for HTCondor CE and related software. You may need
    to configure other software that is installed on your HTCondor CE
    host, too.
2.  Validate the configuration settings

    ```
    osg-configure -v
    ```
    Fix any errors (at least) that `osg-configure` reports.
3.  Once the validation command succeeds without errors, apply the
    configuration settings:

    ```
    osg-configure -c
    ```

### Optional configuration

The following configuration steps are optional and will likely not be
required for setting up a small site. If you do not need any of the
following special configurations, skip to [the section on using
HTCondor CE](#UsingHTCondorCE).

-   [Transforming and filtering jobs](#JobRoutes)
-   [Configuring for multiple network interfaces](#NetworkInterfaces)
-   [Limiting or disabling locally running jobs on the CE](#LocalUni)
-   [HTCondor accounting groups](#AccountingGroups)
-   [Installing the HTCondor-CE View](#CeView)

#### Transforming and filtering jobs

If you need to modify or filter jobs, more information can be found in
the [Job Router Recipes](Documentation/Release3.JobRouterRecipes)
document.

**NOTE**: If you need to assign jobs to
HTCondor accounting groups, refer to [this](#AccountingGroups) section.

#### Configuring for multiple network interfaces

If you have multiple network interfaces with different hostnames, the
HTCondor CE daemons need to know which hostname to use when
communicating to each other. Generally, you will want to set
`NETWORK_HOSTNAME` to the hostname of your public interface in
`/etc/condor-ce/config.d/99-local.conf` directory with the line:

```
NETWORK_HOSTNAME=condorce.example.com
```

Replacing `condorce.example.com` text with your public
interface’s hostname.

#### Limiting or disabling locally jobs running on the CE

If you want to limit or disable jobs running locally on your CE, you
will need to configure HTCondor-CE's local and scheduler universes.
Local and scheduler universes are HTCondor CE’s analogue to GRAM’s
managed fork: they allow jobs to be run on the CE itself. The two
universes are effectively the same (scheduler universe launches a
starter process for each job), so we will be configuring them in unison.

-   **To change the default limit** on the number of locally run jobs
    (the current default is 20), add the following to
    `/etc/condor-ce/config.d/99-local.conf`:

    ```
    LOCAL_JOB_LIMIT = 20
    START_LOCAL_UNIVERSE = TotalLocalJobsRunning + TotalSchedulerJobsRunning < $(LOCAL_JOB_LIMIT)
    START_SCHEDULER_UNIVERSE = $(START_LOCAL_UNIVERSE)
    ```
    (updating `LOCAL_JOB_LIMIT` as appropriate.)

-   **To only allow a specific user** to start locally run jobs, add the
    following to `/etc/condor-ce/config.d/99-local.conf`:

    ```
    ALLOWED_LOCAL_USER=alice
    START_LOCAL_UNIVERSE = target.Owner =?= "$(ALLOWED_LOCAL_USER)"
    START_SCHEDULER_UNIVERSE = $(START_LOCAL_UNIVERSE)
    ```

-   **To disable** locally run jobs, add the following to
    `/etc/condor-ce/config.d/99-local.conf`:

    ```
    START_LOCAL_UNIVERSE = False
    START_SCHEDULER_UNIVERSE = $(START_LOCAL_UNIVERSE)
    ```

**NOTE**: RSV requires the ability to start
local universe jobs so if you are using RSV, you need to allow local
universe jobs from the `rsv` user.

#### HTCondor accounting groups

**NOTE**: For HTCondor batch systems only

If you want to provide fairshare on a group basis, as opposed to a Unix
user basis, you can use HTCondor accounting groups. They are independent
of the Unix groups the user may already be in, and are [documented in the HTCondor manual](http://research.cs.wisc.edu/condor/manual/v8.4/3_4User_Priorities.html#SECTION00447000000000000000).
If you are using HTCondor accounting groups, you can map jobs from the
CE into HTCondor accounting groups based on their numeric user id, their
DN, or their VOMS attributes.

##### Mapping by UID

To map UID’s to an accounting group, use `/etc/osg/uid_table.txt`. It is
consulted first and contains lines of the form:

```
uid GroupName
```

Example `uid_table.txt`:

```
uscms02 TestGroup
osg     other.osgedu
```

##### Mapping by DN or VOMS attribute

To map DN’s or VOMS attributes to an accounting group, use
`/etc/osg/extattr_table.txt`. This file is only consulted if the user is
not found in the UID file and it contains lines of the form:

```
SubjectOrAttribute GroupName
```

The SubjectOrAttribute can be a Perl regular
expression.

Example `extattr_table.txt`:

```
cmsprio cms.other.prio
cms\/Role=production cms.prod
.* other
```


#### Install and run the HTCondor-CE-View

The HTCondor-CE-View is an optional web interface to the status of your
CE. To run the View,

1.  Begin by installing the package htcondor-ce-view:

    ```
    yum install htcondor-ce-view
    ```
2.  Next, uncomment the `DAEMON_LIST` configuration located at
    `/etc/condor-ce/config.d/05-ce-view.conf`:

    ```
    DAEMON_LIST = $(DAEMON_LIST), CEVIEW, GANGLIAD
    ```
3.  Restart the CE service.

    ```
    service condor-ce restart
    ```

By default, the website is served from port 80. This may be configured
in `/etc/condor-ce/config.d/05-ce-view.conf` as well.

Using HTCondor-CE
-----------------

As a site administrator, there are a few ways in which you might use the
HTCondor CE:

-   Managing the HTCondor CE and associated services
-   Using HTCondor CE administrative tools to monitor and maintain the
    job gateway
-   Using HTCondor CE user tools to test gateway operations

### Managing HTCondor CE and associated services

In addition to the HTCondor CE job gateway service itself, there are a
number of supporting services in your installation. The specific
services are:

| Software           | Service name                                       | Notes
| -------------------|--------------------------------------------------- | ----------------------------------------------------------------------------------------
| Fetch CRL          |On EL 6: `fetch-crl-boot` and `fetch-crl-cron`  <br>   On EL 5: `fetch-crl3-boot` and `fetch-crl3-cron`   | See [CA documentation](InstallCertAuth#Start_Stop_fetch_crl_A_quick_gui) for more info |
|  Gratia            | `gratia-probes-cron`                               | Accounting software |
| Your batch system  |`condor` or `pbs_server` or …                       |                     |
| OSG Info Services  |`osg-info-services`                                 |                     |
|  HTCondor-CE       |`condor-ce`                                         |                     |

Start the services in the order listed and stop them in reverse order.
As a reminder, here are common service commands (all run as `root`):


| To …                                         |Run the command …                      |
| ---------------------------------------------|---------------------------------------|
| Start a service                              |`service <em>SERVICE-NAME</em> start`  |
| Stop a service                               |`service <em>SERVICE-NAME</em> stop`   |
| Enable a service to start during boot        |`chkconfig <em>SERVICE-NAME</em> on`   |
| Disable a service from starting during boot  |`chkconfig <em>SERVICE-NAME</em> off`  |

### Using HTCondor-CE tools

Some of the HTCondor CE administrative and user tools are documented in
[the HTCondor CE troubleshooting guide](TroubleshootingHTCondorCE).

Validating HTCondor-CE
----------------------

There are different ways to make sure that your HTCondor CE host is
working well:

-   Perform automated validation by running [RSV](InstallRSV)
-   Manually verify your HTCondor CE using [the HTCondor CE
    troubleshooting guide](TroubleshootingHTCondorCE); useful tools
    include:
    -   [condor\_ce\_run](TroubleshootingHTCondorCE#condor_ce_run)
    -   [condor\_ce\_trace](TroubleshootingHTCondorCE#condor_ce_trace)
    -   [condor\_submit](TroubleshootingHTCondorCE#condor_submit)

Troubleshooting HTCondor-CE
---------------------------

For information on how to troubleshoot your HTCondor CE, please refer to
[the HTCondor CE troubleshooting guide](TroubleshootingHTCondorCE).

Registering the CE
------------------

To be part of the OSG Production Grid, your CE must be registered in the
[https://oim.grid.iu.edu/ OSG Information Management System](https://oim.grid.iu.edu/ OSG Information Management System)
(OIM). To register your resource:

1.  [Obtain, install, and verify your user
    certificate](Documentation.CertificateUserGet) (which you may have
    done already)
2.  [Register your site and CE in
    OIM](Operations.OIMRegistrationInstructions)

Getting Help
------------

To get assistance, please use the [this
page](Documentation.HelpProcedure).

Reference
---------

Here are some other HTCondor-CE documents that might be helpful:

-   [HTCondor-CE overview and architecture](HTCondorCEOverview)
-   [Configuring HTCondor-CE job routes](JobRouterRecipes)
-   [The HTCondor-CE troubleshooting guide](TroubleshootingHTCondorCE)
-   [Submitting Jobs to HTCondor-CE](SubmittingHTCondorCE)

### Configuration

The following directories contain the configuration for HTCondor-CE. The
directories are parsed in the order presented and thus configuration
within the final directory will override configuration specified in the
previous directories.

| Location                           | Comment                                      |
| ---------------------------------- | -------------------------------------------- | 
| `/usr/share/condor-ce/config.d/`   | Configuration defaults (overwritten on package updates) |
| `/etc/condor-ce/config.d/`         | Files in this directory are parsed in alphanumeric order (i.e., `99-local.conf` will override values in `01-ce-auth.conf`) |

For a detailed order of the way configuration files are parsed, run the
following command:

```
# condor_ce_config_val -config
```

### Users

The following users are needed by HTCondor-CE at all sites:

| **User** | **Comment** |
| -------- | ----------- |
| `condor` | The HTCondor-CE will be run as root, but perform most of its operations as the `condor` user. |
| `gratia` | Runs the Gratia probes to collect accounting data |
| `tomcat` | Default user that runs GIP |

### Certificates

| **Certificate**   | **User that owns certificate**  | **Path to certificate**                                                     |
| ----------------- | ------------------------------- | --------------------------------------------------------------------------- |
| Host certificate  | `root`                          | `/etc/grid-security/hostcert.pem` \<br\> `/etc/grid-security/hostkey.pem`   |

Find instructions to request a host certificate [here](GetHostServiceCertificates).

<!--  TODO: Fixup
### Networking

<span class="twiki-macro STARTSECTION">Firewalls</span> <span
class="twiki-macro INCLUDE" section="FirewallTable"
lines="htcondorce,htcondorce_shared">Documentation/Release3/FirewallInformation</span>

Allow inbound and outbound network connection to all internal site
servers, such as GUMS and the batch system head-node only ephemeral
outgoing ports are necessary.\</br\>

<span class="twiki-macro ENDSECTION">Firewalls</span>
-->
