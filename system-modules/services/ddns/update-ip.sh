#!/usr/bin/env bash

# Made by https://github.com/K0p1-Git/cloudflare-ddns-updater

auth_email="pepijn.pve@gmail.com"                   # The email used to login 'https://dash.cloudflare.com'
auth_method="token"                                 # Set to "global" for Global API Key or "token" for Scoped API Token
auth_key="$1"                                       # Your API Token or Global API Key
zone_identifier="91cfb4f7664cc0cd3895af09af172ee6"  # Can be found in the "Overview" tab of your domain
record_name="A"                                     # Which record you want to be synced
ttl=3600                                            # Set the DNS TTL (seconds)
proxy="false"                                       # Set the proxy to true or false
# sitename=""                                         # Title of site "Example Site"
# slackchannel=""                                     # Slack Channel #example
# slackuri=""                                         # URI for Slack WebHook "https://hooks.slack.com/services/xxxxx"
# discorduri=""                                       # URI for Discord WebHook "https://discordapp.com/api/webhooks/xxxxx"


###########################################
## Check if we have a public IP
###########################################
ipv4_regex='([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])'
ip=$(curl -s -4 https://cloudflare.com/cdn-cgi/trace | grep -E '^ip'); ret=$?
if [[ ! $ret == 0 ]]; then # In the case that cloudflare failed to return an ip.
    # Attempt to get the ip from other websites.
    ip=$(curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com)
else
    # Extract just the ip from the ip line from cloudflare.
    ip=$(echo "$ip" | sed -E "s/^ip=($ipv4_regex)$/\1/")
fi

# Use regex to check for proper IPv4 format.
if [[ ! $ip =~ ^$ipv4_regex$ ]]; then
    echo -s "DDNS Updater: Failed to find a valid IP."
    exit 2
fi

###########################################
## Check and set the proper auth header
###########################################
if [[ "${auth_method}" == "global" ]]; then
  auth_header="X-Auth-Key:"
else
  auth_header="Authorization: Bearer"
fi

###########################################
## Seek for the A record
###########################################

echo "DDNS Updater: Check Initiated"
record=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records?type=A&name=$record_name" \
                      -H "X-Auth-Email: $auth_email" \
                      -H "$auth_header $auth_key" \
                      -H "Content-Type: application/json")

###########################################
## Check if the domain has an A record
###########################################
if [[ $record == *"\"count\":0"* ]]; then
  echo -s "DDNS Updater: Record does not exist, perhaps create one first? (${ip} for ${record_name})"
  exit 1
fi

###########################################
## Get existing IP
###########################################
old_ip=$(echo "$record" | sed -E 's/.*"content":"(([0-9]{1,3}\.){3}[0-9]{1,3})".*/\1/')
# Compare if they're the same
if [[ $ip == "$old_ip" ]]; then
  echo "DDNS Updater: IP ($ip) for ${record_name} has not changed."
  exit 0
fi

###########################################
## Set the record identifier from result
###########################################
record_identifier=$(echo "$record" | sed -E 's/.*"id":"([A-Za-z0-9_]+)".*/\1/')

###########################################
## Change the IP@Cloudflare using the API
###########################################
update=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_identifier/dns_records/$record_identifier" \
                     -H "X-Auth-Email: $auth_email" \
                     -H "$auth_header $auth_key" \
                     -H "Content-Type: application/json" \
                     --data "{\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\",\"ttl\":$ttl,\"proxied\":${proxy}}")

###########################################
## Report the status
###########################################
case "$update" in
*"\"success\":false"*)
  echo -e "DDNS Updater: $ip $record_name DDNS failed for $record_identifier entry ($ip). DUMPING RESULTS:\n$update" 
  # if [[ $slackuri != "" ]]; then
  #   curl -L -X POST "$slackuri" \
  #   --data-raw '{
  #     "channel": "$slackchannel",
  #     "text" : "'"$sitename"' DDNS Update Failed: '"$record_name"': '"$record_identifier"' ('"$ip"')."
  #   }'
  # fi
  # if [[ $discorduri != "" ]]; then
  #   curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST \
  #   --data-raw '{
  #     "content" : "'"$sitename"' DDNS Update Failed: '"$record_name"': '"$record_identifier"' ('"$ip"')."
  #   }' "$discorduri"
  # fi
  exit 1;;
*)
  echo "DDNS Updater: $ip $record_name DDNS entry updated."
  # if [[ $slackuri != "" ]]; then
  #   curl -L -X POST "$slackuri" \
  #   --data-raw '{
  #     "channel": "'"$slackchannel"'",
  #     "text" : "'"$sitename"' Updated: '$record_name''"'"'s'""' new IP Address is '"$ip"'"
  #   }'
  # fi
  # if [[ $discorduri != "" ]]; then
  #   curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST \
  #   --data-raw '{
  #     "content" : "'"$sitename"' Updated: '$record_name''"'"'s'""' new IP Address is '"$ip"'"
  #   }' "$discorduri"
  # fi
  exit 0;;
esac