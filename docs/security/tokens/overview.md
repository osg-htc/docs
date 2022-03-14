DateReviewed: 2022-03-10
Bearer Token Overview
=====================

Token-based Authentication and Authorization Infrastructure (AAI) is a security method
that is intended as the replacement for X.509 for accessing compute and storage resources.
This document will describe "bearer tokens," which are one of the components of Token AAI;
bearer tokens are the type of token that server software such as HTCondor and XRootD will primarily interact with.

A bearer token (sometimes called an "access token") is a short-lived credential,
performing a similar role as a grid proxy did in X.509.
X.509 proxies established identity (the DN in your subject) and group membership (VOMS FQANs).
Servers made decisions about access based on those properties.
Tokens also have 'scope' which can restrict the actions that can be done with the token.
For example, a token used for storage access can restrict the files that can be read to a particular directory tree.
Instead of using a single proxy, a job may have multiple tokens.
For example the job could have one token granting it the ability to be run;
it could have a token for read access to an input dataset, and a token for write access to a results directory.


Token Components
----------------

Bearer tokens are credential strings in the [JSON Web Token (JWT)](https://jwt.io) format.
A JWT consists of a JSON header, a JSON payload, and a signature that can be verified.
The payload contains a number of fields, called "claims", that describe the token and what it can access.

There are two JWT-based token standards that can be used with OSG software: [SciTokens](https://scitokens.org)
and [WLCG Tokens](https://github.com/WLCG-AuthZ-WG/common-jwt-profile/blob/master/profile.md).
These standards describe the claims that are used in the payload of the JWT.

SciTokens and WLCG Tokens are similar standards and have some common claims:

**Issuer ("iss")**

The issuer identifies the organization that issued the token.
An issuer looks like an HTTPS URL;
this URL must be valid and publicly accessible as they are used by site services to validate the token.
Token issuers will be described below.

**Subject ("sub")**

The subject identifies an entity (which could be a human or a robot) that owns the token.
Unlike the subject of an X.509 certificate, a token subject does not need to be globally unique,
only unique to the issuer.
Subjects will be elaborated on below.

**Issued-at ("iat"), not-before ("nbf"), expiration ("exp")**

These claims are Unix timestamps that specify when the token was issued, and its lifespan.

**Audience ("aud")**

The audience is a server (or a JSON list of servers) that the token may be used on;
it is typically a hostname, host:port, or URI.
For example a token used for submitting a job to a CE would have
`<CE FQDN>:<CE PORT>` in the `aud` claim.
The special values `ANY` (SciTokens) or `https://wlcg.cern.ch/jwt/v1/any` (WLCG Tokens) allow the token to be
used on any server.

**Scope ("scope")**

The scope limits the actions that can be made using the token.
The format of the scope claim differs between SciTokens and WLCG Tokens;
scopes in use by OSG services will be listed below.
    

### Issuer ###

To generate bearer tokens, a collaboration must adminster at least one "token issuer" to issue tokens to their users.
In addition to generating and signing tokens, token issuers provide a public endpoint that can be used to validate an
issued token,
e.g. an OSG Compute Entrypoint (CE) will contact the token issuer to authorize a bearer token used for pilot job
submission.

The issuer is listed in the `iss` claim; this should be an HTTPS URL of a web server.
This server must have the public key that can be used to validate the token in a well-known location,
as described by the [OpenID Connect Discovery standard](https://openid.net/specs/openid-connect-discovery-1_0.html).
If the issuer is down, or the the public key cannot be downloaded, the token cannot be verified
and will be rejected.

A collaboration may have more than one token issuer,
but a single token issuer should never serve more than one collaboration.
The issuer claim should be able to uniquely identify the collaboration that identifies the token.


### Subject ###

The subject is listed in the `sub` claim and should be unique, stable identifier that corresponds to a user (human)
or a service (robot or pilot job submission).
A subject does not need to be globally unique but it must be unique to the issuer.
The subject, when combined with the issuer, will give a globally unique identity
that can be used for mapping, banning, accounting, monitoring, auditing, or tracing.

!!! note
    Due to privacy concerns, the subject may be a randomly generated string, hash, UUID, etc.,
    that does not contain any personally identifying information.
    Tracing a token to a user or service may require contacting the issuer.


### Scopes and WLCG Groups ###

The `scope` claim is a space-separated list of authorizations that should be granted to the bearer.
Scopes utilized by OSG services include the following:

| **Capability**   | **SciTokens scope** | **WLCG scope**                                 |
|------------------|---------------------|------------------------------------------------|
| HTCondor `READ`  | `condor:/READ`      | `compute.read`                                 |
| HTCondor `WRITE` | `condor:/WRITE`     | `compute.modify compute.cancel compute.create` |
| XRootD read      | `read:<PATH>`       | `storage.read:<PATH>`                          |
| XRootD write     | `write:<PATH>`      | `storage.modify:<PATH>`                        |

Replacing `<PATH>` with a path to the storage location that the bearer should be authorized to access.

A SciToken must have a non-empty scope, or it cannot be used to do anything.

A WLCG Token may have a `wlcg.groups` claim instead of a scope.
This is a comma and space separated list of collaboration groups.
The format of these groups are similar to VOMS FQANs: `/<collaboration>[/<group>][/Role=<role>]`,
replacing `<collaboration>`, `<group>`, and `<role>` with the collaboration, group, and role, respectively, where the
group and role are optional.
For example, the following groups and roles have been used by the ATLAS and CMS collaborations:

```
/atlas/
/atlas/usatlas
/cms/Role=pilot
/cms/local/Role=pilot
```


Using Bearer Tokens with HTCondor-CE 
------------------------------------

In order to support Token AAI, your CE must be based on OSG 3.6 or OSG 3.5-upcoming.
You will need HTCondor 9.0.0 or newer, and `SCITOKENS` must be enabled as an auth method (this is the default).

You must have a mapfile which provides mappings from bearer tokens to Unix usernames,
based on the token's issuer and, optionally, subject.
The OSG distributes the `osg-scitokens-mapfile` RPM package that includes default mappings for use by OSG CEs.

Token mapfile lines look like:
```
SCITOKENS /^https\:\/\/scitokens\.org\/ligo,/ ligo
SCITOKENS /^https\:\/\/cilogon\.org\/gm2,gm2pilot\@fnal\.gov$/ gm2pilot
```
These are regular expressions; the first matches a token with the issuer `https://scitokens.org/ligo`
and any subject, and maps it to the `ligo` user.
Note the trailing `,` in the regular expression: this separates the issuer from the subject.

The second example matches the issuer `https://cilogon.org/gm2` _and_ the subject `gm2pilot@fnal.gov`,
and maps it to the `gm2pilot` user.

A `SCITOKENS` mapfile line supports WLCG tokens as well.
Note that mapping can only be done on issuer and subject, _not_ `wlcg.groups`.

See the [configuring authentication documentation for HTCondor-CE]
(https://opensciencegrid.org/docs/compute-element/install-htcondor-ce/#configuring-authentication)
for further information.


Using Bearer Tokens with XRootD
-------------------------------

In order to support Token AAI, your XRootD installation must be based on OSG 3.6 or OSG 3.5-upcoming.
You will need XRootD 5.0.2 or newer, with the `xrootd-scitokens` plugin.
Follow the [configuring XRootD authorization documentation](https://opensciencegrid.org/docs/data/xrootd/xrootd-authorization)
for information on how to configure XRootD to accept bearer tokens.


Validating Tokens in Pilot Jobs
-------------------------------

If an incoming (pre-routed) pilot on a CE has a token, it will have the following classad attributes:

| Attribute        | Meaning                              |
|------------------|--------------------------------------|
| AuthTokenId      | A UUID of the token                  |
| AuthTokenIssuer  | The URL of the issuer of the token   |
| AuthTokenScopes  | Any scope restrictions on the token  |
| AuthTokenSubject | The `sub` claim of the token         |
| AuthTokenGroups  | The `wlcg.groups`, if any, claim of the token |

(A pre-routed job is a job without `RoutedJob=True` in its classad.)

!!! note
    A job may have both a token and an X.509 proxy.
    Presence of any `x509*` attributes does not indicate the absence of a token.

To see which authentication method was used for a job:
-   Examine the `/var/log/condor-ce/AuditLog*` files.
-   Find a line saying `Submitting new job <JOBID>` (where `<JOBID>` is a job ID like `21249.0`).
    The line before that should say what authentication method was used.
    -   Authentication via a token will say `AuthMethod=SCITOKENS`.
    -   Authentication via a proxy will say `AuthMethod=GSI`.

See the [upstream documentation](https://htcondor.com/htcondor-ce/v5/troubleshooting/common-issues/#jobs-fail-to-submit-verify-scitoken-contents)
for more details.

Collaboration support
---------------------

!!! info "Verify support with collaborations"
    The tables of collaborations below are updated as frequently as possible.
    If a collaboration you support is listed as not supporting tokens or WebDav, please contact your collaboration
    directly to verify that this information is up-to-date.

### Pilot job submission ###

These are the collaborations that support or partially support using tokens for pilot submission:

| Collaboration | Supports Bearer Tokens |
|:--------------|------------------------|
| ATLAS         | Undergoing testing     |
| CLAS12        | Undergoing testing     |
| CMS           | Undergoing testing     |
| EIC           | Undergoing testing     |
| GLOW          | Yes                    |
| GlueX         | Undergoing testing     |
| IceCube       | Undergoing testing     |
| LIGO          | Undergoing testing     |
| OSG           | Yes                    |

Until all of the collaborations you support are using tokens in production, your CE should remain on OSG 3.5,
with the 3.5-upcoming repositories enabled.

### WebDAV/XRootD File transfer ###

The following collaborations support support file transfer using WebDAV or XRootD:

| Collaboration | Supports WebDAV or XRootD |
|:--------------|---------------------------|
| ATLAS         | Yes                       |
| CMS           | Yes                       |
| CLAS12        | Yes                       |
| EIC           | N/A                       |
| GLOW          | N/A                       |
| GlueX         | No                        |
| IceCube       | Undergoing testing        |
| LIGO          | Undergoing testing        |
| OSG           | N/A                       |


Debugging Tokens
----------------

Validating a token:

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
        adding them (e.g. `echo $payload== | base64 -d`) should make base64 stop complaining about "invalid input" or "truncated input".



Help
----

To get assistance, please use the [this page](https://opensciencegrid.org/docs/common/help/).


References and Links
--------------------

-   [OSG Technology - Collaborations and Bearer Tokens](https://opensciencegrid.org/technology/policy/collab-bearer-tokens/)
-   [JSON Web Tokens](https://jwt.io) - includes token decoder
-   [SciTokens](https://scitokens.org)
    -   [SciToken Claims and Scopes Language](https://scitokens.org/technical_docs/Claims)
    -   [SciTokens Demo](https://demo.scitokens.org/) - includes token generator, verifier, and links to libraries
-   [WLCG Common JWT Profiles](https://github.com/WLCG-AuthZ-WG/common-jwt-profile/blob/master/profile.md)
