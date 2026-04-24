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
        {
          custom.desktop-wallpaper = ./desktop-bg.jpeg;
        }
      ];

      custom = {
        boot = "grub";
        login-wallpaper = ./login-bg.jpeg;
      };

      # Portable install, we don't want to accidentally
      # grab other OSs from the host system
      boot.loader.grub.useOSProber = lib.mkForce false;
      boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

      networking.hostName = "mukulaleinikki";
    };

  flake.nixosConfigurations.mukulaleinikki = inputs.nixpkgs.lib.nixosSystem {
    modules = [ config.flake.modules.nixos.mukulaleinikki ];
  };
}
