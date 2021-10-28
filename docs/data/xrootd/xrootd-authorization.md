Configuring XRootD Authorization
================================

!!!bug "EL7 version compatibility"
    There is an incompatibility with EL7 < 7.5 due to an issue with the `globus-gsi-proxy-core` package

XRootD offers several authentication options [security plugins](https://xrootd.slac.stanford.edu/doc/dev50/sec_config.htm)
to validate incoming credentials, such as bearer tokens, GSI proxies, and VOMS proxies.

In the case of GSI and VOMS proxies, after the incoming credential has been mapped to a username or groupname, the
[authorization database file](#authorization-database-file) is used to provide fine-grained file access.

!!! note
    On data nodes, files will be owned by Unix user `xrootd` (or other daemon user), not as the user
    authenticated to, under most circumstances.
    XRootD will verify the permissions and authorization based on the user that the security plugin authenticates you
    to, but, internally, the data node files will be owned by the `xrootd` user. If this behaviour is not desired, enable
    [XRootD multi-user support](install-standalone.md#enabling-multi-user-support). 

Authentication
--------------

### OSG 3.6 ###

In [OSG 3.6](#osg-3.6), XRootD installations are automatically configured to
authenticate all bearer tokens, macaroons, and VOMS proxies, so XRootD administrators can control file access solely
through the [Authorization Database File](#authorization-database-file).
Optionally, you may map the subject distinguished names of incoming X.509 proxies to a user in
`/etc/grid-security/grid-mapfile`.
This mapped user can then be used in XRootD's Authorization Database file.

#### Mapping X.509 proxies ####

!!! note "DN mappings take precedence over VOMS attributes"
    If you have mapped the subject DN of an incoming VOMS proxy, XRootD will map it to a username

In OSG 3.6, X.509 proxies are mapped using the built-in XRootD GSI plug-in.
To map an incoming proxy's subject DN to an [XRootD username](#formatting),
add lines of the following format to `/etc/grid-security/grid-mapfile`:

```
"<SUBJECT DN>" <AUTHDB USERNAME>
```

Replacing `<SUBJECT DN>` with the X.509 proxy's DN to map and `<AUTHDB USERNAME>` with the username to reference in the
[authorization database file](#formatting).
For example, the following mapping:

```
"/DC=org/DC=cilogon/C=US/O=University of Wisconsin-Madison/CN=Brian Lin A2266246" blin
```

Will result in the username `blin`,
i.e. authorize access to clients presenting the above proxy with `u blin ...` in the authorization database file.

#### Mapping VOMS proxies ####

!!! bug "VOMS attribute mappings incompatible with `xrootd-multiuser`"
    The OSG 3.6 configuration of XRootD uses the `XrdVoms` plugin, which pass along the entire VOMS FQAN as the
    groupname to the authorization layer (see the section on [authorization database file formatting](#formatting)).
    Some characters in VOMS FQANs are not legal in Unix usernames, therefore VOMS attributes mappings are incompatible
    with `xrootd-multiuser`.
    See [XRootD GitHub issue #1538](https://github.com/xrootd/xrootd/issues/1538) for more details.

In OSG 3.6, VOMS proxies are automatically mapped using the built-in XRootD GSI and VOMS plug-ins.
An incoming VOMS proxy will authenticate the first VOMS FQAN to the [authorization database groupname](#formatting).
For example, a VOMS proxy from the OSPool will be authenticated to the following groupname:

`/osg/Role=NULL/Capability=NULL`

Instead of only using the first VOMS FQAN, you can configure XRootD to consider all VOMS FQANs in the proxy for
authentication by setting the following in `/etc/xrootd/config.d/10-osg-xrdvoms.cfg`:

```
set vomsfqans = useall
```

### OSG 3.5 ###

!!! info "OSG 3.5 end-of-life"
    OSG 3.5 will reach its end-of-life in [February 2022](../../release/release_series.md#series-overviews).

In OSG 3.5, the [LCMAPS VOMS plugin](../../security/lcmaps-voms-authentication.md) is used to authenticate X.509 and
VOMS proxies to usernames utilized by the [authorization database file](#formatting).
Perform the following instructions on all data nodes:

1.  Install [CA certificates](../../common/ca.md#installing-ca-certificates) and 
    [manage CRLs](../../common/ca.md#managing-certificate-revocation-lists)

1.  Copy your host certificate and key to `/etc/grid-security/xrd/xrdcert.pem` and `/etc/grid-security/xrd/xrdkey.pem`,
    respectively.

1.  Configure the [LCMAPS VOMS plugin](../../security/lcmaps-voms-authentication.md)

Authorization Database File
---------------------------

XRootD allows configuring fine-grained file access permissions based on authenticated identities and paths.
This is configured in the authorization file `/etc/xrootd/Authfile`, which should be writable
only by the `xrootd` user, optionally readable by others.

Here is an example `/etc/xrootd/Authfile` :

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

# This means that OSPool clients presenting a VOMS proxy can do anything under the 'osg' directory
g /osg <STORAGE PATH>/osg a
```

Replacing `<STORAGE PATH>` with the path to the directory that will contain data served by XRootD, e.g. `/data/xrootdfs`.
This path is relative to the `oss.localroot` or `all.localroot` configuration values, if either one is defined in the
xrootd config file.

!!! note
    Specific paths need to be specified _before_ generic paths; e.g., this does not work:

            u * rl /data/xrootdfs -rl /data/xrootdfs/private


### Formatting ###

More generally, each configuration line of the auth file has the following form:

``` file
idtype id path privs
```

| Field  | Description                                                                                                                           |
|--------|---------------------------------------------------------------------------------------------------------------------------------------|
| idtype | Type of id. Use `u` for username, `g` for groupname, etc.                                                                             |
| id     | Username (or groupname). Use `*` for all users or `=` for user-specific capabilities, like home directories                           |
| path   | The path prefix to be used for matching purposes.  `@=` expands to the current user name before a path prefix match is attempted      |
| privs  | Letter list of privileges: `a` - all ; `l` - lookup ; `d` - delete ; `n` - rename ; `i` - insert ; `r` - read ; `k` - lock (not used) ; `w` - write ; `-` - prefix to remove specified privileges |

For more details or examples on how to use templated user options, see
[XRootd Authorization Database File](http://xrootd.org/doc/dev47/sec_config.htm#_Toc489606599).

### Verifying file ownership and permissions ###

Ensure the authorization datbase file is owned by `xrootd` (if you have created file as root),
and that it is not writable by others.

```console
root@host # chown xrootd:xrootd /etc/xrootd/Authfile
root@host # chmod 0640 /etc/xrootd/Authfile  # or 0644
```

Applying Authorization Changes
------------------------------

After making changes to your [authorization database file](#authorization-database-file), you must restart the
[relevant services](install-standalone.md#using-xrootd).

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

1. On the XRootD host, add your DN to [/etc/grid-security/grid-mapfile](../../security/lcmaps-voms-authentication.md#mapping-users)

1. Add a line to `/etc/xrootd/auth_file` to ensure the mapped user can write to `<DESTINATION PATH>`

1. Restart the xrootd service. (See [this section](install-standalone.md#using-xrootd) for more information
   of managing XRootD services.)

1. Generate your proxy and verify that you can successfully transfer files:

        :::console
        user@client $ voms-proxy-init
        user@client $ xrdcp  /bin/sh root://<XROOTD HOST>/<DESTINATION PATH>
        [938.1kB/938.1kB][100%][==================================================][938.1kB/s]

    If your transfer does not succeed, run the previous command with `--debug 2` for more information.
