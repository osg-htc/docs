Configure an HTCondor submit host to send excess jobs to OSG
============================================================

This document explains how to add a path for user jobs to flow from your local site out to the OSG,
which in most cases means that the jobs will have far more resources available to run on than locally.
If your local batch system frequently has many jobs waiting to run for a long time,
adding a path to OSG may result in less waiting for your users.

Background
----------
Every batch computing system has one or more entry points that users log on to and use to hand over their computing work
to the batch system for completion.
For the HTCondor batch system, we say that users log on to a submit host to submit their jobs to HTCondor,
where they wait ("are queued") until computing resources are available to run them.
In a purely local HTCondor system, there are one to a few submit hosts and many computing resources.

An HTCondor submit host can also be configured to forward jobs to an OSG-managed submit host.
This process is called [flocking](https://htcondor.readthedocs.io/en/stable/grid-computing/connecting-pools-with-flocking.html).
If you already have an HTCondor pool, we recommend that you install this software
on top of one of your existing HTCondor submit hosts.
This will let your users submit to the local pool and have the jobs
automatically get forwarded to OSG when the local pool is full.
If you do not have an HTCondor batch system, installing this software will give you a submit host
that will only forward jobs.

!!!note
    Flocking to the OSG requires some modification to user workflows.
    See the [usage](#usage) section after installation for instructions on what your users will need to do.


Before Starting
---------------
Before starting the installation process, consider the following requirements:

* __Operating system:__ A RHEL 6 or 7 compatible operating system.
* __User IDs:__ If they do not exist already, the installation will create the Linux user ID `condor`.
* __Host certificate:__ Recommended for authentication to OSG infrastructure.
  See our [documentation](/security/host-certs.md) for instructions on how to request and install host certificates.
* __Network:__ 
    * Inbound TCP port 9618 must be open.
    * The submit host must have a public IP address with both forward and reverse DNS configured.

As with all OSG software installations, there are some one-time steps to prepare in advance:

* Obtain root access to the host
* Prepare [the required Yum repositories](/common/yum.md)
* Install [CA certificates](/common/ca.md)


Initial Steps
-------------

### Register your submit host in OSG Topology
To be part of OSG, your submit host should be registered with the OSG.
You will need information like the hostname, and the administrative and security contacts.
Follow the [general registration instructions](/docs/common/registration#new-resources).
The service type is `Submit Node`.


### Choose your authentication method
There are two options for authentication of your submit host to the OSG: GSI and pool password.
Of these, GSI is the recommended method, but it will require obtaining a host certificate for your submit host.
See our [documentation](/security/host-certs.md) for instructions on how to request and install host certificates.

If you are unable to obtain a host certificate, use the "pool password" authentication method, described below.


### Request to be allowed to flock to OSG
OSG staff will need to add your submit host to the list of hosts that flocked jobs are accepted from.
Send email to <help@opensciencegrid.org> with the hostname of your submit host and request to be added to the list.


Installing Required Software
----------------------------
Flocking requires HTCondor software as well as software for reporting to the OSG accounting system.
OSG provides a convenience RPM that installs all required packages.
To install, run:

```console
root@host # yum install osg-flock
```


Configuring Reporting via Gratia
--------------------------------
Reporting to the OSG accounting system is done using the _Gratia_ service, which consists of multiple _probes_.
HTCondor uses the "condor" probe, which is configured in `/etc/gratia/condor/ProbeConfig`;
we provide a recommended config for flocking.

1. Copy over the recommended probe configuration:

        :::console
        root@host # cp /etc/gratia/condor/ProbeConfig-flocking /etc/gratia/condor/ProbeConfig

1. Fill in the value for `ProbeName` with the hostname of your submit host.
   For example:

        :::xml
        ProbeName="condor:foo.example.edu"
        
1. Fill in the value for `SiteName` with the Resource Name you registered in Topology (see instructions above).
   For example:
   
        :::xml
        SiteName="OSG_US_EXAMPLE_SUBMIT"


Configuring Authentication
--------------------------
If you have obtained a host certificate according to the [instructions](/security/host-certs.md),
you do not need to do any additional configuration and may skip the rest of this section.

If you cannot obtain a host certificate, then configure pool password authentication via the following instructions:

1. Send email to <help@opensciencegrid.org> requesting the pool password file for flocking.

1. Place the pool password file in `/etc/condor/pool_password`.

1. Create a configration file named `/etc/condor/config.d/90-flock-pool-password.conf` with the following contents:

        :::ini
        #-- Flock to OSG using pool password
        SEC_PASSWORD_FILE = /etc/condor/pool_password
        SEC_DEFAULT_AUTHENTICATION_METHODS = FS,PASSWORD


Managing Services
-----------------
You will need the following services enabled and running:
* gratia-probes-cron
* condor

The following table gives the commands needed to start, stop, enable, and disable a service:

To...                                       | On EL6, run the command...              | On EL7, run the command...         |
:------------------------------------------ | :-------------------------------------- | :--------------------------------- |
| Start a service                           | `service <SERVICE-NAME> start`          | `systemctl start <SERVICE-NAME>`   |
| Stop a service                            | `service <SERVICE-NAME> stop`           | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot         | `chkconfig <SERVICE-NAME> on`           | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot   | `chkconfig <SERVICE-NAME> off`          | `systemctl disable <SERVICE-NAME>` |


Usage
-----
### Running jobs in OSG
Users should be aware that OSG jobs are distributed across multiple institutions across a large geographical area.
Each institution will have its own policy about the kinds of jobs that are allowed to run,
and data transfer may be more complicated.
The [OSG Helpdesk Solutions](https://support.opensciencegrid.org/support/solutions) page has information about
what users should know; the "Choosing Resources for Jobs" and "Data Management" sections should be particularly
relevant.

### Specifying a project
OSG will only run jobs that have a registered *project* associated with them.
A project is associated with a job by adding a ProjectName line to the submit file.
For example:

```file
+ProjectName = "My_Project"
```
The double quotes are necessary.

In addition, the project must be registered in OSG Topology.
To register a project, the user should email <help@opensciencegrid.org> with the following information:

- Name
- Email Address
- Project Name
- Field of Science
- PI Name
- PI Email
- PI Organization
- PI Department
- Project Contact Name
- Project Contact Email
- Project Contact Telephone Number
- Project Description

<!-- ^ C&Ped from https://support.opensciencegrid.org/support/solutions/articles/5000634360-start-or-join-a-project-in-osg-connect -->

Get Help
---------------

If you need help with setup or troubleshooting, see our [help procedure](/common/help).
