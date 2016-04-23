Installing GSI OpenSSH
======================

This document gives instructions on installing and using the GSI OpenSSH server available in the OSG repository and configuring it so that you can use on your cluster.

Requirements
============

Host and OS
-----------

The GSI OpenSSH rpms will require an user account and group in order for the privilege separation to work.

Users and Groups
----------------

The RPM installation will try to create the `gsisshd` user and group and the `/var/empty/gsisshd` directory with the correct ownership if they are not present. If you are using a configuration management system or ROCKS, you should make sure that these users and groups are created before installing the RPMs to avoid potential issues. The gsisshd user should have an empty home directory. By default, this is home directory set to `/var/empty/gsisshd` and belongs to the `gsisshd` user and group. You may change it if needed to something else as long as the ownerships remain the same.

Networking
----------

You'll find more client specific details also in the [Firewall section](#Firewall_Considerations) of this document.

Installation procedure
======================

Prior to install, make sure you have:
* [Yum repositories correctly configured](../Common/yum.md) for OSG.
* [CA certificates installed](../Common/ca.md)

GSI OpenSSH Installation
------------------------

Start with installing GSI OpenSSH from the repository

``` rootscreen
yum install gsi-openssh-server gsi-openssh-clients
```

In addition, you'll need to install CA certificates in order for GSIOpenSSH to work. You can follow the instructions below in order to install them:

Configuration and Operations
============================

Useful configuration and log files
----------------------------------

Configuration Files

| Service or Process | Configuration File        | Description                       |
|:-------------------|:--------------------------|:----------------------------------|
| gsisshd            | `/etc/gsissh/sshd_config` | Configuration file                |
| gsisshd            | `/etc/sysconfig/gsisshd`  | Environment variables for gsisshd |
| gsisshd            | `/etc/lcmaps.db`          | LCMAPS configuration              |

Log Files

| Service or Process | Log File            | Description      |
|:-------------------|:--------------------|:-----------------|
| gsisshd            | `/var/log/messages` | All log messages |

Other Files

| Service or Process | File                              | Description      |
|:-------------------|:----------------------------------|:-----------------|
| gsisshd            | `/etc/grid-security/hostcert.pem` | Host certificate |
| gsisshd            | `/etc/grid-security/hostcert.pem` | Key certificate  |
| gsisshd            | `/etc/gsissh/ssh_host_rsa_key`    | RSA Host key     |

Configuration
-------------
Configuration
-------------
In order to get a running instance of the GSI OpenSSH server, you'll
need to change the default configuration. However, before you go any
further, you'll need to decide whether you want GSI OpenSSH to be your 
primary ssh service or not (e.g. whether the GSI OpenSSH service will 
replace your existing SSH service). If you choose not to replace your 
existing service, you'll need to change the port setting in the GSI 
OpenSSH configuration to another port (e.g. 2222) so that you can run 
both SSH services at the same time. Regardless of your choice, you 
should probably have both services use the same host key. In order 
to do this, symlink `/etc/gsissh/ssh_host_dsa_key` and `/etc/gsissh/ssh_host_rsa_key` 
to `/etc/ssh/ssh_host_dsa_key` and `/etc/ssh/ssh_host_rsa_key` respectively. 

!!! note
    Regardless of the authorization method used for the user, any 
    account that will be used with GSI OpenSSH must have a shell 
    assigned to it and not be locked (have ! in the password field of `/etc/shadow`).

Using a gridmap file for authorization
--------------------------------------

In order to use gsissh, you'll need to create mappings in your 
`/etc/grid-security/grid-mapfile` for the DNs that you will 
allow to login. The mappings should be entered one to a line, 
with each line consisting of DN followed by the account the DN 
should map to. Also, you should ensure that the 
`/etc/grid-security/gsi-authz.conf` file is empty or that all 
of the lines in the file are commented out using a `#` at the beginning of the line.

!!! note
    The mappings will not consider VOMS extensions so the first mapping that matches will be used regardless of the VO role or VO present in the users proxy

An example of the `/etc/grid-security/grid-mapfile` follows:

``` file
"/DC=org/DC=doegrids/OU=People/CN=USER NAME 123456" useraccount
```

Using LCMAPS and GUMS for authorization
---------------------------------------

In order to use LCMAPS callouts with GSI OpenSSH, you'll first need to edit `/etc/grid-security/gsi-authz.conf` to indicate that Globus should do a GSI callout for authorization. The file should contain the following:

``` file
globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout
```

so that LCMAPS is used. Next, install the lcmaps rpms:

``` rootscreen
yum install lcmaps lcas-lcmaps-gt4-interface
```

Finally, you'll need to modify `/etc/lcmaps.db` so that the `gumsclient` entry has the correct endpoint for your gums server.

Starting and Enabling Services
------------------------------

To start the services:

1.  To start GSI OpenSSH you can use the service command, e.g.:

     ```
     service gsisshd start
     ```

You should also enable the appropriate services so that they are automatically started when your system is powered on:

-   To enable OpenSSH by default on the node: \<pre class=“rootscreen”\>

<span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig gsisshd on \</pre\>

Stopping and Disabling Services
-------------------------------

To stop the services:

1.  To stop OpenSSH you can use: \<pre class=“rootscreen”\>

    ``` screen
    service gsisshd stop
    ```

In addition, you can disable services by running the following commands. However, you don't need to do this normally.

-   Optionally, to disable OpenSSH: \<pre class=“rootscreen”\>

<span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig gsisshd off \</pre\>

Troubleshooting
===============

You can get information on troubleshooting errors on the [NCSA page](http://grid.ncsa.illinois.edu/ssh/ts_server.html).

To troubleshoot LCMAPS authorization, you can add the following to `/etc/sysconfig/gsisshd` and choose a higher debug level:

``` file
# level 0: no messages, 1: errors, 2: also warnings, 3: also notices,
#  4: also info, 5: maximum debug
LCMAPS_DEBUG_LEVEL=2
```

Output goes to `/var/log/messages` by default.

Test GSI OpenSSH
----------------

After starting the `gsisshd` service you can check if it is running correctly

``` screen
$ grid-proxy-init
Your identity: /DC=ch/DC=cern/OU=Organic Units/OU=Users/CN=User Name
Enter GRID pass phrase for this identity:
Creating proxy ............................................................................................... Done
Your proxy is valid until: Sat Apr 23 08:18:27 2016
$ gsissh localhost -p 2222
Last login: Tue Sep 18 16:08:03 2012 from itb4.uchicago.edu
$
```

How to get Help?
================

To get assistance please use this [Help Procedure](HelpProcedure).

