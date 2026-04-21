{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
      };
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      xdg.mimeApps.defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };

      home.packages = with pkgs; [
        firefoxpwa
      ];
    };
}
