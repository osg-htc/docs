Worker Node Overview
====================

The Worker Node Client is a collection of useful software components that is expected to be on every OSG worker node. In addition, a job running on a worker node can access a handful of environment variables that can be used to locate resources.

This page describes how to initialize the environment of your job to correctly access the execution and data areas from the worker node.

The OSG provides no scientific software dependencies or software build tools on the worker node; you are expected to bring along all application-level dependencies yourself (preferred; most portable) or utilize CVMFS. Sites are not required to provide any specific tools (`gcc`, `lapack`, `blas`, etc.) beyond the ones in the OSG worker node client and the base OS.

If you would like to test the minimal OS environment that jobs can expect, you can test out your scientific software in [the OSG Docker image](https://hub.docker.com/r/opensciencegrid/osg-wn/).

Hardware Recommendations
------------------------
| Hardware               | Minimum | Recommended                         | Notes                                             |
|:-----------------------|:--------|:----------------------|:--------------------------------------------------|
|Core per pilot                   |  1      |8                      | Depends on the supported VOs. The total core count on every node in the cluster must be divisible by core per pilot.|
|Memory per core                 | 1024MB  | 2048MB                  | Memory per core times core per pilot needs to be less than the total memory on every node. Do not overcommit. |
|Scratch disk per core ([OSG_WN_TMP](#osg_wn_tmp))| 2 GB    | 10 GB                  | This can be overcommitted if a mix of different VO jobs is expected.|
|CVMFS [Cache](/worker-node/install-cvmfs/#before-starting) per node (optional) | 10 GB | 20 GB | |


Common Software Available on Worker Nodes
-----------------------------------------

The OSG worker node environment contains the following software:

-   The supported set of CA certificates (located in `$X509_CERT_DIR` after the environment is set up)
-   Proxy management tools:
    -   Create proxies: `voms-proxy-init` and `grid-proxy-init`
    -   Show proxy info: `voms-proxy-info` and `grid-proxy-info`
    -   Destroy the current proxy: `voms-proxy-destroy` and `grid-proxy-destroy`
-   Data transfer tools:
    -   HTTP/plain FTP protocol tools (via system dependencies):
        -   `wget` and `curl`: standard tools for downloading files with HTTP and FTP
    -   Transfer clients
        -   `GFAL`-based client (`gfal-copy` and others).  GFAL supports SRM, GridFTP, and HTTP protocols.
        -   Globus GridFTP client (`globus-url-copy`)
-   MyProxy client tools

At some sites, these tools may not be available at the pilot launch.  To setup the environment, do the following:

    :::console
    user@host $ source $OSG_GRID/setup.sh

This should be done by a pilot job, not by the end-user payload.

The Worker Node Environment
---------------------------

The following table outlines the various important directories and information in the worker node environment.
A job running on an OSG worker node can refer to each directory using the corresponding environment variable.
Several of them are defined as options in your OSG-Configure `.ini` files in `/etc/osg/config.d`.
Custom variables and those that aren't listed may be defined in the [Local Settings section](/other/configuration-with-osg-configure/#local-settings).

| Environment Variable   | OSG-Configure section/option      | Purpose                                                    | Notes                                                                                                                         |
|:-----------------------|:------------------------------|:-----------------------------------------------------------|:------------------------------------------------------------------------------------------------------------------------------|
| `$OSG_GRID`            | `Storage`/`grid_dir`          | Location of additional environment variables.              | Pilots should source `$OSG_GRID/setup.sh` in order to guarantee the environment contains the worker node binaries in `$PATH`. |
| `$OSG_SQUID_LOCATION`, | `Squid`/`location`            | Location of a HTTP caching proxy server                    | Utilize this service for downloading files via HTTP for cache-friendly workflows.                                             |
| `$OSG_WN_TMP`          | `Storage`/`worker_node_temp`  | Temporary storage area workspace for pilot job(s)          | Local to each worker node. See [this section](#osg_wn_tmp) below for details.                   |
| `$X509_CERT_DIR`       |                               | Location of the CA certificates                            | If not defined, defaults to `/etc/grid-security/certificates`.                                                                |
| `$_CONDOR_SCRATCH_DIR` |                               | Suggested temporary storage for glideinWMS-based payloads. | Users should prefer this environment variable over `$OSG_WN_TMP` if running inside glideinWMS.                                |

### OSG_WN_TMP ###

As [described above](#the-worker-node-environment) `OSG_WN_TMP` is a temporary storage area on each worker node for
pilot jobs to use as temporary scratch space.

#### For site administrators  ####

Site administrators are responsible for cleaning up the contents of `$OSG_WN_TMP`
(see[table above](#hardware-recommendations) for size recommendations).
We recommend one of the following solutions:

- **(Recommended)** Use batch-system capabilities to create directories in the job scratch directory and bind mount
  them for the job so that the batch system performs the clean up.
  For example, HTCondor has this ability through
  [MOUNT\_UNDER\_SCRATCH](http://research.cs.wisc.edu/htcondor/manual/v8.6/3_5Configuration_Macros.html#24738):

        MOUNT_UNDER_SCRATCH = $(MOUNT_UNDER_SCRATCH), <PATH TO OSG_WN_TMP>

    If using this method, space set aside for `OSG_WN_TMP` should be reallocated to the partition containing the job
    scratch directories.
    If using HTCondor, this will be the partition containing the path defined by the HTCondor `EXECUTE` configuration
    variable.

- Use batch-system capabilities to create a temporary, per-job directory that is cleaned up after each job is run.
- Periodically purge the directory (e.g. `tmpwatch`).

#### For VO managers ####

!!! note
    The following advice applies to VO managers or maintainers of *pilot* software; end-users should contact their VO
    for the proper locations to stage temporary work (often, this will be either `$TMPDIR` or `$_CONDOR_SCRATCH_DIR`).

Be careful with using `$OSG_WN_TMP`; at some sites, this directory might be shared with other VOs. We recommend creating a new sub-directory as a precaution:

```shell
mkdir -p $OSG_WN_TMP/MYVO
export mydir=`mktemp -d -t MYVO`
cd $mydir
# Run the rest of your application
rm -rf $mydir
```

The pilot should utilize `$TMPDIR` to communicate the location of temporary storage to payloads.

A significant number of sites use the batch system to make an independent directory for each user job, and change `$OSG_WN_TMP` on the fly to point to this directory.

There is no way to know in advance how much scratch disk space any given worker node has available; recall, what disk space is available may be shared among a number of job slots.
