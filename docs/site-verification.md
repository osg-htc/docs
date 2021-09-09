Site Verification
=================

After installing and [registering](common/registration.md) services from the [site planning document](site-planning.md),
you will need to perform some verification steps before your site can
[scale up to full production](#scale-up-to-full-production).

Verify OSG Software
-------------------

To verify your site's installation of OSG Software, you will need to:

-   Submit local test jobs
-   Contact the OSG for end-to-end tests of pilot job submission
-   Check that OSG usage is reported to the [GRACC](https://gracc.opensciencegrid.org)

### Local verification ###

It is useful to submit jobs from within your site to verify CE's ability to submit jobs to your local batch system.
Consult the document for [submitting jobs into an HTCondor-CE](compute-element/submit-htcondor-ce.md) for detailed
instructions on how to test job submission.

### Verify end-to-end pilot job submission ####

Once you have validated job submission from within your site, request test pilot jobs from
[OSG Factory Operations](mailto:osg-gfactory-support@physics.ucsd.edu) and provide the following information:

-   The fully qualified domain name of the CE
-   Registered OSG resource name
-   Supported OS version of your worker nodes (e.g., EL7, EL8, or a combination)
-   Support for multicore jobs
-   Support for GPUs
-   Maximum job walltime
-   Maximum job memory usage

Once the Factory Operations team has enough information, they will start submitting pilots to your CE.
Initially, this will be a handful of pilots at a time but once the factory verifies that pilot jobs are running
successfully, that number will be ramped up.

### Verify reporting and monitoring ###

To verify that your site is correctly reporting to the OSG, visit
[OSG's Accounting Portal](https://gracc.opensciencegrid.org/d/000000079/site-summary?orgId=1) and select your registered OSG
site name from the `Site` dropdown.
If you don't see your site in the dropdown,
[please contact us for assistance](common/help.md#software-or-service-support).

Scale Up to Full Production
---------------------------

After verifying end-to-end pilot job submission and usage reporting, your site is ready for production!
In the same OSG Factory Operations ticket that you opened [above](#verify-end-to-end-pilot-job-submission),
let OSG staff know when you are ready to accept production pilots.

After requesting production pilots, review the documentation for [how to maintain an OSG site](site-maintenance.md).

Getting Help
------------

If you need help with your site, or need to report a security incident, follow the [contact instructions](common/help.md).
