Site Planning
=============

The OSG vision is to integrate computing across different resource types and business models to allow campus IT to offer
a maximally flexible _high throughput computing_ (HTC) environment for their researchers.

This document is for **System Administrators** and aims to provide an overview of the different options to consider when
planning to share resources via the OSG.

After reading, you should be able to understand what software or services you want to provide to support your
researchers

!!! note
    This document covers the most common options.
    OSG is a diverse infrastructure: depending on what groups you want to support, you may need to install additional
    services.
    Coordinate with your local researchers.

OSG Site Services
-----------------

The OSG Software stack tries to provide a uniform computing and storage fabric across many independently-managed
computing and storage resources.
These individual services will be accessed by virtual organizations (VOs), which will delegate the resources to
scientists, researchers, and students.

_Sharing_ is a fundamental principle for the OSG: your site is encouraged to support as many OSG-registered VOs as
local conditions allow.
_Autonomy_ is another principle: you are not required to support any VOs you do not want.
As the administrator, your task is to make your existing computing and storage resources available to and reliable for
your supported VOs.

We break this down into three tasks:

- Getting ["pilot jobs"](#pilot-jobs) submitted to your site batch system.
- Establishing an OSG [runtime environment](#runtime-environment) for running jobs.
- [Delivering data](#data-services) to payload applications to be processed.

There are multiple approaches for each item, depending on the VOs you support, and time you have to invest in the OSG.

!!! note
    An essential concept in the OSG is the "pilot job".
    The pilot, which arrives at your batch system, is sent by the VO to get a resource allocation.
    However, it _does not_ contain any research payload.
    Once started, it will connect back to a resource pool and pull down individuals' research "payload jobs".
    Hence, we do not think about submitting "jobs" to sites but rather "resource requests".

### Pilot Jobs

Traditionally, an OSG *Compute Entrypoint* (CE) provides remote access for VOs to submit pilot jobs to your
[local batch system](./detailed-overview.md#prepare-the-batch-system).
There are two options for accepting pilot jobs at your site:

- **Hosted CE**: OSG will run and operate the CE services; the site only needs to provide a SSH pubkey-based
   authentication access to the central OSG host.
   OSG will interface with the VO and submit pilots directly to your batch system via SSH.
   By far, this is the _simplest option_: however, it is less-scalable and the site delegates many of the scheduling
   decisions to the OSG.
   Contact <mailto:help@opensciencegrid.org> for more information on the hosted CE.
- **OSG CE**: The traditional option where the site installs and operates a HTCondor-based CE on a dedicated host.
   This provides the best scalability and flexibility, but may require an ongoing time investment from the site.
   The OSG CE install and operation is covered in [this documentation page](compute-element/install-htcondor-ce.md).

There are additional ways that pilots can be started at a site (either by the
site administrator or an end-user); see
[resource sharing](resource-sharing/overview.md) for more details.

### Runtime environment

The OSG requires a very minimal runtime environment that can be deployed via [tarball](./worker-node/install-wn-tarball.md),
[RPM](./worker-node/install-wn.md), or through a [global filesystem](./worker-node/install-wn-oasis.md) on your cluster's worker
nodes.

We believe that all research applications should be portable and self-contained, with no OS dependencies.
This provides access to the most resources and minimizes the presence at sites.
However, this ideal is often difficult to achieve in practice.
For sites that want to support a uniform runtime environment, we provide a global filesystem called
[CVMFS](./worker-node/install-cvmfs.md) that VOs can use to distribute their own software dependencies.

Finally, many researchers use applications that require a specific OS environment - not just individual dependencies -
that is distributed as a container.
OSG supports the use of the [Singularity](http://singularity.lbl.gov/) container runtime with
[Docker-based](https://hub.docker.com) image distribution.

### Data Services

Whether accessed through CVMFS or command-line software like `curl`, the majority of software is moved via HTTP in
cache-friendly patterns.
All sites are highly encouraged to use an [HTTP proxy](./data/frontier-squid.md) to reduce the load on the WAN from the
cluster.

Depending on the VOs you want to support, additional data services may be necessary:

- Some VOs elect to stream their larger input data from offsite using OSG's "StashCache" service.
  This requires no services to be run by the site
- The largest sites will additionally run large-scale data services such as a "storage element".
  This is often required for sites that want to support more complex organizations such as ATLAS or CMS.

Site Policies
-------------

Sites are encouraged to clearly specify and communicate their local policies regarding resource access.
One common mechanism to do this is post them on a web page and make this page part of your
[site registration](https://github.com/opensciencegrid/topology/).
Written policies help external entities understand what your site wants to accomplish with the OSG -- and are often
internally clarifying.

In line of our principle of *sharing*, we encourage you to allow virtual organizations registered with the OSG
"opportunistic use" of your resources.
You may need to preempt those jobs when higher priority jobs come around.
The end-users using the OSG generally prefer having access to your site subject to preemption over having no access
at all.

Getting Help
------------

If you need help with planning your site, follow the [contact instructions](common/help.md).
