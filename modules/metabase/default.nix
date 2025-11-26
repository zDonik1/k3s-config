{
  lib,
  config,
  ...
}:
let
  release = "metabase";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [
    ../cluster-config
    ../tailscale
  ];

  options.releases.${release} = {
    enable = mkEnableOption "metabase, self-hosted analytics software";
  };

  config = mkIf cfg.enable {
    releases = {
      cluster-config.enable = true;
      tailscale.enable = true;
    };

    helmfile.repositories = [
      {
        name = "pmint93";
        url = "https://pmint93.github.io/helm-charts";
      }
      {
        name = "bitnami";
        url = "https://charts.bitnami.com/bitnami";
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
