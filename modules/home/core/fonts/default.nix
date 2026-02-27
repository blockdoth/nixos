{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.core.fonts;
  mkFontDerivation =
    name: fontPath:
    let
      type =
        if lib.hasSuffix ".ttf" fontPath then
          "truetype"
        else if lib.hasSuffix ".otf" fontPath then
          "opentype"
        else
          throw "Unsupported font format: ${fontPath}";
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = name;
      version = "1.0";
      dontUnpack = true;
      installPhase = ''
        install -Dm755 ${fontPath} $out/share/fonts/${type}/'${name}'
      '';
    };
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      (mkFontDerivation "xkcd" ./local/xkcd.otf)
      (mkFontDerivation "Comic Sans MS" ./local/Comic-Sans-MS.ttf)
      (mkFontDerivation "Noto Sans" ./local/NotoSans-Regular.ttf)
      (mkFontDerivation "xkcd Script" ./local/xkcd-script.ttf)
      font-manager
      jetbrains-mono
      font-awesome
      powerline-fonts
      powerline-symbols
      dejavu_fonts
      noto-fonts
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      newcomputermodern
    ];
    fonts.fontconfig.enable = true;
  };
}
