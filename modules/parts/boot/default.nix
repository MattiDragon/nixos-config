{
  flake.modules.nixos.core =
    { lib, ... }:
    {
      options.custom.boot = lib.mkOption {
        type = lib.types.str;
        default = "systemd";
      };
    };
}
