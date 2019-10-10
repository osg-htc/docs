Requesting Host Certificates Using [Let's Encrypt](https://letsencrypt.org/)
============================================================================

[Let's Encrypt](https://letsencrypt.org/) is a free, automated, and open CA frequently used for web services;
see the [security team's position on Let's Encrypt](https://opensciencegrid.github.io/security/LetsEncryptOSGCAbundle/)
for more details.
Let's Encrypt can be used to obtain host certificates as an alternative to InCommon if your institution does not have
an InCommon subscription.

1. Install the `certbot` package (available from the EPEL 7 repository):

        :::console
        root@host # yum install certbot

1. If you have any service running on port 80, you will have to disable it temporarily to obtain certificates, as Let's
   Encrypt needs to bind on it temporarily in order to verify the host.
   For instance, if you already have an HTCondor-CE set up with the
   [HTCondor-CE View service](https://opensciencegrid.github.io/docs/compute-element/install-htcondor-ce/#install-and-run-the-htcondor-ce-view)
   running, stop the HTCondor-CE View service, as it listens on port 80.

1. Run the following command to obtain the host certificate with Let's Encrypt:

        :::console
        root@host # certbot certonly --standalone --email <ADMIN_EMAIL> -d <HOST>

1. Set up hostcert/hostkey links:

        :::console
        root@host # ln -s /etc/letsencrypt/live/*/cert.pem /etc/grid-security/hostcert.pem
        root@host # ln -s /etc/letsencrypt/live/*/privkey.pem /etc/grid-security/hostkey.pem
        root@host # chmod 0600 /etc/letsencrypt/archive/*/privkey*.pem


Renewing Let's Encrypt host certificates
----------------------------------------

Before the host certificate expires, you can renew it with the following command:

``` console
root@host # certbot renew
```

!!!note
   Renewing a certificate requires you to temporarily disable services running on port 80 so that
   certbot can bind to it to verify the host.

To automate the renewal process, you need to choose between using a cron job (SL6 and SL7 hosts) and a systemd timer
(SL7 hosts only).
The two sections below outline both methods for automatically renewing your certificate.


Automating renewals using cron
------------------------------

To automate a monthly renewal with a cron job; you can create `/etc/cron.d/certbot-renew` with the following
contents:

``` console
* * 1 * * root certbot renew
```

### Automating renewals using systemd timers

To automate a monthly  renewal using systemd, you'll need to create two files.
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
        Description=Twice daily renewal of Let's Encrypt's certificates

        [Timer]
        OnCalendar=0/12:00:00
        RandomizedDelaySec=1h
        Persistent=true

        [Install]
        WantedBy=timers.target

1. Update the systemd manager configuration:

        :::console
        root@host # systemctl daemon-reload

1. Start and enable the certbot service and timer:

        :::console
        root@host # systemctl start certbot.service
        root@host # systemctl enable certbot.service
        root@host # systemctl start certbot.timer
        root@host # systemctl enable certbot.timer

You can verify that the timer is active by running `systemctl list-timers`.

!!! note
    Verify that the service has started correctly by running `systemctl status certbot.service`. The timer may fail
    without warnings if the service does not run correctly.


References
------------

-   [Useful OpenSSL commands (from NCSA)](http://security.ncsa.illinois.edu/research/grid-howtos/usefulopenssl.html) - e.g. how to convert the format of your certificate.

-   [Official Let's Encrypt setup guide](https://letsencrypt.org/getting-started/)

-   Another [Let's Encrypt setup reference](https://github.com/cilogon/letsencrypt-certificates)
    Under Getting your host certificate, we follow the first "Setting up" section.
