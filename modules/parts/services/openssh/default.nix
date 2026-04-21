{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = false;
      };
    };

  flake.modules.nixos.user-matti =
    { pkgs, ... }:
    {
      users.users.matti.openssh = {
        authorizedKeys.keys = [
          (builtins.readFile ./_keys/yubikey_primary.pub)
          (builtins.readFile ./_keys/yubikey_secondary.pub)
        ];
      };
    };

  flake.modules.homeManager.user-matti =
    { pkgs, ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks =
          let
            identityFile = [
              "${./_keys/yubikey_primary}"
              "${./_keys/yubikey_secondary}"
            ];
          in
          {
            "mattidragon.dev" = {
              hostname = "mattidragon.dev";
              user = "matti";
              inherit identityFile;
            };
            "github.com" = {
              hostname = "github.com";
              user = "matti";
              inherit identityFile;
            };
            "server.yrttimaa" = {
              hostname = "server.yrttimaa";
              user = "truenas_admin";
            };
          };
      };
    };
}
