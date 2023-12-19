DateReviewed: 2021-11-12
title: Installing an Open Science Pool Access Point

Installing an Open Science Pool Access Point
============================================

This document explains how to add a path for user jobs to flow from your local site out to the Open Science Pool (OSPool),
which in most cases means that the jobs will have far more capacity available to run on than locally.
This is useful if:

- your local batch system frequently has many jobs waiting to run for a long time
- you do not have a local batch system
- you want to provide a local entry point for OSPool-bound jobs

Note that if you do not have a local batch system, consider having your users use
[OSG Connect](https://portal.osg-htc.org/documentation), which will require less
infrastructure work at your site.

!!!note
    Flocking to OSPool resources requires some modification to user workflows.
    After installation, see the [usage](#usage) section for instructions on what your users will need to do.


Background
----------
Every batch computing system has one or more entry points that users log on to and use to hand over their computing work
to the batch system for completion.
For the HTCondor batch system, we say that users log on to an Access Point (AP)
(also known as a submit node or submit host)
to submit their jobs to HTCondor, where the jobs wait ("are queued") until computing capacity is available to run them.
In a purely local HTCondor system, there are one to a few Access Points and many computing resources.

An HTCondor Access Point can also be configured to forward excess jobs to the Open Science Pool.
This process is called [flocking](https://htcondor.readthedocs.io/en/latest/grid-computing/connecting-pools-with-flocking.html).
If you already have an HTCondor pool, we recommend that you install this software
on top of one of your existing HTCondor Access Points.
This approach allows a user to submit locally and have their jobs run locally or,
if the user chooses and if local capacity is unavailable, have their jobs automatically flock to the OSPool.
If you do not have an HTCondor batch system, following these instructions will install the HTCondor submit service
and configure it only to forward jobs to the OSPool.
In other words, you do not need a whole HTCondor batch system just to have a local OSPool Access Point.


System Requirements
-------------------
The hardware requirement for an OSPool Access Pool depends on several factors such as number of users,
number of jobs and for example how I/O intensity of those jobs.
Our minimum recommended configuration is 6 cores, 12 GB RAM and 1 TB of local disk.
The hardware can be bare metal or virtual machine, but we do not recommend containers as these submit host are running
many system services which can be difficult to configure in a container.

Also consider the following configuration requirements:

* __Operating system:__ Ensure the host has [a supported operating system](../release/supported_platforms.md)
* __Software repositories:__ Install the appropriate [EPEL](../common/yum.md#install-the-epel-repositories) and
  [OSG](../common/yum.md#install-the-osg-repositories) Yum repositories for your operating system
* __User IDs:__ If it does not exist already, the installation will create the Linux user ID `condor`.
* __Network:__ 
    * Inbound TCP port 9618 must be open.
    * The access point must have a public IP address with both forward and reverse DNS configured.


Scheduling a Planning Consultation
----------------------------------

Before participating in the OSPool, either as a computational capacity contributor or consumer,
we ask that you [contact us](mailto:help@osg-htc.org) to set up a consultation.
During this consultation, OSG staff will introduce you and your team to the OSG and develop a plan to meet your capacity
contribution and/or research goals.


Initial Steps
-------------

### Read the Acceptable Usage Policy
Be aware that hosting an access point comes with responsibilities, both for the administrators as
well as end users of the system. The polices can be found in the [Acceptable Usage Policy document](ap-ospool-aup.md).

### Register your Access Point in OSG Topology
To be part of the OSPool, your AP must be registered in the OSG Topology system.
You will need information like the hostname, and the administrative and security contacts.
Follow the [general registration instructions](../common/registration.md#new-resources).
For historical reasons, the service type is `Submit Node`. We also request that you tag
the resources with `OSPool`. An example of a registration is
[the osg-vo.isi.edu entry](https://github.com/opensciencegrid/topology/blob/7a71dd4731bb5259f5d9d4004b2df1ddb2bd22ce/topology/University%20of%20Southern%20California/Information%20Sciences%20Institute/ISI.yaml#L32-L57)

### Register with COManage 
The adminstrative contact from the the Topology entry needs to register with COManage. 
Instructions can be found [here](https://osg-htc.org/technology/policy/comanage-instructions-user/)

Next is to retrive a token so that the new Access Point can authenticate with the OSPool manager.
You will need a host with Docker to run the software used for retrieving the token.
Please use your COManage registered and approved identity to log into the
[OSG Token Registration](https://os-registry.opensciencegrid.org/).
Follow the instructions on the website; in the list of hosts,
select the hostname of the Access Point that you registered earlier.

Save this token file; you will use it later when [configuring authentication](#configuring-authentication).

Installing Required Software
----------------------------
Flocking requires HTCondor software as well as software for reporting to the OSG accounting system.
Start by setting up the EPEL and OSG YUM repositories following the
[Installing Yum Repositories](../common/yum.md) document.

Once the Yum repositories are setup, install the `osg-flock` convenience RPM that installs all
required packages. Example on a RHEL 9 host:

```console
# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
# yum install https://repo.opensciencegrid.org/osg/23/osg-23-el9-release-latest.rpm
# yum install osg-flock
```

### Upgrading from OSG 3.5 or earlier

The Access Point must be running a supported version of the OSG Software Stack;
the currently supported versions as of December 2023 are OSG 23 and OSG 3.6.
If you are running an earlier version, you should upgrade to the most recent version
of the OSG Software Stack that your operating system supports.
OSG 23 supports RHEL 8- and 9-compatible operating systems.
OSG 3.6 supports RHEL 7-, 8-, and 9-compatible operating systems.

See the instructions for upgrading to the appropriate series:

- [Upgrading to the OSG 23 series](https://osg-htc.org/docs/release/updating-to-osg-23/)
- [Upgrading to the OSG 3.6 series](https://osg-htc.org/docs/release/updating-to-osg-36/)

If you made local config changes, please verify that the files under
`/etc/condor/config.d` were renamed/disabled during the upgrade.

Note that in some older versions of the package, the Gratia config was kept in 
`/etc/gratia/condor/ProbeConfig`. The new location is `/etc/gratia/condor-ap/ProbeConfig`.

The Open Science Pool does not accept GSI authentication.
If your Access Point was configured with GSI authentication,
you will need to switch to token authentication after upgrading, as described in this document.

Configuring Reporting via Gratia
--------------------------------

Reporting to the OSG accounting system is done using the _Gratia_ service, which consists of _probes_.
HTCondor uses the "condor-ap" probe, which is configured in `/etc/gratia/condor-ap/ProbeConfig`:
see [this section](../other/troubleshooting-gratia.md#access-points_1) for more details.


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
### Running jobs in the OSPool
If your users are accustomed to running jobs locally, they may encounter some significant differences when running jobs in the OSPool.
Users should be aware that OSPool jobs are distributed across multiple institutions across a large geographical area.
Each institution will have its own policy about the kinds of jobs that are allowed to run,
and data transfer may be more complicated.
The [OSG Helpdesk Solutions](https://portal.osg-htc.org/documentation) page has information about
what users should know;
the [Organizing and Submitting HTC Workloads Tutorial](https://portal.osg-htc.org/documentation/htc_workloads/submitting_workloads/tutorial-organizing/) and
<!---
[Data Management Guide](https://portal.osg-htc.org/documentation/htc_workloads/managing_data/osgconnect-storage/)
--->
[Policies for Using OSG Services and the OSPool](https://portal.osg-htc.org/documentation/overview/references/policy/)
are particularly relevant.

### Specifying a project
OSPool resources will only run jobs that have a registered *project* associated with them.
Users must follow the
[instructions for starting a project in OSG-Connect](https://portal.osg-htc.org/documentation/overview/account_setup/starting-project/)
to register a project.

A project is associated with a job by adding a `+ProjectName` line to the user's submit file.
For example:

```file
+ProjectName = "My_Project"
```

__The `+` and the double quotes are necessary__.
Otherwise, the job will fail to submit or it will not run in the OSPool.


Get Help
--------
If you need help with setup or troubleshooting, see our [help procedure](../common/help.md).
