Installing, Configuring, Using, and Troubleshooting RSV
=======================================================

About This Guide
----------------

The Resource and Service Validation (RSV) software helps a site administrator verify that certain site resources and services are working as expected. OSG recommends that sites install and run RSV, but it is optional; further, each site selects which specific tests (called *probes*) to run.

Use this page to learn more about RSV in general, and how to install, configure, run, test, and troubleshoot RSV from the OSG software repositories. For documentation on specific probes or on how to write your own probes, please check the [Reference section](#reference).

Introduction to RSV
-------------------

The Resource and Service Validation (RSV) software provides OSG site administrators a scalable and easy-to-maintain resource and service monitoring infrastructure. The components of RSV are:

- **RSV Client.** The client tools allow a site administrator to run tests against their site by providing a set of tests (which can run on the same or other hosts within a site), HTCondor-Cron for scheduling, and tools for collecting and storing the results (using Gratia). The client package is not installed by default and may be installed on a CE or other host. Generally, you configure the RSV client to run tests at scheduled time intervals and then it makes results available on a local website. Also, the client can upload test results to a central collector (see next item).
- **RSV Collector/Server.** The central OSG RSV Collector accepts and stores results from RSV clients throughout OSG, which can be viewed in [MyOSG](http://my.opensciencegrid.org/), on the “Current RSV Status” page and under the “Resource Group” menu.
- **MyOSG and OIM Links.** RSV picks up resource information, WLCG interoperability information, etc., from a MyOSG resource group summary listing, which is in turn based on the [OSG Information Management (OIM) (topology) system](https://oim.opensciencegrid.org) (Requires registration). Resource [maintenance scheduled on OIM](http://oim.opensciencegrid.org/oim/oimmaint) are forwarded to WLCG SAM, if applicable.


Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Reference section below](#reference) as needed):

- **User IDs:** If they do not exist already, the installation will create the Linux user IDs `rsv` and `cndrcron`
- **Service certificate:** The RSV service requires a service certificate (`/etc/grid-security/rsv/rsvcert.pem`) and matching key (`/etc/grid-security/rsv/rsvkey.pem`)
- **Network ports:** To view results, port 80 must accept incoming requests; outbound connectivity to tested services must work, too
- **Host choice:** Install RSV on your site CE unless you have specific reasons (e.g., performance) for installing on a separate host

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the RSV host has [a supported operating system](../common/yum.md)
- Obtain root access to the host
- Prepare [the required Yum repositories](../common/yum.md)
- Install [CA certificates](../common/ca)

Installing RSV
--------------

An installation of RSV at a site consists of the RSV client software, the Apache web server, parts of HTCondor (for its cron-like scheduling capabilities), and various other small tools. To simplify installation, OSG provides a convenience RPM that installs all required software with a single command.

1. Consider updating your local cache of Yum repository data and your existing RPM packages:

        :::console
        root@host # yum clean all --enablerepo=\*
        root@host # yum update

    !!! note
        The `update` command will update **all** packages on your system.

2. If you have installed HTCondor already but not by RPM, install a special empty RPM to make RSV happy:

        :::console
        root@host # yum install empty-condor --enablerepo=osg-empty

3. Install RSV and related software:

        :::console
        root@host # yum install rsv

Configuring RSV
---------------

After installation, there are some one-time configuration steps to tell RSV how to operate at your site.

1. Edit `/etc/osg/config.d/30-rsv.ini` and follow the instructions in the file. There are detailed comments for each setting. In the simplest case — to monitor only your CE — set the `htcondor_ce_hosts` variable to the fully qualified hostname of your CE.

2. If you have installed HTCondor already but not by RPM, specify the location of the Condor installation in `30-rsv.ini` in the `condor_location` setting. If an HTCondor RPM is installed, you do not need to set `condor_location`.

3. Complete the configuration using the `osg-configure` tool:

        :::console
        root@host # osg-configure -v
        root@host # osg-configure -c

### Optional configuration

The following configuration steps are optional and will likely not be required for setting up a small or typical site. If you do not need any of the following special configurations, skip to [the section on using RSV](#using-rsv).

Generally speaking, read the [ConfigureRsv](advanced-rsv-configuration) page for more advanced configuration options.

#### Configuring RSV to run probes using a remote server

RSV monitors systems by running probes, which can run on the RSV host itself (the default case), via a separate batch system like HTCondor, or via a remote batch system using a Globus gatekeeper and its job manager. The last two options both can count those jobs and report them to, for example, Gratia.

In this case, remember to:

- Add the RSV user `rsv` on all the systems where the probes may run, and
- Map the RSV service certificate to the user you intend to use for RSV. This should be a local user used exclusively for RSV and not belonging to an institutional VO to avoid for the RSV probes to be accounted as regular VO jobs in Gratia. This can be done in [GUMS](../security/install-gums) or [using a grid-mapfile-local](../security/edg-mkgridmap) (if you use a grid-mapfile). [MapServiceCertToRsvUser](https://github.com/opensciencegrid/docs/blob/master/archive/MapServiceCertToRsvUser) explains how to configure GUMS or the grid-mapfile. Also see the [CE installation document](../compute-element/install-htcondor-ce) for more information.

#### Configuring the RSV web server to use HTTPS instead of HTTP

If you would like your local RSV web server to use HTTPS instead of the default HTTP (for compatibility or security reasons), complete the steps below. This procedure assumes that you already have an HTTP service certificate (or a copy of the host certificate) in `/etc/grid-security/http/`. If not, omit the `SSLCertificate*` modifications below, and your web server will start with its own, self-signed certificate.

1. Install `mod_ssl`:

        :::console
        root@host # yum install mod_ssl

2. Make an alternate set of HTTP service certificate files:

        :::console
        root@host # cp -p /etc/grid-security/http/httpcert.pem /etc/grid-security/http/httpcert2.pem
        root@host # cp -p /etc/grid-security/http/httpkey.pem /etc/grid-security/http/httpkey2.pem
        root@host # chown apache:apache /etc/grid-security/http/http*2.pem

3. Back up existing Apache configuration files:

        :::console
        root@host # cp -p /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig
        root@host # cp -p /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.orig

4. Change the default port for HTTP connections to 8000 by editing `/etc/httpd/conf/httpd.conf`

        :::file
        Listen 8000


5. Set up HTTPS access by editing `/etc/httpd/conf.d/ssl.conf`:

        :::file
        Listen 8443
        <VirtualHost _default_:8443>
        SSLCertificateFile /etc/grid-security/http/httpcert2.pem
        SSLCertificateKeyFile /etc/grid-security/http/httpkey2.pem

    After these changes, when you start the Apache service, it will listening on ports `8000` (for HTTP) and `8443` (for HTTPS), rather than the default port `80` (for HTTP only).

    !!! warning
        if you make the changes above, you must restart the Apache server after each CA certificate update to pick up the changes.


Using RSV
---------

### Managing RSV and associated services

In addition to the RSV service itself, there are a number of supporting services in your installation. The specific services are:

| Software      | Service name                                   | Notes                   |
|:--------------|:-----------------------------------------------|------------------------ |
| Fetch CRL     | `fetch-crl-boot` and `fetch-crl-cron` | See [CA documentation](../common/ca/#startstop-fetch-crl-a-quick-guide)|
| Apache        | httpd                                          |                         |
| HTCondor-Cron | condor-cron                                    |                         |
| RSV           | rsv                                            |                         |

Start the services in the order listed and stop them in reverse order. As a reminder, here are common service commands (all run as `root`):


| To …                                        | Run the command …                     |
|:--------------------------------------------|:--------------------------------------|
| Start a service                             | `service %RED%<SERVICE-NAME>%ENDCOLOR% start` |
| Stop a service                              | `service %RED%<SERVICE-NAME>%ENDCOLOR% stop`  |
| Enable a service to start during boot       | `chkconfig %RED%<SERVICE-NAME>%ENDCOLOR% on`  |
| Disable a service from starting during boot | `chkconfig %RED%<SERVICE-NAME>%ENDCOLOR% off` |

### Running RSV manually

Normally, the HTCondor-Cron scheduler runs RSV periodically. However, you can run RSV probes manually at any time:

``` console
root@host # rsv-control --run --all-enabled
```

If successful, results will be available from your local RSV web server (e.g., `http://localhost/rsv`) and, if enabled (which is the default) on [MyOSG](http://my.opensciencegrid.org/).

You can also run the metrics individually or pass special parameters as explained in the [rsv-control document](rsv-control).

Troubleshooting RSV
-------------------

To get assistance, use the [help procedure](../common/help).

RSV has a tool to collect information useful for troubleshooting into a tarball that can be shared with the developers and support staff.
To use it:

``` console
root@host# rsv-control --profile
Running the rsv-profiler...
OSG-RSV Profiler
Analyzing...
Making tarball (rsv-profiler.tar.gz)
```

You can find more information on troubleshooting RSV in the [rsv-control documentation](rsv-control).

!!! note
    If you are getting assistance via the trouble ticket system, you must add a `.txt` extension to the tarball so it can be uploaded:

### Failed to send via Gratia

If you see `Failed to send record Failed to send via Gratia: Server unable to receive data:` in `/var/log/rsv/consumers/gratia-consumer.output` you should process to disable the gratia consumer using the following commands

```console
root@host#  rsv-control --disable --host %RED%<YOUR RSV HOST>%ENDCOLOR% gratia-consumer
root@host#  rsv-control --off --host %RED%<YOUR RSV HOST>%ENDCOLOR% gratia-consumer
```

### Important file locations

Logs and configuration:

| File Description   | Location                 | Comment                                         |
|:-------------------|:-------------------------|:------------------------------------------------|
| Metric log files   | `/var/log/rsv/metrics`   |                                                 |
| Consumer log files | `/var/log/rsv/consumers` |                                                 |
| HTML files         | `/usr/share/rsv/www/`    | Available at `http://your.host.example.com/rsv` |

| File Description      | Location                                    | Comment                                                                                       |
|:----------------------|:--------------------------------------------|:----------------------------------------------------------------------------------------------|
| Initial configuration | `/etc/osg/config.d/30-rsv.ini`              | Read by `osg-configure`                                                                       |
| RSV configuration     | `/etc/rsv`                                  | Generally files in this directory should not be edited directly. Use `osg-configure` instead. |
| Metric configuration  | `/etc/rsv/metrics/HOSTNAME/METRICNAME.conf` | To change arguments and environment                                                           |

To find the metrics and the other files in RSV you can use also the RPM commands: `rpm -ql rsv-metrics` and `rpm -ql rsv`.

### Getting more information from rsv-control

The first step to getting more information is to run rsv-control with more verbosity. Use the `--verbose` (`-v`) flag. This flag can be used with any of rsv-control's abilities (run, enable, list, etc). The verbosity levels are:

- 0 = print nothing
- 1 = print warnings and errors along with usual output of command being run (1 is the default level)
- 2 = adds informational messages
- 3 = full debugging output

For example, here is the output when running a metric with -v2.

<details>
  <summary>Show detailed ouput</summary>
```console
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
</details>

Getting Help
------------

To get assistance, please use [this page](../common/help.md) and attach the output of `rsv-control --profile`:

```console
root@host # rsv-control --profile
Running the rsv-profiler...
OSG-RSV Profiler
Analyzing...
Making tarball (rsv-profiler.tar.gz)
```

### Users

The RSV installation will create two users unless they are already created. The users are created when the `rsv` and `condor-cron` packages are installed.

| User       | Comment                                                                            |
|:-----------|:-----------------------------------------------------------------------------------|
| `rsv`      | Runs the RSV tests; the RSV certificate (below) will need to be owned by this user |
| `cndrcron` | Runs the Condor Cron processes to schedule the running of the tests                |


!!! note
    if you pre-create the RSV user, it should have a working shell. That is, it shouldn't have a default shell of `/sbin/nologin`.

!!! warning

    If you manage your `/etc/passwd` file with configuration management software such as Puppet, CFEngine or 411, make sure the UID and GID in `/etc/condor-cron/config.d/condor_ids` matches the UID and GID of the `cndrcron` user and group in `/etc/passwd`. If it does not, create a file named `/etc/condor-cron/config.d/condor_ids_override` with the contents:


```file
CONDOR_IDS=UID.GID
```

where `UID` and `GID` are the UID and GID of the `cndrcron` user and group.

### Certificates

| Certificate             | User that owns certificate  |Path to certificate                  |
|:------------------------|:----------------------------|:----------------------------------- |
| RSV service certificate | `rsv`                       |`/etc/grid-security/rsv/rsvcert.pem `|
|                         |                             |`/etc/grid-security/rsv/rsvkey.pem  `|

Ensure an RSV service certificate is installed in `/etc/grid-security/rsv/` and the certificate files are owned by the `rsv` user. Adjust the permissions if necessary (cert needs to be readable by all, key needs to be readable by nobody but owner).

You may need another certificate owned by `apache` if you'd like an authenticated web server; see [Configuring the RSV web server to use HTTPS instead of HTTP](#configuring-the-rsv-web-server-to-use-https-instead-of-http) above.

See [instructions](../security/host-certs.md) to request a service certificate.

### Networking

| Service Name  | Protocol    |Port Number | Inbound | Outbound | Comment |
|:--------------|:------------|:-----------|:--------|:---------|:--------|
| HTTP          | tcp         | 80         |   YES   |          | RSV runs an HTTP server (Apache) that publishes a page with the RSV testing results |
| HTTP          | tcp         | 80         |         | YES      | RSV pushes testing results to the OSG Gratia Collectors at opensciencegrid.org  |
| various       | various     | various    |  	     | YES      | Allow outbound network connection to all services that you want to test        |


Or, if you'd rather have your RSV web page appear as `%RED%https%ENDCOLOR%://...:8443/rsv/` like it used to in OSG 1.2, the first column above would be **HTTPS** / **tcp** / **8443**. See [above](#configuring-the-rsv-web-server-to-use-https-instead-of-http) for how to configure this.
