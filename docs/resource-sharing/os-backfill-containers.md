title: Open Science Pool Containers
DateReviewed: 2021-12-17

Open Science Pool Containers
============================

!!! info "Schedule a consultation"
    To ensure that we can meet your research computing goals needs, please contact us at <support@osg-htc.org> to schedule a consultation.

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

1. A system that can run containers, such as Docker or Kubernetes
1. Appropriate user permissions configured on the system.
   1. Launching a container manually via docker requires membership in the [`docker` group](https://docs.docker.com/engine/install/linux-postinstall/).
   1. Installing the container via RPM and launching it via systemd both require `root` privileges.
   1. A scratch directory on the system must be writable by uid 1000.
1. A [registered administrative contact](../common/contact-registration.md)
1. A [registered resource](../common/registration.md) in OSG Topology;
   resource registration allows OSG to do proper usage accounting and maintain contacts in case of security incidents
   and other issues.
1. An authentication token from the OSG: once contact and resource registration are complete, you can retrieve a token
   through the [OSPool Token Registry](https://os-registry.opensciencegrid.org/)
1. An [HTTP caching proxy](../data/run-frontier-squid-container.md) at or near your site.


Running the Container via RPM
---------------------------------

On EL hosts, the pilot container can also be managed via a systemctl service provided by the `ospool-ep` rpm. To install this RPM:

1. [Enable OSG yum repos](../common/yum.md).

1. Install the service:

        :::console
        root@host # yum install ospool-ep

1. [Obtain an OSPool Access Token](https://os-registry.opensciencegrid.org/) for the pilot.
   
1. Copy the OSPool Access Token obtained in the previous step to `/etc/osg/ospool-ep.tkn`.

    !!! note "Token file ownership"
        The EP is run under uid 1000.
        Ensure this user has read access to the token file.

            :::console
            root@host # chown 1000:1000 /etc/osg/ospool-ep.tkn

1. Configure the container service by editing `/etc/osg/ospool-ep.cfg`:

    - Set `GLIDEIN_Site` to your OSG Topology Site identifier.
    - Set `GLIDEIN_ResourceName` to your OSG Topology Resource Name identifier.
    - **If** you have dedicated scratch disk space for OSPool payload jobs (which is recommended),
      then set `WORKER_TEMP_DIR` to the scratch directory; e.g.:

            WORKER_TEMP_DIR=/scratch
    
      Ensure that the directory is writable by uid 1000.

    !!! note "Scratch space ownership"
        The EP is run under uid 1000.
        Ensure this user has read, write, and execute access to the scratch space.

1.  _Optional:_ Configure CVMFS via `/etc/osg/ospool-ep.cfg`:

    - If [CVMFS is installed](https://osg-htc.org/docs/worker-node/install-cvmfs/) on the host system,
      set `BIND_MOUNT_CVMFS=true`
    - Otherwise, set `CVMFSEXEC_REPOS`, `CVMFS_HTTP_PROXY`, and `CVMFS_QUOTA_LIMIT` in accordance with the
      [Configure cvmfsexec](#cvmfsexec) documentation.

1. Configure additional variables in `/etc/osg/ospool-ep.cfg`:

    - If your site has a [Squid HTTP Caching Proxy](https://osg-htc.org/docs/data/run-frontier-squid-container/) configured,
      set `OSG_SQUID_LOCATION` to that proxy's HTTP address.

    - If providing NVIDIA GPU resources, set `PROVIDE_NVIDIA_GPU=true`
      - This automatically sets variables in accordance with section [Providing GPU Resources](#providing-gpu-resources).

    !!! note "GPU Configuration Minimum Version"
        The first version of the ospool-ep RPM to provide support for GPU configuration is
        24-2. Ensure your installation of the ospool-ep package is up to date using 
        `yum update ospool-ep`.

1. Start the OSPool EP container service:

        :::console
        root@host # systemctl start ospool-ep

1. _Optional:_ monitor the systemctl service logs to see if the container starts successfully:

        :::console
        root@host # journalctl -f -u ospool-ep


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
1. Set `GLIDEIN_Site` and `GLIDEIN_ResourceName` to match the resource group name and resource name that you registered
   in Topology, respectively.
1. Set the `OSG_SQUID_LOCATION` environment variable to the HTTP address of your preferred Squid instance.
1. _If providing NVIDIA GPU resources:_ See section [Providing GPU Resources](#providing-gpu-resources)
1. _Strongly recommended:_ If you want job I/O to be done in a separate directory outside of the container,
   volume mount the desired directory on the host to `/pilot` inside the container.

    Without this, user jobs may compete for disk space with other containers on your system.

    If you are using Docker to launch the container, this is done with the command line flag
    `-v /worker-temp-dir:/pilot`.
    Replace `/worker-temp-dir` with a directory you created for jobs to write into.
    Make sure the user you run your container as has write access to this directory.

1. _Optional:_ add an expression with the `GLIDEIN_Start_Extra` environment variable to append to the
   [HTCondor `START` expression](https://htcondor.readthedocs.io/en/latest/admin-manual/ep-policy-configuration.html#the-start-expression);
   this limits the pilot to only run certain jobs.

1. _Optional:_ [limit OSG pilot container resource usage](#limiting-resource-usage)

1. _Optional:_ Enable [CVMFS](#cvmfs) via one of the mechanisms described below.

Here is an example invocation using `docker run` by hand:

```
docker run -it --rm --user osg  \
       --pull=always            \
       --security-opt seccomp=unconfined        \
       --security-opt systempaths=unconfined    \
       --security-opt no-new-privileges         \
       --device /dev/fuse                       \
       -v /path/to/token:/etc/condor/tokens-orig.d/flock.opensciencegrid.org \
       -v /worker-temp-dir:/pilot               \
       -e GLIDEIN_Site="..."                    \
       -e GLIDEIN_ResourceName="..."            \
       -e GLIDEIN_Start_Extra="True"            \
       -e OSG_SQUID_LOCATION="..."              \
       -e CVMFSEXEC_REPOS="                     \
            oasis.opensciencegrid.org           \
            singularity.opensciencegrid.org"    \
       hub.osg-htc.org/osg-htc/ospool-ep:24-release
```

Replace `/path/to/token` with the location you saved the token obtained from the OSPool Token Registry.
The `--security-opt` options and device mount requested in the above `docker run` allow the container
to mount [CVMFS using cvmfsexec](#cvmfsexec) and invoke `singularity` for user jobs.
Singularity (now known as Apptainer) allows OSPool users to use their own container for their job (e.g., a common use case for GPU jobs).


Optional Configuration
----------------------

### CVMFS

[CernVM-FS](https://cernvm.cern.ch/fs/) (CVMFS) is a read-only remote filesystem that some OSG jobs depend on for software and data.
Supporting CVMFS inside your container will increase the types of OSG jobs you can run.

There are two methods for making CVMFS available in your container: [enabling cvmfsexec](#cvmfsexec),
or [bind mounting CVMFS from the host](#bind-mount).
Bind mounting CVMFS will require CVMFS to be installed on the host first,
but the container will need fewer privileges.


#### cvmfsexec

!!! info "cvmfsexec System Requirements"

    -   On EL8, you must have kernel version >= 4.18 (run `uname -vr` to check).

    -   On EL9, all kernel versions >= 5.0 should be supported.

    See the [cvmfsexec README](https://github.com/cvmfs/cvmfsexec#readme) details.

[cvmfsexec](https://github.com/CVMFS/cvmfsexec#readme) is a tool that can be used to mount CVMFS inside the container
without requiring CVMFS on the host.
To enable cvmfsexec, specify a comma-separated list of repos in the `CVMFSEXEC_REPOS` environment variable.
Adding the following line to `/etc/osg/ospool-ep.cfg` will enable the repos we recommend:
```
CVMFSEXEC_REPOS=oasis.opensciencegrid.org,singularity.opensciencegrid.org
```

!!! warning "Systemd environment files"
    Systemd environment files do not honor shell syntax, i.e. variables are passed in directly as written

Additionally, you may set the following environment variables to further control the behavior of cvmfsexec:

-   `CVMFS_HTTP_PROXY` - this sets the proxy to use for CVMFS; if left blank
    it will find the best one via WLCG Web Proxy Auto Discovery.

-   `CVMFS_QUOTA_LIMIT` - the quota limit in MB for CVMFS; leave this blank to
    use the system default (4 GB)

You can add other CVMFS options by bind mounting a config file over `/cvmfsexec/default.local`;
note that options in environment variables take precedence over options in `/cvmfsexec/default.local`.

You may store the cache outside of the container by volume mounting a directory to `/cvmfs-cache`.
Similarly, logs may be stored outside of the container by volume mounting a directory to `/cvmfs-logs`.

#### Bind mount

As an alternative to using cvmfsexec, you may [install CVMFS](../worker-node/install-cvmfs.md) on the host,
and volume mount it into the container.

Once you have CVMFS installed and mounted on your host, add `-v /cvmfs:/cvmfs:shared` to your `docker run` invocation.
This is the [example at the top of the page](#running-the-container-with-docker),
modified to volume mount CVMFS instead of using cvmfsexec:

```hl_lines="6"
docker run -it --rm --user osg      \
        --pull=always            \
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
        hub.osg-htc.org/osg-htc/ospool-ep:24-release
```

Fill in the values for `/path/to/token`, `/worker-temp-dir`, `GLIDEIN_Site`, `GLIDEIN_ResourceName`, and `OSG_SQUID_LOCATION` [as above](#running-the-container-with-docker).


### Providing GPU Resources

By default, the container will not detect NVIDIA GPU resources available on its host. To configure
the container for access to its host’s GPU resources, set the following:

1. Replace the default `24-release` docker image tag with the [CUDA-enabled](https://developer.nvidia.com/cuda-toolkit)
   `24-cuda-11_8_0-release` tag

1. Bind-mount `/etc/OpenCL/vendors`, read-only. If you are using Docker to launch the container, 
   this is done with the command line flags `-v /etc/OpenCL/vendors:/etc/OpenCL/vendors:ro`.

1. The NVIDIA runtime is known to conflict with Singularity [PID Namespaces](https://man7.org/linux/man-pages/man7/pid_namespaces.7.html)
   Disable PID namespaces by adding the flag `-e SINGULARITY_DISABLE_PID_NAMESPACES=True`

This is the [example at the top of the page](#running-the-container-with-docker), modified
to provide NVIDIA GPU resources:

```hl_lines="9 14 15"
docker run -it --rm --user osg  \
       --pull=always            \
       --security-opt seccomp=unconfined        \
       --security-opt systempaths=unconfined    \
       --security-opt no-new-privileges         \
       --device /dev/fuse                       \
       -v /path/to/token:/etc/condor/tokens-orig.d/flock.opensciencegrid.org \
       -v /worker-temp-dir:/pilot               \
       -v /etc/OpenCL/vendors:/etc/OpenCL/vendors:ro \
       -e GLIDEIN_Site="..."                    \
       -e GLIDEIN_ResourceName="..."            \
       -e GLIDEIN_Start_Extra="True"            \
       -e OSG_SQUID_LOCATION="..."              \
       -e SINGULARITY_DISABLE_PID_NAMESPACES=True   \
       hub.osg-htc.org/osg-htc/ospool-ep:24-cuda_11_8_0-release
```

### Limiting resource usage

By default, the container allows jobs to utilize the entire node's resources (CPUs, memory).
To limit a container's resource consumptions, you may specify limits, which must be set in the following ways:

-   As environment variables, limiting the resources the pilot offers to jobs.
-   As options to the `docker run` command, limiting the resources the pilot container can use.

#### CPUs

To limit the number of CPUs available to jobs (thus limiting the number of simultaneous jobs),
add the following to your `docker run` command:

```
   -e NUM_CPUS=<X>  --cpus=<X> \
```

where `<X>` is the number of CPUs you want to allow jobs to use.

The `NUM_CPUS` environment variable tells the pilot not to offer more than the given number of CPUs to jobs;
the `--cpus` argument tells Docker not to allocate more than the given number of CPUs to the container.


#### Memory

To limit the total amount of memory available to jobs, add the following to your `docker run` command:

```
    -e MEMORY=<X> --memory=$(( (<X> + 100) * 1024 * 1024 )) \
```

where `<X>` is the total amount of memory (in MB) you want to allow jobs to use.

The `MEMORY` environment variable tells the pilot not to offer more than the given amount of memory to jobs;
the `--memory` argument tells Docker to kill the container if its total memory usage exceeds the given number.

!!! tip "Allocating additional memory"
    Note that the above command will allocate 100 MB more memory to the container.
    The pilot will place jobs on hold if they exceed their requested memory,
    but it may not notice high memory usage immediately.
    Additionally, the processes that manage jobs also use some amount of memory.
    Therefore, it is important to give the container some extra room.


### Advanced: Advertising additional pilot attributes

You can put arbitrary additional attributes in the machine ads that the pilot advertises to the OSPool.
These attributes will show up when users run `condor_status -l` against your pilot.
This could be useful for advertising something about the way the pilot was provisioned.
To do this, volume-mount a file containing `key=value` pairs to `/etc/osg/extra-attributes.cfg`.
Keys must be valid classad attribute names and values must be valid classad expressions.
Multi-line strings are not supported.
A line starting with `#` will be treated as a comment.
For example:

```
# The Kubernetes namespace this pod is running under
KUBERNETES_NAMESPACE = "path-osgdev"
# The deployment for this pilot
KUBERNETES_DEPLOYMENT = "osgvo-docker-pilot-gpu"
```


Best Practices
--------------

We recommend pulling new versions of backfill containers at least every 72 hours.
This ensures that your containers will have the latest bug and security fixes as well as the configurations to match the
rest of the OSPool.
Additionally, you may see better utilization of your resources as the OSPool may ignore resources with a high number of
job starts.

Getting Help
------------

For assistance, please use the [this page](../common/help.md).
