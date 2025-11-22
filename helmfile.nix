{ lib, var, ... }:
let
  hflib = import ./lib lib;

  module = {
    # Load order matters a bit here, even though we set "needs" for every chart to build
    # the dependency DAG.
    # Modules specified first will be listed first in the helmfile releases.
    imports = lib.reverseList [
      ./modules/cluster-config
      ./modules/tailscale
      ./modules/postgres
      ./modules/kubernetes-dashboard
      ./modules/gramps-web
      ./modules/sleep-track
      ./modules/healthchecks
      ./modules/authentik
      ./modules/httpbin
      ./modules/metabase
      ./modules/superset
    ];

    releases = {
      cluster-config.enable = true;
      tailscale.enable = true;
      postgres.enable = true;
      kubernetes-dashboard.enable = false;
      gramps-web.enable = true;
      sleep-track.enable = false;
      healthchecks.enable = true;
      authentik.enable = true;
      httpbin.enable = true;
      metabase.enable = true;
      superset.enable = true;
    };
  };
in
[
  {
    environments = {
      dev = { };
      prod = {
        kubeContext = "prod";
      };
    };
  }

  (hflib.evalModuleToHelmfile {
    root = ./.;
    specialArgs = { inherit var; };
    inherit module;
  })
]
