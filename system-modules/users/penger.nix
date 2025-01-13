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

    sops.secrets.penger-password.neededForUsers = true;
    users.mutableUsers = false;

    users.users.penger = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      hashedPasswordFile = config.sops.secrets.penger-password.path;
      openssh = {
        authorizedKeys = {
          keys = [
            (builtins.readFile ../../hosts/desktop/id_rsa.pub)
            (builtins.readFile ../../hosts/laptop/id_rsa.pub)
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpzvsxZud2IPq04WtljDQdmOSHukwEncFupWzeGblmZ2diZ5NBcaNbGULKtcapIk6F2sbFDjoiwU8Zj0bdSmYxLUnweQCsvYgqVFj9reIWMZdK+GNSDaaTPU9ay6es45p8O5OIvq79OqBUatTpj6E/Mn3K+zibNWfuwysWw28SxOsva2SmN2SOKq4vi5gDjMT+qnl2wxy70pDux17/ec55Jz1XVGKhPhS1UUofvp4qunst/3qcqNywLS0JkQD5MTlVZzGKEayNSvFhwYvQqPe3+yX3pMikhJx+hUgEPjK5lu0tlXBJkk5BJxcX1azfQrAvd29MegNYPCE3MZm/QlBNwoGVMigZ/uCED1BUccz8z1YAjt9S+RrI9phOdV1MLvH3jQDYWG/w5YNVT6iyJOiSVFYeKhmP0mxZ9ffyoYdefsUazYWDIpKKWMQAA9NMrXzjdMbE729WmoFgiVeHrnW/IgabSQlpz1ZQpiD/gQ6u0W2db2NjFEkE5kSB5/4n0jk= u0_a345@localhost"
          ];
        };
      };
    };

    programs = {
      fish.enable = true;
    };
  };
}
