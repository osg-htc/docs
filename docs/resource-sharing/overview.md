
Compute Resource Sharing Overview
=================================

OSG uses a resource-overlay ("pilot") model to share resources:
compute resources are added to a large central resource pool through the use of a bootstrap process, often called a
_pilot_ or a _glidein_.
These pilots, in turn, download and execute user jobs (also known as "payloads") from the resource pool.

On OSG, there are several resource pools, one for each large community (such as ATLAS or CMS) and the special-purpose
_Open Science Pool_.
The latter focuses on aggregating resources together for small researcher-driven groups and is operated by the OSG
itself.

There are several ways pilots can join a resource pool:

* Submitted to a batch system through a [*compute entrypoint*](compute-element/htcondor-ce-overview).
  These jobs are submitted by an external entity, a *pilot factory* based on observed demand in the pool.
* Sites can launch [*pilot containers*](resource-sharing/os-backfill-containers.md) for a specific pool when they have
  resources they would like to contribute directly.
* Users can launch *personal pilot containers* within a site's batch system so they can use an existing share or
  allocation at a site through the open science pool.

The *compute entrypoint* is the most common way pilots are created as it is highly automated and responsive to existing
demand.
The site-launched *pilot container* method is useful for to backfill otherwise-idle resources;
however, at times these pilots may stay idle because there is insufficient demand within the resource pool.
