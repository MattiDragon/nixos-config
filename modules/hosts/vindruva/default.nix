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
        desktop-kde
        ../../_hardware-configs/vindruva.nix
      ];

      home-manager.users.matti.imports = with config.flake.modules.homeManager; [
        core
        desktop
        user-matti
      ];

      custom = {
        boot = "grub";
      };

      networking.hostName = "vindruva";
      # Deal with windows time
      # TODO: change in windows and remove
      time.hardwareClockInLocalTime = true;

      specialisation = with config.flake.modules; {
        niri.configuration = {
          system.nixos.tags = [ "niri" ];
          imports = [ nixos.desktop-niri ];
          custom.login-wallpaper = ./login-bg.jpeg;

          home-manager.users.matti.imports = [ homeManager.desktop-niri ];
          home-manager.users.matti.custom.desktop-wallpaper = ./desktop-bg.jpeg;

          services.desktopManager.plasma6.enable = lib.mkForce false;
        };
      };
    };

  flake.nixosConfigurations.vindruva = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos.vindruva ];
  };
}
