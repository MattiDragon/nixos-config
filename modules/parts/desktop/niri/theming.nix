wrapperArgs: {
  flake.modules.nixos.desktop-niri =
    { config, lib, ... }:
    {
      options.custom.login-wallpaper = lib.mkOption {
        type = lib.types.path;

      };
      config = {
        programs.regreet.settings = {
          background.path = "${config.custom.login-wallpaper}";
          background.fit = "Cover";
          GTK.application_prefer_dark_theme = true;
        };

        services.displayManager.noctalia-greeter.settings = {
          appearance = {
            hide_logo = true;
            wallpaper = {
              path = "${config.custom.login-wallpaper}";
              fill_mode = "crop";
            };

            cursor = {
              theme = "breeze_cursors";
              size = 24;
            };
          };
        };
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
      # Set theme for KDE apps
      xdg.configFile."kdeglobals".source = ./kdeglobals;

      xdg.configFile."qtengine/config.json".text = ''
        {
          "theme": {
            "colorScheme": "${config.home.homeDirectory}/.local/share/color-schemes/noctalia.colors",
            "iconTheme": "breeze-dark",
            "style": "breeze"
          },
          "misc": {
            "menusHaveIcons": true,
            "singleClickActivate": false,
            "shortcutsForContextMenus": true
          }
        }
      '';

      home.packages = with pkgs; [
        swaybg # wallpaper

        kdePackages.breeze
        kdePackages.breeze-icons
        kdePackages.qt6ct

        kdePackages.plasma-integration

        wrapperArgs.inputs.qtengine.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      qt = {
        enable = true;
        platformTheme.name = "qtengine";
      };

      gtk = {
        enable = true;
        colorScheme = "dark";
        cursorTheme.name = "breeze_cursors";
        cursorTheme.size = 24;
        gtk4.colorScheme = "dark";

        gtk4.theme = null;
      };
    };
}
