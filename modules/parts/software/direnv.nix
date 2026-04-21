{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
      };
    };
}
