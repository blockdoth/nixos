# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:
let 
  theme = "oxocarbon-dark";
in {
  imports =
    [
      ./hardware.nix 
      ../../system/localisation
      ../../system/nix-config
      ../../system/pipewire
      ../../system/ssh  
      ../../system/boot/dual
      ../../system/display
      ../../system/gaming
    ];

  stylix.enable = true;
  stylix.base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/everforest.yaml";

  security.sudo.wheelNeedsPassword = false;
  users.users.desktop-pepijn = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager"];
  };

  users.defaultUserShell = pkgs.fish;
  programs = {
    fish.enable = true; 
  };

  networking = {
    hostName = "desktop-pepijn";
    networkmanager.enable = true;
  };


  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

}
