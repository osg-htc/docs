OSG Hosted CE
=============


## Overview

As an alternative to setting up your own CE, OSG offers a hosted CE option
to connect your existing campus HPC/HTC cluster to the Open Science Grid.
The OSG team will host and operate the HTCondor compute element which routes user jobs to your cluster,
configured for the science communities that you choose to support.

![fig bosco](/compute-element/img/screenshot_2983.png)


## Requirements

Here are the requirements:

-   An existing compute cluster with a supported batch system (HTCondor, LSF, PBS, Slurm, SGE),
    and a supported operating system (RHEL 6 or 7 or compatible)

-   Outbound network connectivity from the compute nodes (they can be behind NAT)

-   A Unix account on your cluster's submit server, accessible via an SSH key
    The OSG CE will use this account to automatically submit jobs,
    so it must also have permissions to submit jobs to the batch system


## Setup Process

Before making any system changes, you should do the following steps:

-   Fill out the [cluster integration questionnaire](http://goo.gl/forms/8OukxsyG6KBSGHuR2)
    so that the OSG team has basic information about your cluster

-   Email [help@opensciencegrid.org](mailto:help@opensciencegrid.org)
    to set up a consultation call with the OSG team,
    in order to discuss how you would like to contribute to the OSG;
    for example, the number of OSG jobs that should run, what resource limits you have,
    or which science communities you support

After the consultation, do the following:

-   Create a Unix account on the submit server for use by the OSG CE

-   Install public SSH keys for the account

Once this is done, the OSG team will:

-   Configure the OSG CE with your system details

-   Validate operation with a set of test jobs

-   Configure central OSG services to schedule jobs

Optionally, we can assist you in installing and setting up the Squid and OASIS software on your cluster
in order to support application software repositories.
This will allow a broader set of jobs to run on your cluster.


## Security

OSG takes multiple precautions to maintain security and prevent unauthorized
usage of resources:

-   Access to the OSG system with ssh keys are restricted to the OSG staff maintaining them
-   Users are carefully vetted before they are allowed to submit jobs to OSG
-   Jobs running through OSG can be traced back to the user that submitted them
-   Job submission can quickly be disabled if needed
-   OSG staff are readily contactable in case of an emergency,
    through email at [help@opensciencegrid.org](help@opensciencegrid.org)


## Which Science Communities and Institutions am I supporting?

The OSG provides monitoring to view which communities are accessing your site, their fields of science, and home institution.
Below is an example of the monitoring views that will be available for your cluster.

![monitoring graphs](/compute-element/img/screenshot_2979.png)


## **Optional**: Providing Access to Application Software Using OASIS

Many OSG communities use software modules provided by their collaborations or by the OSG User Support team.
In order to support these communities, without requiring specific application software on your cluster,
OSG sites use a distributed software repository system called OASIS.

In order to use OASIS, you will need the following:

-   A cluster-wide Squid proxy service with at least 50GB of cache space;
    we recommend using the Frontier Squid software provided in the OSG repositories

-   A local scratch area on each compute node; typical recommendations are 10 GB per job,
    plus an additional 20GB for caching OASIS data


### Install the OSG Packaged Frontier Squid Service

OSG has a yum repository with rpms of the OSG Frontier Squid service.  The rpms
include configuration files that allow Squid to access certified OSG software 
repositories.  Instructions on setting up Frontier Squid are available 
[here](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallFrontierSquid).

### Install the OSG OASIS Software on Your Cluster Compute Servers

OSG also provides rpms for the OASIS software in it's yum repositories.
Instructions on installing and making OASIS based software available on your
compute nodes are available
[here](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallCvmfs).

<br/>
## Getting Started

Drop us a note at [user-support@opensciencegrid.org](mailto:user-support@opensciencegrid.org) if this is of interest to you. We will contact you to setup a consultation.  
