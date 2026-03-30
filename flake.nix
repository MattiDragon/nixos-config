{
  description = "System configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    minegrub-world-sel-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fabric-cli = {
      url = "github:MattiDragon/fabric-cli-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vineflower = {
      url = "github:MattiDragon/vineflower-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        "vindruva" = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            ./hosts/vindruva.nix
            inputs.minegrub-world-sel-theme.nixosModules.default
          ];
          specialArgs = { inherit inputs; };
        };

        "nixos-vm" = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            ./hosts/nixos-vm.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = {
        "matti-desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home.nix ];
        };
        "matti-headless" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./home.nix ];
        };
      };
    };
}
