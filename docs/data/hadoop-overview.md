<span class="twiki-macro DOC_STATUS_TABLE"></span>

Hadoop
======


About this Document
===================

The Hadoop Distributed File System (HDFS) is a highly scalable, very reliable distributed file system developed by the Apache project as a part of the Hadoop data processing system. The primary contributor (and largest user) is Yahoo. HDFS is based on the design of the Google File System. HDFS's strengths is in its ability to use commodity hard drives in worker nodes; it can turn a large amount of semi-reliable hardware into a system which is very reliable.

To find out more information about HDFS, [visit its home page](http://hadoop.apache.org/hdfs/). If you are thinking about installing Hadoop, we also recommend reading the [HDFS architecture page](http://hadoop.apache.org/common/docs/current/hdfs_design.html).

This page covers the OSG's usage of Hadoop, and includes instructions for installing a grid-enabled HDFS system.

Planning
--------

-   Documentation.HadoopUnderstanding: This document explains the various components for Hadoop and the recommended specifications of size and deployment.

Installation
------------

-   [Install Guide](Documentation.Release3.InstallHadoop200SE)
    -   Change link <https://twiki.grid.iu.edu/bin/view/Accounting/ProbeInstallation>
    -   <https://twiki.grid.iu.edu/bin/view/Trash/ReleaseDocumentationGratiaSiteCollector> revisit this link

**Upgrading:** Please note that there are two upgrades that could be needed. To upgrade if you are using 0.19 from the Caltech repository, follow the first guide to upgrade to 0.20 then use the second to convert to the newer OSG repository.

-   Storage.HadoopUpgrade : Upgrade guide to upgrade from 0.19 to 0.20, both using the Caltech repo.
-   Documentation/Release3.UpgradeHadoop: This guide covers upgrading from 0.20 Caltech repository to 0.20 using OSG repository.

Operation
---------

-   Storage.HadoopOperations: Information on how to run hadoop client commands, fscks, and other manual tips.
-   Documentation/Release3.HadoopRecovery: Notes and tips on how to recover corrupted or lost files.
-   Documentation/Release3.HadoopDebug: Troubleshooting tips. Always a work in progress. Help us add solutions!

Additional Links
----------------

-   Storage.HadoopXrootd : Special considerations when installing Xrootd on top of Hadoop
-   Storage.HadoopPhedex: Special considerations when using Phedex file transfer service on top of Hadoop


