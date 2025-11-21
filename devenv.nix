{ pkgs, config, ... }:

{
  env = config.secretspec.secrets;

  packages = with pkgs; [
    pgcli
    postgresql
    secretspec
  ];

  scripts = {
    apply.exec = "helmfile apply --kube-context \${1:-default} -e \${1:-default} \${@:2}";
  };
}
