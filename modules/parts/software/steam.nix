{
  flake.modules.nixos.desktop =
    { ... }:
    {
      programs.steam = {
        enable = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
      hardware.steam-hardware.enable = true;
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ r2modman ];
    };
}
