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
      age.keyFile = "/home/blockdoth/.config/sops/age/keys.txt"; # TODO make user agnostic
      secrets = {
        "users/penger/password" = { };
        "users/blockdoth/password" = { };
        "hosts/desktop/keys/rsa/public" = { };
      };
    };
  };
}
