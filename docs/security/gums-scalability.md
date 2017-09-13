GUMS Scalability
================

About this Document
===================

The purpose of this document is to put together various GUMS configuration and system level settings that may help optimize GUMS server performance. It assumes you are familiar with GUMS, its installation and configuration as covered in [the GUMS install documentation](../security/gums).

Background
==========

In 2011 the FermiGrid Services group at Fermilab carried out various baseload/stress test runs against locally deployed GUMS server (gums1318.fnal.gov, which is actually a front end to 2 back end SL5 64bit servers gums1318a.fnal.gov and gums1318b.fnal.gov running gums 1.3.18.009-15.2). Each baseload run involved 50 clients contacting the server in parallel. Stress run, which was run on top of the baseload jobs, involved 5000 clients contacting the server in parallel (each client making 100 calls in succession). That load was chosen to simulate the case of an active production system when someone deletes a large batch of jobs that all suddenly run glexec to clean up. The purpose of these runs was to tune settings at various levels and achieve a 100% success rate for all calls (number of calls from baseload jobs + 500,000 calls from stress run jobs) made to GUMS server.

In 2015 the tests were repeated on gums-1.4.2-1 with 5000 and 8000 parallel clients each running 100 queries in series, and again in order to have 100% success rate the below Tomcat and System level settings had to be set to the number of parallel clients. In that test the GUMS server was 16 cores, the clients were running on 25 4-core fermicloud VMs, and the average rate of service was 350 queries per second.

Settings
========

GUMS configuration settings
---------------------------

In file `/etc/gums/gums.config`:

| **Setting** | **Value** | **Comments** |
|-------------|-----------|--------------|
| hibernate.c3p0.timeout | 300 | number of seconds after which an idle connection is removed from connection pool |
| hibernate.c3p0.max\_size | 300 | max number of db connections to keep in the connection pool |
| hibernate.c3p0.min\_size | 25 | min number of ready db connections to keep in the connection pool |
| hibernate.c3p0.numHelperThreads | 50 | see note below ; this setting isn't in the original template file from rpm, so it may need to be added in the config file |

!!! note
    The c3p0 library is very asynchronous. Slow JDBC operations are generally performed by helper threads that don't hold contended locks. Spreading these operations over multiple threads can significantly improve performance by allowing multiple operations to be performed simultaneously.

Tomcat settings
---------------

In file `/etc/tomcat5/server.xml` (`/etc/tomcat6/server.xml` on EL6), some of the following settings may not be in the original template file, just add them.

| **Setting** | **Value** |
|-------------|-----------|
| acceptCount | 4096 |

System level settings
=====================

In file `/etc/sysctl.conf`, some settings may not present in the file and need to be added there. Then run "sysctl -p" to reload these new settings.

| Setting            | Value | Comments |
|:-------------------|:------|:---------|
| net.core.somaxconn | 4096  |          |

References
==========

-   [GUMS Installation guide](../security/gums)
-   [Official Tomcat 5 documentation](https://tomcat.apache.org/tomcat-5.5-doc)
-   [Official Tomcat 6 documentation](https://tomcat.apache.org/tomcat-6.0-doc)
-   <http://www.hibernate.org/docs> Official hibernate documentation
-   [c3p0 documentation](http://www.mchange.com/projects/c3p0/) and [code](http://sourceforge.net/projects/c3p0/)

