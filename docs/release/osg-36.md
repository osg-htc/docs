!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If you do not know which VOs you are currently supporting, contact us at <help@opensciencegrid.org>.

OSG 3.6 News
============

**Supported OS Versions:** EL7, EL8

The OSG 3.6 release series introduces HTCondor 8.9 and soon HTCondor 9.0.
With HTCondor 9.0 we will be transistioning to token based authentication.
We also dropped support for the GridFTP, GSI authentication, and Hadoop.

To update to the OSG 3.6 series, please consult the page on
[updating between release series](updating-to-osg-36.md).

Latest News
-----------

### 2020-02-26: 3.6 Released

This is the start of a new release series where we introduce major changes.
One of the major changes is the shift to token based authentication.
Here is a short list of the differences:

-   GridFTP, GSI, and Hadoop are no longer available
-   Added packages to support token-based authentication
-   HTCondor 8.9.11 (HTCondor 8.9.12 release was delayed)
-   HTCondor 5.0.0
-   [Gratia Probe 2.0.0](https://github.com/opensciencegrid/gratia-probe/releases/tag/v2.0.0-2): replace all batch system probes with the non-root HTCondor-CE probe

In addition, we have updated our
[Software Release Policy](https://opensciencegrid.org/technology/policy/software-release/) to follow a rolling
release model.

Finally, our [Docker image releases](https://opensciencegrid.org/technology/policy/container-release/) will more
closely track our OSG 3.6 repositories.

Announcements
-------------

Updates to critical packages also announced by email and are sent to the following recipients and lists:

-   [Registered administrative contacts](../common/registration.md#registering-resources)
-   [osg-general@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-GENERAL)
-   [osg-operations@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-OPERATIONS)
-   [osg-sites@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=OSG-SITES)
-   [site-announce@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=site-announce)
-   [software-discuss@opensciencegrid.org](https://listserv.fnal.gov/scripts/wa.exe?A0=software-discuss)
