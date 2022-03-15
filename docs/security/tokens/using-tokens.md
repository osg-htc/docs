Using Bearer Tokens
===================

As part of the [GridFTP and GSI migration](https://opensciencegrid.org/technology/policy/gridftp-gsi-migration/),
the OSG will be transitioning authentication away from X.509 certificates to the use of bearer tokens such as
[SciTokens](http://scitokens.org/) or [WLCG JWT](https://twiki.cern.ch/twiki/bin/view/LCG/WLCGAuthorizationWG).

Use this document to learn how to request tokens from an OpenID Connect (OIDC) Provider or how to generate a test token
for validating your OSG services.

Requesting Tokens From An OIDC Provider
---------------------------------------

If you are a member of a collaboration with an OIDC provider (such as [CILogon](https://www.cilogon.org/oidc) or
[Indigo IAM](https://indigo-iam.github.io/v/v1.7.2/docs/)), you can use the
[oidc-agent](https://indigo-dc.gitbook.io/oidc-agent/) client to request tokens.
This client tool is available either as [a container](#using-a-container) or as
[an RPM installation](#using an RPM installation).

!!! tip "Alternative tokens for testing"
    If you are not a member of a collaboration with access to an OIDC provider, you can generate test SciTokens using
    [these instructions](#generating-scitokens-for-testing)

### Using a Container

#### Registering an OIDC profile

1. Start an agent container in the background and name it `my-agent` to easily run subsequent commands against it:

        :::console
        docker run -d --name my-agent opensciencegrid/oidc-agent:3.6-release

1. Generate a local client profile and follow the prompts:

        :::console
        docker exec -it my-agent oidc-gen -w device <CLIENT PROFILE>

    1. Specify an OIDC provider such as CILogon or an IAM instance as the client issuer.
       For example, if you are requesting tokens from the WLCG IAM instance:

            Issuer [https://iam-test.indigo-datacloud.eu/]: https://wlcg.cloud.cnaf.infn.it/

    1. Request scopes for the capabilities that you need based on the type of tokens that your provider issues:

        | **Capability**   | **SciTokens Scope** | **WLCG Scope**                                 |
        |:-----------------|---------------------|------------------------------------------------|
        | HTCondor `READ`  | `condor:READ`      | `compute.read`                                 |
        | HTCondor `WRITE` | `condor:WRITE`      | `compute.modify compute.cancel compute.create` |
        | XRootD read      | `read:<PATH>`       | `storage.read:<PATH>`                          |
        | XRootD write     | `write:<PATH>`      | `storage.modify:<PATH>`                        |

        Replacing `<PATH>` with a path to the storage location that the bearer should be authorized to access.
        If you are requesting WLCG tokens, you will need to also add the `wlcg` and `offline_access` scopes.
        For example, to request HTCondor `READ` and `WRITE` access from an OIDC provider issuing WLCG tokens,
        specify the following when prompted for a space delimited list of scopes:

            wlcg offline_access compute.read compute.modify compute.cancel compute.create
    
    1. When prompted, open the verification URL provided a browser, enter the code provided by `oidc-gen`,
       and click "Submit".

    1. Follow the instructions in your browser to authorize your new `oidc-agent` client

    1. Back in your terminal, enter a password to encrypt your local client profile.
       You'll need to remember this if you want to re-use this profile in subsequent sessions.

#### Requesting access tokens

!!! note
    You must first [register a new profile](#registering-an-oidc-profile).

1. Request a token using the client profile that you used with `oidc-gen`:
	
        :::console
        docker exec -it my-agent oidc-token --aud="<SERVER AUDIENCE>" <CLIENT PROFILE>


    For tokens used against an HTCondor-CE, set `<SERVER AUDIENCE>` to `<CE FQDN>:<CE PORT>`.

1. Copy the output of `oidc-token` into a file on the host where you need bearer token authentication, e.g. an HTCondor
   or XRootD client.

#### Reloading an OIDC profile

!!! note
    Required after restarting the running container. You must have an existing [registered profile](#registering-an-oidc-profile).

1. If your existing container is not already running, start it:

        :::console
        docker start my-agent

1. Reload profile:

        :::console
        docker exec -it my-agent oidc-add <CLIENT PROFILE>


1. Enter the password used to encrypt your `<CLIENT PROFILE>` created during profile registration.


### Using an RPM installation

#### Registering an OIDC profile

1. Start the agent and add the appropriate variables to your environment:

        :::console
        eval `oidc-agent`

1. Generate a local client profile and follow the prompts:

        :::console
        oidc-gen -w device <CLIENT PROFILE>

    1. Specify an OIDC provider such as CILogon or an IAM instance as the client issuer.
       For example, if you are requesting tokens from the WLCG IAM instance:

            Issuer [https://iam-test.indigo-datacloud.eu/]: https://wlcg.cloud.cnaf.infn.it/

    1. Request scopes for the capabilities that you need based on the type of tokens that your provider issues:

        | **Capability**   | **SciTokens Scope** | **WLCG Scope**                                 |
        |:-----------------|---------------------|------------------------------------------------|
        | HTCondor `READ`  | `condor:READ`      | `compute.read`                                 |
        | HTCondor `WRITE` | `condor:WRITE`      | `compute.modify compute.cancel compute.create` |
        | XRootD read      | `read:<PATH>`       | `storage.read:<PATH>`                          |
        | XRootD write     | `write:<PATH>`      | `storage.modify:<PATH>`                        |

        Replacing `<PATH>` with a path to the storage location that the bearer should be authorized to access.
        If you are requesting WLCG tokens, you will need to also add the `wlcg` and `offline_access` scopes.
        For example, to request HTCondor `READ` and `WRITE` access from an OIDC provider issuing WLCG tokens,
        specify the following when prompted for a space delimited list of scopes:

            wlcg offline_access compute.read compute.modify compute.cancel compute.create
    
    1. When prompted, open the verification URL provided a browser, enter the code provided by `oidc-gen`,
       and click "Submit".

    1. Follow the instructions in your browser to authorize your new `oidc-agent` client

    1. Back in your terminal, enter a password to encrypt your local client profile.
       You'll need to remember this if you want to re-use this profile in subsequent sessions.

#### Requesting access tokens

!!! note
    You must first [register a new profile](#registering-an-oidc-profile_1).

1. Request a token using the client profile that you used with `oidc-gen`:

        :::console
        oidc-token --aud="<SERVER AUDIENCE>" <CLIENT PROFILE>

    For tokens used against an HTCondor-CE, set `<SERVER AUDIENCE>` to  
    `<CE FQDN>:<CE PORT>`.

1. Copy the output of `oidc-token` into a file on the host where you need bearer token authentication, e.g. an HTCondor
   or XRootD client.

#### Reloading an OIDC profile

!!! note
    Required if you log out of the running machine. You must have an existing [registered profile](#registering-an-oidc-profile_1).

1. If you do not already have a running 'oidc-agent', start one:

        :::console
        eval 'oidc-agent'

1. Reload profile:

        :::console
        oidc-add <CLIENT PROFILE>


1. Enter the password used to encrypt your `<CLIENT PROFILE>` created during profile registration.

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

1.  Copy the entire contents of the `Encoded` window to a file where you will be running your client commands

1.  Add `https://demo.scitokens.org` (and subject if appropriate) to your service's configuration to authenticate your
    new test token

    !!! danger "Remove test mappings"
        After completing testing, remove any test `demo.scitokens.org` mappings that you have added as anyone is capable
        of creating a demo SciToken.

Troubleshooting Tokens
----------------------

### Validating tokens

A token must be a _one-line_ string consisting of 3 base64-encoded parts separated by periods (`.`).
You can use the tools in the `scitokens-cpp` RPM to validate a SciToken or WLCG token.

-   Run `scitokens-verify <TOKEN>` (where `<TOKEN>` is the text of the token) to validate the token using the issuer.

-   Run `scitokens-list-access <TOKEN> <ISSUER> <AUDIENCE>` (where `<TOKEN>` is the text of the token,
    `<ISSUER>` is the issuer to verify the token with,
    and `<AUDIENCE>` is the server you are using the token to access).

### Examining tokens

-   Online: paste the token into <https://jwt.io>.

-   Offline:
    1.  Write the token to a file named `tok`.
    2.  Run `IFS=. read header payload signature < tok`.
    3.  Run `echo $header | base64 -d` to examine the header.
        Run `echo $payload | base64 -d` to examine the payload.
        Note: the header or payload may be missing the final padding characters (up to 2 `=` characters);
        adding them (e.g. `echo $payload== | base64 -d`) should make base64 stop complaining about "invalid input" or
        "truncated input".
