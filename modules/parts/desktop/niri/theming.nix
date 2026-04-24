wrapperArgs: {
  flake.modules.nixos.desktop-niri =
    { config, lib, ... }:
    {
      options.custom.login-wallpaper = lib.mkOption {
        type = lib.types.path;

      };
      config = {
        nixpkgs.overlays = [ wrapperArgs.inputs.dolphin-patch.overlays.default ];
        programs.regreet.settings = {
          background.path = "${config.custom.login-wallpaper}";
          background.fit = "Cover";
          GTK.application_prefer_dark_theme = true;
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
    };

  flake.modules.homeManager.desktop-niri =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.custom.desktop-wallpaper = lib.mkOption {
        type = lib.types.path;
      };

      config = {
        # Set theme for KDE apps
        xdg.configFile."kdeglobals".source = ./kdeglobals;
        # Set background
        xdg.configFile."swaybg/background.jpeg".source = config.custom.desktop-wallpaper;

        home.packages = with pkgs; [
          swaybg # wallpaper

          kdePackages.breeze
          kdePackages.breeze-icons
          kdePackages.qt6ct
        ];

        qt = {
          enable = true;
          platformTheme.name = "qt6ct";
          # TODO: include qt6ct settings here
        };

        gtk = {
          enable = true;
          colorScheme = "dark";
          gtk4.colorScheme = "dark";

          gtk4.theme = null;
        };
      };
    };
}
