DateReviewed: 2022-12-20
title: Registering in the OSG

Registering in the OSG
======================

The OSG keeps a registry containing active projects, collaborations (i.e., virtual organizations or VOs), resources,
and resource downtimes stored as
[YAML files](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)
in the [topology GitHub repository](https://github.com/opensciencegrid/topology/).
This registry is used for [accounting data](https://gracc.opensciencegrid.org), contact information, and resource
availability, particularly if your site is part of the [World LHC Computing Grid](http://wlcg.web.cern.ch/) (WLCG).

Use this page to learn how to register information in the OSG.

Registration Requirements
-------------------------

The instructions in this document require the following:

- A [GitHub](https://github.com/) account
- A working knowledge of [GitHub collaboration](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests)
- [OSG contact](#registering-contacts) registration

Registering Contacts
--------------------

OSG staff keep track of contact information for OSG Consortium participants to provide access to OSG services,
notify administrators and security contacts of software and security updates,
and coordinating in case of security incidents or troubleshooting services.

To register your contact information with the OSG Consortium, follow the instructions in
[this document](contact-registration.md).

!!! info "Privacy Notice"
    The OSG treats any email addresses and phone numbers as confidential data but does not make any guarantees of
    privacy.
    All other data is public (such as name, GitHub username, and any association with particular services or
    collaborations).

Registering Resources
---------------------

An OSG resource is a host that provides grid services, e.g. Compute Entrypoints, storage endpoints, or perfSonar hosts.
See the full list of services that should be registered in the OSG topology
[here](https://github.com/opensciencegrid/topology/blob/master/topology/services.yaml).

OSG resources are stored under a hierarchy of facilities, sites, and resource groups, defined as follows:

-   **Facility**: The institution or company name where your resource is located.
-   **Site**: Smaller than a facility; typically represents a computing center or an academic department.
    Frequently used as the display name for [accounting dashboards](http://gracc.opensciencegrid.org).
-   **Resource Group**: A logical grouping of resources at a site,
    i.e. all resources associated with a specific computing cluster.
    Multi-resource downtimes are easiest to declare across a resource group.
    Production and testing resources must be placed into separate resource groups.
-   **Resource**: A host that provides grid services, e.g. Compute Entrypoints, storage endpoints, or perfSonar hosts.

Throughout this document, you will be asked to substitute your own facility, site, resource group, and resource names
when registering with the OSG.
If you don't already know the relevant names for your resource, using the following naming conventions:

| Level          | Naming convention                                                                                                                                                                 |
|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Facility       | Unabbreviated institution or company name, e.g. `University of Wisconsin - Madison`                                                                                               |
| Site           | Computing center or academic department, e.g. `CHTC`, `MWT2 ATLAS UC`, `San Diego Supercomputer Center`<br>The only characters allowed in Site names are letters, numbers, underscores, hyphens, and spaces; i.e., a Site name must match the regular expression `^[A-Za-z0-9_ -]+$` |
| Resource Group | Abbreviated facility, site, and cluster name. Resource groups used for testing purposes should have an `-ITB` or `- ITB` suffix, e.g. `TCNJ-ELSA-ITB`                            |
| Resource       | In all capital letters, `<ABBREV FACILTY>-<CLUSTER>-<RESOURCE TYPE>`, for example:<br>`TCNJ-ELSA-CE` or `NMSU-AGGIE-GRID-SQUID`<br>If you don't know which collaboration to use, pick `OSG`. |

OSG resources are stored in the GitHub repository as YAML files under a directory structure that reflects the above
hierarchy, i.e. `topology/<FACILITY>/<SITE>/<RESOURCE GROUP>.yaml` from the
[root of the topology repository](https://github.com/opensciencegrid/topology/tree/master/).


### New site

To register a site, first choose a name for it (see the [naming conventions table above](#registering-resources))
The site name will appear in OSG accounting in places such as the
[GRACC site dashboard](https://gracc.opensciencegrid.org/d/000000079/site-summary?orgId=1).

Once you have chosen a site name, open the following in your browser:

    https://github.com/opensciencegrid/topology/new/master?filename=topology/<FACILITY>/<SITE>/SITE.yaml

(replacing `<FACILITY>` and `<SITE>` with the facility and the site [name that you chose](#registering-resources)).
   
!!! note ""You're editing a file in a project you don't have write access to.""
    If you see this message in the GitHub file editor, this is normal and it is because you do not have direct write
    access to the OSG copy of the topology data, which is why you are creating a pull request.
   
Make changes with the [GitHub file editor](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files) using
the [site template](https://github.com/opensciencegrid/topology/blob/master/template-SITE.yaml) as a guide.
You may leave the `ID` field blank.
When adding new entries, make sure that the formatting and indentation of your entry matches that of the template.

Submit your changes as a pull request; select "opensciencegrid/topology" as the base repo.
Provide a descriptive commit message, for example:

    Adding AggieGrid cluster for New Mexico State

### Searching for resources ###

Whether you are registering a new resource or modifying an existing resource, start by searching for the FQDN of your
host to avoid any duplicate registrations:

1. Open the [topology repository](https://github.com/opensciencegrid/topology/tree/master/) in your browser.

1. Search the repository for the FQDN of your resource wrapped in double-quotes using the GitHub search bar
   (e.g., `"glidein2.chtc.wisc.edu"`):

    ![GitHub search](../img/registration/github-search.png)

    - **If the search doesn't return any results**, skip to [these instructions](#new-resources) for registering a new
      resource.
    - **If the search returns a single YAML file**, open the link to the YAML file and skip to
      [these instructions](#modifying-existing-resources) for modifying existing resources.
    - **If the search returns more than one YAML file**, please [contact us](#getting-help).

    !!! note
        If you are adding a new service to a host which is already registered as a resource,
        follow the [instructions](#modifying-existing-resources) for modifying existing resources.

### New resources ###

Before registering a new resource, make sure that its FQDN is not [already registered](#searching-for-resources).

To register a new resource, follow the instructions below:

1. Find the facility, site, and resource group for your resource in the [topology repository](https://github.com/opensciencegrid/topology/tree/master/)
   under this directory structure: 
   `topology/<FACILITY>/<SITE>/<RESOURCE GROUP>.yaml`.
   When searching for these, keep in mind that case and spaces matter.

    - If you do not have a facility, contact <mailto:help@osg-htc.org> for help.
    - If you have a facility but not a site, first follow the instructions
      for [registering a site](#new-site) above.
    - If you have a facility and a site but not a resource group, pick a [resource group name](#registering-resources).

1. Once you have your facility, site, and resource group, follow the instructions below,
   replacing instances of `<FACILITY>`, `<SITE>`, and `<RESOURCE GROUP>`
   with the corresponding [names that you chose above](#registering-resources):

    - If your resource group already exists under your facility and site, open the following URL in your browser:

            https://github.com/opensciencegrid/topology/edit/master/topology/<FACILITY>/<SITE>/<RESOURCE GROUP>.yaml

        For example, to add a resource to the `CHTC` resource group for the `CHTC` site at the `University of
        Wisconsin`, open the following URL:

            https://github.com/opensciencegrid/topology/edit/master/topology/University of Wisconsin/CHTC/CHTC.yaml

    - If your resource group does not exist, open the following URL in your browser:

            https://github.com/opensciencegrid/topology/new/master?filename=topology/<FACILITY>/<SITE>/<RESOURCE GROUP>.yaml

        For example, to create a `CHTC-Slurm-HPC` resource group for the Center for High Throughput Computing (`CHTC`)
        at the `University of Wisconsin`, open the following URL:

            https://github.com/opensciencegrid/topology/new/master?filename=topology/University of Wisconsin/CHTC/CHTC-Slurm-HPC.yaml

    !!! note ""You're editing a file in a project you don't have write access to.""
        If you see this message in the GitHub file editor, this is normal and it is because you do not have direct write
        access to the OSG copy of the topology data, which is why you are creating a pull request.

1. Make changes with the [GitHub file editor](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files) using
   the [resource group template](https://github.com/opensciencegrid/topology/blob/master/template-resourcegroup.yaml)
   as a guide.
   You may leave any `ID` or `GroupID` fields blank.
   When adding new entries, make sure that the formatting and indentation of your entry matches that of the template.

1. Submit your changes as a pull request; select "opensciencegrid/topology" as the base repo.
   Provide a descriptive commit message, for example:

        Adding a new compute entrypoint to the CHTC

### Modifying existing resources ###

To modify an existing resource, follow these instructions:

1. Find the resource that you would like to modify by [searching GitHub](#searching-for-resources), and open the link to
   the YAML file.

1. Click the branch selector button next to the file path and select the `master` branch.

    ![GitHub branch selection](../img/registration/switch-branch.png)

1. Make changes with the [GitHub file editor](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files) using
   the [resource group template](https://github.com/opensciencegrid/topology/blob/master/template-resourcegroup.yaml)
   as a guide.
   You may leave any `ID` or `GroupID` fields blank.
   Make sure that the formatting and indentation of the modified entry does not change.

   If you are adding a new service to a host that is already registered as a resource,
   add the new service to the existing resource; do not create a new resource for the same host.

    !!! note ""You're editing a file in a project you don't have write access to.""
        If you see this message in the GitHub file editor, this is normal and it is because you do not have direct write
        access to the OSG copy of the topology data, which is why you are creating a pull request.

1. Submit your changes as a pull request; select "opensciencegrid/topology" as the base repo.
   Provide a descriptive commit message, for example:

        Updating administrative contact information for CHTC-glidein2

### Retiring resources ###

To retire an already registered resource, set `Active: false`. For example:

``` hl_lines="5"
...
Production: true
Resources:
  GLOW:
    Active: false
    ...
    Services:
      CE:
        Description: Compute Entrypoint
        Details:
          hidden: false
```

If the `Active` attribute does not already exist within the resource definition, add it.
If your resource becomes available again, set `Active: true`.


Registering Resource Downtimes
------------------------------

Resource downtime is a finite period of time for which one or more of the grid services of a registered resource are
unavailable.

!!! warning
    If you expect your resource to be indefinitely unavailable, [retire the resource](#retiring-resources) instead of
    registering a downtime.

Downtimes are stored in YAML files alongside the resource group YAML files as described [here](#registering-resources).

For example, downtimes for resources in the `CHTC-Slurm-HPC` resource group of the `CHTC` site at the `University of
Wisconsin` can be found and registered in the following file, relative to the
[root of the topology repository](https://github.com/opensciencegrid/topology/tree/master/):

```
topology/University of Wisconsin/CHTC/CHTC-Slurm-HPC_downtime.yaml
```

!!! note 
    Do not put downtime updates in the same pull request as other topology updates.

### Registering new downtime ###

To register a new downtime for a resource or for multiples resources that are part of a resource group,
you will use webforms to generate the contents of the downtime entry,
copy it into the downtime file corresponding to your resource,
and submit it as a GitHub pull request.
Follow the instructions below:

1.  Open one of the downtime generation webforms in your browser:

    -   Use the [resource downtime generator](https://topology.opensciencegrid.org/generate_downtime) if you only need
        to declare a downtime for a single resource.
    -   Use the [resource group downtime generator](https://topology.opensciencegrid.org/generate_resource_group_downtime)
        if you need to declare a downtime for multiple resources across a resource group.

1.  Select your facility, site, resource group, and/or resource from the corresponding lists.

1.  **For the single resource downtime form:**
    Select all the services that will be down.
    To select multiple, use Control-Click on Windows and Linux, or Command-Click on macOS.

1.  Fill the other fields with information about the downtime.

1.  Click the `Generate` button.

1.  If the information is valid, a block of text will be displayed in the box labeled `Generated YAML`.
    Otherwise, check for error messages and fix your input.

1.  Follow the instructions shown below the generated block of text.

    !!! note ""You're editing a file in a project you don't have write access to.""
        If you see this message in the GitHub file editor, this is normal and it is because you do not have direct write
        access to the OSG copy of the topology data, which is why you are creating a pull request.

1.  Wait for OSG staff to approve and merge your new downtime.


### Modifying existing downtime ###

In case an already registered downtime is incorrect or need to be updated to reflect new information, you can modify
existing downtime entries using the GitHub editor.

!!! failure
    Changes to the `ID` or `CreatedTime` fields will be rejected.

To modify an existing downtime entry for a registered resource,
manually make the changes in the matching downtime YAML file.
Follow the instructions below:

1.  Open the [topology repository](https://github.com/opensciencegrid/topology/tree/master/) in your browser.

1.  If you do not know the facility, site, and resource group of the resource the downtime entry refers to,
    search the repository for the FQDN of your resource wrapped in double-quotes using the GitHub search bar
    (e.g., `"glidein2.chtc.wisc.edu"`):

    ![GitHub search](../img/registration/github-search.png)

    - **If the search returns a single YAML file**,
      note the name of the facility, site, and resource group and continue to the next step.
    - **If the search doesn't return any results or returns more than one YAML file**,
      please [contact us](#getting-help).

1.  Open the following URL in your browser using the facility, site, and resource group names to replace
    `<FACILITY>`, `<SITE>`, and `<RESOURCE GROUP>`, respectively:

         https://github.com/opensciencegrid/topology/edit/master/topology/<FACILITY>/<SITE>/<RESOURCE GROUP>_downtime.yaml

    !!! note ""You're editing a file in a project you don't have write access to.""
        If you see this message in the GitHub file editor, this is normal and it is because you do not have direct write
        access to the OSG copy of the topology data, which is why you are creating a pull request.

1.  Make changes with the [GitHub file editor](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files) using
    the [downtime template](https://github.com/opensciencegrid/topology/blob/master/template-downtime.yaml)
    as a reference.
    Make sure that the formatting and indentation of the modified entry does not change.

1.  Submit your changes as a pull request; select "opensciencegrid/topology" as the base repo.
    Provide a descriptive commit message, for example:

        Move forward end date for CHTC-glidein2 regular maintenance

1.  Wait for OSG staff to approve and merge your modified downtime.


Registering Collaborations
--------------------------

Collaborations (formerly virtual organizations or VOs) are sets of groups or individuals defined by some common
cyber-infrastructure need.
This can be a scientific experiment, a university campus or a distributed research effort.
A collaboration represents all its members and their common needs in a grid environment.
A collaboration also includes the group’s computing/storage resources and services.
For more information about collaboration, see [this page](https://osg-htc.org/about/organization#virtual-organizations).

!!! info
    Before submitting a registration for a new collaboration, please [contact us](#getting-help) describing your
    organization's computing needs.

Collaboration information is stored as YAML files in the `virtual-organizations` directory of the
[topology repository](https://github.com/opensciencegrid/topology/tree/master).
To modify a collaboration's information or register a new collaboration, follow the instructions below:

1. Open the [topology repository](https://github.com/opensciencegrid/topology/tree/master/virtual-organizations) in your
   browser.

1. If you see your collaboration in the list, open the file and continue to the next step.
   If you do not see your collaboration in the list, click `Create new file` button:

    ![GitHub file creation](../img/registration/create-file.png)

    In the new file dialog, enter `<collaboration>.yaml`, replacing `<collaboration>` with the name of your collaboration.

    !!! note ""You're editing a file in a project you don't have write access to.""
        If you see this message in the GitHub file editor, this is normal and it is because you do not have direct write
        access to the OSG copy of the topology data, which is why you are creating a pull request.

1. Make changes with the [GitHub file editor](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files) using
   the [collaboration template](https://github.com/opensciencegrid/topology/blob/master/template-virtual-organization.yaml)
   as a guide.
   You may leave any `ID` fields blank.
   If you are modifying existing entries, make sure you do not change formatting or indentation of the modified entry.

1. Submit your changes as a pull request; select "opensciencegrid/topology" as the base repo.
   Provide a descriptive commit message, for example:

        Updating contact information for the GLOW collaboration

Registering Projects
--------------------

!!! info
    Before submitting a registration for a new project, please [contact us](#getting-help) describing your organization's
    computing needs.

Project information is stored as YAML files in the `projects` directory of the
[topology repository](https://github.com/opensciencegrid/topology/tree/master).
To modify a collaboration's information or register a new collaboration, follow the instructions below:

1. Open the [topology repository](https://github.com/opensciencegrid/topology/tree/master/projects) in your browser.

1. If you see your project in the list, open the file and continue to the next step.
   If you do not see your project in the list, click `Create new file` button:

    ![GitHub file creation](../img/registration/create-file.png)

    In the new file dialog, enter `<PROJECT>.yaml`, replacing `<PROJECT>` with the name of your project.

    !!! note ""You're editing a file in a project you don't have write access to.""
        If you see this message in the GitHub file editor, this is normal and it is because you do not have direct write
        access to the OSG copy of the topology data, which is why you are creating a pull request.

1. Make changes with the [GitHub file editor](https://docs.github.com/en/repositories/working-with-files/managing-files/editing-files) using
   the [project template](https://github.com/opensciencegrid/topology/blob/master/template-project.yaml) as a guide.
   You may leave any `ID` fields blank.
   If you are modifying existing entries, make sure you do not change formatting or indentation of the modified entry.

1. Submit your changes as a pull request; select "opensciencegrid/topology" as the base repo.
   Provide a descriptive commit message, for example:

        Updating contact information for the Mu2e project

Getting Help
------------

To get assistance, please use the [this page](../common/help.md).
