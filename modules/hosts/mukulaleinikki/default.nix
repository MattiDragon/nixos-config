{ inputs, config, ... }:
{
  flake.modules.nixos.mukulaleinikki =
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
        ../../_hardware-configs/mukulaleinikki.nix
      ];

      home-manager.users.matti.imports = with config.flake.modules.homeManager; [
        core
        desktop
        user-matti
        desktop-niri
      ];

      custom = {
        boot = "grub";
      };

      networking.hostName = "mukulaleinikka";
    };

  flake.nixosConfigurations.mukulaleinikki = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos.mukulaleinikki ];
  };
}
