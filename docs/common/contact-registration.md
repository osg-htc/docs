DateReviewed: 2022-12-16

Registering Contact Information
===============================

OSG staff keep track of contact information for OSG Consortium participants to provide access to OSG services,
notify administrators and security contacts of software and security updates,
and coordinate in case of security incidents or troubleshooting services.

The OSG contact management service is backed by [InCommon federation](https://www.incommon.org/federation/),
meaning that contacts may register with the OSG using their institutional identities with familiar Single Sign-On forms.

!!! info "Privacy Notice"
    The OSG treats any email addresses and phone numbers as confidential data but does not make any guarantees of
    privacy.
    All other data is public (such as name, GitHub username, and any association with particular services or
    collaborations).

Submitting an Application
-------------------------

To register with the OSG, submit an application using the self-signup process:

1.  Visit <https://osg-htc.org/register>

1.  You will be presented with a Single-Sign On page.
    Select your insitution and sign in with your insitutional credentials:

    !!! question "Help, my institution does not show up in the drop-down!"
        If your institution does not show up in the drop-down menu, then your institution is not part of the
        [InCommon federation](https://www.incommon.org/federation/).
        In this case, we recommend using an [ORCID account](https://orcid.org/) instead, registering a new one if necessary.

    ![CILogon Single-Sign On page](../img/comanage/comanage-sso.png)

1.  After you have signed in, you will be presented with the self-signup form.
    Click the "BEGIN" button:

    ![COManage self-signup form](../img/comanage/comanage-landing-page.png)

1.  Enter your name, email address, GitHub username (optional), and a comment describing why you are registering as a
    participant in the OSG Consortium.
    Your institution may provide defaults for your name and email address but you may override these values.
    Once you have updated all the fields to your liking, click the "SUBMIT" button:

    ![COManage enrollment form](../img/comanage/comanage-enrollment-form.png)

Verifying Your Email Address
----------------------------

After submitting your registration application, you will receive an email from <registry@cilogon.org> to verify your email
address.
Follow the link in the email and click the "Accept" button to complete the verification:

!!! tip "Wait for URL redirection"
     After clicking the email verification link, be sure to let the page to completely load (you will be redirected back
     to this page), otherwise you may have issues completing your registration.
     If you believe this has happened to you, please [contact us](#getting-help) for assistance.

!!! question "Help, my email verification link has expired!"
    If the email verification link has expired, please [contact us](#getting-help) to request a new verification link.

![COManage verification email](../img/comanage/comanage-email-verification-form.png)

Waiting for Approval
--------------------

After verifying your email address, your registration application must be approved by OSG staff.
Once your registration application has been approved, you will receive a confirmation email:

![COManage approval email](../img/comanage/comanage-verified-email.png)

Once you have received your confirmation email, you may start using OSG services such as
[registering your resources](registration.md).

OASIS Managers: Adding an SSH Key
---------------------------------

After approval by OSG staff, [OASIS managers](../data/update-oasis.md) must upload a public
SSH key before being able to access the OASIS login host:

1.  Visit <https://osg-htc.org/register> and login if prompted

1.  Click your name in the top right to get a dropdown and click the `My Profile (OSG)` button

    ![COManage profile dropdown](../img/comanage/ssh-homepage-dropdown.png)

1.  On the right-side of your profile, click the `Authenticators` link:

    ![COManage user profile](../img/comanage/ssh-edit-profile.png)

1.  On the authenticators page, click the `Manage` button:

    ![COManage authenticators](../img/comanage/ssh-authenticator-select.png)

1.  On the SSH keys page, click the `Add SSH Key` link:

    ![COManage SSH keys](../img/comanage/ssh-key-list.png)

1.  Finally, upload your public SSH key from your computer:

    ![COManage upload SSH key](../img/comanage/ssh-add-key.png)

Getting Help
------------

For assistance with the OSG contact registration process, please use
[this page](https://osg-htc.org/docs/common/help/).
