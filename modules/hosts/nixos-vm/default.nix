{ inputs, config, ... }:
{
  flake.modules.nixos.nixos-vm =
    { inputs, pkgs, ... }:
    {
      imports = with config.flake.modules.nixos; [
        core
        user-matti
        ../../_hardware-configs/nixos-vm.nix
      ];

      home-manager.users.matti.imports = with config.flake.modules.homeManager; [
        core
        user-matti
      ];

      custom = {
        boot = "systemd";
      };

      networking.hostName = "nixos-vm";

      # Set keymap to English to fix weird remote access issues
      console.keyMap = "en";
    };

  flake.nixosConfigurations.nixos-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos.nixos-vm ];
  };
}
