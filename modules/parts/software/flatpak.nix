{
  flake.modules.nixos.desktop =
    { ... }:
    {
      services.flatpak.enable = true;
    };
}
