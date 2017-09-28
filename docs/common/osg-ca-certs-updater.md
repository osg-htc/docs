<span class="twiki-macro DOC_STATUS_TABLE"></span>

OSG CA Certificates Updater
===========================

<span class="twiki-macro TOC"></span>

About this Document This document explains the installation and use of `osg-ca-certs-updater`, a package in the OSG Software 3.x distribution that provides automatic updates of CA certificates.
=================================================================================================================================================================================================

Requirements
============

-   OS must be Red Hat Enterprise Linux 5 or 6 or variants.
-   The OSG repositories must be installed and enabled. See the [Yum Repositories](YumRepositories) page for instructions.
-   One grid-certificates package from the OSG repositories must be installed as described [here](InstallCertAuth#First_Set_up_the_yum_repositorie). Currently, these are: `igtf-ca-certs`, `osg-ca-certs`.

Install instructions
====================

Run the following command to install the latest version of the updater.

``` rootscreen
%UCL_PROMPT_ROOT% yum install osg-ca-certs-updater
```

Services
========

Starting and Enabling Services
------------------------------

Run the following to enable the updater. This will persist until the machine is rebooted.

``` rootscreen
%UCL_PROMPT_ROOT% service osg-ca-certs-updater-cron start
```

Run the following to enable the updater when the machine is rebooted.

``` rootscreen
%UCL_PROMPT_ROOT% chkconfig osg-ca-certs-updater-cron on
```

Run both commands if you wish for the service to activate immediately and remain active throughout reboots.

Stopping and Disabling Services
-------------------------------

Enter the following to disable the updater. This will persist until the machine is rebooted.

``` rootscreen
%UCL_PROMPT_ROOT% service osg-ca-certs-updater-cron stop
```

Enter the following to disable the updater when the machine is rebooted.

``` rootscreen
%UCL_PROMPT_ROOT% chkconfig osg-ca-certs-updater-cron off
```

Run both commands if you wish for the service to deactivate immediately and not get reactivated during reboots.

Configuration
=============

While there is no configuration file, the behavior of the updater can be adjusted by command-line arguments that are specified in the `cron` entry of the service. This entry is located in the file `/etc/cron.d/osg-ca-certs-updater`. Please see the Unix manual page for `crontab` in section 5 for an explanation of the format. The manual page can be accessed by the command `man 5 crontab`. The valid command-line arguments can be listed by running `osg-ca-certs-updater --help`. Reasonable defaults have been provided, namely:

-   Attempt an update no more often than every 23 hours. Due to the random wait (see below), having a 24-hour minimum time between updates would cause the update time to slowly slide back every day.
-   Run the script every 6 hours. We run the script more often than we update so that downtime at the wrong moment does not cause the update to be delayed for a full day.
-   Delay for a random amount of time up to 30 minutes before updating, to reduce load spikes on OSG repositories.
-   Do not warn the administrator about update failures that have happened less than 72 hours since the last successful update.
-   Log errors only.

Troubleshooting
===============

Useful configuration and log files
----------------------------------

### Configuration file

| Package              | File Description                                      | Location                                                       | Comment                                                                                       |
|:---------------------|:------------------------------------------------------|:---------------------------------------------------------------|:----------------------------------------------------------------------------------------------|
| osg-ca-certs-updater | Cron entry for periodically launching the updater     | `/etc/cron.d/osg-ca-certs-updater`                             | Command-line arguments to the updater can be specified here                                   |
| osg-release          | Repo definition files for production OSG repositories | `/etc/yum.repos.d/osg.repo` or `/etc/yum.repos.d/osg-el6.repo` | Make sure these repositories are enabled and reachable from the host you are trying to update |

### Log files

Logging is performed to the console by default. Please see the manual for your `cron` daemon to find out how it handles console output.

A logfile can be specified via the `-l` / `--logfile` command-line option.

If logging to syslog via the `-s` / `--log-to-syslog` option, the updater will write to the `user` section of the syslog. The file `/etc/syslog.conf` determines where syslog messages are saved.

How to get Help?
================

To get assistance please use [Help Procedure](HelpProcedure).

References
==========

Some guides on X.509 certificates:

-   Useful commands: <http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html>
-   Install GSI authentication on a server: <http://security.ncsa.illinois.edu/research/wssec/gsihttps/>
-   Certificates how-to: <http://www.nordugrid.org/documents/certificate_howto.html>

Some examples about verifying the certificates:

-   <http://gagravarr.org/writing/openssl-certs/others.shtml>
-   <http://www.cyberciti.biz/faq/test-ssl-certificates-diagnosis-ssl-certificate/>
-   <http://www.cyberciti.biz/tips/debugging-ssl-communications-from-unix-shell-prompt.html>

Related software:

-   [OSG CA certificates](InstallCertAuth)
-   Description, manual and examples of OsgCaManage
-   OsgCaCertsUpdater

Comments
========

<span class="twiki-macro COMMENT" type="tableappend"></span>
