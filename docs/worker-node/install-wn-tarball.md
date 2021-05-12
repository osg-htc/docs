Installing the Worker Node Client via Tarball
=============================================

The **OSG Worker Node Client** is a collection of software components that is expected to be added to every worker node
that can run OSG jobs. It provides a common environment and a minimal set of common tools that all OSG jobs can expect
to use. Contents of the worker node client can be found [here](install-wn.md#worker-node-contents).

!!! note
    It is possible to install the Worker Node Client software in a variety of ways, depending on your local site:

    -   Install using a tarball (this guide) - useful when installing onto a shared filesystem for distribution to worker nodes
    -   [Use from OASIS](install-wn-oasis.md) - useful when worker nodes already mount [CVMFS](install-cvmfs.md)
    -   [Install using RPMs and Yum](install-wn.md) - useful when managing your worker nodes with a tool (e.g., Puppet, Chef) that can automate RPM installs

This document is intended to guide users through the process of installing the worker node software and configuring the
installed worker node software.  Although this document is oriented to system administrators, any unprivileged user
may install and use the client.

Before starting, ensure the host has [a supported operating system](../release/supported_platforms.md).

Download the WN Client
----------------------

Please pick the `osg-wn-client` tarball that is appropriate for your distribution and architecture. You will find them in <https://repo.opensciencegrid.org/tarball-install/> .

For OSG 3.5:

-   [Binaries for RHEL7](https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz)
-   [Binaries for RHEL8](https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el8.x86_64.tar.gz)

Install the WN Client
---------------------

1.  Unpack the tarball.
2.  Move the directory that was created to where you want the tarball client to be.
3.  Run `osg-post-install` (**`<PATH_TO_CLIENT>/osg/osg-post-install`**) to fix the directories in the installation.
4.  Source the setup **`source <PATH_TO_CLIENT>/setup.sh`** (or **`setup.csh`** depending on the shell).
5.  Download and set up CA certificates using **`osg-ca-manage`** (See the [CA management documentation](../security/certificate-management.md) for the available options).
6.  Download CRLs using **`fetch-crl`**.

!!! note
    The WN client requires a Perl interpreter to be available in `/usr/bin/perl`.
    If not present, install by running `yum install perl` as root.

!!! warning
    Once `osg-post-install` is run to relocate the install, it cannot be run again.  You will need to unpack a fresh copy.

Example installation (in `/home/user/test-install`, the **`<PATH_TO_CLIENT>/`** is `/home/user/test-install/osg-wn-client` ):

```console
user@host $ mkdir /home/user/test-install
user@host $ cd /home/user/test-install
user@host $ wget https://repo.opensciencegrid.org/tarball-install/3.5/osg-wn-client-latest.el7.x86_64.tar.gz
user@host $ tar xzf osg-wn-client-latest.el7.x86_64.tar.gz
user@host $ cd osg-wn-client
user@host $ ./osg/osg-post-install
user@host $ source setup.sh
user@host $ osg-ca-manage setupCA --url osg
user@host $ fetch-crl
```

Configure the CE
----------------

Using the wn-client software installed from the tarball will require a few changes on the compute entrypoint so that the resource's configuration can be correctly reported.

Set `grid_dir` in the `Storage` section of your OSG-Configure configs: [CE configuration instructions](../other/configuration-with-osg-configure.md#storage). `grid_dir` is used as the `$OSG_GRID` environment variable in running jobs - see the [worker node environment document](using-wn.md). Pilot jobs source `$OSG_GRID/setup.sh` before performing any work. The value set for `grid_dir` must be the path of the wn-client installation directory. This is the path returned by **`echo $OSG_LOCATION`** once you source the setup file created by this installation.

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

### Enabling and Disabling Services

To enable the CRL updates, you must edit your cron with **`crontab -e`** and add the lines above.  To disable, remove
the lines from the `crontab`.

Validating the Worker Node Client
-------------------------------

To verify functionality of the worker node client, you will need to submit a test job against your CE and verify the job's output.

1.  Submit a job that executes the `env` command (e.g. Run [`condor_ce_trace`](https://htcondor.github.io/htcondor-ce/v5/troubleshooting/debugging-tools/#condor_ce_trace) with the `-d` flag from your HTCondor CE)
2.  Verify that the value of `$OSG_GRID` is set to the directory of your worker node client installation

How to get Help?
----------------

To get assistance please use this [Help Procedure](../common/help.md).
