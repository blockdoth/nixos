{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  module = config.modules.programs.browsers.zen;
in
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  config = lib.mkIf module.enable {
    programs.zen-browser = {
      enable = true;

      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "never";
        SearchBar = "unified";
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };

      profiles."default" = {
        isDefault = true;

        search = {
          force = true;
          engines = {

            "Nix Packages" = {
              definedAliases = [ "@nix" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Nix Options" = {
              definedAliases = [ "@opt" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "youtube" = {
              definedAliases = [ "@yt" ];
              icon = "https://www.youtube.com/s/desktop/2253fa3d/img/logos/favicon.ico";
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };

            "ChatGPT" = {
              definedAliases = [ "@gpt" ];
              icon = "https://chat.openai.com/favicon.ico";
              urls = [
                {
                  template = "https://chat.openai.com/?q={searchTerms}";
                }
              ];
            };

            "Home Manager" = {
              definedAliases = [ "@hm" ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
                }
              ];
            };
          };
        };
      };
    };
  };
}
