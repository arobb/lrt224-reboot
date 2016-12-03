#!/usr/bin/env bash

# Get router address
router_ip=$(netstat -rn | grep 'UG' | awk '{print $2}' | grep '^[0-9]\{1,3\}\.')
router_addr="https://$router_ip"

echo "$router_addr"
