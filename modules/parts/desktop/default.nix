{
  flake.modules.nixos.desktop =
    { ... }:
    {
      services.displayManager.sddm.enable = true;
      hardware.graphics.enable = true;

      console.keyMap = "fi";

      services.xserver = {
        enable = true;
        xkb = {
          layout = "fi";
          variant = "";
        };
      };
    };
}
