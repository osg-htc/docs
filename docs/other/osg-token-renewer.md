title: Installing and Using the OSG Token Renewal Service

Installing and Using the OSG Token Renewal Service
==================================================

This document contains instructions to install and configure the
OSG Token Renewal Service package, `osg-token-renewer`,
for obtaining and automatically renewing tokens with [oidc-agent](https://github.com/indigo-dc/oidc-agent).


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


Configuring the OSG Token Renewal Service
-----------------------------------------


### Configuring accounts

To create a new client account named `<ACCOUNT_SHORTNAME>`:

1. Create a corresponding file named `/etc/osg/tokens/<ACCOUNT_SHORTNAME>.pw`
   with the encryption password to use for this client account.
1. Consult the
   [Requesting Tokens](https://osg-htc.org/technology/software/requesting-tokens/)
   document to determine which scopes you will need for this client account.
1. Run the setup script as follows:

        :::console
        root@server # osg-token-renewer-setup <ACCOUNT_SHORTNAME>

    For example,

        :::console
        root@server # osg-token-renewer-setup myaccount123

   That will use dynamic client registration.  If you instead have a
   predefined client id and secret, add a `--manual` option, for example,

        :::console
        root@server # osg-token-renewer-setup --manual myaccount123

1. When prompted, enter your Issuer and desired scopes for this account
   from the list of valid options.
   If you used `--manual`, also enter the client id and secret.
1. You will also be prompted on the console to visit a web link to authorize
   the client request with a passcode printed on the console.
   Follow the prompts (visit the web link, enter the request passcode,
   log in with your account for your issuer, and authorize the request).
1. If this succeeds, you will be prompted with a new
   `[account <ACCOUNT_SHORTNAME>]` section to add to your `config.ini`.
   Add the section to your `/etc/osg/token-renewer/config.ini`,
   replacing the example section if it's still there.

Next you can configure one or more tokens for this client account.


### Configuring tokens

After you have created an OIDC client account and added it to
`/etc/osg/token-renewer/config.ini`, you need to create a corresponding `token`
section in the config for each token that should be generated for this account
(possibly with different options).

1.  Choose a `<TOKEN_NAME>` and add a new `[token <TOKEN_NAME>]` section
    (replacing the example section if it's still there).

    The `account` option in this section must match the `<ACCOUNT_SHORTNAME>`
    for the corresponding `[account <ACCOUNT_SHORTNAME>]` section.

1.  Set the `token_path` to
    `/etc/osg/tokens/<ACCOUNT_SHORTNAME>.<TOKEN_NAME>.token`

1.  Optionally, you may also specify any of the following options, which can
    limit the respective values in the generated token compared to the
    associated account:

    | Option         | Description                                               |
    |:---------------|:----------------------------------------------------------|
    | `audience`     | list of audiences  (see [RFC7519](https://datatracker.ietf.org/doc/html/rfc7519#section-4.1.3)) |
    | `scope`        | list of [scopes](https://github.com/WLCG-AuthZ-WG/common-jwt-profile/blob/master/profile.md#capability-based-authorization-scope)               |
    | `min_lifetime` | min token lifetime in seconds |

    !!! note
        For tokens used against an HTCondor-CE, set the `audience` option to
        `<CE FQDN>:<CE PORT>`.

### Example configuration

```file
[account myclient1234]

password_file = /etc/osg/tokens/myclient1234.pw



[token mytoken567]

account = myclient1234
token_path = /etc/osg/tokens/myclient1234.mytoken567.token
```

### Adjusting token renewal frequency

It is possible to override the default `osg-token-renewer` systemd timer
frequency for this service by creating a config override file under
`/etc/systemd/system/osg-token-renewer.timer.d/`.

For example, to configure the token renewal service to run every 10 minutes,
run the following:

```console
root@host # cat << EOF > /etc/systemd/system/osg-token-renewer.timer.d/timer-frequency.conf
[Timer]
OnBootSec=10min
OnUnitActiveSec=10min
EOF
root@host # systemctl daemon-reload
```

!!! note
    Be aware that the default timer configuration also has a 3 minute random
    delay built in, via the parameter `RandomizedDelaySec=3min`.
    Thus setting the frequency to `10min` only guarantees runs every 13 minutes.
    This parameter is also configurable in the above systemd override file.


Managing the OSG Token Renewal Service
--------------------------------------

These services are managed by `systemctl` and may start additional services as
dependencies.
As a reminder, here are common service commands (all run as `root`):

| To...                                   | Run the command...                 |
| :-------------------------------------- | :--------------------------------- |
| Start a service                         | `systemctl start <SERVICE-NAME>`   |
| Stop a service                          | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot       | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot | `systemctl disable <SERVICE-NAME>` |

### Token renewal services

| **Software** | **Service name** | **Notes** |
|--------------|------------------|-----------|
| OSG Token Renewer | `osg-token-renewer.service` | The OSG Token Renewer, runs as a "oneshot" service, not a daemon. |
| OSG Token Renewer timer | `osg-token-renewer.timer` | Timer to run the OSG Token Renewer every 15 minutes |


The OSG token renewal service is set to run via a systemd timer every 15
minutes.
After configuring your account(s) and token(s), enable the timer with:

```console
root@host # systemctl enable osg-token-renewer.timer
root@host # systemctl start  osg-token-renewer.timer
```

If you would like to run the service manually at a different time (e.g., to
generate all the tokens immediately), you can run the service once with:

```console
root@host # systemctl start osg-token-renewer.service
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
---------

### Files of interest

| Path                                                     | Description                                   |
|:---------------------------------------------------------|:----------------------------------------------|
| `/etc/osg/token-renewer/config.ini`                      | Main config file for service                  |
| `/etc/osg/tokens/<ACCOUNT_SHORTNAME>.pw`                 | Encryption password file for client account   |
| `/etc/osg/tokens/<ACCOUNT_SHORTNAME>.<TOKEN_NAME>.token` | Output location for token files               |
| `/usr/sbin/osg-token-renewer-setup`                      | Setup script for each new client account      |
| `/usr/lib/systemd/system/osg-token-renewer.service`      | SystemD service unit configuruation           |
| `/usr/lib/systemd/system/osg-token-renewer.timer`        | SystemD timer for service                     |
| `/usr/libexec/osg-token-renewer/osg-token-renewer.sh`    | Main wrapper script invoked by service        |
| `/usr/libexec/osg-token-renewer/osg-token-renewer`       | Token renewal program invoked by main wrapper |


