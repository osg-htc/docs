Installing and Using the RSV GlideinWMS Tester
==============================================


About This Guide
----------------

The RSV GlideinWMS Tester (or *Tester*, in this document) is a tool that a VO front-end administrator can use to test remote sites for the ability to run the VO’s jobs. It is particularly useful when setting up a VO for the first time or when changing the sites at which a VO’s jobs can run. For a site to pass the test, it must successfully run a simple test job via the normal GlideinWMS mechanisms, in much the same way as a real VO job.

Use this page to learn how to install, configure, and use the Tester for your VO front-end.

Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Reference section below](#ReferenceSection) as needed):

- **Software:** You must have [a GlideinWMS Front-end](InstallGlideinWMSFrontend) installed
- **Configuration:** The GlideinWMS Front-end must be configured (a) [to have at least one group that matches pilots to sites using DESIRED_SITES](InstallGlideinWMSFrontend#DesiredSites), and (b) [to support the is_itb user job attribute](InstallGlideinWMSFrontend#IsItb)
- **Host choice:** The Tester should be installed on its own host; a small Virtual Machine (VM) is ideal
- **Service certificate:** The Tester requires a host certificate at `/etc/grid-security/hostcert.pem` and an accompanying key at `/etc/grid-security/hostkey.pem`
- **Network ports:** Test jobs must be able to contact the tester using the HTCondor Shared Port on port 9615 (TCP), and you must be able to contact a web server on port 80 (TCP) to view test results.



Installing the Tester
---------------------

The Tester software takes advantage of several other OSG software components, so the installation will also include OSG’s site validation system (RSV), HTCondor, and the GlideinWMS pilot submission software.

```console
[root@client ~] # yum install rsv-gwms-tester
```

Configuring the Tester
----------------------

Before you use the Tester, there are some one-time configuration steps to complete, one set on your GlideinWMS Front-end Central Manager host and one set on the Tester host.

### Configuring the GlideinWMS Front-end Central Manager

Complete these steps **on your GlideinWMS Front-end Central Manager host**:

1. Authorize the Tester host to connect to your Central Manager:
     
        :::console
        [root@client ~] # glidecondor_addDN -allow-others -daemon %RED%<COMMENT> <TESTER_DN>%ENDCOLOR% condor


     Where `COMMENT` is a human-readable label for the Tester host (e.g., “RSV GWMS Tester at myhost”), and `TESTER_DN` is the Distinguished Name (DN) of the host certificate of your Tester host. Most likely, you will need to quote both of these values to protect them from the shell. For example:

        :::console
        [root@client ~] # glidecondor_addDN -allow-others -daemon 'RSV GWMS Tester on Fermicloud' '/DC=com/DC=DigiCert-Grid/O=Open Science Grid/OU=Services/CN=fermicloud357.fnal.gov' condor

2. Restart HTCondor to apply the changes

    On **EL 6** systems:
  
        :::console
        [root@client ~] # service condor restart
    
    On **EL 7** systems:

        :::console
        [root@client ~] # systemctl restart condor

3. Add the new Tester to your GlideinWMS front-end configuration. 
   Edit the file `/etc/gwms-frontend/frontend.xml` and add a line as follows within the `<schedds>` element

        :::file
        <schedd DN="%RED%<TESTER_DN>%ENDCOLOR%" fullname="%RED%<TESTER_HOSTNAME>%ENDCOLOR%">

     Where `TESTER_DN` is the Distinguished Name (DN) of the host certificate of your Tester host (as above), and `TESTER_HOSTNAME` is the fully qualified hostname of the Tester host. For example:

        :::file 
        <schedd DN="/DC=com/DC=DigiCert-Grid/O=Open Science Grid/OU=Services/CN=fermicloud357.fnal.gov" fullname="fermicloud357.fnal.gov">
   
     Reconfigure your GlideinWMS front-end to apply the changes:
      
        :::console
        [root@client ~] # service gwms-frontend reconfig

### Configuring the Tester host

Complete the following steps **on your Tester host**:

1. Configure the Tester for the VOs that your Front-end supports
   
    Edit the file `/etc/rsv/metrics/org.osg.local-gfactory-site-querying-local.conf`. The `constraint` line is an HTCondor ClassAd expression containing one `stringListMember` function per VO that your Front-end supports. If there is more than one VO, the function invocations are joined by the “logical or” operator, `||`. Edit the `constraint` line for your Front-end.

    For example, for a single VO named `Foo`, the line would be:

        :::file
        constraint = stringListMember("Foo", GLIDEIN_Supported_VOs)

    For two VOs named `Foo` and `Bar`, the line would be:

        :::file
        constraint = stringListMember("Foo", GLIDEIN_Supported_VOs) || stringListMember("Bar", GLIDEIN_Supported_VOs)

    Do not change the other settings in this file, unless you have clear and specific reasons to do so.

2. Authorize the central manager of your Front-end to connect to the tester host:

        :::console
        [root@client ~] # glidecondor_addDN -allow-others -daemon %RED%<COMMENT> <CENTRAL_MGR>%ENDCOLOR% condor

    Where `COMMENT` is a human-readable identifier for the Central Manager, and `CENTRAL_MGR` is the Distinguished Name (DN) of the host certificate of your GlideinWMS Front-end’s Central Manager host. Most likely, you will need to quote both of these values to protect them from the shell. For example:

        :::console
        [root@client ~] # glidecondor_addDN -allow-others -daemon 'UCSD central manager DN' '/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=osg-ligo-1.t2.ucsd.edu' condor

3. Configure the special HTCondor-RSV instance with your host IP address.
   
    Create the file `/etc/condor/config.d/98_public_interface.config` with this content:

        :::file
        NETWORK_INTERFACE = %RED%<ADDRESS>%ENDCOLOR%
        CONDOR_HOST = %RED%<CENTRAL_MGR>%ENDCOLOR%

    Where `ADDRESS` is the IP address of your Tester host, and `CENTRAL_MGR` is the hostname of your GlideinWMS Front-end Central Manager.

4. Enable the Tester’s RSV probe:

        :::console
        [root@client ~] # rsv-control --enable org.osg.local-gfactory-site-querying-local --host localhost

Using the Tester
----------------

There are at least two aspects of using the Tester:

-   Managing the services that are associated with the Tester software
-   Viewing results from the Tester

### Managing Tester services

Because the Tester is built on other OSG software, there are a number of services in your installation. The specific services are:


| Software           | Service name  | Notes                      |
|:-------------------|:--------------|:---------------------------|
| Apache HTTP Server | `httpd`       | Web server for results     |
| HTCondor-Cron      | `condor-cron` | cron-like jobs in HTCondor |
| RSV                | `rsv`         | OSG site validator         |


### Viewing Tester results

Once the Tester RSV probe is enabled and active, and the services listed above have been started, there are two kinds of RSV probes that run periodically:

-   One probe asks the GlideinWMS factory for the up-to-date list of sites supported by your VO(s) — runs every 30 minutes
-   One probe submits and monitors one test job to each site supported by your VO(s) — run every 60 minutes

You can view the latest results of both probe types on an RSV results web page, or you can manually run the first probe to see the full list of sites.

#### Viewing RSV results online

To see the latest results, access `https://%RED%<HOSTNAME>%ENDCOLOR%/rsv/` (where `HOSTNAME` is the name of your Tester host).

-   There should be one result row per site supported by your VO(s), using the “org.osg.general.dummy-vanilla-probe” probe (aka *metric*)
-   There should be exactly one result row for the probe that fetches the list of sites, which is the “org.osg.local-gfactory-site-querying-local” probe (aka *metric*)
-   There is a legend for the background colors at the end of the page

Ideally, each site supported by your VO(s) should be shown with a green background, which indicates that a Tester job ran at that site recently and successfully. There may be transient failures but if you notice a site in the failed state over multiple days, contact OSG Factory Operations (<osg-gfactory-support@physics.ucsd.edu>) about the failing site, including a link to your Tester RSV results page.

To see detailed information from each probe, click on the probe name in the Metric column.

To see the list of sites that are supported by your VO(s) and are being tested, click the “org.osg.local-gfactory-site-querying-local” link at the bottom of the list of probes. You can also run the probe manually, as described next.

### Listing supported sites manually

To manually run the probe that fetches the list of sites supported by your VO(s), run the following command on your Tester host:

```console
[root@client ~] # rsv-control --run org.osg.local-gfactory-site-querying-local --host localhost
```

The probe produces many lines of output, some of which are just about the probe execution itself. But look for lines like this:

```console
MSG: Updating configuration for host %RED%<UCSD>%ENDCOLOR%
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

To get assistance, please use the [this page](../common/help.md).

Reference
---------

### Certificates

| Certificate      | User that owns certificate | Path to certificate                                                           |
|:-----------------|:---------------------------|:------------------------------------------------------------------------------|
| Host certificate | `root`                     | `/etc/grid-security/hostcert.pem` &lt;br&gt; `/etc/grid-security/hostkey.pem` |

Find instructions to request a host certificate [here](../common/pki-cli.md).

