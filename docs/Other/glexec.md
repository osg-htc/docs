Glexec Installation Guide
=========================

This document is intended for System Administrators that are installing the OSG version of glexec.

Glexec is commonly used for what are referred to as “pilot” or “glidein” jobs.

Traditionally, users submitted their jobs directly to a remote site (or compute element gatekeeper). The user job was authenticated/authorized to run at that site based on the user’s proxy credentials and run under the local unix account assigned.

In a pilot-based infrastructure, users submit their jobs to a centralized site (or queue). The pilot/glidein software at the centralized site then recognizes there is a demand for computing resources. It will then submit what is called a pilot/glidein job to a remote site. This pilot job gets authenticated/authorized to run on a worker node in that site’s cluster. It will then “pull” down user jobs from the centralized queue and execute them. Both the pilot and the user job are run under the pilot job’s proxy certificate credentials and local unix account. This represents a security problem in pilot-based systems as there is no authentication/authorization of the individual user’s proxy credentials and, thus, the user’s jobs do not run using it’s own local unix account.

Glexec is a security tool that can be used to resolve this problem. It is meant to be used by VOs that run these pilot-based jobs. It has a number of authentication plugins and can be used both by European grid and by OSG.

The pilot job will “pull” user jobs down from the central queue and invoke glexec which will then
1. authenticate the user job’s proxy,
2. perform an authorization callout (to GUMS in the case of OSG, or possibly a gridmapfile) similar to that done by the gatekeeper,
3. and then run the user job under the local account assigned by the authorization service for that user.

In effect, glexec functions much the same as a compute element gatekeeper, except these functions are now performed on the individual worker node. The pilot jobs authentication/authorization is done by the gatekeeper and the individual user jobs are now done by glexec on the individual worker node.

Many worker node clusters use shared file systems like NFS for much of their software and user home accounts. Since glexec is an suid program, it must be installed on every single worker node individually. Most shared file systems do not handle this correctly so it cannot and must not be NFS-exported.

For more information regarding pilot-based systems and glexec:
1. [glideinWMS - The glidein based WMS](http://www.uscms.org/SoftwareComputing/Grid/WMS/glideinWMS/doc.html)
2. [Addressing the pilot security problem with gLExec (pdf)](http://iopscience.iop.org/1742-6596/119/5/052029/pdf/jpconf8_119_052029.pdf)

Engineering Considerations
--------------------------

This section describes any prerequisite software/considerations that must be taken into account before the glexec software installation is performed. It should be reviewed completely before starting the installation process.

A large number of batch slots using glexec can occasionally put an enormous strain on GUMS servers and cause overloading and client timeouts. In order to survive peak loads, the sysctl parameter ‘net.core.somaxconn’ on a GUMS server machine should be set at least as high as the maximum number of job slots that might attempt to contact the server at about the same time. (For example, Fermilab set the value to 4096 on each of two servers and tested with a continuous load from 5000 job slots). At the same time, the Apache parameter ‘ListenBacklog’ must be changed to the same value. Also note that Fermilab determined that for best performance, the Apache parameter ‘MaxClients’ on GUMS servers (at least on their dual-core Virtual Machines) should be set to a value of 32. For details on these and other parameters on the GUMS server see GumsScalability.

Requirements
------------

These are the requirements that must be met to install glexec.

!!! note
    Normally you will install the [OSG worker node](InstallWNClient) first. Technically, installing the `osg-wn-client-glexec` package will also install the worker node, but we do not duplicate instructions specific to the worker node here, so refer to the [OSG worker node](InstallWNClient) for details about the worker node installation.

### Host and OS

-   OS is Red Hat Enterprise Linux 5, 6, 7, and variants.
-   Root access

### Users

The glexec installation will create two users unless they are already created.

| User     | Comment                                                                                                                                      |
|:---------|:---------------------------------------------------------------------------------------------------------------------------------------------|
| `glexec` | Reduced privilege separate id used to improve security. Set the default gid of the “glexec” user to be a group that is also called “glexec”. |
| `gratia` | Needed for the glexec gratia probe which is also automatically installed.                                                                    |

In addition, OSG glexec requires a range of **group ids** for tracking purposes. You don‘t actually have to create the group entries but it is recommended to do so in order to reserve the gids and so they can be associated with names in the `/usr/bin/id` command. The recommended names are ’glexecNN’ where NN is a number starting from 00.

-   Define at least 4 group ids per batch slot per worker node. A conservative way to handle this is to multiply the number of batch slots on the largest worker node by 6 and then share the group ids between all the worker nodes.
-   They must be consecutive and in any range (default range is 65000-65049, configured in the [Configuring glexec](#8_Configuring_glexec) section below).
-   The same group ids can be used on every worker node.

<!---  I see no apparent value in doing this section below - ancient, unsupported versions of GUMS.
### Certificates

| Certificate                  | User that owns certificate | Path to certificate                                                       |
|:-----------------------------|:---------------------------|:--------------------------------------------------------------------------|
| Worker node host certificate | `root`                     | `/etc/grid-security/hostcert.pem` \<br\> `/etc/grid-security/hostkey.pem` |

!!! note
    GUMS versions 1.3.18 or later can work without a host cert or proxy. To do this, [follow these directions](GlexecPilotCert). The directions below only apply to older GUMS installs.

A host certificate on every worker node is required for glexec to use GUMS. The host certificates do not need to be unique on every node; you can share the same one for every node in the cluster. If you don’t have any host certificate for the worker nodes, or you want to avoid the risk of a shared certificate getting stolen, you can use limited-duration proxies instead. There is a host proxy distribution script package called [host\_dist\_latest.tgz](https://twiki.grid.iu.edu/twiki/pub/Documentation/Release3/InstallGlexec/host_dist_latest.tgz) which can be installed on your gatekeeper and which will automatically create a proxy from your gatekeeper’s host certificate and push it out to `/etc/grid-security/hostproxy.pem` and `/etc/grid-security/hostproxykey.pem` on your worker nodes. The script requires a means of passwordless ssh/scp access from the head node to the worker nodes. The location of the certificate and key can be overridden by setting `-cert /etc/grid-security/hostproxy.pem` and `-key /etc/grid-security/hostproxykey.pem` parameters in the gumsclient section of `/etc/lcmaps.db`.

Finally, GUMS versions \>= 1.3.18 can be configured to not require a certificate or proxy from glexec at all, by changing the “userGroups” tag from access=“read self” to access=“read all”, and by setting the hostToGroup mapping to allow a DN that maps all worker nodes’ hostnames.
--->

Install Instructions
--------------------

Prior to installing `glexec`, verify the [yum repositories](../Common/yum.md) are correctly configured.

Some of the worker node client software verifies proxies or certificates. In order to do this, they will need the [CA certificates](../Common/ca.md) used to sign the proxies.

Install glexec
--------------

!!! note
    The glexec tracking function requires a part of HTCondor. There are multiple ways to install HTCondor, for details see [these instructions](CondorInformation). If you want a minimal install, you can run just this command to install the needed piece from the OSG distribution:

    ```
    yum install condor-procd
    ```

After meeting all the requirements in the previous section, install glexec with this command:

```
yum install osg-wn-client-glexec
```

Configuring glexec
------------------

The following steps need to be done after the glexec installation is complete.

1. First, review the contents of `/etc/glexec.conf`. All of the defaults should be fine, but if you want to change the behavior, the parameters are described in `man glexec.conf`.
2. Next, review all of the contents of `/etc/lcmaps.db` and in particular update the following pieces.

   - If you have GUMS, change the yourgums.yourdomain in the following line to the fully qualified domain name of your GUMS server:

     ```
       "–endpoint <https://yourgums.yourdomain:8443/gums/services/GUMSXACMLAuthorizationServicePort>"
     ```

   - If you want to use a range of tracking group ids other than the default as described in the [Requirements](#6_Requirements) section above, uncomment and change the `-min-gid` and `-max-gid` lines to your chosen values:

     ```
       "-min-gid 65000” “-max-gid 65049"
     ```

   - Uncomment the following two lines:

     ```
      glexectracking = "lcmaps_glexec_tracking.mod"
                       "-exec /usr/sbin/glexec_monitor"
     ```

   - If you have GUMS, uncomment the following policy toward the end of the file:

     ```
     verifyproxy -> gumsclient
     gumsclient -> glexectracking
     ```

     or if you have do not have GUMS and want to use a gridmapfile, uncomment the following policy:

     ```
     verifyproxy -> gridmapfile
     gridmapfile -> glexectracking
     ```

Testing the Installation of glexec
----------------------------------

Now, ***as a non-privileged user (not root)*** , do the following (where __yourvo__ is your VO, and __NNN__ is your uid as reported by `/usr/bin/id`):

```
voms-proxy-init -voms yourvo:/yourvo
export GLEXEC_CLIENT_CERT=/tmp/x509up_uNNN
/usr/sbin/glexec /usr/bin/id
uid=13160(fnalgrid) gid=9767(fnalgrid) groups=65000(glexec00)
```

If your `lcmaps.db` is set up to not use a host certificate as described in GlexecPilotCert, you should also set

``
export X509_USER_PROXY=/tmp/x509up_uNNN
```

(substitute `NNN` for your UID) before running glexec.

If `glexec` is successful, it will print out the uid and gid that your proxy would normally be mapped to by your GUMS server, plus a supplementary tracking group. (The actual names and numbers will be different from what you see above.)

If you have problems, please read about [troubleshooting glexec](TroubleshootingGlexecLcmaps).

Glexec log files
----------------

`Glexec` sends all its log information by default to syslog. Where it goes from there depends on your syslog configuration, but by default they go to `/var/log/messages`. Here are some sample messages:

```
Apr 25 16:36:16 fermicloud053 glexec[2867]: lcmaps: lcmaps.mod-PluginInit(): plugin glexectracking not found (arguments: )
Apr 25 16:36:16 fermicloud053 glexec[2867]: lcmaps: lcmaps.mod-lcmaps_startPluginManager(): error initializing plugin: glexectracking
Apr 25 16:36:16 fermicloud053 glexec[2867]: lcmaps: lcmaps_init() error: could not start plugin manager
Apr 25 16:36:16 fermicloud053 glexec[2867]: Initialisation of LCMAPS failed.
```

These particular messages are pretty common, caused by forgetting to uncomment the beginning of the glexectracking rule in `/etc/lcmaps.db`.

It is possible to redirect glexec log messages to a different file with standard syslog. To do that, choose one of the `LOG_LOCAL[0-7]` log facilities that are unused, for example `LOG_LOCAL1`. Then set the following in `/etc/glexec.conf`:

```
syslog_facility = LOG_LOCAL1
```

and add a corresponding parameter to the `lcmaps_glexec_tracking.mod` entry in `/etc/lcmaps.db`:

```
  "-log-facility LOG_LOCAL1"
```

Then in `/etc/syslog.conf` on el5 or `/etc/rsyslog.conf` on el6 add a line like this

```
local1.* /var/log/glexec.log
```

and also exclude those messages from `/var/log/messages` by adding `local1.none` after other wildcards on the existing `/var/log/messages` line, for example:

```
*.info;local1.none;mail.none;authpriv.none;cron.none /var/log/messages
```

Be sure to notify the system logger to re-read the configuration file with `service syslog reload` on el5, or with `service rsyslog restart` on el6.

`rsyslog`, by default, limits the rate at which messages may be logged, and if maximum debugging is enabled in glexec this limit is reached. To avoid that, you can add the following to `/etc/rsyslog.conf` after the line "$ModLoad imuxsock.so":

```
$SystemLogRateLimitInterval 0
$SystemLogRateLimitBurst 0
```

and of course do `service rsyslog restart`.

Alternatively, `syslog-ng` (available in the EPEL repository) can do the same job by matching all the messages that have the string "glexec" in the name.
These rules in `/etc/syslog-ng/syslog-ng.conf` will separate the glexec messages into `/var/log/glexec.log`:

```
destination d_glexec { file("/var/log/glexec.log"); };
filter f_glexec { program("^glexec"); };
filter f_notglexec { not program("^glexec"); };
log { source(s_sys); filter(f_glexec); destination(d_glexec); };
```

Then later, in the log rule writing sending to `d_mesg`, add a `filter(f_notglexec);` before the destination rule to keep glexec messages out of `/var/log/messages`:

```
log { source(s_sys); filter(f_filter1); filter(f_notglexec); destination(d_mesg); };
```

How to get Help?
----------------

To get assistance please use [Help Procedure](HelpProcedure).


