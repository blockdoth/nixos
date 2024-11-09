{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
{
  options = {
    system-modules.servers.minecraftserver.enable = lib.mkEnableOption "Enables minecraft server";
  };

  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  config = lib.mkIf config.system-modules.servers.minecraftserver.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      servers = {
        minecraft_21 = {
          enable = true;
          package = pkgs.vanillaServers.vanilla-1_21;

          serverProperties = {
            motd = "A Minecraft Server running on nixos";
            gamemode = "creative";
            difficulty = "peacefull";
            max-players = "20";
            server-port = "25565";
            white-list = "false";
          };
        };
      };
    };
  };
}
