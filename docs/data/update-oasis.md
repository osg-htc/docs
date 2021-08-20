DateReviewed: 2021-08-20

Updating Software in OASIS
==========================

OASIS is the OSG Application Software Installation Service that can be used to publish and update software on OSG Worker
Nodes under `/cvmfs/oasis.opensciencegrid.org`.
It is implemented using CernVM FileSystem (CVMFS) technology and is the recommended method to install software on the
Open Science Grid.

This document is a step by step explanation of how a member of a Virtual Organization (VO) can become an OASIS manager
for their VO and gain access to the shared OASIS service for software management.
The shared OASIS service is especially appropropriate for VOs that have a relatively small number of members and a
relatively small amount of software to distribute.
Larger VOs should consider [hosting their own separate repositories](external-oasis-repos.md).

!!! note
    For information on how to configure an OASIS client [CVMFS installation documentation](../worker-node/install-cvmfs.md).

Requirements
------------

To begin the process to distribute software on OASIS using the service, you must:

-   Register as an [OSG contact](https://opensciencegrid.org/technology/policy/comanage-instructions-user/) and
    upload your SSH Key
-   Submit a request to <help@opensciencegrid.org> to become an OASIS manager with the following:
    -   The names of the [VO(s)](https://github.com/opensciencegrid/topology/tree/master/virtual-organizations) whose
        software that you would like to manage with the shared OASIS login host
    -   CC a member of the VO(s) that can verify your affiliation
    -   Any other VO members that should be OASIS managers

How to use OASIS
----------------

### Log in with SSH ###

The shared OASIS login server is accessible via SSH for all OASIS managers with registered SSH keys:

``` consolem
user@host $ ssh -i <PATH TO SSH KEY> ouser.<VO>@oasis-login.opensciencegrid.org
```

Change `<VO>` for the name of the Virtual Organization you are trying to access and `<PATH TO SSH KEY>` with the path to
the private part of the SSH key whose public part you
[registered with the OSG](https://opensciencegrid.org/technology/policy/comanage-instructions-user/#oasis-managers-adding-an-ssh-key).

Instead of putting `-i <PATH TO SSH KEY>` or `ouser.<VO>@` on the command line, you can put it in your `~/.ssh/config`:

``` console
Host oasis-login.opensciencegrid.org
User ouser.<VO>
IdentityFile <PATH TO SSH KEY>
```

### Install and update software ###

Once you log in, you can add/modify/remove content on a staging area at `/stage/oasis/$VO` where $VO is the name of the VO represented by the manager.

Files here are visible to both `oasis-login` and the Stratum 0 server (oasis.opensciencegrid.org).  There is a symbolic link at `/cvmfs/oasis.opensciencegrid.org/$VO` that points to the same staging area.  

Request an oasis publish with this command:

``` console
user@host $ osg-oasis-update
```

This command queues a process to sync the content of OASIS with the content of `/stage/oasis/$VO`

`osg-oasis-update` returns immediately, but only one update can run at a time (across all VOs); your request may be queued behind a different VO. If you encounter severe delays before the update is finished being published (more than 4 hours), please file a [support ticket](../common/help.md).

### Limitations on repository content ###

Although CVMFS provides a POSIX filesystem, it does not work well with all types of content. Content in OASIS is expected to adhere to the [CVMFS repository content limitations](http://cvmfs.readthedocs.io/en/stable/cpt-repo.html#limitations-on-repository-content) so please review those guidelines carefully.

### Testing ###

After `osg-oasis-update` completes and the changes have been propagated to the CVMFS stratum 1 servers (typically between 0 and 60 minutes, but possibly longer if the servers are busy with updates of other repositories) then the changes can be visible under `/cvmfs/oasis.opensciencegrid.org` on a computer that has the [CVMFS client installed](../worker-node/install-cvmfs.md). A client normally only checks for updates if at least an hour has passed since it last checked, but people who have superuser access on the client machine can force it to check again with

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
