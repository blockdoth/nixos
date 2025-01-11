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
      hashedPassword = "${config.sops.secrets.penger-password.path}";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCclZYyrEBIsL/osXgpUHBJlRRmzyCMZzFz/oOPX/3LTQZowuwTn4Fiboz7bOv4SWHuxidCyZVwxoaDdYK1PgD4aDi/Re8qLvEK77c2DWJjyg+PWEs/e6EexSJuXi7LeRg2JXQGiZ5HdyXpZ+EQbuKLA7kL3+Z5YVJnxpZm6EK4Kl1nmhrm/HYX5Twf9t72ni8XShxbMbnZkupsQHd+rlwXdcWPbj6wGX1i6wVM9tYmcxvAXcAGqqPhYW3r/9fnpV1swlS1oCilbb9zdDPDhh1nvPR1+dOcl99MHCIRklcv3YNWeVOp6Wt+mIaj913r1zD5A77QWUntx3YI1rsCs9b8qvp8hl4OOvif48CnP4iNdHeCB4pI4siJzGHqwBNBmCvK4/YTUzK5bc2yjjK5S66aMQxv81oiF7NsczAY61DZt63spKnoT3lhpJW6b4Ed6ha6Gs5WGKWel8Yd97E00ES2gmjZgSaJYZbsdILkReEQz808A3c5rEDkOkNtsZXjuM= blockdoth@desktop"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFBm+sLLC0iaJdM2t8ZQxU1jQvvX0gHLEv7+hAxdsPgwfbUQplpptQyUAcXFbl4u8oYWx5YDmU/aRpDdgtCYHjSVGoCYy14q53wGH+H0QqUwW32DunG7m4rNXbGZhaILU4es6V2w/B9Nh9ZFkgcoS/eIk1nK8mMK82XQd/y4ZVLFTaPAD6JfOgb6bpL66C0+eI/5W7l3e2clUt4S4qMFIIUzUASgICZDtW95gSJSqjqDLnEmo+Kav1JPy8S7NaKNq/fflEVHBmJqLF+y9uCvKM1Oz4Hp455K3jZJbYKSlisPDkusv5DM0XJkrM6VXQuKttEmb9MokyjCOC95wkxlbDnSVZ0EOIqV9bxiXM3IYG0hROnca+GSQBkfyu0CSpVZ0/PF/xCn6gF018GRKPEJhoGnXjXuT4kADb3iVVZDPuZkvYrtkCEXWjiQq5j3sqBSlch11Cy2EtEw6Yj550fiAa3hjXU9x4K0kg+GFTyvxPZezzAMPm0zZHUDemee+40Lk= blockdoth@laptop"
      ];
    };
    programs = {
      fish.enable = true;
    };
    services.openssh.passwordAuthentication = false;
  };
}
