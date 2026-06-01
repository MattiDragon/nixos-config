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
    };
}
