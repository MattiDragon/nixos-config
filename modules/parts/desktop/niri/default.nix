{ config, ... }:
{
  flake.modules.nixos.desktop-niri =
    { pkgs, ... }:
    {
      imports = [
        config.flake.modules.nixos.desktop
      ];
      programs.niri.enable = true;
      services.gnome.gnome-keyring.enable = true;

      fonts.packages = with pkgs; [
        font-awesome_4
      ];

      # Needed for udiskie
      services.udisks2.enable = true;
    };

  flake.modules.homeManager.desktop-niri =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      xdg.configFile."niri/config.kdl".source = ./config.kdl;
      # xdg.configFile."niri/config.kdl".source =
      #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/tmpconfigs/config.kdl";

      programs.alacritty.enable = true; # Super+T in the default setting (terminal)
      programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
      programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
      programs.waybar.enable = true; # launch on startup in the default setting (bar)
      services.mako.enable = true; # notification daemon
      services.swayidle.enable = true; # idle management daemon
      services.polkit-gnome.enable = true; # polkit
      home.packages = with pkgs; [
        swaybg # wallpaper
        xwayland-satellite # provides X11 support under niri with autodetection

        kdePackages.breeze
        kdePackages.breeze-gtk
        kdePackages.breeze-icons
        kdePackages.qt6ct
        libsForQt5.qt5ct

        kdePackages.dolphin
      ];

      qt = {
        enable = true;
        platformTheme.name = "qt6ct";
        #style.name = "breeze";
      };

      gtk = {
        enable = true;
        gtk4.theme = {
          package = pkgs.kdePackages.breeze-gtk;
          name = "Breeze-Dark";
        };
        iconTheme = {
          package = pkgs.kdePackages.breeze-icons;
          name = "breeze-dark";
        };
      };

      home.shell.enableBashIntegration = true;
      programs.bash.enable = true;

      home.sessionVariables = {
        #QT_QPA_PLATFORMTHEME = "qt6ct";
      };

      services.udiskie.enable = true;
    };
}
