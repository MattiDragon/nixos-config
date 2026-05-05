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
            libxinerama
          ];
        })
        waywall # MC wrapper for speedrunning

        # Minecraft Dev
        temurin-bin-25
        vineflower
        fabricmc-cli
      ];

      programs.obs-studio = {
        enable = true;

        package = (
          pkgs.obs-studio.override {
            cudaSupport = true;
          }
        );

        plugins = with pkgs.obs-studio-plugins; [
          obs-pipewire-audio-capture
        ];
      };
    };
}
