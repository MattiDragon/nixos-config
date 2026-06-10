{ inputs, ... }:
{
  flake.modules.nixos.desktop-noctalia =
    { ... }:
    {
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
    };

  flake.modules.homeManager.desktop-noctalia =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      xdg.configFile."niri/noctalia-conf.kdl".source = ./niri.kdl;
      custom.niri-config = ''
        include "noctalia-conf.kdl"
        include optional=true "noctalia.kdl"
      '';

      # Used to apply noctalia to firefox
      home.packages = with pkgs; [
        pywalfox-native
      ];
      home.file.".mozilla/native-messaging-hosts/pywalfox.json".source =
        let
          manifest = derivation {
            system = "x86_64-linux";
            builder = "/bin/sh";
            name = "pywalfox-manifest";
            args = [
              "-c"
              "${pkgs.pywalfox-native}/bin/pywalfox install --manifest-path $out"
            ];
          };
        in
        "${manifest}/pywalfox.json";

      programs.alacritty.settings = {
        general.import = [ "./themes/noctalia.toml" ];
        window.opacity = 0.7;
      };

      programs.noctalia = {
        enable = true;

        package = pkgs.noctalia.overrideAttrs (prevAttrs: {
          buildInputs = prevAttrs.buildInputs ++ [ pkgs.python314 ];
        });

        settings = {
          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
          };

          wallpaper = {
            enabled = true;
            default.path = config.custom.desktop-wallpaper;
          };

          bar.default = {
            border_width = 1;
            background_opacity = 0.5;
            start = [
              "workspaces"
              "spacer_2"
              "clock"
            ];
            center = [ "active_window" ];
            end = [
              "media"
              "tray"
              "notifications"
              "network"
              "bluetooth"
              "volume"
              "brightness"
              "battery"
              "session"
            ];

            margin_edge = 5;
            margin_ends = 5;
            thickness = 32;
          };

          control_center.shortcuts = [
            { type = "wifi"; }
            { type = "bluetooth"; }
            { type = "caffeine"; }
            { type = "notification"; }
            { type = "power_profile"; }
            { type = "dark_mode"; }
          ];

          notification = {
            background_opacity = 0.5;
            offset_x = 5;
          };

          osd = {
            background_opacity = 0.5;
            offset_x = 5;
          };

          backdrop.enabled = true;

          shell = {
            polkit_agent = true;
            settings_show_advanced = true;
            telemetry_enabled = true;

            niri_overview_type_to_launch_enabled = true;

            panel = {
              launcher_compact = true;
              open_near_click_control_center = true;
              open_near_click_session = true;
              control_center_placement = "floating";
              session_placement = "floating";
            };

            session.actions = [
              {
                action = "lock";
                enabled = true;
                shortcut = "l";
                variant = "default";
              }
              {
                action = "logout";
                enabled = true;
                shortcut = "u";
                variant = "default";
              }
              {
                action = "lock_and_suspend";
                enabled = true;
                glyph = "player-pause";
                shortcut = "s";
                variant = "default";
              }
              {
                action = "reboot";
                enabled = true;
                shortcut = "r";
                variant = "default";
              }
              {
                action = "shutdown";
                enabled = true;
                shortcut = "p";
                variant = "destructive";
              }
            ];
          };

          desktop_widgets = {
            schema_version = 1;
            widget_order = [ ];

            grid = {
              cell_size = 16;
              major_interval = 4;
              visible = true;
            };

            widget = { };
          };

          theme.templates = {
            builtin_ids = [
              "alacritty"
              "gtk3"
              "gtk4"
              "kcolorscheme"
              "niri"
              "qt"
            ];
            community_ids = [
              "pywalfox"
              "obsidian"
              "vscode"
            ];
          };

          weather.auto_locate = true;

          widget = {
            active_window.max_length = 512;

            clock = {
              format = "{:%a %d.%m.%Y\\n%H:%M}";
              scale = 1.5;
            };

            date.format = "";

            media = {
              hide_when_no_media = true;
              max_length = 100;
            };

            network.show_label = false;

            spacer_2 = {
              capsule = true;
              length = 15;
              type = "spacer";
            };
          };
        };
      };
    };
}
