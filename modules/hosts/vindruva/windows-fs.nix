{
  flake.modules.nixos.vindruva =
    { ... }:
    {
      boot.supportedFilesystems = [ "ntfs" ];
      fileSystems."/mnt/windows" = {
        device = "/dev/disk/by-uuid/4CDA18FCDA18E3CC";
        fsType = "ntfs";
        options = [
          "rw"
          "uid=1000"
          "gid=100"
          "nofail"
        ];
      };
    };
}
