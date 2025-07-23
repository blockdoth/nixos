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
  chatgerInternalPort = 4348;
  chatgerTLSPort = 4349;
  chatgerRawPort = 4348;
  chatger = pkgs.stdenv.mkDerivation {
    name = "chatger";
    src = pkgs.fetchFromGitHub {
      owner = "blockdoth";
      repo = "chatger-fossil-mirror";
      rev = "main";
      sha256 = "sha256-FMmvoesIiJ0hevMbADNQf8sVvxNTzzKhykCyk6vblX0=";
    };
    patches = [
      ./db_from_env.patch
      ./port_from_env.patch
    ];
    buildPhase = ''
      cc -o nob nob.c
      ./nob
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp -r ./sql $out/bin
      cp ./chatger $out/bin
    '';
  };
in
{
  config = lib.mkIf module.enable {
    environment.systemPackages = with pkgs; [
      chatger
    ];
    users.groups.chatger = { };

    users.users.chatger = {
      isSystemUser = true;
      group = "chatger";
    };

    systemd.services = {
      chatger = {
        description = "chatger";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${chatger}/bin/chatger";
          WorkingDirectory = "${chatger}/bin";
          StateDirectory = "chatger";
          Environment = ''
            CHATGER_DB_PATH=/var/lib/chatger/chatger.db
            CHATGER_PORT=${builtins.toString chatgerInternalPort}
          '';
          Restart = "on-failure";
          User = "chatger";
          Group = "chatger";
        };
      };

      socat-tls-terminator = {
        description = "TLS Terminator for chatger.insinuatis.com";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        requires = [ "network.target" ];

        serviceConfig = {
          ExecStart = ''
            ${pkgs.socat}/bin/socat -d -d -v\
              OPENSSL-LISTEN:${builtins.toString chatgerTLSPort},reuseaddr,fork,cert=/var/lib/acme/insinuatis.com/cert.pem,key=/var/lib/acme/insinuatis.com/key.pem,verify=0 \
              TCP:127.0.0.1:${builtins.toString chatgerInternalPort}
          '';
          Group = "acme";
          Restart = "on-failure";
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      chatgerTLSPort
      chatgerRawPort
    ];
  };
}
