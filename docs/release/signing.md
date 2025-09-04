
title: OSG Release Signing Information

OSG Release Signing Information
===============================

Verifying OSG's RPMs
--------------------

We use a GPG key to sign our software packages. Normally `yum` and `rpm` transparently use the GPG signatures to verify the packages have not been corrupted and were created by us. You get our GPG public key when you install the `osg-release` RPM.

If you wish to verify one of our RPMs manually, you can run:

```console
$ rpm --checksig -v <NAME.RPM>
```

For example:

```console
# rpm --import https://repo.osg-htc.org/osg/RPM-GPG-KEY-OSG-24-developer
# rpm --checksig -v https://repo.osg-htc.org/osg/24-main/osg-24-main-el9-release-latest.rpm
https://repo.osg-htc.org/osg/24-main/osg-24-main-el9-release-latest.rpm:
    Header V4 RSA/SHA256 Signature, key ID effc3be6: OK
    Header SHA256 digest: OK
    Header SHA1 digest: OK
    Payload SHA256 digest: OK
    V4 RSA/SHA256 Signature, key ID effc3be6: OK
    MD5 digest: OK
```

The OSG Packaging Signing Keys
------------------------------

The OSG Software Team has several GPG keys for signing RPMs;
The key used depends on the OSG version and software repository used, as documented below:

| OSG 23 Automated Signing Key |                                              |
|--------------------|--------------------------------------------------------|
| Location           | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-23-auto`             |
| Download           | [GitHub](https://raw.githubusercontent.com/opensciencegrid/docs/master/docs/release/RPM-GPG-KEY-OSG-23-auto) |
| Fingerprint        | `E2AF 9F6E 239F D62B 5377  05C0 1760 EDF6 4D43 84D0`   |
| Key ID             | `4d4384d0`                                             |
| Repositories       | osg-23-development                                     |

| OSG 23 Developer Signing Key |                                              |
|--------------------|--------------------------------------------------------|
| Location           | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-23-developer`        |
| Download           | [GitHub](https://raw.githubusercontent.com/opensciencegrid/docs/master/docs/release/RPM-GPG-KEY-OSG-23-developer) |
| Fingerprint        | `4A56 C5BB CDB0 AAA2 DDE9  A690 BDEE E24C 9289 7C00`   |
| Key ID             | `92897c00`                                             |
| Repositories       | All non-development osg-23 repositories                |

| OSG 24 Automated Signing Key |                                              |
|--------------------|--------------------------------------------------------|
| Location           | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-24-auto`             |
| Download           | [GitHub](https://raw.githubusercontent.com/opensciencegrid/docs/master/docs/release/RPM-GPG-KEY-OSG-24-auto) |
| Fingerprint        | `E612 A4B4 2EE0 71C3 15D1  1CDB 51F0 C137 34E9 58B3`   |
| Key ID             | `34e958b3`                                             |
| Repositories       | osg-24-development                                     |

| OSG 24 Developer Signing Key |                                              |
|--------------------|--------------------------------------------------------|
| Location           | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-24-developer`        |
| Download           | [GitHub](https://raw.githubusercontent.com/opensciencegrid/docs/master/docs/release/RPM-GPG-KEY-OSG-24-developer) |
| Fingerprint        | `F77F E0C7 0A9B AA73 9FD3  52C9 9DF7 5B52 EFFC 3BE6`   |
| Key ID             | `effc3be6`                                             |
| Repositories       | All non-development osg-24 repositories                |

| OSG 25 Automated Signing Key |                                              |
|--------------------|--------------------------------------------------------|
| Location           | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-25-auto`             |
| Download           | [GitHub](https://raw.githubusercontent.com/opensciencegrid/docs/master/docs/release/RPM-GPG-KEY-OSG-25-auto) |
| Fingerprint        | `376C 81EE 1421 311A 0FF4  3C3C 467C D904 222C 5D49`   |
| Key ID             | `222c5d49`                                             |
| Repositories       | osg-25-development                                     |

| OSG 25 Developer Signing Key |                                              |
|--------------------|--------------------------------------------------------|
| Location           | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-25-developer`        |
| Download           | [GitHub](https://raw.githubusercontent.com/opensciencegrid/docs/master/docs/release/RPM-GPG-KEY-OSG-25-developer) |
| Fingerprint        | `962A 9BCD D330 245F 2703  C88B 74E5 BE22 D4E9 B1FC`   |
| Key ID             | `d4e9b1fc`                                             |
| Repositories       | All non-development osg-25 repositories                |

You can see the fingerprint for yourself.

On EL 8 and newer (GnuPG &gt;= 2.1.13):
```console
$  gpg --import-options show-only --import < /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-23-auto
pub   rsa4096 2023-06-23 [SC]
      E2AF9F6E239FD62B537705C01760EDF64D4384D0
uid                      OSG 23 Automated Signing Key <help@osg-htc.org>
sub   rsa4096 2023-06-23 [E]

$  gpg --import-options show-only --import < /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-23-developer
pub   rsa4096 2023-08-15 [SC]
      4A56C5BBCDB0AAA2DDE9A690BDEEE24C92897C00
uid                      OSG 23 Developer Signing Key <help@osg-chtc.org>
sub   rsa4096 2023-08-15 [E]

$  gpg --import-options show-only --import < /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-24-auto
pub   rsa4096 2024-08-20 [SC]
      Key fingerprint = E612A4B42EE071C315D11CDB51F0C13734E958B3
uid                      OSG 24 Automated Signing Key <help@osg-htc.org>
sub   rsa4096 2024-08-20 [E]

$  gpg --import-options show-only --import < /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-24-developer
pub   rsa4096 2024-08-20 [SC]
      F77FE0C70A9BAA739FD352C99DF75B52EFFC3BE6
uid                      OSG 24 Developer Signing Key <help@osg-htc.org>
sub   rsa4096 2024-08-20 [E]

```

