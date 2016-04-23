
Install CVMFS
=============

Here we describe how to install the [CVMFS](http://cernvm.cern.ch/portal/filesystem) (Cern-VM file system) client.
This document is intended for system administrators who wish to install this client to have access to files distributed
by cvmfs servers via HTTP.

!!! note "Applicable versions"
    The applicable software versions for this document are OSG Version >= 3.2.22.
    The version of cvmfs installed should be >= 2.1.20-1.osg or greater.

Requirements
------------

### Host and OS

-  OS is RedHat 5, 6, 7 or variants
- `root` access
- `autofs` should be installed
- `fuse` should be installed (or will be as part of the installation)
-  Sufficient (~20GB+20%) cache space reserved, preferably in a separate filesystem (details [below](#4_3_Configuring_cvmfs))

### Users and Groups

This installation will create one user unless it already exists:


| User    | Comment                   |
|:--------|:--------------------------|
| `cvmfs` | CernVM-FS service account |

The installation will also create a cvmfs group and default the cvmfs user to that group. In addition, if the fuse rpm is not for some reason already installed, installing cvmfs will also install fuse and that will create another group:

| Group   | Comment                   | Group members |
|:--------|:--------------------------|:--------------|
| `cvmfs` | CernVM-FS service account | none          |
| `fuse`  | FUSE service account      | `cvmfs`       |

### Networking

You will need network access to a local squid server such as the [squid distributed by OSG](InstallFrontierSquid). The squid will need out-bound access to cvmfs stratum 1 servers.

### Upgrading

When upgrading to cvmfs 2.1.20, delete the setting of `CVMFS_SERVER_URL` in `/etc/cvmfs/domain.d/cern.ch.local`. If that's the only thing in the file (which is likely) then delete the whole file.

When upgrading from a cvmfs 2.0.X version, all `/cvmfs` repositories must be unmounted in order to upgrade. When upgrading between 2.1.X versions, repositories may be mounted.

Note that version 2.1 removed the `/etc/init.d/cvmfs` script. Starting it didn't actually do anything anyway (it is automatically starts when mounted), and the stop function has been moved to `cvmfs_config umount`.
The `restartautofs` function is instead done by `service autofs restart`. The `probe` function has also been moved to `cvmfs_config probe`. Since 2.1.X enables shared cache by default, so in order to reclaim the previous cache space when upgrading from 2.0.X you must manually remove the old caches. For example

```
rm -rf /var/cache/cvmfs/*.*
```

Install Instructions
--------------------

Prior to installing CVMFS, make sure the [yum repositories](../Common/yum.md) are correctly configured for OSG.

The following will install cvmfs from the OSG repository. It will also install cern public keys as well as fuse and autofs if you do not have them, and it will install the configuration for the OSG CVMFS distribution, OASIS.

```
yum install osg-oasis
```

Create or edit `/etc/fuse.conf`. It should contain the following in order to allow fuse to do proper file ownership:

```
user_allow_other
```

Create or edit `/etc/auto.master`. It should contain the following in order to allow cvmfs to automount:

```
/cvmfs /etc/auto.cvmfs
```

Restart autofs to make the change take effect:

``` rootscreen
service autofs restart
Stopping automount:                       [  OK  ]
Starting automount:                       [  OK  ]
```

Create or edit `/etc/cvmfs/default.local`, a file that controls the cvmfs configuration.
Below is a sample configuration, **but please note** that you will need to customize this for your site. (In particular, the `CVMFS_HTTP_PROXY` line below only works within the .fnal.gov domain.)

```
CVMFS_REPOSITORIES="`echo $((echo oasis.opensciencegrid.org;echo cms.cern.ch;ls /cvmfs)|sort -u)|tr ' ' ,`"
CVMFS_CACHE_BASE=/var/cache/cvmfs
CVMFS_QUOTA_LIMIT=20000
CVMFS_HTTP_PROXY="http://squid.fnal.gov:3128"
```

CVMFS 2.1 by default allows any repository to be mounted. The recommended CVMFS\_REPOSITORIES setting is what it is above so that tools such as `cvmfs_config` and `cvmfs_talk` that use known repositories will use two common repositories plus any additional that have been mounted. You may want to choose a different set of always-known repositories. A full list of cern.ch repositories is found at <http://cernvm.cern.ch/portal/cvmfs/examples>. The only opensciencegrid.org repository is currently oasis.

Set up a list of cvmfs HTTP proxies to retrieve from in CVMFS\_HTTP\_PROXY. Vertical bars separating proxies means to load balance between them and try them all before continuing. A semicolon between proxies means to try that one only after the previous ones have failed. A special proxy called DIRECT can be placed last in the list to indicate directly connecting to servers if all other proxies fail. This is acceptable for small sites but discouraged for large sites because of the potential load that could be put upon the stratum one servers.

Set up the cache limit in `CVMFS_QUOTA_LIMIT` (in MB). Recommended for most applications is 20GB. This is the combined limit for all repositories. This cache will be stored in `$CVMFS_CACHE_BASE`. Make sure that at least 20% more than that amount of space stays available for cvmfs in that filesystem. This is very important, since if that space is not available it can cause many I/O errors and application crashes. Many system administrators choose to put the cache space in a separate filesystem.

Verifying cvmfs
---------------

After CVMFS is installed, you should be able to see the `/cvmfs` directory. But note that it will initially appear to be empty:

```
$ ls /cvmfs

```

Directories within `/cvmfs` will not be mounted until you examine them. For instance:

```
# ls -l /cvmfs/atlas.cern.ch
/cvmfs/atlas.cern.ch:
total 5
drwxr-xr-x 1 cvmfs cvmfs 4096 Mar  5  2012 repo
# ls -l /cvmfs/oasis.opensciencegrid.org/cmssoft
/cvmfs/oasis.opensciencegrid.org/cmssoft:
total 1
lrwxrwxrwx 1 cvmfs cvmfs 18 May 28 10:33 cms -> /cvmfs/cms.cern.ch
# ls -l /cvmfs/glast.egi.eu
total 5
drwxr-xr-x 9 cvmfs cvmfs 4096 Feb  7  2014 glast
# ls /cvmfs
atlas.cern.ch  cms.cern.ch  glast.egi.eu  oasis.opensciencegrid.org
```

Troubleshooting problems
------------------------

If no directories exist under `/cvmfs/`, you can try the following steps to debug:

-   Mount it manually `mkdir /mnt/cvmfs` then `mount -t cvmfs REPOSITORYNAME /mnt/cvmfs` where `REPOSITORYNAME` is the repository, for example `oasis.opensciencegrid.org`. If this works, then cvmfs is working, but there is a problem with automount.
-   If that doesn't work and doesn't give any explanatory errors, try `cvmfs_config chksetup` or `cvmfs_config showconfig REPOSITORYNAME` to verify your setup.
-   If chksetup reports access problems to proxies, it may be caused by access control settings in the squids.
-   If you have changed settings in `/etc/cvmfs/default.local`, and they do not seem to be taking effect, note that there are other configuration files that can override the settings. See the comments at the beginning of `/etc/cvmfs/default.conf` regarding the order in which configuration files are evaluated and look for old files that may have been left from a previous installation.
-   More things to try are in the [upstream documentation](http://cernvm.cern.ch/portal/filesystem/debugmount).

### Starting and Stopping services

Once it is set up, cvmfs is always automatically started when one of the repositories are accessed.

cvmfs can be stopped via:

```
# cvmfs_config umount
Unmounting /cvmfs/atlas.cern.ch: OK
Unmounting /cvmfs/oasis.opensciencegrid.org: OK
Unmounting /cvmfs/cms.cern.ch: OK
Unmounting /cvmfs/glast.egi.eu: OK
```

### Screendump of Install

```
[root@fermicloud044 ~]# rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
Retrieving http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
Preparing...                ########################################### [100%]
   1:epel-release           ########################################### [100%]
[root@fermicloud044 ~]# yum install yum-priorities
Loaded plugins: security
epel/metalink                                            |  15 kB     00:00     
epel                                                     | 4.4 kB     00:00     
epel/primary_db                                          | 6.5 MB     00:02     
Setting up Install Process
Resolving Dependencies
--> Running transaction check
---> Package yum-plugin-priorities.noarch 0:1.1.30-14.el6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                     Arch         Version               Repository
                                                                           Size
================================================================================
Installing:
 yum-plugin-priorities       noarch       1.1.30-14.el6         slf        21 k

Transaction Summary
================================================================================
Install       1 Package(s)

Total download size: 21 k
Installed size: 28 k
Is this ok [y/N]: y
Downloading Packages:
yum-plugin-priorities-1.1.30-14.el6.noarch.rpm           |  21 kB     00:00     
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing : yum-plugin-priorities-1.1.30-14.el6.noarch                   1/1 
  Verifying  : yum-plugin-priorities-1.1.30-14.el6.noarch                   1/1 

Installed:
  yum-plugin-priorities.noarch 0:1.1.30-14.el6                                  

Complete!
[root@fermicloud044 ~]# grep plugins /etc/yum.conf
plugins=1
[root@fermicloud044 ~]# rpm -Uvh http://repo.grid.iu.edu/osg/3.2/osg-3.2-el6-release-latest.rpm
Retrieving http://repo.grid.iu.edu/osg/3.2/osg-3.2-el6-release-latest.rpm
warning: /var/tmp/rpm-tmp.C1YSbQ: Header V3 DSA/SHA1 Signature, key ID 824b8603: NOKEY
Preparing...                ########################################### [100%]
   1:osg-release            ########################################### [100%]
[root@fermicloud044 ~]# yum install osg-oasis
Loaded plugins: priorities, security
osg                                                      | 1.9 kB     00:00     
osg/primary_db                                           | 1.9 MB     00:00     
342 packages excluded due to repository priority protections
Setting up Install Process
Resolving Dependencies
--> Running transaction check
---> Package osg-oasis.noarch 0:5-1.osg32.el6 will be installed
--> Processing Dependency: cvmfs-config-osg >= 1.1 for package: osg-oasis-5-1.osg32.el6.noarch
--> Processing Dependency: cvmfs >= 2.1.20 for package: osg-oasis-5-1.osg32.el6.noarch
--> Running transaction check
---> Package cvmfs.x86_64 0:2.1.20-1.osg32.el6 will be installed
--> Processing Dependency: libfuse.so.2(FUSE_2.4)(64bit) for package: cvmfs-2.1.20-1.osg32.el6.x86_64
--> Processing Dependency: /usr/sbin/semanage for package: cvmfs-2.1.20-1.osg32.el6.x86_64
--> Processing Dependency: libfuse.so.2(FUSE_2.6)(64bit) for package: cvmfs-2.1.20-1.osg32.el6.x86_64
--> Processing Dependency: fuse-libs for package: cvmfs-2.1.20-1.osg32.el6.x86_64
--> Processing Dependency: gdb for package: cvmfs-2.1.20-1.osg32.el6.x86_64
--> Processing Dependency: libfuse.so.2(FUSE_2.5)(64bit) for package: cvmfs-2.1.20-1.osg32.el6.x86_64
--> Processing Dependency: fuse for package: cvmfs-2.1.20-1.osg32.el6.x86_64
--> Processing Dependency: libfuse.so.2()(64bit) for package: cvmfs-2.1.20-1.osg32.el6.x86_64
---> Package cvmfs-config-osg.noarch 0:1.1-5.osg32.el6 will be installed
--> Running transaction check
---> Package fuse.x86_64 0:2.8.3-4.el6 will be installed
---> Package fuse-libs.x86_64 0:2.8.3-4.el6 will be installed
---> Package gdb.x86_64 0:7.2-60.el6 will be installed
---> Package policycoreutils-python.x86_64 0:2.0.83-19.30.el6 will be installed
--> Processing Dependency: libsemanage-python >= 2.0.43-4 for package: policycoreutils-python-2.0.83-19.30.el6.x86_64
--> Processing Dependency: audit-libs-python >= 1.4.2-1 for package: policycoreutils-python-2.0.83-19.30.el6.x86_64
--> Processing Dependency: setools-libs-python for package: policycoreutils-python-2.0.83-19.30.el6.x86_64
--> Processing Dependency: libselinux-python for package: policycoreutils-python-2.0.83-19.30.el6.x86_64
--> Processing Dependency: libcgroup for package: policycoreutils-python-2.0.83-19.30.el6.x86_64
--> Running transaction check
---> Package audit-libs-python.x86_64 0:2.2-2.el6 will be installed
---> Package libcgroup.x86_64 0:0.37-7.el6 will be installed
---> Package libselinux-python.x86_64 0:2.0.94-5.3.el6 will be installed
---> Package libsemanage-python.x86_64 0:2.0.43-4.2.el6 will be installed
---> Package setools-libs-python.x86_64 0:3.3.7-4.el6 will be installed
--> Processing Dependency: setools-libs = 3.3.7-4.el6 for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libqpol.so.1(VERS_1.3)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libpoldiff.so.1(VERS_1.3)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libapol.so.4(VERS_4.1)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libqpol.so.1(VERS_1.2)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libqpol.so.1(VERS_1.4)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libseaudit.so.4(VERS_4.2)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libpoldiff.so.1(VERS_1.2)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libsefs.so.4(VERS_4.0)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libapol.so.4(VERS_4.0)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libseaudit.so.4(VERS_4.1)(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libseaudit.so.4()(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libqpol.so.1()(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libapol.so.4()(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libpoldiff.so.1()(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Processing Dependency: libsefs.so.4()(64bit) for package: setools-libs-python-3.3.7-4.el6.x86_64
--> Running transaction check
---> Package setools-libs.x86_64 0:3.3.7-4.el6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                     Arch        Version                 Repository
                                                                           Size
================================================================================
Installing:
 osg-oasis                   noarch      5-1.osg32.el6           osg      2.4 k
Installing for dependencies:
 audit-libs-python           x86_64      2.2-2.el6               slf       58 k
 cvmfs                       x86_64      2.1.20-1.osg32.el6      osg      5.9 M
 cvmfs-config-osg            noarch      1.1-5.osg32.el6         osg      8.0 k
 fuse                        x86_64      2.8.3-4.el6             slf       70 k
 fuse-libs                   x86_64      2.8.3-4.el6             slf       73 k
 gdb                         x86_64      7.2-60.el6              slf      2.3 M
 libcgroup                   x86_64      0.37-7.el6              slf      110 k
 libselinux-python           x86_64      2.0.94-5.3.el6          slf      201 k
 libsemanage-python          x86_64      2.0.43-4.2.el6          slf       80 k
 policycoreutils-python      x86_64      2.0.83-19.30.el6        slf      341 k
 setools-libs                x86_64      3.3.7-4.el6             slf      399 k
 setools-libs-python         x86_64      3.3.7-4.el6             slf      221 k

Transaction Summary
================================================================================
Install      13 Package(s)

Total download size: 9.8 M
Installed size: 35 M
Is this ok [y/N]: y
Downloading Packages:
(1/13): audit-libs-python-2.2-2.el6.x86_64.rpm           |  58 kB     00:00     
(2/13): cvmfs-2.1.20-1.osg32.el6.x86_64.rpm              | 5.9 MB     00:00     
(3/13): cvmfs-config-osg-1.1-5.osg32.el6.noarch.rpm      | 8.0 kB     00:00     
(4/13): fuse-2.8.3-4.el6.x86_64.rpm                      |  70 kB     00:00     
(5/13): fuse-libs-2.8.3-4.el6.x86_64.rpm                 |  73 kB     00:00     
(6/13): gdb-7.2-60.el6.x86_64.rpm                        | 2.3 MB     00:00     
(7/13): libcgroup-0.37-7.el6.x86_64.rpm                  | 110 kB     00:00     
(8/13): libselinux-python-2.0.94-5.3.el6.x86_64.rpm      | 201 kB     00:00     
(9/13): libsemanage-python-2.0.43-4.2.el6.x86_64.rpm     |  80 kB     00:00     
(10/13): osg-oasis-5-1.osg32.el6.noarch.rpm              | 2.4 kB     00:00     
(11/13): policycoreutils-python-2.0.83-19.30.el6.x86_64. | 341 kB     00:00     
(12/13): setools-libs-3.3.7-4.el6.x86_64.rpm             | 399 kB     00:00     
(13/13): setools-libs-python-3.3.7-4.el6.x86_64.rpm      | 221 kB     00:00     
--------------------------------------------------------------------------------
Total                                           9.7 MB/s | 9.8 MB     00:01     
warning: rpmts_HdrFromFdno: Header V4 DSA/SHA1 Signature, key ID 824b8603: NOKEY
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
Importing GPG key 0x824B8603:
 Userid : OSG Software Team (RPM Signing Key for Koji Packages) <vdt-support@opensciencegrid.org>
 Package: osg-release-3.2-7.osg32.el6.noarch (installed)
 From   : /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
Is this ok [y/N]: y
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
Warning: RPMDB altered outside of yum.
  Installing : cvmfs-config-osg-1.1-5.osg32.el6.noarch                     1/13 
  Installing : setools-libs-3.3.7-4.el6.x86_64                             2/13 
  Installing : setools-libs-python-3.3.7-4.el6.x86_64                      3/13 
  Installing : fuse-libs-2.8.3-4.el6.x86_64                                4/13 
  Installing : libsemanage-python-2.0.43-4.2.el6.x86_64                    5/13 
  Installing : gdb-7.2-60.el6.x86_64                                       6/13 
  Installing : fuse-2.8.3-4.el6.x86_64                                     7/13 
  Installing : audit-libs-python-2.2-2.el6.x86_64                          8/13 
  Installing : libselinux-python-2.0.94-5.3.el6.x86_64                     9/13 
  Installing : libcgroup-0.37-7.el6.x86_64                                10/13 
  Installing : policycoreutils-python-2.0.83-19.30.el6.x86_64             11/13 
  Installing : cvmfs-2.1.20-1.osg32.el6.x86_64                            12/13 
  Installing : osg-oasis-5-1.osg32.el6.noarch                             13/13 
  Verifying  : libcgroup-0.37-7.el6.x86_64                                 1/13 
  Verifying  : libselinux-python-2.0.94-5.3.el6.x86_64                     2/13 
  Verifying  : audit-libs-python-2.2-2.el6.x86_64                          3/13 
  Verifying  : policycoreutils-python-2.0.83-19.30.el6.x86_64              4/13 
  Verifying  : fuse-2.8.3-4.el6.x86_64                                     5/13 
  Verifying  : cvmfs-config-osg-1.1-5.osg32.el6.noarch                     6/13 
  Verifying  : setools-libs-python-3.3.7-4.el6.x86_64                      7/13 
  Verifying  : gdb-7.2-60.el6.x86_64                                       8/13 
  Verifying  : osg-oasis-5-1.osg32.el6.noarch                              9/13 
  Verifying  : libsemanage-python-2.0.43-4.2.el6.x86_64                   10/13 
  Verifying  : cvmfs-2.1.20-1.osg32.el6.x86_64                            11/13 
  Verifying  : fuse-libs-2.8.3-4.el6.x86_64                               12/13 
  Verifying  : setools-libs-3.3.7-4.el6.x86_64                            13/13 

Installed:
  osg-oasis.noarch 0:5-1.osg32.el6                                              

Dependency Installed:
  audit-libs-python.x86_64 0:2.2-2.el6                                          
  cvmfs.x86_64 0:2.1.20-1.osg32.el6                                             
  cvmfs-config-osg.noarch 0:1.1-5.osg32.el6                                     
  fuse.x86_64 0:2.8.3-4.el6                                                     
  fuse-libs.x86_64 0:2.8.3-4.el6                                                
  gdb.x86_64 0:7.2-60.el6                                                       
  libcgroup.x86_64 0:0.37-7.el6                                                 
  libselinux-python.x86_64 0:2.0.94-5.3.el6                                     
  libsemanage-python.x86_64 0:2.0.43-4.2.el6                                    
  policycoreutils-python.x86_64 0:2.0.83-19.30.el6                              
  setools-libs.x86_64 0:3.3.7-4.el6                                             
  setools-libs-python.x86_64 0:3.3.7-4.el6                                      

Complete!
[root@fermicloud044 ~]# echo user_allow_other >>/etc/fuse.conf
[root@fermicloud044 ~]# echo "/cvmfs /etc/auto.cvmfs" >>/etc/auto.master
[root@fermicloud044 ~]# service autofs restart
Stopping automount:                                        [  OK  ]
Starting automount:                                        [  OK  ]
[root@fermicloud044 ~]# cat >/etc/cvmfs/default.local
CVMFS_REPOSITORIES="`echo $((echo oasis.opensciencegrid.org;echo cms.cern.ch;ls /cvmfs)|sort -u)|tr ' ' ,`"
CVMFS_CACHE_BASE=/var/cache/cvmfs
CVMFS_QUOTA_LIMIT=20000
CVMFS_HTTP_PROXY="http://squid.fnal.gov:3128"
[root@fermicloud044 ~]# ls /cvmfs
[root@fermicloud044 ~]# ls -l /cvmfs/atlas.cern.ch
total 5
drwxr-xr-x 6 cvmfs cvmfs 4096 Sep 12  2014 repo
[root@fermicloud044 ~]# ls -l /cvmfs/oasis.opensciencegrid.org/cmssoft
total 1
lrwxrwxrwx 1 cvmfs cvmfs 18 Mar 11  2014 cms -> /cvmfs/cms.cern.ch
[root@fermicloud044 ~]# ls -l /cvmfs/glast.egi.eu
total 5
drwxr-xr-x 9 cvmfs cvmfs 4096 Feb  7  2014 glast
[root@fermicloud044 ~]# ls /cvmfs
atlas.cern.ch  cms.cern.ch  glast.egi.eu  oasis.opensciencegrid.org
[root@fermicloud044 ~]# cvmfs_config umount
Unmounting /cvmfs/atlas.cern.ch: OK
Unmounting /cvmfs/oasis.opensciencegrid.org: OK
Unmounting /cvmfs/cms.cern.ch: OK
Unmounting /cvmfs/glast.egi.eu: OK
[root@fermicloud044 ~]# 
```

### File Locations

| Service/Process | Configuration File       | Description                                     |
|:----------------|:-------------------------|:------------------------------------------------|
| cvmfs           | /etc/cvmfs/default.local | cvmfs environment settings and repository setup |
| fuse            | /etc/fuse.conf           | fuse settings                                   |
| automount       | /etc/auto.master         | automount settings                              |

### How to get Help?

If you cannot resolve the problem, there are several ways to receive help:

-   For bug reporting and OSG-specific issues, submit a ticket to the [Grid Operations Center](https://ticket.grid.iu.edu/goc).
-   For community support and best-effort software team support contact <osg-cvmfs@opensciencegrid.org>.
-   For general CERN VM FileSystem support contact <cernvm.support@cern.ch>.

For a full set of help options, see [Help Procedure](HelpProcedure).

### References

-   <http://cernvm.cern.ch/portal/filesystem/techinformation>
-   <https://ecsft.cern.ch/dist/cvmfs/cvmfstech-2.1-6.pdf>


