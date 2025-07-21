{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.chatger;
  domain = config.system-modules.services.network.domains.homelab;
  chatger = pkgs.stdenv.mkDerivation {
    name = "fossil-example";

    src = pkgs.fetchFromGitHub {
      owner = "blockdoth";
      repo = "chatger-fossil-mirror";
      rev = "main";
      sha256 = "sha256-FMmvoesIiJ0hevMbADNQf8sVvxNTzzKhykCyk6vblX0=";
    };
    patches = [ ./db_path.patch ];
    buildPhase = ''
      cc -o nob nob.c
      ./nob
    '';

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/bin/sql

      cp -r ./sql/ $out/bin/sql
      cp ./chatger $out/bin/
    '';
  };
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      chatger
    ];

    systemd.services.chatger = {
      description = "Chatger Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "/home/penger/sources/chatger/chatger";
        WorkingDirectory = "/home/penger/sources";
        Restart = "on-failure";
        User = "penger";
        Group = "penger";
      };
    };

    system-modules.services = {
      network.caddy.reverse-proxies = [
        {
          subdomain = "chatger";
          type = "tcp";
          port = 4348;
        }
      ];
    };
  };
}
