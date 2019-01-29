Updating Software in OASIS
==========================

OASIS is the OSG Application Software Installation Service. It is the recommended method to install software on the Open Science Grid. It is implemented using CernVM FileSystem (CVMFS) technology.

This document is a step by step explanation of how a Virtual Organization (VO) Software Adminstrator can enable the OASIS service and use it to publish and update software on OSG Worker Nodes under `/cvmfs/oasis.opensciencegrid.org`.

!!! note
    -   For information on how to configure a client for OASIS see the [CVMFS installation documentation](../worker-node/install-cvmfs).
    -   For information on hosting your own repository see the [OASIS repository installation](external-oasis-repos).

Requirements
------------

To begin the process to distribute software on OASIS using the service hosted by OSG Operations, you must:

-   [Obtain a personal grid certificate](../security/user-certs), if you don't have one already.
-   Register yourself in the OSG Information Management System (OIM) by sending an email to
    <mailto:help@opensciencegrid.org)
-   Be associated with a [VO registered in OIM](https://github.com/opensciencegrid/topology/tree/master/virtual-organizations).

How to use OASIS
----------------

### Enable OASIS ###

When you are ready to distribute your software with OASIS, submit a [support ticket](https://support.opensciencegrid.org/helpdesk/tickets/new) with a request to enable OASIS for your VO. In your request, please specify your VO and provide a list of people who will install and administer the VO software in OASIS.

OSG Operations will enable OASIS for your VO in [OSG topology](https://github.com/opensciencegrid/topology#topology) and add your list of administrators to the "OASIS Managers" list (which is near the bottom of the page of information about each VO in OIM). oasis-login will then grant access to the people who are listed as OASIS managers. Any time the list is to be modified, submit another ticket.

### Log in with GSISSH ###

The next step is to generate a proxy and log into `oasis-login.opensciencegrid.org` with `gsissh`. These commands should be run on a computer that has the [OSG worker node client](../worker-node/install-wn) software. First make sure that your grid certificate is installed in `~/.globus/usercred.p12` on that computer and that it is mode 600, then run these commands:

``` console
user@host $ voms-proxy-init
user@host $ gsissh -o GSSAPIDelegateCredentials=yes oasis-login.opensciencegrid.org
```

In case the user can be mapped to more than one account, specify it explicitly in a command like this

``` console
user@host $ gsissh -o GSSAPIDelegateCredentials=yes ouser.%RED%VO%ENDCOLOR%@oasis-login.opensciencegrid.org
```

Instead of putting `-o GSSAPIDelegateCredentials=yes` on the command line, you can put it in your `~/.ssh/config` like this:

``` console
Host oasis-login.opensciencegrid.org
    GSSAPIDelegateCredentials yes
```

### Install and update software ###

Once you log in, you can add/modify/remove content on a staging area at `/stage/oasis/$VO` where $VO is the name of the VO represented by the manager.

Files here are visible to both `oasis-login` and the Stratum 0 server (oasis.opensciencegrid.org).  There is a symbolic link at `/cvmfs/oasis.opensciencegrid.org/$VO` that points to the same staging area.  

Request an oasis publish with this command:

``` console
user@host $ osg-oasis-update
```

This command queues a process to sync the content of OASIS with the content of `/stage/oasis/$VO`

`osg-oasis-update` returns immediately, but only one update can run at a time (across all VOs); your request may be queued behind a different VO. If you encounter severe delays before the update is finished being published (more than 4 hours), please file a [support ticket](/common/help).

### Limitations on repository content ###

Although CVMFS provides a POSIX filesystem, it does not work well with all types of content. Content in OASIS is expected to adhere to the [CVMFS repository content limitations](http://cvmfs.readthedocs.io/en/stable/cpt-repo.html#limitations-on-repository-content) so please review those guidelines carefully.

### Testing ###

After `osg-oasis-update` completes and the changes have been propagated to the CVMFS stratum 1 servers (typically between 0 and 60 minutes, but possibly longer if the servers are busy with updates of other repositories) then the changes can be visible under `/cvmfs/oasis.opensciencegrid.org` on a computer that has the [CVMFS client installed](../worker-node/install-cvmfs). A client normally only checks for updates if at least an hour has passed since it last checked, but people who have superuser access on the client machine can force it to check again with

``` console
root@host # cvmfs_talk -i oasis.opensciencegrid.org remount
```

This can be done while the filesystem is mounted (despite the name, it does not do an OS-level umount/mount of the filesystem). If the filesystem is not mounted, it will automatically check for new updates the next time it is mounted.

In order to find out if an update has reached the CVMFS stratum 1 server, you can find out the latest `osg-oasis-update` time seen by the stratum 1 most favored by your CVMFS client with the following long command on your client machine:

``` console
user@host $ date -d "1970-1-1 GMT + $(wget -qO- $(attr -qg host /cvmfs/oasis.opensciencegrid.org)/.cvmfspublished | \
                                                            cat -v|sed -n '/^T/{s/^T//p;q;}') sec"
```

References
----------

[CVMFS Documentation](https://cvmfs.readthedocs.io/en/stable/)
