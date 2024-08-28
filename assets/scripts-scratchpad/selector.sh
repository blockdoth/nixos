      JAVA_ENV="test"
      C_ENV="test"
      RUST_ENV="test"
      PYTHON_ENV="test"
      TYPESCRIPT_ENV="test"
      DEFAULT_ENV="test"

      SEPERATOR="――――――――――――――――――――――――――――"
      echo "Initializing a nix environment"
      echo "$SEPERATOR"

      PS3="$SEPERATOR 
      Choose an environment: "
      options=(
        "java" 
        "c" 
        "rust" 
        "python" 
        "typescript" 
        "default" 
        "exit"
        )
      select opt in "''${options[@]}"
      do
        case $opt in
          "java")
            echo $JAVA_ENV > "shell.nix"
            echo "$SEPERATOR"
            echo "Created a java nix shell template"
            break
            ;;
          "c")
            echo $C_ENV > "shell.nix"
            echo "$SEPERATOR"
            echo "Created a c nix shell template"
            break
            ;;
          "rust")
            echo $RUST_ENV > "shell.nix"
            echo "$SEPERATOR"
            echo "Created a rust nix shell template"
            break
            ;;
          "python")
            echo $PYTHON_ENV > "shell.nix"
            echo "$SEPERATOR"
            echo "Created a python nix shell template"
            break
            ;; 
          "typescript")
            echo $TYPESCRIPT_ENV > "shell.nix"
            echo "$SEPERATOR"
            echo "Created a typescript nix shell template"
            break
            ;;    
          "default")
            echo $DEFAULT_ENV > "shell.nix"
            echo "$SEPERATOR"
            echo "Created an default nix shell template"
            break
            ;;                                      
          "exit")
            echo "$SEPERATOR"
            echo "Exiting without action"
            exit
            ;;
          *) echo "invalid option: \"$REPLY\"";;
        esac
      done

      echo "use nix
      export DIRENV_LOG_FORMAT="$(printf "\033[2mdirenv: %%s\033[0m")"
      eval "$(direnv hook zsh)"
      _direnv_hook() {
        eval "$(direnv export zsh 2> >(egrep -v -e '^....direnv: export' >&2))"
      };
      " > .envrc
      direnv allow
      echo "initialized direnv"