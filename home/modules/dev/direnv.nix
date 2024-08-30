{ pkgs, config, lib, ... }:
{  
  options = {
    modules.dev.env.direnv.enable = lib.mkEnableOption "Enables direnvs";
  };

  config = 
    let
      # function to import a nix file and escape it such that it can be used in a bash scriipt
      replaceAndReadFile = path: builtins.replaceStrings ["\""] ["\\\""] (builtins.readFile path);

      # script to init nix env for various languages 
      devinit = pkgs.writeShellScriptBin "devinit"
      ''
      JAVA_ENV="${replaceAndReadFile ./template-shells/java.nix}"
      C_ENV="${replaceAndReadFile ./template-shells/c.nix}"
      CPP_ENV="${replaceAndReadFile ./template-shells/cpp.nix}"
      RUST_ENV="${replaceAndReadFile ./template-shells/rust.nix}"
      PYTHON_ENV="${replaceAndReadFile ./template-shells/python.nix}"
      TYPESCRIPT_ENV="${replaceAndReadFile ./template-shells/typescript.nix}"
      DEFAULT_ENV="${replaceAndReadFile ./template-shells/default.nix}"
      
      SEPERATOR="――――――――――――――――――――――――――――"
      echo "Initializing a nix environment"
      echo "$SEPERATOR"

      PS3="$SEPERATOR 
      Choose an environment: "
      options=(
        "java" 
        "c" 
        "cpp" 
        "rust" 
        "python" 
        "typescript" 
        "default" 
        "clean"
        "exit"
        )
      select opt in "''${options[@]}"
      do
        case $opt in
          "java")
            echo "$JAVA_ENV" > "flake.nix"
            echo "$SEPERATOR"
            echo "Created a java nix shell template"
            break
            ;;
          "c")
            echo "$C_ENV" > "flake.nix"
            echo "$SEPERATOR"
            echo "Created a c nix shell template"
            break
            ;;
          "cpp")
            echo "$CPP_ENV" > "flake.nix"
            echo "$SEPERATOR"
            echo "Created a cpp nix shell template"
            break
            ;;            
          "rust")
            echo "$RUST_ENV" > "flake.nix"
            echo "$SEPERATOR"
            echo "Created a rust nix shell template"
            break
            ;;
          "python")
            echo "$PYTHON_ENV" > "flake.nix"
            echo "$SEPERATOR"
            echo "Created a python nix shell template"
            break
            ;; 
          "typescript")
            echo "$TYPESCRIPT_ENV" > "flake.nix"
            echo "$SEPERATOR"
            echo "Created a typescript nix shell template"
            break
            ;;    
          "default")
            echo "$DEFAULT_ENV" > "flake.nix"
            echo "$SEPERATOR"
            echo "Created an default nix shell template"
            break
            ;;  
          "clean")
            rm ./.direnv -r
            rm ./.envrc 
            rm ./shell.nix
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
      
      # create .envrc for direnv
      echo "use flake" > .envrc

      # enable flake
      direnv allow
      '';

    in
    lib.mkIf config.modules.dev.editors.jetbrains.enable {

    home.packages = with pkgs; [
      devinit
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
    


