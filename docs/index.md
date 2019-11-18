OSG Site Documentation
======================

!!!tip "User Documentation"
    If you are a **researcher** interested in accessing OSG resources, please consult our
    [user documentation](https://support.opensciencegrid.org/support/home) instead.

The [Open Science Grid](https://www.opensciencegrid.org) (OSG) provides common service and support for resource
providers and scientific institutions (i.e., "sites") using a [distributed fabric](https://map.opensciencegrid.org) of
high throughput computational services.
The OSG does not own resources but provides software and services to users and resource providers alike to enable the
opportunistic usage and sharing of resources.

This documentation aims to provide HTC/HPC system administrators with the necessary information to contribute resources
to the OSG.

Minimum Requirements
--------------------

If you are interested in contributing resources to the OSG, your site must meet the following minimum requirements:

- An existing compute cluster running on a [supported operating system](/release/supported_platforms) with a supported
  batch system:
    - [Grid Engine](http://www.univa.com/products/)
    - [HTCondor](http://htcondor.org)
    - [LSF](https://www.ibm.com/us-en/marketplace/hpc-workload-management)
    - [PBS Pro](https://www.pbsworks.com/PBSProduct.aspx?n=Altair-PBS-Professional&c=Overview-and-Capabilities)/[Torque](http://www.adaptivecomputing.com/products/torque/)
    - [Slurm](https://slurm.schedmd.com/)
- Outbound network connectivty from your cluster's worker nodes
- [Temporary scratch space](/worker-node/using-wn#for-site-administrators) on each worker node
- Allow SSH access to your local cluster's submit node from a known IP address
- Shared home directories on each cluster node

If your cluster does not meet the above requirements but you are still interested in contributing to the OSG, please
[contact us](mailto:help@opensciencegrid.org).
