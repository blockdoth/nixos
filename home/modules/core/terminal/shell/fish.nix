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

              function cl
                if test (count $argv) -gt 0
                  builtin cd $argv[1]
                else
                  builtin cd
                end
                ls
              end              
        		'';
      shellAliases = {
        cls = "clear";
        conf = "cd /home/blockdoth/nixos";
        repos = "cd /home/blockdoth/Documents/repos";
        btm = "btm --mem_as_value -g";
        config = "confh && codium .";
        mkscript = "echo '#!/usr/bin/env bash' > script-template.sh && chmod +x script-template.sh";
        lock = "kill hyprlock && hyprlock";
        print = "firefox -new-tab https://printportal.tudelft.nl:9443/end-user/ui/dashboard";
        log = "git log --graph --pretty=format:'%C(bold red)%h%Creset - %C(bold blue)%an%Creset%C(auto)%d%Creset %s %C(yellow)%ad%Creset %Cgreen(%cr) ' --abbrev-commit --date=human --decorate=full --all";
        penger = "ssh -p 2121 penger@insinuatis.ddns.net";
      };
    };
  };
}
