{
  lib,
  config,
  ...
}:
let
  release = "kubernetes-dashboard";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [ ../cluster-config ];

  options.releases.${release} = {
    enable = mkEnableOption "kubernetes-dashboard";
  };

  config = mkIf cfg.enable {
    releases.cluster-config.enable = true;

    helmfile.repositories = [
      {
        name = "kubernetes-dashboard";
        url = "https://kubernetes.github.io/dashboard";
      }
    ];

    helmfile.releases = [
      {
        name = "${release}";
        namespace = "${release}";
        chart = ./manifests;
        needs = [ "kube-system/cluster-config" ];
      }
    ];
  };
}
