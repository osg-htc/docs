
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

The OSG Packaging Signing Key
-----------------------------

|              |                                                        |
|--------------|--------------------------------------------------------|
| Location     | `/etc/pki/rpm-gpg/RPM-GPG-KEY-OSG`                     |
| Download     | [UW-Madison](https://vdt.cs.wisc.edu/RPM-GPG-KEY-OSG), [GitHub](RPM-GPG-KEY-OSG)  |
| Fingerprint  | `6459 !D9D2 AAA9 AB67 A251  FB44 2110 !B1C8 824B 8603` |
| Key ID       | `824b8603`                                             |

You can see the fingerprint for yourself:

```console
$ gpg --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-OSG
pub  1024D/824B8603 2011-09-15 OSG Software Team (RPM Signing Key for Koji Packages) <vdt-support@opensciencegrid.org>
      Key fingerprint = 6459 D9D2 AAA9 AB67 A251  FB44 2110 B1C8 824B 8603
sub  2048g/28E5857C 2011-09-15
```

