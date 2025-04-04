#!/usr/bin/env bash


USERNAME="penger"
HOSTNAME="nuc"

pushd /home/"$USER"/nixos > /dev/null
nixfmt . 2>/dev/null

git reset > /dev/null 
git add ./hosts/* ./system-modules/* ./assets/* ./flake.nix ./flake.lock ./.gitignore ./.sops.yaml ./secrets/*
git --no-pager diff -U0 --staged .

NUC_IP=$(tailscale status | rg "$HOSTNAME" | awk '{print $1}')

sudo nixos-rebuild --target-host "$USERNAME"@"$NUC_IP" --use-remote-sudo switch --flake .#"$HOSTNAME"
COMMIT_MESSAGE=$(nixos-rebuild list-generations | sed -n '2p' | awk -v host="$HOSTNAME" -v user="$USERNAME" '{printf "[%s@%s] (%s %s) System Generation %s\n", host, user, $3, substr($4, 0, 5), $1}')

git commit -m "$COMMIT_MESSAGE"
popd > /dev/null
