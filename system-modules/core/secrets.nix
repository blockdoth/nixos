{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  module = config.system-modules.core.nix-config;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      age
      sops
      ssh-to-age
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      validateSopsFiles = false;

      age = {
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        generateKey = true;
      };
      secrets = {
        penger-password = { };
        blockdoth-password = { };
      };
    };
  };
}
