
Using the Worker Node Containers
================================

The OSG worker node containers contain the suggested base environment for worker nodes.  They can be used as a base image to build containers, run jobs within, or to perform testing.

The containers are available on [Docker Hub](https://hub.docker.com/r/opensciencegrid/osg-wn/).

Available Containers
--------------------

Available tags include:

* `latest`: The latest version of the OSG worker node environment on the most recent supported OS.  As of June 2017, this is OSG 3.4 and RHEL7.
* `3.4`: The OSG 3.4 release series on top of the most recent supported OS.  As of June 2017, this is RHEL7.
* `3.4-el7`: The OSG 3.4 release series on top of a RHEL7 environment.
* `3.4-el6`: The OSG 3.4 release series on top of a RHEL6 environment.

Building Upon the Container
---------------------------

You may base the container on the OSG worker node by including it inside your `Dockerfile`:

    FROM opensciencegrid/osg-wn:latest
    ...

You can replace `latest` with any tag listed above.

Perform Testing
---------------

You may perform testing from within the OSG worker node envionment by running the command:

    root@host # docker run -ti --rm opensciencegrid/osg-wn:latest /bin/bash


Running Jobs Within Container
-----------------------------

Running jobs within a container requires special configuration of the scheduler.  For example, in HTCondor, you may configure to run each job within a docker container using the [Docker universe](http://research.cs.wisc.edu/htcondor/manual/v8.8/DockerUniverseApplications.html#x24-1260002.12).


