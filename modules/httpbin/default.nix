{
  lib,
  config,
  ...
}:
let
  release = "httpbin";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [ ../cluster-config ];

  options.releases.${release} = {
    enable = mkEnableOption "httpbin, HTTP echo server";
  };

  config = mkIf cfg.enable {
    releases.cluster-config.enable = true;

    helmfile.repositories = [
      {
        name = "matheusfm";
        url = "https://matheusfm.dev/charts";
      }
    ];

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
