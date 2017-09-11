
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

## Requirements

### Host and OS

-  OS is Red Hat Enterprise Linux 6, 7 or variants
-  `root` access

### Users and Groups

singularity runs as the original user so no extra users and groups
are created.

## Avoiding Installation

If you are using a RHEL 7.4 variant OS, you can avoid installing
singularity by doing the following steps:

1. Set the `namespace.unpriv_enable=1` boot option.  The easiest way
    to do this is to add it in `/etc/sysconfig/grub` to the end of the
    GRUB_CMDLINE_LINUX variable, before the ending double-quote.
2. Update the grub configuration:

        [root@client ~] $ grub2-mkconfig -o /boot/grub2/grub.cfg

3. Set a sysctl option as follows:

        [root@client ~] $ echo "user.max_user_namespaces = 15000" \
            > /etc/sysctl.d/90-max_user_namespaces.conf

4. Reboot
5. If you haven't yet installed [cvmfs](cvmfs), do so.
6. Log in as an ordinary unprivileged user and verify that singularity
    works:

        [user@client ~] $ /cvmfs/oasis.opensciencegrid.org/mis/singularity/el7-x86_64/bin/singularity \
                exec -C -H $HOME:/srv /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo:el6 \
                ps -ef
        WARNING: Container does not have an exec helper script, calling 'cat' directly
        UID        PID  PPID  C STIME TTY          TIME CMD
        user         1     0  0 21:34 ?        00:00:00 ps -ef

<br>
## Install Instructions

If you want to go ahead with installing singularity, first
make sure the
[yum repositories](../common/yum.md) are correctly configured for OSG.

### Installing singularity

The singularity packages are split into two parts.  If you are 
installing it on a worker node, where images do not need to be created
of a manipulated, install just the smaller part to limit the amount
of setuid-root code that is installed:

        [root@client ~] $ yum install singularity-runtime
<br>
If instead you want a full singularity installation, do this command:

        [root@client ~] $ yum install singularity
<br>
### Configuring singularity

The default configuration of singularity is sufficient.  If you want
to see what options are available, see `/etc/singularity/singularity.conf`.

## Verifying singularity

After singularity is installed, as an ordinary user run the following
command to verify it:

        [user@client ~] $ singlarity exec -C -H $HOME:/srv /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo:el6 ps -ef
        WARNING: Container does not have an exec helper script, calling 'cat' directly
        UID        PID  PPID  C STIME TTY          TIME CMD
        user         1     0  0 21:34 ?        00:00:00 ps -ef

<br>
## Starting and Stopping services

singularity has no services to start or stop.
