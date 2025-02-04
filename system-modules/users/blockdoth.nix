{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    system-modules.users.blockdoth.enable = lib.mkEnableOption "enables user blockdoth";
  };

  config = lib.mkIf config.system-modules.users.blockdoth.enable {
    sops.secrets.blockdoth-password = {
      neededForUsers = true;
    };

    security.sudo.wheelNeedsPassword = false;

    users = {
      mutableUsers = false;
      users.blockdoth = {
        isNormalUser = true;
        shell = pkgs.fish;
        hashedPasswordFile = config.sops.secrets.blockdoth-password.path;
        extraGroups = [
          "wheel"
          "networkmanager"
          "audio"
        ];
        openssh = {
          authorizedKeys = {
            keys = [
              (builtins.readFile ../../hosts/desktop/id_ed25519.pub)
              (builtins.readFile ../../hosts/laptop/id_ed25519.pub)
              # phone
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpzvsxZud2IPq04WtljDQdmOSHukwEncFupWzeGblmZ2diZ5NBcaNbGULKtcapIk6F2sbFDjoiwU8Zj0bdSmYxLUnweQCsvYgqVFj9reIWMZdK+GNSDaaTPU9ay6es45p8O5OIvq79OqBUatTpj6E/Mn3K+zibNWfuwysWw28SxOsva2SmN2SOKq4vi5gDjMT+qnl2wxy70pDux17/ec55Jz1XVGKhPhS1UUofvp4qunst/3qcqNywLS0JkQD5MTlVZzGKEayNSvFhwYvQqPe3+yX3pMikhJx+hUgEPjK5lu0tlXBJkk5BJxcX1azfQrAvd29MegNYPCE3MZm/QlBNwoGVMigZ/uCED1BUccz8z1YAjt9S+RrI9phOdV1MLvH3jQDYWG/w5YNVT6iyJOiSVFYeKhmP0mxZ9ffyoYdefsUazYWDIpKKWMQAA9NMrXzjdMbE729WmoFgiVeHrnW/IgabSQlpz1ZQpiD/gQ6u0W2db2NjFEkE5kSB5/4n0jk= u0_a345@localhost"
            ];
          };
        };
      };
    };

    #TODO move to home manager
    programs = {
      fish.enable = true;
    };
  };
}
