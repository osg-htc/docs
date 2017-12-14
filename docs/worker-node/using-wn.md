
Worker Node Overview
====================

The Worker Node Client is a collection of useful software components that is expected to be on every OSG worker node. In addition, a job running on a worker node can access a handful of environment variables that can be used to locate resources.

This page describes how to initialize the environment of your job to correctly access the execution and data areas from the worker node.

The OSG provides no scientific software dependencies or software build tools on the worker node; you are expected to bring along all application-level dependencies yourself (preferred; most portable) or utilize CVMFS. Sites are not required to provide any specific tools (`gcc`, `lapack`, `blas`, etc.) beyond the ones in the OSG worker node client and the base OS.

If you would like to test the minimal OS environment that jobs can expect, you can test out your scientific software in [the OSG Docker image](https://hub.docker.com/r/opensciencegrid/osg-wn/).

Common software available on worker nodes.
==========================================

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
===========================

The following table outlines the various important directories and information in the worker node environment.
A job running on an OSG worker node can refer to each directory using the corresponding environment variable.

To set up the environment variables that jobs will have on your worker nodes, edit the `[Local Settings]` section of your [OSG configuration](https://opensciencegrid.github.io/docs/other/configuration-with-osg-configure/#local-settings).

| Environment Variable | Purpose                                            | Notes                                                                                 |
|:---------------------|:---------------------------------------------------|:--------------------------------------------------------------------------------------|
| `$X509_CERT_DIR`     | Location of the CA certificates                    | If not defined, defaults to `/etc/grid-security/certificates`.                        |
| `$OSG_WN_TMP`        | Temporary storage area in which your job(s) run    | Local to each worker node (recommended size: 10 GB/job). Create a directory under this as your work area. Site administrators should use common batch-system capabilities to create a temporary, per-job directory that is clearned up after each job is run. Alternatively, administrators should ensure that this directory is purged periodically. |
| `$_CONDOR_SCRATCH_DIR` | Suggested temporary storage for glideinWMS-based payloads. | Users should prefer this environment variable over `$OSG_WN_TMP` if running inside glideinWMS.  |
| `$OSG_SQUID_LOCATION`, `$http_proxy` | Location of a HTTP caching proxy server | Utilize this service for downloading files via HTTP for cache-friendly workflows. |
| `$OSG_GRID`          | Location of additional environment variables.      | Pilots should source `$OSG_GRID/setup.sh` in order to guarantee the environment contains the worker node binaries in `$PATH`. |
| `$OSG_SITE_NAME`     | Name of the OSG resource where the worker node is located. |                                                                               |
| `$OSG_HOSTNAME`      | Hostname of the CE where this pilot was launched.  |                                                                                       |

Be careful with using `$OSG_WN_TMP`; at some sites, this directory might be shared with other VOs. We recommend creating a new sub-directory as a precaution:

```shell
mkdir -p $OSG_WN_TMP/MYVO
export mydir=`mktemp -d -t MYVO`
cd $mydir
# Run the rest of your application
rm -rf $mydir
```

This advice applies to maintainers of *pilot* software; end-users should contact their VO for advice (often, this will be either `$TMPDIR` or `$_CONDOR_SCRATCH_DIR`).
The pilot should utilize `$TMPDIR` to communicate the location of temporary storage to payloads.

A significant number of sites use the batch system to make an independent directory for each user job, and change `$OSG_WN_TMP` on the fly to point to this directory.

There is no way to know in advance how much scratch disk space any given worker node has available; recall, what disk space is available may be shared among a number of job slots.
