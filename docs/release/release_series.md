DateReviewed: 2023-08-25
title: Release Series

Release Series
==============

OSG Software releases are organized into release series, with the intent that software updates within a series do will
not take require manual configuration updates, cause significant downtime, or break dependent software.

When a new series is released, it is an opportunity for the OSG Software Team to add major new software packages, make
substantial updates to existing packages, and remove obsolete packages.
When a new series is initially released, most packages are identical to the previous release, but two adjacent series
will diverge over time.

Support Policy
--------------

The OSG Software Team supports at most two concurrent release series, __current__ and __previous__, where the goal is to
begin a new release series about every 12 months.
Once a new series starts, the Software Team will support the previous series until the __next__ release series and will
announce its end-of-life date at least 6 months in advance.

When support ends for a release series, it means that the Software Team no longer updates the software, fixes issues, or
troubleshoots installations for releases within the series.
The plan is to maintain interoperability between supported series, but there is no guarantee that unsupported series
will continue to function.

Files for release series older than current or previous will be removed from the OSG Software repositories no earlier
than when support ends for the previous release.
For example, files for OSG 3.2 were not removed until May 2018, when support ended for OSG 3.3 in May 2018.

Series Overviews
----------------

Since the start of the RPM-based OSG Software Stack, we have offered the following release series:

-   **OSG 24** (started October 2024) introduces support for the ARM architecture.
    The initial release includes GlideinWMS 3.10.7, HTCondor 24.0.1, HTCondor 24.1.1, HTCondor-CE 24.0, and XRootD 5.7.0.

-   **OSG 23** (started October 2023) aligns the OSG release series and HTCondor Software Suite release cycles.
    The initial release includes GlideinWMS 3.10.5, HTCondor 23.0, HTCondor-CE 23.0, and XRootD 5.6.2

-   **OSG 3.6** (started February 2021, end-of-lifed June 2024) overhauled the authentication and data transfer 
    protocols used in the OSG software stack:
    bearer tokens, such as [SciTokens](https://scitokens.org/) or WLCG tokens, are used for authentication instead of
    GSI proxies and HTTP is used for data transfer instead of GridFTP.
    See the [OSG GridFTP and GSI migration plan](https://osg-htc.org/technology/policy/gridftp-gsi-migration/)
    for more details.
    To support these new protocols, OSG 3.6 includes HTCondor 8.9, HTCondor-CE 5, and will include XRootD 5.1.

-   **OSG 3.5** started in August 2019 and was end-of-lifed in May 2022.
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

Series Life-cycle
-----------------

Support ends at the end of the month of the following dates unless otherwise specified:

| Release Series | Initial Release | End of Regular Support | End of Critical Bug/Security Support |
|:--------------:|-----------------|------------------------|--------------------------------------|
| 24             | October 2024    | Not set                | Not set                              |
| 23             | October 2023    | Not set                | Not set                              |
| 3.6            | Februrary 2021  | 31 March 2024          | 30 June 2024                         |
| 3.5            | August 2019     | 30 August 2021         | 1 May 2022                           |
| 3.4            | June 2017       | 29 February 2020       | 30 November 2020                     |
| 3.3            | August 2015     | 31 December 2017       | 31 May 2018                          |
| 3.2            | November 2013   | 29 February 2016       | 31 August 2016                       |
| 3.1            | April 2012      | 31 October 2014        | 30 April 2015                        |


Installing an OSG Release Series
--------------------------------

See the [yum repositories document](../common/yum.md) for instructions on installing the OSG repositories.

<a name="updating-from-old"></a>

References
----------

-   [Yum repositories](../common/yum.md)
-   [Basic use of Yum](yum-basics.md)
