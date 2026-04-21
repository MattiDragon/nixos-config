{ inputs, config, ... }:
{
  flake.modules.nixos.vindruva =
    { inputs, pkgs, ... }:
    {
      imports = with config.flake.modules.nixos; [
        core
        nvidia
        desktop-kde
        user-matti
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
    };

  flake.nixosConfigurations.vindruva = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos.vindruva ];
  };
}
