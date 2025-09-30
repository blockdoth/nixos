{
  pkgs,
  config,
  lib,
  ...
}:
let
  module = config.modules.dev.devinit;
  templates = pkgs.stdenv.mkDerivation {
    pname = "templates";
    version = "1.0";

    src = ./template-shells;
    installPhase = ''
      mkdir -p $out/templates
      cp -r $src/* $out/templates/
    '';
  };
  devinit = pkgs.writeShellScriptBin "devinit" ''

    SEPERATOR="――――――――――――――――――――――――――――"
    echo "Initializing a nix environment"
    echo "$SEPERATOR"
    PS3="$SEPERATOR 

    Choose an environment: "
    options=(
      "rust" 
      "default" 
      "clean"
      "exit"
      )
    select opt in "''${options[@]}" # Extra \'\' to escape ''$ under nix eval 
    do
      case $opt in    
        "rust")
          cp -r ${templates}/templates/rust/* .
          echo "$SEPERATOR"
          echo "Created a rust nix shell template"
          break
          ;;           
        "default")
          cp -r ${templates}/templates/default/* .
          echo "$SEPERATOR"
          echo "Created an default nix shell template"
          break
          ;;  
        "clean")
          rm ./.direnv -r
          rm ./.envrc 
          rm ./flake.nix
          rm ./flake.lock
          echo "$SEPERATOR"
          echo "Cleaned up environment"
          exit
          ;;                                       
        "exit")
          echo "$SEPERATOR"
          echo "Exiting without action"
          exit
          ;;
        *) echo "invalid option: \"$REPLY\"";;
      esac
    done

    git init
    git add .gitignore
    git add .
    direnv allow
  '';
in
{
  config = lib.mkIf module.enable {
    home.packages = [
      devinit
    ];
  };
}
