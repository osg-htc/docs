#!/bin/sh
# Script to control the existence and correctness of voms proxies
# 0. Save this script and make sure that it is executable
# 1. Personalize the script by filling correctly the variables below
# 2. Add a Cron entry like
#    10 * * * * /full_path_to_script_make-proxy-control


#### VARIABLES to PERSONALIZE
# Setup file, if needed (not needed if the Grid sw is installed via RPM)
SETUP_FILE=""
# These emails (OWNER_EMAIL, CC_EMAIL) will receive a message if the base-proxy is missing, expired os about to expire
# E.g. You can send th email to the owner and add a support mailing list in CC (this may be empty)
OWNER_EMAIL="name@uchicago.edu"
CC_EMAIL=""
# Comma separated list of the voms proxies to check
PROXY_LIST="/tmp/vofe_proxy,/tmp/vofe_gi_delegated_proxy"


##### SCRIPT
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

NEW_MESSAGE="Controlling certificates:\n"


arr=$(echo $PROXY_LIST | tr "," "\n")

for x in $arr
do
    NEW_MESSAGE="${NEW_MESSAGE}* Executing: voms-proxy-info -all -file $x\n`voms-proxy-info -all -file $x` \n"
done
      

echo -e "Running test on `hostname` as $USER. \n$NEW_MESSAGE" | mail -s "Proxy summary on `hostname`" $OWNER_EMAIL $CC_EMAIL_OPTION



