{
  config,
  lib,
  pkgs,
  ...
}:

let
  module = config.system-modules.display.autologin;
in
{
  config = lib.mkIf module.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    systemd.services.greetd = {
      serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };

      # This override is what makes it auto-login only ONCE at boot
      # It uses systemd's `ExecStartPre` to temporarily override the session
      # The override only lasts until the session ends (i.e., logout)
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        echo '[default_session]' > /run/greetd/config.toml
        echo 'command = "hyprland"' >> /run/greetd/config.toml
        echo 'user = "blockdoth"' >> /run/greetd/config.toml
      '';
    };
  };
}
