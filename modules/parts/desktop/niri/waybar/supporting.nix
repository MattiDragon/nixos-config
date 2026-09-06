{
  flake.modules.nixos.desktop-waybar =
    { pkgs, config, ... }:
    {
      programs.gtklock = {
        enable = true;
        config.main = {
          start-hidden = true;
          idle-hide = true;
          idle-timeout = 60;
        };
      };

      programs.gtklock.style = ''
        #window-box {
        	padding: 32px;
        	border: 4px solid rgba(0, 0, 0, 0.75);
        	border-radius: 16px;
        	background-color: rgba(0, 0, 0, 0.5);
        }

        window {
          background-image: url("${config.custom.login-wallpaper}");
          background-size: cover;
          background-repeat: no-repeat;
          background-position: center;
          background-color: white;
        }
      '';
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
