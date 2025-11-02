{ ... }:

{
  env.KUBECONFIG = "./k3s-server-output/kubeconfig.yaml";

  scripts = {
    apply.exec = "helmfile apply $@";
  };
}
