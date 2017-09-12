&lt;div style="border: 1px solid black; margin: 1em 0; padding: 1em; background-color: \#FFDDDD;"&gt; <span class="twiki-macro NOTE"></span> Edg-mkgridmap will no longer be supported in OSG 3.4. The [LCMAPS VOMS Plugin](Documentation.Release3/InstallLcmapsVoms) is the preferred method for site authentication in the OSG and is available in both OSG 3.3 and OSG 3.4. &lt;/div&gt;

<span class="twiki-macro LINKCSS"></span>

<span class="twiki-macro SPACEOUT">Edg-mkgridmap</span>
=======================================================

<span class="twiki-macro DOC_STATUS_TABLE"></span> <span class="twiki-macro TOC"></span>

1.0 About this Document
=======================

This document describes how you can use `edg-mkgridmap` to authorize users accessing the resources that you provide.

2.0 Requirements
================

\* The purpose of using `edg-mkgridmap` is to create a grid-mapfile that will contain users from all VOs that are supported on your site. For this to happen, make sure that **before** you run `edg-mkgridmap`, you have created user accounts for all such VOs. \* `edg-mkgridmap` should be installed on your node. It gets installed as a dependency during Compute or Storage Element installation.

2.1 Host and OS
---------------

-   OS is <span class="twiki-macro SUPPORTED_OS"></span>.
-   [EPEL](http://fedoraproject.org/wiki/EPEL) repos enabled.
-   Root access

2.2 Certificates
----------------

<span class="twiki-macro STARTSECTION">Certificates</span>

| Certificate      | User that owns certificate | Path to certificate                                                           |
|:-----------------|:---------------------------|:------------------------------------------------------------------------------|
| Host certificate | `root`                     | `/etc/grid-security/hostcert.pem` &lt;br&gt; `/etc/grid-security/hostkey.pem` |

<span class="twiki-macro ENDSECTION">Certificates</span>

3.0 Configuration
=================

If you claim to support a VO, make sure

-   VO is enabled in /etc/edg-mkgridmap.conf
-   The local user account to which VO members are mapped to, exists on the gatekeeper
-   After you run edg-mkgridmap, the VO should exist in /var/lib/osg/supported-vo-list

Let's begin with configuration:

**Step 1** Make sure for all Virtual Organizations (VOs) that you want to support, you have created a local user account. After that, you need to tell `edg-mkgridmap`, which Virtual Organizations (VOs) you want to support. For this, edit the `/etc/edg-mkgridmap.conf` such that all VOs that you want to support are uncommented and all VOs that you do not want to support are commented out. Here is an example in which `cdf` VO is disabled and `fermilab` VO is enabled

``` file
[root@fermicloud046 ~]# cat /etc/edg-mkgridmap.conf 
#### GROUP: group URI [lcluser]
#
#-------------------
# USER-VO-MAP cdf CDF -- 1 -- Dennis Box (dbox@fnal.gov)     
#group vomss://voms.fnal.gov:8443/voms/cdf cdf
#group vomss://voms.cnaf.infn.it:8443/voms/cdf cdf
#-------------------
# USER-VO-MAP fermilab FERMILAB -- 2 -- Fermilab Service Desk (servicedesk@fnal.gov)  
group vomss://voms.fnal.gov:8443/voms/fermilab fermilab
[root@fermicloud046 ~]#
```

**Step 2** For any additional DNs that you want to support (i.e. you want them to be present in the final `grid-mapfile` that gets created), you need to add their `DN username` mapping to a local grid-mapfile. Here is an example of how each line of this file should look like.

``` file
"/DC=gov/DC=fnal/O=Fermilab/OU=People/CN=Neha Sharma/CN=UID:neha" neha
```

<span class="twiki-macro NOTE"></span> The local gridmap file is used also to add certificates of service accounts like the one used for RSV testing.

**Step 3** You need to tell `edg-mkgridmap` about this local grid-mapfile. For this, you need to use the [gmf\_local](http://vdt.cs.wisc.edu/extras/edg-mkgridmap.conf.html#reference:_gmf_local) directive. And if the entry in the local gridmap introduces a new user you sould add it to a VO dding a line **`username voname`** in the local vo-map file (**`/etc/osg/local-user-vo-map`**). And if you use a new VO you must add a VO naming line in `edg-mkgridmap.conf` as well (one starting with **`# USER-VO-MAP ...`** ) Here is an example of how your `edg-mkgridmap.conf` would now look like

``` file
[root@fermicloud046 ~]# cat /etc/edg-mkgridmap.conf 
#### GROUP: group URI [lcluser]
#
#-------------------
# USER-VO-MAP cdf CDF -- 1 -- Dennis Box (dbox@fnal.gov)     
#group vomss://voms.fnal.gov:8443/voms/cdf cdf
#group vomss://voms.cnaf.infn.it:8443/voms/cdf cdf
#-------------------
# USER-VO-MAP fermilab FERMILAB -- 2 -- Fermilab Service Desk (servicedesk@fnal.gov)  
group vomss://voms.fnal.gov:8443/voms/fermilab fermilab
# USER-VO-MAP rsv RSV -- 101 -- Your Name (your@email)
gmf_local /etc/grid-security/local-grid-mapfile
[root@fermicloud046 ~]#
```

**Step 4** If you have additional `useraccount vo` mappings that you want to be included in final `/var/lib/osg/user-vo-map` file, add those mappings to `/etc/osg/local-user-vo-map` file.

`Note:` More information on `edg-mkgridmap.conf` file can be found [here](http://vdt.cs.wisc.edu/extras/edg-mkgridmap.conf.html)

4.0 Enable/Disable
==================

4.1 Enable
----------

You need to configure **`edg-mkgridmap`** to run automatically via a cron job. To do this, you need to run the following command.

``` rootscreen
[root@fermicloud046 ~]# /sbin/service edg-mkgridmap start
Enabling periodic edg-mkgridmap:                           [  OK  ]
[root@fermicloud046 ~]#
```

The entry in cron file (`/etc/cron.d/edg-mkgridmap-cron`) looks like

``` file
[root@fermicloud046 ~]# cat /etc/cron.d/edg-mkgridmap-cron 
# Cron job running by default every 6 hours.
# The lock file can be enabled or disabled via a
# service edg-mkgridmap start
# chkconfig edg-mkgridmap on

# Note the lock file not existing is success hence the the slightly odd logic
# below.
# run every 6 hours but sleep for random time every 5 hours

0 */6 * * * root perl -e 'sleep rand 18000'; [ ! -f /var/lock/subsys/edg-mkgridmap ] || /usr/sbin/edg-mkgridmap
[root@fermicloud046 ~]#
```

`Note:` As you can see above, this cron will run every 6 hours. If you do not want to wait that long, you can execute the command `/usr/sbin/edg-mkgridmap` directly on command line

4.2 Disable
-----------

``` rootscreen
[root@fermicloud046 ~]# /sbin/service edg-mkgridmap stop
Disabling periodic edg-mkgridmap:                          [  OK  ]
[root@fermicloud046 ~]#
```

5.0 Chkconfig on/off
====================

5.1 On
------

``` rootscreen
[root@fermicloud046 ~]# chkconfig edg-mkgridmap on
[root@fermicloud046 ~]# chkconfig --list edg-mkgridmap
edg-mkgridmap   0:off   1:off   2:on    3:on    4:on    5:on    6:off
[root@fermicloud046 ~]#
```

5.2 Off
-------

``` rootscreen
[root@fermicloud046 ~]# chkconfig edg-mkgridmap off
[root@fermicloud046 ~]# chkconfig --list edg-mkgridmap
edg-mkgridmap   0:off   1:off   2:off   3:off   4:off   5:off   6:off
[root@fermicloud046 ~]#
```

6.0 What happens behind the scenes?
===================================

Upon execution, `edg-mkgridmap` reads the configuration file at location `/etc/edg-mkgridmap.conf` and for all VOs for which a local user account exists, it contacts their VOMS server to retrieve list of all users that belong to that VO. Its output is the following files

-   `/var/lib/osg/supported-vo-list`. This file contains names of all VOs you want to support minus all VOs for whom you do not have a user account. In other words, this is list of VOs that will **actually** be supported.
-   `/var/lib/osg/user-vo-map` . This file contains mapping of form 'useraccount VO' for all VOs in `/var/lib/osg/supported-vo-list` and also mappings from `/etc/osg/local-user-vo-map` file.
-   `/var/lib/osg/undefined-accounts`. This file contains names of all VOs for which it **could not** find user account.
-   `/etc/grid-security/grid-mapfile`. This file contains 'DN username' mappings that are present in local grid-mapfile (if you have one) and mappings for **all** users from **all** VOs that are present in `/var/lib/osg/supported-vo-list`.

7.0 What happens when you perform an upgrade?
=============================================

There are two scenerios

7.1 You do not have a custom edg-mkgridmap configuration
--------------------------------------------------------

This means you are using the same `edg-mkgridmap.conf` file that came with prior installation of vo-client-edgmkgridmap package. In this case, during upgrade, the newer `edg-mkgridmap.conf` file will replace the old one. It will probably have new VOs in it and if you want to support them, you need to satisfy conditions as mentioned in Configuration section above.

7.2 You have a custom edg-mkgridmap configuration
-------------------------------------------------

This means you have modified the `edg-mkgridmap.conf` file. In this case, during upgrade, the existing file `/etc/edg-mkgridmap.conf` will remain untouched and new configuration file will be saved as `/etc/edg-mkgridmap.conf.rpmnew`. You can compare the two files and make changes as required.

8.0 Files
=========

| **File Location** | **Description** | | /etc/edg-mkgridmap.conf | Main Edg-mkgridmap configuration file | | /etc/cron.d/edg-mkgridmap-cron | Edg-mkgridmap cron file | | /etc/rc.d/init.d/edg-mkgridmap | Edg-mkgridmap init file | | /var/log/edg-mkgridmap.log | Edg-mkgridmap log file |

9.0 Troubleshooting
===================

Troubleshooting information on edg-mkgridmap can be found [here](https://www.opensciencegrid.org/bin/view/ReleaseDocumentation/EdgMkgridmapTroubleshootingGuide)

---%SHIFT%+ Common Problems

-   [grid-mapfile not created](#NoMapfile)
-   [Local users not included in the grid mapfile](#UserNotincluded)
-   [Error code 64](#CodeSixtyfour)

<span class="twiki-macro STARTSECTION">Troubleshooting</span> ---%SHIFT%++ Troubleshooting Procedure

In case of problems first of all check the service log file `/var/log/edg-mkgridmap.log`. This file lists:

-   any errors accessing individual voms servers or any general errors
-   any mappings eliminated from the `/var/lib/osg/user-vo-map` and `/var/lib/osg/supported-vo-list` files where the Unix account a user would be mapped to does not exist. There is an `/var/lib/osg/undefined-accounts` file created that lists these accounts.
-   changes from the last time the script was run

There is also a \_last*checked* file in `/etc/grid-security` that tells you the last time the cron process was run successfully (the `grid-mapfile` only gets updated if there is a difference from the previous run).

``` rootscreen
%UCL_PROMPT_ROOT% ls -al /etc/grid-security
-rw-r--r--  1 root     root     1162888 Jul 12 02:14 grid-mapfile
-rw-r--r--  1 root     root           0 Jul 12 08:14 grid-mapfile.last_checked
```

\#NoMapfile ---%SHIFT%++ Grid-Mapfile was not created

First make sure that the *edg-mkgridmap* service is enabled:

``` rootscreen
%UCL_PROMPT_ROOT% /sbin/service edg-mkgridmap status
Periodic edg-mkgridmap is enabled.
```

Next, make sure an entry for *edg-mkgridmap* is present:

``` rootscreen
%UCL_PROMPT_ROOT% 
[root@fermicloud044 ~]# cat /etc/cron.d/edg-mkgridmap-cron 
# Cron job running by default every 6 hours.
# The lock file can be enabled or disabled via a
# service edg-mkgridmap start
# chkconfig edg-mkgridmap on

# Note the lock file not existing is success hence the the slightly odd logic
# below.
# run every 6 hours but sleep for random time every 5 hours

0 */6 * * * root perl -e 'sleep rand 18000'; [ ! -f /var/lock/subsys/edg-mkgridmap ] || /usr/sbin/edg-mkgridmap
[root@fermicloud044 ~]#
```

<span class="twiki-macro NOTE"></span> If no entry for *edg-mkgridmap* is present, activate the service.

Last, run the `edg-mkgridmap` script on the command line and check that `/etc/grid-security/grid-mapfile` gets created:

``` rootscreen
%UCL_PROMPT_ROOT% %UCL_CWD%edg-mkgridmap
```

<span class="twiki-macro NOTE"></span> The script will not output to the command line. Check the log file at `%UCL_CWD%/var/log/edg-mkgridmap.log` instead.

\#UserNotincluded ---%SHIFT%++ Grid-Mapfile does not list Local Users

\#CodeSixtyfour ---%SHIFT%++ Error Code 64

This type of error occurs when the script established contact with the VOMS server but the requested group or subgroup does not exist there. It is really a *'not found'* type error. It is usually caused by a bad entry in the `/etc/edg-mkgridmap.conf` file.

In the example below the configuration file contains a request for the VOMS server to send a list of all members of the uscms VO belonging to a non-existent `/uscms/production` group.

Configuration file `/etc/edg-mkgridmap.conf` entry:

``` file
 group vomss://voms.fnal.gov:8443/voms/uscms/production uscms01
```

Command run on CE node:

``` rootscreen
%UCL_PROMPT_ROOT% edg-mkgridmap
   <i>... output....
  voms search(https://voms.fnal.gov:8443/voms/uscms/production/services/VOMSAdmin?method=listMembers): /voms/uscms/production/services/VOMSAdmin

   Exit with error(s) (code=64)</i>
```

On the VOMS host you are attempting to access, the following error can be seen in the `/var/log/tomcat5/voms-admin-VO_NAME.log` or `/var/log/tomcat6/voms-admin-VO_NAME.log`

``` file
2005-05-26 15:51:04,003 INFO  [Ajp13Processor[8892][1]]  Connection from "131.225.82.73" by 
        /DC=org/DC=doegrids/OU=Services/CN=ce_host (serial 4511) -  service.InitSecurityContext
2005-05-26 15:51:04,004 INFO  [Ajp13Processor[8892][1]]  listMembers ("/uscms/production") -  admin.VOMSAdminSoapBindingImpl
2005-05-26 15:51:04,013 ERROR [Ajp13Processor[8892][1]]  org.edg.security.voms.service.NotInDatabase: 
       Not in database: group "/uscms/production" -  connection.Database
 
```

<span class="twiki-macro ENDSECTION">Troubleshooting</span>

---%SHIFT%+ Useful Options for edg-mkgridmap troubleshooting

-   \[--help\]
-   \[--version\]
-   \[--conf=config\_file\] Default configuration file is at /etc/edg-mkgridmap.conf
-   \[--output\[=output\_file\]\]
-   \[--verbose\]

<span class="twiki-macro STOPINCLUDE"></span>

10.0 How to get Help?
=====================

If you cannot resolve the problem or have general questions, there are several ways to receive help:

-   For bug support and issues, submit a ticket to the [Grid Operations Center](https://ticket.grid.iu.edu/goc).
-   For community support and best-effort software team support contact <osg-software@opensciencegrid.org>.

For a full set of help options, see [Help Procedure](HelpProcedure).
