{
  flake.modules.homeManager.desktop-niri =
    { pkgs, ... }:
    {
      services.wl-clip-persist.enable = true;
      services.cliphist.enable = true;

      home.packages = [ pkgs.wl-clipboard ];
    };
}
