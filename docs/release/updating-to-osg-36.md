!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If you do not know which VOs you are currently supporting, contact us at <help@opensciencegrid.org>.

Updating to OSG 3.6
===================

[OSG 3.6](release_series.md#series-overviews) (the *new series*) is a major overhaul of the OSG software stack compared
to OSG 3.5 (the *old series*) with changes to core protocols used for authentication and data transfer.
Depending on the VO(s) that you support, updating to the new series could result in issues with your site receiving
pilot jobs and/or issues with data transfer.

If you have verified that your VO(s) support token-based pilot submission and HTTP-based data transfers,
use this document to update your OSG software to OSG 3.6.

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

#### osg-configure ####

AI (Mat): https://opensciencegrid.atlassian.net/browse/SOFTWARE-4496

#### HTCondor-CE ####

AI (BrianL): https://opensciencegrid.atlassian.net/browse/SOFTWARE-4501
HTCondor-CE in front of HTCondor CE, [see updating your HTCondor Hosts](#updating-your-htcondor-hosts)

### Starting CE services ###


Updating Your HTCondor Hosts
----------------------------

TimT: Insert text for updates to HTCondor (https://opensciencegrid.atlassian.net/browse/SOFTWARE-4508)
