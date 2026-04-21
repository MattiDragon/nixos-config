{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      services.kdeconnect.enable = true;
    };
}
