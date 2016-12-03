#!/usr/bin/env bash
#
# Tested against Linksys LRT224
# Copy env.template to env, and add router user name and password
#
# Failure codes
#  1   General failure
#  2   Login failed
#  3   Restart request failed (Part 1 of 2)
#  5   Restart trigger failed (Part 2 of 2)


# Script directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


# Get router address
router_addr="$($DIR/router-address.sh)"


# # MD5 selection
# function hash_function
# {
#   command -v md5 >/dev/null 2>&1
#   if [ "$?" -eq "0" ];
#   then
#     echo -n "$1" | md5
#   else
#     echo -n "$1" | md5sum | sed -n 's/^\([0-9a-f]*\) .*$/\1/p'
#   fi
# }
#
#
# # Get the auth key
# auth_key=$(curl --silent --insecure "$router_addr/cgi-bin/welcome.cgi" | grep "name=\"auth_key\"" | sed -n 's/^.*value="\([0-9]*\)".*$/\1/p')
#
#
# # Convert the password
# . $DIR/env
# router_pw_hash=$(hash_function "$router_pw$auth_key")
#
#
# # Submit the form
# curl --silent --insecure -X POST -c "$DIR/cookies.txt" \
# -o /dev/null \
# -F "username=$router_un" \
# -F "password=$router_pw_hash" \
# "$router_addr/cgi-bin/userLogin.cgi"
# login_result=$?
#
#
# # Verify the login worked
# if [ "$login_result" -ne "0" ];
# then
#   echo "Login to the router failed. Check password, and try a manual login."
#   exit 2
# fi

# Login to the router
# Provides $DIR/cookies.txt
$DIR/router-login.sh


# Restart is two parts
# Request the restart
restart_1=$(curl --silent --insecure -X POST -b "$DIR/cookies.txt" -c "$DIR/cookies.txt" \
-w "%{http_code}" \
-o /dev/null \
-F "workType=restart" \
-F "page=sys_restart.htm" \
-F "restart=Restart Router" \
"$router_addr/sys_restart.htm")
restart_1_result=$?

if [ "$restart_1_result" -ne "0" ];
then
  echo "Restart failed during step 1 of 2."
  exit 3
fi


# Now trigger the restart
restart_2=$(curl --silent --insecure -b "$DIR/cookies.txt" \
-w "%{http_code}" \
-o /dev/null \
"$router_addr/Rebooting.htm")
restart_2_result=$?

if [ "$restart_2_result" -ne "0" ];
then
  echo "Restart failed during step 2 of 2."
  exit 5
fi


# Everything seems to have worked fine
rm "$DIR/cookies.txt" 2>/dev/null
exit 0
