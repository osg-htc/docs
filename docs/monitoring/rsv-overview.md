<span class="twiki-macro DOC_STATUS_TABLE"></span>

Resource and Service Validation (RSV) Service
=============================================

<span class="twiki-macro TOC"></span>

About this document
===================

This is documentation for RSV for OSG 3. RSV documentation for OSG 1.0 and 1.2 is available [here](Trash/Trash/MonitoringInformation/RSV).

RSV Description
===============

RSV Concepts
------------

The Resource and Service Validation (RSV) software provides a scalable and easy to maintain resource/service monitoring infrastructure for an OSG site admin.

-   [RSV Principles](RsvPrinciples)
-   [RSV Architecture](RsvArchitecture)

RSV Service Components
----------------------

The components of RSV are:

-   **RSV Client:** The client allows OSG site administrators to run tests against their CEs/SEs. This provides a set of metrics to test the resource, Condor-Cron for scheduling, and a Gratia infrastructure for collecting and storing the results.
    -   The RSV Client runs metrics at scheduled time intervals. It produces a simple webpage of local RSV results for a site administrator's viewing. It also has the capability to upload those probe results to a central collector (addressed next).
-   **RSV Collector/Server:** The server collects results from any number of RSV clients and stores them in a database. You can view these central results on [the MyOSG-based RSV current status page](http://myosg.grid.iu.edu/rgcurrentstatus/index?datasource=currentstatus&summary_attrs_showservice=on&summary_attrs_showrsvstatus=on&summary_attrs_showfqdn=on&gip_status_attrs_showtestresults=on&downtime_attrs_showpast=&account_type=cumulative_hours&ce_account_type=gip_vo&se_account_type=vo_transfer_volume&start_type=7daysago&start_date=12/25/2009&end_type=now&end_date=12/25/2009&all_resources=on&gridtype=on&gridtype_1=on&service_central_value=0&service_hidden_value=0&active=on&active_value=1&disable_value=1). Other RSV-based choices are available in the *Resource Group menu* within MyOSG.
-   **Periodic Availability Reports:** The availability of all active registered OSG resources and the services running on each of those resources is calculated using the results received for [critical metrics](Operations.RsvEquivalency#Critical_Tests_for_OSG_Resources). Once a day, these availability numbers are &lt;a href="<http://rsv.grid.iu.edu/daily-reports>"&gt;published online&lt;/a&gt; and via email [as explained here](Trash/Trash/MeasurementsAndMetrics.RsvReportsOverview). (More information: [Outline of reports](Operations.RSVPeriodicReporting), [Installation guide for GOC staff](Trash/Trash/MeasurementsAndMetrics.RsvReports)).
-   **RSV-SAM Transport:** The WLCG RSV-SAM Transport infrastructure pushes out RSV results (for resources that are flagged to be part of the WLCG Interoperability agreement) from the GOC collector to WLCG's Service Availability Monitoring (SAM) system. More information on [viewing these results is available here](Operations.RsvSAMGridView).
    -   **MyOSG and OIM Links:** RSV picks up resource information, WLCG interoperability information, etc. from a MyOSG resource group summary listing, which is in turn based on the [OSG Information Management (OIM) (topology) system](https://oim.grid.iu.edu) (Requires registration). Resource [maintenance scheduled on OIM](Operations.OIMMaintTool), are forwarded to WLCG SAM, if applicable.

For site administrators
=======================

Installing and configuring RSV
------------------------------

-   [InstallRSV](InstallRSV) - For Typical Simple RSV Configuration
-   [RSV Storage probes](RSVStorageProbes) - Information on monitoring SEs with RSV
-   [rsv-control documentation](RsvControl) - rsv-control is a tool to manage RSV
-   [How to configure RSV](ConfigureRsv) - Beginner and advanced configuration instructions

RSV Troubleshooting
-------------------

These documents list known issues, and are meant to help admins and GOC staff troubleshoot RSV issues:&lt;br /&gt;

-   [RSV v4 - OSG 3 troubleshooting](TroubleshootRsv)

Contact RSV Developers
----------------------

See [the contact Information page](RSVContactInfo).

For Developers
==============

-   [The RSV guide for developers](RsvDeveloperGuide) <span class="twiki-macro RED"></span> START HERE! <span class="twiki-macro ENDCOLOR"></span> This should be your starting point for learning about how to develop new RSV probes or maintain existing probes.
-   [List of RSV Metrics and their owners](RsvOwners)
-   [How to write, install, and test a new RSV probe](WriteYourOwnRSVProbe)
-   [How to access the RSV source code repository](RsvRepoAccess)
-   [How the source code repository and release process are managed](ReleaseMethodology)
-   [How RSV support works, and your role in it](RsvSupport)

RSV Probes
==========

-   [Xrootd probe](RsvProbeXrootMultiProbe)
-   [RSV Storage probes](RSVStorageProbes) - Information on monitoring SEs with RSV
-   RsvProbeCacertVerifyProbe
-   RsvProbeCrlFreshnessProbe
-   JavaVersionSSHProbe

Comments
========

<span class="twiki-macro COMMENT" type="tableappend"></span>
