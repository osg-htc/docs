
Install XRootd Client 
=====================

XRootD is a high performance network storage system widely used in high energy physics experiments such as ATLAS and ALICE. The underlying XRootD data transfer protocol provides highly efficient access to ROOT based data files.

This page provides instructions for using a XRootD client to connect to a XRootD storage system.

Installing a XRootD Client
--------------------------

As a user you have three different ways to interact with XRootd: a file system mounted with XRootDFS, the application `xrdcp`, LD\_PRELOAD.

To use a XRootD file system mounted with XRootDFS you don't need any special setup, you will need the XRootD FUSE module.

To use `xrdcp` you need to have it in your path (e.g. `source $INSTALL_DIR/setup.sh`, where `$INSTALL_DIR` is the XRootD installation directory)

The use of LD\_PRELOAD is not recommended if you have any alternative available.

### Install Repositories 

If you have not done so, you will need to install the [proper yum repositories](../common/yum):


### Installing XRootD Client

The XRootD client is needed to access XRootD via `xrdcp` or via POSIX preload.

``` console
root@host # yum install xrootd-client
```

### Installing XRootD Fuse

The XRootD fuse package is needed to access via XRootDFS.

``` console
root@host # yum install xrootd-fuse
```

Using the XRootD Client Mechanisms
----------------------------------

### Using the xrdcp client

From the redirector node, you can run this:

``` console
root@host # echo "This is a test" >/tmp/test 
root@host # xrdcp /tmp/test xroot://redirector.yourdomain.org:1094//storage/path/test 
root@host # xrdcp xroot://redirector.yourdomain.org:1094//storage/path/test /tmp/test1 
root@host # diff /tmp/test1 /tmp/test 
```

Users can write in their own space. E.g. a user with Unix account name `myuser` (the account must exist, eg. in `/etc/passwd`, etc, on the redirector and on all the data servers) could save a file in XRootD:

``` console
root@host # echo "This is a user test" >/tmp/test 
root@host # xrdcp /tmp/test xroot://redirector.yourdomain.org:1094//storage/path/myuser/test 
```

Note that `xrdcp` creates missing directories.

### Tests using the libXrdPosixPreload library

Using XRootD with the POSIX preload library (replace `/usr/lib64` with `/usr/lib` on 32-bit systems)

``` console
root@host # export LD_PRELOAD=/usr/lib64/libXrdPosixPreload.so 
root@host # echo "This is a new test" >/tmp/test 
root@host # mkdir xroot://redirector.yourdomain.org:1094//storage/path/subdir
root@host # cp /tmp/test xroot://redirector.yourdomain.org:1094//storage/path/subdir/test 
root@host # cp xroot://redirector.yourdomain.org:1094//storage/path/subdir/test /tmp/test1 
root@host # diff /tmp/test1 /tmp/test 
root@host # rm xroot://redirector.yourdomain.org:1094//storage/path/subdir/test 
root@host # rmdir xroot://redirector.yourdomain.org:1094//storage/path/subdir
```

### Tests using XRootDFS

The directory mounted using XRootDFS can be used as any other directory mounted on your file system. All the normal Unix commands should work. You don't need any special setup or library. Try using `cp`, `rm`, `mv`, `mkdir`, `rmdir`.

Assuming your mount is `/mnt/xrootd`:

``` console
root@host # echo "This is a new test" >/tmp/test 
root@host # mkdir -p /mnt/xrootd/subdir/sub2
root@host # cp /tmp/test /mnt/xrootd/subdir/sub2/test 
root@host # cp /mnt/xrootd/subdir/sub2/test /mnt/xrootd/subdir/sub2/test1 
root@host # cp /mnt/xrootd/subdir/sub2/test1 /tmp/test1 
root@host # diff /tmp/test1 /tmp/test 
root@host # rm -r /mnt/xrootd/subdir
```

How to get Help?
----------------

If you cannot resolve the problem, the best way to get help is by contacting <osg-software@opensciencegrid.org>.
For a full set of help options, see [Help Procedure](../common/help).

