Installing and Using the Worker Node Client From RPMs
=====================================================

About This Guide
----------------

The **OSG Worker Node Client** is a collection of software components that is expected to be added to every worker node that can run OSG jobs. It provides a common environment and a minimal set of common tools that all OSG jobs can expect to use. See the [reference section](#reference) below for contents of the Worker Node Client.

It is possible to install the Worker Node Client software in a variety of ways, depending on what works best for distributing and managing software at your site:

-   Install using RPMs and `yum` (this guide) - useful when managing your worker nodes with a tool (e.g., Puppet, Chef) that can automate RPM installs
-   [Install using a tarball](InstallWNClientTarball) - useful when installing onto a shared filesystem for distribution to worker nodes
-   [Use from OASIS](UsingOSGWnClientFromOASIS) - useful when worker nodes already mount [OASIS](NavTechOASIS) on your worker nodes

This document is intended to guide system administrators through the process of configuring a site to make the Worker Node Client software available from an RPM.

Before Starting
---------------

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

-   Ensure the host has [a supported operating system](SupportedOperatingSystems)
-   Obtain root access to the host
-   Prepare [the required Yum repositories](YumRepositories)
-   Install [CA certificates](InstallCertAuth)

Install the Worker Node Client
------------------------------

Install the Worker Node Client RPM:

```
yum install osg-wn-client
```

Services
--------

Fetch-CRL is the only service required to support the WN Client.

| Software  | Service name                                          | Notes                                                                                  |
|:----------|:------------------------------------------------------|:---------------------------------------------------------------------------------------|
| Fetch CRL | On EL6 and EL7: `fetch-crl-boot` and `fetch-crl-cron` 
              On EL5: `fetch-crl3-boot` and `fetch-crl3-cron`       | See [CA documentation](InstallCertAuth#Start_Stop_fetch_crl_A_quick_gui) for more info |

!!! note
    `fetch-crl-boot` will begin fetching CRLS, which can take a few minutes
    and fail on transient errors. You can add configuration to ignore these
    transient errors in `/etc/fetch-crl.conf` for EL6 or EL7 machines or
    `/etc/fetch-crl3.conf` for EL5 machines:

    ```
    noerrors
    ```

As a reminder, here are common service commands (all run as `root`):

| To …                                        | Run the command …                     |
|:--------------------------------------------|:--------------------------------------|
| Start a service                             | `service <em>SERVICE-NAME</em> start` |
| Stop a service                              | `service <em>SERVICE-NAME</em> stop`  |
| Enable a service to start during boot       | `chkconfig <em>SERVICE-NAME</em> on`  |
| Disable a service from starting during boot | `chkconfig <em>SERVICE-NAME</em> off` |

Validing the Worker Node Client
-------------------------------

To verify functionality of the worker node client, you will need to submit a test job against your CE and verify the job’s output.

1.  Submit a job that executes the `env` command (e.g. Run [condor\_ce\_trace](TroubleshootingHTCondorCE#condor_ce_trace) with the `-d` flag from your HTCondor CE)
2.  Verify that the value of `OSG_GRID` is set to `/etc/osg/wn-client`

How to get Help?
----------------

To get assistance please use this [Help Procedure](HelpProcedure).

Reference
---------

Please see the documentation on using [yum and RPM](Documentation/Release3.YumRpmBasics), [the best practices](Documentation/Release3.InstallBestPractices) for using yum to install software, and using [yum repositories](Documentation/Release3.YumRepositories).

To see the currently installed version of the worker node package, run the following command:

```
rpm -q --requires osg-wn-client
```

See [our yum basics guide](YumRpmBasics#ListDeps) for more details on using RPM to see what was installed.

