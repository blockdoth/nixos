{
  pkgs,
  config,
  lib,
  hostname,
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
      shellAliases = lib.mkMerge [
        {
          cls = "clear";
          conf = "cd /home/${config.home.username}/nixos";
          repos = "cd /home/${config.home.username}/Documents/repos";
          btm = "btm --process_memory_as_value -g";
          mkscript = "echo '#!/usr/bin/env bash' > script-template.sh && chmod +x script-template.sh";
          log = "git log --graph --pretty=format:'%C(bold red)%h%Creset - %C(bold blue)%an%Creset%C(auto)%d%Creset %s %C(yellow)%ad%Creset %Cgreen(%cr) ' --abbrev-commit --date=human --decorate=full --all";
          penger = "ssh penger@nuc";
          laptop = "ssh blockdoth@laptop";
          desktop = "ssh blockdoth@desktop";
          temp = "cd ~/Documents/temp/";
        }
        (lib.mkIf (config.home.username != "penger") {
          # Graphical
          config = "confh && codium .";
          lock = "kill hyprlock && hyprlock";
          print = "firefox -new-tab https://printportal.tudelft.nl:9443/end-user/ui/dashboard";
        })
      ];
    };
  };
}
