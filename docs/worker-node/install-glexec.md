Glexec Installation Guide
=========================

!!! warning
    As of the June 2017 release of OSG 3.4.0, this software is officially deprecated.  Support is scheduled to end as of June 2018.

This document is intended for System Administrators that are installing the OSG version of glexec.

Glexec is commonly used for what are referred to as "pilot" or "glidein" jobs.

Traditionally, users submitted their jobs directly to a remote site (or compute element gatekeeper). The user job was authenticated/authorized to run at that site based on the user’s proxy credentials and run under the local unix account assigned.

In a pilot-based infrastructure, users submit their jobs to a centralized site (or queue). The pilot/glidein software at the centralized site then recognizes there is a demand for computing resources. It will then submit what is called a pilot/glidein job to a remote site. This pilot job gets authenticated/authorized to run on a worker node in that site’s cluster. It will then "pull" down user jobs from the centralized queue and execute them. Both the pilot and the user job are run under the pilot job’s proxy certificate credentials and local unix account. This represents a security problem in pilot-based systems as there is no authentication/authorization of the individual user’s proxy credentials and, thus, the user’s jobs do not run using it’s own local unix account.

Glexec is a security tool that can be used to resolve this problem. It is meant to be used by VOs that run these pilot-based jobs. It has a number of authentication plugins and can be used both by European grid and by OSG.

The pilot job will "pull" user jobs down from the central queue and invoke glexec which will then

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
If glexec is to be used at a site, it should be installed and configured on every worker node.

A large number of batch slots using glexec can occasionally put an enormous strain on GUMS servers and cause overloading and client timeouts. In order to survive peak loads, the sysctl parameter `net.core.somaxconn` on a GUMS server machine should be set at least as high as the maximum number of job slots that might attempt to contact the server at about the same time.  For example, Fermilab set the value to 4096 on each of two servers and tested with a continuous load from 5000 job slots.

Requirements
------------

These are the requirements that must be met to install glexec.

!!! note
    Normally you will install the [OSG worker node](../worker-node/wn.md) first. Installing the `osg-wn-client-glexec` package will also install the worker node, but we do not duplicate instructions specific to the worker node here.

- Verify you are using one of the [supported platforms](../release/supported_platforms.md).
- Prior to installing `glexec`, verify the [yum repositories](../common/yum.md) are correctly configured.
- `root` access to the host is required.
- The worker nodes will need the [CA certificates](../common/ca.md) used to sign the proxies.
- `fetch-crl` should be enabled and working.

The glexec installation will create two users unless they are already created.

| User     | Comment                                                                                                                                      |
|:---------|:---------------------------------------------------------------------------------------------------------------------------------------------|
| `glexec` | Reduced privilege separate id used to improve security. If creating the account by hand, set the default gid of the `glexec` user to be a group that is also called `glexec`. |
| `gratia` | Needed for the glexec gratia probe which is also automatically installed.                                                                    |

In addition, OSG glexec requires a range of **group ids** for tracking purposes. You don‘t actually have to create the group entries but it is recommended to do so in order to reserve the gids and so they can be associated with names in the `/usr/bin/id` command. The recommended names are `glexecNN` where NN is a number starting from 00.

- Define at least 4 group ids per batch slot per worker node. A conservative way to handle this is to multiply the number of batch slots on the largest worker node by 6 and then share the group ids between all the worker nodes.
- They must be consecutive and in any range (default range is 65000-65049, configured in the [configuring glexec](#configuring-glexec) section below).
- The same group IDs can be used on every worker node.

Install Instructions
--------------------

!!! note
    The glexec tracking function requires a part of HTCondor. There are multiple ways to install HTCondor, for details see [these instructions](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/CondorInformation). If you want a minimal install, you can run just this command to install the needed piece from the OSG distribution:

        :::console
        [root@client ~] # yum install condor-procd

After meeting all the requirements in the previous section, install glexec with this command:

```console
[root@client ~] # yum install osg-wn-client-glexec
```

Configuring glexec
------------------

The following steps need to be done after the glexec installation is complete.

1. First, review the contents of `/etc/glexec.conf`. All of the defaults should be fine, but if you want to change the behavior, the parameters are described in `man glexec.conf`.
2. Next, review all of the contents of `/etc/lcmaps.db` and in particular update the following pieces.

    - If you have GUMS, change `<GUMS_HOST>` in the following line to the fully qualified domain name of your GUMS server:

            "–endpoint https://<GUMS_HOST>:8443/gums/services/GUMSXACMLAuthorizationServicePort"

    - If you want to use a range of tracking group ids other than the default as described in the [Requirements](#6_Requirements) section above, uncomment and change the `-min-gid` and `-max-gid` lines to your chosen values:

            "-min-gid 65000" "-max-gid 65049"

    - Uncomment the following two lines:

            glexectracking = "lcmaps_glexec_tracking.mod"
                             "-exec /usr/sbin/glexec_monitor"

    - If you have GUMS, uncomment the following policy toward the end of the file:

            verifyproxy -> gumsclient
            gumsclient -> glexectracking

        or if you have do not have GUMS and want to use a gridmapfile, uncomment the following policy:

            verifyproxy -> gridmapfile
            gridmapfile -> glexectracking


Testing the Installation of glexec
----------------------------------

Now, _as a non-privileged user (not root)_, do the following (where <YOURVO> is your VO, and <UID> is your uid as reported by `/usr/bin/id`):

```console
[user@client ~] $ voms-proxy-init -voms <YOURVO>:/<YOURVO>
[user@client ~] $ export GLEXEC_CLIENT_CERT=/tmp/x509up_u<UID>
[user@client ~] $ export X509_USER_PROXY=/tmp/x509up_u<UID>
[user@client ~] $ /usr/sbin/glexec /usr/bin/id
[user@client ~] $ uid=13160(fnalgrid) gid=9767(fnalgrid) groups=65000(glexec00)
```

If `glexec` is successful, it will print out the uid and gid that your proxy would normally be mapped to by your GUMS server, plus a supplementary tracking group. (The actual names and numbers will be different from what you see above.)

If you have problems, please read about [troubleshooting glexec](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/TroubleshootingGlexecLcmaps).

Glexec log files
----------------

Glexec sends all its log information by default to syslog. By default they go to `/var/log/messages`, but this may differ if you have customized your syslog setup. Here are some sample messages:

```
Apr 25 16:36:16 fermicloud053 glexec[2867]: lcmaps: lcmaps.mod-PluginInit(): plugin glexectracking not found (arguments: )
Apr 25 16:36:16 fermicloud053 glexec[2867]: lcmaps: lcmaps.mod-lcmaps_startPluginManager(): error initializing plugin: glexectracking
Apr 25 16:36:16 fermicloud053 glexec[2867]: lcmaps: lcmaps_init() error: could not start plugin manager
Apr 25 16:36:16 fermicloud053 glexec[2867]: Initialisation of LCMAPS failed.
```

These particular messages are pretty common, caused by forgetting to uncomment the beginning of the `glexectracking` rule in `/etc/lcmaps.db`.

It is possible to redirect glexec log messages to a different file with standard syslog. To do that, choose one of the `LOG_LOCAL[0-7]` log facilities that are unused, for example `LOG_LOCAL1`. Then set the following in `/etc/glexec.conf`:

```
syslog_facility = LOG_LOCAL1
```

and add a corresponding parameter to the `lcmaps_glexec_tracking.mod` entry in `/etc/lcmaps.db`:

```
  "-log-facility LOG_LOCAL1"
```

Then in `/etc/rsyslog.conf`, add a line like this:

```
local1.* /var/log/glexec.log
```

and also exclude those messages from `/var/log/messages` by adding `local1.none` after other wildcards on the existing `/var/log/messages` line, for example:

```
*.info;local1.none;mail.none;authpriv.none;cron.none /var/log/messages
```

Be sure to notify the system logger to re-read the configuration file with `service rsyslog restart`.

`rsyslog`, by default, limits the rate at which messages may be logged, and if maximum debugging is enabled in glexec this limit is reached. To avoid that, you can add the following to `/etc/rsyslog.conf` after the line "$ModLoad imuxsock.so":

```
$SystemLogRateLimitInterval 0
$SystemLogRateLimitBurst 0
```

and do `service rsyslog restart`.

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

To get assistance please use the [Help Procedure](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/HelpProcedure).

