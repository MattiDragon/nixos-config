{
  description = "System configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    dolphin-patch = {
      url = "github:rumboon/dolphin-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      flake-parts,
      import-tree,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./modules);
}
