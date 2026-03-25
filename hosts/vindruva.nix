# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../modules/basic-utils.nix
    ../modules/audio.nix
    ../modules/bluetooth.nix
    ../modules/boot/grub.nix
  ];

  custom.desktop = {
    enable = true;
    graphics = "nvidia";
  };

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  # Fix windows messing up system time
  time.hardwareClockInLocalTime = true;

  # Network setup
  networking = {
    hostName = "vindruva";
    networkmanager.enable = true;

    firewall.checkReversePath = false;
    firewall.allowedUDPPorts = [ 51820 ];
  };

  # Configure console keymap
  console.keyMap = "fi";

  # Define a user account
  users.users.matti = {
    isNormalUser = true;
    description = "Matti";
    extraGroups = [ "networkmanager" "wheel" "wireshark" ];
    packages = with pkgs; [
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.qtmultimedia
    ];
  };

  # Mount windows filesystem
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/4CDA18FCDA18E3CC";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" "gid=100" "nofail" ];
  };

  # RGB setup
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
    motherboard = "intel";
  };
  hardware.i2c.enable = true;
  users.groups.i2c.members = [ "matti" ];

  services.pcscd.enable = true;

  # Keyboard control software
  hardware.ckb-next.enable = true;
  hardware.ckb-next.package = pkgs.ckb-next;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    v4l-utils
    (makeAutostartItem { name = "ckb-next"; package = pkgs.ckb-next; })
  ];

  # Enable direnv
#   programs.bash.interactiveShellInit = ''if [ ! -e /run/.toolboxenv ]; then eval "$(direnv hook bash)"; fi'';

  # SSH
  services.openssh.enable = true;

  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable/";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
