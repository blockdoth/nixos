#!/usr/bin/env bash
set -e

TYPE=$1
USERNAME=$(whoami)
HOSTNAME=$(cat /etc/hostname)

if [[ "$TYPE" != "home" && "$TYPE" != "system" ]]; then
  echo "Invalid rebuild type specified. Use 'home' or 'system'"
  exit 1
fi

pushd /home/"$USER"/nixos > /dev/null
nixfmt .

git reset > /dev/null 
if [ "$TYPE" = "system" ]; then
  git add ./hosts/* ./system-modules/* ./assets/* ./flake.nix ./flake.lock ./.gitignore 
  git --no-pager diff -U0 --staged .
  nh os switch --hostname "$HOSTNAME" . > /dev/null 
  COMMIT_MESSAGE=$(nixos-rebuild list-generations | sed -n '2p' | awk -v host="$HOSTNAME" -v user="$USERNAME" '{printf "[%s@%s] (%s %s) System Generation %s\n", host, user, $3, substr($4, 0, 5), $1}')
elif [ "$TYPE" = "home" ]; then
  git add ./home/* ./assets/* ./flake.nix ./flake.lock ./.gitignore 
  git --no-pager diff -U0 --staged .
  nh home switch --configuration "$HOSTNAME-$USERNAME" .
  home-manager generations > gen.txt
  COMMIT_MESSAGE=$(head -n 1 gen.txt | awk -v host="$HOSTNAME" -v user="$USERNAME" '{printf "[%s@%s] (%s %s) Home Generation %s\n",host, user,  $1,$2, $5}')
  rm gen.txt
fi

git commit -m "$COMMIT_MESSAGE"
popd > /dev/null
