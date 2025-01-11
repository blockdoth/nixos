{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options = {
    modules.core.utils.secrets.enable = lib.mkEnableOption "Enables secrets";
  };

  config = lib.mkIf config.modules.core.utils.secrets.enable {
    sops = {
      defaultSopsFile = ../../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/blockdoth/.config/sops/age/keys.txt"; # TODO make user agnostic
      secrets = {
        "mail/personal" = { };
        "name/alias" = { };
      };
    };
  };
}
