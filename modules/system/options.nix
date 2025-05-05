{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  enableGui = config.system-modules.presets.gui.enable || enableLaptop;
  enableGaming = config.system-modules.presets.gaming.enable;
  enableLaptop = config.system-modules.presets.laptop.enable;
  enableMediaServer = config.system-modules.presets.mediaserver.enable;
  enablePissStream = config.system-modules.presets.iss-piss-stream.enable;
  enableUserPenger = config.system-modules.users.penger.enable;
  enableUserBlockdoth = config.system-modules.users.blockdoth.enable;
  zenMode = config.system-modules.zenmode.enable;
  inherit (lib)
    mkIf
    mkEnableOption
    mkDefault
    mkOption
    types
    ;
in
{
  imports = [
    ./core
    ./common
    ./display
    ./services
    ../../users/blockdoth/system.nix
    ../../users/penger/system.nix
  ];

  options = {
    system-modules = {
      presets = {
        gui.enable = mkEnableOption "graphical interface";
        gaming.enable = mkEnableOption "gaming";
        laptop.enable = mkEnableOption "laptop specific config";
        mediaserver.enable = mkEnableOption "mediaserver";
        iss-piss-stream.enable = mkEnableOption "enalbes piss stream observability";
        zenmode.enable = mkEnableOption "zenmode";
      };

      users = {
        blockdoth.enable = mkEnableOption "user blockdoth";
        penger.enable = mkEnableOption "user penger";
      };

      core = {
        grub.enable = mkEnableOption "grub";
        env.enable = mkEnableOption "env";
        networking = {
          enable = mkEnableOption "networking config";
          hostname = mkOption { type = types.str; };
        };
        impermanence.enable = mkEnableOption "impermanence";
        localization.enable = mkEnableOption "localization settings";
        nix-config.enable = mkEnableOption "nix config";
        secrets.enable = mkEnableOption "secrets management";
        ssh.enable = mkEnableOption "ssh";
        tailscale = {
          enable = mkEnableOption "tailscale";
          exit-node = mkEnableOption "can serve as exitnode";
        };
      };

      common = {
        audio.enable = mkEnableOption "audio";
        bluetooth.enable = mkEnableOption "bluetooth";
        crosscompilation.enable = mkEnableOption "cross-compilation";
        docker.enable = mkEnableOption "docker";
        gaming.enable = mkEnableOption "gaming";
        power.enable = mkEnableOption "power";
        printing.enable = mkEnableOption "printing";
        syncthing.enable = mkEnableOption "syncthing";
        trackpad.enable = mkEnableOption "trackpad";
      };

      display = {
        greeter.enable = mkEnableOption "greeter";
        wayland.enable = mkEnableOption "hyprland";
        x11.enable = mkEnableOption "x11";
      };

      services = {
        gameservers = {
          minecraft.enable = mkEnableOption "minecraft server";
          factorio.enable = mkEnableOption "factorio server";
        };
        network = {
          ddns.enable = mkEnableOption "ddns";
          acme.enable = mkEnableOption "acme";
          blocky.enable = mkEnableOption "blocky";
          headscale.enable = mkEnableOption "headscale";
          fail2ban.enable = mkEnableOption "fail2ban";
          caddy = {
            enable = mkEnableOption "caddy";
            reverse-proxies = mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    subdomain = mkOption { type = types.str; };
                    port = mkOption {
                      type = types.int;
                    };
                    require-auth = mkOption {
                      type = types.bool;
                      default = false;
                    };
                    redirect-address = mkOption {
                      type = types.str;
                      default = "127.0.0.1";
                    };
                    extra-config = mkOption {
                      type = types.str;
                      default = "";
                    };
                  };
                }
              );
              default = [ ];
            };
          };
          domains = {
            iss-piss-stream = mkOption {
              type = types.str;
              default = "localhost";
            };
            homelab = mkOption {
              type = types.str;
              default = "localhost";
            };
            gameservers = mkOption {
              type = types.str;
              default = "localhost";
            };
          };
        };
        auth = {
          authelia = {
            enable = mkEnableOption "authelia";
            port = mkOption { type = types.int; };
          };
          lldap = {
            enable = mkEnableOption "lldap";
            shared-group = mkOption { type = types.str; };
            shared-jwt = mkOption { type = types.str; };
            shared-password = mkOption { type = types.str; };
          };
        };

        observability = {
          grafana.enable = mkEnableOption "grafana";
          loki.enable = mkEnableOption "loki";
          prometheus.enable = mkEnableOption "prometheus";
          promtail.enable = mkEnableOption "promtail";
          gatus = {
            enable = mkEnableOption "gatus";
            endpoints = mkOption {
              type = types.listOf (
                types.submodule {
                  options = {
                    name = mkOption { type = types.str; };
                    url = mkOption { type = types.str; };
                    endpoint = mkOption {
                      type = types.str;
                      default = "";
                    };
                    interval = mkOption {
                      type = types.str;
                      default = "30s";
                    };
                    conditions = mkOption {
                      type = types.listOf types.str;
                      default = [
                        "[STATUS] == 200"
                        "[RESPONSE_TIME] < 500"
                      ];
                    };
                  };
                }
              );
              default = [ ];
            };
          };
        };

        scraping = {
          iss-piss-stream.enable = mkEnableOption "iss piss stream monitoring";
        };

        sync = {
          atuin.enable = mkEnableOption "atuin shell sync";
          anki.enable = mkEnableOption "anki";
        };

        media = {
          audiobookshelf.enable = mkEnableOption "audiobookshelf";
          bazarr.enable = mkEnableOption "bazarr";
          jellyfin.enable = mkEnableOption "jellyfin";
          jellyseerr.enable = mkEnableOption "jellyseer";
          prowlarr.enable = mkEnableOption "prowlarr";
          radarr.enable = mkEnableOption "radarr";
          lidarr.enable = mkEnableOption "lidarr";
          sonarr.enable = mkEnableOption "sonarr";
          transmission.enable = mkEnableOption "transmission";

          # This module is heavily inspired by https://github.com/zmitchell/nixos-configs/blob/main/modules/media_server.nix
          mediaDir = mkOption {
            type = types.str;
            default = "/var/lib/media";
            description = "Directory for media storage";
          };
          group = mkOption {
            type = types.str;
            default = "media";
            description = "Group for media access";
          };
        };
        vaultwarden.enable = mkEnableOption "vaultwarden";
        filebrowser.enable = mkEnableOption "filebrowser";
        immich.enable = mkEnableOption "immich";
        linkwarden.enable = mkEnableOption "linkwarden";
        nextcloud.enable = mkEnableOption "nextcloud";
        homepage.enable = mkEnableOption "homepage";
        microbin.enable = mkEnableOption "microbin";
      };
    };
  };
  config = {
    system-modules = {
      core = {
        grub.enable = mkDefault true;
        env.enable = mkDefault true;
        networking.enable = mkDefault true;
        localization.enable = mkDefault true;
        nix-config.enable = mkDefault true;
        secrets.enable = mkDefault true;
        ssh.enable = mkDefault true;
        tailscale = {
          enable = mkDefault true;
          exit-node = mkDefault false;
        };
      };

      common = {
        audio.enable = mkDefault enableGui;
        bluetooth.enable = mkDefault enableLaptop;
        power.enable = mkDefault enableLaptop;
        trackpad.enable = mkDefault enableLaptop;
        gaming.enable = mkDefault enableGaming;
      };

      display = {
        greeter.enable = mkDefault enableGui;
        wayland.enable = mkDefault enableGui;
        x11.enable = mkDefault enableGui;
      };

      services = {
        network = {
          domains = {
            iss-piss-stream = "insinuatis.com";
            homelab = "insinuatis.com";
            gameservers = "insinuatis.com";
          };
        };

        # observability = {
        #   grafana.enable = mkDefault enablePissStream;
        #   loki.enable = mkDefault enablePissStream;
        #   prometheus.enable = mkDefault enablePissStream;
        #   promtail.enable = mkDefault enablePissStream;
        # };
        scraping = {
          iss-piss-stream.enable = mkDefault enablePissStream;
        };

        media = {
          bazarr.enable = mkDefault enableMediaServer;
          jellyfin.enable = mkDefault enableMediaServer;
          prowlarr.enable = mkDefault enableMediaServer;
          radarr.enable = mkDefault enableMediaServer;
          lidarr.enable = mkDefault enableMediaServer;
          sonarr.enable = mkDefault enableMediaServer;
          transmission.enable = mkDefault enableMediaServer;
        };
      };
    };

    # Prevent me from fucking myself over again
    assertions = [
      {
        assertion = enableUserPenger || enableUserBlockdoth;
        message = "At least one user must be enabled";
      }
      {
        assertion = enableGui || !(enableGui && enableGaming);
        message = "To use the gaming module, the gui module must be enabled";
      }
    ];
  };
}
