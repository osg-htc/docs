How to Get Help
===============

This page is aimed at OSG site administrators looking for support. Help for OSG users is found at
[our support desk](https://support.opensciencegrid.org/support/home).

OSG Operations
--------------

OSG Operations is available to coordinate users, site admins, and developers around an issue.
Additionally, OSG Operations can provide basic monitoring and troubleshooting.
There are several ways to receive support:

*  You can [submit a trouble ticket](https://support.opensciencegrid.org/helpdesk/tickets/new) or send an email to
   [help@opensciencegrid.org](mailto:help@opensciencegrid.org) (which also accept general inquiries not intended for tickets.)
*  [This page](/release/notes) contains information about recent software releases
*  [This page](https://topology.opensciencegrid.org/rgdowntime/xml?) contains important outage and maintenance
   notifications of OSG resources.


Security incident
-----------------

Security incidents can be reported by following the instructions on the
[Incident Discovery and Reporting](https://opensciencegrid.org/security/IncidentDiscoveryReporting/) page.
Additional steps to aid in the incident handling process are also linked from that page.

Information Required to Help You
--------------------------------

If you came to this page from an installation or other document in this website, then follow instructions in the
**Troubleshooting** and **Debugging** sections of that document and include results in your support inquiry, no matter
which channel you choose (email, trouble ticket, web chat, ...)

For problems with installation of some software run `osg-system-profiler`:

```console
root@host # osg-system-profiler
```

Attach the generated `osg-profile.txt` to your support inquiry.

Community-specific Resources
----------------------------

Some OSG VOs have dedicated forums or mechanisms for community-specific support.
If your VO provides user support, that should be a user's first line of support because the VO is most familiar with
your applications and requirements.

* The list of support centers for OSG VOs can be found in the
[here](https://github.com/opensciencegrid/topology/blob/master/topology/support-centers.yaml).
* Resources for **CMS** sites:
    * <http://www.uscms.org/uscms_at_work/physics/computing/grid/index.shtml>
    * CMS Hyper News: <https://hypernews.cern.ch/HyperNews/CMS/get/osg-tier3.html>
    * CMS Twiki: <https://twiki.cern.ch/twiki/bin/viewauth/CMS/USTier3Computing>

