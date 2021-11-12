Installing and Maintaining HTCondor-CE
======================================

The [HTCondor-CE](http://htcondor-ce.org) software is a *job gateway* for an OSG Compute Entrypoint (CE).
As such, the OSG will submit resource allocation requests (RARs) jobs to your HTCondor-CE and it will handle
authorization and delegation of RARs to your local batch system.
In OSG today, RARs are sent to CEs as *pilot jobs* from a factory, which in turn are able to accept and run end-user jobs.
See the [upstream documentation](https://htcondor.github.io/htcondor-ce/architecture/) for a more detailed introduction.

Use this page to learn how to install, configure, run, test, and troubleshoot an OSG HTCondor-CE.

!!! tip "OSG Hosted CE"
    Unless you plan on running more than 10k concurrently running RARs or plan on making frequent configuration changes,
    we suggest [requesting an OSG Hosted CE](hosted-ce.md).

!!! note
    If you are installing an HTCondor-CE for use outside of the OSG, consult
    [the upstream documentation](https://htcondor.github.io/htcondor-ce/v5/installation/htcondor-ce/) instead.

Before Starting
---------------

Before starting the installation process, consider the following points, consulting the upstream references as needed
([HTCondor-CE 5](https://htcondor.github.io/htcondor-ce/v5/reference/),
[HTCondor-CE 4](https://htcondor.github.io/htcondor-ce/v4/reference/)):

-   **User IDs:** If they do not exist already, the installation will create the Linux users `condor` (UID 4716) and
    `gratia` (UID 42401)
-   **SSL certificate:** The HTCondor-CE service uses a host certificate at `/etc/grid-security/hostcert.pem` and an
    accompanying key at `/etc/grid-security/hostkey.pem`
-   **DNS entries:** Forward and reverse DNS must resolve for the HTCondor-CE host
-   **Network ports:** The pilot factories must be able to contact your HTCondor-CE service on port 9619 (TCP)
-   **Access point/login node:** HTCondor-CE should be installed on a host that already has the ability to submit jobs
    into your local cluster
-   **File Systems**: Non-HTCondor batch systems require a
    [shared file system](https://htcondor.github.io/htcondor-ce/v5/configuration/local-batch-system/#sharing-the-spool-directory)
    between the HTCondor-CE host and the batch system worker nodes.

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms.md)
- Obtain root access to the host
- Install [CA certificates](../common/ca.md)

Choosing the OSG Yum Repository
-------------------------------

!!! danger "Before considering OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, contact your virtual organization(s) (VO) to verify that they
    support token-based authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](../release/notes.md).

The OSG distributes different versions of HTCondor-CE and HTCondor in separate [YUM repositories](../common/yum.md).
Most notably, the repository that you choose will determine the types of credentials that your CE is able to accept.
Use the following table to decide OSG YUM repository to install HTCondor-CE:

| **YUM Repository**                                              | **Bearer Tokens** | **GSI and VOMS** |
|-----------------------------------------------------------------|-------------------|------------------|
| OSG 3.5 upcoming **(recommended)**: HTCondor-CE 5, HTCondor 9.0 | &#9989;           | &#9989;          |
| OSG 3.5 release: HTCondor-CE 4, HTCondor 8.8                    |                   | &#9989;          |
| OSG 3.6 release: HTCondor-CE 5, HTCondor 9.0                    | &#9989;           |                  |


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

    -   If you have decided to install from [3.5 upcoming](#choosing-the-osg-yum-repository), run the following command

            :::console
            root@host # yum install --enablerepo=osg-upcoming <PACKAGE>

    -   Otherwise, run the following command:

            :::console
            root@host # yum install <PACKAGE>


Configuring HTCondor-CE
-----------------------

There are a few required configuration steps to connect HTCondor-CE with your batch system and authentication method.
For more advanced configuration, see the section on [optional configurations](#optional-configuration).

### Configuring the local batch system ###

To configure HTCondor-CE to integrate with your local batch system, please refer to the upstream documentation based on
your installed version of HTCondor-CE:

-   [HTCondor-CE 5](https://htcondor.github.io/htcondor-ce/v5/configuration/local-batch-system/)
-   [HTCondor-CE 4](https://htcondor.github.io/htcondor-ce/v4/installation/htcondor-ce/#configuring-the-batch-system)

### Configuring authentication ###

Depending on the OSG repository from which you have installed HTCondor-CE, you can allow pilot job submission to your CE
based on X.509 proxies (i.e., GSI and VOMS), bearer tokens, or both.

#### GSI and VOMS (OSG 3.5 only) ####

To configure which VOs and users are authorized to submit pilot jobs to your HTCondor-CE, follow the instructions in
[the LCMAPS VOMS plugin document](../security/lcmaps-voms-authentication.md#configuring-the-lcmaps-voms-plugin).


#### Bearer Tokens (OSG 3.5 upcoming, OSG 3.6)####

To configure which VOs are authorized to submit pilot jobs to your HTCondor-CE, consult the "SciTokens" section of the
[upstream documentation](https://htcondor.github.io/htcondor-ce/v5/configuration/authentication/#scitokens).


### Automatic configuration

The OSG CE metapackage brings along a configuration tool, `osg-configure`, that is designed to automatically configure
the different pieces of software required for an OSG HTCondor-CE:

1.   Enable your batch system in the HTCondor-CE configuration by editing the `enabled` field in the
    `/etc/osg/config.d/20-<YOUR BATCH SYSTEM>.ini`:

        :::file
        enabled = True

1.  Read through the other `.ini` files in the `/etc/osg/config.d` directory and

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
For detailed instructions, please refer to the upstream documentation based on your installed version of HTCondor-CE:

-   HTCondor-CE 5
    -   [Configuring the Job Router](https://htcondor.github.io/htcondor-ce/v5/configuration/job-router-overview/)
    -   [Optional configuration](https://htcondor.github.io/htcondor-ce/v5/configuration/optional-configuration/)
-   HTCondor-CE 4
    -   [Configuring the Job Router](https://htcondor.github.io/htcondor-ce/v4/batch-system-integration/)
    -   [Optional configuration](https://htcondor.github.io/htcondor-ce/v4/installation/htcondor-ce/#optional-configuration)

#### Accounting with multiple CEs or local user jobs

!!! note
    For non-HTCondor batch systems only

If your site has multiple CEs or you have non-grid users submitting to the same local batch system, the OSG accounting
software needs to be configured so that it doesn't over report the number of jobs.

1.  Determine which file you need to modify

    -   **For OSG 3.5 installations,** use the following table:

        | If your batch system is… | Then edit the following file on each of your CE(s)… |
        |:-------------------------|:--------------------------------------------|
        | LSF                      | `/etc/gratia/pbs-lsf/ProbeConfig`           |
        | PBS                      | `/etc/gratia/pbs-lsf/ProbeConfig`           |
        | SGE                      | `/etc/gratia/sge/ProbeConfig`               |
        | SLURM                    | `/etc/gratia/slurm/ProbeConfig`             |

    -   **For OSG 3.6 installations,** you'll need to modify `/etc/gratia/htcondor-ce/ProbeConfig`

1.  Edit the value of `SuppressNoDNRecords` on each of your CE's so that it reads:

        :::file
        SuppressNoDNRecords="1"

Starting and Validating HTCondor-CE
-----------------------------------

For information on how to start and validate the core HTCondor-CE services, please refer to the upstream documentation
based on your installed version of HTCondor-CE:

-   [HTCondor-CE 5](https://htcondor.github.io/htcondor-ce/v5/verification/)
-   [HTCondor-CE 4](https://htcondor.github.io/htcondor-ce/v4/verification/)

### Enabling OSG accounting (OSG 3.5 only)

In addition to the core HTCondor-CE services, an OSG 3.5 HTCondor-CE must also start and enable the accounting service,
`gratia-probes-cron`:

```console
root@host # systemctl start gratia-probes-cron
root@host # systemctl enable gratia-probes-cron
```

In OSG 3.6, OSG accounting is managed directly by HTCondor-CE
(see the [update instructions](../release/updating-to-osg-36.md#gratia-probe) for more details).

Troubleshooting HTCondor-CE
---------------------------

For information on how to troubleshoot your HTCondor-CE, please refer to the upstream documentation based on your
installed version of HTCondor-CE:

-   HTCondor-CE 5:
    -   [Common issues](https://htcondor.github.io/htcondor-ce/v5/troubleshooting/common-issues/)
    -   [Debugging tools](https://htcondor.github.io/htcondor-ce/v5/troubleshooting/debugging-tools/)
    -   [Helpful logs](https://htcondor.github.io/htcondor-ce/v5/troubleshooting/logs/)
-   HTCondor-CE 4
    -   [Common issues](https://htcondor.github.io/htcondor-ce/v4/troubleshooting/troubleshooting/#htcondor-ce-troubleshooting-items)
    -   [Debugging tools](https://htcondor.github.io/htcondor-ce/v4/troubleshooting/troubleshooting/#htcondor-ce-troubleshooting-tools)
    -   [Helpful logs](https://htcondor.github.io/htcondor-ce/v4/troubleshooting/troubleshooting/#htcondor-ce-troubleshooting-data)

Registering the CE
------------------

To contribute to the the OSG Production Grid, your CE must be
[registered with the OSG](https://github.com/opensciencegrid/topology#topology).
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
