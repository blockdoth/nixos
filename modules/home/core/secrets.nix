{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  config = {
    sops = {
      defaultSopsFile = ../../../secrets.yaml;
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
