{ pkgs, ... }:
{
  imports = [
    ../../modules/system/options.nix
  ];

  system-modules = {
    presets.defaults.enable = false;
    core = {
      networking.hostname = "phone-redmi";
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
