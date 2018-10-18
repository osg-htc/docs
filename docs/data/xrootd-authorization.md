Configuring XRootD Authorization
================================

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

