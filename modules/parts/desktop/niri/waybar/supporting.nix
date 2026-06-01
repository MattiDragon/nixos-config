{
  flake.modules.nixos.desktop-waybar =
    { pkgs, ... }:
    {

    };

  flake.modules.homeManager.desktop-waybar =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
      services.mako.enable = true; # notification daemon
      # Set background
      xdg.configFile."swaybg/background.jpeg".source = config.custom.desktop-wallpaper;

      xdg.configFile."niri/waybar.kdl".source = ./niri.kdl;
      custom.niri-config = ''include "waybar.kdl"'';

      services.swayidle = {
        enable = true; # idle management daemon
        timeouts = [
          {
            timeout = 60 * 5;
            command = "${pkgs.gtklock}/bin/gtklock -d";
          }
          {
            timeout = 60 * 10;
            command = "${pkgs.systemd}/bin/systemctl suspend";
          }
        ];
      };
    };
}
