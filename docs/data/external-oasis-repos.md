Procedures for handling OASIS externally-hosted CVMFS repositories
==================================================================

**Technical information contained here is believed to be reliable but administrative procedures, particularly as concerns organizational entities outside the OSG, should be considered unapproved proposals.**


About OASIS
-----------

OASIS is the OSG Application Software Installation Service. It is the recommended method to install software on the Open Science Grid. It is implemented using CernVM FileSystem (CVMFS) technology.

About this Document
-------------------

This document describes the detailed procedures for dealing with CVMFS repositories that are part of the OASIS system but are not hosted at the OSG Global Operations Center (GOC). Rather, they are hosted at the home institution of a Virtual Organization (VO). The procedures include the steps performed by both the GOC and by the repository service administrator. If you are only interested in using an OASIS repository that is hosted at the GOC, see [this document](update-oasis) instead.

Policies
--------

These are the policies regarding OSG CVMFS repositories:

1.  The GOC will not host VO-specific CVMFS repositories. This means it will not use its machines to publish files to a repository that is dedicated to a VO. The GOC hosts one and only one repository and that is oasis.opensciencegrid.org.
2.  The GOC will replicate an external repository of a VO or provide access to use oasis.opensciencegrid.org per the existing mechanisms but not both for a given VO.
3.  Quotas on size of repos may be implemented at the discretion of the GOC. A minimum of 100 GB per VO/repo is guaranteed, larger limits may be requested.
4.  The fully qualified repository names of CVMFS repositories distributed to the OSG may be in any domain, but only those in the opensciencegrid.org domain may be requested to be exported to the European grid EGI at this time. There must be one secured master key for all the repositories in a domain. (Although note that the OSG OASIS servers replace that key with their own when distributing non-opensciencegrid.org repositories to OSG sites.)

Requirements: setting up a CVMFS repository server
--------------------------------------------------

This document doesn't cover requirements for the GOC computers since those are already set up. The requirements for a CVMFS repository server are that it have installed cvmfs-server and cvmfs client, both version 2.2.2 or greater; version 2.3.3 or greater is recommended on EL6 and required on EL7. This requires using aufs or OverlayFS: aufs requires a modified kernel from CERN for Redhat EL6-based systems, and OverlayFS requires at least EL7.3; the latter uses a standard kernel so it is highly recommended. Also an apache httpd server needs to be enabled. NOTE: multiple cvmfs repositories can be hosted on the same machine.

`/srv/cvmfs` will hold all the published data, so make sure it is large enough to hold all the repositories hosted on the machine. `/var/spool/cvmfs` will hold files during publish, so it should be large enough to hold the most amount of data that might be attempted to be published at once. In addition, on EL7 and cvmfs-server-2.4.1, `/var/spool/cvmfs` needs to be of filesystem type 'ext3' or 'ext4', or the `cvmfs_server` command will not allow it. There is a variable to override the filesystem type check, but other filesystem types are not guaranteed to work (xfs created with `ftype=1` should work with `CVMFS_DONT_CHECK_OVERLAYFS_VERSION=yes`).

This is a procedure for installing it on a Redhat EL6-based system:

``` console
root@host # rpm -i https://cvmrepo.web.cern.ch/cvmrepo/yum/cvmfs-release-latest.noarch.rpm 
root@host # rpm -i https://repo.grid.iu.edu/osg/3.4/osg-3.4-el6-release-latest.rpm 
root@host # yum install --enablerepo=cernvm-kernel --disablerepo=cernvm kernel aufs2-util cvmfs-server.x86_64 cvmfs.x86_64 cvmfs-config-osg 
root@host # echo "cvmfs_server mount -a" >>/etc/rc.local 
root@host # reboot</pre>
```
<br/>
This is the procedure for installing on a Redhat EL7-based system:

``` console
root@host # rpm -i https://repo.grid.iu.edu/osg/3.4/osg-3.4-el7-release-latest.rpm 
root@host # yum install cvmfs-server.x86_64 osg-oasis 
root@host # echo "cvmfs_server mount -a" >>/etc/rc.local
root@host # chmod +x /etc/rc.local</pre>
```
<br/>
In addition, apache should listen on port 8000, have KeepAlive enabled, and be started. Use commands like these:

``` console
root@host # echo Listen 8000 >>/etc/httpd/conf.d/cvmfs.conf 
root@host # echo KeepAlive on >>/etc/httpd/conf.d/cvmfs.conf 
root@host # chkconfig httpd on 
root@host # service httpd start
```
<br/>
Make sure that port 8000 is available to the internet through any firewalls.

Procedure to add an externally-hosted repository to OASIS
---------------------------------------------------------

1.  A VO representative who will have responsibility for the contents of the repository chooses a name for the repository. This name should be the name of the VO or be derived from it (or a project in the VO for the case of the OSG VO), and in a domain that has a secured master key. The recommended domain name for a new repository that originates at an OSG site is opensciencegrid.org. The full name used as an example in this document is **repo.domain.name**. Note: the VO representative's name will be registered in OIM as an OASIS manager for the VO, and names can be added or changed later with GOC tickets. If there is more than one repository for the VO, all the OASIS managers are assumed to be contacts for all the repositories.

2.  Using whatever mechanism is appropriate at their institution, the VO representative requests the local CVMFS repository service administrator to create this repository called `repo.domain.name`.

3.  The repository service administrator creates the repository with these command like these, where ownerid is the user id that will have write access:

        :::console
        root@host # echo -e "\*\\t\\t-\\tnofile\\t\\t16384" >>/etc/security/limits.conf 
        root@host # ulimit -n 16384 
        root@host # cvmfs_server mkfs -o ownerid repo.domain.name 
        root@host # echo "CVMFS_AUTO_TAG=false" >>/etc/cvmfs/repositories.d/repo.domain.name/server.conf 
        root@host # (echo Order deny,allow;echo Deny from all;echo Allow from 127.0.0.1;echo Allow from ::1;echo Allow from 129.79.53.0/24;echo Allow from 2001:18e8:2:6::/56) >/srv/cvmfs/repo.domain.name/.htaccess

    <br/>
    If you might be hosting any hardlinks that span directories (e.g. the git package) and are using aufs (that is, EL6), also do the following:

        :::console
        root@host # echo "CVMFS_IGNORE_XDIR_HARDLINKS=true" >>/etc/cvmfs/repositories.d/repo.domain.name/server.conf

    <br/>
    Verify that the repository is readable over http with the following command:

        :::console
        root@host # wget -qO- http://localhost:8000/cvmfs/repo.domain.name/.cvmfswhitelist|cat -v

    That should print several lines including some gibberish at the end.

4.  The repository service administrator next creates a [GOC ticket](https://ticket.opensciencegrid.org/goc/submit) using the following format:

        Please add a new CVMFS repository to OASIS for VO voname using the URL 
            http://fully.qualified.domain:8000/cvmfs/repo.domain.name 
        by doing step #5 at
            https://opensciencegrid.github.io/docs/data/external-oasis-repos
        The VO responsible manager will be Vorep Name.

    replacing "voname" with the VO's name, "fully.qualified.domain" with the full name of the repository server, "repo.domain.name" with the full name of the repository, and "Vorep Name" with the name of the VO representative.

5.  The GOC representative next ensures that the repository service administrator is a valid representative of a host site for the VO. This can be done by (a) the GOC representative already having a relationship with the person or (b) the GOC representative contacting the VO manager to find out. The GOC representative makes sure that the repo.domain.name in the URL is derived from the VO name. 

6.  The GOC representative then adds the URL in OIM under OASIS Repo URLs for the VO. The repository will then be added to the GOC stratum 0 within 15 minutes.  Within an hour after step 8 is completed, the repository should also be automatically added to the GOC and FNAL stratum 1s.

7.  If domain.name is a new domain that has not been distributed before, the GOC representative next places a copy of the domain.name.pub public key from domain.name into /srv/etc/keys on both oasis-replica and oasis-replica-itb. If the GOC representative does not have that key, he or she can ask the repository service representative in the ticket how to get it. In addition, in order to support cvmfs client versions 2.2.X (both older and newer clients do not need it), a symbolic link of `domain.name`.conf has to be made in /cvmfs/config-osg.opensciencegrid.org/etc/cvmfs/domain.d pointing to default.conf. This symbolic link has to be created on the oasis-itb machine's copy of the config-osg.opensciencegrid.org repository and then copied to production with the `copy_config_osg` command on the oasis machine.

8.  If the repository name matches `*.opensciencegrid.org` or `*.osgstorage.org`, the GOC representative responds in the ticket to ask that step \#8 be done; all other repositories (such as `*.egi.eu`) skip this step. The repository service administrator next executes the following commands (replacing repo.opensciencegrid.org with repo.osgstorage.org when needed):

        :::console
        root@host # wget -O /srv/cvmfs/repo.opensciencegrid.org/.cvmfswhitelist http://oasis.opensciencegrid.org/cvmfs/repo.opensciencegrid.org/.cvmfswhitelist 
        root@host # /bin/cp /etc/cvmfs/keys/opensciencegrid.org/opensciencegrid.org.pub /etc/cvmfs/keys/repo.opensciencegrid.org.pub

    <br/>
    Next the administrator verifies that a publish operation using the owner's privileges succeeds by making sure there's no errors from the following commands replacing "ownerid" with the owner's username:

        :::console
        root@host # su ownerid -c "cvmfs_server transaction repo.opensciencegrid.org" 
        root@host # su ownerid -c "cvmfs_server publish repo.opensciencegrid.org"

    If that works then add the wget command to a daily cron:
        
        :::console
        root@host # echo "5 4 \* \* \* ownerid cd /srv/cvmfs/repo.opensciencegrid.org && wget -qO .cvmfswhitelist.new http://oasis.opensciencegrid.org/cvmfs/repo.opensciencegrid.org/.cvmfswhitelist && mv .cvmfswhitelist.new .cvmfswhitelist" >>/etc/cron.d/fetch-cvmfs-whitelist

    Note that this eliminates the need for the repository service administrator to periodically use `cvmfs_server resign` to update `.cvmfswhitelist`. Then the repository service administrator goes back to the open GOC ticket and asks to proceed to step \#9.

9.  The GOC representative then asks the administrator of the BNL stratum 1 to also add the new repository. He should set up his stratum 1s to read from `http://oasis-replica.opensciencegrid.org:8000/cvmfs/repo.domain.name`. When he has reported back that the replication is ready, the GOC representative reports in the ticket that the repository is ready on the OSG and closes the ticket.

10.  The repository service administrator then gives the VO representative access to the repository under the "ownerid" login, informs them of the [CVMFS documentation on maintaining repositories](http://cernvm.cern.ch/portal/filesystem/maintain-repositories) and requests that they adhere to the [CVMFS documentation on repository content limitations](http://cernvm.cern.ch/portal/filesystem/repository-limits). If the domain.name is opensciencegrid.org, the repository service administrator should also inform the VO representative that if they want the repository to be accessed outside of the U.S. they should open a ggus ticket following the EGI's [PROC20](https://wiki.egi.eu/wiki/PROC2\). (Note: EGI does not have a concept of sub-VOs like OSG does; to EGI, all sub-VOs under fermilab are the fermilab VO).

Emergency procedure to blank an externally-hosted repository to OASIS
---------------------------------------------------------------------

1.  If there is an emergency request from OSG security to shut down the distribution of a repository, the GOC representative just needs to run `blank_osg_repository` on oasis-replica and give it the full name of the repository. This will rename the repository directories to a name with the current timestamp and replace it with a blank repository. It includes a step to run on the oasis machine, and attempts to do it with ssh, but if that fails it prints instructions on how to finish by logging in to the oasis machine manually.
2.  When it is time to put the repository back into production, the GOC representative runs `unblank_osg_repository` on oasis-replica and gives it the full name of the repository again. This will find the directory with the old timestamp and put it back into service. This step also attempts to ssh to the oasis machine.

Procedure to change the URL of an external repository
-----------------------------------------------------

1.  The repository service administrator opens a GOC ticket with the value of the new URL.
2.  The GOC representative then changes the registered value in OIM for the VO in OASIS Repo URLs. The GOC stratum 1 will then be updated within an hour.

Procedure to shut down and remove an external repository
--------------------------------------------------------

1. First, if the repository has been replicated outside of the U.S., the repository service administrator should open a GGUS ticket asking that the replication be removed from EGI stratum 1s. Wait until they say they are finished before going to the next step. 
1. Next, the repository service administrator opens a GOC ticket asking to shut down the repository, giving the repository name, for example `repo.domain.name`, and the VO it belongs to. 
1. After validating that the ticket submitter is authorized by a registered OASIS manager, the GOC representative next deletes the registered value for `repo.domain.name` in OIM for the VO in OASIS Repo URLs. 
1. Next, the GOC representative adds the FNAL and BNL stratum 1 administrators to the ticket to asks them to remove the repository. 
1. When the FNAL and BNL stratum 1 administrators say they have finished, the GOC representative then runs `cvmfs_server rmfs -f repo.domain.name` and `rm -r /oasissrv/cvmfs/repo.domain.name` on oasis-replica-itb and oasis-replica. 
1. Finally, the GOC representative does `rm -r /srv/cvmfs/repo.domain.name` on oasis-itb and oasis.

