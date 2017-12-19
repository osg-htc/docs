
# Install Singularity

[Singularity](http://singularity.lbl.gov) is a tool that creates
docker-like process containers but without giving extra privileges to
unprivileged users.  It is used by grid pilot jobs (which are
submitted by per-VO grid workload management systems) to isolate user
jobs from the pilot's files and processes and from other users' files
and processes.  It also supplies a chroot environment in order to run
user jobs in different operating system images under one Linux kernel.

For operating system kernels older than the one released for
Red Hat Enterprise Linux (RHEL) 7.4,
singularity needs to use kernel capabilities that are only accessible
to the root user, so it has to be installed with setuid-root
executables.  Securing setuid-root programs is difficult, but singularity
keeps that privileged code to a
[minimum](http://singularity.lbl.gov/docs-security) to keep the
vulnerability low.

Beginning with the kernel released with RHEL 7.4, there is a new
[technology preview feature](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html-single/7.4_Release_Notes/index.html#technology_previews_kernel)
to allow unprivileged bind mounts in user namespaces, which allows
singularity to run as an unprivileged user.  The OSG has installed
singularity in [cvmfs](install-cvmfs), so  you can avoid installing
singularity at all.  The minimum version of the kernel (3.10.0-693) is
available as at least a security update for all RHEL7-based releases.

!!! danger "Kernel vs. Userspace security"
    Enabling unprivileged user namespaces increases the risk to the
    kernel. However, the kernel is more widely reviewed than Singularity and
    the additional capability given to users is more limited.
    OSG Security considers the non-setuid, kernel-based method to have a
    lower security risk.

The document is intended for system administrators who wish to either
install singularity or enable it to be run as an unprivileged user.

!!! note "Applicable versions"
    The applicable software versions for this document are OSG version 3.4.2 or later.
    The version of singularity installed should be 2.3.1 or later.


Before Starting
---------------

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms)
- Obtain root access to the host
- If you're installing singularity, prepare the [required Yum repositories](../common/yum)

# Enabling Unprivileged Mode for Singularity

!!! note
    As of December 2017, no VO in the OSG is ready to use non-setuid
    Singularity in production.  Only testing sites will need to follow
    these instructions; contact the VOs you support for more
    information.

    Most sites will want to follow the privileged RPM install instructions
    until there is wider VO support.

If the operating system is an EL 7 variant and has been updated to the EL
7.4 kernel (3.10.0-693 or greater), you can skip
installation altogether and instead do these steps to enable
singularity to be run as an unprivileged user via CVMFS:

1. Set the `namespace.unpriv_enable=1` boot option.  The easiest way
    to do this is to add it in `/etc/sysconfig/grub` to the end of the
    `GRUB_CMDLINE_LINUX` variable, before the ending double-quote.
2. Update the grub configuration:

        :::console
        root@host # grub2-mkconfig -o /boot/grub2/grub.cfg

3. Enable user namespaces via `sysctl`:

        :::console
        root@host # echo "user.max_user_namespaces = 15000" \
            > /etc/sysctl.d/90-max_user_namespaces.conf
            
4. Disable network namespaces:

        :::console
        root@host # echo "user.max_net_namespaces = 0" \
            > /etc/sysctl.d/90-max_net_namespaces.conf

    OSG VOs do not need network namespaces with singularity, and
    disabling them reduces the risk profile of enabling user
    namespaces.  Network namespaces are, however, utilized by other
    container systems, such as Docker.  Disabling network namespaces
    may break other container solutions, or limit their capabilities
    (such as requiring the `--net=host` option in Docker).

    !!! danger "Danger: current public exploit"
        As December 19, 2018 there is no patch from Redhat for a
        [public exploit](https://access.redhat.com/security/cve/CVE-2017-16939)
        of a vulnerability due to the combination of network namespaces
        and user namespaces.  This vulnerability can crash a kernel and
        potentially lead to privilege escalation.  Do not leave network
        namespaces enabled at the same time as unprivileged user
        namespaces until this is resolved.

4. Reboot
5. If you haven't yet installed [cvmfs](install-cvmfs), do so.


## Validating singularity

Once you have the host configured properly, log in as an ordinary
unprivileged user and verify that singularity works:

```console
user@host $ /cvmfs/oasis.opensciencegrid.org/mis/singularity/el7-x86_64/bin/singularity \
                exec -C -H $HOME:/srv /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo:el6 \
                ps -ef
WARNING: Container does not have an exec helper script, calling 'cat' directly
UID        PID  PPID  C STIME TTY          TIME CMD
user         1     0  0 21:34 ?        00:00:00 ps -ef
```

!!! tip
    The remainder of this document pertains to the privileged
    (`setuid`) mode of singularity.

# Installing Singularity as Privileged

To install singularity as `setuid`, make sure that your host is up to date before installing the required packages:

1. Clean yum cache:

        ::console
        root@host # yum clean all --enablerepo=*

2. Update software:

        :::console
        root@host # yum update
    This command will update **all** packages

3. The singularity packages are split into two parts, choose the command that corresponds to your situation:
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

## Configuring singularity

There are no required changes to the default configuration.  If you want
to see what options are available, see `/etc/singularity/singularity.conf`.

### Limiting Image Types

Images based on loopback devices carry an inherently higher exposure to
unknown kernel exploits compared to directory-based images distributed via
CVMFS.  See [this article](https://lwn.net/Articles/652468/) for further
discussion.

The loopback-based images are the default image type produced by Singularity
users and are common at sites with direct user logins.  However (as of December
2017) we are only aware of directory-based images being used by OSG VOs.  Hence,
it is a reasonable measure to disable the loopback-based images by setting
the following option in `/etc/singularity/singularity.conf`:

        max loop devices = 0

While reasonable for some sites, this is not required as there are currently
no public kernel exploits for this issue; any exploits are patched by
RedHat when they are discovered.

!!! warning "Warning: No Free Lunches"
    If you modify `/etc/singularity/singularity.conf`, carefully test any
    upgrade procedures.
    RPM will not automatically merge your changes with new upstream
    configuration keys, which may cause a broken install or inadvertently
    change the site configuration.  Singularity renames configuration keys
    more frequently than typical OSG software.

    Look for `.rpmnew` files after upgrades and merge in any changes to the
    defaults.

## Validating singularity

After singularity is installed, as an ordinary user run the following
command to verify it:

```console
user@host $ singularity exec -C -H $HOME:/srv /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo:el6 \
                ps -ef
WARNING: Container does not have an exec helper script, calling 'cat' directly
UID        PID  PPID  C STIME TTY          TIME CMD
user         1     0  0 21:34 ?        00:00:00 ps -ef
```

## Starting and Stopping services

singularity has no services to start or stop.

# References

- [Additional guidance for CMS sites](https://twiki.cern.ch/twiki/bin/view/Main/CmsSingularity)
