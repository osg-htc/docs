Resource and Service Validation (RSV) Service
=============================================

RSV Description
---------------

The Resource and Service Validation (RSV) software provides a scalable and easy to maintain resource/service monitoring infrastructure for an OSG site admin.

The components of RSV are:

-   **RSV Client:** The client allows OSG site administrators to run tests against their CEs/SEs. This provides a set of metrics to test the resource, Condor-Cron for scheduling, and a Gratia infrastructure for collecting and storing the results.
    -   The RSV Client runs metrics at scheduled time intervals. It produces a simple webpage of local RSV results for a site administrator's viewing. It also has the capability to upload those probe results to a central collector (addressed next).
-   **RSV Collector/Server:** The server collects results from any number of RSV clients and stores them in a database. You can view these central results on [the MyOSG-based RSV current status page](http://myosg.grid.iu.edu/rgcurrentstatus/index?datasource=currentstatus&summary_attrs_showservice=on&summary_attrs_showrsvstatus=on&summary_attrs_showfqdn=on&gip_status_attrs_showtestresults=on&downtime_attrs_showpast=&account_type=cumulative_hours&ce_account_type=gip_vo&se_account_type=vo_transfer_volume&start_type=7daysago&start_date=12/25/2009&end_type=now&end_date=12/25/2009&all_resources=on&gridtype=on&gridtype_1=on&service_central_value=0&service_hidden_value=0&active=on&active_value=1&disable_value=1). Other RSV-based choices are available in the *Resource Group menu* within MyOSG.
-   **Periodic Availability Reports:** The availability of all active registered OSG resources and the services running on each of those resources is calculated using the results received for [critical metrics](Operations.RsvEquivalency#Critical_Tests_for_OSG_Resources). Once a day, these availability numbers are [published online](http://rsv.grid.iu.edu/daily-reports) (More information: [Outline of reports](https://twiki.grid.iu.edu/bin/view/Operations/RSVPeriodicReporting)
-   **RSV-SAM Transport:** The WLCG RSV-SAM Transport infrastructure pushes out RSV results (for resources that are flagged to be part of the WLCG Interoperability agreement) from the GOC collector to WLCG's Service Availability Monitoring (SAM) system. More information on [viewing these results is available here](https://twiki.grid.iu.edu/bin/view/Operations/RsvSAMGridView).
    -   **MyOSG and OIM Links:** RSV picks up resource information, WLCG interoperability information, etc. from a MyOSG resource group summary listing, which is in turn based on the [OSG Information Management (OIM) (topology) system](https://oim.grid.iu.edu) (Requires registration). Resource [maintenance scheduled on OIM](https://twiki.grid.iu.edu/bin/view/Operations/OIMMaintTool), are forwarded to WLCG SAM, if applicable.

Installing and configuring RSV
------------------------------

-   [InstallRSV](install-rsv) - For Typical Simple RSV Configuration
-   [rsv-control documentation](rsv-control) - rsv-control is a tool to manage RSV
-   [How to configure RSV](configure-rsv) - Beginner and advanced configuration instructions

RSV Troubleshooting
-------------------

These documents list known issues, and are meant to help admins and GOC staff troubleshoot RSV issues:&lt;br /&gt;

-   [RSV v4 - OSG 3 troubleshooting](TroubleshootRsv)

