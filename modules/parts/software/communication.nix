{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/discord-589393213723246592" = "discord-589393213723246592.desktop";
      };

      home.packages = with pkgs; [
        discord
        zoom-us
      ];
    };
}
