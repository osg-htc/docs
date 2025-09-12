title: HTCondor-CE Overview
DateReviewed: 2024-02-09

HTCondor-CE Overview
====================

This document serves as an introduction to HTCondor-CE and how it works.
Before continuing with the overview, make sure that you are familiar with the following concepts:

-   An OSG site plan
    -   What is a batch system and which one will you use ([HTCondor](http://htcondor.org/), PBS, LSF, SGE, or
        [Slurm](https://slurm.schedmd.com/))?
    -   Security via [host certificates](../security/host-certs/overview.md) to authenticate servers and
        [bearer tokens](../security/tokens/overview.md) to authenticate clients
-   Pilot jobs, frontends, and factories (i.e., [GlideinWMS](http://glideinwms.fnal.gov/doc.prd/index.html),
    Harvester)

What is a Compute Entrypoint?
--------------------------

An OSG Compute Entrypoint (CE) is the door for research organizations to submit requests to temporarily allocate local
compute capacity.
At the heart of the CE is the software that is responsible for handling incoming allocation requests, authenticating and
authorizing them, and delegating them to your batch system for execution as jobs.

Capacity allocation requests that arrive at a CE are **not** end-user jobs, but rather pilot jobs that are submitted
from pilot factories.
Successful pilot jobs create an environment for actual research user jobs to match and ultimately run under the pilot job.
Eventually pilot jobs remove themselves, typically after a period of inactivity.

What is HTCondor-CE?
--------------------

HTCondor-CE is a special configuration of the HTCondor software designed to be a compute entrypoint solution for the OSG
Fabric of Services.
It is configured to use the [JobRouter daemon](https://htcondor.readthedocs.io/en/latest/grid-computing/job-router.html) to
delegate pilot jobs by transforming and submitting them to the site’s batch system.

Benefits of running the HTCondor-CE:

-   **Scalability:** HTCondor-CE is capable of supporting pilot job workloads of large sites
-   **Debugging tools:** HTCondor-CE offers [many tools to help troubleshoot](troubleshoot-htcondor-ce.md)
    issues with pilot jobs
-   **Routing as configuration:** HTCondor-CE’s mechanism to transform and submit pilot jobs is customized via
    configuration variables, which means that customizations will persist across upgrades and will not involve
    modification of software internals to route jobs

See the [upstream documentation](https://htcondor.com/htcondor-ce/architecture/) for details about the architecture of
HTCondor-CE.

Next steps
----------

If you are already running a local batch system and are interested in contributing computational capacity to the OSG
Consortium, deploy an OSG CE through one of the following methods:

-   [Request an OSG-Hosted CE](hosted-ce.md)
-   [Install an HTCondor-CE](install-htcondor-ce.md)

If you do not already have a batch system installed,
consider contributing through an [Open Science Pool EP container](../resource-sharing/os-backfill-containers.md).
