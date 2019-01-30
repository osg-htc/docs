Managing VO Registration for the StashCache Federation
======================================================

This document describes the registration steps required to manage a VO's role
in the StashCache Data Federation.

For general information about StashCache, see the [overview document](/data/stashcache/overview/).

For general information about VO registration in the OSG Topology,
see the [registration document](/common/registration/#registering-virtual-organizations).

Site admins should work together with VO managers in order to perform these steps.


Definitions
-----------

- **Namespace:** a directory tree in the federation that is used to find VO data.
- **Public data:** data that can be read by anyone.
- **Protected data:** data that requires authentication to read.


Requirements
------------

In order for a Virtual Organization to join the StashCache Federation, the VO must already be registered in OSG Topology.
See the [registration document](/common/registration/#registering-virtual-organizations).



Choosing namespaces
-------------------

The VO must pick one or more "namespaces" for their data.
A namespace is a directory tree in the federation where VO data is found.

!!! note
    Namespaces are global across the federation, so you must work with the StashCache Operations team
    to ensure that your VO's namespaces do not collide with those of another VO.

A namespace should be easy for your users to remember but not so generic that it collides with other VOs.
We recommend using the lowercase version of your VO as the top-level directory.
In addition, public data, if any, should be stored in a subdirectory named `PUBLIC`,
and protected data, if any, should be stored in a subdirectory named `PROTECTED`.

Putting this together, if your VO is named `Astro`, you should have:

- `/astro/PUBLIC` for public data
- `/astro/PROTECTED` for protected data

Separating the public and protected data in separate directory trees is preferred for technical reasons.


Registering data federation information
---------------------------------------

The VO must allow one or more StashCache origins to host their data.
An origin will typically be hosted on a site owned by the VO.
For information about setting up an origin, see the [installation document](/data/stashcache/install-origin/).

In order to declare your VO's role in the StashCache federation,
you must add StashCache information to your VO's YAML file in the OSG Topology repository.

The data will look like the following:
```
DataFederations:
  StashCache:
    Namespaces:
      /astro/PUBLIC:
        - ANY
    AllowedCaches:
      - ANY
    AllowedOrigins:
      - CHTC_STASHCACHE_ORIGIN
```

The sections are described below.


### Namespaces section

In the namespaces section, you will declare one or more namespaces and, for each namespace,
list who is allowed to access that namespace.

The list will contain one or more of these:

- `FQAN:<VOMS FQAN>` allows someone using a proxy with the specified VOMS FQAN
- `DN:<DN>` allows someone using a proxy with that specific DN
- `ANY` allows anyone; this is used for public data

A complete declaration looks like:
```
    Namespaces:
      /astro/PUBLIC:
        - ANY
      /astro/PROTECTED:
        - FQAN:/Astro
        - DN:/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=People/CN=Matyas Selmeci
```

This declares two namespaces: `/astro/PUBLIC` for public data, and `/astro/PROTECTED`
which can only be read by someone with the `/Astro` FQAN or by Matyas Selmeci.


### AllowedCaches list

The VO must allow one or more StashCache Caches to cache their data.
The more places a VO's data can be cached in, the bigger the data transfer benefit for the VO.
The majority of caches across OSG will automatically cache all "public" VO data.
Caching "protected" VO data will often be done on a site owned by the VO.
For information about setting up a cache, see the [installation document](/data/stashcache/install-cache/).

AllowedCaches is a list of which caches are allowed to host copies of your data.
There are two cases:

- If you only have public data, your AllowedCaches list can look like:

        AllowedCaches:
            - ANY

   This allows any cache to host a copy of your data.

- If you have some protected data, then AllowedCaches is a list of _resources_ that are allowed to cache your data.
   A resource is an entry in a `/topology/<FACILITY>/<SITE>/<RESOURCEGROUP>.yaml` file,
   for example "CHTC_STASHCACHE_CACHE".

   The following requirements must be met for the resource:

   - It must have an "XRootD cache server" service
   - It must have an AllowedVOs list that includes either your VO, "ANY", or "ANY_PUBLIC"
   - It must have a DN attribute with the DN of its host cert


### AllowedOrigins list

AllowedOrigins is a list of which origins are allowed to host your data.
This is a list of _resources_.
A resource is an entry in a `/topology/<FACILITY>/<SITE>/<RESOURCEGROUP>.yaml` file,
for example "CHTC_STASHCACHE_ORIGIN".

The following requirements must be met for the resource:

- It must have an "XRootD origin server" service
- It must have an AllowedVOs list that includes either your VO or "ANY"

