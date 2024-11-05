title: Using the Worker Node Containers

Using the Worker Node Containers
================================

!!! info "Where is the OSG 24 container?"
    We are actively reworking our image build infrastructure for OSG 24 and expect to have all OSG Software containers
    available by the end of 2024.

The OSG worker node containers contain the suggested base environment for worker nodes.  They can be used as a base image to build containers or to perform testing.

The containers are available on [Docker Hub](https://hub.docker.com/r/opensciencegrid/osg-wn/).

Available Containers
--------------------

Available tags include:

* `latest`: The latest version of the OSG worker node environment on the most recent supported OS.
  As of August 2021, this is OSG 3.6 and RHEL8.
* `3.6`: The OSG 3.6 release series on top of the most recent supported OS.  As of August 2021, this is RHEL8.
* `3.6-el7`: The OSG 3.6 release series on top of a RHEL7 environment.
* `3.6-el8`: The OSG 3.6 release series on top of a RHEL8 environment.

Building Upon the Container
---------------------------

You may base the container on the OSG worker node by including it inside your `Dockerfile`:

```
FROM opensciencegrid/osg-wn:latest
```

You can replace `latest` with any tag listed above.

Perform Testing
---------------

You may perform testing from within the OSG worker node envionment by running the command:

```
root@host # docker run -ti --rm opensciencegrid/osg-wn:latest /bin/bash
```
