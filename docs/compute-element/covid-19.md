
Supporting COVID-19 Research on the OSG
=======================================

There are a number of options available for sites wanting to support the
important and urgent work of COVID-19 researchers using the OSG.  The OSG VO
provides sites with the opportunity to accept pilots that _exclusively_ run
jobs relating to COVID-19 research and account for this usage separately
from other OSG activity.

To support this work, one must:

1. Make the site computing resources available through a HTCondor-CE.  This
can be done through an [on-premise](/compute-element/install-htcondor-ce/)
instance or asking OSG to [host the CE](/compute-element/hosted-ce/) on your
behalf.  If neither solution is viable, please send email to
<help@opensciencegrid.org> and we can provide consulting services to determine
a better approach.
2. [Enable the OSG VO](/security/lcmaps-voms-authentication/#configuring-the-lcmaps-voms-plugin)
and setup a job route specific to COVID-19 pilot jobs.
This process is documented below.  This enables you to prioritize these jobs
according to your local policy.
3. Send email to <help@opensciencegrid.org> requesting that your CE receive
COVID-19 pilots.  We will need to know the CE hostname and any special
restrictions that might apply to these pilots.

Setting up a COVID-19 Job Route
-------------------------------

By default, COVID-19 pilots will look identical to OSG pilots _except_ they
will have the attribute `IsCOVID19 = true`.  They do not require mapping to
a distinct Unix account but can be sent to a prioritized queue or accounting
group.

Job routes are controlled by the `JOB_ROUTER_ENTRIES` configuration variable
in HTCondor-CE (customizations may be placed in `/etc/condor-ce/config.d/`).

For example, consider the following route for a CE submitting to a Slurm batch
system:

```
JOB_ROUTER_ENTRIES @=jre
[
 name = "Local_Slurm";
 GridResource = "batch slurm";
 TargetUniverse = 9;
 queue = "osg";
]
```

To add a new route for COVID-19 pilots, append a new route
prior to the existing one and specify their order:

```hl_lines="2 3 4 5 6 7 8 17 18"
JOB_ROUTER_ENTRIES @=jre
[
 name = "OSG_COVID-19_Jobs";
 GridResource = "batch slurm";
 TargetUniverse = 9;
 queue = "covid19";
 Requirements = (TARGET.IsCOVID19 =?= true);
]
[
 name = "Local_Slurm";
 GridResource = "batch slurm";
 TargetUniverse = 9;
 queue = "osg";
]
@jre

# Specify the order of the routes
JOB_ROUTER_ROUTE_NAMES = OSG_COVID-19_Jobs, Local_Slurm
```

To verify jobs are being routed appropriately,
[one may examine pilots](/compute-element/troubleshoot-htcondor-ce/#condor_ce_router_q)
with `condor_ce_router_q`.

!!! note "Additional considerations for older CEs"
    Prior to HTCondor 8.8.7 or 8.9.5, HTCondor-CE had separate rules for handling
    multiple routes; see the
    [job router recipes](/compute-element/job-router-recipes#how-jobs-match-to-job-routes) for more
    details.

Similarly, at a HTCondor site, one can place these jobs into a
separate accounting group by providing the `set_AcctGroup` attribute:

```hl_lines="5 11"
JOB_ROUTER_ENTRIES @=jre
[
 name = "OSG_COVID-19_Jobs";
 TargetUniverse = 5;
 set_AcctGroup = "covid19";
 Requirements = (TARGET.IsCOVID19 =?= true);
]
[
 name = "Local_Condor";
 TargetUniverse = 5;
 set_AcctGroup = "osg";
]
@jre

# Specify the order of the routes
JOB_ROUTER_ROUTE_NAMES = OSG_COVID-19_Jobs, Local_Condor
```

Only Supporting COVID-19
------------------------

If your resource _only_ wants to support COVID-19 research, then you need
to [enable the OSG VO](/security/lcmaps-voms-authentication/#configuring-the-lcmaps-voms-plugin)
but only provide the `OSG_COVID-19_Jobs` job route above.  As long as the
`Requirements` expression for your job route includes
`(TARGET.IsCOVID19 =?= true)`, then non-COVID pilots will not be routed
to the batch system.

When you contact <help@opensciencegrid.org> to receive COVID-19 pilots,
please note that you _only_ want to support these jobs.

Getting Help
------------

To get assistance, please use the [this page](/common/help).
