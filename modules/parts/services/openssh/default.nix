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
    { pkgs, config, ... }:
    let
      sshKeyLocation = "${config.xdg.configHome}/ssh_keys";
    in
    {
      systemd.user.tmpfiles.rules = [
        "C+ ${sshKeyLocation}/yubikey_primary - - - - ${./_keys/yubikey_primary}"
        "C+ ${sshKeyLocation}/yubikey_secondary - - - - ${./_keys/yubikey_secondary}"
        "z ${sshKeyLocation}/yubikey_primary 0600 matti users"
        "z ${sshKeyLocation}/yubikey_secondary 0600 matti users"
      ];

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks =
          let
            identityFile = [
              "${sshKeyLocation}/yubikey_primary"
              "${sshKeyLocation}/yubikey_secondary"
            ];
          in
          {
            "mattidragon.dev" = {
              hostname = "mattidragon.dev";
              user = "matti";
              inherit identityFile;
              identityAgent = "none";
            };
            "github.com" = {
              hostname = "github.com";
              user = "matti";
              inherit identityFile;
              identityAgent = "none";
            };
            "server.yrttimaa" = {
              hostname = "server.yrttimaa";
              user = "truenas_admin";
            };
          };
      };
    };
}
