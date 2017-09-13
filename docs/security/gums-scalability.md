!!! warning
    GUMS is no longer be supported in OSG 3.4. The [LCMAPS VOMS Plugin](../security/lcmaps-voms-authentication) is the preferred method for site authentication in the OSG and is available in both OSG 3.3 and OSG 3.4.

!!! warning
    These experiments were run on EL 5 machines. EL 5 is no longer supported as of OSG 3.3.

GUMS Scalability
================

About this Document
===================

The purpose of this document is to put together various GUMS configuration and system level settings that may help optimize GUMS server performance. It assumes you are familiar with GUMS, its installation and configuration as covered in [the GUMS install documentation](../security/install-gums).

Background
==========

In 2011, the FermiGrid Services group at Fermilab carried out various baseload/stress test runs against a locally deployed GUMS server.
The purpose of these tests were to tune settings in order to achieve a 100% success rate for all calls (both baseload jobs and stress run jobs) made to the GUMS server.
The GUMS server was named `gums1318.fnal.gov`.
This machine was actually a front end to two back end SL5 64bit servers, `gums1318a.fnal.gov` and `gums1318b.fnal.gov`, running GUMS 1.3.18.009-15.2.

Each baseload run involved 50 clients contacting the server in parallel.
The stress run, which was run on top of the baseload jobs, involved 5000 clients contacting the server in parallel,
each client making 100 calls in succession.
(That load was chosen to simulate the case of an active production system when someone deletes a large batch of jobs;
this would suddenly cause all jobs to run glExec to clean up.)
In addition to calls from baseload jobs, the stress run jobs provided a total of 500,000 calls to the GUMS server.

In 2015 the tests were repeated with GUMS 1.4.2-1.
We tested first with 5000 and then 8000 parallel clients, each running 100 queries in series.
The GUMS server was 16 cores, and the clients were running on 25 4-core FermiCloud VMs.
The average rate of service was 350 queries per second.

Settings
========

We tuned the configuration in order to make the tests above successful.

GUMS configuration settings
---------------------------

In file `/etc/gums/gums.config`:

| **Setting** | **Value** | **Comments** |
|-------------|-----------|--------------|
| `hibernate.c3p0.timeout` | 300 | number of seconds after which an idle connection is removed from connection pool |
| `hibernate.c3p0.max_size` | 300 | max number of db connections to keep in the connection pool |
| `hibernate.c3p0.min_size` | 25 | min number of ready db connections to keep in the connection pool |
| `hibernate.c3p0.numHelperThreads` | 50 | see note below; this setting isn't in the original template file from rpm, so it may need to be added in the config file |

!!! note
    The c3p0 library is very asynchronous. Slow JDBC operations are generally performed by helper threads that don't hold contended locks. Spreading these operations over multiple threads can significantly improve performance by allowing multiple operations to be performed simultaneously.

Tomcat settings
---------------

In file `/etc/tomcat5/server.xml` (`/etc/tomcat6/server.xml` on EL6), some of the following settings may not be in the original template file, just add them.

| **Setting**   | **Value** |
|---------------|-----------|
| `acceptCount` | 4096      |

System level settings
=====================

In file `/etc/sysctl.conf`, some settings may not present in the file and need to be added there. Then run `sysctl -p` to reload these new settings.

| Setting              | Value | Comments |
|:---------------------|:------|:---------|
| `net.core.somaxconn` | 4096  |          |

References
==========

-   [GUMS Installation guide](../security/install-gums)
-   [Official Tomcat 5 documentation](https://tomcat.apache.org/tomcat-5.5-doc)
-   [Official Tomcat 6 documentation](https://tomcat.apache.org/tomcat-6.0-doc)
-   <http://www.hibernate.org/docs> Official hibernate documentation
-   [c3p0 documentation](http://www.mchange.com/projects/c3p0/) and [code](http://sourceforge.net/projects/c3p0/)

