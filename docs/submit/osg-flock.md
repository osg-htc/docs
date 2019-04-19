Configuring a submit host to flock to OSG
=========================================

If you have a HTCondor submit node on your campus, it can be configured
to spill over onto available resources on the Open Science Grid. In
HTCondor terms this is called [flocking](https://research.cs.wisc.edu/htcondor/manual/latest/ConnectingHTCondorPoolswithFlocking.html)

If you are interested in this solution, please open a
[new ticket](https://support.opensciencegrid.org/helpdesk/tickets/new) with the hostname.

Requirements
------------

The requirements are:

* A public IP address, forward and reverse DNS.
* Ability to open a few firewall incoming ports to the WAN.
* HTCondor has to authenticate via pool GSI (preffered) or password. For GSI, the submit host
   has to have a host certificate.
* Reporting to the OSG accounting system has to be enabled. This can
   be accomplished by installing and configuring the *gratia-probe-condor* and *gratia-probe-glideinwms* RPMs.
* Submitted jobs should have the *+ProjectName* attribute specified with
   a valid registered project name.


Required Packages
-----------------

Enable the [OSG Yum repository](/common/yum/).

Install the packages required:

```console
root@host # yum install osg-flock
```

Gratia Probe Configuration
--------------------------

1. Copy over the recommended probe configuration:

        :::console
        root@host # cp /etc/gratia/condor/Probeconfig-flocking /etc/gratia/condor/Probeconfig

1. Fill in the values for `ProbeName` and `SiteName` with the hostname and Topology resource name, respectively.
    For example:

        :::xml
        ProbeName="condor:foo.example.edu"
        SiteName="OSG_US_RESOURCE_SUBMIT"

Please remember to enable and start the probe:

```console
root@host # systemctl enable gratia-probes-cron
root@host # systemctl start gratia-probes-cron
```

GSI: Requesting a Host Certificate
---------------------------------

A host certificate is used for authenticating your submit host to the OSG
infrastructure. If you do not already have a certificate, you can request one
using [these instructions](/security/host-certs/)

*Optional* Pool Password: HTCondor Configuration
------------------------------------------------

This section is optional and should be only considered if the local admin cannot obtain
a host certificate for their submit host. To enable pool password authentication place a file here:
`/etc/condor/config.d/90-flock-pool-password.conf` with the following contents.


```file
   #-- Flock to the OSG using pool password
   SEC_PASSWORD_FILE = /etc/condor/pool_password
   SEC_DEFAULT_AUTHENTICATION_METHODS = FS,PASSWORD
```    



Project Names
-------------

OSG will only run jobs tagged with a valid *ProjectName* - this is the main attribute
used for accounting. Please open at ticket to register a new project.
Jobs should specify which project to be accounted against by adding
the *+ProjectName* attribute. Note that the value is a string and hence
the double quotes are required. For example:

```file
+ProjectName = "Some_Name_Here"
```

Get Help
---------------

If you need help with setup or troubleshooting, see our [help procedure](/common/help).