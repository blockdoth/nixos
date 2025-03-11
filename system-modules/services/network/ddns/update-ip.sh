#!/usr/bin/env bash

# Inspired by https://github.com/K0p1-Git/cloudflare-ddns-updater

AUTH_TOKEN=$(cat)                                   # Your API Token or Global API Key
ZONE_ID="91cfb4f7664cc0cd3895af09af172ee6"          # Can be found in the "Overview" tab of your domain
RECORD_NAME="insinuatis.com"                        # Which record you want to be synced
ttl=3600                                            # Set the DNS TTL (seconds)
proxy="false"                                       # Set the proxy to true or false

## Check if we have a public IP
ipv4_regex='([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])'
IP=$(curl -s -4 https://cloudflare.com/cdn-cgi/trace | grep -E '^ip'| sed -E "s/^ip=($ipv4_regex)$/\1/")

## Seek for the A record
echo "DDNS Updater: Check Initiated"
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD_NAME" \
                      -H "Authorization: Bearer $AUTH_TOKEN" \
                      -H "Content-Type: \"application/json\"")

## Check if the domain has an A record
if [[ $record == *"\"count\":0"* ]]; then
  echo "DDNS Updater: Record does not exist, perhaps create one first? (${IP} for ${RECORD_NAME})"
  exit 1
fi

## Get existing IP
OLD_IP=$(echo "$record" | sed -E 's/.*"content":"(([0-9]{1,3}\.){3}[0-9]{1,3})".*/\1/')

# Compare if they're the same
if [[ $IP == "$OLD_IP" ]]; then
  echo "DDNS Updater: IP ($IP) for ${RECORD_NAME} has not changed."
  exit 0
fi

## Set the record identifier from result
DNS_RECORD_ID=$(echo "$record" | sed -E 's/.*"id":"([A-Za-z0-9_]+)".*/\1/')

## Change the IP@Cloudflare using the API
update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" \
                      -H "Authorization: Bearer $AUTH_TOKEN" \
                      -H "Content-Type: application/json" \
                      -d "{\"type\": \"A\", \"content\": \"$IP\", \"name\": \"$RECORD_NAME\", \"proxied\": $proxy, \"ttl\": $ttl }"
        )

## Report the status
case "$update" in
*"\"success\":false"*)
  echo -e "DDNS Updater: $IP $RECORD_NAME DDNS failed for $DNS_RECORD_ID entry ($IP). DUMPING RESULTS:\n" 
  echo "$update" | jq
  exit 1;;
*)
  echo "DDNS Updater: $IP $RECORD_NAME DDNS entry updated."
  exit 0;;
esac