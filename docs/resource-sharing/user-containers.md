User-launched Containers with Singularity
=========================================

The [OSG pilot container](os-backfill-containers.md) can be launched by users in order to run jobs on resources they
have access to.
The most common use case, documented here, is to start the pilot container inside a Slurm batch job that is launched by
the user.

This is a great way to add personal resources to the Open Science Pool to increase throughput for a specific workflow.

Before Starting
---------------

In order to configure the container, you will need:

1. A [registered resource](../common/registration.md) in OSG Topology;
   resource registration allows OSG to do proper usage accounting and maintain contacts in case of security incidents.
2. An authentication token from the OSG.
   Please contact [OSG support](mailto:support@opensciencegrid.org) to request a token for your user.

Launching Inside Slurm
----------------------

To launch inside Slurm, one needs to write a small job control script; the details will vary from site-to-site and the
following is given as an example for running on compute hosts with 24 cores:

```bash
#!/bin/bash
#SBATCH --job-name=osg-glidein
#SBATCH -p compute
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -t 48:00:00
#SBATCH --output=osg-glidein-%j.log

export TOKEN="put_your_provided_token_here"

# Set this so that the OSG accouting knows where the jobs ran
export GLIDEIN_Site="SDSC"
export GLIDEIN_ResourceName="Comet"

# This is an important setting limiting what jobs your glideins will accept.
# At the minimum, the expression should limit the "Owner" of the jobs to
# whatever your username is on the OSG _submit_ side
export GLIDEIN_Start_Extra="Owner == \"my_osgconnect_username\""

module load singularity
singularity run --contain \
                --bind /cvmfs \
                --scratch /pilot \
                docker://opensciencegrid/osgvo-docker-pilot:release
```

The above example rebuilds the Docker container on each host.
If you plan to run large numbers of these jobs, you can download the Docker container once and create a local
Singularity image:

```
$ singularity build osgvo-pilot.sif docker://opensciencegrid/osgvo-docker-pilot:release
```

In this case, the `singularity run` command should be changed to:

```
singularity run --contain --bind /cvmfs --scratch /pilot osgvo-pilot.sif
```

Note, unlike the [site-launched container](os-backfill-containers.md), the Singularity container above
_cannot_ run payloads inside a separate image.
