Slurm Configuration Recipes
===========================

This document contains examples of common Slurm configurations used by sites to contribute capacity to the OSPool.

Contributing X% of Your Cluster
-------------------------------

To contribute a percentage of your Slurm cluster to the OSPool,
set aside a number of whole nodes for a dedicated OSPool [partition](https://slurm.schedmd.com/quickstart.html#arch):

1.  Determine the percentage of your cluster that you would like to contribute and use that to calculate the number of
    cores to meet that percentage

1.  Select nodes and sum the number of cores to meet your desired contribution

1.  In [slurm.conf](https://slurm.schedmd.com/slurm.conf.html),
    configure the `NodeName` for each type of chassis and assign specific nodes to `PartitionName=ospool`

For example, if your cluster is 5120 cores and you wanted to contribute 10% of the cluster to the OSPool,
your `slurm.conf` could contain the following:

```
# Dell PowerEdge C6525, AMD EPYC 7513 32-Core Processor @ 2.6GHz
NodeName=spark-a[002-004,006-028] CPUs=64 Boards=1 SocketsPerBoard=2 CoresPerSocket=32 ThreadsPerCore=1 RealMemory=256000 State=UNKNOWN Features=amd,avx,avx2

# Dell PowerEdge R6525, AMD EPYC 7763 64-Core Processor
NodeName=spark-a[029-071,204-206] CPUs=128 Boards=1 SocketsPerBoard=2 CoresPerSocket=64 ThreadsPerCore=1 RealMemory=512000 State=UNKNOWN Features=amd,avx,avx2

# OSPool Partition, -- 10% of Shared is approx 512 cores; 6x64cores + 1x128 cores = 512
PartitionName=ospool State=UP Nodes=spark-a[002-004,006-008,029] DefaultTime=0-04:00:00 MaxTime=1-00:00:00 PreemptMode=OFF Priority=50 AllowGroups=slurm-admin,osg01
```
