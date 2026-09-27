{
  # pkgs,
  # config,
  ...
}:
{
  imports = [
    ../../modules/system/options.nix
    ./hardware.nix
    # ./disko.nix
  ];

  system-modules = {
    users = {
      blockdoth.enable = true;
      clausum.enable = true;
    };
    core.networking = {
      hostname = "desktop";
      # blocking = {
      #   enable = true;
      #   user = "clausum";
      # };
    };
    presets = {
      gui.enable = true;
      # zenmode.enable = true;
      gaming.enable = true;
    };
    common = {
      bluetooth.enable = true;
      docker.enable = false;
      crosscompilation.enable = true;
      filemanager.enable = true;
      printing.enable = true;
      keyboard.enable = true;
      impermanence.enable = false;
    };
    services = {
      # network.pihole.enable = true;
      # attic.enable = true;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
