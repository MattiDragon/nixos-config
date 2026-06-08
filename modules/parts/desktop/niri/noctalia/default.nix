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
        include "noctalia.kdl"
      '';

      programs.noctalia = {
        enable = true;

        package = pkgs.noctalia.overrideAttrs (prevAttrs: {
          buildInputs = prevAttrs.buildInputs ++ [ pkgs.python314 ];
        });

        settings = {
          # This may also be a string or path to a .toml file.
          theme = {
            mode = "dark";
            source = "builtin";
            builtin = "Catppuccin";
          };

          wallpaper = {
            enabled = true;
            default.path = config.custom.desktop-wallpaper;
          };
        };
      };
    };
}
