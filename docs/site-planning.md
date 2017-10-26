Site Planning
=============

This document is for **System Administrators**. The purpose of the document is to provide an overview about the different ways to setup an OSG site and to encourage you to plan your site before you continue to install the OSG software on your site.

After reading this document you should be able to identify the site elements needed to setup your OSG site and choose among different technology choices presented.

Background
----------

The goal for the OSG Software stack is to provide a uniform computing and storage fabric across many
independently-managed computing and storage resources. These individual services will be accessed by virtual
organizations (VOs), which will delegate the resources to scientists, researchers, and students.

_Sharing_ is a fundamental principle for the OSG: your site is encouraged to support as many OSG-registered VOs as
local conditions allow.  _Autonomy_ is another principle: you are not required to support any you do not want.

As the administrator responsible for deployment of the OSG software stack, your task is to make your existing computing
and storage resources available to and reliable for your supported VOs. Fundamentally, there are three components:

- *Compute Element* (CE): This provides remote access for VOs to submit "pilot jobs" to your local batch system.
- *Worker node* (WN): A standardized runtime environment for pilot jobs, managed and allocated by the batch system.
- *Data*: Various services that provide access to the data and storage resources at your site.

Depending on the VOs you want to support, data services may not be necessary.  Even a compute element is not strictly
necessary: OSG offers a "hosted CE" service where OSG will run the software provided only with a SSH connection to the
batch submit host.  Contact <mailto:goc@opensciencegrid.org> for more information on the hosted CE.

- The simplest way to support OSG is to only provide SSH logins for the hosted CE and install the worker node
  environment.
- Larger or more complex sites will elect to run their own CE in addition to the WN environment and the simplest
  data service (HTTP proxy cache).
- The largest sites will additionally run large-scale data services such as a "storage element".  This is often required
  for sites that want to support more complex organizations such as ATLAS or CMS.

!!! note
    An essential concept on the OSG is the "pilot job".  The pilot, which arrives at your batch system, is sent by the
    VO and gets a resource allocation.  However, it _does not_ contain any scientific payload.  Once started, it will
    connect back to a resource pool and pull down individuals' scientific "payload jobs".  Hence, we do not think about
    submitting "jobs" to sites but rather "resource requests".

Site Policies
-------------

Sites are encouraged to clearly specify and communicate their local policies regarding resource access. One common
mechanism to do this is post them on a web page and make this page part of your site registration in
[MyOSG](http://my.opensciencegrid.org).  Written policies help external entities understand what your site wants to
accomplish with the OSG -- and are often internally clarifying.

In line of our principle of *sharing*, we encourage you to allow virtual organizations registered with the OSG
"opportunistic use" of your resources. You may need to preempt those jobs when higher priority jobs come around.
The end-users using the OSG generally prefer having access to your site subject to preemption over having no access
at all.

Compute Element
---------------

A **Compute Element** allows VOs to access the resources at your site via external submission to a batch system.  To
provide this service, the OSG provides a vertically-integrated set of software centered around the "HTCondor-CE".

As part of the CE deploy, you must make a few site design choices:

- Host operating system: Red Hat Enterprise Linux 6 or 7 are supported, as well as derivative distributions (CentOS,
  ScientificLinux),
- The batch system:  HTCondor, PBS, LSF, SGE, and Slurm are presently supported.  About 70% of OSG sites select
  HTCondor.  Non-HTCondor sites will need a shared filesystem between the CE and worker nodes that is _writable by
  root_ from the CE.
- The network architecture of your cluster: Most VOs require unrestricted outbound network access from the worker nodes;
  this is typically done through a NAT.  For sites where this is difficult to provide, some VOs are be able to provide
  a whitelist of IP addresses they will need outbound access to; contact <mailto:goc@opensciencegrid.org> for support.

The CE will map each VO to one Unix user accont at the site (due to historic concerns, a handful may map to 2-3
accounts).  Except in the case of HTCondor, the CE and the worker nodes need to have uniform username-to-UID mappings.

In addition to the basic remote submission service, the CE providers accounting and monitoring services, which will
run by default when the CE is enabled and started. The OSG central accounting system, GRACC, recieves individual
records for each job run by the OSG on your CE. Aggregated summaries of this information can be viewed via the
[GRACC](https://gracc.opensciencegrid.org) web interface.

Worker Node Client
------------------

The Worker Node Client is software installed on each worker node to provide a minimal runtime environment for pilot
jobs.  We strive to keep this as lightweight as possible; it includes basic grid utilities, not scientific libraries.

There is a wide range of worker node management practices; accordingly, we provide the worker node client in three
forms:

- [*RPM packaging*](worker-node/install-wn.md): Grid utilities are deployed at the system level using `yum`.
- [*Tarball installation*](worker-node/install-wn-tarball.md): Utilities are deployed onto a sitewide shared
  filesystem by unpacking a tarball and running a configuration script.
- [*CVMFS*](worker-node/install-wn-oasis): CVMFS, a heavily-used global read-only filesystem, provides a copy of the grid utilities.

Additionally, OSG packages a global read-only filesystem called [CVMFS](worker-node/install-cvmfs) for distribution of
software and data.  Many VOs either completely rely on CVMFS for software (LIGO, CMS, ATLAS) or rely on CVMFS for a
majority of jobs (OSG VO).  Some jobs can utilize worker nodes without CVMFS.  You will be able to share your
resources regardless, but installing CVMFS is a primary mechanism to attract more jobs.

Data Service
------

There are two types of data services on the OSG:

- A *cache* pulls in data on read-demand, keeping it locally for further use.  We provide support for the
  [Squid HTTP](data/frontier-squid) cache for smaller working set sizes and software called [Xrootd](http://xrootd.org)
  for larger datasets.  Almost every site on the OSG installs a Squid cache.
- A **Storage Element** provides remote, POSIX-like access to your site storage service for reading and writing of data.
  All Storage Element implementations in the OSG support the GridFTP, Xrootd, and HTTPs protocols.

The storage element model is chosen mostly by sites that support either ATLAS or CMS VOs; otherwise, only caches are
typically provided.  Sites that need a SE which have existing POSIX-like storage (e.g., Lustre, GPFS) layer remote
access services (such as [GridFTP](data/gridftp)) on top of the existing storage.  For sites wanting petascale storage -
but without an existing install - we provide support for [HDFS](data/hadoop-overview) and
[Xrootd](data/xrootd-overview).

<!-- TODO: these figures were all garbage.  Redraw
## Example Configurations
This section contains a few example that illustrate how the different elements contributing to an OSG site can be
combined. Each %GRAY%gray%ENDCOLOR% box represents a physical resource or virtual machine that is required in the
example.
-->
