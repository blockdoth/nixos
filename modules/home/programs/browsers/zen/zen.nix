{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.browsers.zen;
  mkLockedAttrs = builtins.mapAttrs (
    _: value: {
      Value = value;
      Status = "locked";
    }
  );
in
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  config = lib.mkIf module.enable {
    programs.zen-browser = {
      enable = true;
      policies = import ./policies.nix;
      profiles.default = {
        isDefault = true;
        search = import ./search.nix pkgs;
        pins = import ./pins.nix;
        extensions = import ./extensions.nix;
        settings = mkLockedAttrs (import ./settings.nix { config = config; });
      };
    };
  };
}
