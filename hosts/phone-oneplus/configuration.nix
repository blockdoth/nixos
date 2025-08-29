{ pkgs, ... }:
{
  imports = [
    ../../modules/system/options.nix
  ];

  system-modules = {
    presets.defaults.enable = false;
    core = {
      secrets.enable = true;
      tailscale.enable = true;
      ssh.enable = true;
      nix-config.enable = true;
      env.enable = true;
    };
  };

  environment.packages = [ pkgs.git ];
  system.stateVersion = "24.05";
}
