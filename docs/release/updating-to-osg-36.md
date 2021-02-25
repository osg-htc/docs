Updating to OSG 3.6
===================



Updating Your OSG Compute Entrypoint
------------------------------------

### Turning off CE services ###

1.  Turn off CE/gratia services
2.  AI (Carl): Document the Gratia command that admins can run to manually upload existing

### Updating CE packages ###

yum update

### Updating CE configuration ###

#### gratia-probe ####

AI (Carl): https://opensciencegrid.atlassian.net/browse/SOFTWARE-4473

#### OSG-Configure ####

The OSG 3.6 release series contains OSG-Configure 4, a major version upgrade from the previously released versions in the OSG.
See the [OSG-Configure 4.0.0 release notes](https://github.com/opensciencegrid/osg-configure/releases/tag/v4.0.0)
for an overview of the changes.
Several configuration modules and options were removed or deprecated and CE configuration has been simplified;
the update from version 3 to version 4 will require some manual changes to your configuration.

To update OSG-Configure, perform the following steps:

1.  Merge any `*.rpmnew` files in `/etc/osg/config.d/`

1.  Uninstall `osg-configure-gip` and `osg-configure-misc` if they are installed:

        :::console
        root@host# yum erase osg-configure-gip osg-configure-misc

1.  If `/etc/osg/config.d/30-gip.ini.rpmsave` exists, merge its contents into `31-cluster.ini`

1.  Edit the `Site Information` configuration section (in `40-siteinfo.ini`).
    If `resource_group` is not set, add:

        resource_group = <TOPOLOGY RESOURCE GROUP FOR THIS HOST>

1.  Run osg-configure to apply your changes:

        osg-configure -dc


#### HTCondor-CE ####

AI (BrianL): https://opensciencegrid.atlassian.net/browse/SOFTWARE-4501
HTCondor-CE in front of HTCondor CE, [see updating your HTCondor Hosts](#updating-your-htcondor-hosts)

### Starting CE services ###


Updating Your HTCondor Hosts
----------------------------

TimT: Insert text for updates to HTCondor (https://opensciencegrid.atlassian.net/browse/SOFTWARE-4508)
