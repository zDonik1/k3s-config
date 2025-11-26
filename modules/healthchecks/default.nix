{
  lib,
  config,
  ...
}:
let
  release = "healthchecks";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [
    ../cluster-config
    ../tailscale
  ];

  options.releases.${release} = {
    enable = mkEnableOption "healthchecks, monitoring health of services";
  };

  config = mkIf cfg.enable {
    releases = {
      cluster-config.enable = true;
      tailscale.enable = true;
    };

    helmfile.repositories = [
      {
        name = "zekker6";
        url = "https://zekker6.github.io/helm-charts";
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
