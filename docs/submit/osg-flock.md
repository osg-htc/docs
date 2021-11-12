DateReviewed: 2021-11-12

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
This process is called [flocking](https://htcondor.readthedocs.io/en/latest/grid-computing/connecting-pools-with-flocking.html).
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
number of jobs and for example how I/O intensity of those jobs.
Our minimum recommended configuration is 6 cores, 12 GB RAM and 1 TB of local disk.
The hardware can be bare metal or virtual machine, but we do not recommend containers as these submit host are running
many system services which can be difficult to configure in a container.

Also consider the following configuration requirements:

* __Operating system:__ A RHEL 7 or RHEL 8 compatible operating system.
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

### Read the Acceptable Usage Policy
Be aware that hosting an access point comes with responsibilities, both for the administrators as
well as end users of the system. The polices can be found in the [Acceptable Usage Policy document](ap-ospool-aup.md).

### Register your access point in OSG Topology
To be part of OSG, your access point should be registered with the OSG.
You will need information like the hostname, and the administrative and security contacts.
Follow the [general registration instructions](../common/registration.md#new-resources).
For historical reasons, the service type is `Submit Node`. We also request that you tag
the resources with `OSPool`. An example of a registration is
[the osg-vo.isi.edu entry](https://github.com/opensciencegrid/topology/blob/7a71dd4731bb5259f5d9d4004b2df1ddb2bd22ce/topology/University%20of%20Southern%20California/Information%20Sciences%20Institute/ISI.yaml#L32-L57)

### Register with COManage 
The adminstrative contact from the the topology entry needs to register with COManage. 
Instructions can be found [here](https://opensciencegrid.org/technology/policy/comanage-instructions-user/)

Next is to retrive a token so that the new submit host can authenticate with the Open
Science Pool manager. Please use your COManage registered and approved identity to
log into the [OSG Token Registration](https://os-registry.opensciencegrid.org/). Once
logged in, select `Token on Docker`, and find your registered submit node in the list.
Follow the instructions (you probably have to do the steps on a host with Docker and as
root), and once you have the token generated, keep that for later steps.


Installing Required Software
----------------------------
Flocking requires HTCondor software as well as software for reporting to the OSG accounting system.
Start by setting up the OSG YUM repositories following the
[Installing Yum Repositories](../common/yum.md). __Note that you have to use OSG 3.6__. Earlier
versions will not work.

Once the YUM repositories are setup, install the `osg-flock` convenience RPM that installs all
required packages. Example on a RHEL 7 host:

```console
# yum install https://repo.opensciencegrid.org/osg/3.6/osg-3.6-el7-release-latest.rpm
# yum install osg-flock
```

### Upgrading

Upgrading from previous versions should be as simple as switching to OSG 3.6, and then
issuing `yum upgrade`. If you made local config changes, please verify that the files under
`/etc/condor/config.d` were renamed/disabled during the upgrade.

Note that in some older versions of the package, the Gratia config was kept in 
`/etc/gratia/condor/ProbeConfig`. The new location is `/etc/gratia/condor-ap/ProbeConfig`.

The Open Science Pool will no longer accept GSI authentcation. Access points still configured
with GSI, will have to be upgraded to OSG 3.6 and switched over to token authentication as
described in this document.

Configuring Reporting via Gratia
--------------------------------
Reporting to the OSG accounting system is done using the _Gratia_ service, which consists of multiple _probes_.
HTCondor uses the "condor" probe, which is configured in `/etc/gratia/condor-ap/ProbeConfig`;
we provide a recommended configuration for flocking.

1. Fill in the value for `SiteName` with the Resource Name you registered in Topology (see
   [instructions above](#register-your-access-point-in-osg-topology)).
   For example:
   
        :::xml
        SiteName="OSG_US_EXAMPLE_SUBMIT"

1. Enable the Gratia Probe:

        :::xml
        EnableProbe=1


Configuring Authentication
--------------------------
Create a file named `/etc/condor/tokens.d/ospool.token` with the IDTOKEN you received earlier.
Ensure that there aren't any line breaks in this file (i.e., the entire token should only take up one line).

Change the ownership to `condor:condor` and the permissions to `0600`. Verify this with
`ls -l /etc/condor/tokens.d/ospool.token`:

```console
# ls -l /etc/condor/tokens.d/ospool.token
-rw------- 1 condor condor 288 Nov 11 09:03 /etc/condor/tokens.d/ospool.token
```

You can also list the token with the `condor_token_list` command:

```console
# condor_token_list 
Header: {"alg":"HS256","kid":"POOL"} Payload: {"iat":1234,"iss":"flock.opensciencegrid.org","jti":"...","scope":"condor:\/READ condor:\/ADVERTISE_SCHEDD","sub":"RESOURCE-hostname@flock.opensciencegrid.org"} File: /etc/condor/tokens.d/ospool.token
```

Managing Services
-----------------
The only service which is required to be running is `condor`. Enable and restart the sevice:

```console
# systemctl enable condor
# systemctl restart condor
```

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

__The double quotes are necessary__. If not quoted, *My_Project* will be interpreted as an expression,
and most likely evaluate to undefined, and prevent your job from running.


Get Help
--------
If you need help with setup or troubleshooting, see our [help procedure](../common/help.md).
