Installing the XRootD Monitoring Shoveler
=========================================

The [XRootD Monitoring Shoveler](https://github.com/opensciencegrid/xrootd-monitoring-shoveler) 
is designed to accept the XRootD monitoring packets and "shovel" them to the OSG message bus.

<figure markdown style="margin: 0px">
``` mermaid
graph LR
  subgraph Site
    subgraph Node 1
    node1[XRootD] -- UDP --> shoveler1{Shoveler};
    end
    subgraph Node 2
    node2[XRootD] -- UDP --> shoveler1{Shoveler};
    end
  end;
  subgraph OSG Operations
  shoveler1 -- TCP/TLS --> C[Message Bus];
  C -- Raw --> D[XRootD Collector];
  D -- Summary --> C;
  C -- Summary --> E[(Storage)];
  style shoveler1 font-weight:bolder,stroke-width:4px,stroke:#E74C3C,font-size:4em,color:#E74C3C
  end;
```
<figcaption>Architecture of XRootD Monitoring with the Shoveler</figcaption>
</figure>


Installing the Shoveler
-----------------------

The shoveler can be installed via RPM, Container, or staticly compiled binary.

Requirements for running the Shoveler

1. An open port (configurable) that can receive UDP packets from the XRootD servers.  It does not need to be an open port to the internet, only open to the XRootD servers.
2. Outgoing TCP connectivity.
3. A directory to store the on-disk queue.

Configuring the Shoveler
------------------------

* Environment variables and config file.

Configuring Security
--------------------

A token is used to authenticate and authorize the shoveler with the message bus.

1. Get your unique CILogon User Identifier from [CILogon](https://cilogon.org/).  It is under User Attributes, and follows the pattern http://cilogon.org/serverA/users/12345.
2. Open a ticket at help@opensciencegrid.org with your CILogon User Identifier to authorize your login with the renewer.
3. Install the [OSG Token Renewal Service](https://opensciencegrid.org/docs/other/osg-token-renewer/)
4. When installing, the issuer is `https://lw-issuer.osgdev.chtc.io/scitokens-server/`
5. When asked about scopes, accept the default.
6. Follow through authentication the flow.
7. In the configuration for the issuer, `/etc/osg/token-renewer/config.ini`, the token location must match the location of the token in the Shoveler configuration.

