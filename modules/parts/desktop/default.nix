{
  flake.modules.nixos.desktop =
    { ... }:
    {
      hardware.graphics.enable = true;

      console.keyMap = "fi";

      services.xserver = {
        enable = true;
        xkb = {
          layout = "fi";
          variant = "";
          options = "caps:none";
        };
      };
    };
}
