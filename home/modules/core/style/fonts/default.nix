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
        fontPath: name: type:
        pkgs.stdenvNoCC.mkDerivation {
          pname = name;
          version = "1.0";
          dontUnpack = true;
          installPhase = ''
            install -Dm755 ${fontPath} $out/share/fonts/${type}/'${name}'
          '';
        };
    in
    lib.mkIf config.modules.core.style.fonts.enable {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        (mkFontDerivation ./local/xkcd-script.ttf "xkcd Script" "truetype")
        (mkFontDerivation ./local/Comic-Sans-MS.ttf "Comic Sans MS" "truetype")
        (mkFontDerivation ./local/xkcd.otf "xkcd" "opentype")
        font-manager
        jetbrains-mono
        font-awesome
        powerline-fonts
        powerline-symbols
        dejavu_fonts
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
        nerd-fonts.jetbrains-mono
      ];
    };
}
