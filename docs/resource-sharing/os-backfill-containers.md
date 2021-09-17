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

The Docker image is kept in [DockerHub](https://hub.docker.com/r/opensciencegrid/osgvo-docker-pilot).
In order to successfully start payload jobs:


1. **Configure authentication:**
   Open Science Pool (OSP) administrators can provide the token,
   which you can then pass to the container by volume mounting it as a file under `/etc/condor/tokens-orig.d/`.
   If you are using Docker to launch the container, this is done with the command line flag
   `-v /path/to/token:/etc/condor/tokens-orig.d/flock.opensciencegrid.org`.
   Replace `/path/to/token` with the full path to the token you obtained from the OSP administrators.
2. Set `GLIDEIN_Site` and `GLIDEIN_ResourceName` to match the site name and resource name that you registered in Topology,
   respectively.
3. Set the `OSG_SQUID_LOCATION` environment variable to the HTTP address of your preferred Squid instance.
4. _Recommended:_ Enable [CVMFS](#cvmfs) via one of the mechanisms described below.
5. _Strongly recommended:_  If you want job I/O to be done in a separate directory outside of the container,
   volume mount the desired directory on the host to `/pilot` inside the container.

    Without this, user jobs may compete for disk space with other containers on your system.

    If you are using Docker to launch the container, this is done with the command line flag
    `-v /worker-temp-dir:/pilot`.
    Replace `/worker-temp-dir` with a directory you created for jobs to write into.
    Make sure the user you run your container as has write access to this directory.

6. _Optional:_ add an expression with the `GLIDEIN_Start_Extra` environment variable to append to the HTCondor `START`
   expression; this limits the pilot to only run certain jobs.

Here is an example invocation using `docker run` by hand:

```
docker run -it --rm --user osg  \
       --security-opt seccomp=unconfined \
       --security-opt systempaths=unconfined \
       --security-opt no-new-privileges \
       --device=/dev/fuse \
       --net=host \
       -v /path/to/token:/etc/condor/tokens-orig.d/flock.opensciencegrid.org \
       -v /worker-temp-dir:/pilot               \
       -e GLIDEIN_Site="..."                    \
       -e GLIDEIN_ResourceName="..."            \
       -e GLIDEIN_Start_Extra="True"            \
       -e OSG_SQUID_LOCATION="..."              \
       -e CVMFSEXEC_REPOS="                     \
            oasis.opensciencegrid.org           \
            singularity.opensciencegrid.org"    \
       opensciencegrid/osgvo-docker-pilot:release
```

Replace `/path/to/token` with the location you saved the token obtained from the OSP administrators.
The security options and adding `/dev/fuse` in the above `docker run` allows the container
to mount [CVMFS using cvmfsexec](#adding-cvmfs-using-cvmfsexec) and invoke `singularity` for user jobs.
Singularity allows OSP users to use their own container for their job (e.g., a common use case for GPU jobs).


CVMFS
-----

[CernVM-FS](https://cernvm.cern.ch/fs/) (CVMFS) is a read-only remote filesystem that many OSG jobs depend on for software and data.
Supporting CVMFS inside your container will greatly increase the types of OSG jobs you can run.

There are two methods for making CVMFS available in your container: [enabling cvmfsexec](#adding-cvmfs-using-cvmfsexec),
or [bind-mounting CVMFS from the host](#adding-cvmfs-via-bind-mount).
Bind-mounting CVMFS will require CVMFS to be installed on the host first,
but it has other advantages such as supporting automounting of repositories.


### Adding CVMFS using cvmfsexec

!!! important "User nameespaces required"
    Your hosts must have kernel version >= 3.10.0-1127 (run `uname -vr` to check) with user namespaces enabled and
    network namespaces disabled.
    See this section on using
    [unprivileged Singularity](https://opensciencegrid.org/docs/worker-node/install-singularity/#enabling-unprivileged-singularity)
    for additional details.

    See the [cvmfsexec README](https://github.com/cvmfs/cvmfsexec#readme) details.

[cvmfsexec](https://github.com/CVMFS/cvmfsexec#readme) is a tool that can be used to mount CVMFS inside the container
without requiring CVMFS to be installed on the host.

To enable cvmfsexec, specify a space-separated list of repos in the `CVMFSEXEC_REPOS` environment variable.
We recommend the following repos:
-   `oasis.opensciencegrid.org`
-   `singularity.opensciencegrid.org`

Note that cvmfsexec will not be run if CVMFS repos are already available in `/cvmfs` via bind-mount,
regardless of the value of `CVMFSEXEC_REPOS`.

Using cvmfsexec takes place in the entrypoint, which means it will still happen
even if you specify a different command to run, such as `bash`.
You can bypass the entrypoint by passing `--entrypoint <cmd>` where `<cmd>` is some different command to run,
e.g. `--entrypoint bash`.
Setting the entrypoint this way clears the command.


#### Additional cvmfsexec configuration

There are several environment variables you can set for cvmfsexec:

-   `CVMFSEXEC_REPOS` - this is a space-separated list of CVMFS repos to mount.
    Leave this blank to disable cvmfsexec.
    OSG jobs frequently use the OASIS repo (`oasis.opensciencegrid.org`) and
    the singularity repo (`singularity.opensciencegrid.org`).

-   `CVMFS_HTTP_PROXY` - this sets the proxy to use for CVMFS; if left blank
    it will find the best one via WLCG Web Proxy Auto Discovery.

-   `CVMFS_QUOTA_LIMIT` - the quota limit in MB for CVMFS; leave this blank to
    use the system default (4 GB)

You can add other CVMFS options by bind-mounting a config file over `/cvmfsexec/default.local`;
note that options in environment variables take precedence over options in `/cvmfsexec/default.local`.

You can store the cache outside of the container by volume mounting a directory to `/cvmfs-cache`.

You can store the logs outside of the container by volume mounting a directory to `/cvmfs-logs`.


### Adding CVMFS via bind-mount

As an alternative to using cvmfsexec, you may install CVMFS on the host, and volume mount it into the container.
This will let you avoid specifying a list of CVMFS repositories to mount because they will be automounted on demand.
It will encourage more stability by enabling longer term reuse of caches, and give you more control over the CVMFS configuration.
It will also let you avoid attaching `/dev/fuse` to the container.

Follow the [installing CVMFS document](../worker-node/install-cvmfs.md) to install CVMFS on the host.

Once you have CVMFS installed and mounted on your host, add `-v /cvmfs:/cvmfs:shared` to your `docker run` invocation.

This is the [example at the top of the page](#running-the-container-with-docker),
modified to volume mount CVMFS instead of using cvmfsexec, and using reduced privileges:

```
docker run -it --rm --user osg      \
        --security-opt seccomp=unconfined \
        --security-opt systempaths=unconfined \
        --security-opt no-new-privileges \
        -v /path/to/token:/etc/condor/tokens-orig.d/flock.opensciencegrid.org \
        -v /worker-temp-dir:/pilot      \
        -e GLIDEIN_Site="..."           \
        -e GLIDEIN_ResourceName="..."   \
        -e GLIDEIN_Start_Extra="True"   \
        -e OSG_SQUID_LOCATION="..."     \
        opensciencegrid/osgvo-docker-pilot:release
```

Fill in the values for `/path/to/token`, `/worker-temp-dir`, `GLIDEIN_Site`, `GLIDEIN_ResourceName`, and `OSG_SQUID_LOCATION` [as above](#running-the-container-with-docker).
