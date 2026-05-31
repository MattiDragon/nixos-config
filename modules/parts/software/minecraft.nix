{
  flake.modules.homeManager.desktop =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        (prismlauncher.override {
          # Manually apply https://github.com/NixOS/nixpkgs/pull/509002
          glfw3-minecraft =
            let
              patched-glfw = pkgs.fetchFromGitHub {
                owner = "Moraxyc";
                repo = "nixpkgs";
                rev = "lwjgl-glfw";
                sha256 = "sha256-L295Y5AgtyTTaMlTAkKdo/NNwD2bZR3TsL9tSLJvqIk=";
              };
            in
            pkgs.callPackage "${patched-glfw}/pkgs/by-name/gl/glfw3-minecraft/package.nix" {
              glfw3 = pkgs.callPackage "${patched-glfw}/pkgs/by-name/gl/glfw3/package.nix" { };
            };
          additionalLibs = [
            libxt
            libxtst
            libxkbcommon
            libxinerama
          ];
        })
        waywall # MC wrapper for speedrunning

        # Minecraft Dev
        temurin-bin-25
        vineflower
        fabricmc-cli
      ];
    };
}
