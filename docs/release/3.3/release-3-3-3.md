OSG Software Release 3.3.3
==========================

**Release Date**: 2015-11-03

Summary of changes
------------------

This release contains:

-   CA certificates based on [IGTF 1.69](https://dist.eugridpma.info/distribution/igtf/current/CHANGES)

These [JIRA tickets](https://jira.opensciencegrid.org/issues/?jql=project%20%3D%20SOFTWARE%20AND%20fixVersion%20%3D%203.3.3%20ORDER%20BY%20priority%20DESC) were addressed in this release.

Detailed changes are below. All of the documentation can be found in the [Release3](Documentation.Release3) area of the TWiki.

CA Certificate Update Information
---------------------------------

### What Is Changing

A new IGTF Certificate Bundle (v1.69) has just been released. This release has a very important change and we would like our sites to install it as soon as they can.

### Who Is Impacted By This Change:

All OSG sites and users need to install the new CA bundle. Especially US-Atlas and US-CMS sites should install the bundle as soon as possible since their VOs will go under the transition in November/December timeframe.

### Why This Change Is Happening:

The OSG CA is changing its backend service support from Digicert to CILogon HSM. As a result, a new OSG CA is created and just recently been accredited by IGTF. The official name of the new OSG CA in the IGTF bundle is CILogon OSG CA. Starting in November we will transition our VOs to start using the new OSG CA (CMS and Atlas being first ones). If a site has not installed the CA bundle by then, they will have authentication failures.

### What You Should Do:

Install the new CA bundle as soon as possible. The latest CA bundle will NOT be distributed in OSG Software v 3.1 because OSG no longer supports it.

For Linux servers (including worker nodes), ensure that the certificate bundle RPM is at version osg-ca-certs-1.50-1 or igtf-ca-certs-1.69-1 or greater.

Instructions for installing server CA certificate bundles are at <https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallCertAuth>

We also highly recommend that you use the CA Cert automatic updater <https://twiki.grid.iu.edu/bin/view/Documentation/Release3/OsgCaCertsUpdater> but note that you need to be using a current OSG software distribution for that to work, that is, OSG 3.2 or 3.3.

### Other Information:

If you have the CA certificate bundle installed on a server with OSG 3.1, you need to upgrade to OSG 3.2 or greater. Follow these instructions: <https://twiki.grid.iu.edu/bin/view/Documentation/Release3/OSGReleaseSeries#Updating_from_OSG_3_1_or_3_2_to>

Please email OSG Security Team with questions or comments

Known Issues
------------

-   HTCondor 8.4.0 has changed it's behavior in ways that cause the GlideinWMS frontend configuration to break. In order to correct this, the following setting needs to be added to the configuration file: \\

``` file
COLLECTOR_USES_SHARED_PORT = False
```

-   StashCache packages need to be manually configured
    -   Manual configuration for origin server
        -   Assuming that the origin server connects only to a redirector (not directly to cache server), minimal xrootd configuration is required. The configuration file, /etc/xrootd/xrootd-stashcache-origin-server.cfg, in this release is overkill. Here are recommended settings to use: \\

``` file
xrd.port 1094
all.role server
all.manager stash-redirector.example.com 1213
all.export / nostage
xrootd.trace emsg login stall redirect
ofs.trace none
xrd.trace conn
cms.trace all
sec.protocol  host
sec.protbind  * none
all.adminpath /var/run/xrootd
all.pidpath /var/run/xrootd
```

-   Manual configuration for cache server
    -   In contrast to the origin server configuration, one needs to declare `pss.origin <stash-redirector.example.com>` instead of configuring the cmsd or manager (only the xrootd daemon is required on the cache server). More detailed configuration of cache server for StashCache is [here](https://confluence.grid.iu.edu/pages/viewpage.action?title=Installing+an+XRootD+server+for+Stash+Cache&spaceKey=STAS).
-   In both cases, administrator needs to set the path of custom configuration file for its xrootd/cmds instance in /etc/sysconfig/xrootd, For example, change the cmds default from: \\

``` file
CMSD_DEFAULT_OPTIONS="-l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-clustered.cfg -k fifo"
```

\\ to \\

``` file
CMSD_DEFAULT_OPTIONS="-l /var/log/xrootd/cmsd.log -c /etc/xrootd/xrootd-stashcache-origin-server.marian -k fifo" 
```

Updating to the new release
---------------------------

### Update Repositories

To update to this series, you need [install the current OSG repositories](Documentation.Release3.YumRepositories#Install_OSG_Repositories).

### Update Software

Once the new repositories are installed, you can update to this new release with:

``` console
[root@client ~] $ yum update
```

<span class="twiki-macro NOTE"></span> Please be aware that running `yum update` may also update other RPMs. You can exclude packages from being updated using the `--exclude=[package-name or glob]` option for the `yum` command.

<span class="twiki-macro NOTE"></span> Watch the yum update carefully for any messages about a `.rpmnew` file being created. That means that a configuration file had been editted, and a new default version was to be installed. In that case, RPM does not overwrite the editted configuration file but instead installs the new version with a `.rpmnew` extension. You will need to merge any edits that have made into the `.rpmnew` file and then move the merged version into place (that is, without the `.rpmnew` extension). Watch especially for `/etc/lcmaps.db`, which every site is expected to edit.

Need help?
----------

Do you need help with this release? [Contact us for help](HelpProcedure).

Detailed changes in this release
--------------------------------

### Packages

We added or updated the following packages to the production OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

-   [igtf-ca-certs-1.69-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.69-1.osg33.el6)
-   [osg-ca-certs-1.50-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.50-1.osg33.el6)
-   [osg-version-3.3.3-1.osg33.el6](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.3-1.osg33.el6)

#### Enterprise Linux 7

-   [igtf-ca-certs-1.69-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=igtf-ca-certs-1.69-1.osg33.el7)
-   [osg-ca-certs-1.50-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-ca-certs-1.50-1.osg33.el7)
-   [osg-version-3.3.3-1.osg33.el7](https://koji-hub.batlab.org/koji/search?match=glob&type=build&terms=osg-version-3.3.3-1.osg33.el7)

### RPMs

If you wish to manually update your system, you can run yum update against the following packages:

    igtf-ca-certs osg-ca-certs osg-version

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
igtf-ca-certs-1.69-1.osg33.el6
osg-ca-certs-1.50-1.osg33.el6
osg-version-3.3.3-1.osg33.el6
```

#### Enterprise Linux 7

``` file
igtf-ca-certs-1.69-1.osg33.el7
osg-ca-certs-1.50-1.osg33.el7
osg-version-3.3.3-1.osg33.el7
```

### Upcoming Packages

We added or updated the following packages to the **upcoming** OSG yum repository. Note that in some cases, there are multiple RPMs for each package. You can click on any given package to see the set of RPMs or see the complete list below.

#### Enterprise Linux 6

#### Enterprise Linux 7

### Upcoming RPMs

If you wish to manually update your system, you can run yum update against the following packages:

If you wish to only update the RPMs that changed, the set of RPMs is:

#### Enterprise Linux 6

``` file
```

#### Enterprise Linux 7

``` file
```

