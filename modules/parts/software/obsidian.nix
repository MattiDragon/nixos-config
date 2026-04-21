{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/obsidian" = "obsidian.desktop";
      };

      home.packages = with pkgs; [
        obsidian
      ];
    };
}
