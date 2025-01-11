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
        keyFile = "/var/lib/sops-nix/key.txt";
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        generateKey = true;
      };
      secrets = {
        atuin-key = { };
      };
    };
  };
}
