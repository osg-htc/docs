Frontier Squid Caching Proxy Installation Guide
===============================================

<span class="twiki-macro TOC" depth="3"></span>

#About This Document

This document is intended for System Administrators who are installing
`frontier-squid`, the OSG distribution of the Frontier Squid software.

# Applicable Versions

The applicable software versions for this document are OSG Version >= 3.1.40 or >=
3.2.16. The version of frontier-squid installed should be >= 2.7.STABLE9-19.1

# About Frontier Squid

Frontier Squid is a distribution of the well-known [squid HTTP caching
proxy software](http://squid-cache.org) that is optimized for use with
applications on the Worldwide LHC Computing Grid (WLCG). It has [many
advantages](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Why_use_frontier_squid_instead_o)
over regular squid for common grid applications, especially Frontier and
CVMFS.

The OSG distribution of frontier-squid is a straight rebuild of the
upstream frontier-squid package for the convenience of OSG users.

# Frontier Squid is Recommended

OSG recommends that all sites run a caching proxy for HTTP and HTTPS to
help reduce bandwidth and improve throughput. To that end, Compute
Element (CE) installations include Frontier Squid automatically. We
encourage all sites to configure and use this service, as described
below.

For large sites that expect heavy load on the proxy, it may be best to
run the proxy on its own host. In that case, the Frontier Squid software
still will be installed on the CE, but it need not be enabled. Instead,
install your proxy service on the separate host and then configure the
CE host to refer to the proxy on that host.

The `osg-configure` configuration tool (version 1.0.45 and later) warns
users who have not added the proxy location to their CE configuration.
In the future, a proxy will be required and osg-configure will fail if
the proxy location is not set.

# Engineering Considerations

If you will be supporting the Frontier application at your site, review
the [upstream documentation Hardware considerations
section](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Hardware)
to determine how to size your equipment.

# Requirements

## Host and OS
-   OS is Red Hat Enterprise Linux 5, 6, 7, and variants
-   Root access

## Users The frontier-squid installation will create one user account
unless it already exists.

| User    |  Comment  | 
| ------- |  -------  |
| `squid` | Reduced privilege user that the squid process runs under. Set the default gid of the “squid” user to be a group that is also called “squid”. | 

The package can instead use another user name of your choice if you
create a configuration file before installation. Details are in the
[upstream documentation Preparation
section](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Preparation).

## Networking

| Service Name | Protocol | Port Number | Inbound | Outbound | Comment  |
| ------------ | -------  | ----------  | ------- | -------- | -------- |
| Squid        | tcp      | 3128        | ✓       | ✓        | Also limited in squid ACLs. Both in and outbound must not be wide open to internet simultaneously |
| Squid monitor | udp     | 3401        | ✓       |          | Also limited in squid ACLs. Should be limited to monitoring server addresses |

<span class="twiki-macro STARTSECTION">Firewalls</span> <span
class="twiki-macro INCLUDE" section="FirewallTable"
lines="squid,squidmonitor">Documentation/Release3.FirewallInformation</span>
\\ <span class="twiki-macro ENDSECTION">Firewalls</span>

The addresses of the WLCG monitoring servers for use in firewalls are
listed in the [upstream documentation Enabling monitoring
section](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Enabling_monitoring).

# Install Instructions 

### Install the Yum Repositories required by OSG
The OSG RPMs currently support Red Hat Enterprise Linux 5, 6, 7, and variants

OSG RPMs are distributed via the OSG yum repositories. Some packages depend on packages distributed via the EPEL repositories. So both repositories must be enabled.

#### Install EPEL
Install the EPEL repository, if not already present. Note: This enables EPEL by default. Choose the right version to match your OS version.

```bash
# EPEL 5 (For RHEL 5, CentOS 5, and SL 5) 
[root@client ~]$ curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm
[root@client ~]$ rpm -Uvh epel-release-latest-5.noarch.rpm
# EPEL 6 (For RHEL 6, CentOS 6, and SL 6) 
[root@client ~]$ rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
# EPEL 7 (For RHEL 7, CentOS 7, and SL 7) 
[root@client ~]$ rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

#### Install the Yum priorities package
For packages that exist in both OSG and EPEL repositories, it is important to prefer the OSG ones or else OSG software installs may fail. Installing the Yum priorities package enables the repository priority system to work.

1. Choose the correct package name based on your operating system’s major version:
 ..* For EL 5 systems, use yum-priorities
 ..* For EL 6 and EL 7 systems, use yum-plugin-priorities
2. Install the yum priorities package:
```bash
[root@client ~]$ yum install PACKAGE
```
Replace PACKAGE with the package name from the previous step.
3. Ensure that ```/etc/yum.conf``` has the following line in the ```[main]``` section (particularly when using ROCKS), thereby enabling Yum plugins, including the priorities one:
```
plugins=1
```
*NOTE*: If you do not have a required key you can force the installation using ```--nogpgcheck```; e.g., ```yum install --nogpgcheck yum-priorities```

#### Install OSG Repositories
1. If you are upgrading from OSG 3.1 (or 3.2) to OSG 3.2 (or 3.3), remove the old OSG repository definition files and clean the Yum cache:
```bash
[root@client ~]$ yum clean all
[root@client ~]$ rpm -e osg-release
```
This step ensures that local changes to ```*.repo``` files will not block the installation of the new OSG repositories. After this step, ```*.repo``` files that have been changed will exist in ```/etc/yum.repos.d/``` with the ```*.rpmsave``` extension. After installing the new OSG repositories (the next step) you may want to apply any changes made in the ```*.rpmsave``` files to the new ```*.repo``` files.
2. Install the OSG repositories using one of the following methods depending on your EL version:
..1. For EL versions greater than EL5, install the files directly from ```repo.grid.iu```:
```bash
[root@client ~]$ rpm -Uvh URL
```
where URL is one of the following:

| Series | EL6 URL (for RHEL 6, CentOS 6, or SL 6) | 	EL7 URL (for RHEL 7, CentOS 7, or SL 7) | 
| ------ | --------------------------------------- |  --------------------------------------- |
| OSG 3.2 | https://repo.grid.iu.edu/osg/3.2/osg-3.2-el6-release-latest.rpm	 | N/A | 
| OSG 3.3 | https://repo.grid.iu.edu/osg/3.3/osg-3.3-el6-release-latest.rpm  | https://repo.grid.iu.edu/osg/3.3/osg-3.3-el7-release-latest.rpm |

## Installing Frontier Squid

After meeting the requirements in the previous section, install
frontier-squid with this command: 
```bash
[root@client ~]# yum install frontier-squid
```

Then enable it to start at boot time with this command: 
```bash
[root@client ~]# chkconfig frontier-squid on
```

# Configuring Frontier Squid

## Configuring the Frontier Squid Service

To configure the Frontier Squid service itself:

1.  Follow the [original Frontier Squid
    documentation](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid),
    in [the Configuration
    section](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Configuration)\\
   **Note:** An important difference between the standard Squid
    software and the Frontier Squid variant is that Frontier Squid
    changes are in `/etc/squid/customize.sh` instead of
    `/etc/squid/squid.conf`.
2.  Enable, start, and test the service (as described below)
3.  Enable WLCG monitoring as described in the [upstream documentation
    on enabling
    monitoring](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Enabling_monitoring)
    and [register the squid in
    OIM](https://twiki.cern.ch/twiki/bin/view/LCG/WLCGSquidRegistration#OIM).

## Configuring the OSG CE

To configure the OSG Compute Element (CE) to know about your Frontier
Squid service:

1.  On your CE host, edit `/etc/osg/config.d/01-squid.ini`
    -   Make sure that `enabled` is set to `True`
    -   Set `location` to the hostname and port of your Frontier Squid
        service (e.g., `my.squid.host.edu:3128`)
    -   Leave the other settings at `DEFAULT` unless you have specific
        reasons to change them

2.  Run `osg-configure` to propagate the changes on your CE
**Note:** You may want to finish other CE configuration tasks before running `osg-configure`. Just be sure to run it once before starting CE services.

# Starting and Stopping the Frontier Squid Service

Starting frontier-squid:

``` {.rootscreen}
[root@client ~]# service frontier-squid start
```

Stopping frontier-squid:

``` {.rootscreen}
[root@client ~]# service frontier-squid stop
```

# Testing Frontier Squid

As any user on another computer, do the following (where
%RED%yoursquid.your.domain<span class="twiki-macro ENDCOLOR"></span> is
the fully qualified domain name of your squid server):

``` {.screen}
[user@client ~]$ export http_proxy=http://yoursquid.your.domain:3128
[user@client ~]$ wget -qdO/dev/null http://frontier.cern.ch 2>&1|grep X-Cache
X-Cache: MISS from yoursquid.your.domain
[user@client ~]$ wget -qdO/dev/null http://frontier.cern.ch 2>&1|grep X-Cache
X-Cache: HIT from yoursquid.your.domain
```

If the grep doesn’t print anything, try removing it from the pipeline to
see if errors are obvious. If the second try says MISS again, something
is probably wrong with the squid cache writes.

If your squid will be supporting the Frontier application, it is also
good to do the test in the [upstream documentation Testing the
installation
section](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Testing_the_installation).

# Frontier Squid Log Files

Log file contents are explained in the [upstream documentation Log file
contents
section](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Log_file_contents).

# Getting Help 
To get assistance please use [Help
Procedure](HelpProcedure).
