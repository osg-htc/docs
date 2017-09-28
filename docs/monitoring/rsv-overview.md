Resource and Service Validation (RSV) Service
=============================================

RSV Description
---------------

The Resource and Service Validation (RSV) software provides a scalable and easy to maintain resource/service monitoring infrastructure for an OSG site admin.

The components of RSV are:

-   **RSV Client:** The client allows OSG site administrators to run tests against their CEs/SEs. This provides a set of metrics to test the resource, Condor-Cron for scheduling, and a Gratia infrastructure for collecting and storing the results.
    -   The RSV Client runs metrics at scheduled time intervals. It produces a simple webpage of local RSV results for a site administrator's viewing. It also has the capability to upload those probe results to a central collector (addressed next).
-   **RSV Collector/Server:** The server collects results from any number of RSV clients and stores them in a database. You can view these central results on [the MyOSG-based RSV current status page](http://myosg.grid.iu.edu/rgcurrentstatus/index?datasource=currentstatus&summary_attrs_showservice=on&summary_attrs_showrsvstatus=on&summary_attrs_showfqdn=on&gip_status_attrs_showtestresults=on&downtime_attrs_showpast=&account_type=cumulative_hours&ce_account_type=gip_vo&se_account_type=vo_transfer_volume&start_type=7daysago&start_date=12/25/2009&end_type=now&end_date=12/25/2009&all_resources=on&gridtype=on&gridtype_1=on&service_central_value=0&service_hidden_value=0&active=on&active_value=1&disable_value=1). Other RSV-based choices are available in the *Resource Group menu* within MyOSG.
-   **Periodic Availability Reports:** The availability of all active registered OSG resources and the services running on each of those resources is calculated using the results received for [critical metrics](https://twiki.grid.iu.edu/bin/view/Operations/RsvEquivalency#Critical_Tests_for_OSG_Resources). Once a day, these availability numbers are [published online](http://rsv.grid.iu.edu/daily-reports) (More information: [Outline of reports](https://twiki.grid.iu.edu/bin/view/Operations/RSVPeriodicReporting)
-   **RSV-SAM Transport:** The WLCG RSV-SAM Transport infrastructure pushes out RSV results (for resources that are flagged to be part of the WLCG Interoperability agreement) from the GOC collector to WLCG's Service Availability Monitoring (SAM) system. More information on [viewing these results is available here](https://twiki.grid.iu.edu/bin/view/Operations/RsvSAMGridView).
    -   **MyOSG and OIM Links:** RSV picks up resource information, WLCG interoperability information, etc. from a MyOSG resource group summary listing, which is in turn based on the [OSG Information Management (OIM) (topology) system](https://oim.grid.iu.edu) (Requires registration). Resource [maintenance scheduled on OIM](https://twiki.grid.iu.edu/bin/view/Operations/OIMMaintTool), are forwarded to WLCG SAM, if applicable.

Installing and configuring RSV
------------------------------

-   [Installing RSV](install-rsv) - For installing RSV and simple configuration
-   [Configuring RSV](advanced-rsv-configuration) - Advanced configuration instructions
-   [Managing RSV via rsv-control](rsv-control) - rsv-control is a tool to manage RSV

RSV Troubleshooting
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

!!! note
    If you are getting assistance via the trouble ticket system, you must add a `.txt` extension to the tarball so it can be uploaded:

        :::console
        root@host# mv rsv-profiler.tar.gz rsv-profiler.tar.gz.txt

### Resending failed Gratia records

If RSV fails to send Gratia records, it will save a copy of the output into `/var/spool/rsv/failed-gratia-scripts`.
You will be notified if files are in this directory on your HTML status page.

If files appear here, you can attempt to determine why by looking at this log file: `/var/log/rsv/consumers/gratia-consumer.output`.
(This file is rotated, so the error message may no longer be present.)

Usually this error is spurious - there may have been a problem with the central collector being unavailable, or there may have been a network problem.
The first step to fix this problem is to try to resend these files.
To do so, move them back into the `gratia` directory and they will be resent the next time the gratia-script-consumer runs (about every 5 minutes):

``` console
root@host# mv /var/spool/rsv/failed-gratia-records/* /var/spool/rsv/gratia-consumer/
```

If that does not solve your problem, follow the [help procedure](../common/help).

