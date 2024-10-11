title: Using the Worker Node Containers

Using the Worker Node Containers
================================

The OSG worker node containers contain the suggested base environment for worker nodes.  They can be used as a base image to build containers or to perform testing.

The containers are available on [Docker Hub](https://hub.docker.com/r/opensciencegrid/osg-wn/).

Available Containers
--------------------

Available tags include:

* `latest`: The latest version of the OSG worker node environment on the most recent supported OS.
  As of October 2024, this is OSG 24 and RHEL9.
* `24`: The OSG 24 release series on top of the most recent supported OS.  As of October 2024, this is RHEL9.
* `24-el8`: The OSG 24 release series on top of a RHEL8 environment.
* `24-el9`: The OSG 24 release series on top of a RHEL9 environment.

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

