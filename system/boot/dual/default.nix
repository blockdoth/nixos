{ pkgs, ... }:
{

  systemd.enableEmergencyMode = false;
  boot = {
    supportedFilesystems = ["ntfs"];
    loader = {
      systemd-boot = {
        enable = false;
        editor = false;
      };
      timeout = 10;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 5;
        # theme =
        #   pkgs.fetchFromGitHub
        #   {
        #     owner = "Lxtharia";
        #     repo = "minegrub-theme";
        #     rev = "193b3a7c3d432f8c6af10adfb465b781091f56b3";
        #     sha256 = "1bvkfmjzbk7pfisvmyw5gjmcqj9dab7gwd5nmvi8gs4vk72bl2ap";
        #   };
      };
    };
  };
}