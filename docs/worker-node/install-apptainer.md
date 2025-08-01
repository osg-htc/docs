title: Install Apptainer

Install Apptainer
=================

[Apptainer](http://apptainer.org) (formerly known as Singularity, see
[announcement](https://apptainer.org/news/community-announcement-20211130))
is a tool that creates
docker-like process containers but without giving extra privileges to
unprivileged users.  It is used by pilot jobs (which are
submitted by per-collaboration workload management systems) to isolate user
jobs from the pilot's files and processes and from other users' files
and processes.  It also supplies a chroot environment in order to run
user jobs in different operating system images under one Linux kernel.

Apptainer works either by making use of unprivileged user namespaces
or with a setuid-root assist program. 
By default it does not install the setuid-root assist program
and it uses only unprivileged user namespaces.
Unprivileged user namespaces are enabled by default on all OS versions that
OSG supports, although some system administrators may have disabled them.
Instructions to enable it are [below](#enabling-unprivileged-apptainer).

!!! danger "Kernel vs. Userspace Security"
    Enabling unprivileged user namespaces increases the risk to the
    kernel. However, the kernel is much more widely reviewed than Apptainer
    and the additional capability given to users is more limited.
    OSG Security considers the non-setuid, kernel-based method to have a
    lower security risk, and they also recommend disabling network
    namespaces as detailed below.

The OSG has installed Apptainer in [OASIS](install-cvmfs.md),
so most sites will not need to install Apptainer locally unless they
have non-OSG users that need it.

This document is intended for system administrators that wish to enable,
install, and/or configure Apptainer.

Before Starting
---------------

As with all OSG Software installations, there are some one-time (per host)
steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms.md)
- Obtain root access to the host
- If you intend to install Apptainer locally, then
  prepare the [required Yum repositories](../common/yum.md). 
  Note that the apptainer RPM comes from the EPEL Yum repository.
  OSG validates that distribution, and detailed instructions are still here.

In addition, this is highly recommended for image distribution and for
access to Apptainer itself:

- Install [CVMFS](install-cvmfs.md)

Choosing whether or not to install Apptainer
--------------------------------------------

There are two sets of instructions on this page:

- [Enabling Unprivileged Apptainer](#enabling-unprivileged-apptainer)
- [Installing Apptainer](#installing-apptainer)

OSG VOs all support running apptainer directly from CVMFS, when CVMFS
is available and unprivileged user namespaces are enabled.
Unprivileged user namespaces are enabled by default on all OS versions
that OSG supports.
When unprivileged user namespaces are enabled, OSG
recommends that sites not install Apptainer unless they have
non-OSG users that require it.

Sites that do want to install apptainer locally have two choices on
how to do it.  They can install it with a script which creates an
unprivileged relocatable installation directory, or they can install
it by RPM.
Sites that install the RPM will by default still only get a
non-setuid installation that makes use of unprivileged user namespaces
and will need to install an additional apptainer-suid RPM if they
want a setuid installation that does not require unprivileged user
namespaces.

Enabling Unprivileged Apptainer
-------------------------------

The instructions in this section are for enabling Apptainer to run
unprivileged.

1. Make sure unprivileged user namespaces are enabled.  They are
   enabled by default on EL 8 and EL 9, but some system administrators
   may have disabled them, possibly because of worries about a need for
   frequent kernel patching (regarding that see step 2).  Look for a
   `sysctl` setting for `user.max_user_namespaces` which needs to be
   non-zero.  Examples for when it was disabled often showed setting
   it to a value of 15000.

1. (Recommended) Disable network namespaces:

        :::console
        root@host # echo "user.max_net_namespaces = 0" \
            > /etc/sysctl.d/90-max_net_namespaces.conf
        root@host # sysctl -p /etc/sysctl.d/90-max_net_namespaces.conf

    OSG VOs do not need network namespaces with Apptainer, and
    disabling them significantly lowers the risk profile of user
    namespaces and reduces the frequency of needing to apply urgent updates.
    Most of the kernel vulnerabilities related to unprivileged user
    namespaces over the last several years have been in combination with
    network namespaces.

    Network namespaces are, however, utilized by other software,
    such as Docker or Podman.
    Disabling network namespaces may break other
    software, or limit its capabilities (such as requiring the
    `--net=host` option in Docker or Podman).
    
    Disabling network namespaces blocks the systemd PrivateNetwork
    feature, which is a feature that is used by some EL 8 & 9 services
    by default.  To check them all, look for PrivateNetwork in
    `/lib/systemd/system/*.service` and see which of those services are
    enabled but failed to start.  The only default such service on EL 8
    is systemd-hostnamed, and a popular non-default such service is
    mlocate-updatedb.  The PrivateNetwork feature can be turned off for
    a service without modifying an RPM-installed file through a
    `<service>.d/*.conf` file, for example for systemd-hostnamed:

        :::console
        root@host # cd /etc/systemd/system
        root@host # mkdir -p systemd-hostnamed.service.d
        root@host # (echo "[Service]"; echo "PrivateNetwork=no") \
                >systemd-hostnamed.service.d/no-private-network.conf
        root@host # systemctl daemon-reload
        root@host # systemctl start systemd-hostnamed
        root@host # systemctl status systemd-hostnamed


### Configuring Docker to work with Apptainer ###

If docker is being used to run jobs, the following options are 
recommended to allow unprivileged Apptainer to run (it does not
need `--privileged` or any added capabilities):

    ::console
    --security-opt seccomp=unconfined --security-opt systempaths=unconfined

`--security-opt seccomp=unconfined` enables unshare to be called
(which is needed to create namespaces),
and `--security-opt systempaths=unconfined` allows `/proc` to be mounted
in an unprivileged process namespace (as is done by apptainer exec -p).
`--security-opt systempaths=unconfined` requires Docker 19.03 or later.
The options are secure as long as the system administrator controls
the images and does not allow user code to run as root, and are
generally more secure than adding capabilities.  If at this point no
setuid or setcap programs needs to be run within the container, adding the
following option will improve security by preventing any privilege
escalation (Apptainer uses the same feature on its containers):

    ::console
    --security-opt no-new-privileges

In addition, the following option is recommended for allowing
unprivileged fuse mounts:

    ::console
    --device=/dev/fuse

### Configuring Unprivileged Apptainer ###

When unprivileged user namespaces are enabled and VOs run apptainer from
CVMFS, the Apptainer configuration file also comes from CVMFS so local
sites have no control over changing the configuration.  However, the
most common local configuration change to the apptainer RPM is to add
additional local "bind path" options to map extra local file paths into
containers.  This can instead be accomplished by setting the
`APPTAINER_BINDPATH` variable in the environment of jobs, for
example through
[configuration](/other/configuration-with-osg-configure)
on your compute entrypoint.
This is a comma-separated list of paths to bind, following the syntax of the
`apptainer exec --bind` option.
In order to be backward compatible with Singularity, also set
`SINGULARITY_BINDPATH` to the same value.
Apptainer also recognizes that variable but it prints a deprecation
warning if only a `SINGULARITY_` variable is set without the
corresponding `APPTAINER_` variable.

There are also other environment variables that can affect Apptainer
operation; see the
[Apptainer documentation](https://apptainer.org/docs/user/main/appendix.html)
for details.

### Validating Unprivileged Apptainer in CVMFS ###

If you will not be installing Apptainer locally and
you haven't yet installed [CVMFS](install-cvmfs.md), please do so.
Alternatively, use the
[cvmfsexec package](https://github.com/cvmfs-contrib/cvmfsexec)
configured for osg as an unprivileged user and mount the
oasis.opensciencegrid.org and singularity.opensciencegrid.org
repositories.

Then as an unprivileged user verify that Apptainer in CVMFS works with this
command:

```console
user@host $ /cvmfs/oasis.opensciencegrid.org/mis/apptainer/bin/apptainer \
                exec --contain --ipc --pid --bind /cvmfs \
                /cvmfs/singularity.opensciencegrid.org/opensciencegrid/osgvo-el8:latest \
                ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
user           1       0  0 10:51 console  00:00:00 appinit
user          11       1  0 10:51 console  00:00:00 /usr/bin/ps -ef
```


Installing Apptainer
--------------------

The instructions in this section are for installing a local copy
of Apptainer, either an unprivileged installation or an RPM installation.

### Installing Apptainer via unprivileged script ###

To install a relocatable unprivileged installation of Apptainer,
follow the instructions in the
[upstream documentation](https://apptainer.org/docs/admin/main/installation.html#install-unprivileged-from-pre-built-binaries).

### Installing Apptainer via RPM ###

To install the apptainer RPM, make sure that your host is up to date
before installing the required packages:

1. Clean yum cache:

        ::console
        root@host # yum clean all --enablerepo=*

1. Update software:

        :::console
        root@host # yum update

    This command will update **all** packages

1. Install Apptainer

        :::console
        root@host # yum install apptainer

1. If you choose to install the (not recommended) setuid-root portion of
    Apptainer, that can be done by instead doing this:

        :::console
        root@host # yum install apptainer-suid

#### Configuring Apptainer RPM ###

Generally Apptainer requires no configuration, but if you install it by
RPM the primary configuration is done in `/etc/apptainer/apptainer.conf`.

!!! warning
    If you modify `/etc/apptainer/apptainer.conf`, be careful with
    your upgrade procedures.
    RPM will not automatically merge your changes with new upstream
    configuration keys, which may cause a broken install or inadvertently
    change the site configuration.  Apptainer changes its default
    configuration file more frequently than typical OSG software.

    Look for `apptainer.conf.rpmnew` after upgrades and merge in any
    changes to the defaults.

#### Upgrading from Singularity RPM

When upgrading from Singularity to Apptainer, any local changes that
were made to `/etc/singularity/singularity.conf` need to be manually
migrated to `/etc/apptainer/apptainer.conf` and the `/etc/singularity`
directory needs to be deleted.

See the Apptainer [Migrating from Singularity](
https://apptainer.org/docs/admin/main/singularity_migration.html)
guide and its explanation of [Singularity compatibility](
https://apptainer.org/docs/user/main/singularity_compatibility.html)
for more details.

#### Limiting Image Types with Setuid Installation ####

If the RPM installation is setuid, consider the following.

Images based on loopback devices carry an inherently higher exposure to
unknown kernel exploits compared to directory-based images distributed via
CVMFS.  See [this article](https://lwn.net/Articles/652468/) for further
discussion.

In setuid mode, the SIF images produced by default by Apptainer are 
mounted with loopback devices.
However, OSG VOs only need directory-based images,
and Apptainer can also mount SIF images using unprivileged user namespaces.
Hence, it is reasonable to disable the loopback-based images by setting
the following option in `/etc/apptainer/apptainer.conf`:

        max loop devices = 0

While reasonable for some sites, this is not required as there are currently
no public kernel exploits for this issue; any exploits are patched by
Red Hat when they are discovered.
If loopback devices are disabled but unprivileged user namespaces are enabled,
then users can run Apptainer with the `--userns` option (which is the same
thing as the default in a non-setuid installation)
and still be able to mount images unprivileged,
although they will get an error if they don't use the option.

### Validating Apptainer installation ###

After apptainer is installed, as an ordinary user run the following
command to verify it:

```console
user@host $ apptainer exec --contain --ipc --pid docker://centos:7 ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
user           1       0  0 11:07 console  00:00:00 appinit
user          12       1  0 11:07 console  00:00:00 /usr/bin/ps -ef
```

Starting and Stopping Services
------------------------------

Apptainer has no services to start or stop.

References
----------
- [Apptainer Documentation](https://apptainer.org/docs/)
- [Apptainer Support](https://apptainer.org/support/)
