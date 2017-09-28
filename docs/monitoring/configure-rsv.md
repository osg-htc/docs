Advanced RSV Configuration
==========================

<span class="twiki-macro DOC_STATUS_TABLE"></span> <span class="twiki-macro TOC"></span>

About This Document
===================

Most site administrators will be able to configure RSV by editing `/etc/osg/config.d/30-rsv.ini` and running osg-configure as described in [the RSV installation document](InstallRSV#Configuration).

However, if you need to do configuration beyond what osg-configure is able to do, read on...

You need a host with RSV installed according to [InstallRSV](InstallRSV). The same document instructs on [**how to get help**](InstallRSV#How_to_get_Help).

<span class="twiki-macro INCLUDE" section="RsvEnableDisable">RsvControl</span>

See the [rsv-control documentation](RsvControl) for more options.

Configure metrics
=================

If you need to change the behavior of a metric you can edit the metric configuration files. These replace the spec files from previous versions of RSV.

-   `/etc/rsv/metrics` - changes made to conf file in this directory named after a metric will affect the metric when run against all hosts
-   `/etc/rsv/metrics/<HOST>` - changes made to conf files in this directory (named as the host FQDN) will affect the metric when run against the specific host

The configuration files are in INI format and have two sections:

-   a first one named after the metric with execution options
-   a second one with the name including the "args" keyword, including parameters sent to the probe at invokation

Change the times a metric runs
------------------------------

To change the time a metric runs set the `cron-interval` setting in the metric's conf file. Use `man 5 crontab` for a description of the format. For example, to change the org.osg.general.ping-host to run at a different time: &lt;pre class="file"&gt; \[org.osg.general.ping-host\] cron-interval = 45 \* \* \* \*

\[org.osg.general.ping-host args\] \#ping-count = \#ping-timeout = &lt;/pre&gt;

<span class="twiki-macro NOTE"></span> Be sure to put the `cron-interval` setting in the \[org.osg.general.ping-host\] section, and not the \[org.osg.general.ping-host args\] section! The purpose of the "args" section is described below.

After modifying the cron time of a metric you must restart RSV for the change to take effect.

To see what times each of the metrics is running you can use rsv-control, e.g.: &lt;pre class="screen"&gt;\# rsv-control -l --cron-times

Metrics enabled for host: osg-edu.cs.wisc.edu:10443 | Cron times ----------------------------------------------------------+-------------------- org.osg.srm.srmcp-readwrite | 28 \* \* \* \* org.osg.srm.srmping | 13,33,53 \* \* \* \* ... &lt;/pre&gt;

Passing extra parameters to a metric
------------------------------------

Any key=value pairs in the 'args' section of the metric's *conf* file will be turned into command line parameters to the probe. For example, for this file: &lt;pre class="file"&gt; \[org.osg.certificates.cacert-expiry args\] warning-hours = 6 error-hours = 12 &lt;/pre&gt; This would convert to `--warning-hours 6 --error-hours 12`

Changing the default CE type that is used for all metrics
---------------------------------------------------------

Each CE can have Globus GRAM CE, HTCondor CE, or both CE types installed and running. To specify the CE type that all metrics for a particular host should use by default, do the following:

1.  Create or edit the file `/etc/rsv/metrics/<em>HOST</em>/allmetrics.conf`
2.  In that file, make sure there is an `[allmetrics]` section
3.  In that section, set the `ce-type` attribute to the default CE type
    -   For a Globus GRAM CE, use `gram`
    -   For an HTCondor CE, use `htcondor-ce`

For example, the following `allmetrics.conf` file causes all metrics for the particular host to use HTCondor CE by default:

``` file
[allmetrics]
ce-type = htcondor-ce
```

<span class="twiki-macro NOTE"></span> Metric-specific configuration files will override values in allmetrics.conf.

Configure consumers
===================

There is a configuration file common to all consumers: `/etc/rsv/consumers.conf`. It is a file in INI format and possible entries are:

| Setting   | Values            | Details                                                                                                                                                                             |
|:----------|:------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| enabled   | &lt;consumers&gt; | Comma-separated list of consumers to be enabled                                                                                                                                     |
| timestamp | local             | If this is set to local, a record with a local timestamp will be supplied to the consumer. If this is set to any other value, or is not set, a record with the GMT will be created. |

Each consumer has a configuration file in `/etc/rsv/consumers` named after it. This allows to specify command lines and environment for the consumers. Some consumers may have also their own configuration file, usually in `/etc/rsv/`. Below is an example for the Nagios consumer.

Sending RSV records to Nagios
-----------------------------

1.  Edit your `/etc/rsv/rsv-nagios.conf` file and fill in the appropriate information. The path of the configuration file is specified in `/etc/rsv/consumers/nagios-consumer.conf`. If you don't have an rsv-nagios.conf file you can download a template from <http://vdt.cs.wisc.edu/releases/2.0.0/rsv-nagios.conf>.
2.  If your Nagios config file contains password information you will want to lock down the permissions. Here is a suggested way to do this. Replace %RED%rsvuser<span class="twiki-macro ENDCOLOR"></span> with the group of your RSV user (`rsvuser` by default). &lt;pre class="screen"&gt;

chown root:%RED%rsvuser<span class="twiki-macro ENDCOLOR"></span> /etc/rsv/rsv-nagios.conf chmod 0440 /etc/rsv/rsv-nagios.conf&lt;/pre&gt;

1.  In the configuration file at `/etc/rsv/consumers/nagios-consumer.conf`, check the following two settings:
    -   Make sure that the path to your config file is correct. It may be referencing a directory `config` instead of `etc`
    -   If you want to use rsv2nsca add the string "--send-nsca" to the `args` line.
2.  Enable and start the nagios consumer by editing `consumers.conf` or by using rsv-control: &lt;pre class="screen"&gt;

rsv-control --enable nagios-consumer&lt;/pre&gt; The nagios-consumer will be started the next time that you start RSV. If you are already running RSV you can turn on the nagios-consumer immediately by running: &lt;pre class="screen"&gt; rsv-control --on nagios-consumer&lt;/pre&gt;

1.  To verify that the nagios-consumer is running you can run `rsv-control -j`.
2.  The log information for the nagios-consumer can be found in these files:
    -   `/var/log/rsv/consumers/rsv2nagios.log`
    -   `/var/log/rsv/consumers/rsv-nagios.out`
    -   `/var/log/rsv/consumers/rsv-nagios.err`

General RSV configuration options
=================================

You can configure the RSV framework using `/etc/rsv/rsv.conf`. It is a file in INI format and possible entries are:

<table>
<thead>
<tr class="header">
<th align="left">Setting</th>
<th align="left">Values</th>
<th align="left">Details</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">user</td>
<td align="left">&lt;username&gt;</td>
<td align="left">The UNIX username that owns RSV. This is mandatory</td>
</tr>
<tr class="even">
<td align="left">service-cert</td>
<td align="left">&lt;path&gt;</td>
<td align="left">Absolute path to the service certificate file. If this is set service-key and service-proxy must also be set.</td>
</tr>
<tr class="odd">
<td align="left">service-key</td>
<td align="left">&lt;path&gt;</td>
<td align="left">Absolute path to the service key file. This must be used with service-cert.</td>
</tr>
<tr class="even">
<td align="left">service-proxy</td>
<td align="left">&lt;path&gt;</td>
<td align="left">Absolute path where the service proxy will be generated. This must be used with service-cert.</td>
</tr>
<tr class="odd">
<td align="left">proxy-file</td>
<td align="left">&lt;path&gt;</td>
<td align="left">Alternative to service-cert. The absolute path where the user proxy file is located. This will not be auto-regenerated.</td>
</tr>
<tr class="even">
<td align="left">details-data-trim-length</td>
<td align="left">&lt;integer&gt;</td>
<td align="left">The number of bytes to trim the detailsData section to. If set to 0 no trimming will occur.</td>
</tr>
<tr class="odd">
<td align="left">job-timeout</td>
<td align="left">&lt;integer&gt;</td>
<td align="left">Time in seconds before a metric is killed. A metric that times out will return a CRITICAL status.</td>
</tr>
<tr class="even">
<td align="left">extra-globus-rsl</td>
<td align="left">&lt;string&gt;</td>
<td align="left">Extra RSL to pass to globus-job-run commands.<br />
For example, this would add an RSVJob attribute to a Condor classad (include the quotes): &quot;&amp;(condorsubmit=('+RSVJob' 'True'))&quot;</td>
</tr>
<tr class="odd">
<td align="left">use-condor-g</td>
<td align="left">True or False</td>
<td align="left">Defaults to True. If this is true, Condor-G will be used to run grid metrics. If this is False, globus-job-run will be used to run grid metrics and therefore will not work with pure HTCondor CE setups.</td>
</tr>
<tr class="even">
<td align="left">ce-type</td>
<td align="left">&quot;gram&quot; or &quot;htcondor-ce&quot;</td>
<td align="left">If &quot;use-condor-g&quot; is true, this determines whether grid metrics will be run with a gram gatekeeper or htcondor-ce. This setting can be overridden by host-specific metric config files or allmetrics.conf files.</td>
</tr>
</tbody>
</table>

Troubleshooting
===============

Important files locations
-------------------------

Configuration files:

| File Description                            | Location                                    | Comment                                                      |
|:--------------------------------------------|:--------------------------------------------|:-------------------------------------------------------------|
| RSV configuration directory                 | `/etc/rsv`                                  |                                                              |
| RSV configuration                           | `/etc/rsv/rsv.conf`                         | RSV framework configuration                                  |
| Consumers configuration in RSV              | `/etc/rsv/consumers.conf`                   | Select the consumers and change generic options              |
| Consumers configuration                     | `/etc/rsv/consumers/CONSUMERNAME`           | To change arguments and environment                          |
| Generic metrics configuration               | `/etc/rsv/metrics/METRICNAME.conf`          | To change arguments and environment                          |
| Host specific metrics configuration         | `/etc/rsv/metrics/HOSTNAME/METRICNAME.conf` | To change arguments and environment when running on HOSTNAME |
| Host specific default metrics configuration | `/etc/rsv/metrics/HOSTNAME/allmetrics.conf` | To change CE type                                            |

Other files:

| File Description      | Location                       | Comment                 |
|:----------------------|:-------------------------------|:------------------------|
| Metric log files      | `/var/log/rsv/metrics`         |                         |
| Consumer log files    | `/var/log/rsv/consumers`       |                         |
| Initial configuration | `/etc/osg/config.d/30-rsv.ini` | Read by `osg-configure` |
| Web files output      | `/usr/share/rsv/www/`          |                         |

To find the metrics and the other files in RSV you can use also the RPM commands: `rpm -ql rsv-metrics` and `rpm -ql rsv`.

References
==========

RSV documents

-   A [Introduction to RSV](RsvOverview)
-   The [RSV architecture](RsvArchitecture)
-   InstallRSV
-   RsvControl

Comments
========

|                                                                                                                                        |                 |                     |
|----------------------------------------------------------------------------------------------------------------------------------------|-----------------|---------------------|
| The file names for the RSV Nagios consumer logs are nagios-consumer.{err,log,out}, rather than rsv2nagios.log and rsv-nagios.{err,out} | Main.WayneBetts | 31 Jul 2015 - 18:57 |

<span class="twiki-macro COMMENT" type="tableappend"></span>
