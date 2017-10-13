Updating Software on OASIS
==========================

OASIS is the OSG Application Software Installation Service. It is the recommended method to install software on the Open Science Grid. It is implemented using CernVM FileSystem (CVMFS) technology.

!!! note
    The applicable software versions for this document are **osg-version 3.1.13** (or higher)

This document is a step by step explanation of how a Virtual Organization (VO) Software Adminstrator can enable the OASIS service and use it to publish and update software on OSG Worker Nodes under /cvmfs/oasis.opensciencegrid.org. For information on how to configure a client for OASIS see the [OSG CVMFS Installation documentation](../worker-node/install-cvmfs). For information on hosting your own opensciencegrid.org repository see OasisExternalRepositories.

Requirements
------------

To begin the process to distribute software on OASIS using the service hosted at the OSG GOC, you must:

-   have a personal grid certificate. The process for getting one is detailed [here](https://www.opensciencegrid.org/bin/view/Documentation/Release3/CertificateUserGet).
-   register that certificate in [OIM](http://oim.opensciencegrid.org/oim/home). In order to register, the certificate has to be installed in your browser. If you are then not registered, clicking "Login" on the page will prompt you to register.
-   be associated with a VO that is registered in OIM. The list of registered VOs appears [here](http://oim.opensciencegrid.org/oim/vo).
-   register your certificate in the VOMS for your Virtual Organization. Click on the VO name that you're associated with in the above list and in the VO page click on the *"Membership Services URL"* to register with that VO VOMS.

How to use OASIS
----------------

### Enable OASIS ###

When you are ready to distribute your software with OASIS, submit a [GOC ticket](https://ticket.opensciencegrid.org/goc/submit) with a request to enable OASIS for your VO. In your request, please specify your VO and provide a list of people who will install and administer the VO software in OASIS.

The GOC will enable OASIS for your VO in [OIM](https://oim.opensciencegrid.org/oim/home) and add your list of administrators to the "OASIS Managers" list (which is near the bottom of the page of information about each VO in OIM). oasis-login will then grant access to the people who are listed as OASIS managers. Any time the list is to be modified, submit another GOC ticket.

### Log in with GSISSH ###

The next step is to generate a proxy and log into `oasis-login.opensciencegrid.org` with `gsissh`. These commands should be run on a computer that has the [OSG worker node client](../worker-node/install-wn) software. First make sure that your grid certificate is installed in `~/.globus/usercred.p12` on that computer and that it is mode 600, then run these commands:

``` console
user@host $ voms-proxy-init -voms %RED%VO%ENDCOLOR%
user@host $ gsissh -o GSSAPIDelegateCredentials=yes oasis-login.opensciencegrid.org
```

In case the user can be mapped to more than one account, specify it explicitly in a command like this

``` console
user@host $ gsissh -o GSSAPIDelegateCredentials=yes ouser.%RED%VO%ENDCOLOR%@oasis-login.opensciencegrid.org
```

Instead of putting <verbatim>-o GSSAPIDelegateCredentials`yes</verbatim> on the command line, you can put it in your =~/.ssh/config` like this:

``` console
Host oasis-login.opensciencegrid.org
    GSSAPIDelegateCredentials yes
```

### Install and update software ###

Once you log in, you can add/modify/remove content on a staging area at `/stage/oasis/$VO` where $VO is the name of the VO represented by the manager.

Files here are visible to both `oasis-login` and the Stratum 0 server (oasis.opensciencegrid.org)

NOTE that `/stage/oasis/$VO` is not your home directory, which you can use for staging purposes but is not visible in OASIS.

As OASIS manager for the VO requests an oasis update with:

``` console
user@host $ osg-oasis-update
```

This command queues a process to sync the content of OASIS with the content of `/stage/oasis/$VO`

`osg-oasis-update` returns immediately, but only one update can run at a time (across all VOs); your request may be queued behind a different VO. If you encounter severe delays before the update is finished being published (more than 4 hours), please file a GOC ticket.

### Limitations on repository content ###

Although CVMFS provides a POSIX filesystem, it does not work well with all types of content. Content in OASIS is expected to adhere to the [CVMFS repository content limitations](http://cernvm.cern.ch/portal/filesystem/repository-limits) so please review those guidelines carefully.

### Testing ###

After `osg-oasis-update` completes and the changes have been propagated to the CVMFS stratum 1 servers (typically between 0 and 60 minutes, but possibly longer if the servers are busy with updates of other repositories) then the changes can be visible under `/cvmfs/oasis.opensciencegrid.org` on a computer that has the [CVMFS client installed](../worker-node/install-cvmfs). A client normally only checks for updates if at least an hour has passed since it last checked, but people who have superuser access on the client machine can force it to check again with

``` console
root@host # cvmfs_talk -i oasis.opensciencegrid.org remount
```

This can be done while the filesystem is mounted (despite what the name sounds like it does not do umount/mount). If the filesystem is not mounted, it will automatically check for new updates the next time it is mounted.

In order to find out if an update has reached the CVMFS stratum 1 server, you can find out the latest `osg-oasis-update` time seen by the stratum 1 most favored by your CVMFS client with the following long command on your client machine:

``` console
user@host $ date -d "1970-1-1 GMT + $(wget -qO- $(attr -qg host /cvmfs/oasis.opensciencegrid.org)/.cvmfspublished | \
                                                            cat -v|sed -n '/^T/{s/^T//p;q;}') sec"
```

References
----------

[CERN CVMFS home page](https://twiki.cern.ch/twiki/bin/view/CvmFS)


