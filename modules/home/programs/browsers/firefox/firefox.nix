{
  pkgs,
  config,
  lib,
  system,
  inputs,
  ...
}:
let
  module = config.modules.programs.browsers.firefox;
  #My shyfox fork
  shyfox = pkgs.fetchFromGitHub {
    owner = "blockdoth";
    repo = "ShyFox";
    rev = "fba147660a1b374f00e50df59b525f7c7bb5a4e5";
    sha256 = "sha256-YfPDJHoyA0tj73rnDOqI65n0bAh8hSTPnXLDEkzQVpg=";
  };
  sideberyConfig = builtins.fromJSON (builtins.readFile ./sidebery-config.json);

  defaultProfile = "default";
in
{
  config = lib.mkIf module.enable {
    home.sessionVariables = {
      BROWSER = "firefox";
    };

    home.file = {
      ".mozilla/firefox/${defaultProfile}" = {
        source = pkgs.runCommand "shyfox" { } ''
          mkdir $out
          mkdir -p $out/chrome
          cp -r ${shyfox}/chrome/* $out/chrome
          cp ${shyfox}/user.js $out/user.js
        '';
        recursive = true;
      };
    };

    programs.firefox = {
      enable = true;
      # package = pkgs.librewolf; # Re-enable whenever mozilla goes rogue
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
        # DisableFirefoxAccounts = true;
        # DisableAccounts = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "never"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"
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
      profiles.${defaultProfile} = {
        isDefault = true;

        search.engines = {
          "Nix Packages" = {
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

            # icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };

        # doesnt work because the it doesnt read dependencies
        # extraConfig = builtins.readFile "${shyfoxProfile}/user.js";
        # userChrome = builtins.readFile "${shyfoxProfile}/chrome/userChrome.css";
        # userContent = builtins.readFile "${shyfoxProfile}/chrome/userContent.css";

        extensions = {
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            bitwarden
            clearurls
            dark-mode-website-switcher # likely darkreader?
            linkwarden
            return-youtube-dislikes
            sidebery
            sponsorblock
            ublock-origin
            userchrome-toggle-extended
            videospeed
            i-dont-care-about-cookies
          ];
        };
        settings = {
          "extensions.autoDisableScopes" = 0;
          "{3c078156-979c-498b-8990-85f7987dd929}" = {
            force = true;
            settings = {
              settings = sideberyConfig."settings";
              sidebar = sideberyConfig."sidebar";
              contextMenu = sideberyConfig."contextMenu";
              keybindings = sideberyConfig."keybindings";
            };
          };
        };
      };
    };
  };
}
