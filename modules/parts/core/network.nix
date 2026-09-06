{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      networking.networkmanager.enable = true;
      networking.networkmanager.plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };
}
