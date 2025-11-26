{
  lib,
  config,
  ...
}:
let
  release = "authentik";
  cfg = config.releases.${release};
in
with lib;
{
  imports = [ ../cluster-config ];

  options.releases.${release} = {
    enable = mkEnableOption "authentik, authentication and authorization server";
  };

  config = mkIf cfg.enable {
    releases.cluster-config.enable = true;

    helmfile.repositories = [
      {
        name = "authentik";
        url = "https://charts.goauthentik.io";
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
