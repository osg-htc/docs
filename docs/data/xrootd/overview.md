XRootD Overview
===============

[XRootD](http://xrootd.org) is a highly-configurable data server used by sites in the OSG to support VO-specific
storage needs.
The software can be used to create a export an existing file system through multiple protocols, participate in a data
federation, or act as a caching service.
XRootD data servers can stream data directly to client applications or support experiment-wide data management by
performing bulk data transfer via "third-party-copy" between distinct sites.
The OSG supports multiple different configurations of XRootD:

XCache
------

Previously known as the "XRootD proxy cache", XCache provides a caching service for data federations that serve one or
more VOs.
If your site contributes large amounts of computing resources to the OSG, a site XCache could be part of a solution to
help reduce incoming WAN usage.
In the OSG, there are three data federations based on XCache: ATLAS XCache, CMS XCache, and
[StashCache](/data/stashcache/overview) for all other VOs.

If you are affiliated with a site or VO interested in contributing to a data federation, contact us at
<mailto:help@opensciencegrid.org>.

XRootD Standalone
-----------------

An [XRootD standalone server](/data/xrootd/install-standalone) exports data from an existing network storage solution,
such as HDFS or Lustre, using both the XRootD and WebDAV protocols.
Generally, only sites affiliated with large VOs would need to install an XRootD standalone server so consult your VO if
you are interested in contributing storage.

XRootD Storage Element
----------------------

For an [XRootD storage element (SE)](/data/xrootd/install-storage-element), the XRootD software acts as the network
storage technology, exporting data from multiple, distributed hosts using both the XRootD and WebDAV protocols.
Generally, only sites affiliated with large VOs would need to install an XRootD SE so consult your VO if you are
interested in contributing storage.
