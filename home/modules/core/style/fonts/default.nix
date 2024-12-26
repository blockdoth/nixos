{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.core.style.fonts.enable = lib.mkEnableOption "Enables custom fonts";
  };

  config =
    let
      local-fonts = pkgs.stdenv.mkDerivation rec {
        pname = "local-fonts";
        version = "1.0";
        src = ./local;
        installPhase = ''find ${src} -type f -name '*.ttf' -exec install -Dm644 {} $out/share/fonts/truetype/ \;'';
      };

    in
    lib.mkIf config.modules.core.style.fonts.enable {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        font-manager
        jetbrains-mono
        font-awesome
        powerline-fonts
        powerline-symbols
        dejavu_fonts
        local-fonts
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "DroidSansMono"
            "JetBrainsMono"
          ];
        })
      ];
    };
}
