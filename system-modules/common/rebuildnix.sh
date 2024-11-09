#!/usr/bin/env bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $(echo $0 | awk -F'-' '{print $2}') <hostname>"
  exit 1
fi

pushd /home/$USER/nixos
nixfmt . &>/dev/null
git diff -U0 *.nix
nh os switch --hostname $1 .
gen=$(nixos-rebuild list-generations | rg current)
git commit -am "$gen"
popd