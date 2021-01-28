Troubleshooting Gratia Accounting
=================================

This document will help you troubleshoot problems with the Gratia Accounting, particularly with problems in collecting and reporting accounting information to the central OSG accounting service.


Gratia/GRACC: The Big Picture
-----------------------

Gratia is software used in OSG to gather accounting information.
The information is collected from individual resources at a site, such as a Compute Entrypoint or a a submission host.
The program that collects the data is called a "Gratia probe".
The information is transferred to the central OSG GRACC server.
Here is a diagram:

!!! note "Difference between Gratia and GRACC"
    Gratia is the legacy name of the OSG Accounting system.  GRACC is the new name of the server and hosted components of the accounting system.  When we refer to Gratia, we mean either the data or the probes on the resources.  If we mention GRACC, we are referring to the hosted components that the OSG maintains.

![Gratia Basics](../img/gratia-overview.png)

These are the definitions of the major elements in the above figure.

-   **Gratia probe**: A piece of software that collects accounting data from the computer on which it's running, and transmits it to a Gratia server.
-   **GRACC server**: A server that collects Gratia accounting data from one or more sites and can share it with users via a web page.  The GRACC server is hosted by the OSG.
-   **Reporter**: A web service running on the GRACC server. Users can connect to the reporter via a web browser to explore the Gratia data.
-   **Collector**: A web service running on the GRACC server that collects data from one or more Gratia probes. Users do not directly interact with the collector.

You can see the OSG's GRACC website at <https://gracc.opensciencegrid.org>.

You can see a fancier version of the Gratia data at <https://display.opensciencegrid.org/>. This is **not** running a Gratia collector, but is a separate service.

Gratia Probes
-------------

Gratia Probes are periodically run as cron jobs, but different probes will run at different intervals. The cron jobs will always run and you should not remove them. You can find them in `/etc/cron.d`.

However, the cron jobs will only do anything if you have enabled them. You enable them via an init script. For example, to enable them:

    :::console
    root@host # service gratia-probes-cron start
    Enabling gratia probes cron:                               [  OK  ]

To disable them:

    :::console
    root@host # service gratia-probes-cron stop
    Disabling gratia probes cron:                               [  OK  ]

You also need to enable individual probes, usually via `osg-configure`.  Documentation on using `osg-configure` with Gratia [documented elsewhere](configuration-with-osg-configure.md#gratia).

### Running Gratia Probes

When the cron jobs are enabled and run, they go through the following process, with minor changes between different Gratia probes:

1.  The probe is invoked. It reads its configuration from `/etc/gratia/PROBE-NAME/ProbeConfig`.
2.  It collects the accounting information from the underlying system. For example, the Condor probe will read it from the `PER_JOB_HISTORY_DIR`, which is usually `/var/lib/gratia/data`.
3.  It transforms the data into Gratia records and saves them into `/var/lib/gratia/tmp/gratiafiles/`
4.  When there are sufficient Gratia records, or when sufficient time has passed, it uploads sets of records in batches to the GRACC server, then removes them from the `gratiafiles` directory.
5.  All progress is logged to `/var/log/gratia`.
6.  If there are failures in uploading the files to the GRACC server
    1.  Files are not removed from `gratiafiles` until they are successfully uploaded.
    2.  Errors are logged to log files in `/var/log/gratia`.
    3.  The uploads will be tried again later.

### Gratia Probe Configuration

In normal cases, `osg-configure` does the editing of the probe configuration files, at least on the CE. The configuration is found in `/etc/osg/config.d/30-gratia.ini` and [documented elsewhere](configuration-with-osg-configure.md#gratia).

If there are problems or special configuration, you might need to edit the Gratia configuration files yourself. Each probe has a separate configuration file found in `/etc/gratia/PROBE-NAME/ProbeConfig`.

The ProbeConfig files have many details. A few options that you might need to edit are shown before. This is **not** a complete file, but only shows a subset of the options.

``` file
<ProbeConfiguration 

    CollectorHost="gratia-osg-itb.opensciencegrid.org:80"
    SSLHost="gratia-osg-itb.opensciencegrid.org:80"
    SSLRegistrationHost="gratia-osg-itb.opensciencegrid.org:80"

    ProbeName="condor:fermicloud084.fnal.gov"
    SiteName="WISC_OSG_EDU"
    EnableProbe="1"
/>
```

The options you see here are:

| Option              | Comments                                                                               |
|:--------------------|:---------------------------------------------------------------------------------------|
| CollectorHost       | The GRACC server this probe reports to                                                |
| SSLHost             | The GRACC server this probe reports to                                                |
| SSLRegistrationHost | The GRACC server this probe reports to                                                |
| ProbeName           | The unique name for this probe. Note that it includes the probe type and the host name |
| SiteName            | The name of your Resource, as registered in [OSG Topology](/common/registration).      |
| EnableProbe         | The probe will only run if this is "1"                                                 |

Again, there are many more options in this file. Most of the time you won't need to touch them.

Are the Gratia cron jobs running? 
---------------------------------

You should make sure the Gratia cron jobs are running. The simplest way is with the `service` command:

    :::console
    root@host # /sbin/service gratia-probes-cron status
    gratia probes cron is enabled.

If it is not enabled, enable it as described above.

This only ensures that the basic gratia-probe-cron "service" is running.
To check if the individual Gratia probes are enabled, look at the `EnableProbe` option in the `ProbeConfig` file, as described above.
A quick command to do this is shown here.
Note that the Condor and GridFTP Transfer probes are enabled while the glexec probe is disabled:

    :::console
    root@host # cd /etc/gratia
    root@host # grep -r EnableProbe *
    condor/ProbeConfig:    EnableProbe="1"
    glexec/ProbeConfig:    EnableProbe="0"
    gridftp-transfer/ProbeConfig:    EnableProbe="1"

If you see no log files in `/var/log/gratia` you may have an error in the probe configuration file. Manually run the test for your probe (check `/etc/cron.d/gratia-probe-condor.cron`), e.g. `/usr/share/gratia/common/cron_check  /etc/gratia/condor/ProbeConfig`. If there is an error you may get a suggestion on where it is, e.g.:

    :::console
    root@host # /usr/share/gratia/common/cron_check  /etc/gratia/condor/ProbeConfig
    Parse error in /etc/gratia/condor/ProbeConfig: not well-formed (invalid token): line 21, column 4

Correct the error and restart gratia.

Have you configured the resource names correctly? 
-------------------------------------------------

Do the names of your resources match the names in
[OSG Topology](https://github.com/opensciencegrid/topology/tree/master/topology)?
Gratia retrieves the resource name from the `Site Information` section of the `/etc/osg/config.d/40-siteinfo.ini`


``` file
;===================================================================
;                       Site Information
;===================================================================

[Site Information]
; Set "group" to "OSG" for a production site, or "OSG-ITB" for an ITB site.
; 
; YOU WILL NEED TO CHANGE THIS
group = OSG

; Set "host_name" to the host name of the CE being configured.
; This should resolve in DNS; if DNS is not set up yet, enter an IPv4/v6 address instead.
;
; YOU WILL NEED TO CHANGE THIS
host_name = tusker-gw1.unl.edu

; Set "resource" to the name of the resource that you have registered
; in the OSG topology repository at https://github.com/opensciencegrid/topology
; 
; YOU WILL NEED TO CHANGE THIS
resource = Tusker-CE1

```

Do those names match the names that you registered with OSG Topology?
If not, edit the names, and rerun "osg-configure -c".

Did the site name change?
-------------------------

Was the site previously reporting data, but the site name (not host name, but site name) changed? When the site name changes, you need to ask the GRACC operations team to update the name of your site at the GRACC collector. To do this:

1.  Open a [support ticket](https://support.opensciencegrid.org/helpdesk/tickets/new)
1.  Select "Software or Service"
1.  Select "GRACC Operations"
1.  Type a friendly email that asks the GRACC team to change your site name at the collector. Make sure to tell them the old name and the new name.  Below is an example email:

        Hello GRACC Team,
        
        Please change the site name of my site from <Insert Old Name> to <Insert New Name>.
        
        Thanks, ...

 Is a site reporting data?
--------------------------

You can see if the OSG GRACC Server is getting data from a site by going to [GRACC](https://gracc.opensciencegrid.org/dashboard/db/pilot-jobs-summary?orgId=1):

1.  Specify the site name in Facility

HTCondor's Gratia Configuration 
-------------------------------

!!! note 
    Only applicable to HTCondor batch sites, not SLURM, PBS, SGE or LSF sites

Condor must be configured to put information about each job into a special directory.  Gratia will read and remove the files in order to collect the accounting information.

The configuration variable is called `PER_JOB_HISTORY_DIR`. If you install the OSG RPM for Condor, the Gratia probe will extend its configuration by adding a file to `/etc/condor/config.d`, and will set this variable to `/var/lib/gratia/data`. If you are using a different installation method, you may need to set the variable yourself. You can check if it's set by using `condor_config_val`, like this:

    :::console
    user@host $ condor_config_val -v PER_JOB_HISTORY_DIR
    PER_JOB_HISTORY_DIR: /var/lib/gratia/data
        Defined in '/etc/condor/config.d/99_gratia.conf', line 5.

If you set this value, you need to restart condor:

    :::console
    root@host # condor_restart
    Sent "Restart" command to local master

Unlike many Condor settings, a **condor\_reconfig** is not sufficient - you must restart!

### If you accidentally did not set `PER_JOB_HISTORY_DIR` (see above)

The HTCondor Gratia probe will not publish accounting information about jobs without `PER_JOB_HISTORY_DIR`. You can have Gratia read the Condor history file and publish data that way. If you know the time period of the missing data, you should specify a start and end times. This reduces the load on the Gratia collector. To do so:

**Preferred method using start and end times**

    :::console hl_lines="1"
    root@host # /usr/share/gratia/condor/condor_meter --history --start-time="2014-06-01" --end-time="2014-06-02" --verbose
    2014-06-03 10:00:36 CDT Gratia: RUNNING condor_meter MANUALLY using HTCondor history from 2014-06-01 to 2014-06-02
    2014-06-03 10:00:36 CDT Gratia: RUNNING: condor_history -l -constraint '((JobCurrentStartDate > 1401598800) && (JobCurrentStartDate < 1401685200))'
    2014-06-03 10:00:49 CDT Gratia: condor_meter --history: Usage records submitted: 399
    2014-06-03 10:00:49 CDT Gratia: condor_meter --history: Usage records found: 400
    2014-06-03 10:00:49 CDT Gratia: RUNNING condor_meter MANUALLY Finished

**or if you need to go back to the beginning of time**

    :::console hl_lines="1"
    root@host # /usr/share/gratia/condor/condor_meter --history --verbose
    2014-06-03 10:06:19 CDT Gratia: RUNNING condor_meter MANUALLY using all HTCondor history
    2014-06-03 10:06:19 CDT Gratia: RUNNING: condor_history -l
    2014-06-03 10:11:38 CDT Gratia: condor_meter --history: Usage records submitted: 13026
    2014-06-03 10:11:38 CDT Gratia: condor_meter --history: Usage records found: 13027
    2014-06-03 10:11:38 CDT Gratia: RUNNING condor_meter MANUALLY Finished


Not much is printed to the screen, but you can see progress in the Gratia log file:

    13:35:28 CDT Gratia: Initializing Gratia with /etc/gratia/condor/ProbeConfig
    13:35:28 CDT Gratia: Creating a ProbeDetails record 2012-04-04T18:35:28Z
    13:35:28 CDT Gratia: ***********************************************************
    13:35:28 CDT Gratia: OK - Handshake added to bundle (1/100)
    13:35:28 CDT Gratia: ***********************************************************
    13:35:28 CDT Gratia: List of backup directories: [u'/var/lib/gratia/tmp']
    13:35:28 CDT Gratia: Reprocessing response: OK - Reprocessing 0 record(s) uploaded, 0 bundled, 0 failed
    13:35:28 CDT Gratia: After reprocessing: 0 in outbox 0 in staged outbox 0 tar files
    13:35:28 CDT Gratia: Creating a UsageRecord 2012-04-04T18:35:28Z
    ...
    13:35:29 CDT Gratia: Processing bundle file: 
    13:35:29 CDT Gratia: Processing bundle file: /var/lib/gratia/tmp/gratiafiles/
        subdir.condor_fermicloud084.fnal.gov_gratia-osg-itb.opensciencegrid.org_80/
        outbox/r.18425.condor_fermicloud084.fnal.gov_gratia-osg-itb.opensciencegrid.org_80.gratia.xml__BSuXo18428
    ...
    13:35:29 CDT Gratia: ***********************************************************
    13:35:29 CDT Gratia: Removing log files older than 31 days from /var/log/gratia
    13:35:29 CDT Gratia: /var/log/gratia uses 0.035% and there is 73% free
    13:35:29 CDT Gratia: Removing incomplete data files older than 31 days from /var/lib/gratia/data/
    13:35:29 CDT Gratia: /var/lib/gratia/data uses 0% and there is 73% free
    13:35:29 CDT Gratia: End of execution summary: new records sent successfully: 37



!!! note 
    Condor rotates history files, so you can only report what Condor has kept.
    Controlling the Condor history is documented in the Condor manual.
    In particular, see the options for
    [MAX_HISTORY_LOG](https://htcondor.readthedocs.io/en/latest/admin-manual/configuration-macros.html#MAX_HISTORY_ROTATIONS)
    and
    [MAX_HISTORY_ROTATIONS](https://htcondor.readthedocs.io/en/latest/admin-manual/configuration-macros.html#MAX_HISTORY_ROTATIONS).

### Bad Gratia hostname

This is an example problem where the configuration was bad: there was an incorrect hostname for the Gratia server. The problem is clearly visible in the Gratia log file, which is located in `/var/log/gratia/`. There is one log file per day, labeled by the date:

    :::console
    root@host # cd /var/log/gratia/
    root@host # cat 2012-04-03.log 

You can see that Gratia is using the correct configuration file:

    :::console
    15:06:55 CDT Gratia: Using config file: /etc/gratia/condor/ProbeConfig

Here Gratia is removing a file from the Condor PER_JOB_HISTORY_DIR and creating a Gratia accounting record for it

    :::console hl_lines="4 7"
    15:06:55 CDT Gratia: Creating a UsageRecord 2012-04-03T20:06:55Z
    15:06:55 CDT Gratia: Registering transient input file: /var/lib/gratia/data/history.37.0
    15:06:55 CDT Gratia: ***********************************************************
    15:06:55 CDT Gratia: Saved record to /var/lib/gratia/tmp/gratiafiles/
        subdir.condor_fermicloud084.fnal.gov_ggratia-osg-itb.opensciencegrid.org_80/
        outbox/r.30604.condor_fermicloud084.fnal.gov_ggratia-osg-itb.opensciencegrid.org_80.gratia.xml__wfIgi30606
    15:06:55 CDT Gratia: Deleting transient input file: /var/lib/gratia/data/history.37.0

Later, Gratia failed to connect to the server due to a bad hostname

    :::console hl_lines="1"
    15:06:55 CDT Gratia: Failed to send xml to web service due to an error of type "socket.gaierror": (-2, 'Name or service not known')
    ...
    15:06:55 CDT Gratia: Response indicates failure, the following files will not be deleted:
    15:06:55 CDT Gratia:    /var/lib/gratia/tmp/gratiafiles/
        subdir.condor_fermicloud084.fnal.gov_ggratia-osg-itb.opensciencegrid.org_80/
        outbox/r.30604.condor_fermicloud084.fnal.gov_ggratia-osg-itb.opensciencegrid.org_80.gratia.xml__wfIgi30606


If you accidentally had a bad Gratia hostname, you probably want to recover your Gratia data. 

This can be done, though it's not simple. There are a few things you need to do. But first, you need to understand exactly where Gratia stores files.

When a Gratia extracts accounting information, it creates one file per record and stores it in a directory. The directory is a long name that contains the type of the probe (such as `condor`), the name of the host you're running on, and the name of the GRACC host you're sending the information to. For simplicity, lets call that name `<PROBE-RECORDS>`, but you'll see what it really looks like below. Within this directory, you'll see some subdirectories:

|  Directory                                                                | Purpose                                       |
|:--------------------------------------------------------------------------|:----------------------------------------------|
| /var/lib/gratia/tmp/grataifiles/`<PROBE-RECORDS>`/outbox       | The usual location for the accounting records |
| /var/lib/gratia/tmp/grataifiles/`<PROBE-RECORDS>`/staged/store | An overflow location when there are problems  |

When you recover old records, you need to:

1.  Move files from the outbox of the incorrect *probe-records* directory into the outbox of the correctly named *probe-records* directory.
2.  Move tarred and compressed files from the staged/store of the incorrect *probe-records* directory into the staged/store of the correctly named *probe-records* directory. Then you uncompress them and remove the compressed version.

In the examples below, the hostname for gratia was "accidentally" spelled backwards. Instead of `gratia-osg-itb.opensciencegrid.org`, it was `aitarg-osg-itb.opensciencegrid.org`.

1. First you need to fix the hostname. For a CE, you can edit `/etc/osg/config.d/30-gratia.ini` and rerun `osg-configure -c`. In other installations, you have to edit the appropriate `ProbeConfig` file.

2. Next, submit a job via to your batch system, then run the appropriate Gratia probe (or wait for it to run via cron). This will create the properly named directories on your disk. For example:

    As a user: 

        :::console
        user@host $ globus-job-run fermicloud084.fnal.gov/jobmanager-condor /bin/hostname 

    As root (adjust for your batch system): 

        :::console
        root@host # /share/gratia/condor/condor\_meter

3. Find the Gratia records that can be easily uploaded. They are located in a a directory with an unwieldly name that
includes your hostname and the incorrect name of the Gratia host. You can see the directory name in the Gratia log: the
misspelled name is between angled brackets and capital letters below, but *it will be different on your computer*.

        :::console
        user@host $ less /var/log/gratia/2012-04-06
        ...
        16:04:29 CDT Gratia: Response indicates failure, the following files will not be deleted:
        16:04:29 CDT Gratia:    /var/lib/gratia/tmp/gratiafiles/
            subdir.condor_fermicloud084.fnal.gov_<AITARG>-osg-itb.opensciencegrid.org_80/
            outbox/r.916.condor_fermicloud084.fnal.gov_aitarg-osg-itb.opensciencegrid.org_80.gratia.xml__JDlHbNb918

    (The filename was wrapped for legibility.)

    You can simply copy these to the correct directory. Wait for the Gratia cron job to run, or force it to run.

        :::console
        root@host # cd /var/lib/gratia/tmp/gratiafiles/subdir.condor_fermicloud084.fnal.gov_<AITARG>-osg-itb.opensciencegrid.org_80/outbox/.
        root@host # mv * /var/lib/gratia/tmp/gratiafiles/subdir.condor_fermicloud084.fnal.gov_gratia-osg-itb.opensciencegrid.org_80/outbox/.


4. If this has been a persistent problem, you might have many records. After a while, they are put into a compressed files in another directory. You can move those files, then uncompress them. This is a long name: note that the path ends in "staged/store" instead of "outbox" as above:

        :::console
        # Find the old files
        root@host # cd /var/lib/gratia/tmp/gratiafiles/subdir.condor_fermicloud084.fnal.gov_<AITARG>-osg-itb.opensciencegrid.org_80/staged/store

        # Move them to the correct directory
        root@host # mv tz* /var/lib/gratia/tmp/gratiafiles/subdir.condor_fermicloud084.fnal.gov_gratia-osg-itb.opensciencegrid.org_80/outbox/.
        root@host # cd !$

        # For each tz file:
        root@host # tar xf tz.1223.... [name shortened for legibility]
        root@host # rm tz.1223....


    When you've done this, you can re-run the Gratia probe by hand, or wait for it to run via cron.

Reference: Important Gratia files
--------------------------------

If you need to look for more data, you can look at log files for the various services on your CE.

| File                                                | Purpose                                                                                                                                                                            |
|:----------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `/var/log/gratia/<DATE>.log`                        | Log file that records information about processing and uploading of Gratia accounting data                                                                                         |
| `/var/log/gratia/gridftpTransfer.log`               | Log file specific to the Gratia GridFTP probe                                                                                                                                      |
| `/var/lib/gratia/data`                              | Location for Condor and PBS job data before being processed by Gratia<br>Condor's `PER_JOB_HISTORY_DIR` should be set to this location                                       |
| `/var/lib/gratia/tmp/gratiafiles`                   | Location for temporary Gratia data as it is being processed, usually empty.<br>If you have files that are more than 30 minutes old in this directory, there may be a problem |
| `/etc/gratia/<PROBE-NAME>/ProbeConfig`              | Configuration for Gratia probes, one per probe type</br>Normally you don't need to edit this                                                                                 |

Not all RPMs will be on all hosts.  Instead, only the `gratia-probe-common` and the one RPM specific to that host will be installed. The most common RPMs you will see are:

| RPM                             | Purpose                                                                             |
|:--------------------------------|:------------------------------------------------------------------------------------|
| `gratia-probe-common`           | Code shared between all Graita probes                                               |                            |
| `gratia-probe-condor`           | The probe that tracks Condor usage                                         |
| `gratia-probe-slurm`           | The probe that tracks SLURM usage                                         |
| `gratia-probe-pbs-lsf`          | The probe that tracks PBS and/or LSF usage                                  |
| `gratia-probe-gridftp-transfer` | The probe that tracks transfers done with GridFTP                                   |


