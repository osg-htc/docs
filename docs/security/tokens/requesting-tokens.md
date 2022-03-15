How to Request Tokens
=====================

As part of the [GridFTP and GSI migration](../policy/gridftp-gsi-migration.md), the OSG will be transitioning authentication
away from X.509 certificates to the use of bearer tokens such as [SciTokens](http://scitokens.org/) or
any OAUTH2 OpenID Connect provider such as [CILogon OpenID Connect](https://www.cilogon.org/oidc) or
[WLCG JWT](https://twiki.cern.ch/twiki/bin/view/LCG/WLCGAuthorizationWG).

## Before Starting

Before you can request the appropriate tokens, you must have the following:

-   One of the following:
    -   The ability to run containers through tools like `docker` or `podman`
    -   An installation of [oidc-agent](https://indigo-dc.gitbook.io/oidc-agent/) available as an RPM from the OSG
        repositories
-   An account at an OAUTH provider
    -   [CILogon OpenID Connect](https://www.cilogon.org/oidc)
    -   A [WLCG INDIGO IAM](https://wlcg.cloud.cnaf.infn.it/) account belonging to the `wlcg`, `wlcg/pilots`, and `wlcg/xfers`
        groups.
    -   If no account available, use the [SciTokens demo site](https://demos.scitokens.org/)

## Requesting Tokens Using a Container

[oidc-agent](https://indigo-dc.gitbook.io/oidc-agent/) is a process that runs in the background that can request access
and refresh tokens from OpenID Connect token providers.

### Registering an OIDC profile

1. Start an agent container in the background and name it `my-agent` to easily run subsequent commands against it:

        :::console
        docker run -d --name my-agent opensciencegrid/oidc-agent:release

1. Generate a local client profile and follow the prompts:

        :::console
        docker exec -it my-agent oidc-gen -w device <CLIENT PROFILE>

    1. Specify an OAUTH2 provider such as CILogon or any IAM instance as the client issuer:

            Issuer [https://iam-test.indigo-datacloud.eu/]: https://wlcg.cloud.cnaf.infn.it/

    1. Request `wlcg`, `offline_access`, and other scopes for the capabilities that you need:

        | **Capability**   | **Scope**                     |
        |------------------|-------------------------------|
        | HTCondor `READ`  | `compute.read`                |
        | HTCondor `WRITE` | `compute.modify compute.cancel compute.create` |
        | XRootD read      | `read:/`                      |
        | XRootD write     | `write:/`                     |

        For example, to request HTCondor `READ` and `WRITE` access, specify the following scopes:

            This issuer supports the following scopes: openid profile email address phone offline_access wlcg iam wlcg.groups
            Space delimited list of scopes or 'max' [openid profile offline_access]: wlcg offline_access compute.read compute.modify compute.cancel compute.create
    
    1. When prompted, open <https://wlcg.cloud.cnaf.infn.it/device> in a browser, enter the code provided by `oidc-gen`,
       and click "Submit".

    1. On the next page, verify the scopes and client profile name, and click "Authorize".

    1. Enter a password to encrypt your local client profile.
       You'll need to remember this if you want to re-use this profile in subsequent sessions.

### Requesting access tokens

!!! note
    You must first [register a new profile](#registering-an-oidc-profile).

1. Request a token using the client profile that you used with `oidc-gen`:
	
        :::console
        docker exec -it my-agent oidc-token --aud="<SERVER AUDIENCE>" <CLIENT PROFILE>


    For tokens used against an HTCondor-CE, set `<SERVER AUDIENCE>` to  
    `<CE FQDN>:<CE PORT>`.

1. Copy the output of `oidc-token` into a file on the host where you need SciToken authentication, e.g. an HTCondor or
   XRootD client.

### Reloading an OIDC profile

!!! note
    Required after restarting the running container. You must have an existing [registered profile](#registering-an-oidc-profile).

1. If your existing container is not already running, start it:

        :::console
        docker start my-agent

1. Reload profile:

        :::console
        docker exec -it my-agent oidc-add <CLIENT PROFILE>


1. Enter password used to encrypt your `<CLIENT PROFILE>` created during profile registration.


## Requesting Tokens with an RPM installation

### Registering an OIDC profile

1. Start the agent and add the appropriate variables to your environment:

        :::console
        eval `oidc-agent`

1. Generate a local client profile and follow the prompts:

        :::console
        oidc-gen -w device <CLIENT PROFILE>

    1. Specify an OAUTH2 provider such as CILogon or any IAM instance as the client issuer:

            Issuer [https://iam-test.indigo-datacloud.eu/]: https://wlcg.cloud.cnaf.infn.it/

    1. Request `wlcg`, `offline_access`, and other scopes for the capabilities that you need:

        | **Capability**   | **Scope**                     |
        |------------------|-------------------------------|
        | HTCondor `READ`  | `compute.read`                |
        | HTCondor `WRITE` | `compute.modify compute.cancel compute.create` |
        | XRootD read      | `read:/`                      |
        | XRootD write     | `write:/`                     |
         For example, to request HTCondor `READ` and `WRITE` access, specify the following scopes:

            This issuer supports the following scopes: openid profile email address phone offline_access wlcg iam wlcg.groups
            Space delimited list of scopes or 'max' [openid profile offline_access]: wlcg offline_access compute.read compute.modify compute.cancel compute.create
    
    1. When prompted, open <https://wlcg.cloud.cnaf.infn.it/device> in a browser, enter the code provided by `oidc-gen`,
       and click "Submit".

    1. On the next page, verify the scopes and client profile name, and click "Authorize".

    1. Enter a password to encrypt your local client profile.
       You'll need to remember this if you want to re-use this profile in subsequent sessions.

### Requesting access tokens

!!! note
    You must first [register a new profile](#registering-an-oidc-profile_1).

1. Request a token using the client profile that you used with `oidc-gen`:

        :::console
        oidc-token --aud="<SERVER AUDIENCE>" <CLIENT PROFILE>

    For tokens used against an HTCondor-CE, set `<SERVER AUDIENCE>` to  
    `<CE FQDN>:<CE PORT>`.

1. Copy the output of `oidc-token` into a file on the host where you need SciToken authentication, e.g. an HTCondor or
   XRootD client.

### Reloading an OIDC profile

!!! note
    Required if you log out of the running machine. You must have an existing [registered profile](#registering-an-oidc-profile_1).

1. If you do not already have a running 'oidc-agent', start one:

        :::console
        eval 'oidc-agent'

1. Reload profile:

        :::console
        oidc-add <CLIENT PROFILE>


1. Enter password used to encrypt your `<CLIENT PROFILE>` created during profile registration.

Generating SciTokens For Testing
--------------------------------

If you are not a member of a collaboration with an OIDC Provider and would like to validate token functionality with
your HTCondor-CE or XRootD service, you can use the [SciTokens demo website](https://demo.scitokens.org):

1.  Open <https://demo.scitokens.org> in a browser window

1.  Add a subject claim to the generated token by adding the following to the `PAYLOAD: DATA` window, between the curly
    braces:

        "sub": "<subject string>",

    Replacing `<subject string>` with a subject appropriate for the service that you are testing:

    -   Any random string for an HTCondor-CE, which should be reflected in your token mapping
    -   If you are using `xrootd-multiuser`, a local Unix username

1.  Add a scopes claim to the generated token by adding the following to the `PAYLOAD: DATA` window, between the curly
    braces:


        "scope": "<list of scopes>",

    Replacing `<list of scopes>` appropriate for the service and authorization that you are interested in testeing.

1.  Copy the entire contents of the `Encoded` window to a file where you will be running our client commands

1.  Add `https://demo.scitokens.org` (and subject if appropriate) to your service's configuration to authenticate your
    new test token

## Troubleshooting Tokens

A token must be a _one-line_ string consisting of 3 base64-encoded parts separated by periods (`.`).
You can use the tools in the `scitokens-cpp` RPM to validate a SciToken or WLCG token.

-   Run `scitokens-verify <TOKEN>` (where `<TOKEN>` is the text of the token) to validate the token using the issuer.

-   Run `scitokens-list-access <TOKEN> <ISSUER> <AUDIENCE>` (where `<TOKEN>` is the text of the token,
    `<ISSUER>` is the issuer to verify the token with,
    and `<AUDIENCE>` is the server you are using the token to access).

Examining a token:

-   Online: paste the token into <https://jwt.io>.

-   Offline:
    1.  Write the token to a file named `tok`.
    2.  Run `IFS=. read header payload signature < tok`.
    3.  Run `echo $header | base64 -d` to examine the header.
        Run `echo $payload | base64 -d` to examine the payload.
        Note: the header or payload may be missing the final padding characters (up to 2 `=` characters);
        adding them (e.g. `echo $payload== | base64 -d`) should make base64 stop complaining about "invalid input" or
        "truncated input".
