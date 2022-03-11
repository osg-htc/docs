DateReviewed: 2022-03-10
=======
Bearer Token Overview
=====================

Bearer Tokens are a security method used for accessing compute and storage resources,
introduced as a replacement for X.509.

Bearer Tokens are credential strings in the [JSON Web Token (JWT)](https://jwt.io) format;
a JWT is a small piece of JSON data with a signature that can be verified.
There are two JWT-based token standards that can be used with OSG software: [SciTokens](https://scitokens.org)
and [WLCG Tokens](https://github.com/WLCG-AuthZ-WG/common-jwt-profile/blob/master/profile.md).

X.509 proxies established identity (the DN in your subject) and group membership (VOMS FQANs).
Servers made decisions about access based on those properties.
Tokens also have 'scope' which can restrict the actions that can be done with the token.
For example, a token used for storage access can restrict the files that can be read to a particular directory tree.
Instead of using a single proxy, a job may have multiple tokens.
For example the job could have one token granting it the ability to be run;
it could have a token for read access to an input dataset, and a token for write access to a results directory.





Validating Tokens in Pilot Jobs
-------------------------------

If an incoming (pre-routed) pilot on a CE has a token, it will have the following classad attributes:

| Attribute        | Meaning                             |
|------------------|-------------------------------------|
| AuthTokenId      | A UUID of the token                 |
| AuthTokenIssuer  | The URL of the issuer of the token  |
| AuthTokenScopes  | Any scope restrictions on the token |
| AuthTokenSubject | The 'sub' field of the token        |

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
