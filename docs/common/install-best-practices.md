**Installation Best Practices**
===============================


About This Document
-------------------

This document covers best practices to be used in installing software packages or security certificates on large numbers of hosts. It assumes you understand [YUM/RPM Basics](../common/).



Install yum-priorities
----------------------

We use `yum` priorities to ensure that we get the right packages from the OSG repositories. Please install it:

``` screen
%UCL_PROMPT_ROOT% yum install yum-priorities
```

There is [good documentation](http://wiki.centos.org/PackageManagement/Yum/Priorities) in the wild about yum priorities, but we'll summarize the essential bits for you.

The basic idea of yum priorities is that if a package is found in two repositories, priorities will influence how yum chooses which package to install. We want the OSG software repository to be chosen instead of the EPEL repository so software, such as Globus, comes from our repository instead of the EPEL repository. (This is important because you will have installation errors if you get the EPEL Globus.)

Yum priorities is a *yum plugin*. Once enabled, you can set the priority of each repository (located in /etc/yum.repos.d) The lower the numerical priority, the better the priority. The default priority for a repository when it's not specified is 99. We set the priority for the OSG repository to be 98, as you can see here:

``` screen
% cat /etc/yum.repos.d/osg.repo
[osg]
name=OSG Software for Enterprise Linux 5 - $basearch
mirrorlist=http://repo.grid.iu.edu/mirror/osg-release/$basearch
failovermethod=priority
priority=%RED%98%ENDCOLOR%
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
```

You can adjust these priorities if you have special needs at your site.

Automatic Updates
-----------------

We strongly recommend against automatic updates for production services. You want to only change software versions during a controlled downtime (or, at least, while a human is watching); we strive to thoroughly test software updates, but cannot guarantee new version of software will not be problematic for your site.

For testbeds, automatic updates are suggested

Troubleshooting
---------------

Sometimes when installing, you will get an error like this:

``` screen
http://ftp1.scientificlinux.org/linux/scientific/54/x86_64/updates/security/repodata/filelists.sqlite.bz2: %RED%[Errno -1] Metadata file does not match checksum%ENDCOLOR%
```

This often indicates that you have out of date information, cached by `yum`. The following command will clear the out of date information, and you can try again:

``` screen
yum --enablerepo='*' clean all
```

Considerations for Large Sites
------------------------------

While `yum` is a wonderful tool for installing software on a single server, it's a poor tool to install the same version of the software on many hosts. We **strongly** recommend a cluster management tool; as far as we know, all cluster management tools provide a mechanism to create a local yum repository and have all your worker nodes use that.

If you have more than 20 worker nodes, we have the following advice:

-   Do **not** use one of the OSG repositories directly for worker node installations; build a local mirror instead. (See below).
-   Distribute CRLs to the worker nodes using an HTTP proxy.

Both items are covered in this document.

In the future, we will be providing a mechanism for distributing CAs and CRLs via a shared file system; this is not quite finished. If you choose to do this, remember that your security infrastructure will only be as safe and reliable as the shared filesystem!

Repository Mirrors
------------------

A local yum mirror allows you to reduce the amount of external bandwidth used when updating or installing packages.

Add the following to a file in `/etc/cron.d`:

``` screen
%RED%RANDOM%ENDCOLOR% * * * * root rsync -aH rsync://repo.grid.iu.edu/osg/ /var/www/html/osg/
```

Or, to mirror only a single repository:

``` screen
%RED%RANDOM%ENDCOLOR% * * * * root rsync -aH rsync://repo.grid.iu.edu/osg/3.1/el6/development /var/www/html/osg/3.1/el6
```

Replace %RED%RANDOM<span class="twiki-macro ENDCOLOR"></span> with a number between 0 and 59.

On your worker node, you can replace the `baseurl` line of `/etc/yum.repos.d/osg.repo` with the appropriate URL for your mirror.

If your osg\*.repo files still point to the legacy 3.0 repo layout (eg, /3.0/el5/osg-release/ instead of the new /osg/3.1/el5/release/), they can be updated to point to the new 3.1 layout by installing the latest version of the 'osg-release' package:

``` screen
yum update --enablerepo=osg-testing osg-release
```

If you are interested in having your mirror be part of the OSG's default set of mirrors, [please file a GOC ticket](https://ticket.grid.iu.edu/).

CA Certificate Installation Considerations
------------------------------------------

CAs are distributed in two ways:

-   As an RPM that contains the set of CAs. There are several such RPMs corresponding to different sets of CAs.
-   Through direct downloads from GOC with the `osg-update-certs` tool (provided by the `osg-ca-scripts` RPM).

As long as you use one of these two mechanisms, the OSG software will install successfully.

Certificate Revocation List (CRL) Installation/Update
-----------------------------------------------------

CRLs are not distributed via `yum`. Instead, we provide the `fetch-crl` tool that downloads CRLs to the CA directory.

<span class="twiki-macro INCLUDE" section="FetchCRLConfigProxy">InstallCertAuth</span>

Removing Large numbers of RPMs
------------------------------

Note that, in general, there is no mechanism to reverse a `yum install` command in RHEL5. Plan accordingly.

We have prepared a [special yum plugin](RemoveOSGComponents), `yum-remove-osg`, to assist in removing OSG RPMs.

To re-iterate: just because it removes most/all of the OSG RPMs, `yum remove` is not guaranteed to be a perfect reversal of `yum install` (things like post-scripts have side-effects that must be taken into account; these are not in general reversible). On the upside, removal of the RPMs will be "good enough" for many sites.

If you need a bit-for-bit, exact replica of your system prior to the upgrade, you'll want to use a backup strategy and restore from backup.

Comments
--------

<span class="twiki-macro COMMENT" type="tableappend"></span>

-- Main.JamesWeichel - 29 Aug 2011
