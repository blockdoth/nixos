{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    system-modules.common.secrets.enable = lib.mkEnableOption "Enables secrets";
  };

  config = lib.mkIf config.system-modules.common.secrets.enable {
    environment.systemPackages = with pkgs; [
      age
      sops
      ssh-to-age
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age = {
        keyFile = "/home/blockdoth/.config/sops/age/keys.txt"; # TODO make user agnostic
        # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        # generateKey = true;
      };
      secrets = {
        "users/penger/password" = { };
        "users/blockdoth/password" = { };
      };

    };
  };
}
