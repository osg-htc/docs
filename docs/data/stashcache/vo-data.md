title: Getting VO Data into the OSDF

Getting VO Data into the OSDF
======================================

This document describes the steps required to manage a VO's role
in the Open Science Data Federation (OSDF) including selecting a namespace, registration,
and selecting which resources are allowed to host or cache your data.

For general information about the OSDF, see the [overview document](overview.md).

Site admins should work together with VO managers in order to perform these steps.


Definitions
-----------

- **Namespace:** a directory tree in the federation that is used to find VO data.
- **Public data:** data that can be read by anyone.
- **Protected data:** data that requires authorization to read.


Requirements
------------

In order for a Virtual Organization to join the federation, the VO must already be registered in OSG Topology.
See the [registration document](../../common/registration.md#registering-virtual-organizations).



Choosing Namespaces
-------------------

The VO must pick one or more "namespaces" for their data.
A namespace is a directory tree in the federation where VO data is found.

!!! note
    Namespaces are global across the federation, so you must work with the OSG Operations team
    to ensure that your VO's namespaces do not collide with those of another VO.
    
    Send an email to help@osg-htc.org with the following subject:
    "Requesting OSDF namespaces for VO <VO>"
    and put the desired namespaces in the body of the email.

A namespace should be easy for your users to remember but not so generic that it collides with other VOs.
We recommend using the lowercase version of your VO as the top-level directory.
In addition, public data, if any, should be stored in a subdirectory named `PUBLIC`,
and protected data, if any, should be stored in a subdirectory named `PROTECTED`.

Putting this together, if your VO is named `Astro`, you should have:

- `/astro/PUBLIC` for public data
- `/astro/PROTECTED` for protected data

Separating the public and protected data in separate directory trees is preferred for technical reasons.


Registering Data Federation Information
---------------------------------------

The VO must allow one or more origins to host their data.
An origin will typically be hosted on a site owned by the VO.
For information about setting up an origin, see the [installation document](install-origin.md).

In order to declare your VO's role in the federation,
you must add OSDF information to your VO's YAML file in the OSG Topology repository.

For example, the full registration for the `Astro` VO may look something like the following:

```yaml
DataFederations:
  StashCache:
    Namespaces:
      - Path: /astro/PUBLIC
        Authorizations:
          - PUBLIC
        AllowedCaches:
          - ANY
        AllowedOrigins:
          - ASTRO_OSDF_ORIGIN

      - Path: /astro/PROTECTED
        Authorizations:
          - FQAN: /Astro
          - DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=People/CN=Matyas Selmeci
          - SciTokens:
              Issuer: https://astro.org
              Base Path: /astro/PROTECTED
        AllowedCaches:
          - ASTRO_EAST_CACHE
          - ASTRO_WEST_CACHE
        AllowedOrigins:
          - ASTRO_AUTH_OSDF_ORIGIN

```

The sections are described below.


### Namespaces section

In the namespaces section, you will declare one or more namespaces.
A namespace is a directory tree in the data federation that is owned by a VO/collaboration.

Each namespace requires:
- a `Path` that is the path to the directory tree, e.g. `/astro/PUBLIC`
- an `Authorizations` list which describes how users are authorized to access data within the namespace
- an `AllowedCaches` list of the OSDF caches that are allowed to cache the data within the namespace
- an `AllowedOrigins` list of the OSDF origins that are allowed to serve the data within the namespace

In addition, a namespace may have the following optional attributes:
- a `Writeback` endpoint that is an HTTPS URL like `https://stash-xrd.osgconnect.net:1094`
  that can be used for jobs to write data to the origin
- a `DirList` endpoint that is an HTTPS URL like `https://origin-auth2001.chtc.wisc.edu:1095`
  that can be used for getting a directory listing of that namespace

### Authorizations list

The Authorizations list of each namespace describes how a user can get authorized in order to access the data within the namespace.
The list will contain one or more of these:

- `FQAN: <VOMS FQAN>` allows someone using a proxy with the specified VOMS FQAN
- `DN: <DN>` allows someone using a proxy with that specific DN
- `PUBLIC` allows anyone; this is used for public data
- `SciTokens` allows someone using a SciToken with the given parameters, which are described [below](#scitokens)

A complete declaration looks like:
```yaml
    Namespaces:
      - Path: /astro/PUBLIC
        Authorizations:
          - PUBLIC
        AllowedCaches: ...
        AllowedOrigins: ...

      - Path: /astro/PROTECTED
        Authorizations:
          - FQAN: /Astro
          - DN: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=People/CN=Matyas Selmeci
          - SciTokens:
              Issuer: https://astro.org
              Base Path: /astro/PROTECTED
              Map Subject: True
        AllowedCaches: ...
        AllowedOrigins: ...
```

This declares two namespaces: `/astro/PUBLIC` for public data, and `/astro/PROTECTED`
which can only be read by someone with the `/Astro` FQAN, by Matyas Selmeci,
or by someone with a SciToken issued by `https://astro.org`.


#### SciTokens

A SciTokens authorization has multiple parameters:

- `Issuer` (required) is the token issuer of the SciToken that the authorization accepts.
  
- `Base Path` (required) is a path that will be prepended to the scopes of the token in order to
  construct the full path to the file(s) that the bearer of the token is allowed to access.
  For example, if `Base Path` is set to `/astro/PROTECTED` then a token with the scope `read:/matyas`
  will have the permission to read from the directory tree under `/astro/PROTECTED/matyas`.

  The correct value for `Base Path` depends on how the issuer is set up, but we recommend that you set
  `Base Path` to the namespace path, and configure the issuer to create scopes relative to the namespace path.

- `Map Subject` (optional, False if not specified) should be set to True if the origin uses the XRootD-Multiuser plugin.
  It will cause the origin to use the token subject (`sub` field) to map to a Unix user in order to access files.

- `Restricted Path` (optional) is a further restriction on paths the token is allowed to access.
  Only tokens whose scopes start with the `Restricted Path` will be accepted.
  Use this only if your issuer does not create relative scopes.


### AllowedCaches list

The VO must allow one or more OSDF caches to cache their data.
The more places a VO's data can be cached in, the bigger the data transfer benefit for the VO.
The majority of caches across OSG will automatically cache all "public" VO data.
Caching "protected" VO data will often be done on a site owned by the VO.
For information about setting up a cache, see the [installation document](install-cache.md).

AllowedCaches is a list of which caches are allowed to host copies of your data.
There are two cases:

- If you only have public data, your AllowedCaches list can look like:

        :::yaml
        AllowedCaches:
            - ANY

   This allows any cache to host a copy of your data.

- If you have some protected data, then AllowedCaches is a list of _resources_ that are allowed to cache your data.
   A resource is an entry in a `/topology/<FACILITY>/<SITE>/<RESOURCEGROUP>.yaml` file,
   for example `CHTC_OSDF_CACHE`.

   The following requirements must be met for the resource:

   - It must have an "XRootD cache server" service
   - It must have an AllowedVOs list that includes either your VO, "ANY", or "ANY_PUBLIC"
   - It must have a DN attribute with the DN of its host cert


### AllowedOrigins list

AllowedOrigins is a list of which origins are allowed to host your data.
This is a list of _resources_.
A resource is an entry in a `/topology/<FACILITY>/<SITE>/<RESOURCEGROUP>.yaml` file,
for example `CHTC_OSDF_ORIGIN`.

The following requirements must be met for the resource:

- It must have an "XRootD origin server" service
- It must have an AllowedVOs list that includes either your VO or "ANY"
