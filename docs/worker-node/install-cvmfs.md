# Install CVMFS

Here we describe how to install the
[CVMFS](http://cernvm.cern.ch/portal/filesystem) (Cern-VM file system) client.
This document is intended for system administrators who wish to
install this client to have access to files distributed by CVMFS
servers via HTTP.

!!! note "Applicable versions"
    The applicable software versions for this document are OSG Version >= 3.4.3.
    The version of CVMFS installed should be >= 2.4.1

Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Reference section below](#reference) as needed):

-   **User IDs:** If it does not exist already, the installation will create the `cvmfs` Linux user
-   **Group IDs:** If they do not exist already, the installation will create the Linux groups `cvmfs` and `fuse`
-   **Network ports:** You will need network access to a local squid server such as the [squid distributed by OSG](../data/frontier-squid.md). The squid will need out-bound access to cvmfs stratum 1 servers.
-   **Host choice:** -  Sufficient (~20GB+20%) cache space reserved, preferably in a separate filesystem (details [below](#configuring-cvmfs))
-   **FUSE**: CVMFS requires FUSE

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](../common/yum)

## Installing CVMFS

The following will install CVMFS from the OSG yum repository. It will also install fuse and autofs if you do not have them, and it will install the configuration for the OSG CVMFS distribution which is called OASIS. To simplify installation, OSG provides convenience RPMs that install all required software with a single command.

1. Clean yum cache:

        ::console
        root@host # yum clean all --enablerepo=*

2. Update software:

        :::console
        root@host # yum update
    This command will update **all** packages

3. Install CVMFS software:

        :::console
        root@host # yum install osg-oasis

## Automount setup

CVMFS uses automount, and the steps to configure it are different on EL6 vs EL7. Follow the section that is appropriate for your host's OS:

* [For EL6 hosts](#for-el6-hosts)
* [For EL7 hosts](#for-el7-hosts)

### For EL6 hosts

1. If automount is not yet in use on the system, do the following:

        :::console
        root@host # chkconfig autofs on
        root@host # service autofs start

1. Create or edit `/etc/auto.master` to have the following contents to enable automounting cvmfs:

        /cvmfs /etc/auto.cvmfs

1. Restart autofs to make the change take effect:

        :::console
        root@host # service autofs restart

### For EL7 hosts

1. If automount is not yet in use on the system, do the following:

        :::console
        root@host # systemctl enable autofs
        root@host # systemctl start autofs

1. Put the following in `/etc/auto.master.d/cvmfs.autofs`:

        /cvmfs /etc/auto.cvmfs
      
1. Restart autofs to make the change take effect:

        :::console
        root@host # systemctl restart autofs


## Configuring CVMFS

Create or edit `/etc/cvmfs/default.local`, a file that controls the
CVMFS configuration. Below is a sample configuration, but please note
that you will need to **edit the parts in %RED%red%ENDCOLOR%**. In
particular, the `CVMFS_HTTP_PROXY` line below must be edited for your
site.

```
CVMFS_REPOSITORIES="`echo $((echo oasis.opensciencegrid.org;echo cms.cern.ch;ls /cvmfs)|sort -u)|tr ' ' ,`"
CVMFS_QUOTA_LIMIT=%RED%20000%ENDCOLOR%
CVMFS_HTTP_PROXY=%RED%"http://squid.example.com:3128"%ENDCOLOR%
```

CVMFS by default allows any repository to be mounted, no matter what
the setting of `CVMFS_REPOSITORIES` is; that variable is used by support
tools such as `cvmfs_config` and `cvmfs_talk` when they need to know a
list of repositories.  The recommended `CVMFS_REPOSITORIES` setting
above is so that those tools will use two common repositories plus any
additional that have been mounted.  You may want to choose a different
set of always-known repositories.

Set up a list of CVMFS HTTP proxies to retrieve from in
`CVMFS_HTTP_PROXY`. If you do not have any squid at your site follow
the instructions to [install squid from OSG](../data/frontier-squid).
Vertical bars separating proxies means to load balance between them
and try them all before continuing. A semicolon between proxies means
to try that one only after the previous ones have failed. A special
proxy called DIRECT can be placed last in the list to indicate
directly connecting to servers if all other proxies fail. A DIRECT
proxy is acceptable for small sites but discouraged for large sites
because of the potential load that could be put upon globally shared
servers.

Set up the cache limit in `CVMFS_QUOTA_LIMIT` (in MegaBytes). The
recommended value for most applications is 20000 MB. This is the
combined limit for all but the osgstorage.org repositories. This cache
will be stored in `/var/lib/cvmfs` by default; to override the
location, set `CVMFS_CACHE_BASE` in `/etc/cvmfs/default.local`. Note
that an additional 1000 MB is allocated for a separate osgstorage.org
repositories cache in `$CVMFS_CACHE_BASE/osgstorage`. To be safe, make
sure that at least 20% more than `$CVMFS_QUOTA_LIMIT` + 1000 MB of space
stays available for CVMFS in that filesystem. This is very important,
since if that space is not available it can cause many I/O errors and
application crashes. Many system administrators choose to put the
cache space in a separate filesystem, which is a good way to manage
it.

!!! warning
    If you use SELinux and change `CVMFS_CACHE_BASE`, then the
    new cache directory must be labelled with SELinux type
    `cvmfs_cache_t`. This can be done by executing the following command:

        :::console
        user@host $ chcon -R -t cvmfs_cache_t %RED%$CVMFS_CACHE_BASE%ENDCOLOR%

## Validating CVMFS

After CVMFS is installed, you should be able to see the `/cvmfs`
directory. But note that it will initially appear to be empty:

```console
user@host $ ls /cvmfs
user@host $
```

Directories within `/cvmfs` will not be mounted until you examine them. For instance:

```console
user@host $ ls /cvmfs
user@host $ ls -l /cvmfs/atlas.cern.ch
total 1
drwxr-xr-x 8 cvmfs cvmfs 3 Apr 13 14:50 repo
user@host $ ls -l /cvmfs/oasis.opensciencegrid.org/cmssoft
total 1
lrwxrwxrwx 1 cvmfs cvmfs 18 May 13  2015 cms -> /cvmfs/cms.cern.ch
user@host $ ls -l /cvmfs/glast.egi.eu
total 5
drwxr-xr-x 9 cvmfs cvmfs 4096 Feb  7  2014 glast
user@host $ ls -l /cvmfs/nova.osgstorage.org
total 6
lrwxrwxrwx 1 cvmfs cvmfs   43 Jun 14  2016 analysis -> pnfs/fnal.gov/usr/nova/persistent/analysis/
lrwxrwxrwx 1 cvmfs cvmfs   32 Jan 19 11:40 flux -> pnfs/fnal.gov/usr/nova/data/flux
drwxr-xr-x 3 cvmfs cvmfs 4096 Jan 19 11:39 pnfs
user@host $ ls /cvmfs
atlas.cern.ch                   glast.egi.eu         oasis.opensciencegrid.org
config-osg.opensciencegrid.org  nova.osgstorage.org
```

### Troubleshooting problems

If no directories exist under `/cvmfs/`, you can try the following
steps to debug:

- Mount it manually with `mkdir -p /mnt/cvmfs` and then
  `mount -t cvmfs REPOSITORYNAME /mnt/cvmfs` where REPOSITORYNAME is
  the repository, for example config-osg.opensciencegrid.org (which is
  the best one to try first because other repositories require it to
  be mounted).  If this works, then CVMFS is working, but there is a
  problem with automount.
-  If that doesn't work and doesn't give any explanatory errors, try
   `cvmfs_config chksetup` or `cvmfs_config showconfig REPOSITORYNAME`
   to verify your setup.
- If chksetup reports access problems to proxies, it may be caused by
  access control settings in the squids.
- If you have changed settings in `/etc/cvmfs/default.local`, and they
  do not seem to be taking effect, note that there are other
  configuration files that can override the settings. See the comments
  at the beginning of `/etc/cvmfs/default.conf` regarding the order in
  which configuration files are evaluated and look for old files that
  may have been left from a previous installation.
- More things to try are in the
  [upstream documentation](http://cernvm.cern.ch/portal/filesystem/debugmount).

## Starting and Stopping services

Once it is set up, CVMFS is always automatically started when one of
the repositories are accessed; there are no system services to start.

CVMFS can be stopped via:

```console
root@host # cvmfs_config umount
Unmounting /cvmfs/config-osg.opensciencegrid.org: OK
Unmounting /cvmfs/atlas.cern.ch: OK
Unmounting /cvmfs/oasis.opensciencegrid.org: OK
Unmounting /cvmfs/glast.egi.eu: OK
Unmounting /cvmfs/nova.osgstorage.org: OK
```

## How to get Help?

If you cannot resolve the problem, there are several ways to receive help:

- For bug reporting and OSG-specific issues, see our [help procedure](../common/help)
- For community support and best-effort software team support contact
   <osg-cvmfs@opensciencegrid.org>.
- For general CERN VM FileSystem support contact <cernvm.support@cern.ch>.

## References

-  <http://cernvm.cern.ch/portal/filesystem/techinformation>
-  <https://cvmfs.readthedocs.io/en/latest/>

### Users and Groups

This installation will create one user unless it already exists

| User    | Comment                   |
|:--------|:--------------------------|
| `cvmfs` | CernVM-FS service account |

The installation will also create a cvmfs group and default the cvmfs
user to that group. In addition, if the fuse rpm is not for some
reason already installed, installing cvmfs will also install fuse and
that will create another group:

| Group   | Comment                   | Group members |
|:--------|:--------------------------|:--------------|
| `cvmfs` | CernVM-FS service account | none          |
| `fuse`  | FUSE service account      | `cvmfs`       |

