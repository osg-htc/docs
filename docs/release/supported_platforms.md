title: Supported Platforms

Supported Platforms
===================

!!! danger "Upcoming OSG 3.6 end-of-support dates"
    OSG 3.6 reaches the "End of Regular Support" on March 31, 2024 and will only receive critical bug-fix and
    security update until it's end-of-life on June 30, 2024.
    See our [Release Series documentation](./release_series.md#series-life-cycle) for more details.

    Note that the OSG 3.6 end-of-life coincides with the wider Enterprise Linux 7 end-of-life.
    **We recommend upgrading to OSG 23 and an Enteprise Linux 9 distribution at your earliest convenience.**

The OSG [release series](../release/release_series.md) are supported on Red Hat Enterprise Linux (RHEL) compatible
platforms for 64-bit Intel architectures according to the following table:

| Platform                   | OSG 3.6 | OSG 23  |
|----------------------------|---------|---------|
| Alma Linux 9               | &#9989; | &#9989; |
| CentOS Stream 9            | &#9989; | &#9989; |
| Red Hat Enterprise Linux 9 | &#9989; | &#9989; |
| Rocky Linux 9              | &#9989; | &#9989; |
| Alma Linux 8               | &#9989; | &#9989; |
| CentOS Stream 8            | &#9989; | &#9989; |
| Red Hat Enterprise Linux 8 | &#9989; | &#9989; |
| Rocky Linux 8              | &#9989; | &#9989; |
| CentOS 7                   | &#9989; |         |
| Red Hat Enterprise Linux 7 | &#9989; |         |
| Scientifix Linux 7         | &#9989; |         |

OSG builds and tests its RPMs on the latest releases of the relevant platforms (e.g., in 2023, the RHEL 9 builds were
based on RHEL 9.2).
Older platform release versions may not receive thorough testing and may have subtle bugs.
If you run into problems with an older OS version, you will be asked them to update to the latest operating system
packages as part of the support process.

In particular, versions of RHEL/CentOS/SL 7 less than 7.5 have known issues with several pieces of software, including
`osg-oasis` and `xrootd-lcmaps`.
In addition, versions of RHEL/CentOS/SL 7 less than 7.8 do not have Python 3, which is required to run HTCondor 9 and
HTCondor-CE 5.

Future Release Series Plans
---------------------------

The OSG Software Team expects to support the following Enterprise Linux (EL) major operating system versions for future
OSG Software [Release Series](../release/release_series.md):

| Release Series | Expected Release | EL8     | EL9     |
|----------------|------------------|---------|---------|
| OSG 24         | Q3 2024          | &#9989; | &#9989; |
| OSG 25         | Q3 2025          | &#9989; | &#9989; |
