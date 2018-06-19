# Overview of StashCache

StashCache is a data caching federation used researchers and the sites that support them. The federation has many distributed caches spread across the U.S.


![StashCache Map](StashCacheMap.png "StashCache Map")

The StashCache federation consists of two service types, the Caches and the Origins:

* **StashCache Cache**: role of cache server is to keep data cached and immediately available (via [stashcp](https://support.opensciencegrid.org/support/solutions/articles/12000002775-transferring-data-with-stashcach) or CVMFS) within Stash federation (without re-transferring from "origin").  StashCache currently consists of multiple regional caches, but any site may install their own cache and make it available to either only their site, or the wider user community.  A cache can reduce the amount of data transferred through the wide area network if you have OSG users that use StashCache data distribution.
* **StashCache Origin**: Authoritative copy data available to the caching servers.  The origin is only accessed when the Caches do not have the requested data.  The Origin is run and maintained by organizations distributing data within the StashCache federation.


![StashCache Diagram](StashCache-Diagram.png "StashCache Diagram")

The Caches receive data requests from the jobs, which in turn query the redirectors for the location of the data.  The redirectors query the origin servers, which will report whether they have the data.  The Cache server connects to the appropriate origin server, caches the data, then distributes the data to the job.