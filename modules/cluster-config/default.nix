{
  lib,
  var,
  config,
  ...
}:
let
  release = "cluster-config";
  cfg = config.releases.${release};
in
with lib;
{
  options.releases.${release} = {
    enable = mkEnableOption "cluster-config, configuration of cluster components";
  };

  config = mkIf cfg.enable {
    helmfile.releases = [
      {
        name = "${release}";
        namespace = "kube-system";
        createNamespace = false;
        chart = ./chart;
        values = [
          { enableLetsEncrypt = var.values.enableLetsEncrypt; }
          ./secrets.yaml
        ];
      }
    ];
  };
}
