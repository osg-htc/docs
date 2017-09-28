Using rsv-control
=================

<span class="twiki-macro DOC_STATUS_TABLE"></span> <span class="twiki-macro TOC"></span>

About this Document
===================

<span class="twiki-macro ICON">hand</span> This document is for System Administrators. It details the usage of the rsv-control command for enabling, disabling, testing and running RSV probes. You need to [install RSV](InstallRSV) in order to use `rsv-control`.

`rsv-control` provides an interface to many RSV tasks. `rsv-control` can view RSV jobs, run metrics, enable or disable metrics and consumers, and allow advanced configuration.

<span class="twiki-macro WARNING"></span> `rsv-control` can be used to configure RSV as described here and in [the advanced configuration document](ConfigureRsv). Anyway most site admins will be able to configure RSV by editing `/etc/osg/config.d/30-rsv.ini` and running `osg-configure` as described in [InstallRSV](InstallRSV#Configuration).

Using `rsv-control` to configure is for advanced RSV use including enabling non-default metrics. Admins who don't use `rsv-control` for configuration can still use it to view their RSV jobs, run RSV tests, and help debug RSV problems. Anyone can view the jobs, but you must be root or the RSV user (`rsv` by default) to execute other commands, e.g. run, enable and disable probes, or to turn RSV on and off.

How to get Help?
================

To get assistance please use [Help Procedure](HelpProcedure). Check the [rsv-profiler](#RsvProfiler) section below to see how to send additional debugging information with your ticket.

<span class="twiki-macro STARTINCLUDE"></span>

<span class="twiki-macro STARTSECTION">RsvView</span> ---%SHIFT%+ Viewing RSV jobs

rsv-control provides two different views: viewing the *desired* state and viewing the current *actual* state.

-   Desired = what metrics and consumers will start the next time RSV is started
-   Actual = what metrics and consumers are currently running

---%SHIFT%++ Desired state To view the desired state, use the `--list` (`-l` for short) flag. This will create one table for each host showing the metrics that are enabled to run against that host. <span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED%</span>

``` screen
%UCL_PROMPT_SHORT% rsv-control --list

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

<span class="twiki-macro ENDTWISTY"></span>

Other options:

-   To view all installed metrics use the `--all` (`-a`) flag along with `--list`. This will print an extra table showing metrics that are disabled on all hosts.
-   If you are having problems with the output being truncated, try the `--wide` (`-w`) flag.

---%SHIFT%++ Actual state To view the current, running state of RSV jobs, use the `--job-list` flag (`-j` for short). This will show all metrics and consumers running in RSV. (It queries the underlying Condor Cron system that we use to run the metrics) <span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED%"</span>

``` screen
%UCL_PROMPT_SHORT% rsv-control --job-list

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

<span class="twiki-macro ENDTWISTY"></span>

The ST field indicates the current job status:

-   R = the metric is currently running
-   I = the metric is idle and will be run at the next scheduled interval
-   Any other letter may indicate a problem
-   Consumers will always appear to be running even though they will only run once every five minutes.

<span class="twiki-macro ENDSECTION">RsvView</span>

<span class="twiki-macro STARTSECTION">RsvRun</span>

Running a metric
================

`rsv-control` can be used to run metrics one time against a host. This can be useful for:

-   updating the status of a metric that had a problem instead of waiting until the next scheduled run time
-   testing a metric against a host before deciding whether to enable it

Note that **the record for each run will be published to all active consumers**. That is, it will be published to Gratia or will show up on your local web page, if you have those enabled.

---%SHIFT%++ Simplest test:

Use the `--run` (`-r`) flag. You must also provide the `--host` flag (`--host` can be abbreviated `-u` which is short for URI, the old and inaccurate RSV term for host \[+ port\]). The syntax is:

`rsv-control --run --host _HOST_ _METRIC_ [ _METRIC2_ ...]`

where METRIC is the full metric name (e.g. org.osg.general.osg-version). You can get the metric names from the `--list` output.

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED%" showlink="Show the example"</span>

``` rootscreen
%UCL_PROMPT_SHORT% rsv-control --run --host osg-edu.cs.wisc.edu org.osg.general.osg-version

Running metric org.osg.general.osg-version:

metricName: org.osg.general.osg-version
metricType: status
timestamp: 2010-11-19 11:40:19 CST
%RED%metricStatus: OK%ENDCOLOR%
serviceType: OSG-CE
serviceURI: osg-edu.cs.wisc.edu
gatheredAt: vdt-itb.cs.wisc.edu
summaryData: OK
detailsData: OSG 1.2.15
EOT
```

Note the *metricStatus* in the example above: that's where you can see if it was successful or not. In this case, it was successful, because it printed OK. <span class="twiki-macro ENDTWISTY"></span>

---%SHIFT%++ Running multiple metrics

Running multiple metrics against a single host is easy, just specify multiple metrics to `rsv-control`. <span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED% showlink="Show the example"</span>

``` screen
%UCL_PROMPT_SHORT% rsv-control -r -u osg-edu.cs.wisc.edu org.osg.general.vo-supported org.osg.globus.gram-authentication org.osg.globus.gridftp-simple

Running metric org.osg.general.vo-supported (1 of 3)

metricName: org.osg.general.vo-supported
metricType: status
timestamp: 2010-11-19 13:40:40 CST
metricStatus: OK
serviceType: OSG-CE
serviceURI: osg-edu.cs.wisc.edu
gatheredAt: vdt-itb.cs.wisc.edu
summaryData: OK
detailsData: # List of VOs this site claims to support mis osgedu
EOT


Running metric org.osg.globus.gram-authentication (2 of 3)

metricName: org.osg.globus.gram-authentication
metricType: status
timestamp: 2010-11-19 13:40:55 CST
metricStatus: OK
serviceType: OSG-CE
serviceURI: osg-edu.cs.wisc.edu
gatheredAt: vdt-itb.cs.wisc.edu
summaryData: OK
detailsData: GRAM Authentication test successful
EOT


Running metric org.osg.globus.gridftp-simple (3 of 3)

metricName: org.osg.globus.gridftp-simple
metricType: status
timestamp: 2010-11-19 13:40:56 CST
metricStatus: OK
serviceType: OSG-GridFtp
serviceURI: osg-edu.cs.wisc.edu
gatheredAt: vdt-itb.cs.wisc.edu
summaryData: OK
detailsData: Gridftp was succesfully tested! Upload to and download from remote host succeeded; Received file is valid.
EOT
```

<span class="twiki-macro ENDTWISTY"></span>

In order to run metrics against multiple hosts you must run `rsv-control` multiple times, once for each host.

Running all enabled metrics
---------------------------

When RSV is first installed it can take up to a day for each enabled metric to run once. A new option is provided to force each metric to run immediately, for all hosts. Use the `--all-enabled` flag along with `--run`. With this option it is not necessary to specify a host - all enabled metrics for all configured hosts will be run (in fact, if you do specify a host it will be ignored).

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED% showlink="Show the example"</span>

``` screen
%UCL_PROMPT_SHORT% rsv-control -r --all-enabled

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


Running metric org.osg.gratia.metric (2 of 15)

.
.
.
Output trimmed
```

<span class="twiki-macro ENDTWISTY"></span>

---%SHIFT%++ Passing extra configuration

**Add a link here pointing at documentation about the configuration files**

If you want to pass extra configuration when running a metric without editing its configuration file you can make an INI-formatted file and pass it on the command line. For example, you can make a file like this for the `org.osg.srm.srmclient-ping` metric (tmp-srm.ini):

``` file
[org.osg.srm.srmclient-ping args]
srm-destination-dir=/srmcache/~
srm-webservice-path=srm/v2/server
```

Then use the `--extra-config-file` parameter and pass the path to the INI file. <span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED% showlink="Show the example"</span>

``` rootscreen
%UCL_PROMPT_SHORT% rsv-control -r --extra-config-file tmp-srm.ini -u osg-edu.cs.wisc.edu:10443 org.osg.srm.srmclient-ping

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

Output trimmed
```

<span class="twiki-macro ENDTWISTY"></span> <span class="twiki-macro ENDSECTION">RsvRun</span>

<span class="twiki-macro STARTSECTION">RsvEnableDisable</span> ---%SHIFT%+ Enabling and disabling metrics and consumers

Metrics and consumers can be enabled or disabled by `rsv-control` using the `--enable` and `--disable` flags. Note that "enable" and "disable" are desired states (this is similar to `vdt-control`). After enabling a metric you should turn it on if you want it to be running immediately. After disabling a metric that is running, you should still turn it off (a message will print after each of these actions to remind you of this behavior).

---%SHIFT%++ Enabling

The syntax for enabling metrics looks similar to the syntax for running metrics:

`rsv-control --enable --host _HOST_ _METRIC_ [ _METRIC2_ ...]`

You must provide a host to enable the metric against (in order to enable a metric on multiple hosts you must run `rsv-control` once per host).

Consumers do not run against a specific host, they process records for all hosts. When enabling consumers a host is not required (if a host is passed it will be ignored).

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED% showlink="Example of enabling a metric"</span>

``` rootscreen
%UCL_PROMPT_SHORT% rsv-control --enable --host osg-edu.cs.wisc.edu org.osg.gip.consistency 
Enabling metric 'org.osg.gip.consistency' for host 'osg-edu.cs.wisc.edu'

One or more metrics have been enabled and will be started the next time RSV is started.  To turn them on immediately run 'rsv-control --on'.
```

<span class="twiki-macro ENDTWISTY"></span>

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED% showlink="Example of enabling a consumer"</span>

``` rootscreen
%UCL_PROMPT_SHORT% rsv-control --enable nagios-consumer
Enabling consumer nagios-consumer
```

<span class="twiki-macro ENDTWISTY"></span>

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED% showlink="Example of enabling multiple metrics"</span>

``` rootscreen
%UCL_PROMPT_SHORT%  rsv-control --enable --host vdt-itb.cs.wisc.edu org.osg.local.hostcert-expiry org.osg.local.httpcert-expiry org.osg.local.containercert-expiry
Enabling metric 'org.osg.local.hostcert-expiry' for host 'vdt-itb.cs.wisc.edu'
Enabling metric 'org.osg.local.httpcert-expiry' for host 'vdt-itb.cs.wisc.edu'
   Metric already enabled
Enabling metric 'org.osg.local.containercert-expiry' for host 'vdt-itb.cs.wisc.edu'

One or more metrics have been enabled and will be started the next time RSV is started.  To turn them on immediately run 'rsv-control --on'.
```

<span class="twiki-macro ENDTWISTY"></span>

---%SHIFT%++ Disabling The syntax for disabling metrics looks similar to the syntax for running metrics:

`rsv-control --disable --host _HOST_ _METRIC_ [ _METRIC2_ ...]`

You must provide a host to disable the metric against (in order to disable a metric on multiple hosts you must run `rsv-control` once per host).

Consumers do not run against a specific host, they process records for all hosts. When disabling consumers a host is not required (if a host is passed it will be ignored).

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED% showlink="Example of disabling a metric"</span>

``` rootscreen
%UCL_PROMPT_SHORT% rsv-control --disable -u vdt-itb.cs.wisc.edu org.osg.local.containercert-expiry
Disabling metric 'org.osg.local.containercert-expiry' for host 'vdt-itb.cs.wisc.edu'

One or more metrics have been disabled and will not start the next time RSV is started.  You may still need to turn them off if they are currently running.
```

<span class="twiki-macro ENDTWISTY"></span>

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED% showlink="Example of disabling multiple consumers"</span>

``` rootscreen
%UCL_PROMPT_SHORT% rsv-control --disable html-consumer gratia-consumer
Disabling consumer html-consumer
Disabling consumer gratia-consumer
   Consumer already disabled
```

<span class="twiki-macro ENDTWISTY"></span>

Metrics and consumers can both be listed in the same disable command. <span class="twiki-macro ENDSECTION">RsvEnableDisable</span>

---%SHIFT%+ Troubleshooting

<span class="twiki-macro STARTSECTION">RsvControlVerbose</span> ---%SHIFT%++ Getting more information from rsv-control The first step to getting more information is to run `rsv-control` with more verbosity. Use the `--verbose` (`-v`) flag. This flag can be used with any of rsv-control's abilities (run, enable, list, etc). The verbosity levels are:

-   0 = print nothing
-   1 = print warnings and errors along with usual output of command being run (1 is the default level)
-   2 = adds informational messages
-   3 = full debugging output

For example, here is the output when running a metric with -v2. <span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED%</span>

``` rootscreen
[root@fermicloud016 condor]# rsv-control -r org.osg.general.osg-version -v 2 -u osg-edu.cs.wisc.edu
INFO: Reading configuration file /etc/rsv/rsv.conf
INFO: Reading configuration file /etc/rsv/consumers.conf
INFO: Validating configuration:
INFO: Validating user:
INFO:     Invoked as root.  Switching to 'rsv' user (uid: 100 - gid: 102)
INFO: Registered consumers: html-consumer, gratia-consumer
INFO: Loading config file '/etc/rsv/meta/metrics/org.osg.general.osg-version.meta'
INFO: Loading config file '/etc/rsv/metrics/org.osg.general.osg-version.conf'
INFO: Optional config file '/etc/rsv/metrics/osg-edu.cs.wisc.edu/org.osg.general.osg-version.conf' does not exist
INFO: Checking proxy:
INFO:     Using service certificate proxy
INFO: Running command with timeout (1200 seconds):
        /usr/bin/openssl x509 -in /tmp/rsvproxy -noout -enddate -checkend 21600
INFO: Exit code of job: 0
INFO:     Service certificate valid for at least 6 hours.
INFO: Pinging host osg-edu.cs.wisc.edu:
INFO: Running command with timeout (1200 seconds):
        /bin/ping -W 3 -c 1 osg-edu.cs.wisc.edu
INFO: Exit code of job: 0
INFO:     Ping successful

Running metric org.osg.general.osg-version:

INFO: Executing job remotely using Condor-G
INFO: Setting up job environment:
INFO:     No environment setup declared
INFO: Condor-G working directory: /var/tmp/rsv/condor_g-JiQthF
INFO: Forming arguments:
INFO:     Arguments: ''
INFO: List of files to transfer: /usr/libexec/rsv/probes/RSVMetric.pm
INFO: Condor submission: Submitting job(s).
1 job(s) submitted to cluster 2.
INFO: Trimming data to 10000 bytes because details-data-trim-length is set
INFO: Creating record for html-consumer consumer at '/var/spool/rsv/html-consumer/org.osg.general.osg-version.7rgLfn'
INFO: Creating record for gratia-consumer consumer at '/var/spool/rsv/gratia-consumer/org.osg.general.osg-version.-qelnL'
INFO: Result:

metricName: org.osg.general.osg-version
metricType: status
timestamp: 2012-01-25 16:12:40 CST
metricStatus: OK
serviceType: OSG-CE
serviceURI: osg-edu.cs.wisc.edu
gatheredAt: fermicloud016.fnal.gov
summaryData: OK
detailsData: OSG 1.2.26

EOT
```

<span class="twiki-macro ENDTWISTY"></span>

<span class="twiki-macro ENDSECTION">RsvControlVerbose</span>

<span class="twiki-macro STARTSECTION">RsvVerify</span> ---%SHIFT%++ Using the RSV verify tool The `--verify` flag will run some basic checks for your RSV installation. <span class="twiki-macro TWISTY">%TWISTY\_OPTS\_DETAILED%</span>

``` screen
%UCL_PROMPT_SHORT% rsv-control --verify
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

<span class="twiki-macro ENDTWISTY"></span>

This tool is still under development and it does only basic checks, but it is a good first step when debugging issues. <span class="twiki-macro ENDSECTION">RsvVerify</span>

\#RsvProfiler ---%SHIFT%++ Running the rsv-profiler <span class="twiki-macro STARTSECTION">RsvProfilerNT</span> RSV has a tool to collect information useful for troubleshooting. For most problems the RSV support team will ask you to generate a profile tarball to share information (including log and configuration files). You can save some time by doing so with your original request:

``` screen
%UCL_PROMPT_SHORT% rsv-control --profile
Running the rsv-profiler...
OSG-RSV Profiler
Analyzing...
Making tarball (rsv-profiler.tar.gz)
```

<span class="twiki-macro ENDSECTION">RsvProfilerNT</span>

<span class="twiki-macro STOPINCLUDE"></span>

References
==========

RSV documents

-   A [Introduction to RSV](RsvOverview)
-   The [RSV architecture](RsvArchitecture)
-   InstallRSV

Comments
========

<span class="twiki-macro COMMENT" type="tableappend"></span>
