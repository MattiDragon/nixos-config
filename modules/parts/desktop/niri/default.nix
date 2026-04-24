wrapperArgs: {
  flake.modules.nixos.desktop-niri =
    { pkgs, config, ... }:
    {
      imports = [
        wrapperArgs.config.flake.modules.nixos.desktop
      ];

      programs.niri.enable = true;
      services.gnome.gnome-keyring.enable = true;

      programs.regreet.enable = true;

      programs.gtklock = {
        enable = true;
        config.main = {
          start-hidden = true;
          idle-hide = true;
          idle-timeout = 60;
        };
      };

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

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
        config.common.default = "kde";
      };

      programs.alacritty.enable = true; # Super+T in the default setting (terminal)
      programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
      services.mako.enable = true; # notification daemon
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
      services.polkit-gnome.enable = true; # polkit
      home.packages = with pkgs; [
        xwayland-satellite # provides X11 support under niri with autodetection

        kdePackages.xdg-desktop-portal-kde

        kdePackages.dolphin
        kdePackages.gwenview
      ];

      home.file.".vscode/argv.json".text = ''
        {
          // Fixes vscode not detecting the gnome keyring (microsoft/vscode#187338)
          "password-store": "gnome-libsecret"
        }
      '';

      home.shell.enableBashIntegration = true;
      programs.bash.enable = true;

      services.udiskie.enable = true;
    };
}
