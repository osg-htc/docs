Using rsv-control
=================

Overview
--------

This document is for System Administrators. It details the usage of the `rsv-control` command for enabling, disabling, testing and running RSV probes.

`rsv-control` provides an interface to many RSV tasks. `rsv-control` can view RSV jobs, run metrics, enable or disable metrics and consumers, and allow advanced configuration.

!!! warning
    `rsv-control` can be used to configure RSV as described here and in [the advanced configuration document](advanced-rsv-configuration.md). Most site admins will be able to configure RSV by editing `/etc/osg/config.d/30-rsv.ini` and running `osg-configure` as described in the [installation doc](install-rsv.md#configuring-rsv).

Using `rsv-control` to configure is for advanced RSV use including enabling non-default metrics. Admins who don't use `rsv-control` for configuration can still use it to view their RSV jobs, run RSV tests, and help debug RSV problems. Anyone can view the jobs, but you must be root or the RSV user (`rsv` by default) to execute other commands, e.g. run, enable and disable probes, or to turn RSV on and off.

Viewing RSV jobs
----------------

rsv-control provides two different views: viewing the *desired* state and viewing the current *actual* state.

-   Desired = what metrics and consumers will start the next time RSV is started
-   Actual = what metrics and consumers are currently running

### Desired state
To view the desired state, use the `--list` (`-l` for short) flag. This will create one table for each host showing the metrics that are enabled to run against that host.

``` console
root@host# rsv-control --list

Metrics enabled for host: osgitb1.nhn.ou.edu              | Service
----------------------------------------------------------+--------------------
org.osg.batch.jobmanager-default-status                   | OSG-CE
org.osg.batch.jobmanagers-available                       | OSG-CE
org.osg.certificates.cacert-expiry                        | OSG-CE
org.osg.certificates.crl-expiry                           | OSG-CE
org.osg.general.osg-directories-CE-permissions            | OSG-CE
org.osg.general.osg-version                               | OSG-CE
org.osg.general.ping-host                                 | OSG-CE
org.osg.general.vdt-version                               | OSG-CE
org.osg.general.vo-supported                              | OSG-CE
org.osg.globus.gram-authentication                        | OSG-CE
org.osg.globus.gridftp-simple                             | OSG-GridFTP
org.osg.gratia.condor                                     | OSG-CE
org.osg.gratia.metric                                     | OSG-CE


Metrics enabled for host: osg-edu.cs.wisc.edu:10443       | Service
----------------------------------------------------------+--------------------
org.osg.srm.srmcp-readwrite                               | OSG-SRM
org.osg.srm.srmping                                       | OSG-SRM
```


Other options:

-   To view all installed metrics use the `--all` (`-a`) flag along with `--list`. This will print an extra table showing metrics that are disabled on all hosts.
-   If you are having problems with the output being truncated, try the `--wide` (`-w`) flag.

### Actual state
To view the current, running state of RSV jobs, use the `--job-list` flag (`-j` for short). This will show all metrics and consumers running in RSV. (It queries the underlying Condor Cron system that we use to run the metrics).

``` console
root@host# rsv-control --job-list

Hostname: osg-edu.cs.wisc.edu
     ID OWNER      ST NEXT RUN TIME   METRIC
  154.0 rsvuser    I  11-19 12:15     org.osg.certificates.cacert-expiry
  155.0 rsvuser    R  11-19 11:23     org.osg.gratia.metric
  156.0 rsvuser    I  11-19 18:47     org.osg.general.vdt-version
  157.0 rsvuser    I  11-19 12:30     org.osg.certificates.crl-expiry
  158.0 rsvuser    I  11-19 11:31     org.osg.globus.gram-authentication
  159.0 rsvuser    I  11-19 11:41     org.osg.general.osg-version
  160.0 rsvuser    R  11-19 11:25     org.osg.batch.jobmanager-default-status
  161.0 rsvuser    I  11-20 04:59     org.osg.batch.jobmanagers-available
  162.0 rsvuser    I  11-19 11:37     org.osg.general.osg-directories-CE-permissions
  163.0 rsvuser    I  11-19 12:08     org.osg.globus.gridftp-simple
  164.0 rsvuser    I  11-19 12:09     org.osg.gratia.condor
  165.0 rsvuser    R  11-19 11:27     org.osg.general.ping-host
  166.0 rsvuser    I  11-19 18:47     org.osg.general.vo-supported

Hostname: osg-edu.cs.wisc.edu:10443
     ID OWNER      ST NEXT RUN TIME   METRIC
  113.0 rsvuser    I  11-19 11:33     org.osg.srm.srmping
  114.0 rsvuser    R  11-19 11:28     org.osg.srm.srmcp-readwrite

     ID OWNER      ST CONSUMER
  198.0 rsvuser    R  html-consumer
  199.0 rsvuser    R  gratia-consumer
```

The ST field indicates the current job status:

-   R = the metric is currently running
-   I = the metric is idle and will be run at the next scheduled interval
-   Any other letter may indicate a problem
-   Consumers will always appear to be running even though they will only run once every five minutes.

Running a metric
----------------

`rsv-control` can be used to run metrics one time against a host. This can be useful for:

-   updating the status of a metric that had a problem instead of waiting until the next scheduled run time
-   testing a metric against a host before deciding whether to enable it

Note that **the record for each run will be published to all active consumers**. That is, it will be published to Gratia or will show up on your local web page, if you have those enabled.

### Simplest test

Use the `--run` (`-r`) flag. You must also provide the `--host` flag. The syntax is:

`rsv-control --run --host <HOST> <METRIC> [ <METRIC2> ...]`

where &lt;METRIC&gt; is the full metric name (e.g. `org.osg.general.osg-version`). You can get the metric names from the `--list` output.

``` console
root@host# rsv-control --run \
    --host osg-edu.cs.wisc.edu org.osg.general.osg-version

Running metric org.osg.general.osg-version:

metricName: org.osg.general.osg-version
metricType: status
timestamp: 2010-11-19 11:40:19 CST
metricStatus: OK
serviceType: OSG-CE
serviceURI: osg-edu.cs.wisc.edu
gatheredAt: vdt-itb.cs.wisc.edu
summaryData: OK
detailsData: OSG 1.2.15
EOT
```

Note the *metricStatus* in the example above: that's where you can see if it was successful or not. In this case, it was successful, because it printed OK.

You may run multiple metrics against a single host by specifying multiple metrics to `rsv-control`.

In order to run metrics against multiple hosts you must run `rsv-control` multiple times, once for each host.

### Running all enabled metrics

When RSV is first installed it can take up to a day for each enabled metric to run once. A new option is provided to force each metric to run immediately, for all hosts. Use the `--all-enabled` flag along with `--run`. With this option it is not necessary to specify a host - all enabled metrics for all configured hosts will be run (in fact, if you do specify a host it will be ignored).

``` console
root@host# rsv-control -r --all-enabled

Running metric org.osg.certificates.cacert-expiry (1 of 15)

metricName: org.osg.certificates.cacert-expiry
metricType: status
timestamp: 2010-11-19 13:44:08 CST
metricStatus: OK
serviceType: OSG-CE
serviceURI: osg-edu.cs.wisc.edu
gatheredAt: vdt-itb.cs.wisc.edu
summaryData: OK
detailsData: Security Probe Version: 1.1
OK: CAs are in sync with OSG distribution
EOT


...
```


### Passing extra configuration

If you want to pass extra configuration when running a metric without editing its configuration file you can make an INI-formatted file and pass it on the command line. For example, you can make a file like this for the `org.osg.srm.srmclient-ping` metric (tmp-srm.ini):

``` dosini
[org.osg.srm.srmclient-ping args]
srm-destination-dir=/srmcache/~
srm-webservice-path=srm/v2/server
```

Then use the `--extra-config-file` parameter and pass the path to the INI file:

``` console
root@host# rsv-control -r --extra-config-file tmp-srm.ini \
    --host osg-edu.cs.wisc.edu:10443 org.osg.srm.srmclient-ping

Running metric org.osg.srm.srmclient-ping:

metricName: org.osg.srm.srmclient-ping
metricType: status
timestamp: 2010-11-19 14:12:35 CST
metricStatus: OK
serviceType: OSG-SRM
serviceURI: osg-edu.cs.wisc.edu:10443
gatheredAt: vdt-itb.cs.wisc.edu
summaryData: OK
detailsData: SRM server running on osg-edu.cs.wisc.edu is alive and responding to the srmping command.
.  Details: Storage Resource Manager (SRM) Client version 2.1.5-16
Copyright (c) 2002-2009 Fermi National Accelerator Laboratory

...
```

Enabling and disabling metrics and consumers
--------------------------------------------

Metrics and consumers can be enabled or disabled by `rsv-control` using the `--enable` and `--disable` flags. Note that "enable" and "disable" are desired states (this is similar to `osg-control`). After enabling a metric you should turn it on if you want it to be running immediately. After disabling a metric that is running, you should still turn it off (a message will print after each of these actions to remind you of this behavior).

### Enabling

The syntax for enabling metrics looks similar to the syntax for running metrics:

`rsv-control --enable --host <HOST> <METRIC> [ <METRIC2> ...]`

You must provide a host to enable the metric against (in order to enable a metric on multiple hosts you must run `rsv-control` once per host).


``` console
root@host# rsv-control --enable \
    --host osg-edu.cs.wisc.edu org.osg.gip.consistency
Enabling metric 'org.osg.gip.consistency' for host 'osg-edu.cs.wisc.edu'

One or more metrics have been enabled and will be started the next time RSV is started.  To turn them on immediately run 'rsv-control --on'.
```

Consumers do not run against a specific host, they process records for all hosts. When enabling consumers a host is not required (if a host is passed it will be ignored).


``` console
root@host# rsv-control --enable nagios-consumer
Enabling consumer nagios-consumer
```



### Disabling

The syntax for disabling metrics looks similar to the syntax for running metrics:

`rsv-control --disable --host <HOST> <METRIC> [ <METRIC2> ...]`

You must provide a host to disable the metric against (in order to disable a metric on multiple hosts you must run `rsv-control` once per host).


``` console
root@host# rsv-control --disable \
    --host vdt-itb.cs.wisc.edu org.osg.local.containercert-expiry
Disabling metric 'org.osg.local.containercert-expiry' for host 'vdt-itb.cs.wisc.edu'

One or more metrics have been disabled and will not start the next time RSV is started.  You may still need to turn them off if they are currently running.
```

Consumers do not run against a specific host, they process records for all hosts. When disabling consumers a host is not required (if a host is passed it will be ignored).

``` console
root@host# rsv-control --disable html-consumer gratia-consumer
Disabling consumer html-consumer
Disabling consumer gratia-consumer
   Consumer already disabled
```


Metrics and consumers can both be listed in the same disable command.

Troubleshooting
---------------

### Getting more information from rsv-control
The first step to getting more information is to run `rsv-control` with more verbosity. Use the `--verbose` (`-v`) flag. This flag can be used with any of rsv-control's abilities (run, enable, list, etc). The verbosity levels are:

-   0 = print nothing
-   1 = print warnings and errors along with usual output of command being run (1 is the default level)
-   2 = adds informational messages
-   3 = full debugging output


### Using the RSV verify tool
The `--verify` flag will run some basic checks for your RSV installation:

``` console
root@host# rsv-control --verify
Testing if Condor-Cron is running...
OK

Testing if metrics are running...
OK (98 running metrics)

Testing if consumers are running...
OK (1 running consumers)

Checking which consumers are configured...
The following consumers are enabled: html-consumer
WARNING: The gratia-consumer is not enabled.  This indicates that your
         resource is not reporting to OSG.
```


This tool is still under development and it does only basic checks, but it is a good first step when debugging issues.


### Running the RSV profiler

RSV has a tool to collect information useful for troubleshooting into a tarball that can be shared with the developers and support staff.
To use it:

``` console
root@host# rsv-control --profile
Running the rsv-profiler...
OSG-RSV Profiler
Analyzing...
Making tarball (rsv-profiler.tar.gz)
```

!!! note
    If you are getting assistance via the trouble ticket system, you must add a `.txt` extension to the tarball so it can be uploaded.

        :::console
        root@host# mv rsv-profiler.tar.gz rsv-profiler.tar.gz.txt


