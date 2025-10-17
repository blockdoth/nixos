{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.dev.ctf;
in
{
  config = lib.mkIf module.enable {
    home.packages = with pkgs; [
      ghidra
      burpsuite
      hashcat
      exiftool
      pngtools
      zsteg # stenography
      wireshark
      qrrs # QR codes
      scalpel
      binwalk
      stegseek
    ];
  };
}
