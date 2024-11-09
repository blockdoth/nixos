#!/usr/bin/env bash
set -e
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Rebuilds, format and commits either system or home"
  echo ""
  echo "Usage: $(echo "$0" | awk -F'-' '{print $2}') <home|system> <identifier>"
  exit 1
fi

TYPE=$1
NAME=$2
# for some reason this is needed because hostname is set lower case
# shellcheck disable=SC2154
HOSTNAME=$(cat /etc/hostname)

if [[ "$TYPE" != "home" && "$TYPE" != "system" ]]; then
  echo "Invalid type specified. Use 'home' or 'system'"
  exit 1
fi

pushd /home/"$USER"/nixos > /dev/null
nixfmt .
git diff -U0 ./*.nix

if [ "$TYPE" = "home" ]; then
  nh home switch --configuration "$NAME" .
  MESSAGE=$(home-manager generations | head -n 1 | awk -v host="$HOSTNAME" -v user="$USER" '{printf "[%s@%s] (%s %s) Home Generation %s",host, user,  $1,$2, $5}')
elif [ "$TYPE" = "system" ]; then
  nh os switch --hostname "$NAME" .
  MESSAGE=$(nixos-rebuild list-generations | sed -n '2p' | awk -v host="$HOSTNAME" -v user="$USER" '{printf "[%s@%s] (%s %s) System Generation %s", host, user, $3, substr($4, 0, 5), $1}')
fi

git commit -am "$MESSAGE"
echo "Committed new generation with message:"
echo "$MESSAGE"
popd > /dev/null
