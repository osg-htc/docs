Site Maintenance
================

This document outlines how to maintain your OSG site, including steps to take if you suspect that OSG jobs are causing
issues.

Handle Misbehaving Jobs
-----------------------

In rare instances, you may experience issues at your site caused by misbehaving jobs (e.g., over-utilization of memory)
from an OSG community or Virtual Organization (VO).
If this occurs, you should immediately stop accepting job submissions from the OSG and remove the offending jobs:

1.  Configure your batch system to stop accepting jobs from the VO:

    -   **For HTCondor batch systems,** set the following on your HTCondor-CE or Access Point accepting jobs from an OSG
        Hosted CE:

            SUBMIT_REQUIREMENT_Ban_OSG = (Owner != "<OFFENDING VO USER>")
            SUBMIT_REQUIREMENT_Ban_OSG_REASON = "OSG pilot job submission temporarily disabled"
            SUBMIT_REQUIREMENT_NAMES = $(SUBMIT_REQUIREMENT_NAMES) Ban_OSG

        Replacing `<OFFENDING VO USER>` with the name of the local Unix account corresponding to the problematic VO.

    -   **For Slurm batch systems,**
        disable the relevant [Slurm partition](https://slurm.schedmd.com/faq.html#stop_sched)

1.  Remove the VO's jobs:

    -   **For HTCondor batch systems,** run the following command on your HTCondor-CE or Access Point accepting jobs
        from an OSG Hosted CE:

            :::console
            [root@access-point] # condor_rm <OFFENDING VO USER>

        Replacing `<OFFENDING VO USER>` with the name of the local Unix account corresponding to the problematic VO.

    -   **For Slurm batch systems,** run the following command:

            :::console
            [root@host] # scancel -u <OFFENDING VO USER>

        Replacing `<OFFENDING VO USER>` with the name of the local Unix account corresponding to the problematic VO.

1.  [Let us know](#help) so that we can track down the offending software or user:
    the same issue that you're experiencing may also be affecting other sites!

Keep OSG Software Updated
-------------------------

It is important to keep your software and data (e.g., CAs and VO client) up-to-date with the latest OSG release.
See the release notes for your installed release series:

-  [OSG 3.5 release notes](release/notes.md)
-  [OSG 3.6 release notes](release/osg-36.md)

To stay abreast of software releases, we recommend subscribing to the <mailto:osg-sites@opensciencegrid.org> mailing
list.

Notify OSG of Major Changes
---------------------------

To avoid potential issues with OSG job submissions, please [notify us](mailto:help@opensciencegrid.org) of major changes
to your site, including:

- Major OS version changes on the worker nodes (e.g., upgraded from EL 7 to EL 8)
- Adding or removing [container support through Singularity](worker-node/install-singularity.md)
- Policy changes regarding OSG resource requests (e.g., number of cores or GPUs, memory usage, or maximum walltime)
- Scheduled or unscheduled [downtimes](common/registration.md#registering-resource-downtimes)
- [Site topology changes](common/registration.md) such as additions, modifications, or retirements of OSG services
- Changes to site contacts, such as administrative or security staff

Help
----

If you need help with your site, or need to report a security incident,
follow the [contact instructions](common/help.md).
