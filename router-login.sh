#!/usr/bin/env bash
#
# Tested against Linksys LRT224
# Copy env.template to env, and add router user name and password
# To use, include these arguments when invoking CURL:
#   -b "$DIR/cookies.txt" -c "$DIR/cookies.txt"
#
# Failure codes
#  1   General failure
#  2   Login failed


# Script directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


# Get router address
router_addr="$($DIR/router-address.sh)"


# MD5 selection
function hash_function
{
  command -v md5 >/dev/null 2>&1
  if [ "$?" -eq "0" ];
  then
    echo -n "$1" | md5
  else
    echo -n "$1" | md5sum | sed -n 's/^\([0-9a-f]*\) .*$/\1/p'
  fi
}


# Get the auth key
auth_key=$(curl --silent --insecure "$router_addr/cgi-bin/welcome.cgi" | grep "name=\"auth_key\"" | sed -n 's/^.*value="\([0-9]*\)".*$/\1/p')


# Convert the password
. $DIR/env
router_pw_hash=$(hash_function "$router_pw$auth_key")


# Submit the form
curl --silent --insecure -X POST -c "$DIR/cookies.txt" \
-o /dev/null \
-F "username=$router_un" \
-F "password=$router_pw_hash" \
"$router_addr/cgi-bin/userLogin.cgi"
login_result=$?


# Verify the login worked
if [ "$login_result" -ne "0" ];
then
  echo "Login to the router failed. Check password, and try a manual login."
  exit 2
fi
