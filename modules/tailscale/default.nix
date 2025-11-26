{
  lib,
  config,
  ...
}:
let
  release = "tailscale";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [ ../cluster-config ];

  options.releases.${release} = {
    enable = mkEnableOption "tailscale, virtual private network";
  };

  config = mkIf cfg.enable {
    releases.cluster-config.enable = true;

    helmfile.repositories = [
      {
        name = "tailscale";
        url = "https://pkgs.tailscale.com/helmcharts";
      }
    ];

    helmfile.releases = [
      {
        name = "${release}";
        namespace = "${release}";
        chart = ./chart;
        needs = [ "kube-system/cluster-config" ];
        values = [ ./secrets.yaml ];
      }
    ];
  };
}
