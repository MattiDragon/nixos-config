{
  flake.modules.nixos.core =
    { ... }:
    {
      services.flatpak.enable = true;
    };
}
