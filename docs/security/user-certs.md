User Certificates
=================

!!! note
    For instructions on getting **service** and **host** certificates, **you're in the wrong place**. See [Get Host and Service Certificates](host-certs.md).

This document describes how to get and set up a **personal** certificate (also called a grid user certificate), from the OSG Certificate Authority (OSG CA). The OSG CA is recognized by all OSG resources. Other CAs may be used; if your virtual organization (VO) requires that you get a certificate from a different CA, [contact your VO Support Center](http://www.opensciencegrid.org/?pid=1000187) for instructions.

Know Your Responsibilities
--------------------------

When you request a certificate your provide some public personal information about yourself; *name, email address, phone number*, and which *VO* (virtual organization) you belong to. If any of this information changes after you have your certificate you should notify OSG (and probably VO) of the changes. For the OSG RA send email to osg-ra at opensciencegrid dot org.

Your **name** and **email** address are encoded into the signed certificate and **if either of those change** (usually email address) then you should **request a new certificate** with the correct information and **revoke the old certificate**.

Requesting a User Certificate
-----------------------------

There are two different ways to obtain your certificate, either via a command line interface, or through a web browser. The links below will guide you through whichever method you choose. The command line method is generally simpler and less prone to errors than using a web browser but it may require extra setup and package installation the first time you do it. Most people end up needing their certificate for both command line grid use and web browser use and it is generally easier to import your certificate into your browser (and email client) from the command line certificate files than to export your certificate from your web browser to use on the command line. This is because of the large variety of web browsers each with it's own way to deal with certificates. If you will use the certificate ONLY in your web browser then requesting it from your browser is probably the easiest method.

[Get or renew a certificate with command line interface.](../security/certificate-management.md)

PKCS12 (.p12) vs PEM format
---------------------------

Your certificate and key pair can be stored as separate files, by default named `~/.globus/usercert.pem` and `~/.globus/userkey.pem`, or they can be bundled in a single file in PKCS12 (Public Key Cryptography Standard \#12), by default named `~/.globus/usercred.p12`. All OSG user tools works with both formats. Unless you specify a name in the command, they look first for the certificate/key pair default names, then for the PKCS12 default name and use the first one they find. PKCS 12 is a single file, convenient to move and used by many softwares, e.g. the Web browsers (so you don't need conversions).

Anyway note that the PKCS12 bundle includes normally the certificate, the key and also the CA certificate (or a certificate chain) validating your certificate. In the rare (but possible) case where the CA certificate expires before your certificate this may lead to the creation of a proxy without VOMS attributes and confusing error messages where it is not clear if the problem is with the host, remote server or the certificate, e.g. "Error: Error during SSL handshake:Either proxy or user certificate are expired." or "error:80066423:lib(128):verify\_callback:remote certificate has expired:sslutils.c:1963 remote certificate has expired".

``` console
user@host $  voms-proxy-init -debug
Detected Globus version: 2.2
Unspecified proxy version, settling on Globus version: 2
Number of bits in key :1024
Files being used:
 CA certificate file: none
 Trusted certificates directory : /etc/grid-security/certificates
 Proxy certificate file : /tmp/x509up_u20003
 User certificate file: /home/user/.globus/usercred.p12
 User key file: /home/user/.globus/usercred.p12
Output to /tmp/x509up_u20003
Enter GRID pass phrase for this identity:
Your identity: /DC=org/DC=doegrids/OU=People/CN=First Lastname 12345
Creating proxy to /tmp/x509up_u20003 .............++++++
.....................++++++
 Done

Your proxy is valid until Fri Aug  9 00:18:07 2013
Error: Certificate verify failed.
error:80066423:lib(128):verify_callback:remote certificate has expired:sslutils.c:1963
remote certificate has expired
Function: verify_callback
error:80066412:lib(128):verify_callback:certificate::sslutils.c:2283
        subject=/DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1
        issuer =/DC=net/DC=ES/O=ESnet/OU=Certificate Authorities/CN=ESnet Root CA 1
certificate:
        subject=/DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1
        issuer =/DC=net/DC=ES/O=ESnet/OU=Certificate Authorities/CN=ESnet Root CA 1
Function: verify_callback
user@host $ voms-proxy-init -debug -voms osg
Detected Globus version: 2.2
Unspecified proxy version, settling on Globus version: 2
Number of bits in key :1024
Files being used:
 CA certificate file: none
 Trusted certificates directory : /etc/grid-security/certificates
 Proxy certificate file : /tmp/x509up_u20003
 User certificate file: /home/user/.globus/usercred.p12
 User key file: /home/user/.globus/usercred.p12
Output to /tmp/x509up_u20003
Enter GRID pass phrase for this identity:
Your identity: /DC=org/DC=doegrids/OU=People/CN=First Lastname 12345
Using configuration file /home/marco/.glite/vomses
Using configuration file /etc/vomses
Creating temporary proxy to /tmp/tmp_x509up_u20003_17448 ..........................++++++
...................++++++
 Done
Contacting  voms.opensciencegrid.org:15027 [/DC=org/DC=doegrids/OU=Services/CN=host/voms.opensciencegrid.org] "osg" Failed

Error: Error during SSL handshake:Either proxy or user certificate are expired.

None of the contacted servers for osg were capable
of returning a valid AC for the user.
```

To solve the problem split the bundle in the two PEM files as documented in the [referenced document](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html), so that the embedded CA chain is not used.

Revoking Your User Certificate
------------------------------

If the security of your certificate or private key has been compromised, you have a responsibility to revoke the certificate. You can follow the steps [here](../security/certificate-management#osg-user-cert-revoke) to revoke your certificate. The same instructions apply if you need to revoke a certificate because your email address changed or your name has changed.

References
----------

-   [Useful Documentation.OpenSSL commands (from NCSA)](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html) - e.g. how to convert the format of your certificate.
