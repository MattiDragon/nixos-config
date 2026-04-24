wrapperArgs: {
  flake.modules.nixos.desktop-niri =
    { pkgs, config, ... }:
    {
      imports = [
        wrapperArgs.config.flake.modules.nixos.desktop
      ];

      nixpkgs.overlays = [ wrapperArgs.inputs.dolphin-patch.overlays.default ];

      programs.niri.enable = true;
      services.gnome.gnome-keyring.enable = true;

      programs.regreet = {
        enable = true;
        settings = {
          background.path = "${./login-bg.jpeg}";
          background.fit = "Cover";
          GTK.application_prefer_dark_theme = true;
        };
      };

      programs.gtklock = {
        enable = true;
        config.main = {
          start-hidden = true;
          idle-hide = true;
          idle-timeout = 60;
        };
        style = ''
          #window-box {
          	padding: 32px;
          	border: 4px solid rgba(0, 0, 0, 0.75);
          	border-radius: 16px;
          	background-color: rgba(0, 0, 0, 0.5);
          }

          window {
            background-image: url("${./desktop-bg.jpeg}");
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            background-color: white;
          }
        '';
      };

      fonts.packages = with pkgs; [
        font-awesome
        nerd-fonts.symbols-only
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
      xdg.configFile."kdeglobals".source = ./kdeglobals;
      xdg.configFile."swaybg/background.jpeg".source = ./desktop-bg.jpeg;

      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
        config.common.default = "kde";
      };

      programs.alacritty.enable = true; # Super+T in the default setting (terminal)
      programs.fuzzel.enable = true; # Super+D in the default setting (app launcher)
      programs.waybar = {
        enable = true;
        # style = ./waybar/style.css;
        style = config.lib.file.mkOutOfStoreSymlink /home/matti/Flakes/nixos-config/modules/parts/desktop/niri/waybar/style.css;
        settings.main = {
          reload_style_on_change = true;
          spacing = 4;
          modules-left = [
            "cpu"
            "memory"
            #"disk"
            "battery"
            "temperature"
            "network#usage"
          ];
          modules-center = [ "niri/window" ];
          modules-right = [
            "pulseaudio"
            "network"
            "clock"
            "custom/power"
          ];

          cpu = {
            format = " {usage}%";
          };

          memory = {
            format = " {percentage}% + {swapPercentage}%";
          };

          "network#usage" = {
            format = " {bandwidthUpBytes}  {bandwidthDownBytes}";
            interval = 5;
          };

          # This doesn't actually do disk utilisation
          # disk = {
          #   format = " {usage}%";
          # };

          battery = {
            format = "{icon} {capacity}%";
            tooltip-format-charging = "{time} until charged";
            tooltip-format-discharging = "{time} left";
            tooltip-format-full = "Full";
            states = {
              warning = 30;
              critical = 15;
            };
            format-icons = {
              default = [
                "󰂎"
                "󱊡"
                "󱊢"
                "󱊣"
              ];
              charging = [
                "󰢟"
                "󱊤"
                "󱊥"
                "󱊦"
              ];
            };
          };

          temperature = {
            critical-threshold = 80;
            tooltip = false;
          };

          pulseaudio = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{icon} {volume}% {format_source}";
            format-bluetooth-muted = "{icon}  {format_source}";
            format-muted = " {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "pavucontrol";
          };

          network = {
            format-wifi = " {essid} ({signalStrength}%)";
            format-ethernet = " Connected";
            tooltip-format = "{ipaddr}/{cidr}";
            format-linked = "⚠ {ifname} (No IP)";
            format-disconnected = "⚠ Disconnected";
            on-click = "alacritty -e nmtui";
          };

          clock = {
            format = "{0:%H:%M:%S}  {0:%d/%m/%Y}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            #format-alt = "";
          };

          "custom/power" = {
            format = "";
            menu = "on-click";
            menu-file = ./waybar/power_menu.xml;
            menu-actions = {
              lock = "gtklock -d";
              shutdown = "shutdown now";
              reboot = "reboot";
              suspend = "suspend";
            };
          };
        };
      };
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
        swaybg # wallpaper
        xwayland-satellite # provides X11 support under niri with autodetection

        kdePackages.breeze
        kdePackages.breeze-icons
        kdePackages.qt6ct
        materia-theme
        materia-kde-theme
        kdePackages.qtstyleplugin-kvantum
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

      qt = {
        enable = true;
        platformTheme.name = "qt6ct";
      };

      gtk = {
        enable = true;
        colorScheme = "dark";
        gtk4.colorScheme = "dark";

        gtk4.theme = null;
      };

      home.shell.enableBashIntegration = true;
      programs.bash.enable = true;

      services.udiskie.enable = true;
    };
}
