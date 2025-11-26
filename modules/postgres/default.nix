{
  lib,
  config,
  var,
  ...
}:
let
  release = "postgres";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [
    ../cluster-config
  ]
  ++ lib.lists.optional var.values.enableTailscaleOnlyMiddleware ../tailscale;

  options.releases.${release} = {
    enable = mkEnableOption "postgres, a relational database management system";
  };

  config = mkIf cfg.enable {
    releases = {
      cluster-config.enable = true;
      tailscale.enable = mkDefault var.values.enableTailscaleOnlyMiddleware;
    };

    helmfile.repositories = [
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
        values = [
          ./secrets.yaml
          { enableTailscaleOnlyMiddleware = var.values.enableTailscaleOnlyMiddleware; }
        ];
      }
    ];
  };
}
