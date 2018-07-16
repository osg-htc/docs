Host Certificates
=================

!!! note
    This document describes how to get **host** certificates.
    For instructions on how to get **user** certificates, see the [User Certificates document](user-certs.md).

Host certificates are [X.509 certificates](https://en.wikipedia.org/wiki/X.509) that are used to securely identify
servers and to establish encrypted connections between services and clients.
In the OSG, some grid resources (e.g., HTCondor-CE, XRootD, GridFTP) require host certificates.
If you are unsure if your host needs a host certificate, please consult the installation instructions for the software
you are interested in installing.

To acquire a host certificate, you must submit a request to a Certificate Authority (CA).
We recommend requesting host certificates from one of the following CA services:

- [InCommon](https://www.incommon.org/cert/): an IGTF-accredited CA for services that interact with the WLCG;
  requires a subscription, generally held by an institution
- [Let's Encrypt](https://letsencrypt.org/): a free, automated, and open CA frequently used for web services;
  see the [security team's position on Let's Encrypt](https://opensciencegrid.org/security/LetsEncryptOSGCAbundle/)
  for more details
- If neither of the above options work for your site, the OSG also accepts all
  [IGTF-accredited CAs](http://repo.opensciencegrid.org/pacman/cadist/).

Use this page to learn how to request and install host certificates on an OSG resource.

Before Starting
---------------

Before requesting a new host certificate, use `openssl` to check if your host already has a valid certificate.
If so, you may safely skip this document:

``` console
user@host $ openssl x509 -in /etc/grid-security/hostcert.pem -subject -issuer -dates -noout
subject= /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=host.opensciencegrid.org
issuer=/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1
notBefore=Jan  4 21:08:09 2010 GMT
notAfter=Jan  4 21:08:09 2011 GMT
```

Requesting InCommon Host Certificates
-------------------------------------

Many institution in the United States already subscribe to InCommon and offer certificate services.
If your institution is in the list of [InCommon subscribers](https://www.incommon.org/certificates/subscribers.html),
continue with the instructions below.
If your institution is not in the list, Let's Encrypt certificates do not meet your needs, and you do not have access to
another IGTF CA subscription, please [contact us](/common/help.md).

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](/release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](/common/yum)

From a host that meets the above requirements, follow the instructions below to request a new host certificate:

1. Install the `osg-pki-tools`:

        :::console
        root@host # yum install osg-pki-tools

1. Generate a Certificate Signing Request (CSR) and private key using the `osg-cert-request` tool:

        :::console
        user@host $ osg-cert-request --hostname <HOSTNAME> \
                     --country <COUNTRY> \
                     --state <STATE> \
                     --locality <LOCALITY> \
                     --organization <ORGANIZATION>

    You may also add [DNS Subject Alternative Names](https://en.wikipedia.org/wiki/Subject_Alternative_Name) (SAN) to
    the request by specifying any number of `--altname <SAN>`.
    For example, the following generates a CSR for `test.opensciencegrid.org` with `foo.opensciencegrid.org` and
    `bar.opensciencegrid.org` as SANs:

        :::console
        user@host $ osg-cert-request --hostname test.opensciencegrid.org \
                     --country US \
                     --state Wisconsin \
                     --locality Madison \
                     --organization 'University of Wisconsin' \
                     --altname foo.opensciencegrid.org \
                     --altname bar.opensciencegrid.org

    If successful, the CSR will be named `<HOSTNAME>.req` and the private key will be named `<HOSTNAME>-key.pem`.
    Additional options and descriptions can be found [here](https://github.com/opensciencegrid/osg-pki-tools#options).

1. Find your institution-specific InCommon contact
   (e.g. [UW-Madison InCommon contact](https://it.wisc.edu/about/office-of-the-cio/cybersecurity/security-tools-software/server-certificates/)),
   submit the CSR that you generated above, and ask for the certificate to be signed by the InCommon IGTF CA.
1. After the certificate has been issued by your institution, download it on its intended host and copy over the key you
generated above.
1. Verify that the issuer `CN` field is ` InCommon IGTF Server CA`:

        :::console
        $ openssl x509 -in %RED%<PATH TO CERTIFICATE>%ENDCOLOR% -noout -issuer
        issuer= /C=US/O=Internet2/OU=InCommon/CN=InCommon IGTF Server CA

1. Install the host certificate and key:

        :::console
        root@host # cp %RED%<PATH TO CERTIFICATE>%ENDCOLOR% /etc/grid-security/hostcert.pem
        root@host # chmod 444 /etc/grid-security/hostcert.pem
        root@host # cp %RED%<PATH TO KEY>%ENDCOLOR% /etc/grid-security/hostkey.pem
        root@host # chmod 400 /etc/grid-security/hostkey.pem

Requesting Host Certificates Using [Let's Encrypt](https://letsencrypt.org/)
----------------------------------------------------------------------------

[Let's Encrypt](https://letsencrypt.org/) is a free, automated, and open CA frequently used for web services;
see the [security team's position on Let's Encrypt](https://opensciencegrid.github.io/security/LetsEncryptOSGCAbundle/)
for more details.
Let's Encrypt can be used to obtain host certificates as an alternative to InCommon if your institution does not have
an InCommon subscription.

1. Install the `certbot` package (available from the EPEL 7 repository):

        :::console
        root@host # yum install certbot

1. If you have any service running on port 80, you will have to disable it temporarily to obtain certificates, as Let's
   Encrypt needs to bind on it temporarily in order to verify the host.
   For instance, if you already have an HTCondor-CE set up with the
   [HTCondor-CE View service](https://opensciencegrid.github.io/docs/compute-element/install-htcondor-ce/#install-and-run-the-htcondor-ce-view)
   running, stop the HTCondor-CE View service, as it listens on port 80.

1. Run the following command to obtain the host certificate with Let's Encrypt:

        :::console
        root@host # certbot certonly --standalone --email %RED%<ADMIN_EMAIL>%ENDCOLOR% -d %RED%<HOST>%ENDCOLOR%

1. Set up hostcert/hostkey links:

        :::console
        root@host # ln -s /etc/letsencrypt/live/*/cert.pem /etc/grid-security/hostcert.pem
        root@host # ln -s /etc/letsencrypt/live/*/privkey.pem /etc/grid-security/hostkey.pem
        root@host # chmod 0600 /etc/letsencrypt/archive/*/privkey*.pem


### Renewing Let's Encrypt host certificates ###

Before the host certificate expires, you can renew it with the following command:

``` console
root@host # certbot renew
```

To automate renewal monthly with a cron job; for example you can create `/etc/cron.d/certbot-renew` with the following
contents:

``` console
* * 1 * * root certbot renew
```

Requesting Service Certificates
-------------------------------

Previously, the OSG recommended using separate X.509 certificates, called "service certificates", for each grid service
on a host.
This practice has become less popular as sites have separated SSL-requiring services to their own hosts.

In the case where your host is only running a single service that requires a service certificate, we recommend using
your host certificate as your service certificate.
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

There is no separate renewal procedure.
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

-   [CILogon documentation for requesting InCommon certificates](http://www.cilogon.org/globus-with-incommon-ca)
-   [Useful OpenSSL commands (from NCSA)](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html) - e.g. how to convert the format of your certificate.

-   [Official Let's Encrypt setup guide](https://letsencrypt.org/getting-started/)

-   Another [Let's Encrypt setup reference](https://github.com/cilogon/letsencrypt-certificates)
    Under Getting your host certificate, we follow the first "Setting up" section.
