
# Install Singularity

This document describes installation of the OSG distribution of
[Singularity](http://singularity.lbl.gov).
This document is intended for system administrators who wish to
install this client or enable it to be run as an unprivileged user.

!!! note "Applicable versions"
    The applicable software versions for this document are OSG Version >= 3.4.3.
    The version of singularity installed should be >= 2.3.1

## About Singularity

Singularity is a tool that creates docker-like process containers but
without giving extra privileges to unprivileged users.  It is used by
pilot jobs submitted by per-VO grid workload management systems to
isolate the user jobs that they run from the pilot's files and
processes and from other users' files and processes.

Prior to Red Hat Enterprise Linux (RHEL) 7.4, singularity needs to use
kernel capabilities that are only accessible to the root user, so it
has to be installed with setuid-root executables.  Security setuid-root
programs is difficult, but it keeps that privileged code to a
[minimum](http://singularity.lbl.gov/docs-security) to keep the
vulnerability low.  Beginning in RHEL 7.4, there is a new
[technology preview feature](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html-single/7.4_Release_Notes/index.html#technology_previews_kernel)
to allow unprivileged access to name spaces, which allows singularity
to run as an unprivileged user.  The OSG has installed singularity in
[cvmfs](cvmfs), so if you have RHEL 7.4 or later you can avoid
installing singularity at all and reduce vulnerability even further.

Before Starting
---------------

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](../common/yum)

## Via CVMFS (EL 7.4 only)

If you are using a RHEL 7.4 variant OS, you can skip installation altogether and use singularity through OASIS:

1. Set the `namespace.unpriv_enable=1` boot option.  The easiest way
    to do this is to add it in `/etc/sysconfig/grub` to the end of the
    GRUB_CMDLINE_LINUX variable, before the ending double-quote.
2. Update the grub configuration:

        :::console
        [root@client ~] $ grub2-mkconfig -o /boot/grub2/grub.cfg

3. Set a sysctl option as follows:

        :::console
        [root@client ~] $ echo "user.max_user_namespaces = 15000" \
            > /etc/sysctl.d/90-max_user_namespaces.conf

4. Reboot
5. If you haven't yet installed [cvmfs](cvmfs), do so.
6. Log in as an ordinary unprivileged user and verify that singularity
    works:

        :::console
        [user@client ~] $ /cvmfs/oasis.opensciencegrid.org/mis/singularity/el7-x86_64/bin/singularity \
                exec -C -H $HOME:/srv /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo:el6 \
                ps -ef
        WARNING: Container does not have an exec helper script, calling 'cat' directly
        UID        PID  PPID  C STIME TTY          TIME CMD
        user         1     0  0 21:34 ?        00:00:00 ps -ef

## Installing singularity

To install singularity, make sure that your host is up to date before installing the required packages:

1. Clean yum cache:

        ::console
        [root@client ~ ] $ yum clean all --enablerepo=*

2. Update software:

        :::console
        [root@client ~ ] $ yum update
    This command will update **all** packages

3. The singularity packages are split into two parts, choose the command that corresponds to your host:
    - If you are installing singularity on a worker node, where images do not need to be created of a manipulated, install just the smaller part to limit the amount of setuid-root code that is installed:

            :::console
            [root@client ~] $ yum install singularity-runtime

    - If you want a full singularity installation, run the following command:

            :::console
            [root@client ~] $ yum install singularity

## Configuring singularity

The default configuration of singularity is sufficient.  If you want
to see what options are available, see `/etc/singularity/singularity.conf`.

## Validating singularity

After singularity is installed, as an ordinary user run the following
command to verify it:

```console
[user@client ~] $ singlarity exec -C -H $HOME:/srv /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo:el6 ps -ef
WARNING: Container does not have an exec helper script, calling 'cat' directly
UID        PID  PPID  C STIME TTY          TIME CMD
user         1     0  0 21:34 ?        00:00:00 ps -ef
```

## Starting and Stopping services

singularity has no services to start or stop.
