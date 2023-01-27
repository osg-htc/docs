title: Firewall Considerations
DateReviewed:

Firewall Considerations
=======================

In order for hosts such as CEs to communicate with the OSG Factory hosts,
firewall rules should be added to allow the following connections:

| **Destination Port** | **Direction** | **Hosts** |
|:---------------------|---------------|-----------|
| TCP 9619             | Inbound       | gfactory-2.opensciencegrid.org<br/>gfactory-itb-1.opensciencegrid.org<br/>vocms0207.cern.ch         |
| TCP 9619             | Outbound      | collector.opensciencegrid.org<br/>collector1.opensciencegrid.org<br/>collector1.opensciencegrid.org |

Note the following:

-   Inbound hosts only apply to certain collaborations (including the OSPool).
    If an administrator is unsure about which hosts to allow, they should
    contact the collaborations that they support.
-   Limiting inbound connections will limit collaborators' ability to remotely
    troubleshoot issues or result in service outages as a collaboration's
    glidein submission infrastructure evolves.

