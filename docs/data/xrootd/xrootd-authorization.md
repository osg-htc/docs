title: Configuring XRootD Authorization
DateReviewed: 2022-05-06

Configuring XRootD Authorization
================================

XRootD offers several authentication options using [security plugins](https://xrootd.web.cern.ch/doc/dev56/sec_config.htm#_Toc119617427)
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

XRootD supports authorization of bearer tokens such as macaroons, SciTokens, or WLCG tokens.
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

Authorizations for proxy-based security are declared in an [XRootD authorization database file](#authorization-database).
XRootD authentication plugins are used to provide the mappings that are used in the database.

DN mappings are performed with XRootD's built-in GSI support,
and FQAN mappings are with the XRootD-VOMS (`XrdVoms`) plugin.

To enable proxy authentication, edit `/etc/xrootd/config.d/10-osg-xrdvoms.cfg` and add or uncomment the line

```
set EnableVoms = 1
```

!!! note
    Proxy authentication is already enabled in [XRootD Standalone](install-standalone.md),
    so this step is not necessary there.

!!! warning "Requirements for XRootD-Multiuser with VOMS FQANs"
    Using XRootD-Multiuser with a VOMS FQAN requires XRootD 5.5.0 or newer.

!!! warning "Key length requirements"
    Servers on EL 8 or newer will reject proxies that are not at least 2048 bits long.
    Ensure your clients' proxies have at least 2048 bits long with `voms-proxy-info`;
    if necessary, have them add the argument `-bits 2048` to their `voms-proxy-init` calls.

#### Mapping subject DNs ####

!!! note "DN mappings take precedence over VOMS attributes"
    If you have mapped the subject Distinguished Name (DN) of an incoming proxy with VOMS attributes,
    XRootD will map it to a username.

X.509 proxies are mapped using the built-in XRootD GSI plug-in.
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

!!! warning "Requirements for XRootD-Multiuser with VOMS FQANs"
    Using XRootD-Multiuser with a VOMS FQAN requires XRootD 5.5.0 or newer.

If the XRootD-VOMS plugin is enabled,
an incoming VOMS proxy will authenticate the first VOMS FQAN and map it to an organization name (`o`),
groupname (`g`), and role name (`r`) in the [authorization database](#authorization-database).
For example, a proxy from the OSPool whose first VOMS FQAN is `/osg/Role=NULL/Capability=NULL` will be authenticated to
the `/osg` groupname; note that the `/` _is_ included in the groupname.

<!-- XXX Which part of an FQAN ends up in "organization" ? -->

Instead of only using the first VOMS FQAN, you can configure XRootD to consider all VOMS FQANs in the proxy for
authentication by setting the following in `/etc/xrootd/config.d/10-osg-xrdvoms.cfg`:

```
set vomsfqans = useall
```

<!-- XXX and how does this work? How can multiple FQANs be used? -->


#### Mapping VOMS attributes to users ####

In order for the XRootD-Multiuser plugin to work, a proxy must be mapped to a user (`u`) that is a valid Unix user.

Use a VOMS Mapfile, conventionally in `/etc/grid-security/voms-mapfile` that contains lines in the following form:
```
"<FQAN PATTERN>" <USERNAME>
```
replacing `<FQAN PATTERN>` with a glob matching FQANs, and `<USERNAME>` with the user that you want to map
matching FQANs to.

For example,
```
"/osg/*" osg01
```
will map FQANs starting with `/osg/` to the user `osg01`.

To enable using VOMS mapfiles in the first place, add the following line to your XRootD configuration:
```
voms.mapfile /etc/grid-security/voms-mapfile
```
replacing `/etc/grid-security/voms-mapfile` with the actual location of your mapfile, if it is different.

!!!note
    A VOMS Mapfile only affects mapping the user (`u`) attribute understood in the [authorization-database](#authorization-database).
    The FQAN will always be used for the groupname (`g`), organization name (`o`), and role name (`r`),
    even if the mapfile is missing or does not contain a matching mapping.

See the [VOMS Mapping documentation](https://github.com/xrootd/xrootd/tree/master/src/XrdVoms#voms-mapping) for details.
VOMS Mapfiles previously used with LCMAPS should continue to work unmodified,
but the plugin can only look at a single mapfile,
so if you are using the mappings provided in `/usr/share/osg/voms-mapfile-default`
(by the `vo-client-lcmaps-voms` package),
you will have to copy them to `/etc/grid-security/voms-mapfile`.

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
[XRootD authorization database](https://xrootd.web.cern.ch/doc/dev56/sec_config.htm#_Toc119617472).

#### Verifying file ownership and permissions ####

Ensure the authorization datbase file is owned by `xrootd` (if you have created file as root),
and that it is not writable by others.

```console
root@host # chown xrootd:xrootd /etc/xrootd/Authfile
root@host # chmod 0640 /etc/xrootd/Authfile  # or 0644
```


### Multiuser and the authorization database

The XRootD-Multiuser plugin can be used to perform file system operations as a different user than the XRootD daemon (whose user is `xrootd`).
If it is enabled, then _after_ authorization is done using the authorization database,
XRootD will take the user (`u`) attribute of the incoming request, and perform file operations as the Unix user with the same name as that attribute.

!!!note
    If there is no Unix user with a matching name, you will see an error like
    `XRootD mapped request to username that does not exist: <username>`; the operation will then fail with "EACCES" (access denied).


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

1.  On the XRootD host, add your DN to [/etc/grid-security/grid-mapfile](#mapping-subject-dns)

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


Updating to OSG 25
------------------

There are no manual steps necessary for authentication to work when upgrading from OSG 24 to OSG 25.

Updating to OSG 24
------------------

There are no manual steps necessary for authentication to work when upgrading from OSG 23 to OSG 24.

Updating to OSG 23
------------------

There are no manual steps necessary for authentication to work when upgrading from OSG 3.6 to OSG 23.
