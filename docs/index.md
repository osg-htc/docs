Installation Guides
===================

The Open Science Grid consists primarily of a fabric of services at
participating sites.

One of the most common ways of participating in the OSG is to install
one of our software services at your site and provide computational
power opportunistically to the grid.

Our most common software products include:

* [HTCondor CE Installation](compute-element/install-htcondor-ce.md): Provides a _gateway_
  between the grid and your batch system.
* [HTTP Proxy](data/frontier-squid.md): Caches the most commonly-used files at your
  site to preserve bandwidth (a custom packaging of the venerable `squid` software).
* [CVMFS](worker-node/cvmfs.md) The CernVM File System (CVMFS) is a global-scale, read-only,
  hierarchical filesystem.  CVMFS volumes distribute the majority of the scientific
  software used on OSG in addition to the OSG worker node client.
* [Worker node client](worker-node/wn.md) and [singularity](worker-node/singularity.md): An RPM-based install
  of the worker node software; this includes the `singularity` binary which allows pilots to securely isolate payload user jobs.


You can help!
=============

Documentation is a task that is never done!  Feel free to fork this on github and
send us any updates or corrections.

In particular, many documents are being converted from our old twiki to this site.
We have used an automatic converter, but most documents need a human touch prior
to being included in the table of contents.

If you'd like to contribute, please consider trying to clean up one of these
documents:

* [CA Certificate Updater script](common/ca_updater.md)
* [Host certificate management package](common/cert_scripts.md)
* [Job Router Recipes](compute-element/job_router.md)
* [Installing the Worker Node from OASIS](worker-node/wn-oasis.md)
* [Installing a GridFTP Server](data/gridftp.md)

