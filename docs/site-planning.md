**<span class="twiki-macro SPACEOUT">%TOPIC%</span>**
=====================================================

<span class="twiki-macro DOC_STATUS_TABLE"></span> <span class="twiki-macro TOC"></span>

About this Document
===================

<span class="twiki-macro ICON">hand</span> This document is for **System Administrators**. The purpose of the document is to provide an overview about the different ways to setup an OSG site and to encourage you to plan your site before you continue to install the OSG software on your site.

<span class="twiki-macro ICON">choice-yes</span> After reading this document you should be able to identify the site elements needed to setup your OSG site and choose among different technology choices presented.

Background
==========

The goal for the Open Science Grid software stack is to provide a uniform computing and storage interface across many independently managed computing and storage clusters. Scientists, researchers, and students, organized as virtual organizations (VOs), are the consumers of the CPU cycles and storage.

Your site is encouraged to support as many OSG-registered VOs as possible, but you are not required to support all of them.

As the administrator responsible for deployment of the OSG software stack, your task is to make your existing computing and storage cluster available to and reliable for the VOs that you support. The OSG expects you to set up a gatekeeper node called a Compute Element (CE) on which the bulk of the OSG software gets installed. The end-user sends jobs into your cluster's batch system, your CE receives them and passes them out to Worker Nodes (WN) for execution. Some VOs and end-users require non-negligible amounts of data as input, or generate non-negligible amounts of data as output. They will need to store that data in a Storage Element (SE). A site is not required to provide both a CE and an SE.

Site Policies
=============

OSG expects you to clearly specify your site's policies regarding resource access. Please write them on a web page, make this page part of your site registration, and make it available via the GOC publishing tool [MyOSG](http://myosg.grid.iu.edu) and the OSG information management system, OIM. We encourage you to allow all virtual organizations registered with the OSG at least "opportunistic use" of your resources. You may need to preempt those jobs when higher priority jobs come around. The end-users using the OSG generally prefer having access to your site subject to preemption over having no access at all.

OSG Site Elements
=================

The OSG provides software and documentation to install and operate following services:

&lt;div style="margin: 1em 2em 2em 2em; width: 90%"&gt;

| Element               | Description                                                                                |
|:----------------------|:-------------------------------------------------------------------------------------------|
| Authorization Service | enables grid users to authorize with your site using their grid or voms proxies            |
| Compute Element       | enables grid users to run jobs on your site                                                |
| Worker Node Client    | enables grid jobs running on worker nodes to access grid tools                             |
| Storage Element       | enables grid users to store large amounts of data at your site                             |
| VO Management Service | provides functionality for VO Managers to manage the membership information of their users |

&lt;/div&gt;

Authorization Service
---------------------

Grid users will authorization with your site using their **grid or voms proxy**. The OSG provides two different services that let you control the authorization process:

&lt;div style="margin: 1em 2em 2em 2em; width: 90%"&gt; | **Service** | **Description** | **Advantages** | **Disadvantages** |

|                                 |                                                                           |                              |                                            |
|---------------------------------|---------------------------------------------------------------------------|------------------------------|--------------------------------------------|
| edg-mkgridmap                   | a simple program that contacts VOMS servers and creates a gridmap file    | easy to install and maintain | does not support voms proxies              |
| [GUMS](Documentation.AboutGums) | a web service providing sophisticated controls of how users authorization | supports voms proxies        | requires Tomcat to be run as a web service |

&lt;/div&gt;

<span class="twiki-macro ICON">warning</span> A **VOMS Server** is not an element of your site. Each **Virtual Organization** operates a central VOMS Server to manage membership information of its grid users. Please contact the **VO Manager** for your virtual organization to obtain more details.

Compute Element
---------------

A **Compute Element** allows grid users to run jobs on your site. It is software that provides following services when run on your **gatekeeper**: The standard installation is based on HTCondor-CE with RSV for monitoring.

You must determine your security policy with regard to Unix ID management on the cluster. You may choose group accounts and/or dynamic accounts for all users.

You must choose the OS (Red Hat Enterprise Linux derivative), the batch system (Condor, PBS, LSF, SGE, and Slurm are presently supported), and the network architecture of your cluster. The default network assumption is public/private with NAT so you will need to advertise your architecture by changing some settings by hand if yours isn't like this. In addition, there are some configuration choices, including one that avoids all NFS exports from the CE to the compute cluster (NFS-lite).

The CE hosts information provider(s) and monitoring services, most of which are configured correctly by default. We require all OSG sites to deploy Gratia, the OSG accounting system. Your site thus sends accounting records to OSG about jobs run on your site and data transfers involving your site. Aggregated summaries of this information can be viewed via the [Gratia displays](http://gratia-osg.fnal.gov:8880/gratia-reporting/).

&lt;div style="margin: 1em 2em 2em 2em; width: 90%"&gt;

<table>
<thead>
<tr class="header">
<th align="left">Service</th>
<th align="left">Description</th>
<th align="left">Comments</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">HTCondor-CE</td>
<td align="left">HTCondor-CE, based on the HTCondor batch system, provide a public entry point to your local batch system.<br />
It also allows grid users to <strong>fork</strong> jobs on your gatekeeper by default.</td>
<td align="left">Required</td>
</tr>
<tr class="even">
<td align="left">RSV</td>
<td align="left"><strong>R</strong>esource <strong>S</strong>ervice <strong>V</strong>alidation system which schedules execution of local &quot;probes&quot; of your CE (and SE), and reports the results up to the GOC. This is important for service availablity monitoring of OSG sites.</td>
<td align="left">Required</td>
</tr>
<tr class="odd">
<td align="left">Squid</td>
<td align="left">Squid is a caching proxy for the Web that enables restricted access of worker nodes to the web.</td>
<td align="left">Optional</td>
</tr>
<tr class="even">
<td align="left">Syslog-ng</td>
<td align="left">A logging service that can be used to forward CE logfiles to the GOC for troubleshooting purposes.</td>
<td align="left">Optional</td>
</tr>
</tbody>
</table>

&lt;/div&gt;

Additionally two shared file systems are for grid users to install applications **OSG\_APP** (required) and to save data **OSG\_DATA** (optional). If available, both must be mounted on the gatekeeper and all worker nodes:

&lt;div style="margin: 1em 2em 2em 2em; width: 90%;"&gt;

| Shared Filesystem | Description                                  | Recommended Size                 | Typical Size\[TB\] | Comments                                                                    |
|:------------------|:---------------------------------------------|:---------------------------------|:------------------:|:----------------------------------------------------------------------------|
| HOME              | space for grid user home directories         | 10GB for each VO                 |      0.1 to 1      | required, auto-cleanup                                                      |
| OSG\_APP          | space for grid users to install applications | 10GB for each VO                 |      0.1 to 1      | required, no auto-cleanup                                                   |
| OSG\_DATA         | space for grid users to stage data           | 10GB for each VO and worker node |      0.1 to 10     | optional, no quota, auto-cleanup                                            |
| OSG\_WN\_TMP      | tmp space for users on worker nodes          | 2GB for each cpu core            |         0.1        | required, auto-cleanup                                                      |
| OSG\_GRID         | location of the worker node client           | 10GB                             |         0.1        | optional/required (see %RED%NOTE<span class="twiki-macro ENDCOLOR"></span>) |

&lt;/div&gt;

<span class="twiki-macro NOTE"></span> If you install wn-client on each node via RPM all the client software is available in the default path. There is no need for OSG\_GRID. The RPM installation creates `/etc/osg/wn-client/` with dummy setup files for compatibility with old jobs looking for a OSG\_GRID. New jobs should source the setup file in OSG\_GRID if this is defined; if not, they should expect all the client binaries in the default PATH.

More details can be found in [Local Storage Configuration](Trash.ReleaseDocumentationLocalStorageConfiguration).

Worker Node Client
------------------

The [Worker Node Client](InstallWNClient) is software installed on each worker node to give programs running on the worker nodes access to grid utilities. While it is technically optional, it is **strongly recommended** that you install it on the gatekeeper and all worker nodes. This can be done as a local installation, in which the software is installed individually on every worker node, or as a shared installation in which the software is installed on one machine that shares it via a global file system to all the worker nodes. All the site configurations below are showing a local installation of the worker node client.

Storage Element
---------------

A **Storage Element** provides grid users the possibility to read and write large amounts of data on your site using the **S**torage **R**esource **M**anager (**SRM**). All Storage Element implementations in the OSG support the gsiftp protocol and full or partial SRM specification. The selection of storage suitable for your site varies on anticipated usage patterns, available hardware, the choice of underlying distributed storage, support for a tape-archival backend etc.

There are two types of storage element services provided by OSG which implement SRM v2. See pointers to instructions for these services:

-   [BeStMan](BestmanOverview) - Sits in front of any POSIX filesystem. There is also a version which supports xrootd filesystems.
-   [Hadoop](HadoopOverview) - Map-reduce based solution to aggregate off-the-shelf disks into a scalable reliable system.

An SE must run correctly configured Grid Information Providers, Gratia accounting and RSV probes.

These services are supported by the OSG Storage group. Please email <osg-storage@opensciencegrid.org> for installation and support questions for these services.

&lt;div style="margin: 1em 2em 2em 2em; width: 90%"&gt; | **Storage Requirements** | **Min Hardware Requirements** | **OSG SE Solution** |

|                                                 |                        |                   |                                                      |                               |                  |                                                                                              |                         |                        |                                                                        |                         |                       |                                                                                              |                          |        |
|-------------------------------------------------|------------------------|-------------------|------------------------------------------------------|-------------------------------|------------------|----------------------------------------------------------------------------------------------|-------------------------|------------------------|------------------------------------------------------------------------|-------------------------|-----------------------|----------------------------------------------------------------------------------------------|--------------------------|--------|
| SRM interface, Dynamic Space Management Support | Server with local disk | BeStMan-fullmode| | SRM interface, No or Static Space Management Support | Server with local disk or NFS | BeStMan-gateway| | SRM interface, No or Static Space Management Support, jobs need root protocol to access data | Multiple servers(&gt;3) | BeStMan-gateway/Xrood| | SRM interface, No or Static Space Management Support, file replication | Multiple servers(&gt;4) | BeStMan-gateway/HDFS| | SRM interface, Dynamic Space Management Support, file replication, interface to tape backend | Multiple servers (&gt;5) | dcache |

&lt;/div&gt; To learn more about storage technologies used in OSG, read the [Overview](Documentation.StorageInfrastructureSoftware) and the [Storage Site Administrator Guide](Documentation.StorageSiteAdministrator).

VO Management Service
---------------------

A **V**irtual **O**ganization **M**anagement **S**ervice (VOMS) controls who is a member of your VO. Each VO needs to provide one VOMS. Please contact the VO Manager of VO to find out about the VOMS of your VO.

Recommendations
===============

<span class="twiki-macro ICON">hand</span> In this section we outline %RED%important<span class="twiki-macro ENDCOLOR"></span> recommendations for setting up an OSG site. The recommendations are based on the knowledge of experienced system administrators and will help you avoid typical problems operating an OSG site from the beginning.

Shared File Systems
-------------------

We recommend to use a dedicated server for hosting the shared file system. The expected load on the file server could be distributed further by providing a dedicated file server for **HOME** and **OSG\_DATA** if possible. You should also consider to:

-   use a consistent mounting scheme for shared partitions when mounted on the gatekeeper with respect to all worker nodes
-   use a reasonable automatic cleanup procedure for **HOME**, **OSG\_DATA** and **OSG\_WN\_TMP**
-   not use an automatic cleanup procedures for **OSG\_APP**
-   not use quota for **OSG\_DATA**

### NFS Warning

NFS is known to be an *easy* but never the less %RED%inadequate<span class="twiki-macro ENDCOLOR"></span> choice for all but the smallest sites! If you want to use NFS you should read the chapter *"Optimizing NFS Performance"* in the [http://nfs.sourceforge.net/nfs-howto/ Linux NFS HowTo](http://nfs.sourceforge.net/nfs-howto/ Linux NFS HowTo). Software partitions that can be locally installed, such as OSG\_GRID, should be locally installed and not shared unless you have an enterprise-class NFS server.

Condor provides mechanisms which can be used to greatly minimize NFS usage [NFSLite](http://vdt.cs.wisc.edu/releases/2.0.0/notes/Globus-CondorNFSLite-Setup.html). This package makes it unnecessary to have NFS-mounted **HOME** directories on all the worker nodes. Security is also improved because user proxies will not be sent across NFS in the clear. The running job will only have access to grid or voms proxies running at the same time on the same worker node as the job itself avoiding identity theft.

Compute and Storage Element
---------------------------

-   provide dedicated hardware for the Compute and the Storage Element
-   use as many cpu cores and main memory as possible
-   avoid running other grid services such as GUMS on the Compute and the Storage Element
-   avoid running a file server on the Compute and the Storage Element

Use Job Manager managedfork instead of fork
-------------------------------------------

*GRAM* provides several jobmanagers that control how jobs will be executed on the gatekeeper and the worker nodes. By %RED%default jobmanager fork<span class="twiki-macro ENDCOLOR"></span> will be used to allow grid users to run maintenance jobs on the gatekeeper. Unfortunately fork doesn't provide a way to restrict the number of jobs that may be run simultaneously.

By choosing %RED%managedfork instead of fork<span class="twiki-macro ENDCOLOR"></span> during the setup process, you will be able to restrict the number of simultaneous running jobs on the gatekeeper. We strongly recommend to choose managedfork as the default jobmanager when configuring the Compute Element.

Role based Authentication using VOMS Proxies
--------------------------------------------

*VOMS proxies* allow role based authentication. If your site will support VOMS proxies for authentication you will be able to restrict write access to shared file systems for grid users while providing write permissions to VO Administrators only. In this case we recommend to export **OSG\_APP** read-only to the gatekeeper and all worker nodes for grid users and read-write for VO Managers only.

Example Configurations
======================

This section contains a few example that illustrate how the different elements contributing to an OSG site can be combined. Each %GRAY%gray<span class="twiki-macro ENDCOLOR"></span> box represents a physical resource or virtual machine that is required in the example.

OSG Resource with Compute Element
---------------------------------

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="CE-EDG.png" src="%ATTACHURLPATH%/CE-EDG.png"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; &lt;p&gt; The image to the left shows all elements of a compute element. &lt;/p&gt; &lt;p&gt; *edg-mkgridmap* is used to create the *grid-mapfile* and to keep it current. &lt;/p&gt; &lt;p&gt; The *shared filesystem* is mounted on the compute element providing access to *OSG\_APP*, *OSG\_DATA* and *HOME*. &lt;/p&gt; &lt;p&gt; *GRAM* and *GridFTP* use the *grid-mapfile* to authenticate requests to run jobs and to transfer data. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="WN.png" src="%ATTACHURLPATH%/WN.png"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; &lt;p&gt; The image to the left shows a *Worker Node* that is connected to the *Compute Element* above by a network. &lt;/p&gt; &lt;p&gt; The *Worker Node Client* has to be installed on each worker node. &lt;/p&gt; &lt;p&gt; The *shared filesystem* is mounted on the worker node providing access to *OSG\_APP*, *OSG\_DATA* and *HOME*. &lt;/p&gt; &lt;p&gt; *Node Local Storage* is used for *OSG\_WN\_TMP* and *OSG\_GRID*. *OSG\_GRID* points to the installation of the *Worker Node Client*. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

OSG Resource with joined Compute and Storage Element
----------------------------------------------------

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;a href="%ATTACHURLPATH%/CE-SE-EDG.png"&gt;&lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="CE-SE-EDG.png" src="%ATTACHURLPATH%/CE-SE-EDG.png"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; &lt;p&gt; The left side shows elements of a joined Compute and Storage Element. &lt;/p&gt; &lt;p&gt; The shared file system is mounted on the compute and storage element. &lt;/p&gt; &lt;p&gt; The *BeStMan* storage solution provides the *SRM Service* allowing grid users to remotely access the shared file system. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="WN.png" src="%ATTACHURLPATH%/WN.png"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; &lt;p&gt; The image to the left shows a *Worker Node* that is connected to the *Compute Element* above by a network. &lt;/p&gt; &lt;p&gt; The *Worker Node Client* has to be installed on each worker node. &lt;/p&gt; &lt;p&gt; The *shared filesystem* is mounted on the worker node providing access to *OSG\_APP*, *OSG\_DATA* and *HOME*. &lt;/p&gt; &lt;p&gt; *Node Local Storage* is used for *OSG\_WN\_TMP* and *OSG\_GRID*. *OSG\_GRID* points to the installation of the *Worker Node Client*. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

OSG Resource with separate Compute and Storage Element
------------------------------------------------------

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="GUMS.png" src="%ATTACHURLPATH%/GUMS.png"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; &lt;p&gt; The image to the left shows the elements of an authorization host. &lt;/p&gt; &lt;p&gt; *GUMS* provides a central web service for grid authorization requests from storage and compute elements. &lt;/p&gt; &lt;p&gt; It is not required but recommended to run GUMS outside of the compute and and storage element which are shown below. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="CE-GUMS.png" src="%ATTACHURLPATH%/CE-GUMS.png"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; &lt;p&gt; The image to the left shows all elements of a compute element. &lt;/p&gt; &lt;p&gt; *GRAM* and *GridFTP* query *GUMS* to authenticate requests from grid users to run jobs or transfer data. &lt;/p&gt; &lt;p&gt; The *shared filesystem* is mounted on the compute element providing access to *OSG\_APP*, *OSG\_DATA* and *HOME*. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="SE-GUMS.png" src="%ATTACHURLPATH%/SE-GUMS.png"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; &lt;p&gt; The image to the left shows all elements of a storage element. &lt;/p&gt; &lt;p&gt; *SRM* and *GridFTP* query *GUMS* to authenticate requests from grid users to transfer data. &lt;/p&gt; &lt;p&gt; The *shared filesystem* is mounted on the compute element providing access to *OSG\_APP*, *OSG\_DATA* and *HOME*. &lt;/p&gt; &lt;p&gt; The *BeStMan* storage solution provides the *SRM Service* allowing grid users to remotely access the shared file system. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="WN.png" src="%ATTACHURLPATH%/WN.png"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; &lt;p&gt; The image to the left shows a *Worker Node* that is connected to the *Compute Element* above by a network. &lt;/p&gt; &lt;p&gt; The *Worker Node Client* has to be installed on each worker node. &lt;/p&gt; &lt;p&gt; The *shared filesystem* is mounted on the worker node providing access to *OSG\_APP*, *OSG\_DATA* and *HOME*. &lt;/p&gt; &lt;p&gt; *Node Local Storage* is used for *OSG\_WN\_TMP* and *OSG\_GRID*. *OSG\_GRID* points to the installation of the *Worker Node Client*. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

OSG Resource with Compute Element and dCache Storage Element
------------------------------------------------------------

&lt;div style="%STYLE\_CAP\_FRAME%"&gt; &lt;div style="float: left;"&gt; &lt;a href="%ATTACHURLPATH%/LargeSite.gif"&gt;&lt;img style="%STYLE\_IMG\_FRAME%" width="%IMG\_WIDTH%" height="%IMG\_HEIGHT%" alt="%LargeSite.gif" src="%ATTACHURLPATH%/LargeSite.gif"/&gt;&lt;/a&gt; &lt;/div&gt; &lt;div style="%STYLE\_CAP\_BOX%"&gt; *OSG Compute and dCache Storage Element using GUMS* &lt;p style="text-indent: 2em;"&gt; The left side shows all elements of a compute and a *dCache* storage element. On the right side a set of worker node are drawn which are distinct from *dCache Pool Nodes*. &lt;/p&gt; &lt;p&gt; The worker nodes and dCache pool nodes are connected to the compute and storage element by a network. &lt;/p&gt; &lt;p&gt; *GRAM* and *GridFTP* use *GUMS* to authenticate requests to run jobs and to transfer data. &lt;/p&gt; &lt;/div&gt; &lt;/div&gt;

Plan your own Site
------------------

<span class="twiki-macro ICON">hand</span> We recommend that you draw your site configuration on paper before you proceed. You can also use the attached &lt;a href="%ATTACHURLPATH%/GraphicsTemplate.svg"&gt;Graphics Template&lt;/a&gt; for this purpose.

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_REVIEW%</span>

%GRAY%This doesn't belong on thos page:<span class="twiki-macro ENDCOLOR"></span>

+--++ Certificates

In general, your CE will need two certificates: a host certificate and an http certificate. A squid proxy doesn't need any certificates.

Your installation will go most smoothly if you get your certificates first.

[More information about the certificates you need](Trash.ReleaseDocumentationGetHostServiceCertificates)

+---++ Registering with OSG Note that you will need to register your site with the OSG Grid Operations Center (GOC). This can be done at the [OIM](https://oim.grid.iu.edu) registration pages. You will need to have a valid IGTF certificate loaded into your browser to access OIM.

%GRAY%The SitefabricBestPractices seems outdated and is therefor not linked here anymore:<span class="twiki-macro ENDCOLOR"></span>

+---+ Site Best Practices

Some technical details about [site fabric best practices](SiteFabricBestPractices). <span class="twiki-macro ENDTWISTY"></span>

**Comments**
============

|                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |                    |                     |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------|---------------------|
| For the example configurations: If your fork/managed-fork jobs are running on the Compute Element, then OSG\_GRID and the Worker Node Client have to be installed/accessible also on the compute element. Possibly also OSG\_WN\_TMP should be available.                                                                                                                                                                                                                             | Main.MarcoMambelli | 04 Aug 2010 - 02:39 |
| The images of the power button and the drive are missing. So the template cannot be used to reproduce the images in the document.                                                                                                                                                                                                                                                                                                                                                     | Main.MarcoMambelli | 05 Aug 2010 - 15:26 |
| Only documentation on NFSLite that I can find is in the VDT, not in any current ReleaseDocumentation. There should be a page for that.                                                                                                                                                                                                                                                                                                                                                | Main.StevenTimm    | 15 Oct 2010 - 19:11 |
| Under VOMS proxies, the phrase "export **OSG\_APP** read-only to the gatekeeper and all worker nodes for grid users and read-write for VO Managers only." doesn't technically make sense, there&lt;br /&gt;is no way to do a user-based nfs export. &lt;br /&gt;&lt;br /&gt;Better to say "export OSG\_APP to worker nodes read-only for all grid users, and read-write to the gatekeeper with file and directory permissions such that only VO managers and no grid users can write. | Main.StevenTimm    | 15 Oct 2010 - 19:14 |
| The GraphicsTemplate.svg link doesn't work on my browser.                                                                                                                                                                                                                                                                                                                                                                                                                             | Main.SoichiHayashi | 03 Aug 2011 - 18:41 |
| Any examples of multiple gatekeepers feeding a single resource?                                                                                                                                                                                                                                                                                                                                                                                                                       | Main.RobGardner    | 10 May 2012 - 19:45 |

<span class="twiki-macro COMMENT" type="tableappend"></span>

<span class="twiki-macro STOPINCLUDE"></span>
