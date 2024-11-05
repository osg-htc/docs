title: Using Bearer Tokens

Using Bearer Tokens
===================

As part of the [GridFTP and GSI migration](https://opensciencegrid.org/technology/policy/gridftp-gsi-migration/),
the OSG has transitioned authentication away from X.509 certificates to the use of bearer tokens such as
[SciTokens](http://scitokens.org/) or [WLCG JWT](https://twiki.cern.ch/twiki/bin/view/LCG/WLCGAuthorizationWG).

Use this document to learn how to request tokens from an OpenID Connect (OIDC) Provider or how to generate a test token
for validating your OSG services.

Requesting Tokens From An OIDC Provider
---------------------------------------

If you are a member of a collaboration with an OIDC provider (such as [CILogon](https://www.cilogon.org/oidc) or
[Indigo IAM](https://indigo-iam.github.io/v/v1.7.2/docs/)), you can use the
[oidc-agent](https://indigo-dc.gitbook.io/oidc-agent/) client to request tokens.
This client tool is available either as [a container](#using-a-container) or as
[an RPM installation](#using-an-rpm-installation).

Alternatively, a collaboration may choose to set up a shared 
[htvault-config](https://github.com/fermitools/htvault-config)
service that is registered as the OIDC client or clients and enables
each user to have a simpler experience to obtain tokens using the
[htgettoken](https://github.com/fermitools/htgettoken)
command while at the same time keeping long-lived refresh tokens stored
more securely.
Both of those can be installed as RPMs from OSG repos as described at the
above links, and they are also
[integrated with HTCondor](https://htcondor.readthedocs.io/en/latest/admin-manual/file-and-cred-transfer.html#using-vault-as-the-oauth-client).
OSG Software recommends those tools as documented at those links for when
collaborations are ready to use tokens in production, 
but the rest of this page gives instructions for `oidc-agent` which
is better for early experimentation with tokens.
At the [end of the page](#examining-tokens) we also recommend installing
the `htgettoken` package just for its additional `htdecodetoken` command
which is useful for looking inside tokens.

!!! tip "Alternative tokens for testing"
    If you are not a member of a collaboration with access to an OIDC provider, you can generate test SciTokens using
    [these instructions](#generating-scitokens-for-testing)

### Using a Container

#### Registering an OIDC profile

!!! info "Where is the OSG 24 container?"
    We are actively reworking our image build infrastructure for OSG 24 and expect to have all OSG Software containers
    available by the end of 2024.

1. Start an agent container in the background and name it `my-agent` to easily run subsequent commands against it:

        :::console
        docker run -d --name my-agent opensciencegrid/oidc-agent:23-release

1. Generate a local client profile and follow the prompts:

        :::console
        docker exec -it my-agent oidc-gen -w device <CLIENT PROFILE>

    1. Specify an OIDC provider such as CILogon or an IAM instance as the client issuer.
       For example, if you are requesting tokens from the WLCG IAM instance:

            Issuer [https://iam-test.indigo-datacloud.eu/]: https://wlcg.cloud.cnaf.infn.it/

    1. Request scopes for the capabilities that you need based on the type of tokens that your provider issues:

        | **Capability**   | **SciTokens Scope** | **WLCG Scope**                                 |
        |:-----------------|---------------------|------------------------------------------------|
        | HTCondor `READ`  | `condor:/READ`      | `compute.read`                                 |
        | HTCondor `WRITE` | `condor:/WRITE`      | `compute.modify compute.cancel compute.create` |
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
        | HTCondor `READ`  | `condor:/READ`      | `compute.read`                                 |
        | HTCondor `WRITE` | `condor:/WRITE`      | `compute.modify compute.cancel compute.create` |
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


        "scope": "<space separated list of scopes>",

    Replacing `<list of scopes>` appropriate for the service and authorization that you are interested in testing:

    | **Capability**   | **Scope**      | **Note**                    |
    |:-----------------|----------------|-----------------------------|
    | HTCondor `READ`  | `condor:/READ`  | Required for job submission |
    | HTCondor `WRITE` | `condor:/WRITE` | Required for job submission |
    | XRootD read      | `read:<PATH>`  |                             |
    | XRootD write     | `write:<PATH>` |                             |

1.  Copy the entire contents of the `Encoded` window to a file where you will be running your client commands

1.  Add `https://demo.scitokens.org` (and subject if appropriate) to your service's configuration to authenticate your
    new test token

    !!! danger "Remove test mappings"
        After completing testing, remove any test `demo.scitokens.org` mappings that you have added as anyone is capable
        of creating a demo SciToken.

Using Tokens
------------

Client tools such as `condor_submit` or `xrdcp` will search for your access token in order of the following locations:

1.  Token contents in the `$BEARER_TOKEN` environment variable
1.  Path to the token in the `$BEARER_TOKEN_FILE` environment variable
1.  Path to the token in `$XDG_RUNTIME_DIR/bt_u$UID`
1.  Token saved to `/tmp/bt_u$UID`

For more details, see the [WLCG Bearer Token Discovery technical note](https://zenodo.org/record/3937438).

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
    1.  Install `htgettoken`:

            # yum install htgettoken

    2.  Write the token to a file named `tok` or store it in one of the
        default WLCG Bearer Token Discovery locations described above.
    3.  Run `htdecodetoken -H tok` or leave off the `tok` filename if
        it is in one of the default locations.

    `htdecodetoken` is one of the
    [additional commands](https://github.com/fermitools/htgettoken#additional-commands)
    that come with the `htgettoken` package.
