{
  flake.modules.nixos.desktop-niri =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        nerd-fonts.symbols-only
      ];
    };

  flake.modules.homeManager.desktop-niri =
    { ... }:
    {
      programs.waybar = {
        enable = true;
        style = ./style.css;
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
            menu-file = ./power_menu.xml;
            menu-actions = {
              lock = "gtklock -d";
              shutdown = "shutdown now";
              reboot = "reboot";
              suspend = "suspend";
            };
          };
        };
      };
    };
}
