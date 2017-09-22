
Install a CVMFS Stratum 1
===================================================================

# About this Document 
This document describes how to install a CVMFS Stratum 1. There are many different variations on how to do that, but this document focuses on the configuration of the OSG GOC Stratum 1 oasis-replica.opensciencegrid.org. It is applicable to other Stratum 1s as well, very likely with modifications (some of which are suggested in the document below).

# Applicable versions 
The applicable software versions for this document are cvmfs and cvmfs-server >= 2.2.1.

# Requirements

## Host and OS

-   OS is a 64-bit <span class="twiki-macro SUPPORTED_OS"></span>.
-   Root access
-   SELinux disabled
-   Adequate disk space for the repositories that will be served, at `/srv/cvmfs`. Do not use xfs as the filesystem type on operating systems older than RHEL7, because it has been demonstrated to perform poorly for CVMFS repositories; instead use ext3 or ext4. About 10GB should be reserved for apache and squid logs under /var/log on a production server, although they normally will not get that large. A Stratum 1 that is also a repository server should have at least 5GB available at `/var/cache`.

## Users and Groups

If your machine is also going to be a repository server like the OSG GOC, the installation will create one user unless it already exists:

<span class="twiki-macro STARTSECTION">Users</span>

| User    | Comment                   |
|:--------|:--------------------------|
| `cvmfs` | CernVM-FS service account |

<span class="twiki-macro ENDSECTION">Users</span>

A repository server installation will also create a cvmfs group and default the cvmfs user to that group.

In addition, if the fuse rpm is not for some reason already installed, installing the repository server packages will also install fuse and that will create another group:

<span class="twiki-macro STARTSECTION">Groups</span>

| Group   | Comment                   | Group members |
|:--------|:--------------------------|:--------------|
| `cvmfs` | CernVM-FS service account | none          |
| `fuse`  | FUSE service account      | `cvmfs`       |

<span class="twiki-macro ENDSECTION">Groups</span>

# Install Instructions

All CVMFS Stratum 1s require cvmfs-server software and apache (httpd). It is highly recommended to also install frontier-squid and frontier-awstats on the same machine to be able to easily join the WLCG [MRTG](http://wlcg-squid-monitor.cern.ch/snmpstats/indexcvmfs.html) and [awstats](http://wlcg-squid-monitor.cern.ch/awstats/cvmfs.html) monitoring systems. The recommended configuration for frontier-squid below does not do any caching, it is just for monitoring.

## Installing cvmfs-server and httpd

The OSG GOC Stratum 1 has to function as a repository server in addition to serving repository replications; most Stratum 1s serve only replications. Serving repositories is done quite differently on Redhat EL5 and EL6 systems. Instructions are also provided for how to install cvmfs-server on Stratum 1s that do not have to be repository servers, which is the same on both versions of operating systems. Choose one of the following three sections.

### Installing a CVMFS repository server

#### Installing CVMFS repository server on RHEL5

Redhat EL5-based systems that are not Scientific Linux-based should first build the [SL5 aufs source rpm](http://ftp.scientificlinux.org/linux/scientific/5x/SRPMS/SL/aufs-0.20090202.cvs-6.sl5.src.rpm) and install the resulting rpm in their own yum repository.

Follow these instructions to install:

```
[root@client ~] $ rpm -i http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/5/x86_64/cvmfs-release-2-4.el5.noarch.rpm
[root@client ~] $ rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
[root@client ~] $ yum -y install aufs cvmfs-server.x86_64 cvmfs.x86_64 mod_wsgi
```

#### Installing CVMFS repository server on RHEL6

Redhat EL6-based systems running a CVMFS repository server have to get their kernel from CERN: 

```
[root@client ~] $ rpm -i http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-release-latest.noarch.rpm
[root@client ~] $ yum -y install --enablerepo=cernvm-kernel kernel aufs2-util cvmfs-server.x86_64 cvmfs.x86_64 mod_wsgi
[root@client ~] $ reboot
```

#### CVMFS repository server and RHEL7 
RHEL7.2 cannot be reliably used as a repository server, because of bugs in the union filesystem OverlayFS. The bugs are fixed in RHEL7.3.

Redhat EL7.3-based systems running a CVMFS repository server is the simplest method: 

```
[root@client ~] $ rpm -i http://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-release-latest.noarch.rpm
[root@client ~] $ yum -y install cvmfs-server.x86_64 cvmfs.x86_64 mod_wsgi
```

### Installing CVMFS stratum 1 code without repository server code 
If you're not installing for the OSG GOC or otherwise want to support serving repositories on the same machine as a Stratum 1, use this section.

On Redhat EL5, first do these commands:

```
[root@client ~] $ curl -O https://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs/EL/5/x86_64/cvmfs-release-2-4.el5.noarch.rpm
[root@client ~] $ rpm -i cvmfs-release-2-4.el5.noarch.rpm 
[root@client ~] $ curl -O https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm
[root@client ~] $ rpm -Uvh epel-release-latest-5.noarch.rpm
```

On Redhat EL6, first do these commands:

```
[root@client ~] $ rpm -i https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
```


On Redhat EL7, first do these commands:

```
[root@client ~] $ rpm -i https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm
```

Then on any type of system do this command:

```
[root@client ~] $ yum -y install cvmfs-server.x86_64 cvmfs-config mod_wsgi
```

## Installing frontier-squid and frontier-awstats

Do these commands to install frontier-squid and frontier-awstats:

```
[root@client ~] $ rpm -i http://frontier.cern.ch/dist/rpms/RPMS/noarch/frontier-release-1.1-1.noarch.rpm
[root@client ~] $ yum -y install frontier-awstats
```

# Configuring

## Configuring the system

Increase the default number of open file descriptors:

```
[root@client ~] $ echo -e "\*\t\t-\tnofile\t\t16384" >>/etc/security/limits.conf 
[root@client ~] $ ulimit -n 16384
```

In order for this to apply also interactively when logging in over ssh, the option `UsePAM` has to be set to `yes` in `/etc/ssh/sshd_config`.

## Configuring cron 
First, create the log directory: 

```
[root@client ~] $ mkdir -p /var/log/cvmfs
```

Put the following in `/etc/cron.d/cvmfs`:

```
0,15,30,45 * * * * root test -d /srv/cvmfs || exit;cvmfs_server snapshot -ai 
0 9 * * * root find /srv/cvmfs/\*.**/data/txn -name "**.*" -mtime +2 2>/dev/null|xargs rm -f
```


Also put the following in `/etc/logrotate.d/cvmfs`:

```
/var/log/cvmfs/\*.log { weekly missingok notifempty }
```

## Configuring apache

If you are installing frontier-squid, create `/etc/httpd/conf.d/cvmfs.conf` and put the following lines into it:

```
Listen 8080 KeepAlive On
```

If you are not installing frontier-squid, instead put the following lines into that file:

```
Listen 8000 KeepAlive On
```

If you will be serving opensciencegrid.org repositories, you have to allow for old client configurations that access repositories without the domain name added. For that reason, you will need to remove each `/etc/httpd/conf.d/cvmfs.<repositoryname>.conf` that adding a replica creates (this is included in the [add_osg_repository script](http://svn.usatlas.bnl.gov/svn/oasis/oasis-server/trunk/bin/add_osg_repository)), and instead add the following to `/etc/httpd/conf.d/cvmfs.conf`:

```
RewriteEngine On 
RewriteRule ^/cvmfs/(\[^./\]**)/(.**)$ /cvmfs/$1.opensciencegrid.org/$2 
RewriteRule ^/cvmfs/(\[^/\]+)/api/(.**)$ /cvmfs/$1/api/$2 \[PT\] 
RewriteRule ^/cvmfs/(.**)$ /srv/cvmfs/$1 
<Directory "/srv/cvmfs"> 
  Options -MultiViews +FollowSymLinks -Indexes 
  AllowOverride All 
  Order allow,deny 
  Allow from all

  EnableMMAP Off EnableSendFile Off

  <FilesMatch "^\.cvmfs"> ForceType application/x-cvmfs </FilesMatch>

  Header unset 
  Last-Modified 
  FileETag None

  ExpiresActive On 
  ExpiresDefault "access plus 3 days" 
  ExpiresByType text/html "access plus 15 minutes" 
  ExpiresByType application/x-cvmfs "access plus 2 minutes" 
</Directory>

WSGIDaemonProcess cvmfs-api processes=2 display-name=%{GROUP} \\ python-path=/usr/share/cvmfs-server/webapi 
WSGIProcessGroup cvmfs-api 
WSGISocketPrefix /var/run/wsgi 
WSGIScriptAliasMatch /cvmfs/(\[^/\]+)/api /var/www/wsgi-scripts/cvmfs-api.wsgi/$1 
```

On EL7-based systems (apache httpd 2.4 and later) replace the "Order allow, deny" and "Allow from all" to "Require all granted".

If you will be serving cern.ch repositories, it has the same problem; replace opensciencegrid.org above with cern.ch. If you need to serve both opensciencegrid.org and cern.ch contact Dave Dykstra to discuss the options.

Then enable apache:

```
[root@client ~] $ chkconfig httpd on 
[root@client ~] $ service httpd start
```

## Configuring frontier-squid

Put the following in `/etc/squid/customize.sh` after the existing comment header:

```
awk --file `dirname $0`/customhelps.awk --source '{

# cache only api calls 
insertline("^http_access deny all", "acl CVMFSAPI urlpath_regex ^/cvmfs/\[^/\]\*/api/") insertline("^http_access deny all", "cache deny CVMFSAPI")

# port 80 is also supported, through an iptables redirect 
setoption("http_port", "8000 accel defaultsite=localhost:8080 no-vhost") setoption("cache_peer", "localhost parent 8080 0 no-query originserver")

# allow incoming http accesses from anywhere \# all requests will be forwarded to the originserver 
commentout("http_access allow NET_LOCAL") insertline("^http_access deny all", "http_access allow all")

# do not let squid cache DNS entries more than 5 minutes 
setoption("positive_dns_ttl", "5 minutes")

# set shutdown_lifetime to 0 to avoid giving new connections error \# codes, which get cached upstream 
setoption("shutdown_lifetime", "0 seconds")

# turn off collapsed_forwarding to prevent slow clients from slowing down faster ones
setoption("collapsed_forwarding", "off")

print }'
```


On an RHEL7 system, make sure that iptables-services is installed and enabled:

```
[root@client ~] $ yum -y install iptables-services 
[root@client ~] $ systemctl enable iptables
```

Forward port 80 to port 8000 (first command is for external, second command for localhost):

```
[root@client ~] $ iptables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8000 
[root@client ~] $ iptables -t nat -A OUTPUT -o lo -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8000 
[root@client ~] $ service iptables save
```

On RHEL7 also set up the the same port forwarding for IPv6 (unfortunately it is not supported on RHEL6):

```
[root@client ~] $ ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8000
[root@client ~] $ ip6tables -t nat -A OUTPUT -o lo -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8000
[root@client ~] $ service ip6tables save
```


Enable frontier-squid:

```
[root@client ~] $ chkconfig frontier-squid on
[root@client ~] $ service frontier-squid start
```

Note: the above configuration is for a single squid thread, which is fine for 1Gbit/s and possibly 2Gbit/s, but if higher bandwidth is needed, see the [instructions for running multiple squid workers](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Running_multiple_squid_workers).

# Verifying

In order to verify that everything is installed correctly, create a repository replica. The repository chosen for the instructions below is one from egi.eu because it is very small, but you can use another one if you prefer.

## Adding an example repository

The OSG GOC Stratum 1 should add a repository replica using the `add_osg_repository` script from the oasis-2 rpm. Instructions for installing that are elsewhere but you can also [download add_osg_repository](http://svn.usatlas.bnl.gov/svn/oasis/oasis-server/trunk/bin/add_osg_repository). This script assumes that the oasis.opensciencegrid.org replica repository was first created, so this instruction creates it but does not download the first snapshot because that would take a lot of space and time. Use these commands to create the oasis replica and to create and download the example replica:

```
[root@client ~] $ cvmfs_server add-replica -o root http://oasis.opensciencegrid.org:8000/cvmfs/oasis.opensciencegrid.org> /etc/cvmfs/keys/opensciencegrid.org/opensciencegrid.org.pub 
[root@client ~] $ add_osg_repository http://cvmfs-stratum0.gridpp.rl.ac.uk:8000/cvmfs/config-egi.egi.eu
```

It's a good idea for other Stratum 1s to make their own scripts for adding repository replicas, because there's always two or three commands to run, and it's easy to forget the commands after the first one. The first command is generically this:

```
[root@client ~] $ cvmfs_server add-replica -o root http://cvmfs-stratum0.gridpp.rl.ac.uk:8000/cvmfs/config-egi.egi.eu> /etc/cvmfs/keys/egi.eu/egi.eu.pub
```

However, non-GOC OSG Stratum 1s (that is, at BNL and FNAL), for the sake of fulfilling an OSG security requirement, need to instead read from the OSG GOC machine with this as their first command:

```
[root@client ~] $ cvmfs_server add-replica -o root http://oasis-replica.opensciencegrid.org:8000/cvmfs/config-egi.egi.eu /etc/cvmfs/keys/egi.eu/egi.eu.pub:/etc/cvmfs/keys/opensciencegrid.org/opensciencegrid.org.pub
```

The second command for Stratum 1s that have the httpd configuration as described above in the [Configuring apache section](#Configuring_apache) is this:

```
[root@client ~] $ rm -f /etc/httpd/conf.d/cvmfs.config-egi.egi.eu.conf
```

Then the next command is this:

```
[root@client ~] $ cvmfs_server snapshot config-egi.egi.eu
```

With large repositories that can take a very long time, but with small repositories it should be very quick and not show any errors.

## Verifying that the replica is being served

Now to verify that the replication is working, do the following commands:

```
[user@client ~] $ wget -qdO- http://localhost:8000/cvmfs/config-egi.egi.eu/.cvmfspublished%7Ccat -v
[user@client ~] $ wget -qdO- http://localhost:80/cvmfs/config-egi.egi.eu/.cvmfspublished%7Ccat -v
```

Both commands should show a short file including gibberish at the end which is the signature.

It is a good idea to familiarize yourself with the log entries at `/var/log/httpd/access_log` and also, if you have installed frontier-squid, at `/var/log/squid/access.log`. Also, at least 15 minutes after the snapshot is finished, check the log `/var/log/cvmfs` to see that it tried to get an update and got no errors.

# Setting up monitoring

If you installed frontier-squid and frontier-awstats, there is a little more to do to configure monitoring.

First, make sure that your firewall accepts UDP queries from the monitoring server at CERN. Details are on [the frontier-squid instructions](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Enabling_monitoring). Next, choose any random password and put it in `/etc/awstats/password-file`. Then tell Dave Dykstra the fully qualified domain name of your machine and the password you chose, and he'll set up the monitoring servers.

