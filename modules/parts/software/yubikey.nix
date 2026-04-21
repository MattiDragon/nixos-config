{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      services.pcscd.enable = true;
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        yubioath-flutter
        yubikey-manager
      ];
    };
}
