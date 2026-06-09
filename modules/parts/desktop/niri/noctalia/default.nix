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
        };
      };
    };
}
