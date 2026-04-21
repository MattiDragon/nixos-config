{ inputs, ... }:
{
  flake.modules.nixos.core =
    { config, lib, ... }:
    {
      imports = [
        inputs.minegrub-world-sel-theme.nixosModules.default
      ];

      boot.loader = lib.mkIf (config.custom.boot == "grub") {
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
    };
}
