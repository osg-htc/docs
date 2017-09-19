Installing and Using the Worker Node Client from Tarballs
=========================================================

Introduction
------------

This document is intended to guide users through the process of installing the worker node software and configuring the installed worker node software. Contents of the worker node client can be found [here](install-wn.md#worker-node-contents).  Although this document is oriented to system administrators, any unprivileged user may install and use the client.

If you are installing the OSG worker node client following these instruction, remember to configure the `grid_dir` option on your CE - see [below](#configure-the-ce).

About This Guide
----------------

The *OSG Worker Node Client* is a collection of software components that is expected to be added to every worker node that can run OSG jobs. It provides a common environment and a minimal set of common tools that all OSG jobs can expect to use.

It is possible to install the Worker Node Client software in a variety of ways, depending on what works best for distributing and managing software at your site:  This guide is useful when installing onto a shared filesystem for distribution to worker nodes.  Other options include installing [via RPMs](install-wn.md) or providing the client [via OASIS (CVMFS)](install-wn-oasis).

Before starting, ensure the host has [a supported operating system](../release/supported_platforms.md).

Download, Installation and Configuration
----------------------------------------

### Download the WN Client

Please pick the `osg-wn-client` tarball that is appropriate for your distribution and architecture. You will find them in <https://repo.grid.iu.edu/tarball-install/> .

The latest available the tarballs for OSG 3.3 are:

-   [Binaries for 32-bit RHEL6](https://repo.grid.iu.edu/tarball-install/3.3/osg-wn-client-latest.el6.i386.tar.gz)
-   [Binaries for 64-bit RHEL6](https://repo.grid.iu.edu/tarball-install/3.3/osg-wn-client-latest.el6.x86_64.tar.gz)
-   [Binaries for RHEL7](https://repo.grid.iu.edu/tarball-install/3.3/osg-wn-client-latest.el7.x86_64.tar.gz)

For OSG 3.4:

-   [Binaries for 64-bit RHEL6](https://repo.grid.iu.edu/tarball-install/3.4/osg-wn-client-latest.el6.x86_64.tar.gz)
-   [Binaries for RHEL7](https://repo.grid.iu.edu/tarball-install/3.4/osg-wn-client-latest.el7.x86_64.tar.gz)

### Install the WN Client

1.  Unpack the tarball.
2.  Move the directory that was created to where you want the tarball client to be.
3.  Run `osg-post-install` (**`<PATH_TO_CLIENT>/osg/osg-post-install`**) to fix the directories in the installation.
4.  Source the setup **`source <PATH_TO_CLIENT>/setup.sh`** (or **`setup.csh`** depending on the shell).
5.  Download and set up CA certificiates using **`osg-ca-manage`** (See the [CA management documentation](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/OsgCaManage) for the available options).
6.  Download CRLs using **`fetch-crl`**.

!!! warning
    Once `osg-post-install` is run to relocate the install, it cannot be run again.  You will need to unpack a fresh copy.

Example installation (in `/home/user/test-install`, the **`<PATH_TO_CLIENT>/`** is `/home/user/test-install/osg-wn-client` ):

```console
[root@client ~] # mkdir /home/user/test-install
[root@client ~] # cd /home/user/test-install
[root@client ~] # wget http://repo.grid.iu.edu/tarball-install/3.4/osg-wn-client-latest.el6.x86_64.tar.gz
[root@client ~] # tar xzf osg-wn-client-latest.el6.x86_64.tar.gz
[root@client ~] # cd osg-wn-client
[root@client ~] # ./osg/osg-post-install
[root@client ~] # source setup.sh
[root@client ~] # osg-ca-manage setupCA --url osg
[root@client ~] # fetch-crl
```

#### Configure the CE

Using the wn-client software installed from the tarball will require a few changes on the compute element so that the resource's configuration can be correctly reported.

Set `grid_dir` in the `Storage` section of your OSG-Configure configs: [CE configuration instructions](../other/configuration-with-osg-configure#storage). `grid_dir` is used as the `$OSG_GRID` environment variable in running jobs - see [the environment variables document](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/EnvironmentVariables). Pilot jobs source `$OSG_GRID/setup.sh` before performing any work. The value set for `grid_dir` must be the path of the wn-client installation directory. This is the path returned by **`echo $OSG_LOCATION`** once you source the setup file created by this installation.

Services
--------

The WN client is a collection of client programs that do not require service startup or shutdown. The only services are `osg-update-certs` that keeps the CA certificates up-to-date and `fetch-crl` that keeps the CRLs up-to-date. Following the instructions below you'll add the services to your crontab that will take care to run them periodically until you remove them.

### Auto-updating certificates and CRLs

You must create cron jobs to run `fetch-crl` and `osg-update-certs` to update your CRLs and certificates automatically.

Here is what they should look like. (Note: fill in `<OSG_LOCATION>` with the full path of your tarball install, including `osg-wn-client` that is created by the tarball).

```text
# Cron job to update certs.
# Runs every hour by default, though does not update certs until they're at
# least 24 hours old.  There is a random sleep time for up to 45 minutes (2700
# seconds) to avoid overloading cert servers.
10 * * * *   ( . <OSG_LOCATION>/setup.sh && osg-update-certs --random-sleep 2700 --called-from-cron )
```

```text
# Cron job to update CRLs
# Runs every 6 hours at, 45 minutes +/- 3 minutes.
42 */6 * * *   ( . <OSG_LOCATION>/setup.sh && fetch-crl -q -r 360 )
```

You might want to configure proxy settings in `$OSG_LOCATION/etc/fetch-crl.conf`.

### Starting and Enabling Services

To start the services you must edit your cron with **`crontab -e`** and add the lines above.

### Stopping and Disabling Services

To stop the services you must edit your cron with **`crontab -e`** and remove or comment the lines above.

Validing the Worker Node Client
-------------------------------

To verify functionality of the worker node client, you will need to submit a test job against your CE and verify the job's output.

1.  Submit a job that executes the `env` command (e.g. Run [`condor_ce_trace`](troubleshoot-htcondor-ce#condor95ce95trace) with the `-d` flag from your HTCondor CE)
2.  Verify that the value of `$OSG_GRID` is set to the directory of your worker node client installation

How to get Help?
----------------

To get assistance please use this [Help Procedure](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/HelpProcedure).
