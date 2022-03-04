Token Authentication Overview
=============================



How to Tell When Incoming Jobs Are Using Tokens
-----------------------------------------------

The authentication method of a job is recorded in two places: the `AuditLog` files in `/var/log/condor-ce`.
In addition, an incoming (pre-routed) job on a CE will have the following classad attributes:

| AuthTokenId      | A UUID of the token                 |
| AuthTokenIssuer  | The URL of the issuer of the token  |
| AuthTokenScopes  | Any scope restrictions on the token |
| AuthTokenSubject | The 'sub' field of the token        |

(A pre-routed job is a job without `RoutedJob=True` in its classad.)

Note: a job may have both a token and an X.509 proxy;
presence of any `x509*` attributes does not indicate the absence of a token.

To see which authentication method was used for a job, look at the `/var/log/condor-ce/AuditLog*` files.
Find a line saying `Submitting new job <JOBID>` (where `<JOBID>` is a job ID like `21249.0`).
The line before that should say what authentication method was used.
Authentication via a token will say `AuthMethod=SCITOKENS`;
authentication via a proxy will say `AuthMethod=GSI`.


VOs Supporting Token Authentication for Pilot Submission
--------------------------------------------------------

These are the VOs that support or partially support using tokens for pilot submission:

| VO Name | Testing Tokens | Using Tokens in Production |
|:--------|----------------|----------------------------|
| ATLAS   | Yes            | No                         |
| CMS     | Yes            | No                         |
| GLOW    | Yes            | Yes                        |
| OSG     | Yes            | Yes                        |

Until all of the VOs you support are using tokens in production, your CE has to remain on OSG 3.5,
with the 3.5-upcoming repositories enabled.

