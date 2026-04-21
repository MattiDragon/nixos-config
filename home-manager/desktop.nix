{ pkgs, ... }:

{
  services.kdeconnect.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
      "x-scheme-handler/discord-589393213723246592" = "discord-589393213723246592.desktop";
      "x-scheme-handler/jetbrains-gateway" = "jetbrains-gateway.desktop";
    };
  };

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
