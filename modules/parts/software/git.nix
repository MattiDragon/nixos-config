{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        github-cli
      ];

      programs.git.enable = true;
      programs.git.lfs.enable = true;
    };

  flake.modules.homeManager.matti =
    { ... }:
    {
      programs.git = {
        enable = true;
        lfs.enable = true;

        settings = {
          user.name = "MattiDragon";
          user.email = "matti@mattidragon.dev";

          alias.graph = "log --oneline --graph";

          core.autocrlf = "input";
          init.defaultbranch = "main";

          credential."https://github.com.helper".helper = "/run/current-system/sw/bin/gh auth git-credential";
          credential."https://gist.github.com.helper".helper =
            "/run/current-system/sw/bin/gh auth git-credential";
        };
      };
    };
}
