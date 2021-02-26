Supported Platforms
===================

The OSG [release series](../release/release_series.md) are supported on Red Hat Enterprise Linux (RHEL) compatible platforms
for 64-bit Intel architectures according to the following table:

!!! note
    As of July 2020, only of a subset of the software stack is supported on RHEL 8-compatible platforms.
    The full software stack will be supported by the end of 2020.
    You can track packages released for EL8 through our [release notes](../release/notes.md).

| Platform                   | OSG 3.5 | OSG 3.6 |
|----------------------------|---------|---------|
| CentOS 7                   | &#9989; | &#9989; |
| CentOS 8                   | &#9989; | &#9989; |
| Red Hat Enterprise Linux 7 | &#9989; | &#9989; |
| Red Hat Enterprise Linux 8 | &#9989; | &#9989; |
| Scientifix Linux 7         | &#9989; | &#9989; |

OSG builds and tests its RPMs on the latest releases of the relevant platforms (e.g., in 2018, the RHEL 7 builds were based on RHEL 7.5).
Older platform release versions may not receive thorough testing and may have subtle bugs.
In particular, versions of RHEL/CentOS/SL 7 less than 7.5 have known issues with several pieces of software, including `osg-oasis` and `xrootd-lcmaps`.
If sites run into problems with one of those versions, we will ask them to update to the latest operating system packages as part of the support process.
