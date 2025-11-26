{
  pkgs,
  config,
  helmfile-nix,
  ...
}:

{
  env = config.secretspec.secrets;

  packages = with pkgs; [
    helmfile
    helmfile-nix.packages.${system}.default
    kustomize
    pgcli
    postgresql
    secretspec
  ];

  languages.helm = {
    enable = true;
    languageServer.enable = true;
    plugins = [
      "helm-diff"
      "helm-secrets"
    ];
  };
}
