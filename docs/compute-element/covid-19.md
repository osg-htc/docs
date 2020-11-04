
Supporting COVID-19 Research on the OSG
=======================================

There a few options available for sites with computing resources who want to support the
important and urgent work of COVID-19 researchers using the OSG. As we're
currently routing such projects through the OSG VO, your site can be configured
to accept pilots that _exclusively_ run OSG VO jobs relating to COVID-19 research
(among other pilots you support), allowing you to prioritize these pilots and account
for this usage separately from other OSG activity.

To support COVID-19 work, the overall process includes the following:

1. Make the site computing resources available through a HTCondor-CE if you have not already done so.
    -  You can install a [locally-managed](/compute-element/install-htcondor-ce/) instance or ask OSG to
       [host the CE](/compute-element/hosted-ce/) on your behalf.
       If neither solution is viable, or you'd like to discuss the options, please send email to
       <help@opensciencegrid.org> and we'll work with you to arrive at the best solution.
    -  If you already provide resources through an OSG Hosted CE, skip to [this section](#requesting-covid-19-jobs).
1. [Enable the OSG VO](/security/lcmaps-voms-authentication/#configuring-the-lcmaps-voms-plugin) on your HTCondor-CE.
1. Setup a job route specific to COVID-19 pilot jobs (documented below).
   The job route will allow you to prioritize these jobs using local policy in your site's cluster.
1. Send email to <help@opensciencegrid.org> requesting that your CE receive COVID-19 pilots.
   We will need to know the CE hostname and any special restrictions that might apply to these pilots.

Setting up a COVID-19 Job Route
-------------------------------

By default, COVID-19 pilots will look identical to OSG pilots _except_ they
will have the attribute `IsCOVID19 = true`.  They do not require mapping to
a distinct Unix account but can be sent to a prioritized queue or accounting
group.

Job routes are controlled by the `JOB_ROUTER_ENTRIES` configuration variable in HTCondor-CE.
Customizations may be placed in `/etc/condor-ce/config.d/` where files are parsed in lexicographical order, e.g.
`JOB_ROUTER_ENTRIES` specified in `50-covid-routes.conf` will override `JOB_ROUTER_ENTRIES` in `02-local-slurm.conf`.

### For Non-HTCondor batch systems

To add a new route for COVID-19 pilots for non-HTCondor batch systems:

1.  Note the names of your currently enabled routes:

        condor_ce_job_router_info -config

1.  Add the following configuration to a file in `/etc/condor-ce/config.d/` (files are parsed in lexicographical order):

        :::config hl_lines="6 7"
        JOB_ROUTER_ENTRIES @=jre
        [
         name = "OSG_COVID19_Jobs";
         GridResource = "batch slurm";
         TargetUniverse = 9;
         set_default_queue = "covid19";
         Requirements = (TARGET.IsCOVID19 =?= true);
        ]
        $(JOB_ROUTER_ENTRIES)
        @jre

    Replacing `slurm` in the `GridResource` attribute with the appropriate value for your batch system (e.g., `lsf`,
    `pbs`, `sge`, or `slurm`);
    and the value of `set_default_queue` with the name of the partition or queue of your local batch system dedicated to
    COVID-19 work.

1.  Ensure that COVID-19 jobs match to the new route.
    Choose one of the options below depending on your HTCondor version (`condor_version`):

    -   **For versions of HTCondor >= 8.8.7 and < 8.9.0; or HTCondor >= 8.9.6:**
        specify the routes considered by the job router and the order in which they're considered by adding the
        following configuration to a file in `/etc/condor-ce/config.d/`:

            JOB_ROUTER_ROUTE_NAMES = OSG_COVID19_Jobs, $(JOB_ROUTER_ROUTE_NAMES)
            
        If your configuration does not already define `JOB_ROUTER_ROUTE_NAMES`, you need to add the name of all previous
        routes to it, leaving `OSG_COVID19_Jobs` at the start of the list.
        For example:
        
            JOB_ROUTER_ROUTE_NAMES = OSG_COVID19_Jobs, Local_Condor, $(JOB_ROUTER_ROUTE_NAMES)

    -   **For older versions of HTCondor:** add `(TARGET.IsCOVID19 =!= true)` to the `Requirements` of any existing routes.
        For example, the following job route:

            :::config hl_lines="7"
            JOB_ROUTER_ENTRIES @=jre
            [
             name = "Local_Slurm"
             GridResource = "batch slurm";
             TargetUniverse = 9;
             set_default_queue = "atlas;
             Requirements = (TARGET.Owner =!= "osg");
            ]
            @jre

        Should be updated as follows:

            :::config hl_lines="7"
            JOB_ROUTER_ENTRIES @=jre
            [
             name = "Local_Slurm"
             GridResource = "batch slurm";
             TargetUniverse = 9;
             set_default_queue = "atlas;
             Requirements = (TARGET.Owner =!= "osg") && (TARGET.IsCOVID19 =!= true);
            ]
            @jre

1.  Reconfigure your HTCondor-CE:

        :::console
        condor_ce_reconfig

1.  Continue onto [this section](#verifying-covid-19-job-routes) to verify your configuration

### For HTCondor batch systems

Similarly, at an HTCondor site, one can place these jobs into a separate accounting group by providing the
`set_AcctGroup` and `eval_set_AccountingGroup` attributes in a new job route.
To add a new route for COVID-19 pilots for non-HTCondor batch systems:

1.  Note the names of your currently enabled routes:

        :::console
        condor_ce_job_router_info -config

1.  Add the following configuration to a file in `/etc/condor-ce/config.d/` (files are parsed in lexicographical order):

        :::config hl_lines="5 6 7"
        JOB_ROUTER_ENTRIES @=jre
        [
         name = "OSG_COVID19_Jobs";
         TargetUniverse = 5;
         set_AcctGroup = "covid19";
         eval_set_AccountingGroup = strcat(AcctGroup, ".", Owner);
         Requirements = (TARGET.IsCOVID19 =?= true);
        ]
        $(JOB_ROUTER_ENTRIES)
        @jre

    Replacing `covid19` in `set_AcctGroup` with the name of the accounting group that you would like to use for COVID-19
    jobs.

1.  Ensure that COVID-19 jobs match to the new route.
    Choose one of the options below depending on your HTCondor version (`condor_version`):

    -   **For versions of HTCondor >= 8.8.7 and < 8.9.0; or HTCondor >= 8.9.6:**
        specify the routes considered by the job router and the order in which they're considered by adding the
        following configuration to a file in `/etc/condor-ce/config.d/`:

            JOB_ROUTER_ROUTE_NAMES = OSG_COVID19_Jobs, $(JOB_ROUTER_ROUTE_NAMES)

    -   **For older versions of HTCondor:** add `(TARGET.IsCOVID19 =!= true)` to the `Requirements` of any existing routes.
        For example, the following job route:

            :::config hl_lines="6"
            JOB_ROUTER_ENTRIES @=jre
            [
             name = "Local_Condor"
             TargetUniverse = 5;
             Requirements = (TARGET.Owner =!= "osg");
            ]
            @jre

        Should be updated as follows:

            :::config hl_lines="6"
            JOB_ROUTER_ENTRIES @=jre
            [
             name = "Local_Condor"
             TargetUniverse = 5;
             Requirements = (TARGET.Owner =!= "atlas") && (TARGET.IsCOVID19 =!= true);
            ]
            @jre

1.  Reconfigure your HTCondor-CE:

        :::console
        condor_ce_reconfig

1.  Continue onto [this section](#verifying-covid-19-job-routes) to verify your configuration

Verifying the COVID-19 Job Route
--------------------------------

To verify that your HTCondor-CE is configured to support COVID-19 jobs, perform the following steps:

1.  Ensure that the `OSG_COVID19_Jobs` route appears with all of your other previously enabled routes:

        :::console
        condor_ce_job_router_info -config


    !!! bug "Known issue: removing old routes"
        If your HTCondor-CE has jobs associated with a route that is removed from your configuration, this will result
        in a crashing Job Router.
        If you accidentally remove an old route, restore the route or remove all jobs associated with said route.

1.  Ensure that COVID-19 jobs will match to your new job route:

    -   **For versions of HTCondor >= 8.8.7 and < 8.9.0; or HTCondor >= 8.9.6:**
        `OSG_COVID19_Jobs` should be the first route in the routing table:

            :::console
            condor_ce_config_val -verbose JOB_ROUTER_ROUTE_NAMES

    -   **For older versions of HTCondor:**
        the `Requirements` expresison of your `OSG_COVID19_Jobs` route must contain `(TARGET.IsCOVID19 =?= true)` and
        all other routes must contain `(TARGET.IsCOVID19 =!= true)` in their `Requirements` expression.
        
1.  After [requesting COVID-19 jobs](#requesting-covid-19-jobs), verify that jobs are being routed appropriately,
    [by examining pilots](/compute-element/troubleshoot-htcondor-ce/#condor_ce_router_q) with `condor_ce_router_q`.

Requesting COVID-19 Jobs
------------------------

To receive COVID-19 pilot jobs, send an email to <help@opensciencegrid.org> with the subject `Requesting COVID-19 pilots`
and the following information:

-  Whether you want to receive _only_ COVID-19 jobs, or if you want to accept COVID-19 and other OSG jobs
-  The hostname(s) of your HTCondor-CE(s)
-  Any other restrictions that may apply to these jobs (e.g. number of available cores)

Viewing COVID-19 Contributions
------------------------------

You can view how many hours that COVID-19 projects have consumed at your site with this
[GRACC dashboard](https://gracc.opensciencegrid.org/dashboard/db/covid-19-research?orgId=1&refresh=5m&from=now-7d&to=now).

Getting Help
------------

To get assistance, please use [this page](/common/help).
