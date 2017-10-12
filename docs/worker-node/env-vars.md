Grid Job Environment
=========================

This document is for grid users. It lists environment variables present in a job's environment while it is being executed on a Worker Node.

Conventions used in this Document
======================================

For variables that are of string type, a value of `UNAVAILABLE` indicates that the variable is not defined or not applicable.

Site Related Variables
===========================

These are variables that contain information about the site:

| Variable Name | Type | Definition |
|---------------|------|-----------|
| OSG\_GROUP | Enumerated String \[OSG,OSG-ITB\] | Group that the site belongs to, should be OSG unless the site is being used for validation or integration testing only |
| OSG\_HOSTNAME | String | Hostname for the CE (e.g. ce01.university.edu) |
| OSG\_SITE\_NAME | String | Identifier for the site. This is will be used for displaying the site by monitoring tools. Valid characters are letters, numbers, underscore, dot, and dash ( A-Z,a-z,0-9,\_,.,- ) |
| OSG\_SPONSOR | Enumerated String | Valid VO(s) that sponsors the site. Multiple VOs can be specified with the percent sponsorship by each sponsor, e.g. "usatlas:50 uscms:50" |
| OSG\_SITE\_INFO | String (URL) | Valid url that gives the site policy for OSG usage. |
| OSG\_CONTACT\_NAME | String | The name of the administrative contact for the site |
| OSG\_CONTACT\_EMAIL | String | Valid email address for the administrative contact. Notifications from scripts will be sent to this email address |
| OSG\_SITE\_CITY | String | Name of the city where the OSG site is located |
| OSG\_SITE\_COUNTRY | String | Name of the country where the OSG site is located |
| OSG\_SITE\_LONGITUDE | Float | The site's longitude (will be negative for locations west of Greenwich) |
| OSG\_SITE\_LATITUDE | Float | The site's latitude (will be negative for locations south of the equator) |
| GLOBUS\_LOCATION | String | Path to the directory where the Globus software is installed (usually /usr) |
| OSG\_USER\_VO\_MAP | String | Path to the location of the osg-user-vo-map.txt file, typically `/var/lib/osg/user-vo-map` |
| OSG\_GRIDFTP\_LOG | String | Path to the location of the grid ftp log created by gridftp server , typically `/var/log/gridftp.log` |

Storage Related Variables
==============================

The storage related variables are defined in more detail within the <a href="/bin/view/Trash/ReleaseDocumentationLocalStorageConfiguration" class="twikiLink">local storage configuration</a> document. The following is a summary, but the Twiki page should be consulted for a definitive view as well as for an explanation for the use cases and which variables must be defined for each use case.

| Variable Name | Type | Definition |
|---------------|------|------------|
| OSG\_STORAGE\_ELEMENT | Enumerated String \[y,n\] | Indicates whether a storage element is available for CEs in the site. |
| OSG\_DEFAULT\_SE | String | Full url to the default storage element that can be used by worker nodes within the cluster |
| OSG\_GRID | String | Directory where the worker node client (wn-client) or packages to use the grid are installed |
| OSG\_APP | String | Directory available to install job specific applications and binaries. This also requires a sub-directory, $OSG\_APP/etc, with 1777 permissions. |
| OSG\_DATA | String | Directory available for jobs to store data and to stage data in and out, this directory is shared across the cluster |
| OSG\_WN\_TMP | String | Directory available for scratch space for worker nodes. This directory is local to each node and provides POSIX semantics for file operations |

Squid Service Variables
============================

These variables provide information about the squid proxy that site may make available.

| Variable Name | Type | Definition |
|---------------|------|------------|
| OSG\_SQUID\_LOCATION      | String                                                                                                                  | The hostname (and optionally port) of the machine that is providing squid proxy services for the site. This should be set to `UNAVAILABLE` if squid is not provided. E.g. squid.host.name:3128                                                                                                                                                                                                             |
| OSG\_SQUID\_POLICY        | Enumerated String \[LRU,LFUDA,GDSF\]                                                                                    | The caching policy squid should use for evicting elements from the cache. **Not currently used** GDSF maximizes the bytes that the proxy caches (i.e. the cache favors large elements over multiple smaller elements) , LFUDA maximizes the number of objects that the proxy caches (i.e. the cache favors multiple smaller elements over large elements), LRU just evicts the least recently used element |
| OSG\_SQUID\_CACHE\_SIZE   | integer with optional MB or GB postfixes                                                                                | The size of the squid disk cache. The size is assumed to be in megabytes unless a postfix is given.                                                                                                                                                                                                                                                                                                        |
| OSG\_SQUID\_MEM\_CACHE    | integer with optional MB or GB postfixes                                                                                | The size of the squid memory cache. The size is assumed to be in megabytes unless a postfix is given.                                                                                                                                                                                                                                                                                                      |

Other Service Variables
============================

These variables provide information about other services that may be available on the site.

| Variable Name | Type | Definition |
|---------------|------|------------|
| OSG\_GLEXEC\_LOCATION | String | The path to the GLEXEC binaries on the worker nodes. This is set to `UNAVAILABLE` if GLEXEC is not installed. |
