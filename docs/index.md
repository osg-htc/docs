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

Contributing to the OSG
-----------------------

We offer two models for sites to contribute resources to OSG users:
one where the [OSG hosts and maintains](#osg-hosted-services) the services to submit batch work to your site;
and the traditional model where the [site](#self-hosted-services) hosts and maintains these same services.
In both of these cases, your site must meet the following requirements:

- An existing compute cluster running on a [supported operating system](/release/supported_platforms) with a supported
  batch system:
  [Grid Engine](http://www.univa.com/products/),
  [HTCondor](http://htcondor.org),
  [LSF](https://www.ibm.com/us-en/marketplace/hpc-workload-management),
  [PBS Pro](https://www.pbsworks.com/PBSProduct.aspx?n=Altair-PBS-Professional&c=Overview-and-Capabilities)/[Torque](http://www.adaptivecomputing.com/products/torque/),
  or [Slurm](https://slurm.schedmd.com/).
- Outbound network connectivty from your cluster's worker nodes
- [Temporary scratch space](/worker-node/using-wn#for-site-administrators) on each worker node

### OSG-hosted services ###

To contribute computational resources with OSG-hosted services, your site must additionally provide the following:

- Allow SSH access to your local cluster's submit node from a known IP address
- Shared home directories on each cluster node

If you are interested in OSG-hosted services, please [contact us](mailto:help@opensciencegrid.org), whether or not your
site meets the above requirements!

### Self-hosted services ###

If you are interested in contributing resources by hosting your own OSG services, please continue with the
[detailed overview](/detailed-overview) page.
