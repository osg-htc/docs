Configuring XRootD Authorization
================================

!!!bug "EL7 version compatibility"
    There is an incompatibility with EL7 < 7.5 due to an issue with the `globus-gsi-proxy-core` package


There are several authorization options in XRootD available through its security plugins.
In this document, we will cover the [`xrootd-lcmaps`](#enabling-xrootd-lcmaps-authorization) security option supported
in the OSG.

The XRootD LCMAPS authorization method depends on configuring
[LCMAPS with the VOMS plugin](/security/lcmaps-voms-authentication).
LCMAPS maps an incoming user's grid credentials to a Unix account name;
the permissions listed in the [authorization file](#authorization-file) all reference Unix account names. 

!!! note
    On the data nodes, the files will actually be owned by Unix user `xrootd` (or other daemon user), not as the user
    authenticated to, under most circumstances.
    XRootD will verify the permissions and authorization based on the user that the security plugin authenticates you
    to, but, internally, the data node files will be owned by the `xrootd` user.

#### Authorization file

XRootD allows configuring fine-grained file access permissions based on usernames and paths.
This is configured in the authorization file `/etc/xrootd/auth_file` on the data server node, which should be writable
only by the xrootd user, optionally readable by others.

(The path `/etc/xrootd/auth_file` corresponds to the
[`acc.authdb`](http://xrootd.org/doc/dev47/sec_config.htm#_Toc489606592) parameter in your xrootd config.)

Here is an example `/etc/xrootd/auth_file` :

```file hl_lines="2 5 8 13 16"
# This means that all the users have read access to the datasets, _except_ under /private
u * <STORAGE PATH>/private -rl <STORAGE PATH> rl

# Or the following, without a restricted /private dir
# u * <STORAGE PATH> rl

# This means that all the users have full access to their private home dirs
u = <STORAGE PATH>/home/@=/ a

# This means that the privileged 'xrootd' user can do everything
# There must be at least one such user in order to create the
# private dirs for users willing to store their data in the facility
u xrootd <STORAGE PATH> a

# This means that users in group 'biology' can do anything under the 'genomics' directory
g biology <STORAGE PATH>/genomics a
```

Replacing `<STORAGE PATH>` with the path to the directory that will contain data served by XRootD, e.g. `/data/xrootdfs`.
This path is relative to the `oss.localroot` or `all.localroot` configuration values, if either one is defined in the
xrootd config file.

!!! note
    Specific paths need to be specified _before_ generic paths; e.g., this does not work:

            u * rl /data/xrootdfs -rl /data/xrootdfs/private


More generally, each configuration line of the auth file has the following form:

``` file
idtype id path privs
```

| Field  | Description                                                                                                                           |
|--------|---------------------------------------------------------------------------------------------------------------------------------------|
| idtype | Type of id. Use `u` for username, `g` for group, etc.                                                                                 |
| id     | Username (or groupname). Use `*` for all users or `=` for user-specific capabilities, like home directories                           |
| path   | The path prefix to be used for matching purposes.  `@=` expands to the current user name before a path prefix match is attempted      |
| privs  | Letter list of privileges: `a` - all ; `l` - lookup ; `d` - delete ; `n` - rename ; `i` - insert ; `r` - read ; `k` - lock (not used) ; `w` - write ; `-` - prefix to remove specified privileges |

For more details or examples on how to use templated user options, see
[XRootd Authorization Database File](http://xrootd.org/doc/dev47/sec_config.htm#_Toc489606599).

Ensure the auth file is owned by `xrootd` (if you have created file as root), and that it is not writable by others.

```console
root@host # chown xrootd:xrootd /etc/xrootd/auth_file
root@host # chmod 0640 /etc/xrootd/auth_file  # or 0644
```


#### Enabling xrootd-lcmaps authorization

The xrootd-lcmaps security plugin uses the `lcmaps` library and the [LCMAPS VOMS plugin](/security/lcmaps-voms-authentication)
to authenticate and authorize users based on X509 certificates and VOMS attributes. Perform the following instructions
on all data nodes:

1. Install [CA certificates](/common/ca#installing-ca-certificates) and [manage CRLs](/common/ca#installing-ca-certificates#managing-certificate-revocation-lists)

1. Follow the instructions for requesting a [service certificate](/security/host-certs#requesting-service-certificates),
   using `xrootd` for both the `<SERVICE>` and `<OWNER>`, resulting in a certificate and key in `/etc/grid-security/xrd/xrdcert.pem`
   and `/etc/grid-security/xrd/xrdkey.pem`, respectively.

1. Install and configure the [LCMAPS VOMS plugin](/security/lcmaps-voms-authentication)

1. Install `xrootd-lcmaps` and necessary configuration:

        :::console
        root@host # yum install xrootd-lcmaps vo-client

1. Configure access rights for mapped users by creating and modifying the XRootD [authorization file](#authorization-file)

1. Restart the [relevant services](/data/xrootd/install-standalone/#using-xrootd)

Verifying XRootD Authorization
------------------------------

To verify the LCMAPS security, run the following commands from a machine with your user certificate/key pair,
`xrootd-client`, and `voms-clients-cpp` installed:

1. Destroy any pre-existing proxies and attempt a copy to a directory (which we will refer to as `<DESTINATION PATH>`) on the `<XROOTD HOST>` to verify failure:

        :::console
        user@client $ voms-proxy-destroy
        user@client $ xrdcp /bin/bash root://<XROOTD HOST>/<DESTINATION PATH>
        180213 13:56:49 396570 cryptossl_X509CreateProxy: EEC certificate has expired
        [0B/0B][100%][==================================================][0B/s]
        Run: [FATAL] Auth failed

1. On the XRootD host, add your DN to [/etc/grid-security/grid-mapfile](/security/lcmaps-voms-authentication#mapping-users)

1. Add a line to `/etc/xrootd/auth_file` to ensure the mapped user can write to `<DESTINATION PATH>`

1. Restart the xrootd service. (See [this section](/data/xrootd/install-standalone/#using-xrootd) for more information
   of managing XRootD services.)

1. Generate your proxy and verify that you can successfully transfer files:

        :::console
        user@client $ voms-proxy-init
        user@client $ xrdcp  /bin/sh root://<XROOTD HOST>/<DESTINATION PATH>
        [938.1kB/938.1kB][100%][==================================================][938.1kB/s]

    If your transfer does not succeed, run the previous command with `--debug 2` for more information.

