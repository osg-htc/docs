Configuring an HTCondor Submit Host to Send Jobs to the OSG
===========================================================

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
For the HTCondor batch system, we say that users log on to a submit host to submit their jobs to HTCondor,
where the jobs wait ("are queued") until computing resources are available to run them.
In a purely local HTCondor system, there are one to a few submit hosts and many computing resources.

An HTCondor submit host can also be configured to forward excess jobs to an OSG-managed submit host.
This process is called [flocking](https://htcondor.readthedocs.io/en/stable/grid-computing/connecting-pools-with-flocking.html).
If you already have an HTCondor pool, we recommend that you install this software
on top of one of your existing HTCondor submit hosts.
This approach allows a user to submit locally and have their jobs run locally or,
if the user chooses and if local resources are unavailable, have their jobs automatically flock to OSG.
If you do not have an HTCondor batch system, following these instructions will install the HTCondor submit service
and configure it only to forward jobs to the OSG.
In other words, you do not need a whole HTCondor batch system just to have a local OSG submit host.


Before Starting
---------------
Because jobs running in OSG run in a completely different environment than your local cluster,
and require additional considerations for data movement,
you or your campus will need to provide additional support for your users to enable them to
properly use OSG.
Send email to <help@opensciencegrid.org> saying that you would like to flock jobs to OSG,
and we will consult with you about the proper solution for your site and what needs to be set up
at both the OSG and at your site.

Also consider the following technical requirements:

* __Operating system:__ A RHEL 6 or 7 compatible operating system.
* __User IDs:__ If it does not exist already, the installation will create the Linux user ID `condor`.
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
Follow the [general registration instructions](/common/registration#new-resources).
The service type is `Submit Node`.


### Choose your authentication method
There are two options for authentication of your submit host to the OSG: GSI and pool password.
Of these, GSI is the recommended method, but it will require obtaining a host certificate for your submit host.
See our [documentation](/security/host-certs.md) for instructions on how to request and install host certificates.

If you are unable to obtain a host certificate, use the "pool password" authentication method,
[described in the Configuring Authentication section](#configuring-authentication).


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
we provide a recommended configuration for flocking.

1. Copy over the recommended probe configuration:

        :::console
        root@host # cp /etc/gratia/condor/ProbeConfig-flocking /etc/gratia/condor/ProbeConfig

1. Fill in the value for `ProbeName` with the hostname of your submit host, with the following format:

        :::xml
        ProbeName="condor:<HOSTNAME>"
        
1. Fill in the value for `SiteName` with the Resource Name you registered in Topology (see
   [instructions above](#register-your-submit-host-in-osg-topology)).
   For example:
   
        :::xml
        SiteName="OSG_US_EXAMPLE_SUBMIT"


Configuring Authentication
--------------------------
If you have obtained a host certificate according to the [instructions](/security/host-certs.md),
you do not need to do any additional configuration and may [continue to the next section](#managing-services).

If you cannot obtain a host certificate, then configure pool password authentication via the following instructions:

1. Send email to <help@opensciencegrid.org> requesting the pool password file for flocking.

1. Move the pool password file you have received to `/etc/condor/pool_password`;
   set the ownership of that file to `condor:condor` and the permissions to `0600`.

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
* fetch-crl-cron
* fetch-crl-boot

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
If your users are accustomed to running jobs locally, they may encounter some significant differences when running jobs in OSG.
Users should be aware that OSG jobs are distributed across multiple institutions across a large geographical area.
Each institution will have its own policy about the kinds of jobs that are allowed to run,
and data transfer may be more complicated.
The [OSG Helpdesk Solutions](https://support.opensciencegrid.org/support/solutions) page has information about
what users should know; the "Choosing Resources for Jobs" and "Data Management" sections are particularly relevant.

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
If you need help with setup or troubleshooting, see our [help procedure](/common/help).
