{ inputs, ... }:
{
  flake.modules.nixos.core =
    { ... }:
    {
      imports = [ inputs.home-manager.nixosModules.default ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    };

  flake.modules.homeManager.core =
    { ... }:
    {
      xdg.mimeApps.enable = true;
    };
}
