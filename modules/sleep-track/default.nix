{
  lib,
  config,
  ...
}:
let
  release = "sleep-track";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [
    ../cluster-config
    ../postgres
  ];

  options.releases.${release} = {
    enable = mkEnableOption "sleep-track, sleep tracking API";
  };

  config = mkIf cfg.enable {
    releases = {
      cluster-config.enable = true;
      postgres.enable = true;
    };

    helmfile.repositories = [
      {
        name = "swaggerui";
        url = "https://chrisfu.github.io/charts";
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
      }
    ];
  };
}
