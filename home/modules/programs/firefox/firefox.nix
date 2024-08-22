{ pkgs, config, lib, ... }:
{
  options = {
    firefox.enable = lib.mkEnableOption "Enables firefox";
  };

  config = 
    let
      firefoxUser = "default";
    in 
    lib.mkIf config.firefox.enable {
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
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        # DisableFirefoxAccounts = true;
        # DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"
        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
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
      profiles ={
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
