{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      # Wireguard itself is already part of networkmanager
      networking.firewall = {
        checkReversePath = false;
        allowedUDPPorts = [ 51820 ];
      };
    };
}
