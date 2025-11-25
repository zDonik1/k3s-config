{ var, ... }:
let
  mkStandardRelease =
    name: attrs:
    {
      inherit name;
      namespace = name;
      createNamespace = true;
    }
    // attrs;
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

  {
    repositories = [
      {
        name = "kubernetes-dashboard";
        url = "https://kubernetes.github.io/dashboard";
      }
      {
        name = "swaggerui";
        url = "https://chrisfu.github.io/charts";
      }
      {
        name = "healthchecks";
        url = "https://zekker6.github.io/helm-charts";
      }
      {
        name = "authentik";
        url = "https://charts.goauthentik.io";
      }
      {
        name = "matheusfm";
        url = "https://matheusfm.dev/charts";
      }
      {
        name = "tailscale";
        url = "https://pkgs.tailscale.com/helmcharts";
      }
      {
        name = "pmint9";
        url = "https://pmint93.github.io/helm-charts";
      }
      {
        name = "bitnami";
        url = "https://charts.bitnami.com/bitnami";
      }
    ];

    releases = [
      {
        name = "cluster-config";
        namespace = "kube-system";
        chart = "./charts/cluster-config";
        values = [
          { enableLetsEncrypt = var.values.enableLetsEncrypt; }
          "./secrets/traefik.yaml"
        ];
      }
      (mkStandardRelease "tailscale" {
        chart = "./charts/tailscale";
        values = [ "./secrets/tailscale.yaml" ];
      })
      (mkStandardRelease "postgres" {
        chart = "./charts/postgres";
        values = [ "./secrets/postgres.yaml" ];
      })
      (mkStandardRelease "kubernetes-dashboard" {
        installed = false;
        chart = "./charts/kubernetes-dashboard";
      })
      (mkStandardRelease "gramps-web" {
        chart = "./charts/gramps-web";
      })
      (mkStandardRelease "sleep-track" {
        installed = false;
        chart = "./charts/sleep-track";
        values = [ "./secrets/sleep-track.yaml" ];
      })
      (mkStandardRelease "healthchecks" {
        chart = "./charts/healthchecks";
        values = [ "./secrets/healthchecks.yaml" ];
      })
      (mkStandardRelease "authentik" {
        chart = "./charts/authentik";
        values = [ "./secrets/authentik.yaml" ];
      })
      (mkStandardRelease "httpbin" {
        chart = "./charts/httpbin";
      })
      (mkStandardRelease "metabase" {
        chart = "./charts/metabase";
        values = [ "./secrets/metabase.yaml" ];
      })
    ];
  }
]
