{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        gimp
        aseprite
        blender
        blockbench
      ];
    };
}
