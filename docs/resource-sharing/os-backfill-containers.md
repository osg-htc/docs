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

1. Set the `TOKEN` environment variable to the authentication token you received from OSG.
2. Set `GLIDEIN_Site` and `GLIDEIN_ResourceName` to match the site name and resource name you registered in topology,
   respectively.
3. Set the `OSG_SQUID_LOCATION` environment variable to the HTTP address of your preferred squid instance.
4. _Optional:_  Some sites prefer that job I/O is done in a specific temporary directory instead of inside the container.
   To do this, map the appropriate directory on the host to `/pilot` inside containers.
   If you are using Docker to launch the container, this is done with the command line flag `-v /somelocaldir:/pilot`.
5. _Optional:_ add an expression with the `GLIDEIN_Start_Extra` environment variable to append to the HTCondor `START`
   expression; this limits the pilot to only run certain jobs.

Here is an example invocation using `docker run` by hand:

```
docker run -it --rm --user osg \
       --cap-add=DAC_OVERRIDE --cap-add=SETUID --cap-add=SETGID \
       --cap-add=SYS_ADMIN --cap-add=SYS_CHROOT --cap-add=SYS_PTRACE \
       --cap-add=CAP_DAC_READ_SEARCH \
       -v /cvmfs:/cvmfs:shared \
       -e TOKEN="..." \
       -e GLIDEIN_Site="..." \
       -e GLIDEIN_ResourceName="..." \
       -e GLIDEIN_Start_Extra="True" \
       -e OSG_SQUID_LOCATION="..." \
       opensciencegrid/osgvo-docker-pilot:release
```

Note the additional capabilities requested in the above `docker run` allow the container to invoke `singularity` for
user jobs; this allows the user to utilize a container for their job that is different from the pilot.
