# Install a CVMFS Stratum 1

This document describes how to install a CVMFS Stratum 1. There are many different variations on how to do that, but this document focuses on the configuration of the OSG Operations Stratum 1 oasis-replica.opensciencegrid.org. It is applicable to other Stratum 1s as well, very likely with modifications (some of which are suggested in the document below).

!!! note "Applicable versions"
    The applicable software versions for this document are cvmfs and cvmfs-server >= 2.4.2.

## Before Starting

Before starting the installation process, consider the following points:

- **User IDs and Group IDs:** If your machine is also going to be a repository server like OSG Operations, the installation will create the same user and group IDs as the [cvmfs client](../worker-node/install-cvmfs.md).  If you are installing frontier-squid, the installation will also create the same user id as [frontier-squid](../data/frontier-squid.md).
-  **Network ports:** This installation will host the stratum 1 on ports 80, 8000 and 8080, and if squid is installed it will host the uncached apache on port 8081.  Port 80 is default but sometimes runs into operational problems, port 8000 is the alternate for most production use, and port 8080 is for Cloudflare (https://openhtc.io).
- **Host choice:** -  Make sure there is adequate disk space for the repositories that will be served, at `/srv/cvmfs`. Do not use xfs as the filesystem type on operating systems older than EL7, because it has been demonstrated to perform poorly for CVMFS repositories; instead use ext3 or ext4. About 10GB should be reserved for apache and squid logs under /var/log on a production server, although they normally will not get that large. A Stratum 1 that is also a repository server should have at least 5GB available at `/var/cache`.
- **SELinux** - Ensure SELinux is disabled

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms.md)
- Obtain root access to the host
- Prepare the [required Yum repositories](../common/yum.md)

## Installing

All CVMFS Stratum 1s require cvmfs-server software and apache (httpd). It is highly recommended to also install [frontier-squid](../data/frontier-squid.md) and [frontier-awstats](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallAwstats) on the same machine to be able to easily join the WLCG [MRTG](http://wlcg-squid-monitor.cern.ch/snmpstats/indexcvmfs.html) and [awstats](http://wlcg-squid-monitor.cern.ch/awstats/cvmfs.html) monitoring systems. The recommended configuration for frontier-squid below only caches geo api lookups.  Other than that, it is primarily for monitoring.

### Installing cvmfs-server and httpd

The OSG Operations Stratum 1 has to function as a repository server in addition to serving repository replications; most Stratum 1s serve only replications. Instructions are also provided for how to install cvmfs-server on Stratum 1s that do not have to be repository servers.  Choose the appropriate subsection.

#### Installing a CVMFS stratum 1 that is also a repository server

EL7.2 cannot be reliably used as a repository server, because of bugs in the union filesystem OverlayFS. The bugs are fixed in EL7.3, so use EL7.3 or later.

```console
root@host # yum -y install cvmfs-server cvmfs mod_wsgi
```

#### Installing CVMFS stratum 1 that is not a repository server

If you're not installing for OSG Operations or otherwise want to support serving repositories on the same machine as a Stratum 1, use this command:

```console
root@host # yum -y install cvmfs-server cvmfs-config mod_wsgi
```

### Installing frontier-squid and frontier-awstats

[frontier-awstats](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallAwstats) is not distributed by OSG so these instructions get it from its original source.  Do these commands to install frontier-squid and frontier-awstats:

```console
root@host # rpm -i http://frontier.cern.ch/dist/rpms/RPMS/noarch/frontier-release-1.1-1.noarch.rpm
root@host # yum -y install frontier-squid frontier-awstats
```

## Configuring

### Configuring the system

Increase the default number of open file descriptors:

```console
root@host # echo -e "*\t\t-\tnofile\t\t16384" >>/etc/security/limits.conf 
root@host # ulimit -n 16384
```

In order for this to apply also interactively when logging in over ssh, the option `UsePAM` has to be set to `yes` in `/etc/ssh/sshd_config`.

### Configuring cron 
First, create the log directory: 

```console
root@host # mkdir -p /var/log/cvmfs
```

Put the following in `/etc/cron.d/cvmfs`:

```
*/5 * * * * root test -d /srv/cvmfs || exit;cvmfs_server snapshot -ai 
6 1 * * * root cvmfs_server gc -af 2>/dev/null || true
0 9 * * * root find /srv/cvmfs/*.*/data/txn -name "*.*" -mtime +2 2>/dev/null|xargs rm -f
```

Also, put the following in `/etc/logrotate.d/cvmfs`:

```
/var/log/cvmfs/*.log {
    weekly
    missingok
    notifempty
}
```

### Configuring apache

If you are installing frontier-squid, create `/etc/httpd/conf.d/cvmfs.conf` and put the following lines into it:

```
Listen 8081 KeepAlive On
```

If you are not installing frontier-squid, instead put the following lines into that file:

```
Listen 8000 KeepAlive On
Listen 8080 KeepAlive On
```

If you will be serving opensciencegrid.org repositories, you have to allow for old client configurations that access repositories without the domain name added. For that reason, you will need to remove each `/etc/httpd/conf.d/cvmfs.<repositoryname>.conf` that adding a replica creates (this is included in the [add_osg_repository script](https://github.com/opensciencegrid/oasis-server/blob/master/bin/add_osg_repository)), and instead add the following to `/etc/httpd/conf.d/cvmfs.conf`:

```
RewriteEngine On 
RewriteRule ^/cvmfs/([^./]*)/(.*)$ /cvmfs/$1.opensciencegrid.org/$2 
RewriteRule ^/cvmfs/([^/]+)/api/(.*)$ /var/www/wsgi-scripts/cvmfs-server/cvmfs-api.wsgi/$1/$2
RewriteRule ^/cvmfs/(.*)$ /srv/cvmfs/$1 
<Directory "/srv/cvmfs"> 
  Options -MultiViews +FollowSymLinks -Indexes 
  AllowOverride All 
  Require all granted

  EnableMMAP Off EnableSendFile Off

  <FilesMatch "^\.cvmfs">
    ForceType application/x-cvmfs
  </FilesMatch>

  Header unset Last-Modified 
  RequestHeader unset If-Modified-Since
  FileETag None

  ExpiresActive On 
  ExpiresDefault "access plus 3 days" 
  ExpiresByType text/html "access plus 15 minutes" 
  ExpiresByType application/x-cvmfs "access plus 61 seconds" 
  ExpiresByType application/json "access plus 61 seconds" 
</Directory>

WSGIDaemonProcess cvmfs-api threads=64 display-name=%{GROUP} \
    python-path=/usr/share/cvmfs-server/webapi
<Directory /var/www/wsgi-scripts/cvmfs-server>
  WSGIProcessGroup cvmfs-api
  WSGIApplicationGroup cvmfs-api
  Options ExecCGI
  SetHandler wsgi-script
  Require all granted
</Directory>
WSGISocketPrefix /var/run/wsgi 
```

If you will be serving cern.ch repositories, it has the same problem; replace opensciencegrid.org above with cern.ch. If you need to serve both opensciencegrid.org and cern.ch contact Dave Dykstra to discuss the options.

Then enable apache:

```console
root@host # systemctl enable httpd
root@host # systemctl start httpd
```


### Configuring frontier-squid

Put the following in `/etc/squid/customize.sh` after the existing comment header:

```awk
awk --file `dirname $0`/customhelps.awk --source '{

# cache only api calls 
insertline("^http_access deny all", "acl CVMFSAPI urlpath_regex ^/cvmfs/[^/]*/api/")
insertline("^http_access deny all", "cache deny !CVMFSAPI")

# port 80 is also supported, through an iptables redirect 
setoption("http_port", "8000 accel defaultsite=localhost:8081 no-vhost")
insertline("TAG: http_port","http_port 8080 accel defaultsite=localhost:8081 no-vhost")
setoption("cache_peer", "localhost parent 8081 0 no-query originserver")

# allow incoming http accesses from anywhere
# all requests will be forwarded to the originserver 
commentout("http_access allow NET_LOCAL")
insertline("^http_access deny all", "http_access allow all")

# do not let squid cache DNS entries more than 5 minutes 
setoption("positive_dns_ttl", "5 minutes")

# set shutdown_lifetime to 0 to avoid giving new connections error
# codes, which get cached upstream 
setoption("shutdown_lifetime", "0 seconds")

# turn off collapsed_forwarding to prevent slow clients from slowing down
# faster ones
setoption("collapsed_forwarding", "off")

print
}'
```

On an EL7 system, make sure that iptables-services is installed and enabled:

```console
root@host # yum -y install iptables-services 
root@host # systemctl enable iptables
```

Forward port 80 to port 8000:

```console
root@host # iptables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8000 
root@host # service iptables save
```

On EL7 also set up the the same port forwarding for IPv6:

```console
root@host # ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8000
root@host # service ip6tables save
```

Enable frontier-squid:

```console
root@host # systemctl enable frontier-squid
root@host # systemctl start frontier-squid
```

!!! note
    The above configuration is for a single squid thread, which is fine for 1Gbit/s and possibly 2Gbit/s, but if higher bandwidth is needed, see the [instructions for running multiple squid workers](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Running_multiple_squid_workers).

## Verifying

In order to verify that everything is installed correctly, create a repository replica. The repository chosen for the instructions below is one from egi.eu because it is very small, but you can use another one if you prefer.

### Adding an example repository

The OSG Operations Stratum 1 should add a repository replica using the `add_osg_repository` script from the oasis-goc rpm. Instructions for installing that are elsewhere. That script assumes that the oasis.opensciencegrid.org replica repository was first created, so this instruction creates it but does not download the first snapshot because that would take a lot of space and time. Use these commands to create the oasis replica and to create and download the example replica:

```console
root@host # cvmfs_server add-replica -o root http://oasis.opensciencegrid.org:8000/cvmfs/oasis.opensciencegrid.org /etc/cvmfs/keys/opensciencegrid.org/opensciencegrid.org.pub 
root@host # add_osg_repository http://cvmfs-stratum0.gridpp.rl.ac.uk:8000/cvmfs/config-egi.egi.eu
```

It's a good idea for other Stratum 1s to make their own scripts for adding repository replicas, because there's always two or three commands to run, and it's easy to forget the commands after the first one. The first command is this:

```console
root@host # cvmfs_server add-replica -o root http://cvmfs-stratum0.gridpp.rl.ac.uk:8000/cvmfs/config-egi.egi.eu /etc/cvmfs/keys/egi.eu/egi.eu.pub
```

However, non-OSG Operations Stratum 1s (that is, at BNL and FNAL), for the sake of fulfilling an OSG security requirement, need to instead read from the OSG Operations machine with this as their first command:

```console
root@host # cvmfs_server add-replica -o root http://oasis-replica.opensciencegrid.org:8000/cvmfs/config-egi.egi.eu /etc/cvmfs/keys/egi.eu/egi.eu.pub:/etc/cvmfs/keys/opensciencegrid.org/opensciencegrid.org.pub
```

The second command for Stratum 1s that have the httpd configuration as described above in the [Configuring apache section](#configuring-apache) is this:

```console
root@host # rm -f /etc/httpd/conf.d/cvmfs.config-egi.egi.eu.conf
```

Then the next command is this:

```console
root@host # cvmfs_server snapshot config-egi.egi.eu
```

With large repositories that can take a very long time, but with small repositories it should be very quick and not show any errors.

### Verifying that the replica is being served

Now to verify that the replication is working, do the following commands:

```console
root@host # wget -qdO- http://localhost:8000/cvmfs/config-egi.egi.eu/.cvmfspublished | cat -v
root@host # wget -qdO- http://localhost:80/cvmfs/config-egi.egi.eu/.cvmfspublished | cat -v
```

Both commands should show a short file including gibberish at the end which is the signature.

It is a good idea to familiarize yourself with the log entries at `/var/log/httpd/access_log` and also, if you have installed frontier-squid, at `/var/log/squid/access.log`. Also, at least 15 minutes after the snapshot is finished, check the log `/var/log/cvmfs/snapshots.log` to see that it tried to get an update and got no errors.

## Setting up monitoring

If you installed frontier-squid and frontier-awstats, there is a little more to do to configure monitoring.

First, make sure that your firewall accepts UDP queries from the monitoring server at CERN. Details are in [the frontier-squid instructions](https://twiki.cern.ch/twiki/bin/view/Frontier/InstallSquid#Enabling_monitoring). Next, choose any random password and put it in `/etc/awstats/password-file`. Then tell Dave Dykstra the fully qualified domain name of your machine and the password you chose, and he'll set up the monitoring servers.

