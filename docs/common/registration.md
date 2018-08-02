Registering in the OSG
======================

The OSG keeps a registry containing active projects, virtual organizations (VOs), resources, and resource
downtimes in the [topology Github repository](https://github.com/opensciencegrid/topology/).
This registry is used for [accounting data](https://gracc.opensciencegrid.org), contact information, and resource
availability, particularly if your site is part of the [World LHC Computing Grid](http://wlcg.web.cern.ch/) (WLCG).

Use this page to learn how to register information in the OSG.

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

To remove or disable a resource already registered, follow the steps:

1. If the resource is a Compute Element or OSG submitter, set `Active: false` within resource group's yaml file.  For example, to remove
   the resource GLOW, edit the file `topology/University of Wisconsin/GLOW/GLOW.yaml`, setting `Active: false`:
    
        :::toml
        ...
        Production: true
        Resources:
          GLOW:
            Active: %RED%false%ENDCOLOR%
            ...
    
    You may have to add the `Active` attribute it if does not already exist within the resource definition.

2. If the resource is not an Compute Element or OSG submitter, you may remove the resource completely.  If there are no more resources
   in the resource group, you may remove the entire resource group file.


### How to Register Downtime ###

Downtime is a period of time for which one or more services you provide are unavailable.
You should register downtime if one of these is true:

-  your site is part of the WLCG
-  your CE is one of the services affected

1. Find the file that should contain downtime information about resources you own.
   It is named `topology/<FACILITY>/<SITE>/<RESOURCE GROUP NAME>_downtime.yaml`.

   For example, `topology/University of Wisconsin/GLOW/GLOW.yaml` has the corresponding downtime file
   `topology/University of Wisconsin/GLOW/GLOW_downtime.yaml`.

   If the downtime file does not exist, create it.

   To find out what resource group a host is in, search for the FQDN of the host with something like:

   `grep -F "<FQDN>" topology/*/*/*.yaml | grep -Fv _downtime.yaml | grep -Fv SITE.yaml`

   If the above command returns nothing, then the host is not registered in the topology data
   and you don't need to register downtime for it.

2. Add the contents of `template-downtime.yaml` to the end of the downtime file in the path above.

3. Follow the instructions in the comments to fill out the necessary fields.

   **Note:** Make sure the info you add matches the formatting and indentation of the template or the other downtime entries in the file.
   In particular, make sure no additional indentation gets added when pasting in the new data.

4. Submit your changes as a GitHub pull request.

Alternatively, send an email to <help@opensciencegrid.org> requesting your desired changes.


