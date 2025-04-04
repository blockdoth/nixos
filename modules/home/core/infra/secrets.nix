{
  config,
  inputs,
  lib,
  ...
}:
let
  module = config.modules.core.infra.secrets;
  keysFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  config = lib.mkIf module.enable {
    sops = {
      defaultSopsFile = ../../../../secrets.yaml;
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
