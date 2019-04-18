Configuring a submit host to flock to OSG
=========================================

Overview
--------

If you have a HTCondor submit node on your campus, it can be configured
to spill over onto available resources on the Open Science Grid. In
HTCondor terms this is called [flocking](https://research.cs.wisc.edu/htcondor/manual/latest/ConnectingHTCondorPoolswithFlocking.html)

If you are interested in this solution, please open a
[new ticket](https://support.opensciencegrid.org/helpdesk/tickets/new) with the hostname.

Requirements
------------

The requirements are:

* A public IP address, forward and reverse DNS
* Ability to open a few firewall ports to the WAN.
* HTCondor has to authenticate via pool GSI (preffered) or password. For GSI, the submit host
   has to have a host certificate.
* Reporting to the OSG accounting system has to be enabled. This can
   be accomplished by installing and configuring the *gratia-probe-condor* and *gratia-probe-glideinwms* RPMs.
* Submitted jobs should have the *+ProjectName* attribute specified with
   a valid registered project name.


Required Packages
----------------

Enable the [OSG Yum repository](http://opensciencegrid.github.io/docs/common/yum/).

Install the packages required:

```console
root@host # yum install osg-flock
```
