title: Open Science Data Federation Overview

Open Science Data Federation Overview
========================

The OSG operates the Open Science Data Federation (OSDF), which connects disparate dataset repositories into a single, nation-wide data distribution network. 
OSDF providers can make their datasets available to a wide variety of compute users, from browsers to Jupyter notebooks to high throughput computing environments like the OSPool. 

The OSDF is powered by the [Pelican Platform](https://pelicanplatform.org/). Sites can run a Pelican _origin_ service and/or a Pelican _cache_ service to connect local storage to the federation. 

The map below shows the location of the current caches and origins in the OSDF:

<iframe width="100%" height="500px" frameBorder="0" style="margin-bottom:1em; margin-top:1em" src="https://map.opensciencegrid.org/map/iframe?view=OpenScienceDataFederation#38.61687,-97.86621|4|hybrid"></iframe>

__For more information on the OSDF__, please see our [overview page](https://osg-htc.org/about/osdf/).

## Schedule a Consultation

If you are a campus who wants to make data or storage available via the OSDF, especially as part of a CC\* grant sharing requirement, we strongly recommend scheduling an initial consultation with our facilitation and campus support team. 

[Request a Meeting](https://docs.google.com/forms/d/e/1FAIpQLSem2Lu-9nL2DBOXrSzmHTWdBZHsMmVN_pIq5ITSnj4A51BTLw/viewform)

or

[Email Us](mailto:support@osg-htc.org)

## Choose Service Option

Before joining the OSDF, you should identify a) what service you are offering (an origin or a cache) and b) if an origin, whether you plan to serve your own data, or share storage with OSG services. 

!!! We strongly recommend scheduling a consultation to discuss these options. 

## Choose Integration Option

To connect storage to the OSDF, an origin or cache service needs to be running with on a physical or virtual host with access to the backing store.
Pelican services can access storage via Unix mount, S3 endpoint, or Globus endpoint. 

There are two overall paths forward to operate the Pelican service.
Many campus storage contributors use Option 1, as it simplifies the effort required to keep the service operational. 
Again, please contact us to discuss these options before pursuing an integration path. 

!!! tip "Hardware recommendations"
    See hardware recommendations for each service in the [origin](../osdf/install-origin-container.md#before-starting)
    and [cache](../osdf/install-cache-container.md#before-starting) documentation


### Option 1: We (OSDF) operate

!!! **If your data store has an S3 endpoint**, we can operate the origin without 
!!! any local hardware requirements. Let us know if this applies to you. 

Currently, we can operate the Pelican services on a service node local to the institution via Kubernetes.
It is conceptually described on our [home website](https://osg-htc.org/about/osdf/deploying_an_osdf_origin.html) for an origin.
A cache would be deployed exactly the same way. 

You can provide a node with Kubernetes in one of two ways: 

1. Integrate with the National Research Platform (NRP): [Joining a Server to NRP](https://nrp.ai/documentation/admindocs/participating/new-contributor-guide/).
    After your server is integrated with NRP, we will deploy the appropriate service. 

1. If you have an existing Kutbernetes cluster on campus, and you can provide 
a user account on that cluster, our staff can operate the service from there. 

The benefit of this approach is that you don't need to learn anything about Pelican or be responsible for running the appropriate service. The trade-off is the work of either running Kubernetes yourself, or providing to the node so it can be integrated with NRP. 

!!! info "Under Development"
    We are developing an integration method where OSDF operations staff can run the 
    appropriate Pelican service on your service node through **SSH access**, without 
    requiring Kubernetes or root access.
    Contact us (support@osg-htc.org) if you would like to explore using this option. 

### Option 2: You (the campus/site) operate

In this scenario, you deploy the service on either your storage system or an attached service node as you would any other service, like a web server. 

There are multiple ways to deploy Pelican yourself: 

1. Use the Pelican container. 
	1. [Installing the OSDF Origin by Container](../osdf/install-origin-container.md).
	1. [Installing the OSDF Cache by Container](../osdf/install-cache-container.md).	
1. Use the RPM. 
	1. [Installing the OSDF Origin by RPM](../osdf/install-origin-rpm.md)
	1. [Installing the OSDF Cache by RPM](../osdf/install-cache-rpm.md)

The benefit of this approach is full control of the service - no one from the OSG team needs access to the service node.
The trade-off is the time and effort to stand up the service, and then to maintain it (upgrades, configuration, etc.).
OSG staff members are available to help with initial configuration and set up. 


