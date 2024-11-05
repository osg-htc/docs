title: Basics of using yum and RPM

Basics of using yum and RPM
===========================

About This Document
-------------------

This document introduces package management tools that help you install, update, and remove packages. OSG uses RPMs (the Red Hat Packaging Manager) to package its software. While RPM is the packaging format, `yum` is the command you will use to do the installation. For example, `yum` will resolve and download the dependencies for the package you want to install; `rpm` will simply complain if you want to install a package that does not have all its dependencies installed.


Installation
------------

Installation is done with the `yum install` command. Each of the individual installation guide shows you the correct command to use to do an installation. Here is an example installation with all of the output from yum.

```console
root@host# yum install osg-ca-certs
OSG Software for Enterprise Linux 9 - x86_64                       5.1 kB/s | 1.4 kB     00:00    
OSG Software for Enterprise Linux 9 - Development - x86_64         1.4 MB/s | 470 kB     00:00    
Dependencies resolved.
===================================================================================================
 Package               Architecture    Version                      Repository                Size
===================================================================================================
Installing:
 osg-ca-certs          noarch          1.131-1.osg24.el9            osg                       242 k

Transaction Summary
===================================================================================================
Install  1 Package

Total download size: 242 k
Installed size: 483 k
Is this ok [y/N]: y
Downloading Packages:
osg-ca-certs-1.131-1.osg24.el9.noarch.rpm                          1.8 MB/s | 242 kB     00:00    
---------------------------------------------------------------------------------------------------
Total                                                              1.2 MB/s | 242 kB     00:00     
OSG Software for Enterprise Linux 9 - Development - x86_64         3.0 MB/s | 3.1 kB     00:00    
Importing GPG key 0xEFFC3BE6:
 Userid     : "OSG 24 Developer Signing Key <help@osg-htc.org>"
 Fingerprint: F77F E0C7 0A9B AA73 9FD3  52C9 9DF7 5B52 EFFC 3BE6
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-24-developer
Is this ok [y/N]: y
Key imported successfully
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                           1/1 
  Installing       : osg-ca-certs-1.131-1.osg24.el9.noarch                                     1/1 
  Verifying        : osg-ca-certs-1.131-1.osg24.el9.noarch                                     1/1 

Installed:
  osg-ca-certs-1.131-1.osg24.el9.noarch                                                            

Complete! 
```

**Please Note**: When you first install a package from the OSG repository, you will be prompted to import the GPG key. We use this key to sign our RPMs as a security measure. You should double-check the key id (above it is 824B8603) with the [information on our signed RPMs](signing.md). If it doesn't match, there is a problem somewhere and you should report it to the OSG via help@osg-htc.org.

Verifying Packages and Installations
------------------------------------

You can check if an RPM has been modified. For instance, to check to see if any files have been modified in the `osg-ca-certs` RPM you just installed:

    :::console
    user@host $ rpm --verify osg-ca-certs


The lack of any output means there were no problems. If you would like to see all the files for which there are no problems, you can do:

    :::console
    user@host $ rpm --verify -v osg-ca-certs
    ........    /etc/grid-security/certificates
    ........    /etc/grid-security/certificates/0119347c.0
    ........    /etc/grid-security/certificates/0119347c.namespaces
    ........    /etc/grid-security/certificates/0119347c.signing_policy
    ... etc ...


Each dot indicates a specific check that was made and passed. If someone had modified a file, you might see this:

    :::console
    user@host $ rpm --verify osg-ca-certs
    ..5....T    /etc/grid-security/certificates/ffc3d59b.0


This means the files MD5 checksum has changed (so the contents have changed) and the timestamp is different. The complete set of changes you might see (copied from the `rpm` man page) are:

| Letter | Meaning                                           |
|:-------|:--------------------------------------------------|
| `S`    | file Size differs                                 |
| `M`    | Mode differs (includes permissions and file type) |
| `5`    | MD5 sum differs                                   |
| `D`    | Device major/minor number mismatch                |
| `L`    | readLink(2) path mismatch                         |
| `U`    | User ownership differs                            |
| `G`    | Group ownership differs                           |
| `T`    | mTime differs                                     |

If you don't care about some of those changes, you can tell rpm to ignore them. For instance, to ignore changes in the modification time:

    :::console
    user@host $ rpm --verify --nomtime osg-ca-certs
    ..5.....    /etc/grid-security/certificates/ffc3d59b.0


Understanding a package
-----------------------

If you want to know what package a file belongs to, you can ask rpm. For instance, if you're curious what package contains the `srm-ls` command, you can do:

    :::console
    # 1. Find the exact path
    user@host $ which osg-cert-request
    /usr/bin/osg-cert-request

    # 2. Ask rpm what package it is part of:
    user@host $ rpm -q --file /usr/bin/osg-cert-request 
    osg-pki-tools-3.5.2-2.osg36.el9.noarch


If you want to know what other things are in a package--perhaps the other available tools or configuration files--you can do that as well:

    :::console
    user@host $ rpm -ql osg-pki-tools
    /usr/bin/osg-cert-request
    /usr/bin/osg-incommon-cert-request
    /usr/lib/python3.9/site-packages/osgpkitools
    /usr/lib/python3.9/site-packages/osgpkitools/ExceptionDefinitions.py
    /usr/lib/python3.9/site-packages/osgpkitools/__init__.py
    ... output trimmed ...


What else does a package install?
---------------------------------

Sometimes you need to understand what other software is installed by a package. This can be particularly useful for understanding *meta-packages*, which are packages such as the `osg-wn-client` (worker node client) that contain nothing by themselves but only depend on other RPMs. To do this, use the `--requires` option to rpm. For example, you can see that the worker node client (as of OSG 24 in October, 2024) will install `curl`, `uberftp`, `wget`, and a dozen or so other packages.

    :::console
    user@host $ rpm -q --requires osg-wn-client
    /usr/bin/curl
    /usr/bin/ldapsearch
    /usr/bin/wget
    /usr/bin/xrdcp
    config(osg-wn-client) = 24-1.osg24.el9
    fetch-crl
    gfal2
    gfal2-plugin-file
    gfal2-plugin-http
    gfal2-plugin-xrootd
    grid-certificates >= 7
    osg-system-profiler
    python3-gfal2-util
    rpmlib(CompressedFileNames) <= 3.0.4-1
    rpmlib(FileDigests) <= 4.6.0-1
    rpmlib(PayloadFilesHavePrefix) <= 4.0-1
    rpmlib(PayloadIsZstd) <= 5.4.18-1
    stashcp
    vo-client
    voms-clients-cpp

Finding RPM Packages
--------------------

It is normally best to read the OSG documentation to decide which packages to install because it may not be obvious what the correct packages to install are. That said, you can use yum to find out all sort of things. For instance, you can list packages that begin with "voms":

    :::console
    user@host $ yum list "voms*"
    Available Packages
    voms.x86_64                                      2.1.0-0.31.rc3.2.osg24.el9                osg 
    voms-api-java.noarch                             3.3.3-1.el9                               epel
    voms-api-java-javadoc.noarch                     3.3.3-1.el9                               epel
    voms-clients-cpp.x86_64                          2.1.0-0.31.rc3.2.osg24.el9                osg 
    voms-clients-cpp-debuginfo.x86_64                2.1.0-0.31.rc3.2.osg24.el9                osg 
    voms-clients-java.noarch                         3.3.3-1.el9                               epel
    voms-debuginfo.x86_64                            2.1.0-0.31.rc3.2.osg24.el9                osg 
    voms-debugsource.x86_64                          2.1.0-0.31.rc3.2.osg24.el9                osg 
    voms-devel.x86_64                                2.1.0-0.31.rc3.2.osg24.el9                osg 
    voms-doc.noarch                                  2.1.0-0.31.rc3.2.osg24.el9                osg 
    voms-mysql-plugin.x86_64                         3.1.7-13.el9                              epel
    voms-server.x86_64                               2.1.0-0.31.rc3.2.osg24.el9                osg 
    voms-server-debuginfo.x86_64                     2.1.0-0.31.rc3.2.osg24.el9                osg

If you want to search for packages that contain VOMS anywhere in the name or description, you can use `yum search`:

    :::console
    user@host $ yum search voms
    ============================================ Name Exactly Matched: voms ============================================
    voms.x86_64 : Virtual Organization Membership Service
    =========================================== Name & Summary Matched: voms ===========================================
    vo-client-lcmaps-voms.noarch : Provides a voms-mapfile-default file, mapping VOMS FQANs to Unix users suitable for
                                : use by the LCMAPS VOMS plugin
    voms-mysql-plugin.x86_64 : VOMS server plugin for MySQL
    xrootd-voms.x86_64 : VOMS attribute extractor plug-in for XRootD
    ================================================ Name Matched: voms ================================================
    voms-doc.noarch : Virtual Organization Membership Service Documentation
    voms-server.x86_64 : Virtual Organization Membership Service Server
    ============================================== Summary Matched: voms ===============================================
    vo-client.noarch : Contains vomses file for use with user authentication
    vo-client-dcache.noarch : Provides a grid-vorolemap file for use by dCache, similar to voms-mapfile-default
    ... etc ...

One last example, if you want to know what RPM would give you the `voms-proxy-init` command, you can ask `yum`. The **`*`** indicates that you don't know the full pathname of `voms-proxy-init`.

    :::console
    user@host $ yum whatprovides "*voms-proxy-init"
    voms-clients-cpp-2.1.0-0.31.rc3.1.osg24.el9.x86_64 : Virtual Organization Membership Service Clients
    Repo        : osg
    Matched from:
    Other       : *voms-proxy-init

    voms-clients-cpp-2.1.0-0.31.rc3.2.osg24.el9.x86_64 : Virtual Organization Membership Service Clients
    Repo        : osg
    Matched from:
    Other       : *voms-proxy-init

    voms-clients-cpp-2.1.0-1.el9.x86_64 : Virtual Organization Membership Service Clients
    Repo        : epel
    Matched from:
    Other       : *voms-proxy-init

    voms-clients-java-3.3.3-1.el9.noarch : Virtual Organization Membership Service Java clients
    Repo        : epel
    Matched from:
    Other       : *voms-proxy-init

Removing Packages
-----------------

To remove a single RPM, you can use `yum remove`. Not only will it uninstall the RPM you requested, but it will uninstall anything that depends on it. For example, if I previously installed the `voms-clients` package, I also installed another package it depends on called `voms`. If I remove `voms`, yum will also remove `voms-clients`:

``` console
user@host $ sudo yum remove voms
Dependencies resolved.
====================================================================================================================
 Package                                Architecture     Version                         Repository            Size
====================================================================================================================
Removing:
 voms                                   x86_64           2.1.0-0.31.rc3.2.osg24.el9      @epel                432 k
Removing dependent packages:
 osg-wn-client                          noarch           23-1.osg24.el9                 @osg                 211  

Transaction Summary
====================================================================================================================
Remove        2 Package(s)

Is this ok [y/N]: y
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running Transaction
  ... etc ...

Removed:
  voms-2.1.0-0.31.rc3.2.osg24.el9.x86_64

Complete!
```

Upgrading Packages
------------------

You can check for updates with `yum check-update`. For example:

``` console
root@host # yum check-update
Loaded plugins: kernel-module, priorities
957 packages excluded due to repository priority protections

kernel.x86_64                                            2.6.18-274.3.1.el5                           fermi-security
Obsoleting Packages
ocsinventory-agent.noarch                                1.1.2.1-1.el5                                epel          
    ocsinventory-client.noarch                           0.9.9-10                                     installed     
```

You can do the update with `yum update`. Note that in this case we got more than was listed due to dependencies that needed to be resolved:

``` console
root@host # yum update
957 packages excluded due to repository priority protections
Setting up Update Process
Resolving Dependencies
--> Running transaction check
---> Package kernel.x86_64 0:2.6.18-274.3.1.el5 set to be installed
---> Package ocsinventory-agent.noarch 0:1.1.2.1-1.el5 set to be updated
--> Processing Dependency: perl(Crypt::SSLeay) for package: ocsinventory-agent
--> Processing Dependency: perl(Proc::Daemon) for package: ocsinventory-agent
--> Processing Dependency: monitor-edid for package: ocsinventory-agent
--> Processing Dependency: perl(Net::IP) for package: ocsinventory-agent
--> Processing Dependency: nmap for package: ocsinventory-agent
--> Processing Dependency: perl(Net::SSLeay) for package: ocsinventory-agent
--> Running transaction check
---> Package monitor-edid.x86_64 0:2.5-1.el5.1 set to be updated
---> Package nmap.x86_64 2:4.11-1.1 set to be updated
---> Package perl-Crypt-SSLeay.x86_64 0:0.51-11.el5 set to be updated
---> Package perl-Net-IP.noarch 0:1.25-2.fc6 set to be updated
---> Package perl-Net-SSLeay.x86_64 0:1.30-4.fc6 set to be updated
---> Package perl-Proc-Daemon.noarch 0:0.03-1.el5 set to be updated
--> Finished Dependency Resolution
Beginning Kernel Module Plugin
Finished Kernel Module Plugin
--> Running transaction check
---> Package kernel.x86_64 0:2.6.18-238.1.1.el5 set to be erased
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================
 Package                        Arch               Version                         Repository                  Size
====================================================================================================================
Installing:
 kernel                         x86_64             2.6.18-274.3.1.el5              fermi-security              21 M
 ocsinventory-agent             noarch             1.1.2.1-1.el5                   epel                       156 k
     replacing  ocsinventory-client.noarch 0.9.9-10

Removing:
 kernel                         x86_64             2.6.18-238.1.1.el5              installed                   93 M
Installing for dependencies:
 monitor-edid                   x86_64             2.5-1.el5.1                     epel                        82 k
 nmap                           x86_64             2:4.11-1.1                      sl-base                    680 k
 perl-Crypt-SSLeay              x86_64             0.51-11.el5                     sl-base                     45 k
 perl-Net-IP                    noarch             1.25-2.fc6                      sl-base                     31 k
 perl-Net-SSLeay                x86_64             1.30-4.fc6                      sl-base                    192 k
 perl-Proc-Daemon               noarch             0.03-1.el5                      epel                       9.4 k

Transaction Summary
====================================================================================================================
Install       8 Package(s)
Upgrade       0 Package(s)
Remove        1 Package(s)
Reinstall     0 Package(s)
Downgrade     0 Package(s)

Total download size: 22 M
Is this ok [y/N]: y
Downloading Packages:
(1/8): perl-Proc-Daemon-0.03-1.el5.noarch.rpm                                                | 9.4 kB     00:00     
(2/8): perl-Net-IP-1.25-2.fc6.noarch.rpm                                                     |  31 kB     00:00     
(3/8): perl-Crypt-SSLeay-0.51-11.el5.x86_64.rpm                                              |  45 kB     00:00     
(4/8): monitor-edid-2.5-1.el5.1.x86_64.rpm                                                   |  82 kB     00:00     
(5/8): ocsinventory-agent-1.1.2.1-1.el5.noarch.rpm                                           | 156 kB     00:00     
(6/8): perl-Net-SSLeay-1.30-4.fc6.x86_64.rpm                                                 | 192 kB     00:00     
(7/8): nmap-4.11-1.1.x86_64.rpm                                                              | 680 kB     00:00     
(8/8): kernel-2.6.18-274.3.1.el5.x86_64.rpm                                                  |  21 MB     00:00     
--------------------------------------------------------------------------------------------------------------------
Total                                                                               3.5 MB/s |  22 MB     00:06     
warning: rpmts_HdrFromFdno: Header V3 DSA signature: NOKEY, key ID 217521f6
epel/gpgkey                                                                                  | 1.7 kB     00:00     
Importing GPG key 0x217521F6 "Fedora EPEL <epel@fedoraproject.org>" from /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL
Is this ok [y/N]: y
Running rpm_check_debug
Running Transaction Test
Finished Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing     : perl-Net-SSLeay                                                                             1/10 
  Installing     : nmap                                                                                        2/10 
  Installing     : monitor-edid                                                                                3/10 
  Installing     : perl-Crypt-SSLeay                                                                           4/10 
  Installing     : perl-Net-IP                                                                                 5/10 
  Installing     : perl-Proc-Daemon                                                                            6/10 
  Installing     : kernel                                                                                      7/10 
  Installing     : ocsinventory-agent                                                                          8/10 
ule, priorities
957 packages excluded due to repository priority protections

kernel.x86_64                                            2.6.18-274.3.1.el5                           fermi-security
Obsoleting Packages
ocsinventory-agent.noarch                                1.1.2.1-1.el5                                epel          
    ocsinventory-client.noarch                           0.9.9-10                                     installed     
  Erasing        : ocsinventory-client                                                                         9/10 
warning: /etc/ocsinventory-client/ocsinv.conf saved as /etc/ocsinventory-client/ocsinv.conf.rpmsave
  Cleanup        : kernel                                                                                     10/10 

Removed:
  kernel.x86_64 0:2.6.18-238.1.1.el5                                                                                

Installed:
  kernel.x86_64 0:2.6.18-274.3.1.el5                    ocsinventory-agent.noarch 0:1.1.2.1-1.el5                   

Dependency Installed:
  monitor-edid.x86_64 0:2.5-1.el5.1   nmap.x86_64 2:4.11-1.1                perl-Crypt-SSLeay.x86_64 0:0.51-11.el5  
  perl-Net-IP.noarch 0:1.25-2.fc6     perl-Net-SSLeay.x86_64 0:1.30-4.fc6   perl-Proc-Daemon.noarch 0:0.03-1.el5    

Replaced:
  ocsinventory-client.noarch 0:0.9.9-10                                                                             

Complete!
```

Advanced topic: Only geting OSG updates
---------------------------------------

If you only want to get updates from the OSG repository and *no other* repositories, you can tell yum to do that with the following command:

```console
root@host # yum --disablerepo=* --enablerepo=osg update
```

Advanced topic: Getting debugging information for installed software
---------------------------------------------------------------------

If you run into a problem with our software and have a hankering to debug it directly (or perhaps we need to ask you for some help), you can install so-called "debuginfo" packages. These packages will provide debugging symbols and source code so that you can do things like run `gdb` or `pstack` to get information about a program.

Installing the debuginfo package requires three steps.

1. Install the `yum-utils` package, which contains the `debuginfo-install` utility.

        :::console
        root@host # yum install yum-utils
        ...
        ====================================================================================================================
        Package                    Architecture            Version                           Repository               Size
        ====================================================================================================================
        Installing:
        yum-utils                  noarch                  4.3.0-5.el9_2                     baseos                   35 k

        Transaction Summary
        ====================================================================================================================
        Install  1 Package

        Total download size: 35 k
        Installed size: 23 k
        Is this ok [y/N]: y
        ...
        Installed:
          yum-utils-4.3.0-5.el9_2.noarch  

1.  Figure out which package installed the program you want to debug. One way to figure it out is to ask RPM. For example, if you want to debug grid-proxy-init:

        :::console
        user@host $ rpm -qf `which voms-proxy-init`
        voms-clients-cpp-2.1.0-0.27.rc3.el9.x86_64

1.  Install the debugging information for that package. Continuing this example: 

        :::console
        root@host # debuginfo-install voms-clients-cpp
        ...
        ====================================================================================================================
        Package                              Architecture     Version                       Repository                Size
        ====================================================================================================================
        Installing:
        voms-clients-cpp-debuginfo           x86_64           2.1.0-0.27.rc3.el9            epel-debuginfo           437 k
        voms-debugsource                     x86_64           2.1.0-0.27.rc3.el9            epel-debuginfo           195 k
        Installing dependencies:
        voms-debuginfo                       x86_64           2.1.0-0.27.rc3.el9            epel-debuginfo           928 k

        Transaction Summary
        ====================================================================================================================
        Install  3 Packages

        Total download size: 1.5 M
        Installed size: 6.0 M
        Is this ok [y/N]: y
        ...
        Installed:
          voms-clients-cpp-debuginfo-2.1.0-0.27.rc3.el9.x86_64           voms-debuginfo-2.1.0-0.27.rc3.el9.x86_64          
          voms-debugsource-2.1.0-0.27.rc3.el9.x86_64     

    This last step will select the right package name, then use `yum` to install it.

Troubleshooting
---------------

### Yum not finding packages

If you is not finding some packages, e.g.:

```text
Error Downloading Packages:
  packageXYZ: failure: packageXYZ.rpm from osg: [Errno 256] No more mirrors to try.
```

then you can try cleaning up Yum's cache:

```console
root@host # yum clean all --enablerepo=*
```

### Yum complaining about missing keys

If yum is complaining you can re-import the keys in your distribution:

```console
root@host # rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*
```

References
----------

- [The main Yum web site](http://yum.baseurl.org/)
- A good description of the commands for RPM and Yum can be found at [Learn Linux 101: RPM and Yum Package Management](https://developer.ibm.com/tutorials/l-lpic1-102-5/).

