OSG PKI Command Line Clients
============================

Overview
--------

The OSG PKI Command Line Clients provide a command-line interface for requesting and issuing host certificates from the OSG PKI. They complement the [OIM Web Interface](https://oim.grid.iu.edu/oim/certificateuser).

Prerequisites
-------------

If you have not already done so, you need to [configure the OSG software repositories](../common/yum.md).

Installation
------------

The command-line scripts have been packaged as an RPM and are available from the OSG repositories.

To install the RPM, run:

```console
[root@client ~] # yum install osg-pki-tools
```

Usage
-----

### Configuration Files

This configuration file contains information divided into two sections for testing and production.  Configuration variables include:

-   Request URL
-   Approve URL
-   Retrieve URL
-   Host URL

These parameters are used as input to the script depending upon the mode of execution of the script (test or OIM). The command-line utilities check for configuration files in the following order:

-   `$HOME/.osg-pki/OSG_PKI.ini`
-   `./pki-clients.ini`
-   `/etc/pki-clients.ini`

### osg-cert-request

Sends a request for a host certificate.

This script generates a private key and submits a request for a certificate to the OSG PKI. The request will be approved by an appropriate Grid Admin. You will receive an email when this approval has been completed containing directions on how to run `osg-cert-retreive` to retrieve the certificate. It works in two modes:

-   CSR is provided by the user: the CSR provided is sent to the OIM.
-   CSR is not provided by the user: the script generates a private key for the user. Writes it to default key file name or the one specified by `-o`.

This script:

-   Generates a new host private key and CSR (the only important part of CSR is `CN=<HOSTNAME>` component).
-   Saves the host private key to disk (as specified by the user).
-   Authenticates to OIM and posts the CSR as a request to OIM.
-   Returns the request ID to the user.

If the user provides the CSR, then this script would just send the same CSR to OIM.

**Inputs:**

-   fully-qualified hostname
-   filename to store private key (optional; default is `./hostkey.pem`).
-   path to user's certificate (optional: default is path specified by `$X509_USER_CERT` environment variable, then `~/.globus/usercert.pem`).
-   path to user's private key (optional: default is path specified by `$X509_USER_KEY` environment variable, then `~/.globus/userkey.pem`).
-   Passphrase for user's private key (via non-echoing prompt).
-   User needs to provide VO name if the requested hostname has multiple VO's assigned.

**Outputs:**

-   Private key, to filename specified by `-o` or `./hostkey.pem` by default.
-   Request Id, to `stdout`.

```console
[root@client ~] # osg-cert-request --help
Usage: osg-cert-request [options]

Options:
  -h, --help            show this help message and exit
  -c CSR, --csr=CSR     Specify CSR name (default = gennew.csr)
  -o OUTPUT KEYFILE, --outkeyfile=OUTPUT KEYFILE
                        Specify the output filename for the retrieved user certificate.
                        Default is ./hostkey.pem
  -v VO name, --vo=VO name
                        Specify the VO for the host request
  -y CC LIST, --cc=CC LIST
                        Specify the CC list(the email id's to be CCed).
                        Separate values by ','
  -m COMMENT, --comment=COMMENT
                        The comment to be added to the request
  -H CN, --hostname=CN  Specify a hostname for CSR (FQDN)
  -a HOSTNAME, --altname=HOSTNAME
                        Specify an alternative hostname for the CSR (FQDN). May be used more than once
  -e EMAIL, --email=EMAIL
                        Email address to receive certificate
  -n NAME, --name=NAME  Name of user receiving certificate
  -p PHONE, --phone=PHONE
                        Phone number of user receiving certificate
  -t TIMEOUT, --timeout=TIMEOUT
                        Specify the timeout in minutes
  -T, --test            Run in test mode
  -q, --quiet           don't print status messages to stdout
  -d WRITE_DIRECTORY, --directory=WRITE_DIRECTORY
                        Write the output files to this directory
  -V, --version         Print version information and exit
```

#### Examples.

OSG generates the key pair for the request.

```console
[root@client ~] # osg-cert-request -t hostname.domain.com -e emailaddress@domain.com -n "Your Name" -p 9999999999 -y "xyz@domain.com,abc@domain.com" -m "This is my comment"
```

If you want to request a service certificate, you need to escape backslash for service name inside CN like following.

```console
[root@client ~] # osg-cert-request -t hostname.domain.com -e emailaddress@domain.com -n "Your Name" -p 9999999999 -y "rsv\/xyz@domain.com" -m "This is my comment"
```

You can create your CSR on your target hosts using tools such as `openssl`.

```console
[root@client ~] # umask 077; openssl req -new -newkey rsa:2048 -nodes -keyout hostkey.pem -subj "/CN=osg-ce.example.edu" -out csr.pem
```

Note that the DN will be overriden by the OSG PKI except for the CN component.

Submitting the request:

```console
[root@client ~] # osg-cert-request -t hostname.domain.com -e emailaddress@domain.com -n "Your Name" -p 9999999999 -y "xyz@domain.com,abc@domain.com" -m "This is my comment" --csr csr.pem
```

### osg-cert-retrieve

Retrieve a certificate (host or user) from OIM given a request Id. Typically you will run this script after submitting a request with `osg-cert-request` and receiving an email telling you your certificate has been approved.

You can also use this script to retrieve other certificates that have been previously issued (assuming you know their request ID number).

Since certificates are public, no authentication of the user is required.

This script:

-   Accepts a request Id from the user
-   Connects to OIM and requests the certificate identified by the request ID
-   Writes the certificate to disk (as specified by the user)

**Inputs:**

-   Request ID
-   Filename to store certificate (optional: default is `./hostcert.pem`).

**Outputs:**

-   Host certificate as PEM, to filename specified or `./hostcert.pem`.

```console
[root@client ~] # osg-cert-retrieve --help
Usage: osg-cert-retrieve [options] <Request ID>
Usage: osg-cert-retrieve -h/--help [for detailed explanations of options]

Options:
  -h, --help            show this help message and exit
  -o ID, --certfile=ID  Specify the output filename for the retrieved user
                        certificate . Default is ./hostcert.pem
  -T, --test            Run in test mode
  -t TIMEOUT, --timeout=TIMEOUT
                        Specify the timeout in minutes
  -q, --quiet           don't print status messages to stdout
  -d WRITE_DIRECTORY, --directory=WRITE_DIRECTORY
                        Write the output files to this directory
  -V, --version         Print version information and exit
  -i, --id              Specify ID# of certificate to be retrieved
                        [deprecated]
```

Example:

```console
[root@client ~] # osg-cert-retrieve -i 555
```

### osg-gridadmin-cert-request

Request and retrieve multliple host certificates from OIM. Authenticates to OIM and is only for use by Grid Admins for certificates they are authorized to approve. This script is only supported with all hosts being in the same domain (so we ensure they go to the same Grid Admin). The certificates are stored with the format of `hostname-requestid.pem` (i.e. the id generated from the request for the certificate). The key is stored as `hostname-serial-key.pem`.

This script does the following in the process of acquiring certificates for the hostnames specified:

-   Reads a list of fully-qualified hostnames from a file specified by the user.
-   For each hostname:
    -   Generates a new private key and `CSR`.
    -   Only important part of CSR is `CN=<HOSTNAME>` component.
    -   Writes the private key to a file with filename: `<PREFIX>/<HOSTNAME>-key.pem`.
    -   Prompts the user for their private key pass phrase (the pass phrase is cached so user is not re-prompted).
    -   Authenticates to OIM and posts the CSRs as a single request to OIM.
    -   Request ID is returned and subsequently used.
    -   Authenticates to OIM and approves the request.
    -   Waits one minute for request to be processed by OIM.
    -   Connects to OIM and attempts to retrieve certificates.
    -   Writes out any certificates it retrieves with filename of `<PREFIX>/<HOSTNAME>-<ID>.pem`.
    -   If all certificates have been retrieved, exits loop.
    -   Wait 5 seconds and proceeds with the next repeat.

**Inputs:**

-   filename of list of hostnames.
-   prefix path in which to write private keys and certificates (default: `.`.)
-   path to user's certificate (optional: default is path specified by `$X509_USER_CERT` environment variable, then `~/.globus/usercert.pem`).
-   path to user's private key (optional, default is path specified by `$X509_USER_KEY` environment variable, then `~/.globus/userkey.pem`).
-   Passphrase for user's private key via non-echoing prompt.

**Outputs:**

-   `N` host certificates in PEM format.
-   `N` private keys in PEM format.

```console
[root@client ~] # osg-gridadmin-cert-request --help
Usage: osg-gridadmin-cert-request [options] arg
Usage: osg-gridadmin-cert-request -h/--help [for detailed explanations of options]

Options:
  -h, --help            show this help message and exit
  -k PKEY, --pkey=PKEY  Specify Requestor's private key (PEM Format). If not
                        specifiedwill take the value of X509_USER_KEY or
                        $HOME/.globus/userkey.pem
  -c CERT, --cert=CERT  Specify Requestor's certificate (PEM Format). If not
                        specified, will take the value of X509_USER_CERT or
                        $HOME/.globus/usercert.pem
  -a HOSTNAME, --altname=HOSTNAME
                        Specify an alternative hostname for CSR (FQDN). May be
                        used more than once and if specified, -f/--hostfile
                        will be ignored
  -v VO name, --vo=VO name
                        Specify the VO for the host request
  -y CC List, --cc=CC List
                        Specify the CC list(the email id's to be
                        CCed).Separate values by ','
  -T, --test            Run in test mode
  -t TIMEOUT, --timeout=TIMEOUT
                        Specify the timeout in minutes
  -q, --quiet           don't print status messages to stdout
  -d WRITE_DIRECTORY, --directory=WRITE_DIRECTORY
                        Write the output files to this directory
  -V, --version         Print version information and exit

  Hostname Options:
    Use either of these options. Specify hostname as a single hostname
    using -H/--hostname or specify from a file using -f/--hostfile.

    -H HOSTNAME, --hostname=HOSTNAME
                        Specify the hostname or service/hostname for which you
                        want to request the certificate for. If specified,
                        -f/--hostfile will be ignored
    -f HOSTFILE, --hostfile=HOSTFILE
                        Filename with one host (hostname or service/hostname
                        and its optional,alternative hostnames, separated by
                        spaces) per line
```

Examples:

```console
[root@client ~] # osg-gridadmin-cert-request -f filename -k privatekeyfile -c certificatefile
```

```console
[root@client ~] # osg-gridadmin-cert-request -H hostname.domain.com -k privatekeyfile -c certificatefile
```

### osg-user-cert-renew

Sends a request for renewing a user certificate and if the certificate can be renewed, fetches and writes the renewed certificate.

The script generates request for renewing user certificate to the OIM, and if the certificate is renewed, it fetches the renewed user certificate. The user is authenticated before making such a request. If the user certificate is renewed, the user gets email notification regarding the same and the renewed certificate is saved by the name of the existing certificate suffixed by `-renewed.pem` (e.g. when we renew `my-cert.pem`, the renewed certificate is named `my-cert-renewed.pem`).

**Inputs:**

-   path to user's certificate (optional: default is path specified by `$X509_USER_CERT` environment variable, then `~/.globus/usercert.pem`).
-   path to user's private key (optional: default is path specified by `$X509_USER_KEY` environment variable, then `~/.globus/userkey.pem`).
-   Passphrase for user's private key via non-echoing prompt.
-   User needs to provide VO name if the requested hostname has multiple VO's assigned

**Outputs:**

-   On Renewal, the renewed certificate is stored with the filename of the older user certificate suffixed with `-renewed.pem`.  The certificate name for renewed certificate is sent to `stdout`.

!!! note
    If the retrieval of user certificate fails for some reason, the user can download the renewed certificate from OIM web interface using the following URL (where `<REQID>` is the request ID number for the user certificate on OIM):

        https://oim.opensciencegrid.org/oim/certificateuser?id=<REQID>

```console
[root@client ~] # osg-user-cert-renew --help
Usage: osg-user-cert-renew [options]

Options:
  -h, --help            show this help message and exit
  -k PKEY, --pkey=PKEY  Specify Requestor's private key (PEM Format). If not
                        specified  will take the value of X509_USER_KEY or
                        $HOME/.globus/userkey.pem
  -c CERT, --cert=CERT  Specify Requestor's certificate (PEM Format).  If not
                        specified will take the value of X509_USER_CERT or
                        $HOME/.globus/usercert.pem
  -T, --test            Run in test mode
  -t TIMEOUT, --timeout=TIMEOUT
                        Specify the timeout in minutes
  -d WRITE_DIRECTORY, --directory=WRITE_DIRECTORY
                        Write the output files to this directory
  -q, --quiet           don't print status messages to stdout
  -V, --version         Print version information and exit
```

**Example**

```console
[root@client ~] # osg-user-cert-renew -k userkey.pem -c usercert.pem
```

### osg-user-cert-revoke

Revoke a user certificate from OIM given a request ID or certificate ID. Usually the script is run when a user wants to revoke user certificate.

For revoking user certificate, user authentication is done and if the user is authorized to revoke the user certificate, the certificate is immediately revoked and an email notification is sent informing the user that the user certificate is revoked.

**The script:**

-   Accepts a Request ID or Certificate ID from the user.
-   Authenticates user and connects to OIM to revoke the user certificate identified by the request ID or the certificate ID.

**Inputs:**

-   Private key for the user requesting host certificate revocation.
-   User certificate for the user requesting host certificate revocation.
-   Message for requesting the user certificate revocation.
-   Request ID OR the certificate ID for the user certificate to be revoked.

**Outputs:**

-   Message if the revocation was successful along with the host cert request ID/certificate ID on `stdout`.
-   Error message if the revocation was unsuccessful on `stdout`.

If the user's private key and certificate are not provided, the script takes the private key and user certificate from the `~/.globus` folder using the default names (`userkey.pem` and `usercert.pem`, respectively)

```console
[root@client ~] # osg-user-cert-revoke --help
Usage: osg-user-cert-revoke [options] <Request ID> <message>
Usage: osg-user-cert-revoke -h/--help [for detailed explanations of options]

Options:
  -h, --help            show this help message and exit
  -n, --certid          Treat the ID argument as the serial ID# for the
                        certificate to be revoked
  -u, --user            Certificate to be revoked is a user certificate.
                        Redundant when using `osg-user-cert-revoke`.
  -k PKEY, --pkey=PKEY  Specify Requestor's private key (PEM Format). If not
                        specified, this takes the value of X509_USER_KEY or
                        $HOME/.globus/userkey.pem
  -c CERT, --cert=CERT  Specify Requestor's certificate (PEM Format). If not
                        specified, this takes the value of X509_USER_CERT or
                        $HOME/.globus/usercert.pem
  -T, --test            Run in test mode
  -t TIMEOUT, --timeout=TIMEOUT
                        Specify the timeout in minutes
  -q, --quiet           don't print status messages to stdout
  -V, --version         Print version information and exit
  -m REASON, --message=REASON
                        Specify the reason for certificate revocation
                        [deprecated]
  -i, --id              Specify ID# of certificate to be retrieved
                        [deprecated]
```

**Example:**

```console
[root@client ~] # osg-user-cert-revoke -i 999 -m "Testing user cert revocation" -k privatekeyfile -c usercertfile
```

### osg-cert-revoke

Revoke a host certificate from OIM given a request ID. Usually the script is run when a user wants to revoke host/service certificate.

For revoking host certificate, user authentication is done and if the user is authorized to revoke the host certificate, the certificate is immediately revoked and an email notification is sent informing the user that the host certificate is revoked.

**The script:**

-   Accepts a request ID from the user.
-   Authenticates user and connects to OIM to revoke the host certificate identified by the request ID.

**Inputs:**

-   Private key for the user requesting host certificate revocation.
-   certificate for the user requesting host certificate revocation.
-   Message for requesting the host certificate revocation.
-   Request ID for the host certificate to be revoked.

**Outputs:**

-   Message if the revocation was successful along with the host cert request ID on `stdout`.
-   Error message if the revocation was unsuccessful on `stdout`.

If the user's private key and certificate are not provided, the script takes the private key and user certificate from the `~/.globus` folder using the default names (`userkey.pem` and `usercert.pem`, respectively).

```console
[root@client ~] # osg-user-cert-revoke --help
Usage: osg-cert-revoke [options] <Request ID> <message>
Usage: osg-cert-revoke -h/--help [for detailed explanations of options]

Options:
  -h, --help            show this help message and exit
  -n, --certid          Treat the ID argument as the serial ID# for the
                        certificate to be revoked
  -u, --user            Certificate to be revoked is a user certificate.
                        Redundant when using `osg-user-cert-revoke`.
  -k PKEY, --pkey=PKEY  Specify Requestor's private key (PEM Format). If not
                        specified, this takes the value of X509_USER_KEY or
                        $HOME/.globus/userkey.pem
  -c CERT, --cert=CERT  Specify Requestor's certificate (PEM Format). If not
                        specified, this takes the value of X509_USER_CERT or
                        $HOME/.globus/usercert.pem
  -T, --test            Run in test mode
  -t TIMEOUT, --timeout=TIMEOUT
                        Specify the timeout in minutes
  -q, --quiet           don't print status messages to stdout
  -V, --version         Print version information and exit
  -m REASON, --message=REASON
                        Specify the reason for certificate revocation
                        [deprecated]
  -i, --id              Specify ID# of certificate to be retrieved
                        [deprecated]
```

**Example:**

```console
[root@client ~] # osg-cert-revoke -i 999 -m "Testing host cert revocation" -k privatekeyfile -c usercertfile
```

Test Mode
---------

The scripts have two modes of execution.

In the normal mode of execution, the script connects to the production server and generated certificates are from default OSG CA.

If the user provides a `-T` parameter on the command-line, the scripts connect to the OIM-ITB server and any generated certificates are issued by the OSG test CAs. This mode is intended for testing and training. The resulting certificates are not usable in a production environment.

Current Limitations and Bugs
----------------------------

- Note that Common Names (CNs) are limited to 64 characters. This is a limitation of OpenSSL and the PKI standard. For details see [OSGPKI-252](https://jira.opensciencegrid.org/browse/OSGPKI-252).

