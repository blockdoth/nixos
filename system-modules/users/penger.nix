{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    system-modules.users.penger.enable = lib.mkEnableOption "enables penger user";
  };

  config = lib.mkIf config.system-modules.users.penger.enable {
    users.users.penger = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      hashedPasswordFile = config.sops.secrets."users/penger/password".path;
      openssh.authorizedKeys = {
        keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFBm+sLLC0iaJdM2t8ZQxU1jQvvX0gHLEv7+hAxdsPgwfbUQplpptQyUAcXFbl4u8oYWx5YDmU/aRpDdgtCYHjSVGoCYy14q53wGH+H0QqUwW32DunG7m4rNXbGZhaILU4es6V2w/B9Nh9ZFkgcoS/eIk1nK8mMK82XQd/y4ZVLFTaPAD6JfOgb6bpL66C0+eI/5W7l3e2clUt4S4qMFIIUzUASgICZDtW95gSJSqjqDLnEmo+Kav1JPy8S7NaKNq/fflEVHBmJqLF+y9uCvKM1Oz4Hp455K3jZJbYKSlisPDkusv5DM0XJkrM6VXQuKttEmb9MokyjCOC95wkxlbDnSVZ0EOIqV9bxiXM3IYG0hROnca+GSQBkfyu0CSpVZ0/PF/xCn6gF018GRKPEJhoGnXjXuT4kADb3iVVZDPuZkvYrtkCEXWjiQq5j3sqBSlch11Cy2EtEw6Yj550fiAa3hjXU9x4K0kg+GFTyvxPZezzAMPm0zZHUDemee+40Lk= blockdoth@laptop"
        ];
        keyFiles = [
          config.sops.secrets."hosts/desktop/keys/rsa/public".path
        ];
      };
    };
    programs = {
      fish.enable = true;
    };
    services.openssh.settings.passwordAuthentication = false;
  };
}
