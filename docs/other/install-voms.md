Install VOMS
=================

This document is for VO System Administrators.

Here we describe how to install and configure VOMS on your Linux machine. When you install VOMS as described here, you get all three parts: MySQL database, VOMS admin and VOMS server. Instructions for creating your VO are also on this page, in the configuration section.

We also describe how to remove a VO from VOMS if the need arises.

The installation section will give you a bare-bones installation. In order to use VOMS you need to go through the configuration: run `configure_voms` to create your VO, probably enable read-only access to your VO and probably set a VO-admin to add/remove users. The other sections help in troubleshooting and knowing what is running.

This is not a complete reference. If you need to administer a VO, please check the [VOMS User guide](https://twiki.cern.ch/twiki/bin/view/EMI/EMIVomsAdminUserGuide261) linked also in the [reference](#reference) section.

Introduction
=================

The [Virtual Organization Membership Service](https://twiki.cern.ch/twiki/bin/view/EMI/EMIVomsDocumentation) allows to manage the members of a VO and their privileges (groups and roles). It has three main parts:

-   MySQL database which is a persistent repository for VO membership information,
-   VOMS admin which provides the Web UI/services to maintain the VO membership. This requires Apache/Tomcat.
-   VOMS server, a daemon process which services the *voms-proxy-init* requests.

Requirements
=================

Host and OS 
-----------------------------------------------------

-   A host to install the VOMS Service (Pristine node)
-   OS is Red Hat Enterprise Linux 6, 7, and variants (see [details...](../release/supported_platforms.md)). Currently most of our testing has been done on Scientific Linux 5.
-   Time must be synchronized (e.g. `ntpd`). 
-   Root access

Users 
-----------------------------------------------

The VOMS and voms-admin installation will create two users unless they are already created.

| User | Default uid | Comment |
|----------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| `voms`                                                                                                         | none                                                                                                                  | Runs the VOMS daemons, one per VO.                                                                                |
| `tomcat`                                                                                                       | 91                                                                                                                    | Runs tomcat6 and owns voms-admin configuration and certificates.                                                  |

Note that if uid 91 is already taken but not used for the tomcat user, you will experience errors. [Details...](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/KnownProblems#Reserved_user_ids_especially_for)

Certificates 
------------------------------------------------------

You will need two service certificates. [Here](../security/host-certs) are instructions to request a host certificate. 

| Certificate | User that owns certificate | Path to certificate |
|-----------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| VOMS service certificate                                                                                              | `voms`                                                                                                                               | `/etc/grid-security/voms/vomscert.pem`                                                                                        
                                                                                                                                                                                                                                                                `/etc/grid-security/voms/vomskey.pem`                                                                                          |
| Tomcat service certificate                                                                                            | `tomcat`                                                                                                                             | `/etc/grid-security/http/httpcert.pem`                                                                                        
                                                                                                                                                                                                                                                                `/etc/grid-security/http/httpkey.pem`                                                                                          |

Networking 
----------------------------------------------------

| Service Name | Protocol | Port Number | Inbound | Outbound | Comment |
|------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| VOMS                                  | tcp                                                                                                                | 15001+                                                                                                                | Y           |                                                                                                                    | range of ports, increment by 1 for each VO supported                                                                        |
| VOMS Admin                       | tcp                                                                                                                | 8443                                                                                                                  | Y           |                                                                                                                    | VOMS Admin (which runs within Tomcat) web interface, it must be available to VO administrators and users registering online |

!!! note
    \* 15001 is the port specified in the [configuration command](#configure). You can choose a different one or have multiple ones if you support multiple VOs.

Additional Requirements 
-----------------------------------------------------------------

-   Testing requirements:
    -   The Subject and Issuer of a voms admin certificate (it could be your certificate)
    -   Access to your own certificate if you want to create your voms proxy
    -   Your certificate uploaded into a browser if you want to test voms-admin WEB UI

!!! note
    The configuration and testing require some familiarity with openssl commands, e.g. to extract the subject (DN) and the issuer of a certificate. If you are not familiar please check the guides in the [reference section](#reference):

Installation Procedure
===========================

Install VOMS 
------------------------------------------------------

1.  Install Java using [these instructions](../common/openjdk7#installing-java)
2.  Install OSG-VOMS:

    ``` console
    [root@voms ~]$ yum install osg-voms
    ```

Configure
==============

The configuration requires some initial steps plus the addition of one or more VO. You will not be able to start voms-admin if you don't add at least one VO.

Configure MySQL Database 
------------------------------------------------------------------

Before you will be able configure VOMS you will need to have access to MySQL database. The MySQL software is installed with the `osg-voms` package. By default it will be using port 3306 and will not have password for `root`.

It is not necessary to change the port number if you don't want to. If you want to modify the port you will need to edit `/etc/my.cnf` file and add a new port:

``` file
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
port=MYSQL_PORT_NUMBER
```

It is wise to set a password for the `root` user. Run the following command to set the password:

``` console
[root@voms ~]$ /etc/init.d/mysqld start
[root@voms ~]$ mysqladmin -u root password top_secret
```

Setup the Service Certificates 
------------------------------------------------------------------------

Make sure that you have the host, VOMS and Tomcat service certificates/keys in the right directories and with the correct owners and permissions (`600` for key and `644` the certificate). [Host certificate](../security/host-certs.md) is required and must be in `/etc/grid-security/hostcert.pem` and `hostkey.pem`. It is recommended to provide also service certificates for VOMS and Tomcat. If you don't, here are the instructions to copy the host certificate/key and set the correct owner (permissions are preserved). Note that if you did not previously have a voms or tomcat user on your system, they were added during the RPM install:

1.  VOMS-core daemon is running as user `voms` and requires its service certificate and key in `/etc/grid-security/voms`. To copy the host certificate/key for this service, you need to do the following:

    ``` console
    [root@voms ~]$ cd /etc/grid-security
    [root@voms ~]$ cp hostcert.pem voms/vomscert.pem
    [root@voms ~]$ cp hostkey.pem voms/vomskey.pem
    [root@voms ~]$ chown -R voms:voms voms
    ```

2.  Tomcat service is running as user `tomcat` and requires its service certificate and key in `/etc/grid-security/http`. To copy the host certificate/key for this service, you need to do the following:

    ``` console
    [root@voms ~]$ cd /etc/grid-security
    [root@voms ~]$ mkdir /etc/grid-security/http
    [root@voms ~]$ cp hostcert.pem http/httpcert.pem
    [root@voms ~]$ cp hostkey.pem http/httpkey.pem
    [root@voms ~]$ chown -R tomcat:tomcat http
    ```

Configure Tomcat options 
------------------------------------------------------------------

Edit `/etc/tomcat6/tomcat6.conf` to add the following line to the bottom of the file. This is important for good performance and essential if you run more than one VO.

``` file
CATALINA_OPTS="${CATALINA_OPTS} -XX:MaxPermSize=256m"
```

If you run a large number of VOs, you might need to increase the amount of memory used by Tomcat. You can do this by adding one more line to the bottom of `/etc/tomcat6/tomcat6.conf`:

``` file
JAVA_OPTS="${JAVA_OPTS} -Xmx2048m"
```

You must add the following line to `/etc/tomcat6/tomcat6.conf` to use VOMS-Admin successfully:

``` file
JAVA_ENDORSED_DIRS="${JAVA_ENDORSED_DIRS}:/usr/share/voms-admin/endorsed"
```

Disable SSLv3 in Tomcat 
-----------------------------------------------------------------

The OSG Security team has concluded that the POODLE SSLv3 vulnerability is not a **critical** concern to OSG software installations. Most services are not affected, and those that are affected are difficult to exploit in a meaningful way. Nonetheless, the recommendation is to disable support for SSLv3 where reasonable.

OSG software includes VOMS Admin Server (currently, version 2.7.0), which runs within Tomcat. By default Tomcat allows SSLv3 connections, but that is easy to change. To disable SSLv3 support from a Tomcat instance that contains VOMS Admin Server, set `protocols="TLSv1.1,TLSv1.2"` in `/etc/tomcat[56]/server.xml`, as shown below.

Note: OSG Software has tested this change only for Tomcat and VOMS Admin Server. But this is a server-level Tomcat configuration change and thus affects all Tomcat web applications running on the same server. For now, we recommend making this change to Tomcat servers that run only VOMS Admin Server. There are known issues with applying this change to a Tomcat instance that runs GUMS, in that dCache clients (at least) fail to work with the changed GUMS server.

    --- server.xml.old      2014-10-28 11:27:11.000000000 -0500
    +++ server.xml  2014-10-28 11:29:34.000000000 -0500
    @@ -20,19 +20,20 @@
         <Connector port="8443" SSLEnabled="true"
                   maxThreads="150" minSpareThreads="25" maxSpareThreads="75"
                   enableLookups="false" disableUploadTimeout="true"
                   acceptCount="100" debug="0" scheme="https" secure="true"
                   sSLImplementation="org.glite.security.trustmanager.tomcat.TMSSLImplementation"
                   trustStoreDir="/etc/grid-security/certificates"
                   sslCertFile="/etc/grid-security/http/httpcert.pem"
                   sslKey="/etc/grid-security/http/httpkey.pem"
                   crlUpdateInterval="2h"
                   log4jConfFile="/usr/share/tomcat6/conf/log4j-trustmanager.properties"
                   clientAuth="true" sslProtocol="TLS" sslEnabledProtocols="TLSv1"
    +              protocols="TLSv1.1,TLSv1.2"
                   crlEnabled="true" crlRequired="true"/>

        <Engine name="Catalina" defaultHost="localhost">

          <Host name="localhost" appBase="webapps" />
        </Engine>
      </Service>
    </Server>

Allow Tomcat to have more open files and processes 
--------------------------------------------------------------------------------------------

If you run several VOs, you may need to extend the limits for Tomcat so that it can open more file and create more processes. To do this, add the following lines to `/etc/security/limits.conf`:

``` file
tomcat          soft    nofile  63536
tomcat          hard    nofile  63536

tomcat          soft    nproc   16384
tomcat          hard    nproc   16384
```

Note that this is not needed if you are running just a single VO, this is only needed if you run many VOs.

Configure Trust Manager 
-----------------------------------------------------------------

Configure Tomcat's trust manager. This must be done once, before starting up Tomcat for the first time:

1.  You have to configure Tomcat in order to enable EMI trustmanager:

    ``` console
    [root@voms ~]$ /var/lib/trustmanager-tomcat/configure.sh
    Info: using default install root: /
    Info: using default configuration file: //var/lib/trustmanager-tomcat/config.properties
    Info: using default configuration directory: //var/lib/trustmanager-tomcat
    Info: you can clean up using the following commands
          mv -f /etc/tomcat5/server.xml.old-trustmanager /etc/tomcat5/server.xml
          rm -f /usr/share/tomcat5/server/lib/bcprov*.jar
          rm -f /usr/share/tomcat5/server/lib/log4j*.jar
          rm -f /usr/share/tomcat5/server/lib/trustmanager-*.jar
          rm -f /etc/tomcat5/log4j-trustmanager.properties
          rm -f //var/lib/trustmanager-tomcat/server.xml
    ```

(the output may look different on EL6)

Configure Email Services for the VOMS Server 
--------------------------------------------------------------------------------------

The VOMS server may need to send administrative emails. To enable this feature **on EL 6 systems**, you must complete a one-time initialization of Java email services within Tomcat:

1.  Run the `build-jar-repository` command:

    ``` console
    [root@voms ~]$ /usr/bin/build-jar-repository /usr/share/tomcat6/lib javamail
    ```

2.  Set the hostname for reminder e-mails in `/etc/voms-admin/VO_NAME/voms.service.properties`:

    ``` file
    voms.hostname = <hostname>
    ```

    Replacing <hostname> with the public hostname of your VOMS server.

EL 5 systems are already configured to use Java email services.

Add and configure a VO 
----------------------------------------------------------------

You must add at least one VO before you can start VOMS Admin. You must start the services as instructed during the configuration steps. You can stop them at the end if you don't want them running yet.

1.  Run `voms-admin-configure` script to create a new VO. Note that if you have multiple VOs, each VO must have a unique VOMS\_PORT

    ``` console
    [root@voms ~]$ voms-admin-configure install \
        --dbtype mysql \
        --vo VO_NAME \
        --createdb \
        --deploy-database  \
        --dbauser root  \
        --dbapwd MYSQL_ROOT_PASSD \
        --dbusername  admin-VO_NAME \
        --dbpassword secret  \
        --dbport  DB_PORT \
        --port VOMS_PORT  \
        --mail-from email \
        --smtp-host smtp.domain \
        --sqlloc /usr/lib64/voms/libvomsmysql.so \
        --cert /etc/grid-security/voms/vomscert.pem \
        --key  /etc/grid-security/voms/vomskey.pem \
        --read-access-for-authenticated-clients 
    ```

    For example for the test1 VO:

    ``` console
    [root@voms ~]$ voms-admin-configure install --dbtype mysql --vo test1 --createdb \
         --deploy-database --dbauser root --dbapwd  top_secret \
         --dbusername admin_test1 --dbpassword secret --dbport 3306 \
         --port 15001 --mail-from tlevshin@fnal.gov --smtp-host smtp.fnal.gov \
         --sqlloc /usr/lib64/voms/libvomsmysql.so --cert /etc/grid-security/voms/vomscert.pem \
         --key  /etc/grid-security/voms/vomskey.pem --read-access-for-authenticated-clients 
    ```

    If the command fails with a `IOError: [Errno 32] Broken pipe` error, check that you entered the correct database password.
    If the above command is executed correctly a lot of sql stuff will scroll across the screen, followed by

    ``` console
    Deploying voms database...
    Database deployed correctly!



    VO test1 installation finished.
     
    You can start the voms services using the following commands:
        /etc/init.d/voms start test1
        /etc/init.d/voms-admin start test1
    ```

2.  Start VOMS and VOMS Admin for the VO you just added:

    ``` console
    [root@voms ~]$ /sbin/service voms start VO_NAME
    [root@voms ~]$ /sbin/service voms-admin start VO_NAME
    ```

    For example:

    ``` console
    [root@voms ~]$ /sbin/service voms start test1
    [root@voms ~]$ /sbin/service voms-admin start test1
    ```

    Note that the voms-admin init script really isn't an init script. Instead it deploys a Tomcat webapp into Tomcat. In normal usage, you never need to run this command again, and you should *not* run `/sbin/service voms-admin stop VO_NAME`.

3.  Add a local admin:

    ``` console
    [root@voms ~]$ /usr/sbin/voms-db-deploy.py add-admin --vo VO_NAME  \
            --dn  HOST_CERT_SUBJECT \
            --ca HOST_CERT_ISSUER 
    ```

    For example:

    ``` console
    [root@voms ~]$ /usr/sbin/voms-db-deploy.py add-admin --vo test1 \
         --dn /DC=org/DC=doegrids/OU=Services/CN=fermicloud002.fnal.gov \
         --ca "/DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1"
    ```

4.  In order to complete the next step you need to start also Tomcat if it is not already running. And since Tomcat requires valid CRLs you need to fetch the CRLs if it is a fresh installation they are not there:

    ``` console
    [root@voms ~]$ /usr/sbin/fetch-crl  # If there are no CRLs in /etc/grid-security/certificates
    [root@voms ~]$ /sbin/service tomcat6 start
    ```

5.  Configure VOMS Admin to allow GUMS and edg-mkgridmap to query your VO for the set of users. Note that you must have a valid certificate; voms-admin needs a certificate authorized to perform the operation (ACL editing) on the VO:

    ``` console
    [root@voms ~]$ voms-admin --nousercert --vo VO_NAME add-ACL-entry /VO_NAME ANYONE VOMS_CA "CONTAINER_READ,MEMBERSHIP_READ" true
    ```

    For example:

    ``` console
    [root@voms ~]$ voms-admin --nousercert --vo test1 add-ACL-entry /test1 ANYONE VOMS_CA "CONTAINER_READ,MEMBERSHIP_READ" true
    ```

6.  Allow compatibility with `GUMS` and `edg-mkgridmap`. Edit `/etc/voms-admin/VO_NAME/voms.service.properties` by adding the following line to the file:

    ``` console
    voms.csrf.log_only = true
    ```

If you don't want to leave your services running you can stop them after you are done with adding the VO:

``` console
[root@voms ~]$ /sbin/service voms stop
[root@voms ~]$ /sbin/service tomcat6 stop
```

Services
=============

VOMS has its persistent repository in a MySQL database, that requires `mysql` to be running in order to be queried. All grid interactions require updated CA certificates and CRLs. Then the *voms server* is a daemon servicing authentication requests and *voms-admin*, requiring Tomcat, is a Web UI/service to manage the VO membership.

Starting and Enabling Services 
------------------------------------------------------------------------

To start VOMS you need to start several services:

1.  2.  MySQL server needs to be running if it is not already:

    ``` console
    [root@voms ~]$ /sbin/service mysqld start
    ```

3.  Start voms server

    ``` console
    [root@voms ~]$ service voms start
    ```

4.  Start Tomcat, required by voms-admin:

    ``` console
    [root@voms ~]$ service tomcat6 start
    ```

You should also enable the appropriate services so that they are automatically started when your system is powered on:

-   -   To enable the other services:

    ``` console
    [root@voms ~]$ /sbin/chkconfig mysqld on
    [root@voms ~]$ /sbin/chkconfig voms on
    [root@voms ~]$ /sbin/chkconfig tomcat6 on
    ```

**Note**: You do *not* need to run chkconfig on the voms-admin service. This service is only need to do the initial "deployment" of the VOMS Admin service into Tomcat and is not needed thereafter unless you add another VO.

Stopping and Disabling Services 
-------------------------------------------------------------------------

To stop VOMS you need to stop voms and voms-admin, and also the services they use if nothing else is using them:

1.  Stop voms server

    ``` console
    [root@voms ~]$ service voms stop
    ```

2.  , Stop Tomcat, if no other application is using it:

    ``` console
    [root@voms ~]$ service tomcat6 stop
    ```

3.  Stop MySQL server if no other application is using it:

    ``` console
    [root@voms ~]$ service mysqld stop
    ```

4.  In addition, you can disable services by running the following commands. However, you don't need to do this normally.

-   -   To disable the other services:

    ``` console
    [root@voms ~]$ /sbin/chkconfig mysqld off
    [root@voms ~]$ /sbin/chkconfig voms off
    [root@voms ~]$ /sbin/chkconfig tomcat6 off
    ```

!!! note
    You do not need to run chkconfig on the voms-admin service. See above for more details.

Advertise your VOMS server
===============================

A working VOMS server can be contacted to sign certificates extensions (e.g., by `voms-proxy-init`) or to verify VO memberships only if it is on the list of valid VOMS servers (`/etc/vomses`) and if there is an LSC file for that VO. Some grid services (glite-FTS and glite-WMS) even require a copy of the VOMS server certificate.

The file `/etc/vomses` contains a list of VOs and their VOMS servers. A VOMS server may appear on multiple lines if it is serving multiple VOs on different ports. All lines contain:

``` file
"alias" "HOST_NAME" "PORT" "HOST_DN" "VO_NAME"
```

For example:

``` file
"test1" "fermicloud002.fnal.gov" "15001" "/DC=org/DC=doegrids/OU=Services/CN=fermicloud002.fnal.gov" "test1"
```

The [LSC file](https://twiki.cern.ch/twiki/bin/view/LCG/VOMSLSCfileConfiguration) (LiSt of Certificates) is another description of your VOMS server:

-   It is located in `$X509_VOMS_DIR/${VO}`, by default `/etc/grid-security/vomsdir/${VO}`
-   The filename is the fully qualified hostname (FQDN) of your server, followed by `.lsc`
-   The first line contains the subject DN of the VOMS server host certificate, without quotes
-   The second line contains the subject DN of the CA that issued the VOMS server host certificate, also without quotes

For example, for the VO named `test1` hosted on `fermicloud002`, the LSC file named `/etc/grid-security/vomsdir/test1/fermicloud002.fnal.gov.lsc` might contain:

``` file
/DC=org/DC=doegrids/OU=Services/CN=fermicloud002.fnal.gov
/DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1
```

The VOMS server manager must distribute the line for `/etc/vomses` and the LSC file to all hosts that will contact the VOMS server. OSG distributes with all its client and server installations a default list of VOMS servers (`/etc/vomses`) and a default set of LSC files. These are part of the `vo-client` RPM.

To be included, use the VO Registration function at [OIM VO Registration](https://oim.opensciencegrid.org/oim/vo). Even if you are already registered as a VO you need to notify the Grid Operations Center if the information in the vomses file or the LSC file has changed.

Test
=========

!!! note
    Before performing any of the tests you must start all the services as [described above](#starting-and-enabling-services)

To test VOMS you can add a member (her/his certificate) to a VO using voms-admin, login in the Web UI and then:

-   use the voms server to generate a proxy for that certificate.
-   or generate a grid-mapfile
-   or query with GUMS

Voms-admin test 
---------------------------------------------------------

Add a member(yourself) to the VO:

``` console
[root@voms ~]$ voms-admin --vo VO_NAME --host HOST_NAME \
       --nousercert create-user USER_CERT_SUBJECT USER_CERT_ISSUER \
       USER_COMMON_NAME email 
```

For example:

``` console
[root@voms ~]$ voms-admin --vo test1 --host fermicloud002 --nousercert create-user \
   "/DC=org/DC=doegrids/OU=People/CN=Joe Doe 12345" "/DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1" 
   "Joe Doe 12345" 'jdoe@fnal.gov'
```

Assign VOAdmin role to yourself, so you can manage the VO using the Web UI:

``` console
voms-admin --vo VO_NAME --host HOST_NAME \
    --nousercert assign-role  /VO_NAME  VO-Admin  \
      USER_CERT_SUBJECT USRT_CERT_ISSUER 
```

For example:

``` console
[root@voms ~]$ voms-admin --vo test1 --host fermicloud002 --nousercert assign-role /test1   VO-Admin  \
   "/DC=org/DC=doegrids/OU=People/CN=Joe Doe 12345" "/DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1" 
```

Check the Web UI by accessing `https://hostname:8443/voms/voname`. If you have your certificate loaded into the browser you will be able to manage the VO.

Voms-core test: 
---------------------------------------------------------

To perform this test you need the `voms-client` RPM.

To use your VOMS you need to add a line with its description (similar to the following) to `/etc/vomses`, a file containing a list of all valid voms servers:

``` file
"alias" "HOST_NAME" "PORT" "HOST DN" "VO_NAME"
```

Look at `/etc/voms-admin/VO_NAME/vomses` to find the correct line for your VO. For example:

``` file
"test1" "fermicloud002.fnal.gov" "15001" "/DC=org/DC=doegrids/OU=Services/CN=fermicloud002.fnal.gov" "test1"
```

If it is not there already, add your certificate to the VO using `voms-admin` `create-user` as in the previous section. Being the local admin set with `voms-db-deploy.py add-admin` does not add the certificate to the VO.

Use `voms-proxy-init` to generate proxy. Login as user, create `vomses` file (e.g. `~/.vomses`). Generate voms proxy

``` console
[user@voms ~]$ voms-proxy-init -voms VO_NAME -vomses ~/vomses
```

Testing edg-mkgridmap 
---------------------------------------------------------------

The `edg-mkgridmap` command is run on a site's Compute Element node to generate a `grid-mapfile` file. This script is not provided as a part of the VOMS installation, so you will have to go on a CE node to test this. You do not have to be the `root` user on the CE node, but you will need to have a personal certificate available.

The `mkgridmap` file syntax/values for each VO you create, can be viewed on the WEB UI for your VO by selecting `Configuration information` on the left hand menu of the main page. You will get a line like:

``` file
 group vomss://HOST_NAME:8443/voms/VO_NAME  group_name
```

e.g. for the OSG VO :

``` file
 group vomss://cms-xen3.fnal.gov:8443/voms/OSG  osg
```

!!! note
    The `osg` (3rd token) is an EDG format for the account name. You will likely want to change it to the group unix account you want assigned for your CE node. The example above is for a `group` account assignment.

To test, you will need to do this on a CE node where the authorization mode is "gridmap" (lcmaps or PRIMA are not enabled):

1.  Populate `/etc/edg-mkgridmap.conf` with the example configuration file on your VOMS server. It will be the only entry.

    ``` console
    [root@voms ~]$ echo 'group vomss://cms-xen3.fnal.gov:8443/voms/OSG  osg' > /etc/edg-mkgridmap.conf
    ```

2.  Execute edg-mkgridmap:

    ``` console
    [root@voms ~]$ edg-mkgridmap
      ... the output will be in /etc/grid-security/grid-mapfile and will look as follows ...
      "/DC=org/DC=doegrids/OU=People/CN=John Weigand 458491"  vdt
      "/DC=org/DC=doegrids/OU=Services/CN=cms-xen3.fnal.gov"  vdt
    ```

You can find more in the [compute element install document](../compute-element/install-htcondor-ce).

Testing the GUMS interface 
--------------------------------------------------------------------

The GUMS authorization server periodically 'pulls' the VO membership data for it's authorization and account assignment functions from the various VO's VOMS servers.

Unfortunately, there is no way of testing this except with an installed GUMS server which this document does not address.

See the [GUMS install guide](../security/install-gums) for more information.

Removing a VO 
-------------------------------------------------------

If you added the VO just for testing purposes, you can remove it using `voms-admin-configure remove --vo VONAME` as documented in the [user guide](https://twiki.cern.ch/twiki/bin/view/EMI/EMIVomsAdminUserGuide261#Removing_a_VO), e.g.:

``` console
## Stop the service 
[root@voms ~]$ service voms-admin stop test1
[root@voms ~]$ service voms stop test1  
## Remove it.
[root@voms ~]$ voms-admin-configure remove --vo test1 --undeploy-database --dropdb --dbapwd top_secret
voms-admin-configure, version 2.6.1

Removing vo  test1
VO test1 succesfully removed.
## Restart to update the voms-server webpage 
[root@voms ~]$ service tomcat6 restart
```

Note that the --undeploy-database and --dropdb will remove the database that stores all the membership information. You cannot undo this option. If you're not quite sure that you really want to remove the database, then do not pass this option. The VO will be unaccessible and unusable, but the membership information will be retained in case you recreate the VO later.

Troubleshooting
====================

Useful configuration and log files 
----------------------------------------------------------------------------

Configuration Files

| Service or Process | Configuration File | Description |
|------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| voms                                                                                                                         | `/etc/voms/VO_NAME/voms.conf`                                                                                                
                                                                                                                                `/etc/voms/VO_NAME/voms.pass`                                                                                                 | VOMS server configuration and password for the VO database                                                                                                                   |
| voms-admin                                                                                                                   | `/etc/voms-admin/voms-siblings.xml`                                                                                          | Auxiliary voms-admin application configuration                                                                                                                               |
|                                                                                                                              | `/etc/voms-admin/VO_NAME/logback.runtime.xml`                                                                                | Logging configuration                                                                                                                                                        |
|                                                                                                                              | `/etc/voms-admin/VO_NAME/vo-aup.txt`                                                                                         | VO acceptable use policy                                                                                                                                                     |
|                                                                                                                              | `/etc/voms-admin/VO_NAME/voms-admin-VO_NAME.xml`                                                                             
                                                                                                                                `/etc/voms-admin/VO_NAME/voms.service.properties`                                                                             | VOMS Admin configuration                                                                                                                                                     |
|                                                                                                                              | `/etc/voms-admin/VO_NAME/voms.database.properties`                                                                           | VO database handler configuration                                                                                                                                            |
|                                                                                                                              | `/etc/voms-admin/VO_NAME/vomses`                                                                                             | vomses line |
| mysql                                                                                                                        | `/var/lib/mysql/VO_NAME`                                                                                                     | VOMS database for the VO                                                                                                                                                     |
|                                                                                                                              | `/etc/my.cnf`                                                                                                                | MySQL configuration, e.g. server port                                                                                                                                        |
| tomcat                                                                                                                       | `/etc/tomcat6/`                                                                                                              | Tomcat configuration files                                                                                                                                                   |
|                                                                                                                              | `/etc/tomcat6/Catalina/localhost/*`                                                                                          | VOMS related tomcat configuration                                                                                                                                            |

Log files

| Service or Process | Log File | Description |
|------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------|
|                                                                                                                              | `/var/log/tomcat5/voms-admin-VO_NAME.log`                                                                          | This is the vo-by-vo log for voms-admin Web UI                                                                        |
|                                                                                                                              | `/var/log/tomcat5/trustmanager.log`                                                                                | The trustmanager handles things related to authentication. Useful errors are sometimes here.                          |
| tomcat                                                                                                                       | `/var/log/tomcat6/catalina.out`                                                                                    | This is the Tomcat log file. Problems (and a lot of noise) are reported here.                                         |
|                                                                                                                              | `/var/log/tomcat6/voms-admin-VO_NAME.log`                                                                          | This is the vo-by-vo log for voms-admin Web UI                                                                        |
|                                                                                                                              | `/var/log/tomcat6/trustmanager.log`                                                                                | The trustmanager handles things related to authentication. Useful errors are sometimes here.                          |
| voms                                                                                                                         | `/var/log/voms/voms.VO_NAME`                                                                                       | This is the log of the VOMS daemon for each VO                                                                        |

Fix these errors 
----------------------------------------------------------

### VOMS Server for VO\_NAME not known!

If you saw an error like "VOMS Server for VO\_NAME not known!" probably you did not add the VO VO\_NAME (e.g. test1) to `/etc/vomses`

### Tomcat is not starting

If Tomcat is not starting and `/var/log/tomcat5/catalina.out` contains an error like "/usr/bin/tomcat5: line 331: /usr/lib/java/bin/java: No such file or directory", then you may have to uncomment the line `JAVA_HOME="/usr/lib/jvm/java"` in `/etc/tomcat5/tomcat5.conf`. The Jpackage repository is known to provide a misconfigured tomcat5 package.

### Problems running voms-admin

Verify if voms-admin was configured and started correctly:

-   If voms-admin is not responding and you get a "Socket error 111" try restarting tomcat6 and voms-admin
-   If there are BC (bouncycastle) related errors in Tomcat's log file (`/var/log/tomcat6/catalina.out`), the trust manager may not be configured correctly. Try to run `/var/lib/trustmanager-tomcat/configure.sh`.
-   If there are OpenSAML or XML parser related errors in Tomcat's log file (`/var/log/tomcat6/catalina.out`), the JAVA\_ENDORSED\_DIRS variable may not be set in `/etc/tomcat6/tomcat6.conf`. See the **Configure Tomcat options** section above.
-   If you get an error like "Socket error: (1, 'error:14094416:SSL routines:SSL3\_READ\_BYTES:sslv3 alert certificate unknown')" probably you have no CRLs for your CA certificates. You can see in `/var/log/tomcat6/trustmanager.log` that Tomcat is discarding CA certificates without CRL. Run `fetch-crl`.

### Wrong URLs in VOMS admin pages/Connection timed out/Host unavailable

If you can reach the first page but all the links are failing, check the URL in the links. Tomcat by default constructs the absolute URLs in the web pages using the hostname/IP and port used for the request. If the server resides behind a Firewall or NAT that enforces port redirection, these may be the server IP or the port on the private network, that likely are not reachable by your Web browser. To fix the problem you must use [Tomcat's proxy support](http://tomcat.apache.org/tomcat-5.5-doc/config/http.html#Proxy_Support) by setting `proxyName` and/or `proxyPort` in Tomcat's configuration file (`/etc/tomcat5/server.xml`).

After changing `server.xml` [stop and restart](#services) Tomcat in order for the changes to take effect.

How to get Help?
=====================

To get assistance please use [Help Procedure](../common/help.md).

References
===============

EMI documentation:

-   [EMI VOMS documentation](https://twiki.cern.ch/twiki/bin/view/EMI/EMIVomsDocumentation)
-   [VOMS Admin User Guide](https://twiki.cern.ch/twiki/bin/view/EMI/EMIVomsAdminUserGuide261)
-   [VOMS System Admin Guide](https://twiki.cern.ch/twiki/bin/view/EMI/VOMSystemAdministratorGuide)
-   [How to configure VOMS LSC files](https://twiki.cern.ch/twiki/bin/view/LCG/VOMSLSCfileConfiguration)

Openssl commands:

<http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html>
