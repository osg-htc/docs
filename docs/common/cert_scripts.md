**Certificate Scripts package**
===============================

<span class="twiki-macro DOC_STATUS_TABLE"></span> <span class="twiki-macro TOC"></span>

About This Document
===================

This the home page for documenting the cert-scripts package that provides a command-line interface to the DOEGrids CA website and some additional utilities for dealing with X509 certificates. This package was developed originally by the PPDG project and is now maintained by the OSG RA.

As an alternative to the web browser interface, these scripts are contributed to the DOEGrids PKI to allow a command-line interface to the certificate authority for submitting certificate requests, retrieving signed certificates, renewing certificates, directory lookup of existing certificates, and checking the remaining lifetime of certificates and certificate revocation lists. They work directly with the PEM format files used by Globus. These are perl scripts and bash shell scripts (some awk), depend upon openssl, ldapsearch and the perl LWP:: module with [SSL support](http://search.cpan.org/src/GAAS/libwww-perl-5.803/README.SSL). Click on the File link below for the usage description of the script, or to download the tar file package containing the scripts.

How to get Help?
================

To get assistance please use [Help Procedure](help).

Requirements
============

-   A host to install the Cert Scripts package. It is normally included in the CE.
-   OS is <span class="twiki-macro SUPPORTED_OS"></span>. Currently most of our testing has been done on Scientific Linux 5.
-   Root access
-   Allow outbound network connection to the CA

Installation Procedure <span class="twiki-macro STARTSECTION">OSGAllInstallCertScripts</span>
=============================================================================================

<span class="twiki-macro INCLUDE" section="OSGRepoBrief" TOC_SHIFT="+">YumRepositories</span>

<span class="twiki-macro INCLUDE" section="OSGBriefCaCerts" TOC_SHIFT="+">InstallCertAuth</span>

<span class="twiki-macro STARTSECTION">OSGBriefInstallCertScripts</span>

Install the certificate scripts package The Cert Scripts package can be installed with the following command:
-------------------------------------------------------------------------------------------------------------

``` rootscreen
%UCL_PROMPT_ROOT% yum install osg-cert-scripts
```

<span class="twiki-macro ENDSECTION">OSGBriefInstallCertScripts</span> <span class="twiki-macro ENDSECTION">OSGAllInstallCertScripts</span>

Usage of certificate scripts package This package is mainly used to request certificates via the command line: either host and service certificates or user certificates.
=========================================================================================================================================================================

[Get host and service certificates using command line](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/GetHostServiceCertificates)
---------------------------------------------------------------------------------------------------------

Example usage of check-cert-time The cert-check-time script is helpful in setting up and monitoring the CA certificates and CRL’s that get installed in your trusted certificates directory. This section describes using these scripts to check the CA and CRL status. —+++! Checking CA certificates
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

There are numerous CA certificates installed with VDT and you may not want to allow all of them on your site. The `cert-check-time` is a helpful command for reviewing them. This must be run in a directory where you have write access even though it does not create any permanent files. You may want to redirect stdout to a file you can then review.

``` screen
%UCL_PROMPT% <b>cert-check-time -cR -s /usr/share/osg-cert-scripts/</b>
```

For each CA, the output shows:

-   remaining lifetime of the CA certificate (in days),
-   the human readable name of the CA,
-   and the location of the actual certificate file.

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_OUTPUT%</span>

``` screen
         days  name       CA certificate file
       6712.9 subject= /DC=HK/DC=HKU/DC=GRID/CN=HKU Grid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/4798da47.0
       6674.9 subject= /DC=cz/DC=cesnet-ca/O=CESNET CA/CN=CESNET CA Root  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/edca0fc0.0
       6640.8 subject= /C=FR/O=CNRS/CN=CNRS2  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/163af95c.0
       6639.8 subject= /C=FR/O=CNRS/CN=CNRS2-Projets  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/09ff08b7.0
       6638.8 subject= /C=FR/O=CNRS/CN=GRID2-FR  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/d11f973e.0
       6620.4 subject= /C=US/ST=UT/L=Salt Lake City/O=The USERTRUST Network/OU=http://www.usertrust.com/CN=UTN-USERFirst-Client Authentication and Email  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/9ec3a561.0
       6620.4 subject= /C=NL/O=TERENA/CN=TERENA eScience Personal CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/169d7f9c.0
       6620.4 subject= /C=GB/ST=Greater Manchester/L=Salford/O=Comodo CA Limited/CN=AAA Certificate Services  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/75680d2e.0
       6542.2 subject= /DC=by/DC=grid/O=uiip.bas-net.by/CN=Belarusian Grid Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/709bed08.0
       6274.0 subject= /C=MK/O=MARGI/CN=MARGI-CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/7d0d064a.0
       6191.7 subject= /C=UK/O=eScienceRoot/OU=Authority/CN=UK e-Science Root  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/98ef0ee5.0
       6165.7 subject= /C=TW/O=AS/CN=Academia Sinica Grid Computing Certification Authority Mercury  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/9cd75e87.0
       5929.1 subject= /C=CH/O=Switch - Teleinformatikdienste fuer Lehre und Forschung/CN=SWITCHgrid Root CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/d0b701c0.0
       5799.7 subject= /DC=ch/DC=cern/CN=CERN Root CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/d254cc30.0
       5719.6 subject= /C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid Root CA 2006  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/28a58577.0
       5690.1 subject= /C=HR/O=edu/OU=srce/CN=SRCE CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/ff94d436.0
       5581.6 subject= /DC=CN/DC=Grid/CN=Root Certificate Authority at CNIC  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/b2771d44.0
       5536.3 subject= /C=CA/O=Grid/CN=Grid Canada Certificate Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/bffbd7d0.0
       5437.9 subject= /C=TR/O=TRGrid/CN=TR-Grid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/1691b9ba.0
       5327.0 subject= /DC=cz/DC=cesnet-ca/CN=CESNET CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/9b59ecad.0
       5084.8 subject= /C=JP/O=AIST/OU=GRID/CN=Certificate Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/a317c467.0
       4947.1 subject= /C=PT/O=LIPCA/CN=LIP Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/11b4a5a2.0
       4361.6 subject= /DC=net/DC=ES/O=ESnet/OU=Certificate Authorities/CN=ESnet Root CA 1  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/d1b603c3.0
       3774.1 subject= /C=BM/O=QuoVadis Limited/OU=Root Certification Authority/CN=QuoVadis Root Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/5cf9d536.0
       3737.4 subject= /C=NL/O=NIKHEF/CN=NIKHEF medium-security certification auth  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/16da7552.0
       3572.8 subject= /C=PL/O=GRID/CN=Polish Grid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/8a661490.0
       3482.8 subject= /C=US/ST=UT/L=Salt Lake City/O=The USERTRUST Network/OU=http://www.usertrust.com/CN=UTN-USERFirst-Hardware  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/ff783690.0
       3482.8 subject= /C=SE/O=AddTrust AB/OU=AddTrust External TTP Network/CN=AddTrust External CA Root  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/3c58f906.0
       3482.8 subject= /C=NL/O=TERENA/CN=TERENA eScience SSL CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/20ce830e.0
       3319.1 subject= /DC=cz/DC=cesnet-ca/O=CESNET CA/CN=CESNET CA 3  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/712ae4cc.0
       3089.1 subject= /DC=gov/DC=fnal/O=Fermilab/OU=Certificate Authorities/CN=Kerberized CA HSM  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/99f9f5a3.0
       3087.2 subject= /C=BM/O=QuoVadis Limited/OU=Issuing Certification Authority/CN=QuoVadis Grid ICA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/e72045ce.0
       3039.3 subject= /DC=MD/DC=MD-Grid/O=RENAM/OU=Certification Authority/CN=MD-Grid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/9ff26ea4.0
       2939.0 subject= /C=BE/OU=BEGRID/O=BELNET/CN=BEgrid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/e8d818e6.0
       2906.9 subject= /C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN SLCS-CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/a02131f7.0
       2904.9 subject= /C=VE/O=Grid/O=Universidad de Los Andes/OU=CeCalCULA/CN=ULAGrid Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/3f0f4285.0
       2879.6 subject= /DC=IN/DC=GARUDAINDIA/CN=Indian Grid Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/da75f6a8.0
       2874.5 subject= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC Root CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/684261aa.0
       2850.4 subject= /DC=TW/DC=ORG/DC=NCHC/CN=NCHC CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/71a89a47.0
       2769.2 subject= /DC=NET/DC=PRAGMA-GRID/CN=PRAGMA-UCSD CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/7721d4d3.0
       2763.2 subject= /DC=LV/DC=latgrid/CN=Certification Authority for Latvian Grid  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/742edd45.0
       2756.7 subject= /DC=me/DC=ac/DC=MREN/CN=MREN-CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/3232b9bc.0
       2581.9 subject= /C=PK/O=NCP/CN=PK-GRID-CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/f5ead794.0
       2560.4 subject= /C=MX/O=UNAMgrid/OU=UNAM/CN=CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/24c3ccde.0
       2549.2 subject= /C=MA/O=MaGrid/CN=MaGrid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/7b54708e.0
       2510.1 subject= /DC=RO/DC=RomanianGRID/O=ROSA/OU=Certification Authority/CN=RomanianGRID CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/1f3834d0.0
       2485.1 subject= /C=AR/O=e-Ciencia/OU=UNLP/L=CeSPI/CN=PKIGrid  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/b7bcb7b2.0
       2449.6 subject= /C=KR/O=KISTI/O=GRID/CN=KISTI Grid Certificate Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/722e5071.0
       2446.1 subject= /DC=BR/DC=UFF/DC=IC/O=UFF LACGrid CA/CN=UFF Latin American and Caribbean Catch-all Grid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/a9082267.0
       2367.8 subject= /C=CL/O=REUNACA/CN=REUNA Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/295adc19.0
       2343.9 subject= /C=RS/O=AEGIS/CN=AEGIS-CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/393f7863.0
       2279.2 subject= /DC=bg/DC=acad/CN=BG.ACAD CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/2418a3f3.0
       2238.5 subject= /C=TH/O=NECTEC/OU=GOC/CN=NECTEC GOC CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/8a047de1.0
       2147.9 subject= /C=IT/O=INFN/CN=INFN CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/2f3fadf6.0
       2147.8 subject= /DC=ch/DC=cern/CN=CERN Trusted Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/1d879c6c.0
       2068.6 subject= /C=JP/O=National Research Grid Initiative/OU=CGRD/CN=NAREGI CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/a87d9192.0
       2067.7 subject= /C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2006  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/82b36fca.0
       2064.1 subject= /C=BR/O=ICPEDU/O=UFF BrGrid CA/CN=UFF Brazilian Grid Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/0a2bac92.0
       1928.6 subject= /DC=CN/DC=Grid/DC=SDG/CN=Scientific Data Grid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/c48c63f3.0
       1877.5 subject= /C=AU/O=APACGrid/OU=CA/CN=APACGrid/emailAddress=camanager@vpac.org  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/1e12d831.0
       1769.8 subject= /DC=org/DC=balticgrid/CN=Baltic Grid Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/2a237f16.0
       1725.0 subject= /C=RU/O=RDIG/CN=Russian Data-Intensive Grid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/55994d72.0
       1682.6 subject= /DC=es/DC=irisgrid/CN=IRISGridCA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/9dd23746.0
       1649.8 subject= /C=CN/O=HEP/CN=gridca-cn/emailAddress=gridca@ihep.ac.cn  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/ba2f39ca.0
       1575.2 subject= /C=AT/O=AustrianGrid/OU=Certification Authority/CN=Certificate Issuer  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/6e3b436b.0
       1571.4 subject= /C=HU/O=NIIF/OU=Certificate Authorities/CN=NIIF Root CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/cc800af0.0
       1389.9 subject= /CN=Purdue TeraGrid RA/OU=Purdue TeraGrid/O=Purdue University/ST=Indiana/C=US  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/67e8acfa.0
       1378.2 subject= /CN=PurdueCA/O=Purdue University/ST=Indiana/C=US  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/95009ddc.0
       1374.7 subject= /DC=ORG/DC=SEE-GRID/CN=SEE-GRID CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/468d15b3.0
       1301.9 subject= /C=DE/O=GermanGrid/CN=GridKa-CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/dd4b34ea.0
       1211.2 subject= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=GridShib CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/e8ac4b61.0
       1141.9 subject= /C=IL/O=IUCC/CN=IUCC/emailAddress=ca@mail.iucc.ac.il  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/6fee79b0.0
       1111.4 subject= /C=AM/O=ArmeSFo/CN=ArmeSFo CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/d0c2a341.0
       1049.5 subject= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC MICS CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/2ac09305.0
       1049.5 subject= /DC=EDU/DC=UTEXAS/DC=TACC/O=UT-AUSTIN/CN=TACC Classic CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/e5cc84c2.0
       1025.9 subject= /C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN-Verein PCA Grid - G01  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/1149214e.0
        943.2 subject= /DC=net/DC=ES/OU=Certificate Authorities/CN=NERSC Online CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/b93d6240.0
        910.1 subject= /C=IR/O=IPM/O=IRAN-GRID/CN=IRAN-GRID CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/ce33db76.0
        815.9 subject= /C=CY/O=CyGrid/O=HPCL/CN=CyGridCA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/afe55e66.0
        800.7 subject= /DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/1c3f2ca8.0
        795.3 subject= /DC=org/DC=ugrid/CN=UGRID CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/0a12b607.0
        761.9 subject= /C=SK/O=SlovakGrid/CN=SlovakGrid CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/e13e0fcf.0
        713.7 subject= /C=UK/O=eScienceCA/OU=Authority/CN=UK e-Science CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/367b75c3.0
        619.1 subject= /C=IE/O=Grid-Ireland/CN=Grid-Ireland Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/1e43b9cc.0
        523.2 subject= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=MyProxy  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/f2e89fe3.0
        523.2 subject= /C=US/O=National Center for Supercomputing Applications/OU=Certificate Authorities/CN=CACL  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/9b95bbf2.0
        450.1 subject= /C=CH/O=Switch - Teleinformatikdienste fuer Lehre und Forschung/CN=SWITCHslcs CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/304cf809.0
        279.7 subject= /C=SI/O=SiGNET/CN=SiGNET CA  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/3d5be7bc.0
        179.9 subject= /O=Grid/O=NorduGrid/CN=NorduGrid Certification Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/1f0e8352.0
        135.0 subject= /C=JP/O=KEK/OU=CRC/CN=KEK GRID Certificate Authority  cert:/ncsa/apps-local/itb-1.2/globus/TRUSTED_CA/617ff41b.0
nearest CA certificate expiration 134.984 days
```

<span class="twiki-macro ENDTWISTY"></span>

In addition, at the bottom of the listing it points out which CA’s do not have a CRL. This is useful AFTER the edg-crl-upgraded daemon has run at least once because then it shows those CA’s which have not published a certificate revocation list. Note that two of the CAs, Kerberos CAs from PSC (85ca9edc.0) and FNAL (e1fce4e9.0) don’t really need CRLs since they only generate short lived certificates.

### Checking CRL’s

Certificate revocation lists contain the list of certificates (by serial number) that have been issued by a CA but were then revoked, meaning you should not accept them. CRL’s are updated frequently and typically have a lifetime limited to a month or less. When a CRL has expired, the CRL file will still exist in the trusted certificates directory, but Globus will fail **all** authentication attempts for **all** certificates issued by the corresponding CA.

For this reason, and others, it is important that CRL files are current and not expired. Another variation of the cert-check-time script will list the remaining lifetime of CRL’s in the trusted certificates directory. This must be run in a directory where you have write access even though it does not create any files. You may want to redirect stdout to a file you can then review.

``` screen
%UCL_PROMPT% <b>cert-check-time -r -s /usr/share/osg-cert-scripts/ </b>
```

For each CRL, the sample output below shows:

-   the remaining lifetime,
-   the name of the CA that issued the CRL
-   and the actual CRL file.

<span class="twiki-macro TWISTY">%TWISTY\_OPTS\_OUTPUT%</span>

``` screen
         days  name       CRL file
        365.1 issuer=/C=CA/O=Grid/CN=Grid Canada CA  crl:/opt/osg036/globus/TRUSTED_CA/5f54f417.r0
        340.8 issuer=/CN=SWITCH CA/emailAddress=switch.ca@switch.ch/O=Switch - Teleinformatikdienste fuer Lehre und Forschung/C=CH  crl:/opt/osg036/globus/TRUSTED_CA/c4435d12.r0
        317.1 issuer=/C=FR/O=CNRS/CN=CNRS-Projets  crl:/opt/osg036/globus/TRUSTED_CA/34a509c3.r0
        317.1 issuer=/C=FR/O=CNRS/CN=CNRS  crl:/opt/osg036/globus/TRUSTED_CA/cf4ba8c8.r0
        257.1 issuer=/CN=SwissSign Silver CA/emailAddress=silver@swisssign.com/O=SwissSign/C=CH  crl:/opt/osg036/globus/TRUSTED_CA/e9d08b40.r0
        257.1 issuer=/CN=SwissSign Bronze CA/emailAddress=bronze@swisssign.com/O=SwissSign/C=CH  crl:/opt/osg036/globus/TRUSTED_CA/e36e7a72.r0
        204.4 issuer=/DC=net/DC=ES/O=ESnet/OU=Certificate Authorities/CN=ESnet Root CA 1  crl:/opt/osg036/globus/TRUSTED_CA/d1b603c3.r0
        149.4 issuer=/C=CH/O=SwissSign/CN=SwissSign CA (RSA IK May 6 1999 18:00:58)/emailAddress=ca@SwissSign.com  crl:/opt/osg036/globus/TRUSTED_CA/7b2d086c.r0
         31.0 issuer=/C=RU/O=RDIG/CN=Russian Data-Intensive Grid CA  crl:/opt/osg036/globus/TRUSTED_CA/55994d72.r0
         30.0 issuer=/C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN-Verein Server CA Grid - G01  crl:/opt/osg036/globus/TRUSTED_CA/fe102e03.r0
         30.0 issuer=/C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN-Verein User CA Grid - G01  crl:/opt/osg036/globus/TRUSTED_CA/34f8e29c.r0
         29.9 issuer=/C=IT/O=INFN/CN=INFN Certification Authority  crl:/opt/osg036/globus/TRUSTED_CA/49f18420.r0
         29.9 issuer=/C=CY/O=CyGrid/O=HPCL/CN=CyGridCA  crl:/opt/osg036/globus/TRUSTED_CA/afe55e66.r0
         29.9 issuer=/C=IE/O=Grid-Ireland/CN=Grid-Ireland Certification Authority  crl:/opt/osg036/globus/TRUSTED_CA/1e43b9cc.r0
         29.7 issuer=/DC=es/DC=irisgrid/CN=IRISGridCA  crl:/opt/osg036/globus/TRUSTED_CA/9dd23746.r0
         29.7 issuer=/C=IL/O=IUCC/CN=IUCC/emailAddress=ca@mail.iucc.ac.il  crl:/opt/osg036/globus/TRUSTED_CA/6fee79b0.r0
         29.6 issuer=/DC=org/DC=DOEGrids/OU=Certificate Authorities/CN=DOEGrids CA 1  crl:/opt/osg036/globus/TRUSTED_CA/1c3f2ca8.r0
         29.5 issuer=/C=TW/O=AS/CN=Academia Sinica Grid Computing Certification Authority  crl:/opt/osg036/globus/TRUSTED_CA/a692434d.r0
         29.3 issuer=/C=FR/O=CNRS/CN=GRID-FR  crl:/opt/osg036/globus/TRUSTED_CA/12a1d8c2.r0
         29.1 issuer=/C=DE/O=GermanGrid/CN=GridKa-CA  crl:/opt/osg036/globus/TRUSTED_CA/dd4b34ea.r0
         28.8 issuer=/C=JP/O=National Research Grid Initiative/OU=GRID/CN=NAREGI CA  crl:/opt/osg036/globus/TRUSTED_CA/0cb5fc2c.r0
         28.3 issuer=/C=AU/O=APACGrid/OU=CA/CN=APACGrid/emailAddress=camanager@vpac.org  crl:/opt/osg036/globus/TRUSTED_CA/1e12d831.r0
         27.9 issuer=/DC=ORG/DC=SEE-GRID/CN=SEE-GRID CA  crl:/opt/osg036/globus/TRUSTED_CA/468d15b3.r0
         27.9 issuer=/C=GR/O=HellasGrid/CN=HellasGrid CA  crl:/opt/osg036/globus/TRUSTED_CA/ede78092.r0
         27.1 issuer=/C=NL/O=NIKHEF/CN=NIKHEF medium-security certification auth  crl:/opt/osg036/globus/TRUSTED_CA/16da7552.r0
         27.0 issuer=/C=PL/O=GRID/CN=Polish Grid CA  crl:/opt/osg036/globus/TRUSTED_CA/8a661490.r0
         26.8 issuer=/O=Grid/O=NorduGrid/CN=NorduGrid Certification Authority  crl:/opt/osg036/globus/TRUSTED_CA/1f0e8352.r0
         25.9 issuer=/C=AM/O=ArmeSFo/CN=ArmeSFo CA  crl:/opt/osg036/globus/TRUSTED_CA/d0c2a341.r0
         25.9 issuer=/C=BE/O=BELNET/OU=BEGrid/CN=BEGrid CA/emailAddress=gridca@belnet.be  crl:/opt/osg036/globus/TRUSTED_CA/03aa0ecb.r0
         24.0 issuer=/C=UK/O=eScience/OU=Authority/CN=CA/emailAddress=ca-operator@grid-support.ac.uk  crl:/opt/osg036/globus/TRUSTED_CA/01621954.r0
         23.9 issuer=/C=HU/O=KFKI RMKI CA/CN=KFKI RMKI CA  crl:/opt/osg036/globus/TRUSTED_CA/5e5501f3.r0
         23.9 issuer=/C=SK/O=SlovakGrid/CN=SlovakGrid CA  crl:/opt/osg036/globus/TRUSTED_CA/e13e0fcf.r0
         23.1 issuer=/C=PT/O=LIPCA/CN=LIP Certification Authority  crl:/opt/osg036/globus/TRUSTED_CA/11b4a5a2.r0
         23.0 issuer=/C=PT/O=LIP/OU=LISCC/CN=LIP Certification Authority  crl:/opt/osg036/globus/TRUSTED_CA/41380387.r0
         23.0 issuer=/C=AT/O=AustrianGrid/OU=Certification Authority/CN=Certificate Issuer  crl:/opt/osg036/globus/TRUSTED_CA/6e3b436b.r0
         22.9 issuer=/C=CZ/O=CESNET/CN=CESNET CA  crl:/opt/osg036/globus/TRUSTED_CA/ed99a497.r0
         21.9 issuer=/C=KR/O=KISTI/CN=KISTI GRID ROOT CA  crl:/opt/osg036/globus/TRUSTED_CA/47183fda.r0
         21.7 issuer=/C=CN/O=HEP/CN=gridca-cn/emailAddress=gridca@ihep.ac.cn  crl:/opt/osg036/globus/TRUSTED_CA/ba2f39ca.r0
         21.1 issuer=/C=CH/O=CERN/OU=GRID/CN=CERN CA  crl:/opt/osg036/globus/TRUSTED_CA/fa3af1d7.r0
         19.1 issuer=/C=SI/O=SiGNET/CN=SiGNET CA/emailAddress=signet-ca@ijs.si  crl:/opt/osg036/globus/TRUSTED_CA/747183a5.r0
         16.0 issuer=/DC=org/DC=balticgrid/CN=Baltic Grid Certification Authority  crl:/opt/osg036/globus/TRUSTED_CA/2a237f16.r0
         15.9 issuer=/C=EE/O=Grid/CN=Estonian Grid Certification Authority  crl:/opt/osg036/globus/TRUSTED_CA/566bf40f.r0
         12.9 issuer=/C=PK/O=NCP/CN=ncp.edu.pk  crl:/opt/osg036/globus/TRUSTED_CA/d2a353a5.r0
         11.3 issuer=/C=US/ST=California/L=Los Angeles/O=University of Southern California/CN=University of Southern California PKI-Lite CA, release 1/emailAddress=nmiadmin@usc.edu  crl:/opt/osg036/globus/TRUSTED_CA/2ca73e82.r0
         10.8 issuer=/C=RU/O=DataGrid/CN=Russian DataGrid CA  crl:/opt/osg036/globus/TRUSTED_CA/d64ccb53.r0
          9.7 issuer=/C=TR/O=TRGrid/CN=TR-Grid CA  crl:/opt/osg036/globus/TRUSTED_CA/1691b9ba.r0
          9.3 issuer=/C=US/O=Pittsburgh Supercomputing Center/CN=PSC Root Certificate Authority  crl:/opt/osg036/globus/TRUSTED_CA/aa99c057.r0
          9.2 issuer=/C=ES/O=DATAGRID-ES/CN=DATAGRID-ES CA  crl:/opt/osg036/globus/TRUSTED_CA/13eab55e.r0
          8.0 issuer=/C=DE/O=DFN-Verein/OU=DFN-PKI/CN=DFN-Verein PCA Grid - G01  crl:/opt/osg036/globus/TRUSTED_CA/1149214e.r0
          7.7 issuer=/C=JP/O=AIST/OU=GRID/CN=Certificate Authority  crl:/opt/osg036/globus/TRUSTED_CA/a317c467.r0
          7.2 issuer=/DC=cz/DC=cesnet-ca/CN=CESNET CA  crl:/opt/osg036/globus/TRUSTED_CA/9b59ecad.r0
 ***      6.8 issuer=/C=US/O=SDSC/OU=SDSC-CA/CN=Certificate Authority/UID=certman  crl:/opt/osg036/globus/TRUSTED_CA/3deda549.r0
 ***      6.2 issuer=/C=CA/O=Grid/CN=Grid Canada Certificate Authority  crl:/opt/osg036/globus/TRUSTED_CA/bffbd7d0.r0
 ***      4.4 issuer=/C=HU/O=NIIF/OU=Certificate Authorities/CN=NIIF Root CA  crl:/opt/osg036/globus/TRUSTED_CA/cc800af0.r0
 ***      4.2 issuer=/C=US/O=UTAustin/OU=TACC/CN=TACC Certification Authority/UID=caman  crl:/opt/osg036/globus/TRUSTED_CA/9a1da9f9.r0
 ***      1.1 issuer=/CN=PurdueCA/O=Purdue University/ST=Indiana/C=US  crl:/opt/osg036/globus/TRUSTED_CA/95009ddc.r0
 ***      1.0 issuer=/C=CH/O=SWITCH - Teleinformatikdienste fuer Lehre und Forschung/CN=SWITCH Server CA/emailAddress=switch.server.ca@switch.ch  crl:/opt/osg036/globus/TRUSTED_CA/072fe468.r0
 ***      1.0 issuer=/C=CH/O=SWITCH - Teleinformatikdienste fuer Lehre und Forschung/CN=SWITCH Personal CA/emailAddress=switch.personal.ca@switch.ch  crl:/opt/osg036/globus/TRUSTED_CA/4aa5ef7d.r0
 ***      1.0 issuer=/CN=SWITCH Personal CA/emailAddress=switch.personal.ca@switch.ch/O=SWITCH - Teleinformatikdienste fuer Lehre und Forschung/C=CH  crl:/opt/osg036/globus/TRUSTED_CA/7c0f6d74.r0
 ***      1.0 issuer=/CN=SWITCH Server CA/emailAddress=switch.server.ca@switch.ch/O=SWITCH - Teleinformatikdienste fuer Lehre und Forschung/C=CH  crl:/opt/osg036/globus/TRUSTED_CA/f8b4299c.r0
 ***      1.0 issuer=/CN=Purdue TeraGrid RA/OU=Purdue TeraGrid/O=Purdue University/ST=Indiana/C=US  crl:/opt/osg036/globus/TRUSTED_CA/67e8acfa.r0
nearest CRL expiration 0.951088 days
```

<span class="twiki-macro ENDTWISTY"></span>

Site administrators may find it useful to run this command in a daily cron job following the edg-crl-upgraded daemon as a way to monitor the status of the CRL’s.

References
==========

For additional information on the functionality of a script execute it with the -help option.

Files in the package:

| File                                                                                                        | Description                                                                                       |
|:------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------|
| [README](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe)                                      | describes the package, includes release notes                                                     |
| [cert-check-time](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe#cert_check_time)             | checks lifetime of certificates and revocation lists                                              |
| [cert-gridadmin](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe#cert_gridadmin)               | immediate issuance of service certificates for authorized requestors                              |
| [cert-lookup](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe#cert_lookup)                     | queries directory based on DN of certificates                                                     |
| [cert-request](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe#cert_request)                   | generates and submits a certificate signing request                                               |
| [cert-retrieve](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe#cert_retrieve)                 | retrieves signed certificate previously requested                                                 |
| [cert-renew](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe#cert_renew)                       | renews existing person certificate (not host or service)                                          |
| [multi-cert-gridadmin](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe#multi_cert_gridadmin)   | immediate issuance of multiple service certificates for authorized administrators (new with V2-3) |
| [InstallationNotes.txt](https://twiki.opensciencegrid.org/bin/view/Security/CSReadMe#InstallationNotes_txt) | extra installation requirements for multi-cert-gridadmin (new with V2-3)                          |

FAQ
===

How to perform common tasks. In %RED%red<span class="twiki-macro ENDCOLOR"></span> the items you have to change.

Request a certificate for myself (personal certificate)
-------------------------------------------------------

``` screen
%UCL_PROMPT% cert-request -ou p
```

Full details in the [command line document](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/CertificateGetCmd) or in the [Web interface document](https://twiki.opensciencegrid.org/bin/view/Documentation/CertificateGetWeb) (for a browser based alt.).

Request a certificate for my computer (host certificate)
--------------------------------------------------------

``` screen
%UCL_PROMPT% cert-request -ou s
```

Full details in the [host and service certificates document](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/GetHostServiceCertificates).

Request a certificate for the http service on my computer (service certificate)
-------------------------------------------------------------------------------

``` screen
%UCL_PROMPT% cert-request -ou s -service http -host %RED%my-computer.some.domain%ENDCOLOR% -label %RED%http-my-computer%ENDCOLOR%
```

Full details in the [host and service certificates document](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/GetHostServiceCertificates).

Retrieve a certificate
----------------------

1.  Check the email notice you got when the certificate was granted for the serial number (*0xNNNN*)

``` screen
%UCL_PROMPT% cert-retrieve -serial %RED%0xNNNN%ENDCOLOR% [-label %RED%label-matching-cert-request%ENDCOLOR%]
```

Use the `-p12` option to create the PKCS12 format file useful for importing your certificate into a web browser or email program.

If you need to get lots of service certificates
-----------------------------------------------

1.  Ask your RA to grant you the [gridadmin](http://www.doegrids.org/Library/gridAdmin/gridAdminUser.html) privilege. 2. Use `cert-gridadmin` and you can get service certificates issued immediately without using the web interface.

My personal certificate is about to expire, how do I get another with the same DN?
----------------------------------------------------------------------------------

1.  Use `cert-renew`

Full details in the [command line document](https://twiki.opensciencegrid.org/bin/view/Documentation/Release3/CertificateGetCmd) or in the [Web interface document](https://twiki.opensciencegrid.org/bin/view/Documentation/CertificateGetWeb) (for a browser based alt.).

