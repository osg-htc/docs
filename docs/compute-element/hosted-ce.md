DateReviewed: 2021-01-28

Requesting an OSG Hosted CE
===========================

An OSG Hosted Compute Entrypoint (CE) is the entry point for [resource requests](../resource-sharing/overview.md) coming
from the OSG;
it handles authorization and delegation of resource requests to your existing campus HPC/HTC cluster.
Many sites set up their compute entrypoint locally.

As an alternative, OSG offers a Hosted CE option
wherein the OSG team will host and operate the HTCondor Compute Entrypoint,
and configure it for the communities that you choose to support.

This document explains the requirements and the procedure for requesting an OSG Hosted CE.

![managed services diagram](img/managed_services_diagram.png)

!!! info "Running more than 10,000 resource requests"
    The Hosted CE can support thousands of concurrent resource request submissions.
    If you wish to run your own local compute entrypoint or expect to support more than 10,000 concurrently running OSG
    resource requests, see [this page](../compute-element/install-htcondor-ce.md) for installing the HTCondor-CE.


Before Starting
---------------

Before preparing your cluster for OSG resource requests, consider the following requirements:

-   An existing compute cluster with a [supported batch system](../detailed-overview.md#prepare-the-batch-system)
    running on a [supported operating system](../release/supported_platforms.md)
-   Outbound network connectivity from the worker nodes (they can be behind NAT)
-   One or more Unix accounts on your cluster's submit server, accessible via SSH key, with permissions to submit jobs
    to your local cluster.
-   Shared user home directories between the submit server and the worker nodes.
    Not required for HTCondor clusters:
    see [this section](#htcondor-only-providing-the-osg-worker-node-client) for more details.
-   [Temporary scratch space](../worker-node/using-wn.md#for-site-administrators) on each worker node
-   OSG resource contributors must inform the OSG of [any relevant](../site-responsibilities.md) changes to their site.

    !!! important "Site downtimes"
        For an improved turnaround time regarding an outage or downtime at your site,
        [contact us](mailto:help@opensciencegrid.org) and include `downtime` in the subject or body of the email.

For additional technical details, please consult the [reference](#reference) section below.

!!! question "Don't meet the requirements?"
    If your site does not meet these conditions, please [contact us](mailto:help@opensciencegrid.org) to discuss
    your options for contributing to the OSG.


Scheduling a Planning Consultation
----------------------------------

Before participating in the OSG, either as a computational resource contributor or consumer,
we ask that you [contact us](mailto:help@opensciencegrid.org) to set up a consultation.
During this consultation, OSG staff will introduce you and your team to the OSG and develop a plan to meet your resource
contribution and/or research goals.


Preparing Your Local Cluster
----------------------------

After the consultation, ensure that your local cluster meets the [requirements as outlined above](#before-starting).
In particular, you should now know which [accounts to create](#user-accounts) for the communities that you wish to serve
at your cluster.

Additionally, OSG staff may have directed you to follow installation instructions from one or more of the following
sections:

### (Recommended) Providing access to CVMFS ###

!!! tip "Maximize resource utilization; required for GPU support"
    Installing CVMFS on your cluster makes your resources more attractive to OSG user jobs!
    Additionally, if you plan to contribute GPUs to the OSG, installation of CVMFS is **required**.

Many users in the OSG make of use software modules and/or containers provided by their collaborations or by the OSG
Research Facilitation team.
In order to support these users without having to install specific software modules on your cluster,
you may provide a distributed software repository system called
[CernVM File System](https://cernvm.cern.ch/portal/filesystem) (CVMFS).

In order to provide CVMFS at your site, you will need the following:

-   A cluster-wide Frontier Squid proxy service with at least 50GB of cache space;
    installation instructions for Frontier Squid are [provided here](../data/run-frontier-squid-container.md).

-   A local CVMFS cache per worker node (10 GB minimum, 20 GB recommended)

After setting up the Frontier Squid proxy and worker node local caches,
[install CVMFS](../worker-node/install-cvmfs.md) on each worker node.


### (HTCondor clusters only) Installing the OSG Worker Node Client ###

!!! tip "Skip this section if you have CVMFS or shared home directories!"
    If you have [CVMFS](#recommended-providing-access-to-cvmfs) installed or shared home directories on your worker
    nodes, you can skip manual installation of the OSG Worker Node Client.

All OSG sites need to provide the OSG Worker Node Client on each worker node in their local cluster.
This is normally handled by OSG staff for a Hosted CE but that requires shared home directories across the cluster.

However, for sites with an HTCondor batch system, often there is no shared filesystem set up.
If you run an HTCondor site and it is easier to install and maintain the Worker Node Client on each worker node than to
install CVMFS or maintain shared file system, you have the following options:

-   Install the [Worker Node Client from RPM](../worker-node/install-wn.md)
-   Install the [Worker Node Client from tarball](../worker-node/install-wn-tarball.md)


Requesting an OSG Hosted CE
---------------------------

After preparing your local cluster, apply for a Hosted CE by filling out the
[cluster integration questionnaire](https://docs.google.com/forms/d/e/1FAIpQLSexKMFho_TGJ8nOY-qLXJf_8neAnjDSJqrNbYIUvMcOfoZ6Uw/viewform?usp=sf_lin).
Your answers will help our operators submit resource requests to your local cluster of the appropriate size and scale.

!!! question "Can I change my answers at a later date?"
    Yes! If you want the OSG to change the size (i.e. CPU, RAM), type (e.g., GPU requests), or number of resource requests,
    [contact us](mailto:help@opensciencegrid.org) with the FQDN of your login host and the details of your changes.


Finalizing Installation
-----------------------

After applying for an OSG Hosted CE, our staff will contact you with the following information:

-   IP ranges of OSG hosted services
-   Public SSH key to be installed in the [OSG accounts](#user-accounts)

Once this is done, OSG staff will work with you and your team to begin submitting resource requests to your site, first
with some tests, then with a steady ramp-up to full production.


### Validating contributions ###

In addition to any internal validation processes that you may have, the OSG provides monitoring to view which
communities and projects within said communities are accessing your site, their fields of science, and home institution.
Below is an example of the monitoring views that will be available for your cluster.

![monitoring graphs](img/monitoring_graphs.png)

To view your contributions, select your site from the `Facility` dropdown of the
[Payload job summary](https://gracc.opensciencegrid.org/d/000000043/pilot-jobs-summary?orgId=1) dashboard.
Note that accounting data may take up to 24 hours to display.


Reference
---------


### User accounts ###

Each community in the OSG utilizing the Hosted CEs is mapped to your site as a fixed, specific account; we request
the account names are of the form `osg01` through `osg20`.

The mappings from Unix username to community is as follows:

| User          | VO(s)    | Description                                                                                          |
| ----          | -----    | -----                                                                                                |
| osg01         | OSG      | Projects (primarily single PI, such as OSG-Connect) supported directly by the OSG organization       |
| osg02         | GLOW     | Projects coming from the Center for High Throughput Computing at the University of Wisconsin-Madison |
| osg03         | HCC      | Projects coming from the Holland Computing Center at the University of Nebraska - Lincoln            |
| osg04         | CMS      | High-energy physics experiment from the Large Hadron Collider at CERN                                |
| osg05         | Fermilab | Experiments from the Fermi National Accelerator Laboratory                                           |
| osg06         | JLab     | Experiments from the Thomas Jefferson National Accelerator Facility                                  |
| osg07         | IGWN     | Gravitational wave detection experiments                                                             |
| osg08         | IGWN     | Gravitational wave detection experiments                                                             |
| osg09         | ATLAS    | High-energy physics experiment from the Large Hadron Collider at CERN                                |
| osg10         | GlueX    | Study of quark and gluon degrees of freedom in hadrons using high-energy photons                     |
| osg11         | DUNE     | Experiment for neutrino science and proton decay studies                                             |
| osg12         | IceCube  | Research based on data from the IceCube neutrino detector                                            |
| osg13         | XENON    | Dark matter search experiment                                                                        |
| osg14 - osg20 | -        | Unassigned                                                                                           |

For example, the activities in your batch system corresponding to the user `osg02` will always be associated with the
GLOW community.


### Security ###

OSG takes multiple precautions to maintain security and prevent unauthorized usage of resources:

-   Access to the OSG system with SSH keys are restricted to the OSG staff maintaining them
-   Users are carefully vetted before they are allowed to submit jobs to OSG
-   Jobs running through OSG can be traced back to the user that submitted them
-   Job submission can quickly be disabled if needed
-   Our security team is readily contactable in case of an emergency:
    <https://opensciencegrid.org/security/#reporting-a-security-incident>


How to Get Help
---------------

If you need help with setup or troubleshooting, [contact us](mailto:help@opensciencegrid.org).
