{ config, ... }:
{
  flake.modules.nixos.desktop-kde =
    { ... }:
    {
      imports = [
        config.flake.modules.nixos.desktop
      ];
      services.desktopManager.plasma6.enable = true;
    };
}
