<span class="twiki-macro DOC_STATUS_TABLE"></span>

OSG Upcoming Software Repositories Installation Guide
=====================================================

<span class="twiki-macro TOC" depth="2"></span>

---\# About this Document

Here we describe the OSG Upcoming Software Repositories, their purpose, and how to use them.

This document is intended for site administrators.

---\# Overview and Purpose

Certain sites have requested new versions of software that would be considered "disruptive" or "experimental" -- upgrading to them would likely require manual intervention before the site would come back up. We do not want sites to unwittingly upgrade to these versions. For the benefit of the sites that do want to upgrade, we want to provide the same assurance of quality and production-readiness that we provide to the software we currently ship now.

Due to the relatively small number of such packages, a full fork of the OSG 3 distribution was not warranted. Instead, we have created a separate set of repositories that contain only the "disruptive" versions of the software.

These repositories have the same structure as our standard repositories. For example, there is an `osg-upcoming-testing` repository and an `osg-upcoming` repository.

A full installation of our software stack is *not* be possible using only the `osg-upcoming` repositories, since they contain a small subset of the software we ship. Both the main `osg` and the `osg-upcoming` repositories will need to be enabled for the installation to work. Because of this, interoperability will be maintained between the main `osg` and `osg-upcoming`.

Depending on test results from sites, some packages in `osg-upcoming` may eventually end up in the main `osg` branch. The rest of the packages will eventually form the nucleus of the next fork of the software stack (e.g. "OSG 3.2").

---\# Installation and Usage

The following directions must be followed to install software from the Upcoming repositories.

First, install the standard OSG yum repositories:

<span class="twiki-macro INCLUDE" section="OSGRepoBrief" TOC_SHIFT="+">YumRepositories</span>

---\#\# Enabling Upcoming repositories

You must have the 3.0-22 or newer version of the `osg-release` package to use the upcoming repositories. That version was released in OSG Software Release 3.1.15. To obtain the version currently installed, run the following:

``` screen
%UCL_PROMPT% rpm -q osg-release
```

If it does not print `osg-release-3.0-22` or higher, upgrade by running:

``` rootscreen
%UCL_ROOT_PROMPT% yum upgrade osg-release
```

You should have a file called `osg-upcoming.repo` (el5) or `osg-el6-upcoming.repo` (el6) located in `/etc/yum.repos.d`. At the top, it should have a section looking like this (el5):

``` file
[osg-upcoming]
name=OSG Software for Enterprise Linux 5 - Upcoming - $basearch
#baseurl=http://repo.grid.iu.edu/3.0/el5/osg-upcoming-release/$basearch
mirrorlist=http://repo.grid.iu.edu/mirror/3.0/el5/osg-upcoming-release/$basearch
failovermethod=priority
priority=98
%RED%enabled=0%ENDCOLOR%
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
consider_as_osg=yes
```

Edit this file, and under the section `[osg-upcoming]`, change `enabled=0` to `enabled=1`. This will enable the production upcoming software repositories. Future yum installs will bring in software from the upcoming repositories.

---\# Get Help/Support To get assistance please use [this page](Documentation/Release3.HelpProcedure).

---\# Comments <span class="twiki-macro COMMENT" type="tableappend"></span>
