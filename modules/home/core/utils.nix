{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.core.utils;
  tree_but_cooler = inputs.tree-but-cooler.packages.${pkgs.stdenv.hostPlatform.system}.default;
  mail = config.modules.core.secrets.mails.personal;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      # core utils
      jq
      fd
      ripgrep
      tree
      tree_but_cooler
      file
      xxd
      bc
      wget
      zip
      unzip
      pandoc
      comma
      tmux
      cron

      # fs
      eza
      bat
      fzf
      broot
      gdu
      dua
      dust
      lsof
      # Disks
      caligula
      udiskie
      wl-clipboard
      # git
      git
      git-lfs
      gh
      lazygit
      cloc
      entr
      # system monitoring
      bottom
      powertop
      systemctl-tui
      # Networking
      dig
      nmap
      netcat-gnu
      inetutils
      unixtools.netstat
      tcpdump
      speedtest-cli
      nfs-utils
      ethtool
      curl
      # nix
      nh
      nix-search
      nix-tree
      deploy-rs
      attic-client
      cachix
      # Media
      ffmpeg
      jhead
      exiftool
      # Benchmarking
      wrk
      hey
      perf
      hyperfine
    ];

    programs = {
      git = {
        enable = true;
        lfs.enable = true;
        signing = {
          signByDefault = true;
          format = "ssh";
        };
        settings = {
          user = {
            name = "blockdoth";
            email = "${mail}";
            signingkey = "~/.ssh/id_ed25519";
          };
          init.defaultBranch = "main";
          push.autoSetupRemote = "true";
          pull.rebase = "true";
          core.editor = "micro";
        };
      };
      yazi = {
        enable = true;
        settings.yazi = ''
          [mgr]
          show_hidden = true
        '';
        shellWrapperName = "y";
      };
    };
  };
}
