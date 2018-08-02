Installing and Maintaining XRootD
=================================

[XRootD](http://xrootd.org/) is a hierarchical storage system that can be used in a variety of ways to access data,
typically distributed among actual storage resources. 
One way to use XRootD is to have it refer to many data resources at a single site, and another way to use it is to refer
to many storage systems, most likely distributed among sites.  An XRootD system includes a *redirector*, which accepts
requests for data and finds a storage repository — locally or
otherwise — that can provide the data to the requestor.

Use this page to learn how to install, configure, and use an XRootD redirector as part of a Storage Element (SE) or as
part of a global namespace.

Before Starting
---------------

Before starting the installation process, consider the following points:

-   **User IDs:** If it does not exist already, the installation will create the Linux user ID `xrootd`
-   **Service certificate:** The XRootD service uses a host certificate at `/etc/grid-security/host*.pem`
-   **Networking:** The XRootD service uses port 1094 by default

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

-   Ensure the host has [a supported operating system](../release/supported_platforms)
-   Obtain root access to the host
-   Prepare [the required Yum repositories](../common/yum)
-   Install [CA certificates](../common/ca)

Installing an XRootD Server
---------------------------

An installation of the XRootD server consists of the server itself and its dependencies. 
Install these with Yum:

``` console
root@host # yum install xrootd
```

Configuring an XRootD Server
----------------------------

### Minimal configuration

A new installation of XRootD is already configured to run a standalone server that serves files from `/tmp` on the local
file system. 
This configuration is useful to verify basic connectivity between your clients and your server. 
To do this, start the `xrootd` service with standalone config as described in the [managing services
section](#managing-xrootd-services).

You should be able now to copy a file such as `/bin/sh` using `xrdcp` command into `/tmp`. 
To test, do:

``` console
root@host # yum install xrootd-client
root@host # xrdcp /bin/sh root://localhost:1094//tmp/first_test
[xrootd] Total 0.76 MB  [====================] 100.00 % [inf MB/s]
root@host # ls -l /tmp/first_test
-rw-r--r-- 1 xrootd xrootd 801512 Apr 11 10:48 /tmp/first_test
```

Other than for testing, a standalone server is useful when you want to serve files off of a single host with lots of
large disks. 
If your storage capacity is spread out over multiple hosts, you will need to set up an XRootD cluster.

### Advanced configuration

An advanced XRootD setup has multiple components; it is important to validate that each additional component that you
set up is working before moving on to the next component. 
We have included validation instructions after each component below.

### Creating an XRootD cluster

![XRootD cluster](/img/xrootd.jpg)

If your storage is spread out over multiple hosts, you will need to set up an XRootD *cluster*. 
The cluster uses one "redirector" node as a frontend for user accesses, and multiple data nodes that have the data that
users request. 
Two daemons will run on each node:

`xrootd`<br/>
The eXtended Root Daemon controls file access and storage.

`cmsd`<br/>
The Cluster Management Services Daemon controls communication between nodes.

Note that for large virtual organizations, a site-level redirector may actually also communicate upwards to a regional
or global redirector that handles access to a multi-level hierarchy. 
This section will only cover handling one level of XRootD hierarchy.

In the instructions below, %RED%RDRNODE%ENDCOLOR% will refer to the redirector host and %RED%DATANODE%ENDCOLOR% will
refer to the data node host. 
These should be replaced with the fully-qualified domain name of the host in question.

#### Modify /etc/xrootd/xrootd-clustered.cfg

You will need to modify the `xrootd-clustered.cfg` on the redirector node and each data node. 
The following example should serve as a base configuration for clustering. Further customizations are detailed below.

``` file
all.export %RED%/tmp%ENDCOLOR% stage
set xrdr = %RED%RDRNODE%ENDCOLOR%
all.manager $(xrdr):3121

if $(xrdr)
  # Lines in this block are only executed on the redirector node
  all.role manager
else
  # Lines in this block are executed on all nodes but the redirector node
  all.role server
  cms.space min %RED%2g 5g%ENDCOLOR%
fi
```

You will need to customize the following lines:

| Configuration Line                     | Changes Needed                                                                                                                                                                                                                                                                      |
|:---------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `all.export %RED%/tmp%ENDCOLOR% stage` | Change `/tmp` to the directory to allow XRootD access to                                                                                                                                                                                                                            |
| `set xrdr=%RED%RDRNODE%ENDCOLOR%`      | Change to the hostname of the redirector                                                                                                                                                                                                                                            |
| `cms.space min %RED%2g 5g%ENDCOLOR%`   | Reserve this amount of free space on the node. For this example, if space falls below 2GB, xrootd will not store further files on this node until space climbs above 5GB. You can use `k`, `m`, `g`, or `t` to indicate kilobyte, megabytes, gigabytes, or terabytes, respectively. |

Further information can be found at <http://xrootd.slac.stanford.edu/doc>

#### Verifying the clustered config

Start both `xrootd` and `cmsd` on all nodes according to the instructions in the [managing services
section](#ManagingServices).

Verify that you can copy a file such as `/bin/sh` to `/tmp` on the server data via the redirector:

``` console
root@host # xrdcp /bin/sh  root://%RED%RDRNODE%ENDCOLOR%:1094///tmp/second_test
[xrootd] Total 0.76 MB  [====================] 100.00 % [inf MB/s]
```

Check that the `/tmp/second_test` is located on data server %RED%DATANODE%ENDCOLOR%.

### (Optional) Adding Simple Server Inventory to your cluster

The Simple Server Inventory (SSI) provide means to have an inventory for each data server. 
SSI requires:

-   A second instance of the `xrootd` daemon on the redirector
-   A "composite name space daemon" (`XrdCnsd`) on each data server; this daemon handles the inventory

As an example, we will set up a two-node XRootD cluster with SSI.

Host A is a redirector node that is running the following daemons:

1.  xrootd redirector
2.  cmsd
3.  xrootd - second instance that required for SSI

Host B is a data server that is running the following daemons:

1.  xrootd data server
2.  cmsd
3.  XrdCnsd - started automatically by xrootd

We will need to create a directory on the redirector node for Inventory files.

``` console
root@host # mkdir -p /data/inventory
root@host # chown xrootd:xrootd /data/inventory
```

On the data server (host B) let's use a storage cache that will be at a different location from `/tmp`. 

``` console
root@host # mkdir -p  /local/xrootd
root@host # chown xrootd:xrootd /local/xrootd
```

We will be running two instances of XRootD on %RED%hostA%ENDCOLOR%. 
Modify `/etc/xrootd/xrootd-clustered.cfg` to give the two instances different behavior, as such:

``` file
all.export /data/xrootdfs
set xrdr=%RED%hostA%ENDCOLOR%
all.manager $(xrdr):3121
if $(xrdr) && named cns
      all.export /data/inventory
      xrd.port 1095
else if $(xrdr)
      all.role manager
      xrd.port 1094
else
      all.role server
      oss.localroot /local/xrootd
      ofs.notify closew create mkdir mv rm rmdir trunc | /usr/bin/XrdCnsd -d -D 2 -i 90 -b $(xrdr):1095:/data/inventory
      #add cms.space if you have less the 11GB
      # cms.space options http://xrootd.slac.stanford.edu/doc/dev/cms_config.htm
      cms.space min 2g 5g
fi
```

The value of `oss.localroot` will be prepended to any file access.  
E.g. accessing `root://%RED%RDRNODE%ENDCOLOR%:1094//data/xrootdfs/test1` will actually go to
`/local/xrootd/data/xrootdfs/test1`.

#### Starting a second instance of XRootD on EL 6

The procedure for starting a second instance differs between EL 6 and EL 7. 
This section is the procedure for EL 6.

Now, we have to change `/etc/sysconfig/xrootd` on the redirector node (%RED%hostA%ENDCOLOR%) to run multiple instances
of XRootD. 
The second instance of XRootD will be named "cns" and will be used for SSI.

```file
XROOTD_USER=xrootd 
XROOTD_GROUP=xrootd 
XROOTD_DEFAULT_OPTIONS="%RED%-k 7%ENDCOLOR% -l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-clustered.cfg"
%RED%XROOTD_CNS_OPTIONS="-k 7 -l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-clustered.cfg"%ENDCOLOR% 
CMSD_DEFAULT_OPTIONS="%RED%-k 7%ENDCOLOR% -l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-clustered.cfg" 
FRMD_DEFAULT_OPTIONS="%RED%-k 7%ENDCOLOR% -l /var/log/xrootd/frmd.log -c /etc/xrootd/xrootd-clustered.cfg" 
%RED%XROOTD_INSTANCES="default cns"%ENDCOLOR% 
CMSD_INSTANCES="default" 
FRMD_INSTANCES="default" 
```

Now, we can start XRootD cluster executing the following commands. 
On redirector you will see:

```console
root@host # service xrootd start 
Starting xrootd (xrootd, default): %GREEN%[ OK ]%ENDCOLOR% 
Starting xrootd (xrootd, cns): %GREEN%[ OK ]%ENDCOLOR% 
root@host # service cmsd start 
Starting xrootd (cmsd, default): %GREEN%[ OK ]%ENDCOLOR% 
```

On redirector node you should see two instances of xrootd running:

```console
root@host # ps auxww|grep xrootd
xrootd 29036 0.0 0.0 44008 3172 ? Sl Apr11 0:00 /usr/bin/xrootd -k 7 -l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-clustered.cfg -b -s /var/run/xrootd/xrootd-default.pid -n default
xrootd 29108 0.0 0.0 43868 3016 ? Sl Apr11 0:00 /usr/bin/xrootd -k 7 -l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-clustered.cfg -b -s /var/run/xrootd/xrootd-cns.pid -n cns
xrootd 29196 0.0 0.0 51420 3692 ? Sl Apr11 0:00 /usr/bin/cmsd -k 7 -l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-clustered.cfg -b -s /var/run/xrootd/cmsd-default.pid -n default
```
%RED%Warning%ENDCOLOR% the log file for second named instance of xrootd with be
placed in `/var/log/xrootd/cns/xrootd.log`

On data server node you should that XrdCnsd process has been started:

```console
root@host # ps auxww|grep xrootd
xrootd 19156 0.0 0.0 48096 3256 ? Sl 07:37 0:00 /usr/bin/cmsd -l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-clustered.cfg -b -s /var/run/xrootd/cmsd-default.pid -n default
xrootd 19880 0.0 0.0 46124 2916 ? Sl 08:33 0:00 /usr/bin/xrootd -l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-clustered.cfg -b -s /var/run/xrootd/xrootd-default.pid -n default
xrootd 19894 0.0 0.1 71164 6960 ? Sl 08:33 0:00 /usr/bin/XrdCnsd -d -D 2 -i 90 -b fermicloud053.fnal.gov:1095:/data/inventory
```

#### Starting a second instance of XRootD on EL 7

The procedure for starting a second instance differs between EL 6 and EL 7. 
This section is the procedure for EL 7.

1.  Create a symlink pointing to `/etc/xrootd/xrootd-clustered.cfg` at `/etc/xrootd/xrootd-cns.cfg`:

```console
root@host # ln -s /etc/xrootd/xrootd-clustered.cfg /etc/xrootd/xrootd-cns.cfg
```

1.  Start an instance of the `xrootd` service named `cns` using the syntax in the [managing services section](#ManagingServices):

```console
root@host # systemctl start xrootd@cns
```

#### Testing an XRootD cluster with SSI

1.  Copy file to redirector node specifying storage path (/data/xrootdfs instead of /tmp):

```console
root@host # xrdcp /bin/sh root://%RED%RDRNODE%ENDCOLOR%:1094//data/xrootdfs/test1 
[xrootd] Total 0.00 MB [================] 100.00 % [inf MB/s] 
```

1.  To verify that SSI is working execute `cns_ssi` command on the redirector node:

```console
root@host # cns_ssi list /data/inventory 
fermicloud054.fnal.gov incomplete inventory as of Mon Apr 11 17:28:11 2011 
root@host # cns_ssi updt /data/inventory 
cns_ssi: fermicloud054.fnal.gov inventory with 1 directory and 1 file updated with 0 errors. 
root@host # cns_ssi list /data/inventory 
fermicloud054.fnal.gov complete inventory as of Tue Apr 12 07:38:29 2011 /data/xrootdfs/test1 
```

**Note**: In this example, `fermicloud53.fnal.gov` is a redirector node and `fermicloud054.fnal.gov` is a data node.

### (Optional) Enabling Xrootd over HTTP

XRootD can be accessed using the HTTP protocol. To do that:

1.   Modify `/etc/xrootd/xrootd-clustered.cfg` and add the following lines:

        :::file
           sec.protocol /usr/lib64 gsi \
              -certdir:/etc/grid-security/certificates \
              -cert:/etc/grid-security/xrd/xrdcert.pem \
              -key:/etc/grid-security/xrd/xrdkey.pem \
              -crl:3 \
              -authzfun:libXrdLcmaps.so \
              -authzfunparms:--lcmapscfg,/etc/xrootd/lcmaps.cfg,--loglevel,4 \
              -gmapopt:10 \
              -gmapto:0
           if exec xrootd
            xrd.protocol http:1094 libXrdHttp.so
            http.cadir /etc/grid-security/certificates
            http.cert /etc/grid-security/xrd/xrdcert.pem
            http.key /etc/grid-security/xrd/xrdkey.pem
            http.secxtractor /usr/lib64/libXrdLcmaps.so
            http.listingdeny yes
            http.staticpreload http://static/robots.txt /etc/xrootd/robots.txt
            http.desthttps yes
           fi
  
1.   Create robots.txt. Add file `/etc/xrootd/robots.txt` with these contents:

        :::file
           User-agent: *
           Disallow: / 

1.   Testing the configuration
    
     From the terminal, generate a proxy and attempt to use davix-get to copy from your XRootD host:
   
        :::console
           davix-get https://%RED%yourHostname%ENDCOLOR%:1094/store/user/goughes/test.root -E /tmp/x509up_u28772 --capath /etc/grid-security/certificates

!!! note
    For clients to successfully read from the regional redirector, HTTPS must be enabled for the data servers and the site-level redirector.

#### (Optional) Enable HTTP based Writes

The primary changes are to the Authfile; you will need to add several a (all) authorizations to where users need to be able to write. Here's an example:
    
    :::file
       t writecmsdata /store/foo/          a  \
                      /store/bar/          a  \
       t readcmsdata  /store/              lr
  
!!! note
    - List authorizations from most specific to least specific.
    - The first two columns must be unique; if multiple authorizations are needed for a user, add them to the same line.
    - `t` is a template.
    - `u` lines are for users as mapped by LCMAPS (such as cmsprod). These should correspond to Unix usernames at your site.
    - `g` lines refer to VOMS groups (such as /cms). These do not correspond to Unix group names at your site.
 
    The [upstream documentation](http://xrootd.org/doc/dev49/sec_config.htm#_Toc517294132) has further information on the Authfile format.

!!! warning
    If you have `u *`, recall this allows ALL users, including unauthenticated. This includes random web spiders!

### (Optional) Enabling a FUSE mount

XRootD storage can be mounted as a standard POSIX filesystem via FUSE, providing users with a more familiar interface..

Modify `/etc/fstab` by adding the following entries:

    :::file
    ....
    xrootdfs                %RED%/mnt/xrootd%ENDCOLOR%              fuse    rdr=xroot://%RED%redirector1.domain.com%ENDCOLOR%:1094/%RED%/path/%ENDCOLOR%,uid=xrootd 0 0


Replace `/mnt/xrootd` with the path that you would like to access with. 
This should also match the GridFTP settings for the `XROOTD_VMP` local path. 
Create `/mnt/xrootd` directory. Make sure the xrootd user exists on the system. Once you are finished, you can mount it:

    :::file
    mount /mnt/xrootd

You should now be able to run UNIX commands such as `ls /mnt/xrootd` to see the contents of the XRootD server.

### (Optional) Authorization

There are several authorization options in XRootD available through the security plugins. 
In this document, we will cover two options for security:

-   [Simple Unix Security](#security-option-1-adding-simple-unix-security): Based on user accounts that the client is
    logged in as.
-   [Shared-key based authentication](#security-option-2-shared-keys).
-   [`xrootd-lcmaps`](#security-option-3-xrootd-lcmaps-authorization): Using the LCMAPS callout to use X509-based
    authentication

Note: On the data nodes, the files will actually be owned by unix user `xrootd` (or other daemon user), not as the user
authenticated to, under most circumstances. 
XRootD will verify the permissions and authorization based on the user that the security plugin authenticates you to
(for instance, your unix user for option 1 or your gums id for option 2), but, internally, the data node files will be
owned by the `xrootd` user.

#### Authorization file

In order to add security to your cluster you will need to add "auth\_file" on the your data server node. 
Create `/etc/xrootd/auth_file` :

```file
# This means that all the users have read access to the datasets 
u * %RED%/data/xrootdfs%ENDCOLOR% lr

# This means that all the users have full access to their private dirs 
u = %RED%/data/xrootdfs/%ENDCOLOR%@=/ a

# This means that this privileged user can do everything 
# You need at least one user like that, in order to create the 
# private dir for each user willing to store his data in the facility 
u xrootd %RED%/data/xrootdfs%ENDCOLOR% a 
```

Here we assume that your storage path is `/data/xrootdfs` (same as in the
previous example).

Change file ownership (if you have created file as root):

```console
root@host # chown xrootd:xrootd /etc/xrootd/auth_file
```


This file is a flat file of the following form:

``` file
idtype id path privs
```

Some examples of each option. For more details or examples on how to use
templated user options, see [XRootd Authorization Database
File](http://xrootd.org/doc/dev47/sec_config.htm#_Toc489606599).

|        |                                                                                                                                       |
|--------|---------------------------------------------------------------------------------------------------------------------------------------|
| idtype | Type of id. Use `u` for username, `g` for group, etc.                                                                                 |
| id     | Username (or groupname). Use `*` for all users or `=` for user-specific capabilities, like home directories                           |
| path   | The path prefix to be used for matching purposes                                                                                      |
| privs  | Letter list of privileges: `a - all ; l - lookup ; d - delete ; n - rename ; i - insert ; r - read ; k - lock (not used) ; w - write` |

#### Security option 1: adding simple (Unix) security

The first step in adding simple Unix security to validate based on username is to create the `auth_file` as in the
previous section.

The next step is to modify `/etc/xrootd/xrootd-clustered.cfg` on both nodes:

```file
all.export /data/xrootdfs 
set xrdr=%RED%hostA%ENDCOLOR% 
all.manager $(xrdr):3121 
if $(xrdr) && named cns 
    all.export /data/inventory 
    xrd.port 1095 
else if $(xrdr) 
    all.role manager 
    xrd.port 1094 
else 
    all.role server 
    oss.localroot /local/xrootd 
    ofs.notify closew create mkdir mv rm rmdir trunc | /usr/bin/XrdCnsd -d -D 2 -i 90 -b $(xrdr):1095:/data/inventory 
    cms.space min 2g 5g 
    
    %RED% # ENABLE_SECURITY_BEGIN 
    xrootd.seclib /usr/lib64/libXrdSec.so 
    # this specify that we use the 'unix' authentication module, additional one can be specified. 
    sec.protocol /usr/lib64 unix 
    # this is the authorization file 
    acc.authdb /etc/xrootd/auth_file 
    ofs.authorize 
    # ENABLE_SECURITY_END %ENDCOLOR% 
fi 
```

Note that, to access users directories, you will have to create them in oss.localroot (For instance,
`/local/xrootd/data/xrootdfs/username`) and make sure they are writable by `xrootd` user (or the daemon user, if you
have changed it). 
Files in localroot on the data nodes are normally owned by `xrootd` not by the authenticated username.

After making all the changes, please, restart XRootD and cmsd daemons on all nodes.

#### Testing an XRootD cluster with simple security enabled

1.  Login on redirector node as root
2.  Check that user "root" still can read files:

```console
root@host # xrdcp root://%RED%RDRNODE%ENDCOLOR%:1094//data/xrootdfs/test1 /tmp/b 
[xrootd] Total 0.00 MB [================] 100.00 % [inf MB/s]
```

1.  Check that user "root" can not write files under /data/xrootdfs:

```console
root@host # xrdcp /tmp/b root://%RED%RDRNODE%ENDCOLOR%:1094//data/xrootdfs/test2 
Last server error 3010 ('Unable to create /data/xrootdfs/test2; Permission denied') 
Error accessing path/file for root://localhost:1094//data/xrootdfs/test3 
```

or you may get this error:

```console
root@host # xrdcp /tmp/b root://%RED%RDRNODE%ENDCOLOR%:1094//data/xrootdfs/test2 
Last server error 3011 ('No servers are available to write the file.') 
Error accessing path/file for root://localhost:1094//data/xrootdfs/test2
```

1.  Check that user can copy/retrieve files to/from /data/xrootdfs/~/...

```console
root@host # su - %RED%user%ENDCOLOR% 
-bash-3.2$ xrdcp /tmp/a root://%RED%RDRNODE%ENDCOLOR%:1094//data/xrootdfs/%RED%user%ENDCOLOR%/test1
[xrootd] Total 0.00 MB [================] 100.00 % [inf MB/s] 
-bash-3.2$ xrdcp root://localhost:1094//data/xrootdfs/%RED%user%ENDCOLOR%/test1 /tmp/c 
[xrootd] Total 0.00 MB [================] 100.00 % [inf MB/s]
```

#### Security option 2: Shared keys

If you want to enable security for access to XRootD via xrootdfs you will need to modify XRootD configuration and
perform several steps to make xrootdfs secured.

1. On the XRootD redirector node, execute the following command:

        :::console
        root@host # xrdsssadmin -k %RED%<my_key_name>%ENDCOLOR% -u anybody -g usrgroup add %RED%<keyfile>%ENDCOLOR%

    eg:

        root@host # xrdsssadmin -k top_secret -u anybody -g usrgroup add /etc/xrootd/xrootd.key

1. Set ownership

        :::console
        root@host # chown xrootd.xrootd /etc/xrootd/xrootd.key

1. On the node where xrootdfs is installed modify `/etc/fstab` add security information:

        :::console
        root@host # xrootdfs %RED%/mnt/xrootd %ENDCOLOR% fuse rdr=xroot://%RED%redirector1.domain.com%ENDCOLOR%:1094/%RED%/path/redirector1%ENDCOLOR%,uid=xrootd,sss=%RED%keyfile%ENDCOLOR% 0 0

1. On all XRootD data servers and redirector nodes, modify XRootD configuration (`/etc/xrootd/xrootd-clustered.cfg`) by adding the following segment:

        :::file
        # ENABLE_SECURITY_BEGIN
           xrootd.seclib /usr/lib64/libXrdSec.so
           #the line below should be before "sec.protocol ... unix"
           %RED%sec.protocol /usr/lib64 sss -s keyfile %ENDCOLOR%
           sec.protocol /usr/lib64 unix
           # this specify that we use the 'unix' authentication module, additional one can be specified.
           # this is the authorization file
           acc.authdb /etc/xrootd/auth_file
           ofs.authorize
           # ENABLE_SECURITY_END

1. On all XRootD data server nodes, edit `/etc/xrootd/auth_file` to add authorized users of the form `u %RED%username%ENDCOLOR% %RED%/directoryname%ENDCOLOR% lr` where "lr" is the permission set.

1. Copy %RED%keyfile%ENDCOLOR% from redirector node to every data server node and the xrootdfs node. Make sure that this file is owned by the `xrootd` user.

1. Restart XRootD cluster by restarting all the relevant daemons.

1. On xroodfs node execute mount:

        :::console
        root@host # mount %RED%/mnt/xrootd%ENDCOLOR%

1. Verify that you can access the mount point (df,ls) and can not write into unauthorized path, e.g:

        :::console
        root@host # cp /bin/sh /mnt/xrootd/tlevshin/test1 cp:
        cannot create regular file `/mnt/xrootd/tlevshin/test1': Permission denied

    Login as yourself and try:

        :::console
        root@host # su - tlevshin
        user@host $ cp /bin/sh /mnt/xrootd/tlevshin/test1



#### Security option 3: xrootd-lcmaps authorization

The xrootd-lcmaps security plugin uses the `lcmaps` library and the [LCMAPS VOMS plugin](/security/lcmaps-voms-authentication)
to authenticate and authorize users based on X509 certificates and VOMS attributes. Perform the following instructions
on all data nodes:

1. Install [CA certificates](/common/ca#installing-ca-certificates) and [manage CRLs](/common/ca#installing-ca-certificates#managing-certificate-revocation-lists)

1. Follow the instructions for requesting a [service certificate](/security/host-certs#requesting-and-installing-a-service-certificate),
   using `xrootd` for both the `<SERVICE>` and `<OWNER>`, resulting in a certificate and key in `/etc/grid-security/xrootd/xrootdcert.pem`
   and `/etc/grid-security/xrootd/xrootdkey.pem`, respectively.

1. Install and configure the [LCMAPS VOMS plugin](/security/lcmaps-voms-authentication)

1. Install `xrootd-lcmaps` and necessary configuration:

        :::console
        root@host # yum install xrootd-lcmaps vo-client

1. Append the following to `/etc/lcmaps.db`:

        xrootd_policy:
        verifyproxynokey -> banfile
        banfile -> banvomsfile | bad
        banvomsfile -> gridmapfile | bad
        gridmapfile -> good | vomsmapfile
        vomsmapfile -> good | defaultmapfile
        defaultmapfile -> good | bad

1. Modify `/etc/osg/config.d/10-misc.ini` so that future invocations don't overwrite your `/etc/lcmaps.db` changes:

        edit_lcmaps_db = False

1. Configure access rights for mapped users by creating and modifying the XRootD [authorization file](#authorization-file)

1. Modify your XRootD configuration:

    1. Choose the configuration file to edit based on the following table:

        | If you are running XRootD in... | Then modify the following file...   |
        |:--------------------------------|:------------------------------------|
        | Standalone mode                 | `/etc/xrootd/xrootd-standalone.cfg` |
        | Clustered mode                  | `/etc/xrootd/xrootd-clustered.cfg`  |

    1. Add the following lines to the configuration that you chose above:

            xrootd.seclib /usr/lib64/libXrdSec-4.so
            sec.protocol /usr/lib64 gsi -certdir:/etc/grid-security/certificates \
                                -cert:/etc/grid-security/xrootd/xrootdcert.pem \
                                -key:/etc/grid-security/xrootd/xrootdkey.pem -crl:1 \
                                -authzfun:libXrdLcmaps.so -authzfunparms:--loglevel,0 \
                                -gmapopt:10 -gmapto:0
            acc.authdb /etc/xrootd/auth_file
            ofs.authorize

        If you are running XRootD in clustered mode, the above will also need to be added to all data nodes in the section relevant to the data node server. For instance, in the [above example](#security-option-1-adding-unix-security), the security configuration should be placed after the `all.role server` line:

            all.export /data/xrootdfs
            set xrdr=%RED%hostA%ENDCOLOR%
            all.manager $(xrdr):3121
            if $(xrdr) && named cns
                all.export /data/inventory
                xrd.port 1095
            else if $(xrdr)
                all.role manager
                xrd.port 1094
            else
                all.role server
                oss.localroot /local/xrootd
                ofs.notify closew create mkdir mv rm rmdir trunc | /usr/bin/XrdCnsd -d -D 2 -i 90 -b $(xrdr):1095:/data/inventory
                cms.space min 2g 5g

                %RED% # ENABLE_SECURITY_BEGIN
                xrootd.seclib /usr/lib64/libXrdSec-4.so
                sec.protocol /usr/lib64 gsi -certdir:/etc/grid-security/certificates \
                                    -cert:/etc/grid-security/xrootd/xrootdcert.pem \
                                    -key:/etc/grid-security/xrootd/xrootdkey.pem -crl:1 \
                                    -authzfun:libXrdLcmaps.so -authzfunparms:--loglevel,0 \
                                    -gmapopt:10 -gmapto:0
                acc.authdb /etc/xrootd/auth_file
                ofs.authorize
                # ENABLE_SECURITY_END %ENDCOLOR%
            fi

1. Restart the [relevant services](#using-xrootd)

To verify the LCMAPS security, run the following commands from a machine with your user certificate/key pair,
`xrootd-client`, and `voms-clients-cpp` installed:

1. Destroy any pre-existing proxies and attempt a copy to `<DESTINATION PATH>` on the `<XROOTD HOST>` to verify failure:

        :::console
        user@client $ voms-proxy-destroy
        user@client $ xrdcp /bin/bash root://%RED%<XROOTD HOST>%ENDCOLOR%/%RED%<DESTINATION PATH>%ENDCOLOR%
        180213 13:56:49 396570 cryptossl_X509CreateProxy: EEC certificate has expired
        [0B/0B][100%][==================================================][0B/s]
        Run: [FATAL] Auth failed

1. On the XRootD host, add your DN to [/etc/grid-security/grid-mapfile](/security/lcmaps-voms-authentication#mapping-users)

1. Generate your proxy and verify that you can successfully transfer files:

        :::console
        user@client $ voms-proxy-init
        user@client $ xrdcp  /bin/sh root://%RED%<XROOTD HOST>%ENDCOLOR%/%RED%<DESTINATION PATH>%ENDCOLOR%
        [938.1kB/938.1kB][100%][==================================================][938.1kB/s]

    If your transfer does not succeed, run the previous command with `--debug 2` for more information.

### (Optional) Adding CMS TFC support to XRootD (CMS sites only)

For CMS users, there is a package available to integrate rule-based name lookup using a `storage.xml` file. 
If you are not setting up a CMS site, you can skip this section.

``` console
yum install --enablerepo=osg-contrib xrootd-cmstfc
```

You will need to add your `storage.xml` to `/etc/xrootd/storage.xml` and then add the following line to your XRootD
configuration:

``` file
# Integrate with CMS TFC, placed in /etc/xrootd/storage.xml
oss.namelib /usr/lib64/libXrdCmsTfc.so file:/etc/xrootd/storage.xml%ORANGE%?protocol=hadoop%ENDCOLOR%
```

Add the orange text only if you are running hadoop (see below).

See the CMS TWiki for more information:

-   <https://twiki.cern.ch/twiki/bin/view/Main/XrootdTfcChanges>
-   <https://twiki.cern.ch/twiki/bin/view/Main/HdfsXrootdInstall>

### (Optional) Adding Hadoop support to XRootD

HDFS-based sites should utilize the `xrootd-hdfs` plugin to allow XRootD to access their storage.

``` console
root@host # yum install xrootd-hdfs
```

You will then need to add the following lines to your
`/etc/xrootd/xrootd-clustered.cfg`:

``` file
xrootd.fslib /usr/lib64/libXrdOfs.so
ofs.osslib /usr/lib64/libXrdHdfs.so
```

For more information, see [the HDFS installation documents](install-hadoop).

### (Optional) Adding File Residency Manager (FRM) to an XRootd cluster

If you have a multi-tiered storage system (e.g. some data is stored on SSDs and some on disks or tapes), then install
the File Residency Manager (FRM), so you can move data between tiers more easily. 
If you do not have a multi-tiered storage system, then you do not need FRM and you can skip this section.

The FRM deals with two major mechanisms:

-   local disk
-   remote servers

The description of fully functional multiple XRootD clusters is beyond the scope of this document. 
In order to have this fully functional system you will need a global redirector and at least one remote XRootD cluster
from where files could be moved to the local cluster.

Below are the modifications you should make in order to enable FRM on your local cluster:

1.  Make sure that FRM is enabled in `/etc/sysconfig/xrootd` on your data sever:

```file
ROOTD_USER=xrootd 
XROOTD_GROUP=xrootd 
XROOTD_DEFAULT_OPTIONS="-l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-clustered.cfg" 
CMSD_DEFAULT_OPTIONS="-l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-clustered.cfg" 
FRMD_DEFAULT_OPTIONS="-l /var/log/xrootd/frmd.log -c /etc/xrootd/xrootd-clustered.cfg" 
XROOTD_INSTANCES="default" 
CMSD_INSTANCES="default" 
FRMD_INSTANCES="default"
```

1.  Modify `/etc/xrootd/xrootd-clustered.cfg` on both nodes to specify options for `frm_xfrd` (File Transfer Daemon) and `frm_purged` (File Purging Daemon). For more information, you can visit the [FRM Documentation](http://xrootd.org/doc/dev4/frm_config.htm)
2.  Start frm daemons on data server:

```console
root@host # service frm_xfrd start
root@host # service frm_purged start
```

(Optional) Installing a GridFTP Server
--------------------------------------

The Globus GridFTP server can be installed alongside an XRootD storage element to provide GridFTP-based access to the
storage.

!!! note "See Also"
    OSG has extensive documentation on setting up a GridFTP server; this section is an
    abbreviated version documenting the special steps needed for XRootD integration.
    You may also find the following useful:

    -   [Basic GridFTP Install](gridftp).  Additionally covers service planning topics.
    -   [Load-balanced GridFTP Install](load-balanced-gridftp).  Covers the creation of
        a load-balanced GridFTP service using multiple servers.

Prior to following this installation guide, verify the host certificates and networking is configured correctly as in
the [basic GridFTP install](gridftp).

### Installation

GridFTP support for XRootD-based storage is provided by the `osg-gridftp-xrootd` meta-package:

``` console
root@host # yum install osg-gridftp-xrootd
```

### Configuration

For information on how to configure authentication for your GridFTP installation, please refer to the [configuring
authentication section of the GridFTP guide](gridftp#configuring-authentication).

Edit `/etc/sysconfig/xrootd-dsi` to set `XROOTD_VMP` to use your XRootD redirector.

    :::bash
    export XROOTD_VMP="%RED%redirector:1094:/local_path=/remote_path%ENDCOLOR%"

!!! warning
    The syntax of `XROOTD_VMP` is tricky; make sure to use the following guidance:

    - **Redirector**: The hostname and domain of the local XRootD redirector server.
    - **local_path**: The path exported by the GridFTP server.
    - **remote_path**: The XRootD path that will be mounted at **local_path**.

When `xrootd-dsi` is enabled, GridFTP configuration changes should go into `/etc/xrootd-dsi/gridftp-xrootd.conf`, not
`/etc/gridftp.conf`.  
Sites should review any customizations made in the latter and copy them as necessary.

You can use the FUSE mount in order to test POSIX access to xrootd in the GridFTP server.
You should be able to run Unix commands such as `ls /mnt/xrootd` and see the contents of the XRootD server.

For log / config file locations and system services to run, see the [basic GridFTP install](gridftp).

Using XRootD
------------

### Managing XRootD services

Start services on the redirector node before starting any services on the data nodes. 
If you installed only XRootD itself, you will only need to start the `xrootd` service. 
However, if you installed cluster management services, you will need to start `cmsd` as well.

The instructions for starting and stopping an XRootD service depend on whether the service is installed on an EL 6 or EL
7 machine, and whether you are using a standalone or clustered configuration.

On EL 6, which config to use is set in the file `/etc/sysconfig/xrootd`. 
For example, to have `xrootd` use the clustered config, you would have a line such as this:

``` file
XROOTD_DEFAULT_OPTIONS="-l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-%RED%clustered%ENDCOLOR%.cfg -k fifo"
```

To use the standalone config instead, you would use:

``` file
XROOTD_DEFAULT_OPTIONS="-l /var/log/xrootd/xrootd.log -c /etc/xrootd/xrootd-%RED%standalone%ENDCOLOR%.cfg -k fifo"
```

On EL 7, which config to use is determined by the service name given to `systemctl`. 
For example, to have `xrootd` use the clustered config, you would start up `xrootd` with this line:

``` console
root@host # systemctl start xrootd@%RED%clustered%ENDCOLOR%
```

To use the standalone config instead, you would use:

``` console
root@host # systemctl start xrootd@%RED%standalone%ENDCOLOR%
```

The services are:


| Service                    | EL 6 service name | EL 7 service name   |
|:---------------------------|:------------------|:--------------------|
| XRootD (standalone config) | `xrootd`          | `xrootd@standalone` |
| XRootD (clustered config)  | `xrootd`          | `xrootd@clustered`  |
| CMSD (clustered config)    | `cmsd`            | `cmsd@clustered`    |

As a reminder, here are common service commands (all run as `root`):


| To …                                        | On EL 6, run the command…    | On EL 7, run the command…        |
|:--------------------------------------------|:-----------------------------|:---------------------------------|
| Start a service                             | `service SERVICE-NAME start` | `systemctl start SERVICE-NAME`   |
| Stop a service                              | `service SERVICE-NAME stop`  | `systemctl start SERVICE-NAME`   |
| Enable a service to start during boot       | `chkconfig SERVICE-NAME on`  | `systemctl enable SERVICE-NAME`  |
| Disable a service from starting during boot | `chkconfig SERVICE-NAME off` | `systemctl disable SERVICE-NAME` |

Getting Help
------------

To get assistance. please use the [Help Procedure](../common/help/) page.

Reference
---------

### File locations



| Service/Process | Configuration File                 | Description                              |
|:----------------|:-----------------------------------|:-----------------------------------------|
| `xrootd`        | `/etc/xrootd/xrootd-clustered.cfg` | Main clustered mode XRootD configuration |
|                 | `/etc/xrootd/auth_file`            | Authorized users file                    |

| Service/Process          | Log File                         | Description                                 |
|:-------------------------|:---------------------------------|:--------------------------------------------|
| `xrootd`                 | `/var/log/xrootd/xrootd.log`     | XRootD server daemon log                    |
| `cmsd`                   | `/var/log/xrootd/cmsd.log`       | Cluster management log                      |
| `cns`                    | `/var/log/xrootd/cns/xrootd.log` | Server inventory (composite name space) log |
| `frm_xfrd`, `frm_purged` | `/var/log/xrootd/frmd.log`       | File Residency Manager log                  |



Links
-----

-   [XRootD documentation](http://xrootd.slac.stanford.edu/doc)


