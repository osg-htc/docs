Registering in the OSG
======================

The OSG keeps a registry containing active projects, virtual organizations (VOs), resources, and resource
downtimes stored as as [YAML files](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)
in the [topology Github repository](https://github.com/opensciencegrid/topology/).
This registry is used for [accounting data](https://gracc.opensciencegrid.org), contact information, and resource
availability, particularly if your site is part of the [World LHC Computing Grid](http://wlcg.web.cern.ch/) (WLCG).

Use this page to learn how to register information in the OSG.

Registration Requirements
-------------------------

The instructions in this document require the following:

- A [GitHub](https://github.com/) account
- A working knowledge of [GitHub collaboration](https://help.github.com/categories/collaborating-with-issues-and-pull-requests/)
- OSG contact registration. If not already registered [here](https://topology.opensciencegrid.org/miscuser/xml?), send
  an email to <mailto:help@opensciencegrid.org> with the following information:
    - Full name
    - GitHub ID
    - Description of your OSG affiliation, e.g. FermiGrid site administrator, senior scientist for the DUNE experiment,
      etc.
    - Contact information of site, Virtual Organization, or project sponsor to prove affiliation

Registering Resources
---------------------

An OSG resource is a host that provides grid services, e.g. Compute Elements, storage endpoints, or perfSonar hosts.
See the full list of services that should be registered in the OSG topology
[here](https://github.com/opensciencegrid/topology/blob/master/topology/services.yaml).

OSG resources are stored under a hierarchy of facilities, sites, and resource groups, defined as follows:

| Level          | Definition                                                                                                                                                             |
|----------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Facility       | The institution or company where your resource is located, e.g. `University of Wisconsin`                                                                              |
| Site           | Smaller than a facility; typically represents an academic department, research group, or a computing center, e.g. `CHTC` for the Center for High Throughput Computing. |
| Resource Group | A logical grouping of resources, e.g. you may group together resources that serve your Slurm cluster under a resource group named `Slurm-HPC`                          |
| Resource       | A host that provides grid services, e.g. Compute Elements, storage endpoints, or perfSonar hosts.                                                                      |

OSG resources are stored in YAML files that can be found in the GitHub repository in a directory structure that reflects
the above hierarchy, i.e. `topology/<FACILITY>/<SITE>/<RESOURCE GROUP>.yaml` from the
[root of the topology repository](https://github.com/opensciencegrid/topology/tree/master/).

### Searching for resources ###

Whether you are registering a new resource or modifying an existing resource, start by searching for the FQDN of your
host to avoid any duplicate registrations:

1. Open the [topology repository](https://github.com/opensciencegrid/topology/tree/master/) in your browser.

1. Search the repository for the FQDN of your resource wrapped in double-quotes using the GitHub search bar
   (e.g., `"glidein2.chtc.wisc.edu"`):

    ![GitHub search](/img/registration/github-search.png)

    - **If the search doesn't return any results**, skip to [these instructions](#new-resources) for registering a new
      resource.
    - **If the search returns a single YAML file**, open the link to the YAML file and skip to
      [these instructions](#modifying-existing-resources) for modifying an existing resources.
    - **If the search returns more than one YAML file**, please [contact us](#getting-help).

### New resources ###

To register a new resource, follow the instructions below:

1. If you haven't already, verify that the FQDN of your resource is not [already registered](#registering-resources)

1. Choose the names of your facility, site, and resource group, ensuring that the names match any pre-existing
   facilities, sites, or resource groups (including case and spaces). Use the names that you choose to replace
   `<FACILITY>`, `<SITE>`, and `<RESOURCE GROUP>` below:

    - If your resource group already exists under your facility and site, open the following URL in your browser:

            https://github.com/opensciencegrid/topology/edit/master/<FACILITY>/<SITE>/<RESOURCE GROUP>.yaml

        For example, to add a resource to the `CHTC` resource group for the `CHTC` site at the `University of
        Wisconsin`, use the following URL:

            https://github.com/opensciencegrid/topology/edit/master/topology/University of Wisconsin/CHTC/CHTC.yaml

    - If any of your facility, site, or resource group do not exist, open the following URL in your browser:

            https://github.com/opensciencegrid/topology/new/master?filename=topology/<FACILITY>/<SITE>/<RESOURCE GROUP>.yaml

        For example, to create a `Slurm-HPC` resource group for the Center for High Throughput Computing (`CHTC`) at the
        `University of Wisconsin`, use the following URL:

            https://github.com/opensciencegrid/topology/new/master?filename=topology/University of Wisconsin/CHTC/Slurm-HPC.yaml

1. Use the [GitHub file editor](https://help.github.com/articles/editing-files-in-your-repository/) to make changes
   using the [resource group template](https://github.com/opensciencegrid/topology/blob/master/template-resourcegroup.yaml)
   as a guide.

1. Submit your changes as a pull request, providing a descriptive commit message. For example:

        Adding a new compute element to the CHTC

### Modifying existing resources ###

To modify an existing resource, follow these instructions:

1. Find the resource that you would like to modify by [searching GitHub](#searching-for-resources) and opening the link
   to the YAML file.

1. Use the branch selector dropdown next to the file path and select the `master` branch.

    ![GitHub branch selection](/img/registration/switch-branch.png)

1. Use the [GitHub file editor](https://help.github.com/articles/editing-files-in-your-repository/) to make changes
   using the [resource group template](https://github.com/opensciencegrid/topology/blob/master/template-resourcegroup.yaml)
   as a guide.

1. Submit your changes as a pull request, providing a descriptive commit message. For example:

        Updating administrative contact information for CHTC-glidein2

Registering Resource Downtimes
------------------------------

Resource downtime is a period of time for which one or more of the grid services of a registered resource are
unavailable.
Downtimes are stored in YAML files alongside the resource group YAML files as described [here](#registering-resources),
i.e. `topology/<FACILITY>/<SITE>/<RESOURCE GROUP>_downtime.yaml` from the
[root of the topology repository](https://github.com/opensciencegrid/topology/tree/master/).
To register a new downtime for a registered resource, follow the instructions below:

1. Open the [topology repository](https://github.com/opensciencegrid/topology/tree/master/) in your browser.

1. Search the repository for the FQDN of your resource wrapped in double-quotes using the GitHub search bar
   (e.g., `"glidein2.chtc.wisc.edu"`):

    ![GitHub search](/img/registration/github-search.png)

    - **If the search returns a single YAML file**, note the name of the facility, site, and resource group and continue
      to the next step.
    - **If the search doesn't return any results**, your resource is not registered.
      Follow the [resource registration](#registering-resources) instructions before registering a downtime.
    - **If the search returns more than one YAML file**, please [contact us](#getting-help).

1. Open the following URL in your browser using the facility, site, and resource group names to replace `<FACILITY>`,
   `<SITE>`, and `<RESOURCE GROUP`>, respectively:

        https://github.com/opensciencegrid/topology/edit/master/<FACILITY>/<SITE>/<RESOURCE GROUP>_downtime.yaml

    If the above URL returns a 404, use this link instead:

        https://github.com/opensciencegrid/topology/new/master?filename=topology/<FACILITY>/<SITE>/<RESOURCE GROUP>_downtime.yaml

1. Use the [GitHub file editor](https://help.github.com/articles/editing-files-in-your-repository/) to make changes
   using the [downtime template](https://github.com/opensciencegrid/topology/blob/master/template-downtime.yaml) as a
   guide.

    !!! note
        Make sure the info you add matches the formatting and indentation of the template or the other downtime entries
        in the file.
        In particular, make sure no additional indentation gets added when pasting in the new data.

1. Submit your changes as a pull request, providing a descriptive commit message. For example:

        Adding downtime for CHTC-glidein2 for regular maintenance

How to Register
---------------

OSG registry information is stored in [YAML files](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)
in the topology Github repository.
The formatting and locations of the YAML files for the different types of registration data are described
in the following table:

| The following data... | Is defined by template file...       | And should be copied to location, relative to the Git root directory... |
|-----------------------|--------------------------------------|-------------------------------------------------------------------------|
| Project               | `template-project.yaml`              | `projects/<PROJECT NAME>.yaml`                                          |
| Resource Downtime     | `template-downtime.yaml`             | `topology/<FACILITY>/<SITE>/<RESOURCE GROUP NAME>_downtime.yaml`        |
| Resource Topology     | `template-resourcegroup.yaml`        | `topology/<FACILITY>/<SITE>/<RESOURCE GROUP NAME>.yaml`                 |
| Virtual Organization  | `template-virtual-organization.yaml` | `virtual-organizations/<VO NAME>.yaml`                                  |

The comments in the template files explain the structure and the meaning of the data.

!!! note
    File and directory names _must_ match the name of your project, VO, facility, site, or resource group, as
    appropriate.
    This includes case and spaces.

### New registrations ###

To create a new resource group, project, or VO, please create the YAML file according to the table above, and use the
corresponding template file to fill in the appropriate information.
If you do not feel comfortable creating the new file yourself, send an email to <help@opensciencegrid.org> with
details about your resource group, project, or VO.

### Updating existing registrations ###

To update the data for your site resources, project, or VO, make and submit your changes using one of the following
methods:

- [Modify the corresponding YAML file](https://help.github.com/articles/editing-files-in-your-repository/) and submit
  your changes as a GitHub pull request.
- Send an email to <help@opensciencegrid.org> requesting your desired changes.

For definitions for the various fields, consult the corresponding template file for the type of data you are updating.

To remove or disable a resource already registered:

- If the resource is a Compute Element or OSG submitter, set `Active: false` within resource group's yaml file.  For example, to remove
   the resource GLOW, edit the file `topology/University of Wisconsin/GLOW/GLOW.yaml`, setting `Active: false`:

        ...
        Production: true
        Resources:
          GLOW:
            Active: %RED%false%ENDCOLOR%
            ...
    
    You may have to add the `Active` attribute it if does not already exist within the resource definition.

- If the resource is not a Compute Element or OSG submitter, you may remove the resource completely.  If there are no more resources
   in the resource group, you may remove the entire resource group file.

Getting Help
------------

To get assistance, please use the [this page](/common/help).
