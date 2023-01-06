title: OSG Site Documentation

OSG Site Documentation
======================

!!!tip "User documentation"
    If you are a **researcher** interested in accessing OSG computational capacity, please consult our
    [user documentation](https://support.opensciencegrid.org/support/home) instead.

The [OSG Consortium](https://www.opensciencegrid.org) provides common service and support for capacity
providers and scientific institutions (i.e., "sites") using a [distributed fabric](https://map.opensciencegrid.org) of
high throughput computational services.
The OSG Consortium does not own computational capacity but provides software and services to users and capacity
providers alike to enable the opportunistic usage and sharing of capacity.

This documentation aims to provide HTC/HPC system administrators with the necessary information to contribute
computational capacity to the OSG Consortium.

Contributing to the OSG
-----------------------

We offer two models for sites to contribute capacity to the OSG Consortium:
one where [OSG staff hosts and maintains](#osg-hosted-services) capacity provisioning services for users;
and the traditional model where the [site](#self-hosted-services) hosts and maintains these same services.
In both of these cases, the following will be needed:

- An existing compute cluster running on a [supported operating system](./release/supported_platforms.md) with a supported
  batch system:
  [Grid Engine](https://www.altair.com/grid-engine/),
  [HTCondor](https://research.cs.wisc.edu/htcondor/),
  [LSF](https://www.ibm.com/us-en/marketplace/hpc-workload-management),
  [PBS Pro](https://www.altair.com/pbs-professional/)/[Torque](https://adaptivecomputing.com/cherry-services/torque-resource-manager/),
  or [Slurm](https://slurm.schedmd.com/).
- Outbound network connectivity from your cluster's worker nodes
- [Temporary scratch space](./worker-node/using-wn.md#for-site-administrators) on each worker node

!!!info "Don't meet the requirements?"
    If your site does not meet the above conditions, please [contact us](mailto:help@osg-htc.org) to discuss
    your options for contributing to the OSG Consortium.

### OSG-hosted services ###

To contribute computational capacity with OSG-hosted services, your site will also need the following:

- Allow SSH access to your local cluster's login host from a known IP address
- Shared home directories on each cluster node

!!!success "Next steps"
    If you are interested in OSG-hosted services, please [contact us](mailto:help@osg-htc.org) for a
    consultation, even if your site does not meet the conditions as outlined above!

### Self-hosted services ###

If you are interested in contributing capacity by hosting your own OSG services, please continue with the
[site planning](./site-planning.md) page.
