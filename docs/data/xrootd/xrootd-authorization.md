DateReviewed: 2021-10-29

Configuring XRootD Authorization
================================

!!!bug "OSG 3.5 EL7 version compatibility"
    There is an incompatibility with EL7 < 7.5 due to an issue with the `globus-gsi-proxy-core` package

XRootD offers several authentication options [security plugins](https://xrootd.slac.stanford.edu/doc/dev50/sec_config.htm)
to validate incoming credentials, such as bearer tokens, X.509 proxies, and VOMS proxies.

In the case of X.509 and VOMS proxies, after the incoming credential has been mapped to a username or groupname, the
[authorization database](#authorization-database) is used to provide fine-grained file access.

!!! note
    On data nodes, files will be owned by Unix user `xrootd` (or other daemon user), not as the user
    authenticated to, under most circumstances.
    XRootD will verify the permissions and authorization based on the user that the security plugin authenticates you
    to, but, internally, the data node files will be owned by the `xrootd` user. If this behaviour is not desired, enable
    [XRootD multi-user support](install-standalone.md#enabling-multi-user-support). 

Authorizing Bearer Tokens
-------------------------

The OSG configurations of XRootD support authorization of bearer tokens such as macaroons, SciTokens, or WLCG tokens.
Encoded in the bearer tokens themselves are information about the files that they should have read/write access to and
in the case of SciTokens and WLCG tokens, you may configure XRootD to further restrict access.

### Configuring SciTokens/WLCG Tokens ###

SciTokens and WLCG Tokens are asymmetrically signed bearer tokens: they are signed by a token issuer (e.g., CILogon, IAM)
and can be verified with the token issuer's public key.
To configure XRootD to accept tokens from a given token issuer use the following instructions:

1.  Add a section for each token issuer to `/etc/xrootd/scitokens.conf`:

        [Issuer <NAME>]
        issuer = <URL>
        base_path = <RELATIVE PATH>

    Replacing `<NAME`> with a descriptive name, `<URL>` with the token issuer URL, and `base_path` to a path relative to
    [`rootdir`](install-standalone.md#configuring-xrootd) that the client should be restricted to accessing.

1.  **(Optional)** if you want to map the incoming token for a given issuer to a Unix username:

    1.  Install [xrootd-multiuser](install-standalone.md#enabling-multi-user-support)

    1.  Add the following to the relevant issuer section in `/etc/xrootd/scitokens.conf`:

            map_subject = True

1.  **(Optional)** if you want to only accept tokens with the appropriate `aud` field, add the following to
    `/etc/xrootd/scitokens.conf`:

        [Global]
        audience = <COMMMA SEPARATED LIST OF AUDIENCES>

An example configuration that supports tokens issued by the OSG Connect and CMS:

```
[Global]
audience = https://testserver.example.com/, MySite

[Issuer OSG-Connect]

issuer = https://scitokens.org/osg-connect
base_path = /stash
map_subject = True

[Issuer CMS]

issuer = https://scitokens.org/cms
base_path = /user/cms
```

### Configuring macaroons ###

Macaroons are symetrically signed bearer tokens so your XRootD host must have access to the same secret key that is used
to sign incoming macaroons.
When used in an XRootD cluster, all data nodes and the redirector need access to the same secret.
To enable macaroon support:

1.  Place the shared secret in `/etc/xrootd/macaroon-secret`
1.  Ensure that it has the appropriate file ownership and permissions:

        :::console
        root@host # chown xrootd:xrootd /etc/xrootd/macaroon-secret
        root@host # chmod 0600 /etc/xrootd/macaroon-secret

Authorizing X.509 proxies
-------------------------

### Authenticating proxies ###

!!! bug "VOMS attribute mappings incompatible with `xrootd-multiuser`"
    The OSG 3.6 configuration of XRootD uses the `XrdVoms` plugin, which pass along the entire VOMS FQAN as the
    groupname to the authorization layer (see the section on [authorization database file formatting](#formatting)).
    Some characters in VOMS FQANs are not legal in Unix usernames, therefore VOMS attributes mappings are incompatible
    with `xrootd-multiuser`.
    See [XRootD GitHub issue #1538](https://github.com/xrootd/xrootd/issues/1538) for more details.

In [OSG 3.6](../../release/release_series.md#series-overviews), XRootD installations are automatically configured to
authenticate all X.509 and VOMS proxies, so XRootD administrators can control file access through the
[authorization database](#authorization-database).
Optionally, you may map the subject distinguished names of incoming X.509 proxies to a username in
`/etc/grid-security/grid-mapfile`.
This mapped username can then be used in XRootD's authorization database file.

#### Mapping subject DNs ####

!!! note "DN mappings take precedence over VOMS attributes"
    If you have mapped the subject Distinguished Name (DN) of an incoming proxy with VOMS attributes,
    XRootD will map it to a username.

In OSG 3.6, X.509 proxies are mapped using the built-in XRootD GSI plug-in.
To map an incoming proxy's subject DN to an [XRootD username](#authorization-database),
add lines of the following format to `/etc/grid-security/grid-mapfile`:

```
"<SUBJECT DN>" <AUTHDB USERNAME>
```

Replacing `<SUBJECT DN>` with the X.509 proxy's DN to map and `<AUTHDB USERNAME>` with the username to reference in the
[authorization database](#authorization-database).
For example, the following mapping:

```
"/DC=org/DC=cilogon/C=US/O=University of Wisconsin-Madison/CN=Brian Lin A2266246" blin
```

Will result in the username `blin`,
i.e. authorize access to clients presenting the above proxy with `u blin ...` in the authorization database.

#### Mapping VOMS attributes ####

!!! bug "VOMS attribute mappings incompatible with `xrootd-multiuser`"
    The OSG 3.6 configuration of XRootD uses the `XrdVoms` plugin, which pass along the entire VOMS FQAN as the
    groupname to the authorization layer (see the section on [authorization database formatting](#formatting)).
    Some characters in VOMS FQANs are not legal in Unix usernames, therefore VOMS attributes mappings are incompatible
    with `xrootd-multiuser`.
    See [XRootD GitHub issue #1538](https://github.com/xrootd/xrootd/issues/1538) for more details.

In OSG 3.6, VOMS proxies are automatically mapped using the built-in XRootD GSI and VOMS plug-ins.
An incoming VOMS proxy will authenticate the first VOMS FQAN and map it to an organization name, groupname, and role
name in the [authorization database](#authorization-database).
For example, a proxy from the OSPool whose first VOMS FQAN is `/osg/Role=NULL/Capability=NULL` will be authenticated to
the `osg` groupname.

Instead of only using the first VOMS FQAN, you can configure XRootD to consider all VOMS FQANs in the proxy for
authentication by setting the following in `/etc/xrootd/config.d/10-osg-xrdvoms.cfg`:

```
set vomsfqans = useall
```

### Authenticating Proxies (deprecated) ###

!!! info "OSG 3.5 end-of-life"
    OSG 3.5 will reach its end-of-life in [February 2022](../../release/release_series.md#series-overviews).

In [OSG 3.5](../../release/release_series.md#series-overviews), [LCMAPS](../../security/lcmaps-voms-authentication.md) is
used to authenticate X.509 and VOMS proxies to usernames utilized by the
[authorization database](#authorization-database).
Perform the following instructions on all data nodes:

1.  Install [CA certificates](../../common/ca.md#installing-ca-certificates) and 
    [manage CRLs](../../common/ca.md#managing-certificate-revocation-lists)

1.  Copy your host certificate and key to `/etc/grid-security/xrd/xrdcert.pem` and `/etc/grid-security/xrd/xrdkey.pem`,
    respectively.

1.  Configure the [LCMAPS VOMS plugin](../../security/lcmaps-voms-authentication.md)

1.  Any subject DN or VOMS FQAN mappings from LCMAPS will result in usernames that can be used in the
    [authorization database](#authorization-database).

### Authorization database ###

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
This path is relative to the [`rootdir`](install-standalone.md#configuring-xrootd).

!!! warning "Configure most to least specific paths"
    Specific paths need to be specified _before_ generic paths.
    For example, this line will allow all users to read the contents `/data/xrootdfs/private`:

            u * /data/xrootdfs rl /data/xrootdfs/private -rl

    Instead, specify the following to ensure that a given user will not be able to read the contents of
    `/data/xrootdfs/private` unless specified with another authorization rule:

            u * /data/xrootdfs/private -rl /data/xrootdfs rl


#### Formatting ####

More generally, each authorization rule of the authorization database has the following form:

``` file
idtype id path privs
```

| Field  | Description                                                                                                                           |
|--------|---------------------------------------------------------------------------------------------------------------------------------------|
| idtype | Type of id. Use `u` for username, `g` for groupname, `o` for organization name, `r` for role name, etc.                               |
| id     | ID name, e.g. username or groupname. Use `*` for all users or `=` for user-specific capabilities, like home directories               |
| path   | The path prefix to be used for matching purposes.  `@=` expands to the current user name before a path prefix match is attempted      |
| privs  | Letter list of privileges: `a` - all ; `l` - lookup ; `d` - delete ; `n` - rename ; `i` - insert ; `r` - read ; `k` - lock (not used) ; `w` - write ; `-` - prefix to remove specified privileges |

For more details or examples on how to use templated user options, see
[XRootD authorization database](http://xrootd.org/doc/dev47/sec_config.htm#_Toc489606599).

#### Verifying file ownership and permissions ####

Ensure the authorization datbase file is owned by `xrootd` (if you have created file as root),
and that it is not writable by others.

```console
root@host # chown xrootd:xrootd /etc/xrootd/Authfile
root@host # chmod 0640 /etc/xrootd/Authfile  # or 0644
```

Applying Authorization Changes
------------------------------

After making changes to your [authorization database](#authorization-database), you must restart the
[relevant services](install-standalone.md#using-xrootd).

Verifying XRootD Authorization
------------------------------

### Bearer tokens ###

To test read access using macaroon, SciTokens, and WLCG token authorization, run the following command:

```console
user@host $ curl -v \
                 -H 'Authorization: Bearer <TOKEN>' \
                 https://host.example.com//path/to/directory/hello_world
```

Replacing `<TOKEN>` with the contents of your encoded token, `host.example.com` with the target XRootD host, and
`/path/to/directory/hello_world` with the path of the file to read.


To test write access, using macaroon, SciTokens, and WLCG token authorization, run the following command:

```console
user@host $ curl -v \
                 -X PUT \
                 --upload-file <FILE TO UPLOAD> \
                 -H 'Authorization: Bearer <TOKEN>' \
                 https://host.example.com//path/to/directory/hello_world
```

Replacing `<TOKEN>` with the contents of your encoded token, `<FILE TO UPLOAD>` with the file to write to the XRootD
host, `host.example.com` with the target XRootD host, and `/path/to/directory/hello_world` with the path of the file to
write.

### X.509 and VOMS proxies ###

To verify X.509 and VOMS proxy authorization, run the following commands from a machine with your user certificate/key
pair, `xrootd-client`, and `voms-clients-cpp` installed:

1.  Destroy any pre-existing proxies and attempt a copy to a directory (which we will refer to as `<DESTINATION PATH>`)
    on the `<XROOTD HOST>` to verify failure:

        :::console
        user@client $ voms-proxy-destroy
        user@client $ xrdcp /bin/bash root://<XROOTD HOST>/<DESTINATION PATH>
        180213 13:56:49 396570 cryptossl_X509CreateProxy: EEC certificate has expired
        [0B/0B][100%][==================================================][0B/s]
        Run: [FATAL] Auth failed

1.  On the XRootD host, add your DN to [/etc/grid-security/grid-mapfile](../../security/lcmaps-voms-authentication.md#mapping-users)

1.  Add a line to the [authorization database](#authorization-database) to ensure the mapped user can write to
    `<DESTINATION PATH>`

1.  Restart the relevant XRootD services.
    See [this section](install-standalone.md#using-xrootd) for details

1. Generate your proxy and verify that you can successfully transfer files:

        :::console
        user@client $ voms-proxy-init
        user@client $ xrdcp  /bin/sh root://<XROOTD HOST>/<DESTINATION PATH>
        [938.1kB/938.1kB][100%][==================================================][938.1kB/s]

    If your transfer does not succeed, re-run `xrdcp`  with `--debug 2` for more information.
