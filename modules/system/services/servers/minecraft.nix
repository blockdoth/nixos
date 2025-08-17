{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.system-modules.services.servers.minecraft;
  domain = config.system-modules.services.domains.gameservers;
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  config = lib.mkIf module.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      servers = {
        minecraft_21 = {
          enable = true;
          package = pkgs.vanillaServers.vanilla-1_21;
          autoStart = false;
          enableReload = true;
          serverProperties = {
            motd = "A Minecraft Server running on nixos";
            gamemode = "creative";
            difficulty = "peacefull";
            max-players = "69";
            server-port = "25565";
            white-list = "false";
            # enable-rcon = true;
            # rcon.password = "dontbother"; # doesnt type check for some reason
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        (lib.strings.toInt config.services.minecraft-servers.servers.minecraft_21.serverProperties.server-port)
      ];
    };

    # Stops if the server from automatically starting
    # systemd.services.minecraft-server-minecraft_21.wantedBy = lib.mkForce [ ];

    # services.caddy = {
    #   virtualHosts."minecraft.${domain}".extraConfig = ''
    #     reverse_proxy 127.0.0.1:${builtins.toString config.services.minecraft-servers.servers.minecraft_21.serverProperties.server-port}
    #   '';
    # };
  };
}
