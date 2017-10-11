Java Installation Guide for OSG Software
========================================


About This Document
-------------------

Several OSG software components (e.g., [BeStMan](BestmanOverview), [GUMS](InstallGums), [VOMS Admin](InstallVoms), and their dependencies) are written in the [Java programming language](http://en.wikipedia.org/wiki/Java_(programming_language)) and therefore need a Java Virtual Machine (JVM) implementation in which to run. Currently, OSG software is supported under the OpenJDK 7 implementation. Other implementations (such as the Oracle JDK) may also work, but there is considerable risk in using one; for instance, the IBM implementation is known to cause failures in most OSG Java software.

This document explains how to install Java for OSG software components in a way that allows other Java implementations to be present on a system. If you want to remove all other Java implementations besides the supported OpenJDK 7, there are optional instructions for doing so. This document is only about installing Java as a preliminary step for other OSG software installations; other OSG install guides refer to this document when necessary.

---------------

OSG strongly recommends installing OpenJDK 7 as the primary Java implementation on each OSG host that needs Java. Instructions for doing so are below. If you have specific technical reasons to install or use an alternate, unsupported Java implementation, there are separate instructions for doing so. Choose one of the following subsections based on your needs.

### Installing OpenJDK 7 for OSG software

To install OpenJDK 7 as the primary Java implementation on an OSG host:

1.  Remove any conflicting symbolic links from an Oracle JDK installation (will not break Oracle JDK) 

        :::console
        root@host # rm -f /usr/bin/java /usr/bin/javac /usr/bin/javadoc /usr/bin/jar

2.  Install OpenJDK 7 and OSG Java 7 package compatability layer 

        :::console
        root@host # yum install java-1.7.0-openjdk java-1.7.0-openjdk-devel osg-java7-compat osg-java7-devel-compat 
        
    !!! note
        If yum claims that java-1.7.0-openjdk is not available, you likely need to upgrade your operating system. The package *is* available on both EL 5 and EL 6 systems, although only the latest releases of EL 5 systems contain it.

3.  Make OpenJDK the preferred Java runtime environment (JRE) 

        :::console
        root@host # alternatives --config java Select `jre-1.7.0-openjdk`.

4.  Verify that OpenJDK is the preferred JRE 

        :::console
        root@host # java -version The version number should start with `1.7`.

5.  Make OpenJDK the preferred Java development kit (JDK) 

        :::console
        root@host # alternatives --config javac Select `java-1.7.0-openjdk`.

6.  Verify that OpenJDK is the preferred JDK 

        :::console
        root@host # javac -version The version number should start with `1.7`.

### Installing another Java implementation for OSG software

Unless you have specific technical reasons otherwise, you should use OpenJDK 7 for OSG Software; see the installation instructions above and skip this section. To install an alternate Java implementation as the primary Java implementation on an OSG host, use this section.

!!! note
    The IBM Java implementation (`java-1.7.0-ibm` or `java-1.7.1-ibm`) is known to cause severe failures in BeStMan 2 and GUMS (at least).

1.  Install the Java implementation of your choice
2.  Install the OSG Java 7 package compatability layer 


        :::console
        root@host # yum install osg-java7-compat osg-java7-devel-compat
3.  Make your Java implementation the preferred Java runtime environment (JRE) 


        :::console
        root@host # alternatives --config java
4.  Verify that your Java implementation is the preferred JRE 


        :::console
        root@host # java -version The version number should start with `1.7`.
5.  Make your Java implementation the preferred Java development kit (JDK) 


        :::console
        root@host # alternatives --config javac
6.  Verify that your Java implementation is the preferred JDK 


        :::console
        root@host # javac -version The version number should start with `1.7`.

Fixing OpenJDK After Installing Other Software
----------------------------------------------

If you happened to install OSG or other Java-dependent software **before** installing OpenJDK, there may be issues with some stale symbolic links to the Oracle Java implementation. To see whether the issue exists:

1.  Check for an Oracle Java installation 


        :::console
        root@host # rpm -q jdk 
        
    If this command outputs a specific RPM name and version (e.g., `jdk-1.7.0`), then Oracle Java is installed and you should continue with the next step. Otherwise, there are no issues and you are done

2.  Check for stale symbolic links 


        :::console
        root@host # **file /usr/bin/java**

/usr/bin/java: symbolic link to \`/etc/alternatives/java' If the output of the `file` command above differs from the sample output — if `/usr/bin/java` does not exist, if it is not a symbolic link, or if it is a symbolic link to a different path — then your OpenJDK installation has issues and must be fixed; continue with the next repair procedure below. Otherwise, there are no issues and you are done

To fix the OpenJDK installation:

1.  Remove incorrect symbolic links: 

        :::console
        root@host # rm -f /usr/bin/java /usr/bin/javac /usr/bin/javadoc /usr/bin/jar

2.  Reinstall OpenJDK to create the symbolic links: 

        :::console
        root@host # yum reinstall java-1.7.0-openjdk java-1.7.0-openjdk-devel

3.  Make OpenJDK the preferred Java runtime environment (JRE): 

        :::console
        root@host # alternatives --config java Select `jre-1.7.0-openjdk`.

4.  Verify that OpenJDK is the preferred JRE: 

        :::console
        root@host # java -version The version number should start with `1.7`.

5.  Make OpenJDK the preferred Java development kit (JDK): 

        :::console
        root@host # alternatives --config javac Select `java-1.7.0-openjdk`.

6.  Verify that OpenJDK is the preferred JDK: 

        :::console
        root@host # javac -version The version number should start with `1.7`.

Fixing Tomcat
-------------

If you have a pre-existing Tomcat installation, you must ensure that that it is using your preferred Java implementation.

### Fixing Tomcat on an EL6 system

1.  Check if tomcat6 is installed: 

        :::console
        root@host # rpm -q tomcat6 
        
    If the RPM is installed, the command will output the specific RPM name and version. If there is no output: Tomcat is not installed, there is no issue, and you are done

2.  Open `/etc/sysconfig/tomcat6`.
3.  Check if there is a line setting `JAVA_HOME` and that line is uncommented. If so, change that line to: <pre class="file">JAVA\_HOME="/etc/alternatives/jre" If not, then you do not need to do anything.
4.  Do the same check for `/etc/tomcat6/tomcat6.conf`.
5.  Restart the Tomcat service: 


        :::console
        root@host # service tomcat6 restart

### Fixing Tomcat on an EL5 system

1.  Check if tomcat5 is installed: 

        :::console
        root@host # rpm -q tomcat5 
        
    If the RPM is installed, the command will output the specific RPM name and version. If there is no output: Tomcat is not installed, there is no issue, and you are done

2.  Open `/etc/sysconfig/tomcat5`.
3.  Check if there is a line setting `JAVA_HOME` and that line is uncommented. If so, change that line to: <pre class="file">JAVA\_HOME="/etc/alternatives/jre" If not, then you do not need to do anything.
4.  Do the same check for `/etc/tomcat5/tomcat5.conf`.
5.  Restart the Tomcat service: 

        :::console
        root@host # service tomcat5 restart

Fixing BeStMan
--------------

If you have a pre-existing BeStMan installation, you must ensure that it is using your preferred Java implementation.

1.  Check if any bestman2 packages are installed: 

        :::console
        root@host # rpm -qa | grep ^bestman2 

    If any bestman2 RPMs are installed, the command will output the specific names and versions. If there is no output: BeStMan is not installed, there is no issue, and you are done
2.  Open `/etc/sysconfig/bestman2`.
3.  Check if there is a line setting `JAVA_HOME` and that line is uncommented. If so, change that line to: <pre class="file">JAVA\_HOME=/etc/alternatives/java\_sdk If not, then you do not need to do anything.
4.  Restart the BeStMan service: 

        :::console
        root@host # service bestman2 restart

Fixing SSL problems / Disabling SSLv3
-------------------------------------

We have received reports that the latest version of Firefox (39.0) keeps users from being able to access the web UIs of GUMS, Gratia, or VOMS-Admin. Attempts to access will result in this error: 

          SSL received a weak ephemeral Diffie-Hellman key in Server Key Exchange handshake message.
          (Error code: ssl_error_weak_server_ephemeral_dh_key)

This affects all known versions of OpenJDK 1.7.0.   The recommended workaround for this is server-side:

1.  Find the file: `/usr/lib/jvm/java-1.7.0-openjdk-1.7.0-*/jre/lib/security/java.security`
2.  Find the setting called `jdk.tls.disabledAlgorithms` (or add it if missing)
3.  If not already present, add `SSLv3` and `DHE` to the list
4.  If using EL6, run `service tomcat6 restart`. If using EL7, run `service tomcat restart`

  This will cause the webapp to use a different algorithm, which Firefox will not complain about.   We do not have an ETA for when a future version of OpenJDK 1.7.0 will contain a fix. OpenJDK 1.8.0 does not have this problem, but since we have not verified that it works with OSG software, we do not recommend switching to that yet. 

Optional: Preventing Oracle JDK From Being Installed
----------------------------------------------------

To prevent Oracle's java implementation from being installed, you can configure yum to exclude it from all future installs: Edit `/etc/yum.conf` and add the line `exclude=jdk java-1.6.0-sun-compat` to the end of the file. If a line starting with `exclude=` already exists in `/etc/yum.conf`, then add `jdk` and `java-1.6.0-sun-compat` to the end of that line, separated by spaces.

Getting Help with Java and OSG Software
---------------------------------------

For further assistance please use [this page](Documentation/Release3.HelpProcedure).

