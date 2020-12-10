DigiCert IGTF Host Certificates
===============================

!!! note
    This document describes how to get **host** certificates.
    For instructions on how to get **user** certificates, see the [User Certificates document](../user-certs.md).

This document describes how to purchase individual IGTF-accredited host certificates from [DigiCert](https://www.digicert.com/).
Before purchasing individual certificates, consider the following alternatives:

1. Request a [Let's Encrypt certificate](lets-encrypt.md)
   if you don't support any VOs that require IGTF-accredited certificates (e.g. `ATLAS` or `CMS`).
1. Request an [InCommon certificate](incommon.md)
   if your institution has an InCommon subscription.

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

If you do not have a valid certificate, the OSG offers a command-line tool to generate certificate signing requests (CSR)
to assist in acquiring a grid host certificate.
As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../../release/supported_platforms.md)
- Obtain root access to the host
- Prepare the [required Yum repositories](../../common/yum.md)

Create a DigiCert Account
-------------------------

Before requesting a certificate, you must create a DigiCert account with permission to request grid certificates:

1. Navigate to the [DigiCert sign up page](https://www.digicert.com/account/signup/) and create an account

    !!!attention
        It is very important to use your institution's main address and other contact information.
        Departmental addresses will not pass DigiCert's verification process.

1. Submit a support request to allow you to order grid host certificates, referencing support ticket `#01336672`

1. After your request has been approved, verify that the `Grid Host SSL` option is available to you from your account's
   order page:

![DigiCert Order Menu](../../img/digicert-order-menu.png)

Requesting DigiCert IGTF Host Certificates
------------------------------------------

1. Install the `osg-pki-tools`:

        :::console
        root@host # yum install osg-pki-tools

1. Generate a CSR and private key using the `osg-cert-request` tool:

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
                     --organization 'University of Wisconsin-Madison' \
                     --altname foo.opensciencegrid.org \
                     --altname bar.opensciencegrid.org

    If successful, the CSR will be named `<HOSTNAME>.req` and the private key will be named `<HOSTNAME>-key.pem`.
    Additional options and descriptions can be found [here](https://github.com/opensciencegrid/osg-pki-tools#options).

1. Submit an order using DigiCert's grid certificate [order page](https://www.digicert.com/secure/requests/ssl_certificate/grid_host_ssl):

    1. Login to your [DigiCert account](#create-a-digicert-account)

    1. Attach the CSR that you generated above

    1. Pay for your certificate and await approval

1. After the certificate has been issued by DigiCert, download the host certificate only (not the full chain) to
   its intended host and copy over the key you generated above.

1. Verify that the issuer `CN` field is ` DigiCert Grid Trust CA G2`:

        :::console
        $ openssl x509 -in <PATH TO CERTIFICATE> -noout -issuer
        issuer= /C=US/O=DigiCert Grid/OU=www.digicert.com/CN=DigiCert Grid Trust CA G2

    Where `<PATH TO CERTIFICATE>` is the file you downloaded in the previous step

1. Install the host certificate and key:

        :::console
        root@host # cp <PATH TO CERTIFICATE> /etc/grid-security/hostcert.pem
        root@host # chmod 444 /etc/grid-security/hostcert.pem
        root@host # cp <PATH TO KEY> /etc/grid-security/hostkey.pem
        root@host # chmod 400 /etc/grid-security/hostkey.pem

    Where `<PATH TO KEY>` is the ".key" file you created in the first step
