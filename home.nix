{ pkgs, ... }:

{
  home.username = "matti";
  home.homeDirectory = "/home/matti";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    micro
  ];
}
