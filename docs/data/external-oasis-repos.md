Install an OASIS Repository
===========================

OASIS (the **OSG** **A**pplication **S**oftware **I**nstallation **S**ervice) is an infrastructure, based on
[CVMFS](https://cvmfs.readthedocs.io), for distributing software throughout the OSG.  Once software is installed into
an OASIS repository, the goal is to make it available across about 90% of the OSG within an hour.

OASIS consists of keysigning infrastructure, a content distribution network (CDN), and a shared CVMFS repository that
is hosted by the OSG.  Many use cases will be covered by utilizing the [shared repository](update-oasis); this document
covers how to install, configure, and host your own CVMFS _repository server_.  This server will distribute software
via OASIS, but will be hosted and operated externally from the OSG project.

OASIS-based distribution and key signing is available to OSG VOs or repositories affiliated with an OSG VO.
See the [policy page](https://opensciencegrid.github.io/technology/policy/external-oasis-repos/) for more information
on what repositories OSG is willing to distribute.

Before Starting
---------------

CVMFS repositories work at the kernel filesystem layer, which adds more stringent host requirements than a typical
OSG install.  The host OS must meet ONE of the following:

-   RHEL 7.3 (or equivalent) or later.  **This option is recommended**.
-   RHEL 6 with the aufs kernel module.

Additionally,

-   **User IDs:** If it does not exist already, the installation will create the `cvmfs` Linux user
-   **Group IDs:** If they do not exist already, the installation will create the Linux groups `cvmfs` and `fuse`
-   **Network ports:** This page will configure the repository to distribute using Apache HTTPD on port 8000.  At the
    minimum, the repository needs in-bound access from the OASIS CDN.
-   **Disk space:** This host will need enough free disk space to host _two_ copies of the software: one compressed
    and one uncompressed. `/srv/cvmfs` will hold all the published data (compressed and de-deuplicated).  The
    `/var/spool/cvmfs` directory will contain all the data in all current transactions (uncompressed).
-   **Root access** will be needed to install.  Software install will be done as an unprivileged user.
-   **Yum** will need to be [configured to use the OSG repositories](../common/yum).

!!! warning "Overlay-FS limitations"
    CVMFS on RHEL7 only supports Overlay-FS if the underlying filesystem is `ext3` or `ext4`; make sure
    `/var/spool/cvmfs` is one of these filesystem types.

    If this is not possible, add `CVMFS_DONT_CHECK_OVERLAYFS_VERSION=yes` to your CVMFS configuration.  Using
    `xfs` will work if it was created with `ftype=1`

Installation
------------

### RHEL7-based Systems

For a RHEL7-based system, installation is a straightforward install via `yum`:

``` console
root@host # yum install cvmfs-server osg-oasis 
```

### RHEL6-based Systems

A RHEL6 host needs additional steps in order to add the AUFS2 kernel module.

``` console
root@host # rpm -i https://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-release-latest.noarch.rpm
root@host # yum install --enablerepo=cernvm-kernel --disablerepo=cernvm kernel aufs2-util cvmfs-server.x86_64 osg-oasis
root@host # reboot
```

### Apache and Repository Mounts

For all installs, we recommend mounting all the local repositories on startup:

```console
root@host # echo "cvmfs_server mount -a" >>/etc/rc.local
root@host # chmod +x /etc/rc.local
```

The Apache HTTPD service should be configured to listen on port 8000, have the `KeepAlive` option enabled, and be
started:

``` console
root@host # echo Listen 8000 >>/etc/httpd/conf.d/cvmfs.conf 
root@host # echo KeepAlive on >>/etc/httpd/conf.d/cvmfs.conf 
root@host # chkconfig httpd on 
root@host # service httpd start
```

!!! note "Check Firewalls"
    Make sure that port 8000 is available to the Internet.  Check the setting of the host- and site-level firewalls.
    The next steps will fail if the web server is not accessible.

Creating a Repository
---------------------

Prior to creation, the repository administrator will need to make two decisions:

-   **Select a repository name**; typically, this is derived from the VO or project's name and ends in
    `opensciencegrid.org`.  For example, the NoVA VO runs the repository `nova.opensciencegrid.org`.  For this section,
    we will use %RED%example.opensciencegrid.org%ENDCOLOR%.
-   **Select a repository owner**: Software publication will need to run by a non-`root` Unix user account; for this
    document, we will use %BLUE%LIBRARIAN%ENDCOLOR% as the account name of the repository owner.

The initial repository creation must be run as `root`:

    :::console
    root@host # echo -e "\*\\t\\t-\\tnofile\\t\\t16384" >>/etc/security/limits.conf
    root@host # ulimit -n 16384
    root@host # cvmfs_server mkfs -o %BLUE%LIBRARIAN%ENDCOLOR% %RED%example.opensciencegrid.org%ENDCOLOR%
    root@host # (echo Order deny,allow;echo Deny from all;echo Allow from 127.0.0.1;echo Allow from ::1;echo Allow from 129.79.53.0/24;echo Allow from 2001:18e8:2:6::/56) >/srv/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.htaccess

Here, we increase the number of open files allowed, create the repository using the `mkfs` command, and then limit the hosts that are allowed to access the repo to the OSG CDN.

Next, adjust the configuration in the repository as follows.  

    :::console
    root@host # cat >>/etc/cvmfs/repositories.d/%RED%example.opensciencegrid.org%ENDCOLOR%/server.conf <<xEOFx
    CVMFS_AUTO_TAG_TIMESPAN="2 weeks ago"
    CVMFS_IGNORE_XDIR_HARDLINKS=true
    CVMFS_GENERATE_LEGACY_BULK_CHUNKS=false
    CVMFS_AUTOCATALOGS=true
    CVMFS_ENFORCE_LIMITS=true
    CVMFS_FORCE_REMOUNT_WARNING=false
    xEOFx

Also, check the [cvmfs documentation](http://cvmfs.readthedocs.io/en/latest/cpt-repo.html#configuration-recommendation-by-use-case) for additional recommendations for special purpose repositories.

Now verify that the repository is readable over HTTP:

    :::console
    root@host # wget -qO- http://localhost:8000/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.cvmfswhitelist | cat -v

That should print several lines including some gibberish at the end.

Hosting a Repository on OASIS
-----------------------------

<!-- NOTE: these steps are referenced by the "Replacing an Existing
     OASIS Repository Server" section below and also on the
     operations/external-oasis-repos.md page, so if you change
     anything here check those to make sure they are still accurate.
  -->

In order to host a repository on OASIS, perform the following steps:

1.  **Verify your VO's OIM registration is up-to-date**.  All repositories need to be associated with a VO; the VO
    needs to assign an _OASIS manager_ in OIM who would be responsible for the contents of any of the VO's repositories
    and will be contacted in case of issues. To designate an OASIS manager, have the VO manager update the
    [OIM registration](https://oim.grid.iu.edu).

1.  Create a [support ticket](https://ticket.opensciencegrid.org/goc/submit) using the following template:

        Please add a new CVMFS repository to OASIS for VO %RED%voname%ENDCOLOR% using the URL 
            http://%RED%fully.qualified.domain%ENDCOLOR%:8000/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%
        The VO responsible manager will be %RED%OASIS Manager Name%ENDCOLOR%.

    Replace the %RED%red%ENDCOLOR% items with the appropriate values.

1.  If the repository name matches `*.opensciencegrid.org` or `*.osgstorage.org`, wait for the go-ahead from the OSG
    representative before continuing with the remaining instructions; for all other repositories (such as `*.egi.eu`),
    you are done.

1. One you are told in the ticket to proceed to the next step, execute the following commands:

        :::console
        root@host # wget -O /srv/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.cvmfswhitelist \
                    http://oasis.opensciencegrid.org/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.cvmfswhitelist 
        root@host # /bin/cp /etc/cvmfs/keys/opensciencegrid.org/opensciencegrid.org.pub \
                    /etc/cvmfs/keys/%RED%example.opensciencegrid.org%ENDCOLOR%.pub

    Replace %RED%example.opensciencegrid.org%ENDCOLOR% as appropriate.
    
1. Verify that publishing operation succeeds:

        :::console
        root@host # su %BLUE%LIBRARIAN%ENDCOLOR% -c "cvmfs_server transaction %RED%example.opensciencegrid.org%ENDCOLOR%"
        root@host # su %BLUE%LIBRARIAN%ENDCOLOR% -c "cvmfs_server publish %RED%example.opensciencegrid.org%ENDCOLOR%"

    Within an hour, the repository updates should appear at the GOC and FNAL Stratum-1 servers.

    On success, make sure the whitelist update happens daily by creating `/etc/cron.d/fetch-cvmfs-whitelist` with the
    following contents:
        
        :::
        5 4 * * * %BLUE%LIBRARIAN%ENDCOLOR% cd /srv/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR% && wget -qO .cvmfswhitelist.new http://oasis.opensciencegrid.org/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.cvmfswhitelist && mv .cvmfswhitelist.new .cvmfswhitelist

    !!! note
        This cronjob eliminates the need for the repository service administrator to periodically use
        `cvmfs_server resign` to update `.cvmfswhitelist` as described in the upstream CVMFS documentation.

1. Update the open support ticket to indicate that the previous steps have been completed

Once the repository is fully replicated on the OSG, the VO may proceed in publishing into CVMFS using the
%BLUE%LIBRARIAN%ENDCOLOR% account on the repository server.

!!! tip
    We strongly recommend the repository maintainer read through the upstream documentation on
    [maintaining repositories](http://cernvm.cern.ch/portal/filesystem/maintain-repositories) and
    [content limitations](http://cernvm.cern.ch/portal/filesystem/repository-limits).

If the repository ends in `.opensciencegrid.org`, the VO may ask for it to be replicated outside the US.  The
VO should open a GGUS ticket following EGI's [PROC20](https://wiki.egi.eu/wiki/PROC20).

Replacing an Existing OASIS Repository Server
---------------------------------------

If a need arises to replace a server for an existing `*.opensciencegrid.org` or `*.osgstorage.org` repository, there are two ways to do it:
one without changing the DNS name and one with changing it.
The latter can take longer because it requires GOC intervention.

!!! note "Revision numbers must increase"
    CVMFS does not allow repository revision numbers to decrease, so the instructions below make sure the revision numbers only go up.


### Without changing the server DNS name

If you are recreating the repository on the same machine, use the following command to 
remove the repository configuration while preserving the data and keys:

        :::console
        root@host # cvmfs_server rmfs -p example.opensciencegrid.org

Otherwise if it is a new machine, copy the keys from /etc/cvmfs/keys/%RED%example.opensciencegrid.org%ENDCOLOR%.* and the data from /srv/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR% from the old server to the new, making sure that no publish operations happen on the old server while you copy the data.

Then in either case use `cvmfs_server import` instead of `cvmfs_server mkfs` in the above instructions for [Creating the Repository](#creating-a-repository), in order to reuse old data and keys.

If you run an old and a new machine in parallel for a while, make sure that when you put the new machine into production (by moving the DNS name) that the new machine has had at least as many publishes as the old machine, so the revision number does not decrease.

### With changing the server DNS name

!!! note "Note"
    If you create a repository from scratch, as opposed to copying the data and keys from an old server, it is in fact better to change the DNS name of the server because that causes the GOC server to reinitialize the .cvmfswhitelist.

If you create a replacement repository on a new machine from scratch, follow the normal instructions on this page above, but with the following differences in the [Hosting a Repository on OASIS](#hosting-a-repository-on-oasis) section:

-   In step 2, instead of asking in the GOC ticket to create a new repository, give the new URL and ask them to change the repository registration to that URL.
-   When you do the publish in step 5, add a `-n NNNN` option where `NNNN` is a revision number greater than the number on the existing repository.
    That number can be found by this command on a client machine:

        :::console
        user@host $ attr -qg revision /cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%

-   Skip step 6; there is no need to tell the GOC when you are finished.
-   After enough time has elapsed for the publish to propagate to clients, typically around 15 minutes, verify that the new chosen revision has reached a client.

Removing a Repository from OASIS
--------------------------------

In order to remove a repository that is being hosted on OASIS, perform the following steps:

1.  If the repository has been replicated outside of the U.S., open a GGUS ticket asking that the replication be removed
    from EGI Stratum-1s. Wait until this ticket is resolved before proceeding.
2.  Open a [support ticket](https://ticket.opensciencegrid.org/goc/submit) asking to shut down the repository, giving the repository
    name (e.g., %RED%example.opensciencegrid.org%ENDCOLOR%), and the corresponding VO.

