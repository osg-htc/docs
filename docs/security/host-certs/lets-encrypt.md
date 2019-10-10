Requesting Host Certificates Using [Let's Encrypt](https://letsencrypt.org/)
============================================================================

[Let's Encrypt](https://letsencrypt.org/) is a free, automated, and open CA frequently used for web services;
see the [security team's position on Let's Encrypt](https://opensciencegrid.github.io/security/LetsEncryptOSGCAbundle/)
for more details.
Let's Encrypt can be used to obtain host certificates as an alternative to InCommon if your institution does not have
an InCommon subscription.

Let's Encrypt uses an automated script named [certbot](https://certbot.eff.org) for requesting and renewing host certs.
`certbot` binds to port 80 when running, so services running on port 80
(such as [HTCondor-CE View service](https://opensciencegrid.github.io/docs/compute-element/install-htcondor-ce/#install-and-run-the-htcondor-ce-view))
must be temporarily stopped before running `certbot`.
In addition, port 80 must be open to the world while `certbot` is running.
If this is a problem, see the [alternate renewal methods](#alternate-renewal-methods) section below.
Let's Encrypt host certs expire every three months so it is important to set up automated renewal.

EL7 and Newer
-------------
This section contains instructions for EL7 and newer systems, using systemd timers and `certbot` from an RPM.

### Installation and Obtaining the Initial Certificate

1. Install the `certbot` package (available from the EPEL 7 repository):

        :::console
        root@host # yum install certbot

1. Stop services running on port 80 if there are any.

1. Run the following command to obtain the host certificate with Let's Encrypt:

        :::console
        root@host # certbot certonly --standalone --email <ADMIN_EMAIL> -d <HOST>

1. Set up hostcert/hostkey links:

        :::console
        root@host # ln -sf /etc/letsencrypt/live/*/cert.pem /etc/grid-security/hostcert.pem
        root@host # ln -sf /etc/letsencrypt/live/*/privkey.pem /etc/grid-security/hostkey.pem
        root@host # chmod 0600 /etc/letsencrypt/archive/*/privkey*.pem

1. Restart services running on port 80 if there were any.


### Renewing Let's Encrypt host certificates

You can manually renew with the following command:

``` console
root@host # certbot renew
```

The certificate will be renewed if it is close to expiring.
 
!!!note
   Just like with obtaining a new certificate, renewing a certificate requires you to temporarily disable
   services running on port 80 so that `certbot` can verify the host.
 

#### Automating renewals using systemd timers

To automate renewal using systemd, you'll need to create two files:
The first is a service file that tells systemd how to invoke certbot.
The second is to generate a timer file that tells systemd how often to run the service.
The steps to setup the timer are as follows:

1. Create a service file called `/etc/systemd/system/certbot.service` with the following contents

        :::file
        [Unit]
        Description=Let's Encrypt renewal

        [Service]
        Type=oneshot
        ExecStart=/usr/bin/certbot renew --quiet --agree-tos

1. Once the certbot service is working correctly, you will need to create the timer file.
   Create the timer file at `/etc/systemd/system/certbot.timer`) with the following contents:

        :::file
        [Unit]
        Description=Let's Encrypt renewal timer

        [Timer]
        OnCalendar=0/12:00:00
        RandomizedDelaySec=1h
        Persistent=true

        [Install]
        WantedBy=timers.target

1. Update the systemd manager configuration:

        :::console
        root@host # systemctl daemon-reload

1. Start and enable the certbot timer:

        :::console
        root@host # systemctl enable --now certbot.timer

You can verify that the timer is active by running `systemctl list-timers`.

!!! note
    Verify that the service has started correctly by running `systemctl status certbot.service`. The timer may fail
    without warnings if the service does not run correctly.


### Pre- and post-renewal hooks

Sometimes you want to run commands before and after cert renewal.
Some uses of this are:

- copy the renewed certificate so it can be used for a separate service (such as xrootd)
- shut down and restart a service running on port 80
- temporarily open up a firewall

To do this, call `certbot` with `--pre-hook <COMMAND>` for a command or script to run before renewal,
and `--post-hook <COMMAND>` for a command or script to run after renewal.
The command(s) will only be run if the certificate is actually renewed.


#### Example

This example is for a host running CEView and XRootD standalone;
CEView needs to be stopped so it doesn't block port 80, and XRootD needs the cert in a separate location.

Create the following scripts:

**/root/bin/certbot-pre.sh**
```bash
#!/bin/bash
condor_ce_off -daemon CEVIEW
```

**/root/bin/certbot-post.sh**
```bash
#!/bin/bash
cd /etc/grid-security
cp -f hostcert.pem xrd/xrdcert.pem
cp -f hostkey.pem xrd/xrdkey.pem
chown -R xrootd:xrootd xrd
condor_ce_on -daemon CEVIEW
systemctl restart xrootd@standalone
```

Then call `certbot` as follows:

```console
root@host # certbot renew --pre-hook /root/bin/certbot-pre.sh \
                          --post-hook /root/bin/certbot-post.sh
```

For automated renewal, edit the `certbot.service` file and add the `--pre-hook <COMMAND>`
and `--post-hook <COMMAND>` arguments to the `ExecStart` line:

```ini
ExecStart=/usr/bin/certbot renew --quiet --agree-tos \
             --pre-hook /root/bin/certbot-pre.sh \
             --post-hook /root/bin/certbot-post.sh
```


### Alternate renewal methods

There are some cases in which you might need an alternative to running `certbot` as above.
For example:

- you have a web server running on port 80 that you do not want to shut down during renewal
- you cannot open up port 80 during renewal
- you want a wildcard certificate
- you want to run the renewal on a different machine than where the cert will be used

[Certbot plugins](https://certbot.eff.org/docs/using.html#getting-certificates-and-choosing-plugins) may help in these
cases.

- The Apache, Nginx, and Webroot plugins integrate with an already running web server to allow renewal
without shutting the webserver down.
- One of the DNS plugins can be used to avoid using port 80, run on a different machine, or obtain a wildcard cert.
- If all else fails, the manual plugin can be used for manual renewal.


References
----------

-   [Useful OpenSSL commands (from NCSA)](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html) -
    e.g. how to convert the format of your certificate.

-   [Official Let's Encrypt setup guide](https://letsencrypt.org/getting-started/).

-   Another [Let's Encrypt setup reference](https://github.com/cilogon/letsencrypt-certificates).
    Under Getting your host certificate, we follow the first "Setting up" section.
