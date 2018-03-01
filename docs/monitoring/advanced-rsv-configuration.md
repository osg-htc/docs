Advanced RSV Configuration
==========================


About This Document
-------------------

Most site administrators will be able to configure RSV by editing `/etc/osg/config.d/30-rsv.ini` and running osg-configure as described in [the RSV installation document](install-rsv#configuring-rsv).  This document provides instructions for configuration beyond what osg-configure is able to do.


Configuring metrics
-------------------

If you need to change the behavior of a metric you can edit the metric configuration files. These replace the spec files from previous versions of RSV.

-   `/etc/rsv/metrics` - changes made to conf file in this directory named after a metric will affect the metric when run against all hosts
-   `/etc/rsv/metrics/<HOST>` - changes made to conf files in this directory (named as the host FQDN) will affect the metric when run against the specific host

The configuration files are in INI format and have two sections:

-   a first one named after the metric with execution options
-   a second one with the name including the "args" keyword, including parameters sent to the probe at invokation

### Changing the times a metric runs

To change the time a metric runs set the `cron-interval` setting in the metric's conf file. Use `man 5 crontab` for a description of the format. For example, to change the `org.osg.general.ping-host` to run at a different time:

``` dosini
[org.osg.general.ping-host]
cron-interval = 45 * * * *

[org.osg.general.ping-host args]
#ping-count =
#ping-timeout =
```

!!! note
    Be sure to put the `cron-interval` setting in the `[org.osg.general.ping-host]` section, and not the `[org.osg.general.ping-host args]` section! The purpose of the "args" section is described in the "passing extra parameters to a metric" section below.

After modifying the cron time of a metric you must restart RSV for the change to take effect.

To see what times each of the metrics is running you can use `rsv-control` as follows:

``` console
root@host# rsv-control -l --cron-times

Metrics enabled for host: osg-edu.cs.wisc.edu:10443 | Cron times
----------------------------------------------------+--------------------
org.osg.srm.srmcp-readwrite                         | 28 * * * *
org.osg.srm.srmping                                 | 13,33,53 * * * *
...
```

### Passing extra parameters to a metric

Any `key=value` pairs in the "args" section of the metric's *conf* file will be turned into command line parameters to the probe. For example, for this file:

``` dosini
[org.osg.certificates.cacert-expiry args]
warning-hours = 6
error-hours = 12
```

This would lead to the probe getting called with the command-line parameters `--warning-hours 6 --error-hours 12`.

Configure consumers
-------------------

There is a configuration file common to all consumers: `/etc/rsv/consumers.conf`. It is a file in INI format and possible entries are:

| Setting   | Values            | Details                                                                                                                                                                             |
|:----------|:------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| enabled   | &lt;consumers&gt; | Comma-separated list of consumers to be enabled                                                                                                                                     |
| timestamp | local             | If this is set to local, a record with a local timestamp will be supplied to the consumer. If this is set to any other value, or is not set, a record with the GMT will be created. |

Each consumer has a configuration file in `/etc/rsv/consumers` named after it. This allows to specify command lines and environment for the consumers. Some consumers may have also their own configuration file, usually in `/etc/rsv/`. Below is an example for the Nagios consumer.


### Sending RSV records to Nagios

1.  Edit your `/etc/rsv/rsv-nagios.conf` file and fill in the appropriate information. The path of the configuration file is specified in `/etc/rsv/consumers/nagios-consumer.conf`.
2.  If your Nagios config file contains password information you will want to lock down the permissions. Here is a suggested way to do this (replace %RED%rsvuser%ENDCOLOR% with the group of your RSV user (`rsvuser` by default)):

        :::console
        root@host# chown root:%RED%rsvuser%ENDCOLOR% /etc/rsv/rsv-nagios.conf
        root@host# chmod 0440 /etc/rsv/rsv-nagios.conf

3.  In the configuration file at `/etc/rsv/consumers/nagios-consumer.conf`, check the following two settings:
    -   Make sure that the path to your config file is correct. It may be referencing a directory `config` instead of `etc`
    -   If you want to use `rsv2nsca` add the string "--send-nsca" to the `args` line.
4.  Enable and start the Nagios consumer by editing `consumers.conf` or by using `rsv-control` as follows:

        :::console
        root@host# rsv-control --enable nagios-consumer

    The Nagios consumer will be started the next time that you start RSV. If you are already running RSV you can turn on the Nagios consumer immediately by running:

        :::console
        root@host# rsv-control --on nagios-consumer

5.  To verify that the Nagios consumer is running you can run `rsv-control -j`.
6.  The log information for the Nagios consumer can be found in these files:
    -   `/var/log/rsv/consumers/nagios-consumer.log`
    -   `/var/log/rsv/consumers/nagios-consumer.out`
    -   `/var/log/rsv/consumers/nagios-consumer.err`

General RSV configuration options
---------------------------------

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
</tbody>
</table>

Troubleshooting
---------------

### Important files locations


Configuration files:

| File Description                            | Location                                        | Comment                                                      |
|:--------------------------------------------|:------------------------------------------------|:-------------------------------------------------------------|
| RSV configuration directory                 | `/etc/rsv`                                      |                                                              |
| RSV configuration                           | `/etc/rsv/rsv.conf`                             | RSV framework configuration                                  |
| Consumers configuration in RSV              | `/etc/rsv/consumers.conf`                       | Select the consumers and change generic options              |
| Consumers configuration                     | `/etc/rsv/consumers/<CONSUMERNAME>`             | To change arguments and environment                          |
| Generic metrics configuration               | `/etc/rsv/metrics/<METRICNAME>.conf`            | To change arguments and environment                          |
| Host specific metrics configuration         | `/etc/rsv/metrics/<HOSTNAME>/<METRICNAME>.conf` | To change arguments and environment when running on HOSTNAME |

Other files:

| File Description      | Location                       | Comment                 |
|:----------------------|:-------------------------------|:------------------------|
| Metric log files      | `/var/log/rsv/metrics`         |                         |
| Consumer log files    | `/var/log/rsv/consumers`       |                         |
| Initial configuration | `/etc/osg/config.d/30-rsv.ini` | Read by `osg-configure` |
| Web files output      | `/usr/share/rsv/www/`          |                         |

To find the metrics and the other files in RSV you can use also the RPM commands: `rpm -ql rsv-metrics` and `rpm -ql rsv`.

