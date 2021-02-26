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
-   XRootD 5.0.0 (XRootD 5.1.0 release was delayed)
-   HTCondor 5.0.0 (HTCondor-CE 6.0.0 release was delayed)
-   Gratia probe
    -   consolidated all batch system probes into the HTCondor-CE probe
    -   dropped all storage probes

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
