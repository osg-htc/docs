Installation of FileBeats for Submit nodes
==========================================

This document is for frontend administrators. It describes the installation of [Filebeats](https://www.elastic.co/products/beats/filebeat) to continusly upload the HTCondor submit host transfer log to Elastic Search.


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

1. The `Filebeat Prospectors` section, the input should look like this:

        :::file
        - input_type: log
        paths:
        - /var/log/condor/XferStatsLog

1. The output logstash section should look like:

        :::file
        #----------------------------- Logstash output --------------------------------
        output.logstash:
        # The Logstash hosts
        hosts: ["gracc.opensciencegrid.org:6938"]
 
        # Optional SSL. By default is off. 
        # List of root certificates for HTTPS server verifications
        ssl.certificate_authorities: ["/etc/grid-security/certificates/cilogon-osg.pem"]

        #  Certificate for SSL client authentication
        ssl.certificate: "/etc/grid-security/hostcert.pem"
 
        # Client Certificate Key
        ssl.key: "/etc/grid-security/hostkey.pem"

1. Comment out all of the `Elasticsearch output` since we are using LogStash

        :::file
        #-------------------------- Elasticsearch output ------------------------------
        #output.elasticsearch:
        # Array of hosts to connect to.
        #hosts: ["localhost:9200"]

        # Optional protocol and basic auth credentials.
        #protocol: "https"
        #username: "elastic"
        #password: "changeme"

1. Test configuration is correct by running:
 
        :::console
        root@host # filebeat.sh -configtest -e

1. Start the filebeats services

        :::console
        root@host # service filebeat start

1. The general section should look like this:

        :::file
        #================================ General =====================================

        name: %RED%<hostname>%ENDCOLOR%
        tags: ["xfer-log"]

        # Optional fields that you can specify to add additional information to the
        # output.
        #fields:
        #  env: staging



Configuration of HTCondor
-----------------------------------------

For the configuration of the HTCondor submit host to use the TransferLog follow the next instructions:

1. Create a file named `/etc/condor/config.d/50-transferLog.config` with the following contnets
    
        :::file
        SHADOW_DEBUG = D_STATS
        SHADOW_STATS_LOG = $(LOG)/XferStatsLog
        STARTER_STATS_LOG = $(LOG)/XferStatsLog

1. Reconfigure condor:

        :::console
        root@host #condor_reconfig

1. Make sure that after a while the new log `/var/log/XferStatsLog` is present.



