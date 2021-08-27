Installing and Using the OSG Token Renewal Service
==================================================

This document contains instructions to install and configure the
OSG Token Renewal Service package, `osg-token-renewer`,
for obtaining and automatically renewing tokens with the OIDC tools.
This service automates the procedure in the
[Requesting Tokens](https://opensciencegrid.org/technology/software/requesting-tokens/)
document.


Before Starting
---------------

Before starting the installation process, consider the following points
(consulting [the Reference section below](#reference) as needed):

- An account is needed with an OIDC token issuer that offers the device flow
- **User and Group IDs:** If they do not exist already, the installation will
  create the Linux user and group named `osg-token-svc`

As with all OSG software installations, there are some one-time (per host)
steps to prepare in advance:

- Ensure the host has
  [a supported operating system](../release/supported_platforms.md)
- Obtain root access to the host
- Prepare the [required Yum repositories](../common/yum.md)


Installing the OSG Token Renewal Service
----------------------------------------

Install the OSG Token Renewal Service package:

```console
root@server # yum install osg-token-renewer
```

This will install the `osg-token-renewer` scripts & systemd service files,
and will pull in the `oidc-agent` package that the service depends on.


Configuring the OSG token renewal service
-----------------------------------------

The main configuration file for the service is `/osg/token-renewer/config.ini`.

For each OIDC Client, you will add an `account` section to the config file.
For each token you wish to generate for this client account,
you will configure a `token` section with any relevant options.

Examples of this can be found in the `/osg/token-renewer/config.ini` that gets
installed with the package.

Each `[account <ACCOUNT_SHORTNAME>]` section corresponds to a client account
named `<ACCOUNT_SHORTNAME>`, set up with the `oidc-gen` tool, run by the
`osg-token-renewer-setup.sh` script.

In this `account` section, the `password_file` option is a path to a file
you create as `root` with the encryption password to be used for this client
account.

Details for this configuration can be found below under
[Configuring tokens for an OIDC client account](#configuring-tokens-for-an-oidc-client-account).

For each client account, you can configure one or more `[token <TOKEN_NAME>]`
sections, where `<TOKEN_NAME>` is a unique name of your choosing.
These sections describe how to create the token with the `oidc-token` tool.
For details, see
[Creating a new OIDC Client Account](#creating-a-new-oidc-client-account)
below.


Creating a new OIDC client account
----------------------------------


To create a new client account named `<ACCOUNT_SHORTNAME>`:

1. Create a corresponding file named `/etc/osg/tokens/<ACCOUNT_SHORTNAME>.pw`
   with the encryption password to use for this client account.
1. Consult the 
   [Requesting Tokens](https://opensciencegrid.org/technology/software/requesting-tokens/)
   document to determine which scopes you will need for this client account.
1. Run the setup script as follows:

        :::console
        root@server # osg-token-renewer-setup.sh <ACCOUNT_SHORTNAME> <ISSUER> <SCOPES...>

    For example,

        :::console
        root@server # account=myaccount123
        root@server # issuer=https://wlcg.cloud.cnaf.infn.it/
        root@server # scopes="wlcg offline_access"
        root@server # osg-token-renewer-setup.sh $account $issuer $scopes

1. You will be prompted on the console to visit a web link to authorize
   the client request with a passcode printed on the console.
   Follow the prompts (visit the web link, enter the request passcode,
   log in with your account for your issuer, and authorize the request).
1. If this succeeds you will be prompted with a new
   `[account <ACCOUNT_SHORTNAME>]` section to add to your `config.ini`.
   Add the section to your `/etc/token-renewer/config.ini`, replacing the example section if it's still there.

Next you can configure one or more tokens for this client account.


Configuring tokens for an OIDC client account
---------------------------------------------

After you have created an OIDC client account and added it to
`/osg/token-renewer/config.ini`, you need to create a corresponding `token`
section in the config for each token that should be generated for this account
(possibly with different options).

1.  Choose a `<TOKEN_NAME>` and add a new `[token <TOKEN_NAME>]` section
    (replacing the example section if it's still there).

    The `account` option in this section must match the `<ACCOUNT_SHORTNAME>`
    for the corresponding `[account <ACCOUNT_SHORTNAME>]` section.

1.  Set the `token_path` to `/etc/osg/tokens/<ACCOUNT_SHORTNAME>.token 

1.  Optionally, you may also specify any of the following options, which will
    be passed to the `oidc-token` command when generating the token:

    | Option         | Description                                               |
    |:---------------|:----------------------------------------------------------|
    | `audience`     | list of audiences to pass via `--aud` option              |
    | `scope`        | list of scopes to pass via `--scope` option               |
    | `min_lifetime` | min token lifetime in seconds to pass via `--time` option |

    !!! note
        For tokens used against an HTCondor-CE, set the `audience` option to
        `<CE FQDN>:<CE PORT>`.
### Example configuration

<insert example config here with account + token sections>

Managing the OSG Token Renewal Service
--------------------------------------

The OSG token renewal service is set up as a "oneshot" systemd service,
which runs under the `osg-token-svc` user, sets up an `oidc-agent`,
adds the relevant OIDC client accounts as specified in the `config.ini`
with `oidc-add`, and generates the tokens with `oidc-token`.

This service is set to run via a systemd timer nightly at midnight.

If you would like to run the service manually at a different time (e.g., to generate
all the tokens immediately), you can run the service once with:

```console
root@host # systemctl start osg-token-renewer
```

If this succeeds, the new token will be written to the location you configured
for `token_path` (`/etc/osg/tokens/<ACCOUNT_SHORTNAME>.token`, by convention).

Failures can be diagnosed by running:

```console
root@host # journalctl -eu osg-token-renewer
```

Help
----

To get assistance please use this [Help Procedure](../common/help.md).


Reference 
----------

### Files of interest

| Path                                                | Description                                   |
|:----------------------------------------------------|:----------------------------------------------|
| `/etc/osg/token-renewer/config.ini`                 | Main config file for service                  |
| `/etc/osg/tokens/<ACCOUNT_SHORTNAME>.pw`            | Encryption password file for client account   |
| `/etc/osg/tokens/<ACCOUNT_SHORTNAME>.token`         | Output location for token files               |
| `/usr/bin/osg-token-renewer-setup.sh`               | Setup script for each new client account      |
| `/usr/lib/systemd/system/osg-token-renewer.service` | SystemD service unit configuruation           |
| `/usr/lib/systemd/system/osg-token-renewer.timer`   | SystemD timer for service                     |
| `/usr/bin/osg-token-renewer.sh`                     | Main wrapper script invoked by service        |
| `/usr/bin/osg-token-renewer`                        | Token renewal program invoked by main wrapper |


