title: Firewall Considerations
DateReviewed:

Firewall Considerations
=======================

Services run at a site need to communicate with the distributed OSG Fabric of
Services, which may require changes in your firewall.
For instance, the OSG Factory hosts need to communicate with CEs in order for
your site to receive any work.
This page contains information about ports and hosts that need to communicate with your site services.

!!! note
    -   Inbound hosts only apply to certain collaborations (including the OSPool).
        If an administrator is unsure about which hosts to allow, they should
        contact the collaborations that they support.
    -   Limiting inbound connections will limit collaborators' ability to remotely
        troubleshoot issues or result in service outages as a collaboration's
        glidein submission infrastructure evolves.

### Compute Entrypoints

| **Destination Port** | **Direction** | **Hosts** |
|:---------------------|---------------|-----------|
| TCP 9619             | Inbound       | gfactory-2.opensciencegrid.org<br/>gfactory-itb-1.opensciencegrid.org<br/>vocms0207.cern.ch         |
| TCP 9619             | Outbound      | collector.opensciencegrid.org<br/>collector1.opensciencegrid.org<br/>collector1.opensciencegrid.org |

