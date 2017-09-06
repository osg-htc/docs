&lt;style type="text/css"&gt; code strong, pre strong { color: red; font-weight: normal; font-style: normal; } pre\[class="rootscreen"\] em { background-color: \#FFFF00; font-weight: normal; font-style: normal; } pre\[class="file"\] em { background-color: \#FFCCFF; font-weight: normal; font-style: normal; } &lt;/style&gt;

Installing and Using the RSV GlideinWMS Tester
==============================================

<span class="twiki-macro TOC" depth="3"></span>

About This Guide
----------------

The RSV GlideinWMS Tester (or *Tester*, in this document) is a tool that a VO front-end administrator can use to test remote sites for the ability to run the VO’s jobs. It is particularly useful when setting up a VO for the first time or when changing the sites at which a VO’s jobs can run. For a site to pass the test, it must successfully run a simple test job via the normal GlideinWMS mechanisms, in much the same way as a real VO job.

Use this page to learn how to install, configure, and use the Tester for your VO front-end.

Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Reference section below](#ReferenceSection) as needed):

-   **Software:** You must have [a GlideinWMS Front-end](InstallGlideinWMSFrontend) installed
-   **Configuration:** The GlideinWMS Front-end must be configured (a) [to have at least one group that matches pilots to sites using DESIRED\_SITES](InstallGlideinWMSFrontend#DesiredSites), and (b) [to support the is\_itb user job attribute](InstallGlideinWMSFrontend#IsItb)
-   **Host choice:** The Tester should be installed on its own host; a small Virtual Machine (VM) is ideal
-   **Service certificate:** The Tester requires a host certificate at `/etc/grid-security/hostcert.pem` and an accompanying key at `/etc/grid-security/hostkey.pem`
-   **Network ports:** Test jobs must be able to contact the tester using the HTCondor Shared Port on port 9615 (TCP), and you must be able to contact a web server on port 80 (TCP) to view test results.

<span class="twiki-macro INCLUDE" section="OsgPreReqs">Documentation/Release3.DocumentationSnippets</span>

Installing the Tester
---------------------

The Tester software takes advantage of several other OSG software components, so the installation will also include OSG’s site validation system (RSV), HTCondor, and the GlideinWMS pilot submission software.

&lt;ol&gt; &lt;li&gt; &lt;p&gt;Install the software:&lt;/p&gt; &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> yum install rsv-gwms-tester&lt;/pre&gt; &lt;/li&gt; &lt;/ol&gt;

Configuring the Tester
----------------------

Before you use the Tester, there are some one-time configuration steps to complete, one set on your GlideinWMS Front-end Central Manager host and one set on the Tester host.

### Configuring the GlideinWMS Front-end Central Manager

Complete these steps **on your GlideinWMS Front-end Central Manager host**:

1.  &lt;p&gt;Authorize the Tester host to connect to your Central Manager:&lt;/p&gt;\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> glidecondor\_addDN -allow-others -daemon *COMMENT* *TESTER\_DN* condor&lt;/pre&gt;\\ &lt;p&gt;Where `COMMENT` is a human-readable label for the Tester host (e.g., “RSV GWMS Tester at myhost”), and `TESTER_DN` is the Distinguished Name (DN) of the host certificate of your Tester host. Most likely, you will need to quote both of these values to protect them from the shell. For example:&lt;/p&gt;\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> glidecondor\_addDN -allow-others -daemon 'RSV GWMS Tester on Fermicloud' '/DC=com/DC=DigiCert-Grid/O=Open Science Grid/OU=Services/CN=fermicloud357.fnal.gov' condor&lt;/pre&gt;
2.  &lt;p&gt;Restart HTCondor to apply the changes&lt;/p&gt;\\ &lt;p&gt;On **EL 6** systems:&lt;/p&gt;\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> service condor restart&lt;/pre&gt;\\ &lt;p&gt;On **EL 7** systems:&lt;/p&gt;\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl restart condor&lt;/pre&gt;
3.  &lt;p&gt;Add the new Tester to your GlideinWMS front-end configuration&lt;/p&gt;\\ &lt;p&gt;Edit the file `/etc/gwms-frontend/frontend.xml` and add a line as follows within the `<schedds>` element:&lt;/p&gt;\\ &lt;pre class="file"&gt;&lt;schedd DN="*TESTER\_DN*" fullname="*TESTER\_HOSTNAME*"/&gt;&lt;/pre&gt;\\ &lt;p&gt;Where `TESTER_DN` is the Distinguished Name (DN) of the host certificate of your Tester host (as above), and `TESTER_HOSTNAME` is the fully qualified hostname of the Tester host. For example:&lt;/p&gt;\\ &lt;pre class="file"&gt;&lt;schedd DN="/DC=com/DC=DigiCert-Grid/O=Open Science Grid/OU=Services/CN=fermicloud357.fnal.gov" fullname="fermicloud357.fnal.gov"/&gt;&lt;/pre&gt;
4.  &lt;p&gt;Reconfigure your GlideinWMS front-end to apply the changes:&lt;/p&gt;\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> service gwms-frontend reconfig&lt;/pre&gt;

### Configuring the Tester host

Complete the following steps **on your Tester host**:

1.  &lt;p&gt;Configure the Tester for the VOs that your Front-end supports&lt;/p&gt;\\ &lt;p&gt;Edit the file `/etc/rsv/metrics/org.osg.local-gfactory-site-querying-local.conf`. The `constraint` line is an HTCondor ClassAd expression containing one `stringListMember` function per VO that your Front-end supports. If there is more than one VO, the function invocations are joined by the “logical or” operator, `||`. Edit the `constraint` line for your Front-end.&lt;/p&gt;\\ &lt;p&gt;For example, for a single VO named `Foo`, the line would be:&lt;/p&gt;\\ &lt;pre class="file"&gt;constraint = stringListMember("Foo", GLIDEIN\_Supported\_VOs)&lt;/pre&gt;\\ &lt;p&gt;For two VOs named `Foo` and `Bar`, the line would be:&lt;/p&gt;\\ &lt;pre class="file"&gt;constraint = stringListMember("Foo", GLIDEIN\_Supported\_VOs) || stringListMember("Bar", GLIDEIN\_Supported\_VOs)&lt;/pre&gt;\\ &lt;p&gt;Do not change the other settings in this file, unless you have clear and specific reasons to do so.&lt;/p&gt;
2.  &lt;p&gt;Authorize the central manager of your Front-end to connect to the tester host:&lt;/p&gt;\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> glidecondor\_addDN -allow-others -daemon *COMMENT* *CENTRAL\_MGR* condor&lt;/pre&gt;\\ &lt;p&gt;Where `COMMENT` is a human-readable identifier for the Central Manager, and `CENTRAL_MGR` is the Distinguished Name (DN) of the host certificate of your GlideinWMS Front-end’s Central Manager host. Most likely, you will need to quote both of these values to protect them from the shell. For example:&lt;/p&gt;\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> glidecondor\_addDN -allow-others -daemon 'UCSD central manager DN' '/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=osg-ligo-1.t2.ucsd.edu' condor&lt;/pre&gt;
3.  &lt;p&gt;Configure the special HTCondor-RSV instance with your host IP address&lt;/p&gt;\\ &lt;p&gt;Create the file `/etc/condor/config.d/98_public_interface.config` with this content:&lt;/p&gt;\\ &lt;pre class="file"&gt;NETWORK\_INTERFACE = *ADDRESS*

CONDOR\_HOST = *CENTRAL\_MGR* &lt;/pre&gt;\\ &lt;p&gt;Where `ADDRESS` is the IP address of your Tester host, and `CENTRAL_MGR` is the hostname of your GlideinWMS Front-end Central Manager.&lt;/p&gt;

1.  &lt;p&gt;Enable the Tester’s RSV probe:&lt;/p&gt;\\ &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> rsv-control --enable org.osg.local-gfactory-site-querying-local --host localhost&lt;/pre&gt;\\

Using the Tester
----------------

There are at least two aspects of using the Tester:

-   Managing the services that are associated with the Tester software
-   Viewing results from the Tester

### Managing Tester services

Because the Tester is built on other OSG software, there are a number of services in your installation. The specific services are:

<span class="twiki-macro TABLE" sort="off"></span>

| Software           | Service name  | Notes                      |
|:-------------------|:--------------|:---------------------------|
| Apache HTTP Server | `httpd`       | Web server for results     |
| HTCondor-Cron      | `condor-cron` | cron-like jobs in HTCondor |
| RSV                | `rsv`         | OSG site validator         |

<span class="twiki-macro INCLUDE" section="ServiceManagement">Documentation/Release3.DocumentationSnippets</span>

### Viewing Tester results

Once the Tester RSV probe is enabled and active, and the services listed above have been started, there are two kinds of RSV probes that run periodically:

-   One probe asks the GlideinWMS factory for the up-to-date list of sites supported by your VO(s) — runs every 30 minutes
-   One probe submits and monitors one test job to each site supported by your VO(s) — run every 60 minutes

You can view the latest results of both probe types on an RSV results web page, or you can manually run the first probe to see the full list of sites.

#### Viewing RSV results online

To see the latest results, access `https://<em>HOSTNAME</em>/rsv/` (where `HOSTNAME` is the name of your Tester host).

-   There should be one result row per site supported by your VO(s), using the “org.osg.general.dummy-vanilla-probe” probe (aka *metric*)
-   There should be exactly one result row for the probe that fetches the list of sites, which is the “org.osg.local-gfactory-site-querying-local” probe (aka *metric*)
-   There is a legend for the background colors at the end of the page

Ideally, each site supported by your VO(s) should be shown with a green background, which indicates that a Tester job ran at that site recently and successfully. There may be transient failures but if you notice a site in the failed state over multiple days, contact OSG Factory Operations (<osg-gfactory-support@physics.ucsd.edu>) about the failing site, including a link to your Tester RSV results page.

To see detailed information from each probe, click on the probe name in the Metric column.

To see the list of sites that are supported by your VO(s) and are being tested, click the “org.osg.local-gfactory-site-querying-local” link at the bottom of the list of probes. You can also run the probe manually, as described next.

### Listing supported sites manually

To manually run the probe that fetches the list of sites supported by your VO(s), run the following command on your Tester host:

``` rootscreen
%UCL_PROMPT_ROOT% rsv-control --run org.osg.local-gfactory-site-querying-local --host localhost
```

The probe produces many lines of output, some of which are just about the probe execution itself. But look for lines like this:

``` rootscreen
MSG: Updating configuration for host <em>UCSD</em>
```

The highlighted name is the site name, and there should be one such line per site supported by your VO(s).

Troubleshooting RSV-GWMS-Tester
-------------------------------

You can find more information on troubleshooting in the [RSV troubleshooting section](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallRSV#Troubleshooting_RSV)

Logs and configuration:

| File Description      | Location               | Comment |
|:----------------------|:-----------------------|:--------|
| Condor Cron log files | `/var/log/condor-cron` |         |

| File Description     | Location                                                           | Comment                             |
|:---------------------|:-------------------------------------------------------------------|:------------------------------------|
| Metric configuration | `/etc/rsv/metrics/org.osg.local-gfactory-site-querying-local.conf` | To change arguments and environment |

Getting Help
------------

To get assistance, please use the [this page](Documentation.HelpProcedure).

Reference
---------

### Certificates

<span class="twiki-macro STARTSECTION">Certificates</span>

| Certificate      | User that owns certificate | Path to certificate                                                           |
|:-----------------|:---------------------------|:------------------------------------------------------------------------------|
| Host certificate | `root`                     | `/etc/grid-security/hostcert.pem` &lt;br&gt; `/etc/grid-security/hostkey.pem` |

Find instructions to request a host certificate [here](Documentation/Release3.GetHostServiceCertificates). <span class="twiki-macro ENDSECTION">Certificates</span>

### Networking

<span class="twiki-macro STARTSECTION">Firewalls</span> <span class="twiki-macro INCLUDE" section="FirewallTable" lines="condorscheddshared,rsvin">FirewallInformation</span>

<span class="twiki-macro ENDSECTION">Firewalls</span>
