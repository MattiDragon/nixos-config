{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    dig
    pciutils
    zip
    unzip
    tree
    htop

    git
    git-lfs
    github-cli

    direnv
    nix-direnv

    ffmpeg
  ];

  programs.command-not-found.enable = true;

  programs.bash.interactiveShellInit = ''eval "$(direnv hook bash)"'';
}
