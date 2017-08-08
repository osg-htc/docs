Berkeley Storage Manager
========================

BeStMan, or Berkeley Storage Manager, is a full implementation of SRM v2.2, developed by Lawrence Berkeley National Laboratory, for a disk based storage and mass storage systems. End users may have their own personal BeStMan that manages and gives an SRM interface to their own local disks. It works on top of existing disk-based unix file systems, and has been reported so far to work on file systems such as NFS, GPFS, PVFS, GFS, Ibrix, HFS+, Hadoop, XrootdFS and Lustre. It also works with any existing file transfer service, such as gsiftp, http, https, bbftp and ftp. It requires minimal administrative efforts on the deployment and updates. BeStMan2 is a Jetty based implementation of SRM v2.2.

As of the June 2017 release of OSG 3.4.0, this software is officially deprecated.  Support is scheduled to end as of June 2018.

Planning
--------

-   [Information on various BeStMan architectures](https://twiki.opensciencegrid.org/bin/view/Documentation/BestmanStorageElement)
-   [Bestman home page](https://sdm.lbl.gov/bestman/): Bestman project home

Installation
------------

-   [Install Bestman SE](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallOSGBestmanSE): BeStMan installation interfacing with local disk
-   [Install Bestman Gateway Xrootd](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallBestmanXrootdSE): BeStMan gateway mode on top of XRootD
-   [Install Bestman Gateway Hadoop](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallHadoop200SE): BeStMan gateway mode on top of Hadoop
-   [LBNL Configuration Reference](https://sdm.lbl.gov/twiki/bin/view/Software/BeStMan/BeStManGuide/Configuration)

Operation
---------

-   [LBNL SRM Client](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/LbnlSrmClient): SRM client provided with BeStMan.  This is deprecated; use of `gfal-utils` is strongly encouraged instead.
-   [BeStMan SRMTester](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/SrmTester): Tester for BeStMan SRM instances
-   [Using Adler checksums with BeStMan](https://twiki.opensciencegrid.org/bin/view/Storage/BestmanAdler32Checksum)

