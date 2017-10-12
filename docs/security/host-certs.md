How to Get Host and Service Certificates
=============================================

This document is for system administrators. After reading this document you should be able to apply for and install a grid certificate on a grid resource. This document does not explain how to apply for a grid user certificate. To apply for a grid user certificate click [here](user-certs.md) instead!

Requirements
=================

Before requesting a new host or service certificate, you should check if a certificate is not installed already using **openssl**. In this case you may safely skip this document:

``` console
[user@host ~]$ openssl x509 -in /etc/grid-security/hostcert.pem -subject -issuer -dates -noout
subject= /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=host.opensciencegrid.org
issuer=/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1
notBefore=Jan  4 21:08:09 2010 GMT
notAfter=Jan  4 21:08:09 2011 GMT
```

The OSG PKI Command Line Clients are tested to work on Python version 2.4+. They have not been tested on Python version 3.

We recommend to read background information on grid certificates which can be found <a href="/bin/view/Documentation/CertificateWhatIs" class="twikiLink">here</a>. In order to proceed you will also need:

-   the **fully qualified domain name** of the host you need a grid certificate for
-   the **purpose** of the certificate that explains your request to the Certificate Authority
-   the full **name of the administrator** responsible for the host
-   the **e-mail address of the administrator**
-   the **telephone number of the administrator**
-   the name of the **Certificate Authority** your project is affiliated with
-   the name of the **Virtual Organization** affiliated with the Certificate Authority

Requesting host/service certificate using OIM
==================================================

The OSG PKI Certificate Request & Management System can be found at: <https://oim.grid.iu.edu/oim/certificate>.

For instructions on how to request a host or service certificate using the Web interface please see the [user guide maintained by GOC](https://confluence.grid.iu.edu/pages/viewpage.action?pageId=3244064).

Installation
=================

Install the OSG PKI Command Line Clients 
----------------------------------------------------------------------------------

``` console
[root@host /]$ yum install osg-pki-tools
```

### Configuration file pki-clients.ini

This configuration is correctly set by default and you will not need to change them. The information is provided in case you need it for debugging purposes.

The client checks for pki-clients.ini file at three location in order:

-   $HOME/.osg-pki/OSG\_PKI.ini
-   ./pki-clients.ini
-   /etc/osg/pki-clients.ini (default location)

The INI file contains the following information:

-   Request URL
-   Approve URL
-   Retrieve URL
-   Host URL

Validate authentication
============================

Make sure you can create a valid grid proxy. To do so, please follow instructions:

1.  Double-check your configuration to make sure that you are allowed (specifically, your credentials are allowed) to access your CE. You can be either member of a VO allowed to run at the site or you can add your personal certificate locally. This will either be in your GUMS server or in your `edg-mkgridmap` configuration.
2.  Create a proxy with `voms-proxy-init` or `grid-proxy-init`. For example:

    ``` console
    [user@host /]$ voms-proxy-init -voms GLOW
    Enter GRID pass phrase for this identity:
    Your identity: /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services=People/CN=Alain Roy 424511
    Creating temporary proxy ................................................................................. Done
    Contacting  glow-voms.cs.wisc.edu:15001 [/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=glow-voms.cs.wisc.edu] "GLOW" Done
    Creating proxy ..................................................................... Done

    Your proxy is valid until Fri Dec  2 01:32:47 2011
    ```

    You'll substitute your own VO, of course.

Request a Host Certificate
===============================

Every resource or service contributing to the grid needs a certificate issued by one of the trusted **Certificate Authorities**. To proceed you will need following information at hand:

-   the **fully qualified domain** name of the host you need a grid certificate for
-   the **purpose** of the certificate that explains your request to the Certificate Authority
-   the full **name of the administrator** responsible for the host
-   the **e-mail address of the administrator**
-   the **telephone number of the administrator**
-   the name of the **Certificate Authority** your project is affiliated with
-   the name of the **Virtual Organization** affiliated with the Certificate Authority

Send the request 
----------------------------------------------------------

This command line client generates a private key and submits a request for a certificate to the OSG PKI. The request will be approved by an appropriate Grid Admin. You will receive an email when this approval has been completed containing directions on how to run 'osg-cert-retreive' to retrieve the certificate. It works in two modes:

-   CSR is provided by the user: Here the csr provided is just trimmed for begin and end certificate lines and the request is sent to the OIM
-   CSR is not provided by the user: Here the script generates a private key for the user. Writes it to default key file name or the one specified by -o. Then generates a new csr and sends it to OIM.

The second mode will commonly be used by most OSG site admins

Use **osg-cert-request** to generate a request which will be sent to the Certificate Authority you specified. Change "host.opensciencegrid.org" to be the host name for the computer for which you need a certificate and provide your contact details for the grid admin to approve your request.

``` console
[user@host /]$ osg-cert-request -H host.opensciencegrid.org -e emailaddress@domain.com -n "Your Name" -p 9999999999 (Ph No) -v "Your VO" -y "xyz@domain.com,abc@domain.com" (CC list) -m "This is my comment" -o hostkey.pem
```

Example:

``` console
[user@host /]$ osg-cert-request -H sectest.cigi.illinois.edu -e apadmana@domain.edu -n "Anand" -p 9999999999 -m "Testing for developing security documentation" -o hostkey.pem

Writing key to hostkey.pem

Connecting to server...
Succesfully submitted
Request Id#: 570
```

At this point **osg-cert-request** has created some files in the directory you specified and an e-mail has been sent to the Certificate Authority containing your request. The files will be needed again once you receive a reply from the Certificate Authority asking you to retrieve the certificate. Please note down the Request Id. You will need it for retrieving the signed certificate.

<span id="twistyIdDocumentation/Release3GetHostServiceCertificates1show" class="twistyRememberSetting twistyStartHide twistyTrigger twikiUnvisited twistyInited0">[![](/twiki/pub/TWiki/TWikiDocGraphics/toggleopen-small.gif)<span class="twikiLinkLabel twikiUnvisited">Show Full Output](#)  <span id="twistyIdDocumentation/Release3GetHostServiceCertificates1hide" class="twistyRememberSetting twistyStartHide twistyTrigger twikiUnvisited twistyHidden twistyInited0">[![](/twiki/pub/TWiki/TWikiDocGraphics/toggleclose-small.gif)<span class="twikiLinkLabel twikiUnvisited">Hide Full Output](#) 

### Detailed description of the osg-cert-request usage

This script:
-   Generates a new host private key and CSR
-   Only important part of CSR is CN= component
-   Saves the host private key to disk (as specified by the user)
-   Authenticates to OIM and posts the CSR as a request to OIM
-   Returns the request ID to the user
-   If the user provides the CSR, then this script would just send the same CSR to OIM

**Inputs:**
-   fully-qualified hostname
-   filename to store private key \[Optional, default is ./hostkey.pem\]
-   path to user's certificate \[Optional, default is path specified by $X509\_USER\_CERT environment variable, ~/.globus/usercert.pem\]
-   path to user's private key \[Optional, default is path specified by $X509\_USER\_KEY environment variable, ~/.globus/userkey.pem\]
-   Passphrase for user's private key via non-echoing prompt.
-   User needs to provide VO name if the requested hostname has multiple VO's assigned

**Outputs:**
-   Private key, to filename specified by '-o' or ./hostkey.pem by default
-   Request Id, to stdout

**Usage**: osg-cert-request \[options\]
    *Options*:

      -h, --help            show this help message and exit
      -c CSR, --csr=CSR     Specify CSR name (default = gennew.csr)
      -o Output Keyfile, --outkeyfile=Output Keyfile
                            Specify the output filename for the retrieved user
                            certificate.  Default is ./hostkey.pem
      -y CC List, --cc=CC List
                            Specify the CC list(the email id's to be CCed). Separate values by ','
      -m Comment, --comment=Comment
                            The comment to be added to the request
      -H CN, --hostname=CN  Specify hostname for CSR (FQDN)
      -e EMAIL, --email=EMAIL
                            Email address to receive certificate
      -n NAME, --name=NAME  Name of user receiving certificate
      -p PHONE, --phone=PHONE
                            Phone number of user receiving certificate
      -v VO, --vo=VO
                            VO name of requested hostname
      -T, --test            Run in test mode
      -q, --quiet           don't print status messages to stdout
      -V, --version         Print the script version number and exit. 

Retrieve and Install the Host Certificate 
-----------------------------------------------------------------------------------

Once the certificate has been approved by the Certificate Authority you will receive an e-mail for the GOC. Then to retrieve the host certificate we will execute **osg-cert-retrieve**: and use the request ID we recorded earlier. Since certificates are public, no authentication of the user is required to retrieve them.

``` console
[user@host /]$  osg-cert-retrieve 570 -o hostcert.pem
Using timeout of 5 minutes
Running in test mode
Connecting server to retrieve certificate...
Certificate written to hostcert.pem
```

<span id="twistyIdDocumentation/Release3GetHostServiceCertificates2show" class="twistyRememberSetting twistyStartHide twistyTrigger twikiUnvisited twistyInited0">[![](/twiki/pub/TWiki/TWikiDocGraphics/toggleopen-small.gif)<span class="twikiLinkLabel twikiUnvisited">Show Full Output](#)  <span id="twistyIdDocumentation/Release3GetHostServiceCertificates2hide" class="twistyRememberSetting twistyStartHide twistyTrigger twikiUnvisited twistyHidden twistyInited0">[![](/twiki/pub/TWiki/TWikiDocGraphics/toggleclose-small.gif)<span class="twikiLinkLabel twikiUnvisited">Hide Full Output](#) 

### Detailed description of the osg-cert-retrive usage

This osg-cert-retrive script:
-   Accepts a request Id from the user
-   Connects to OIM and requests the certificate identified by the request ID
-   Writes the certificate to disk (as specified by the user)

**Inputs:**
-   Request ID
-   Filename to store certificate \[Optional, default is ./hostcert.pem\]

**Outputs:**
-   Host certificate as PEM, to filename specified or ./hostcert.pem

**Usage**:osg-cert-retrieve -h/--help \[for detailed explanations of options\]

    Options:
      -h, --help            show this help message and exit
      -i ID, --id=ID        Specify ID# of certificate to retrieve[Required]
      -o ID, --certfile=ID  Specify the output filename for the retrieved user
                            certificate . Default is ./hostcert.pem
      -T, --test            Run in test mode
      -q, --quiet           don't print status messages to stdout
      -V, --version         Print the script version number and exit. 

The certificate consists of two files (default hostcert.pem and hostkey.pem) which have been placed into the current directory. Note, If you did not use the `--o` option the filenames will be what you provided.

<img src="/twiki/pub/TWiki/TWikiDocGraphics/warning.gif" alt="warning" width="16" height="16" /> Please note that these files represent a public and a private and should be treated accordingly!

Please take a moment to verify that the **certificate matches the hostname** of the resource where you intend to install it before you proceed:

``` console
[user@host /]$ grid-cert-info -file ./hostcert.pem -subject
/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=host.opensciencegrid.org

[user@host /]$ hostname -f
host.opensciencegrid.org
```

Finally, install the certificate in the default location **/etc/grid-security/**:

``` console
[root@host /]$ cp ./host.opensciencegrid.orgcert.pem /etc/grid-security/hostcert.pem
[root@host /]$ chmod 444 /etc/grid-security/hostcert.pem
[root@host /]$ cp ./host.opensciencegrid.orgkey.pem /etc/grid-security/hostkey.pem
[root@host /]$ chmod 400 /etc/grid-security/hostkey.pem
```

Request a Service Certificate
==================================

You can use the same **osg-cert-request** and **osg-cert-retrieve** commands to request and service certificates just like any host certificate. Just use service/hostname for the -t parameter.

``` console
[user@host /]$ osg-cert-request -H http/host.opensciencegrid.org -e emailaddress@domain.com -n "Your Name" -p 9999999999 (Ph No) -v "Your VO" -y "xyz@domain.com,abc@domain.com" (CC list) -m "This is my comment" -o hostkey.pem
Writing key to ./hostkey.pem

Connecting to server...
Succesfully submitted
Request Id#: 571
```

Please note down the request ID.

Once the certificate has been approved by the Certificate Authority you will receive an e-mail for the GOC. Then to retrieve the host certificate we will execute **osg-cert-retrieve**: and use the request ID we recorded earlier. Since certificates are public, no authentication of the user is required to retrieve them.

``` console
[user@host /]$  osg-cert-retrieve 571 -o hostcert.pem
Using timeout of 5 minutes
Running in test mode
Connecting server to retrieve certificate...
Certificate written to hostcert.pem
```

<img src="/twiki/pub/TWiki/TWikiDocGraphics/warning.gif" alt="warning" width="16" height="16" /> Please note that these files represent a public and a private and should be treated accordingly!

Install the Service Certificate 
-------------------------------------------------------------------------

The **Service Certificate** should be installed under a subdirectory in **/etc/grid-security** indicating the name of the service. The next step will install the service certificate in the default location **/etc/grid-security/http**:

``` console
[root@host /]$ cp ./host.opensciencegrid.org-httpcert.pem /etc/grid-security/http/httpcert.pem
[root@host /]$ chmod 444 /etc/grid-security/http/httpcert.pem
[root@host /]$ cp ./host.opensciencegrid.org-httpkey.pem /etc/grid-security/http/httpkey.pem
[root@host /]$ chmod 400 /etc/grid-security/http/httpkey.pem
```

<img src="/twiki/pub/TWiki/TWikiDocGraphics/warning.gif" alt="warning" width="16" height="16" /> Please note that the service certificate must also be owned by the unix user who runs the service. For **Apache/Tomcat** this is the tomcat user:

``` console
[root@host /]$ chown tomcat.tomcat /etc/grid-security/http/httpcert.pem
[root@host /]$ chown tomcat.tomcat /etc/grid-security/http/httpkey.pem
```

Please refer to [Operations/OSGPKICommandlineClients](../common/pki-cli.md) for full documentation of the Client package

Information for Grid Admins
================================

If you are a grid admin then you can use a single command to request and retrieve a certificate immediately. For getting grid admin privileges please refer <a href="/bin/view/Operations/OSGPKITrustedAgent" class="twikiLink">here</a>.

Request and retrieve multliple host certificates from OIM. Authenticates to OIM and is only for use by Grid Admins for certificates they are authorized to approve. This script is only supported with all hosts being in the same domain (so we ensure they go to the same Grid Admin). The certificates are stored with the format of 'hostname-requestid.pem' (i.e. the id generated from the request for the certificate). The key is stored as 'hostname-serial-key.pem'.

Examples:

``` console
[user@host /]$ osg-gridadmin-cert-request -H host.opensciencegrid.org
```

If you want to request more then one certificate you can list them in a file (one host per line) and use the following command

``` console
[user@host /]$ osg-gridadmin-cert-request -f hostfile
```

<span id="twistyIdDocumentation/Release3GetHostServiceCertificates3show" class="twistyRememberSetting twistyStartHide twistyTrigger twikiUnvisited twistyInited0">[![](/twiki/pub/TWiki/TWikiDocGraphics/toggleopen-small.gif)<span class="twikiLinkLabel twikiUnvisited">Show Full Output](#)  <span id="twistyIdDocumentation/Release3GetHostServiceCertificates3hide" class="twistyRememberSetting twistyStartHide twistyTrigger twikiUnvisited twistyHidden twistyInited0">[![](/twiki/pub/TWiki/TWikiDocGraphics/toggleclose-small.gif)<span class="twikiLinkLabel twikiUnvisited">Hide Full Output](#) 

### Detailed description of the osg-gridadmin-cert-request usage

This osg-gridadmin-cert-request script does the following in the process of acquiring certificates for the hostnames specified:

Reads a list of fully-qualified hostnames from a file specified by the user. For reach hostname: Generates a new private key and CSR Only important part of CSR is CN= component Writes the private key to a file with filename: /-key.pem Prompts the user for their private key pass phrase Pass phrase is cached so user is not re-prompted Authenticates to OIM and posts the CSRs as a single request to OIM Request id is returned and subsequently used Authenticates to OIM and approves the request Waits one minute for request to be processed by OIM Connects to OIM and attempts to retrieve certificates Writes out any certificates it retrieves with filename of /-<red-id>.pem if all certificates have been retrieved, exits loop Wait 5 seconds and repeat.

Inputs:

filename of list of hostnames prefix path in which to write private keys and certificares \[default: .\] path to user's certificate \[Optional, default is path specified by $X509\_USER\_CERT environment variable, ~/.globus/usercert.pem\] path to user's private key \[Optional, default is path specified by $X509\_USER\_KEY environment variable, ~/.globus/userkey.pem\] Passphrase for user's private key via non-echoing prompt.

Outputs:

N host certificates in PEM format N private keys in PEM format

Usage:osg-gridadmin-cert-request -h/--help \[for detailed explanations of options\]

**Options**: -h, --help show this help message and exit -k PKEY, --pkey=PKEY Specify Requestor's private key (PEM Format). If not specified will take the value of X509\_USER\_KEY or $HOME/.globus/userkey.pem -c CERT, --cert=CERT Specify Requestor's certificate (PEM Format). If not specified will take the value of X509\_USER\_CERT or $HOME/.globus/usercert.pem -T, --test Run in test mode -q, --quiet don't print status messages to stdout -V, --version Print the script version number and exit.

**Hostname Options**: Use either of these options. Specify hostname as a single hostname using -H/--hostname or specify from a file using -f/--hostfile.

-H HOSTNAME, --hostname=HOSTNAME Specify the hostname or service/hostname for which you want to request the certificate for. If specified -f/--hostfile will be ignored -f HOSTFILE, --hostfile=HOSTFILE Filename with one hostname or service/hostname per line

Frequently Asked Questions
===============================

Can I use any host to request a certificate for a different host? 
-----------------------------------------------------------------------------------------------------------

YES, you can use any host to create a certificate request as long as the hostname for the certificate is a fully qualified domain name.

May I reuse my host certificate as a service certificate? 
---------------------------------------------------------------------------------------------------

NO! For security reasons, please do not use clones of your host certificate for additional certificates even though it's technically possible.

How do I renew a host/service certificate? 
------------------------------------------------------------------------------------

There is no separate procedure. Simply ask for a new certificate the same way you asked for it the previous time.

I get a "GSS authentication failure" when users try to authenticate with my site? 
---------------------------------------------------------------------------------------------------------------------------

You likely used an **alias** for the host instead of the fully qualified domain name when you generated the certificate request. This can cause the GSS authentication failures similar to the following when a user tries to authenticate to the host after your certificate is installed:

``` console
GSS authentication failure 
GSS Major Status: General failure 
GSS Minor Status Error Chain: 
accept_sec_context.c:gss_accept_sec_context:403: 
Error during delegation: Delegation protocol violation 
Failure: GSS failed Major:000d0000 Minor:00000001 Token:00000000 
```

How can I check if I have a host certificate installed already? 
---------------------------------------------------------------------------------------------------------

By default the host certificate key pair will be installed in `/etc/grid-security/hostcert.pem` and `/etc/grid-security/hostkey.pem`. You can use **openssl** to access basic information about the certificate:

``` console
[root@osg-se robert]# openssl x509 -in /etc/grid-security/hostcert.pem -subject -issuer -dates -noout
subject= /DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=host.opensciencegrid.org
issuer= /DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1
notBefore=Apr  8 00:00:00 2013 GMT
notAfter=May 17 12:00:00 2014 GMT
```

How can I check the expiration time of my installed host certificate? 
---------------------------------------------------------------------------------------------------------------

If you installed the <a href="/bin/view/Documentation/Release3/InstallCertScripts" class="twikiLink">Certificates Script Package</a> you can use **grid-cert-info** to retrieve information about the certificate:

``` console
[root@osg-se robert]# grid-cert-info -file /etc/grid-security/hostcert.pem -startdate -enddate
Jan  4 21:08:41 2010 GMT
Jan  4 21:08:41 2011 GMT
```

Alternatively you can use **openssl**:

``` console
[root@osg-se robert]# openssl x509 -in /etc/grid-security/hostcert.pem -dates -noout
notBefore=Jan  4 21:08:41 2010 GMT
notAfter=Jan  4 21:08:41 2011 GMT
```

References
===============

-   [Useful OpenSSL commands (from NCSA)](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html) - e.g. how to convert the format of your certificate.
