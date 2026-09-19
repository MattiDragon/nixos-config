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

      # Required for noctalia sync
      security.polkit.enable = true;
      security.polkit.enablePkexecWrapper = true;

      services.displayManager.noctalia-greeter = {
        enable = true;
        cursorTheme.package = pkgs.kdePackages.breeze-icons;
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

        # Fixes dolphin missing menu issue
        xdg.configFile."menus/applications.menu".source =
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

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

        programs.alacritty.enable = true; # Terminal

        services.polkit-gnome.enable = true; # polkit
        home.packages = with pkgs; [
          xwayland-satellite # provides X11 support under niri with autodetection

          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome

          kdePackages.dolphin
          kdePackages.gwenview
          kdePackages.ark
          kdePackages.okular
          haruna
        ];

        xdg.mimeApps.defaultApplicationPackages = with pkgs; [
          kdePackages.gwenview
          haruna
          kdePackages.ark
        ];
        xdg.mimeApps.defaultApplications = {
          "application/pdf" = "org.kde.okular.desktop";

          # For some reason missing by default
          "inode/mount-point" = "org.kde.dolphin.desktop";
          "inode/directory" = "org.kde.dolphin.desktop";

          "text/plain" = "org.kde.kate.desktop";
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
