{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (prismlauncher.override {
          additionalLibs = [
            libxt
            libxtst
            libxkbcommon
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
