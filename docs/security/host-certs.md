Host and Service Certificates
=============================

Host and service certificates are used to securely identify your system and to
establish encrypted connections between services and clients in the OSG. Host
certificates can be used by any service running on your system. In contrast,
service certificates are used to identify specific services on your machine. For
example, HTCondor-CE typically uses a host certificate while RSV, Gratia,
Tomcat, and Apache httpd use service certificates. Technically, the primary
difference between a host certificate and service certificate is in the common
name (CN) field of the certificate.  A host certificate's CN contains the
hostname (e.g.  mymachine.mydomain.edu) while a service certificate will prepend
a service name to the hostname (e.g. http/mymachine.mydomain.edu for an Apache
httpd service certificate).

Since October 2015 the OSG has run its own OSG CA service that handled host and service certificate requests.
At the end of May 2018, this service will be retired;
see [the policy details here](https://opensciencegrid.github.io/technology/policy/service-migrations-spring-2018/#osg-ca).
To replace the OSG CA service, we suggest using one or more of the following services depending on your site's needs:

- [InCommon](https://www.incommon.org/cert/): an IGTF-accredited CA for services that interact with the WLCG;
  requires a subscription, generally held by an institution
- [Let's Encrypt](https://letsencrypt.org/): a free, automated, and open CA frequently used for web services;
  see the [security team's position on Let's Encrypt](https://opensciencegrid.github.io/security/LetsEncryptOSGCAbundle/)
  for more details

!!! tip "Recommendation"
    Certificates issued from the OSG CA before the service retirement will still be valid until they expire.
    Therefore, we recommend that you request certificates for any currently existing or planned hosts and services
    prior to retirement.

After reading this document you should be able to apply for and install a host
or service certificate on a grid resource.  This document does not explain how
to apply for a grid user certificate. To learn how to apply for a grid user
certificate click [here](user-certs.md) instead!

Before Starting
---------------

Before requesting a new host or service certificate, you should use **openssl** to 
check if you have a valid certificate already. If so, you may
safely skip this document:

``` console
user@host $ openssl x509 -in /etc/grid-security/hostcert.pem -subject -issuer -dates -noout
subject= /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=host.opensciencegrid.org
issuer=/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1
notBefore=Jan  4 21:08:09 2010 GMT
notAfter=Jan  4 21:08:09 2011 GMT
```

Requesting InCommon Certificates
--------------------------------

Many institution in the United States already subscribe to InCommon and offer certificate services.
If your institution is in the list of [InCommon subscribers](https://www.incommon.org/certificates/subscribers.html),
continue with the instructions below.
If your institution is not in the list and Let's Encrypt certificates do not meet your needs, please
[contact us](/common/help.md).

1. Construct the Common Name based on the type of certificate you need:

    1. Determine if you need a host and/or service certificate:

        | If the host is a(n)... | You need a host certificate | You need a service certificate |
        |------------------------|-----------------------------|--------------------------------|
        | HTCondor-CE            | Yes                         | No                             |
        | GridFTP                | Yes                         | No                             |
        | XRootD                 | Yes                         | No                             |
        | GlideinWMS             | Yes                         | Yes, frontend and pilot(s)     |
        | GUMS                   | No                          | Yes, tomcat                    |
        | RSV                    | No                          | Yes                            |

        If you need both kinds of certificates, repeat the following instructions for each certificate.

    1. If you need a host certificate, the Common Name should be the hostname, e.g. `mymachine.mydomain.edu`.
       If you need a service certificate, the Common Name should be the name of the service prepended to the hostname,
       e.g. `http/mymachine.mydomain.edu` for an Apache httpd service certificate.

1. Generate a Certificate Signing Request (CSR) and private key, using the Common Name from the previous step:

        :::console
        root@server # openssl req -nodes -new -newkey rsa:2048 -sha256 -out req.pem -keyout hostkey.pem -subj "/CN=%RED%<COMMON NAME>%ENDCOLOR%"

1. Set the permissions on the CSR and private key:

        :::console
        root@server # chmod 0600 hostkey.pem req.pem

1. Submit the CSR to your institution
1. Install the [host](#installing-host-certificates) or [service](#installing-service-certificates) certificate

Requesting Let's Encrypt Certificates
-------------------------------------

Instructions for requesting Let's Encrypt host certificates will be released with the next release of the
[OSG CA certificate bundle](/common/ca.md), expected in early May 2018.

See the [security team's position on Let's Encrypt](https://opensciencegrid.github.io/security/LetsEncryptOSGCAbundle/)
for more details

Requesting Host/Service Certificates Using the Command Line
-----------------------------------------------------------

The OSG PKI Command Line Clients are tested to work on Python version 2.4+. They
have not been tested on Python version 3. In order to proceed you will also
need:

-  an X.509 user certificate
-  Grid Admin privileges

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](/release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](/common/yum)
- Install [CA certificates](/common/ca)

!!! note 
    If you would like to request a host or service certificate without obtaining
    Grid Admin privileges, see [this](#requesting-hostservice-certificate-using-oim) section. 

### Requesting Grid Admin privileges

A Grid Admin is a person associated with a Virtual Organization (VO) that has
been given privileges to automatically approve host certificate requests for a
given domain and any sub-domain.  For example, a Grid Admin for the `uchicago.edu`
domain would be able to approve host or service certificate requests for
`myhost.uchicago.edu`, `gums.grid.uchicago.edu`,
`myhost2.subdomain.uchicago.edu`, etc.

If you do not have Grid Admin privileges, you can request them
[here](https://oim.opensciencegrid.org/oim/gridadmin) after obtaining
your [user certificate](user-certs).

### Installing the OSG PKI command line client

The scripts needed to request host or service certificates are contained in the
`osg-pki-tools` RPM.  Install it by running the following:

``` console
root@host # yum install osg-pki-tools
```

Please refer to [this
documentation](/security/certificate-management#osg-pki-command-line-clients)
for full documentation of the osg-pki-tools.

### Validating your X.509 user certificate

Make sure you can create a valid grid proxy with `voms-proxy-init` or `grid-proxy-init`. For example :

``` console
user@host $ voms-proxy-init 
Enter GRID pass phrase for this identity:
Your identity: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services=People/CN=Alain Roy 424511
Creating temporary proxy ................................................................................. Done
Contacting  glow-voms.cs.wisc.edu:15001 [/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=glow-voms.cs.wisc.edu] "GLOW" Done
Creating proxy ..................................................................... Done

Your proxy is valid until Fri Dec  2 01:32:47 2011
```

#### Requesting host certificates

The **osg-gridadmin-cert-request** script only supports requesting host
certificates that are in the same domain.  The certificates are stored with the
format of `<hostname>.pem` and the corresponding key is stored as
`<hostname>-key.pem`. For example:

- To request a host certificate for `host.opensciencegrid.org`:

        :::console
        user@host $ osg-gridadmin-cert-request -H host.opensciencegrid.org

- To request a host certificate for `host.opensciencegrid.org` with Subject
  Alternative Names (SANs), use the `-a` flag for each SAN:

        :::console
        user@host $ osg-gridadmin-cert-request -H host.opensciencegrid.org -a host1.opensciencegrid.org -a host2.opensciencegrid.org

- To request more than one host certificate, you can provide a file with one
  host per line and optional SANs separated with spaces. The following example
  would request three certificates; one for `host1.opensciencegrid.org`, one for
  `host2.opensciencegrid.org`, and one for `host.opensciencegrid.org` with the
  SANs `host1.opensciencegrid.org` and `host2.opensciencegrid.org`:

        host1.opensciencegrid.org
        host2.opensciencegrid.org
        host.opensciencegrid.org host1.opensciencegrid.org host2.opensciencegrid.org

    If the above contents were saved to `hostfile`, run the following command to request multiple certificates:

        :::console
        user@host $ osg-gridadmin-cert-request -f hostfile

#### Installing host certificates

Finally, install the certificate in the default location `/etc/grid-security/`:

``` console
root@host # cp ./host.opensciencegrid.org.pem /etc/grid-security/hostcert.pem
root@host # chmod 444 /etc/grid-security/hostcert.pem
root@host # cp ./host.opensciencegrid.org-key.pem /etc/grid-security/hostkey.pem
root@host # chmod 400 /etc/grid-security/hostkey.pem
```

### Requesting and installing a service certificate

#### Requesting service certificates

To request a service certificate, use the same **osg-gridadmin-cert-request** command used to request host certificates
but prepend the service name, `<SERVICE>`, to the requested hostname:

``` console
user@host $ osg-gridadmin-cert-request -H %RED%<SERVICE>%ENDCOLOR%/host.opensciencegrid.org
```

!!! note
    All methods for [requesting host certificates](#requesting-host-certificates) can also be used to request service certificates

#### Installing service certificates

Since a single host can run multiple services, service certificates must be placed in their own directory.

1. Create a directory indicating the name of the service, `<SERVICE>`, under `/etc/grid-security/`.

        :::console
        root@host # mkdir /etc/grid-security/<SERVICE>

1. Copy and rename the service certificate and key to the `<SERVICE>` directory that you created above:

        :::console
        root@host # cp ./%RED%<SERVICE>%ENDCOLOR%-host.opensciencegrid.org.pem /etc/grid-security/%RED%<SERVICE>%ENDCOLOR%/%RED%<SERVICE>%ENDCOLOR%cert.pem
        root@host # cp ./%RED%<SERVICE>%ENDCOLOR%-host.opensciencegrid.org-key.pem /etc/grid-security/%RED%<SERVICE>%ENDCOLOR%/%RED%<SERVICE>%ENDCOLOR%key.pem

    For example, the service certificate for an Apache httpd service should be installed in `/etc/grid-security/http`:

        :::console
        root@host # cp ./http-host.opensciencegrid.org.pem /etc/grid-security/http/httpcert.pem
        root@host # cp ./http-host.opensciencegrid.org-key.pem /etc/grid-security/http/httpkey.pem

1. Set the appropriate permissions on the service certificate and key

        :::console
        root@host # chmod 444 /etc/grid-security/%RED%<SERVICE>%ENDCOLOR%/%RED%<SERVICE>%ENDCOLOR%cert.pem
        root@host # chmod 400 /etc/grid-security/%RED%<SERVICE>%ENDCOLOR%/%RED%<SERVICE>%ENDCOLOR%key.pem

1. Set the ownership of the directory and its underlying files to the Unix user, indicated as `<USER>`, who runs the service:

        :::console
        root@host # chown -R %RED%<USER>%ENDCOLOR%:%RED%<USER>%ENDCOLOR% /etc/grid-security/%RED%<SERVICE>%ENDCOLOR%/

    For example, both the Apache and Tomcat services are run by the `tomcat` user:

        :::console
        root@host # chown -R tomcat:tomcat /etc/grid-security/http/

Requesting Host/Service Certificate Using OIM
----------------------------------------------

If you do not have Grid Admin privileges, please use OIM to request any host or
service certificates that you may need.  The OSG PKI Certificate Request &
Management System can be found at:
<https://oim.opensciencegrid.org/oim/certificate>. Alternatively, you can request
Grid Admin privileges [here](https://oim.opensciencegrid.org/oim/gridadmin) after obtaining
your [user certificate](user-certs).


For instructions on how to request a host or service certificate using the Web
interface please see the [user guide maintained by
the OIM development team](https://confluence.grid.iu.edu/pages/viewpage.action?pageId=3244064).

Frequently Asked Questions
---------------------------

### Can I use any host to request a certificate for a different host? 

YES, you can use any host to create a certificate request as long as the hostname for the certificate is a fully qualified domain name.

### May I reuse my host certificate as a service certificate? 

NO! For security reasons, please do not use clones of your host certificate for additional certificates even though it's technically possible.

### How do I renew a host/service certificate? 

There is no separate procedure. Simply ask for a new certificate the same way you asked for it the previous time.

### I get a "GSS authentication failure" when users try to authenticate with my site? 

You likely used an **alias** for the host instead of the fully qualified domain
name when you generated the certificate request. This can cause the GSS
authentication failures similar to the following when a user tries to
authenticate to the host after your certificate is installed:

``` console
GSS authentication failure 
GSS Major Status: General failure 
GSS Minor Status Error Chain: 
accept_sec_context.c:gss_accept_sec_context:403: 
Error during delegation: Delegation protocol violation 
Failure: GSS failed Major:000d0000 Minor:00000001 Token:00000000 
```

### How can I check if I have a host certificate installed already? 

By default the host certificate key pair will be installed in
`/etc/grid-security/hostcert.pem` and `/etc/grid-security/hostkey.pem`. You can
use **openssl** to access basic information about the certificate:

``` console
root@host # openssl x509 -in /etc/grid-security/hostcert.pem -subject -issuer -dates -noout
subject= /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=host.opensciencegrid.org
issuer= /DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1
notBefore=Apr  8 00:00:00 2013 GMT
notAfter=May 17 12:00:00 2014 GMT
```

### How can I check the expiration time of my installed host certificate? 

If you installed the Certificates Script Package you can use **grid-cert-info**
to retrieve information about the certificate:

``` console
root@host # grid-cert-info -file /etc/grid-security/hostcert.pem -startdate -enddate
Jan  4 21:08:41 2010 GMT
Jan  4 21:08:41 2011 GMT
```

Alternatively you can use **openssl**:

``` console
root@host # openssl x509 -in /etc/grid-security/hostcert.pem -dates -noout
notBefore=Jan  4 21:08:41 2010 GMT
notAfter=Jan  4 21:08:41 2011 GMT
```

### How can I change the URLs queried by the PKI clients?

This configuration should not need to be changed for the vast majority of uses.
The information is provided in case you need it for debugging purposes.

The client checks for `pki-clients.ini` file at three location in order:

-   `$HOME/.osg-pki/OSG_PKI.ini`
-   `./pki-clients.ini`
-   `/etc/osg/pki-clients.ini` (default location)

The INI file contains the following information:

-   Request URL
-   Approve URL
-   Retrieve URL
-   Host URL



References
------------

-   [CILogon documentation for requesting InCommon certificates](http://www.cilogon.org/globus-with-incommon-ca)
-   [Useful OpenSSL commands (from NCSA)](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html) - e.g. how to convert the format of your certificate.
