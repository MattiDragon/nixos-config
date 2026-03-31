{ pkgs, ... }:

{
  services.kdeconnect.enable = true;

  home.packages = with pkgs; [
    # Yubikey
    yubioath-flutter
    yubikey-manager

    # Editors
    vscode.fhs
    jetbrains-toolbox
    kdePackages.kate
    mousepad

    discord
    zoom-us

    # Games
    (prismlauncher.override {
      additionalLibs = [
        libxt
        libxtst
        libxkbcommon
      ];
    })
    waywall # MC wrapper for speedrunning
    r2modman

    # Graphics
    gimp
    aseprite
    blender
    blockbench

    # Misc
    obsidian
    kdePackages.krdc # Remote desktop client
    nil # Nix LS
    firefoxpwa # Needed for PWA support in firefox
    kdePackages.kcalc
    kdePackages.qtmultimedia
  ];
}
