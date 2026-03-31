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
            ./nixos/hosts/vindruva.nix
            inputs.minegrub-world-sel-theme.nixosModules.default
          ];
          specialArgs = { inherit inputs; };
        };

        "nixos-vm" = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            ./nixos/hosts/nixos-vm.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        in
        {
          "matti-desktop" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./home.nix
              ./home-manager/desktop.nix
            ];
          };
          "matti-headless" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ./home.nix ];
          };
        };
    };
}
