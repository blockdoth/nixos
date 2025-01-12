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
<<<<<<< HEAD
        keyFile = "/home/blockdoth/.config/sops/age/keys.txt"; # TODO make user agnostic
=======
        keyFile = "/var/lib/sops-nix/key.txt";
>>>>>>> 16db91cbe4ee7392bdec7c8767c4743c9937d65d
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        generateKey = true;
      };
      secrets = {
        atuin-key = { };
      };
    };
  };
}
