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
      hashedPassword = "$6$pVfO9OK6/hHCIXwo$xYSMfLFIugMnUgg2i96Qdclk9WqoRXFV0qJ/kP.Hid12Qesv7BwMZqhs4DrdTRQb8BdGgOdWKhiRdIgFsipjv.";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCclZYyrEBIsL/osXgpUHBJlRRmzyCMZzFz/oOPX/3LTQZowuwTn4Fiboz7bOv4SWHuxidCyZVwxoaDdYK1PgD4aDi/Re8qLvEK77c2DWJjyg+PWEs/e6EexSJuXi7LeRg2JXQGiZ5HdyXpZ+EQbuKLA7kL3+Z5YVJnxpZm6EK4Kl1nmhrm/HYX5Twf9t72ni8XShxbMbnZkupsQHd+rlwXdcWPbj6wGX1i6wVM9tYmcxvAXcAGqqPhYW3r/9fnpV1swlS1oCilbb9zdDPDhh1nvPR1+dOcl99MHCIRklcv3YNWeVOp6Wt+mIaj913r1zD5A77QWUntx3YI1rsCs9b8qvp8hl4OOvif48CnP4iNdHeCB4pI4siJzGHqwBNBmCvK4/YTUzK5bc2yjjK5S66aMQxv81oiF7NsczAY61DZt63spKnoT3lhpJW6b4Ed6ha6Gs5WGKWel8Yd97E00ES2gmjZgSaJYZbsdILkReEQz808A3c5rEDkOkNtsZXjuM= blockdoth@desktop"
      ];
    };
    programs = {
      fish.enable = true;
    };
  };
}
