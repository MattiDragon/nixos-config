final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    kfinal: kprev: {
      dolphin = prev.symlinkJoin (
        let
          kservice5Menu = prev.stdenv.mkDerivation {
            name = "kservice5-applications-menu";
            version = "5.116.0";

            src = prev.fetchFromGitLab {
              domain = "invent.kde.org";
              owner = "frameworks";
              repo = "kservice";
              tag = "v5.116.0";
              sparseCheckout = [ "src/applications.menu" ];
              hash = "sha256-28ueuJiI34o1wayiq85KPNkUCwjdhPMYtU2nJTQ84V4=";
            };

            installPhase = ''
              mkdir -p $out/etc/xdg/menus
              cp ./src/applications.menu $out/etc/xdg/menus/applications.menu
            '';
          };
        in
        {
          name = "dolphin-wrapped";
          paths = [ kprev.dolphin ];
          nativeBuildInputs = [ prev.makeWrapper ];
          postBuild = ''
            rm $out/bin/dolphin
            makeWrapper ${kprev.dolphin}/bin/dolphin $out/bin/dolphin \
              --set XDG_CONFIG_DIRS "${kservice5Menu}/etc/xdg:$XDG_CONFIG_DIRS" \
              --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${kservice5Menu}/etc/xdg/menus/applications.menu"
          '';
        }
      );
    }
  );
}
