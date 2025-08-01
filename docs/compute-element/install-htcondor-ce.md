title: Installing and Maintaining HTCondor-CE

Installing and Maintaining HTCondor-CE
======================================

The [HTCondor-CE](http://htcondor-ce.org) software is a *job gateway* for an OSG Compute Entrypoint (CE).
As such, the OSG will submit resource allocation requests (RARs) jobs to your HTCondor-CE and it will handle
authorization and delegation of RARs to your local batch system.
In OSG today, RARs are sent to CEs as *pilot jobs* from a factory, which in turn are able to accept and run end-user jobs.
See the [upstream documentation](https://htcondor.com/htcondor-ce/architecture/) for a more detailed introduction.

Use this page to learn how to install, configure, run, test, and troubleshoot an OSG HTCondor-CE.

!!! tip "OSG Hosted CE"
    Unless you plan on running more than 10k concurrently running RARs or plan on making frequent configuration changes,
    we suggest [requesting an OSG Hosted CE](hosted-ce.md).

!!! note
    If you are installing an HTCondor-CE for use outside of the OSG, consult
    [the upstream documentation](https://htcondor.com/htcondor-ce/) instead.

Before Starting
---------------

Before starting the installation process, consider the following points, consulting the upstream references as needed
([HTCondor-CE 24](https://htcondor.com/htcondor-ce/v24/reference/)):

-   **User IDs:** If they do not exist already, the installation will create the Linux users `condor` (UID 4716) and
    `gratia`
    You will also need to create Unix accounts for each collaboration that you wish to support.
    See details in the ['Configuring authentication' section below](#configuring-authentication).
-   **SSL certificate:** The HTCondor-CE service uses a host certificate and an accompanying key.
    -  If using a Let's Encrypt cert, install these as
       `/etc/pki/tls/certs/localhost.crt` and `/etc/pki/tls/private/localhost.key`
    -  If using an IGTF cert, install these as
       `/etc/grid-security/hostcert.pem` and `/etc/grid-security/hostkey.pem`

    See details in the [Host Certificates overview](../security/host-certs/overview.md).

-   **DNS entries:** Forward and reverse DNS must resolve for the HTCondor-CE host
-   **Network ports:** The [pilot factories](../other/firewall.md#compute-entrypoints) must be able to contact your 
    HTCondor-CE service on port 9619 (TCP)
-   **Access point/login node:** HTCondor-CE should be installed on a host that already has the ability to submit jobs
    into your local cluster
-   **File Systems**: Non-HTCondor batch systems require a
    [shared file system](https://htcondor.com/htcondor-ce/v24/configuration/local-batch-system/#sharing-the-spool-directory)
    between the HTCondor-CE host and the batch system worker nodes.

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms.md)
- Install the appropriate [EPEL](../common/yum.md#install-the-epel-repositories) and
  [OSG](../common/yum.md#install-the-osg-repositories) Yum repositories for your operating system.
- Obtain root access to the host
- Install [CA certificates](../common/ca.md)

Installing HTCondor-CE
----------------------

An HTCondor-CE installation consists of the job gateway (i.e., the HTCondor-CE job router) and other support software
(e.g., `osg-configure`, a Gratia probe for OSG accounting).
To simplify installation, OSG provides convenience RPMs that install all required software.

1. Clean yum cache:

        ::console
        root@host # yum clean all --enablerepo=*

1. Update software:

        :::console
        root@host # yum update

    This command will update **all** packages

1. **(Optional)** If your batch system is already installed via non-RPM means and is in the following list, install the
   appropriate 'empty' RPM.
   Otherwise, skip to the next step.

    | If your batch system is… | Then run the following command…                       |
    |:-------------------------|:------------------------------------------------------|
    | HTCondor                 | `yum install empty-condor --enablerepo=osg-empty`     |
    | SLURM                    | `yum install empty-slurm --enablerepo=osg-empty`      |

1. **(Optional)** If your HTCondor batch system is already installed via non-OSG RPM means, add the line below to
`/etc/yum.repos.d/osg.repo`.
   Otherwise, skip to the next step.

        exclude=condor

1. Select the appropriate convenience RPM:

    | If your batch system is... | Then use the following package... |
    |:---------------------------|:----------------------------------|
    | HTCondor                   | `osg-ce-condor`                   |
    | LSF                        | `osg-ce-lsf`                      |
    | PBS                        | `osg-ce-pbs`                      |
    | SGE                        | `osg-ce-sge`                      |
    | SLURM                      | `osg-ce-slurm`                    |

1. Install the CE software where `<PACKAGE>` is the package you selected in the above step.:

        :::console
        root@host # yum install <PACKAGE>


Configuring HTCondor-CE
-----------------------

There are a few required configuration steps to connect HTCondor-CE with your batch system and authentication method.
For more advanced configuration, see the section on [optional configurations](#optional-configuration).

### Configuring the local batch system ###

To configure HTCondor-CE to integrate with your local batch system,
please refer to the [upstream documentation](https://htcondor.com/htcondor-ce/v24/configuration/local-batch-system/).

### Configuring authentication ###

HTCondor-CE clients will submit RARs accompanied by [bearer tokens](../security/tokens/overview.md) declaring their
association with a given collaboration and what permissions the collaboration has given the client
The `osg-scitokens-mapfile`, pulled in by the `osg-ce` package, provides default token to local user mappings.
To accept RARs from a particular collaboration:

1.  Create the Unix account(s) corresponding to the last field in the default mapfile:
    `/usr/share/condor-ce/mapfiles.d/osg-scitokens-mapfile.conf`.
    For example, to add support for the OSPool, create the `osg` user account on the CE and across your cluster.

1.  **(Optional)** if you wish to change the user mapping, copy the relevant mapping from
    `/usr/share/condor-ce/mapfiles.d/osg-scitokens-mapfile.conf` to a `.conf` file in `/etc/condor-ce/mapfiles.d/`
    and change the last field to the desired username.
    For example, if you wish to add support for the OSPool but prefer to map OSPool pilot jobs to the `osgpilot` account
    that you created on your CE and across your cluster, you could add the following to
    `/etc/condor-ce/mapfiles.d/50-ospool.conf`:

        # OSG
        SCITOKENS /^https\:\/\/scitokens\.org\/osg\-connect,/ osgpilot

For more details of the mapfile format, consult the "SciTokens" section of the
[upstream documentation](https://htcondor.com/htcondor-ce/v24/configuration/authentication/#scitokens).

#### Bannning a collaboration

!!! tip "Implicit banning"
    Note that if you have not created the mapped user per [the above section](#configuring-authentication),
    it is not strictly necessary to add a ban mapping.
    HTCondor-CE will only authenticate remote RAR submission for the relevant credential if the Unix user exists.

To explicitly ban a remote submitter from your HTCondor-CE, add a line like the following to a file in
`/etc/condor-ce/mapfiles.d/*.conf`:

    SCITOKENS /<TOKEN ISSUER>,<TOKEN SUBJECT>/ <USER>@banned.htcondor.org

Replacing `<CREDENTIAL>` with a regular expression and `<USER>` with an arbitrary user name.
For example, to ban OSPool pilots from your site, you could add the following to `/etc/condor-ce/config.d/99-bans.conf`:

    SCITOKENS /^https\:\/\/scitokens\.org\/osg\-connect,/ osgpilot@banned.htcondor.org

### Automatic configuration

The OSG CE metapackage brings along a configuration tool, `osg-configure`, that is designed to automatically configure
the different pieces of software required for an OSG HTCondor-CE:

1.   Enable your batch system in the HTCondor-CE configuration by editing the `enabled` field in the
    `/etc/osg/config.d/20-<YOUR BATCH SYSTEM>.ini`:

        :::file
        enabled = True

1.  Read through the other `.ini` files in the `/etc/osg/config.d` directory and make any necessary changes.
    See the [osg-configure documentation](/other/configuration-with-osg-configure#osg-configure) for details.

1.  Validate the configuration settings

        :::console
        root@host # osg-configure -v

1.  Fix any errors (at least) that `osg-configure` reports.

1.  Once the validation command succeeds without errors, apply the configuration settings:

        :::console
        root@host # osg-configure -c

### Optional configuration

In addition to the configurations above, you may need to further configure how pilot jobs are filtered and transformed
before they are submitted to your local batch system or otherwise change the behavior of your CE.
For detailed instructions, please refer to the upstream documentation:

-   [Configuring the Job Router](https://htcondor.com/htcondor-ce/v24/configuration/job-router-overview/)
-   [Optional configuration](https://htcondor.com/htcondor-ce/v24/configuration/optional-configuration/)

#### Accounting with multiple CEs or local user jobs

!!! note
    For non-HTCondor batch systems only

If your site has multiple CEs or you have local users submitting to the same local batch system, the OSG accounting
software needs to be configured so that it doesn't over report the number of jobs.
Modify the value of `SuppressNoDNRecords` in `/etc/gratia/htcondor-ce/ProbeConfig` on each of your CE's so that it
reads:

    :::file
    SuppressNoDNRecords="1"

Starting and Validating HTCondor-CE
-----------------------------------

For information on how to start and validate the core HTCondor-CE services, please refer to the
[upstream documentation](https://htcondor.com/htcondor-ce/v24/operation/)

Troubleshooting HTCondor-CE
---------------------------

For information on how to troubleshoot your HTCondor-CE, please refer to the upstream documentation:

-   [Common issues](https://htcondor.com/htcondor-ce/v24/troubleshooting/common-issues/)
-   [Debugging tools](https://htcondor.com/htcondor-ce/v24/troubleshooting/debugging-tools/)
-   [Helpful logs](https://htcondor.com/htcondor-ce/v24/troubleshooting/logs/)

Registering the CE
------------------

To contribute capacity, your CE must be
[registered with the OSG Consortium](https://github.com/opensciencegrid/topology#topology).
To register your resource:

1.  Identify the facility, site, and resource group where your HTCondor-CE is hosted.
    For example, the Center for High Throughput Computing at the University of Wisconsin-Madison uses the following
    information:

        Facility: University of Wisconsin
        Site: CHTC
        Resource Group: CHTC

1. Using the above information, [create or update](https://github.com/opensciencegrid/topology#how-to-register) the
   appropriate YAML file, using [this template](https://github.com/opensciencegrid/topology/blob/master/template-resourcegroup.yaml)
   as a guide.


Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
