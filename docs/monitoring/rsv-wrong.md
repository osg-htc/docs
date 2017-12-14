Installing, Configuring, Using, and Troubleshooting RSV
=======================================================

<span class="twiki-macro TOC" depth="3"></span>

About This Guide
----------------

The Resource and Service Validation (RSV) software helps a site administrator verify that certain site resources and services are working as expected. OSG recommends that sites install and run RSV, but it is optional; further, each site selects which specific tests (called *probes*) to run.

Use this page to learn more about RSV in general, and how to install, configure, run, test, and troubleshoot RSV from the OSG software repositories. For documentation on specific probes or on how to write your own probes, please check the [Reference section](#Reference).

Introduction to RSV
-------------------

<span class="twiki-macro STARTSECTION">RsvDefinition</span> The Resource and Service Validation (RSV) software provides OSG site administrators a scalable and easy-to-maintain resource and service monitoring infrastructure. The components of RSV are:

-   **RSV Client.** The client tools allow a site administrator to run tests against their site by providing a set of tests (which can run on the same or other hosts within a site), HTCondor-Cron for scheduling, and tools for collecting and storing the results (using Gratia). The client package is not installed by default and may be installed on a CE or other host. Generally, you configure the RSV client to run tests at scheduled time intervals and then it makes results available on a local website. Also, the client can upload test results to a central collector (see next item).
-   **RSV Collector/Server.** The central OSG RSV Collector accepts and stores results from RSV clients throughout OSG, which can be viewed in [MyOSG](http://myosg.grid.iu.edu/), on the “Current RSV Status” page and under the “Resource Group” menu.
-   **Periodic Availability Reports.** The availability of all active registered OSG resources and the services running on each of those resources is calculated using the results received for &lt;a href="<https://twiki.grid.iu.edu/bin/view/Operations/RsvEquivalency#Critical_Tests_for_OSG_Resources>" target="\_new"&gt;critical metrics&lt;/a&gt;. Once a day, these availability numbers are &lt;a href="<http://rsv.opensciencegrid.org/daily-reports>"&gt;published online&lt;/a&gt; and via email &lt;a href="<https://twiki.grid.iu.edu/bin/view/Trash/Trash/Trash/Trash/MeasurementsAndMetrics/RsvReportsOverview>" target="\_new"&gt; as explained here&lt;/a&gt; (More information: &lt;a href="<https://twiki.grid.iu.edu/bin/view/Operations/RSVPeriodicReporting>" target="\_new"&gt;Outline of reports&lt;/a&gt;, &lt;a href="<https://twiki.grid.iu.edu/bin/view/Trash/Trash/Trash/Trash/MeasurementsAndMetrics/RsvReports>" target="\_new"&gt;Installation guide for GOC staff&lt;/a&gt;).
-   **RSV-SAM Transport.** The WLCG RSV-SAM Transport infrastructure pushes out RSV results, for resources that are flagged to be part of the WLCG Interoperability agreement, from the GOC collector to WLCG's Service Availability Monitoring (SAM) system. More information on viewing these results is [available here](Operations.RsvSAMGridView).
-   **MyOSG and OIM Links.** RSV picks up resource information, WLCG interoperability information, etc., from a MyOSG resource group summary listing, which is in turn based on the &lt;a href="<https://oim.opensciencegrid.org>" target="\_new"&gt;OSG Information Management (OIM) (topology) system&lt;/a&gt; (Requires registration). Resource &lt;a href="<https://twiki.grid.iu.edu/twiki/bin/view/Operations/OIMMaintTool>"&gt;maintenance scheduled on OIM&lt;/a&gt;, are forwarded to WLCG SAM, if applicable.

<span class="twiki-macro ENDSECTION">RsvDefinition</span>

Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Reference section below](#ReferenceSection) as needed):

-   **User IDs:** If they do not exist already, the installation will create the Linux user IDs `rsv` and `cndrcron`
-   **Service certificate:** The RSV service requires a service certificate (`/etc/grid-security/rsv/rsvcert.pem`) and matching key (`/etc/grid-security/rsv/rsvkey.pem`)
-   **Network ports:** To view results, port 80 must accept incoming requests; outbound connectivity to tested services must work, too
-   **Host choice:** Install RSV on your site CE unless you have specific reasons (e.g., performance) for installing on a separate host

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

-   Ensure the RSV host has [a supported operating system](SupportedOperatingSystems)
-   Obtain root access to the host
-   Prepare [the required Yum repositories](YumRepositories)
-   Install [CA certificates](InstallCertAuth)

Installing RSV
--------------

An installation of RSV at a site consists of the RSV client software, the Apache web server, parts of HTCondor (for its cron-like scheduling capabilities), and various other small tools. To simplify installation, OSG provides a convenience RPM that installs all required software with a single command.

1.  Consider updating your local cache of Yum repository data and your existing RPM packages:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> yum clean all --enablerepo=\*

<span class="twiki-macro UCL_PROMPT_ROOT"></span> yum update&lt;/pre&gt; &lt;p&gt;**Note:** The `update` command will update **all** packages on your system.&lt;/p&gt;

1.  If you have installed HTCondor already but not by RPM, install a special empty RPM to make RSV happy:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> yum install empty-condor --enablerepo=osg-empty&lt;/pre&gt;
2.  Install RSV and related software: &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> yum install rsv&lt;/pre&gt;

### (Optional) Special one-time clean-up instructions for RSV perfSONAR 1.1.2 or later

If you run `rsv-perfsonar` and have upgraded from version 1.1.1 or earlier to version 1.1.2 or later, there is a clean-up step you should take to fix an unnecessary symlink. This optional, one-time procedure is recommended if it applies to your installation.

1.  Check to see if you need to perform this step:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> ls -l /usr/share/rsv/www&lt;/pre&gt; &lt;p&gt;If `www` is a symlink to `/var/www/html/rsv`, then continue with the procedure; if not, then you are done&lt;/p&gt;
2.  Stop (only) the RSV service using the instructions below
3.  Verify that RSV is not running:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> condor\_cron\_q 0 jobs; 0 completed, 0 removed, 0 idle, 0 running, 0 held, 0 suspended&lt;/pre&gt;
4.  Remove the symbolic link:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> unlink /usr/share/rsv/www&lt;/pre&gt;
5.  Move the formerly linked directory into place:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> mv -f /var/www/html/rsv /usr/share/rsv/www&lt;/pre&gt;
6.  Make sure that all RSV files are owned by RSV:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> chown -R rsv:rsv /usr/share/rsv/www&lt;/pre&gt;
7.  Restart the RSV service using the instructions below

This procedure can be done before or after upgrading the `rsv-perfsonar` package to version 1.1.2 or later.

Configuring RSV
---------------

After installation, there are some one-time configuration steps to tell RSV how to operate at your site.

1.  &lt;p&gt;Edit `/etc/osg/config.d/30-rsv.ini` and follow the instructions in the file. There are detailed comments for each setting. In the simplest case — to monitor only your CE — set the `htcondor_ce_hosts` variable (or `gram_ce_hosts` for a GRAM CE) to the fully qualified hostname of your CE. For a sample `rsv.ini` file, see the complete installation output [below](#InstallDetails).&lt;/p&gt;
2.  &lt;p&gt;If you have installed HTCondor already but not by RPM, specify the location of the Condor installation in `30-rsv.ini` in the `condor_location` setting. If an HTCondor RPM is installed, you do not need to set `condor_location`.&lt;/p&gt;
3.  &lt;p&gt;Complete the configuration using the `osg-configure` tool:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> osg-configure -v

<span class="twiki-macro UCL_PROMPT_ROOT"></span> osg-configure -c&lt;/pre&gt; &lt;p&gt;**Note:** The `osg-configure` tool produces a lot of output; see [below](#OsgConfigDetails) for an example.&lt;/p&gt;

### Optional configuration

The following configuration steps are optional and will likely not be required for setting up a small or typical site. If you do not need any of the following special configurations, skip to [the section on using RSV](#UsingRSV).

Generally speaking, read the ConfigureRsv page for more advanced configuration options. Or see [below](#ConfigFileDetails) for specific advanced configuration scenarios.

#### Configuring RSV to run probes using a remote server

RSV monitors systems by running probes, which can run on the RSV host itself (the default case), via a separate batch system like HTCondor, or via a remote batch system using a Globus gatekeeper and its job manager. The last two options both can count those jobs and report them to, for example, Gratia.

In this case, remember to:

-   Add the RSV user `rsv` on all the systems where the probes may run, and
-   Map the RSV service certificate to the user you intend to use for RSV. This should be a local user used exclusively for RSV and not belonging to an institutional VO to avoid for the RSV probes to be accounted as regular VO jobs in Gratia. This can be done in [GUMS](InstallGums) or [using a grid-mapfile-local](Edg-mkgridmap) (if you use a grid-mapfile). MapServiceCertToRsvUser explains how to configure GUMS or the grid-mapfile. Also see the [CE installation document](NavAdminCompute) for more information.

\#ConfiguringForHTTPS

#### Configuring the RSV web server to use HTTPS instead of HTTP

If you would like your local RSV web server to use HTTPS instead of the default HTTP (for compatibility or security reasons), complete the steps below. This procedure assumes that you already have an HTTP service certificate (or a copy of the host certificate) in `/etc/grid-security/http/`. If not, omit the `SSLCertificate*` modifications below, and your web server will start with its own, self-signed certificate.

1.  Install `mod_ssl`:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> yum install mod\_ssl&lt;/pre&gt;
2.  Make an alternate set of HTTP service certificate files:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> cp -p /etc/grid-security/http/httpcert.pem /etc/grid-security/http/httpcert2.pem

<span class="twiki-macro UCL_PROMPT_ROOT"></span> cp -p /etc/grid-security/http/httpkey.pem /etc/grid-security/http/httpkey2.pem <span class="twiki-macro UCL_PROMPT_ROOT"></span> chown apache:apache /etc/grid-security/http/http\*2.pem&lt;/pre&gt;

1.  Back up existing Apache configuration files:\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> cp -p /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig

<span class="twiki-macro UCL_PROMPT_ROOT"></span> cp -p /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.orig&lt;/pre&gt;

1.  Change the default port for HTTP connections to 8000 by editing `/etc/httpd/conf/httpd.conf`:\\ &lt;pre class="file"&gt;Listen 8000&lt;/pre&gt;
2.  Set up HTTPS access by editing `/etc/httpd/conf.d/ssl.conf`:\\ &lt;pre class="file"&gt;

Listen 8443 &lt;VirtualHost *default*:8443&gt; SSLCertificateFile /etc/grid-security/http/httpcert2.pem SSLCertificateKeyFile /etc/grid-security/http/httpkey2.pem&lt;/pre&gt;

After these changes, when you start the Apache service, it will listening on ports `8000` (for HTTP) and `8443` (for HTTPS), rather than the default port `80` (for HTTP only).

<span class="twiki-macro WARNING"></span> If you make the changes above, you must restart the Apache server after each CA certificate update to pick up the changes.

\#UsingRSV

Using RSV
---------

### Managing RSV and associated services

In addition to the RSV service itself, there are a number of supporting services in your installation. The specific services are:

<span class="twiki-macro TABLE" sort="off"></span>

<table>
<thead>
<tr class="header">
<th align="left">Software</th>
<th align="left">Service name</th>
<th align="left">Notes</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Fetch CRL</td>
<td align="left">On EL 6: <code>fetch-crl-boot</code> and <code>fetch-crl-cron</code><br />
On EL 5: <code>fetch-crl3-boot</code> and <code>fetch-crl3-cron</code></td>
<td align="left">See <a href="InstallCertAuth#Start_Stop_fetch_crl_A_quick_gui">CA documentation</a> for more info</td>
</tr>
<tr class="even">
<td align="left">Apache</td>
<td align="left"><code>httpd</code></td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left">HTCondor-Cron</td>
<td align="left"><code>condor-cron</code></td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left">RSV</td>
<td align="left"><code>rsv</code></td>
<td align="left"></td>
</tr>
</tbody>
</table>

Start the services in the order listed and stop them in reverse order. As a reminder, here are common service commands (all run as `root`):

<span class="twiki-macro TABLE" sort="off"></span>

| To …                                        | Run the command …                     |
|:--------------------------------------------|:--------------------------------------|
| Start a service                             | `service <em>SERVICE-NAME</em> start` |
| Stop a service                              | `service <em>SERVICE-NAME</em> stop`  |
| Enable a service to start during boot       | `chkconfig <em>SERVICE-NAME</em> on`  |
| Disable a service from starting during boot | `chkconfig <em>SERVICE-NAME</em> off` |

### Running RSV manually

Normally, the HTCondor-Cron scheduler runs RSV periodically. However, you can run RSV probes manually at any time:

``` rootscreen
%UCL_PROMPT_ROOT% rsv-control --run --all-enabled
```

If successful, results will be available from your local RSV web server (e.g., <http://localhost/rsv>) and, if enabled (which is the default) on [MyOSG](http://myosg.grid.iu.edu/).

You can also run the metrics individually or pass special parameters as explained in the [rsv-control document](RsvControl).

Troubleshooting RSV
-------------------

You can find more information on troubleshooting RSV in the [rsv-control documentation](RsvControl) and in [TroubleshootRSV](TroubleshootRsv).

### Important file locations

Logs and configuration:

| File Description   | Location                 | Comment                                         |
|:-------------------|:-------------------------|:------------------------------------------------|
| Metric log files   | `/var/log/rsv/metrics`   |                                                 |
| Consumer log files | `/var/log/rsv/consumers` |                                                 |
| HTML files         | `/usr/share/rsv/www/`    | Available at <http://your.host.example.com/rsv> |

| File Description      | Location                                    | Comment                                                                                       |
|:----------------------|:--------------------------------------------|:----------------------------------------------------------------------------------------------|
| Initial configuration | `/etc/osg/config.d/30-rsv.ini`              | Read by `osg-configure`                                                                       |
| RSV configuration     | `/etc/rsv`                                  | Generally files in this directory should not be edited directly. Use `osg-configure` instead. |
| Metric configuration  | `/etc/rsv/metrics/HOSTNAME/METRICNAME.conf` | To change arguments and environment                                                           |

To find the metrics and the other files in RSV you can use also the RPM commands: `rpm -ql rsv-metrics` and `rpm -ql rsv`.

<span class="twiki-macro INCLUDE" section="RsvControlVerbose" TOC_SHIFT="+">RsvControl</span> <span class="twiki-macro INCLUDE" section="RsvVerify" TOC_SHIFT="+">RsvControl</span>

Getting Help
------------

To get assistance, please use [this page](Documentation.HelpProcedure).

<span class="twiki-macro INCLUDE" section="RsvProfilerNT">RsvControl</span>

\#ReferenceSection

Reference
---------

Here are some other RSV documents that might be helpful:

-   A longer [introduction to RSV](RsvOverview)
-   [The RSV architecture](RsvArchitecture)
-   [RSV storage probes](RSVStorageProbes)

### Users

The RSV installation will create two users unless they are already created. The users are created when the `rsv` and `condor-cron` packages are installed.

<span class="twiki-macro STARTSECTION">Users</span>

| User       | Comment                                                                            |
|:-----------|:-----------------------------------------------------------------------------------|
| `rsv`      | Runs the RSV tests; the RSV certificate (below) will need to be owned by this user |
| `cndrcron` | Runs the Condor Cron processes to schedule the running of the tests                |

<span class="twiki-macro ENDSECTION">Users</span>

Note that if you pre-create the RSV user, it should have a working shell. That is, it shouldn't have a default shell of `/sbin/nologin`.

**WARNING:** If you manage your `/etc/passwd` file with configuration management software such as Puppet, CFEngine or 411, make sure the UID and GID in `/etc/condor-cron/config.d/condor_ids` matches the UID and GID of the `cndrcron` user and group in `/etc/passwd`. If it does not, create a file named `/etc/condor-cron/config.d/condor_ids_override` with the contents:&lt;pre class`"file">CONDOR_IDS=<em>UID</em>.<em>GID</em></pre>where <em>UID</em> and <em>GID</em> are the UID and GID of the =cndrcron` user and group.

### Certificates

<span class="twiki-macro STARTSECTION">Certificates</span>

<table>
<thead>
<tr class="header">
<th align="left">Certificate</th>
<th align="left">User that owns certificate</th>
<th align="left">Path to certificate</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">RSV service certificate</td>
<td align="left"><code>rsv</code></td>
<td align="left"><code>/etc/grid-security/rsv/rsvcert.pem</code><br />
<code>/etc/grid-security/rsv/rsvkey.pem</code></td>
</tr>
</tbody>
</table>

<span class="twiki-macro ENDSECTION">Certificates</span>

Ensure an RSV service certificate is installed in `/etc/grid-security/rsv/` and the certificate files are owned by the `rsv` user. Adjust the permissions if necessary (cert needs to be readable by all, key needs to be readable by nobody but owner).

You may need another certificate owned by `apache` if you'd like an authenticated web server; see [Configuring the RSV web server to use HTTPS instead of HTTP](#ConfiguringForHTTPS) above.

See [instructions](InstallCertScripts) to request a service certificate.

### Networking

<span class="twiki-macro STARTSECTION">Firewalls</span> <span class="twiki-macro INCLUDE" section="FirewallTable" lines="rsvin,rsvout,various">Documentation/Release3.FirewallInformation</span> \\ <span class="twiki-macro ENDSECTION">Firewalls</span>

Or, if you'd rather have your RSV web page appear as `%RED%https%ENDCOLOR%://...:8443/rsv/` like it used to in OSG 1.2, the first column above would be **HTTPS** / **tcp** / **8443**. See [above](#ConfiguringForHTTPS) for how to configure this.
