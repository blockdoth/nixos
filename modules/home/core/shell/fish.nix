{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.shell.fish;
  secrets = config.modules.core.secrets;
  extern = config.modules.presets.extern;
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
        "shell" = "nix shell nixpkgs#{";
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
          code = "zeditor .";
          bat = "bat -p";
          ls = "eza";
          vw = "notes && cat tos | wl-copy";
          systui = "sudo systemctl-tui";
          wifilist = "nmcli device wifi list";
          hotspot = " nmcli device wifi connect \"government-bird-drone-213\" --ask";
        }
        (lib.mkIf (config.home.username != "penger") {
          # Graphical
          config = "conf && codium .";
          lock = "kill hyprlock && hyprlock";
          print = "zen -new-tab https://printportal.tudelft.nl:9443/end-user/ui/dashboard";
          rickroll = "zen -new-tab 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'";
        })
        (lib.mkIf (!extern.enable) {
          # Dont want to leak secrets
          gituni = "git config user.name \"${secrets.name}\" && git config user.email \"${secrets.mails.uni}\"";
        })
      ];
      functions = {
        nix-shell = ''
          function nix-shell
            command nix-shell $argv --command "exec fish"
          end
        '';
      };
    };
  };
}
