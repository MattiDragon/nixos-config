wrapperArgs: {
  flake.modules.nixos.desktop-niri =
    { pkgs, config, ... }:
    {
      imports = [
        wrapperArgs.config.flake.modules.nixos.desktop
      ];

      programs.niri.enable = true;
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.login.kwallet.enable = true;

      programs.regreet.enable = true;
      # TODO: remove once nixpkgs auto enables this
      services.accounts-daemon.enable = true;

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

      # Needed for dolphin to access gnome-keyring
      services.dbus.packages = with pkgs; [
        kdePackages.kio-extras
        kdePackages.kio
      ];

      environment.systemPackages = with pkgs; [
        kdePackages.kwallet
      ];
    };

  flake.modules.homeManager.desktop-niri =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.custom = {
        niri-config = lib.mkOption {
          type = lib.types.lines;
          default = "";
        };
        desktop-wallpaper = lib.mkOption {
          type = lib.types.path;
        };
      };
      config = {
        home.sessionVariables = {
          GTK_USE_PORTAL = "1";
        };

        xdg.configFile."niri/config.kdl".source = ./config.kdl;
        xdg.configFile."niri/extra.kdl".text = config.custom.niri-config;

        xdg.configFile."kwalletrc".text = ''
          [KSecretD]
          Enabled=false
        '';

        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.xdg-desktop-portal-gtk
            pkgs.xdg-desktop-portal-gnome
          ];
          config.common = {
            default = "gnome";
          };
        };

        programs.alacritty.enable = true; # Super+T in the default setting (terminal)

        services.polkit-gnome.enable = true; # polkit
        home.packages = with pkgs; [
          xwayland-satellite # provides X11 support under niri with autodetection

          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome

          kdePackages.dolphin
          kdePackages.gwenview
          kdePackages.ark
        ];

        xdg.mimeApps.defaultApplications = {
          # Prism Launcher steals this unless we fix it
          "application/zip" = "org.kde.ark.desktop";

          # For some reason aseprite takes images for itself
          # We set all images to gwenview by default
          "image/avif" = "org.kde.gwenview.desktop";
          "image/bmp" = "org.kde.gwenview.desktop";
          "image/gif" = "org.kde.gwenview.desktop";
          "image/heif" = "org.kde.gwenview.desktop";
          "image/jpeg" = "org.kde.gwenview.desktop";
          "image/jxl" = "org.kde.gwenview.desktop";
          "image/png" = "org.kde.gwenview.desktop";
          "image/svg+xml" = "org.kde.gwenview.desktop";
          "image/svg+xml-compressed" = "org.kde.gwenview.desktop";
          "image/tiff" = "org.kde.gwenview.desktop";
          "image/webp" = "org.kde.gwenview.desktop";
          "image/x-eps" = "org.kde.gwenview.desktop";
          "image/x-ico" = "org.kde.gwenview.desktop";
          "image/x-icns" = "org.kde.gwenview.desktop";
          "image/x-portable-bitmap" = "org.kde.gwenview.desktop";
          "image/x-portable-graymap" = "org.kde.gwenview.desktop";
          "image/x-portable-pixmap" = "org.kde.gwenview.desktop";
          "image/x-psd" = "org.kde.gwenview.desktop";
          "image/x-tga" = "org.kde.gwenview.desktop";
          "image/x-webp" = "org.kde.gwenview.desktop";
          "image/x-xbitmap" = "org.kde.gwenview.desktop";
          "image/x-xcf" = "org.kde.gwenview.desktop";
          "image/x-xpixmap" = "org.kde.gwenview.desktop";
          "image/openraster" = "org.kde.gwenview.desktop";
          "application/x-krita" = "org.kde.gwenview.desktop";
        };

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
    };
}
