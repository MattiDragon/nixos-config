{ inputs, ... }:
{
  flake.modules.nixos.core =
    { ... }:
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        inputs.fabric-cli.overlays.default
        inputs.vineflower.overlays.default
      ];

      system.stateVersion = "25.05";
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

  flake.modules.homeManager.core =
    { ... }:
    {
      home.stateVersion = "25.11";
    };
}
