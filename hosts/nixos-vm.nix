{ config, pkgs, ... }:

{
  imports = [
    ../modules/basic-utils.nix
    ../modules/boot/systemd.nix
  ];

  networking.hostName = "nixos-vm";


  networking.networkmanager.enable = true;

  # Configure console keymap
  console.keyMap = "en";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.matti = {
    isNormalUser = true;
    description = "Matti";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      jetbrains.jdk
      jetbrains.idea
    ];
  };

  users.users.nicholas = {
    isNormalUser = true;
    description = "Nicholas";
    extraGroups = [ "wheel" ];
  };

  services.code-server.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wakeonlan
    nodejs
  ];

  programs.bash.interactiveShellInit = ''eval "$(direnv hook bash)"'';

  # Enable the OpenSSH
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
