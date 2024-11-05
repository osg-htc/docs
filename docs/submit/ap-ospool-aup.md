title: Acceptable Use Policy For OSG Access Points and the OSPool

Acceptable Use Policy For OSG Access Points and the OSPool
==========================================================

The OSG Access Points and the [Open Science Pool](https://osg-htc.org/about/open_science_pool/) (OSPool) are
shared resources in support of US Open Science research.
As a shared resource, actions of one researcher can impact other researchers.
It is therefore important that all parties involved in using or operating these OSG services follow the Acceptable Use
Policies (AUP).

The OSPool offers capacity contributed by organizations that are members of the OSG Compute Federation.
These contributions are entrusted to the OSG Consortium to be shared with US researchers and their collaborators in
support of their research.
It is the responsibility of all parties involved to maximize the impact of these contributions to Open Science. 

The OSG operates shared Access Points (<https://connect.osg-htc.org>) that provide researchers with capabilities to
harness the capacity of the OSPool.
Misuse of the resources of these Access Points can slow down or prevent the launching of jobs to the OSPool or file
movement to and from jobs served by the OSPool.

This AUP outlines the responsibilities for operators of Access Points and researchers that place their workloads on
OSG-managed Access Points that harness the capacity of the OSPool.

General Use Limitations
-----------------------

In addition to the user or operator specific policies outlined in the sections below,
all AP users and operators are expected to adhere to the following usage limitations:

-   You agree that work running on the OSPool through your Access Point will be relevant to research and/or education
    efforts associated with an academic, government, or non-profit institution in the United States.
    Use by external collaborators of such an institution are permitted, provided they are relevant as defined above.
    Use of other resources and services via the Access Point should also follow relevant policies of use for those
    resources and services.
-   Efforts benefitting from the OSPool and other Access Point features shall provide appropriate acknowledgement of
    support or citation;
    please see
    [this page](https://osg-htc.org/acknowledging)
    for information about citation.
-   You shall not use the Access Point or OSPool for any purpose that is unlawful and not (attempt to) breach or
    circumvent any administrative or security controls.
-   You shall respect intellectual property and confidentiality agreements.
-   You shall protect your access credentials (e.g. private keys, tokens, or passwords).
-   You shall keep all your registered information correct and up to date.
-   You shall immediately report any known or suspected security breach or misuse of the resources/services or access
    credentials to the specified incident reporting locations and to the relevant credential-issuing authorities.
-   You use the resources/services at your own risk. There is no guarantee that the
    resources/services will be available at any time or that their integrity or confidentiality will be preserved or
    that they will suit any purpose.
-   You agree that logged information, including personal data provided by you for registration purposes, may be used
    for administrative, operational, accounting, monitoring and security purposes.
    You agree that this logged information may be disclosed to other authorized participants via secured mechanisms,
    only for the same purposes and only as far as necessary to provide the services.
-   You agree that the body or bodies granting you access and resource/service providers are entitled to regulate,
    suspend or terminate your access without prior notice and without compensation, within their domain of authority,
    and you shall immediately comply with their instructions.
-   You are liable for the consequences of your violation of any of these conditions of use, which may include but are
    not limited to the reporting of your violation to your home institute and, if the activities are thought to be
    illegal, to appropriate law enforcement agencies.
-   You are responsible for ensuring that your use of OSG Connect and the OSPool is appropriate and does not violate any
    other requirements.
    This includes adhering to any applicable agreements regarding appropriate use, any regulatory requirements, any
    licensing agreements, privacy agreements, or any other requirements covering the data and software which you use
    with OSG Connect or the OSPool.

Access Point Operation Policy
-----------------------------

This Operational Policy enumerates the roles and responsibilities of the Access Point (AP) operator;
the operator of an AP is then responsible for their users' behaviors.

The OSG Consortium collects metadata about the jobs run on the OSPool to present resources and funding agencies with
information like the resource usage, project, and field of science;
APs must participate in this resource accounting system.
Additionally, the statistics about jobs (aggregated per-user-per-project) will be used to monitor the overall health and
throughput of the pool;
staff may follow up with APs in light of poor resource utilization.

The AP operator agrees to keep the installed HTCondor Software Suite (HTCSS) versions up-to-date:

1.  An OSPool AP must run on a
    [supported release series of HTCSS](https://htcondor.readthedocs.io/en/latest/version-history/introduction-version-history.html#support-life-cycle).
    Supported release series include series that are under regular or security support.
1.  The release may be no more than 4 months behind the latest version in the release series.
1.  The release may be no more than 1 month behind the latest security patch in the release series.

In practice, the minimum required versions for each of the supported release series are as follows:

| **HTCondor Release Series** | **Required Minimum Version** |
|-----------------------------|------------------------------|
| 23.x.y                      | 23.8.1                       |
| 23.0.y                      | 23.0.14                      |

As the OSPool operations staff has a responsibility to the entire pool, the OSPool operations staff may disable the AP’s
connection to the OSPool, as necessary, to maintain operational integrity and resource utilization.
When disabled, the AP will no longer receive resources from the OSPool (but may still use other non-OSPool resources).
If the OSPool operators are unable to contact the AP administrator in a timely manner to respond to an urgent
operational issue (such as a security incident or workload crashing execution points), they may disable the AP.
To reduce the security attack surface of the OSPool, operators will disable APs that have been idle for more than 90
days.  APs will need to contact the OSPool operators to be re-enabled.
