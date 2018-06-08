Site Planning
=============

The OSG vision is to integrate computing across different resource types and business models to allow campus IT to offer
a maximally flexible _high throughput computing_ (HTC) environment for their researchers.

This document is for **System Administrators** and aims to provide an overview of the different options to consider when
planning to share resources via the OSG.

After reading, you should be able to understand what software or services you want to provide to support your
researchers

!!! note
    This document covers the most common options.  OSG is a diverse infrastructure: depending on what groups you want to
    support, you may need to install additional services.  Coordinate with your local researchers.

OSG Site Services
-----------------

The OSG Software stack tries to provide a uniform computing and storage fabric across many independently-managed
computing and storage resources. These individual services will be accessed by virtual organizations (VOs), which will
delegate the resources to scientists, researchers, and students.

_Sharing_ is a fundamental principle for the OSG: your site is encouraged to support as many OSG-registered VOs as
local conditions allow.  _Autonomy_ is another principle: you are not required to support any you do not want.  As the
administrator, your task is to make your existing computing and storage resources available to and reliable for your
supported VOs.

We break this down into three tasks:

- Getting "pilot jobs" submitted to your site batch system.
- Establishing a OSG runtime environment for running jobs.
- Delivering data to payload applications to be processed.

There are multiple approaches for each item, depending on the VOs you support and time you have to invest on the OSG.

!!! note
    An essential concept on the OSG is the "pilot job".  The pilot, which arrives at your batch system, is sent by the
    VO and gets a resource allocation.  However, it _does not_ contain any scientific payload.  Once started, it will
    connect back to a resource pool and pull down individuals' scientific "payload jobs".  Hence, we do not think about
    submitting "jobs" to sites but rather "resource requests".

### Pilot Jobs

Traditionally, an OSG *Compute Element* (CE) provides remote access for VOs to submit pilot jobs to your local batch
system.  However, today, there are two options for accepting pilot jobs at your site:

- **Hosted CE**: OSG will run and operate the CE services; the site only needs to provide a SSH pubkey-based
   authentication access to the central OSG host.  OSG will interface with the VO and submit pilots directly to your
   batch system via SSH.  By far, this is the _simplest option_: however, it is less-scalable and the site delegates
   many of the scheduling decisions to the OSG.  Contact <mailto:help@opensciencegrid.org> for more information on the
   hosted CE.
- **OSG CE**: The traditional option where the site installs and operates a HTCondor-based CE on a dedicated host.
   This provides the best scalability and flexibility, but may require an ongoing time investment from the site.  The
   OSG CE install and operation is covered in this documentation page.

### Runtime environment

The OSG provides a very minimal runtime environment that can be deployed via tarball, RPM, or through a global
filesystem on your cluster's worker nodes.

We believe that all scientific applications should be portable and self-contained, with no OS dependencies.
This provides access to the most resources and minimizes the presence at sites.
However, this ideal is often difficult to achieve in practice.
For sites that want to support a uniform runtime environment, we provide a global filesystem called CVMFS that VOs can
use to distribute their own software dependencies.

Finally, many researchers use applications that require a specific OS environment - not just individual dependencies -
that is distributed as a container.  OSG supports the use of the [Singularity](http://singularity.lbl.gov/) container
runtime with [Docker-based](https://hub.docker.com) image distribution.

### Data Services

Whether accessed through CVMFS or command-line software like `curl`, the majority of software is moved via HTTP in
cache-friendly patterns.  All sites are highly encouraged to use a HTTP proxy (such as the Squid software) to reduce
the load on the WAN from the cluster.

Depending on the VOs you want to support, additional data services may not be necessary:

- Some VOs elect to stream their larger input data from offsite using OSG's "StashCache" service.  This requires no
  services to be run by the site
- The largest sites will additionally run large-scale data services such as a "storage element".  This is often required
  for sites that want to support more complex organizations such as ATLAS or CMS.

Site Policies
-------------

Sites are encouraged to clearly specify and communicate their local policies regarding resource access.
One common mechanism to do this is post them on a web page and make this page part of your
[site registration](https://github.com/opensciencegrid/topology/).
Written policies help external entities understand what your site wants to accomplish with the OSG -- and are often
internally clarifying.

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
  a whitelist of IP addresses they will need outbound access to; contact <mailto:help@opensciencegrid.org> for support.

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

Caches and Storage Elements
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
