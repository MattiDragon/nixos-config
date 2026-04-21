{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {

    };

  flake.modules.nixos.nixos-vm =
    { pkgs, ... }:
    {
      services.code-server.enable = true;
    };

  flake.modules.homeManager.core =
    { pkgs, ... }:
    {
      programs.micro.enable = true;

      home.sessionVariables = {
        EDITOR = "micro";
      };
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vscode.fhs
        jetbrains-toolbox
        kdePackages.kate
        mousepad
        nil # Nix LS for VSCode
      ];
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/jetbrains-gateway" = "jetbrains-gateway.desktop";
        "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";
      };
    };

  flake.modules.homeManager.nixos-vm =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jetbrains.jdk
        jetbrains.idea
      ];
    };
}
