{
  pkgs,
  config,
  lib,
  hostname,
  ...
}:
let
  module = config.modules.core.shell.fish;
in
{
  config = lib.mkIf module.enable {
    programs.fish = {
      enable = true;
      plugins = with pkgs.fishPlugins; [
        {
          name = "bass";
          src = bass.src;
        }
      ];
      interactiveShellInit = ''
              direnv hook fish | source
          		set fish_greeting 
        		'';

      shellAbbrs = {
        "shell" = "nix shell nixpkgs#{}";
      };
      shellAliases = lib.mkMerge [
        {
          cls = "clear";
          conf = "cd ~/nixos";
          repos = "cd ~/repos";
          sources = "cd ~/sources";
          btm = "btm --process_memory_as_value -g";
          mkscript = "echo '#!/usr/bin/env bash' > script-template.sh && chmod +x script-template.sh";
          log = "git log --graph --pretty=format:'%C(bold red)%h%Creset - %C(bold blue)%an%Creset%C(auto)%d%Creset %s %C(yellow)%ad%Creset %Cgreen(%cr) ' --abbrev-commit --date=human --decorate=full --all";
          penger = "ssh penger@nuc -t \"fish\"";
          laptop = "ssh blockdoth@laptop -t \"fish\"";
          desktop = "ssh blockdoth@desktop -t \"fish\"";
          temp = "cd ~/temp/";
          up = "cd ..";
          eep = "systemctl suspend";
          notes = "cd ~/documents/notes";
          note = "cd ~/documents/notes && micro \"$(date +%F)\"";
          getrepo = "git clone ";
          code = "codium . 2>/dev/null";
          bat = "bat -p";
          ls = "eza";
          vw = "notes && cat tos | wl-copy";
        }
        (lib.mkIf (config.home.username != "penger") {
          # Graphical
          config = "conf && codium .";
          lock = "kill hyprlock && hyprlock";
          print = "firefox -new-tab https://printportal.tudelft.nl:9443/end-user/ui/dashboard";
          rickroll = "firefox -new-tab 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'";
        })
      ];
      functions = {
        nix-shell = ''
          function nix-shell
            command nix-shell $argv --command fish
          end
        '';
      };
    };
  };
}
