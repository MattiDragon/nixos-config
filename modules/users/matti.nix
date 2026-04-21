{
  flake.modules.nixos.user-matti =
    { config, ... }:
    let
      ifGroupExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
    in
    {
      users.users.matti = {
        isNormalUser = true;
        description = "Matti";
        extraGroups = [
          "wheel"
        ]
        ++ ifGroupExists [
          "networkmanager"
          "wireshark"
        ];
      };
    };

  flake.modules.homeManager.user-matti =
    { ... }:
    {
      home.username = "matti";
      home.homeDirectory = "/home/matti";
    };
}
