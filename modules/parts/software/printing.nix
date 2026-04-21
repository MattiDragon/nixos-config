{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
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
    };
}
