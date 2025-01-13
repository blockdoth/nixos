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
      age = {
        sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
        generateKey = true;
      };
      secrets = {
        atuin-key = { };
      };
    };
  };
}
