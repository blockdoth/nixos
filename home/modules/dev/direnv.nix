{
  pkgs,
  config,
  lib,
  ...
}:
{
  options = {
    modules.dev.env.direnv.enable = lib.mkEnableOption "Enables direnvs";
  };

  config =
    let
      # function to import a nix file and escape it such that it can be used in a bash scriipt
      readAndEscapeFile = path: builtins.replaceStrings [ "\"" ] [ "\\\"" ] (builtins.readFile path);

      # script to init nix env for various languages 
      devinit = pkgs.writeShellScriptBin "devinit" ''
         JAVA_ENV="${readAndEscapeFile ./template-shells/java.nix}"
         SCALA_ENV="${readAndEscapeFile ./template-shells/scala.nix}"
         C_ENV="${readAndEscapeFile ./template-shells/c.nix}"
         CPP_ENV="${readAndEscapeFile ./template-shells/cpp.nix}"
         RUST_ENV="${readAndEscapeFile ./template-shells/rust.nix}"
         PYTHON_ENV="${readAndEscapeFile ./template-shells/python.nix}"
         JUPYTER_ENV="${readAndEscapeFile ./template-shells/python-jupyter.nix}"
         TYPESCRIPT_ENV="${readAndEscapeFile ./template-shells/typescript.nix}"
         HASKELL_ENV="${readAndEscapeFile ./template-shells/haskell.nix}"
         DEFAULT_ENV="${readAndEscapeFile ./template-shells/default.nix}"
         
         SEPERATOR="――――――――――――――――――――――――――――"
         echo "Initializing a nix environment"
         echo "$SEPERATOR"

         PS3="$SEPERATOR 
         Choose an environment: "
         options=(
           "java" 
           "scala" 
           "c" 
           "cpp" 
           "rust" 
           "python" 
           "python-jupyter" 
           "typescript" 
           "haskell"
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
             "scala")
               echo "$SCALA_ENV" > "flake.nix"
               echo "$SEPERATOR"
               echo "Created a scala nix shell template"
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
             "python-jupyter")
               echo "$JUPYTER_ENV" > "flake.nix"
               echo "$SEPERATOR"
               echo "Created a jupyter notebook nix shell template"
               break
               ;; 
             "typescript")
               echo "$TYPESCRIPT_ENV" > "flake.nix"
               echo "$SEPERATOR"
               echo "Created a typescript nix shell template"
               break
               ;;    
             "haskell")
               echo "$HASKELL_ENV" > "flake.nix"
               echo "$SEPERATOR"
               echo "Created a haskell nix shell template"
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
         
        # create .envrc for direnv
         echo "use flake" > .envrc
         echo "
         .idea
         .envrc
         .direnv
         " > .gitignore

         # create .envrc for direnv
         # if [[ $(git rev-parse --is-inside-work-tree) == "true" ]]; then
         #   git add flake.nix 
         # fi

         # enable flake
         direnv allow

         # if [[ $(git rev-parse --is-inside-work-tree) == "true" ]]; then
         #   git add flake.lock
         # fi
      '';

    in
    {

      home.packages = with pkgs; [ devinit ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };
}
