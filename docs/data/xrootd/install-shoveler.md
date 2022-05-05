title: Installing the XRootD Monitoring Shoveler

Installing the XRootD Monitoring Shoveler
=========================================

The [XRootD Monitoring Shoveler](https://github.com/opensciencegrid/xrootd-monitoring-shoveler) 
is designed to accept the XRootD monitoring packets and "shovel" them to the OSG message bus.
Shoveling is the act of moving messages from one medium to another.
In this case, the shoveler is moving messages from a UDP stream to a message bus.

```mermaid
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

Installing the Shoveler
-----------------------

The shoveler can be installed via RPM, container, or staticly compiled binary.

### Requirements for running the Shoveler:

1. An open port (configurable) that can receive UDP packets from the XRootD servers on the shoveler server.
    It does not need to be an open port to the internet, only open to the XRootD servers.
1. Outgoing TCP connectivity on the shoveler host.
1. A directory on the shoveler host to store the on-disk queue.

### Resource Requirements:

1. **RAM**: Production shovelers use less than 50MB of memory
2. **Disk**: If the shoveler is disconnected from the message bus, it will store the messages on disk until reconnected.  Through testing, a disconnected shoveler with 12 busy XRootD servers will generate <30 MB of data a day on disk.
3. **CPU**: A production shoveler will use 1-2% of a CPU, depending on how many XRootD servers are reporting to the shoveler.  A shoveler with 12 busy XRootD servers reporting to it uses 1-2% of a CPU.
4. **Network**: A production shoveler will receive UDP messages from XRootD servers and send them to a message bus.  The incoming and outgoing network utilization will be the same.  In testing, a shoveler will use <30MB of data a day on the network.

Configuring the Shoveler
------------------------

Configuration can be specified with environment variables or a configuration file.
The configuration file is in `yaml`.
An example configuration file is distributed with the shoveler.
In the RPM, the configuration file is located in `/etc/xrootd-monitoring-shoveler/config.xml`.
Below, we will break the configuration file into fragments but together they make a whole configuration file.

Environment variables can be derived from the yaml.  Every environment variable starts with `SHOVELER_`, then continues with the structure of the configuration file.  For example, the `amqp url` can be configured with the environment variable `SHOVELER_AMQP_URL`.  The `verify` option can be configured with `SHOVELER_VERIFY`.

### Configuration Fragments


#### AMQP Configuration

AMQP configuration.  For the OSG, the url should be `amqps://clever-turkey.rmq.cloudamqp.com/xrd-mon`.  The `exchange` should is correct for the OSG.  `token_location` is the path to the authentication token.

```yaml
# AMQP configuration
amqp:
  url: amqps://username:password@example.com/vhost
  exchange: shoveled-xrd
  topic:
  token_location: /etc/xrootd-monitoring-shoveler/token
```

#### Listening to UDP messages

Where to listen for UDP messages from XRootD servers.

```yaml
listen:
  port: 9993
  ip: 0.0.0.0
```

#### Verify packet header

Whether to verify the header of the packet matches XRootD's monitoring packet format.

```yaml
verify: true
```

#### Prometheus monitoring data

Listening location of [Prometheus](https://prometheus.io/) metrics to view the performance and status of the shoveler in Prometheus format.

```yaml
# Export prometheus metrics
metrics:
  enable: true
  port: 8000
```

#### Queue Configuration

Directory to store overflow of queue onto disk. The queue keeps 100 messages in memory.  If the shoveler is disconnected from the message bus, it will store messages over the 100 in memory onto disk into this directory.  Once the connection has been re-established the queue will be emptied.  The queue on disk is persistent between restarts.

```yaml
queue_directory: /tmp/shoveler-queue
```

#### IP Mapping Configuration

Mapping configuration (optional). If `map.all` is set, all messages will be mapped to the configured IP address.
For example, with the above configuration, if a packet comes in with the private IP address of 192.168.0.4, the packet origin will be changed to 172.0.0.4.  The port is always preserved.

```yaml
# map:
#   all: 172.0.0.4
```

If you want multiple mappings, you can specify multiple map entries.

```yaml
# map:
#   192.168.0.5: 172.0.0.5
#   192.168.0.6: 129.93.10.7
```


Configuring Security
--------------------

A token is used to authenticate and authorize the shoveler with the message bus.  The token is generated by the shoveler's lightweight issuer.

Sequence of getting a token for the shoveler is shown below.

```mermaid
sequenceDiagram
    User->>oidc-agent: Authenticate
    oidc-agent->>Issuer: Register agent
    Issuer->>oidc-agent: User Code
    oidc-agent->>User: User Code and URL
    User->>Issuer: Authenticate at URL
    oidc-agent->>Issuer: Get Token
```

1. Get your unique CILogon User Identifier from [CILogon](https://cilogon.org/).
    It is under User Attributes, and follows the pattern http://cilogon.org/serverA/users/12345.
1. Open a ticket at help@opensciencegrid.org with your CILogon User Identifier to authorize your login with the renewer.
1. Install the [OSG Token Renewal Service](https://opensciencegrid.org/docs/other/osg-token-renewer/)
1. When installing, the issuer is `https://lw-issuer.osgdev.chtc.io/scitokens-server/`
1. When asked about scopes, accept the default.
1. Follow through authentication the flow.
1. In the configuration for the issuer, `/etc/osg/token-renewer/config.ini`, the token location must match the location of the token in the Shoveler configuration.

