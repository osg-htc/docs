Contrib software
================

What is the contrib software repository?
----------------------------------------

In addition to our regular software repository, we also have a *contrib* (short for "contributed") software repository. This is software that is does not go through the same software testing and release processes as the official OSG Software release, but may be useful to you.

Caveats
-------

You should be aware:

-   The software in the contrib repository may have been more lightly tested than software in our official release. In particular, we do not test all of the software in the contrib repository together, and there is no guarantee all the software in compatible or even that it works.
-   If you have problems with the software in the contrib repository, you can ask us for help, but you may be on your own. This software is not officially supported and we may not have time to help you with it.

Do you want more software in the repository?
--------------------------------------------

We're happy to work with you to add more software to the contrib repository. If you provide the RPM packaging (preferably a spec file, so we can build it), it will get into the repository than if we have to do the packaging ourselves.

What software is in the contrib repository?
-------------------------------------------

The definitive list of software in the contrib repository is the repository itself. You can browse:

-   [The EL5 contrib software repository](http://repo.grid.iu.edu/3.0/el5/osg-contrib/x86_64/)
-   [The EL6 contrib software repository](http://repo.grid.iu.edu/3.0/el6/osg-contrib/x86_64/)

The software includes:

-   **gsh:** Gsh is the "grid shell". It acts like a simple shell, something like bash, but with fewer features. All of the commands are run with globus-job-run against a remote Compute Element. This can be a very convenient way to debug a Compute Element.
-   **glideinwms**: The `osg-contrib` repository contains the development series for the GlideinWMS workload management system. This system submits condor-based pilots to grid sites to create a dynamic worker node pool for user jobs. Contained in the RPMs are packages for frontend and factory installations. This repository contains the development series that has newer features still in wider testing. At the time of writing, this series is the version 3 with new features for submission to clouds and to TeraGrid sites using corral frontends. For more stable installations, use the `osg-release` or `osg-testing` repositories.
-   **xrootd-cmstfc**: This package is for a plugin for xrootd storage system to provide a static rule-based logical to physical mapping. This is primarily used by the CMS experiment.
-   **xrootd-status-probe**: This package is a simple nagios probe for xrootd that verifies the first kilobyte of a multi-GB file.
-   **cms-xrootd**: Meta-packages containing sample configuration files for joining the CMS xrootd infrastructure.

Installing from the contrib repository
--------------------------------------

To install software, you need to enable the osg-cotrib repository. The easiest way to do that is on case-by-case basis in the `yum` command-line. For example, to install `gsh`:

``` console
[root@client ~] $ yum install --enablerepo=osg-contrib gsh
```

