{
  flake.modules.nixos.core =
    { config, lib, ... }:
    {
      boot.loader = lib.mkIf (config.custom.boot == "systemd") {
        efi.canTouchEfiVariables = true;

        systemd-boot.enable = true;
      };
    };
}
