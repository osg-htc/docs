Installing and Using the XRootD Client 
==============================================

XRootD is a high performance data system widely used by several science VOs on OSG to store and to distribute data to
jobs.
It can be used to create a data store from distributed data nodes or to serve data to systems using a distributed
caching architecture.
Either mode of operation requires you to install the XRootD client software.

This page provides instructions for installing and using the XRootD client software to access data using XRootD.

As a user you have three different ways to interact with XRootD: 

1. Using the XRootD client tools command 
1. Using LD\_PRELOAD to use XRootD libraries with Unix tools
1. Using a XRootDFS FUSE mount to mount a local XRootD data store

We'll show how to install the XRootD client software and use all three mechanisms to access data.

!!! Note
    Only the client tools method should be used to access XRootD systems across a WAN link.


Before Starting
---------------

Before starting the installation process, consider the following points *if you are using a FUSE mount to access
XRootD:*

-   **User IDs:** If it does not exist already, you will need to create Linux users `xrootd` 

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](/docs/release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](/docs/common/yum)
- Install [CA certificates](/docs/common/ca)


Installing the XRootD Software
------------------------------

If you are planning on interacting with XRootD using the XRootD client tools  or LD\_PRELOAD, then you'll only need to install the XRootD
client RPM.
Mounting a XRootD data store using FUSE will require installing the XRootD FUSE rpm and the client rpm.

### Installing the XRootD Client RPM

The XRootD client rpm is needed to access XRootD using `xrdcp` or POSIX preload.  
The following steps will install the software on your system.

1. Clean yum cache:

        ::console
        root@host # yum clean all --enablerepo=\*

1. Update software:

        :::console
        root@host # yum update

    This command will update **all** packages

1. Install XRootD Client rpm:

        :::console
        root@host # yum install xrootd-client


### Installing the XRootD FUSE RPM

The XRootD FUSE rpm is only needed if you are planning on mounting a local XRootD data store.
If you are planning on using a FUSE mount, you'll need to install the client rpm as outlined above and also run the following command:

1. Install XRootD FUSE rpm:

        :::console
        root@host # yum install xrootd-fuse


Configuring the XRootD Client Software
--------------------------------------

Once the appropriate RPM(s) are installed, only the FUSE setup will need further configuration.
See [this](/docs/data//install-xrootd#optional-enabling-a-fuse-mount) for instructions on updating your `fstab` file.


Using the XRootD Client Software
----------------------------------

### Using the XRootD client tools

Once the `xrootd-client` rpm is installed, you should be able to use the `xrdcp` command to copy files to and from
XRootD systems and the local file system.
For example:

``` console
user@host # echo "This is a test" >/tmp/test 
user@host # xrdcp /tmp/test xroot://redirector.domain.org:1094//storage/path/test 
user@host # xrdcp xroot://redirector.domain.org:1094//storage/path/test /tmp/test1 
user@host # diff /tmp/test1 /tmp/test 
```

For other operations, you'll need to use the `xrdfs` command.
This command allows you to do file operations such as creating directories, removing directories, deleting files, and
moving files on a XRootD system, provided you have the appropriate authorization.
The `xrdfs` command can be used interactively by running `xrdfs xroot://redirector.domain.org:1094/`.
Alternatively, you can use it in batch mode by adding the `xrdfs` command after the xroot URI.  For example:

``` console
user@host # echo "This is a test" >/tmp/test 
user@host # xrdfs xroot://redirector.domain.org:1094/  mkdir  /storage/path/test
user@host # xrdcp xroot://redirector.domain.org:1094//storage/path/test/test1 /tmp/test1 
user@host # xrdfs xroot://redirector.domain.org:1094/  ls  /storage/path/test/test1
user@host # xrdfs xroot://redirector.domain.org:1094/  rm  /storage/path/test/test1
user@host # xrdfs xroot://redirector.domain.org:1094/  rmdir  /storage/path/test
```


!!! Note
    To access remote XRootD resources, you will may need to use a VOMS proxy in order to authenticate successfully.  The
    XRootD client tools will automatically locate your proxy if you generate it using `voms-proxy-init`, otherwise you
    can set the `X509_USER_PROXY` environment variable to the location of the proxy XRootD should use.

### Using LD\_PRELOAD method

In order to use the LD\_PRELOAD method to access a XRootD data store, you'll need to change your environment to use the
XRootD libraries in conjunction with the standard Unix binaries.
This is done by setting the `LD_PRELOAD` environment variable.
Once this is done, the standard unix commands like `mkdir`, `rm`, `cp`, etc. will work with xroot URIs.
For example:

``` console
user@host # export LD_PRELOAD=/usr/lib64/libXrdPosixPreload.so 
user@host # echo "This is a new test" >/tmp/test 
user@host # mkdir xroot://redirector.yourdomain.org:1094//storage/path/subdir
user@host # cp /tmp/test xroot://redirector.yourdomain.org:1094//storage/path/subdir/test 
user@host # cp xuser://redirector.yourdomain.org:1094//storage/path/subdir/test /tmp/test1 
user@host # diff /tmp/test1 /tmp/test 
user@host # rm xroot://redirector.yourdomain.org:1094//storage/path/subdir/test 
user@host # rmdir xroot://redirector.yourdomain.org:1094//storage/path/subdir
```

### Using the XRootDFS FUSE Mount

The directory mounted using XRootDFS can be used as any other directory mounted on your file system. 
All the normal Unix commands should work out of the box.
Try using `cp`, `rm`, `mv`, `mkdir`, `rmdir`.

Assuming your mount is `/mnt/xrootd`:

``` console
user@host # echo "This is a new test" >/tmp/test 
user@host # mkdir -p /mnt/xrootd/subdir/sub2
user@host # cp /tmp/test /mnt/xrootd/subdir/sub2/test 
user@host # cp /mnt/xrootd/subdir/sub2/test /mnt/xrootd/subdir/sub2/test1 
user@host # cp /mnt/xuserd/subdir/sub2/test1 /tmp/test1 
user@host # diff /tmp/test1 /tmp/test 
user@host # rm -r /mnt/xrootd/subdir
```

Validation
----------

You can validate your XRootD client installation by copying an example file from XRootD to the local file system.

### XRootD client software

Assuming that there is a file called `test_file` in your XRootD data store:

``` console
user@host # xrdcp xroot://redirector.yourdomain.org:1094//storage/path/test_file /tmp/test1
```

### LD\_PRELOAD

Assuming that there is a file called `test_file` in your XRootD data store:

``` console
user@host # export LD_PRELOAD=/usr/lib64/libXrdPosixPreload.so
user@host # cp xroot://redirector.yourdomain.org:1094//storage/path/test_file /tmp/test1
```


### XRootDFS FUSE Mount

Assuming your mount is `/mnt/xrootd` and that there is a file called `test_file` in your XRootD data store:

``` console
user@host # cp /mnt/xrootd/test_file /tmp/test1
```


How to get Help?
----------------

If you cannot resolve the problem, the best way to get help is by contacting <osg-software@opensciencegrid.org>.
For a full set of help options, see [Help Procedure](../common/help).

