{ pkgs, ... }:
{
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
}
