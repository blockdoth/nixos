{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.programs.firefox.enable = lib.mkEnableOption "Enables firefox";
  };

  config =
    let
      firefoxUser = "default";
    in
    lib.mkIf config.modules.programs.firefox.enable {
      home.sessionVariables = {
        BROWSER = "firefox";
      };
      home.file = {
        ".mozilla/firefox/${firefoxUser}/chrome" = {
          source = ./chrome;
          recursive = true;
        };
        ".mozilla/firefox/${firefoxUser}/user.js" = {
          source = ./user.js;
          recursive = true;
        };
      };

      programs.firefox = {
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
        profiles = {
          ${firefoxUser} = {
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
    };
}
