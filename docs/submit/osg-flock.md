DateReviewed: 2021-03-26

Installing an Open Science Pool Access Point
============================================

This document explains how to add a path for user jobs to flow from your local site out to the OSG,
which in most cases means that the jobs will have far more resources available to run on than locally.
If your local batch system frequently has many jobs waiting to run for a long time,
you do not have a local batch system,
or if you simply want to provide a local entry point for OSG-bound jobs,
adding a path to OSG may result in less waiting for your users.

Note that if you do not have a local batch system, consider having your users use
[OSG Connect](https://support.opensciencegrid.org/support/solutions), which will require less
infrastructure work at your site.

!!!note
    Flocking to the OSG requires some modification to user workflows.
    After installation, see the [usage](#usage) section for instructions on what your users will need to do.


Background
----------
Every batch computing system has one or more entry points that users log on to and use to hand over their computing work
to the batch system for completion.
For the HTCondor batch system, we say that users log on to a access point (i.e., submit node, submit host) to submit
their jobs to HTCondor, where the jobs wait ("are queued") until computing resources are available to run them.
In a purely local HTCondor system, there are one to a few access points and many computing resources.

An HTCondor access point can also be configured to forward excess jobs to an OSG-managed pool.
This process is called [flocking](https://htcondor.readthedocs.io/en/stable/grid-computing/connecting-pools-with-flocking.html).
If you already have an HTCondor pool, we recommend that you install this software
on top of one of your existing HTCondor access points.
This approach allows a user to submit locally and have their jobs run locally or,
if the user chooses and if local resources are unavailable, have their jobs automatically flock to OSG.
If you do not have an HTCondor batch system, following these instructions will install the HTCondor submit service
and configure it only to forward jobs to the OSG.
In other words, you do not need a whole HTCondor batch system just to have a local OSG access point.


System Requirements
-------------------
The hardware requirement for an OSG access point depends on several factors such as number of users, 
number of jobs and for example how I/O intensive those jobs are. Our minimum recommended configuration
is 6 cores, 12 GB RAM and 1 TB of local disk. The hardware can be bare metal or virtual machine, but
we do not recommend containers as these submit host are running a bunch of system services which can
be difficult to configure in a container.

Also consider the following configuration requirements:

* __Operating system:__ A RHEL 7 compatible operating system.
* __User IDs:__ If it does not exist already, the installation will create the Linux user ID `condor`.
* __Network:__ 
    * Inbound TCP port 9618 must be open.
    * The access point must have a public IP address with both forward and reverse DNS configured.


Scheduling a Planning Consultation
----------------------------------

Before participating in the OSG, either as a computational resource contributor or consumer,
we ask that you [contact us](mailto:help@opensciencegrid.org) to set up a consultation.
During this consultation, OSG staff will introduce you and your team to the OSG and develop a plan to meet your resource
contribution and/or research goals.


Initial Steps
-------------

### Register your access point in OSG Topology
To be part of OSG, your access point should be registered with the OSG.
You will need information like the hostname, and the administrative and security contacts.
Follow the [general registration instructions](../common/registration.md#new-resources).
For historical reasons, the service type is `Submit Node`.

### Request to be allowed to flock to OSG
OSG staff will need to add your access point to the list of hosts that flocked jobs are accepted from,
and provide a HTCondor IDTOKEN so that your new access point can authenticate with OSG.
Send email to <help@opensciencegrid.org> with the hostname of your access point and request to be added to the list.


Installing Required Software
----------------------------
Flocking requires HTCondor software as well as software for reporting to the OSG accounting system.
Start by setting up the OSG YUM repositories following the
[Installing Yum Repositories](../common/yum/). __Note that you have to use OSG 3.6__. Earlier
versions will not work.

Once the YUM repositories are setup, install the `osg-flock` convenience RPM that installs all
required packages:

```console
root@host # yum install osg-flock
```


Configuring Reporting via Gratia
--------------------------------
Reporting to the OSG accounting system is done using the _Gratia_ service, which consists of multiple _probes_.
HTCondor uses the "condor" probe, which is configured in `/etc/gratia/condor/ProbeConfig`;
we provide a recommended configuration for flocking.

1. Copy over the recommended probe configuration:

        :::console
        root@host # cp /etc/gratia/condor/ProbeConfig-flocking /etc/gratia/condor/ProbeConfig

1. Fill in the value for `ProbeName` with the hostname of your access point, with the following format:

        :::xml
        ProbeName="condor:<HOSTNAME>"
        
1. Fill in the value for `SiteName` with the Resource Name you registered in Topology (see
   [instructions above](#register-your-access-point-in-osg-topology)).
   For example:
   
        :::xml
        SiteName="OSG_US_EXAMPLE_SUBMIT"

1. Enable the Gratia Probe.

        :::xml
        EnableProbe=1

1. Under the section `Title2` make sure to set the following (if not already there):
  
        :::xml
        MapUnknownToGroup="1"
        MapGroupToRole="1"
        VOOverride="OSG"

Configuring Authentication
--------------------------
Create a file named `/etc/condor/tokens.d/flock.opensciencegrid.org` with the IDTOKEN you
received earlier. The token you only take up one line (that is, there should not be any
line breaks in the token).

Change the ownership to `condor:condor` and the permissions to `0600`. Verify this with
`ls -l /etc/condor/tokens.d/flock.opensciencegrid.org`:

```console
# ls -l /etc/condor/tokens.d/flock.opensciencegrid.org 
-rw------- 1 condor condor 288 Nov 11 09:03 /etc/condor/tokens.d/flock.opensciencegrid.org
```

Managing Services
-----------------
In addition to the HTCondor service itself, there are a number of supporting services in your installation. The specific services are:

| Software          | Service name                          | Notes                                                                                  |
|:------------------|:--------------------------------------|:---------------------------------------------------------------------------------------|
| Gratia            | `gratia-probes-cron`                  | Accounting software                                                                    |
| HTcondor          | `condor`                              |                                                                                        |

The following table gives the commands needed to start, stop, enable, and disable a service:

| To...                                       | Run the command...                 |
| :------------------------------------------ | :--------------------------------- |
| Start a service                             | `systemctl start <SERVICE-NAME>`   |
| Stop a service                              | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot           | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot     | `systemctl disable <SERVICE-NAME>` |


Usage
-----
### Running jobs in OSG
If your users are accustomed to running jobs locally, they may encounter some significant differences when running jobs in OSG.
Users should be aware that OSG jobs are distributed across multiple institutions across a large geographical area.
Each institution will have its own policy about the kinds of jobs that are allowed to run,
and data transfer may be more complicated.
The [OSG Helpdesk Solutions](https://support.opensciencegrid.org/support/solutions) page has information about
what users should know;
the [Choosing Resources for Jobs](https://support.opensciencegrid.org/support/solutions/folders/5000266057) and
[Data Management](https://support.opensciencegrid.org/support/solutions/folders/12000013267)
sections are particularly relevant.

### Specifying a project
OSG will only run jobs that have a registered *project* associated with them.
Users must follow the
[instructions for starting a project in OSG-Connect](https://support.opensciencegrid.org/support/solutions/articles/5000634360-start-or-join-a-project-in-osg-connect)
to register a project.

A project is associated with a job by adding a ProjectName line to the user's submit file.
For example:

```file
+ProjectName = "My_Project"
```
The double quotes are necessary.


Get Help
--------
If you need help with setup or troubleshooting, see our [help procedure](../common/help.md).
