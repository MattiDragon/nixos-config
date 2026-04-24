{ config, ... }:
{
  flake.modules.nixos.desktop-kde =
    { ... }:
    {
      imports = [
        config.flake.modules.nixos.desktop
      ];
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
    };
}
