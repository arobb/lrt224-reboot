#!/usr/bin/env bash
#
# Use: ./router-redirect.sh moveToIface1
# Use: ./router-redirect.sh moveToIface2
#
# PortBindingList=1{192.168.10.40 ;192.168.10.49 (0.0.0.0;0.0.0.0)1}1
# PortBindingList=1{192.168.10.100;192.168.10.199(0.0.0.0;0.0.0.0)0}2
# PortBindingList=1{192.168.10.100;192.168.10.199(0.0.0.0;0.0.0.0)1}1
# PortBindingList=Protocol {Internal addr start; Internal addr end(dest start; dest end) status } interface
#
# Protocol 1 = All traffic
# Status 0 = Disabled
# Status 1 = Enabled
# Interface 1 = WAN Port 1
# Interface 2 = WAN Port 2

if [ -z "$1" ];
then
  echo "Nothing to do. Tell me which interface to move to: moveToIface1 or moveToIface2"
  exit
fi


range1enabled='PortBindingList=1%7B192.168.10.100%3B192.168.10.199%280.0.0.0%3B0.0.0.0%291%7D1'
range1disabled='PortBindingList=1%7B192.168.10.100%3B192.168.10.199%280.0.0.0%3B0.0.0.0%290%7D1'

range2enabled='PortBindingList=1%7B192.168.10.100%3B192.168.10.199%280.0.0.0%3B0.0.0.0%291%7D2'
range2disabled='PortBindingList=1%7B192.168.10.100%3B192.168.10.199%280.0.0.0%3B0.0.0.0%290%7D2'

base='page=edit_sys_dualwan3.htm&submitStatus=1&log_ch=1&iName=&editInterface=1&LanIp=192.168.10.1&LanMask=255.255.255.0&service_menu=%3Coption+value%3D%221%22%3EAll+Traffic+%5BTCP%26UDP%2F1%7E65535%5D%3C%2Foption%3E%3Coption+value%3D%222%22%3EDNS+%5BUDP%2F53%7E53%5D%3C%2Foption%3E%3Coption+value%3D%223%22%3EFTP+%5BTCP%2F21%7E21%5D%3C%2Foption%3E%3Coption+value%3D%224%22%3EHTTP+%5BTCP%2F80%7E80%5D%3C%2Foption%3E%3Coption+value%3D%225%22%3EHTTP+Secondary+%5BTCP%2F8080%7E8080%5D%3C%2Foption%3E%3Coption+value%3D%226%22%3EHTTPS+%5BTCP%2F443%7E443%5D%3C%2Foption%3E%3Coption+value%3D%227%22%3EHTTPS+Secondary+%5BTCP%2F8443%7E8443%5D%3C%2Foption%3E%3Coption+value%3D%228%22%3ETFTP+%5BUDP%2F69%7E69%5D%3C%2Foption%3E%3Coption+value%3D%229%22%3EIMAP+%5BTCP%2F143%7E143%5D%3C%2Foption%3E%3Coption+value%3D%2210%22%3ENNTP+%5BTCP%2F119%7E119%5D%3C%2Foption%3E%3Coption+value%3D%2211%22%3EPOP3+%5BTCP%2F110%7E110%5D%3C%2Foption%3E%3Coption+value%3D%2212%22%3ESNMP+%5BUDP%2F161%7E161%5D%3C%2Foption%3E%3Coption+value%3D%2213%22%3ESMTP+%5BTCP%2F25%7E25%5D%3C%2Foption%3E%3Coption+value%3D%2214%22%3ETELNET+%5BTCP%2F23%7E23%5D%3C%2Foption%3E%3Coption+value%3D%2215%22%3ETELNET+Secondary+%5BTCP%2F8023%7E8023%5D%3C%2Foption%3E%3Coption+value%3D%2216%22%3ETELNET+SSL+%5BTCP%2F992%7E992%5D%3C%2Foption%3E%3Coption+value%3D%2217%22%3EDHCP+%5BUDP%2F67%7E67%5D%3C%2Foption%3E%3Coption+value%3D%2218%22%3EL2TP+%5BUDP%2F1701%7E1701%5D%3C%2Foption%3E%3Coption+value%3D%2219%22%3EPPTP+%5BTCP%2F1723%7E1723%5D%3C%2Foption%3E%3Coption+value%3D%2220%22%3EIPSec+%5BUDP%2F500%7E500%5D%3C%2Foption%3E%3Coption+value%3D%2221%22%3EESP+%5BESP%2F0%7E0%5D%3C%2Foption%3E%3Coption+value%3D%2222%22%3EGRE+%5BGRE%2F0%7E0%5D%3C%2Foption%3E%3Coption+value%3D%2223%22%3EAll+IP+Traffic+%5BALL%2F0%7E0%5D%3C%2Foption%3E%3Coption+value%3D%2225%22%3ESSH+%5BTCP%2F22%7E22%5D%3C%2Foption%3E%3Coption+value%3D%2226%22%3ESpreedBox+Config+%5BTCP%2F8000%7E8000%5D%3C%2Foption%3E%3Coption+value%3D%2227%22%3EOpenVPN+UDP+%5BUDP%2F1194%7E1194%5D%3C%2Foption%3E%3Coption+value%3D%2228%22%3EOpenVPN+UDP+2+%5BUDP%2F1195%7E1195%5D%3C%2Foption%3E%3Coption+value%3D%2229%22%3EICMP+%5BICMP%2F0%7E0%5D%3C%2Foption%3E&NsdHostValue=NO&NsdHostValue=NO&NsdHostValue=NO&NsdHostValue=NO&NsdHostValue=NO&NsdHostValue=NO&NsdHostValue=NO&DnsHostValue=google.com&DnsHostValue=akamai.com&DnsHostValue=+&DnsHostValue=+&DnsHostValue=+&DnsHostValue=+&DnsHostValue=+&isDMZmode=0&IPRange1=192&IPRange2=168&IPRange3=10&modeLB0=1&forbiddenIP=0.0.0.0&wanNumbers=2&BaLanceMode=1&SmartLKW=1&modeLB=1&nsd_enabled1=0&nsd_enabled2=0&nsd_retry_count1=3&nsd_retry_count2=3&nsd_retry_timeout1=1&nsd_retry_timeout2=1&nsd_action1=1&wan_nsd_def_gw1=0&wan_nsd_def_gw2=0&isphost_enabled1=0&wan_nsd_isp_host1=&isphost_enabled2=0&wan_nsd_isp_host2=&remotehost_enabled1=1&remotehost_enabled_check1=1&wan_nsd_remote_host1=8.8.8.8&remotehost_enabled2=1&remotehost_enabled_check2=1&wan_nsd_remote_host2=8.8.4.4&dnshost_enabled1=0&wan_nsd_dns_host1=google.com&dnshost_enabled2=0&wan_nsd_dns_host2=akamai.com&V_protocol=1&srcIPStart=&srcIPEnd=&destIPStart=&destIPEnd=&iFace=1&PortBindingList=1%7B192.168.10.40%3B192.168.10.49%280.0.0.0%3B0.0.0.0%291%7D1'


# Script directory
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )


function doMove()
{
  body=$1

  # Get router address
  router_addr="$($DIR/router-address.sh)"

  # Login
  # Provides $DIR/cookies.txt
  $DIR/router-login.sh

  enableIface=$(curl "$router_addr/edit_sys_dualwan3.htm" \
  --silent --insecure -X POST \
  -b "$DIR/cookies.txt" -c "$DIR/cookies.txt" \
  -w "%{http_code}" \
  -o /dev/null \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data $body \
  )
  result=$?

  echo $enableIface

  return $result
}


if [ "$1" == "moveToIface1" ];
then
  body="$base&$range1enabled&$range2disabled"

  doMove "$body"
  result=$?

  if [ "$result" -ne "0" ];
  then
    echo "Redirect to interface 1 failed."
    exit 3
  fi
fi


if [ "$1" == "moveToIface2" ];
then
  body="$base&$range1disabled&$range2enabled"

  doMove "$body"
  result=$?

  if [ "$result" -ne "0" ];
  then
    echo "Redirect to interface 2 failed."
    exit 3
  fi
fi


# Everything seems to have worked fine
rm "$DIR/cookies.txt" 2>/dev/null
exit 0
