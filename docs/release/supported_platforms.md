title: Supported Platforms

Supported Platforms
===================

The OSG Software [Release Series](../release/release_series.md) are supported on Red Hat Enterprise Linux (RHEL)
compatible platforms for 64-bit Intel architectures according to the following table:

| Platform                    | OSG 24  | OSG 25  |
|-----------------------------|---------|---------|
| Alma Linux 10               |         | &#9989; |
| CentOS Stream 10            |         | &#9989; |
| Red Hat Enterprise Linux 10 |         | &#9989; |
| Rocky Linux 10              |         | &#9989; |
| Alma Linux 9                | &#9989; | &#9989; |
| CentOS Stream 9             | &#9989; | &#9989; |
| Red Hat Enterprise Linux 9  | &#9989; | &#9989; |
| Rocky Linux 9               | &#9989; | &#9989; |
| Alma Linux 8                | &#9989; | &#9989; |
| CentOS Stream 8             | &#9989; | &#9989; |
| Red Hat Enterprise Linux 8  | &#9989; | &#9989; |
| Rocky Linux 8               | &#9989; | &#9989; |


Starting in OSG 24, the above platforms are also supported on 64-bit ARM architecture:

| Architecture               | OSG 24  | OSG 25  |
|----------------------------|---------|---------|
| 64-bit Intel (amd64)       | &#9989; | &#9989; |
| 64-bit ARM (aarch64)       | &#9989; | &#9989; |


OSG builds and tests its RPMs on the latest releases of the relevant platforms (e.g., in 2025, the RHEL 9 builds were
based on RHEL 9.6).
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

| Release Series | Expected Release | EL8     | EL9     | EL10    |
|----------------|------------------|---------|---------|---------|
| OSG 26         | Q3 2026          | &#9989; | &#9989; | &#9989; |
| OSG 27         | Q3 2027          | &#9989; | &#9989; | &#9989; |
