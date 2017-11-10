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

Create a Repository
-------------------

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
    root@host # echo "CVMFS_AUTO_TAG=false" >>/etc/cvmfs/repositories.d/%RED%example.opensciencegrid.org%ENDCOLOR%/server.conf
    root@host # (echo Order deny,allow;echo Deny from all;echo Allow from 127.0.0.1;echo Allow from ::1;echo Allow from 129.79.53.0/24;echo Allow from 2001:18e8:2:6::/56) >/srv/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.htaccess

Here, we increase the number of open files, create the repository using the `mkfs` command, adjust the configuration,
and then limit the hosts that are allowed to access the repo to the OSG CDN.

!!! warning "Hardlink Limitations on EL6"
    If you might be hosting any hardlinks that span directories (e.g. publishing a `git` repository) and are using
    EL6 with aufs, make the following configuration change:

        :::console
        root@host # echo "CVMFS_IGNORE_XDIR_HARDLINKS=true" >>/etc/cvmfs/repositories.d/repo.domain.name/server.conf

Verify that the repository is readable over HTTP:

    :::console
    root@host # wget -qO- http://localhost:8000/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.cvmfswhitelist | cat -v

That should print several lines including some gibberish at the end.

Host a Repository on OASIS
------------------------

1.  **Verify your VO's OIM registration is up-to-date**.  All repositories need to be associated with a VO; the VO
    needs to assign an _OASIS manager_ in OIM who would be responsible for the contents of any of the VO's repositories
    and will be contacted in case of issues. To designate an OASIS manager, have the VO manager update the
    [OIM registration](https://oim.grid.iu.edu).

2.  The repository administrator should **create a [support ticket](https://ticket.opensciencegrid.org/goc/submit)**
    using the following template:

        Please add a new CVMFS repository to OASIS for VO %RED%voname%ENDCOLOR% using the URL 
            http://%RED%fully.qualified.domain%ENDCOLOR%:8000/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%
        by doing step #3 at
            https://opensciencegrid.github.io/docs/data/external-oasis-repos
        The VO responsible manager will be %RED%OASIS Manager Name%ENDCOLOR%.

    Replace the %RED%red%ENDCOLOR% items with the appropriate values.

3.  (**OSG internal step**)
    OSG Operations ensures that the repository administrator is valid for the VO. This can be done by (a) OSG
    already having a relationship with the person or (b) the GOC representative contacting the VO manager to find out.
    OSG Operations should review the URL to verify it is appropriate for the VO.  This typically takes one business day.

4.  (**OSG internal step**)
    The OSG representative adds the repository URL in OIM under the VO's OASIS repository URLs. This should cause
    the repository's configuration to be added to the GOC Stratum-0 within 15 minutes.

5.  (**OSG internal step**) If the respository ends in a new
    domain name that has not been distributed before, the OSG representative next places a copy of the `domain.name.pub`
    public key from `domain.name` into `/srv/etc/keys` on both `oasis-replica` and `oasis-replica-itb`. If the OSG
    representative does not have that key, he or she will ask the repository service representative how to obtain it.
    In order to support CVMFS client versions 2.2.X, a symbolic link of `domain.name.conf` has to be made in
    `/cvmfs/config-osg.opensciencegrid.org/etc/cvmfs/domain.d` pointing to `default.conf`. This symbolic link has to be
    created on the `oasis-itb` machine's copy of the `config-osg.opensciencegrid.org` repository and then copied to
    production with the `copy_config_osg` command on the oasis machine.

6.  If the repository name matches `*.opensciencegrid.org` or `*.osgstorage.org`, the OSG representative responds in
    the ticket to ask that step \#6 be done; all other repositories (such as `*.egi.eu`) skip this step.

    The repository administrator should **execute the following commands**:

        :::console
        root@host # wget -O /srv/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.cvmfswhitelist \
                    http://oasis.opensciencegrid.org/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%/.cvmfswhitelist 
        root@host # /bin/cp /etc/cvmfs/keys/opensciencegrid.org/opensciencegrid.org.pub \
                    /etc/cvmfs/keys/%RED%example.opensciencegrid.org%ENDCOLOR%.pub

    Replace %RED%example.opensciencegrid.org%ENDCOLOR% as appropriate.  Next, the repository administrator should
    verify that publishing operation succeed:

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

    The repository administrator should update the open support ticket and ask to proceed to step \#7.


7.  (**OSG internal step**)
    The OSG representative then asks the administrator of the BNL stratum 1 to also add the new repository.
    The BNL Stratum-1 operator should set the service to read from
    `http://oasis-replica.opensciencegrid.org:8000/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%`.
    When the BNL Stratum-1 operator has reported back that the replication is ready, the OSG representative reports in
    the ticket that the repository is fully replicated on the OSG and closes the ticket.

Once the repository is fully replicated on the OSG, the VO may proceed in publishing into CVMFS using the
%BLUE%LIBRARIAN%ENDCOLOR% account on the repository server.

!!! tip
    We strongly recommend the repository maintainer read through the upstream documentation on
    [maintaining repositories](http://cernvm.cern.ch/portal/filesystem/maintain-repositories) and
    [content limitations](http://cernvm.cern.ch/portal/filesystem/repository-limits).

If the repository ends in `.opensciencegrid.org`, the VO may ask for it to be replicated outside the US.  The
VO should open a GGUS ticket following EGI's [PROC20](https://wiki.egi.eu/wiki/PROC20).

Change the URL of an external repository
----------------------------------------

If necessary, it is possible to change the URL of the repository server; simply have the repository administrator
open a support ticket with the new value, and OSG operations will update OIM's OASIS repository URL for the VO.
The GOC Stratum-1 will then be updated within an hour.

Remove an external repository
-----------------------------

1.  If the repository has been replicated outside of the U.S., the repository service administrator should open a GGUS
    ticket asking that the replication be removed from EGI Stratum-1s. Wait until this ticket is resolved before
    proceeding.
2.  The repository administrator opens an OSG support ticket asking to shut down the repository, giving the repository
    name (e.g., %RED%example.opensciencegrid.org%ENDCOLOR%) and the corresponding VO.
3.  (**OSG internal step**)
    After validating the ticket submitter is authorized by the VO's OASIS manager, the OSG representative next deletes
    the registered value for %RED%example.opensciencegrid.org%ENDCOLOR% in OIM for the VO in OASIS Repo URLs. 
4.  (**OSG internal step**)
    The OSG representative adds the FNAL and BNL Stratum-1 operators to the ticket to asks them to remove the
    repository.  Wait for the Stratum-1 operators to finish before proceeding.
5.  (**OSG internal step**)
    The OSG representative then runs `cvmfs_server rmfs -f %RED%example.opensciencegrid.org%ENDCOLOR%`
    and `rm -r /oasissrv/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%` on `oasis-replica-itb` and `oasis-replica`
6.  (**OSG internal step**)
    The OSG representative does `rm -r /srv/cvmfs/%RED%example.opensciencegrid.org%ENDCOLOR%` on `oasis-itb` and
    `oasis`.

Procedure to blank an externally-hosted repository
--------------------------------------------------

!!! note
    This is an OSG-internal procedure

1.  If there is a request from OSG Security to shut down the distribution of a repository, the OSG representative
    needs to run `blank_osg_repository` on `oasis-replica` and give it the full name of the repository. This will
    rename the repository directories to a name with the current timestamp and replace it with a blank repository.
    It includes a step to run on the `oasis` machine, and attempts to do it with `ssh`, but if that fails it prints
    instructions on how to finish by logging in to the `oasis` machine manually.
2.  When it is time to put the repository back into production, the GOC representative runs `unblank_osg_repository`
    on `oasis-replica` and gives it the full name of the repository again. This will find the directory with the old
    timestamp and put it back into service. This step also attempts to `ssh` to the `oasis` machine.
