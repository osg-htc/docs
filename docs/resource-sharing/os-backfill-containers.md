DateReviewed: 2021-12-17

Open Science Pool Containers
============================

In order to [share compute resources](overview.md) with the Open Science Pool (OSPool),
sites can launch pilot jobs directly by starting an OSG-provided Docker container.
The container includes a worker node environment and an embedded pilot;
when combined with an OSG-provided authentication token (not included in the container),
the pilot can connect to the OSPool and start executing jobs.

This technique is useful to implement _backfill_ at a site:
contributing computing resources when they would otherwise be idle.

!!! warning "Container Limitations"
    These containers do not allow the site to share resources between multiple pools and,
    if there are no matching idle jobs in the OSPool,
    the pilots may remain idle.

Before Starting
---------------

In order to configure the container, you will need:

1. A [registered administrative contact](https://opensciencegrid.org/technology/policy/comanage-instructions-user/)
1. A [registered resource](../common/registration.md) in OSG Topology;
   resource registration allows OSG to do proper usage accounting and maintain contacts in case of security incidents
   and other issues.
1. An authentication token from the OSG: once contact and resource registration are complete, you can retrieve a token
   through the [OSPool Token Registry](https://os-registry.opensciencegrid.org/)
1. An [HTTP caching proxy](../data/run-frontier-squid-container.md) at or near your site.

Running the Container with Docker
---------------------------------

The Docker image is kept in [DockerHub](https://hub.docker.com/r/opensciencegrid/osgvo-docker-pilot).
In order to successfully start payload jobs:


1. **Configure authentication:**
   Authentication with the OSPool is performed using tokens retrieved from the
   [OSPool Token Registry](https://os-registry.opensciencegrid.org/)
   which you can then pass to the container by volume mounting it as a file under `/etc/condor/tokens-orig.d/`.
   If you are using Docker to launch the container, this is done with the command line flag
   `-v /path/to/token:/etc/condor/tokens-orig.d/flock.opensciencegrid.org`.
   Replace `/path/to/token` with the full path to the token you obtained from the OSPool Token Registry.
2. Set `GLIDEIN_Site` and `GLIDEIN_ResourceName` to match the site name and resource name that you registered in Topology,
   respectively.
3. Set the `OSG_SQUID_LOCATION` environment variable to the HTTP address of your preferred Squid instance.
4. _Strongly_recommended:_ Enable [CVMFS](#cvmfs) via one of the mechanisms described below.
5. _Strongly recommended:_  If you want job I/O to be done in a separate directory outside of the container,
   volume mount the desired directory on the host to `/pilot` inside the container.

    Without this, user jobs may compete for disk space with other containers on your system.

    If you are using Docker to launch the container, this is done with the command line flag
    `-v /worker-temp-dir:/pilot`.
    Replace `/worker-temp-dir` with a directory you created for jobs to write into.
    Make sure the user you run your container as has write access to this directory.

6. _Optional:_ add an expression with the `GLIDEIN_Start_Extra` environment variable to append to the
   [HTCondor `START` expression](https://htcondor.readthedocs.io/en/latest/admin-manual/policy-configuration.html#the-start-expression);
   this limits the pilot to only run certain jobs.

7. _Optional:_ [limit OSG pilot container resource usage](#limiting-resource-usage)


Here is an example invocation using `docker run` by hand:

```
docker run -it --rm --user osg  \
       --privileged             \
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

Replace `/path/to/token` with the location you saved the token obtained from the OSPool Token Registry.
Privileged mode (`--privileged`) requested in the above `docker run` allows the container
to mount [CVMFS using cvmfsexec](#adding-cvmfs-using-cvmfsexec) and invoke `singularity` for user jobs.
Singularity allows OSPool users to use their own container for their job (e.g., a common use case for GPU jobs).


CVMFS
-----

[CernVM-FS](https://cernvm.cern.ch/fs/) (CVMFS) is a read-only remote filesystem that many OSG jobs depend on for software and data.
Supporting CVMFS inside your container will greatly increase the types of OSG jobs you can run.

There are two methods for making CVMFS available in your container: [enabling cvmfsexec](#adding-cvmfs-using-cvmfsexec),
or [bind-mounting CVMFS from the host](#adding-cvmfs-via-bind-mount).
Bind-mounting CVMFS will require CVMFS to be installed on the host first,
but the container will need fewer privileges.


### Adding CVMFS using cvmfsexec

[cvmfsexec](https://github.com/CVMFS/cvmfsexec#readme) is a tool that can be used to mount CVMFS inside the container
without requiring CVMFS to be installed on the host.

To enable cvmfsexec, specify a space-separated list of repos in the `CVMFSEXEC_REPOS` environment variable.
We recommend the following repos:
-   `oasis.opensciencegrid.org`
-   `singularity.opensciencegrid.org`

cvmfsexec has the following system requirements:

-   On EL7, you must have kernel version >= 3.10.0-1127 (run `uname -vr` to check), and user namespaces enabled.
    See step 1 in the
    [Singularity Install document](https://opensciencegrid.org/docs/worker-node/install-singularity/#enabling-unprivileged-singularity)
    for details.

-   On EL8, you must have kernel version >= 4.18 (run `uname -vr` to check).

See the [cvmfsexec README](https://github.com/cvmfs/cvmfsexec#readme) details.

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
This will let you avoid running the container in privileged mode.
However, supporting Singularity jobs inside the container will require extra privileges,
namely the capabilities `DAC_OVERRIDE`, `DAC_READ_SEARCH`, `SETGID`, `SETUID`, `SYS_ADMIN`, `SYS_CHROOT`, and `SYS_PTRACE`.

Follow the [installing CVMFS document](../worker-node/install-cvmfs.md) to install CVMFS on the host.

Once you have CVMFS installed and mounted on your host, add `-v /cvmfs:/cvmfs:shared` to your `docker run` invocation.

This is the [example at the top of the page](#running-the-container-with-docker),
modified to volume mount CVMFS instead of using cvmfsexec, and using reduced privileges:

```
docker run -it --rm --user osg      \
        --security-opt seccomp=unconfined \
        --security-opt systempaths=unconfined \
        --security-opt no-new-privileges \
        -v /cvmfs:/cvmfs:shared     \
        -v /path/to/token:/etc/condor/tokens-orig.d/flock.opensciencegrid.org \
        -v /worker-temp-dir:/pilot      \
        -e GLIDEIN_Site="..."           \
        -e GLIDEIN_ResourceName="..."   \
        -e GLIDEIN_Start_Extra="True"   \
        -e OSG_SQUID_LOCATION="..."     \
        opensciencegrid/osgvo-docker-pilot:release
```

Fill in the values for `/path/to/token`, `/worker-temp-dir`, `GLIDEIN_Site`, `GLIDEIN_ResourceName`, and `OSG_SQUID_LOCATION` [as above](#running-the-container-with-docker).


Limiting Resource Usage
-----------------------

By default, the OSG pilot container will allow jobs to utilize the entire node's resources (CPUs, memory).
If you don't want to allow jobs to use all of these, you can specify limits.

You must specify limits in two places:

-   As environment variables, limiting the resources the pilot offers to jobs.

-   As options to the `docker run` command, limiting the resources the pilot container can use.

### Limiting CPUs

To limit the number of CPUs available to jobs (thus limiting the number of simultaneous jobs),
add the following to your `docker run` command:

```
   -e NUM_CPUS=<X>  --cpus=<X> \
```

where `<X>` is the number of CPUs you want to allow jobs to use.

The `NUM_CPUS` environment variable will tell the pilot not to offer more than the given number of CPUs to jobs;
the `--cpus` argument will tell Docker not to allocate more than the given number of CPUs to the container.

Both options are necessary for optimal behavior.


### Limiting memory

To limit the total amount of memory available to jobs, add the following to your `docker run` command:
```
    -e MEMORY=<X> --memory=$(( (<X> + 100) * 1024 * 1024 )) \
```

where `<X>` is the total amount of memory (in MB) you want to allow jobs to use.

The `MEMORY` environment variable will tell the pilot not to offer more than the given amount of memory to jobs;
the `--memory` argument will tell Docker to kill the container if its total memory usage exceeds the given number.

Both options are necessary for optimal behavior.

!!! tip "Allocating additional memory"
    Note that the above command will allocate 100 MB more memory to the container.
    The pilot will place jobs on hold if they exceed their requested memory,
    but it may not notice high memory usage immediately.
    In addition, the processes that manage jobs also use some amount of memory.
    Therefore it is important to give the container some extra room.

Best Practices
--------------

We recommend redeploying backfill containers at least every 72 hours.
This ensures that your containers will have the latest bug and security fixes as well as the configurations to match the
rest of the OSPool.
Additionally, you may see better utilization of your resources as the OSPool may ignore resources with a high number of
job starts.

Getting Help
------------

For assistance, please use the [this page](../common/help.md).
