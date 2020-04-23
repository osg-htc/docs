Requesting an OSG Hosted CE
===========================

An OSG Hosted Compute Element (CE) is the entry point for jobs coming from the OSG;
it handles authorization and delegation of jobs to your existing campus HPC/HTC cluster.

Many sites set up their compute element locally.
As an alternative, OSG offers a Hosted CE option
wherein the OSG team will host and operate the HTCondor compute element,
and configure it for the science communities that you choose to support.
The Hosted CE can support thousands of concurrent job submissions.

This document explains the requirements and the procedure for obtaining a Hosted CE.
If you wish to run your own local compute element or expect to support more than 10,000 concurrently running OSG jobs,
see [this page](/compute-element/install-htcondor-ce) for installing the HTCondor-CE.

![managed services diagram](/compute-element/img/managed_services_diagram.png)


Before Starting
---------------

Before preparing your cluster for OSG jobs, consider the following requirements:

-   An existing compute cluster with a [supported batch system](/index.md#prepare-the-batch-system)
    running on a [supported operating system](/release/supported_platforms)

-   Outbound network connectivity from the worker nodes (they can be behind NAT)

-   A Unix account on your cluster's submit server, accessible via an SSH key.
    The Hosted CE will use this account to automatically submit jobs,
    so it must also have permissions to submit jobs to the batch system

-   If your batch system is not HTCondor,
    there must be a shared file system between the submit server and the worker nodes.
    See [this section](#providing-the-osg-worker-node-client-htcondor-batch-systems-only) for details.

-   [Temporary scratch space](/worker-node/using-wn#for-site-administrators) on each worker node


Which Science Communities and Institutions am I Supporting?
-----------------------------------------------------------

The OSG provides monitoring to view which communities are accessing your site, their fields of science, and home institution.
Below is an example of the monitoring views that will be available for your cluster.

![monitoring graphs](/compute-element/img/monitoring_graphs.png)

Each community in the OSG utilizing the Hosted CEs is mapped to your site as a fixed, specific account; we request
the account names are of the form `osg01` through `osg20`.

The mappings from Unix username to community is as follows:

| User | VO(s) | Description |
| ---- | ----- | ----- |
| osg01 | OSG | Projects (primarily single PI, such as OSG-Connect) supported directly by the OSG organization. |
| osg02 | GLOW | Projects coming from the Center for High Throughput Computing at the University of Wisconsin-Madison. |
| osg03 | HCC | Projects coming from the Holland Computing Center at the University of Nebraska - Lincoln. |
| osg04 - osg20 | - | Unassigned. |

So, for example, the activities in your batch system corresponding to the user `osg02` will always be associated with the GLOW organization.  Note these mappings are the same for each site.  As more communities participate in the program, this table will be updated.

Security
--------

OSG takes multiple precautions to maintain security and prevent unauthorized
usage of resources:

-   Access to the OSG system with SSH keys are restricted to the OSG staff maintaining them
-   Users are carefully vetted before they are allowed to submit jobs to OSG
-   Jobs running through OSG can be traced back to the user that submitted them
-   Job submission can quickly be disabled if needed
-   OSG staff are readily contactable in case of an emergency,
    through email at <mailto:help@opensciencegrid.org>


Applying for an OSG Hosted CE
-----------------------------

Before making any system changes, you should do the following steps:

-   Fill out the [cluster integration questionnaire](https://docs.google.com/forms/d/e/1FAIpQLSexKMFho_TGJ8nOY-qLXJf_8neAnjDSJqrNbYIUvMcOfoZ6Uw/viewform?usp=sf_link)
    so that the OSG team has basic information about your cluster

-   Email [help@opensciencegrid.org](mailto:help@opensciencegrid.org)
    to set up a consultation call with the OSG team,
    in order to discuss how you would like to contribute to the OSG;
    for example, the number of OSG jobs that should run, what resource limits you have,
    or which science communities you support

After the consultation, do the following:

-   Create a Unix account for OSG jobs on the submit server and across the cluster as necessary

-   Install OSG-provided public SSH keys for the account

Once this is done, the OSG team will:

-   Configure the Hosted CE with your system details

-   Validate operation with a set of test jobs

-   Configure central OSG services to schedule jobs

Optionally, we can assist you in
[installing and setting up the Squid and OASIS](#optional-providing-access-to-application-software-using-oasis)
software on your cluster in order to support application software repositories.
This will allow a broader set of jobs to run on your cluster.


Providing the OSG Worker Node client (HTCondor batch systems only)
------------------------------------------------------------------

All OSG sites need to provide the OSG Worker Node Client on each worker node in the cluster.
This is normally handled by OSG staff for a Hosted CE, but requires shared home directories across the cluster.

However, for sites with an HTCondor batch system, often there is no shared filesystem set up.
If you run an HTCondor site and it is easier to install and maintain the Worker Node Client on each worker node than to
set up and maintain shared file system, you have the following options:

-   Install the [Worker Node Client from RPM](/worker-node/install-wn)
-   Install the [Worker Node Client from tarball](/worker-node/install-wn-tarball)
-   Install the Worker Node Client from [OASIS](/worker-node/install-wn-oasis)


**Optional**: Providing Access to Application Software Using OASIS
------------------------------------------------------------------

Many OSG jobs make of use software modules provided by their collaborations or by the OSG User Support team.
In order to support these jobs without having to install specific software modules on your cluster,
OSG sites may provide a distributed software repository system called OASIS, built on top of
[CVMFS](https://cernvm.cern.ch/portal/filesystem).

In order to provide OASIS at your site, you will need the following:

-   A cluster-wide Frontier Squid proxy service with at least 50GB of cache space;
    installation instructions for Frontier Squid are [provided here](/data/frontier-squid).

-   A local OASIS cache per worker node (10 GB minimum, 20 GB recommended)

After setting up the Frontier Squid proxy and local caches on each worker node,
[install OASIS](/worker-node/install-cvmfs) on each worker node.

How to Get Help
---------------

If you need help with setup or troubleshooting, see our [help procedure](/common/help).

