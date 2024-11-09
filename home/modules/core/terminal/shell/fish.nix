{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.core.terminal.shell.fish.enable = lib.mkEnableOption "Enables fish";
  };

  config = lib.mkIf config.modules.core.terminal.shell.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
              direnv hook fish | source
          		set fish_greeting # Disable greeting
        		'';
      shellAliases = {
        cls = "clear";
        conf = "cd /home/blockdoth/nixos";
        repos = "cd /home/blockdoth/Documents/repos";
        hr-blockdoth = "conf && home-manager switch --flake .#blockdoth";
        hr-headless = "conf && home-manager switch --flake .#headless";
        nr-desktop = "conf && sudo nixos-rebuild switch --flake .#desktop";
        nr-server = "conf && sudo nixos-rebuild switch --flake .#server";
        nr-laptop = "conf && sudo nixos-rebuild switch --flake .#laptop";

        btm = "btm --mem_as_value -g";
        config = "confh && codium .";
        mkscript = "echo '#!/usr/bin/env bash' > script-template.sh && chmod +x script-template.sh";
        lock = "kill hyprlock && hyprlock";
        print = "firefox -new-tab https://printportal.tudelft.nl:9443/end-user/ui/dashboard";
      };
    };
  };
}
