Using XRootD 
=============

!!!bug "EL7 version compatibility"
    There is an incompatibility with EL7 < 7.5 due to an issue with the `globus-gsi-proxy-core` package


XRootD is a high performance data system widely used by several science VOs on OSG to store and to distribute data to
jobs.
It can be used to create a data store from distributed data nodes or to serve data to systems using a distributed
caching architecture.
Either mode of operation requires you to install the XRootD client software.

This page provides instructions for accessing data on XRootD data systems using a variety of methods.

As a user you have three different ways to interact with XRootD: 

1. [Using the XRootD clients](#using-the-xrootd-client-software)
1. [Using a XRootDFS FUSE mount to access a local XRootD data store](#using-xrootdfs-fuse-mount)
1. [Using LD\_PRELOAD to use XRootD libraries with Unix tools](#using-ld95preload-to-access-xrootd)

We'll show how to install the XRootD client software and use all three mechanisms to access data.

!!! Note
    Only the client tools method should be used to access XRootD systems across a WAN link.


Before Starting
---------------

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../../release/supported_platforms.md)
- Obtain root access to the host
- Prepare the [required Yum repositories](../../common/yum.md)
- Install [CA certificates](../../common/ca.md)

If you are using the FUSE mount, you should also consider the following requirement:

-   **User IDs:** If it does not exist already, you will need to create a `xrootd` user


Using the XRootD client software
------------------------------------------------

### Installing the XRootD Client 

If you are planning on interacting with XRootD using the XRootD client, then you'll need to install the XRootD
client RPM.

### Installing the XRootD Client RPM

The following steps will install the rpm on your system.

1. Clean yum cache:

        ::console
        root@client $ yum clean all --enablerepo=\*

1. Update software:

        :::console
        root@client $ yum update

    This command will update **all** packages

1. Install XRootD Client rpm:

        :::console
        root@client $ yum install xrootd-client

### Using the XRootD Client 

Once the `xrootd-client` rpm is installed, you should be able to use the `xrdcp` command to copy files to and from
XRootD systems and the local file system.
For example:

``` console
user@client $ echo "This is a test" >/tmp/test 
user@client $ xrdcp /tmp/test xroot://redirector.domain.org:1094//storage/path/test 
user@client $ xrdcp xroot://redirector.domain.org:1094//storage/path/test /tmp/test1 
user@client $ diff /tmp/test1 /tmp/test 
```

For other operations, you'll need to use the `xrdfs` command.
This command allows you to do file operations such as creating directories, removing directories, deleting files, and
moving files on a XRootD system, provided you have the appropriate authorization.
The `xrdfs` command can be used interactively by running `xrdfs xroot://redirector.domain.org:1094/`.
Alternatively, you can use it in batch mode by adding the `xrdfs` command after the xroot URI.  For example:

``` console
user@client $ echo "This is a test" >/tmp/test 
user@client $ xrdfs xroot://redirector.domain.org:1094/  mkdir  /storage/path/test
user@client $ xrdcp xroot://redirector.domain.org:1094//storage/path/test/test1 /tmp/test1 
user@client $ xrdfs xroot://redirector.domain.org:1094/  ls  /storage/path/test/test1
user@client $ xrdfs xroot://redirector.domain.org:1094/  rm  /storage/path/test/test1
user@client $ xrdfs xroot://redirector.domain.org:1094/  rmdir  /storage/path/test
```


!!! Note
    To access remote XRootD resources, you will may need to use a VOMS proxy in order to authenticate successfully.  The
    XRootD client tools will automatically locate your proxy if you generate it using `voms-proxy-init`, otherwise you
    can set the `X509_USER_PROXY` environment variable to the location of the proxy XRootD should use.

### Validation

Assuming that there is a file called `test_file` in your XRootD data store, you can do the following to validate your
installation.  Here we assume that there is a file on your XRootD system at `/storage/path/test_file`.

``` console
user@client $ xrdcp xroot://redirector.yourdomain.org:1094//storage/path/test_file /tmp/test1
```


Using XRootDFS FUSE mount
-----------------------------------------

This section will explain how to install, setup, and interact with XRootD using a FUSE mount.
This method of accessing XRootD only works when accessing a local XRootD system.

### Installing the XRootD FUSE RPM

If you are planning on using a FUSE mount, you'll need to install the xrootd-fuse rpm by running the following commands:

1. Clean yum cache:

        ::console
        root@client $ yum clean all --enablerepo=\*

1. Update software:

        :::console
        root@client $ yum update

1. Install XRootD FUSE rpm:

        :::console
        root@client $ yum install xrootd-fuse

### Configuring the FUSE Mount 

Once the appropriate rpms are installed, the FUSE setup will need further configuration.
See [this](install-storage-element.md#optional-enabling-a-fuse-mount) for instructions on updating your
`fstab` file.

### Using the XRootDFS FUSE Mount

The directory mounted using XRootDFS can be used as any other directory mounted on your file system. 
All the normal Unix commands should work out of the box.
Try using `cp`, `rm`, `mv`, `mkdir`, `rmdir`.

Assuming your mount is `/mnt/xrootd`:

``` console
user@client $ echo "This is a new test" >/tmp/test 
user@client $ mkdir -p /mnt/xrootd/subdir/sub2
user@client $ cp /tmp/test /mnt/xrootd/subdir/sub2/test 
user@client $ cp /mnt/xrootd/subdir/sub2/test /mnt/xrootd/subdir/sub2/test1 
user@client $ cp /mnt/xuserd/subdir/sub2/test1 /tmp/test1 
user@client $ diff /tmp/test1 /tmp/test 
user@client $ rm -r /mnt/xrootd/subdir
```

### Validation

Assuming your mount is `/mnt/xrootd` and that there is a file called `test_file` in your XRootD data store:

``` console
user@client $ cp /mnt/xrootd/test_file /tmp/test1
```


Using LD\_PRELOAD to access XRootD
-----------------------------------

### Installing XRootD Libraries For LD\_PRELOAD

In order to use LD\_PRELOAD to access XRootD, you'll need to install the XRootD client libraries.  
The following steps will install them on your system:

1. Clean yum cache:

        ::console
        root@client $ yum clean all --enablerepo=\*

1. Update software:

        :::console
        root@client $ yum update

    This command will update **all** packages

1. Install XRootD Client rpm:

        :::console
        root@client $ yum install xrootd-client



### Using LD\_PRELOAD method

In order to use the LD\_PRELOAD method to access a XRootD data store, you'll need to change your environment to use the
XRootD libraries in conjunction with the standard Unix binaries.
This is done by setting the `LD_PRELOAD` environment variable.
Once this is done, the standard unix commands like `mkdir`, `rm`, `cp`, etc. will work with xroot URIs.
For example:

``` console
user@client $ export LD_PRELOAD=/usr/lib64/libXrdPosixPreload.so 
user@client $ echo "This is a new test" >/tmp/test 
user@client $ mkdir xroot://redirector.yourdomain.org:1094//storage/path/subdir
user@client $ cp /tmp/test xroot://redirector.yourdomain.org:1094//storage/path/subdir/test 
user@client $ cp xuser://redirector.yourdomain.org:1094//storage/path/subdir/test /tmp/test1 
user@client $ diff /tmp/test1 /tmp/test 
user@client $ rm xroot://redirector.yourdomain.org:1094//storage/path/subdir/test 
user@client $ rmdir xroot://redirector.yourdomain.org:1094//storage/path/subdir
```

### Validation

Assuming that there is a file called `test_file` in your XRootD data store, the following steps will validate your
installation:

``` console
user@client $ export LD_PRELOAD=/usr/lib64/libXrdPosixPreload.so
user@client $ cp xroot://redirector.yourdomain.org:1094//storage/path/test_file /tmp/test1
```


How to get Help?
----------------

If you cannot resolve the problem, the best way to get help is by contacting <osg-software@opensciencegrid.org>.
For a full set of help options, see [Help Procedure](../../common/help.md).

