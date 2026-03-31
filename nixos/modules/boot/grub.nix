{ ... }:
{
  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      configurationLimit = 5;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;

      minegrub-world-sel = {
        enable = true;
        customIcons = [ ];
      };
    };
  };
}
