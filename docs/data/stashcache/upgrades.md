# OSG StashCache Upgrade Status

This page is used to track the status of hardware and software used for the StashCache service within the OSG community. Please update your status when you complete an upgrade.


## 2018 Table of Caches

| **Hosting site** | **Hostname** | **XRootD version** | **OS** | **CPU** | **RAM** | **Disk (cache) space** | **Disk configuration** | **Connectivity** | **Notes** | **Last update** |
|------------------|--------------|--------------------|--------|---------|---------|------------------------|------------------------|------------------|-----------|-----------------|
| Syracuse | its-condor-xrootd1.syr.edu | xrootd-4.8.2-0.1.rc1.osg34.el7.x86_64 | CentOS 7.2.1511   | Intel(R) Xeon(R) CPU E7-8890 v4 @ 2.20GHz (8 cores) | 65GB  | 16TB  |   | 10Gbps |   | 05-01-2018  |
| BNL | osgxroot.usatlas.bnl.gov |   |   |   |   |   |   |   |   |   |
| FZU | stash.farm.particle.cz | 4.8.0-1.osg34 | CentOS 7.4.1708 | 2x Xeon(R) E5-2630 v4 @2.20GHz  | 128GB  | 30TB  | 5x8TB, RAID-Z1, ZFS, 1TB NVMe Cache | 10Gbps | Container | 2-2-2018  |
| Nebraska | hcc-stash.unl.edu | 4.8.2-1.osg34  | CentOS 7.4.1708  | 2x (8 core) Intel(R) Xeon(R) Gold 6134 CPU @ 3.20GHz | 394GB | ~1.5TB | NVMe | 40Gbps  |  | 05-01-2018 |
| UChicago | stashcache.grid.uchicago.edu  | 4.7.1-1 | SL 7.3  | 2x Xeon(R) E5440 @2.83GHz | 32GB | 60TB | 5x 12TB arrays, RAID6, XFS, bound with oss.space | 2x10Gbps | Old dCache node, probably not optimally tuned for XRootD | 11-07-2017 |
| UIllinois | mwt2-stashcache.campuscluster.illinois.edu | 4.6.1-0.2.rc3.osg33 |   | VM 4CPUS | 16GB | 100TB | GPFS on DDN via FDR IB | 10Gbps |   | 04-28-2017 |
| UCSD | xrd-cache-1.t2.ucsd.edu | xrootd-4.8.2-1.osg34 | CentOS 6.8 | 2x Xeon(R) E5-2650 v3 @2.30GHz w/HT (40 cores total) | 128GB | 21.8TB | 6x 3.6TB, XFS, individual disks bound with oss.space | 10Gbps  | The same machine runs hdfs-healing xrootd cache on another set of 6 independent disks. We can move more disks to StashCache if needed. | 10-28-2016 |
