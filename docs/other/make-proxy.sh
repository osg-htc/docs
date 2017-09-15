#!/bin/sh
# Script to refresh the a proxy with VO attributes - Marco Mambelli marco@hep.uchicago.edu
# make-proxy [--no-voms-proxy]
#  --no-voms-proxy creates only a grid proxy from the certificates (2a below), no VOMS proxy command is run
# TO RUN THE SCRIPT
# 0. Save this script and make sure that it is executable
# 1. Personalize the script by filling correctly the variables below
# 2a. If you provide CERT_FILE and KEY_FILE these will be used to generate the base-proxy 
#    make sure that ownership and permissions are correct
#    and there is no need for 2b
# 2b. Generate the base-proxy (user-proxy) with something like
#    (where IN_NAME="/full_path_to_base_proxy"):
#    As owner of the certificate used to generate the base proxy:
#      grid-proxy-init -valid 8800:0 -out /full_path_to_base_proxy -old 
#    Then ss root: 
#      chown user_that_owns_vo_proxy  /full_path_to_base_proxy
#      chmod 0600  /full_path_to_base_proxy
#  Remember that the proxy needs to be renewed once a year  (you will receive an email)
# 3. Add a Cron entry like
#    10 * * * * /full_path_to_script_make-proxy



# A cron entry like
# 10 * * * * . /share/wlcg-client/setup.sh; voms-proxy-init -valid 48:0 -voms voms_option -key $HOME/.globus/base_proxy -cert $HOME/.globus/base_proxy -out my_proxy_with_atlas_voms_attribute >/dev/null 2>&1 
# will provide similar results but not send the warning emails like this script


#### VARIABLES to PERSONALIZE
# Setup file, if needed (not needed if the Grid sw is installed via RPM)
SETUP_FILE=""
# If you are using a certificate/key pair (2a) instead of a proxy then define CERT_FILE & KEY_FILE
CERT_FILE="/var/lib/gwms-frontend/hostcert.pem"
KEY_FILE="/var/lib/gwms-frontend/hostkey.pem"
# base-proxy (user-proxy) 
IN_NAME="/var/lib/gwms-frontend/frontend_base_proxy"
# provy with VO attributes used by the application
OUT_NAME="/tmp/vofe_proxy"
# These emails (OWNER_EMAIL, CC_EMAIL) will receive a message if the base-proxy is missing, expired os about to expire
# E.g. You can send th email to the owner and add a support mailing list in CC (this may be empty)
OWNER_EMAIL="name@uchicago.edu"
CC_EMAIL=""
# Proxy description used in the email sent when the proxy is missing, expired os about to expire
PROXY_DESCRIPTION="VO Fronted on ui-gwms"
# The VO option for the proxy, usually "voname:/voname"
VOMS_OPTION=""
VOMS_EXTRA_OPTION="-dont-verify-ac"

##### PARAMETERS
VOMS_ACTION=
PROXY_TIME="500:0"
PROXY_VERTIME="150:0"
VOMS_PROXY_TIME="64:0"

if [ "x$1" == "x--no-voms-proxy" ]; then
   VOMS_ACTION="novoms"
   PROXY_TIME="50:0"
   PROXY_VERTIME="24:0"
fi

##### SCRIPT
EMAIL_MESSAGE="
Generate the base-proxy used by $PROXY_DESCRIPTION by doing the following.
As owner of the certificate used to generate the base proxy:
 grid-proxy-init -valid 8800:0 -out /tmp/tmp_proxy -old 
Then as root: 
 cp /tmp/tmp_proxy $IN_NAME
 chown $USER $IN_NAME
 chmod 0600 $IN_NAME
 rm /tmp/tmp_proxy"
CC_EMAIL_OPTION=""
if [[ ! "x$CC_EMAIL" == "x" ]]
then
   CC_EMAIL_OPTION="-c $CC_EMAIL"
fi
VOMS_OPTION_STRING=""
if [[ ! "x$VOMS_OPTION" == "x" ]]
then
   VOMS_OPTION_STRING="-voms $VOMS_OPTION"
fi


if [[ ! -z $SETUP_FILE && -f $SETUP_FILE ]]
then
   source $SETUP_FILE
fi
NEW_CERT_MESSAGE=""
if [[ ! -z $CERT_FILE &&  ! -z $KEY_FILE && -f $CERT_FILE && -f $KEY_FILE ]]
then
   NEW_CERT_MESSAGE="Th proxy was generated from the certificate $CERT_FILE and key $KEY_FILE."
   grid-proxy-init -valid $PROXY_TIME -key $KEY_FILE  -cert $CERT_FILE -out $IN_NAME >/dev/null 2>&1
   if [ $? -ne 0 ]; then
      echo -e "The generation of the proxy file $IN_NAME for $PROXY_DESCRIPTION failed.\n Please login on `hostname` and check the certificate $CERT_FILE and key $KEY_FILE. As $USER run manually:\ngrid-proxy-init -valid $PROXY_TIME -key $KEY_FILE  -cert $CERT_FILE -out $IN_NAME" | mail -s "$PROXY_DESCRIPTION proxy error due to certificates." $OWNER_EMAIL $CC_EMAIL_OPTION
      exit 0
   fi
fi

if [ -f $IN_NAME ]; 
then
   grid-proxy-info -exists -valid $PROXY_VERTIME -file $IN_NAME
   if [ $? -ne 0 ]; then
      echo "The proxy file $IN_NAME for $PROXY_DESCRIPTION has or will expire soon. $NEW_CERT_MESSAGE $EMAIL_MESSAGE" | mail -s "$PROXY_DESCRIPTION proxy has or will expire soon." $OWNER_EMAIL -c $CC_EMAIL
   fi
else
   echo "The proxy file $IN_NAME for $PROXY_DESCRIPTION is missing. $NEW_CERT_MESSAGE $EMAIL_MESSAGE" | mail -s "Missing $PROXY_DESCRIPTION proxy" $OWNER_EMAIL $CC_EMAIL_OPTION
fi

# Exit if no VOMS proxy is required
if [ "x$VOMS_ACTION" == "xnovoms" ]; then
   cp $IN_NAME $OUT_NAME
   chmod 600 $OUT_NAME
   exit 0
fi

voms-proxy-init -valid $VOMS_PROXY_TIME -key $IN_NAME -cert $IN_NAME $VOMS_OPTION_STRING -out $OUT_NAME $VOMS_EXTRA_OPTION >/dev/null 2>&1
if [ $? -ne 0 ]; then
   echo -e "The proxy file $IN_NAME seems OK but voms-proxy-init is failing. $NEW_CERT_MESSAGE\nPlease login on `hostname` and as $USER run manually:\nvoms-proxy-init -valid $VOMS_PROXY_TIME -key $IN_NAME -cert $IN_NAME $VOMS_OPTION_STRING -out $OUT_NAME $VOMS_EXTRA_OPTION" | mail -s "$PROXY_DESCRIPTION proxy renewal broken." $OWNER_EMAIL $CC_EMAIL_OPTION
fi


