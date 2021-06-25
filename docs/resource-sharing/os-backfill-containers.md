Open Science Pool Containers
============================

In order to [share compute resources](overview.md) with the Open Science pool,
sites can launch pilot jobs directly by starting an OSG-provided Docker container.
The container includes a simple worker node environment and an embedded pilot;
when combined with an OSG-provided authentication token (not included in the container),
the pilot can connect to the Open Science pool and start executing jobs.

This technique is useful to implement _backfill_ at a site:
contributing computing resources when they would otherwise be idle.
It does not allow the site to share resources between multiple pools and,
if there are no matching idle jobs in the Open Science pool,
the pilots may remain idle.

Before Starting
---------------

In order to configure the container, you will need:

1. A [registered resource](../common/registration.md) in OSG Topology;
   resource registration allows OSG to do proper usage accounting and maintain contacts in case of security incidents.
2. An authentication token from the OSG.  Please contact [OSG support](mailto:support@opensciencegrid.org) to request a
   token for your site.
3. An HTTP caching proxy ("squid server") at or near your site.

Running the Container with Docker
---------------------------------

The Docker image is kept in [DockerHub](https://hub.docker.com/r/opensciencegrid/osgvo-docker-pilot) and requires a
number of environment variables to be set in order to function appropriately:

1. Set `TOKEN` to the authentication token you received from OSG.
2. Set `GLIDEIN_Site` and `GLIDEIN_ResourceName` to match the site name and resource name you registered in topology,
   respectively.
3. Set the `OSG_SQUID_LOCATION` environment variable to the HTTP address of your preferred squid instance.
4. _Recommended:_ Set `CVMFSEXEC_REPOS` to the list of CVMFS repos you want to support (see [CVMFS](#cvmfs) below).
   We recommend including `oasis.opensciencegrid.org`, `singularity.opensciencegrid.org`, and `stash.osgstorage.org` in the list.
5. _Optional:_  Some sites prefer that job I/O is done in a specific temporary directory instead of inside the container.
   To do this, map the appropriate directory on the host to `/pilot` inside containers.
   If you are using Docker to launch the container, this is done with the command line flag `-v /somelocaldir:/pilot`.
6. _Optional:_ add an expression with the `GLIDEIN_Start_Extra` environment variable to append to the HTCondor `START`
   expression; this limits the pilot to only run certain jobs.

Here is an example invocation using `docker run` by hand:

```
docker run -it --rm --user osg \
       --privileged \
       -e TOKEN="..." \
       -e GLIDEIN_Site="..." \
       -e GLIDEIN_ResourceName="..." \
       -e GLIDEIN_Start_Extra="True" \
       -e OSG_SQUID_LOCATION="..." \
       -e CVMFSEXEC_REPOS="\
oasis.opensciencegrid.org,\
singularity.opensciencegrid.org,\
stash.osgstorage.org" \
       opensciencegrid/osgvo-docker-pilot:release
```

Privileged mode requested in the above `docker run` allows the container to mount CVMFS using cvmfsexec
(see below) and invoke `singularity` for user jobs;
this allows the user to utilize a container for their job that is different from the pilot.

CVMFS
-----

CVMFS is a read-only remote filesystem that many OSG jobs depend on for software and data.
Supporting CVMFS inside your container will greatly increase the types of OSG jobs you can run.

There are two methods for adding CVMFS: bind-mounting it from the host, and enabling cvmfsexec.


### Adding CVMFS via bind-mount

Follow the [installing CVMFS document](../worker-node/install-cvmfs.md) to install CVMFS on the host.

Once you have CVMFS installed and mounted on your host, add `-v /cvmfs:/cvmfs:shared` to your `docker run` invocation:

        docker run -it --rm --user osg \
               --cap-add=DAC_OVERRIDE --cap-add=SETUID --cap-add=SETGID \
               --cap-add=SYS_ADMIN --cap-add=SYS_CHROOT --cap-add=SYS_PTRACE \
               --cap-add=DAC_READ_SEARCH \
               -v /cvmfs:/cvmfs:shared \
               -e TOKEN="..." \
               -e GLIDEIN_Site="..." \
               -e GLIDEIN_ResourceName="..." \
               -e GLIDEIN_Start_Extra="True" \
               -e OSG_SQUID_LOCATION="..." \
               opensciencegrid/osgvo-docker-pilot:latest

Fill in the values for `TOKEN`, `GLIDEIN_Site`, `GLIDEIN_ResourceName`, and `OSG_SQUID_LOCATION` [as above](#running-the-container-with-docker).

Note the additional capabilities requested in the above `docker run` allow the container to invoke `singularity` for
user jobs; this allows the user to utilize a container for their job that is different from the pilot.


### Adding CVMFS using cvmfsexec

[cvmfsexec](https://github.com/CVMFS/cvmfsexec#readme) is a tool that can be used to mount CVMFS inside the container
without requiring it to be installed on the host.
cvmfsexec is already installed in the container.
To enable it, specify a space-separated list of repos in the `CVMFSEXEC_REPOS` environment variable.
"oasis.opensciencegrid.org" is a recommended repo to add.

Using Singularity with cvmfsexec requires the container to run in privileged mode,
so you will have to replace the `--cap-add ...` arguments in your `docker run` invocation with `--privileged`:

        docker run -it --rm --user osg \
               --privileged \
               -e TOKEN="..." \
               -e GLIDEIN_Site="..." \
               -e GLIDEIN_ResourceName="..." \
               -e GLIDEIN_Start_Extra="True" \
               -e OSG_SQUID_LOCATION="..." \
               -e CVMFSEXEC_REPOS="\
                    oasis.opensciencegrid.org \
                    singularity.opensciencegrid.org \
                    stash.osgstorage.org" \
               opensciencegrid/osgvo-docker-pilot:latest

Fill in the values for `TOKEN`, `GLIDEIN_Site`, `GLIDEIN_ResourceName`, and `OSG_SQUID_LOCATION` [as above](#running-the-container-with-docker).

There are additional options for cvmfsexec that are passed via environment variables:

-   `CVMFS_HTTP_PROXY` - this sets the proxy to use for CVMFS;
    if left blank, it will find the best one via WLCG Web Proxy Auto Discovery.

-   `CVMFS_QUOTA_LIMIT` - the quota limit in MB for CVMFS; leave this blank to use the system default (4 GB)

You can add other CVMFS options by bind-mounting a config file over `/cvmfsexec/default.local`;
note that options in environment variables are preferred over options in `/cvmfsexec/default.local`.

You can store the cache outside of the container by bind-mounting a directory to `/cvmfs-cache`.

You can store the logs outside of the container by bind-mounting a directory to `/cvmfs-logs`.

