Detailed Overview
=================

This document outlines the overall installation process for an OSG site and provides many links into detailed
installation, configuration, troubleshooting, and similar pages. If you do not see software-related technical
documentation listed here, try the search bar at the top or contacting us at
[help@opensciencegrid.org](mailto:help@opensciencegrid.org).

Plan the Site
-------------

If you have not done so already, [plan the overall architecture of your OSG site](site-planning.md).
It is recommended that your plan be sufficiently detailed to include the OSG hosts that are needed and the main software
components for each host.
Be sure to consider [the operating systems that OSG supports](release/supported_platforms.md). For example, a basic site might include:

| Purpose              | Host                                | Major Software                                           |
|:---------------------|:------------------------------------|:---------------------------------------------------------|
| Compute Entrypoint (CE) | `osg-ce.example.edu`                | OSG CE, HTCondor Central Manager, etc. (`osg-ce-condor`) |
| Worker Nodes         | `wNNN.cluster.example.edu`          | OSG worker node client (`osg-wn-client`)                 |

Prepare the Batch System
------------------------

The assumption is that you have an existing batch system at your site.
Currently, we support [HTCondor](http://research.cs.wisc.edu/htcondor/),
[LSF](https://www.ibm.com/us-en/marketplace/hpc-workload-management), PBS and
[Torque](https://adaptivecomputing.com/cherry-services/torque-resource-manager/),
[SGE](http://en.wikipedia.org/wiki/Oracle_Grid_Engine), and [Slurm](http://slurm.schedmd.com) batch systems.

For smaller sites (less than 50 worker nodes), the most common way to add a site to OSG is to install the OSG Compute
Element (CE) on the central host of your batch system.
At such a site - especially if you have minimal time to maintain a CE - you may want to contact
<mailto:help@opensciencegrid.org> to ask about using an OSG-hosted CE instead of running your own.
Before proceeding with an install, be sure that you can submit and successfully run a job from your OSG CE host into
your batch system.

Add OSG Software
----------------

If necessary, provision all OSG hosts that are in your site plan that do not exist yet.
The general steps to installing an OSG site are:

1. Install [OSG Yum Repos](./common/yum.md) and the [Compute Entrypoint software](#installing-and-configuring-the-compute-entrypoint)
   on your CE host
1. Install the [Worker Node client](#adding-osg-software-to-worker-nodes) on your worker nodes.
1. Install [optional software](#installing-and-configuring-other-services) to increase the capabilities of your site.

!!! note
    For sites with more than a handful of worker nodes, it is recommended to use some sort of configuration management
    tool to install, configure, and maintain your site.
    While beyond the scope of OSG’s documentation to explain how to select and use such a system, some popular
    configuration management tools are [Puppet](http://puppetlabs.com), [Chef](https://www.chef.io),
    [Ansible](https://www.ansible.com), and [CFEngine](http://cfengine.com).

### General Installation Instructions ###

-   [Security information for OSG signed RPMs](release/signing.md)
-   [Using Yum and RPM](release/yum-basics.md)
-   [Install the OSG Yum repositories](./common/yum.md)
-   [OSG Software release series](release/updating-to-osg-35.md) - look here to upgrade to OSG 3.5

### Installing and Managing Certificates for Site Security ###

-   [Installing the grid certificate authorities (CAs)](common/ca.md)
-   [How do I get X.509 host certificates?](security/host-certs/overview.md)
-   [Automatically updating the grid certificate authorities (CAs)](security/certificate-management.md)
-   [OSG PKI command line client reference](security/certificate-management.md)

### Installing and Configuring the Compute Entrypoint ###

-   Install the compute entrypoint (HTCondor-CE and other software):
    -   [Overview and architecture](compute-element/htcondor-ce-overview.md)
    -   [Request a Hosted CE](./compute-element/hosted-ce.md)
    -   [Install HTCondor-CE](compute-element/install-htcondor-ce.md)
    -   [Configure the HTCondor-CE job router](compute-element/job-router-recipes.md), including common recipes
    -   [Troubleshooting HTCondor-CE installations](compute-element/troubleshoot-htcondor-ce.md)
    -   [Submitting jobs to HTCondor-CE](compute-element/submit-htcondor-ce.md)
-   [`osg-configure` Reference](other/configuration-with-osg-configure.md)

### Adding OSG Software to Worker Nodes ###

-   [Worker Node (WN) Client Overview](worker-node/using-wn.md)
-   Install the WN client software on every worker node – pick a method:
    -   [Using RPMs](worker-node/install-wn.md) – useful when managing your worker nodes with a tool (e.g., Puppet, Chef)
    -   [Using a tarball](worker-node/install-wn-tarball.md) – useful for installation onto a shared filesystem (does not
        require root access)
    -   [Using OASIS](worker-node/install-wn-oasis.md) – useful when [CVMFS](worker-node/install-cvmfs.md) is already mounted
        on your worker nodes
-   (optional) [Install the CernVM-FS client](worker-node/install-cvmfs.md) to make it easy for user jobs to use needed
    software from OSG's OASIS repositories
-   (optional) [Install singularity on the OSG worker node](worker-node/install-singularity.md), to allow pilot jobs to
    isolate user jobs.


### Installing and Configuring Other Services ###

All of these node types and their services are optional, although OSG requires an HTTP caching service if you have
installed [CVMFS](worker-node/install-cvmfs.md) on your worker nodes.

-   [Install Frontier Squid](data/frontier-squid.md), an HTTP caching proxy service.
-   Storage element:
    -   Existing POSIX-based systems (such as NFS, Lustre, or GPFS):
        -   [Install standalone OSG GridFTP](data/gridftp.md): GridFTP server
        -   (optional) [Install load-balanced OSG GridFTP](data/load-balanced-gridftp.md): when a single GridFTP server
            isn't enough
    -   Hadoop Distributed File System (HDFS):
        -   [Hadoop Overview](data/hadoop-overview.md): HDFS information, planning, and guides
    -   XRootD:
        -   [XRootd Overview](./data/xrootd/overview.md): XRootD information, planning, and guides
        -   [Install XRootD Server](./data/xrootd/install-storage-element.md): XRootD redirector installation
-   RSV monitoring to monitor and report to OSG on the health of your site
    -   [Install RSV](monitoring/install-rsv.md)
-   [Install the GlideinWMS VO Frontend](other/install-gwms-frontend.md) if your want your users' jobs to run on the OSG
    -   [Install the RSV GlideinWMS Tester](monitoring/install-rsv-gwms-tester.md) if you want to test your front-end's
        ability to submit jobs to sites in the OSG

Get Help
--------
If you need help with your site, or need to report a security incident,
follow the [contact instructions](./common/help.md).

