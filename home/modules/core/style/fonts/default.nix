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
      mkFontDerivation =
        fontPath: name:
        pkgs.stdenvNoCC.mkDerivation {
          pname = name;
          version = "1.0";
          dontUnpack = true;
          installPhase = ''
            install -Dm755 ${fontPath} $out/share/fonts/truetype/
          '';
        };
    in
    lib.mkIf config.modules.core.style.fonts.enable {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        # (mkFontDerivation "./local/xkcd-script.ttf" "xkcd-script")
        # (mkFontDerivation "./local/Comic-Sans-MS.ttf" "Comic-Sans-MS")
        font-manager
        jetbrains-mono
        font-awesome
        powerline-fonts
        powerline-symbols
        dejavu_fonts
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
