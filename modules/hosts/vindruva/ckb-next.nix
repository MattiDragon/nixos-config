{
  flake.modules.nixos.vindruva =
    { pkgs, ... }:
    {
      hardware.ckb-next.enable = true;
      hardware.ckb-next.package = pkgs.ckb-next;
    };

  flake.modules.homeManager.vindruva =
    { ... }:
    {
      xdg.configFile."ckb-next/ckb-next.conf".source = ./ckb-next.conf;
      custom.niri-config = ''
        spawn-at-startup "ckb-next" "-b"
      '';
    };
}
