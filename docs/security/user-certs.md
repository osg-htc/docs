User Certificates
=================

!!! note
    This document describes how to get and set up a **personal** certificate (also called a grid user certificate).
    For instructions on getting **service** and **host** certificates, **you're in the wrong place**. See [Get Host and Service Certificates](host-certs.md).


Getting an User Certificate 
---------------------------

This section describes how to get and set up a personal certificate to use on OSG.
Currently you can get a certificate from either the OSG CA or from CILogon.
After May 31st, you will only be able to get a certificate issued by CILogon.
Other CAs may be used; if your virtual organization (VO) requires that you get a certificate from a different CA, [contact your VO Support Center](http://www.opensciencegrid.org/?pid=1000187) for instructions.

### Know your responsibilities

When you request a certificate your provide some public personal information about yourself; *name, email address, phone number*, and which *VO* (virtual organization) you belong to. If any of this information changes after you have your certificate you should notify OSG (and probably VO) of the changes. For the OSG RA send email to osg-ra at opensciencegrid dot org.

Your **name** and **email** address are encoded into the signed certificate and **if either of those change** (usually email address) then you should **request a new certificate** with the correct information and **revoke the old certificate**.

### Getting a Certificate from CILogon

You will have to obtain your user certificate using the [CILogon web UI](https://cilogon.org/).
Follow the steps below to get an user certificate:

1. First, either search for your institution and select it or scroll through list and do the same. <br>![Institution Selection](/img/cilogon_select_idp.png)
1. Click the `Log On` button and enter your instutional credentials.
1. Upon successfully entering your credentials, you'll get a page asking for you to enter a password.  Enter a password that is at least 12 characters long and then click on the `Get New Certificate` button.<br>![Password entry](/img/cilogon_cert_password.png) 
1. The web page will generate a `usercred.p12` file and prompt you to download it.  The certiticate will be protected
using the password you entered in the prior step.

### Getting a Certificate from the OSG CA

There are two different ways to obtain your certificate, either via a command line interface, or through a web browser.
The links below will guide you through whichever method you choose.
The command line method is generally simpler and less prone to errors than using a web browser but it may require extra
setup and package installation the first time you do it.
Most people end up needing their certificate for both command line grid use and web browser use and it is generally
easier to import your certificate into your browser (and email client) from the command line certificate files than to
export your certificate from your web browser to use on the command line. 
This is because of the large variety of web browsers each with its own way to deal with certificates. If you will use
the certificate ONLY in your web browser then requesting it from your browser is probably the easiest method.

[Get or renew a certificate with command line interface.](/security/certificate-management.md)

### PKCS12 (.p12) vs PEM format

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

### Revoking your user certificate

If the security of your certificate or private key has been compromised, you have a responsibility to revoke the certificate.
In addition, if your name or email address changes, you must revoke your certificate and get a new one with the correct
information.

If you have an OSG issued certifiacte, you can follow the steps [here](/security/certificate-management#osg-user-cert-revoke) to revoke your certificate. 
If you have a CILogon issued certificate, contact [ca@cilogon.org](mailto:ca@cilogon.org) in order revoke your certificate. 


Getting a Certificate from a Service Provider with cigetcert
------------------------------------------------------------

You may also get a user certificate from a SAML 2.0 Service Provider such as your home institution or XSEDE.
This kind of certificate is short-lived, typically valid only for a week.
Therefore it is not suitable for using in your browser.
However, it is useful for command-line access to site services such as compute or storage.

You will need to use the `cigetcert` tool to get a certificate this way.
Use yum to install the `cigetcert` package from the OSG repositories.

This is a new way of getting a certificate and does not work with all institutions.
To get a list of institutions supported by `cigetcert`, run:
```console
user@host $ cigetcert --listinstitutions
Clemson University
Fermi National Accelerator Laboratory
LIGO Scientific Collaboration
LTER Network
...
```

To get a certificate, run
```console
user@host $ cigetcert -i "<INSTITUTION>"
Authorizing ...... authorized
Fetching certificate ..... fetched
Storing certificate in /tmp/x509up_u46142
Your certificate is valid until: Fri Apr 13 17:03:13 2018
```
Authentication is controlled by the institution;
depending on the institution, you may need a valid Kerberos token, or will be prompted for a password.

If all goes well, you should see output similar to what's above.
The certificate is created in `/tmp/x509up_u<YOUR UID>`, which is the same place proxies are created by `grid-proxy-init`.

You may specify default arguments in the `CIGETCERTOPTS` environment variable.
This can save you from having to type in the entire institution name every time you want a cert.
For example, to always use FNAL as the institution, put this in your `.bashrc`:
```bash
export CIGETCERTOPTS="-i 'Fermi National Accelerator Laboratory'"
```

Your VO may also provide specific instructions for how to best use this tool.
Contact your VO support center for details.

Finally, `cigetcert` has advanced features, such as the ability to load configuration from a server, or store the cert on a MyProxy server.
See the [manual page for cigetcert](http://htmlpreview.github.io/?https://github.com/fermitools/cigetcert/blob/master/cigetcert.html) for more information.


### Using cigetcert with XSEDE credentials

`cigetcert` also works with XSEDE as the service provider.
To use XSEDE credentials, you will first need an account at <https://portal.xsede.org>.
In addition, you _need_ to set up two-factor authentication with XSEDE; see their [MFA documentation](https://portal.xsede.org/mfa) for details.
Push notifications using the Duo Mobile app are required.

Once you have set all those up, run `cigetcert` as follows:
```console
user@host $ cigetcert -u %RED%<USERNAME>%ENDCOLOR% -i XSEDE
```
`<USERNAME>` is your username at portal.xsede.org.
You will get prompted to "Enter XSEDE Kerberos Password."
Enter the password for your account at portal.xsede.org.
You should then get a 2FA authentication request with Duo Mobile; once you accept this, `cigetcert` will issue the certificate.

References
----------

-   [Useful Documentation.OpenSSL commands (from NCSA)](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html) - e.g. how to convert the format of your certificate.
-   [Manual page for cigetcert](http://htmlpreview.github.io/?https://github.com/fermitools/cigetcert/blob/master/cigetcert.html)
