Hadoop Overview
===============

!!! warning
    This document is for software that will no longer be supported after the OSG 3.5 retirement (beginning of May 2022).
    See the [Release Series Support Policy](https://opensciencegrid.org/technology/policy/release-series/) for details.

Hadoop Introduction
-------------------

Hadoop is a data processing framework.
The framework has two main parts - job scheduling and a distributed file system,
the Hadoop Distributed File System (HDFS).  

We currently utilize HDFS as a general-purpose file system. For this document,
we'll use the words "Hadoop" and "HDFS" interchangeably, but it's nice to know
the distinction.


The HDFS file system has several features, some of which differ a bit from a typical
file system:

- Each file is broken up into 64 MB or 128 MB chunks (user configurable)
    - These chunks are stored on data nodes and served up from there; 
    - The central namenode manages block locations, the namespace information, and block placement policies. 
- HDFS provides a subset of POSIX semantics:
    - Random-access reads and non-random-access writes are fully supported. 
    - Fsync and appends (after the file has been initially closed) are experimental and not available to OSG-based installs.
    - Rewriting closed files is not supported

Hadoop SE Components
--------------------

We broadly break down the server components of the Hadoop SE into three categories: HDFS core, Grid extensions, and HDFS
auxiliary. 
The components in each of these categories are outlined below:

-   HDFS Core:
    -   Namenode: The core metadata server of Hadoop. This is the most critical piece of the system, and there can only be one of these. This stores both the file system image and the file system journal. The namenode keeps all of the filesystem layout information (files, blocks, directories, permissions, etc) and the block locations. The filesystem layout is persisted on disk and the block locations are kept solely in memory. When a client opens a file, the namenode tells the client the locations of all the blocks in the file; the client then no longer needs to communicate with the namenode for data transfer.
    -   Datanode: This node stores copies of the blocks in HDFS. They communicate with the namenode to perform "housekeeping" such as creating new replicas, transferring blocks between datanodes, and deleting excess blocks. They also communicate with the clients to transfer data. To reach the best scalability, there should be as many datanodes as possible.
-   Grid extensions
    -   Globus GridFTP: The standard GridFTP from Globus. We use a plug-in module (using the Globus Direct Storage Interface) that allows the GridFTP process to use the HDFS C-bindings directly.
    -   Gratia probe: Gratia is an accounting system that records batch system and transfer records to a database. The records are collected by a client program called a "probe" which runs on the GridFTP or XRootD server.  The probe parses the GridFTP or XRootD logs and generates transfer records.
    -   XRootD server plugin: XRootD is an extremely flexible and powerful data server popular in the high energy physics community. There exists a HDFS plugin for XRootD; integrating with XRootD provides a means to export HDFS securely outside the local cluster, as another XRootD plugin provides GSI-based authentication and authorization.
-   HDFS auxiliary:
    -   "Secondary Namenode": Perhaps more aptly called a "checkpoint server". This server downloads the file system image and journal from the namenode, merges the two together, and uploads the new file system image up to the namenode. This is done on a different server in order to reduce the memory footprint of the namenode.
    -   Hadoop Balancer: This is a script (unlike the others, which are daemons) that runs on the namenode. It requests transfers of random blocks between the datanodes. This works until all datanodes have approximately the same percentage of free space. Well-balanced datanodes are necessary for having a healthy cluster.

In addition to the server components, there are two client components:

-   FUSE: This allows HDFS to be mounted as a filesystem on the worker nodes. FUSE is a Linux kernel module that allows kernel I/O calls to be translated into a call to a userspace program. In this case, a program called fuse\_dfs translates the POSIX calls into HDFS C-binding calls.
-   Hadoop Command Line Client: This command line client exposes a lot of the Unix-like calls without mounting FUSE, plus access to the non-POSIX calls (such as setting quotas and file replication levels). For example, "hadoop fs -ls /" is equivalent to "ls /mnt/hadoop" if /mnt/hadoop is the mount point of HDFS.

--------------------

-   Namenode: We recommend at least 8GB of RAM (minimum is 2GB RAM), preferably 16GB or more. A rough rule of thumb is 1GB per 100TB of raw disk space; the actual requirements is around 1GB per million objects (files, directories, and blocks). The CPU requirements are any modern multi-core server CPU. Typically, the namenode will only use 2-5% of your CPU.
    -   As this is a single point of failure, the **most important** requirement is reliable hardware rather than high performance hardware. We suggest a node with redundant power supplies and at least 2 hard drives.
-   Secondary namenode: This node needs the same amount of RAM as the namenode for merging namespaces. It does not need to be high performance or high reliability.
-   Datanode: Each datanode should plan to dedicate about 1-1.5 GB of RAM to HDFS. A general rule of thumb is to dedicate 1 CPU to HDFS per 5TB of disk capacity under heavily load; clusters with moderate load (i.e., mostly sequential workflows) will need less. At idle, HDFS will consume almost no CPU.

Sizing Your Cluster
---------------------

The minimal installation would involve 5 nodes:

- hadoop-name: The namenode for the Hadoop system.  
- hadoop-name2: This will run the HDFS secondary namenode. 
- hadoop-data1, hadoop-data2: Two HDFS datanodes. They will hold data for the system, so they should have sizable hard drives. As the Hadoop installation grows to many terabytes, this will be the only class of nodes one adds.
- hadoop-grid: Runs the Globus GridFTP server. 

If desired, hadoop-name and hadoop-name2 may be virtualized. 
Prior to installation, DNS / host name resolution **must** work. 
That is, you should be able to resolve all the Hadoop servers either through DNS or /etc/hosts. 
Because of the grid software, hadoop-grid **must** have reverse DNS working.  

Larger clusters have the same basic components but with  more HDFS datanodes and gridftp servers. 
Adding HDFS datanodes increases the capacity and  number of IOPS the cluster can provide.
Additional GridFTP servers will increase the data transfer rates to locations outside your data center.
As your cluster increases in size, virtualized namenodes may need to be moved to physical hardware.

Hadoop Security
---------------

HDFS has Unix-like user/group authorization, but no strict authentication. 
**HDFS should use a secure internal network which only non-malicious users are able to access**. 
For users with access to the local cluster, it is not difficult to bypass authentication.

[The default ports are listed here](http://www.cloudera.com/blog/2009/08/14/hadoop-default-ports-quick-reference/).

There are some ways to improve security of your cluster:

-   Keep the namenode behind a firewall. One possibility is to run Hadoop entirely on the private subnet of a cluster.
-   Use firewalls to protect the HDFS ports (default for the datanode is 50010 and 50075; for the namenode, 50070 and 9000).
-   For clusters utilizing FUSE, one can block outgoing connections to the HDFS ports except for user root. This means that only root-owned processes (such as FUSE-DFS) will be able to access Hadoop.
    -   This is sufficient for grid environments, but does not protect one in the case where the attacker has physical access to the network switch.
-   There exists another option, currently untested. It is possible to limit all HDFS socket connections to SSL-based sockets. Using this to only allow known hosts to connect to HDFS and only allowing FUSE-DFS to connect on those known hosts, one might be able to satisfy even fairly stringent security folks (but not paranoid ones).

There are three options to export your data outside your cluster:

-   Globus GridFTP.
-   XRootD.
-   HTTP and HTTPS.  OSG utilizes the HTTP(S) protocol implementation built into the XRootD server.


References
----------

- [Hadoop Architecture](http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html)

