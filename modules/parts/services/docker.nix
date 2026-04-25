{
  flake.modules.nixos.core =
    { pkgs, ... }:
    {
      users.users.matti.extraGroups = [ "podman" ];

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };
      environment.etc."distrobox/distrobox.conf".text = ''
        container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
      '';

      environment.systemPackages = with pkgs; [
        docker-compose
        distrobox
      ];
    };
}
