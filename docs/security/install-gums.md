!!! warning
    GUMS is no longer be supported in OSG 3.4. The [LCMAPS VOMS Plugin](../security/lcmaps-voms-authentication) is the preferred method for site authentication in the OSG and is available in both OSG 3.3 and OSG 3.4.

GUMS Install Guide
==================

This document is intended for site administrators who want to install and configure the GUMS service.

GUMS is a service that authorizes and maps users from their global (X.509) identity to a local (Linux user) identity. It is not a required service (some sites use the simple `edg-mkgridmap` to construct a `grid-mapfile` instead), but it is commonly used. GUMS is useful when more than one resource (Compute Element, Storage Element, etc.) needs to authorize or map users, because it helps them share data. It is particularly helpful when using gLExec at a site, because gLExec runs on every worker node and needs authorization and mapping information. GUMS is a web application that runs in Tomcat.

Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Reference section below](#reference) as needed):

-   **User IDs:** If they do not exist already, the installation will create the Linux users `mysql` (UID 27) and `tomcat` (UID 91)
-   **Service certificate:** The GUMS service uses a host certificate at `/etc/grid-security/http/httpcert.pem` and an accompanying key at `/etc/grid-security/http/httpkey.pem`
-   **Network ports:** Hosts using your GUMS server for authentication (e.g., HTCondor-CE, GridFTP) must be able to contact it on port 8443 (TCP)

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has [a supported operating system](../release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](../common/yum)
- Install [CA certificates](https://twiki.grid.iu.edu/bin/view/Documentation/Release3/InstallCertAuth)

Installing GUMS
---------------

1.  Whether installing or upgrading GUMS, please make sure to follow [these instructions](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallSoftwareWithOpenJDK7#InstallingJava) for updating/installing Java to work correctly with GUMS
2.  If you have an existing GUMS installation on the same host, shut down Tomcat.
    The service is named `tomcat6` on EL6 and `tomcat` on EL7
3.  Install the GUMS Service:

        :::console
        [root@server]# yum install osg-gums

4.  Configure Tomcat to use GSI:

        :::console
        [root@server]# /var/lib/trustmanager-tomcat/configure.sh

    !!! note
        This step will overwrite your `server.xml` file in your tomcat configuration directory (`/etc/tomcat6` on EL6, `/etc/tomcat` on EL7).
        If you are using Tomcat on this host for non-grid purposes, you may want to save the `server.xml` file first, run the script, then merge your own configuration back into the file

Configuring GUMS
----------------

### Configure GUMS database

In this section, you will configure the GUMS MySQL database, either by creating a new database or by copying an existing GUMS database. Pick the appropriate subsection below for your environment.

#### New Installation

1.  Start the database server
    -   On EL6, this is MySQL:

            :::console
            [root@server]# service mysqld start

    -   On EL7, this is MariaDB:

            :::console
            [root@server]# systemctl start mariadb

2.  Create a new GUMS database:

        :::console
        [root@server]# /usr/bin/gums-setup-mysql-database \
            --user gums --host localhost:3306 --password %RED%<password>%ENDCOLOR% \
            --template /etc/gums/gums.config.template


    !!! note
        The password is saved in plaintext in the `/etc/gums/gums.config` file, so choose one that is not used elsewhere. The `gums.config` file should be readable only by the `tomcat` user, but this situation provides light security at best

    !!! note
        When specifying the database host with the `--host` option above, it is also possible to use `$HOSTNAME` instead of `localhost`, though `localhost` is recommended. This value corresponds to `@SERVER@` in a `gums.config.template` file, discussed below

    !!! note
        Although it is possible to specify a different location for the `--template` or to omit the option and use the default GUMS template (at `/usr/lib/gums/config/gums.config.template`), neither option is typically useful for an OSG installation

3.  Add yourself as a GUMS administrator:

        :::console
        [root@server]# gums-add-mysql-admin '%RED%<YOUR DN>%ENDCOLOR%'

4.  \[Optional but recommended:\] Apply reasonable MySQL security settings:

        :::console
        [root@server]# /usr/bin/mysql_secure_installation


#### Upgrade from existing GUMS server on another host

**Note for GUMS 1.4+:** Since the database schema has not changed between GUMS 1.3 and 1.4, the database name continues to be `GUMS_1_3`. *Do not* rename `GUMS_1_3` database references to `GUMS_1_4`. There was a schema change within the GUMS 1.4 series, but this happens automatically when GUMS is started - make sure the GUMS user has permission to perform schema changes. Nevertheless the database name remains `GUMS_1_3` in GUMS 1.4 and GUMS 1.5.

1.  On the older host, dump the GUMS\_1\_3 database to a text file:

        :::console
        [root@server]# mysqldump GUMS_1_3 > gums_1_3.sql

2.  Copy the `gums_1_3.sql` file from the old host to the new one
3.  Start MySQL:

    For EL 6:

        :::console
        [root@server]# service mysqld start

    For EL 7:

        :::console
        [root@server]# systemctl start mariadb

4.  Load the old GUMS data into the new MySQL database:

        :::console
        [root@server]# echo 'CREATE DATABASE IF NOT EXISTS GUMS_1_3;' | mysql
        [root@server]# mysql GUMS_1_3 < gums_1_3.sql

5.  \[Optional but recommended for new MySQL instances:\] Apply reasonable MySQL security settings:

        :::console
        [root@server]# /usr/bin/mysql_secure_installation


### Set Initial GUMS Configuration

In this section, you will set up an initial GUMS configuration file, either by copying in an OSG template or by copying an existing configuration from an old installation. Pick the appropriate subsection below for your environment.

#### New Installation

If you ran the `gums-setup-mysql-database` command above with the `--template` option, the OSG GUMS template will be used. This should have created a suitable `/etc/gums/gums.config` with the configuration values in this section already filled in. *In that case, you can skip this section.*

If you ran the `gums-setup-mysql-database` command above *without* a `--template` option, it created a default, pre-configured `/etc/gums/gums.config` file. It is almost certainly not what you want. Instead, it is recommended that you start with an OSG template for your configuration.

1.  Copy the OSG template over the default configuration file:

        :::console
        [root@server]# cp /etc/gums/gums.config.template /etc/gums/gums.config

2.  Edit the new `/etc/gums/gums.config` file and change the following settings (note: each placeholder occurs exactly once in the file):

    | Search for     | Replace with                                                                                  |
    |----------------|-----------------------------------------------------------------------------------------------|
    | `@USER@`       | The name of the MySQL GUMS user. If you followed the instructions above, this will be `gums`  |
    | `@PASSWORD@`   | The password for the MYSQL GUMS user (see above)                                              |
    | `@SERVER@`     | The name of your computer and port (e.g. `localhost` or `my.computer:3306`). See note         |
    | `@DOMAINNAME@` | Your local domain (e.g. `wisc.edu`)                                                           |

    !!! note
        Normally MySQL is running on the same machine as GUMS (as in the instructions above).<br/>
        We **highly recommend** using `localhost` instead of the actual hostname; this will cause MySQL to use a local Unix socket instead of listening on the network, which is more secure.
        If you use `localhost`, there is no need to specify a port.
        In either case, the value for `@SERVER@` *must* match the value for `--host` used when setting up the GUMS database with the `gums-setup-mysql-database` command



### Configure Log Rotation

By default, certain output is written to files named `/var/log/tomcat*/catalina.YYYY-MM-DD.log` without automatic cleanup of old logs. To configure log rotation and cleanup of `catalina.log`, follow the steps below:

1.  Choose the Tomcat directory name based on your operating system:

    | If your operating system is... | Then your TOMCAT DIR NAME is... |
    |:-------------------------------|:--------------------------------|
    | EL6                            | `tomcat6`                       |
    | EL7                            | `tomcat`                        |

2.  Edit `/etc/tomcat*/logging.properties` so that Tomcat only produces a single, undated log file:

        :::diff
        --- /etc/%RED%<TOMCAT DIR NAME>%ENDCOLOR%/logging.properties.orig
        +++ /etc/%RED%<TOMCAT DIR NAME>%ENDCOLOR%/logging.properties
        @@ -24,7 +24,8 @@
         catalina.org.apache.juli.FileHandler.level = FINE
         catalina.org.apache.juli.FileHandler.directory = ${catalina.base}/logs
        -catalina.org.apache.juli.FileHandler.prefix = catalina.
        +catalina.org.apache.juli.FileHandler.prefix = catalina
        +catalina.org.apache.juli.FileHandler.rotatable = false

         localhost.org.apache.juli.FileHandler.level = FINE
         localhost.org.apache.juli.FileHandler.directory = ${catalina.base}/logs

3.  Write `/etc/logrotate.d/tomcat_catalina_logs` to configure `logrotate`:

        /var/log/%RED%<TOMCAT DIR NAME>%ENDCOLOR%/catalina.log
        { copytruncate weekly rotate 52 compress missingok create 0644 tomcat tomcat }


Services
--------

The GUMS service is actually a web application running within the Tomcat web application server. It also uses the MySQL database server for storage and the Fetch CRL service to maintain each CRL. Choose the list of services based on your host's operating system:

- For EL6 hosts

    | Software          | Service name                          | Notes                                                                                  |
    |:------------------|:--------------------------------------|:---------------------------------------------------------------------------------------|
    | Fetch CRL         | `fetch-crl-boot` and `fetch-crl-cron` | See [CA documentation](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallCertAuth#Start_Stop_fetch_crl_A_quick_gui) for more info |
    | MySQL             | `mysqld`                              |                                                                                        |
    | Tomcat            | `tomcat6`                             |                                                                                        |

- For EL7 hosts

    | Software          | Service name                          | Notes                                                                                  |
    |:------------------|:--------------------------------------|:---------------------------------------------------------------------------------------|
    | Fetch CRL         | `fetch-crl-boot` and `fetch-crl-cron` | See [CA documentation](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallCertAuth#Start_Stop_fetch_crl_A_quick_gui) for more info |
    | MariaDB           | `mariadb`                             |                                                                                        |
    | Tomcat            | `tomcat`                              |                                                                                        |

Start the services in the order listed and stop them in reverse order. As a reminder, here are common service commands (all run as `root`):

| To...                                   | On EL6, run the command...                  | On EL7, run the command...                      |
| :-------------------------------------- | :----------------------------------------   | :--------------------------------------------   |
| Start a service                         | `service <SERVICE-NAME> start` | `systemctl start <SERVICE-NAME>`   |
| Stop a  service                         | `service <SERVICE-NAME> stop`  | `systemctl stop <SERVICE-NAME>`    |
| Enable a service to start on boot       | `chkconfig <SERVICE-NAME> on`  | `systemctl enable <SERVICE-NAME>`  |
| Disable a service from starting on boot | `chkconfig <SERVICE-NAME> off` | `systemctl disable <SERVICE-NAME>` |

Validating GUMS
---------------

This section is optional, but if you would like to verify that your GUMS installation and configuration are good, consider using some or all of the sections below.

### Connect to the GUMS web page ###

Connect to `https://<HOSTNAME>:8443/gums/` to use your GUMS instance. You must have the certificate that you used for `gums-add-mysql-admin` above loaded in your browser. You should see the GUMS web page load.

!!! note
    Javascript must be enabled in order to make any configuration changes on the web interface.

If you do not see it load, check a few things:

For EL 6:

-   Look for errors in `/var/log/tomcat6/catalina.out` and `/var/log/tomcat6/catalina.err`.
-   Look for errors in `/var/log/tomcat6/trustmanager.log`. There are likely to be CRL errors in this file, this can be ignored unless all your CA's get CRL errors in which case you should check to make sure that your CRL updates are running correctly.

For EL 7:

-   Look for errors in `/var/log/tomcat/catalina.*.log`
-   Look for errors in `/var/log/tomcat/trustmanager.log`. There are likely to be CRL errors in this file, this can be ignored unless all your CA's get CRL errors in which case you should check to make sure that your CRL updates are running correctly.

For all systems:

-   Ensure that you have an http certificate in `/etc/grid-security/http/httpcert.pem` and `/etc/grid-security/http/httpkey.pem`. Make sure it is readable by the `tomcat` user. Permissions should be as follows:

``` console
[root@server]# ls -l /etc/grid-security/http/
total 8
-r--r--r-- 1 tomcat tomcat 1671 Jul 2 15:54 httpcert.pem
-r-------- 1 tomcat tomcat 1675 Jul 2 15:54 httpkey.pem
```

If you change the permissions/ownership, make sure to restart tomcat so that your changes take effect.

### Check accounts ###

After you connect to the GUMS web page, go to the Summary tab to check the configuration. You should see several dozen OSG VOs listed.

In the Account column on the summary page, you will see the local Unix user accounts that these VO users will be mapped to. It is critical that these accounts exist on the gatekeeper and worker nodes at your site. If they do not, there will be errors when users attempt to access your site.

### Update VO members list ###

GUMS contacts each VOMS server to update its knowledge of VO membership every 6 hours. After installing or updating GUMS, you should trigger the update manually by going to the Update VO Members tab, and clicking update.

You can track the progress of the update process by watching a log file.

For EL 6:

    :::console
    [root@server]# tail -f /var/log/tomcat6/gums-service-admin.log

For EL 7:

    :::console
    [root@server]# tail -f /var/log/tomcat/gums-service-admin.log

With so many VOMS servers in the OSG config, several member updates may fail for various reasons (e.g., host down "connect timed out", bad or expired host certificates, etc.). Unfortunately, this situation is normal. Typically, you will see about 5 or 6 failed updates, with the rest succeeding. The update will take a while and then should display any errors that occurred during the updates. To get more details or track the update process in real time, look at `/var/log/gums-service-admin.log`.

### Map a known good user DN ###

1.  Go to Map Grid Identity to Account tab: `https://<HOSTNAME>:8443/gums/map_grid_identity_form.jsp`
2.  Fill in the required info. Service DN means the DN of the host certificate of your CE (see above). Use the DN of a user (probably yourself) who you know belongs to a particular VO. Fill in the VO name in the VOMS FQAN field.
3.  Click "map user". A failed mapping will display "null". A successful mapping will display a UNIX account name.


Miscellaneous Procedures
------------------------

### Forcing GUMS to update the set of users ###

GUMS automatically contacts each VOMS server every 6 hours to update its knowledge of VO membership. To trigger a manual update:

1.  Access the “Update VO Members” tab
2.  Click "Update"
3.  \[Optional:\] Monitor update progress via a log file:

    For EL 6:

        :::console
        [root@server]# tail -f /var/log/tomcat6/gums-service-admin.log

    For EL 7:

        :::console
        [root@server]# tail -f /var/log/tomcat/gums-service-admin.log

With so many VOMS servers in the OSG config, several member updates may fail for various reasons (e.g., host down "connect timed out", bad or expired host certificates, etc.). Unfortunately, this situation is normal.

### Updating the GUMS configuration ###

Periodically, the OSG Grid Operations Center will release an updated template for the GUMS configuration that updates information about an existing VO or adds a new VO. You may get the update as part of a regular update process, or you can force an update by using yum:

``` console

[root@server]# yum update osg-gums-config
```

This step does **not** update your GUMS configuration (`/etc/gums/gums.config`) but will update the template for your configuration (`/etc/gums/gums.config.template`), because RPM cannot merge configuration changes. Instead, use GUMS to merge in the new VO configuration information:

1.  Go to the Merge Configuration tab: `https://<HOSTNAME>:8443/gums/mergeConfiguration.jsp`
2.  Cut and paste the URL of the OSG template into the Configuration URI field

    For the template provided in the RPM, use: `file:///etc/gums/gums.config.template`

    To fetch it directly from the GOC, use `http://repo.grid.iu.edu/pacman/tarballs/vo-version/gums.template`

3.  Click Merge

    You should get a green success message if it has worked, along with a suggestion that you update the VO members

4.  Check the Summary tab to verify the set of VOs you have, as well as their accounts


Troubleshooting
---------------

### Useful Configuration and Log Files ###

Configuration Files

| Service or Process | Configuration File | Description                           |
|:-------------------|:-------------------|:--------------------------------------|
| MySQL              | `/etc/my.cnf`      | MySQL configuration, e.g. server port |
| tomcat (EL6)       | `/etc/tomcat6/`    | Tomcat configuration files            |
| tomcat (EL7)       | `/etc/tomcat/`     | Tomcat configuration files            |

Log files

| Service or Process | Log File                                          | Description                                                                                                                          |
|:-------------------|:--------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------|
| tomcat (EL6)       | `/var/log/tomcat6/catalina.out`                   | This is the Tomcat log file. Problems (and a lot of noise) are reported here.                                                        |
|                    | `/var/log/tomcat6/trustmanager.log`               | The trustmanager handles things related to authentication. Useful errors are sometimes here.                                         |
| tomcat (EL6/EL7)   | `/var/log/tomcat*/catalina.*.log`                 | These are the Tomcat log files. Problems (and a lot of noise) are reported here.                                                     |
| tomcat (EL6/EL7)   | `/var/log/tomcat*/catalina.log`                   | Alternate non-rotated location for tomcat log file. Not the same as `catalina.out`. Problems (and a lot of noise) are reported here. |
|                    | `/var/log/tomcat/trustmanager.log`                | The trustmanager handles things related to authentication. Useful errors are sometimes here.                                         |
| **GUMS** (EL6)     | `/var/log/tomcat6/gums-service-admin.log`         | GUMS outputs error messages related to its operations here.                                                                          |
|                    | `/var/log/tomcat6/gums-service-cybersecurity.log` | GUMS outputs security related messages to this file.                                                                                 |
| **GUMS** (EL7)     | `/var/log/tomcat/gums-service-admin.log`          | GUMS outputs error messages related to its operations here.                                                                          |
|                    | `/var/log/tomcat/gums-service-cybersecurity.log`  | GUMS outputs security related messages to this file.                                                                                 |

|                    |                                             |                                                                           |
|--------------------|---------------------------------------------|---------------------------------------------------------------------------|
| **GUMS** (EL6/EL7) | `/var/log/gums/gums-developer.root.log`     |                                                                           |
|                    | `/var/log/gums/gums-egee-security.root.log` | GUMS may also output some security related messages to this file as well. |
|                    | `/var/log/gums/gums-privilege.root.log`     | GUMS outputs mapping related errors to this file.                         |


How to get Help?
----------------

To get assistance please use the [Help Procedure](../common/help).


References
----------

-   [Official Tomcat 6 documentation](https://tomcat.apache.org/tomcat-6.0-doc)
-   [Official Tomcat 7 documentation](https://tomcat.apache.org/tomcat-7.0-doc)
-   [Official Hibernate documentation](http://hibernate.org/orm/documentation/) (Hibernate is the GUMS database interface)

### Host ###
   For security reasons, it is recommended to install GUMS on a separate host from the CE,
    but it is not necessary

### Users ###

The GUMS installation will create two users unless they exist already:

| User     | Default UID | Comment                                                 |
|:---------|:------------|:--------------------------------------------------------|
| `mysql`  | 27          | Runs the MySQL database server, which GUMS uses         |
| `tomcat` | 91          | Runs the Tomcat web application server, which runs GUMS |

Note that if UIDs 27 and 91 are taken already but not used for the appropriate users, you will experience errors.

### Certificates ###

| Certificate              | Owner, Permissions        | Path                                   |
|:-------------------------|:--------------------------|:---------------------------------------|
| HTTP service certificate | `tomcat:tomcat`, 0644     | `/etc/grid-security/http/httpcert.pem` |
| HTTP service key         | `tomcat:tomcat`, 0600     | `/etc/grid-security/http/httpkey.pem`  |

### Networking ###

GUMS communicates on TCP port 8443; this port must be accessible to the Compute Element and any other hosts that need to authenticate via GUMS.
