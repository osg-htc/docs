&lt;div style="border: 1px solid black; margin: 1em 0; padding: 1em; background-color: \#FFDDDD;"&gt; <span class="twiki-macro NOTE"></span> GUMS will no longer be supported in OSG 3.4. The [LCMAPS VOMS Plugin](Documentation.Release3/InstallLcmapsVoms) is the preferred method for site authentication in the OSG and is available in both OSG 3.3 and OSG 3.4. &lt;/div&gt;

GUMS Install Guide
==================

<span class="twiki-macro TOC" depth="3"></span>

---\# Introduction

<span class="twiki-macro LINK_GLOSSARY_GUMS"></span> is a service that authorizes and maps users from their global (X.509) identity to a local (Linux user) identity. It is not a required service (some sites use the simple `edg-mkgridmap` to construct a `grid-mapfile` instead), but it is commonly used. GUMS is useful when more than one resource (Compute Element, Storage Element, etc.) needs to authorize or map users, because it helps them share data. It is particularly helpful when using gLExec at a site, because gLExec runs on every worker node and needs authorization and mapping information. GUMS is a web application that runs in Tomcat.

<span class="twiki-macro NOTE"></span> Starting on 11 February 2014, all OSG-issued Digicert certificates (host, service, and personal) use the SHA-2 algorithm. &lt;span style="color: \#F60;"&gt;The GUMS software must be on a recent version to support SHA-2 certificates.&lt;/span&gt; Please visit [our SHA-2 compliance page](SHA2Compliance) for more information about minimum required versions of software components.

---\# About This Document

This document is intended for site administrators who want to install and configure the <span class="twiki-macro LINK_GLOSSARY_GUMS"></span> service.

<span class="twiki-macro INCLUDE" section="Header">Trash/DocumentationTeam/DocConventions</span> <span class="twiki-macro INCLUDE" section="CommandLine">Trash/DocumentationTeam/DocConventions</span>

---\# Requirements

---\#\# Host and OS

-   A host for the GUMS service&lt;p&gt;It is strongly recommended that GUMS be installed on a separate computer from the <span class="twiki-macro LINK_GLOSSARY_CE"></span>, although it is possible to install both on the same computer. But for security reasons, it is best to run the authorization service separately from any resource that can run user jobs.&lt;/p&gt;
-   OS is <span class="twiki-macro SUPPORTED_OS"></span>
-   Root access

---\#\# Users

The GUMS installation will create two users unless they exist already:

<span class="twiki-macro STARTSECTION">Users</span>

| User     | Default UID | Comment                                                 |
|:---------|:------------|:--------------------------------------------------------|
| `mysql`  | 27          | Runs the MySQL database server, which GUMS uses         |
| `tomcat` | 91          | Runs the Tomcat web application server, which runs GUMS |

Note that if UIDs 27 and 91 are taken already but not used for the appropriate users, you will experience errors. [Details...](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/KnownProblems#Reserved_user_ids_especially_for) <span class="twiki-macro ENDSECTION">Users</span>

---\#\# Certificates

| Certificate              | Certificate Owner | Path to Certificate                                                                     |
|:-------------------------|:------------------|:----------------------------------------------------------------------------------------|
| HTTP service certificate | `tomcat`          | `/etc/grid-security/http/httpcert.pem` &lt;br&gt; `/etc/grid-security/http/httpkey.pem` |

---\#\# Networking

<span class="twiki-macro STARTSECTION">Firewalls</span> <span class="twiki-macro INCLUDE" section="FirewallTable" lines="gums">Documentation/Release3.FirewallInformation</span> <span class="twiki-macro ENDSECTION">Firewalls</span>

---\# Installation Procedure

<span class="twiki-macro INCLUDE" section="OSGRepoBrief" TOC_SHIFT="+">YumRepositories</span> <span class="twiki-macro INCLUDE" section="OSGBriefCaCerts" TOC_SHIFT="+">InstallCertAuth</span>

---\#\# Install and Configure GUMS

---\#\#\# Install GUMS

1.  Whether installing or upgrading GUMS, please make sure to follow [these instructions](Documentation/Release3.InstallSoftwareWithOpenJDK7#InstallingJava) for updating/installing Java to work correctly with GUMS. &lt;br&gt; **Note:** if you have older versions of java installed (for instance, `jdk`), make sure to re-run `alternatives --config java` and `alternatives --config javac`
2.  If you have an existing GUMS installation on the same host, shutdown Tomcat.
    For OSG 3.x (RPM) installs, see the [shutdown instructions](#StoppingAndDisablingServices).
    For OSG 1.2.x (Pacman) installs: `vdt-control --off tomcat-55`
3.  Install the GUMS Service &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> yum install osg-gums&lt;/pre&gt;
4.  Configure Tomcat to use GSI &lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> /var/lib/trustmanager-tomcat/configure.sh&lt;/pre&gt; &lt;p&gt;**Note:** This step will overwrite your `server.xml` file in your tomcat configuration directory (`/etc/tomcat5` on EL5, `/etc/tomcat6` on EL6, or `/etc/tomcat` on EL7); if you are using Tomcat on this host for non-grid purposes, you may want to save the `server.xml` file first, run the script, then merge your own configuration back into the file.&lt;/p&gt;

---\#\#\# Configure GUMS database

In this section, you will configure the GUMS MySQL database, either by creating a new database or by copying an existing GUMS database. Pick the appropriate subsection below for your environment.

---\#\#\#\# New Installation

1.  Start the database server
    -   On EL5 and EL6, this is MySQL:&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> service mysqld start&lt;/pre&gt;
    -   On EL7, this is MariaDB:&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl start mariadb&lt;/pre&gt;
2.  Create a new GUMS database&lt;pre class`"rootscreen">%UCL_PROMPT_ROOT% /usr/bin/gums-setup-mysql-database --user gums --host <strong>localhost</strong>:3306 --password <em>PASSWORD</em> --template /etc/gums/gums.config.template</pre><p><strong>Note:</strong> The password is saved in plaintext in the =/etc/gums/gums.config` file, so choose one that is not used elsewhere. The `gums.config` file should be readable only by the `tomcat` user, but this situation provides light security at best.&lt;/p&gt;&lt;p&gt;**Note:** When specifying the database host with the `--host` option above, it is also possible to use `$HOSTNAME` instead of `localhost`, though `localhost` is recommended. This value corresponds to `@SERVER@` in a `gums.config.template` file, discussed below.&lt;/p&gt;&lt;p&gt;**Note:** Although it is possible to specify a different location for the `--template` or to omit the option and use the default GUMS template (at `/usr/lib/gums/config/gums.config.template`), neither option is typically useful for an OSG installation.&lt;/p&gt;
3.  Add yourself as a GUMS administrator&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> gums-add-mysql-admin '*YOUR DN*'&lt;/pre&gt;
4.  \[Optional but recommended:\] Apply reasonable MySQL security settings&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> /usr/bin/mysql\_secure\_installation&lt;/pre&gt;

---\#\#\#\# Upgrade from existing GUMS server on another host

**Note for GUMS 1.4+:** Since the database schema has not changed between GUMS 1.3 and 1.4, the database name continues to be `GUMS_1_3`. *Do not* rename `GUMS_1_3` database references to `GUMS_1_4`. There was a schema change within the GUMS 1.4 series, but this happens automatically when GUMS is started - make sure the GUMS user has permission to perform schema changes. Nevertheless the database name remains `GUMS_1_3` in GUMS 1.4 and GUMS 1.5.

1.  On the older host, dump the GUMS\_1\_3 database to a text file&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> mysqldump GUMS\_1\_3 &gt; gums\_1\_3.sql&lt;/pre&gt;
2.  Copy the `gums_1_3.sql` file from the old host to the new one
3.  Start MySQL&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> service mysqld start&lt;/pre&gt; \* On EL7, this is MariaDB:&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl start mariadb&lt;/pre&gt;
4.  Load the old GUMS data into the new MySQL database&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> echo 'CREATE DATABASE IF NOT EXISTS GUMS\_1\_3;' | mysql

<span class="twiki-macro UCL_PROMPT_ROOT"></span> mysql GUMS\_1\_3 &lt; gums\_1\_3.sql&lt;/pre&gt;

1.  \[Optional but recommended for new MySQL instances:\] Apply reasonable MySQL security settings&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> /usr/bin/mysql\_secure\_installation&lt;/pre&gt;

---\#\#\#\# Upgrade from existing GUMS server (installed by Pacman) on the same host

**Note for GUMS 1.4+:** Since the database schema has not changed between GUMS 1.3 and 1.4, the database name continues to be `GUMS_1_3`. *Do not* rename `GUMS_1_3` database references to `GUMS_1_4`. There was a schema change within the GUMS 1.4 series, but this happens automatically when GUMS is started - make sure the GUMS user has permission to perform schema changes. Nevertheless the database name remains `GUMS_1_3` in GUMS 1.4 and GUMS 1.5.

1.  In one terminal, use the old installation to dump the GUMS\_1\_3 database to a text file&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> cd VDT\_LOCATION

<span class="twiki-macro UCL_PROMPT_ROOT"></span> source setup.sh <span class="twiki-macro UCL_PROMPT_ROOT"></span> mysqldump GUMS\_1\_3 &gt; /tmp/gums\_1\_3.sql&lt;/pre&gt;

1.  Shut down the old MySQL server&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> vdt-control --off mysql5&lt;/pre&gt;
2.  Switch to another terminal (window, session, etc.) to avoid contamination from OSG 1.2.x environment variables
3.  Start the new database server
    -   On EL5 and EL6, this is MySQL:&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> service mysqld start&lt;/pre&gt;
    -   On EL7, this is MariaDB:&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl start mariadb&lt;/pre&gt;
4.  Load the old GUMS data into the new MySQL database&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> echo 'CREATE DATABASE IF NOT EXISTS GUMS\_1\_3;' | mysql

<span class="twiki-macro UCL_PROMPT_ROOT"></span> mysql GUMS\_1\_3 &lt; /tmp/gums\_1\_3.sql&lt;/pre&gt;

1.  Update the database schema&lt;p&gt;There was a GUMS database schema change between the OSG 1.2.x (Pacman) and OSG 3.x (RPM) versions of GUMS. In particular, the `USER` table is now named `USERS`. You must update the `GUMS_1_3` database schema before starting Tomcat&lt;/p&gt;&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> mysql GUMS\_1\_3

mysql&gt; RENAME TABLE USER TO USERS; mysql&gt; quit&lt;/pre&gt;

1.  \[Optional but recommended for new MySQL instances:\] Apply reasonable MySQL security settings&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> /usr/bin/mysql\_secure\_installation&lt;/pre&gt;

---\#\#\# Set Initial GUMS Configuration

In this section, you will set up an initial GUMS configuration file, either by copying in an OSG template or by copying an existing configuration from an old installation. Pick the appropriate subsection below for your environment.

---\#\#\#\# New Installation

If you ran the `gums-setup-mysql-database` command above with the `--template` option, the OSG GUMS template will be used. This should have created a suitable `/etc/gums/gums.config` with the configuration values in this section already filled in. *In that case, you can skip this section.*

If you ran the `gums-setup-mysql-database` command above *without* a `--template` option, it created a default, pre-configured `/etc/gums/gums.config` file. It is almost certainly not what you want. Instead, it is recommended that you start with an OSG template for your configuration.

1.  Copy the OSG template over the default configuration file&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> cp /etc/gums/gums.config.template /etc/gums/gums.config&lt;/pre&gt;
2.  Edit the new `/etc/gums/gums.config` file and change the following settings&lt;p&gt;**Note:** Each placeholder occurs exactly once in the file&lt;/p&gt;

<table>
<thead>
<tr class="header">
<th align="left">Search for</th>
<th align="left">Replace with</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">@USER@</td>
<td align="left">The name of the MySQL GUMS user. If you followed the instructions above, this will be <code>gums</code>.</td>
</tr>
<tr class="even">
<td align="left">@PASSWORD@</td>
<td align="left">The password for the MySQL gums user (see above).</td>
</tr>
<tr class="odd">
<td align="left">@SERVER@</td>
<td align="left">The name of your computer and port (e.g. <code>localhost</code> or <code>my.computer:3306</code>) .<br />
Normally MySQL is running on the same machine as GUMS (as in the instructions above).&lt;br&gt;We <strong>highly recommend</strong> using <code>localhost</code> instead of the actual hostname; this will cause MySQL to use a local Unix socket instead of listening on the network, which is more secure. If you use localhost, there is no need to specify a port. In either case, the value for <code>@SERVER@</code> <strong>must</strong> match the value for <code>--host</code> used when setting up the gums database with the <code>gums-setup-mysql-database</code> command, above.</td>
</tr>
<tr class="even">
<td align="left">@DOMAINNAME@</td>
<td align="left">Your local domain, such as <code>wisc.edu</code>.</td>
</tr>
</tbody>
</table>

---\#\#\#\# Existing Installation

**Note for GUMS 1.4+:** Since the database schema has not changed between GUMS 1.3 and 1.4, the database name continues to be `GUMS_1_3`. *Do not* rename `GUMS_1_3` database references to `GUMS_1_4`. There was a schema change within the GUMS 1.4 series, but this happens automatically when GUMS is started - make sure the GUMS user has permission to perform schema changes. Nevertheless the database name remains `GUMS_1_3` in GUMS 1.4 and GUMS 1.5.

If you are migrating from an older version of GUMS (i.e., from OSG 1.2.x), you can copy your existing `gums.config` file to its new location, then update it for the new version of GUMS.

1.  Copy your existing `gums.config` into `/etc/gums/gums.config`
2.  Edit `/etc/gums/gums.config` as follows
    -   Update the MySQL username and password (if different)
    -   Change the connection string for `hibernate.connection.url` so that the port is 3306 instead of 49xxx
    -   If you're migrating from GUMS installed by pacman, change `vomsServer` elements to remove the `services/VOMSAdmin` string from each `baseURL`.
    -   If you're migrating from GUMS installed by pacman, update the `sslCAFiles` attribute in the `vomsServer` element to identify correctly to your CA certificate files (`/etc/grid-security/certificates/*.0`, if you are using default settings).
3.  If you have updated GUMS from another server or from an OSG 1.2.x installation, you will need to authorize the user being used by GUMS to access the `GUMS_1_3` database. Using the table above, replace values in the following command and run it&lt;pre class="rootscreen"&gt;<span class="twiki-macro UCL_PROMPT_ROOT"></span> mysql -u root mysql

mysql&gt; GRANT ALL ON GUMS\_1\_3.\* TO '@USER@'@'@SERVER@' IDENTIFIED BY '@PASSWORD@'; mysql&gt; FLUSH PRIVILEGES; mysql&gt; quit&lt;/pre&gt;

For convenience, you can use the following sed commands to make the changes to the `vomsServer` and `sslCAFiles` elements: <span class="twiki-macro TWISTY">%TWISTY\_OPTS\_OUTPUT% showlink="Sed command to change vomsServer elements"</span>

``` rootscreen
%UCL_PROMPT_ROOT% sed -i -e "s@/services/VOMSAdmin'@'@g" gums.config.template_from_pacman
```

<span class="twiki-macro ENDTWISTY"></span> <span class="twiki-macro TWISTY">%TWISTY\_OPTS\_OUTPUT% showlink="Sed command to change sslCAFiles elements"</span>

``` rootscreen
%UCL_PROMPT_ROOT% sed -i -e "s@sslCAFiles=''@sslCAFiles='/etc/grid-security/certificates/*.0'@g" gums.config.template_from_pacman
```

<span class="twiki-macro ENDTWISTY"></span>

---\#\#\# Configure Log Rotation

By default, certain output is written to files named `/var/log/tomcat*/catalina.YYYY-MM-DD.log` without automatic cleanup of old logs. To configure log rotation and cleanup of `catalina.log`, follow the steps below:

&lt;ol&gt; &lt;li&gt; &lt;p&gt;Choose the Tomcat directory name based on your operating system:&lt;/p&gt; <span class="twiki-macro TABLE" sort="off"></span>

| If your operating system is... | Then your TOMCAT DIR NAME is... |
|:-------------------------------|:--------------------------------|
| EL6                            | `tomcat6`                       |
| EL7                            | `tomcat`                        |

&lt;/li&gt; &lt;li&gt; &lt;p&gt;Edit `/etc/tomcat*/logging.properties` so that Tomcat only produces a single, undated log file:&lt;/p&gt; &lt;pre class="screen"&gt; --- /etc/&lt;span style="background-color: \#FFCCFF;"&gt;TOMCAT DIR NAME&lt;/span&gt;/logging.properties.orig +++ /etc/&lt;span style="background-color: \#FFCCFF;"&gt;TOMCAT DIR NAME&lt;/span&gt;/logging.properties @@ -24,7 +24,8 @@

1catalina.org.apache.juli.FileHandler.level = FINE 1catalina.org.apache.juli.FileHandler.directory = ${catalina.base}/logs -1catalina.org.apache.juli.FileHandler.prefix = catalina. +1catalina.org.apache.juli.FileHandler.prefix = catalina +1catalina.org.apache.juli.FileHandler.rotatable = false

2localhost.org.apache.juli.FileHandler.level = FINE 2localhost.org.apache.juli.FileHandler.directory = ${catalina.base}/logs &lt;/pre&gt; &lt;/li&gt; &lt;li&gt; &lt;p&gt;Write `/etc/logrotate.d/tomcat_catalina_logs` to configure `logrotate`:&lt;/p&gt; &lt;pre class="file"&gt; /var/log/&lt;span style="background-color: \#FFCCFF;"&gt;TOMCAT DIR NAME&lt;/span&gt;/catalina.log { copytruncate weekly rotate 52 compress missingok create 0644 tomcat tomcat } &lt;/pre&gt; &lt;/li&gt; &lt;/ol&gt;

---\# Services

The GUMS service is actually a web application running within the Tomcat web application server. It uses the MySQL database server for storage and the Fetch CRL service to maintain each <span class="twiki-macro LINK_GLOSSARY_CRL"></span>.

\#StartingAndEnablingServices ---\#\# Starting and Enabling Services

To start GUMS and associated services:

1.  Start the GUMS and associated services
    -   <span class="twiki-macro INCLUDE" section="OSGBriefFetchCrlStart">InstallCertAuth</span>
    -   Start other services:&lt;pre class="rootscreen"&gt;

<span class="twiki-macro RED"></span> \# For RHEL 5, CentOS 5, and SL5 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/service mysqld start <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/service tomcat5 start <span class="twiki-macro RED"></span> \# For RHEL 6, CentOS 6, and SL6 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/service mysqld start <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/service tomcat6 start <span class="twiki-macro RED"></span> \# For RHEL 7, CentOS 7, and SL7 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl start mariadb <span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl start tomcat &lt;/pre&gt;

1.  \[Optional but recommended:\] Enable services so that they start automatically when your system is powered on
    -   <span class="twiki-macro INCLUDE" section="OSGBriefFetchCrlEnable">InstallCertAuth</span>
    -   Enable other services: &lt;pre class="rootscreen"&gt;

%RED%\# For RHEL 5, CentOS 5, and SL5 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig mysqld on <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig tomcat5 on %RED%\# For RHEL 6, CentOS 6, and SL6 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig mysqld on <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig tomcat6 on %RED%\# For RHEL 7, CentOS 7, and SL7 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl enable mariadb <span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl enable tomcat &lt;/pre&gt;

\#StoppingAndDisablingServices ---\#\# Stopping and Disabling Services

To stop GUMS, stop it and associated services in the opposite order from which you started them:

1.  Stop the GUMS and associated services:
    -   Stop main services: &lt;pre class="rootscreen"&gt;

%RED%\# For RHEL 5, CentOS 5, and SL5 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/service tomcat5 stop <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/service mysqld stop %RED%\# For RHEL 6, CentOS 6, and SL6 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/service tomcat6 stop <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/service mysqld stop %RED%\# For RHEL 7, CentOS 7, and SL7 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl stop tomcat <span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl stop mariadb &lt;/pre&gt;

-   (other grid service running on the machine may still use it) <span class="twiki-macro INCLUDE" section="OSGBriefFetchCrlStop">InstallCertAuth</span> 1. Stop services from starting when the system is powered on:
-   Disable the main services: &lt;pre class="rootscreen"&gt;

%RED%\# For RHEL 5, CentOS 5, and SL5 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig mysqld off <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig tomcat5 off %RED%\# For RHEL 6, CentOS 6, and SL6 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig mysqld off <span class="twiki-macro UCL_PROMPT_ROOT"></span> /sbin/chkconfig tomcat6 off %RED%\# For RHEL 7, CentOS 7, and SL7 <span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl disable mariadb <span class="twiki-macro UCL_PROMPT_ROOT"></span> systemctl disable tomcat &lt;/pre&gt;

-   (other grid service running on the machine may still use it) <span class="twiki-macro INCLUDE" section="OSGBriefFetchCrlDisable">InstallCertAuth</span>

---\# Validating GUMS

This section is optional, but if you would like to verify that your GUMS installation and configuration are good, consider using some or all of the sections below.

---\#\# Connect to the GUMS web page

Connect to `https://<em>HOSTNAME</em>:8443/gums/` to use your GUMS instance. You must have the certificate that you used for `gums-add-mysql-admin` above loaded in your browser. You should see the GUMS web page load.

<span class="twiki-macro NOTE"></span> Javascript must be enabled in order to make any configuration changes on the web interface.

If you do not see it load, check a few things:

%RED%For OSG 3.x (RPM) installs on EL5 systems<span class="twiki-macro ENDCOLOR"></span>

-   Look for errors in `/var/log/tomcat5/catalina.out` and `/var/log/tomcat5/catalina.err`.
-   Look for errors in `/var/log/tomcat5/trustmanager.log`. There are likely to be CRL errors in this file, this can be ignored unless all your CA's get CRL errors in which case you should check to make sure that your CRL updates are running correctly.

%RED%For OSG 3.x (RPM) installs on EL6 systems<span class="twiki-macro ENDCOLOR"></span>

-   Look for errors in `/var/log/tomcat6/catalina.out` and `/var/log/tomcat6/catalina.err`.
-   Look for errors in `/var/log/tomcat6/trustmanager.log`. There are likely to be CRL errors in this file, this can be ignored unless all your CA's get CRL errors in which case you should check to make sure that your CRL updates are running correctly.

%RED%For OSG 3.x (RPM) installs on EL7 systems<span class="twiki-macro ENDCOLOR"></span>

-   Look for errors in `/var/log/tomcat/catalina.*.log`
-   Look for errors in `/var/log/tomcat/trustmanager.log`. There are likely to be CRL errors in this file, this can be ignored unless all your CA's get CRL errors in which case you should check to make sure that your CRL updates are running correctly.

%RED%For all systems<span class="twiki-macro ENDCOLOR"></span>

-   Ensure that you have an http certificate in `/etc/grid-security/http/httpcert.pem` and `/etc/grid-security/http/httpkey.pem`. Make sure it is readable by the `tomcat` user. Permissions should be as follows:&lt;pre class="screen"&gt;

\# ls -l /etc/grid-security/http/ total 8 -r--r--r-- 1 tomcat tomcat 1671 Jul 2 15:54 httpcert.pem -r-------- 1 tomcat tomcat 1675 Jul 2 15:54 httpkey.pem&lt;/pre&gt;

If you change the permissions/ownership, make sure to restart tomcat so that your changes take effect.

---\#\# Check accounts

After you connect to the GUMS web page, go to the Summary tab to check the configuration. You should see several dozen OSG VOs listed.

In the Account column on the summary page, you will see the local Unix user accounts that these VO users will be mapped to. It is critical that these accounts exist on the gatekeeper and worker nodes at your site. If they do not, there will be errors when users attempt to access your site.

---\#\# Update VO members list

GUMS contacts each VOMS server to update its knowledge of VO membership every 6 hours. After installing or updating GUMS, you should trigger the update manually by going to the Update VO Members tab, and clicking update.

You can track the progress of the update process by watching a log file: &lt;pre class="rootscreen"&gt; %RED%\#For OSG 3.x (RPM) installs on EL5 systems<span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> tail -f /var/log/tomcat5/gums-service-admin.log %RED%\#For OSG 3.x (RPM) installs on EL6 systems<span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> tail -f /var/log/tomcat6/gums-service-admin.log %RED%\#For OSG 3.x (RPM) installs on EL7 systems<span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> tail -f /var/log/tomcat/gums-service-admin.log &lt;/pre&gt;

With so many VOMS servers in the OSG config, several member updates may fail for various reasons (e.g., host down "connect timed out", bad or expired host certificates, etc.). Unfortunately, this situation is normal. Typically, you will see about 5 or 6 failed updates, with the rest succeeding. The update will take a while and then should display any errors that occurred during the updates. To get more details or track the update process in real time, look at `/var/log/gums-service-admin.log`.

---\#\# Map a known good user DN

1.  Go to Map Grid Identity to Account tab: `https://<em>HOSTNAME</em>:8443/gums/map_grid_identity_form.jsp`
2.  Fill in the required info. Service DN means the DN of the host certificate of your CE (see above). Use the DN of a user (probably yourself) who you know belongs to a particular VO. Fill in the VO name in the VOMS FQAN field.
3.  Click "map user". A failed mapping will display "null". A successful mapping will display a UNIX account name.

---\# Miscellaneous Procedures

---\#\# Forcing GUMS to update the set of users

GUMS automatically contacts each VOMS server every 6 hours to update its knowledge of VO membership. To trigger a manual update:

1.  Access the “Update VO Members” tab
2.  Click “Update”
3.  \[Optional:\] Monitor update progress via a log file&lt;pre class="rootscreen"&gt;

%RED%\#For OSG 3.x (RPM) installs on EL5 systems<span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> tail -f /var/log/tomcat5/gums-service-admin.log %RED%\#For OSG 3.x (RPM) installs on EL6 systems<span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> tail -f /var/log/tomcat6/gums-service-admin.log %RED%\#For OSG 3.x (RPM) installs on EL7 systems<span class="twiki-macro ENDCOLOR"></span> <span class="twiki-macro UCL_PROMPT_ROOT"></span> tail -f /var/log/tomcat/gums-service-admin.log &lt;/pre&gt;

With so many VOMS servers in the OSG config, several member updates may fail for various reasons (e.g., host down "connect timed out", bad or expired host certificates, etc.). Unfortunately, this situation is normal.

---\#\# Updating the GUMS configuration

Periodically, the OSG Grid Operations Center will release an updated template for the GUMS configuration that updates information about an existing VO or adds a new VO. You may get the update as part of a regular update process, or you can force an update by using yum:

``` rootscreen
%UCL_PROMPT_ROOT% yum update osg-gums-config
```

This step does **not** update your GUMS configuration (`/etc/gums/gums.config`) but will update the template for your configuration (`/etc/gums/gums.config.template`), because RPM cannot merge configuration changes. Instead, use GUMS to merge in the new VO configuration information.

1.  Go to the Merge Configuration tab: `https://<em>HOSTNAME</em>:8443/gums/mergeConfiguration.jsp`
2.  Cut and paste the URL of the OSG template into the Configuration URI field.&lt;p&gt;For the template provided in the RPM, use: `file:///etc/gums/gums.config.template` &lt;BR&gt;To fetch it directly from the GOC, use `http://software.grid.iu.edu/pacman/tarballs/vo-version/gums.template` &lt;/p&gt;
3.  Click Merge&lt;p&gt;You should get a green success message if it has worked, along with a suggestion that you update the VO members.&lt;/p&gt;
4.  Check the Summary tab to verify the set of VOs you have, as well as their accounts

---\# Troubleshooting

---\#\# Useful Configuration and Log Files

Configuration Files

| Service or Process | Configuration File | Description                           |
|:-------------------|:-------------------|:--------------------------------------|
| MySQL              | `/etc/my.cnf`      | MySQL configuration, e.g. server port |
| tomcat (EL5)       | `/etc/tomcat5/`    | Tomcat configuration files            |
| tomcat (EL6)       | `/etc/tomcat6/`    | Tomcat configuration files            |
| tomcat (EL7)       | `/etc/tomcat/`     | Tomcat configuration files            |

Log files

| Service or Process | Log File                                          | Description                                                                                                                          |
|:-------------------|:--------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------|
| tomcat (EL5)       | `/var/log/tomcat5/catalina.out`                   | This is the Tomcat log file. Problems (and a lot of noise) are reported here.                                                        |
|                    | `/var/log/tomcat5/trustmanager.log`               | The trustmanager handles things related to authentication. Useful errors are sometimes here.                                         |
| tomcat (EL6)       | `/var/log/tomcat6/catalina.out`                   | This is the Tomcat log file. Problems (and a lot of noise) are reported here.                                                        |
|                    | `/var/log/tomcat6/trustmanager.log`               | The trustmanager handles things related to authentication. Useful errors are sometimes here.                                         |
| tomcat (EL6/EL7)   | `/var/log/tomcat*/catalina.*.log`                 | These are the Tomcat log files. Problems (and a lot of noise) are reported here.                                                     |
| tomcat (EL6/EL7)   | `/var/log/tomcat*/catalina.log`                   | Alternate non-rotated location for tomcat log file. Not the same as `catalina.out`. Problems (and a lot of noise) are reported here. |
|                    | `/var/log/tomcat/trustmanager.log`                | The trustmanager handles things related to authentication. Useful errors are sometimes here.                                         |
| **GUMS** (EL5)     | `/var/log/tomcat5/gums-service-admin.log`         | GUMS outputs error messages related to it's operations here.                                                                         |
|                    | `/var/log/tomcat5/gums-service-cybersecurity.log` | GUMS outputs security related messages to this file.                                                                                 |
| **GUMS** (EL6)     | `/var/log/tomcat6/gums-service-admin.log`         | GUMS outputs error messages related to it's operations here.                                                                         |
|                    | `/var/log/tomcat6/gums-service-cybersecurity.log` | GUMS outputs security related messages to this file.                                                                                 |
| **GUMS** (EL7)     | `/var/log/tomcat/gums-service-admin.log`          | GUMS outputs error messages related to it's operations here.                                                                         |
|                    | `/var/log/tomcat/gums-service-cybersecurity.log`  | GUMS outputs security related messages to this file.                                                                                 |

|                        |                                             |                                                                           |
|------------------------|---------------------------------------------|---------------------------------------------------------------------------|
| **GUMS** (EL5/EL6/EL7) | `/var/log/gums/gums-developer.root.log`     |                                                                           |
|                        | `/var/log/gums/gums-egee-security.root.log` | GUMS may also output some security related messages to this file as well. |
|                        | `/var/log/gums/gums-privilege.root.log`     | GUMS outputs mapping related errors to this file.                         |

---\#\# Tuning GUMS for a big Site GumsScalability contains several performance tips built form the experience of running the service on FermiGrid, a big OSG Site.

---\# How to get Help?

To get assistance please use the [Help Procedure](HelpProcedure).

---\# References

-   [GUMS tuning and scalability tips](GumsScalability)
-   <http://tomcat.apache.org/tomcat-5.5-doc/> Official tomcat5 documentation
-   <http://tomcat.apache.org/tomcat-6.0-doc/> Official tomcat6 documentation
-   <https://tomcat.apache.org/tomcat-7.0-doc/> Official tomcat7 documentation
-   <http://www.hibernate.org/docs> Official hibernate documentation

---\# Comments

<span class="twiki-macro COMMENT" type="tableappend"></span>
