
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
$ rpm --checksig -v globus-core-8.0-2.osg.x86_64.rpm
globus-core-8.0-2.osg.x86_64.rpm:
    Header V3 DSA signature: OK, key ID 824b8603
    Header SHA1 digest: OK (2b5af4348c548c27f10e2e47e1ec80500c4f85d7)
    MD5 digest: OK (d11503a229a1a0e02262034efe0f7e46)
    V3 DSA signature: OK, key ID 824b8603
```

The OSG Packaging Signing Keys
------------------------------

The OSG Software Team has two GPG keys for signing RPMs;
the first key is used for packages before the 3.6 release series,
and the second key is used for packages in the 3.6 release series and afterward.

| Key 1 (3.0 to 3.5) |                                                        |
|--------------------|--------------------------------------------------------|
| Location           | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG`                     |
| Download           | [UW-Madison](https://vdt.cs.wisc.edu/RPM-GPG-KEY-OSG), [GitHub](https://raw.githubusercontent.com/opensciencegrid/docs/master/docs/release/RPM-GPG-KEY-OSG) |
| Fingerprint        | `6459 !D9D2 AAA9 AB67 A251  FB44 2110 !B1C8 824B 8603` |
| Key ID             | `824b8603`                                             |

| Key 2 (3.6 and on) |                                                        |
|--------------------|--------------------------------------------------------|
| Location           | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-2`                   |
| Download           | [UW-Madison](https://vdt.cs.wisc.edu/RPM-GPG-KEY-OSG-2), [GitHub](https://raw.githubusercontent.com/opensciencegrid/docs/master/docs/release/RPM-GPG-KEY-OSG-2) |
| Fingerprint        | `1216 FF68 897A 77EA 222F  C961 27DC 6864 96D2 B90F`   |
| Key ID             | `96d2b90f`                                             |

!!! note
    Some packages in the 3.6 repos may still be signed with the old key;
    the `osg-release` RPM contains both keys so you can verify old packages.

You can see the fingerprint for yourself.
On EL 7 and older (GnuPG &lt; 2.1.13):

```console
$ gpg --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
pub  1024D/824B8603 2011-09-15 OSG Software Team (RPM Signing Key for Koji Packages) <vdt-support@opensciencegrid.org>
      Key fingerprint = 6459 D9D2 AAA9 AB67 A251  FB44 2110 B1C8 824B 8603
sub  2048g/28E5857C 2011-09-15

$ gpg --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-2
pub  4096R/96D2B90F 2021-02-24 Open Science Grid Software <help@opensciencegrid.org>
      Key fingerprint = 1216 FF68 897A 77EA 222F  C961 27DC 6864 96D2 B90F
sub  4096R/49E9ACC2 2021-02-24
```

On EL 8 and newer (GnuPG &gt;= 2.1.13):
```console
$ gpg --import-options show-only --import  < /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
pub   dsa1024 2011-09-15 [SC]
      6459D9D2AAA9AB67A251FB442110B1C8824B8603
uid                      OSG Software Team (RPM Signing Key for Koji Packages) <vdt-support@opensciencegrid.org>
sub   elg2048 2011-09-15 [E]

$ gpg --import-options show-only --import  < /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG-2
pub   rsa4096 2021-02-24 [SC]
      1216FF68897A77EA222FC96127DC686496D2B90F
uid                      Open Science Grid Software <help@opensciencegrid.org>
sub   rsa4096 2021-02-24 [E]
```

