XRootD Overview
===============

The XRootD project aims at giving high performance, scalable fault tolerant access to data repositories of many kinds. The typical usage is to give access to file-based ones. It is based on a scalable architecture, a communication protocol, and a set of plugins and tools based on those. The freedom to configure it and to make it scale (for size and performance) allows the deployment of data access clusters of virtually any size, which can include sophisticated features, like authentication/authorization, integrations with other systems, WAN data distribution, etc.

XRootD software framework is a fully generic suite for fast, low latency and scalable data access, which can serve natively any kind of data, organized as a hierarchical filesystem-like namespace, based on the concept of directory. As a general rule, particular emphasis has been put in the quality of the core software parts.

Planning
--------

-   [Xrootd Homepage](http://xrootd.slac.stanford.edu/)

Installation
------------

-   [Install Xrootd Server](Documentation/Release3.InstallXrootd): This page explains how to install an XRootD redirector and data nodes
-   [Install Bestman Gateway Xrootd](Documentation/Release3.InstallBestmanXrootdSE): Installing a SRM frontend wit GridFTP for XRootD redirector
-   [Install GridFTP on Xrootd](Documentation/Release3.InstallGridFtpXrootd): For sites with multiple GridFTP servers, this page explains how to install a GridFTP server.
-   [Hadoop on Xrootd](Storage.HadoopXrootd): Example configuration of Xrootd on top of Hadoop.

Operations
----------

-   InstallXrootdClient: Installing and using XRootD clients
-   [Xrootd bug reporting](https://savannah.cern.ch/bugs/?group=xrootd)
-   [Source code browsable repo](http://xrootd.cern.ch/cgi-bin/cgit.cgi/xrootd/)


