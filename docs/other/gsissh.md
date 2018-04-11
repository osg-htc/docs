Installing and Maintaining GSI OpenSSH
=======================================

This document contains instructions to install and configure the GSI OpenSSH server available in the OSG repository for
use on your cluster.

Before Starting
---------------


Before starting the installation process, consider the following points (consulting [the Reference section
below](#reference) as needed):

-   **User IDs:** If they do not exist already, the installation will create the Linux users `gsisshd` and `gsisshd`

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](/release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](/common/yum)
- Install [CA certificates](/common/ca)

Installing GSI OpenSSH
----------------------

Install the GSI OpenSSH rpms:

```
root@server # yum install gsi-openssh-server gsi-openssh-clients
```

Configuring GSI OpenSSH
-----------------------

In order to get a running instance of the GSI OpenSSH server, you'll need to change the default configuration. 
However, before you go any further, you'll need to decide whether you want GSI OpenSSH to be your primary ssh service or
not (e.g. whether the GSI OpenSSH service will replace your existing SSH service). 
Regardless of your choice, you should probably have both services use the same host keys.  
This can be done by running the following commands :

```console
root@host # cd /etc/gsissh
root@host # ln -s /etc/ssh/ssh_host_rsa_key ssh_host_rsa_key
root@host # ln -s /etc/ssh/ssh_host_rsa_key.pub ssh_host_rsa_key.pub
root@host # ln -s /etc/ssh/ssh_host_dsa_key ssh_host_dsa_key
root@host # ln -s /etc/ssh/ssh_host_dsa_key.pub ssh_host_dsa_key.pub
root@host # ln -s /etc/ssh/ssh_host_ecdsa_key ssh_host_ecdsa_key
root@host # ln -s /etc/ssh/ssh_host_ecdsa_key.pub ssh_host_ecdsa_key.pub
root@host # ln -s /etc/ssh/ssh_host_ed25519_key ssh_host_ed25519_key
root@host # ln -s /etc/ssh/ssh_host_ed25519_key.pub ssh_host_ed25519_key.pub
```

!!! note
    Your system may not have all of these host keys

If you choose not to replace your existing SSH service, you'll need to change the port setting in the GSI OpenSSH
configuration to another port (e.g. 2222) so that you can run both SSH services at the same time.
This can be done by editing `/etc/gsissh/sshd` and setting `Port 2222`.



!!! note
    Regardless of the authorization method used for the user, any 
    account that will be used with GSI OpenSSH must have a shell 
    assigned to it and not be locked (e.g., have `!` in the password field of `/etc/shadow`).

### Configuring authentication

To configure authentication for GSI OpenSSH, follow the instructions in [the LCMAPS VOMS plugin document](/security/lcmaps-voms-authentication#configuring-the-lcmaps-voms-plugin)
to prepare the LCMAPS VOMS plugin.

Using GSI OpenSSH
------------------

The following table gives the commands needed to start, stop, enable, and disable GSI OpenSSH.

| To...                                   | On EL6, run the command...   | On EL7, run the command...                      |
| :-------------------------------------- | :--------------------------- | :--------------------------------------------   |
| Start  service                          | `service gsisshd start`      | `systemctl start gsisshd`   |
| Stop a  service                         | `service gsisshd stop`       | `systemctl stop gsisshd`    |
| Enable a service to start on boot       | `chkconfig gsisshd on`       | `systemctl enable gsisshd`  |
| Disable a service from starting on boot | `chkconfig gsisshd off`      | `systemctl disable gsisshd` |


Validating GSI OpenSSH
----------------------

After starting the `gsisshd` service you can check if it is running correctly

``` console
user@client $ grid-proxy-init
Your identity: /DC=ch/DC=cern/OU=Organic Units/OU=Users/CN=User Name
Enter GRID pass phrase for this identity:
Creating proxy ............................................................................................... Done
Your proxy is valid until: Sat Apr 23 08:18:27 2016
$ gsissh localhost -p 2222
Last login: Tue Sep 18 16:08:03 2012 from itb4.uchicago.edu
$
```

Troubleshooting
---------------

You can get information on troubleshooting errors on the [NCSA page](http://grid.ncsa.illinois.edu/ssh/ts_server.html).

To troubleshoot LCMAPS authorization, you can add the following to `/etc/sysconfig/gsisshd` and choose a higher debug
level:

``` bash
# level 0: no messages, 1: errors, 2: also warnings, 3: also notices,
#  4: also info, 5: maximum debug
LCMAPS_DEBUG_LEVEL=2
```

Output goes to `/var/log/messages` or `journalctl` by default.


Help
----

To get assistance please use this [Help Procedure](/common/help).


Reference 
----------

### Useful configuration and log files

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
| gsisshd            | `/etc/grid-security/hostkey.pem`  | X.509 host key   |
| gsisshd            | `/etc/gsissh/ssh_host_rsa_key`    | RSA Host key     |


