{ pkgs, ... }:

{
  home.username = "matti";
  home.homeDirectory = "/home/matti";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
  programs.micro.enable = true;

  home.sessionVariables = {
    EDITOR = "micro";
  };
}
