Installation of FileBeats for Submit nodes
==========================================

This document is for frontend administrators. It describes the installation of [Filebeats](https://www.elastic.co/products/beats/filebeat) to continusly upload the HTCondor submit hosts transfer log to Elastic Search.


Introduction
=================

A submit host (HTCondor schedd) is a login node where users submit jobs to the Grid. One interesting log that it produces is the TransferLog. The TransferLogs report all the transfers of files between compute node sand submit nodes. In this guide we describe the installation of Filebeats to upload this log to Elastic Search.

Installation
=================

FileBeat Installation
----------------------------------------------
For the installation of filebeats follow the  official instruction to set up the repositories and install filebeats as described [here](https://www.elastic.co/guide/en/beats/filebeat/current/setup-repositories.html).

Configuration
================

Configuration of Filebeats
-----------------------------------------

The configuration of filebeats revovles around this file `/etc/filebeat/filebeat.yml`. Bellow are the steps to modify the different sections of this file

1. The input section should look like this:

     ::: file
     - input_type: log
     paths:
     - /var/log/condor/XferStatsLog

1. The output logstash section should look like:

   ```file
      #----------------------------- Logstash output --------------------------------
      output.logstash:
      # The Logstash hosts
      hosts: ["gracc.opensciencegrid.org:6938"]

      # Optional SSL. By default is off. 
      # List of root certificates for HTTPS server verifications
      ssl.certificate_authorities: ["/etc/grid-security/certificates/cilogon-osg.pem"]

      # Certificate for SSL client authentication
      ssl.certificate: "/etc/grid-security/hostcert.pem"

      # Client Certificate Key
      ssl.key: "/etc/grid-security/hostkey.pem"
   ```

Configuration of HTCondor
-----------------------------------------


Client Site Installation 
------------------------------------------------------------------

The Network Performance Toolkit is installed with the OSG Client. Specifically, the tools included are: BWCTL, NDT and OWAMP (bwctl-client, bwctl-server, bwctl, ndt, owamp-client). NPAD is currently not in OSG client.

If you just want to install the OSG command line clients you can do the following::

``` console
yum install bwctl-client
yum install owamp-client
yum install ndt-client
yum install npad-client
```

You may install these utilities separately as RPM using yum by following the [perfSONAR](http://www.perfsonar.net/about) instructions. The packages are in the OSG repository, some of them with a separate client or server version, available for the OSG supported platforms:

-   NDT: ndt
-   OWAMP: owamp, owamp-client, owamp-server
-   BWCTL: bwctl, bwctl-client, bwctl-server
-   NPAD: npad

Server Site Installation 
------------------------------------------------------------------

