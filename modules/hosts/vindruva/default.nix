{ inputs, config, ... }:
{
  flake.modules.nixos.vindruva =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    {
      imports = with config.flake.modules.nixos; [
        core
        nvidia
        user-matti
        desktop-niri
        desktop-noctalia
        ../../_hardware-configs/vindruva.nix
      ];

      home-manager.users.matti = {
        imports = with config.flake.modules.homeManager; [
          core
          desktop
          desktop-niri
          desktop-noctalia
          user-matti
          vindruva
          game-dev
        ];
        custom.desktop-wallpaper = ./desktop-bg.jpeg;
        programs.waybar.settings.main = {
          temperature.hwmon-path = "/sys/class/hwmon/hwmon3/temp1_input";
        };
      };

      custom.login-wallpaper = ./login-bg.jpeg;

      custom = {
        boot = "grub";
      };

      networking.hostName = "vindruva";
      # Deal with windows time
      # TODO: change in windows and remove
      time.hardwareClockInLocalTime = true;
    };

  flake.modules.homeManager.vindruva = { ... }: { };

  flake.nixosConfigurations.vindruva = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos.vindruva ];
  };
}
