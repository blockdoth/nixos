{
  pkgs,
  config,
  lib,
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
in
{
  config = lib.mkIf module.enable {
    home.sessionVariables = {
      BROWSER = "librewolf";
    };

    home.file = {
      ".mozilla/firefox/default" = {
        source = pkgs.runCommand "shyfox" { } ''
          mkdir -p $out
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

        # ---- EXTENSIONS ----
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };

      };
      profiles.default = {
        isDefault = true;

        # dependent on fixing the NUR
        # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        #   ublock-origin
        #   sponsorblock
        #   sidebery
        #   userchrome-toggle
        #   videospeed
        #   return-youtube-dislikes
        #   clearurls
        #   i-dont-care-about-cookies
        # ];
      };
    };
  };
}
