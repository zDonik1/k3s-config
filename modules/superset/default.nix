{
  lib,
  config,
  var,
  ...
}:
let
  release = "superset";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [
    ../cluster-config
    ../postgres
  ]
  ++ lib.lists.optional var.values.enableTailscaleOnlyMiddleware ../tailscale;

  options.releases.${release} = {
    enable = mkEnableOption "superset, analytics platform";
  };

  config = mkIf cfg.enable {
    releases = {
      cluster-config.enable = true;
      postgres.enable = true;
      tailscale.enable = mkDefault var.values.enableTailscaleOnlyMiddleware;
    };

    helmfile.repositories = [
      {
        name = "superset";
        url = "https://apache.github.io/superset";
      }
    ];

    helmfile.releases = [
      {
        name = "${release}";
        namespace = "${release}";
        chart = ./chart;
        needs = [
          "kube-system/cluster-config"
          "postgres/postgres"
        ];
        values = [
          ./secrets.yaml
          { enableTailscaleOnlyMiddleware = var.values.enableTailscaleOnlyMiddleware; }
        ];
      }
    ];
  };
}
