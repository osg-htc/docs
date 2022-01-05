**Release Series**
==================

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

Series Overviews
----------------

Since the start of the RPM-based OSG software stack, we have offered the following release series:

!!! danger "Before considering an upgrade to OSG 3.6&hellip;"
    Due to potentially disruptive changes in protocols, contact your VO(s) to verify that they support token-based
    authentication and/or HTTP-based data transfer before considering an upgrade to OSG 3.6.
    If your VO(s) don't support these new protocols or you don't know which protocols your VO(s) support,
    install or remain on the [OSG 3.5 release series](notes.md).

-   **OSG 3.5** was started in August 2019 and will reach its end-of-life at the end of February 2022.
    The main differences between it and 3.4 were the introduction of the HTCondor 8.8 and 8.9 series;
    also the RSV monitoring probes, EL6 support, and CREAM support were all dropped.

-   **OSG 3.6** (started February 2021) overhauls the authentication and data transfer protocols used in the OSG
    software stack:
    bearer tokens, such as [SciTokens](https://scitokens.org/) or WLCG tokens, are used for authentication instead of
    GSI proxies and HTTP is used for data transfer instead of GridFTP.
    See the [OSG GridFTP and GSI migration plan](https://opensciencegrid.org/technology/policy/gridftp-gsi-migration/)
    for more details.
    To support these new protocols, OSG 3.6 includes HTCondor 8.9, HTCondor-CE 5, and will include XRootD 5.1.

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

Installing an OSG Release Series
--------------------------------

See the [yum repositories document](../common/yum.md) for instructions on installing the OSG repositories.

<a name="updating-from-old"></a>

References
----------

-   [Yum repositories](../common/yum.md)
-   [Basic use of Yum](yum-basics.md)
