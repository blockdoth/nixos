{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.dev.editors.micro.enable = lib.mkEnableOption "Enables micro";
  };

  config = lib.mkIf config.modules.dev.editors.micro.enable {
    home.packages = with pkgs; [ micro ];

    programs.micro = {
      enable = true;
      settings = {
        autosu = true;
        colorscheme = "grubox-transparant";
      };
    };

    home.file.".config/micro/colorschemes".text = ''
      color-link default "223,"
      color-link comment "243,"
      color-link constant "175,"
      color-link constant.string "142,"
      color-link identifier "109,"
      color-link statement "124,"
      color-link symbol "124,"
      color-link preproc "72,"
      color-link type "214,"
      color-link special "172,"
      color-link underlined "underline 109,"
      color-link error "235,"
      color-link todo "bold 223,"
      color-link hlsearch "235,"
      color-link diff-added "34"
      color-link diff-modified "214"
      color-link diff-deleted "160"
      color-link line-number "243,"
      color-link current-line-number "172,"
      color-link cursor-line "237"
      color-link color-column "237"
      color-link statusline "223,"
      color-link tabbar "223,237"
      color-link match-brace "235,72"
      color-link tab-error "167"
    '';
  };
}
