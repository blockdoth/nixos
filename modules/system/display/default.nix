{
  ...
}:
{
  imports = [
    ./wayland.nix
    ./x11.nix
    ./greeter.nix
    ./portals.nix
  ];
  config = {
    # Needed for a bunch of gtk programs
    programs.dconf.enable = true;
  };
}
