{
  lib,
  config,
  ...
}:
let
  release = "gramps-web";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [
    ../cluster-config
    ../tailscale
  ];

  options.releases.${release} = {
    enable = mkEnableOption "gramps-web, genealogy software on the web";
  };

  config = mkIf cfg.enable {
    releases = {
      cluster-config.enable = true;
      tailscale.enable = true;
    };

    helmfile.releases = [
      {
        name = "${release}";
        namespace = "${release}";
        chart = ./chart;
        needs = [ "kube-system/cluster-config" ];
      }
    ];
  };
}
