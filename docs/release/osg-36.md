!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](notes.md)

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

!!! question "Where are GlideinWMS and XRootD?"
    XRootD and GlideinWMS are both absent in the initial OSG 3.6 release:
    we expect major version updates that may require manual intervention for both of these packages so we are holding
    their initial releases in this series until they are ready.

!!! warning "OSG 3.5 end-of-life"
    As a result of this initial OSG 3.6 release, the end-of-life dates have been set for OSG 3.6 per our
    [policy](https://opensciencegrid.org/technology/policy/release-series/):
    regular support will end in **August 2021** and critical bug/security support will end in **February 2022**.

This is the start of a new release series where we introduce major changes.
One of the major changes is the shift to token based authentication.
Here is a short list of the differences:

-   GridFTP, GSI, and Hadoop are no longer available
-   Added packages to support token-based authentication
-   [HTCondor 8.9.11](https://htcondor.readthedocs.io/en/latest/version-history/development-release-series-89.html#version-8-9-11): Initial token support (8.9.12, which will contain default configuration using tokens, was delayed)
-   [HTCondor-CE 5.0.0](https://htcondor.github.io/htcondor-ce/releases/#500): Support for tokens and Python 3
-   [Gratia Probe 2.0.0](https://github.com/opensciencegrid/gratia-probe/releases/tag/v2.0.0-2): replace all batch system probes with the non-root HTCondor-CE probe
-   [OSG-Configure 4.0.0](https://github.com/opensciencegrid/osg-configure/releases/tag/v4.0.0):
    - Deprecated RSV
    - Dropped unused configuration modules and attributes
    - Reorganized some configuration (see [update instructions](updating-to-osg-36.md#osg-configure) for more details)

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
