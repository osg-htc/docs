Network Performance Toolkit
================================

This document is for System Administrators and advanced Grid Users. It describes the usage of tools provided by the [Virtual Data Toolkit](http://vdt.cs.wisc.edu) to evaluate the network performance between resources.

Introduction
=================

The Network Performance Toolkit is a collection of applications provided by the [perfSONAR project](http://www.perfsonar.net/) and distributed by the [Open Science Grid](http://www.opensciencegrid.org). The *server* components of the Network Performance Toolkit have been installed on dedicated resources of the [Open Science Grid](http://www.opensciencegrid.org). Following *client* tools are described in this document:

-   Network Diagnostic Tool (NDT)
-   One Way Active Measurement Protocol (OWAMP)
-   Bandwidth Control tool (BWCTL)
-   Network Path and Application Diagnosis (NPAD)

Installation
=================

Client Site Installation 
------------------------------------------------------------------

The Network Performance Toolkit is installed with the OSG Client. Specifically, the tools included are: BWCTL, NDT and OWAMP (bwctl-client, bwctl-server, bwctl, ndt, owamp-client). NPAD is currently not in OSG client.

If you just want to install the OSG command line clients you can do the following::

``` console
yum install bwctl-client
yum install owamp-client
yum install ndt-client
yum install npad-client
```

You may install these utilities separately as RPM using yum by following the [perfSONAR](http://www.perfsonar.net/about) instructions. The packages are in the OSG repository, some of them with a separate client or server version, available for the OSG supported platforms:

-   NDT: ndt
-   OWAMP: owamp, owamp-client, owamp-server
-   BWCTL: bwctl, bwctl-client, bwctl-server
-   NPAD: npad

Server Site Installation 
------------------------------------------------------------------

The [perfSONAR](http://www.perfsonar.net/about)-based tools and services support the following tasks for OSG VO's:

1.  monitor site-to-site network paths and ensure that these paths remain operational
2.  troubleshoot performance problems quickly and efficiently

The *server site components* can be brought-up *on demand* using the netinstall provided by [perfSONAR project downloads](http://docs.perfsonar.net/install_getting.html#downloads). Source packages are provided on the [perfSONAR home page](http://docs.perfsonar.net/).

Once the Toolkit server has booted you may begin on-demand testing. The server tools will use a generic set of configuration files. The intent is to make it easy to stand up a temporary server when and where it is needed. However, it is expected that a permanently installed server will be customized/configured, allowing it to support both on-demand testing and regularly scheduled monitoring. See the [perfSONAR home page](http://docs.perfsonar.net/) for step-by-step instructions on how to complete this customization process.

Finding Target Servers
===========================

Finding servers against which to run on-demand tests can be a major impediment to effectively using these tools. The [perfSONAR](http://www.perfsonar.net/about) project tackles this problem by running a registration service for participating tools. The Performance Node ISO automatically uses this Lookup Service to advertise the tools' existence. You can also create custom views by making web-service calls to retrieve the data of interest. 

We also have requested ALL OSG sites register their perfSONAR Toolkit installations in OIM (See <https://www.opensciencegrid.org/bin/view/Documentation/RegisterPSinOIM> ). You can use the MyOSG -> Resource Group -> Resource Group Summary page to see a list of perfSONAR Toolkit hosts that are installed at <http://tinyurl.com/mxfmutg>. Using this list you can select a "closest" relevant instance to use for running on-demand tests. Alternately if you have a perfSONAR toolkit install, the web interface has a "Global Services" link you can visit to see ALL perfSONAR instances that have updated the perfSONAR lookup service.

Using the Client Tools
===========================

These tools support delay measurements (OWAMP), throughput measurements (BWCTL), and advanced diagnostics (NDT and NPAD). The command syntax for each tool is described in the following sub-sections. Each of the client tools listed above communicates with a companion server process to perform a measurement/test.

Network Diagnostic Tool (NDT) 
-----------------------------------------------------------------------

The Network Diagnostic Tool (NDT) runs a series of short tests to determine what the current performance is and what, if anything, is limiting that performance. It can distinguish between host configuration and network infrastructure problems. To diagnose the CE/SE configuration and network connection run the `web100clt` command:

``` console
[user@client /opt/npt]$ web100clt –n <Target Server for Measurement>
```

More details can be obtained by using the `-l` command line option to `web100ctl`:

``` console
[user@client /opt/npt]$ web100clt –n <Target Server for Measurement> -l
```

To increase the output further use:

``` console
[user@client /opt/npt]$ web100clt –n <Target Server for Measurement> -ll
```

One Way Active Measurement Protocol (OWAMP) 
-------------------------------------------------------------------------------------

The One Way Active Measurement Protocol (OWAMP) is an advanced version of the common `ping` program. The OWAMP client `owping` communicates with an OWAMP server and measures the delay in each direction using NTP based time stamps. OWAMP can be used to identify delay, loss, and packet reordering problems inside the network. To measure the delay between the CE/SE and the remote server use the `owping` command:

``` console
[user@client /opt/npt]$ owping <Target Server for Measurement>
```

Bandwidth Control tool (BWCTL) 
------------------------------------------------------------------------

The Bandwidth Control tool (BWCTL) is a wrapper for the `iperf` command, its policy and a daemon. BWCTL improves the usability of `iperf` by avoiding following problems:

1.  need for remote access to the target host used for measurement
2.  security concerns about leaving an `iperf` daemon running on the target host

BWCTL supports testing in either direction, or between 2 remote BWCTL servers from a third location. To measure the current throughput from your SE/CE to the remote server use the `bwctl` command:

``` console
[user@client /opt/npt]$ bwctl –s <Target Server for Measurement>
```

Third party tests, between 2 remote BWCTL servers, will let you measure various sections of the end-2-end path, running

``` console
[user@client /opt/npt]$ bwctl –c <1st Server for Measurement> –s <2nd Server for Measurement>
```

Other useful options are `-f`, format, `-t`, length of test, and `-i`, test interval.

Network Path and Application Diagnosis (NPAD) 
---------------------------------------------------------------------------------------

**NOTE: Network Path and Application Diagnosis (NPAD) is deprecated and won't be in future versions of the OSG distribution**

The Network Path and Application Diagnosis (NPAD) tool examines a host and its local network infrastructure to determine what problems, if any, would hinder wide area performance. Issues such as small TCP buffers in switches and routers are detected as well as common host configuration errors. To determine if the CE/SE will achieve maximum performance over a WAN path run the command `diag-client`:

``` console
[user@client /opt/npt]$ diag-client <Target Server for Measurement> 8001 10 50
```


!!! note
    The last 2 numeric parameters, after host and port, are the rtt time (in ms) and speed/rate values (in Mbps) you need to achieve. The reason it works this way is that its meant to 'test' local infrastructure. The idea is that if you were testing to an NPAD server that was 5ms away on a 1G network, you would get close to that speed even with network flaws. If you were to supply 80ms and 1G to the server and there truly was a flaw, the NPAD test would tell you it wasn't possible, thus enabling you to fix the problem

!!! note
    The `diag-client` commands return a partial URL, enabling easy sharing of results between users and site administrators. To view the results, prepend the Toolkit servers name/port to the returned string. The example above would result in this URL: `http://server.this.osg.domain:8002/ServerData/Reports-2011-07/vtbv-ce.uchicago.edu:2011-07-12-18:50:07.html`.

[Advanced Topic: Scheduled Monitoring](http://docs.perfsonar.net/manage_regular_tests.html)
================================================================================================

(See <http://docs.perfsonar.net/install_quick_start.html> for more details.)

In addition to the above on-demand tests, the Performance Toolkit server can be configured to continuously monitor the throughput or delay between your site and peer sites of interest. To begin this monitoring, enter the GUI and ensure that your server is a member of the community or communities of interest. Once that is complete, continue on by selecting either the **perfSONAR-BUOY** throughput or delay configuration menu item.

pSB-throughput: This utility will run regularly scheduled BWCTL tests between your Toolkit server and the selected peer servers. Results are stored in a database and displayed on the server's web page. You may also use standard web-service calls to retrieve this data for display on remote web servers. This would allow monitoring of a common core infrastructure at a central site, while each site could keep local/customized views.

pSB-delay: This utility will run regularly scheduled OWAMP tests between your Toolkit server and the selected peers. Results are stored in a database and displayed on the server’s web page. You may also use standard web-service calls to retrieve this data for display on remote web servers. This would allow monitoring of a common core infrastructure at a central site, while each site could keep local/customized views as required.

References
===============

* [One Way Active Measurement Protocol (OWAMP)](http://docs.perfsonar.net/config_owamp.html)
* [Bandwidth Control tool (BWCTL)](http://docs.perfsonar.net/config_bwctl.html)

See also the OSG/WLCG pages on perfSONAR at <https://twiki.opensciencegrid.org/bin/view/Documentation/DeployperfSONAR>
