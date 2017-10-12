Configuring a Site to Use the Worker Node Client Software From OASIS
====================================================================


About This Guide
----------------

The *OSG Worker Node Client* is a collection of software components that is expected to be added to every worker node that can run OSG jobs. It provides a common environment and a minimal set of common tools that all OSG jobs can expect to use.

It is possible to install the Worker Node Client software in a variety of ways, depending on what works best for distributing and managing software at your site:

-   Use the Worker Node Client software from OASIS (this guide) - useful when [CVMFS](install-cvmfs) is already mounted on your worker nodes
-   [Install using RPMs and Yum](install-wn.md) - useful when managing your worker nodes with a tool (e.g., Puppet, Chef) that can automate RPM installs
-   [Install using a tarball](install-wn-tarball.md) - useful when installing onto a shared filesystem for distribution to worker nodes

This document is intended to guide system administrators through the process of configuring a site to make the Worker Node Client software available from OASIS.

Before Starting
---------------

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

-   Ensure the host has [a supported operating system](../release/supported_platforms.md)

Also note that, once configured to use OASIS, each use of Worker Node Client software will cause that software and its associated files to be downloaded from a CVMFS server or your local cache thereof. This may result in extra network activity, especially if Worker Node Client tools are used heavily.

Configuring Your Site to Use the Worker Node Client From OASIS
--------------------------------------------------------------

Below are the one-time steps that you must perform to configure your site to use the Worker Node Client software from OASIS.

On every worker node, [install and configure CVMFS](install-cvmfs.md)

Determine the OASIS path to the Worker Node Client software for your worker nodes:

| Worker Node OS | Use…                                                                                 |
|:---------------|:-------------------------------------------------------------------------------------|
| EL 6 (32-bit)  | `/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el6-i386`   |
| EL 6 (64-bit)  | `/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el6-x86_64` |
| EL 7 (64-bit)  | `/cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el7-x86_64` |

On the CE, in the `/etc/osg/config.d/10-storage.ini` file, set the `grid_dir` configuration setting to the path from the previous step.

For more information, see the [OSG environment variables reference page](../worker-node/using-wn.md) and the [CE configuration instructions](../other/configuration-with-osg-configure#storage).

Once you finish making changes to configuration files on your CE, validate, fix, and apply the configuration:

```console
root@host # osg-configure -v
root@host # osg-configure -c
```

Validating the Worker Node Client
---------------------------------

To verify functionality of the worker node client, you will need to submit a test job against your CE and verify the job's output.

1.  Submit a job that executes the `env` command (e.g. Run [condor\_ce\_trace](../compute-element/troubleshoot-htcondor-ce#condor_ce_trace) with the `-d` flag from your HTCondor CE)
2.  Verify that the value of `OSG_GRID` is set to the directory of your WN Client installation

### Manually Using the Worker Node Client From OASIS

If you must log onto a worker node and use the Worker Node Client software directly during your login session, consult the following table for the command to set up your environment:

| Worker Node OS | Run the following command…                                                                           |
|:---------------|:-----------------------------------------------------------------------------------------------------|
| EL 6 (32-bit)  | `source /cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el6-i386/setup.sh`   |
| EL 6 (64-bit)  | `source /cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el6-x86_64/setup.sh` |
| EL 7 (64-bit)  | `source /cvmfs/oasis.opensciencegrid.org/osg-software/osg-wn-client/3.3/current/el7-x86_64/setup.sh` |

Troubleshooting
---------------

Some possible issues that may come up:

- A missing softlink to the CA certs directory. To check this, run:

        :::console
        user@host $ ls -l /cvmfs/oasis.opensciencegrid.org/mis/osg-wn-client/3.3/current/el6-x86_64/etc/grid-security/

    and check that `certificates` is linked to somewhere. The fix is to yum update the `oasis-config` package to version 4 or higher. A known workaround is to run:

        :::console
        user@host $ export X509_CERT_DIR=/cvmfs/oasis.opensciencegrid.org/mis/certificates

    before any commands.

How to get Help?
----------------

To get assistance please use this [Help Procedure](../common/help.md).
