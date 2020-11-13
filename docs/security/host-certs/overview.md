Host Certificates
=================

!!! note
    This document describes how to get **host** certificates.
    For instructions on how to get **user** certificates, see the [User Certificates document](../user-certs.md).

Host certificates are [X.509 certificates](https://en.wikipedia.org/wiki/X.509) that are used to securely identify
servers and to establish encrypted connections between services and clients.
In the OSG, some grid resources (e.g., HTCondor-CE, XRootD, GridFTP) require host certificates.
If you are unsure if your host needs a host certificate, please consult the installation instructions for the software
you are interested in installing.

To acquire a host certificate, you must submit a request to a Certificate Authority (CA).
We recommend requesting host certificates from one of the following CAs:

- [InCommon IGTF](incommon.md):
  an IGTF-accredited CA for services that interact with the WLCG;
  requires a subscription, generally held by an institution

    !!! important
        For integration with the OSG, InCommon host certificates must be issued by the
        [IGTF CA](https://spaces.at.internet2.edu/display/ICCS/InCommon+Cert+Types#InCommonCertTypes-IGTFServerCertificates)
        and not the InCommon RSA CA.

- [Let's Encrypt](lets-encrypt.md):
  a free, automated, and open CA frequently used for web services;
  see the [security team's position on Let's Encrypt](https://opensciencegrid.org/security/LetsEncryptOSGCAbundle/)
  for more details.
  Let's Encrypt is not IGTF-accredited so their certificates are not suitable for WLCG services.

- [DigiCert IGTF](digicert.md):
  an IGTF-accredited CA for services that interact with the WLCG;
  individual certificates are available for purchase without a subscription.

If neither of the above options work for your site, the OSG also accepts all
[IGTF-accredited CAs](https://repo.opensciencegrid.org/cadist/).

Before Starting
---------------

Before requesting a new host certificate, use `openssl` to check if your host already has a valid certificate, i.e. the
present is between `notBefore` and `notAfter` dates and times.
If so, you may safely skip this document:

``` console
user@host $ openssl x509 -in /etc/grid-security/hostcert.pem -subject -issuer -dates -noout
subject= /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=host.opensciencegrid.org
issuer=/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1
notBefore=Jan  4 21:08:09 2010 GMT
notAfter=Jan  4 21:08:09 2011 GMT
```

If you are using OpenSSL 1.1, you may notice minor formatting differences.



Requesting Service Certificates
-------------------------------

Previously, the OSG recommended using separate X.509 certificates, called "service certificates", for each grid service
on a host.
This practice has become less popular as sites have separated SSL-requiring services to their own hosts.

In the case where your host is only running a single service that requires a service certificate, we recommend using
your [host certificate](#host-certificates) as your service certificate.
Ensure that the ownership of the host certificate and key are appropriate for the service you are running.

If you are running multiple services that require host certificates, we recommend requesting a certificate whose
CommonName is `<service>-hostname` and has the hostname in the list of subject alternative names.

Frequently Asked Questions
---------------------------

### Can I use any host to request a certificate for a different host? 

YES, you can use any host to create a certificate signing request as long as the hostname for the certificate is a fully
qualified domain name.

### How do I renew a host certificate? 

For Let's Encrypt certificates, see [this section](#renewing-lets-encrypt-host-certificates)

For other certificates, there is no separate renewal procedure.
Instead, request a new certificate using one of the methods above.

### How can I check if I have a host certificate installed already? 

By default the host certificate key pair will be installed in `/etc/grid-security/hostcert.pem` and
`/etc/grid-security/hostkey.pem`.
You can use `openssl` to access basic information about the certificate:

``` console
root@host # openssl x509 -in /etc/grid-security/hostcert.pem -subject -issuer -dates -noout
subject= /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=host.opensciencegrid.org
issuer= /DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1
notBefore=Apr  8 00:00:00 2013 GMT
notAfter=May 17 12:00:00 2014 GMT
```

### How can I check the expiration time of my installed host certificate? 

Use the following `openssl` command to find the dates that your host certificate is valid:

``` console
root@host # openssl x509 -in /etc/grid-security/hostcert.pem -dates -noout
notBefore=Jan  4 21:08:41 2010 GMT
notAfter=Jan  4 21:08:41 2011 GMT
```

References
------------

-   [Useful OpenSSL commands (from NCSA)](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html) - e.g. how to convert the format of your certificate.

