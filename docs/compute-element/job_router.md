Writing Routes For HTCondor-CE
==============================

<span class="twiki-macro TOC" depth="4"></span>

About This Guide
----------------

The [JobRouter](http://research.cs.wisc.edu/htcondor/manual/v8.2/5_4HTCondor_Job.html) is at the heart of HTCondor-CE and allows admins to transform and direct jobs to specific batch systems. Customizations are made in the form of job routes where each route corresponds to a separate job transformation: If an incoming job matches a job route‘s requirements, the route creates a transformed job (referred to as the ’routed job’) that is then submitted to the batch system. The CE package comes with default routes located in `/etc/condor-ce/config.d/02-ce-*.conf` that provide enough basic functionality for a small site.

If you have needs beyond delegating all incoming jobs to your batch system as they are, this document provides examples of common job routes and job route problems.

<span class="twiki-macro STARTSECTION">RoutePitfalls</span>

Quirks and Pitfalls
-------------------

-   The JobRouter matches jobs to routes in a round-robin fashion. This means that if a job can match to multiple routes, it can be routed by any of them! So when writing job routes, make sure that they are exclusive to each other and that your jobs can only match to a single route.
-   If a value is set in [JOB\_ROUTER\_DEFAULTS](#JobRouterDefaults) with `eval_set_<variable>`, override it by using `eval_set_<variable>` in the `JOB_ROUTER_ENTRIES`. Do this at your own risk as it may cause the CE to break.
-   Make sure to run `condor_ce_reconfig` after changing your routes, otherwise they will not take effect.
-   Before the last square bracket, make sure all lines end in a line continuation character (backslash). You can inspect the syntax of your routes with `condor_ce_config_val JOB_ROUTER_ENTRIES` to see if HTCondor-CE has ingested them properly.
-   Do **not** set the [JOB\_ROUTER\_DEFAULTS](#JobRouterDefaults) configuration variable yourself. This will cause the CE to stop functioning.
-   Do **not** set the job environment through the JobRouter. Instead, add any changes to the /etc/osg/config.d/ `[Local Settings]` section and run osg-configure, as documented [here](https://twiki.grid.iu.edu/bin/view/ReleaseDocumentation/ConfigurationFileLocalSettings).
-   HTCondor batch system only: Local universe jobs are excluded from any routing.

<span class="twiki-macro ENDSECTION"></span>

\#JobRouteConstruction

How Job Routes are Constructed
------------------------------

Each job route’s [ClassAd](http://research.cs.wisc.edu/htcondor/manual/v8.2/4_1HTCondor_s_ClassAd.html) is constructed by combining each entry from the `JOB_ROUTER_ENTRIES` with the `JOB_ROUTER_DEFAULTS`. Attributes that are set in `JOB_ROUTER_ENTRIES` will override those set in `JOB_ROUTER_DEFAULTS`

### JOB\_ROUTER\_ENTRIES

`JOB_ROUTER_ENTRIES` is a configuration variable whose default is set in `/etc/condor-ce/config.d/02-ce-*.conf` but may be overriden by the administrator in `/etc/condor-ce/config.d/99-local.conf`. This document outlines the many changes you can make to `JOB_ROUTER_ENTRIES` to fit your site’s needs.

\#JobRouterDefaults

### JOB\_ROUTER\_DEFAULTS

`JOB_ROUTER_DEFAULTS` is a python-generated configuration variable that sets default job route values that are required for the HTCondor-CE’s functionality. To view its contents, run the following command:

``` screen
%UCL_PROMPT% condor_ce_config_val JOB_ROUTER_DEFAULTS | sed 's/;/;\n/g'
```

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_OUTPUT% showlink="Show sample output"</span>

``` screen
[ MaxIdleJobs = 2000;
 MaxJobs = 10000;
 /* by default, accept all jobs */ Requirements = True;
 /* now modify routed job attributes */ /* remove routed job if the client disappears for 48 hours or it is idle for 6 */ /*set_PeriodicRemove = (LastClientContact - time() > 48*60*60) || (JobStatus == 1 && (time() - QDate) > 6*60);
*/ delete_PeriodicRemove = true;
 delete_CondorCE = true;
 set_RoutedJob = true;
 copy_environment = "orig_environment";
 set_osg_environment = "OSG_GRID='/etc/osg/wn-client/' OSG_SQUID_LOCATION='fermicloud133.fnal.gov:3128' OSG_SITE_READ='None' OSG_APP='/share/osg/app' OSG_GLEXEC_LOCATION='None' OSG_DATA='UNAVAILABLE' OSG_HOSTNAME='fermicloud136.fnal.gov' OSG_STORAGE_ELEMENT='False' OSG_SITE_NAME='herp' GLOBUS_LOCATION='/usr' OSG_WN_TMP='None' OSG_DEFAULT_SE='None' OSG_SITE_WRITE='None'";
 eval_set_environment = debug(strcat("HOME=", userHome(Owner, "/"), " ", ifThenElse(orig_environment is undefined, osg_environment, strcat(osg_environment, " ", orig_environment) )));
 /* Set new requirements */ /* set_requirements = LastClientContact - time() < 30*60;
 */ set_requirements = True;
 set_InputRSL = ifThenElse(GlobusRSL is null, [], eval_rsl(GlobusRSL));
 /* Note default memory request of 2GB */ /* Note yet another nested condition allow pass attributes (maxMemory,xcount,jobtype,queue) via gWMS Factory described within ClassAd if undefined via RSL */ eval_set_RequestMemory = ifThenElse(InputRSL.maxMemory isnt null, InputRSL.maxMemory, ifThenElse(maxMemory isnt null, maxMemory, ifThenElse(default_maxMemory isnt null, default_maxMemory, 2000)));
 eval_set_remote_queue = ifThenElse(InputRSL.queue isnt null, InputRSL.queue, ifThenElse(queue isnt null, queue, ifThenElse(default_queue isnt null, default_queue, "")));
 /* HTCondor uses RequestCpus;
 blahp uses SMPGranularity and NodeNumber.  Default is 1 core. */ eval_set_RequestCpus = ifThenElse(InputRSL.xcount isnt null, InputRSL.xcount, ifThenElse(xcount isnt null, xcount, ifThenElse(default_xcount isnt null, default_xcount, 1)));
 eval_set_remote_SMPGranularity = ifThenElse(InputRSL.xcount isnt null, InputRSL.xcount, ifThenElse(xcount isnt null, xcount, ifThenElse(default_xcount isnt null, default_xcount, 1)));
 eval_set_remote_NodeNumber = ifThenElse(InputRSL.xcount isnt null, InputRSL.xcount, ifThenElse(xcount isnt null, xcount, ifThenElse(default_xcount isnt null, default_xcount, 1)));
 /* If remote_cerequirements is a string, BLAH will parse it as an expression before examining it */ eval_set_remote_cerequirements = ifThenElse(InputRSL.maxWalTlime isnt null, strcat("Walltime == ", string(60*InputRSL.maxWallTime), " && CondorCE == 1"), ifThenElse(maxWallTime isnt null, strcat("Walltime == ", string(60*maxWallTime), " && CondorCE == 1"), ifThenElse(default_maxWallTime isnt null, strcat("Walltime == ", string(60*default_maxWallTime), " && CondorCE == 1"), "CondorCE == 1")));
 ]
```

<span class="twiki-macro ENDTWISTY"></span>

<span class="twiki-macro NOTE"></span> If a value is set in [JOB\_ROUTER\_DEFAULTS](#JobRouterDefaults) with `eval_set_<variable>`, override it by using `eval_set_<variable>` in the `JOB_ROUTER_ENTRIES`. Do this at your own risk as it may cause the CE to break. <span class="twiki-macro NOTE"></span> Do **not** set the `JOB_ROUTER_DEFAULTS` configuration variable yourself. This will cause the CE to stop functioning.

Generic Routes
--------------

New routes should be placed in `/etc/condor-ce/config.d/99-local.conf`, not the original `02-ce-*.conf`.

### Required fields

The minimum requirements for a route are that you specify the type of batch system that jobs should be routed to and a name for each route. Default routes can be found in `/usr/share/condor-ce/config.d/02-ce-<batch system>-defaults.conf`, provided by the `osg-ce-<batch system>` packages.

#### Batch system

Each route needs to indicate the type of batch system that jobs should be routed to. For HTCondor batch systems, the `TargetUniverse` attribute needs to be set to `5` or `"vanilla"`. For all other batch systems, the `TargetUniverse` attribute needs to be set to `9` or `"grid"` and the `GridResource` attribute needs to be set to `"batch <batch system>"` (where `<batch system>` can be one of `pbs` (for both users of `pbs` and `SLURM`), `lsf`, or `sge`).

``` file
JOB_ROUTER_ENTRIES = [ \
     <span style="background-color: #FFCCFF;"><b># Route to an HTCondor-CE batch system \</b></span>
     <span style="background-color: #FFCCFF;"><b>TargetUniverse = 5; \</b></span>
     name = "Route jobs to HTCondor"; \
] \
[ \
     <span style="background-color: #FFCCFF;"><b># Route to a PBS batch system \</b></span>
     <span style="background-color: #FFCCFF;"><b>GridResource = "batch pbs"; \</b></span>
     <span style="background-color: #FFCCFF;"><b>TargetUniverse = 9; \</b></span>
     name = "Route jobs to PBS"; \
]
```

#### Route name

To identify routes, you will need to assign a name to the route with the `name` attribute:

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     <span style="background-color: #FFCCFF;"><b>name = "Route jobs to HTCondor"; \</b></span>
]
```

The name of the route will be useful in debugging since it shows up in the output of [condor\_ce\_job\_router\_info](Documentation/Release3.TroubleshootingHTCondorCE#condor_ce_job_router_info), the [JobRouterLog](Documentation/Release3.TroubleshootingHTCondorCE#JobRouterLog_AN1), and in the ClassAd of the routed job, which can be viewed with [condor\_ce\_q](Documentation/Release3.TroubleshootingHTCondorCE#condor_ce_q) or [condor\_ce\_history](Documentation/Release3.TroubleshootingHTCondorCE#condor_ce_history).

### Writing multiple routes

If your batch system needs incoming jobs to be sorted (e.g. if different VO’s need to go to separate queues), you will need to write multiple job routes. Each route is enclosed by square brackets and unless they’re the last closing bracket, they need to be followed by the line continuation character. The following routes takes incoming jobs that have a `queue` attribute set to `"analy"` and routes them to the site’s HTCondor batch system. Any other jobs will be sent to that site’s PBS batch system.

<span class="twiki-macro NOTE"></span> The JobRouter matches jobs to routes in a round-robin fashion. This means that if a job can match to multiple routes, it can be routed by any of them! So when writing job routes, make sure that they are exclusive to each other and that your jobs can only match to a single route.

``` file
JOB_ROUTER_ENTRIES = <span style="background-color: #FFCCFF;"><b>[ \</b></span>
     TargetUniverse = 5; \
     name = "Route jobs to HTCondor"; \
     Requirements = (TARGET.queue =?= "analy"); \
<span style="background-color: #FFCCFF;"><b>] \</b></span>
<span style="background-color: #FFCCFF;"><b>[ \</b></span>
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Route jobs to PBS"; \
     Requirements = (TARGET.queue =!= "analy"); \
<span style="background-color: #FFCCFF;"><b>]</b></span>
```

### Writing comments

To write comments you can use C-style comments, text enclosed by `/* */`. If the comment is at the end of a line, it still has to be followed by the line continuation character.

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     name = "C-style comments"; \
     <span style="background-color: #FFCCFF;"><b>/* This is a comment */ \</b></span>
] 
```

For `condor_ce_version` 8.2.x or greater, you can also use `#` to comment out single lines:

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     name = "Hash comments"; \
     <span style="background-color: #FFCCFF;"><b># BrokenAttribute = "commented out"; \</b></span> 
] 
```

### Setting attributes for all routes

To set an attribute that will be applied to all routes, you will need to use the `[[#SettingAttributes][set_]]` function for each route.

<span class="twiki-macro NOTE"></span> Do **not** try to do this by setting the [JOB\_ROUTER\_DEFAULTS](#JobRouterDefaults) configuration variable, as this will cause the CE to stop functioning.

The following routes set the `Periodic_Hold` attribute for both routes:

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     name = "Route jobs to HTCondor"; \
     Requirements = (TARGET.queue =?= "analy"); \
     <span style="background-color: #FFCCFF;"><b>/* Puts the routed job on hold if the job's been idle and has been started at least once or if the job has tried to start more than once */ \ </b></span>
     <span style="background-color: #FFCCFF;"><b>set_Periodic_Hold = (NumJobStarts >= 1 && JobStatus == 1) || NumJobStarts > 1; \</b></span>
] \
[ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Route jobs to PBS"; \
     Requirements = (TARGET.queue =!= "analy"); \
     <span style="background-color: #FFCCFF;"><b>/* Puts the routed job on hold if the job's been idle and has been started at least once or if the job has tried to start more than once */ \ </b></span>
     <span style="background-color: #FFCCFF;"><b>set_Periodic_Hold = (NumJobStarts >= 1 && JobStatus == 1) || NumJobStarts > 1; \</b></span>
] 
```

### Filtering jobs based on…

To filter jobs, use the `Requirements` attribute. Jobs will evaluate against the ClassAd expression set in the `Requirements` and if the expression evaluates to `TRUE`, the route will match. More information on the syntax of ClassAd's can be found in the [HTCondor manual](http://research.cs.wisc.edu/htcondor/manual/v8.2/4_1HTCondor_s_ClassAd.html). For an example on how incoming jobs interact with filtering in job routes, consult [this document](Documentation.Release3/SubmittingHTCondorCE#Matching).

When setting requirements, you need to prefix job attributes that you are filtering with `TARGET.` so that the job route knows to compare the attribute of the incoming job rather than the route’s own attribute. For example, if an incoming job has a =queue = “analy”= attribute, then the following job route will not match:

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     name = "Filtering by queue"; \
     queue = "not-analy"; \
     <span style="background-color: #FFCCFF;"><b>Requirements = (TARGET.queue =?= "analy"); \</b></span>
] 
```

This is because when evaluating the route requirement, the job route will compare its own `queue` attribute to “analy” and see that it does not match. You can read more about comparing two ClassAds in the [HTCondor manual](http://research.cs.wisc.edu/htcondor/manual/v8.2/4_1HTCondor_s_ClassAd.html#43151).

<span class="twiki-macro NOTE"></span> If you have an HTCondor batch system, note the difference with [set\_requirements](#RoutedReq). <span class="twiki-macro NOTE"></span> The JobRouter matches jobs to routes in a round-robin fashion. This means that if a job can match to multiple routes, it can be routed by any of them! So when writing job routes, make sure that they are exclusive to each other and that your jobs can only match to a single route.

\#GlideIn

#### Glidein queue

To filter jobs based on their glidein queue attribute, your routes will need a `Requirements` expression using the incoming job’s `queue` attribute. The following entry routes jobs to the PBS queue if the incoming job (specified by `TARGET`) is an `analy` (Analysis) glidein:

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     name = "Filtering by queue"; \
     <span style="background-color: #FFCCFF;"><b>Requirements = (TARGET.queue =?= "analy"); \</b></span>
] 
```

#### Job submitter

To filter jobs based on who submitted it, your routes will need a `Requirements` expression using the incoming job’s `Owner` attribute. The following entry routes jobs to the HTCondor batch system iff the submitter is `usatlas2`:

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     name = "Filtering by job submitter"; \
     <span style="background-color: #FFCCFF;"><b>Requirements = (TARGET.Owner =?= "usatlas2"); \</b></span>
] 
```

Alternatively, you can match based on regular expression. The following entry routes jobs to the PBS batch system iff the submitter’s name begins with `usatlas`:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Filtering by job submitter (regular expression)"; \
     <span style="background-color: #FFCCFF;"><b>Requirements = regexp("^usatlas", TARGET.Owner); \</b></span>
] 
```

#### VOMS attribute

To filter jobs based on the subject of the job’s proxy, your routes will need a `Requirements` expression using the incoming job’s `x509UserProxyFirstFQAN` attribute. The following entry routes jobs to the PBS batch system if the proxy subject contains `/cms/Role=Pilot`:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Filtering by VOMS attribute (regex)"; \
     <span style="background-color: #FFCCFF;"><b>Requirements = regexp("\/cms\/Role\=pilot", TARGET.x509UserProxyFirstFQAN); \</b></span>
] 
```

### Setting a default…

This section outlines how to set default job limits, memory, cores, queue, and maximum walltime. For an example on how users can override these defaults, consult [this document](Documentation.Release3/SubmittingHTCondorCE#Route_defaults).

#### Maximum number of jobs

To set a default limit to the maximum number of jobs per route, you can edit the configuration variable `CONDORCE_MAX_JOBS` in `/etc/condor-ce/config.d/01-ce-router.conf`:

``` file
<span style="background-color: #FFCCFF;"><b>CONDORCE_MAX_JOBS = 10000</b></span>
```

Note that this is to be placed directly into the HTCondor-CE configuration, not into a job route.

#### Maximum memory

To set a default maximum memory for routed jobs, set the attribute `default_maxMemory`:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Request memory"; \
     /* Set the requested memory to 1 GB */ \
     <span style="background-color: #FFCCFF;"><b>set_default_maxMemory = 1000; \</b></span>
] 
```

#### Number of cores to request

To set a default number of cores for routed jobs, set the attribute `default_xcount`:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Request CPU"; \
     /* Set the requested cores to 8 */ \
     <span style="background-color: #FFCCFF;"><b>set_default_xcount = 8; \</b></span>
] 
```

#### Maximum walltime

To set a default maximum walltime (in minutes) for routed jobs, set the attribute `default_maxWallTime`:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Setting WallTime"; \
     /* Set the max walltime to 1 hr */ \
     <span style="background-color: #FFCCFF;"><b>set_default_maxWallTime = 60; \</b></span>
] 
```

### Editing attributes…

The following functions are operations that affect job attributes and are evaluated in the following order:

1.  copy\_\*
2.  delete\_\*
3.  set\_\*
4.  eval\_set\_\*

After each job route’s ClassAd is [constructed](#JobRouteConstruction), the above operations are evaluated in order. For example, if the attribute `foo` is set using `eval_set_foo` in the `JOB_ROUTER_DEFAULTS`, you‘ll be unable to use `delete_foo` to remote it from your jobs since the attribute is set using `eval_set_foo` after the deletion occurs according to the order of operations. To get around this, we can take advantage of the fact that operations defined in `JOB_ROUTER_DEFAULTS` get overriden by the same operation in `JOB_ROUTER_ENTRIES`. So to ’delete’ `foo`, we would add =eval\_set\_foo = “”= to the route in the `JOB_ROUTER_ENTRIES`, resulting in `foo` being absent from the routed job.

More documentation can be found in the [HTCondor manual](http://research.cs.wisc.edu/htcondor/manual/v8.2/5_4HTCondor_Job.html#SECTION00644000000000000000).

#### Copying attributes

To copy the value of an attribute of the incoming job to an attribute of the routed job, use `copy_`. The following route copies the `environment` attribute of the incoming job and sets the attribute `Original_Environment` on the routed job to the same value:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Copying attributes"; \
     <span style="background-color: #FFCCFF;"><b>copy_environment = "Original_Environment"; \</b></span>
] 
```

#### Removing attributes

To remove an attribute of the incoming job from the routed job, use `delete_`. The following route removes the `environment` attribute from the routed job:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Copying attributes"; \
     <span style="background-color: #FFCCFF;"><b>delete_environment = True; \</b></span>
] 
```

\#SettingAttributes

#### Setting attributes

To set an attribute on the routed job, use `set_`. The following route sets the Job’s `Rank` attribute to 5:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Setting an attribute"; \
     <span style="background-color: #FFCCFF;"><b>set_Rank = 5; \</b></span>
] 
```

#### Setting attributes with ClassAd expressions

To set an attribute to a ClassAd expression to be evaluated, use `set_eval`. The following route sets the `Experiment` attribute to `atlas.osguser` if the Owner of the incoming job is `osguser`:

<span class="twiki-macro NOTE"></span> If a value is set in JOB\_ROUTER\_DEFAULTS with `eval_set_<variable>`, override it by using `eval_set_<variable>` in the `JOB_ROUTER_ENTRIES`.

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Setting an attribute with a !ClassAd expression"; \
     <span style="background-color: #FFCCFF;"><b>eval_set_Experiment = strcat("atlas.", Owner); \</b></span>
] 
```

### Limiting the number of…

This section outlines how to limit the number of total or idle jobs in a specific route (i.e., if this limit is reached, jobs will no longer be placed in this route).

<span class="twiki-macro NOTE"></span> If you are using an HTCondor batch system, limiting the number of jobs is not the preferred solution: HTCondor manages fair share on its own via [user priorities and group accounting](http://research.cs.wisc.edu/htcondor/manual/v8.2/3_4User_Priorities.html).

#### Total jobs

To set a limit on the number of jobs for a specific route, set the [MaxJobs](http://research.cs.wisc.edu/htcondor/manual/v8.2/5_4HTCondor_Job.html#49135) attribute:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Limit the total number of jobs to 100"; \
     <span style="background-color: #FFCCFF;"><b>MaxJobs = 100; \</b></span>
] \
[ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Limit the total number of jobs to 75"; \
     <span style="background-color: #FFCCFF;"><b>MaxJobs = 75; \</b></span>
]
```

#### Idle jobs

To set a limit on the number of idle jobs for a specific route, set the [MaxIdleJobs](http://research.cs.wisc.edu/htcondor/manual/v8.2/5_4HTCondor_Job.html#49136) attribute:

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     name = "Limit the total number of idle jobs to 100"; \
     <span style="background-color: #FFCCFF;"><b>MaxIdleJobs = 100; \</b></span>
] \
[ \
     TargetUniverse = 5; \
     name = "Limit the total number of idle jobs to 75"; \
     <span style="background-color: #FFCCFF;"><b>MaxIdleJobs = 75; \</b></span>
]
```

<span class="twiki-macro STARTSECTION">DebugRoutes</span>

### Debugging routes

To help debug expressions in your routes, you can use the `debug()` function. First, set the debug mode for the JobRouter by editing a file in `/etc/condor-ce/config.d/` to read

``` file
JOB_ROUTER_DEBUG = D_FULLDEBUG
```

Then wrap the problematic attribute in `debug()`:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Debugging a difficult !ClassAd expression"; \
     <span style="background-color: #FFCCFF;"><b>eval_set_Experiment = debug(strcat("atlas", Name)); \</b></span>
] 
```

<span class="twiki-macro ENDSECTION"></span>

You will find the debugging output in `/var/log/condor-ce/JobRouterLog`.

Routes for HTCondor Batch Systems
---------------------------------

### Setting periodic hold, release or remove

To release, remove or put a job on hold if it meets certain criteria, use the `PERIODIC_*` family of attributes. By default, periodic expressions are evaluated once every 300 seconds but this can be changed by setting PERIODIC\_EXPR\_INTERVAL in your CE’s configuration.

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     name = "Setting periodic statements"; \
     <span style="background-color: #FFCCFF;"><b>/* Puts the routed job on hold if the job's been idle and has been started at least once or if the job has tried to start more than once */ \</b></span>
     <span style="background-color: #FFCCFF;"><b>set_Periodic_Hold = (NumJobStarts >= 1 && JobStatus == 1) || NumJobStarts > 1; \</b></span>
     <span style="background-color: #FFCCFF;"><b>/* Remove routed jobs if their walltime is longer than 3 days and 5 minutes */ \</b></span>
     <span style="background-color: #FFCCFF;"><b>set_Periodic_Remove = ( RemoteWallClockTime > (3*24*60*60 + 5*60) ); \</b></span>
     <span style="background-color: #FFCCFF;"><b>/* Release routed jobs if the condor_starter couldn't start the executable and 'VMGAHP_ERR_INTERNAL' is in the HoldReason */ \</b></span>
     <span style="background-color: #FFCCFF;"><b>set_Periodic_Release = HoldReasonCode == 6 && regexp("VMGAHP_ERR_INTERNAL", HoldReason); \</b></span>
] 
```

\#RoutedReq

### Setting routed job requirements

If you need to set requirements on your routed job, you will need to use `set_Requirements` instead of `Requirements`. The `Requirements` attribute filters jobs coming into your CE into different job routes whereas `set_requirements` will set conditions on the routed job that must be met by the worker node it lands on. For more information on requirements, consult the [HTCondor manual](http://research.cs.wisc.edu/htcondor/manual/v8.2/2_5Submitting_Job.html#SECTION00352000000000000000).

To ensure that your job lands on a Linux machine in your pool:

``` file
JOB_ROUTER_ENTRIES = [ \
     TargetUniverse = 5; \
     <span style="background-color: #FFCCFF;"><b>set_Requirements =  OpSys == "LINUX" \</b></span>
]
```

### Setting accounting groups

To assign jobs to an HTCondor accounting group to manage fair share on your local batch system, we recommend using [UID and ExtAttr tables](Documentation/Release3.InstallHTCondorCE#AccountingGroups).

Routes for non-HTCondor Batch Systems
-------------------------------------

### Setting a default batch queue

To set a default queue for routed jobs, set the attribute `default_queue`:

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Setting batch system queues"; \
     <span style="background-color: #FFCCFF;"><b>set_default_queue = "osg_queue"; \</b></span>
] 
```

### Setting batch system directives

To write batch system directives that are not supported in the route examples above, you will need to edit the job submit script for your local batch system in `/etc/blahp/` (e.g., if your local batch system is PBS, edit `/etc/blahp/pbs_local_submit_attributes.sh`). This file is sourced during submit time and anything printed to stdout is appended to the job submit script that gets submitted to your batch system. ClassAd attributes can be passed from the routed job to the local submit attributes script via the `default_remote_cerequirements` attribute, which can take the following form:

``` file
default_remote_cerequirements = foo == X && bar == Y && ...
```

This sets `foo` to value `X` and `bar` to `Y` in the environment of the local submit attributes script. The following example sets the maximum walltime to 1 hour and the accounting group to the `x509UserProxyFirstFQAN` attribute of the job submitted to a PBS batch system

``` file
JOB_ROUTER_ENTRIES = [ \
     GridResource = "batch pbs"; \
     TargetUniverse = 9; \
     name = "Setting job submit variables"; \
     <span style="background-color: #FFCCFF;"><b>set_default_remote_cerequirements = strcat("Walltime == 3600 && AccountingGroup == \"", x509UserProxyFirstFQAN, "\""); \</b></span>
] 
```

With `/etc/blahp/pbs_local_submit_attributes.sh` containing.

``` file
#!/bin/bash
echo "#PBS -l walltime=$Walltime"
echo "#PBS -A $AccountingGroup"
```

The result is that the following will be appended to the script that gets submitted to your batch system:

``` file
#PBS -l walltime=3600
#PBS -A <span style="background-color: #FFCCFF;">"&lt;CE job's x509UserProxyFirstFQAN attribute&gt;"</span>
```

Example Configurations
----------------------

### AGLT2’s job routes

Atlas AGLT2 is using an HTCondor batch system. Here are some things to note about their routes.

-   Setting various HTCondor-specific attributes like `Rank`, `AccountingGroup`, `JobPrio` and `Periodic_Remove` (see the [HTCondor manual](http://research.cs.wisc.edu/htcondor/manual/v8.2/12_Appendix_A.html) for more). Some of these are site-specific like `LastandFrac`, `IdleMP8Pressure`, `localQue`, `IsAnalyJob` and `JobMemoryLimit`.
-   There is a difference between `Requirements` and `set_requirements`. The `Requirements` attribute matches jobs to specific routes while the `set_requirements` sets the `Requirements` attribute on the *routed* job, which confines which machines that the routed job can land on.

Source: <https://www.aglt2.org/wiki/bin/view/AGLT2/CondorCE#The_JobRouter_configuration_file_content>

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_OUTPUT% showlink="Click to expand full job route…"</span>

``` file
JOB_ROUTER_ENTRIES = \
/* Still to do on all routes, get job requirements and add them here */ \
/* ***** Route no 1 ***** */ \
/* ***** Analysis queue ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue=="analy"; \
    Name = "Analysis Queue"; \
    TargetUniverse = 5; \
    eval_set_IdleMP8Pressure = $(IdleMP8Pressure); \
    eval_set_LastAndFrac = $(LastAndFrac); \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ) && (IfThenElse((Owner == "atlasconnect" || Owner == "muoncal"),IfThenElse(IdleMP8Pressure,(TARGET.PARTITIONED =!= TRUE),True),IfThenElse(LastAndFrac,(TARGET.PARTITIONED =!= TRUE),True))); \
    eval_set_AccountingGroup = strcat("group_gatekpr.prod.analy.",Owner); \
    set_localQue = "Analysis"; \
    set_IsAnalyJob = True; \
    set_JobPrio = 5; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 2 ***** */ \
/* ***** splitterNT queue ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue == "splitterNT"; \
    Name = "Splitter ntuple queue"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
    eval_set_AccountingGroup = "group_calibrate.muoncal"; \
    set_localQue = "Splitter"; \
    set_IsAnalyJob = False; \
    set_JobPrio = 10; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 3 ***** */ \
/* ***** splitter queue ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue == "splitter"; \
    Name = "Splitter queue"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
    eval_set_AccountingGroup = "group_calibrate.muoncal"; \
    set_localQue = "Splitter"; \
    set_IsAnalyJob = False; \
    set_JobPrio = 15; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 4 ***** */ \
/* ***** xrootd queue ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue == "xrootd"; \
    Name = "Xrootd queue"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
    eval_set_AccountingGroup = strcat("group_gatekpr.prod.analy.",Owner); \
    set_localQue = "Analysis"; \
    set_IsAnalyJob = True; \
    set_JobPrio = 35; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 5 ***** */ \
/* ***** Tier3Test queue ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue == "Tier3Test"; \
    Name = "Tier3 Test Queue"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ) && ( IS_TIER3_TEST_QUEUE =?= True ); \
    eval_set_AccountingGroup = strcat("group_gatekpr.prod.analy.",Owner); \
    set_localQue = "Tier3Test"; \
    set_IsTier3TestJob = True; \
    set_IsAnalyJob = True; \
    set_JobPrio = 20; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 6 ***** */ \
/* ***** mp8 queue ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue=="mp8"; \
    Name = "MCORE Queue"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ) && (( TARGET.Cpus == 8 && TARGET.CPU_TYPE =?= "mp8" ) || TARGET.PARTITIONED =?= True ); \
    eval_set_AccountingGroup = strcat("group_gatekpr.prod.mcore.",Owner); \
    set_localQue = "MP8"; \
    set_IsAnalyJob = False; \
    set_JobPrio = 25; \
    set_Rank = 0.0; \
    eval_set_RequestCpus = 8; \
    set_JobMemoryLimit = 33552000; \
    set_Slot_Type = "mp8"; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 7 ***** */ \
/* ***** Installation queue, triggered by usatlas2 user ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue is undefined && target.Owner == "usatlas2"; \
    Name = "Install Queue"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ) && ( TARGET.IS_INSTALL_QUE =?= True ) && (TARGET.AGLT2_SITE == "UM" ); \
    eval_set_AccountingGroup = strcat("group_gatekpr.other.",Owner); \
    set_localQue = "Default"; \
    set_IsAnalyJob = False; \
    set_IsInstallJob = True; \
    set_JobPrio = 15; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 8 ***** */ \
/* ***** Default queue for usatlas1 user ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue is undefined && regexp("usatlas1",target.Owner); \
    Name = "ATLAS Production Queue"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
    eval_set_AccountingGroup = strcat("group_gatekpr.prod.prod.",Owner); \
    set_localQue = "Default"; \
    set_IsAnalyJob = False; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 9 ***** */ \
/* ***** Default queue for any other usatlas account ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue is undefined && (regexp("usatlas2",target.Owner) || regexp("usatlas3",target.Owner)); \
    Name = "Other ATLAS Production"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
    eval_set_AccountingGroup = strcat("group_gatekpr.other.",Owner); \
    set_localQue = "Default"; \
    set_IsAnalyJob = False; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ] \
/* ***** Route no 10 ***** */ \
/* ***** Anything else. Set queue as Default and assign to other VOs  ***** */ \
  [ \
    GridResource = "condor localhost localhost"; \
    eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", " $(JOB_ROUTER_SCHEDD2_POOL)"); \
    Requirements = target.queue is undefined && ifThenElse(regexp("usatlas",target.Owner),false,true); \
    Name = "Other Jobs"; \
    TargetUniverse = 5; \
    set_requirements = ( ( TARGET.TotalDisk =?= undefined ) || ( TARGET.TotalDisk >= 21000000 ) ) && ( TARGET.Arch == "X86_64" ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
    eval_set_AccountingGroup = strcat("group_VOgener.",Owner); \
    set_localQue = "Default"; \
    set_IsAnalyJob = False; \
    set_Rank = (SlotID + (64-TARGET.DETECTED_CORES))*1.0; \
    set_JobMemoryLimit = 4194000; \
    set_Periodic_Remove = ( ( RemoteWallClockTime > (3*24*60*60 + 5*60) ) || (ImageSize > JobMemoryLimit) ); \
  ]
```

<span class="twiki-macro ENDTWISTY"></span>

### BNL’s job routes

Atlas BNL T1, they are using an HTCondor batch system. Here are some things to note about their routes:

-   Setting various HTCondor-specific attributes like `JobLeaseDuration`, `Requirements` and `Periodic_Hold` (see the [HTCondor manual](http://research.cs.wisc.edu/htcondor/manual/v8.2/12_Appendix_A.html) for more). Some of these are site-specific like `RACF_Group`, `Experiment`, `Job_Type` and `VO`.
-   Jobs are split into different routes based on the [GlideIn](#GlideIn) queue that they’re in.
-   There is a difference between `Requirements` and `set_requirements`. The `Requirements` attribute matches *incoming* jobs to specific routes while the `set_requirements` sets the `Requirements` attribute on the *routed* job, which confines which machines that the routed job can land on.

Source: <http://www.usatlas.bnl.gov/twiki/bin/view/Admins/HTCondorCE.html>

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_OUTPUT% showlink="Click to expand full job route…"</span>

``` file
###############################################################################
#
# HTCondor-CE HTCondor batch system configuration file.
#
###############################################################################

# Submit the job to the site Condor

JOB_ROUTER_ENTRIES = \
   [ \
     GridResource = "condor localhost localhost"; \
     eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", "$(FULL_HOSTNAME)"); \
     TargetUniverse = 5; \
     name = "BNL_Condor_Pool_long"; \
     Requirements = target.queue=="analysis.long"; \
     eval_set_RACF_Group = "long"; \
     set_Experiment = "atlas"; \
     set_requirements = ( ( Arch == "INTEL" || Arch == "X86_64" ) && ( CPU_Experiment == "atlas" ) ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
     set_Job_Type = "cas"; \
     set_JobLeaseDuration = 3600; \
     set_Periodic_Hold = (NumJobStarts >= 1 && JobStatus == 1) || NumJobStarts > 1; \
     eval_set_VO = x509UserProxyVOName; \
   ] \
   [ \
     GridResource = "condor localhost localhost"; \
     eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", "$(FULL_HOSTNAME)"); \
     TargetUniverse = 5; \
     name = "BNL_Condor_Pool_short"; \
     Requirements = target.queue=="analysis.short"; \
     eval_set_RACF_Group = "short"; \
     set_Experiment = "atlas"; \
     set_requirements = ( ( Arch == "INTEL" || Arch == "X86_64" ) && ( CPU_Experiment == "atlas" ) ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
     set_Job_Type = "cas"; \
     set_JobLeaseDuration = 3600; \
     set_Periodic_Hold = (NumJobStarts >= 1 && JobStatus == 1) || NumJobStarts > 1; \
     eval_set_VO = x509UserProxyVOName; \
   ] \
   [ \
     GridResource = "condor localhost localhost"; \
     eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", "$(FULL_HOSTNAME)"); \
     TargetUniverse = 5; \
     name = "BNL_Condor_Pool_grid"; \
     Requirements = target.queue=="grid"; \
     eval_set_RACF_Group = "grid"; \
     set_Experiment = "atlas"; \
     set_requirements = ( ( Arch == "INTEL" || Arch == "X86_64" ) && ( CPU_Experiment == "atlas" ) ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
     set_Job_Type = "cas"; \
     set_JobLeaseDuration = 3600; \
     set_Periodic_Hold = (NumJobStarts >= 1 && JobStatus == 1) || NumJobStarts > 1; \
     eval_set_VO = x509UserProxyVOName; \
   ] \
   [ \
     GridResource = "condor localhost localhost"; \
     eval_set_GridResource = strcat("condor ", "$(FULL_HOSTNAME)", "$(FULL_HOSTNAME)"); \
     TargetUniverse = 5; \
     name = "BNL_Condor_Pool"; \
     Requirements = target.queue is undefined; \
     eval_set_RACF_Group = "grid"; \
     set_requirements = ( ( Arch == "INTEL" || Arch == "X86_64" ) && ( CPU_Experiment == "rcf" ) ) && ( TARGET.OpSys == "LINUX" ) && ( TARGET.Disk >= RequestDisk ) && ( TARGET.Memory >= RequestMemory ) && ( TARGET.HasFileTransfer ); \
     set_Experiment = "atlas"; \
     set_Job_Type = "cas"; \
     set_JobLeaseDuration = 3600; \
     set_Periodic_Hold = (NumJobStarts >= 1 && JobStatus == 1) || NumJobStarts > 1; \
     eval_set_VO = x509UserProxyVOName; \
   ]
```

<span class="twiki-macro ENDTWISTY"></span>

Reference
---------

Here are some other HTCondor-CE documents that might be helpful:

-   [HTCondor-CE overview and architecture](HTCondorCEOverview)
-   [Installing HTCondor-CE](InstallHTCondorCE)
-   [The HTCondor-CE troubleshooting guide](TroubleshootingHTCondorCE)
-   [Submitting Jobs to HTCondor-CE](SubmittingHTCondorCE)

