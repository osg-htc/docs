GlideinWMS VO Frontend Installation
===================================

This document describes how to install the Glidein Workflow Managment System
(GlideinWMS) VO Frontend for use with the OSG glidein factory. This software is
the minimum requirement for a VO to use glideinWMS.

This document assumes expertise with Condor and familiarity with the glideinWMS
software. It **does not** cover anything but the simplest possible install.
Please consult the [Glidein WMS reference
documentation](http://www.uscms.org/SoftwareComputing/Grid/WMS/glideinWMS/doc.prd/install.html)
for advanced topics, including non-`root`, non-RPM-based installation.

This document covers three components of the GlideinWMS a VO needs to install:

-   **User Pool Collectors**: A set of `condor_collector` processes. Pilots submitted by the factory will join to one of these collectors to form a Condor pool.
-   **User Pool Schedd**: A `condor_schedd`. Users may submit Condor vanilla universe jobs to this schedd; it will run jobs in the Condor pool formed by the **User Pool Collectors**.
-   **Glidein Frontend**: The frontend will periodically query the **User Pool Schedd** to determine the desired number of running job slots. If necessary, it will request the factory to launch additional pilots.

This guide covers installation of all three components on the same host: it is
designed for small to medium VOs (see the Hardware Requirements below). Given a
significant, large host, we have been able to scale the single-host install to
20,000 running jobs.

![GlideinWMS Architecture](/images/simple_diagram.png)


Before Starting
---------------

Before starting the installation process, consider the following points (consulting [the Reference section below](#reference) as needed):

-   **User IDs:** If they do not exist already, the installation will create the Linux users `apache` (UID 48), `condor`, `frontend`, and `gratia`
-   **Network:** The VO frontend must have reliable network connectivity, be on the public internet (no NAT), and preferably with no firewalls. Each running pilot requires 5 outgoing TCP ports. Incoming TCP ports 9618 to 9660 must be open.
-   **Host choice**: The Glidein WMS VO Frontend has the following hardware requirements for a production host:
    -   **CPU**: Four cores, preferably no more than 2 years old.
    -   **RAM**: 3GB plus 2MB per running job. For example, to sustain 2000 running jobs, a host with 5GB is needed.
    -   **Disk**: 30GB will be sufficient for all the binaries, config and log files related to glideinWMS. As this will be an interactive submit host, have enough disk space for your users' jobs. 

As with all OSG software installations, there are some one-time (per host) steps to prepare in advance:

- Ensure the host has a [supported operating system](/release/supported_platforms)
- Obtain root access to the host
- Prepare the [required Yum repositories](/common/yum)
- Install [CA certificates](/common/ca)

### Credentials and Proxies

The VO Frontend will use two credentials in its interactions with the the other
glideinWMS services. At this time, these will be proxy files.

1. the %GREEN%VO Frontend proxy%ENDCOLOR% (used to authenticate with the other glideinWMS services).
2. one or more glideinWMS %RED%pilot proxies%ENDCOLOR% (used/delegated to the factory services and submitted on the glideinWMS pilot jobs).

The %GREEN%VO Frontend proxy%ENDCOLOR% and the %RED% pilot proxy%ENDCOLOR% can
be the same. By default, the VO Frontend will run as user `frontend` (UID is
machine dependent) so these proxies must be owned by the user `frontend`.

#### VO Frontend proxy

The use of a service certificate is recommended. Then you create a proxy from
the certificate as explained in the [proxy configuration
section](#proxy-configuration). This can be a plain grid proxy (from
`grid-proxy-init`), no VO extensions are required.

**You must give the Factory operations team the DN of this proxy when you
initially setup the frontend and each time the DN changes**.

#### Pilot proxies

This proxy is used by the factory to submit the glideinWMS pilot jobs.
Therefore, they must be authorized to access to the CEs (factory entry points)
where jobs are submitted. There is no need to notify the Factory operation about
the DN of this proxy (neither at the initial registration nor for subsequent
changes). This second proxy has no special requirement or controls added by the
factory but will probably require VO attributes because of the CEs: if you are
able to use this proxy to submit jobs to the CEs where the Factory runs
glideinWMS pilots for you, then the proxy is OK. You can test your proxy using
`globusrun` or HTCondor-G

To check the important information about a pem certificate you can use: `openssl
x509 -in /etc/grid-security/hostcert.pem -subject -issuer -dates -noout`. You
will need that to find out information for the configuration files and the
request to the GlideinWMS factory.

### OSG Factory access

Before installing the Glidein WMS VO Frontend you need the information about a [Glidein Factory](http://www.uscms.org/SoftwareComputing/Grid/WMS/glideinWMS/doc.prd/factory/index.html) that you can access:

1. (recommended) OSG is managing a factory at UCSD and one at GOC and you can request access to them
2. You have another Glidein Factory that you can access
3. You [install your own Glidein Factory](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/InstallGlideinWMSFactory)

To request access to the OSG Glidein Factory at UCSD you have to send an email to <osg-gfactory-support@physics.ucsd.edu> providing:

1. Your Name
2. The VO that is utilizing the VO Frontend
3. The DN of the proxy you will use to communicate with the Factory (VO Frontend DN, e.g. the host certificate subject if you follow the [proxy configuration section](#proxy-configuration))
4. You can propose a security name that will have to be confirmed/changed by the Factory managers (see below)
5. A list of sites where you want to run:

- Your VO must be supported on those sites
- You can provide a list or piggy back on existing lists, e.g. all the sites supported for the VO. Check with the Factory managers
- You can start with one single site

In the reply from the OSG Factory managers you will receive some information needed for the configuration of your VO Frontend

1. The exact spelling and capitalization of your VO name. Sometime is different from what is commonly used, e.g. OSG VO is "OSGVO".
2. The host of the Factory Collector: `gfactory-1.t2.ucsd.edu`
3. The DN os the factory, e.g. `/DC=org/DC=doegrids/OU=Services/CN=gfactory-1.t2.ucsd.edu`
4. The factory identity, e.g.: `gfactory@gfactory-1.t2.ucsd.edu`
5. The identity on the factory you will be mapped to. Something like: `username@gfactory-1.t2.ucsd.edu`
6. Your security name. A unique name, usually containing your VO name: `My_SecName`
7. A string to add in the main factory query\_expr in the frontend configuration, e.g. `stringListMember("%RED%VO%ENDCOLOR%",GLIDEIN_Supported_VOs)`. From there you get the correct name of the VO (above in this list).

Installing GlideinWMS Frontend
------------------------------

### Installing HTCondor

If you don't have HTCondor already installed, you can install the HTCondor RPM
from the OSG repository:

``` console
root@host # yum install condor.x86_64
```

If you already have installed HTCondor using a tarball or a source other than
the OSG ROM, you will need to install the empty-condor RPM:

``` console
root@host # yum install empty-condor --enablerepo=osg-empty
```

### Installing the VO Frontend RPM


Install the RPM and dependencies (be prepared for a lot of dependencies).

``` console
root@host # yum install glideinwms-vofrontend
```

This will install the current production release verified and tested by OSG with
default condor configuration. This command will install the glideinwms
vofrontend, condor, the OSG client, and all the required dependencies all on one
node.

If you wish to install a different version of GlideinWMS, add the "--enablerepo"
argument to the command as follows:

-   `yum install --enablerepo=osg-testing glideinwms-vofrontend`: The most recent production release, still in testing phase. This will usually match the current tarball version on the GlideinWMS home page. (The osg-release production version may lag behind the tarball release by a few weeks as it is verified and packaged by OSG). Note that this will also take the osg-testing versions of all dependencies as well.
-   `yum install --enablerepo=osg-upcoming glideinwms-vofrontend`: The most recent development series release, i.e. version 3.3 release. This has newer features such as cloud submission support, but is less tested.

Note that these commands will install default condor configurations with all
services on one node.

### Installing GlideinWMS Frontend on Multiple Nodes (Advanced) 

For advanced users expecting heavy usage on their submit node, you may want to
consider splitting the user collector, user submit, and vo frontend
services. This can be doing using the following three commands (on different
machines):

``` console
root@host # yum install glideinwms-vofrontend-standalone
root@host # yum install glideinwms-usercollector
root@host # yum install glideinwms-userschedd
```

In addition, you will need to perform the following steps:

- On the vofrontend and userschedd, modify `CONDOR_HOST` to point to your usercollector. This is in `/etc/condor/config.d/00_gwms_general.config`. You can also override this value by placing it in a new config file. (For instance, `/etc/condor/config.d/99_local_custom.config` to avoid rpmsave/rpmnew conflicts on upgrades).
- In `/etc/condor/certs/condor_mapfile`, you will need to all DNs for each machine (userschedd, usercollector, vofrontend). Take great care to escape all special characters. Alternatively, you can use the `glidecondor_addDN` to add these values.
- In the `/etc/gwms-frontend/frontend.xml` file, change the schedd locations to match the correct server. Also change the collectors tags at the bottom of the file. More details on frontend xml are in the following sections.

### Upgrading the GlideinWMS Frontend

If you have a working installation of glideinwms-frontend you can just upgrade
the frontend rpms and skip the most of the configuration procedure below. These
general upgrade instructions apply when upgrading the glideinwms-frontend rpm
within same major versions.

``` console
# %RED% Update the glideinwms-vofrontend packages%ENDCOLOR%
root@host # yum update glideinwms\*
# %RED% Update the scripts in the working directory to the latest one%ENDCOLOR%
# %RED% For RHEL 7, CentOS 7, and SL7%ENDCOLOR%
root@host # /usr/sbin/gwms-frontend upgrade
# %RED% For RHEL 6, CentOS 6, and SL6%ENDCOLOR%
root@host # service gwms-frontend upgrade
# %RED% Restart HTCondor because the configuration may be different%ENDCOLOR%
root@host # service condor restart
```

!!! note
    When upgrading to GlideinWMS 3.2.7 the second schedd is removed from the default configuration. For a smooth transition:

    1. remove from **`/etc/gwms-frontend/frontend.xml`** the second schedd (the line containing **`schedd_jobs2@YOUR_HOST`**)
    2. reconfigure the frontend (`service gwms-frontend reconfig`)
    3. restart HTCondor (`service condor restart`)

Configuring GlideinWMS Frontend
--------------------------------

After installing the RPM, you need to configure the components of the glideinWMS VO Frontend:

1.  Edit Frontend configuration options
2.  Edit Condor configuration options
3.  Create a Condor grid map file
4.  Reconfigure and Start frontend

#### Configuring the Frontend

The VO Frontend configuration file is `/etc/gwms-frontend/frontend.xml`. The next steps will describe each line that you will need to edit if you are using the OSG Factory at UCSD. The portions to edit are highlighted in red font. If you are using a different Factory more changes are necessary, please check the VO Frontend configuration reference.

1. The VO you are affiliated with. This will identify those CEs that the glideinWMS pilot will be authorized to run on using the %RED%pilot proxy%ENDCOLOR% described previously in the this [section](#credentials-and-proxies). Sometimes the whole `query_expr` is provided to you by the factory (see Factory access above):

        :::file
        <factory query_expr='((stringListMember("VO", GLIDEIN_Supported_VOs)))'>

2. Factory collector information. The `username` that you are assigned by the factory (also called the identity you will be mapped to on the factory, see above) . Note that if you are using a factory different than the production factory, you will have to change also `DN`, `factory_identity` and `node` attributes. (refer to the information provided to you by the factory operator):

        :::file
        <collector DN="/DC=org/DC=doegrids/OU=Services/CN=gfactory-1.t2.ucsd.edu"
                   comment="Define factory collector globally for simplicity"
                   factory_identity="gfactory@gfactory-1.t2.ucsd.edu"
                   my_identity="username@gfactory-1.t2.ucsd.edu"
                   node="gfactory-1.t2.ucsd.edu"/>

3. Frontend security information.

    - The `classad_proxy` in the security entry is the location of the VO Frontend proxy described previously [here](#credentials-and-proxies).
    - The `proxy_DN` is the DN of the `classad_proxy` above.
    - The `security_name` identifies this VO Frontend to the the Factory, It is provided by the factory operator.
    - The `absfname` in the credential (or proxy in v 2.x) entry is the location of the glideinWMS %RED%`pilot`%ENDCOLOR% proxy described in the requirements section [here](#credentials-and-proxies). There can be multiple pilot proxies, or even other kind of keys (e.g. if you use cloud resources). ***The type and trust_domain of the credential must match respectively auth_method and trust_domain used in the entry definition in the factory. If there is no match, between these two attributes in one of the credentials and some entry in one of the factories, then this frontend cannot trigger glideins.***
Both the `classad_proxy` and `absfname` files should be owned by `frontend` user.


            :::file
            # These lines are from the configuration of v 3.x
            <security classad_proxy="/tmp/vo_proxy" proxy_DN="DN of vo_proxy"
                  proxy_selection_plugin="ProxyAll"
                  security_name="The security name, this is used by factory"
                  sym_key="aes_256_cbc">
                  <credentials>
                    <credential absfname="/tmp/pilot_proxy" security_class="frontend"
                    trust_domain="OSG" type="grid_proxy"/>
                  </credentials>
            </security>

4. The schedd information.

    - The `DN` of the %GREEN%VO Frontend Proxy%ENDCOLOR% described previously [here](#credentials-and-proxies).
    - The `fullname` attribute is the fully qualified domain name of the host where you installed the VO Frontend (`hostname --fqdn`).
    A secondary schedd is optional. You will need to delete the secondary schedd line if you are not using it. Multiple schedds allow the frontend to service requests from multiple submit hosts.


            :::file
            <schedds>
              <schedd DN="Cert DN used by the schedd at fullname:"
                    fullname="Hostname of the schedd"/>
               <schedd DN="Cert DN used by the second Schedd at fullname:"
                     fullname="schedd name@Hostname of second schedd"/>
            </schedds>


5. The User Collector information.

     - The `DN` of the %GREEN%VO Frontend Proxy%ENDCOLOR% described previously [here](#credentials-and-proxies).
     - The `node` attribute is the full hostname of the collectors (`hostname --fqdn`) and port
     - The `secondary` attribute indicates whether the element is for the primary or secondary collectors (True/False).
     The default Condor configuration of the VO Frontend starts multiple Collector processes on the host (`/etc/condor/config.d/11_gwms_secondary_collectors.config`). The `DN` and `hostname` on the first line are the hostname and the host certificate of the VO Frontend. The `DN` and `hostname` on the second line are the same as the ones in the first one. The hostname (e.g. hostname.domain.tld) is filled automatically during the installation. The secondary collector ports can be defined as a range, e.g., 9620-9660).


            :::file
            <collector DN="DN of main collector"
                   node="hostname.domain.tld:9618" secondary="False"/>
            <collector DN="DN of secondary collectors (usually same as DN in line above)"
                   node="hostname.domain.tld:9620-9660" secondary="True"/>

!!! warning
    The Frontend configuration includes many knobs, some of which are conflicting with a RPM installation where there is only one version of the Frontend installed and it uses well known paths.     Do not change the following in the Frontend configuration (you must leave the default values coming with the RPM installation):

       - frontend_versioning='False' (in the first line of XML, versioning is useful to install multiple tarball versions)
       - work base_dir must be /var/lib/gwms-frontend/vofrontend/ (other scripts like /etc/init.d/gwms-frontend count on that value)

#### Using a Different Factory

The configuration above points to the OSG production Factory. If you are using a different Factory, then you have to:

1.  replace `gfactory@gfactory-1.t2.ucsd.edu` and `gfactory-1.t2.ucsd.edu` with the correct values for your factory. And control also that the name used for the frontend () matches.
2.  make sure that the factory is advertising the attributes used in the factory query expression (`query_expr`).

### Configuring HTCondor

The HTCondor configuration for the frontend is placed in `/etc/condor/config.d`.

- 00_gwms_general.config
- 01_gwms_collectors.config
- 02_gwms_schedds.config
- 03_gwms_local.config
- 11_gwms_secondary_collectors.config
- 90_gwms_dns.config


For most installations create a new file named `/etc/condor/config.d/92_local_condor.config`

#### Using other HTCondor RPMs, e.g. UW Madison HTCondor RPM

The above procedure will work if you are using the OSG HTCondor RPMS. You can
verify that you used the OSG HTCondor RPM by using `yum list condor`. The
version name should include "osg", e.g. `7.8.6-3.osg.el5`.

If you are using the UW Madison Condor RPMS, be aware of the following changes:

-   This Condor RPM uses a file `/etc/condor/condor_config.local` to add your local machine slot to the user pool.
-   If you want to disable this behavior (recommended), you should blank out that file or comment out the line in `/etc/condor/condor_config` for LOCAL\_CONFIG\_FILE. (Make sure that LOCAL\_CONFIG\_DIR is set to `/etc/condor/config.d`)
-   Note that the variable LOCAL\_DIR is set differently in UW Madison and OSG RPMs. This should not cause any more problems in the glideinwms RPMs, but please take note if you use this variable in your job submissions or other customizations.

In general if you are using a non OSG RPM or if you added custom configuration
files for HTCondor please check the order of the configuration files:

``` console
root@host # condor_config_val -config
Configuration source:
    /etc/condor/condor_config
Local configuration sources:
    /etc/condor/config.d/00_gwms_general.config
    /etc/condor/config.d/01_gwms_collectors.config
    /etc/condor/config.d/02_gwms_schedds.config
    /etc/condor/config.d/03_gwms_local.config
    /etc/condor/config.d/11_gwms_secondary_collectors.config
    /etc/condor/config.d/90_gwms_dns.config
    /etc/condor/condor_config.local
```

If, like in the example above, the GlideinWMS configuration files are not the
last ones in the list please verify that important configuration options have
not been overridden by the other configuration files.

#### Verifying your HTCondor configuration

1. The glideinWMS configuration files in `/etc/condor/config.d` should be the last ones in the list. If not, please verify that important configuration options have not been overridden by the other configuration files.

2. Verify the alll the expected HTCondor daemons are running:

        :::console
        root@host # condor_config_val -verbose DAEMON_LIST DAEMON_LIST: MASTER, COLLECTOR, NEGOTIATOR, SCHEDD, SHARED_PORT, COLLECTOR0
        COLLECTOR1 COLLECTOR2 COLLECTOR3 COLLECTOR4 COLLECTOR5 COLLECTOR6 COLLECTOR7 COLLECTOR8 COLLECTOR9 COLLECTOR10 , COLLECTOR11, COLLECTOR12,
        COLLECTOR13, COLLECTOR14, COLLECTOR15, COLLECTOR16, COLLECTOR17, COLLECTOR18, COLLECTOR19, COLLECTOR20, COLLECTOR21, COLLECTOR22, COLLECTOR23,
        COLLECTOR24, COLLECTOR25, COLLECTOR26, COLLECTOR27, COLLECTOR28, COLLECTOR29, COLLECTOR30, COLLECTOR31, COLLECTOR32, COLLECTOR33, COLLECTOR34,
        COLLECTOR35, COLLECTOR36, COLLECTOR37, COLLECTOR38, COLLECTOR39, COLLECTOR40
        Defined in '/etc/condor/config.d/11_gwms_secondary_collectors.config', line 193.

If you don't see all the collectors. shared port and the two schedd, then the
configuration must be corrected. There should be ***no*** `startd` daemons
listed.

#### Creating a Condor grid mapfile.

The Condor grid mapfile (`/etc/condor/certs/condor_mapfile`) is used for
authentication between the glideinWMS pilot running on a remote worker node, and
the local collector. Condor uses the mapfile to map certificates to pseudo-users
on the local machine. It is important that you map the DN's of:

- %RED%Each schedd proxy%ENDCOLOR%: The `DN` of each schedd that the frontend talks to. Specified in the frontend.xml schedd element `DN` attribute:

        :::file
        <schedds>
          <schedd DN="/DC=org/DC=doegrids/OU=Services/CN=YOUR_HOST" fullname="YOUR_HOST"/>
          <schedd DN="/DC=org/DC=doegrids/OU=Services/CN=YOUR_HOST" fullname="schedd_jobs2@YOUR_HOST"/>
        </schedds>

- %GREEN%Frontend proxy%ENDCOLOR%: The DN of the proxy that the frontend uses to communicate with the other glideinWMS services. Specified in the frontend.xml security element `proxy_DN` attribute:

        :::file
        <security classad_proxy="/tmp/vo_proxy" proxy_DN="DN of vo_proxy" ....

- %RED%Each pilot proxy%ENDCOLOR% The DN of __each__ proxy that the frontend forwards to the factory to use with the glideinWMS pilots.  This allows the !glideinWMs pilot jobs to communicate with the User Collector. Specified in the frontend.xml proxy `absfname` attribute (you need to specify the `DN` of each of those proxies:

        :::file
        <security ....
        <proxies>
           < proxy absfname="/tmp/vo_proxy" ....
           :
        </proxies>

Below is an example mapfile, by default found in
`/etc/condor/certs/condor_mapfile`. In this example there are lines for each of
services mentioned above.

!!! note
    The `example_of_format` entry as each DN should use this format for security purposes.

``` file
GSI "%RED%DN of schedd proxy%ENDCOLOR%" schedd
GSI "%GREEN%DN of frontend proxy%ENDCOLOR%" frontend
GSI "%RED%DN of pilot proxy%ENDCOLOR%$" pilot_proxy
GSI "^\/DC\=org\/DC\=doegrids\/OU\=Services\/CN\=personal\-submit\-host2\.mydomain\.edu$" %RED%<example_of_format>%ENDCOLOR%
GSI (.*) anonymous
FS (.*) \1
```

#### Restarting Condor

After configuring condor, be sure to restart condor:

    :::console
    root@host # service condor restart

### Proxy Configuration

There are 2 types of (or purposes for) proxies required for the VO Frontend: 1
the %GREEN%VO Frontend proxy%ENDCOLOR% (used to authenticate with the other
glideinWMS services) 1 one or more glideinWMS %GREEN%pilot proxies%ENDCOLOR%
(used/delegated to the factory services and submitted on the glideinWMS pilot
jobs) The %GREEN%VO Frontend proxy%ENDCOLOR% and the %GREEN%pilot
proxy%ENDCOLOR% can be the same. By default, the VO Frontend will run as user
`frontend` (UID is machine dependent) so these proxies must be owned by the user
`frontend`.

#### Manual proxy renewal

%GREEN%VO Frontend proxy%ENDCOLOR%
The VO Frontend Proxy is used for communicating with the other glideinWMS
services (Factory, User Collector and Schedd/Submit services). Create the proxy
using the glidenWMS VO Frontend Host (or Service) cert and change ownership to
the frontend user.

``` console
root@host # voms-proxy-init-valid %RED%<hours_valid>%ENDCOLOR% \
-cert /etc/grid-security/hostcert.pem \
-key /etc/grid-security/hostkey.pem \
-out %GREEN%/tmp/vofe_proxy%ENDCOLOR%
root@host # chown frontend %GREEN%/tmp/vofe_proxy%ENDCOLOR%
```    

%RED%Pilot proxy%ENDCOLOR%
The pilot proxy is used on the glideinWMS pilot jobs submitted to the CEs.
Create the proxy using the %RED%pilot certificate%ENDCOLOR% and change ownership
to the frontend user.

``` console
root@host # voms-proxy-init -valid %RED%<hours_valid>%ENDCOLOR% \
-voms <vo>
-cert <pilot_cert> \
-key <pilot_key> \
-out %RED%/tmp/pilot_proxy%ENDCOLOR%
root@host # chown frontend %RED%/tmp/pilot_proxy%ENDCOLOR%
```

!!! warning
    **Proxies do expire.** You can extend the validity by using a longer time interval, e.g. `-valid 3000:0`. This sequence of commands will need to be renewed when the proxy expires or the machine reboots (if /tmp is used only).

Make sure that this location is specified correctly in the `frontend.xml`
described in the [Configuring the Frontend](#configuring-the-frontend) section.

You may want to automate the procedure above (or part of it) by writing a script
and adding it to crontab.

#### Example of automatic proxy renewal

This example (user provided) uses the script
[make-proxy.sh](../other/make-proxy.sh) attached to this document. You still
need to do some prep-work but this can be done only once a year and the script
will warn you with an email.

Preparation for the %GREEN%VO Frontend proxy%ENDCOLOR%. You'll have to redo this
each time the Host (or Service) certificate and key are renewed:

1. Copy the Host (or Service) certificate and key

        :::console
        root@host # cp /etc/grid-security/hostcert.pem /etc/grid-security/hostkey.pem /var/lib/gwms-frontend/
        

2. Change ownership and permission of the certificate and key

        :::console
        root@host # chown frontend: /var/lib/gwms-frontend/host**.pem
        root@host # chmod 0600 /var/lib/gwms-frontend/host**.pem
         

Preparation for the %RED% pilot proxy%ENDCOLOR%. You'll have to redo this for
each new or renewed pilot cert.

1. Create the proxy using the pilot certificate/key (as the user/submitter)

        :::console
        root@host # grid-proxy-init -valid 8800:0 -out /tmp/tmp_proxy
        

2. Copy the proxy to the correct name and change ownership and permissions (as root):

        :::console
        root@host # cp /tmp/tmp_proxy /var/lib/gwms-frontend/vofe_base_gi_delegated_proxy
        root@host # chown frontend: /var/lib/gwms-frontend/vofe_base_gi_delegated_proxy
        root@host # chmod 0600 /var/lib/gwms-frontend/vofe_base_gi_delegated_proxy
        root@host # rm /tmp/tmp_proxy
        

Configure the script for the %GREEN%VO Frontend proxy%ENDCOLOR%

1. Download the [attached script](../other/make-proxy.sh) (the latest one is [Here on Github](https://raw.github.com/DHTC-Tools/OSG-Connect/master/gwms-frontend/make-proxy.sh)) and save it as `/var/lib/gwms-frontend/make-frontend-proxy.sh`, make sure that it is executable.

2. Edit the VARIABLES section to look something like (replace your email, host name and the paths that are different in your setup - the comments in the script will help):

        :::file
        SETUP_FILE=""
        CERT_FILE="/var/lib/gwms-frontend/hostcert.pem"
        KEY_FILE="/var/lib/gwms-frontend/hostkey.pem"
        IN_NAME="/var/lib/gwms-frontend/frontend_base_proxy"
        OUT_NAME="/tmp/vofe_proxy"
        OWNER_EMAIL="%RED%<your@email_here>%ENDCOLOR%"
        PROXY_DESCRIPTION="VO Fronted on %RED%<hostname>%ENDCOLOR%"
        VOMS_OPTION=""
        

Configure the script for the %RED%pilot proxy%ENDCOLOR%:

1.  Download the [attached script](../other/make-proxy.sh) (the latest one is [Here on Github](https://raw.github.com/DHTC-Tools/OSG-Connect/master/gwms-frontend/make-proxy.sh)) and save it as `/var/lib/gwms-frontend/make-pilot-proxy.sh`, make sure that it is executable.

2.  Edit the VARIABLES section to look something like (replace your email, host name and the paths that are different in your setup - the comments in the script will help):

        :::file
        SETUP_FILE=""
        CERT_FILE=""
        KEY_FILE=""
        IN_NAME="/var/lib/gwms-frontend/vofe_base_gi_delegated_proxy"
        OUT_NAME="/tmp/vofe_gi_delegated_proxy"
        OWNER_EMAIL="%RED%<your@email_here>%ENDCOLOR%"
        PROXY_DESCRIPTION="VO Fronted glidein delegated on %RED%<hostname>%ENDCOLOR%"
        VOMS_OPTION="osg:/osg"
         

Before adding the scripts to the crontab I'd recommend to test them manually
once to make sure that there are no errors. As user `frontend` run the scripts
(you can also use **`sh -x`** to debug them):

    :::console
    /var/lib/gwms-frontend/make-frontend-proxy.sh --no-voms-proxy /var/lib/gwms-frontend/make-pilot-proxy.sh
    

Add the scripts to the crontab of the user `frontend` with `crontab -e`:

    :::file
    10 * * * * /var/lib/gwms-frontend/make-frontend-proxy.sh --no-voms-proxy
    10 * * * * /var/lib/gwms-frontend/make-pilot-proxy.sh
     

An additional script like
[make-proxy-control.sh](../other/make-proxy-control.sh) (the latest one is [Here
on
Github](https://raw.github.com/DHTC-Tools/OSG-Connect/master/gwms-frontend/make-proxy-control.sh))
can be used for an independent verification of the proxies. If you like,
download it, fix the variables and add it to the crontab like the other two.

### Reconfigure and verify installation

!!! warning
    In order to use the frontend, first you must reconfigure and upgrade it.
        
        :::console
        # %RED% For RHEL 6, CentOS 6, and SL6%ENDCOLOR%
        root@host # service gwms-frontend reconfig
        root@host # service gwms-frontend upgrade

        # %RED% For RHEL 7, CentOS 7, and SL7%ENDCOLOR%
        root@host # /usr/sbin/gwms-frontend reconfig
        root@host # /usr/sbin/gwms-frontend upgrade

After this initial reconfiguring/upgrading, you can start the frontend:

```console
# %RED% For RHEL 6, CentOS 6, and SL6%ENDCOLOR%
root@host # service gwms-frontend start
# %RED% For RHEL 7, CentOS 7, and SL7%ENDCOLOR%
root@host # systemctl start gwms-frontend
```

### Adding Gratia Accounting and a Local Monitoring Page on a Production Server

You must report to Gratia if you are running on OSG more than a few test jobs.

[ProbeConfigGlideinWMS](https://twiki.opensciencegrid.org/bin/view/Accounting/ProbeConfigGlideinWMS)
explains how to instal and configure the HTCondor Gratia probe. If you are on a
Campus Grid without x509 certificates pay attention to the [Users without
Certificates
part](https://twiki.opensciencegrid.org/bin/view/Accounting/ProbeConfigGlideinWMS#Users_without_Certificates)
in the Unusual Use Cases section.

### Optional Configuration

The following configuration steps are optional and will likely not be required
for setting up a small site. If you do not need any of the following special
configurations, skip to [the section on service
activation/deactivation](#service-activation-and-deactivation).

- [Allow users to specify where their jobs run](#allow-users-to-specify-where-their-jobs-run)
- [Creating a group to test configuration changes](#creating-a-group-for-testing-configuration-changes)

#### Allowing users to specify where their jobs run

In order to allow users to specify the sites at which their jobs want to run (or
to test a specific site), a frontend can be configured to match on
`DESIRED_Sites` or ignore it if not specified. Modify
`/etc/gwms-frontend/frontend.xml` using the following instructions:

1. In the frontend's global `<match>` stanza, set the `match_expr`:

        :::file
        '((job.get("DESIRED_Sites","nosite")=="nosite") or (glidein["attrs"]["GLIDEIN_Site"] in job.get("DESIRED_Sites","nosite").split(",")))'
        

2. In the same `<match>` stanza, set the `start_expr`:

        :::file
        '(DESIRED_Sites=?=undefined || stringListMember(GLIDEIN_Site,DESIRED_Sites,","))
        

3. Add the `DESIRED_Sites` attribute to the match attributes list:

        ::file
        <match_attrs>
           <match_attr name="DESIRED_Sites" type="string"/>
        </match_attrs>
        

4. Reconfigure the Frontend:

        :::console
        root@host # /etc/init.d/gwms-frontend reconfig
        

#### Creating a group for testing configuration changes

To perform configuration changes without impacting production the recommended
way is to create an ITB group in `/etc/gwms-frontend/frontend.xml`. This
groupwould only match jobs that have the `+is_itb=True` ClassAd.

1. Create a [group](http://glideinwms.fnal.gov/doc.prd/frontend/configuration.html#management) named itb.

2. Set the group's `start_expr` so that the group's glideins will only match user jobs with `+is_itb=True`:

        :::file
        <match match_expr="True" start_expr="(is_itb)">
        

3. Set the `factory_query_expr` so that this group only communicates with ITB factories:

        :::file
        <factory query_expr='FactoryType=?="itb"'>
        

4. Set the group's `collector` stanza to reference the ITB factory, replacing `username@gfactory-1.t2.ucsd.edu` with your factory identity:

        :::file
        <collector DN="/DC=com/DC=DigiCert-Grid/O=Open Science Grid/OU=Services/CN=glidein-itb.grid.iu.edu" \
                  factory_identity="gfactory@glidein-itb.grid.iu.edu" \
                  my_identity="username@gfactory-1.t2.ucsd.edu" \
                  node="glidein-itb.grid.iu.edu"/>
        

5. Set the job `query_expr` so that only ITB jobs appear in `condor_q`:

        :::file
        <job query_expr="(!isUndefined(is_itb) && is_itb)">
        

6. Reconfigure the Frontend:

        :::file
        /etc/init.d/gwms-frontend reconfig
        


Managing GlideinWMS Services
----------------------------

The scripts updating your CA and CRLs plus three frontend services need to be running:

1. You need to fetch the latest CA Certificate Revocation Lists (CRLs) and you should enable the fetch-crl service to keep the CRLs up to date:

        :::console
        # %RED% For RHEL 6, CentOS 6, and SL6, or OSG 3 _older_ than 3.1.15%ENDCOLOR%
        root@host # /usr/sbin/fetch-crl   # This fetches the CRLs
        root@host # /sbin/service fetch-crl-boot start
        root@host # /sbin/service fetch-crl-cron start
        # %RED% For RHEL 7, CentOS 7, and SL7 %ENDCOLOR%
        root@host # /usr/sbin/fetch-crl   # This fetches the CRLs
        root@host # systemctl start fetch-crl-boot
        root@host # systemctl start fetch-crl-cron
        

2.  HTCondor, httpd, VO Frontend

        :::console
        # %RED%For RHEL 6, CentOS 6, and SL6%ENDCOLOR%
        root@host # service condor start
        root@host # service httpd start
        root@host # service gwms-frontend start
        # %RED% For RHEL 7, CentOS 7, and SL7%ENDCOLOR%
        root@host # systemctl start condor
        root@host # systemctl start gwms-frontend
        

!!! note
    Once you successfully start using the frontend service, each time you change the configuration or want to upgrade, you need to run the following commands

        :::console
        # %RED% For RHEL 6, CentOS 6, and SL6%ENDCOLOR%
        root@host # service gwms-frontend reconfig
        # %RED% And if you change also some code%ENDCOLOR%
        root@host # service gwms-frontend upgrade
        

        # %RED% But the situation is a bit more complicated in RHEL 7, CentOS 7, and SL7 due to systemd restrictions%ENDCOLOR%
        # %GREEN% For reconfig:%ENDCOLOR%
        A. %RED% when the frontend is running%ENDCOLOR%
        A.1 %RED% without any additional options%ENDCOLOR%
        root@host # /usr/sbin/gwms-frontend reconfig%ENDCOLOR%
        or
        root@host # systemctl reload gwms-frontend

        A.2 %RED% if you want to give additional options %ENDCOLOR%
        systemctl stop gwms-frontend
        /usr/sbin/gwms-frontend reconfig "and your options"
        systemctl start gwms-frontend

        B. %RED% when the frontend is NOT running %ENDCOLOR%
        root@host # /usr/sbin/gwms-frontend reconfig ("and your options")

        $ %GREEN%For upgrade:%ENDCOLOR%
        A. %RED% when the frontend is running %ENDCOLOR%
        systemctl stop gwms-frontend
        /usr/sbin/gwms-frontend upgrade ("and your options if any")
        systemctl start gwms-frontend

        B. %RED% when the frontend is NOT running %ENDCOLOR%
        /usr/sbin/gwms-frontend upgrade ("and your options if any")

To stop the frontend:

```console
# %RED%For RHEL 6, CentOS 6, and SL6 %ENDCOLOR%
root@host # service gwms-frontend stop
# %RED%For RHEL 7, CentOS 7, and SL7%ENDCOLOR%
root@host # systemctl stop gwms-frontend
```    

And you can stop also the other services if you are not using them independently
of the frontend.

Validating GlideinWMS Frontend
------------------------------

The complete validation of the frontend is the submission of actual jobs.
However, there are a few things that can be checked prior to submitting user
jobs to Condor.

### Verifying Services Are Running

There are a few things that can be checked prior to submitting user jobs to Condor.

1. Verify all Condor daemons are started.

        :::file
        user@host $ condor_config_val -verbose DAEMON_LIST
        DAEMON_LIST: MASTER,  COLLECTOR, NEGOTIATOR,  SCHEDD, SHARED_PORT, SCHEDDJOBS2 COLLECTOR0 COLLECTOR1 COLLECTOR2
        COLLECTOR3 COLLECTOR4 COLLECTOR5 COLLECTOR6 COLLECTOR7 COLLECTOR8 COLLECTOR9 COLLECTOR10 , COLLECTOR11,
        COLLECTOR12, COLLECTOR13, COLLECTOR14, COLLECTOR15, COLLECTOR16, COLLECTOR17, COLLECTOR18, COLLECTOR19, COLLECTOR20,
        COLLECTOR21, COLLECTOR22, COLLECTOR23, COLLECTOR24, COLLECTOR25, COLLECTOR26, COLLECTOR27, COLLECTOR28, COLLECTOR29,
        COLLECTOR30, COLLECTOR31, COLLECTOR32, COLLECTOR33, COLLECTOR34, COLLECTOR35, COLLECTOR36, COLLECTOR37, COLLECTOR38,
        COLLECTOR39, COLLECTOR40
        Defined in '/etc/condor/config.d/11_gwms_secondary_collectors.config', line 193.
       

       If you don't see all the collectors and the two schedd, then the configuration must be corrected. There should be no startd daemons listed

2. Verify all VO Frontend Condor services are communicating.

        :::file
        user@host $ condor_status -any
        MyType               TargetType           Name
        glideresource        None                 MM_fermicloud026@gfactory_inst
        Scheduler            None                 fermicloud020.fnal.gov
        DaemonMaster         None                 fermicloud020.fnal.gov
        Negotiator           None                 fermicloud020.fnal.gov
        Collector            None                 frontend_service@fermicloud020
        Scheduler            None                 schedd_jobs2@fermicloud020.fnal
        

3. To see the details of the glidein resource use `condor_status -subsystem glideresource -l`, including the GlideFactoryName.

4. Verify that the Factory is seeing correctly the Frontend using `condor_status -pool %RED%<FACTORY_HOST>%ENDCOLOR% -any -constraint 'FrontendName==%RED%<"FRONTEND_NAME_FROM_CONFIG">%ENDCOLOR%' -l`, including the GlideFactoryName.

### Glidein WMS Job submission

Condor submit file `glidein-job.sub`. This is a simple job printing the hostname of the host where the job is running:

``` file
#file glidein-job.sub
universe = vanilla
executable = /bin/hostname
output = glidein/test.out
error = glidein/test.err
requirements = IS_GLIDEIN == True
log = glidein/test.log
ShouldTransferFiles = YES

when_to_transfer_output = ON_EXIT
queue
```

To submit the job:

``` console
root@host # condor_submit glidein-job.sub
```

Then you can control the job like a normal condor job, e.g. to check the status of the job use `condor_q`.

### Monitoring Web pages

You should be able to see the jobs also in the GWMS monitoring pages that are
made available on the Web:
**`http://gwms-frontend-host.domain/vofrontend/monitor/`**

Troubleshooting GlideinWMS
--------------------------

### File Locations

|  File Description  |                                                             File Location                                                    |
|:------------------:|:----------------------------------------------------------------------------------------------------------------------------:|
| Configuration file |                                                    /etc/gwms-frontend/frontend.xml                                           |
|        Logs        |                                                        /var/log/gwms-frontend/                                               |
|   Startup script   |                                                       /etc/init.d/gwms-frontend                                              |
|    Web Directory   |                                                    /var/lib/gwms-frontend/web-area                                           |
|      Web Base      |                                                    /var/lib/gwms-frontend/web-base                                           |
|  Web configuration |                                                 /etc/httpd/conf.d/gwms-frontend.conf                                         |
|  Working Directory |                                                  /var/lib/gwms-frontend/vofrontend/                                          |
|     Lock files     | /etc/init.d/gwms-frontend/vofrontend/lock/frontend.lock /etc/init.d/gwms-frontend/vofrontend/group\_\*/lock/frontend.lock |
|    Status files    |                               /var/lib/gwms-frontend/vofrontend/monitor/group\_\*/frontend\_status.xml                       |


!!! note
    `/var/lib/gwms-frontend` is also the home directory of the `frontend` user

### Certificates brief

Here a short list of files to check when you change the certificates. Note that if you renew a proxy or certificate and the DN remains the same no configuration file needs to change, just put the renewed certificate/proxy in place.

|              File Description             |                               File Location                               |
|:-----------------------------------------:|:-------------------------------------------------------------------------:|
|             Configuration file            |                      /etc/gwms-frontend/frontend.xml                      |
|         HTCondor certificates map         |                   /etc/condor/creds/condor\_mapfile (1)                   |
|        Host certificate and key (2)       | /etc/grid-security/hostcert.pem            /etc/grid-security/hostkey.pem |
| VO Frontend proxy (from host certificate) |                            /tmp/vofe\_proxy (3)                           |
|                Pilot proxy                |                            /tmp/vofe\_proxy (3)                           |

1. If using HTCondor RPM installation, e.g. the one coming from OSG. If you have separate/multiple HTCondor hosts (schedds, collectors, negotiators, ..) you may have to check this file on all of them to make sure that the HTCondor authentication works correctly.

2. Used to create the VO Frontend proxy if following the [instructions above](#proxy-configuration)

3. If using the scripts described [above in this document](#proxy-configuration)

Remember also that when you change DN:

- The VO Frontend certificate DN must be communicated to the GWMS Factory ([see above](#osg-factory-access))
- The pilot proxy must be able to run jobs at the sites you are using, e.g. by being added to the correct VO in OSG (the Factory forwards the proxy and does not care about the DN)

### Increase the log level and change rotation policies

You can increase the log level of the frontend. To add a log file with all the log information add the following line with all the message types in the `process_log` section of `/etc/gwms-frontend/frontend.xml`:

``` file
<log_retention>
   <process_logs>
       <process_log extension="all" max_days="7.0" max_mbytes="100.0" min_days="3.0" msg_types="DEBUG,EXCEPTION,INFO,ERROR,ERR"/>
```

You can also change the rotation policy and choose whether compress the rotated files, all in the same section of the config files:

-   max_bytes is the max size of the log files
-   max_days it will be rotated.
-   compression specifies if rotated files are compressed
-   backup_count is the number of rotated log files kept

Further details are in the [reference documentation](http://www.uscms.org/SoftwareComputing/Grid/WMS/glideinWMS/doc.prd/frontend/configuration.html#process_logs).

### Frontend reconfig failing

If `service gwms-frontend reconfig` fails at the end with an error like "Writing back config file failed, Reconfiguring the frontend \[FAILED\]", make sure that `/etc/gwms-frontend/` belongs to the `frontend` user. It must be able to write to update the configuration file.

### Frontend failing to start

If the startup script of the frontend is failing, check the log file for errors (probably `/var/log/gwms-frontend/frontend/frontend.%RED%TODAY%ENDCOLOR%.err.log` and `.debug.log`).

If you find errors like *"Exception occurred: ... 'ExpatError: no element found: line 1, column 0\\n'\]"* and *"IOError: \[Errno 9\] Bad file descriptor"* you may have an empty status file (`/var/lib/gwms-frontend/vofrontend/monitor/group_*/frontend_status.xml`) that causes Glidein WMS Frontend not to start. The glideinFrontend crashes after a XML parsing exception visible in the log file ("Exception occurred: ... 'ExpatError: no element found: line 1, column 0\\n'\]").

Remove the status file. Then start the frontend. The fronten will be fixed in future versions to handle this automatically.

### Certificates not there

The scripts should send an email warning if there are problems and they fail to generate the proxies. Anyway something could go wrong and you want to check manually. If you are using the scripts to generate automatically the proxies but the proxies are not there (in `/tmp` or wherever you expect them):

-   make sure that the scripts are there and configured with the correct values
-   make sure that the scripts are executable
-   make sure that the scripts are in `frontend` 's crontab
-   make sure that the certificates (or master proxy) used to generate the proxies is not expired

### Failed authentication

If you get a failed authentication error (e.g. "Failed to talk to factory\_pool gfactory-1.t2.ucsd.edu...) then:

-   check that you have the right x509 certificates mentioned in the security section of `/etc/gwms-frontend/frontend.xml`
    -   the owner must be `frontend` (user running the frontend)
    -   the permission must be 600
    -   they must be valid for more than one hour (2/300 hours), at least the non VO part
-   check that the clock is synchronized (see HostTimeSetup)

### Frontend doesn't trust factory

If your frontend complains in the debug log:

``` file
code 256:['Error: communication error\n', 'AUTHENTICATE:1003:Failed to authenticate with any method\n', 'AUTHENTICATE:1004:Failed to authenticate using GSI\n', "GSI:5006:Failed to authenticate because the subject '/DC=org/DC=doegrids/OU=Services/CN=devg-3.t2.ucsd.edu' is not currently trusted by you.  If it should be, add it to GSI_DAEMON_NAME in the condor_config, or use the environment variable override (check the manual).\n", 'GSI:5004:Failed to gss_assist_gridmap /DC=org/DC=doegrids/OU=Services/CN=devg-3.t2.ucsd.edu to a local user.
```

A possible solution is to comment/remove the LOCAL\_CONFIG\_DIR in the file `/var/lib/gwms-frontend/vofrontend/frontend.condor_config`.

### No security credentials match for factory pool ..., not advertising request

You may see a warning like "No security credentials match for factory pool ..., not advertising request", if the `trust_domain` and `auth_method` of an entry in the Factory configuration is not matching any of the `trust_domain`, `type` couples in the credentials in the Frontend configuration. This causes the Frontend not to use some Factory entries (the ones not matching) and may end up without entries to send glideins to.

To fix the problem make sure that those attributes match as desired.

### Jobs not running

If your jobs remain Idle

-   Check the frontend log files (see above)
-   Check the condor log files (`condor_config_val LOG` will give you the correct log directory):
    -   Specifically look the CollectorXXXLog files

Common causes of problems could be:

- x509 certificates
    -   missing or expired or too short-lived proxy
    -   incorrect ownership or permission on the certificate/proxy file
    -   missing certificates
- If the frontend http server is down in the factory there will be errors like "Failed to load file 'description.dbceCN.cfg' from `http://FRONTEND_HOST/vofrontend/stage`."
    - check that the http server is running and you can reach the URL (`http://FRONTEND_HOST/vofrontend/stage/description.dbceCN.cfg`)

Advanced Configurations
-----------------------

- [GlideinWMS Frontend on a Campus Grid](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/GlideinWMSCampusGrid)


Getting Help
------------

To get assistance about the OSG software please use [this page](/common/help).

For specific questions about the Frontend configuration (and how to add it in your HTCondor infrastructure) you can email the glideinWMS support <glideinwms-support@fnal.gov>

To request access the OSG Glidein Factory (e.g. the UCSD factory) you have to send an email to <osg-gfactory-support@physics.ucsd.edu> (see below).

References
----------

Definitions:

-   What is a [Virtual Organization](https://www.opensciencegrid.org/about/organization/)

Documents about the Glidein-WMS system and the VO frontend:

-   <http://www.uscms.org/SoftwareComputing/Grid/WMS/glideinWMS/>
-   <http://www.uscms.org/SoftwareComputing/Grid/WMS/glideinWMS/doc.prd/manual/>

### Users

The Glidein WMS Frontend installation will create the following users unless they are already created.

| User       | Default uid | Comment                                                                                                                        |
|:-----------|:------------|:-------------------------------------------------------------------------------------------------------------------------------|
| `apache`   | 48          | Runs httpd to provide the monitoring page (installed via dependencies).                                                        |
| `condor`   | none        | Condor user (installed via dependencies).                                                                                      |
| `frontend` | none        | This user runs the glideinWMS VO frontend. It also owns the credentials forwarded to the factory to use for the glideins.      |
| `gratia`   | none        | Runs the Gratia probes to collect accounting data (optional see [the Gratia section below](#adding-gratia-accounting-and-a-local-monitoring-page-on-a-production-server)) |

!!! warning
    UID 48 is reserved by RedHat for user `apache`.  If it is already taken by a different username, you will experience errors.

### Certificates

This document has a [proxy configuration section](#proxy-configuration) that
uses the host certificate/key and a user certificate to generate the required
proxies.

| Certificate      | User that owns certificate | Path to certificate               |
|:-----------------|:---------------------------|:----------------------------------|
| Host certificate | `root`                     | `/etc/grid-security/hostcert.pem` |
| Host key         | `root`                     | `/etc/grid-security/hostkey.pem`  |

[Here](/security/host-certs.md) are instructions to request a host certificate.

### Networking

| Service Name      | Protocol | Port Number      |Inbound|Outbound| Comment                 |
|:------------------|:---------|:-----------------|:------|:-------|-------------------------|
|HTCondor port range| tcp      |`LOWPORT, HIGHPORT`|`YES` |        |contiguous range of ports|
|GlideinWMS Frontend| tcp      | 9618 to 9660     |`YES`  |        |HTCondor Collectors for the GlideinWMS Frontend (received ClassAds from resources and jobs)|

The VO frontend must have reliable network connectivity, be on the public
internet (no NAT), and preferably with no firewalls. Incoming TCP ports 9618 to 9660 must be open.

Each running pilot requires 5 outgoing TCP connections. For example, 2000 running jobs require about 10,100 TCP connections. This will overwhelm many firewalls; if you are unfamiliar with your network topology, you may want to warn your network administrator.
