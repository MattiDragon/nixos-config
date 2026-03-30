{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    custom.desktop.enable = lib.mkEnableOption "";
    custom.desktop.graphics = lib.mkOption { type = lib.types.str; };
  };

  # Configure console keymap
  console.keyMap = "fi";

  config = lib.mkIf config.custom.desktop.enable (
    let
      desktop-config = config.custom.desktop;
      nvidia = (desktop-config.graphics == "nvidia");
    in
    {
      ## Desktop Environment ##
      # Enable X11 in case Wayland breaks
      services.xserver.enable = true;

      # Enable the KDE Plasma Desktop Environment.
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "fi";
        variant = "";
      };

      services.xserver.videoDrivers = [ ] ++ lib.optionals nvidia [ "nvidia" ];

      # Graphics setup
      hardware.graphics = {
        enable = true;
      };

      hardware.nvidia = lib.mkIf nvidia {
        modesetting.enable = true;
        # Fixes issues with sleep
        powerManagement.enable = true;
        powerManagement.finegrained = false;

        open = true;
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      ## Printing ##
      # Enable CUPS to print documents.
      services.printing.enable = true;
      services.printing.drivers = with pkgs; [
        cups-filters
        cups-browsed
        hplip
      ];
      # Needed for CUPS
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      ## Desktop Apps ##
      programs.firefox = {
        enable = true;
        nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
      };

      programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
      hardware.steam-hardware.enable = true;

      programs.kdeconnect.enable = true;

      programs.wireshark.enable = true;
      programs.wireshark.package = pkgs.wireshark;

      services.flatpak.enable = true;

      environment.systemPackages = with pkgs; [
        # Yubikey
        yubioath-flutter
        yubikey-manager

        # Editors
        vscode.fhs
        jetbrains-toolbox

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
      ];
    }
  );
}
