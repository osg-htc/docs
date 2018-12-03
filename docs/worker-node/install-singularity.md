Install Singularity
===================

[Singularity](http://singularity.lbl.gov) is a tool that creates
docker-like process containers but without giving extra privileges to
unprivileged users.  It is used by grid pilot jobs (which are
submitted by per-VO grid workload management systems) to isolate user
jobs from the pilot's files and processes and from other users' files
and processes.  It also supplies a chroot environment in order to run
user jobs in different operating system images under one Linux kernel.

For operating system kernels older than the one released for
Red Hat Enterprise Linux (RHEL) 7.6,
singularity needs to use kernel capabilities that are only accessible
to the root user, so it has to be installed with setuid-root
executables.  Securing setuid-root programs is difficult, but singularity
keeps that privileged code to a
[minimum](https://www.sylabs.io/guides/2.6/user-guide/introduction.html#security-and-privilege-escalation)
to keep the vulnerability to a minimum.

Beginning with the kernel released with RHEL 7.6, there is a
fully supported but optional feature
to allow unprivileged bind mounts in user namespaces, which allows
singularity to run as an unprivileged user.
The kernel version (3.10.0-957) is available as a security update for
all RHEL (and its derivatives Scientific Linux and CentOS) 7.x
releases so it does not require upgrading to 7.6.

The OSG has installed
singularity in [OASIS](/worker-node/install-cvmfs), so many sites
will eventually not need to install singularity locally if they enable
it to run unprivileged.

!!! danger "Kernel vs. Userspace Security"
    Enabling unprivileged user namespaces increases the risk to the
    kernel. However, the kernel is more widely reviewed than Singularity and
    the additional capability given to users is more limited.
    OSG Security considers the non-setuid, kernel-based method to have a
    lower security risk.

The document is intended for system administrators who wish to either
enable singularity to be run as an unprivileged user or install
privileged singularity, or both.

Before Starting
---------------

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](/release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](/common/yum)
- A [CVMFS installation](/worker-node/install-cvmfs) for Singularity image distribution

Choosing Unprivileged vs Privileged Singularity
-----------------------------------------------

There are two separate sets of instructions on this page:

- [Enabling unprivileged singularity](#unprivileged-singularity) via OASIS
- [Installing privileged singularity](#privileged-singularity) via RPM

As of December 2018, no VO in the OSG is ready to use unprivileged, non-setuid Singularity from OASIS in production.
VOs are, however, working to support it soon so OSG recommends that
all RHEL 7.x installations enable support for unprivileged singularity,
and for now also install the privileged RPM.  RHEL 6.x installations
have no option for unprivileged singularity and so will have to
install the privileged RPM.

In addition, there a few singularity features that only work with the
privileged RPM, so a limited number of sites will want to continue to
take the risk of running the privileged RPM.  These are the features
not supported in unprivileged singularity:

1. Using loopback-based container image files.  The default container
    images made by singularity are single, monolithic images containing
    a filesystem of files that need to be loopback-mounted by the kernel
    with root privileges.  We [recommend below](#limiting-image-types)
    disabling that feature in privileged singularity because of
    inherent risks and to use unpacked directory-based images instead,
    but some sites may need the feature.  In particular, High
    Performance Computing (HPC) systems often work better with large
    image files than with many small files in CVMFS.

1. The overlay feature.  The overlay feature of singularity uses
    overlayfs to be able to add bind mounts where mount points don't
    exist in the underlying image, and overlayfs is a privileged
    kernel feature.  However, singularity also has another feature
    called underlay that provides essentially the same functionality
    without privileges.  Also, the overlay feature doesn't work when
    the image is a directory distributed in CVMFS.  We [recommend
    below](#configuring-singularity) to enable underlay and disable
    overlay in privileged singularity installations.

1. Allocating new pseudo-tty devices.  In the current RHEL 7.6 kernel,
    allocating pseudo-tty devices is also a privileged operation.
    Most workflows don't use that feature and so won't notice, but
    certain features such as `condor_ssh_to_job` and `condor_submit -i`
    will not work, and some users might need those.  There is also a
    workaround in the next (3.x) version of singularity in an option
    called `--fakeroot` that makes the user name space appear to be
    running as the root user even though all its file accesses are as
    the original unprivileged user.  The kernel then allows allocating
    pseudo-tty devices in the fakeroot environment.


Unprivileged Singularity
------------------------

The instructions in this section are for enabling singularity with non-setuid executables, which is available in OASIS,
the OSG Software [CVMFS distribution](/worker-node/install-cvmfs).

### Enabling Singularity via OASIS ###

If the operating system is an EL 7 variant and has been updated to the EL
7.6 kernel or later, enable unprivileged singularity with the following
steps:

1. Enable user namespaces via `sysctl`:

        :::console
        root@host # echo "user.max_user_namespaces = 15000" \
            > /etc/sysctl.d/90-max_user_namespaces.conf

1. (Optional) Disable network namespaces:

        :::console
        root@host # echo "user.max_net_namespaces = 0" \
            > /etc/sysctl.d/90-max_net_namespaces.conf

    OSG VOs do not need network namespaces with singularity, and
    disabling them reduces the risk profile of enabling user
    namespaces.

    Network namespaces are, however, utilized by other container
    systems, such as Docker.  Disabling network namespaces may break
    other container solutions, or limit their capabilities (such as
    requiring the `--net=host` option in Docker).

1. If you haven't yet installed [cvmfs](install-cvmfs), do so.


### Validating singularity ###

Once you have the host configured properly, log in as an ordinary
unprivileged user and verify that singularity in OASIS works:

```console
user@host $ /cvmfs/oasis.opensciencegrid.org/mis/singularity/bin/singularity \
                exec --contain --ipc --pid --bind /cvmfs \
                /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo:el6 \
                ps -ef
WARNING: Container does not have an exec helper script, calling 'ps' directly
UID        PID  PPID  C STIME TTY          TIME CMD
user         1     0  2 21:27 ?        00:00:00 shim-init                      
user         2     1  0 21:27 ?        00:00:00 ps -ef
```


Privileged Singularity
----------------------

The instructions in this section are for installing singularity with setuid-root executables.

### Installing Singularity via RPM ###

To install singularity as `setuid`, make sure that your host is up to date before installing the required packages:

1. Clean yum cache:

        ::console
        root@host # yum clean all --enablerepo=*

1. Update software:

        :::console
        root@host # yum update

    This command will update **all** packages

1. The singularity packages are split into two parts, choose the command that corresponds to your situation:
    - If you are installing singularity on a worker node, where images do not need to be created or manipulated, install just the smaller part to limit the amount of setuid-root code that is installed:

            :::console
            root@host # yum install singularity-runtime

    - If you want a full singularity installation, run the following command:

            :::console
            root@host # yum install singularity

!!! tip
    In most cases, only `singularity-runtime` is needed on the worker node;
    installing only this smaller package reduces risk of potential security
    exploits.

### Configuring singularity ###

The OSG distribution of singularity includes an option called
`underlay` that enables using bind mount points that do not exist in
the container image.
It is not enabled by default but recommended because it is less
vulnerable to security problems than the similar default `overlay`
option.
In addition, the `overlay` option does not work on RHEL6 and does not
work correctly on RHEL7 when container images are distributed by CVMFS.

Set these options in `/etc/singularity/singularity.conf`:

        use overlay = no
        use underlay = yes

!!! warning
    If you modify `/etc/singularity/singularity.conf`, be careful with
    your upgrade procedures.
    RPM will not automatically merge your changes with new upstream
    configuration keys, which may cause a broken install or inadvertently
    change the site configuration.  Singularity changes its default
    configuration file more frequently than typical OSG software.

    Look for `singularity.conf.rpmnew` after upgrades and merge in any
    changes to the defaults.

#### Limiting image types ####

Images based on loopback devices carry an inherently higher exposure to
unknown kernel exploits compared to directory-based images distributed via
CVMFS.  See [this article](https://lwn.net/Articles/652468/) for further
discussion.

The loopback-based images are the default image type produced by Singularity
users and are common at sites with direct user logins.  However (as of May
2018) we are only aware of directory-based images being used by OSG VOs.  Hence,
it is a reasonable measure to disable the loopback-based images by setting
the following option in `/etc/singularity/singularity.conf`:

        max loop devices = 0

While reasonable for some sites, this is not required as there are currently
no public kernel exploits for this issue; any exploits are patched by
Red Hat when they are discovered.

### Validating singularity ###

After singularity is installed, as an ordinary user run the following
command to verify it:

```console
user@host $ singularity exec --contain --ipc --pid --bind /cvmfs \
                /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo:el6 \
                ps -ef
WARNING: Container does not have an exec helper script, calling 'ps' directly
UID        PID  PPID  C STIME TTY          TIME CMD
user         1     0  1 21:41 ?        00:00:00 shim-init                      
user         2     1  0 21:41 ?        00:00:00 ps -ef
```

Starting and Stopping Services
------------------------------

singularity has no services to start or stop.

References
----------
- [Singularity Documentation](https://www.sylabs.io/docs/)
- [Singularity Support](https://www.sylabs.io/singularity/support/)
- [Additional guidance for CMS sites](https://twiki.cern.ch/twiki/bin/view/Main/CmsSingularity)
