title: Updating to OSG 24

Updating to OSG 24
==================

[OSG 24](release_series.md#series-overviews) (the *new series*) introduces support for the ARM architecture. Changes
required to upgrade from OSG 23 are relatively minor.

Updating Container-based OSPool EP Deployments
-----------------------------

In OSG 24, the `opensciencegrid/osgvo-docker-pilot` worker node docker image has been renamed to `osg-htc/ospool-ep`.
To upgrade your docker-based worker nodes from OSG 23 to OSG 24, follow the sections below:

#### Via Docker Run ####

For sites running the container [directly via docker](../resource-sharing/os-backfill-containers.md#running-the-container-with-docker),
the EP container can be updated by changing the image name referenced in the `docker run` command. All other arguments to the 
`docker run` command may remain the same. 

```console
root@host # docker run <existing docker args> hub.opensciencegrid.org/osg-htc/ospool-ep:24-release
```

#### Via RPM ####

For sites running the EP container [via rpm installation](../resource-sharing/os-backfill-containers.md#running-the-container-via-rpm),
the container can be upgraded by updating the RPM.

1. [Install](../common/yum.md#install-the-osg-repositories) the OSG 24 Yum repositories

1. Upgrade the `ospool-ep` rpm:

        :::console
        root@host # yum install ospool-ep

1. (Optional) Clean up `/etc/osg/ospool-ep.cfg`:
    - A bug in the OSG 23 release of ospool-ep required users to add a `WORK_TEMP_DIR` config field as a copy of the default `WORKER_TEMP_DIR`.
    When upgrading to OSG 24, remove the duplicated `WORK_TEMP_DIR` field.

1. Restart the ospool-ep systemctl service:

        :::console
        root@host # systemctl restart ospool-ep
