{
  flake.modules.nixos.vindruva =
    { pkgs, ... }:
    {
      hardware.ckb-next.enable = true;
      hardware.ckb-next.package = pkgs.ckb-next;

      # TODO: find better way to autostart
      # (makeAutostartItem {
      #   name = "ckb-next";
      #   package = pkgs.ckb-next;
      # })
    };
}
