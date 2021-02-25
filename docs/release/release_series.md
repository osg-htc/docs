**OSG Release Series**
======================

An OSG release series is a sequence of OSG software releases that are intended to provide a painless upgrade path.
For example, the 3.2 release series contains OSG software 3.2.0, 3.2.1, 3.2.2, and so forth.
A release series corresponds to a set of Yum software repositories, including ones for development, testing, and
production use.
The Yum repositories for one release series are completely distinct from the repositories for a different release
series, even though they share many common packages.
A particular release within a series is a snapshot of packages and their exact versions at one point in time.
When you install software from a release series, say 3.2, you get the most current versions of software packages within
that series, regardless of the current release version.

When a new series is released, it is an opportunity for the OSG Technology area to add major new software packages, make
substantial updates to existing packages, and remove obsolete packages.
When a new series is initially released, most packages are identical to the previous release, but two adjacent series
will diverge over time.

Our goal is, within a series, that one may upgrade their OSG services via `yum update` cleanly and without any necessary
config file changes or excessive downtime.

OSG Release Series
------------------

Since the start of the RPM-based OSG software stack, we have offered the following release series:

-   **OSG 3.5** started August 2019.
    The main differences between it and 3.4 were the introduction of the HTCondor 8.8 and 8.9 series;
    also the RSV monitoring probes, EL6 support, and CREAM support were all dropped.

-   **OSG 3.4** started June 2017 and was end-of-lifed in November 2020.
    The main differences between it and 3.3 are the removal of edg-mkgridmap, GUMS, BeStMan, and VOMS Admin Server
    packages.

-   **OSG 3.3** started in August 2015 and was end-of-lifed in May 2018.
    While the files have not been removed, it is strongly recommended that it not be installed anymore.
    The main differences between 3.3 and 3.2 are the dropping of EL5 support, the addition of EL7 support, and the
    dropping of Globus GRAM support.

-   **OSG 3.2** started in November 2013, and was end-of-lifed in August 2016.
    The main differences between it and 3.1 were the introduction of glideinWMS 3.2, HTCondor 8.0, and Hadoop/HDFS 2.0;
    also the gLite CE Monitor system was dropped in favor of osg-info-services.

-   **OSG 3.1** started in April 2012, and was end-of-lifed in April 2015.
    Historically, there were 3.0.x releases as well, but there was no separate release series for 3.0 and 3.1;
    we simply went from 3.0.10 to 3.1.0 in the same repositories.

OSG Upcoming
------------

There is one more OSG Series called "upcoming" which contains major updates planned for a future release series.
The yum repositories for upcoming (`osg-upcoming` and `osg-upcoming-testing`) are available from all OSG 3.x series, and
individual packages can be installed from Upcoming without needing to update entirely to a new series.
Note, however, that packages in the "upcoming" repositories are tested against the most recent OSG series.
As of the time of writing, `osg-upcoming` is meant to work with OSG 3.5.

Installing an OSG Release Series
--------------------------------

See the [yum repositories document](../common/yum.md) for instructions on installing the OSG repositories.

<a name="updating-from-old"></a>

References
----------

-   [Yum repositories](../common/yum.md)
-   [Basic use of Yum](yum-basics.md)

