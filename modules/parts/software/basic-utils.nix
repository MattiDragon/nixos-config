{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        wget
        dig
        pciutils
        zip
        unzip
        tree
        htop
        file

        ffmpeg
      ];

      # Broken with flakes without extra work
      # programs.command-not-found.enable = true;
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kdePackages.kcalc
        kdePackages.qtmultimedia
        kdePackages.krdc
      ];
    };
}
